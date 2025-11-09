# Work Distribution Guide for Multi-Agent Systems

Guide for distributing work across multiple Claude Code agents.

---

## When to Use Multiple Agents

**Good Use Cases:**
- Building complex applications with independent components
- Parallel research across multiple sources
- Multi-domain Life OS implementation
- Distributed testing (unit, integration, E2E in parallel)
- Content generation at scale

**Poor Use Cases:**
- Simple single-file changes
- Sequential dependent tasks
- Small projects (< 10 files)
- When context sharing is critical

---

## 🚨 CRITICAL: Context Isolation

**All agents have ZERO conversation context with each other.**

### What This Means:

❌ **Agents CANNOT:**
- Share conversation history
- Remember what coordinator "told" them
- Access context from previous tasks
- Know what other agents did

✅ **Agents CAN:**
- Read files from shared location (VPS, git repo)
- Write files for other agents to read
- Execute based on self-contained instruction files

### Implication:

**ALL coordination happens through files:**
- Task queue (JSON)
- Instruction files (Markdown with complete instructions)
- Context files (referenced in tasks)
- Status files (JSON for tracking)
- Communication logs (JSONL for async messages)

---

## Architecture Patterns

### Pattern 1: Coordinator + Workers (VPS-Based)

**Best for:** Large projects with independent tasks

**Structure:**
```
┌─────────────┐
│ Coordinator │ ← You interact with this agent
│             │   - Breaks down requests into tasks
│             │   - Creates instruction files
│             │   - Monitors progress
└─────┬───────┘
      │ Writes to VPS
      ↓
┌─────────────────────────────┐
│  VPS Shared Workspace       │
│  - task-queue.json          │
│  - tasks/*.md (instructions)│
│  - worker-status.json       │
│  - agent-comms.jsonl        │
└─────┬────────────────────────┘
      │ Multiple workers read from VPS
      ↓
┌────────────┬────────────┬────────────┐
│  Worker 1  │  Worker 2  │  Worker 3  │
│  Backend   │  Frontend  │  Testing   │
└────────────┴────────────┴────────────┘
```

**Coordinator Responsibilities:**
1. Break user request into independent tasks
2. Create instruction file for each task
3. Deploy instruction files to VPS
4. Add tasks to queue with instruction file references
5. Monitor worker status
6. Report progress to user

**Worker Responsibilities:**
1. Poll task queue (read task-queue.json)
2. Claim available task
3. Read instruction file from VPS
4. Read any context files specified in task
5. Execute based on file content
6. Write results to VPS
7. Update task status
8. Continue polling or shutdown

**Files Required:**

```json
// task-queue.json
[
  {
    "id": 1234,
    "description": "Create user model",
    "instruction_file": "tasks/task-1234-instructions.md",
    "context_files": ["docs/schema.md", "src/models/base.py"],
    "status": "pending",
    "assigned_to": "worker-backend"
  }
]

// worker-status.json
{
  "worker-backend": {
    "status": "active",
    "last_heartbeat": "2025-11-09T10:30:00",
    "last_task_claimed": "2025-11-09T10:25:00"
  }
}
```

```markdown
<!-- tasks/task-1234-instructions.md -->
# Task: Create User Model

## Objective
Create User model with authentication fields

## Context Files to Read First
- docs/schema.md - Database schema
- src/models/base.py - Base model class

## Requirements
- SQLAlchemy model in src/models/user.py
- Fields: id, username, email, password_hash
- Password hashing with bcrypt

## Steps
1. Read context files above
2. Import Base from base.py
3. Create User class
4. Add fields
5. Implement password hashing

## Acceptance Criteria
- [ ] File created: src/models/user.py
- [ ] Password hashing works
- [ ] Tests pass
```

---

### Pattern 2: Parallel Subagents (Repository-Based)

**Best for:** Parallel independent work in same repo

