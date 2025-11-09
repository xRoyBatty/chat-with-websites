# Task Queue Coordination System

## Overview

The task queue system enables multiple Claude agents to coordinate work through shared state files on the VPS. This creates a distributed work system where a coordinator assigns tasks and workers claim and execute them autonomously.

## Architecture

```
Coordinator Agent
    ↓ Creates tasks
Task Queue (task-queue.json)
    ↓ Workers poll
Worker Agents (1-N)
    ↓ Claim & execute
Task Results
    ↓ Monitor
Coordinator Agent
```

## Core Data Structures

### 1. Task Queue (task-queue.json)

Array of task objects:

```json
[
  {
    "id": 1731159000123,
    "description": "Create user authentication API endpoint",
    "instruction_file": "tasks/task-1731159000123-instructions.md",
    "context_files": ["docs/api-spec.md", "src/models/user.py"],
    "assigned_to": "worker-backend",
    "status": "pending",
    "created_at": "2025-11-09T10:00:00",
    "claimed_by": null,
    "claimed_at": null,
    "completed_by": null,
    "completed_at": null,
    "result": null,
    "metadata": {
      "working_directory": "src/api",
      "acceptance_criteria": ["Tests pass", "Coverage > 80%"],
      "estimated_minutes": 30
    }
  },
  {
    "id": 1731159000124,
    "description": "Write tests for auth endpoint",
    "instruction_file": "tasks/task-1731159000124-instructions.md",
    "context_files": ["src/api/auth.py", "tests/conftest.py"],
    "assigned_to": null,
    "status": "in_progress",
    "created_at": "2025-11-09T10:00:00",
    "claimed_by": "worker-testing",
    "claimed_at": "2025-11-09T10:02:00",
    "completed_by": null,
    "completed_at": null,
    "result": null,
    "metadata": {
      "working_directory": "tests/api",
      "acceptance_criteria": ["All tests pass", "Coverage > 90%"],
      "estimated_minutes": 20
    }
  },
  {
    "id": 1731159000125,
    "description": "Build React login component",
    "instruction_file": "tasks/task-1731159000125-instructions.md",
    "context_files": ["docs/ui-design.md", "src/components/Form.jsx"],
    "assigned_to": "worker-frontend",
    "status": "completed",
    "created_at": "2025-11-09T10:00:00",
    "claimed_by": "worker-frontend",
    "claimed_at": "2025-11-09T10:01:00",
    "completed_by": "worker-frontend",
    "completed_at": "2025-11-09T10:15:00",
    "result": {
      "files_created": ["src/components/Login.jsx"],
      "tests_passed": true,
      "status": "success"
    },
    "metadata": {
      "working_directory": "src/components",
      "acceptance_criteria": ["Component renders", "Form validation works"],
      "estimated_minutes": 15
    }
  }
]
```

**Task Status Flow:**
```
pending → in_progress → completed
```

**Fields:**
- `id`: Unique identifier (timestamp in milliseconds)
- `description`: Human-readable task description
- `instruction_file`: Path to complete task instructions (REQUIRED for context-free workers)
- `context_files`: Array of files worker should read before executing
- `assigned_to`: Specific worker ID, or `null` for any worker
- `status`: Current state (pending, in_progress, completed)
- `claimed_by`: Worker that claimed the task
- `result`: Optional result data from worker
- `metadata`: Optional object with:
  - `working_directory`: Where task should be executed
  - `acceptance_criteria`: List of requirements for completion
  - `estimated_minutes`: Time estimate for planning

### 2. Worker Status (worker-status.json)

Object mapping worker IDs to status:

```json
{
  "worker-backend": {
    "status": "active",
    "capabilities": ["backend", "api", "database"],
    "registered_at": "2025-11-09T10:00:00",
    "last_heartbeat": "2025-11-09T10:15:30",
    "last_task_claimed": "2025-11-09T10:10:00",
    "last_task_completed": "2025-11-09T10:14:00"
  },
  "worker-frontend": {
    "status": "active",
    "capabilities": ["frontend", "react", "ui"],
    "registered_at": "2025-11-09T10:00:00",
    "last_heartbeat": "2025-11-09T10:15:25",
    "last_task_claimed": "2025-11-09T10:12:00",
    "last_task_completed": "2025-11-09T10:15:00"
  },
  "worker-testing": {
    "status": "active",
    "capabilities": ["testing", "pytest", "jest"],
    "registered_at": "2025-11-09T10:00:00",
    "last_heartbeat": "2025-11-09T10:15:28",
    "last_task_claimed": "2025-11-09T10:13:00",
    "last_task_completed": null
  }
}
```

**Fields:**
- `status`: Worker state (active/inactive)
- `capabilities`: What types of tasks this worker can handle
- `registered_at`: When worker joined
- `last_heartbeat`: Last time worker sent heartbeat (for health monitoring)
- `last_task_claimed`: Last task start time (for idle calculation)
- `last_task_completed`: Last task finish time (for idle calculation)

### 3. Progress Tracking (progress.json)

