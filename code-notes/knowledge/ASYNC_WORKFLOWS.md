# Async Workflows & Advanced Multitasking

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

**Synchronous execution blocks everything:**
```
User: "Run tests"
Claude: Bash("npm test")  # Blocks for 5 minutes
User: ... waits ...
User: ... still waiting ...
User: ... finally gets response after 5 min
```

**Better with background:**
```
User: "Run tests"
Claude: Bash("npm test", run_in_background=true)  # Returns instantly
Claude: "Tests running! Meanwhile, what else can I help with?"
User: "Explain the auth code"
Claude: Read(auth.py) → Explains code
... 3 minutes later ...
System: Background task completed
Claude: "Tests finished! 148/150 passed, 2 failures in auth module."
```

---

### Background Bash Mechanics

**Starting background task:**
```python
Bash(command="npm test", run_in_background=true)
→ Returns: { shell_id: "abc123" }
→ Claude is FREE immediately
```

**Checking progress:**
```python
BashOutput(bash_id="abc123")
→ Returns: { status: "running", stdout: "..." }
→ This check BLOCKS briefly
```

**Key insight:**
- ✅ **Starting** background task = instant, non-blocking
- ❌ **Checking** with BashOutput = synchronous, blocks

---

### When to Use Background

**✅ Use background for:**
- Long-running tests (>30 seconds)
- Package installations (npm install, pip install)
- Builds (cargo build, webpack build)
- Database migrations
- Large file downloads
- Docker operations
- Comprehensive linting

**❌ Don't use background for:**
- Quick commands (<2 seconds)
- Commands you need results from immediately
- Interactive commands
- Commands that fail fast

**Rule of thumb:** If it takes >5 seconds, consider background.

---

### Parallel Background Execution

**Pattern: Start all, then check:**
```python
# Start all 3 in one message (instant)
Bash("npm run test:unit", run_in_background=true)     # 2 min
Bash("npm run test:integration", run_in_background=true)  # 5 min
Bash("npm run build", run_in_background=true)         # 3 min

# Continue conversation immediately
"All tasks started! Working on code review while they run..."

# Read code, analyze, discuss with user
# ... 5 minutes of productive work ...

# Eventually check results
BashOutput(shell_id_1)  # Check tests
BashOutput(shell_id_2)  # Check integration
BashOutput(shell_id_3)  # Check build
```

**Productivity gain:** 10 minutes of sequential work → 5 minutes parallel + ability to do other work during.

---

## Context Management

### The Challenge

Claude has a context window. Every tool call, every file read, every response consumes tokens.

**Problem:**
```
Session starts: 0 tokens used
Read 50 files: 100K tokens used
Run agent: +20K tokens
Read more files: +30K tokens
Context full! Can't continue.
```

### Strategy 1: Progressive Context Loading

**Don't load everything upfront:**
```markdown
# Bad: Load all files immediately
Read(file1.py)
Read(file2.py)
Read(file3.py)
... Read(file50.py)

# Good: Load what you need when you need it
Read(main.py)  # Start with entry point
# Understand structure
# Only read imports as needed
```

**Use Task agents for exploration:**
```python
# Bad: Grep entire codebase, load all results
Grep(pattern="function.*auth", output_mode="content")
→ Returns 10,000 lines → Context explosion

# Good: Use Explore agent
Task(
  subagent_type="Explore",
  prompt="Find authentication-related code, summarize key files",
  model="haiku"
)
→ Agent explores, returns concise summary
→ You only load what matters
```

---

### Strategy 2: Artifact Files

**Problem:** Need to track state across long sessions

**Solution:** Write state to files

```markdown
# Session Start
Read(.claude/session-state.json)
{
  "completed_tasks": ["setup-db", "create-models"],
  "current_focus": "api-endpoints",
  "blockers": ["need-api-key"],
  "next_steps": ["implement-auth", "write-tests"]
}

# Do work
...

# Before ending
Write(.claude/session-state.json)
{
  "completed_tasks": ["setup-db", "create-models", "api-endpoints"],
  "current_focus": "testing",
  "blockers": [],
  "next_steps": ["implement-auth", "write-tests", "deploy"]
}
```

**Benefits:**
- Context persists across sessions
- Other agents can pick up where you left off
- User can resume without re-explaining

---

### Strategy 3: Reference Files Over Inline Content

