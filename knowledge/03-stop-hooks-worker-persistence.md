# Stop Hooks: Keeping Worker Agents Alive

## The Problem

Claude Code sessions naturally want to stop when they think they're done:

```
Worker Agent: "I checked the task queue, no tasks available."
Worker Agent: "My work is complete, time to stop."
→ Session ends
→ Worker gone
You: "Wait, come back!" → Too late
```

For multi-agent systems, we need workers to **stay alive and keep polling** for new tasks, even when temporarily idle.

## The Solution: Stop Hooks

**Stop hooks** intercept when Claude tries to stop and can:
1. **Block stoppage** - Force Claude to continue
2. **Provide feedback** - Tell Claude why it must continue
3. **Set conditions** - Allow stoppage only when certain criteria met

## ⚠️ CRITICAL: Understanding Worker Execution Model

**WRONG MENTAL MODEL:**
```python
# Workers DO NOT run as continuous background scripts
while True:  # ❌ This does NOT happen
    check_queue()
    execute_task()
    time.sleep(30)
```

**CORRECT MENTAL MODEL:**
```
Worker operates in DISCRETE CONVERSATION CYCLES:

Cycle 1: Worker checks queue → No tasks → Tries to stop
         ↓
      Stop hook blocks: "Keep waiting (9 min remaining)"
         ↓
      Worker continues

Cycle 2: Worker checks queue → Claims task → Executes → Completes
         ↓
      Tries to stop
         ↓
      Stop hook blocks: "Keep waiting (10 min remaining)" [idle timer RESET]
         ↓
      Worker continues

Cycle 3: Worker checks queue → No tasks → Tries to stop
         ↓
      Stop hook blocks: "Keep waiting (8 min remaining)"
         ↓
      Worker continues

...

Cycle N: Worker checks queue → No tasks → Tries to stop
         ↓
      Stop hook approves: "Idle for 10 minutes - shutdown"
         ↓
      Worker stops gracefully
```

**Key insight:** Each "check queue → do work → try to stop" is ONE discrete conversation cycle. The stop hook creates the polling behavior by repeatedly blocking the natural stop attempt.

## How Stop Hooks Work

### Hook Execution Flow

```
1. Claude finishes a task (or finds no tasks)
2. Claude thinks: "I'm done, time to stop"
3. Stop hook is triggered BEFORE stopping
4. Hook evaluates: Should we stop or continue?
5a. Hook returns "approve" → Claude stops gracefully
5b. Hook returns "block" + reason → Claude continues with new instructions
6. Cycle repeats from step 1
```

### Hook Configuration

In `.claude/settings.json`:

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "python3 .claude/hooks/worker-stop-check.py",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

### Hook Script Example

`.claude/hooks/worker-stop-check.py`:

```python
#!/usr/bin/env python3
import json
import sys
import os

# Add VPS skill to path
sys.path.insert(0, '.claude/skills/vps-deploy')
from vps_deploy_helper import should_worker_continue

# Read hook input from stdin
input_data = json.load(sys.stdin)

# Get worker ID
worker_id = os.environ.get('WORKER_ID', 'worker-unknown')

# Check if should continue
should_continue, reason = should_worker_continue(worker_id, max_idle_minutes=10)

if should_continue:
    # Block stoppage - keep agent alive
    output = {
        "decision": "block",
        "reason": f"Worker {worker_id}: {reason}. Continue monitoring task queue..."
    }
    print(json.dumps(output))
    sys.exit(0)
else:
    # Allow stoppage
    output = {
        "decision": "approve",
        "reason": f"Worker {worker_id}: {reason}. Shutting down gracefully."
    }
    print(json.dumps(output))
    sys.exit(0)
```

## Idle Time Management

### Critical: Idle Time vs Total Time

**WRONG IMPLEMENTATION:**
```python
# This gives only 1 minute if task arrives at minute 9
registered_at = worker_info['registered_at']
elapsed = now() - registered_at
if elapsed < 10 minutes:
    continue
else:
    stop
```

