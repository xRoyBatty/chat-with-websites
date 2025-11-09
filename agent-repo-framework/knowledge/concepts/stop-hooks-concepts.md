# Stop Hooks: Worker Persistence Concepts

## The Problem

Claude Code sessions naturally want to stop when they think they're done. A worker agent checks the task queue, finds no tasks, and concludes its work is complete. The session ends and the worker disappears.

For multi-agent systems, we need workers to **stay alive and keep polling** for new tasks, even when temporarily idle.

## The Solution: Stop Hooks

**Stop hooks** intercept when Claude tries to stop and can:
1. **Block stoppage** - Force Claude to continue
2. **Provide feedback** - Tell Claude why it must continue
3. **Set conditions** - Allow stoppage only when certain criteria are met

## How Stop Hooks Work

### Hook Execution Flow

The hook operates in a discrete cycle:

1. Claude finishes a task
2. Claude thinks: "I'm done, time to stop"
3. Stop hook is triggered BEFORE stopping
4. Hook evaluates: Should we stop or continue?
5. Two possible outcomes:
   - Hook returns "approve" → Claude stops gracefully
   - Hook returns "block" + reason → Claude continues with new instructions

### Hook Configuration Pattern

Stop hooks are configured in the repository settings file, specifying:
- Which script to execute
- Timeout limits for hook execution
- Type of hook (command-based is common)

### Hook Decision Logic

The hook script evaluates conditions and makes a decision:
- If conditions warrant continuation, it blocks the stop attempt
- If conditions allow shutdown, it approves the stop
- The decision is communicated back with a reason message

## Idle Time Management

### Critical Concept: Idle Time vs Total Time

**WRONG MENTAL MODEL:**
Tracking total time since worker registration means a task arriving at minute 9 gives the worker only 1 minute to work before timeout.

**CORRECT MENTAL MODEL:**
Idle time resets when work happens. The timeout only counts time spent waiting between tasks, not time spent working.

### Last Activity Tracking

The system tracks multiple activity timestamps:
- When the worker registered
- When the worker last claimed a task
- When the worker last completed a task

The **most recent** of these timestamps represents the last activity. Idle time is calculated from this point, not from registration.

### Timeline Example (Concept)

Here's how idle time behaves through a worker's lifecycle:

```
12:00 PM - Worker registers
           Idle time: 0 minutes

12:01-12:08 PM - Worker polls for tasks, finds none
                  Idle time: 1-8 minutes (increasing)

12:09 PM - Task arrives! Worker claims it
           Idle time: RESETS to 0
           (The 9 minutes spent waiting is forgotten)

12:10-12:38 PM - Worker actively processing task
                  Idle time: 0 (not idle, working)

12:39 PM - Task completes
           Idle time: RESETS to 0 again

12:40-12:48 PM - Worker polls for tasks, finds none
                  Idle time: 1-9 minutes (increasing from task completion)

12:49 PM - Idle time reaches 10 minute limit
           Hook evaluates and approves shutdown
           Worker stops gracefully
```

Key insight: The worker gets a **fresh 10-minute window** after each task completion.

## Worker Lifecycle Pattern

### Continuous Polling Loop

Workers operate in a continuous cycle:

1. Send heartbeat to signal they're alive
2. Check task queue for available work
3. If task found:
   - Claim the task
   - Execute the work
   - Mark task as complete
   - Reset idle timer
4. If no task found:
   - Wait briefly
   - Loop back to step 1

This loop never ends naturally. The stop hook is what eventually allows shutdown.

### Stop Hook Integration

The stop hook integrates with this cycle:

- After each iteration where no tasks are found
- Claude considers stopping
- Hook checks: "Are there pending tasks? How long have we been idle?"
- If tasks exist OR idle time under threshold: Block stop, continue loop
- If no tasks AND idle time exceeded: Approve stop, graceful shutdown

## Decision Logic Concepts

### Checking for Pending Tasks

