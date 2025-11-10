# Async Workflows & Advanced Multitasking - Concepts

**Version:** 1.0 (Concept-Only)
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

**Synchronous execution blocks everything:**

When you run a long task synchronously, the entire session freezes until completion. If a test suite takes 5 minutes, you wait 5 minutes before you can do anything else. The user sees no progress and cannot interact with the system.

**Better with background execution:**

Start the long task in the background, which returns control immediately. While the task runs, you can explain code, review documentation, or work on completely different problems. When the task completes, you receive results and can act on them.

---

### Background Task Mechanics

**Starting a background task:**
- Command executes in the background
- Returns a shell identifier immediately
- Agent is free to do other work instantly
- No blocking occurs during task startup

**Checking progress:**
- Query the background task using its identifier
- Get current status and any output produced so far
- This check operation blocks briefly while fetching status
- Can check as frequently or infrequently as needed

**Key insight:**
- ✅ **Starting** background task = instant, non-blocking
- ❌ **Checking** status = synchronous, blocks temporarily

---

### When to Use Background Execution

**✅ Use background for:**
- Long-running tests (more than 30 seconds)
- Package installations
- Build processes
- Database migrations
- Large file downloads
- Container operations
- Comprehensive linting or code analysis

**❌ Don't use background for:**
- Quick commands (less than 2 seconds)
- Commands requiring immediate results for next step
- Interactive commands requiring user input
- Commands that typically fail fast

**Rule of thumb:** If a task takes more than 5 seconds, consider background execution.

---

### Parallel Background Execution

**Pattern: Start all tasks, then check results**

Start multiple independent background tasks in rapid succession. All tasks run simultaneously. While they execute, perform other useful work like code review, documentation updates, or user communication. Eventually check all results and synthesize findings.

**Productivity gain:** Sequential execution of three 5-minute tasks takes 15 minutes. Parallel execution takes 5 minutes plus the ability to accomplish other work during that time.

**Example workflow:**
1. Start unit tests in background
2. Start integration tests in background
3. Start production build in background
4. All three now running simultaneously
5. Review code or analyze logs while waiting
6. Check all three results when appropriate
7. Report combined findings

---

## Context Management

### The Challenge

AI assistants have finite context windows. Every tool call, file read, and response consumes tokens from this limited budget. As sessions grow longer and more complex, you can exhaust available context.

**Problem scenario:**
- Session starts with zero tokens used
- Read 50 files: 100,000 tokens consumed
- Run exploratory agent: 20,000 more tokens
- Read additional files: 30,000 more tokens
- Context window full, cannot continue

### Strategy 1: Progressive Context Loading

**Don't load everything upfront:**

Rather than reading all potentially relevant files at session start, load only what you need for the immediate task. Start with entry points and high-level structure. Load details only when you need to work with specific components.

**Use exploration agents wisely:**

Instead of searching an entire codebase and loading thousands of lines of results into context, use a lightweight exploration agent. The agent searches, analyzes, and returns only a concise summary. You load full details only for the specific files that matter.

---

### Strategy 2: Artifact Files

**Problem:** Need to track state across long sessions or between sessions

**Solution:** Write state to files

Save session state, progress, blockers, and next steps to persistent files. At session start, read the state file to understand where you left off. Before ending, update the file with current progress. This creates continuity without consuming context window with history.

**Benefits:**
- Context persists across sessions
- Multiple agents can coordinate through shared state files
- Users can resume work without re-explaining context
- State files are small, consuming minimal tokens

---

### Strategy 3: Reference Files Over Inline Content

**Problem:** Repeating the same information wastes tokens

**Inefficient approach:**
Load all 20 API endpoint files into context to apply the same change to each. Context window fills with repetitive code.

**Better approach:**
Use exploration agent to list all 20 endpoints. Edit them one at a time, loading only one file into context at any moment. Total token usage dramatically lower.

**Even better with file-based instructions:**
Write comprehensive instructions to a task file. Future agents or sessions read the instruction file for clear direction without re-explaining through conversation.

---

### Strategy 4: Compress Context with Summaries

**After complex analysis:**

Write a summary document capturing key findings, priorities, and details. Include references to full analysis in git history or other permanent storage. Future sessions read the concise summary rather than re-analyzing the entire codebase.

**Benefits:**
- Compress extensive analysis into digestible format
- Quick reference for future work
- Enables long-term memory without context bloat

---

## Long-Running Tasks

### Pattern 1: Background Task with Periodic Checks

**Problem:** Task takes 2-5 minutes, blocking is wasteful

