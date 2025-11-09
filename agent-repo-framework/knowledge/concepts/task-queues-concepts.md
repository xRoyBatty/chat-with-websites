# Task Queue Coordination System (Concepts)

## Overview

The task queue system enables multiple Claude agents to coordinate work through shared state files on the VPS. This creates a distributed work system where a coordinator assigns tasks and workers claim and execute them autonomously.

## Architecture

The system follows a simple coordination pattern:

1. **Coordinator Agent** creates and manages tasks
2. **Task Queue** stores all tasks in a shared file
3. **Worker Agents** (one or more) poll the queue continuously
4. Workers claim available tasks and execute them
5. Task results are written back to shared files
6. Coordinator monitors progress through the shared state

This creates an asynchronous, distributed work system without requiring direct communication between agents.

## Core Data Structures

### 1. Task Queue File

A shared file containing all tasks in the system. Each task represents a unit of work that needs to be completed.

**Task Lifecycle States:**
- **Pending**: Task created, waiting to be claimed
- **In Progress**: Worker has claimed task and is executing
- **Completed**: Task finished successfully

**Key Task Information:**
- Unique identifier for tracking
- Human-readable description of the work
- Optional assignment to specific worker (or available to any)
- Current status in lifecycle
- Timestamps for creation, claiming, and completion
- Worker identity for who claimed/completed it
- Optional result data from execution

**Purpose:** Central coordination point where all work is tracked and distributed.

### 2. Worker Status File

A shared file mapping worker identities to their current state. Enables coordinator to monitor the health and availability of the worker pool.

**Key Worker Information:**
- Current activity status (active/inactive)
- Capabilities or specializations (what types of work this worker handles)
- Registration timestamp (when worker joined the system)
- Health monitoring timestamps (regular heartbeat updates)
- Task activity timestamps (when last claimed/completed tasks)

**Purpose:** Health monitoring and worker discovery. Allows coordinator to know which workers are available and what they can do.

### 3. Progress Tracking File (Optional)

A shared file tracking overall project or phase progress. Useful for long-running multi-phase projects.

**Key Information:**
- Current progress metric (steps completed, percentage, etc.)
- Overall status indicator
- Metadata about current phase or blockers
- Last update timestamp

**Purpose:** High-level project status without needing to analyze entire task queue.

### 4. Communication Log (Optional)

A time-ordered log of messages from agents. Uses append-only format for safe concurrent writes.

**Key Information:**
- Timestamp for each message
- Agent identity (who sent it)
- Message content (status updates, notifications, debugging info)

**Purpose:** Debugging, monitoring, and loose coordination through broadcast messages.

## Agent Roles

### Coordinator Functions

**Task Management:**
- Create new tasks with descriptions and optional worker assignments
- Monitor queue status (how many pending/in-progress/completed)
- Track progress toward completion
- Identify stale tasks that may need reassignment

**Worker Management:**
- Discover which workers are currently active
- Check worker capabilities for task assignment
- Monitor worker health through heartbeat timestamps

**System Orchestration:**
- Break down large goals into individual tasks
- Assign tasks to specialized workers when appropriate
- Monitor overall progress and adjust strategy
- Handle error recovery (reassigning failed tasks)

### Worker Functions

**Registration:**
- Announce presence to the system
- Declare capabilities and specializations
- Maintain health status through regular heartbeats

**Task Execution Loop:**
- Poll queue for available tasks
- Claim next task that matches capabilities
- Execute the work
- Mark task complete with optional result data
- Reset idle timer after each task

**Status Updates:**
- Send regular heartbeats to prove liveness
- Update timestamps when claiming/completing tasks
- Write messages to communication log for visibility

## Workflow Patterns

### Pattern 1: Simple Task Distribution

The coordinator creates a list of independent tasks. Each task can be completed in any order. Workers continuously poll for available work, claim the next task, execute it, and mark it complete. This provides automatic load balancing across multiple workers.

**Characteristics:**
- Tasks are independent (no dependencies)
- Any worker can handle any task
- First available worker claims each task
- Simple parallel execution

**Use Cases:**
- Running test suites across multiple files
- Processing batch data transformations
- Creating multiple similar components

### Pattern 2: Capability-Based Assignment

The coordinator creates specialized tasks that require specific skills. Tasks are optionally assigned to workers with matching capabilities. Workers check if they have required capabilities before executing.

**Characteristics:**
- Workers declare specializations (backend, frontend, testing, etc.)
- Coordinator assigns tasks to matching workers
- Fallback to any-worker if specialist unavailable
- Efficient routing of work to appropriate agents

**Use Cases:**
- Backend tasks to API specialist
- Frontend tasks to UI specialist
- Database migrations to database specialist

### Pattern 3: Progress Monitoring

The coordinator periodically checks queue status to monitor completion. When all tasks are done, coordinator proceeds to next phase or declares success.

**Characteristics:**
- Non-blocking progress checks
- Coordinator doesn't wait, just observes
- Can add more tasks dynamically based on progress
- Clear completion criteria

