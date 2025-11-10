# Claude Code: Complete Manual - Concepts Only

**Version:** 1.0 (Concept Edition)
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
- Maximum line limits by default (use offset/limit for large files)
- Very long lines are truncated
- Cannot read directories (use shell commands)

**Conceptual workflow:**
When a user asks to fix a bug in a specific file, first read that file to understand the current implementation, identify the issue, then make the necessary changes.

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
- Must read file first if it exists (tool will fail otherwise)
- Overwrites existing files completely
- Prefer Edit for existing files

**What to avoid:**
- Creating files unnecessarily (prefer editing existing structure)
- Creating documentation without explicit request
- Using Write when Edit is more appropriate

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
- Must read file first (tool will fail otherwise)
- Old string must be unique in file (or use replace-all option)
- Must preserve exact indentation from Read output
- Line number prefixes from Read are NOT part of file content

**What to avoid:**
- Including line numbers from Read output in replacement string
- Changing indentation style (preserve tabs/spaces exactly)
- Using non-unique strings without replace-all option

---

#### Glob
**Purpose:** Find files by pattern matching
**Blocking:** Yes (synchronous)
**Best for:** Finding files by name/extension

**Use cases:**
- Finding all files of a specific type
- Locating test files
- Finding configuration files

**Pattern examples:**
- All JavaScript files in current directory
- All JavaScript files recursively through subdirectories
- All TypeScript React files under a source directory

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
- Files with matches (default) - Just file paths
- Content - Show matching lines
- Count - Match counts per file

**Advanced features:**
- Context lines (before/after matches)
- Case insensitive search
- Multiline patterns
- File filtering by type or pattern

**What to avoid:**
- Using for exploratory searches (use Task with Explore agent)
- Forgetting to escape special regex characters

---

### Execution & Process Management

#### Bash
**Purpose:** Execute shell commands
**Blocking:** Yes by default, No with background option
**Best for:** Git, package managers, docker, system operations
**NOT for:** File operations (use dedicated tools)

**Execution modes:**

**Foreground execution (blocking):**
Commands block until complete - simple but stops other work.

**Background execution (non-blocking):**
Returns immediately with shell identifier, allowing you to continue other work and check results later.

**Use cases:**
- Git operations (clone, commit, push, branch)
- Package management (npm, pip, cargo)
- Building projects
- Running tests
- Docker operations
- System administration

**Caveats:**
- Always quote paths with spaces
- Use chaining operators for sequential dependent commands
- Use semicolons for sequential independent commands
- Use multiple parallel calls for independent operations
- Background mode has maximum timeout

**What to avoid:**
- Using for file operations (cat, grep, find, sed, awk)
- Interactive commands (require user input)
- Interactive flags
- Chaining with directory changes when absolute paths work

**Git workflow best practices:**
- Never update git config without permission
- Never force push without explicit request
- Never skip hooks without permission
- Always check authorship before amending commits
- Use proper formatting for commit messages

---

#### BashOutput
**Purpose:** Monitor background process output
**Blocking:** Yes (checking is synchronous)
**Best for:** Monitoring long-running background tasks

**How it works:**
1. Start a background task and receive a shell identifier
2. Continue other work, stay responsive
3. Check progress using the identifier to see output or completion status
4. Repeat checking periodically or when reminded

**Key insight:** Starting background tasks is instant and non-blocking, but CHECKING them is blocking.

**Use cases:**
- Long test suites (minutes)
- Large builds
- Package installations on slow networks
- Database migrations
- Docker image builds
- Large file downloads

**Advanced features:**
Can filter output to show only lines matching specific patterns (errors, progress indicators, etc.)

**What to avoid:**
- Using for fast commands - overhead not worth it
- Checking all background tasks in rapid succession (blocks you multiple times)
- Starting background task then immediately checking it
- Using when you need results immediately (use foreground)

**Proper workflow:**
Start multiple background tasks instantly, continue conversation with user, eventually check one task, continue conversation, check another task later. Do NOT check all tasks immediately in sequence.

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

**Conceptual workflow:**
Start an installation with one approach in background, if user decides to try a different approach mid-operation, terminate the first and start the alternative.

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
- Has caching for repeated requests
- Redirects to different host require new request

**What to avoid:**
- Using when MCP web tools available (prefer MCP)
- Fetching same URL repeatedly (use cache)

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
- Regional availability restrictions
- Returns search results, not full content
- Best for discovery, use WebFetch for details

---

### Task Orchestration

