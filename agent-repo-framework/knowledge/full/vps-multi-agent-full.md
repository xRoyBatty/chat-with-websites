# VPS-Based Multi-Agent Architecture

## The Core Concept

Instead of having a GitHub repo that contains actual code, use GitHub as a **"thin client"** that only contains:
- Instructions (CLAUDE.md)
- Skills (VPS deployment skill)
- Configuration (.claude/settings.json)

The **actual code lives entirely on the VPS**, and Claude agents interact with it via a Flask API.

## Why This Enables True Multi-Agent Collaboration

### GitHub Branch Limitation (Standard Approach)

```
Session 1 → claude/feature-1-xxxxx (isolated branch)
Session 2 → claude/feature-2-yyyyy (isolated branch)
❌ Can't see each other's work in real-time
❌ Can't share state during execution
❌ Have to merge branches manually later
```

### VPS Shared Workspace (Our Approach)

```
Session 1 (Agent 1) → VPS at /var/www/.../myproject/
Session 2 (Agent 2) → VPS at /var/www/.../myproject/ (SAME location!)
Session 3 (Agent 3) → VPS at /var/www/.../myproject/ (SAME location!)
✅ All agents see the same files
✅ Changes are immediately visible to all
✅ Can coordinate through shared state files
✅ True real-time collaboration
```

## Architecture Diagram

```
┌─────────────────┐
│  GitHub Repo    │  ← Only contains instructions, no actual code
│  (Thin Client)  │
│                 │
│  - CLAUDE.md    │  ← Instructions for agents
│  - .claude/     │  ← Skills, hooks, settings
│    └─skills/    │
│      └─vps-deploy/  ← VPS API skill
└─────────────────┘
         ↓
    (You launch tasks from GitHub repo)
         ↓
┌─────────────────────────────────────┐
│  Claude Code Web Sessions           │
│                                     │
│  ┌─────────────┐                   │
│  │ Coordinator │ ← You talk to     │
│  │   Agent     │   this one only   │
│  └──────┬──────┘                   │
│         │                           │
│  ┌──────▼──────┐  ┌──────────┐    │
│  │  Worker 1   │  │ Worker 2 │    │
│  │  (Backend)  │  │(Frontend)│    │
│  └──────┬──────┘  └─────┬────┘    │
│         │                │          │
│  ┌──────▼──────┐  ┌─────▼────┐    │
│  │  Worker 3   │  │ Worker 4 │    │
│  │  (Testing)  │  │ (DevOps) │    │
│  └──────┬──────┘  └─────┬────┘    │
└─────────┼────────────────┼─────────┘
          │                │
          │  All agents use VPS skill
          │  to access shared workspace
          ↓
┌─────────────────────────────────────┐
│  VPS: 51.75.162.195:5555           │
│  Flask API                          │
│                                     │
│  Shared Workspace:                 │
│  /var/www/.../httpdocs/myproject/  │
│                                     │
│  - src/                ← Actual code │
│  - tests/                           │
│  - task-queue.json    ← Coordination │
│  - worker-status.json               │
│  - agent-comms.jsonl                │
│  - progress.json                    │
└─────────────────────────────────────┘
```

## Key Advantages

### 1. Privacy
- ✅ Actual code never touches GitHub
- ✅ Sensitive data stays on VPS
- ✅ Only instructions are in version control

### 2. Unlimited Storage
- ✅ Use VPS storage (not GitHub limits)
- ✅ Large datasets can live on VPS
- ✅ No concerns about repo size

### 3. True Multi-Agent Collaboration
- ✅ Multiple agents see same filesystem
- ✅ Real-time state sharing via files
- ✅ Task queue coordination
- ✅ Worker status monitoring
- ✅ No branch merging needed

### 4. Real Deployment Environment
- ✅ Work directly on production/staging server
- ✅ Access to databases and internal APIs
- ✅ Test in real environment
- ✅ Instant deployment (already on server)

### 5. Session Persistence
- ✅ Work persists even if Claude session dies
- ✅ New session can pick up exactly where last one left off
- ✅ Progress tracking via VPS files
- ✅ Resilient to rate limits

## Multi-Agent Patterns