**Problem:** Repeating same information wastes tokens

**Bad:**
```
User: "Add error handling to all API endpoints"
Claude reads all 20 endpoint files into context
Claude suggests changes for endpoint 1
User: "Good, do the same for the rest"
Claude: Already has all files in context ✓
BUT: Used 50K tokens to keep them loaded
```

**Better:**
```
User: "Add error handling to all API endpoints"
Claude: Task(Explore, "Find all API endpoints")
Agent returns: List of 20 endpoints
Claude: Edit(endpoint1.py) # Only load one at a time
Claude: Edit(endpoint2.py)
... etc ...
Total tokens: Much lower
```

**Even better with file-based instructions:**
```
Write(.claude/tasks/add-error-handling.md)
"Add try-catch blocks to all endpoints in:
- auth.py
- users.py
- posts.py
..."

# Next session or agent:
Read(.claude/tasks/add-error-handling.md)
# Clear instructions without re-explaining
```

---

### Strategy 4: Compress Context with Summaries

**After complex analysis:**
```
Write(.claude/analysis/security-review.md)
"# Security Review Summary

## Findings
1. SQL injection risk in user search (users.py:45)
2. Missing auth check in admin panel (admin.py:120)
3. Weak password policy (auth.py:67)

## Priority
1. Fix SQL injection (CRITICAL)
2. Add auth check (HIGH)
3. Strengthen passwords (MEDIUM)

## Details
See full analysis in git commit message"
```

**Future sessions:**
```
Read(.claude/analysis/security-review.md)
# Get summary without re-analyzing entire codebase
```

---

## Long-Running Tasks

### Pattern 1: Background Task with Periodic Checks

**Problem:** Task takes 2-5 minutes, don't want to block

**Solution:**
```python
# Start task
Bash("npm run build:production", run_in_background=true)
# → shell_id: "abc123"

# Do other work
Read(README.md)
"Let me review your README while build runs..."

# Check periodically
BashOutput("abc123")
# → status: "running", partial output visible

# Continue other work
Write(CONTRIBUTING.md)

# Eventually complete
BashOutput("abc123")
# → status: "completed", full output
```

**Benefits:**
- Productive during waits
- User doesn't see idle time
- Can pivot if issues arise

---

### Pattern 2: Chained Background Tasks

**Problem:** Multiple dependent tasks, each long-running

**Solution:**
```python
# Task 1: Install dependencies
Bash("npm install", run_in_background=true)
# → shell_id_1

# Wait for completion (check occasionally)
BashOutput(shell_id_1)
# → status: "running", stdout shows progress

# ... do other work ...

# Once Task 1 completes:
BashOutput(shell_id_1)
# → status: "completed"

# Task 2: Build
Bash("npm run build", run_in_background=true)
# → shell_id_2

# ... do other work ...

# Once Task 2 completes:
BashOutput(shell_id_2)
# → status: "completed"

# Task 3: Tests
Bash("npm test", run_in_background=true)
# → shell_id_3
```

**Benefits:**
- Maximum parallelism where possible
- Sequential where dependencies exist
- Productive throughout

---

### Pattern 3: Fire-and-Forget with Callback Script

**Problem:** Task takes 10+ minutes, way too long to wait

**Solution:** Use script that notifies when done

```bash
# .claude/scripts/long-task-with-callback.sh
#!/bin/bash

# Run long task
npm run very-long-build

# Write completion marker
echo "COMPLETED at $(date)" > .claude/task-status/build.txt
echo "Exit code: $?" >> .claude/task-status/build.txt
```

**Workflow:**
```python
# Start long task
Bash(".claude/scripts/long-task-with-callback.sh", run_in_background=true)

# Tell user
"Build started in background. Will take ~15 minutes.
I've moved on to other tasks. Check .claude/task-status/build.txt
later to see when it completes."

# Do completely different work
# User can check status file themselves
# Or ask Claude to check in next session
```

---

## Remote Machine Workflows

### Pattern: Proxy Script for Remote Execution

**Problem:** Need to run commands on remote VPS, but Claude can't SSH directly

**Solution 1: SSH + Background**
```bash
# .claude/scripts/remote-deploy.sh
#!/bin/bash

ssh user@remote-vps << 'ENDSSH'
  cd /app
  git pull
  npm install
  pm2 restart app
ENDSSH

echo "Remote deployment complete"
```

