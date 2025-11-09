# Multi-Agent VPS System - Implementation TODO

## Overview

This project implements a VPS-based multi-agent coordination system where multiple Claude agents can work together on the same codebase through a shared workspace on a VPS.

**Core Concept:** GitHub repo contains only instructions and tooling. Actual code lives entirely on VPS.

**⚠️ CRITICAL:** Workers have ZERO conversation context. All task coordination happens through files on VPS. Every task must include instruction files with complete context.

---

## Prerequisites Checklist

Before starting implementation, verify:

- [ ] **VPS API is running** at `51.75.162.195:5555`
- [ ] **VPS_API_KEY** is set in Claude Code environment named "vps-dev"
- [ ] **Environment "vps-dev"** has full network access enabled
- [ ] You have read all knowledge files in `knowledge/` directory
- [ ] You understand that workers have NO conversation context (file-based only)

---

## Phase 1: Foundation (Start Here)

### Step 1: Test VPS Connection

**Goal:** Verify the VPS API is reachable and authentication works

**Tasks:**
1. Create test script `test_vps_connection.py`
2. Test `/test` endpoint (no auth)
3. Test `/list` endpoint (with auth)
4. Test `/execute` endpoint (with auth)
5. Verify `VPS_API_KEY` environment variable is accessible

**Success Criteria:**
- All 4 tests pass
- Can list VPS directory contents
- Can execute commands on VPS

**Files to create:**
- `test_vps_connection.py`

**Reference:**
- `knowledge/04-vps-api-specification.md`

---

### Step 2: Create VPS Deployment Skill

**Goal:** Build the skill that allows Claude to interact with VPS

**Directory structure:**
```
.claude/
└── skills/
    └── vps-deploy/
        ├── skill.md           # Skill documentation
        └── vps_deploy_helper.py  # Helper functions
```

**Tasks:**
1. Create skill directory structure
2. Implement `vps_deploy_helper.py` with functions:
   - `deploy_file(filepath, content)` - Deploy files to VPS
   - `deploy_multiple(files_dict)` - Deploy multiple files
   - `list_files(path)` - List VPS directory
   - `execute_command(command, workdir)` - Run commands
   - `read_file(filepath)` - Read file from VPS
   - `search_files(pattern, directory)` - Find files
   - `search_content(pattern, directory)` - Grep in files
   - `test_connection()` - Verify API connectivity
3. Create `skill.md` with usage instructions
4. Test all functions work correctly

**Success Criteria:**
- Can deploy files to VPS
- Can list VPS directories
- Can execute commands on VPS
- Can read files from VPS

**Files to create:**
- `.claude/skills/vps-deploy/skill.md`
- `.claude/skills/vps-deploy/vps_deploy_helper.py`

**Reference:**
- `knowledge/04-vps-api-specification.md`

---

### Step 3: Create Task Queue Coordination Functions

**Goal:** Extend VPS helper with multi-agent coordination functions

**⚠️ Important:** Task structure must include instruction_file and context_files to work with context-free workers.

**Tasks:**
1. Add to `vps_deploy_helper.py`:

   **Coordinator functions:**
   - `add_task(description, instruction_file, context_files=[], assigned_to=None, metadata={})`
   - `get_active_workers()`
   - `get_queue_status()`
   - `create_task_instruction(task_id, requirements, context_files, acceptance_criteria)`

   **Worker functions:**
   - `register_worker(worker_id, capabilities)`
   - `heartbeat(worker_id)`
   - `claim_task(worker_id)`
   - `complete_task(task_id, worker_id, result)`
   - `should_worker_continue(worker_id, max_idle_minutes)`

   **Communication functions:**
   - `write_message(agent_name, message)`
   - `read_messages(since_timestamp=None)`

2. Update task data structure to include:
   ```json
   {
     "id": 1731159000123,
     "description": "Create user authentication API endpoint",
     "instruction_file": "tasks/task-1731159000123-instructions.md",
     "context_files": ["docs/api-spec.md", "docs/project-requirements.md"],
     "assigned_to": "worker-backend",
     "status": "pending",
     "metadata": {
       "working_directory": "src/api",
       "acceptance_criteria": ["Tests pass", "Coverage > 80%"],
       "estimated_minutes": 30
     }
   }
   ```

3. Test task queue operations locally
4. Create test coordinator script
5. Create test worker script

**Success Criteria:**
- Can create tasks with instruction files in queue on VPS
- Workers can claim tasks and read instruction files
- Can mark tasks complete
- Worker status tracking works

**Files to modify:**
- `.claude/skills/vps-deploy/vps_deploy_helper.py`

**Reference:**
- `knowledge/05-task-queue-coordination.md`

---

## Phase 2: Worker Infrastructure

### Step 4: Create Stop Hook for Workers

**Goal:** Implement Stop hook that keeps workers alive while tasks are available