### Pattern 1: Division of Labor (Parallel)

```
Agent 1: Works on myproject/frontend/ only
Agent 2: Works on myproject/backend/ only
Agent 3: Works on myproject/tests/ only
Agent 4: Works on myproject/devops/ only

Coordination: Each checks a shared status file
```

### Pattern 2: Task Queue (Dynamic)

```
Coordinator: Breaks work into tasks, writes to task-queue.json
Workers 1-4: Poll queue, claim tasks, execute, mark complete
Result: Automatic load balancing
```

### Pattern 3: Sequential Pipeline

```
Agent 1: Writes code → Sets status: "code_complete"
Agent 2: Waits for code_complete → Writes tests → Sets "tests_complete"
Agent 3: Waits for tests_complete → Refactors → Sets "refactor_complete"
Result: Coordinated workflow
```

### Pattern 4: Coordinator + Workers (Recommended)

```
You → Coordinator Agent: "Build a todo app with auth"

Coordinator:
  - Breaks into 20 tasks
  - Writes to task-queue.json
  - Monitors progress
  - Reports to you

Workers 1-4:
  - Continuously poll task queue
  - Claim available tasks
  - Execute tasks
  - Mark complete
  - Repeat until queue empty
```

## Communication Mechanisms

### 1. Task Queue (task-queue.json)
```json
[
  {
    "id": 1001,
    "description": "Create user model",
    "status": "pending|in_progress|completed",
    "assigned_to": "worker-backend",
    "claimed_by": "worker-backend",
    "result": {...}
  }
]
```

### 2. Worker Status (worker-status.json)
```json
{
  "worker-backend": {
    "status": "active",
    "last_heartbeat": "2025-11-09T10:15:30",
    "last_task_completed": "2025-11-09T10:14:00",
    "capabilities": ["backend", "api", "database"]
  }
}
```

### 3. Agent Communication Log (agent-comms.jsonl)
```json
{"timestamp": "...", "agent": "worker-frontend", "message": "Started login component"}
{"timestamp": "...", "agent": "worker-backend", "message": "Auth API ready"}
```

### 4. Progress Tracking (progress.json)
```json
{
  "current_step": 45,
  "total_steps": 100,
  "status": "in_progress",
  "last_updated": "2025-11-09T10:15:30"
}
```

## Comparison: GitHub vs VPS

| Feature | GitHub Branches | VPS Shared Workspace |
|---------|----------------|---------------------|
| **Isolation** | Each agent in separate branch | All agents in same workspace |
| **Real-time collaboration** | ❌ No | ✅ Yes |
| **State sharing** | ❌ No (until merge) | ✅ Yes (immediate) |
| **Task coordination** | ❌ Manual | ✅ Automated via queue |
| **Privacy** | ⚠️ Code on GitHub | ✅ Code stays on VPS |
| **Storage** | Limited by GitHub | Limited by VPS (large) |
| **Environment access** | ❌ Sandboxed | ✅ Full VPS access |
| **Merge overhead** | ❌ High (multiple branches) | ✅ None (shared space) |
| **Session persistence** | ⚠️ Lost if session dies | ✅ Persists on VPS |

## Limitations & Considerations

### Rate Limits
- Running 4 agents = 4x rate limit consumption
- Pro users: ~40 requests per 5 minutes per agent
- Must manage workload distribution

### Cost
- 4-5 simultaneous sessions = significant token usage
- Monitor costs carefully

### Conflict Prevention
- Need file locking mechanism
- Coordinate which agent touches which files
- Use atomic operations

### Network Latency
- Every operation = API call to VPS
- Slower than local file operations
- Mitigate with batching

### Worker Management
- Workers eventually timeout (idle limit)
- Need mechanism to restart workers if needed
- Coordinator should monitor worker health

## Summary

VPS-based architecture enables **true distributed multi-agent systems** where:
- Multiple Claude agents collaborate in real-time
- Work persists beyond individual sessions
- Privacy is maintained (code stays on VPS)
- Coordination happens naturally through shared state
- You only need to manage the coordinator agent

This is fundamentally more powerful than the standard GitHub branch approach for complex, multi-step tasks.