**CORRECT IMPLEMENTATION:**
```python
# Idle time resets when work happens
last_activity = max(
    worker_info.get('last_task_claimed'),
    worker_info.get('last_task_completed'),
    worker_info['registered_at']
)
idle_time = now() - last_activity

if idle_time < 10 minutes:
    continue  # Still waiting
else:
    stop  # Been idle too long
```

### Timeline Example

```
12:00 PM - Worker registers (idle_time = 0)
           Cycle 1: No tasks → Stop hook blocks

12:01 PM - Still idle (idle_time = 1 min)
           Cycle 2: No tasks → Stop hook blocks

12:02 PM - Still idle (idle_time = 2 min)
           Cycle 3: No tasks → Stop hook blocks
...
12:09 PM - Task arrives! Worker claims it
           Cycle N: Claims task → Executes
           → last_task_claimed = 12:09 PM
           → idle_time RESETS to 0

12:10 PM - Working on task (idle_time = 0, not idle)

12:39 PM - Task complete
           → last_task_completed = 12:39 PM
           → idle_time RESETS to 0 again
           → Tries to stop → Stop hook blocks

12:40 PM - No tasks (idle_time = 1 min)
           Cycle N+1: No tasks → Stop hook blocks

12:41 PM - No tasks (idle_time = 2 min)
           Cycle N+2: No tasks → Stop hook blocks
...
12:49 PM - No tasks (idle_time = 10 min)
           Cycle N+10: No tasks → Stop hook APPROVES
           → Worker shuts down gracefully
```

## VPS Helper Functions

### should_worker_continue()

```python
def should_worker_continue(worker_id, max_idle_minutes=10):
    """
    Determine if worker should keep running

    Returns:
        (bool, str): (should_continue, reason)
    """
    # Check for pending tasks
    queue = read_task_queue()
    pending = [t for t in queue if t['status'] == 'pending']

    if pending:
        return True, "Tasks available in queue"

    # Check idle time
    worker_info = get_worker_status(worker_id)

    # Find last activity
    last_activity = max([
        worker_info.get('last_task_claimed'),
        worker_info.get('last_task_completed'),
        worker_info['registered_at']
    ])

    idle_minutes = (now() - parse_time(last_activity)).total_seconds() / 60

    if idle_minutes < max_idle_minutes:
        remaining = max_idle_minutes - idle_minutes
        return True, f"Waiting for tasks ({int(remaining)} min idle remaining)"

    return False, f"Idle for {int(idle_minutes)} minutes - timeout"
```

### Task Claiming Resets Idle Timer

```python
def claim_task(worker_id):
    """Claim a task AND reset idle timer"""
    task = find_pending_task(worker_id)

    if task:
        task['status'] = 'in_progress'
        task['claimed_by'] = worker_id
        save_task_queue()

        # IMPORTANT: Reset idle timer
        update_worker_status(worker_id, {
            'last_task_claimed': now(),
            'last_heartbeat': now()
        })

        return task

    return None
```

### Task Completion Resets Idle Timer

```python
def complete_task(task_id, worker_id, result=None):
    """Mark task complete AND reset idle timer"""
    task = find_task(task_id)
    task['status'] = 'completed'
    task['completed_by'] = worker_id
    task['result'] = result
    save_task_queue()

    # IMPORTANT: Reset idle timer
    update_worker_status(worker_id, {
        'last_task_completed': now(),
        'last_heartbeat': now()
    })
```

## Worker Cycle Pattern

Instead of a continuous loop, workers operate in discrete cycles:

### Worker CLAUDE.md Instructions

```markdown
# Worker Agent Instructions

Your role: Poll the VPS task queue and execute available tasks.

## On Each Conversation Cycle:

1. **Send heartbeat**
   - Use `heartbeat(WORKER_ID)` to update your last-seen time
   - This helps coordinator know you're alive

2. **Check for tasks**
   - Use `claim_task(WORKER_ID)` to get next task
   - If no task: Report "No tasks available" and FINISH
   - If task found: Proceed to step 3

3. **Execute task** (if claimed)
   - Read the task's instruction file from VPS
   - Read any referenced context files
   - Execute the task requirements
   - Save results to VPS

4. **Mark complete**
   - Use `complete_task(task_id, WORKER_ID, result_data)`
   - Report completion

5. **Finish cycle**
   - Say "Cycle complete"
   - Session will try to stop
   - Stop hook will either block (keep going) or approve (shutdown)

## Critical Understanding:

You are NOT running a continuous script. Each time you execute steps 1-5 above,
that is ONE conversation cycle. The stop hook creates persistence by blocking
your natural tendency to stop after each cycle.

When you say "Cycle complete", you will either:
- Be blocked by stop hook → Start steps 1-5 again in NEW conversation cycle
- Be approved by stop hook → Shutdown gracefully (idle timeout reached)
```