**Usage:**
```python
Bash(".claude/scripts/remote-deploy.sh", run_in_background=true)
# Runs entirely in background
# Check completion with BashOutput
```

---

**Solution 2: API-based Remote Control**

```bash
# .claude/scripts/trigger-remote-job.sh
#!/bin/bash

# Trigger job via API
RESPONSE=$(curl -X POST https://your-vps.com/api/deploy \
  -H "Authorization: Bearer $API_TOKEN" \
  -d '{"action": "deploy", "branch": "main"}')

JOB_ID=$(echo $RESPONSE | jq -r '.job_id')
echo "Job started: $JOB_ID"

# Poll for completion
while true; do
  STATUS=$(curl -s https://your-vps.com/api/jobs/$JOB_ID \
    -H "Authorization: Bearer $API_TOKEN" | jq -r '.status')

  if [ "$STATUS" = "completed" ]; then
    echo "Job completed successfully!"
    break
  elif [ "$STATUS" = "failed" ]; then
    echo "Job failed!"
    exit 1
  fi

  sleep 5
done
```

**Usage:**
```python
Bash(".claude/scripts/trigger-remote-job.sh", run_in_background=true)
# Script handles polling
# Claude can do other work
# BashOutput eventually shows completion
```

---

**Solution 3: WebSocket/Webhook Callback**

**Remote VPS:**
```javascript
// When job completes, POST to webhook
fetch('https://your-proxy.com/claude-webhook', {
  method: 'POST',
  body: JSON.stringify({
    job_id: '12345',
    status: 'completed',
    result: '...'
  })
});
```

**Proxy receives and writes to file:**
```javascript
// Webhook handler
app.post('/claude-webhook', (req, res) => {
  const { job_id, status, result } = req.body;

  // Write to file Claude can access
  fs.writeFileSync(
    `/shared/jobs/${job_id}.json`,
    JSON.stringify({ status, result })
  );

  res.json({ ok: true });
});
```

**Claude checks file:**
```python
# After starting remote job
"Job started remotely. I'll check for completion..."

# Periodically:
Bash("cat /shared/jobs/12345.json 2>/dev/null || echo 'not ready'")
# When file appears → Job done
```

---

### Pattern: Download to Remote, Sync to Local

**Problem:** Need to download large file, but Claude's environment is ephemeral

**Solution:**
```bash
# .claude/scripts/download-and-sync.sh
#!/bin/bash

# Download to persistent VPS
ssh user@vps "cd /storage && wget https://large-file.com/data.zip"

# Process on VPS
ssh user@vps "cd /storage && unzip data.zip && ./process-data.sh"

# Sync results back
scp user@vps:/storage/processed-data.csv ./data/

echo "Data downloaded, processed on VPS, results synced locally"
```

**Benefits:**
- VPS has persistent storage
- Fast datacenter connection for download
- Claude environment doesn't fill up
- Results available locally when needed

---

## Subagents vs Scripts vs Webhooks

### Comparison Matrix

| Approach | Startup Time | Flexibility | Consistency | Maintenance | Best For |
|----------|--------------|-------------|-------------|-------------|----------|
| **Subagents** (Task tool) | Slow (AI reasoning) | High (adapts to context) | Medium (AI variability) | Low | Complex analysis, exploration |
| **Scripts** (Bash background) | Fast (direct execution) | Low (fixed logic) | High (deterministic) | Medium | Well-defined workflows |
| **Webhooks** (External triggers) | Very Fast | Medium (predefined hooks) | High | High | Remote/async operations |

---

### When to Use Subagents

**Use Task agents for:**

1. **Open-ended exploration**
   ```python
   Task(
     subagent_type="Explore",
     prompt="Analyze error handling patterns across the codebase"
   )
   # Agent explores, adapts to what it finds
   ```

2. **Complex analysis**
   ```python
   Task(
     subagent_type="general-purpose",
     prompt="Review security of authentication system,
             check for common vulnerabilities, suggest improvements"
   )
   # Requires judgment and context
   ```

