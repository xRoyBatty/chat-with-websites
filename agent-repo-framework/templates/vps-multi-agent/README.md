# VPS Multi-Agent Coordination Template

A framework for multiple Claude Code agents collaborating on the same codebase through shared VPS workspace.

## What This Does

Enables **true multi-agent collaboration** where multiple Claude instances work together on a shared codebase that lives on your VPS (not GitHub).

**Key Innovation:** GitHub repo contains only instructions and tooling—actual code lives entirely on VPS for privacy and real-time shared access.

## Perfect For

- Teams wanting multiple agents working simultaneously
- Privacy-conscious projects (code never leaves your VPS)
- Large codebases with independent modules
- Distributed task processing
- Background worker pools
- Projects requiring persistent agent state

## Architecture

```
┌─────────────────────────────────────────────┐
│         GitHub Repository (Instructions)    │
│                                             │
│  - COORDINATOR_CLAUDE.md (orchestrator)     │
│  - WORKER_CLAUDE.md (executor template)     │
│  - Task queue coordination tools            │
│  - VPS API client                           │
└─────────────────────────────────────────────┘
                    │
                    │ All agents access via VPS API
                    ↓
┌─────────────────────────────────────────────┐
│         VPS Shared Workspace                │
│                                             │
│  /path/to/project/                          │
│  ├── src/               ← Actual code       │
│  ├── tests/             ← Tests             │
│  ├── task-queue.json    ← Coordination     │
│  ├── worker-status.json ← Agent status     │
│  └── tasks/             ← Task instructions│
│      ├── task-1.md                          │
│      └── task-2.md                          │
└─────────────────────────────────────────────┘
                    ↑
        ┌───────────┼───────────┐
        │           │           │
   ┌────▼────┐ ┌────▼────┐ ┌────▼────┐
   │Worker 1 │ │Worker 2 │ │Worker 3 │
   │         │ │         │ │         │
   │Backend  │ │Frontend │ │Testing  │
   └─────────┘ └─────────┘ └─────────┘
```

## Core Concepts

### 1. Coordinator Agent
- Breaks user requests into independent tasks
- Creates complete instruction files for each task
- Adds tasks to VPS queue
- Monitors worker progress
- Reports results to user

### 2. Worker Agents
- Poll task queue on VPS
- Claim available tasks
- Read instruction files
- Execute on VPS codebase
- Update task status
- Continue until idle timeout

### 3. Context Isolation

**CRITICAL:** Workers have ZERO conversation context.

**They CANNOT:**
- Remember what coordinator "told" them
- Access conversation history
- Know what other workers did

**They CAN:**
- Read files from VPS
- Execute based on instruction files
- Write results back to VPS

**ALL coordination happens through files on VPS:**
- `task-queue.json` - Available tasks
- `tasks/task-{id}-instructions.md` - Complete instructions
- Context files referenced in tasks
- `worker-status.json` - Agent heartbeats

### 4. Stop Hooks for Persistence

Workers use stop hooks to survive session timeouts:

```
Worker checks queue → No tasks → Tries to stop
   ↓
Stop hook intercepts: "Any tasks available?"
   ↓
If tasks exist OR idle < 10 minutes:
   Block stop → Worker continues
Else:
   Approve stop → Worker shuts down
```

This creates polling behavior without actual continuous loops.

## Features

- ✅ **Multi-Agent Collaboration** - Multiple Claude agents work simultaneously
- ✅ **Privacy** - Code never leaves your VPS
- ✅ **Real-Time Coordination** - File-based task queue
- ✅ **Automatic Load Balancing** - Workers claim available tasks
- ✅ **Persistent Workers** - Stop hooks keep agents alive
- ✅ **Context Isolation** - Clean separation between agents
- ✅ **Instruction Files** - Self-contained task specifications
- ✅ **Scalable** - Add more workers as needed

## Setup Requirements

### VPS Requirements
- Linux VPS with SSH access
- VPS API server running (included in template)
- Sufficient resources for your codebase
- Stable network connection

### Environment Setup
- Claude Code environment configured with VPS_API_KEY
- Network access enabled
- GitHub authentication for repo

## Structure

```
vps-multi-agent-system/
├── .claude/
│   ├── COORDINATOR_CLAUDE.md    # Orchestrator instructions
│   ├── WORKER_CLAUDE.md         # Worker template
│   ├── skills/
│   │   └── vps-deploy/          # VPS interaction skill
│   ├── hooks/
│   │   └── worker-stop-check.py # Worker persistence
│   └── settings.json            # Hook registration
│
├── templates/
│   ├── task-instruction.md      # Task template
│   └── worker-status.json       # Status tracking
│
├── docs/
│   ├── setup-guide.md           # Complete setup instructions
│   ├── coordinator-guide.md     # How to coordinate work
│   └── worker-guide.md          # How to be a worker
│
└── README.md                    # This file
```

## Workflow Example

### User Request → Multi-Agent Execution

**Step 1: User Request**
```
User → Coordinator: "Build a REST API with authentication,
                      database, and tests"
```

**Step 2: Coordinator Breaks Down**

Coordinator creates 3 instruction files on VPS:

