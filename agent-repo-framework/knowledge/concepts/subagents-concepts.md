# Subagent Concepts Guide

## ⚠️ CRITICAL: Subagent Context Isolation

**ALL subagents (Task tool and custom @agents) have ZERO conversation context.**

This is the most important constraint to understand:

✅ **What subagents CAN access:**
- Files in the repository (via Read tool)
- Their own prompt (what you tell them in Task/invoke)
- Results from their tool calls

❌ **What subagents CANNOT access:**
- Conversation history from main session
- Things discussed with the user
- Context from previous subagent invocations
- Variables or state from calling agent

**Implication:** Every subagent invocation must be self-contained. If a subagent needs context, you must:
1. Write context to files
2. Tell subagent which files to read
3. Include complete instructions in prompt

**Example:**

**WRONG** - Subagent has no context:
"Fix the auth bug we discussed earlier"

**CORRECT** - Self-contained with file reference:
First write bug details to a file, then tell the subagent: "Read the auth bug report file for bug details, then fix the authentication file accordingly"

This applies to:
- Task tool subagents (general-purpose, Explore, Plan)
- Custom @agents defined in agent configuration
- ALL agent invocations are stateless

---

## Table of Contents
1. [What Are Subagents?](#what-are-subagents)
2. [Subagent Use Cases](#subagent-use-cases)
3. [Implementation Strategies](#implementation-strategies)
4. [Integration with VPS Multi-Agent System](#integration-with-vps-multi-agent-system)
5. [Communication Methods](#communication-methods)
6. [Advanced Patterns](#advanced-patterns)
7. [Context Management](#context-management)
8. [Skills Inheritance](#skills-inheritance)
9. [Best Practices](#best-practices)
10. [Troubleshooting](#troubleshooting)

---

## What Are Subagents?

### Definition

Subagents are specialized Claude instances created dynamically by a parent agent to handle specific tasks, domains, or workflows. They operate as independent agents with their own context, capabilities, and execution environment, while maintaining communication with their parent agent.

### Key Characteristics

- **Autonomy**: Each subagent can make decisions independently within its scope
- **Specialization**: Subagents are optimized for specific tasks (writing, reviewing, coding, etc.)
- **Communication**: Subagents report back to parent agents through defined channels
- **Isolation**: Each subagent maintains separate context and state
- **Scalability**: Multiple subagents can run in parallel or sequentially

### Types of Subagents

1. **Specialist Subagents**: Focused on a single domain (e.g., documentation writer, code reviewer)
2. **Worker Subagents**: Execute assigned tasks from a queue
3. **Supervisor Subagents**: Review and validate work from other agents
4. **Coordinator Subagents**: Orchestrate workflows across multiple agents
5. **Support Subagents**: Provide auxiliary services (file reading, API calls, research)

---

## Subagent Use Cases

### 1. Code Review Supervision

**Scenario**: A parent agent writes code, then spawns a reviewer subagent to validate it.

**Benefits**:
- Automatic quality control
- Catches bugs before deployment
- Enforces coding standards
- Multiple review passes without human intervention

**Example Flow**:
```
Parent Agent (Developer)
    ↓
    └─ Spawn Reviewer Subagent
         ↓
         ├─ Reads code
         ├─ Checks style
         ├─ Verifies logic
         └─ Reports issues back
    ↓
Parent applies feedback and resubmits
```

### 2. Documentation Generation

**Scenario**: A subagent specialized in documentation creation generates guides while the parent focuses on implementation.

**Benefits**:
- Documentation stays in sync with code
- Specialist formatter ensures consistency
- Can generate multiple documentation formats
- Parallel execution with implementation

**Example Flow**:
```
Parent Agent (Implementer)
    ├─ Implement feature
    └─ Spawn Documentation Subagent
         ├─ Extract code comments
         ├─ Generate API docs
         ├─ Create usage examples
         └─ Format as markdown/HTML
```

### 3. Research and Data Gathering

**Scenario**: While a main agent processes information, a subagent researches background context.

**Benefits**:
- Parallel information gathering
- Focused search queries
- Synthesis of multiple sources
- No blocking on research time

**Use Cases**:
- Web research for article writing
- API documentation lookup
- Competitor analysis
- Market research
- Historical context gathering

### 4. File Reading and Context Extraction

**Scenario**: A parent agent needs to understand multiple files, spawns subagent to read and summarize.

**Benefits**:
- Parallel file reading
- Structured extraction of information
- Reduced token usage through summarization
- Parent agent can work on other tasks

**Pattern**: Parent spawns subagent with a task description like "Extract function signatures from source code" along with a list of files to read.

### 5. Parallel Content Creation

**Scenario**: Parent agent needs 5 different sections written in parallel.

**Benefits**:
- 5x faster execution for independent content
- Consistent style across sections
- Each subagent specializes in its section
- Automatic merging when complete

**Example**:
```
Parent Agent (Project Manager)
    ├─ Spawn Section-A Subagent → Write architecture overview
    ├─ Spawn Section-B Subagent → Write API reference
    ├─ Spawn Section-C Subagent → Write usage guide
    ├─ Spawn Section-D Subagent → Write troubleshooting
    └─ Spawn Section-E Subagent → Write FAQ

Wait for all, then merge results
```

### 6. Task Queue Worker Pool

**Scenario**: Coordinator agent creates tasks, spawns worker subagents to claim and execute them.

**Benefits**:
- Scalable work distribution
- Automatic load balancing
- Long-running workers via stop hooks
- Independent task execution

**Key Pattern**: Coordinator spawns multiple workers, each configured to poll the queue, claim tasks, and execute them independently.

### 7. Supervision and Validation

**Scenario**: A supervisor subagent validates the work of multiple other agents.

**Benefits**:
- Independent quality checking
- Objective assessment
- Prevents conflicts of interest
- Ensures standards compliance

**Example**:
```
Main Agent A (Writer)
Main Agent B (Coder)
Main Agent C (Designer)
    ↓
    └─ Spawn Supervisor Subagent
         ├─ Reviews writing quality
         ├─ Checks code style
         ├─ Validates design
         └─ Approves or rejects each component
```

### 8. The "Conference Table" Pattern

**Scenario**: Multiple agents discuss a problem and reach consensus.

**Benefits**:
- Multiple perspectives
- Collaborative decision-making
- Better risk assessment
- Documented reasoning

**Example**:
```
Parent Agent (Decision Maker)
    ├─ Spawn Optimist Subagent → Highlight benefits
    ├─ Spawn Pessimist Subagent → Identify risks
    ├─ Spawn Pragmatist Subagent → Assess feasibility
    └─ Spawn Mediator Subagent → Synthesize views

Read all perspectives, make informed decision
```

---

## Implementation Strategies

### 1. Sequential Execution

**When to use**: When one task must complete before the next starts.

**Characteristics**:
- Simple parent-child relationship
- Parent waits for each subagent to complete
- Guaranteed order of execution
- Easier error handling

**Conceptual Example**:
```
Step 1: Generate code
Step 2: Review the code (wait for step 1)
Step 3: Apply feedback (wait for step 2)
```

**Advantages**:
- Clear dependencies
- Easy debugging
- Straightforward error handling

**Disadvantages**:
- Slower (sequential execution)
- Subagents wait idle
- Not optimal for parallel work

### 2. Parallel Execution

**When to use**: When multiple independent tasks can run simultaneously.

**Characteristics**:
- Multiple subagents run at same time
- Parent gathers results and combines them
- Much faster for independent work
- Requires coordination for merging results

**Conceptual Example**:
Spawn multiple subagents at once (for introduction, methods, results, conclusion sections), wait for all to complete, then combine the results into a final document.

**Advantages**:
- Much faster execution
- Better resource utilization
- Ideal for independent work

**Disadvantages**:
- More complex coordination
- Harder error handling
- Need to merge results

### 3. Nested (Hierarchical) Execution

**When to use**: When subagents themselves need to spawn sub-subagents.

**Characteristics**:
- Multi-level hierarchy
- Subagents can create their own subagents
- Complex workflows
- More resource usage

**Example**:
```
Level 1: Main coordinator
    ↓
Level 2: Domain coordinators
├─ Backend Coordinator
│   ├─ Database Subagent
│   ├─ API Subagent
│   └─ Cache Subagent
├─ Frontend Coordinator
│   ├─ UI Subagent
│   ├─ State Management Subagent
│   └─ Testing Subagent
└─ DevOps Coordinator
    ├─ Infrastructure Subagent
    ├─ CI/CD Subagent
    └─ Monitoring Subagent
```

**Use Cases**:
- Large projects with many components
- Hierarchical task decomposition
- Domain-specific orchestration

**Considerations**:
- Complexity increases exponentially
- Harder to debug
- Resource management crucial
- Communication overhead

### 4. Hybrid Approach

**When to use**: Most real-world scenarios that combine sequential and parallel patterns.

**Characteristics**:
- Some tasks run in parallel
- Some tasks have dependencies
- Optimizes for both speed and correctness
- Requires careful orchestration

**Conceptual Example**:
1. Sequential: Planning must happen first
2. Parallel: Implementation of multiple modules happens simultaneously
3. Sequential: Testing happens after all implementation complete
4. Parallel: Can fix multiple issues in parallel
5. Final merge of all fixes

---

## Integration with VPS Multi-Agent System

### Overview

The VPS multi-agent system provides infrastructure for:
- Task queue management
- Worker persistence via stop hooks
- Shared file system on VPS
- Decoupled agent communication

Subagents integrate with this system through:
1. **Task Queue**: Subagents pull from VPS task queue
2. **Shared Files**: Subagents read/write to shared VPS directory
3. **Idle Management**: Subagents use stop hooks for persistence
4. **Coordination**: Through VPS API

### Architecture Integration

```
Claude Code Environment
├─ Parent Agent (Coordinator)
│   ├─ Spawns Worker Subagent 1
│   │   └─ Claims tasks from VPS queue
│   │   └─ Executes tasks
│   │   └─ Reports results via VPS API
│   │
│   ├─ Spawns Worker Subagent 2
│   │   └─ Claims tasks from VPS queue
│   │   └─ Executes tasks
│   │   └─ Reports results via VPS API
│   │
│   └─ Spawns Supervisor Subagent
│       └─ Validates work
│       └─ Approves/rejects tasks
│
VPS Backend
├─ Task Queue
│   ├─ Pending tasks
│   ├─ In-progress tasks
│   └─ Completed tasks
├─ Shared Workspace
│   ├─ Code files
│   ├─ Data files
│   └─ Result files
└─ APIs
    ├─ Queue operations (add, claim, complete tasks)
    ├─ File operations (read, write)
    └─ Command execution
```

### Worker Pattern

**Worker subagents that work with VPS queue**:

**Conceptual flow**:
1. Worker enters continuous polling loop
2. Check for tasks in queue
3. If task exists:
   - Claim the task (resets idle timer)
   - Execute the task
   - Report results back to VPS
   - Handle any failures gracefully
4. If no task exists:
   - Sleep briefly before polling again
   - Stop hook will end worker if idle too long

**Stop hook concept**: Decides if worker should continue running based on idle time. Important: idle time resets when a task is claimed or completed (NOT based on total runtime since worker started).

### Coordinator Pattern

**Coordinator agent that creates tasks for workers**:

**Conceptual flow**:
1. Define all work that needs to be done
2. Create tasks in VPS queue
3. Wait for workers to complete (workers spawned elsewhere or pre-existing)
4. Monitor progress periodically
5. When all tasks complete, gather and process results
6. Return final output

### Key Integration Points

1. **Task Queue Management**
   - Coordinator: Adds tasks to queue
   - Worker: Claims tasks from queue
   - Worker: Marks tasks complete

2. **File Operations**
   - Read files from VPS
   - Write files to VPS
   - List directory contents

3. **Command Execution**
   - Execute commands on VPS
   - Used for setup, cleanup, system tasks

---

## Communication Methods

### 1. Direct Returns (Sequential Pattern)

**Best for**: Sequential subagent calls where parent waits.

**Mechanism**: Parent spawns and waits for subagent. Subagent returns result directly to parent.

**Advantages**:
- Simple implementation
- Synchronous, easy to follow
- Immediate feedback

**Limitations**:
- Parent blocks while waiting
- Only one subagent at a time
- Not suitable for long-running tasks

### 2. Shared Files (Async Pattern)

**Best for**: Parallel execution, long-running tasks, large data.

**Mechanism**:
1. Parent writes task specification to a file
2. Spawns subagent (doesn't wait) with instructions to read the file and write results
3. Parent can continue with other work
4. Later, parent checks for results file
5. Read results when available

**Advantages**:
- Non-blocking
- Can handle large data
- Multiple subagents work in parallel
- Suitable for long-running tasks

**Considerations**:
- Need polling or callbacks
- File format must be agreed upon
- Coordination overhead

### 3. Task Queue (Scalable Pattern)

**Best for**: Many independent tasks, worker pools.

**Mechanism**:
1. Coordinator creates tasks in queue
2. Workers poll queue continuously
3. Workers claim next available task
4. Workers process task and mark complete
5. Workers continue polling (or stop if idle too long)

**Advantages**:
- Scalable to many workers
- Automatic load balancing
- Clear status tracking
- Persistent workers

**Use Cases**:
- Data processing pipelines
- Content generation
- Multi-file operations
- Batch processing

### 4. HTTP API (Custom Endpoints)

**Best for**: Custom integrations, special protocols.

**Mechanism**: Subagent makes HTTP calls to custom API endpoints or existing services. Can support webhooks/callbacks for asynchronous notifications.

**Advantages**:
- Full control over protocol
- Can integrate external services
- Supports webhooks/callbacks

**Considerations**:
- Requires running API
- More infrastructure
- Error handling complexity

### 5. Environment Variables

**Best for**: Configuration, simple status flags.

**Mechanism**: Parent sets environment variables, subagent reads them.

**Limitations**:
- Only small strings
- Not persistent across sessions
- Security concerns

---

## Advanced Patterns

### 1. Supervisor Pattern

**Purpose**: Quality control, validation, approval workflows.

**Structure**:
```
Work Agent (creates content)
    ↓
    └─ Spawn Supervisor (validates work)
         ├─ If approved → Done
         └─ If rejected → Send back to Work Agent
```

**Conceptual Implementation**:
1. Create work
2. Get supervisor feedback
3. If approved, done
4. If rejected, fix issues and resubmit
5. Repeat up to max iterations

**Benefits**:
- Automatic quality gates
- Multiple review passes
- Prevents bad work from propagating
- Clear approval workflow

### 2. Conference Table Pattern

**Purpose**: Multi-perspective analysis, consensus decision-making.

**Structure**:
```
Decision Point
    ├─ Spawn Optimist (highlight opportunities)
    ├─ Spawn Pessimist (identify risks)
    ├─ Spawn Pragmatist (assess feasibility)
    └─ Spawn Mediator (synthesize views)

    ↓
Parent Agent
    └─ Make informed decision
```

**Conceptual Implementation**:
1. Spawn multiple subagents with different perspectives (in parallel)
2. Wait for all perspectives to complete
3. Spawn a mediator to synthesize all views
4. Parent makes informed decision based on synthesis

**Benefits**:
- Reduces blind spots
- Better risk assessment
- Documented reasoning
- More balanced decisions

### 3. Auto-Spawning Worker Pool

**Purpose**: Automatically create workers as needed, clean up when done.

**Conceptual Mechanism**:
1. Maintain a pool of active workers
2. Monitor pending tasks in queue
3. If tasks outnumber workers, spawn new workers (up to max limit)
4. Remove workers that have completed or stopped
5. Continue until all work done and workers cleaned up

**Benefits**:
- Scales with workload
- Automatic cleanup
- Cost-efficient
- Handles variable load

### 4. Coordinator + Worker Pattern (with Stop Hooks)

**Purpose**: Scalable, persistent task processing on VPS.

**Architecture**:
```
Coordinator Session
    ├─ Analyze work
    ├─ Create task queue on VPS
    ├─ Spawn persistent workers
    └─ End session
         ↓
         (Workers continue via stop hook)
         ↓
Worker Sessions (multiple)
    ├─ Wake up periodically
    ├─ Poll queue
    ├─ Claim and execute task
    └─ Sleep until next poll
         ↓
         (Stop hook checks: idle > threshold? If yes, terminate)
```

**Key Concept**: Workers use stop hooks to continue running beyond normal session timeouts. Stop hook checks idle time (time since last task) and decides whether to keep worker alive or terminate it.

---

## Context Management

### ⚠️ Context Management (File-Based Only)

**CRITICAL:** The context you can "manage" is what you pass in the prompt and what files the subagent reads. Subagents have NO access to conversation history.

### 1. Prompt Context

**Best Practice**: Include relevant context in spawn prompt.

**Good example**: Provide complete instructions including what to do, specific requirements, formatting guidelines, and expected output.

**Bad example**: Vague instruction like "Format some code for me" without details.

### 2. File-Based Context

**Use when**: Context is large or binary.

**Pattern**: Write context to a file, then tell subagent to read that specific file and perform operations based on its content.

### 3. Environment Variables

**Use when**: Small configuration needed.

**Pattern**: Set environment variables, then include them in the subagent prompt so the subagent knows configuration values.

### 4. Instruction Templates

**Use when**: Reusing instructions across subagents.

**Pattern**: Define a template with placeholders, fill in specific values for each subagent invocation, ensures consistency across multiple similar subagents.

---

## Skills Inheritance

### 1. Subagent Skills Inheritance

**Concept**: Subagents inherit skills from their parent environment.

When spawning a subagent, it can use all the same skills that are available in the parent environment. The subagent can be instructed to use specific skills as part of its task.

### 2. Custom Skills for Subagents

**Scenario**: Create specialized skills for specific subagent types.

**Example categories**:
- Supervisor validation skills
- Worker task execution skills
- Coordinator orchestration skills

Different subagent types can have specialized skills tailored to their roles.

### 3. Skill Versioning

**For complex projects**: Version skills for consistency.

**Pattern**: When spawning workers, specify which version of a skill they should use to ensure all workers operate consistently.

---

## Best Practices

### 1. Clear Specification

**Always provide detailed requirements**:

**Good**: Provide complete task description including what to do, format requirements, output location, and specific criteria.

**Bad**: Vague instruction without details.

### 2. Error Handling

**Always handle subagent failures**:

**Pattern**: Wrap subagent spawning in retry logic with exponential backoff. Validate results and retry if needed. Set maximum retry attempts to avoid infinite loops.

### 3. Progress Tracking

**Monitor subagent progress for long-running tasks**:

**Pattern**: Create a status file, instruct subagent to periodically update it with progress, parent checks status file to monitor completion percentage and identify any issues.

### 4. Resource Management

**Limit concurrent subagents to avoid overload**:

**Pattern**: Implement a pool manager that enforces maximum concurrent subagents. Queue requests when at capacity, spawn new subagents only when slots available.

### 5. Clear Communication Protocol

**Document how subagents communicate results**:

**Pattern**: Define a standard format for task results (task ID, status, output, execution time, errors, timestamp). Instruct all subagents to use this format. Makes result processing consistent and predictable.

### 6. Timeout Management

**Prevent hanging subagents**:

**Pattern**: Include timeout in subagent instructions. Instruct subagent to save progress to checkpoint files if approaching timeout. Parent monitors elapsed time and can terminate if needed.

### 7. Logging and Debugging

**Always add logging for subagent activities**:

**Pattern**: Log when spawning subagents, log their prompts, log when they complete, log results. On errors, log exceptions. Comprehensive logging makes debugging multi-agent systems much easier.

---

## Troubleshooting

### Issue: Subagent Doesn't Start

**Symptoms**: Subagent creation returns immediately with no output.

**Solutions**:
1. Check environment has sufficient resources
2. Verify prompt is clear and specific
3. Check subagent description is valid
4. Ensure API keys/credentials are available to subagent

### Issue: Subagent Stops Unexpectedly

**Symptoms**: Subagent completes work early or stops mid-task.

**Solutions**:
1. Check for hard timeouts in Claude Code environment
2. Review stop hook logic (if applicable)
3. Add checkpointing for long tasks
4. Increase timeout in subagent prompt

### Issue: Subagents Can't Communicate

**Symptoms**: Results not being returned or files not created.

**Solutions**:
1. Verify file paths are correct
2. Check file permissions on VPS
3. Use absolute paths, not relative
4. Test file operations manually first

### Issue: Workers Die Too Quickly

**Symptoms**: Worker subagents terminate immediately.

**Solutions**:
1. Check stop hook idle timeout logic
2. Ensure tasks exist in queue to claim
3. Verify idle timer resets on task claim
4. Check for errors in worker loop

### Issue: Too Many Subagents

**Symptoms**: Errors about exceeding resource limits.

**Solutions**:
1. Implement subagent pooling
2. Reduce max concurrent setting
3. Use sequential execution for non-critical tasks
4. Monitor and clean up completed subagents

### Issue: Subagent Context Too Large

**Symptoms**: Prompt becomes too long, subagent confused.

**Solutions**:
1. Move large data to files
2. Summarize context instead of full text
3. Use multiple subagents for different aspects
4. Create focused prompts for each subagent

---

## Summary Table: When to Use Which Pattern

| Pattern | Best For | Parallel | Async | Complexity |
|---------|----------|----------|-------|-----------|
| Sequential | Simple tasks, dependencies | No | No | Low |
| Parallel | Independent work, speed | Yes | Yes | Medium |
| Nested | Complex hierarchies | Yes | Yes | High |
| Supervisor | Quality control | Mixed | Yes | Medium |
| Conference | Decision-making | Yes | Yes | Medium |
| Auto-Pool | Variable workloads | Yes | Yes | High |
| Task Queue | Scalable processing | Yes | Yes | Medium |

---

## Context Isolation Examples

### Example 1: Research Task (WRONG vs CORRECT)

**WRONG (assumes conversation context):**
- User discussed building a Flask API for user management
- You tell subagent: "Research best practices for the API we're building"
- Subagent responds: "What API? I have no context."

**CORRECT (self-contained):**
1. Write context to a file describing the current project: Flask API for user management with requirements
2. Tell subagent: "Read the project context file for project details. Research best practices for Flask user management APIs. Focus on JWT auth, database models, REST endpoints. Write findings to a research file."

### Example 2: Code Review (WRONG vs CORRECT)

**WRONG (assumes context):**
- You just wrote a User model file
- You tell subagent: "Review the User model I just created"
- Subagent responds: "What User model? Where?"

**CORRECT (file reference):**
Tell subagent: "Read the User model file and review it. Check for SQL injection vulnerabilities, password hashing security, field validation, and database indexing. Write review to a review file."

### Example 3: Multi-Step Workflow (WRONG vs CORRECT)

**WRONG (assumes memory between invocations):**
- First subagent: "Research database options"
- Subagent writes findings somewhere
- Second subagent: "Now recommend the best option"
- Second subagent responds: "Best option for what? I don't remember the research."

**CORRECT (file-based state):**
- First subagent: "Research database options for Python web apps. Consider PostgreSQL, MySQL, SQLite. Write comparison to a specific file."
- Second subagent: "Read the database comparison file. Based on that comparison, recommend best option for: Flask app, 10K users expected, needs complex queries. Write recommendation to another specific file."

---

## Key Takeaways

1. **Context Isolation is Absolute**: Subagents have zero memory of conversations or previous invocations. Always provide complete context in prompts or files.

2. **Choose the Right Pattern**: Sequential for dependencies, parallel for speed, task queue for scalability, supervisor for quality control.

3. **Communication Through Files**: For complex workflows, use shared files on VPS to pass information between agents and track state.

4. **Stop Hooks Enable Persistence**: Workers can run for extended periods by using stop hooks that check idle time (not total time).

5. **Error Handling is Critical**: Always implement retry logic, timeouts, and comprehensive logging for multi-agent systems.

6. **Specialization Wins**: Create focused subagents with clear responsibilities rather than general-purpose agents trying to do everything.

7. **Parallel Execution for Speed**: When tasks are independent, spawn multiple subagents simultaneously to dramatically reduce execution time.

8. **VPS Integration for Scale**: Use VPS task queue system for true multi-agent coordination across sessions and time.

---

## Additional Resources

- See VPS multi-agent architecture knowledge for VPS system details
- See stop hooks and worker persistence knowledge for worker longevity
- See VPS API specification knowledge for API reference
- See task queue coordination knowledge for queue management details

---

**Last Updated**: 2025-11-09
**Version**: 1.0 (Concept-Only)
**Status**: Complete
