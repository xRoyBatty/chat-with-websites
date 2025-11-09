# Claude Code Advanced Tools: Decision Tree

## Start: What are you trying to accomplish?

```
                    ┌─────────────────────────────────┐
                    │ What's your primary goal?       │
                    └──────────────┬──────────────────┘
                                   │
          ┌────────────────────────┼────────────────────────┐
          │                        │                        │
          ▼                        ▼                        ▼
    ┌──────────────┐         ┌──────────────┐      ┌──────────────┐
    │ Scale work   │         │ Reuse logic  │      │ Speed up     │
    │ across multiple│         │ across       │      │ execution    │
    │ agents on     │         │ sessions     │      │ (parallelism)│
    │ same codebase?│         │              │      │              │
    └──────┬───────┘         └──────┬───────┘      └──────┬───────┘
           │                        │                     │
     YES ▼ NO                 YES ▼ NO              YES ▼ NO
     ┌─────────┐             ┌─────────┐          ┌─────────┐
     │   VPS   │             │ SKILLS  │          │SUBAGENTS│
     │MULTI-   │             │         │          │or ASYNC │
     │AGENT    │             │         │          │WORKFLOWS│
     └─────────┘             └─────────┘          └─────────┘
           │                        │                     │
           │                        │                     │
           └────────────────────────┼─────────────────────┘
                                    │
                    ┌───────────────▼────────────────┐
                    │ Continue below for details...  │
                    └────────────────────────────────┘
```

---

## Decision Point 1: VPS Multi-Agent System

**Use if:**
- ✅ Multiple Claude Code agents need to work on the **same codebase simultaneously**
- ✅ You need **persistent workers** that survive session timeouts
- ✅ You want **asynchronous task coordination** through shared files
- ✅ You need **privacy** - code stays on your VPS, not in GitHub
- ✅ Workers should **auto-discover and execute tasks** from a queue

**Skip if:**
- ❌ You're working alone
- ❌ Tasks are quick (single session)
- ❌ No need for persistent background execution

**Next:** See [VPS Multi-Agent Guide](../../../knowledge/full/vps-multi-agent.md)

---

## Decision Point 2: Skills

**Use if:**
- ✅ You have **reusable functionality** (workflows, utilities, helpers)
- ✅ You want to **invoke it with `/skill-name`** in conversations
- ✅ Same logic needed **across multiple sessions**
- ✅ You want **custom domain knowledge** (PDF extraction, data parsing, etc.)
- ✅ You need **consistent behavior** across different Claude Code sessions

**Skip if:**
- ❌ One-time script for this session only
- ❌ No need for reusability
- ❌ Built-in tools already handle your use case

**Next:** See [Skills Guide](../../../knowledge/full/skills.md)

---

## Decision Point 3: Subagents

**Use if:**
- ✅ You want **parallel execution** of independent tasks
- ✅ Multiple tasks can run **simultaneously** (true concurrency)
- ✅ You need **specialized agents** for different domains
- ✅ Results from subtasks need **aggregation/synthesis**
- ✅ You want **auto-spawning of new agent instances**

**Skip if:**
- ❌ Tasks must run **sequentially**
- ❌ Only one task at a time needed
- ❌ Simple tool usage (Bash, file operations) is sufficient

**Next:** See [Subagents Guide](../../../knowledge/full/subagents.md)

---

## Decision Point 4: Async Workflows / Background Execution

**Use if:**
- ✅ Tasks **take a long time** (minutes/hours)
- ✅ You want to **monitor progress** without waiting
- ✅ Other work should continue **while task executes**
- ✅ You need to **check status periodically**
- ✅ Session timeout would be a problem

**Implementation options:**
1. **Background Bash** - Use `run_in_background=true` parameter
   - Good for: Long-running CLI commands
   - Check output with `BashOutput` tool

2. **Async API** - Queue tasks via API
   - Good for: External service integration
   - Requires: Task queue system (see VPS Multi-Agent)

3. **Stop Hooks** - Keep workers alive between tasks
   - Good for: Persistent polling workers
   - Requires: VPS setup

