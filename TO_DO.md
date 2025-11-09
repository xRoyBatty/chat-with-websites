# Multi-Agent VPS System - Implementation TODO

## Overview

This project implements a VPS-based multi-agent coordination system where multiple Claude agents can work together on the same codebase through a shared workspace on a VPS.

**Core Concept:** GitHub repo contains only instructions and tooling. Actual code lives entirely on VPS.

---

## Prerequisites Checklist

Before starting implementation, verify:

- [ ] **VPS API is running** at `51.75.162.195:5555`
- [ ] **VPS_API_KEY** is set in Claude Code environment named "vps-dev"
- [ ] **Environment "vps-dev"** has full network access enabled
- [ ] You have read all knowledge files in `knowledge/` directory

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

**Tasks:**
1. Add to `vps_deploy_helper.py`:

   **Coordinator functions:**
   - `add_task(description, assigned_to=None)`
   - `get_active_workers()`
   - `get_queue_status()`

   **Worker functions:**
   - `register_worker(worker_id, capabilities)`
   - `heartbeat(worker_id)`
   - `claim_task(worker_id)`
   - `complete_task(task_id, worker_id, result)`
   - `should_worker_continue(worker_id, max_idle_minutes)`

   **Communication functions:**
   - `write_message(agent_name, message)`
   - `read_messages(since_timestamp=None)`

2. Test task queue operations locally
3. Create test coordinator script
4. Create test worker script

**Success Criteria:**
- Can create tasks in queue on VPS
- Can claim tasks from queue
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

**Tasks:**
1. Create `templates/WORKER_CLAUDE.md`:
   - Worker initialization (register, set ID)
   - Main work loop (heartbeat, claim task, execute, complete)
   - Explain Stop hook behavior
   - Emphasize continuous polling
   - Include error handling guidance
2. Test with a single worker session
3. Verify worker stays alive while idle (within timeout)
4. Verify worker shuts down gracefully after timeout

**Success Criteria:**
- Worker can register successfully
- Worker polls for tasks continuously
- Worker executes claimed tasks
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

**Tasks:**
1. Create `templates/COORDINATOR_CLAUDE.md`:
   - Coordinator role and responsibilities
   - How to break user requests into tasks
   - How to add tasks to queue
   - How to monitor worker health
   - How to check queue status
   - How to report progress to user
2. Include examples of:
   - Creating simple task list
   - Assigning tasks to specific workers
   - Checking active workers
   - Monitoring queue progress

**Success Criteria:**
- Coordinator can break down complex requests
- Coordinator can add tasks to queue
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

**Goal:** Verify single worker can execute tasks end-to-end

**Test scenario:**
1. Coordinator creates 3 simple tasks
2. Single worker claims and executes all 3
3. Verify results on VPS
4. Worker shuts down after idle timeout

**Tasks:**
1. Start coordinator session
2. Create 3 test tasks (e.g., "create file1.txt", "create file2.txt", "list files")
3. Start worker session
4. Monitor worker execution
5. Verify files created on VPS
6. Verify worker graceful shutdown

**Success Criteria:**
- All 3 tasks executed successfully
- Files exist on VPS
- Worker shut down after idle timeout
- Queue shows all tasks completed

---

### Step 8: Multi-Worker Test

**Goal:** Verify multiple workers can collaborate

**Test scenario:**
1. Coordinator creates 10 tasks
2. 3 workers running simultaneously
3. All tasks distributed and completed
4. No race conditions or conflicts

**Tasks:**
1. Start coordinator session
2. Create 10 tasks with varied complexity
3. Start 3 worker sessions (worker-1, worker-2, worker-3)
4. Monitor task distribution
5. Verify all tasks completed
6. Check for any conflicts or errors

**Success Criteria:**
- All 10 tasks completed
- Work distributed across workers
- No duplicate task claims (race conditions)
- All workers shutdown gracefully when done

---

### Step 9: Real-World Test (Build a Simple App)

**Goal:** Use the system to build an actual application

**Test scenario:**
Coordinator receives: "Build a simple Flask API with 2 endpoints: /hello and /time"

**Tasks:**
1. Start coordinator with real-world request
2. Start 2-3 workers
3. Coordinator breaks down into tasks:
   - Create Flask app structure
   - Implement /hello endpoint
   - Implement /time endpoint
   - Write tests
   - Create requirements.txt
4. Workers execute tasks
5. Verify working API on VPS

**Success Criteria:**
- Flask API is deployed to VPS
- Both endpoints work
- Tests pass
- Code lives entirely on VPS (not in Git)

---

## Phase 4: Documentation & Handoff

### Step 10: Create Usage Guide

**Goal:** Document how to use the system

**Tasks:**
1. Create `USAGE.md`:
   - How to set up environment
   - How to launch coordinator
   - How to launch workers
   - Example workflows
   - Troubleshooting guide
2. Document limitations and known issues
3. Include examples from testing

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
- System works end-to-end
- Ready for production use

---

## Quick Start After Reading This

1. **First, read all knowledge files** in `knowledge/` directory (5 files)
2. **Verify prerequisites** (VPS connection, API key, environment)
3. **Start with Phase 1, Step 1** (Test VPS Connection)
4. **Follow steps sequentially** - don't skip ahead
5. **Test thoroughly** after each step before moving on

---

## Notes

- **Take your time**: Each step should be tested before moving on
- **Ask questions**: If anything is unclear, ask for clarification
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
5. Ask for help if stuck

Good luck! 🚀
