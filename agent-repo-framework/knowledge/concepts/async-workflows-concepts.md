# Async Workflows & Advanced Multitasking - Concepts

**Version:** 1.0
**Last Updated:** 2025-11-09

---

## Table of Contents

1. [Background Process Fundamentals](#background-process-fundamentals)
2. [Context Management](#context-management)
3. [Long-Running Tasks](#long-running-tasks)
4. [Remote Machine Workflows](#remote-machine-workflows)
5. [Subagents vs Scripts vs Webhooks](#subagents-vs-scripts-vs-webhooks)
6. [Multi-Workflow Orchestration](#multi-workflow-orchestration)
7. [Waiting Strategies](#waiting-strategies)
8. [Advanced Patterns](#advanced-patterns)

---

## Background Process Fundamentals

### The Problem

Synchronous execution blocks everything. When running a long task, the entire conversation waits. The user sits idle while tests run for 5 minutes, builds complete, or installations finish.

Better approach: Start tasks in background and continue being productive while they run. Return instant control to the conversation, do other work, then check results later.

**Example workflow:**
- User asks to run tests
- Tests start in background (returns instantly)
- Continue explaining code or doing other tasks
- Check test results when they complete
- Report findings to user

---

### Background Process Mechanics

**Starting background tasks:**
- Task begins execution immediately
- Returns control instantly with a task identifier
- Claude is free to do other work immediately

**Checking progress:**
- Use task identifier to check status
- Status check blocks briefly but starting doesn't
- Can see partial output while task runs

**Key insight:**
- Starting background tasks = instant, non-blocking
- Checking status = synchronous, brief block
- This asymmetry enables productive multitasking

---

### When to Use Background

**Use background for:**
- Long-running tests (>30 seconds)
- Package installations
- Builds and compilations
- Database migrations
- Large file downloads
- Docker operations
- Comprehensive linting

**Don't use background for:**
- Quick commands (<2 seconds)
- Commands you need results from immediately
- Interactive commands
- Commands that fail fast

**Rule of thumb:** If it takes >5 seconds, consider background.

---

### Parallel Background Execution

**Pattern: Start multiple tasks, then check all**

Launch several independent tasks simultaneously:
- Start unit tests (2 minutes)
- Start integration tests (5 minutes)
- Start build (3 minutes)

All three run in parallel while you continue working. Total time: 5 minutes instead of 10 minutes sequential, plus ability to do other productive work during execution.

After some time working on other tasks, check all results and report findings.

**Productivity gain:** Massive time savings through parallelism plus continued productivity during waits.

---

## Context Management

### The Challenge

AI assistants have finite context windows. Every file read, every tool call, every response consumes tokens. Large codebases can quickly exhaust available context if not managed carefully.

**Problem scenario:**
- Session starts with empty context
- Read 50 files to understand codebase
- Run analysis tasks
- Read more supporting files
- Context window fills up
- Can't continue work, must start new session

### Strategy 1: Progressive Context Loading

**Don't load everything upfront.** Start with entry points and load files only as needed.

**Bad approach:** Read entire codebase immediately, trying to understand everything.

**Good approach:**
- Read main entry point first
- Understand architecture
- Load specific modules only when needed
- Use exploration tools to summarize before loading

**Use exploration agents** to survey large areas without loading everything into context. Agent explores, summarizes findings, you only load what matters.

---

### Strategy 2: Artifact Files

**Problem:** Need to track state across long sessions

**Solution:** Write state to files on disk

Create session state files that track:
- Completed tasks
- Current focus area
- Known blockers
- Next steps planned

**Benefits:**
- Context persists across sessions
- Other agents can pick up where you left off
- User can resume work without re-explaining everything
- State doesn't consume active context

---

### Strategy 3: Reference Files Over Inline Content

**Problem:** Repeating same information wastes tokens

**Bad pattern:** Load all files into context, keep them loaded throughout session

**Better pattern:** Use exploration to find files, then edit them one at a time. Don't keep all loaded simultaneously.

**Even better:** Create instruction files that list what needs to be done. Future sessions or agents can read instructions without re-explaining.

---

### Strategy 4: Compress Context with Summaries

After complex analysis, write summary documents capturing key findings. Future sessions can read the summary instead of re-analyzing the entire codebase.

**Summary document structure:**
- High-level findings
- Prioritized list of issues
- References to detailed analysis
- Action items

This compresses hours of analysis into a single readable document that doesn't exhaust context.

---

## Long-Running Tasks

### Pattern 1: Background Task with Periodic Checks

**Problem:** Task takes 2-5 minutes, don't want to block

**Solution:**
- Start task in background
- Do other productive work (review docs, analyze code)
- Check progress periodically
- Continue other work between checks
- Eventually task completes with full results

**Benefits:**
- Productive during waits
- User doesn't see idle time
- Can pivot if issues arise early

---

### Pattern 2: Chained Background Tasks

**Problem:** Multiple dependent tasks, each long-running

**Solution:**
- Start first task in background
- Do other work while waiting
- Check completion occasionally
- When first completes, start second task
- Continue pattern through all dependent tasks

**Benefits:**
- Maximum parallelism where possible
- Sequential execution where dependencies exist
- Productive throughout entire workflow

---

### Pattern 3: Fire-and-Forget with Callback Script

**Problem:** Task takes 10+ minutes, way too long to wait

**Solution:** Use script that writes completion marker to file when done

**Workflow:**
- Start extremely long task in background
- Script writes status to file when complete
- Tell user task is running
- Move on to completely different work
- User or future session checks status file later

**Benefits:**
- Don't waste time waiting for very long tasks
- Clear status tracking
- Can check results in future session if needed

---

## Remote Machine Workflows

### Pattern: Proxy Script for Remote Execution

**Problem:** Need to run commands on remote servers, but cannot SSH directly

**Solution 1: SSH via script in background**
Create script that connects to remote machine, runs commands, returns results. Run entire script in background.

**Solution 2: API-based remote control**
Trigger remote job via API endpoint, poll for completion. Script handles polling automatically while running in background.

**Solution 3: WebSocket/Webhook callback**
Remote system notifies when job completes by writing to shared file. Check file periodically to discover completion.

---

### Pattern: Download to Remote, Sync to Local

**Problem:** Need to download large file, but local environment is ephemeral

**Solution:**
- Download to persistent remote server
- Process data on remote (fast datacenter connection)
- Sync only results back to local environment
- Results available locally when needed

**Benefits:**
- Remote server has persistent storage
- Fast network connection for downloads
- Local environment doesn't fill up
- Results available when needed

---

## Subagents vs Scripts vs Webhooks

### Comparison Matrix

| Approach | Startup Time | Flexibility | Consistency | Maintenance | Best For |
|----------|--------------|-------------|-------------|-------------|----------|
| **Subagents** | Slow (AI reasoning) | High (adapts to context) | Medium (AI variability) | Low | Complex analysis, exploration |
| **Scripts** | Fast (direct execution) | Low (fixed logic) | High (deterministic) | Medium | Well-defined workflows |
| **Webhooks** | Very Fast | Medium (predefined hooks) | High | High | Remote/async operations |

---

### When to Use Subagents

**Use separate AI agents for:**

1. **Open-ended exploration**
   - Analyzing patterns across codebase
   - Agent explores and adapts to what it finds
   - Returns summary of findings

2. **Complex analysis**
   - Security reviews requiring judgment
   - Checking for common vulnerabilities
   - Suggesting context-aware improvements

3. **Multi-step workflows with decision points**
   - Finding TODO comments and categorizing by priority
   - Creating issues based on context understanding
   - Requires judgment about priorities

**Benefits:**
- Handles unexpected situations
- Provides nuanced analysis
- Can make judgment calls

**Drawbacks:**
- Slower (AI reasoning time)
- Uses more tokens
- Less predictable

---

### When to Use Scripts

**Use background scripts for:**

1. **Well-defined workflows**
   - Run unit tests, then integration tests, then coverage
   - Same steps every time

2. **Performance-critical operations**
   - Fast execution, no AI overhead
   - Production builds

3. **Consistent, repeatable tasks**
   - Linting and formatting
   - Same result every time

**Benefits:**
- Fast execution
- Predictable results
- Low token usage
- Can be tested independently

**Drawbacks:**
- Inflexible (can't adapt)
- Requires maintenance
- Limited error handling

---

### When to Use Webhooks

**Use webhooks for:**

1. **Long-running remote jobs**
   - Trigger remote build on CI/CD
   - Webhook notifies when complete
   - Receive notification via file or API

2. **External system integration**
   - GitHub webhook triggers automatic review
   - Integration with external services

3. **Async task queues**
   - Add task to queue
   - Worker processes over minutes/hours
   - Worker writes result to file
   - Check file in next session

**Benefits:**
- True asynchronicity
- No polling required
- Integrates with external systems
- Scalable

**Drawbacks:**
- Complex setup
- Requires infrastructure
- Debugging harder
- Security considerations

---

### Hybrid Approach Example

**Scenario:** Deploy to production (complex + risky)

**Multi-approach workflow:**

1. **Use Agent for pre-deploy analysis**
   - Review all changes since last deploy
   - Identify potential risks
   - Check if tests pass
   - Verify migrations are safe
   - Agent returns risk assessment

2. **Use Script for actual deployment**
   - Script handles deterministic deploy steps
   - Well-defined, repeatable process

3. **Use Webhook for long-running smoke tests**
   - Deployment triggers external smoke tests
   - Smoke test service posts results to webhook
   - Check results file when ready

4. **Use Agent for post-deploy verification**
   - Check error logs
   - Verify key endpoints
   - Analyze performance metrics
   - Requires context and judgment

**Why hybrid:**
- Agent: Analysis requires judgment
- Script: Deploy steps are well-defined
- Webhook: Smoke tests run externally
- Agent: Verification needs context

---

## Multi-Workflow Orchestration

### Pattern: Parallel Workflows with Coordination

**Scenario:** Build frontend and backend simultaneously

**Workflow:**
- Start frontend build in background
- Start backend build in background
- Use exploration agent to check for configuration issues while building
- Check frontend build status
- Check backend build status
- When both complete, start integration task

**Benefits:**
- Maximum parallelism
- Productive during build time
- Coordinated completion

---

### Pattern: Workflow Branching

**Scenario:** Different workflows based on conditions

**Workflow:**
- Check current state (e.g., git status)
- Branch A: If changes exist, review and commit first, then run tests
- Branch B: If no changes, pull latest, then run tests
- Both branches converge: Deploy if tests pass

**Benefits:**
- Adaptive workflows
- Handle different scenarios appropriately
- Same end goal with different paths

---

### Pattern: Workflow Checkpoints

**Scenario:** Long workflow with save points

**Concept:**
- Create checkpoint files after each major step
- Step 1: Install dependencies → Write checkpoint file
- Step 2: Build → Write checkpoint file
- Step 3: Tests → Write checkpoint file

**Resumability:**
If session interrupted, next session:
- Read checkpoint files to see what's completed
- Resume from last incomplete step
- Don't redo work already done

**Benefits:**
- Resumable across sessions
- Don't lose progress
- Clear state tracking

---

## Waiting Strategies

### Strategy 1: Tell User to Come Back

**When:** Task takes 10+ minutes

**Approach:**
Start task in background, inform user honestly about timing. User can:
- Come back later and ask for results
- Check status file themselves
- Move on to other tasks

**Pros:**
- Honest about timing
- User can do other things
- Clear expectations

**Cons:**
- Requires user to remember
- Breaks conversation flow

---

### Strategy 2: Do Other Work in Meantime

**When:** Task takes 2-5 minutes

**Approach:**
- Start task in background
- Do related but independent work (review docs, analyze code)
- Task likely completes while doing other work
- Check status afterward

**Pros:**
- Productive use of time
- User sees continuous progress
- Natural conversation flow

**Cons:**
- Limited to independent tasks
- May still end up waiting

---

### Strategy 3: Progressive Checks with User Engagement

**When:** Task takes 3-10 minutes, user is engaged

**Approach:**
Ask user their preference:
- Check periodically and provide updates
- Do other work and check when prompted
- Just notify when complete

Adapt to user's preferred engagement level.

**Pros:**
- User stays informed
- Can catch failures early
- Feels responsive

**Cons:**
- Requires user prompting
- Each check blocks briefly

---

### Strategy 4: Monitoring Script with Live Output

**When:** Want continuous visibility

**Approach:**
- Script runs task and continuously writes progress to file
- Script monitors and provides incremental updates
- Can check file anytime for latest progress

**Benefits:**
- Continuous visibility
- No need to poll
- Clear progress tracking

---

### Strategy 5: State Machine for Complex Waits

**When:** Multiple dependent long tasks

**Approach:**
- Maintain state file tracking current workflow stage
- State file shows: current stage, completed stages, current task ID
- Check state to determine next action
- Based on stage: check current task, advance to next when ready

**Benefits:**
- Resumable across sessions
- Clear state tracking
- Can pause and resume
- Perfect for complex multi-stage workflows

---

## Advanced Patterns

### Pattern: Speculative Execution

**Concept:** Start likely-needed work before user confirms

**Example scenario:**
- User mentions thinking about deploying
- Speculatively start build in background while discussing
- Ask user to confirm deployment
- When user confirms, build is likely already done
- Deploy immediately

**Benefits:**
- Saves time on confirmation
- User perceives instant action
- More responsive experience

**Risks:**
- Wasted work if user says no
- Be conservative with costly operations
- Only for low-risk, reversible tasks

---

### Pattern: Fan-out / Fan-in

**Concept:** Parallel execution, then combine results

**Workflow:**
- Fan-out: Start multiple similar tasks in parallel
  - Analyze security in auth module
  - Analyze security in API module
  - Analyze security in database module
  - Analyze security in frontend module
  - Analyze security in infrastructure

- All tasks run simultaneously

- Fan-in: Combine all results into unified summary
  - Total issues across all modules
  - Prioritized list combining all findings
  - Cross-module insights

**Benefits:**
- Massive time savings through parallelism
- Comprehensive coverage
- Unified insights from distributed analysis

---

### Pattern: Pipeline with Early Exit

**Concept:** Stop pipeline if any stage fails

**Workflow stages:**
1. Run linting → If fails, stop and report
2. Run type checking → If fails, stop and report
3. Run tests → If fails, stop and report
4. All passed → Deploy

Each stage is a gate. Failure at any stage prevents progression. This avoids wasting time on later stages when early stages fail.

**Benefits:**
- Fast feedback on failures
- Don't waste time on doomed workflows
- Clear failure points

---

### Pattern: Watchdog for Hung Processes

**Concept:** Kill tasks that take too long

**Approach:**
- Start task with timeout mechanism
- If task exceeds timeout, kill it
- Report timeout failure
- Prevents infinite hangs

**Use cases:**
- Tests that occasionally hang
- Network operations that might timeout
- Any task with known maximum reasonable duration

---

### Pattern: Retry with Exponential Backoff

**Concept:** Retry flaky operations with increasing delays

**Workflow:**
- Attempt 1: Try immediately
- If fails: Wait 2 seconds, retry
- If fails again: Wait 4 seconds, retry
- If fails again: Wait 8 seconds, retry
- After max attempts: Report failure

**Use cases:**
- Flaky tests
- Network operations
- External API calls
- Any intermittently failing task

**Benefits:**
- Handles transient failures
- Increasing delays reduce load
- Eventually succeeds or definitively fails

---

## Best Practices Summary

### Do's

✅ **Start long tasks in background** - Enables multitasking and productivity

✅ **Do other work while waiting** - Review code, analyze architecture, document findings

✅ **Write state to files for persistence** - Enables resumption across sessions

✅ **Use exploration agents to save context** - Get summaries without loading everything

✅ **Check background tasks periodically, not constantly** - Avoid polling overhead

✅ **Provide user with time estimates** - Set clear expectations

✅ **Use scripts for deterministic workflows** - Fast, reliable, repeatable

✅ **Handle failures gracefully** - Plan for errors, provide clear diagnostics

### Don'ts

❌ **Don't use background for quick tasks (<2s)** - Overhead not worth it

❌ **Don't check status immediately after starting** - Task hasn't had time to progress

❌ **Don't check multiple status outputs in rapid sequence** - Each check blocks

❌ **Don't keep all files in context unnecessarily** - Exhausts context window

❌ **Don't rely on temporary state for multi-session work** - Use files instead

❌ **Don't start tasks you don't plan to wait for** - Creates orphaned processes

❌ **Don't ignore timeout risks** - Always have watchdog for potentially hanging tasks

---

## Key Takeaways

**Background execution enables:**
- True multitasking during long operations
- Parallel execution of independent tasks
- Continued productivity during waits
- Better user experience with responsive interaction

**Context management is critical:**
- Progressive loading preserves context budget
- Artifact files enable cross-session persistence
- Summaries compress analysis for reuse
- Exploration agents find information without loading everything

**Choose the right tool:**
- Subagents for complex, adaptive analysis
- Scripts for fast, deterministic workflows
- Webhooks for true async external integration
- Often best to combine approaches

**Workflow orchestration patterns:**
- Parallel execution saves time
- Checkpoints enable resumability
- State machines handle complex flows
- Early exit prevents wasted work

**The fundamental shift:**
Traditional: One task at a time, blocking execution, idle waiting
Modern: Multiple tasks in parallel, background execution, productive waiting

This transforms AI assistance from sequential command execution to orchestrated workflow management.

---

*End of Async Workflows Concepts Guide. Last updated: 2025-11-09*