3. **Multi-step workflows with decision points**
   ```python
   Task(
     subagent_type="general-purpose",
     prompt="Find all TODO comments, categorize by priority,
             create GitHub issues for high-priority ones"
   )
   # Requires understanding context of TODOs
   ```

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
   ```bash
   # .claude/scripts/run-full-test-suite.sh
   npm run test:unit &&
   npm run test:integration &&
   npm run test:e2e &&
   npm run coverage
   ```

2. **Performance-critical operations**
   ```bash
   # Fast, no AI overhead
   ./scripts/build-production.sh
   ```

3. **Consistent, repeatable tasks**
   ```bash
   # Same result every time
   ./scripts/lint-and-format.sh
   ```

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
   ```
   Trigger remote build on CI/CD
   Webhook notifies when complete
   Claude receives notification via file/API
   ```

2. **External system integration**
   ```
   User pushes code → GitHub webhook
   → Triggers Claude session via API
   → Claude reviews PR automatically
   ```

3. **Async task queues**
   ```
   Claude adds task to queue
   Worker processes task (minutes/hours)
   Worker writes result to file
   Claude checks file in next session
   ```

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

```python
# 1. Use Agent for pre-deploy analysis
Task(
  subagent_type="general-purpose",
  prompt="Review all changes since last deploy,
          identify potential risks, check if tests pass,
          verify migrations are safe"
)
# Agent returns risk assessment

# 2. Use Script for actual deployment
Bash(".claude/scripts/deploy-production.sh", run_in_background=true)
# Script handles deterministic deploy steps

# 3. Use Webhook for long-running smoke tests
# Deployment script triggers external smoke tests
# Smoke test service POSTs results to webhook
# Claude checks results file

# 4. Use Agent for post-deploy verification
Task(
  subagent_type="general-purpose",
  prompt="Check error logs, verify key endpoints,
          analyze performance metrics"
)
```

**Why hybrid:**
- Agent: Analysis requires judgment
- Script: Deploy steps are well-defined
- Webhook: Smoke tests run externally
- Agent: Verification needs context

---

## Multi-Workflow Orchestration

### Pattern: Parallel Workflows with Coordination

**Scenario:** Build frontend + backend simultaneously

```python
# Start both builds
Bash("cd frontend && npm run build", run_in_background=true)
# → shell_id_frontend

Bash("cd backend && npm run build", run_in_background=true)
# → shell_id_backend

# Do other work while building
Task(
  subagent_type="Explore",
  prompt="Find all configuration files, check for sensitive data"
)

# Check frontend build
BashOutput(shell_id_frontend)
# → If completed: "Frontend built successfully"

# Check backend build
BashOutput(shell_id_backend)
# → If completed: "Backend built successfully"

# Both done → Start integration
Bash("docker-compose up --build", run_in_background=true)
```

---

### Pattern: Workflow Branching

**Scenario:** Different workflows based on conditions

```python
# Check current state
Bash("git status")
# → Has uncommitted changes

# Branch A: If changes exist
if has_changes:
  Task(
    subagent_type="general-purpose",
    prompt="Review uncommitted changes, create appropriate commit"
  )
  # Then run tests
  Bash("npm test", run_in_background=true)

# Branch B: If no changes
else:
  # Pull latest
  Bash("git pull")
  # Run tests on latest
  Bash("npm test", run_in_background=true)

# Both branches converge: Deploy if tests pass
```

---

### Pattern: Workflow Checkpoints

**Scenario:** Long workflow with save points

```python
# Checkpoint 1: Dependencies
Bash("npm install", run_in_background=true)
# ... wait for completion ...
Write(".claude/checkpoints/dependencies.txt", "COMPLETED")

# Checkpoint 2: Build
Bash("npm run build", run_in_background=true)
# ... wait for completion ...
Write(".claude/checkpoints/build.txt", "COMPLETED")

# Checkpoint 3: Tests
Bash("npm test", run_in_background=true)
# ... wait for completion ...
Write(".claude/checkpoints/tests.txt", "COMPLETED")

# If session interrupted, next time:
Read(".claude/checkpoints/dependencies.txt")  # Completed ✓
Read(".claude/checkpoints/build.txt")         # Completed ✓
Read(".claude/checkpoints/tests.txt")         # Not found ✗
# → Resume from tests
```

---

## Waiting Strategies

### Strategy 1: Tell User to Come Back

**When:** Task takes 10+ minutes

