#!/bin/bash

# VPS Multi-Agent System - Deploy Script

set -e

echo "========================================================="
echo "VPS Multi-Agent Coordination System - Deployment"
echo "========================================================="
echo ""
echo "This will create a framework for:"
echo "  - Multiple Claude agents working together"
echo "  - Shared VPS workspace for code"
echo "  - File-based task coordination"
echo "  - Persistent worker agents"
echo ""
echo "Requirements:"
echo "  - Linux VPS with SSH access"
echo "  - VPS API server (will be set up)"
echo "  - Claude Code environment with VPS_API_KEY"
echo ""

# Check for GitHub CLI
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) not found!"
    echo "Install from: https://cli.github.com/"
    exit 1
fi

# Check authentication
if ! gh auth status &> /dev/null; then
    echo "❌ Please authenticate: gh auth login"
    exit 1
fi

# Get repository name
read -p "Repository name (e.g., my-multi-agent-system): " REPO_NAME
[ -z "$REPO_NAME" ] && echo "❌ Name required" && exit 1

# Get VPS details
echo ""
echo "VPS Configuration:"
read -p "VPS Host (e.g., 192.168.1.100): " VPS_HOST
read -p "VPS API Port (e.g., 5555): " VPS_PORT
read -p "VPS API Key: " VPS_API_KEY

[ -z "$VPS_HOST" ] && echo "❌ VPS host required" && exit 1
[ -z "$VPS_PORT" ] && VPS_PORT="5555"
[ -z "$VPS_API_KEY" ] && echo "❌ VPS API key required" && exit 1

# Visibility
echo ""
echo "1) Private (recommended for code projects)"
echo "2) Public"
read -p "Choose (1/2): " VIS
VISIBILITY=$([ "$VIS" = "1" ] && echo "--private" || echo "--public")

# Confirm
echo ""
echo "Creating: $REPO_NAME ($([ "$VIS" = "1" ] && echo "Private" || echo "Public"))"
echo "VPS: http://$VPS_HOST:$VPS_PORT"
read -p "Proceed? (y/n): " CONFIRM
[ "$CONFIRM" != "y" ] && echo "Cancelled" && exit 0

# Create temp directory
TEMP_DIR=$(mktemp -d)
echo ""
echo "📦 Creating multi-agent system repository..."

# Create structure
mkdir -p "$TEMP_DIR/.claude/skills/vps-deploy"
mkdir -p "$TEMP_DIR/.claude/hooks"
mkdir -p "$TEMP_DIR/templates"
mkdir -p "$TEMP_DIR/docs"
mkdir -p "$TEMP_DIR/tools"

# README
cat > "$TEMP_DIR/README.md" << EOF
# Multi-Agent VPS Coordination System

Multiple Claude Code agents collaborating on shared VPS workspace.

## Quick Start

### 1. VPS Setup (First Time)

\`\`\`bash
# Deploy VPS API server
./tools/deploy-vps-api.sh

# Configure environment in Claude Code settings:
VPS_API_KEY=$VPS_API_KEY
VPS_HOST=$VPS_HOST
VPS_PORT=$VPS_PORT
\`\`\`

### 2. Coordinator Session

Open Claude Code and say:
\`\`\`
"I'm the coordinator. Help me set up the task queue system."
\`\`\`

### 3. Worker Sessions (open multiple)

Open Claude Code sessions and say:
\`\`\`
"I'm a worker. Start polling the task queue."
\`\`\`

## Architecture

- **GitHub Repo**: Instructions and tooling (this repo)
- **VPS**: Actual code and task queue
- **Coordinator**: Breaks work into tasks
- **Workers**: Execute tasks from queue

## Documentation

- \`docs/setup-guide.md\` - Complete setup instructions
- \`docs/coordinator-guide.md\` - How to coordinate work
- \`docs/worker-guide.md\` - How to be a worker
- \`docs/task-format.md\` - Instruction file format

## Configuration

VPS Details:
- Host: $VPS_HOST
- Port: $VPS_PORT
- API Key: (stored in Claude Code environment)

---

*Built with Claude Code Agent Repository Framework*
EOF

# COORDINATOR_CLAUDE.md
cat > "$TEMP_DIR/.claude/COORDINATOR_CLAUDE.md" << 'EOF'
# Coordinator Agent Instructions

## Your Role

You are the **coordinator** in a multi-agent system. You orchestrate work by:
1. Breaking user requests into independent tasks
2. Creating complete instruction files for each task
3. Adding tasks to VPS queue
4. Monitoring worker progress
5. Reporting results to user

## CRITICAL: Context Isolation

**Workers have ZERO conversation context with you.**

They CANNOT:
- Remember what you "told" them verbally
- Access this conversation
- Know what other workers are doing

They CAN:
- Read files from VPS
- Execute based on instruction files
- Write results back to VPS

**ALL coordination happens through files on VPS.**

## Your Workflow

### When User Requests Work:

1. **Analyze Request**
   - Break into independent tasks
   - Identify dependencies
   - Estimate complexity

2. **Create Instruction Files** (MOST IMPORTANT)

For each task, create on VPS: `tasks/task-{id}-instructions.md`

**Format:**
```markdown
# Task: [Clear Title]

