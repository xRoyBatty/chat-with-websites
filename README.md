# Multi-Agent VPS Coordination System

A research implementation of a distributed multi-agent system where multiple Claude Code agents collaborate in real-time through a shared VPS workspace.

## 🎯 What Is This?

This is not a traditional software project - it's a **meta-system** that enables multiple Claude agents to work together on the same codebase simultaneously, with true real-time collaboration through **file-based coordination**.

**Key Innovation:** Instead of each agent working in isolated GitHub branches, all agents share a workspace on a VPS, enabling:
- Real-time file sharing
- Task queue coordination via JSON files
- Distributed work assignment through file-based task system
- Persistent worker agents via stop hooks

**⚠️ CRITICAL:** Agents have ZERO conversation context with each other. All coordination happens through files on VPS.

## 🏗️ Architecture Overview

```
┌─────────────────┐
│  GitHub Repo    │  ← Contains ONLY instructions and tooling
│  (This repo)    │     NOT the actual project code
└─────────┬───────┘
          │
          ↓
┌─────────────────────────────┐
│  Multiple Claude Sessions   │
│  - 1 Coordinator Agent      │  ← NO direct communication
│  - N Worker Agents          │  ← Each isolated, zero context
└────────┬────────────────────┘
         │
         ↓ ALL communication via files ↓
┌─────────────────────────────┐
│  VPS Shared Workspace       │
│  - Actual code lives here   │
│  - task-queue.json          │  ← Task coordination
│  - worker-status.json       │  ← Worker tracking
│  - tasks/*.md               │  ← Instruction files
│  - agent-comms.jsonl        │  ← Communication log
└─────────────────────────────┘
```

## 🚀 Quick Start

### For the Next Session

1. **Read `CLAUDE.md`** - Start here for complete instructions
2. **Read all knowledge files** in `knowledge/` directory (required!)
3. **Follow `TO_DO.md`** - Step-by-step implementation guide
4. **Verify environment** has `VPS_API_KEY` configured
5. **Understand context isolation** - Agents communicate ONLY via files

### Prerequisites

- Claude Code on the web (Pro or Max subscription)
- Access to VPS at `51.75.162.195:5555`
- Environment named "vps-dev" with:
  - `VPS_API_KEY` configured
  - Full network access enabled

## 📚 Documentation Structure

| File | Purpose |
|------|---------|
| `CLAUDE.md` | **START HERE** - Main instructions for agents |
| `TO_DO.md` | Step-by-step implementation checklist |
| `knowledge/01-environment-benefits.md` | Understanding Claude Code environments |
| `knowledge/02-vps-multi-agent-architecture.md` | The multi-agent system architecture |
| `knowledge/03-stop-hooks-worker-persistence.md` | How to keep workers alive (discrete cycles) |
| `knowledge/04-vps-api-specification.md` | VPS API documentation |
| `knowledge/05-task-queue-coordination.md` | Task queue system design (file-based) |

## 🎭 Key Concepts

### GitHub as "Thin Client"

The GitHub repo contains:
- ✅ Instructions (CLAUDE.md)
- ✅ Skills (.claude/skills/)
- ✅ Hooks (.claude/hooks/)
- ✅ Templates
- ❌ NO actual project code

### VPS as Shared Workspace