**Solution:**
1. Start task in background
2. Perform other valuable work (documentation review, code analysis, user communication)
3. Periodically check task status
4. Continue other work between checks
5. When task completes, analyze results and act accordingly

**Benefits:**
- Productive during wait times
- User sees continuous activity rather than idle periods
- Can pivot if issues emerge during execution

---

### Pattern 2: Chained Background Tasks

**Problem:** Multiple dependent tasks, each long-running

**Solution:**
1. Start first task in background
2. Do other work while it runs
3. Periodically check until completion
4. Once complete, start second dependent task
5. Continue pattern for entire chain
6. Maximize productivity between chain links

**Benefits:**
- Maximum parallelism where dependencies allow
- Sequential where dependencies require it
- Productive throughout entire workflow
- Clear progress visible to user

---

### Pattern 3: Fire-and-Forget with Callback

**Problem:** Task takes 10+ minutes, far too long to wait

**Solution:** Use a script that writes completion status to a file

**Workflow:**
1. Start very long task in background with callback mechanism
2. Script writes completion marker to file when done
3. Inform user about expected duration and status file location
4. Move on to completely different work
5. User or future session checks status file to see completion
6. Resume dependent work only after verification

**Benefits:**
- No waiting for extremely long tasks
- Clear completion tracking
- User can check status independently
- Enables truly asynchronous workflows

---

## Remote Machine Workflows

### Pattern: Proxy Script for Remote Execution

**Problem:** Need to run commands on remote servers, but direct SSH access isn't available or practical

**Solution 1: SSH-based Background Execution**

Create a script that establishes SSH connection, executes remote commands, and reports completion. Run the script in background mode. The script handles all remote interactions while you continue other work.

**Solution 2: API-based Remote Control**

Trigger remote jobs through API calls. Script polls API for job completion status. When job finishes, script completes with final status. Entire process runs in background while you work on other tasks.

**Solution 3: WebSocket/Webhook Callback**

Remote system executes long-running job. Upon completion, remote system sends notification via webhook. Webhook handler writes result to file accessible to agent. Agent periodically checks for result file appearance.

---

### Pattern: Download to Remote, Process, Sync Back

**Problem:** Need to download large file, but local environment is ephemeral or has limited storage

**Solution:**
1. Download file directly to persistent remote server (fast datacenter connection)
2. Process data on remote server (persistent storage, powerful resources)
3. Sync only results back to local environment
4. Local environment doesn't fill up with intermediate data

**Benefits:**
- Remote server has persistent storage
- Fast datacenter-to-datacenter transfers
- Local environment remains clean
- Results available when needed without full dataset

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

**Use specialized agents for:**

1. **Open-ended exploration**
   - Analyze patterns across large codebase
   - Agent explores and adapts to discoveries
   - Handles unexpected code structures gracefully

2. **Complex analysis requiring judgment**
   - Review security of authentication system
   - Check for common vulnerabilities
   - Suggest context-appropriate improvements
   - Requires understanding nuances

3. **Multi-step workflows with decision points**
   - Find all TODO comments in codebase
   - Categorize by priority based on context
   - Create issues for high-priority items
   - Requires understanding importance of each TODO

**Benefits:**
- Handles unexpected situations intelligently
- Provides nuanced analysis beyond pattern matching
- Can make judgment calls based on context
- Adapts strategy based on findings

**Drawbacks:**
- Slower (requires AI reasoning time)
- Uses more tokens
- Less predictable than deterministic scripts
- May vary between runs

---

### When to Use Scripts

**Use background scripts for:**

1. **Well-defined workflows**
   - Run complete test suite (unit, integration, end-to-end)
   - Generate coverage reports
   - Predetermined sequence of steps

2. **Performance-critical operations**
   - Fast execution without AI overhead
   - Production builds requiring speed
   - Time-sensitive deployments

3. **Consistent, repeatable tasks**
   - Linting and formatting
   - Same result every execution
   - Deterministic outcomes required

**Benefits:**
- Fast execution (no reasoning overhead)
- Predictable, consistent results
- Low token usage
- Can be tested independently
- Easy to debug and verify

**Drawbacks:**
- Inflexible (cannot adapt to unexpected situations)
- Requires maintenance when requirements change
- Limited error handling for edge cases
- Cannot make judgment calls

---

### When to Use Webhooks

**Use webhooks for:**

1. **Long-running remote jobs**
   - Trigger remote build on CI/CD system
   - Webhook notifies when complete
   - Agent receives notification asynchronously
   - No polling required

2. **External system integration**
   - User pushes code triggers GitHub webhook
   - Webhook triggers agent session automatically
   - Agent reviews pull request
   - Posts results back to GitHub