First priority: Are there tasks waiting in the queue?
- If yes, worker should continue (even if briefly idle)
- If no, proceed to check idle time

### Calculating Idle Time

Find the most recent activity timestamp:
- Compare: registration time, last task claimed, last task completed
- Take the maximum (most recent)
- Calculate time elapsed since that moment
- This is the true idle time

### Comparing Against Threshold

Compare idle time to configured threshold:
- Under threshold: Block stop, report remaining time
- Over threshold: Approve stop, report timeout reason

## Idle Timer Reset Points

The idle timer resets at two critical moments:

**Task Claiming:**
When a worker claims a task, it updates:
- Its last task claimed timestamp to now
- Its heartbeat to now
This resets the idle timer to zero.

**Task Completion:**
When a worker completes a task, it updates:
- Its last task completed timestamp to now
- Its heartbeat to now
This resets the idle timer to zero again.

## Configurable Timeout Strategies

Different worker types can have different idle thresholds:

**Critical Worker:** 30-minute idle timeout
- Stays alive longer waiting for tasks
- Good for high-priority work queues

**Temporary Worker:** 5-minute idle timeout
- Shuts down quickly if no work
- Good for bursty workloads

**Persistent Worker:** No timeout (infinite idle)
- Never stops unless manually terminated
- Not recommended for web environments (rate limits)

## Stop Hook Output Patterns

### Blocking Stoppage

When conditions warrant continuation, the hook returns:
- Decision: Block the stop attempt
- Reason: Why the worker must continue
- Context: How much time remaining, tasks available, etc.

### Approving Stoppage

When conditions allow shutdown, the hook returns:
- Decision: Approve the stop
- Reason: Why shutdown is appropriate
- Context: How long idle, no tasks available, etc.

## Rate Limit Considerations

When a worker hits rate limits:
- Session pauses (doesn't end immediately)
- Heartbeat stops updating (worker appears inactive)
- After limit resets, worker can resume
- Or new worker can be launched to replace it

Coordinators can detect inactive workers by checking heartbeat staleness:
- Workers with recent heartbeat (within 2 minutes): Active
- Workers with old heartbeat (over 2 minutes): Inactive or rate-limited

## Key Insights

### 1. Discrete Cycle Model

Stop hooks create a **discrete decision cycle**:
- Work → Check → Decision → Continue/Stop
- Not continuous monitoring, but checkpoint-based
- Each cycle is independent and stateless

### 2. Idle Time Is Not Total Time

The timeout measures **waiting time between tasks**, not total runtime:
- A worker can run for hours if tasks keep arriving
- Only idle periods (no work available) count toward timeout
- Each task completion gives a fresh timeout window

### 3. Polling Worker Pattern

Stop hooks enable a **persistent polling pattern**:
- Workers continuously monitor for work
- Stay alive while needed
- Gracefully shutdown when truly idle
- Self-regulating based on workload

### 4. Two-Tier Persistence

Persistence comes from two mechanisms:
- **Main loop:** Worker keeps checking queue
- **Stop hook:** Prevents premature shutdown

Both must work together for effective worker persistence.

### 5. Graceful Degradation

The system degrades gracefully:
- No tasks + timeout → Worker stops (saves resources)
- Tasks present → Worker continues (serves work)
- Rate limited → Worker pauses (respects limits)
- New tasks arrive → New workers can launch

## Summary

Stop hooks transform Claude Code from a single-task executor into a **persistent worker agent** by:

1. **Intercepting stop attempts** before the session ends
2. **Evaluating continuation criteria** (tasks available? idle time acceptable?)
3. **Blocking unnecessary stops** to keep workers alive
4. **Allowing graceful shutdown** after reasonable timeout
5. **Managing idle time correctly** (only time between tasks counts)

This creates a polling worker pattern where agents continuously monitor for work, stay alive while needed, and gracefully shutdown when truly idle.

The 10-minute timeout is **idle time only** (time waiting for work), NOT total runtime. Workers can run indefinitely as long as they keep getting tasks.