```python
Bash("./scripts/very-long-build.sh", run_in_background=true)

"Build started! This will take approximately 15 minutes.
I've started it in the background.

You can:
1. Come back in 15 minutes and ask me 'What's the build status?'
2. Check .claude/task-status/build.txt yourself
3. Move on to other tasks - I'll have results when you return"
```

**Pros:**
- ✅ Honest about timing
- ✅ User can do other things
- ✅ Clear expectations

**Cons:**
- ❌ Requires user to remember
- ❌ Breaks conversation flow

---

### Strategy 2: Do Other Work in Meantime

**When:** Task takes 2-5 minutes

```python
Bash("npm run build", run_in_background=true)
# → shell_id

"Build started! While that runs (about 3 minutes),
let me review your documentation..."

Task(
  subagent_type="Explore",
  prompt="Review all markdown files, check for outdated info"
)

# Agent completes in ~1 minute
"Documentation looks good! Checking build status..."

BashOutput(shell_id)
# → May still be running or may be done
```

**Pros:**
- ✅ Productive use of time
- ✅ User sees continuous progress
- ✅ Natural conversation flow

**Cons:**
- ❌ Limited to independent tasks
- ❌ May still end up waiting

---

### Strategy 3: Progressive Checks with User Engagement

**When:** Task takes 3-10 minutes, user is engaged

```python
Bash("npm test", run_in_background=true)

"Tests running! This typically takes 5-7 minutes.
I can check progress periodically. Want me to:

1. Check every 30 seconds and update you
2. Do other work and check when you prompt me
3. Just let you know when complete

What's your preference?"

# If user chooses option 1:
# Check periodically, show progress
BashOutput(shell_id)
# → "Running... 45/150 tests complete"

# 30 seconds later (user prompts):
BashOutput(shell_id)
# → "Running... 89/150 tests complete"

# etc.
```

**Pros:**
- ✅ User stays informed
- ✅ Can catch failures early
- ✅ Feels responsive

**Cons:**
- ❌ Requires user prompting
- ❌ Each check blocks briefly

---

### Strategy 4: Monitoring Script with Live Output

**When:** Want continuous visibility

```bash
# .claude/scripts/test-with-monitoring.sh
#!/bin/bash

# Run tests with output to file
npm test 2>&1 | tee .claude/logs/test-output.txt &
TEST_PID=$!

# Monitor and provide updates
while kill -0 $TEST_PID 2>/dev/null; do
  PASS_COUNT=$(grep -c "PASS" .claude/logs/test-output.txt)
  FAIL_COUNT=$(grep -c "FAIL" .claude/logs/test-output.txt)
  echo "Progress: $PASS_COUNT passed, $FAIL_COUNT failed"
  sleep 10
done

echo "Tests complete!"
```

**Usage:**
```python
Bash(".claude/scripts/test-with-monitoring.sh", run_in_background=true)

# Check anytime:
BashOutput(shell_id)
# → See progress updates
```

---

### Strategy 5: State Machine for Complex Waits

**When:** Multiple dependent long tasks

```python
# State file: .claude/state/workflow.json
{
  "stage": "building",
  "stages_completed": ["install"],
  "current_task_id": "abc123"
}

# Check state
Read(".claude/state/workflow.json")

# Based on stage, take action:
if stage == "installing":
  BashOutput(current_task_id)
  if complete:
    # Move to next stage
    Bash("npm run build", run_in_background=true)
    Write(".claude/state/workflow.json", {"stage": "building", ...})

elif stage == "building":
  BashOutput(current_task_id)
  if complete:
    # Move to next stage
    Bash("npm test", run_in_background=true)
    Write(".claude/state/workflow.json", {"stage": "testing", ...})

# etc.
```

**Benefits:**
- Resumable across sessions
- Clear state tracking
- Can pause and resume

---

## Advanced Patterns

### Pattern: Speculative Execution

**Concept:** Start likely-needed work before user confirms

```python
User: "I'm thinking about deploying to staging"

# Speculatively start build
Bash("npm run build:staging", run_in_background=true)
# → shell_id_build

"I've started the staging build speculatively while we discuss.
Should we proceed with deployment?"

User: "Yes"

# Check build (likely done by now)
BashOutput(shell_id_build)
# → "Build complete!"

# Deploy immediately
Bash("./deploy staging", run_in_background=true)
```

**Benefits:**
- Saves time on confirmation
- User perceives instant action