**Structure:**
```
┌──────────────┐
│ Main Agent   │ ← You interact with this
│              │   - Launches subagents in parallel
│              │   - Each subagent gets complete instructions
└──────┬───────┘
       │ Spawns subagents with file references
       ↓
┌──────────────┬──────────────┬──────────────┐
│  Subagent 1  │  Subagent 2  │  Subagent 3  │
│  Research A  │  Research B  │  Research C  │
└──────┬───────┴──────┬───────┴──────┬───────┘
       │              │              │
       ↓              ↓              ↓
   writes to      writes to      writes to
 research-a.md  research-b.md  research-c.md
```

**Main Agent Responsibilities:**
1. Break work into parallel tasks
2. Write context to files (if needed)
3. Launch subagents with:
   - Complete instructions
   - File references to read
   - Output file to write
4. Wait for all to complete
5. Synthesize results

**Subagent Responsibilities:**
1. Read instruction from prompt
2. Read context files specified
3. Execute task
4. Write result to specified file
5. Return completion

**Example:**

```python
# Main agent launches 3 research subagents
Task("""
Read research-context.md for project background.
Research topic: Machine Learning frameworks.
Write findings to research/ml-frameworks.md
Include: popularity, use cases, pros/cons
""")

Task("""
Read research-context.md for project background.
Research topic: Database options.
Write findings to research/databases.md
Include: scalability, ease of use, cost
""")

Task("""
Read research-context.md for project background.
Research topic: Cloud providers.
Write findings to research/cloud.md
Include: pricing, services, reliability
""")

# All run in parallel, write to separate files
# Main agent reads all files when done and synthesizes
```

---

### Pattern 3: Sequential Pipeline

**Best for:** Dependent tasks that must run in order

**Structure:**
```
Task 1: Design  →  Task 2: Implement  →  Task 3: Test  →  Task 4: Document
  (writes spec)      (reads spec,          (reads code,      (reads code,
                      writes code)          writes tests)      writes docs)
```

**Not truly "multi-agent"** - just one agent doing sequential work, but using file-based state to maintain context across tasks.

**Coordination Files:**

```markdown
<!-- 1-design-spec.md -->
# API Design Specification
[Complete spec written by Task 1]

<!-- 2-implementation.md -->
# Implementation Notes
Read: 1-design-spec.md
[Task 2 implements based on spec, writes code]

<!-- 3-test-results.md -->
# Test Results
Read: src/api.py (code from Task 2)
[Task 3 writes tests and results]

<!-- 4-documentation.md -->
# API Documentation
Read: 1-design-spec.md, src/api.py
[Task 4 writes user docs]
```

---

## Work Distribution Best Practices

### 1. Task Independence

**Good:**
```
Task A: Create user model (independent)
Task B: Create product model (independent)
Task C: Create order model (independent)
→ All can run in parallel
```

**Bad:**
```
Task A: Create user model
Task B: Create product model (depends on User)
Task C: Create order model (depends on User AND Product)
→ Must run sequentially, no benefit from multiple agents
```

### 2. Complete Instruction Files

**Every task needs:**
- Objective (what to accomplish)
- Context files to read (for background)
- Requirements (specific details)
- Steps (how to do it)
- Acceptance criteria (what success looks like)

**Example of GOOD instruction file:**
```markdown
# Task: Add Authentication Endpoint

## Objective
Create POST /api/auth/login endpoint

## Context Files
Read these FIRST:
- docs/api-standards.md (how we structure endpoints)
- src/models/user.py (User model with password verification)
- src/auth/jwt.py (JWT token generation)

## Requirements
- Accept JSON: {username, password}
- Validate against User model
- Return JWT on success
- Return 401 on failure

## Steps
1. Read all context files
2. Create route in src/api/auth.py
3. Parse JSON body
4. Query User by username
5. Verify password
6. Generate JWT token
7. Return response

## Acceptance Criteria
- [ ] Endpoint responds to POST /api/auth/login
- [ ] Valid credentials return JWT
- [ ] Invalid credentials return 401
- [ ] Follows standards from docs/api-standards.md
```

### 3. File-Based Status Tracking

**Use JSON files for tracking:**