3. **Async task queues**
   - Agent adds task to queue
   - Worker processes task (minutes or hours later)
   - Worker writes result to shared location
   - Agent checks result in future session

**Benefits:**
- True asynchronicity (no polling)
- Efficient (notified only when needed)
- Integrates with external systems naturally
- Scalable to many concurrent operations
- Low resource overhead

**Drawbacks:**
- Complex setup and infrastructure
- Requires external services
- Debugging more difficult
- Security considerations (authentication, authorization)
- Network reliability concerns

---

### Hybrid Approach Example

**Scenario:** Deploy to production (complex and risky)

**Step 1: Use Agent for Pre-Deploy Analysis**
- Review all changes since last deployment
- Identify potential risks based on code understanding
- Check test passage and coverage
- Verify database migrations are safe
- Agent returns risk assessment with recommendations

**Step 2: Use Script for Actual Deployment**
- Deterministic deploy steps (well-defined)
- Run build, run migrations, restart services
- Fast execution without reasoning overhead
- Consistent process every time

**Step 3: Use Webhook for Long-Running Smoke Tests**
- Deployment script triggers external smoke test suite
- Smoke tests run on staging environment (10+ minutes)
- Smoke test service posts results to webhook when complete
- Agent checks results file asynchronously

**Step 4: Use Agent for Post-Deploy Verification**
- Check error logs for anomalies
- Verify key endpoints are responding correctly
- Analyze performance metrics vs baseline
- Requires judgment and context awareness

**Why hybrid works:**
- Each component uses appropriate tool for its nature
- Agent handles complexity and judgment
- Script handles deterministic execution
- Webhook handles long-running external processes
- Combined approach is more robust than any single method

---

## Multi-Workflow Orchestration

### Pattern: Parallel Workflows with Coordination

**Scenario:** Build frontend and backend simultaneously

**Workflow:**
1. Start frontend build in background
2. Start backend build in background (now both running in parallel)
3. Perform other valuable work (security review, configuration audit)
4. Check frontend build status
5. Check backend build status
6. Once both complete, start integration step (Docker compose, etc.)
7. Report combined results

**Benefits:**
- Parallelizes independent work
- Maintains productivity during builds
- Clear coordination point (both must complete)
- Visible progress throughout

---

### Pattern: Workflow Branching

**Scenario:** Different workflows based on current state

**Workflow:**
1. Check current state (uncommitted changes? clean working directory?)
2. Branch A if changes exist:
   - Review uncommitted changes
   - Create appropriate commit
   - Run tests on new commit
3. Branch B if no changes:
   - Pull latest from remote
   - Run tests on latest code
4. Both branches converge: Deploy if tests pass

**Benefits:**
- Adaptive based on actual state
- Handles different scenarios appropriately
- Clear convergence point
- Prevents invalid states

---

### Pattern: Workflow Checkpoints

**Scenario:** Long workflow that might be interrupted

**Workflow:**
1. Execute step 1 (install dependencies)
2. Write checkpoint file indicating completion
3. Execute step 2 (build project)
4. Write checkpoint file indicating completion
5. Execute step 3 (run tests)
6. Write checkpoint file indicating completion

**If session interrupted:**
1. Next session reads checkpoint files
2. Skip completed steps
3. Resume from first incomplete checkpoint
4. No wasted effort repeating work

**Benefits:**
- Resumable workflows
- Survives interruptions
- Clear progress tracking
- Efficient use of time

---

## Waiting Strategies

### Strategy 1: Tell User to Come Back

**When:** Task takes 10+ minutes

**Approach:**
- Start task in background
- Inform user about expected duration (be specific)
- Tell user how to check status independently
- Suggest what user can do in the meantime
- Move on to other tasks or end session

**Pros:**
- ✅ Honest about timing expectations
- ✅ User can do other things productively
- ✅ Clear communication about status check method
- ✅ Avoids artificial waiting

**Cons:**
- ❌ Requires user to remember to check back
- ❌ Breaks conversation flow and continuity
- ❌ User might forget and lose context

---

### Strategy 2: Do Other Work in Meantime

**When:** Task takes 2-5 minutes

**Approach:**
- Start task in background
- Immediately begin different valuable work
- Review documentation, analyze code, or explain concepts
- Work completes naturally around same time as background task
- Check background task status when ready
- May still need to wait briefly if task not done

**Pros:**
- ✅ Productive use of waiting time
- ✅ User sees continuous progress
- ✅ Natural conversation flow maintained
- ✅ Time passes quickly for user

**Cons:**
- ❌ Limited to work independent of background task
- ❌ May still end up waiting if timing doesn't align
- ❌ Need to context-switch between tasks