Optional file for tracking overall project progress:

```json
{
  "current_step": 45,
  "total_steps": 100,
  "status": "in_progress",
  "last_updated": "2025-11-09T10:15:30",
  "metadata": {
    "phase": "backend_implementation",
    "blockers": []
  }
}
```

### 4. Communication Log (agent-comms.jsonl)

JSON Lines format for agent messages:

```jsonl
{"timestamp": "2025-11-09T10:00:00", "agent": "coordinator", "message": "Created 20 tasks for todo app"}
{"timestamp": "2025-11-09T10:01:00", "agent": "worker-backend", "message": "Starting work on user model"}
{"timestamp": "2025-11-09T10:15:00", "agent": "worker-backend", "message": "User model complete"}
{"timestamp": "2025-11-09T10:15:30", "agent": "worker-frontend", "message": "Login UI integrated with backend"}
```

## VPS Helper Functions

### Coordinator Functions

#### add_task()
```python
def add_task(description, instruction_file, context_files=None, assigned_to=None, metadata=None):
    """
    Add a new task to the queue

    Args:
        description (str): Short task description
        instruction_file (str): Path to complete task instructions
        context_files (list|None): Files worker should read for context
        assigned_to (str|None): Specific worker ID, or None for any
        metadata (dict|None): Optional metadata (working_dir, acceptance criteria, etc.)

    Returns:
        dict: The created task object
    """
    task = {
        "id": int(time.time() * 1000),
        "description": description,
        "instruction_file": instruction_file,
        "context_files": context_files or [],
        "assigned_to": assigned_to,
        "status": "pending",
        "created_at": datetime.now().isoformat(),
        "claimed_by": None,
        "claimed_at": None,
        "completed_by": None,
        "completed_at": None,
        "result": None,
        "metadata": metadata or {}
    }

    queue = read_task_queue()
    queue.append(task)
    save_task_queue(queue)

    return task
```

**Usage:**
```python
# 1. First, create the instruction file
instruction_content = """
# Task: Create User Model

## Objective
Create SQLAlchemy User model with authentication

## Requirements
- Model in src/models/user.py
- Fields: id, username, email, password_hash, created_at
- Password hashing with bcrypt

## Context
Read these files first for background:
- docs/database-schema.md
- src/models/base.py

## Steps
1. Import Base from base.py
2. Create User class
3. Add fields with proper types
4. Implement password hashing

## Acceptance Criteria
- File created
- Password hashing works
- Model extends Base
"""

deploy_file('tasks/task-123-instructions.md', instruction_content)

# 2. Add task to queue with instruction file reference
add_task(
    description="Create User model with authentication",
    instruction_file="tasks/task-123-instructions.md",
    context_files=["docs/database-schema.md", "src/models/base.py"],
    assigned_to="worker-backend",
    metadata={
        "working_directory": "src/models",
        "acceptance_criteria": ["File exists", "Tests pass"],
        "estimated_minutes": 30
    }
)
```

#### get_active_workers()
```python
def get_active_workers():
    """
    Get workers that are currently alive (recent heartbeat)

    Returns:
        dict: Active workers {worker_id: worker_info}
    """
    workers = read_worker_status()
    active = {}

    for worker_id, info in workers.items():
        last_hb = datetime.fromisoformat(info['last_heartbeat'])
        if (datetime.now() - last_hb).total_seconds() < 120:  # 2 min
            active[worker_id] = info

    return active
```

#### get_queue_status()
```python
def get_queue_status():
    """
    Get summary of task queue

    Returns:
        dict: {pending: int, in_progress: int, completed: int}
    """
    queue = read_task_queue()

    return {
        "pending": len([t for t in queue if t['status'] == 'pending']),
        "in_progress": len([t for t in queue if t['status'] == 'in_progress']),
        "completed": len([t for t in queue if t['status'] == 'completed']),
        "total": len(queue)
    }
```

### Worker Functions

#### register_worker()
```python
def register_worker(worker_id, capabilities=None):
    """
    Register worker as active

    Args:
        worker_id (str): Unique worker identifier
        capabilities (list): What this worker can do
    """
    workers = read_worker_status()

    workers[worker_id] = {
        "status": "active",
        "capabilities": capabilities or [],
        "registered_at": datetime.now().isoformat(),
        "last_heartbeat": datetime.now().isoformat(),
        "last_task_claimed": None,
        "last_task_completed": None
    }

    save_worker_status(workers)
```

#### heartbeat()
```python
def heartbeat(worker_id):
    """
    Update worker's last heartbeat time

    Args:
        worker_id (str): Worker sending heartbeat
    """
    workers = read_worker_status()

    if worker_id in workers:
        workers[worker_id]['last_heartbeat'] = datetime.now().isoformat()
        save_worker_status(workers)
```