`tasks/task-1-auth.md`:
```markdown
# Task: Build Authentication Endpoint

## Objective
Create POST /api/auth/login endpoint

## Context Files to Read First
- docs/api-standards.md
- src/models/user.py

## Requirements
- Accept JSON: {username, password}
- Return JWT on success
- Return 401 on failure

## Steps
1. Read context files
2. Create route in src/api/auth.py
3. Implement password verification
4. Generate JWT token
5. Write tests in tests/test_auth.py

## Acceptance Criteria
- [ ] Endpoint responds to POST /api/auth/login
- [ ] Valid credentials return JWT
- [ ] Invalid credentials return 401
- [ ] Tests pass
```

Similar instruction files for database and other tests.

**Step 3: Workers Execute**

Three workers poll queue, each claims a task:
- Worker 1 → Authentication (backend specialist)
- Worker 2 → Database models (data specialist)
- Worker 3 → Tests (testing specialist)

All work simultaneously on VPS codebase.

**Step 4: Completion**

Workers update `task-queue.json`:
```json
{
  "task-1-auth": {"status": "completed", "worker": "worker-backend"},
  "task-2-database": {"status": "completed", "worker": "worker-data"},
  "task-3-tests": {"status": "completed", "worker": "worker-testing"}
}
```

Coordinator sees all complete, reports to user.

## Deployment

Run `./deploy_me.sh` and follow prompts.

You'll need:
- GitHub repository name
- VPS API endpoint and key
- Desired number of workers

## After Deployment

### 1. VPS Setup (30 min)
- Deploy VPS API server
- Configure authentication
- Create project directory structure

### 2. Coordinator Session (ongoing)
- Open coordinator agent
- Give it tasks to distribute
- Monitor progress

### 3. Worker Sessions (persistent)
- Open N worker agents
- They auto-poll and execute
- Survive via stop hooks

## Key Differences from Standard GitHub Workflow

| Aspect | GitHub Branches | VPS Multi-Agent |
|--------|----------------|-----------------|
| Code location | GitHub | VPS |
| Collaboration | Branch merges | Real-time shared files |
| Privacy | Code in GitHub | Code stays on VPS |
| Agents | 1 agent, sequential | N agents, parallel |
| Coordination | Manual | Automatic (task queue) |
| Context | Conversation | Instruction files |
| Persistence | N/A | Stop hooks |

## Use Cases

**Large Application Development:**
- Coordinator: "Build e-commerce site"
- Worker 1: Backend API
- Worker 2: Frontend UI
- Worker 3: Database schema
- Worker 4: Tests
→ All modules built in parallel

**Data Processing Pipeline:**
- Coordinator: "Process 1000 files"
- Workers: Each claims files from queue
→ Distributed processing

**Code Review & Testing:**
- Coordinator: "Review and test all PRs"
- Worker pool: Each handles one PR
→ Parallel review pipeline

**Research & Analysis:**
- Coordinator: "Analyze 50 papers"
- Workers: Each analyzes subset
→ Distributed research

## Advanced Features

### Dynamic Worker Pools
- Add workers during high load
- Workers auto-discover tasks
- Automatic load balancing

### Specialized Workers
- Backend specialist
- Frontend specialist
- Testing specialist
- Documentation specialist

### Priority Queue
- High-priority tasks taken first
- Dependencies handled automatically
- Deadline-aware scheduling

### Progress Monitoring
- Real-time status dashboard
- Worker health checks
- Task completion tracking

## Cost Considerations

**VPS Costs:**
- Small projects: $5-10/month
- Medium projects: $20-40/month
- Large projects: $50-100/month

**Claude API Costs:**
- Coordinator: Constant usage
- Workers: Billed per task execution
- Consider: Haiku for simple tasks, Sonnet for complex

**ROI:**
- Parallel execution = 3-10x faster
- Privacy = Priceless for sensitive code
- Team coordination = Massive time savings

## Tips for Success

1. **Write Complete Instruction Files**
   - Every task needs full context
   - List all context files to read
   - Clear acceptance criteria

2. **Design Independent Tasks**
   - Parallel work requires independence
   - Minimize task dependencies
   - Clear ownership boundaries

3. **Monitor Worker Health**
   - Check worker-status.json regularly
   - Restart stuck workers
   - Adjust idle timeouts as needed

4. **Start Small**
   - Begin with 2-3 workers
   - Scale up as you learn patterns
   - Test coordination thoroughly

5. **Document Conventions**
   - Code standards on VPS
   - Task format guidelines
   - Worker specialization areas

## Troubleshooting

**Workers stop immediately:**
- Check stop hook configuration
- Verify idle time calculation
- Ensure tasks exist in queue

**Tasks not claimed:**
- Check VPS API connectivity
- Verify task-queue.json format
- Ensure worker capabilities match tasks

**Conflicting changes:**
- Design better task independence
- Use file-level task granularity
- Implement locking if needed

## When NOT to Use This

- Simple single-file projects
- Sequential dependent tasks
- When privacy isn't a concern and GitHub works fine
- Small projects (< 10 files)
- When you don't have VPS access

Use standard GitHub workflow or simpler templates instead.

## Documentation

After deployment, see:
- `docs/setup-guide.md` - Complete VPS and environment setup
- `docs/coordinator-guide.md` - How to orchestrate work
- `docs/worker-guide.md` - How workers operate
- `docs/task-format.md` - Instruction file format
- `docs/troubleshooting.md` - Common issues

## References

- VPS Multi-Agent Architecture: See framework knowledge base
- Task Queue Coordination: See framework knowledge base
- Stop Hooks: See framework knowledge base
- Context Isolation: See framework knowledge base

---

*Deploy this template to enable true multi-agent collaboration!*
