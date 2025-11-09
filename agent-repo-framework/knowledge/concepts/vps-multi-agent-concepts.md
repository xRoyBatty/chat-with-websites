# VPS-Based Multi-Agent Architecture (Concepts)

## The Core Concept

Instead of having a GitHub repo that contains actual code, use GitHub as a **"thin client"** that only contains:
- Instructions
- Skills for deployment
- Configuration

The **actual code lives entirely on a remote server (VPS)**, and Claude agents interact with it via an API.

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
Session 1 (Agent 1) → VPS shared workspace
Session 2 (Agent 2) → VPS shared workspace (SAME location!)
Session 3 (Agent 3) → VPS shared workspace (SAME location!)
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
│  VPS: Remote Server with API       │
│                                     │
│  Shared Workspace:                 │
│                                     │
│  - src/                ← Actual code │
│  - tests/                           │
│  - task-queue         ← Coordination │
│  - worker-status                    │
│  - agent-comms                      │
│  - progress                         │
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
Agent 1: Works on frontend/ only
Agent 2: Works on backend/ only
Agent 3: Works on tests/ only
Agent 4: Works on devops/ only

Coordination: Each checks a shared status file
```

**Use when:** You have clearly separable domains with minimal dependencies.

**Benefits:** Maximum parallelism, minimal coordination overhead.

**Challenges:** Need to coordinate interfaces between domains.

---

### Pattern 2: Task Queue (Dynamic)

```
Coordinator: Breaks work into tasks, writes to task queue
Workers 1-4: Poll queue, claim tasks, execute, mark complete
Result: Automatic load balancing
```

**Use when:** You have many small-to-medium tasks that can be executed independently.

**Benefits:**
- Automatic load balancing
- Workers self-assign based on availability
- Easy to scale up/down worker count
- Natural handling of worker failures

**Workflow:**
1. Coordinator analyzes project requirements
2. Breaks work into discrete, independent tasks
3. Each task includes complete instructions (no shared context)
4. Workers continuously poll for available tasks
5. Workers claim tasks atomically (prevent double assignment)
6. Workers execute and mark complete
7. Coordinator monitors overall progress

---

### Pattern 3: Sequential Pipeline

```
Agent 1: Writes code → Sets status: "code_complete"
Agent 2: Waits for code_complete → Writes tests → Sets "tests_complete"
Agent 3: Waits for tests_complete → Refactors → Sets "refactor_complete"
Result: Coordinated workflow
```

**Use when:** Tasks have strict dependencies and must be done in order.

**Benefits:**
- Clear handoffs between stages
- Each agent specializes in one phase
- Quality gates between stages

**Workflow:**
1. Each agent watches a status file
2. Waits for predecessor to signal completion
3. Executes their specialized task
4. Signals completion to next agent

---

### Pattern 4: Coordinator + Workers (Recommended)

```
You → Coordinator Agent: "Build a todo app with auth"

Coordinator:
  - Breaks into 20 tasks
  - Writes to task queue
  - Monitors progress
  - Reports to you

Workers 1-4:
  - Continuously poll task queue
  - Claim available tasks
  - Execute tasks
  - Mark complete
  - Repeat until queue empty
```

**Use when:** You want to delegate complex projects to multiple agents.

**Benefits:**
- You only interact with one agent (coordinator)
- Coordinator handles all orchestration
- Workers are autonomous and persistent
- Natural fault tolerance
- Scalable (add more workers easily)

**Coordinator responsibilities:**
- Break down high-level goals into tasks
- Create complete, self-contained task instructions
- Monitor worker health and progress
- Handle task reassignment if workers fail
- Report progress and blockers to you
- Make strategic decisions about approach

**Worker responsibilities:**
- Poll task queue continuously
- Claim available tasks atomically
- Execute based solely on task instructions
- Save results to shared workspace
- Update task status
- Continue until queue empty or timeout

---

## Communication Mechanisms

Since agents have no shared conversation context, all coordination happens through files on the VPS:

### 1. Task Queue
A shared file containing all tasks to be executed. Each task includes:
- Unique identifier
- Complete description and instructions
- Current status (pending, in progress, completed)
- Which worker claimed it
- Results or output location

**Key insight:** Task instructions must be self-contained. Workers have zero context from conversations.

---

### 2. Worker Status
A shared file where each worker reports:
- Current activity status
- Last heartbeat timestamp
- Last task completed timestamp
- Capabilities and specializations

**Key insight:** Coordinators use this to monitor worker health and redistribute work if needed.

---

### 3. Agent Communication Log
An append-only log where agents can leave messages for each other. Each entry includes:
- Timestamp
- Agent identifier
- Message content

**Use cases:**
- Workers report completion of milestones
- Workers flag blockers or issues
- Coordinators broadcast instructions
- Asynchronous Q&A between agents

---

### 4. Progress Tracking
A shared file tracking overall project progress:
- Current step or phase
- Total steps
- Overall status
- Last update timestamp
- Blockers or issues

**Key insight:** Allows coordinator to summarize progress for the human user.

---

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
- Pro users have per-session limits
- Must manage workload distribution
- Consider staggering worker starts

### Cost
- Multiple simultaneous sessions = significant token usage
- Monitor costs carefully
- May need to limit concurrent workers

### Conflict Prevention
- Need file locking mechanism for shared files
- Coordinate which agent touches which files
- Use atomic operations for task claiming
- Design file structure to minimize conflicts

### Network Latency
- Every operation = API call to VPS
- Slower than local file operations
- Mitigate with batching operations
- Cache reads where possible

### Worker Management
- Workers eventually timeout (idle limit)
- Need mechanism to restart workers if needed
- Coordinator should monitor worker health
- Implement heartbeat system

### Context Isolation (Critical)
Workers have ZERO conversation context. They cannot:
- ❌ Remember what coordinator "told" them verbally
- ❌ Access conversation history
- ❌ Understand context from previous tasks
- ❌ Know what other workers did

**All coordination happens through files:**
- Task instructions must be completely self-contained
- Include all necessary context files in task definition
- Workers read everything fresh from VPS
- No assumptions about shared knowledge

## When to Use This Architecture

**Ideal for:**
- Complex multi-step projects requiring parallelization
- Projects with sensitive code that shouldn't touch GitHub
- Long-running projects spanning multiple sessions
- Projects requiring real deployment environment access
- Teams wanting to test distributed AI collaboration

**Not ideal for:**
- Simple single-file tasks
- Projects requiring immediate responses
- Exploration/learning (higher cost)
- Tasks with tight latency requirements

## Summary

VPS-based architecture enables **true distributed multi-agent systems** where:
- Multiple Claude agents collaborate in real-time
- Work persists beyond individual sessions
- Privacy is maintained (code stays on VPS)
- Coordination happens naturally through shared state
- You only need to manage the coordinator agent

This is fundamentally more powerful than the standard GitHub branch approach for complex, multi-step tasks requiring coordination between multiple specialized agents.

The key innovation is treating the filesystem as a **coordination layer** rather than just storage, enabling asynchronous, file-based communication between agents who have no other way to coordinate.