```json
// progress.json
{
  "total_tasks": 10,
  "completed": 3,
  "in_progress": 2,
  "pending": 5,
  "tasks": {
    "task-1": {"status": "completed", "worker": "worker-1"},
    "task-2": {"status": "in_progress", "worker": "worker-2"},
    "task-3": {"status": "pending"}
  }
}
```

### 4. Communication via JSONL

**For async messages between agents:**

```jsonl
{"timestamp": "2025-11-09T10:00:00", "from": "coordinator", "to": "all", "message": "Starting project"}
{"timestamp": "2025-11-09T10:05:00", "from": "worker-1", "to": "coordinator", "message": "Task 1 complete"}
{"timestamp": "2025-11-09T10:06:00", "from": "worker-2", "to": "coordinator", "message": "Blocker on task 2"}
```

---

## Common Pitfalls

### ❌ Assuming Agents Share Context

**Wrong:**
```
Coordinator: "Build the auth endpoint we discussed"
Worker: "What auth endpoint? I have no context."
```

**Right:**
```
Coordinator: Creates instruction file with complete details
Worker: Reads instruction file, has everything needed
```

### ❌ Verbal Instructions Only

**Wrong:**
```
Coordinator tells worker: "Create user model like we talked about"
[Worker has no access to that conversation]
```

**Right:**
```
Coordinator:
1. Creates tasks/user-model-instructions.md with complete details
2. Adds task to queue referencing instruction file
3. Worker reads instruction file, has full context
```

### ❌ Forgetting to Reset Context

**Wrong:**
```
Task 1 instruction file references "the database schema we created"
[Worker has no idea what schema was created]
```

**Right:**
```
Task 1 instruction file:
- Context file: docs/database-schema.md
- Worker reads that file, gets schema details
```

---

## Success Checklist

For multi-agent work distribution:

- [ ] Tasks are independent (can run in parallel)
- [ ] Each task has complete instruction file
- [ ] Instruction files reference all needed context files
- [ ] No assumptions about conversation history
- [ ] Status tracked in files (JSON)
- [ ] Communication via files (JSONL for logs)
- [ ] Workers know where to read and write
- [ ] Coordinator monitors file-based status
- [ ] All agents can access shared files (VPS, git)
- [ ] Testing plan includes multi-agent scenarios

---

## Templates

### Coordinator CLAUDE.md Template

```markdown
# Coordinator Agent

Your role: Orchestrate multi-agent work via task queue.

## On User Request:

1. Break into independent tasks
2. For each task:
   - Create instruction file (tasks/task-{id}-instructions.md)
   - Include: objective, context files, requirements, steps, acceptance
   - Deploy to VPS
3. Add to task queue (task-queue.json) with instruction_file reference
4. Monitor worker-status.json
5. Report progress

## Critical Rules:

- NEVER assume workers have conversation context
- ALWAYS create complete instruction files
- ALWAYS list context files in tasks
- ALWAYS track via files, not conversation

See: knowledge/task-queues-full.md for details
```

### Worker CLAUDE.md Template

```markdown
# Worker Agent

Your role: Execute tasks from queue.

## On Each Cycle:

1. Read task-queue.json
2. Find pending task (matching your capabilities)
3. Claim task (update status to in_progress)
4. Read instruction file (path in task.instruction_file)
5. Read context files (listed in task.context_files)
6. Execute based on instruction file
7. Write results to VPS
8. Mark task complete (update status)
9. Update worker-status.json
10. Cycle complete

## Critical Rules:

- Execute ONLY from instruction files
- Read ALL context files specified
- NO assumptions about conversation history
- Update status files after each action

See: knowledge/stop-hooks-full.md for persistence details
```

---

## Further Reading

- `knowledge/task-queues-full.md` - Complete task queue system
- `knowledge/vps-multi-agent-full.md` - VPS architecture
- `knowledge/stop-hooks-full.md` - Worker persistence
- `knowledge/subagents-concepts.md` - Subagent patterns

---

*Remember: Files = Communication. Context Isolation = Reality. Instruction Files = Mandatory.*