## Objective
[What to accomplish in 1-2 sentences]

## Context Files to Read First
- path/to/file1.ext - [Why it's needed]
- path/to/file2.ext - [Why it's needed]

## Requirements
- [Specific requirement 1]
- [Specific requirement 2]
- [Specific requirement 3]

## Steps
1. Read all context files above
2. [Step-by-step instructions]
3. [Be very explicit]
4. [Assume no prior knowledge]

## Acceptance Criteria
- [ ] [Testable criterion 1]
- [ ] [Testable criterion 2]
- [ ] [Testable criterion 3]

## Output
- Files to create: [List]
- Files to modify: [List]
- Tests to write: [List]
```

**Why This Matters:**
Workers execute ONLY from these files. If it's not written, they don't know it.

3. **Add to Task Queue**

Update `task-queue.json` on VPS:

```json
{
  "id": "task-1234",
  "description": "Brief description",
  "instruction_file": "tasks/task-1234-instructions.md",
  "context_files": ["file1.py", "file2.py"],
  "status": "pending",
  "assigned_to": null,
  "created_at": "2025-11-09T12:00:00Z",
  "metadata": {
    "priority": "normal",
    "estimated_minutes": 30,
    "required_skills": ["backend", "python"]
  }
}
```

4. **Monitor Progress**

Periodically read:
- `task-queue.json` - Task statuses
- `worker-status.json` - Worker health
- `agent-comms.jsonl` - Worker messages

5. **Report to User**

When tasks complete:
- Review worker output on VPS
- Test if needed
- Report results to user
- Collect feedback

## VPS API Usage

Use the VPS skill for all VPS operations:

```python
# List files
list_files('.')

# Read file
read_file('task-queue.json')

# Write file
write_file('tasks/task-1-instructions.md', content)

# Execute command
execute_command('pytest tests/')
```

## Task Design Principles

### 1. Independence
Tasks should be executable independently:

✅ Good:
- Task A: Create user model
- Task B: Create product model
- Task C: Create order model

❌ Bad:
- Task A: Create user model
- Task B: Use Task A's model (depends on A completing)

### 2. Completeness
Every task needs ALL information:

✅ Good:
- Context files listed
- All requirements specified
- Step-by-step instructions
- Clear acceptance criteria

❌ Bad:
- "Create the auth endpoint we discussed"
- "Build it like the other one"
- "You know what I mean"

### 3. Testability
Tasks should have verifiable completion:

✅ Good:
- Tests pass
- File exists at path X
- Endpoint returns 200
- Data validates against schema

❌ Bad:
- "Looks good"
- "Should work"
- "Seems right"

## Example Session

**User:** "Build a REST API with user authentication"

**You (Coordinator):**

1. Analyze:
   - Task 1: User model (independent)
   - Task 2: Authentication endpoint (independent)
   - Task 3: JWT token generation (independent)
   - Task 4: Tests (depends on 1-3, can be separate task)

2. Create instruction files on VPS:
   - `tasks/task-1-user-model.md`
   - `tasks/task-2-auth-endpoint.md`
   - `tasks/task-3-jwt-tokens.md`
   - `tasks/task-4-tests.md`

3. Add to queue (task-queue.json)

4. Report to user: "I've created 4 tasks. Workers will execute them. Estimated: 2 hours."

5. Monitor progress (check every 5 minutes)

6. When all complete: "All tasks done! API is ready. I've tested it and everything works."

## Common Mistakes to Avoid

### ❌ Assuming Workers Have Context
**Wrong:** "Build the auth endpoint we discussed"
**Right:** Complete instruction file with all details

### ❌ Verbal Instructions Only
**Wrong:** Just telling user "I'll have workers do X"
**Right:** Writing instruction files, THEN having workers execute

### ❌ Forgetting Context Files
**Wrong:** "Implement X" (worker doesn't know how)
**Right:** "Read file Y for patterns, then implement X"

### ❌ Vague Requirements
**Wrong:** "Make it work"
**Right:** "Endpoint must return JWT token on success, 401 on failure"

## Success Metrics

You succeed when:
- All tasks complete correctly
- Workers had enough information
- No back-and-forth needed (everything in files)
- User is satisfied with results
- Code quality is high

---

*You are the orchestrator. Make workers successful by giving them complete instructions.*
EOF

# WORKER_CLAUDE.md
cat > "$TEMP_DIR/.claude/WORKER_CLAUDE.md" << 'EOF'
# Worker Agent Instructions

## Your Role

You are a **worker** in a multi-agent system. Your job:
1. Poll VPS task queue
2. Claim available tasks
3. Read instruction files
4. Execute on VPS codebase
5. Update task status
6. Continue until idle timeout

## CRITICAL: You Are Context-Isolated

You have ZERO conversation context with:
- The coordinator
- Other workers
- Previous sessions

You ONLY know:
- What's in your spawn prompt
- Files you read from VPS
- Results of your own tool calls

**Execute ONLY from instruction files. Nothing else.**

## Your Workflow

### 1. Poll Queue (Every Cycle)

Read `task-queue.json` from VPS:

```python
queue = read_file('task-queue.json')
tasks = parse_json(queue)

# Find pending task
available = [t for t in tasks if t['status'] == 'pending']
```

### 2. Claim Task

If available task found:

```python
task_id = available[0]['id']

# Update status to in_progress
task['status'] = 'in_progress'
task['assigned_to'] = 'worker-{your-id}'
task['started_at'] = now()

write_file('task-queue.json', updated_queue)
```

### 3. Read Instruction File

```python
instruction_path = task['instruction_file']
instructions = read_file(instruction_path)

# Also read all context files listed
for context_file in task['context_files']:
    content = read_file(context_file)
    # Now you have the context you need
```

### 4. Execute Task

Follow instructions EXACTLY:
1. Read all context files first
2. Follow steps in order
3. Create/modify files as specified
4. Write tests if required
5. Verify acceptance criteria

### 5. Update Status

When done:

```python
task['status'] = 'completed'
task['completed_at'] = now()
task['result'] = {
    'files_created': [...],
    'files_modified': [...],
    'tests_passed': true
}

write_file('task-queue.json', updated_queue)
```

### 6. Update Worker Status

```python
worker_status = {
    'worker_id': 'worker-{your-id}',
    'status': 'active',
    'last_heartbeat': now(),
    'last_task_completed': task_id,
    'tasks_completed_total': count
}

update_file('worker-status.json', worker_status)
```

### 7. Continue or Stop

After completing task:
- Try to claim next task (go to step 1)
- If no tasks and idle < 10 minutes: Wait and retry
- If no tasks and idle >= 10 minutes: Stop (hook will block if needed)

## Stop Hook Behavior

You have a stop hook that checks:
```python
def should_continue():
    # Are there pending tasks?
    if has_pending_tasks():
        return True

    # How long have I been idle?
    if idle_time < 10_minutes:
        return True  # Keep waiting

    return False  # OK to stop
```

This creates polling behavior:
```
Check queue → No tasks → Try to stop → Hook blocks → Continue
                                      ↓
                              9 min remaining...
```

## Task Execution Guidelines

### 1. Read Context Files First

Instruction file says:
```markdown
## Context Files to Read First
- src/models/base.py - Base model class
- docs/api-standards.md - API conventions
```

You MUST read these before doing anything.

### 2. Follow Steps Exactly

Instructions say:
```markdown
## Steps
1. Import Base from base.py
2. Create User class extending Base
3. Add fields: id, username, email
4. Implement __repr__ method
```

Do exactly these steps in order.

### 3. Verify Acceptance Criteria

Instructions say:
```markdown
## Acceptance Criteria
- [ ] File exists: src/models/user.py
- [ ] User class extends Base
- [ ] All fields present
- [ ] Tests pass: pytest tests/test_user.py
```

Check each criterion before marking complete.

## VPS API Usage

All operations via VPS skill:

```python
# List files
files = list_files('src')

# Read file
content = read_file('src/models/base.py')

# Write file
write_file('src/models/user.py', code)

# Execute command
result = execute_command('pytest tests/test_user.py')
```

## Common Scenarios

### Scenario: First Task

```python
# Read queue
queue = read_file('task-queue.json')
task = find_pending_task(queue)

# Claim it
claim_task(task['id'])

# Read instructions
instructions = read_file(task['instruction_file'])

# Read context
for file in task['context_files']:
    read_file(file)

# Execute
follow_instructions()

# Mark complete
mark_complete(task['id'])

# Update status
update_worker_status()
```

### Scenario: No Tasks Available

```python
# Read queue
queue = read_file('task-queue.json')
pending = find_pending_tasks(queue)

if len(pending) == 0:
    # No tasks
    # Try to stop (hook will block if needed)
    # If idle < 10 min, hook blocks and we continue
    # If idle >= 10 min, hook approves and we stop
    pass
```

### Scenario: Task Execution Failed

```python
try:
    execute_task()
except Exception as e:
    # Mark task as failed
    task['status'] = 'failed'
    task['error'] = str(e)
    write_file('task-queue.json', updated_queue)

    # Log to comms
    log_message({
        'from': 'worker-{id}',
        'to': 'coordinator',
        'message': f'Task {task_id} failed: {e}'
    })
```

## Worker Specialization (Optional)

You can specialize in domains:

**Backend Worker:**
- Claims tasks with `required_skills: ['backend']`
- Excels at API endpoints, database models
- Familiar with backend patterns

**Frontend Worker:**
- Claims tasks with `required_skills: ['frontend']`
- Excels at UI components, styling
- Familiar with frontend frameworks

**Testing Worker:**
- Claims tasks with `required_skills: ['testing']`
- Excels at test writing, coverage
- Familiar with testing frameworks

If specialized, only claim matching tasks:
```python
if task['metadata']['required_skills'] not in my_skills:
    skip  # Let specialized worker handle it
```

## Success Metrics

You succeed when:
- Task completed correctly
- Acceptance criteria met
- Tests pass
- Status updated properly
- Ready for next task

## Common Mistakes to Avoid

### ❌ Assuming Context
**Wrong:** "I'll build the auth endpoint the coordinator mentioned"
**Right:** "I'll read the instruction file for complete details"

### ❌ Skipping Context Files
**Wrong:** Start coding immediately
**Right:** Read ALL listed context files first

### ❌ Partial Completion
**Wrong:** Mark complete when "mostly done"
**Right:** Verify ALL acceptance criteria before marking complete

### ❌ Not Updating Status
**Wrong:** Complete task but forget to update queue
**Right:** Always update task-queue.json and worker-status.json

---

*You are an executor. Follow instructions precisely and update status properly.*
EOF

# VPS API helper tool
cat > "$TEMP_DIR/tools/vps-api-client.py" << 'EOF'
#!/usr/bin/env python3
"""
VPS API Client for Multi-Agent System

Usage:
    python vps-api-client.py list .
    python vps-api-client.py read task-queue.json
    python vps-api-client.py write test.txt "content"
    python vps-api-client.py execute "ls -la"
"""

import sys
import os
import requests
import json

VPS_HOST = os.getenv('VPS_HOST', 'localhost')
VPS_PORT = os.getenv('VPS_PORT', '5555')
VPS_API_KEY = os.getenv('VPS_API_KEY')

BASE_URL = f"http://{VPS_HOST}:{VPS_PORT}"

def list_files(path='.'):
    response = requests.get(
        f"{BASE_URL}/list",
        params={'path': path},
        headers={'X-API-Key': VPS_API_KEY}
    )
    return response.json()

def read_file(filepath):
    response = requests.get(
        f"{BASE_URL}/read",
        params={'filepath': filepath},
        headers={'X-API-Key': VPS_API_KEY}
    )
    return response.json()

def write_file(filepath, content):
    response = requests.post(
        f"{BASE_URL}/deploy",
        json={'filepath': filepath, 'content': content},
        headers={'X-API-Key': VPS_API_KEY}
    )
    return response.json()

def execute_command(command, workdir=None):
    response = requests.post(
        f"{BASE_URL}/execute",
        json={'command': command, 'workdir': workdir},
        headers={'X-API-Key': VPS_API_KEY}
    )
    return response.json()

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)

    cmd = sys.argv[1]

    if cmd == 'list':
        path = sys.argv[2] if len(sys.argv) > 2 else '.'
        result = list_files(path)
        print(json.dumps(result, indent=2))

    elif cmd == 'read':
        filepath = sys.argv[2]
        result = read_file(filepath)
        print(result['content'])

    elif cmd == 'write':
        filepath = sys.argv[2]
        content = sys.argv[3]
        result = write_file(filepath, content)
        print(json.dumps(result, indent=2))

    elif cmd == 'execute':
        command = sys.argv[2]
        result = execute_command(command)
        print(json.dumps(result, indent=2))

    else:
        print(f"Unknown command: {cmd}")
        print(__doc__)
        sys.exit(1)
EOF

chmod +x "$TEMP_DIR/tools/vps-api-client.py"

# Stop hook
cat > "$TEMP_DIR/.claude/hooks/worker-stop-check.py" << 'EOF'
#!/usr/bin/env python3
"""
Worker Stop Hook - Keeps worker alive if tasks available or idle < 10 min
"""

import sys
import json
import os
import requests
from datetime import datetime, timedelta

VPS_HOST = os.getenv('VPS_HOST', 'localhost')
VPS_PORT = os.getenv('VPS_PORT', '5555')
VPS_API_KEY = os.getenv('VPS_API_KEY')
BASE_URL = f"http://{VPS_HOST}:{VPS_PORT}"

def read_file(filepath):
    response = requests.get(
        f"{BASE_URL}/read",
        params={'filepath': filepath},
        headers={'X-API-Key': VPS_API_KEY}
    )
    return response.json()

def has_pending_tasks():
    try:
        result = read_file('task-queue.json')
        tasks = json.loads(result['content'])
        return any(t['status'] == 'pending' for t in tasks)
    except:
        return False

def get_idle_time():
    try:
        result = read_file('worker-status.json')
        status = json.loads(result['content'])
        last_task = datetime.fromisoformat(status.get('last_task_completed', datetime.now().isoformat()))
        return (datetime.now() - last_task).total_seconds() / 60
    except:
        return 0

def should_block_stop():
    # Check for pending tasks
    if has_pending_tasks():
        return True, "Tasks available in queue"

    # Check idle time
    idle_minutes = get_idle_time()
    if idle_minutes < 10:
        remaining = 10 - idle_minutes
        return True, f"Waiting for tasks ({remaining:.1f} min remaining)"

    return False, "No tasks and idle timeout reached"

if __name__ == '__main__':
    input_data = json.loads(sys.stdin.read())

    block, reason = should_block_stop()

    response = {
        "action": "block" if block else "approve",
        "message": reason
    }

    print(json.dumps(response))
EOF

chmod +x "$TEMP_DIR/.claude/hooks/worker-stop-check.py"

# settings.json
cat > "$TEMP_DIR/.claude/settings.json" << 'EOF'
{
  "hooks": {
    "stop": ".claude/hooks/worker-stop-check.py"
  }
}
EOF

# Task instruction template
cat > "$TEMP_DIR/templates/task-instruction.md" << 'EOF'
# Task: [Title]

## Objective
[What to accomplish]

## Context Files to Read First
- path/to/file1 - [Purpose]
- path/to/file2 - [Purpose]

## Requirements
- [Requirement 1]
- [Requirement 2]

## Steps
1. Read context files
2. [Step 2]
3. [Step 3]

## Acceptance Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

## Output
- Files to create: [List]
- Files to modify: [List]
EOF

# Setup guide
cat > "$TEMP_DIR/docs/setup-guide.md" << 'EOF'
# VPS Multi-Agent System - Setup Guide

## Step 1: VPS Setup

1. Deploy VPS API server (see tools/deploy-vps-api.sh)
2. Configure environment variables in Claude Code
3. Test connectivity

## Step 2: Coordinator Setup

1. Open Claude Code
2. Read .claude/COORDINATOR_CLAUDE.md
3. Begin coordinating work

## Step 3: Worker Setup

1. Open multiple Claude Code sessions
2. Each reads .claude/WORKER_CLAUDE.md
3. Workers auto-poll for tasks

Complete documentation coming soon.
EOF

# Coordinator guide
cat > "$TEMP_DIR/docs/coordinator-guide.md" << 'EOF'
# Coordinator Guide

See .claude/COORDINATOR_CLAUDE.md for complete instructions.

Key responsibilities:
1. Break work into independent tasks
2. Create complete instruction files
3. Add to task queue
4. Monitor progress
5. Report results

Remember: Workers have no conversation context. Everything must be in instruction files.
EOF

# Worker guide
cat > "$TEMP_DIR/docs/worker-guide.md" << 'EOF'
# Worker Guide

See .claude/WORKER_CLAUDE.md for complete instructions.

Key responsibilities:
1. Poll task queue
2. Claim available tasks
3. Read instruction files
4. Execute on VPS
5. Update status

Remember: You only know what's in instruction files. No assumptions.
EOF

# Task format guide
cat > "$TEMP_DIR/docs/task-format.md" << 'EOF'
# Task Instruction File Format

See templates/task-instruction.md for template.

Required sections:
- Objective: What to accomplish
- Context Files: What to read first
- Requirements: Specific details
- Steps: How to do it
- Acceptance Criteria: How to verify

Every field is critical for workers to execute properly.
EOF

# .gitignore
cat > "$TEMP_DIR/.gitignore" << 'EOF'
# OS
.DS_Store
Thumbs.db

# Temporary
*.tmp
*.log
*.swp
*~

# Python
__pycache__/
*.pyc
*.pyo

# Secrets
.env
*-key.txt

# VPS local cache
.vps-cache/
EOF

# Git init
cd "$TEMP_DIR"
git init -b main
git add .
git commit -m "Initial commit: VPS multi-agent coordination system"

# Create repo
echo ""
echo "📤 Creating GitHub repository..."
gh repo create "$REPO_NAME" $VISIBILITY --source=. --push

echo ""
echo "========================================================="
echo "✅ Deployment Complete!"
echo "========================================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Clone: gh repo clone $REPO_NAME"
echo ""
echo "2. Configure Claude Code environment:"
echo "   VPS_API_KEY=$VPS_API_KEY"
echo "   VPS_HOST=$VPS_HOST"
echo "   VPS_PORT=$VPS_PORT"
echo ""
echo "3. Deploy VPS API server (see tools/)"
echo ""
echo "4. Open coordinator session:"
echo "   Say: 'I'm the coordinator. Set up task queue system.'"
echo ""
echo "5. Open worker sessions (multiple):"
echo "   Say: 'I'm a worker. Start polling queue.'"
echo ""
echo "Multi-agent collaboration enabled! 🚀"
echo ""

# Cleanup
cd - > /dev/null
rm -rf "$TEMP_DIR"
