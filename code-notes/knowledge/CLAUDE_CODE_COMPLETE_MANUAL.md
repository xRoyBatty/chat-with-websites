# Claude Code: Complete Manual

**Version:** 1.0
**Last Updated:** 2025-11-09

---

## Table of Contents

1. [Core Tools Reference](#core-tools-reference)
2. [Use Cases by Category](#use-cases-by-category)
3. [Workflows & Patterns](#workflows--patterns)
4. [Limitations & Caveats](#limitations--caveats)
5. [What to Avoid](#what-to-avoid)
6. [Performance Optimization](#performance-optimization)

---

## Core Tools Reference

### File Operations

#### Read
**Purpose:** Read files from filesystem
**Blocking:** Yes (synchronous)
**Best for:** Reading specific files you know exist
**Avoid for:** Exploratory file searching (use Glob instead)

**Use cases:**
- Reading configuration files
- Analyzing code structure
- Reviewing documentation
- Examining logs

**Caveats:**
- Max 2000 lines by default (use offset/limit for large files)
- Lines >2000 chars are truncated
- Cannot read directories (use Bash with `ls`)

**Example workflow:**
```
User: "Fix the bug in auth.py"
→ Read(auth.py)
→ Identify issue
→ Edit(auth.py) to fix
```

---

#### Write
**Purpose:** Create new files
**Blocking:** Yes (synchronous)
**Best for:** Creating files that don't exist
**Avoid for:** Modifying existing files (use Edit instead)

**Use cases:**
- Creating new modules
- Generating configuration files
- Writing scripts
- Creating documentation

**Caveats:**
- MUST read file first if it exists (tool will fail otherwise)
- Overwrites existing files completely
- Prefer Edit for existing files

**What to avoid:**
- ❌ Writing files unnecessarily (prefer editing existing structure)
- ❌ Creating documentation without explicit request
- ❌ Using Write when Edit is more appropriate

---

#### Edit
**Purpose:** Modify existing files with exact string replacement
**Blocking:** Yes (synchronous)
**Best for:** Surgical edits to existing code

**Use cases:**
- Fixing bugs
- Adding features to existing code
- Refactoring
- Updating configurations

**Caveats:**
- MUST read file first (tool will fail otherwise)
- `old_string` must be unique in file (or use `replace_all`)
- Must preserve exact indentation from Read output
- Line number prefixes from Read are NOT part of file content

**What to avoid:**
- ❌ Including line numbers from Read output in old_string
- ❌ Changing indentation style (preserve tabs/spaces exactly)
- ❌ Using non-unique strings without `replace_all=true`

---

#### Glob
**Purpose:** Find files by pattern matching
**Blocking:** Yes (synchronous)
**Best for:** Finding files by name/extension

**Use cases:**
- Finding all TypeScript files: `**/*.ts`
- Locating test files: `**/*test.py`
- Finding configs: `**/config.*`

**Patterns:**
- `*.js` - All JS files in current directory
- `**/*.js` - All JS files recursively
- `src/**/*.tsx` - All TSX files under src/

**When to use Task instead:**
- Open-ended searches requiring multiple rounds
- Exploring unfamiliar codebases
- Need to understand context, not just find files

---

#### Grep
**Purpose:** Search file contents with regex
**Blocking:** Yes (synchronous)
**Best for:** Finding specific code patterns

**Use cases:**
- Finding function definitions
- Searching for API calls
- Locating TODO comments
- Finding security issues

**Output modes:**
- `files_with_matches` (default) - Just file paths
- `content` - Show matching lines
- `count` - Match counts per file

**Advanced features:**
- Context lines: `-A`, `-B`, `-C`
- Case insensitive: `-i`
- Multiline patterns: `multiline: true`
- File filtering: `glob: "*.py"` or `type: "py"`

**What to avoid:**
- ❌ Using for exploratory searches (use Task with Explore agent)
- ❌ Forgetting to escape special regex chars

---

### Execution & Process Management

#### Bash
**Purpose:** Execute shell commands
**Blocking:** Yes by default, No with `run_in_background=true`
**Best for:** Git, npm, docker, system operations
**NOT for:** File operations (use dedicated tools)

**Foreground execution (blocking):**
```bash
git status  # Blocks until complete
npm install # Blocks for entire install
```

**Background execution (non-blocking):**
```bash
Bash("npm test", run_in_background=true)
→ Returns immediately with shell_id
→ Continue other work
→ Check later with BashOutput
```

**Use cases:**
- Git operations (clone, commit, push, branch)
- Package management (npm, pip, cargo)
- Building projects
- Running tests
- Docker operations
- System administration

**Caveats:**
- ALWAYS quote paths with spaces: `cd "path with spaces"`
- Use `&&` for sequential dependent commands
- Use `;` for sequential independent commands
- Use multiple parallel Bash calls for independent operations
- `run_in_background` max timeout: 600000ms (10 min)

**What to avoid:**
- ❌ Using for file operations (cat, grep, find, sed, awk)
- ❌ Interactive commands (require user input)
- ❌ Using `-i` flags (git rebase -i, git add -i)
- ❌ Chaining with `cd` when absolute paths work

**Git workflow best practices:**
- Never update git config without permission
- Never force push without explicit request
- Never skip hooks (--no-verify) without permission
- Always check authorship before amending commits
- Use HEREDOC for commit messages (proper formatting)

---

#### BashOutput
**Purpose:** Monitor background process output
**Blocking:** Yes (checking is synchronous)
**Best for:** Monitoring long-running background tasks

**How it works:**
```
1. Start: Bash(..., run_in_background=true) → Returns shell_id
2. Continue: Do other work, stay responsive
3. Check: BashOutput(shell_id) → See progress/completion
4. Repeat: Check periodically or when reminded
```

**Key insight:** Starting background tasks is instant and non-blocking, but CHECKING them with BashOutput is blocking.

**Use cases:**
- Long test suites (minutes)
- Large builds (cargo, webpack, etc.)
- Package installations on slow networks
- Database migrations
- Docker image builds
- Large file downloads

**Advanced: Filter output:**
```
BashOutput(shell_id, filter="ERROR|FAIL")  # Only errors
BashOutput(shell_id, filter="\\d+%")       # Only progress
```

**What to avoid:**
- ❌ Using for fast commands (<2 seconds) - overhead not worth it
- ❌ Checking all background tasks in rapid succession (blocks you multiple times)
- ❌ Starting background task then immediately checking it
- ❌ Using when you need results immediately (use foreground)

**Proper workflow:**
```
Start 3 background tasks (instant)
Continue conversation with user
Eventually check ONE task
Continue conversation
Check another task later
NOT: Check all 3 tasks immediately in sequence
```

---

#### KillShell
**Purpose:** Terminate background process
**Blocking:** Yes (synchronous)
**Best for:** Canceling operations, pivoting strategies

**Use cases:**
- User changes mind mid-operation
- Background task is taking too long
- Wrong command was started
- Need to free resources

**Workflow:**
```
npm install --legacy-peer-deps  # background
... 30 seconds later ...
User: "Actually, let's try a different approach"
KillShell(shell_id)
npm install --force  # Try alternative
```

---

### Web & External Access

#### WebFetch
**Purpose:** Fetch and process web content
**Blocking:** Yes (synchronous)
**Best for:** Retrieving specific URLs, documentation

**Use cases:**
- Fetching API documentation
- Reading blog posts
- Getting library docs
- Checking website content

**How it works:**
- Fetches URL
- Converts HTML to markdown
- Processes with AI to extract info you requested

**Caveats:**
- Read-only (cannot modify content)
- Results may be summarized if very large
- 15-minute cache for repeated requests
- Redirects to different host require new request

**What to avoid:**
- ❌ Using when MCP web tools available (prefer MCP)
- ❌ Fetching same URL repeatedly (use cache)

---

#### WebSearch
**Purpose:** Search the web for current information
**Blocking:** Yes (synchronous)
**Best for:** Finding recent information beyond knowledge cutoff

**Use cases:**
- Current library versions
- Recent framework updates
- Current events affecting code
- Finding documentation URLs

**Caveats:**
- Only available in US
- Returns search results, not full content
- Best for discovery, use WebFetch for details

---

### Task Orchestration

#### Task (Launching Agents)
**Purpose:** Launch specialized agents for complex work
**Blocking:** Yes (agent runs, then returns final report)
**Best for:** Complex multi-step tasks, exploration, planning

**Available agent types:**

**1. general-purpose**
- Access to ALL tools
- For complex research and multi-step tasks
- Use when task doesn't fit other specialized agents

**2. Explore**
- Fast codebase exploration
- Find files, search code, answer codebase questions
- Thoroughness levels: "quick", "medium", "very thorough"

**3. Plan**
- Similar to Explore, specialized for planning

**4. statusline-setup**
- Configure Claude Code status line

**Key properties:**
- Each agent runs autonomously
- Returns single final report (cannot interact mid-execution)
- NOT visible to user unless you show them
- Can specify model (haiku for speed, sonnet for quality)
- Can resume from previous agent run

**Parallel execution:**
```
Launch multiple agents in SINGLE message:
Task(Explore, "Find React files")
Task(Explore, "Find auth code")
Task(general-purpose, "Analyze security")
→ All run simultaneously
```

**What to avoid:**
- ❌ Using for simple file reads (use Read directly)
- ❌ Using for specific class searches (use Glob)
- ❌ Expecting mid-execution interaction
- ❌ Launching agents one at a time when they could be parallel

**When to use Task instead of direct tools:**
- Open-ended exploration (unfamiliar codebase)
- Multiple rounds of search likely needed
- Need to understand context, not just find exact match
- Complex analysis requiring multiple steps

---

#### TodoWrite
**Purpose:** Create visual task tracking in UI
**Blocking:** No (updates UI state)
**Best for:** Real-time progress visibility during session

**Use cases:**
- Complex multi-step tasks (3+ steps)
- User provides list of tasks
- Demonstrating thoroughness
- Tracking progress visually

**Task states:**
- `pending` - Not started
- `in_progress` - Currently working (EXACTLY ONE at a time)
- `completed` - Finished

**Requirements:**
- Two forms: `content` (imperative) and `activeForm` (present continuous)
- Example: "Run tests" / "Running tests"
- Mark completed IMMEDIATELY after finishing
- Keep exactly ONE task in_progress

**What to avoid:**
- ❌ Using for single trivial tasks
- ❌ Marking incomplete tasks as completed
- ❌ Batching completions (mark as done immediately)
- ❌ Having zero or multiple in_progress tasks

**Critical limitation:**
- ❌ NOT persistent across sessions (disappears)
- ❌ NOT available to other agents
- ❌ NOT in git repo
- ✅ Better alternative: File-based TODO.md for handoffs/persistence

**When file-based is better:**
```
Multi-session projects
Agent handoff scenarios
Team collaboration
Persistent tracking
Need to commit progress
```

---

### Custom Extensions

#### SlashCommand
**Purpose:** Execute custom user-defined commands
**Blocking:** Expands to prompt in next message
**Best for:** Frequently used workflows

**How it works:**
- User creates `.claude/commands/name.md`
- Use `/name` to execute
- Command expands to prompt defined in file

**Only loads at session start** - cannot use newly created commands in same session

**What to avoid:**
- ❌ Using for built-in CLI commands
- ❌ Expecting newly created commands to work immediately

---

#### Skill
**Purpose:** Execute specialized skill workflows
**Blocking:** Loads skill prompt, then you execute
**Best for:** Complex reusable capabilities

**Available skills:**
- `session-start-hook` - Create startup hooks for web sessions

**Skill types:**
- Personal: `~/.claude/skills/` (user-only)
- Project: `.claude/skills/` (team-shared via git)
- Plugin: Bundled with plugins

**More detail:** See SKILLS_ADVANCED_GUIDE.md

---

## Use Cases by Category

### Development Workflows

**Feature Development:**
```
1. Read existing code
2. Plan changes
3. Edit files
4. Run tests (background)
5. Check test results
6. Commit and push
```

**Bug Fixing:**
```
1. Grep for error pattern
2. Read affected files
3. Identify root cause
4. Edit fix
5. Run tests to verify
6. Commit
```

**Refactoring:**
```
1. Task(Explore) to understand codebase
2. Plan refactoring strategy
3. Edit files incrementally
4. Run tests after each change
5. Commit when tests pass
```

**Code Review:**
```
Start in parallel:
- Bash(eslint, background)
- Bash(tsc --noEmit, background)
- Bash(npm test, background)

While running:
- Read code changes
- Check for security issues
- Review documentation

As each completes:
- Report linter issues
- Show type errors
- Display test failures
```

---

### Git Workflows

**Creating commits:**
```
1. git status (see changes)
2. git diff (see details)
3. git log (understand commit style)
4. git add (stage files)
5. git commit (with HEREDOC message)
6. git status (verify)
```

**Creating PRs:**
```
1. git status
2. git diff
3. git log (all commits in branch)
4. git diff main...HEAD (all changes)
5. Create branch if needed
6. git push -u origin branch
7. gh pr create (if gh available)
```

**Never:**
- Force push to main/master
- Amend other developers' commits
- Skip hooks without permission
- Update git config without permission

---

### Parallel Workflows

**Parallel testing:**
```
Background:
- npm run test:unit
- npm run test:integration
- npm run test:e2e

Foreground:
- Review code
- Write documentation
- Fix obvious bugs

As tests complete:
- Report results
- Address failures
```

**Multi-repo development:**
```
Agent 1 → repo-a (frontend)
Agent 2 → repo-b (backend)
Agent 3 → repo-c (mobile)
Agent 4 → repo-d (docs)

Monitor all from mobile
Merge as each completes
```

---

## Workflows & Patterns

### Pattern: Progressive Enhancement
```
Start slow comprehensive analysis (background)
Start fast basic check (background)
Fast check completes → Show quick results
Continue conversation
Slow analysis completes → Show detailed findings
```

### Pattern: Dependency Chain
```
Install dependencies (background)
  ↓ (check when complete)
Run build (background)
  ↓ (check when complete)
Run tests (background)
  ↓ (check when complete)
Report final results
```

### Pattern: Speculative Execution
```
User: "We might need to deploy"
Start build speculatively (background)
Discuss deployment plan
User confirms → Build already done!
```

### Pattern: Parallel Research
```
Task(Explore, "Find auth code")
Task(Explore, "Find API endpoints")
Task(general-purpose, "Analyze security")

All run simultaneously
Combine findings into comprehensive answer
```

---

## Limitations & Caveats

### Tool Execution
- **All tools block** except background Bash
- **BashOutput blocks** when checking (not when starting)
- **Task agents cannot be interrupted** mid-execution
- **File operations are synchronous** - no parallelism

### Context & Memory
- **TodoWrite is ephemeral** - lost between sessions
- **Agents don't share context** - each starts fresh
- **Skills load at session start** - new skills not available until restart
- **No persistent memory** across sessions without files

### Git & GitHub
- **gh CLI not available** in this environment
- **Proxy auth only for session repo** - not for arbitrary repos
- **Cannot create GitHub repos** remotely
- **Commit signing** requires proper configuration

### Network & Resources
- **15 GB disk space** - generous but not unlimited
- **Background tasks max 10 min** timeout
- **Fast datacenter connection** - not your home internet
- **Read-only web access** - cannot POST to APIs

### File Operations
- **Read max 2000 lines** by default (use offset/limit)
- **Edit requires exact string match** - whitespace matters
- **Write overwrites completely** - no partial updates
- **Cannot read directories** - use Bash ls

---

## What to Avoid

### Anti-Patterns

**❌ Using Bash for file operations:**
```
Bad:  cat file.py
Good: Read(file.py)

Bad:  grep "pattern" *.py
Good: Grep(pattern="pattern", glob="*.py")

Bad:  find . -name "*.js"
Good: Glob(pattern="**/*.js")
```

**❌ Sequential when parallel possible:**
```
Bad:
  Read(file1.py)
  ... wait ...
  Read(file2.py)
  ... wait ...

Good:
  Read(file1.py)
  Read(file2.py)
  # Both in same message - parallel execution
```

**❌ Checking background tasks immediately:**
```
Bad:
  Bash(npm test, background=true)
  BashOutput(shell_id)  # Too fast!

Good:
  Bash(npm test, background=true)
  # Do other work for 30+ seconds
  BashOutput(shell_id)  # Now it's useful
```

**❌ Using background for fast commands:**
```
Bad:  Bash(ls, background=true)  # Overhead not worth it
Good: Bash(ls)  # Just use foreground
```

**❌ Multiple BashOutput checks in sequence:**
```
Bad:
  BashOutput(id1)  # Blocks
  BashOutput(id2)  # Blocks
  BashOutput(id3)  # Blocks
  # User loses touch with you

Good:
  BashOutput(id1)
  # Continue conversation
  # Later check id2
  # Even later check id3
```

**❌ Creating files unnecessarily:**
```
Bad:  Write(README.md) without being asked
Good: Only create files when explicitly requested
```

**❌ Using TodoWrite for persistence:**
```
Bad:  TodoWrite for multi-session project
Good: Create TODO.md file for persistence
```

---

## Performance Optimization

### Maximize Parallelism
```
✅ Multiple file reads in one message
✅ Multiple background Bash commands together
✅ Multiple Task agents in one message
✅ Start all background work, THEN check results

❌ Sequential file reads
❌ Starting background tasks one by one
❌ Checking background results in rapid sequence
```

### Minimize Context Usage
```
✅ Use Task(Explore) for open-ended searches
✅ Use Grep with head_limit for large results
✅ Read specific files you know exist

❌ Reading entire codebase into context
❌ Unlimited Grep results
❌ Exploring with direct tools instead of agents
```

### Efficient Git Operations
```
✅ Chain with &&: git add . && git commit && git push
✅ Fetch specific branches: git fetch origin branch
✅ Use local proxy for auth

❌ Separate commands for dependent operations
❌ Fetching all branches
❌ Manual token management
```

### Smart Background Usage
```
✅ Long-running operations (>5 seconds)
✅ Multiple independent tasks in parallel
✅ Continue working while tasks run

❌ Fast operations (<2 seconds)
❌ Tasks you need results from immediately
❌ Interactive commands
```

---

## Advanced Tips

### Context Management
- Use `.claudeignore` to exclude files from context
- Prefer specific file reads over directory scans
- Use Task agents for exploration, not direct tools
- Commit important state to files, not just TodoWrite

### Mobile Optimization
- Launch agents in morning, review on mobile during day
- Use GitHub mobile app for PR reviews
- Background tasks perfect for mobile workflow
- Short focused PRs easier to review on phone

### Session Handoff
- Use TODO.md files, not TodoWrite
- Commit progress regularly
- Document assumptions in files
- Use conventional commit messages

### Error Recovery
- Always check git status after commits
- Verify tests pass before pushing
- Use KillShell to cancel failed operations
- Keep incremental commits for easy rollback

---

**See also:**
- `SKILLS_ADVANCED_GUIDE.md` - Deep dive into skills system
- `ASYNC_WORKFLOWS.md` - Background processes & multitasking
- `NONSTANDARD_USES.md` - Creative applications
- `UNLIMITED_WEEK_STRATEGY.md` - Maximizing unlimited access

---

*End of manual. Last updated: 2025-11-09*