**Directory structure:**
```
.claude/
├── hooks/
│   └── worker-stop-check.py
└── settings.json
```

**Tasks:**
1. Create `.claude/hooks/` directory
2. Create `worker-stop-check.py`:
   - Read hook input from stdin
   - Get worker ID from environment
   - Call `should_worker_continue(worker_id, max_idle_minutes=10)`
   - Return JSON with `decision` (approve/block) and `reason`
3. Update `.claude/settings.json` to register Stop hook:
   ```json
   {
     "hooks": {
       "Stop": [{
         "hooks": [{
           "type": "command",
           "command": "python3 .claude/hooks/worker-stop-check.py",
           "timeout": 10
         }]
       }]
     }
   }
   ```
4. Test hook blocks stoppage when tasks exist
5. Test hook allows stoppage after idle timeout

**Success Criteria:**
- Hook blocks stop when tasks in queue
- Hook blocks stop when idle < 10 minutes
- Hook allows stop when idle >= 10 minutes
- Hook properly resets idle timer on task claim/complete

**Files to create:**
- `.claude/hooks/worker-stop-check.py`
- `.claude/settings.json`

**Reference:**
- `knowledge/03-stop-hooks-worker-persistence.md`

---

### Step 5: Create Worker CLAUDE.md Template

**Goal:** Create instructions for worker agents

**⚠️ Critical:** Worker template must emphasize discrete cycles and file-based task execution.

**Tasks:**
1. Create `templates/WORKER_CLAUDE.md`:
   - Worker initialization (register, set ID)
   - Discrete cycle pattern (NOT continuous loop)
   - Explain Stop hook behavior
   - How to read instruction files from tasks
   - How to read context files
   - How to save results to VPS
   - Include error handling guidance
2. Test with a single worker session
3. Verify worker stays alive while idle (within timeout)
4. Verify worker shuts down gracefully after timeout

**Key Content:**
```markdown
## On Each Conversation Cycle:

1. Send heartbeat
2. Claim task (if available)
3. If task claimed:
   - Read instruction file from VPS (task['instruction_file'])
   - Read all context files from VPS (task['context_files'])
   - Execute requirements
   - Save results to VPS
   - Mark task complete
4. If no task: Report "No tasks" and finish
5. Session tries to stop → Stop hook blocks or approves
```

**Success Criteria:**
- Worker can register successfully
- Worker operates in discrete cycles (not continuous loop)
- Worker reads instruction files from tasks
- Worker executes based on file content
- Worker respects idle timeout
- Worker shuts down gracefully

**Files to create:**
- `templates/WORKER_CLAUDE.md`

**Reference:**
- `knowledge/03-stop-hooks-worker-persistence.md`
- `knowledge/05-task-queue-coordination.md`

---

### Step 6: Create Coordinator CLAUDE.md Template

**Goal:** Create instructions for coordinator agent

**⚠️ Critical:** Coordinator must create complete instruction files for each task.

**Tasks:**
1. Create `templates/COORDINATOR_CLAUDE.md`:
   - Coordinator role and responsibilities
   - How to break user requests into tasks
   - **How to create instruction files with complete context**
   - How to add tasks to queue with instruction_file and context_files
   - How to monitor worker health
   - How to check queue status
   - How to report progress to user
2. Include examples of:
   - Creating task instruction files
   - Identifying required context files
   - Writing self-contained task instructions
   - Assigning tasks to specific workers
   - Checking active workers
   - Monitoring queue progress

**Key Content:**
```markdown
## Creating Tasks (CRITICAL):

Workers have ZERO conversation context. Every task needs:

1. **Instruction file** (tasks/task-{id}-instructions.md):
   - Complete requirements
   - Step-by-step instructions
   - Expected output
   - Acceptance criteria

2. **Context files** (referenced in task):
   - Project specs
   - Architecture docs
   - Code standards
   - Related code files

Example:
```python
# 1. Create instruction file
instruction_content = """
# Task: Create User Model

## Objective
Create a User model with authentication fields

## Requirements
- SQLAlchemy model in src/models/user.py
- Fields: id, username, email, password_hash, created_at
- Password hashing using bcrypt
- Validation: email format, username min 3 chars

## Context
Read these files first:
- docs/database-schema.md - Database design
- src/models/base.py - Base model class

## Steps
1. Import Base from src/models/base.py
2. Create User class extending Base
3. Add all fields with proper types
4. Add password setter with bcrypt hashing
5. Add password verification method

## Acceptance Criteria
- [ ] File created: src/models/user.py
- [ ] All fields present with correct types
- [ ] Password hashing implemented
- [ ] Can create user and verify password
"""

deploy_file('tasks/task-1234-instructions.md', instruction_content)