---

### Strategy 3: Progressive Checks with User Engagement

**When:** Task takes 3-10 minutes, user is actively engaged

**Approach:**
- Start task in background
- Ask user preference for updates (frequent, occasional, or final only)
- If frequent updates requested:
  - User prompts periodically
  - Check and report progress (45 of 150 tests complete)
  - Continue pattern until completion
- Shows incremental progress and keeps user engaged

**Pros:**
- ✅ User stays informed throughout process
- ✅ Can catch failures early and abort
- ✅ Feels responsive and interactive
- ✅ User has control over update frequency

**Cons:**
- ❌ Requires user to actively prompt for updates
- ❌ Each status check blocks briefly
- ❌ Can be tedious for very long tasks

---

### Strategy 4: Monitoring Script with Live Output

**When:** Want continuous visibility into progress

**Approach:**
Create a wrapper script that:
- Runs the actual task
- Simultaneously monitors output for progress indicators
- Periodically reports progress summary
- Agent checks script output to see progress updates

**Benefits:**
- Continuous progress visibility
- No need for manual status checks
- Can see rate of progress
- User knows system is actively working

**Drawbacks:**
- Requires creating monitoring script
- More complex than simple background execution
- May impact task performance slightly

---

### Strategy 5: State Machine for Complex Waits

**When:** Multiple dependent long tasks in sequence

**Approach:**
- Define state file tracking current stage
- Read state file to determine what to do
- Execute appropriate action for current state
- Update state file when stage completes
- Transition to next state
- Repeat until all stages complete

**Workflow example:**
1. Read state: "installing"
2. Check if install complete
3. If yes: start build, update state to "building"
4. If no: continue waiting or do other work
5. Eventually read state: "building"
6. Check if build complete
7. Continue pattern...

**Benefits:**
- Resumable across sessions
- Clear state tracking at all times
- Can pause and resume easily
- Multiple agents can coordinate via state file
- Handles interruptions gracefully

**Drawbacks:**
- More complex than simple workflows
- Requires state file management
- Need to handle state transitions carefully

---

## Advanced Patterns

### Pattern: Speculative Execution

**Concept:** Start likely-needed work before user confirms

**Example scenario:**
- User mentions "thinking about deploying to staging"
- Speculatively start staging build in background (likely needed)
- Continue discussion with user
- Ask for confirmation on deployment
- If user confirms: build likely already complete, deploy immediately
- If user declines: kill background build, minimal waste

**Benefits:**
- Saves time by working ahead
- User perceives instant responsiveness
- Reduces apparent latency
- Shows initiative

**Risks:**
- Wasted effort if user says no
- Could consume resources unnecessarily
- Be conservative with expensive or risky operations
- Only speculate on safe, reversible operations

**Best practices:**
- Only speculate on fast, cheap operations
- Inform user about speculation
- Easy to cancel if wrong
- Don't speculate on irreversible operations

---

### Pattern: Fan-out / Fan-in

**Concept:** Parallel execution of similar tasks, then combine results

**Example workflow:**
1. **Fan-out:** Start 5 security review agents in parallel
   - Agent 1: Review authentication module
   - Agent 2: Review API endpoints
   - Agent 3: Review database layer
   - Agent 4: Review frontend code
   - Agent 5: Review infrastructure configs
2. All 5 run simultaneously, each analyzing different module
3. **Fan-in:** Collect all results when complete
4. Synthesize findings across all modules
5. Create prioritized list of issues from all sources
6. Report comprehensive security assessment

**Benefits:**
- Massive parallelization of similar work
- Much faster than sequential analysis
- Comprehensive coverage
- Natural synthesis point
- Clear structure

**Use cases:**
- Security audits across modules
- Performance analysis of different services
- Testing multiple configurations
- Research across multiple sources
- Any divide-and-conquer problem

---

### Pattern: Pipeline with Early Exit

**Concept:** Stop pipeline immediately if any stage fails

**Example workflow:**
1. **Stage 1:** Run linting
   - If fails: Report errors, stop pipeline
   - If passes: Continue
2. **Stage 2:** Run type checking
   - If fails: Report errors, stop pipeline
   - If passes: Continue
3. **Stage 3:** Run tests
   - If fails: Report errors, stop pipeline
   - If passes: Continue
4. **Stage 4:** Deploy
   - Only reached if all previous stages passed

**Benefits:**
- Fail fast on quality issues
- Don't waste time on later stages if early ones fail
- Clear quality gates
- Prevents bad code from progressing
- Easy to identify which stage failed

**Use cases:**
- CI/CD pipelines
- Quality assurance workflows
- Progressive validation
- Build processes with dependencies

