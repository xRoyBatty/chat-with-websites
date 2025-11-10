# Subagents Tool Suggestion Guide

**Reference:** See `knowledge/concepts/subagents-concepts.md` for deep-dive concepts and advanced patterns.

---

## What Are Subagents?

Subagents are specialized Claude instances that you spawn to handle specific tasks while maintaining independent context. Think of them as delegating work to a specialized expert who doesn't know what you discussed before—they only know what you explicitly tell them.

**Key trait:** Each subagent is a fresh Claude instance. They cannot access:
- Your conversation history
- Previous messages in this chat
- What you discussed earlier
- Context from other subagents

**They CAN access:**
- Their spawn prompt (your explicit instructions)
- Files in the repository
- Results from their own tool calls
- Environment variables you set

---

## ⚠️ Context Isolation — CRITICAL

**This is the single most important concept for subagents.**

### The Problem

**WRONG approach:**
```
You discuss a bug in the conversation with Claude
You say: "Create a fix for the authentication bug"
Subagent responds: "What authentication bug? I have no context."
```

The subagent literally cannot see your conversation. It's a fresh Claude instance.

### The Solution

**CORRECT approach:**
```
1. Write bug details to: docs/auth-bug-report.md
2. Tell subagent: "Read docs/auth-bug-report.md for the bug details.
   Then fix the authentication.py file according to the bug report."
3. Subagent reads the file and understands the context
```

**Golden Rule:** If you can't point to a file or write it in a prompt, the subagent cannot access it.

### Practical Impact

Every subagent invocation must be **self-contained**:

✅ Include complete instructions in prompt
✅ Reference specific files subagent should read
✅ Describe expected output format explicitly
✅ State success criteria clearly

❌ Don't assume subagent remembers previous invocations
❌ Don't reference "that thing we discussed"
❌ Don't expect context from conversation history

---

## Types of Subagents

### 1. Task Tool Subagents

**What:** General-purpose subagents from the Task tool (Explore, Plan, Review, Build).

**Characteristics:**
- Pre-configured roles (planning, exploring, reviewing, building)
- Good for one-off focused tasks
- Automatically understand their role
- Simple invocation

**Best for:**
- Quick analysis or research
- Code review
- Documentation generation
- Planning assistance

**Example:** `Task: Explore the repository structure and summarize architecture`

### 2. Custom @agents

**What:** Specialized agents defined in your `.claude/agents.json` or custom configuration.

**Characteristics:**
- Tailored for your specific domain
- Can have custom instructions and personality
- Reusable across sessions
- Persistent configuration

**Best for:**
- Recurring specialized work
- Domain-specific expertise
- Complex workflows
- Multi-step coordination

**Example:** Create a `@doc-writer` agent that specializes in documentation with your style preferences built in.

### 3. Worker Agents (VPS Integration)

**What:** Long-running agents that poll task queues on VPS.

**Characteristics:**
- Persistent across sessions via stop hooks
- Coordinate through task queue files
- Designed for distributed work
- Scalable worker pools

**Best for:**
- Large-scale processing
- Background task execution
- Multi-agent coordination systems
- Work that spans multiple sessions

---

## When to Use Subagents

### Good Use Cases

**1. Parallel Independent Work**
- Need 5 sections of documentation written simultaneously
- Spawn 5 subagents in parallel instead of writing sequentially
- Save 80% of time through parallelization

**2. Specialized Expertise**
- Need code reviewed by a specialist
- Need research gathered from multiple angles
- Spawn specialized subagents for each angle

**3. Long-Running Tasks**
- Background processing while you do other work
- Set it up to run independent of your session
- Check results later via files

**4. Delegation with Clear Scope**
- Know exactly what the subagent should do
- Can write complete instructions
- Don't need back-and-forth interaction

**5. Quality Control**
- Spawn supervisor subagent to review work
- Validate output before finalizing
- Multiple review passes without manual effort

### Common Patterns

**Pattern: Sequential Refinement**
```
1. Parent creates initial draft
2. Spawn reviewer subagent → reads draft, critiques
3. Parent applies feedback
4. Spawn verifier subagent → checks corrections
5. Done
```

**Pattern: Parallel Execution**
```
1. Write task specifications to files
2. Spawn 5 subagents simultaneously
3. Each reads its task file and executes independently
4. Collect results when all complete
```

**Pattern: Multi-Perspective Analysis**
```
1. Create analysis task
2. Spawn subagent with "optimist" perspective
3. Spawn subagent with "pessimist" perspective
4. Spawn subagent with "pragmatist" perspective
5. Parent synthesizes all perspectives
```

---

## Parallel Execution Benefits

### Speed Multiplier