#### Task (Launching Agents)
**Purpose:** Launch specialized agents for complex work
**Blocking:** Yes (agent runs, then returns final report)
**Best for:** Complex multi-step tasks, exploration, planning

**Available agent types:**

**General-purpose agents:**
- Access to all tools
- For complex research and multi-step tasks
- Use when task doesn't fit other specialized agents

**Explore agents:**
- Fast codebase exploration
- Find files, search code, answer codebase questions
- Configurable thoroughness levels

**Plan agents:**
- Similar to Explore, specialized for planning

**Specialized configuration agents:**
- Setup and configuration tasks

**Key properties:**
- Each agent runs autonomously
- Returns single final report (cannot interact mid-execution)
- Not visible to user unless you show them
- Can specify different models (faster vs more capable)
- Can resume from previous agent run

**Parallel execution:**
Launch multiple agents in a single message - they all run simultaneously, then you receive all reports together.

**What to avoid:**
- Using for simple file reads (use Read directly)
- Using for specific searches (use Glob)
- Expecting mid-execution interaction
- Launching agents one at a time when they could be parallel

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
- Complex multi-step tasks
- User provides list of tasks
- Demonstrating thoroughness
- Tracking progress visually

**Task states:**
- Pending - Not started
- In progress - Currently working (EXACTLY ONE at a time)
- Completed - Finished

**Requirements:**
- Two forms: imperative (what needs to be done) and present continuous (what is being done)
- Mark completed immediately after finishing
- Keep exactly one task in progress

**What to avoid:**
- Using for single trivial tasks
- Marking incomplete tasks as completed
- Batching completions (mark as done immediately)
- Having zero or multiple in-progress tasks

**Critical limitation:**
- NOT persistent across sessions (disappears)
- NOT available to other agents
- NOT in git repo
- Better alternative: File-based TODO for handoffs/persistence

**When file-based is better:**
- Multi-session projects
- Agent handoff scenarios
- Team collaboration
- Persistent tracking
- Need to commit progress

---

### Custom Extensions

#### SlashCommand
**Purpose:** Execute custom user-defined commands
**Blocking:** Expands to prompt in next message
**Best for:** Frequently used workflows

**How it works:**
- User creates custom command files
- Execute commands to trigger workflows
- Command expands to prompt defined in file

**Only loads at session start** - cannot use newly created commands in same session

**What to avoid:**
- Using for built-in CLI commands
- Expecting newly created commands to work immediately

---

#### Skill
**Purpose:** Execute specialized skill workflows
**Blocking:** Loads skill prompt, then you execute
**Best for:** Complex reusable capabilities

**Skill types:**
- Personal skills (user-only)
- Project skills (team-shared via git)
- Plugin skills (bundled with plugins)

**Conceptual understanding:**
Skills provide specialized workflows for complex tasks. They load additional instructions and context to help complete specific types of work.

---

## Use Cases by Category

### Development Workflows

**Feature Development:**
Read existing code, plan changes, edit files, run tests in background, check test results, commit and push.

**Bug Fixing:**
Search for error pattern, read affected files, identify root cause, edit fix, run tests to verify, commit.

**Refactoring:**
Use exploration agents to understand codebase, plan refactoring strategy, edit files incrementally, run tests after each change, commit when tests pass.

**Code Review:**
Start linter, type checker, and tests in parallel background processes. While they run, read code changes, check for security issues, review documentation. As each completes, report findings.

---

### Git Workflows

**Creating commits:**
Check status, view changes in detail, understand existing commit style, stage files, commit with proper message formatting, verify success.

**Creating PRs:**
Check status, view changes, examine all commits in branch, view all changes since divergence from main, create branch if needed, push with tracking, create pull request if tooling available.

**Never:**
- Force push to main/master
- Amend other developers' commits
- Skip hooks without permission
- Update git config without permission

---

### Parallel Workflows

**Parallel testing:**
Run unit tests, integration tests, and end-to-end tests in background. While they run, review code, write documentation, fix obvious bugs. As tests complete, report results and address failures.

**Multi-repo development:**
Multiple agents work on different repositories (frontend, backend, mobile, docs). Monitor all from mobile device, merge as each completes.

---

## Workflows & Patterns

### Pattern: Progressive Enhancement
Start a slow comprehensive analysis in background. Start a fast basic check in background. Fast check completes and shows quick results. Continue conversation. Slow analysis completes and shows detailed findings.

### Pattern: Dependency Chain
Install dependencies in background, check when complete. Run build in background, check when complete. Run tests in background, check when complete. Report final results.