# 2. Add task to queue
add_task(
    description="Create User model with authentication",
    instruction_file="tasks/task-1234-instructions.md",
    context_files=[
        "docs/database-schema.md",
        "src/models/base.py"
    ],
    assigned_to="worker-backend",
    metadata={
        "working_directory": "src/models",
        "acceptance_criteria": ["File created", "Tests pass"],
        "estimated_minutes": 20
    }
)
```
```

**Success Criteria:**
- Coordinator can break down complex requests
- Coordinator creates complete instruction files
- Coordinator identifies necessary context files
- Coordinator can monitor worker status
- Coordinator can report progress

**Files to create:**
- `templates/COORDINATOR_CLAUDE.md`

**Reference:**
- `knowledge/05-task-queue-coordination.md`
- `knowledge/02-vps-multi-agent-architecture.md`

---

## Phase 3: Testing & Validation

### Step 7: Single Worker Test

**Goal:** Verify single worker can execute tasks end-to-end using instruction files

**Test scenario:**
1. Coordinator creates 3 tasks with complete instruction files
2. Single worker claims and executes all 3 using only file content
3. Verify results on VPS
4. Worker shuts down after idle timeout

**Tasks:**

1. **Create test instruction files:**
   ```
   tasks/test-task-1-instructions.md:
   ---
   # Task: Create Hello World File

   Create a file called `hello.txt` with content "Hello from VPS!"

   ## Steps
   1. Use VPS deploy function
   2. File path: test-output/hello.txt
   3. Content: "Hello from VPS!"

   ## Acceptance
   - File exists at test-output/hello.txt
   - Content matches exactly
   ---

   tasks/test-task-2-instructions.md:
   ---
   # Task: Create Data File

   Create a JSON file with test data

   ## Steps
   1. Create file: test-output/data.json
   2. Content: {"test": true, "timestamp": "<current-time>"}

   ## Acceptance
   - Valid JSON file
   - Contains test and timestamp fields
   ---

   tasks/test-task-3-instructions.md:
   ---
   # Task: List Created Files

   List all files in test-output/ and save to manifest

   ## Steps
   1. List files in test-output/
   2. Save file list to test-output/manifest.txt

   ## Acceptance
   - manifest.txt contains hello.txt and data.json
   ---
   ```

2. Start coordinator session
3. Coordinator deploys instruction files to VPS
4. Coordinator adds 3 tasks to queue (with instruction_file paths)
5. Start worker session with WORKER_ID environment variable
6. Monitor worker execution (should read instruction files)
7. Verify files created on VPS
8. Verify worker graceful shutdown

**Success Criteria:**
- All 3 instruction files deployed to VPS
- All 3 tasks created in queue with instruction_file field
- Worker claimed tasks by reading from queue
- Worker read instruction files from VPS
- Worker executed based ONLY on instruction file content (no conversation context)
- Files exist on VPS
- Worker shut down after idle timeout
- Queue shows all tasks completed

---

### Step 8: Multi-Worker Test

**Goal:** Verify multiple workers can collaborate using file-based coordination

**Test scenario:**
1. Coordinator creates 10 tasks with instruction files
2. 3 workers running simultaneously
3. All tasks distributed and completed
4. No race conditions or conflicts

**Tasks:**
1. Start coordinator session
2. Create 10 instruction files with varied complexity
3. Deploy all instruction files to VPS
4. Add 10 tasks to queue (each with instruction_file and context_files)
5. Start 3 worker sessions (worker-1, worker-2, worker-3)
6. Monitor task distribution via queue status
7. Verify all tasks completed
8. Check for any conflicts or errors

**Success Criteria:**
- All 10 instruction files deployed
- All 10 tasks completed
- Work distributed across workers
- No duplicate task claims (race conditions)
- All workers shutdown gracefully when done
- Each worker operated purely from instruction files

---

### Step 9: Real-World Test (Build a Simple App)

**Goal:** Use the system to build an actual application with complete file-based coordination

**Test scenario:**
Coordinator receives: "Build a simple Flask API with 2 endpoints: /hello and /time"

**⚠️ Critical:** Each task must have complete instructions and context files