**Sequential:** Task 1 (10 min) → Task 2 (10 min) → Task 3 (10 min) = **30 minutes**

**Parallel:** Task 1 + Task 2 + Task 3 (all simultaneous) = **10 minutes**

**3x faster** for independent work.

### Resource Efficiency

- You keep working while subagents handle other tasks
- Your main agent context stays focused
- Large work gets decomposed automatically

### Scalability

- 10 subagents = 10x throughput (for independent work)
- Limited mainly by API concurrency
- True parallelism not pseudo-concurrency

### Quality Improvement

- Specialists subagents may produce better quality
- Multiple reviews catch more issues
- Parallel perspectives create more balanced decisions

---

## When NOT to Use Subagents

### ❌ When Work Is Sequential

If Task B depends on Task A's output, you cannot parallelize:
```
WRONG: Spawn both simultaneously (B has no input from A)
CORRECT: Complete A sequentially, then start B
```

### ❌ When You Need Real-Time Interaction

Subagents are fire-and-forget or file-based polling. If you need back-and-forth conversation, keep it in the main agent.

### ❌ When Context Is Unclear

If you can't write clear instructions or point to files, subagent will be confused. Keep ambiguous work in main agent.

### ❌ When Context Is Huge

If the task requires understanding massive amounts of context, the subagent prompt becomes impractical. Better to have main agent handle it or break work into focused pieces.

### ❌ For Single Simple Tasks

Creating a subagent for a one-liner is overhead. Direct agent action is simpler.

---

## Practical Example Scenarios

### Scenario 1: Documentation Sprint

**Task:** Write 5-section documentation for a feature.

**Without subagents:** Write intro (20 min) → API reference (20 min) → Examples (20 min) → Troubleshooting (20 min) → FAQ (20 min) = **100 minutes**

**With subagents:**
1. Write detailed section specs to files: `docs/section-*.md.spec`
2. Spawn 5 subagents (one per section) simultaneously
3. Each reads its spec and writes the section
4. Collect results = **20 minutes + merge** (5x faster)

### Scenario 2: Code Quality Control

**Task:** Implement feature + get review + fix issues

**Process:**
1. Write code implementation (agent A)
2. Spawn reviewer subagent (reads code, creates issues list)
3. Agent A reads issues, fixes them
4. Spawn verifier subagent (confirms fixes are correct)
5. Done

Result: Quality-controlled output without manual review friction.

### Scenario 3: Multi-Angle Analysis

**Task:** Analyze a business decision from multiple perspectives.

**Process:**
1. Write decision context to file: `analysis/decision.md`
2. Spawn "Optimist" subagent (reads file, highlights benefits)
3. Spawn "Pessimist" subagent (reads file, identifies risks)
4. Spawn "Pragmatist" subagent (reads file, assesses feasibility)
5. Parent synthesizes all three perspectives
6. Informed decision made

Result: More balanced analysis through parallel perspectives.

### Scenario 4: Multi-Agent Coordination

**Task:** Coordinate 3 workers processing 100 tasks each.

**Process:**
1. Write 300 tasks to VPS task queue
2. Spawn 3 worker subagents with stop hooks
3. Each worker:
   - Polls queue continuously
   - Claims available task
   - Executes based on task instructions
   - Updates queue status
   - Continues until no tasks or idle timeout
4. Done (all 300 tasks processed in parallel)

Result: Distributed work across multiple agents, automatic load balancing.

---

## Quick Decision Tree

**Should I use a subagent?**

```
Is the work independent of other tasks?
├─ YES: Can I run it in parallel?
│  ├─ YES: Use parallel subagents (fast!)
│  └─ NO: Is it specialized?
│     ├─ YES: Use specialist subagent
│     └─ NO: Keep in main agent
└─ NO: Does Task B depend on Task A?
   └─ YES: Do sequentially OR
           Parallelize independent parts + sequence dependent parts
```

---

## Key Takeaways

1. **Context Isolation is Absolute** — Every subagent needs explicit context through prompts or files
2. **Parallelization Wins** — Independent tasks run 3-10x faster with parallel subagents
3. **File-Based Communication** — Use files to pass context, specifications, and results
4. **Self-Contained Instructions** — Each subagent invocation must be complete
5. **Specialist > Generalist** — Subagents with focused roles produce better results
6. **Not a Conversation Tool** — Subagents are for work delegation, not discussion

---

## Next Steps

- **Read:** `knowledge/concepts/subagents-concepts.md` for advanced patterns
- **Experiment:** Try spawning a simple subagent to understand context isolation
- **Plan:** Identify parallel work in your projects and parallelize with subagents
- **Scale:** For distributed work, consider VPS task queue pattern with worker agents

---

*Created: 2025-11-09 | Source: subagents-concepts.md knowledge base*