### Example Worker Workflow

**Cycle 1:**
```
Worker: Sending heartbeat...
Worker: Checking for tasks...
Worker: No tasks available. Cycle complete.
[Tries to stop]
Stop Hook: "BLOCK - Waiting for tasks (10 min remaining)"
[New cycle starts]
```

**Cycle 2:**
```
Worker: Sending heartbeat...
Worker: Checking for tasks...
Worker: Claimed task #1234: "Create user model"
Worker: Reading instruction file: tasks/task-1234.md
Worker: Reading context: project-spec.md, database-schema.md
Worker: Creating user model...
Worker: [executes work]
Worker: Task complete! Marking as done.
Worker: Cycle complete.
[Tries to stop]
Stop Hook: "BLOCK - Waiting for tasks (10 min remaining)" [timer reset]
[New cycle starts]
```

**Cycle N (timeout):**
```
Worker: Sending heartbeat...
Worker: Checking for tasks...
Worker: No tasks available. Cycle complete.
[Tries to stop]
Stop Hook: "APPROVE - Idle for 10 minutes, shutting down"
[Worker stops gracefully]
```

## Configurable Timeouts

Different worker types can have different timeouts:

```python
# Critical worker - stays alive 30 minutes while idle
should_worker_continue(WORKER_ID, max_idle_minutes=30)

# Temporary worker - shuts down after 5 minutes idle
should_worker_continue(WORKER_ID, max_idle_minutes=5)

# Persistent worker - very long timeout (max recommended for web: 60 min)
should_worker_continue(WORKER_ID, max_idle_minutes=60)
```

## Stop Hook JSON Output

Stop hooks can return structured JSON for more control:

```json
{
  "decision": "block",
  "reason": "Worker must continue monitoring queue (7 min remaining)",
  "continue": true,
  "systemMessage": "Worker is healthy and waiting for tasks"
}
```

Or allow stoppage:

```json
{
  "decision": "approve",
  "reason": "Worker idle for 10 minutes, no tasks available",
  "continue": false
}
```

## Rate Limit Considerations

When a worker hits rate limit:
1. Session pauses (not ends)
2. Worker status shows as inactive (no heartbeat)
3. After limit resets, worker can resume
4. Or launch new worker to replace it

The coordinator can detect inactive workers:

```python
def get_active_workers():
    """Get workers with recent heartbeat (within 2 minutes)"""
    workers = read_worker_status()
    active = {}

    for worker_id, info in workers.items():
        last_hb = parse_time(info['last_heartbeat'])
        if (now() - last_hb).total_seconds() < 120:
            active[worker_id] = info

    return active
```

## Summary

Stop hooks enable persistent worker agents by:

1. ✅ **Intercepting stop attempts** - After each discrete conversation cycle
2. ✅ **Checking conditions** - Are there tasks? How long idle?
3. ✅ **Blocking stoppage** - Force continuation with feedback, creating polling behavior
4. ✅ **Graceful shutdown** - Allow exit after reasonable timeout
5. ✅ **Idle time management** - Only count time between tasks, not total time

This creates a **polling worker pattern** where agents operate in discrete cycles, the stop hook creates persistence by repeatedly blocking the natural stop attempt, and workers gracefully shutdown when truly idle.

**Key insight:** The 10-minute timeout is **idle time only** (time waiting for work), NOT total runtime. Workers can run for hours as long as they keep getting tasks. Each "check → work → complete" is ONE conversation cycle, and the stop hook creates the continuous polling behavior by blocking after each cycle.