**Tasks:**
1. Start coordinator with real-world request
2. Coordinator breaks down into tasks with instruction files:

   **Task 1 Instruction File** (tasks/flask-app-structure.md):
   ```markdown
   # Task: Create Flask App Structure

   ## Objective
   Set up basic Flask application structure

   ## Requirements
   Create the following files:
   - app.py - Main Flask application
   - requirements.txt - Dependencies
   - README.md - Setup instructions

   ## Flask App Template
   ```python
   from flask import Flask, jsonify
   from datetime import datetime

   app = Flask(__name__)

   # Endpoints will be added by other tasks

   if __name__ == '__main__':
       app.run(host='0.0.0.0', port=5000)
   ```

   ## Requirements.txt
   ```
   Flask==2.3.0
   ```

   ## Acceptance Criteria
   - [ ] app.py created
   - [ ] requirements.txt created
   - [ ] README.md created
   - [ ] All in flask-demo/ directory
   ```

   **Task 2 Instruction File** (tasks/flask-hello-endpoint.md):
   ```markdown
   # Task: Implement /hello Endpoint

   ## Context Files
   Read these first:
   - flask-demo/app.py - Main Flask app

   ## Requirements
   Add /hello endpoint to Flask app

   ## Implementation
   Add this route to app.py (after imports, before if __name__):
   ```python
   @app.route('/hello')
   def hello():
       return jsonify({
           "message": "Hello from Flask!",
           "status": "success"
       })
   ```

   ## Acceptance Criteria
   - [ ] /hello route added to app.py
   - [ ] Returns JSON with message and status
   - [ ] No syntax errors
   ```

   **Task 3 Instruction File** (tasks/flask-time-endpoint.md):
   ```markdown
   # Task: Implement /time Endpoint

   ## Context Files
   Read these first:
   - flask-demo/app.py - Main Flask app

   ## Requirements
   Add /time endpoint to Flask app

   ## Implementation
   Add this route to app.py:
   ```python
   @app.route('/time')
   def current_time():
       return jsonify({
           "current_time": datetime.now().isoformat(),
           "timezone": "UTC"
       })
   ```

   ## Acceptance Criteria
   - [ ] /time route added to app.py
   - [ ] Returns current timestamp
   - [ ] Uses datetime.now()
   ```

   **Task 4 Instruction File** (tasks/flask-test.md):
   ```markdown
   # Task: Create Tests for Flask API

   ## Context Files
   Read these first:
   - flask-demo/app.py - Flask application to test

   ## Requirements
   Create test_app.py with tests for both endpoints

   ## Test Template
   ```python
   import pytest
   from app import app

   @pytest.fixture
   def client():
       app.config['TESTING'] = True
       with app.test_client() as client:
           yield client

   def test_hello(client):
       response = client.get('/hello')
       assert response.status_code == 200
       data = response.get_json()
       assert data['message'] == "Hello from Flask!"

   def test_time(client):
       response = client.get('/time')
       assert response.status_code == 200
       data = response.get_json()
       assert 'current_time' in data
   ```

   ## Acceptance Criteria
   - [ ] test_app.py created
   - [ ] Both endpoints tested
   - [ ] Tests pass when run
   ```

3. Start 2-3 workers
4. Workers execute tasks based on instruction files
5. Verify working API on VPS

**Success Criteria:**
- Flask API is deployed to VPS
- Both endpoints work
- Tests pass
- Code lives entirely on VPS (not in Git)
- **All work done via instruction files (no conversation context used)**

---

## Phase 4: Documentation & Handoff

### Step 10: Create Usage Guide

**Goal:** Document how to use the system

**Tasks:**
1. Create `USAGE.md`:
   - How to set up environment
   - How to launch coordinator
   - How to launch workers
   - **How to create effective instruction files**
   - Example workflows
   - Troubleshooting guide
2. Document limitations and known issues
3. Include examples from testing
4. Emphasize file-based coordination

**Files to create:**
- `USAGE.md`

---

### Step 11: Clean Up & Final Testing

**Goal:** Ensure system is production-ready

**Tasks:**
1. Remove test files from VPS
2. Clean task queue on VPS
3. Run full end-to-end test one more time
4. Update README.md with project summary
5. Commit all changes

**Success Criteria:**
- VPS is clean
- All documentation is complete
- System works end-to-end with file-based coordination
- Ready for production use

---

## Quick Start After Reading This

1. **First, read all knowledge files** in `knowledge/` directory (5 files)
2. **Understand context isolation** - Workers have ZERO conversation context
3. **Verify prerequisites** (VPS connection, API key, environment)
4. **Start with Phase 1, Step 1** (Test VPS Connection)
5. **Follow steps sequentially** - don't skip ahead
6. **Test thoroughly** after each step before moving on

---

## Notes

- **Take your time**: Each step should be tested before moving on
- **Understand context isolation**: Workers read everything from files, not conversation
- **Create complete instruction files**: Each task needs self-contained instructions
- **Document issues**: Note any problems encountered for troubleshooting
- **Test frequently**: Verify each function works before building on it
- **Keep it simple**: Start with basic implementations, optimize later

---

## Current Status

**Phase:** Not started
**Last Step Completed:** None
**Next Step:** Phase 1, Step 1 - Test VPS Connection

---

## Questions?

If anything is unclear or you encounter issues:
1. Review relevant knowledge file
2. Check VPS API specification
3. Verify environment setup
4. Test components individually
5. Remember: Workers have NO conversation context - everything via files
6. Ask for help if stuck

Good luck! 🚀