**Next:** See [Async Patterns Guide](../../../knowledge/full/async-patterns.md)

---

## Common Scenarios

### Scenario A: Data Processing Team
> "We have 3 people who need to process documents in parallel"

```
Multi-agents needed?     YES ──► Use VPS Multi-Agent
Working on same code?    YES ──► Use VPS
Need persistence?        YES ──► Use Stop Hooks
Parallel processing?     YES ──► Use Subagents within coordinator
```

**Solution:** VPS Multi-Agent + Subagents

---

### Scenario B: Personal Project with Reusable Tools
> "I often use custom PDF extraction and markdown formatting"

```
Reusable across sessions? YES ──► Use Skills
Need multi-agent?        NO  ──► Skip VPS
Need parallelism?        NO  ──► Skip Subagents
```

**Solution:** Skills + Built-in Tools

---

### Scenario C: Complex Data Pipeline
> "Multiple stages that can run in parallel, aggregate results"

```
Parallel execution?      YES ──► Use Subagents
Same codebase context?   NO  ──► Skip VPS
Long-running?            YES ──► Use Background Execution
Reusable logic?          YES ──► Consider Skills for stages
```

**Solution:** Subagents + Background Execution (+ Skills if reusable)

---

### Scenario D: Persistent Worker System
> "I need agents that continuously poll for work and execute tasks"

```
Multiple agents?         YES ──► Use VPS Multi-Agent
Persistent?              YES ──► Use Stop Hooks
Task coordination?       YES ──► Use Task Queue
Async execution?         YES ──► Background Bash in worker
```

**Solution:** VPS Multi-Agent + Stop Hooks + Task Queue

---

## Quick Reference Matrix

| Need | Tool | Why |
|------|------|-----|
| Reusable logic across sessions | Skills | Domain-specific knowledge you'll use repeatedly |
| Multiple agents, same codebase | VPS Multi-Agent | Real-time collab, privacy, shared workspace |
| Parallel independent tasks | Subagents | True concurrency, task aggregation |
| Long-running operations | Background Bash | Don't block main conversation |
| Persistent workers polling | Stop Hooks + VPS | Survive timeouts, continuous monitoring |
| Quick one-time script | Built-in Bash/Edit | Simplicity, no overhead |

---

## Flow Summary

```
START
  │
  ├─ Scale to multiple agents? ────► YES ──► VPS MULTI-AGENT
  │                                   NO ──┐
  │                                        │
  ├─ Reusable across sessions? ───► YES ──► SKILLS
  │                                 NO ──┐
  │                                      │
  ├─ Need true parallelism? ────► YES ──► SUBAGENTS
  │                              NO ──┐
  │                                   │
  ├─ Long-running tasks? ────► YES ──► BACKGROUND EXECUTION
  │                           NO ──┐
  │                               │
  └─────────────────────────────► USE BUILT-IN TOOLS
```

---

## Related Guides

- **VPS Multi-Agent Architecture:** `knowledge/full/vps-multi-agent.md`
- **Skills Creation & Usage:** `knowledge/full/skills.md`
- **Subagents Coordination:** `knowledge/full/subagents.md`
- **Async Patterns:** `knowledge/full/async-patterns.md`
- **Tool Combinations:** `user-engagement/tool-suggestions/combinations/`

---

## Decision Support

**Still unsure?** Answer these questions:

1. **How many agents will work together?** (1+ = VPS)
2. **Can tasks run in parallel?** (Yes = Subagents)
3. **Will you reuse this logic?** (Yes = Skills)
4. **How long will execution take?** (10+ minutes = Background)
5. **Do agents need to survive restarts?** (Yes = Stop Hooks)

For each "yes" answer, apply the corresponding tool.

---

## Pro Tips

- **Combine tools** - VPS + Subagents is powerful for distributed parallelism
- **Start simple** - Built-in tools handle 80% of use cases
- **Iterate** - Start with one tool, add others as needed
- **Test** - Each tool should be tested independently before combining
- **Document** - Context isolation means everything must be in files

---

**Last Updated:** November 2024
**Next Review:** When new tools are added to Claude Code