**Use Cases:**
- Multi-phase projects (complete Phase 1 before starting Phase 2)
- Adaptive work (create new tasks based on results)
- Reporting progress to human users

### Pattern 4: Error Recovery

The system detects when workers die mid-task by checking heartbeat timestamps. Tasks claimed by dead workers are reset to pending status for retry.

**Characteristics:**
- Tasks have timeout thresholds
- Stale tasks automatically become available again
- No manual intervention needed
- Fault-tolerant execution

**Use Cases:**
- Handling unexpected worker failures
- Network interruptions
- Resource exhaustion recovery

## Best Practices

### 1. Atomic Operations
Ensure file updates are atomic to prevent corruption from concurrent writes. Use appropriate file-locking or atomic write patterns for your platform.

### 2. Heartbeat Frequency
Workers should update their heartbeat timestamp every 30-60 seconds. This allows quick detection of failures without excessive overhead.

### 3. Idle Time Management
Track idle time separately from total runtime. Reset the idle timer when tasks are claimed or completed, not continuously during execution.

### 4. Task Granularity
Break work into tasks that take 5-15 minutes each. Too small creates overhead, too large risks losing work if worker dies.

### 5. Worker Specialization
Declare worker capabilities to enable efficient task routing. Avoids waste from workers claiming tasks they can't handle.

### 6. Error Handling
Design tasks to be idempotent (safe to retry). Include retry logic and consider task timeout values carefully.

### 7. Communication
Use the message log for status updates and debugging. Helps humans understand what's happening across the distributed system.

### 8. Monitoring
Coordinator should periodically check worker health. Dead workers should be detected within 2-3 minutes of their last heartbeat.

## Context Isolation Principle

**Critical Understanding:** Workers have ZERO conversation context. All coordination happens exclusively through files.

### What Workers Cannot Access
- Conversation history with coordinator
- Verbal instructions from previous interactions
- Context from other workers' conversations
- Implicit understanding of project goals

### How to Coordinate Without Context

**Task Instruction Files:**
Every task should reference a detailed instruction file containing:
- Complete objective description
- Specific requirements and constraints
- Step-by-step guidance
- Links to context files that need to be read first
- Acceptance criteria for completion

**Context Files:**
Tasks include lists of files workers must read before executing:
- Documentation files (architecture, specifications)
- Related code files (base classes, utilities)
- Previous results from dependent tasks

**Self-Contained Execution:**
Each task must be 100% self-contained. A worker with zero prior knowledge should be able to:
1. Read the task from queue
2. Read the instruction file
3. Read all referenced context files
4. Execute the work successfully
5. Write results back to VPS

**Example Flow:**
- Coordinator creates instruction file with all details
- Coordinator adds task to queue with reference to instruction file
- Worker claims task from queue
- Worker reads instruction file
- Worker reads all context files mentioned
- Worker executes based entirely on file contents
- Worker writes results and marks task complete

No verbal communication needed - everything is in files.

## Error Scenarios and Handling

### Worker Dies Mid-Task
Tasks have a timeout threshold. The coordinator periodically scans for tasks claimed longer than this threshold with no completion. These stale tasks are reset to pending status for another worker to claim.

### Queue File Corruption
Implement validation when reading the queue. Invalid entries are logged and skipped. A queue repair function can rebuild from valid entries only.

### Race Conditions
Multiple workers might try to claim the same task simultaneously. The file system's write semantics determine which claim wins. Timestamps and worker IDs help detect conflicts. Proper file locking prevents this entirely.

### Worker Specialization Mismatch
A worker claims a task but lacks required capabilities. Worker should check requirements before executing and release the task back if unable to handle it.

### Network or API Failures
Workers should handle VPS API errors gracefully. Failed operations should be retried with exponential backoff. Tasks should not be marked complete if file operations failed.

## System Capabilities

This architecture enables:

- **Distributed Work Coordination**: Multiple agents working in parallel without stepping on each other
- **Dynamic Load Balancing**: Work automatically distributed to available workers
- **Worker Specialization**: Tasks routed to agents with appropriate skills
- **Progress Monitoring**: Real-time visibility into system state
- **Fault Tolerance**: Automatic task reassignment if workers fail
- **Agent Communication**: Shared message log for status and debugging
- **Scalability**: Add more workers to increase throughput
- **Persistence**: All state survives individual agent sessions
- **Context Isolation**: Workers operate independently with file-based coordination

## Advantages Over Traditional Approaches

**Compared to GitHub Branches:**
- No merge conflicts from parallel work
- Real-time coordination instead of async PR reviews
- Automatic load balancing across workers
- Central state visible to all agents instantly

**Compared to Conversation-Based Coordination:**
- No context isolation issues
- Workers can join/leave without losing state
- Persistent coordination across sessions
- Scales to many workers without confusion

**Compared to Manual Task Assignment:**
- Automatic distribution to available workers
- No human bottleneck for task routing
- Progress visible without asking each agent
- Built-in fault tolerance and retry

This creates a production-grade distributed system using simple file-based coordination on a shared VPS.