#### claim_task()
```python
def claim_task(worker_id):
    """
    Claim next available task for this worker

    Args:
        worker_id (str): Worker claiming task

    Returns:
        dict|None: Task object if claimed, None if no tasks
    """
    queue = read_task_queue()

    # Find first pending task (unassigned or assigned to this worker)
    for task in queue:
        if task['status'] == 'pending':
            if task['assigned_to'] is None or task['assigned_to'] == worker_id:
                # Claim it
                task['status'] = 'in_progress'
                task['claimed_by'] = worker_id
                task['claimed_at'] = datetime.now().isoformat()

                save_task_queue(queue)

                # Reset idle timer
                update_worker_idle_timer(worker_id, 'claimed')

                return task

    return None
```

#### complete_task()
```python
def complete_task(task_id, worker_id, result_data=None):
    """
    Mark task as complete

    Args:
        task_id (int): Task identifier
        worker_id (str): Worker completing task
        result_data (dict|None): Optional result data
    """
    queue = read_task_queue()

    for task in queue:
        if task['id'] == task_id:
            task['status'] = 'completed'
            task['completed_by'] = worker_id
            task['completed_at'] = datetime.now().isoformat()
            task['result'] = result_data
            break

    save_task_queue(queue)

    # Reset idle timer
    update_worker_idle_timer(worker_id, 'completed')
```

### Communication Functions

#### write_message()
```python
def write_message(agent_name, message):
    """
    Write a message to shared communication log

    Args:
        agent_name (str): Agent sending message
        message (str): Message content
    """
    msg = {
        "timestamp": datetime.now().isoformat(),
        "agent": agent_name,
        "message": message
    }

    # Append to JSONL file
    execute_command(
        f"echo '{json.dumps(msg)}' >> agent-comms.jsonl"
    )
```

#### read_messages()
```python
def read_messages(since_timestamp=None):
    """
    Read messages from communication log

    Args:
        since_timestamp (str|None): Only return messages after this time

    Returns:
        list: List of message objects
    """
    result = execute_command("cat agent-comms.jsonl 2>/dev/null || echo ''")

    if not result['stdout']:
        return []

    messages = [
        json.loads(line)
        for line in result['stdout'].strip().split('\n')
        if line
    ]

    if since_timestamp:
        messages = [
            m for m in messages
            if m['timestamp'] > since_timestamp
        ]

    return messages
```

## Workflow Patterns

### Pattern 1: Simple Task Distribution

```python
# Coordinator
tasks = [
    "Create user model",
    "Create post model",
    "Create comment model"
]

for task_desc in tasks:
    add_task(task_desc, assigned_to="worker-backend")

# Worker loop
while True:
    task = claim_task(WORKER_ID)
    if task:
        result = do_work(task)
        complete_task(task['id'], WORKER_ID, result)
    else:
        time.sleep(30)
```

### Pattern 2: Capability-Based Assignment

```python
# Coordinator
if "worker-backend" in get_active_workers():
    add_task("Build API endpoint", assigned_to="worker-backend")
else:
    add_task("Build API endpoint", assigned_to=None)  # Any worker

# Worker with capability check
task = claim_task(WORKER_ID)
if task:
    if requires_capability(task, MY_CAPABILITIES):
        execute_task(task)
    else:
        # Release task back to queue
        release_task(task['id'])
```

### Pattern 3: Progress Monitoring

```python
# Coordinator checking progress
while True:
    status = get_queue_status()

    if status['pending'] == 0 and status['in_progress'] == 0:
        print("All tasks complete!")
        break

    print(f"Progress: {status['completed']}/{status['total']}")
    time.sleep(60)
```

## Best Practices

1. **Atomic Operations**: Use file locks or atomic writes for queue updates
2. **Heartbeats**: Workers should heartbeat every 30-60 seconds
3. **Idle Management**: Track idle time separately from total runtime
4. **Error Handling**: Tasks should include retry logic or error states
5. **Task Granularity**: Break large tasks into smaller ones (5-15 min each)
6. **Worker Specialization**: Assign capabilities to workers for efficient routing
7. **Communication**: Use message log for debugging and coordination
8. **Monitoring**: Coordinator should check worker health periodically

## Error Scenarios

### Worker Dies Mid-Task
```python
# Coordinator detects stale task
tasks = get_stale_tasks(timeout_minutes=30)
for task in tasks:
    task['status'] = 'pending'  # Reset for retry
    task['claimed_by'] = None
```

### Queue Corruption
```python
# Add validation
def validate_queue():
    queue = read_task_queue()
    valid = []

    for task in queue:
        if 'id' in task and 'status' in task:
            valid.append(task)

    save_task_queue(valid)
```

### Race Condition (Multiple Workers Claim Same Task)
```python
# Use timestamps + worker ID to detect
# Last writer wins, or implement file locking
```

## Summary

The task queue system enables:
- ✅ Distributed work coordination
- ✅ Dynamic load balancing
- ✅ Worker specialization
- ✅ Progress monitoring
- ✅ Fault tolerance (task reassignment)
- ✅ Agent communication
- ✅ Scalable multi-agent systems

This creates a **production-grade distributed system** using simple JSON files on a VPS as the coordination layer.