---

### Pattern: Watchdog for Hung Processes

**Concept:** Automatically kill tasks that exceed time limits

**Approach:**
- Start the actual task
- Start a timeout timer in parallel
- Wait for either to complete
- If task finishes first: success, kill timer
- If timer finishes first: task hung, kill task, report failure

**Benefits:**
- Prevents infinite hangs
- Ensures resources aren't wasted
- Clear timeout policy
- Automatic cleanup
- Fails explicitly rather than hanging

**Use cases:**
- Tasks prone to hanging
- Operations with clear time expectations
- Resource-constrained environments
- Automated systems needing reliability

---

### Pattern: Retry with Exponential Backoff

**Concept:** Retry failed operations with increasing delays

**Approach:**
1. Attempt operation (e.g., run flaky test suite)
2. If succeeds: done
3. If fails:
   - Attempt 1 failed: wait 2 seconds, retry
   - Attempt 2 failed: wait 4 seconds, retry
   - Attempt 3 failed: wait 8 seconds, retry
   - All attempts failed: report final failure

**Benefits:**
- Handles transient failures gracefully
- Increasing delays avoid overwhelming failing systems
- Clear attempt limit prevents infinite loops
- Common pattern for network operations
- Increases success rate for flaky operations

**Use cases:**
- Flaky tests
- Network operations
- External API calls
- Resource contention scenarios
- Eventual consistency systems

---

## Best Practices Summary

### Do's

✅ **Start long tasks in background**
- Enables parallelism and productivity during waits

✅ **Do other work while waiting**
- Maximize productivity, keep user engaged

✅ **Write state to files for persistence**
- Enables cross-session continuity and multi-agent coordination

✅ **Use exploration agents to save context**
- Agents summarize rather than loading everything into context

✅ **Check background tasks periodically, not constantly**
- Balance responsiveness with efficiency

✅ **Provide user with time estimates**
- Set clear expectations, enable user planning

✅ **Use scripts for deterministic workflows**
- Fast, reliable, consistent execution

✅ **Handle failures gracefully**
- Clear error messages, recovery paths, explicit failures

---

### Don'ts

❌ **Don't use background for quick tasks (<2 seconds)**
- Overhead not worth it, just run synchronously

❌ **Don't check status immediately after starting**
- Task hasn't had time to produce meaningful output

❌ **Don't check multiple outputs in rapid sequence**
- Blocks repeatedly, defeats purpose of background execution

❌ **Don't keep all files in context unnecessarily**
- Context window is finite and precious

❌ **Don't rely on conversation for multi-session state**
- Conversation doesn't persist, use files

❌ **Don't start tasks you don't plan to wait for**
- Waste of resources, creates zombie processes

❌ **Don't ignore timeout risks**
- Tasks can hang indefinitely, need safeguards

---

## Key Takeaways

### Fundamental Principles

1. **Background execution enables parallelism**
   - Start long tasks and continue working
   - Multiple tasks can run simultaneously
   - Dramatically improves productivity

2. **Context management is critical**
   - Finite context window requires discipline
   - Load what you need, when you need it
   - Use files for persistence, not conversation

3. **Choose the right tool for the job**
   - Agents for complexity and judgment
   - Scripts for deterministic workflows
   - Webhooks for external integrations

4. **User communication matters**
   - Set clear expectations about timing
   - Provide progress updates appropriately
   - Offer status checking mechanisms

5. **State persistence enables coordination**
   - Files persist across sessions
   - Multiple agents coordinate via shared files
   - Workflows can resume after interruptions

### Advanced Concepts

1. **Workflows can be orchestrated**
   - Parallel execution where independent
   - Sequential where dependent
   - Clear coordination points

2. **Speculation can reduce latency**
   - Start likely-needed work proactively
   - User perceives instant responsiveness
   - Be conservative with risky operations

3. **Monitoring and timeouts prevent hangs**
   - Watchdog patterns catch hung processes
   - Progress monitoring shows system is working
   - Explicit timeouts prevent infinite waits

4. **Retry patterns handle transience**
   - Exponential backoff for flaky operations
   - Increases success rate
   - Clear limits prevent infinite loops

5. **Hybrid approaches often best**
   - Combine agents, scripts, and webhooks
   - Use each where it excels
   - More robust than single-method approach

---

**See also:**
- CLAUDE_CODE_COMPLETE_MANUAL.md (concepts)
- SKILLS_ADVANCED_GUIDE.md (concepts)
- NONSTANDARD_USES.md (concepts)

---

*End of Async Workflows Concepts Guide. Last updated: 2025-11-09*