The VPS hosts:
- ✅ Actual project code
- ✅ Task queue (task-queue.json)
- ✅ Task instruction files (tasks/*.md)
- ✅ Worker status tracking (worker-status.json)
- ✅ Inter-agent communication (agent-comms.jsonl)

### Multi-Agent Coordination (File-Based)

- **Coordinator Agent**: Creates tasks by writing files
  - Writes task instruction files to VPS
  - Adds tasks to task-queue.json
  - Monitors worker-status.json
  - Reads agent-comms.jsonl for updates

- **Worker Agents**: Execute tasks by reading files
  - Read task-queue.json to find work
  - Read task instruction files (tasks/*.md)
  - Read context files specified in tasks
  - Write results to VPS
  - Update task-queue.json and worker-status.json
  - Use Stop hooks to stay alive (discrete cycles)

**⚠️ NO direct agent-to-agent communication** - Everything via shared VPS files

## 🔧 How It Works

### 1. User Creates Request

```
You (in Coordinator session):
"Build a REST API with authentication"
```

### 2. Coordinator Creates Task Files

Coordinator writes to VPS:

**File: tasks/task-1234-instructions.md**
```markdown
# Task: Create User Model

## Objective
Create User model with authentication fields

## Requirements
- SQLAlchemy model in src/models/user.py
- Fields: id, username, email, password_hash
- Password hashing with bcrypt

## Context Files
Read these first:
- docs/database-schema.md
- src/models/base.py

## Steps
1. Import Base from base.py
2. Create User class
3. Add fields
4. Implement password hashing

## Acceptance Criteria
- [ ] File created: src/models/user.py
- [ ] Password hashing works
- [ ] Tests pass
```

**File: task-queue.json** (append):
```json
{
  "id": 1234,
  "description": "Create User model",
  "instruction_file": "tasks/task-1234-instructions.md",
  "context_files": ["docs/database-schema.md", "src/models/base.py"],
  "status": "pending"
}
```

### 3. Worker Discovers and Executes Task

**Worker Cycle 1:**
```
Worker reads: task-queue.json
Worker finds: Task #1234 (pending)
Worker updates: task-queue.json (status: in_progress, claimed_by: worker-1)
Worker reads: tasks/task-1234-instructions.md
Worker reads: docs/database-schema.md
Worker reads: src/models/base.py
Worker executes: Creates src/models/user.py based on instructions
Worker writes: src/models/user.py to VPS
Worker updates: task-queue.json (status: completed)
Worker updates: worker-status.json (last_task_completed: now)
Worker tries to stop → Stop hook blocks → Worker continues
```

**Worker Cycle 2:**
```
Worker reads: task-queue.json
Worker finds: No pending tasks
Worker tries to stop → Stop hook checks idle time
  - If idle < 10 min: Block (keep polling)
  - If idle >= 10 min: Approve (shutdown)
```

### 4. Coordinator Monitors Progress

```
Coordinator reads: task-queue.json
Coordinator sees: Task #1234 completed
Coordinator reads: agent-comms.jsonl
Coordinator reports to you: "User model complete!"
```

**Key Insight:** At NO point do agents talk directly. All coordination is reading/writing shared files.

## ✨ Benefits

### vs. GitHub Branches (Standard Approach)

| Feature | GitHub Branches | VPS Workspace |
|---------|----------------|---------------|
| Real-time collaboration | ❌ No | ✅ Yes (via shared files) |
| State sharing | ❌ Isolated | ✅ Shared JSON files |
| Agent communication | ❌ None | ✅ File-based (queue, status, logs) |
| Merge overhead | ❌ High | ✅ None |
| Privacy | ⚠️ Code on GitHub | ✅ Code on VPS |
| Session persistence | ⚠️ Lost | ✅ Persists in files |
| Context between agents | ❌ None | ✅ Via instruction files |

### Key Advantages

1. **Privacy**: Code never touches GitHub
2. **File-Based Coordination**: Agents coordinate through JSON/MD files
3. **Persistence**: Work survives session interruptions (stored on VPS)
4. **Scalability**: Add more workers as needed
5. **Real Environment**: Work on actual deployment server
6. **Zero Context Requirement**: Workers need no conversation history - everything in files

## 📦 Implementation Status

**Current Status:** Documentation Phase Complete

**Next Steps:**
1. Test VPS connection
2. Build VPS deployment skill
3. Implement task queue system (file-based)
4. Create Stop hooks (discrete cycle model)
5. Test with multiple agents (file coordination)

See `TO_DO.md` for detailed implementation checklist.

## 🎯 Use Cases

Perfect for:
- ✅ Large refactoring projects
- ✅ Building complex applications
- ✅ Parallel feature development
- ✅ Privacy-sensitive codebases
- ✅ Direct-to-production workflows
- ✅ Distributed team simulation

Not ideal for:
- ❌ Simple single-file changes
- ❌ Code review workflows
- ❌ Open source collaboration
- ❌ Projects requiring GitHub history

## 🔒 Security Considerations

- **API Key**: Stored in environment variable, never committed
- **VPS Access**: Restricted by API authentication
- **Network**: Configurable (full, limited, or no internet)
- **Isolation**: Each project in separate VPS directory
- **Audit**: All agent actions logged in agent-comms.jsonl

## 🐛 Known Limitations

- **Context Isolation**: Agents have ZERO conversation context - all coordination via files
- **Rate Limits**: Multiple agents = multiplied token usage
- **Cost**: Running 4+ agents simultaneously is expensive
- **Network Latency**: Every operation is an API call
- **Worker Management**: Workers timeout after idle period (discrete cycles, not continuous)
- **File Coordination Overhead**: Creating instruction files for every task
- **GitHub Integration**: Minimal (by design)

## 🔄 File-Based Coordination Details

### Task Queue (task-queue.json)

```json
[
  {
    "id": 1234,
    "description": "Create user model",
    "instruction_file": "tasks/task-1234-instructions.md",
    "context_files": ["docs/schema.md", "src/models/base.py"],
    "status": "completed",
    "claimed_by": "worker-backend",
    "claimed_at": "2025-11-09T10:15:00",
    "completed_at": "2025-11-09T10:20:00"
  }
]
```

### Worker Status (worker-status.json)

```json
{
  "worker-backend": {
    "status": "active",
    "capabilities": ["backend", "database"],
    "registered_at": "2025-11-09T10:00:00",
    "last_heartbeat": "2025-11-09T10:20:30",
    "last_task_claimed": "2025-11-09T10:15:00",
    "last_task_completed": "2025-11-09T10:20:00"
  }
}
```

### Communication Log (agent-comms.jsonl)

```jsonl
{"timestamp": "2025-11-09T10:00:00", "agent": "coordinator", "message": "Created 5 tasks"}
{"timestamp": "2025-11-09T10:15:00", "agent": "worker-backend", "message": "Claimed task #1234"}
{"timestamp": "2025-11-09T10:20:00", "agent": "worker-backend", "message": "Completed task #1234"}
```

### Task Instruction File (tasks/task-{id}-instructions.md)

Complete, self-contained instructions for workers with zero context:
- Objective
- Requirements
- Context files to read
- Step-by-step instructions
- Acceptance criteria

## 🤝 Contributing

This is a research implementation exploring multi-agent coordination patterns. If you're implementing this:

1. Read ALL documentation first
2. **Understand context isolation** - Agents communicate ONLY via files
3. Follow `TO_DO.md` steps sequentially
4. Test thoroughly at each step
5. Document any issues or improvements

## 📝 License

This is experimental research code. Use at your own risk.

## 🙏 Acknowledgments

Built on:
- Claude Code on the web (Anthropic)
- Flask VPS API
- Multi-agent coordination patterns
- File-based state sharing

---

**Ready to build?** Open `CLAUDE.md` and start reading! 📖

**Remember:** Agents have ZERO conversation context. All coordination is file-based.