**Risks:**
- Wasted work if user says no
- Be conservative with costly operations

---

### Pattern: Fan-out / Fan-in

**Concept:** Parallel execution, then combine results

```python
# Fan-out: Start 5 tasks in parallel
Task(Explore, "Find security issues in auth/")
Task(Explore, "Find security issues in api/")
Task(Explore, "Find security issues in db/")
Task(Explore, "Find security issues in frontend/")
Task(Explore, "Find security issues in infrastructure/")

# All 5 run simultaneously

# Fan-in: Combine results
"Found 15 total issues across all modules:
- auth/: 3 issues (2 critical)
- api/: 5 issues (1 critical)
- db/: 2 issues (0 critical)
- frontend/: 4 issues (1 critical)
- infrastructure/: 1 issue (0 critical)

Prioritized list:
1. [CRITICAL] SQL injection in api/users.py
2. [CRITICAL] Missing auth check in auth/admin.py
..."
```

---

### Pattern: Pipeline with Early Exit

**Concept:** Stop pipeline if any stage fails

```python
# Stage 1: Lint
Bash("npm run lint", run_in_background=true)
BashOutput(shell_id_1)

if failed:
  "Linting failed. Fix issues before proceeding."
  exit()

# Stage 2: Type check
Bash("npm run type-check", run_in_background=true)
BashOutput(shell_id_2)

if failed:
  "Type checking failed. Fix issues before proceeding."
  exit()

# Stage 3: Tests
Bash("npm test", run_in_background=true)
BashOutput(shell_id_3)

if failed:
  "Tests failed. Fix issues before proceeding."
  exit()

# All passed → Deploy
Bash("./deploy.sh", run_in_background=true)
```

---

### Pattern: Watchdog for Hung Processes

**Concept:** Kill tasks that take too long

```bash
# .claude/scripts/build-with-timeout.sh
#!/bin/bash

# Start build
npm run build &
BUILD_PID=$!

# Timeout after 10 minutes
sleep 600 &
SLEEP_PID=$!

# Wait for either to finish
wait -n $BUILD_PID $SLEEP_PID
EXIT_CODE=$?

# If timeout finished first, kill build
if kill -0 $BUILD_PID 2>/dev/null; then
  echo "Build timeout! Killing process..."
  kill $BUILD_PID
  exit 1
fi

# Build finished first, kill timeout
kill $SLEEP_PID 2>/dev/null

exit $EXIT_CODE
```

---

### Pattern: Retry with Exponential Backoff

```bash
# .claude/scripts/flaky-test-with-retry.sh
#!/bin/bash

MAX_ATTEMPTS=3
ATTEMPT=1

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
  echo "Attempt $ATTEMPT/$MAX_ATTEMPTS"

  npm test
  EXIT_CODE=$?

  if [ $EXIT_CODE -eq 0 ]; then
    echo "Tests passed!"
    exit 0
  fi

  if [ $ATTEMPT -lt $MAX_ATTEMPTS ]; then
    SLEEP_TIME=$((2 ** ATTEMPT))
    echo "Tests failed. Retrying in ${SLEEP_TIME}s..."
    sleep $SLEEP_TIME
  fi

  ATTEMPT=$((ATTEMPT + 1))
done

echo "All attempts failed!"
exit 1
```

---

## Best Practices Summary

### Do's

✅ **Start long tasks in background**
✅ **Do other work while waiting**
✅ **Write state to files for persistence**
✅ **Use Task agents for exploration to save context**
✅ **Check background tasks periodically, not constantly**
✅ **Provide user with time estimates**
✅ **Use scripts for deterministic workflows**
✅ **Handle failures gracefully**

### Don'ts

❌ **Don't use background for quick tasks (<2s)**
❌ **Don't check BashOutput immediately after starting**
❌ **Don't check multiple BashOutputs in rapid sequence**
❌ **Don't keep all files in context unnecessarily**
❌ **Don't rely on TodoWrite for multi-session state**
❌ **Don't start tasks you don't plan to wait for**
❌ **Don't ignore timeout risks**

---

**See also:**
- CLAUDE_CODE_COMPLETE_MANUAL.md
- SKILLS_ADVANCED_GUIDE.md
- NONSTANDARD_USES.md

---

*End of Async Workflows Guide. Last updated: 2025-11-09*
