# Claude Code: Conceptual Understanding

**Version:** 1.0 (Concepts Only)
**Last Updated:** 2025-11-09

---

## Table of Contents

1. [Core Tools Overview](#core-tools-overview)
2. [Use Cases by Category](#use-cases-by-category)
3. [Workflows & Patterns](#workflows--patterns)
4. [Limitations & Caveats](#limitations--caveats)
5. [What to Avoid](#what-to-avoid)
6. [Performance Optimization](#performance-optimization)

---

## Core Tools Overview

### File Operations

#### Read
**Purpose:** Access and examine files from the filesystem

**Execution Model:** Synchronous (blocks until complete)

**Best Uses:**
- Examining configuration files
- Analyzing code structure
- Reviewing documentation
- Inspecting logs

**Key Characteristics:**
- Returns file contents with line numbers
- Default limit on number of lines returned
- Long lines may be truncated
- Cannot read directories (need different approach)

**Typical Workflow:**
When a user requests a fix or modification, first read the relevant file to understand current state, then identify the issue, then make necessary changes using appropriate editing tools.

---

#### Write
**Purpose:** Create brand new files that don't yet exist

**Execution Model:** Synchronous (blocks until complete)

**Best Uses:**
- Creating new modules or scripts
- Generating configuration files
- Writing documentation
- Initializing new components

**Key Characteristics:**
- Must read first if file already exists
- Completely overwrites existing files
- Better to use editing tools for modifications
- Should be avoided unless file creation is specifically needed

**Best Practices:**
- Avoid creating files unnecessarily
- Prefer modifying existing structure over creating new files
- Don't create documentation without explicit request
- Use editing tools when working with existing files

---

#### Edit
**Purpose:** Make precise modifications to existing files through string replacement

**Execution Model:** Synchronous (blocks until complete)

**Best Uses:**
- Fixing bugs in existing code
- Adding features to current codebase
- Refactoring existing implementations
- Updating configuration values

**Key Characteristics:**
- Requires reading file first
- Replacement string must be unique unless using replace-all mode
- Must preserve exact indentation from original
- Line number prefixes from reading are not part of actual content

**Best Practices:**
- Don't include line numbers in replacement strings
- Preserve existing indentation style exactly
- Use replace-all mode when changing repeated strings
- Always verify changes match intended location

---

#### Glob
**Purpose:** Discover files using pattern matching

**Execution Model:** Synchronous (blocks until complete)

**Best Uses:**
- Finding all files of specific type
- Locating test files
- Discovering configuration files
- Identifying files by naming convention

**Common Patterns:**
- Match files in current directory only
- Match files recursively through subdirectories
- Match specific file types in specific locations
- Combine multiple patterns

**When to Use Alternatives:**
- For open-ended exploration requiring multiple search rounds
- When unfamiliar with codebase structure
- When context understanding is needed beyond just finding files

---

#### Grep
**Purpose:** Search file contents using regular expressions

**Execution Model:** Synchronous (blocks until complete)

**Best Uses:**
- Finding function or class definitions
- Searching for API usage
- Locating TODO or FIXME comments
- Identifying potential security issues

**Output Options:**
- Show just file paths that contain matches
- Display matching lines with context
- Count matches per file

**Advanced Capabilities:**
- Show lines before and after matches for context
- Case-insensitive searching
- Multi-line pattern matching
- Filter by file type or pattern

**Best Practices:**
- Don't use for exploratory searches (use specialized agents)
- Remember to escape special regex characters
- Use appropriate output mode for your needs

---

### Execution & Process Management

#### Bash
**Purpose:** Execute shell commands and system operations

**Execution Model:** Synchronous by default, optionally asynchronous

**Best Uses:**
- Git operations (cloning, committing, pushing, branching)
- Package management (installing dependencies)
- Building projects
- Running tests
- Container operations
- System administration tasks

**NOT for:**
- File reading operations (use dedicated tools)
- Content searching (use dedicated tools)
- File pattern finding (use dedicated tools)

**Execution Modes:**

**Foreground (Blocking):**
- Command runs and you wait for completion
- Appropriate for quick operations
- Results available immediately

**Background (Non-blocking):**
- Command starts and returns control immediately
- You can continue other work
- Check results later when convenient

**Key Characteristics:**
- Always quote paths containing spaces
- Can chain dependent commands sequentially
- Can run independent commands in parallel
- Background tasks have maximum timeout

**Best Practices:**
- Use sequential chaining for dependent operations
- Use parallel execution for independent tasks
- Avoid interactive commands requiring user input
- Don't use flags that require interactivity
- Prefer absolute paths over changing directories

**Git Workflow Principles:**
- Never modify configuration without permission
- Never force operations without explicit request
- Never skip hooks without permission
- Always verify authorship before amending
- Use proper formatting for commit messages

---

#### BashOutput
**Purpose:** Monitor the progress and output of background processes

**Execution Model:** Synchronous check (the checking blocks, not the original task)

**Best Uses:**
- Monitoring long-running test suites
- Tracking large build processes
- Watching package installations
- Observing database migrations
- Following container builds
- Monitoring file downloads

**How It Works:**
Starting background tasks is instant and non-blocking, but checking their status is a blocking operation that should be done strategically.

**Advanced Capability:**
Can filter output to show only lines matching specific patterns, useful for monitoring specific events or errors.

**Best Practices:**
- Don't use for fast operations (overhead not worthwhile)
- Avoid checking multiple tasks in rapid succession
- Don't check immediately after starting
- Use foreground execution when results needed immediately

**Proper Usage Pattern:**
Start multiple background tasks instantly, continue productive conversation or work, eventually check one task status, continue conversation, check another task later. Not: start tasks and immediately check all of them in sequence.

---

#### KillShell
**Purpose:** Terminate running background processes

**Execution Model:** Synchronous (blocks until complete)

**Best Uses:**
- Canceling operations when user changes direction
- Stopping tasks taking too long
- Correcting mistakenly started commands
- Freeing system resources

**Typical Scenario:**
Start a background operation, then user decides to try a different approach or the operation is taking longer than expected, so terminate it and try alternative method.

---

### Web & External Access

#### WebFetch
**Purpose:** Retrieve and process web content

**Execution Model:** Synchronous (blocks until complete)

**Best Uses:**
- Accessing API documentation
- Reading blog posts or articles
- Getting library documentation
- Checking website content

**How It Works:**
Fetches the URL, converts HTML to readable markdown format, processes content with AI to extract specifically requested information.

**Key Characteristics:**
- Read-only (cannot modify remote content)
- Large results may be summarized
- Has caching to avoid repeated fetches
- Cross-domain redirects require new request

**Best Practices:**
- Prefer specialized web tools if available
- Leverage cache for repeated accesses

---

#### WebSearch
**Purpose:** Search the internet for current information

**Execution Model:** Synchronous (blocks until complete)

**Best Uses:**
- Finding current library versions
- Discovering recent framework updates
- Understanding current events affecting development
- Locating documentation URLs

**Key Characteristics:**
- Geographic restrictions may apply
- Returns search results, not full content
- Best for discovery, use fetch tools for details

---

### Task Orchestration

#### Task (Launching Agents)
**Purpose:** Deploy specialized agents for complex, multi-step work

**Execution Model:** Synchronous (agent runs autonomously, then returns final report)

**Best Uses:**
- Complex research requiring multiple steps
- Exploration of unfamiliar codebases
- Planning complex operations
- Multi-step analysis tasks

**Available Agent Types:**

**General Purpose:**
- Has access to all available tools
- Suitable for complex research and multi-step operations
- Use when task doesn't fit specialized agents

**Explore:**
- Optimized for fast codebase exploration
- Finds files, searches code, answers codebase questions
- Configurable thoroughness levels

**Plan:**
- Similar to Explore but specialized for planning tasks

**Specialized Configuration:**
- Can configure agents for specific purposes

**Key Properties:**
- Each agent runs autonomously without mid-execution interaction
- Returns single comprehensive final report
- Not visible to user unless explicitly shown
- Can specify different models for speed vs quality tradeoffs
- Can resume from previous agent execution

**Parallel Execution:**
Can launch multiple agents simultaneously in a single message, all run concurrently and return results together.

**Best Practices:**
- Don't use for simple file reads (use direct tools)
- Don't use for specific searches with known location
- Don't expect mid-execution interaction
- Launch parallel agents together, not sequentially

**When to Use vs Direct Tools:**
- Open-ended exploration of unfamiliar territory
- Multiple search rounds likely needed
- Context understanding required beyond exact matching
- Complex analysis requiring multiple analytical steps

---

#### TodoWrite
**Purpose:** Create visual task tracking in user interface

**Execution Model:** Non-blocking (updates UI state)

**Best Uses:**
- Complex multi-step tasks
- When user provides task lists
- Demonstrating thoroughness and progress
- Real-time progress visibility

**Task States:**
- Pending: Not yet started
- In Progress: Currently working (exactly one at a time)
- Completed: Finished successfully

**Requirements:**
- Must provide two forms of description: imperative (what to do) and continuous (currently doing)
- Mark completed immediately after finishing
- Maintain exactly one task in progress state
- Only mark completed when truly finished

**Best Practices:**
- Don't use for single trivial tasks
- Don't mark incomplete tasks as completed
- Don't batch completions (update immediately)
- Don't have zero or multiple in-progress tasks

**Critical Limitation:**
Not persistent across sessions - disappears when session ends. Not accessible to other agents. Not committed to repository. For persistent tracking across sessions or agent handoffs, use file-based tracking instead.

**When File-Based is Better:**
Projects spanning multiple sessions, scenarios requiring agent handoff, team collaboration needs, persistent tracking requirements, need to commit progress to repository.

---

### Custom Extensions

#### SlashCommand
**Purpose:** Execute user-defined custom commands

**Execution Model:** Expands to prompt in next message

**Best Uses:**
- Frequently used workflows
- Team-standardized procedures
- Complex multi-step operations

**How It Works:**
User creates command definition file, command is invoked by name, expands to defined prompt in next message.

**Key Limitation:**
Only loads at session start - newly created commands not available until next session.

**Best Practices:**
- Don't use for built-in system commands
- Don't expect new commands to work immediately

---

#### Skill
**Purpose:** Execute specialized skill workflows

**Execution Model:** Loads skill prompt, then execute

**Best Uses:**
- Complex reusable capabilities
- Specialized domain expertise
- Team-shared workflows

**Skill Types:**
- Personal skills (user-only)
- Project skills (team-shared)
- Plugin skills (bundled)

---

## Use Cases by Category

### Development Workflows

**Feature Development:**
Read existing implementation to understand structure, plan necessary changes, make modifications to code, run tests in background while continuing work, check test results, commit and push changes when verified.

**Bug Fixing:**
Search for error pattern in codebase, read affected files to understand context, identify root cause of issue, implement fix, run tests to verify resolution, commit fix when confirmed working.

**Refactoring:**
Use exploration agent to understand codebase structure, develop refactoring strategy, make incremental file changes, run tests after each modification, commit when tests pass and refactoring complete.

**Code Review:**
Start linting, type checking, and tests in background simultaneously. While those run, read code changes, check for security issues, review documentation quality. As background tasks complete, incorporate their findings into review.

---

### Git Workflows

**Creating Commits:**
Check current repository status, examine detailed changes, understand existing commit message style, stage appropriate files, create commit with well-formatted message, verify successful commit.

**Creating Pull Requests:**
Check status, examine changes, review all commits in branch, understand full diff from base branch, create branch if needed, push to remote, create pull request with comprehensive description.

**Core Principles:**
Never force operations to main branches, never amend others' commits, never skip hooks without permission, never modify configuration without permission.

---

### Parallel Workflows

**Parallel Testing:**
Start unit tests, integration tests, and end-to-end tests in background. While running, review code, write documentation, fix obvious issues. As tests complete, report results and address failures.

**Multi-Repository Development:**
Deploy separate agents to different repositories (frontend, backend, mobile, documentation). Monitor all from mobile device. Merge as each completes successfully.

---

## Workflows & Patterns

### Pattern: Progressive Enhancement
Start comprehensive slow analysis in background. Start quick basic check in background. Quick check completes and provides initial results. Continue conversation. Slow analysis completes and provides detailed findings.

### Pattern: Dependency Chain
Install dependencies in background, wait for completion. Then start build in background, wait for completion. Then run tests in background, wait for completion. Report final results to user.

### Pattern: Speculative Execution
User mentions possible future need. Start preparatory work speculatively in background. Discuss options with user. When user confirms direction, preparation already complete.

### Pattern: Parallel Research
Launch multiple exploration agents simultaneously for different aspects of codebase. All run concurrently. Combine findings into comprehensive answer addressing all aspects.

---

## Limitations & Caveats

### Tool Execution
- All tools are blocking operations except background bash
- Checking background output is itself a blocking operation
- Task agents cannot be interrupted during execution
- File operations are synchronous with no parallelism

### Context & Memory
- Todo lists are ephemeral and lost between sessions
- Agents don't share context - each starts fresh
- Skills load only at session start - new ones unavailable until restart
- No persistent memory across sessions without files

### Git & GitHub
- Command-line GitHub tools may not be available
- Proxy authentication only for session repository
- Cannot create GitHub repositories remotely
- Commit signing requires proper configuration

### Network & Resources
- Disk space is generous but not unlimited
- Background tasks have maximum timeout
- Fast network connection available
- Web access is read-only for external APIs

### File Operations
- Read has default line limit (can be adjusted)
- Edit requires exact string matching with whitespace
- Write completely overwrites files
- Cannot read directories with read tool

---

## What to Avoid

### Anti-Patterns

**Using shell commands for file operations:**
Wrong: Execute shell command to read file
Right: Use dedicated file reading tool

Wrong: Execute shell command to search file contents
Right: Use dedicated search tool

Wrong: Execute shell command to find files
Right: Use dedicated pattern matching tool

**Sequential execution when parallel possible:**
Wrong: Read first file and wait, then read second file and wait
Right: Read both files in same message for parallel execution

**Checking background tasks immediately:**
Wrong: Start background task, immediately check output
Right: Start background task, do other work, check later

**Using background for fast commands:**
Wrong: Run trivial command in background
Right: Use foreground for quick operations

**Multiple sequential background checks:**
Wrong: Check background task one, check background task two, check background task three in rapid succession (blocks you three times and loses responsiveness)
Right: Check one task, continue conversation, later check another, continue conversation, even later check third

**Creating files unnecessarily:**
Wrong: Write new file without being asked
Right: Only create files when explicitly requested

**Using ephemeral todos for persistence:**
Wrong: Use todo list for multi-session project tracking
Right: Create file-based tracking for persistence

---

## Performance Optimization

### Maximize Parallelism
- Read multiple files in one message
- Start multiple background commands together
- Launch multiple task agents simultaneously
- Start all background work before checking any results

Avoid:
- Sequential file reads
- Starting background tasks one by one
- Checking background results in rapid succession

### Minimize Context Usage
- Use exploration agents for open-ended searches
- Use result limiting for large searches
- Read specific known files directly

Avoid:
- Reading entire codebase into context
- Unlimited search results
- Exploring with direct tools instead of agents

### Efficient Git Operations
- Chain dependent operations together
- Fetch specific branches rather than all
- Use local proxy for authentication

Avoid:
- Separate commands for dependent operations
- Fetching all branches unnecessarily
- Manual token management

### Smart Background Usage
- Use for long-running operations (several seconds or more)
- Use for multiple independent tasks in parallel
- Continue productive work while tasks run

Avoid:
- Fast operations (under a few seconds)
- Tasks needing immediate results
- Interactive commands

---

## Advanced Concepts

### Context Management
- Use ignore files to exclude unnecessary content from context
- Prefer specific file reads over directory scans
- Use task agents for exploration rather than direct tools
- Commit important state to files, not just ephemeral todos

### Mobile Optimization
- Launch agents in morning, review on mobile during day
- Use mobile applications for review workflows
- Background tasks perfect for mobile workflow
- Short focused work easier to review on mobile

### Session Handoff
- Use file-based tracking, not ephemeral todos
- Commit progress regularly
- Document assumptions in files
- Use conventional commit messages

### Error Recovery
- Always verify repository status after commits
- Confirm tests pass before pushing
- Use process termination to cancel failed operations
- Keep incremental commits for easy rollback

---

## Related Documentation

For deeper understanding of specific areas:
- Skills system deep dive
- Background processes and multitasking
- Creative applications
- Maximizing unlimited access strategies

---

*End of conceptual manual. Last updated: 2025-11-09*

This document focuses on understanding WHAT each tool does, WHEN to use it, and WHY, without implementation details. For specific syntax and examples, refer to the complete manual.