### Pattern: Speculative Execution
When user mentions they might need to do something later, start it speculatively in background. Discuss the plan while it runs. When user confirms, the work is already done.

### Pattern: Parallel Research
Launch multiple exploration agents simultaneously on different aspects of the codebase. All run in parallel. Combine findings into comprehensive answer.

---

## Limitations & Caveats

### Tool Execution
- All tools block except background Bash
- Checking background output blocks even though starting doesn't
- Task agents cannot be interrupted mid-execution
- File operations are synchronous - no parallelism

### Context & Memory
- TodoWrite is ephemeral - lost between sessions
- Agents don't share context - each starts fresh
- Skills load at session start - new skills not available until restart
- No persistent memory across sessions without files

### Git & GitHub
- GitHub CLI not always available in all environments
- Proxy auth only for session repo - not for arbitrary repos
- Cannot create GitHub repos remotely
- Commit signing requires proper configuration

### Network & Resources
- Generous but not unlimited disk space
- Background tasks have maximum timeout
- Fast datacenter connection - not your home internet
- Read-only web access - cannot POST to APIs

### File Operations
- Read has maximum line limits by default (configurable)
- Edit requires exact string match - whitespace matters
- Write overwrites completely - no partial updates
- Cannot read directories - use shell commands

---

## What to Avoid

### Anti-Patterns

**Using Bash for file operations:**
Don't use shell commands for reading files, searching file contents, or finding files by pattern. Use dedicated tools instead.

**Sequential when parallel possible:**
Don't read multiple files one at a time, waiting between each. Make all file read requests in the same message for parallel execution.

**Checking background tasks immediately:**
Don't start a background task and immediately check its output. Do other work first, giving the task time to produce meaningful results.

**Using background for fast commands:**
Don't use background mode for commands that complete in under 2 seconds - the overhead isn't worth it.

**Multiple BashOutput checks in sequence:**
Don't check multiple background tasks in rapid succession. Check one, continue conversation, check another later. Otherwise user loses touch with you.

**Creating files unnecessarily:**
Don't create README or documentation files without being asked. Only create files when explicitly requested.

**Using TodoWrite for persistence:**
Don't use TodoWrite for multi-session projects. Create file-based TODO files for persistence across sessions.

---

## Performance Optimization

### Maximize Parallelism
- Multiple file reads in one message
- Multiple background shell commands together
- Multiple Task agents in one message
- Start all background work, THEN check results

Avoid:
- Sequential file reads
- Starting background tasks one by one
- Checking background results in rapid sequence

### Minimize Context Usage
- Use exploration agents for open-ended searches
- Use search tools with result limits for large codebases
- Read specific files you know exist

Avoid:
- Reading entire codebase into context
- Unlimited search results
- Exploring with direct tools instead of agents

### Efficient Git Operations
- Chain dependent operations together
- Fetch specific branches, not all branches
- Use local proxy for authentication

Avoid:
- Separate commands for dependent operations
- Fetching all branches
- Manual token management

### Smart Background Usage
Use background mode for:
- Long-running operations (over 5 seconds)
- Multiple independent tasks in parallel
- Continue working while tasks run

Don't use background mode for:
- Fast operations (under 2 seconds)
- Tasks you need results from immediately
- Interactive commands

---

## Advanced Concepts

### Context Management
- Use ignore files to exclude files from context
- Prefer specific file reads over directory scans
- Use Task agents for exploration, not direct tools
- Commit important state to files, not just TodoWrite

### Mobile Optimization
- Launch agents in morning, review on mobile during day
- Use GitHub mobile app for PR reviews
- Background tasks perfect for mobile workflow
- Short focused PRs easier to review on phone

### Session Handoff
- Use TODO files, not TodoWrite
- Commit progress regularly
- Document assumptions in files
- Use conventional commit messages

### Error Recovery
- Always check git status after commits
- Verify tests pass before pushing
- Use KillShell to cancel failed operations
- Keep incremental commits for easy rollback

---

**Conceptual understanding is key:** This manual focuses on the "what" and "why" of each tool rather than the "how". Understanding when to use each tool and how they work together is more important than memorizing syntax.

**See also:**
- Skills Advanced Guide - Deep dive into skills system
- Async Workflows - Background processes & multitasking
- Nonstandard Uses - Creative applications
- Unlimited Week Strategy - Maximizing unlimited access

---

*End of manual. Last updated: 2025-11-09*
