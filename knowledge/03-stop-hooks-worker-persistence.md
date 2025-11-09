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

## How Stop Hooks Work

### Hook Execution Flow

```
1. Claude finishes a task
2. Claude thinks: "I'm done, time to stop"
3. Stop hook is triggered BEFORE stopping
4. Hook evaluates: Should we stop or continue?
5a. Hook returns "approve" → Claude stops gracefully
5b. Hook returns "block" + reason → Claude continues with new instructions
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
12:01 PM - Still idle (idle_time = 1 min)
12:02 PM - Still idle (idle_time = 2 min)
...
12:09 PM - Task arrives! Worker claims it
          → last_task_claimed = 12:09 PM
          → idle_time RESETS to 0
12:10 PM - Working on task (idle_time = 0, not idle)
12:39 PM - Task complete
          → last_task_completed = 12:39 PM
          → idle_time RESETS to 0 again
12:40 PM - No tasks (idle_time = 1 min)
12:41 PM - No tasks (idle_time = 2 min)
...
12:49 PM - No tasks (idle_time = 10 min)
          → Idle limit reached
          → Hook returns "approve"
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

## Worker Main Loop

Worker agents should run a continuous loop:

```python
import time
from vps_deploy_helper import *

# Register
WORKER_ID = os.environ.get('WORKER_ID', 'worker-1')
register_worker(WORKER_ID, capabilities=['backend'])

# Main loop
while True:
    # Send heartbeat
    heartbeat(WORKER_ID)

    # Try to claim task
    task = claim_task(WORKER_ID)

    if task:
        print(f"📋 Working on: {task['description']}")

        # DO THE ACTUAL WORK HERE
        result = execute_task(task)

        # Mark complete
        complete_task(task['id'], WORKER_ID, result)
        print(f"✅ Completed task {task['id']}")
    else:
        print("⏳ No tasks, waiting...")
        time.sleep(30)  # Wait before checking again

# Note: Loop never ends naturally
# Stop hook will eventually allow shutdown after idle timeout
```

## Configurable Timeouts

Different worker types can have different timeouts:

```python
# Critical worker - stays alive 30 minutes while idle
should_worker_continue(WORKER_ID, max_idle_minutes=30)

# Temporary worker - shuts down after 5 minutes idle
should_worker_continue(WORKER_ID, max_idle_minutes=5)

# Persistent worker - never times out (not recommended for web)
should_worker_continue(WORKER_ID, max_idle_minutes=None)
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

1. ✅ **Intercepting stop attempts** - Before Claude can exit
2. ✅ **Checking conditions** - Are there tasks? How long idle?
3. ✅ **Blocking stoppage** - Force continuation with feedback
4. ✅ **Graceful shutdown** - Allow exit after reasonable timeout
5. ✅ **Idle time management** - Only count time between tasks, not total time

This creates a **polling worker pattern** where agents continuously monitor for work, stay alive while needed, and gracefully shutdown when truly idle.

**Key insight:** The 10-minute timeout is **idle time only** (time waiting for work), NOT total runtime. Workers can run for hours as long as they keep getting tasks.
