# Subagent Complete Guide

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

**Example**:
```python
# Parent agent spawns subagent with task
spawn_subagent(
    description="Extract function signatures from source code",
    prompt="Read and extract all function definitions from files...",
    files_to_read=['src/main.py', 'src/utils.py']
)
```

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

**Key Pattern** (from VPS system):
```python
# Coordinator spawns workers
for i in range(num_workers):
    spawn_worker_subagent(
        worker_id=f"worker-{i}",
        prompt="Poll queue, claim tasks, execute them"
    )
```

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

**Example**:
```python
# Step 1: Generate code
code = execute_main_task("Write Python function")

# Step 2: Review the code
review = spawn_and_wait_subagent(
    description="Code Reviewer",
    prompt=f"Review this code: {code}"
)

# Step 3: Apply feedback
if issues_found(review):
    code = spawn_and_wait_subagent(
        description="Code Fixer",
        prompt=f"Fix these issues: {review}"
    )
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

**Example**:
```python
# Spawn all subagents
tasks = []
for section in ['intro', 'implementation', 'conclusion', 'refs']:
    task = spawn_subagent_async(
        description=f"Write {section}",
        prompt=f"Write the {section} section of the paper"
    )
    tasks.append(task)

# Wait for all to complete
results = wait_all(tasks)

# Combine results
final_document = combine_sections(results)
```

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
```python
# Level 1: Main coordinator
main_coordinator()
    ↓
# Level 2: Domain coordinators
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

**Example**:
```python
# Sequential: Planning must happen first
plan = generate_project_plan()

# Parallel: Implementation can happen in parallel
implementation_tasks = []
for module in plan.modules:
    task = spawn_subagent_async(
        description=f"Implement {module}",
        prompt=f"Implement this module: {module}"
    )
    implementation_tasks.append(task)

results = wait_all(implementation_tasks)

# Sequential: Testing happens after implementation
test_results = spawn_and_wait_subagent(
    description="Tester",
    prompt=f"Test these implementations: {results}"
)

# Parallel: Can improve multiple sections in parallel
improvements = []
for issue in test_results.issues:
    task = spawn_subagent_async(
        description=f"Fix {issue}",
        prompt=f"Fix this issue: {issue}"
    )
    improvements.append(task)

final_code = merge_all(improvements)
```

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
│   ├─ /code
│   ├─ /data
│   └─ /results
└─ APIs
    ├─ /queue (add, claim, complete tasks)
    ├─ /files (read, write)
    └─ /execute (run commands)
```

### Worker Pattern

**Worker subagents that work with VPS queue**:

```python
# Worker subagent code (runs in Claude Code environment)

def worker_loop():
    """Poll task queue and execute tasks"""
    while True:
        # 1. Check for tasks in queue
        task = claim_task_from_vps_queue()

        if task:
            # 2. Reset idle timer (via task claim)
            try:
                # 3. Execute the task
                result = execute_task(task)

                # 4. Report results back to VPS
                complete_task_on_vps(task_id=task['id'], result=result)

            except Exception as e:
                # 5. Handle failures gracefully
                fail_task_on_vps(task_id=task['id'], error=str(e))

        # 6. Sleep briefly before polling again
        time.sleep(5)  # Poll every 5 seconds
        # Stop hook will end this worker if idle > 10 minutes

# Stop hook in .claude/hooks/worker-stop-check.py
def should_worker_continue():
    """Decide if worker should continue running"""
    idle_time = time.time() - last_task_completion

    # IMPORTANT: Idle time resets when task is claimed/completed
    # NOT total runtime since registration
    if idle_time > 600:  # 10 minutes
        return "approve"  # Stop worker
    return "block"  # Keep worker running
```

### Coordinator Pattern

**Coordinator agent that creates tasks for workers**:

```python
# Coordinator subagent code

def coordinator():
    """Create and manage tasks for workers"""

    # 1. Define work that needs to be done
    work_items = [
        {"id": 1, "task": "Process file A"},
        {"id": 2, "task": "Process file B"},
        {"id": 3, "task": "Process file C"},
    ]

    # 2. Create tasks in VPS queue
    for item in work_items:
        add_task_to_vps_queue({
            "task_id": item["id"],
            "description": item["task"],
            "priority": "normal",
            "created_at": datetime.now()
        })

    # 3. Wait for workers to complete
    # (Workers spawned elsewhere or pre-existing)

    # 4. Monitor progress
    while True:
        status = get_queue_status_from_vps()

        if status['pending'] == 0 and status['in_progress'] == 0:
            # All tasks complete
            break

        time.sleep(10)  # Check every 10 seconds

    # 5. Gather and process results
    results = fetch_all_completed_tasks_from_vps()
    final_output = process_results(results)

    return final_output
```

### Key Integration Points

1. **Task Queue Management**
   - Coordinator: `POST /queue/add`
   - Worker: `POST /queue/claim`
   - Worker: `POST /queue/complete`

2. **File Operations**
   - Read: `GET /files/read?path=...`
   - Write: `POST /files/write`
   - List: `GET /files/list?path=...`

3. **Command Execution**
   - Execute: `POST /execute`
   - Used for setup, cleanup, system tasks

---

## Communication Methods

### 1. Direct Returns (Sequential Pattern)

**Best for**: Sequential subagent calls where parent waits.

**Mechanism**:
```python
# Parent spawns and waits
result = spawn_and_wait_subagent(
    description="Translator",
    prompt="Translate this text: ..."
)

# Subagent returns result directly
return translated_text
```

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
```python
# Parent writes task specification
write_file("/vps/tasks/task_1.json", {
    "task_id": 1,
    "input_data": "...",
    "status": "pending"
})

# Spawn subagent (doesn't wait)
spawn_subagent_async(
    description="Processor",
    prompt="Read /vps/tasks/task_1.json, process, write results"
)

# Parent can continue with other work
do_other_work()

# Later, parent checks results
while not file_exists("/vps/tasks/task_1_results.json"):
    time.sleep(1)

results = read_file("/vps/tasks/task_1_results.json")
```

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
```python
# Coordinator creates tasks in queue
for work_item in work_items:
    add_to_queue({
        "id": work_item['id'],
        "data": work_item['data'],
        "status": "pending"
    })

# Workers poll queue
while True:
    task = claim_next_task()
    if task:
        result = process_task(task)
        mark_task_complete(task['id'], result)
    else:
        sleep(5)  # Idle, but stop hook will terminate if > 10 min idle
```

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

**Mechanism**:
```python
# Parent creates custom API endpoint (or existing service)
# Subagent makes HTTP calls

subagent_prompt = """
POST http://api.custom.local/process
{
    "data": "...",
    "callback": "http://callback.local/results"
}

Wait for callback with results
"""

spawn_subagent(description="API Client", prompt=subagent_prompt)
```

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

**Mechanism**:
```python
# Parent sets environment variable
os.environ['TASK_STATUS'] = 'pending'
os.environ['TASK_DATA'] = json.dumps(data)

# Subagent reads it
task_status = os.getenv('TASK_STATUS')
task_data = json.loads(os.getenv('TASK_DATA'))

# Subagent updates status
os.environ['TASK_RESULT'] = json.dumps(result)
```

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

**Implementation**:
```python
def work_with_supervisor():
    max_iterations = 3

    for iteration in range(max_iterations):
        # Create work
        work = generate_content()

        # Get supervisor feedback
        feedback = spawn_and_wait_subagent(
            description="Supervisor",
            prompt=f"""
            Review this work: {work}

            Respond with:
            APPROVED: if it meets standards
            REJECTED: detailed issues if not
            """
        )

        if "APPROVED" in feedback:
            return work

        # Try to fix issues
        work = spawn_and_wait_subagent(
            description="Content Improver",
            prompt=f"Fix these issues: {feedback}"
        )

    # Return best effort after max iterations
    return work
```

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

**Implementation**:
```python
def make_decision(problem):
    perspectives = {}

    # Get different viewpoints in parallel
    tasks = []

    # Optimist
    tasks.append(spawn_subagent_async(
        description="Optimist",
        prompt=f"What are the best-case scenarios and benefits? {problem}"
    ))

    # Pessimist
    tasks.append(spawn_subagent_async(
        description="Pessimist",
        prompt=f"What are the risks and potential failures? {problem}"
    ))

    # Pragmatist
    tasks.append(spawn_subagent_async(
        description="Pragmatist",
        prompt=f"What is realistic given constraints? {problem}"
    ))

    # Wait for all perspectives
    results = wait_all(tasks)

    # Synthesize
    synthesis = spawn_and_wait_subagent(
        description="Mediator",
        prompt=f"""
        Given these perspectives:
        Optimist: {results[0]}
        Pessimist: {results[1]}
        Pragmatist: {results[2]}

        Synthesize into balanced recommendation.
        """
    )

    return synthesis
```

**Benefits**:
- Reduces blind spots
- Better risk assessment
- Documented reasoning
- More balanced decisions

### 3. Auto-Spawning Worker Pool

**Purpose**: Automatically create workers as needed, clean up when done.

**Mechanism**:
```python
def auto_spawning_coordinator(work_items, max_workers=5):
    """
    Create workers on demand, remove when idle
    """
    active_workers = []
    work_queue = list(work_items)

    def spawn_worker(worker_id):
        """Spawn a worker subagent"""
        worker = spawn_subagent_async(
            description=f"Worker-{worker_id}",
            prompt="""
            While there is work:
                1. Claim next task from queue
                2. Execute task
                3. Report results
                4. Sleep 5 seconds

            Stop hook will terminate when idle > 10 minutes
            """
        )
        return worker

    # Spawn initial workers
    for i in range(min(len(work_items), max_workers)):
        worker = spawn_worker(i)
        active_workers.append(worker)

    # Monitor and spawn additional workers as needed
    while work_queue or active_workers:
        # Check if we need more workers
        pending_tasks = count_pending_tasks_in_queue()
        active_count = count_active_workers(active_workers)

        if pending_tasks > active_count and active_count < max_workers:
            new_worker = spawn_worker(len(active_workers))
            active_workers.append(new_worker)

        # Remove completed workers
        active_workers = [w for w in active_workers if w.is_running()]

        time.sleep(10)

        # Check if done
        if pending_tasks == 0 and len(active_workers) == 0:
            break

    return gather_all_results()
```

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
         (Stop hook checks: idle > 10 min? If yes, terminate)
```

**Code Structure**:
```python
# coordinator.md (main agent instructions)
"""
You are the Coordinator Agent.

1. Read the work list
2. For each work item:
   POST /queue/add with item details
3. Spawn 3 worker subagents
4. Monitor progress until complete
5. Gather results
"""

# worker.md (subagent instructions)
"""
You are a Worker Agent.

While working:
1. Check /queue/next-task
2. If task exists:
   - Claim it
   - Execute it
   - Report results
   - Reset idle timer
3. If no task:
   - Sleep 30 seconds
   - Repeat
"""

# .claude/hooks/worker-stop-check.py
import time

IDLE_TIMEOUT = 600  # 10 minutes

last_activity = time.time()

def handle_stop_hook(context):
    global last_activity

    # Check if task was just claimed/completed
    if recent_task_activity():
        last_activity = time.time()

    idle_time = time.time() - last_activity

    if idle_time > IDLE_TIMEOUT:
        return {
            "approve": True,  # Stop the worker
            "message": f"Idle for {idle_time}s, stopping"
        }

    return {
        "approve": False,  # Keep running
        "idle_time": idle_time
    }
```

---

## Context Management

### 1. Prompt Context

**Best Practice**: Include relevant context in spawn prompt.

```python
# Good: Subagent knows what to do
spawn_subagent(
    description="Code Formatter",
    prompt=f"""
    Format this Python code according to PEP 8:

    {code_to_format}

    Include:
    - Proper indentation (4 spaces)
    - Docstrings for all functions
    - Type hints where applicable
    - Comments for complex logic
    """
)

# Bad: Unclear requirements
spawn_subagent(
    description="Code Formatter",
    prompt="Format some code for me"
)
```

### 2. File-Based Context

**Use when**: Context is large or binary.

```python
# Write context to file
write_file("/vps/context/project_structure.json", project_data)

# Spawn subagent pointing to context
spawn_subagent(
    description="Project Analyzer",
    prompt="""
    Read /vps/context/project_structure.json
    Analyze the project structure
    Generate summary report
    """
)
```

### 3. Environment Variables

**Use when**: Small configuration needed.

```python
import os

os.environ['PROJECT_NAME'] = 'my-project'
os.environ['VERSION'] = '2.0'
os.environ['DEBUG'] = 'true'

spawn_subagent(
    description="Builder",
    prompt=f"""
    You're working on: {os.getenv('PROJECT_NAME')}
    Version: {os.getenv('VERSION')}
    Debug mode: {os.getenv('DEBUG')}

    Build the project accordingly.
    """
)
```

### 4. Instruction Templates

**Use when**: Reusing instructions across subagents.

```python
REVIEWER_TEMPLATE = """
You are a {domain} reviewer.

Review the following {domain} work:

{content}

Criteria:
1. {criterion_1}
2. {criterion_2}
3. {criterion_3}

Respond with:
APPROVED: if all criteria met
REJECTED: with specific issues if not
"""

def spawn_reviewer(domain, content, criteria):
    prompt = REVIEWER_TEMPLATE.format(
        domain=domain,
        content=content,
        criterion_1=criteria[0],
        criterion_2=criteria[1],
        criterion_3=criteria[2]
    )

    return spawn_and_wait_subagent(
        description=f"{domain} Reviewer",
        prompt=prompt
    )
```

---

## Skills Inheritance

### 1. Subagent Skills Inheritance

**Concept**: Subagents inherit skills from their parent environment.

```python
# Parent environment has these skills:
# - vps-deploy/
# - code-review/
# - document-generator/

# When spawning subagent, it can use inherited skills
spawn_subagent(
    description="Code Generator",
    prompt="""
    Generate Python code for:
    1. Parse JSON
    2. Validate data
    3. Store in database

    After generating, use the 'code-review' skill
    to validate the code.
    """
)
```

### 2. Custom Skills for Subagents

**Scenario**: Create specialized skills for specific subagent types.

```
.claude/skills/
├── vps-deploy/
├── code-review/
├── document-generator/
├── supervisor-validator/      ← New for supervisor subagents
├── worker-task-executor/      ← New for worker subagents
└── coordinator-orchestrator/  ← New for coordinator subagents
```

**Supervisor Skill**:
```python
# .claude/skills/supervisor-validator/skill.md
"""
# Supervisor Validation Skill

## Functions

### validate_work(work, criteria)
Check work against criteria

### generate_feedback(issues)
Create actionable feedback

### approve_or_reject(feedback)
Return structured decision
"""
```

### 3. Skill Versioning

**For complex projects**: Version skills for consistency.

```python
# Coordinator spawns workers with specific skill version
spawn_subagent(
    description="Worker",
    prompt="""
    Use skill: code-review@2.1

    Process tasks from queue using:
    - Code validation 2.1
    - PEP 8 checks 2.1
    - Type checking 2.1
    """
)
```

---

## Best Practices

### 1. Clear Specification

**Always provide detailed requirements**:

```python
# Good
spawn_subagent(
    description="Documentation Writer",
    prompt="""
    Write API documentation for:

    Functions:
    - process_data(input: dict) -> dict
    - validate_input(input: dict) -> bool

    Format:
    - Markdown
    - Include type hints
    - Include examples
    - Include error cases

    Output file: /vps/docs/api.md
    """
)

# Bad
spawn_subagent(
    description="Documentation Writer",
    prompt="Write documentation"
)
```

### 2. Error Handling

**Always handle subagent failures**:

```python
def safe_spawn(description, prompt, max_retries=3):
    """Spawn subagent with retry logic"""

    for attempt in range(max_retries):
        try:
            result = spawn_and_wait_subagent(
                description=description,
                prompt=prompt
            )

            if result and "error" not in result.lower():
                return result

        except Exception as e:
            print(f"Attempt {attempt+1} failed: {e}")
            if attempt < max_retries - 1:
                time.sleep(2 ** attempt)  # Exponential backoff

    raise Exception(f"Failed after {max_retries} attempts")
```

### 3. Progress Tracking

**Monitor subagent progress for long-running tasks**:

```python
def spawn_with_progress(description, prompt, check_interval=30):
    """Spawn subagent with progress monitoring"""

    # Create status file
    status_file = f"/vps/progress/{description}.json"
    write_file(status_file, {"status": "started"})

    # Include check-in instruction in prompt
    full_prompt = f"""
    {prompt}

    Additionally:
    - Every 5 minutes, write progress to {status_file}
    - Include: current_step, completion_percent, any_issues
    """

    subagent = spawn_subagent_async(
        description=description,
        prompt=full_prompt
    )

    # Monitor progress
    while subagent.is_running():
        status = read_file(status_file)
        print(f"Progress: {status['completion_percent']}%")
        time.sleep(check_interval)

    return read_file(status_file)
```

### 4. Resource Management

**Limit concurrent subagents to avoid overload**:

```python
class SubagentPool:
    def __init__(self, max_concurrent=5):
        self.max_concurrent = max_concurrent
        self.active = []

    def spawn(self, description, prompt):
        """Spawn subagent, respecting concurrency limit"""

        # Wait until slot available
        while len(self.active) >= self.max_concurrent:
            self.active = [a for a in self.active if a.is_running()]
            time.sleep(1)

        # Spawn subagent
        subagent = spawn_subagent_async(
            description=description,
            prompt=prompt
        )

        self.active.append(subagent)
        return subagent

    def wait_all(self):
        """Wait for all subagents to complete"""

        while self.active:
            self.active = [a for a in self.active if a.is_running()]
            time.sleep(1)
```

### 5. Clear Communication Protocol

**Document how subagents communicate results**:

```python
# Example: Task completion format
TASK_RESULT_FORMAT = {
    "task_id": "string",
    "status": "success|failure",
    "output": "string or object",
    "execution_time": "seconds",
    "errors": ["list of error messages"],
    "timestamp": "ISO 8601"
}

# Subagent instructions
spawn_subagent(
    description="Task Executor",
    prompt=f"""
    Execute the task and return results in this format:
    {json.dumps(TASK_RESULT_FORMAT, indent=2)}

    Write results to: /vps/results/task_1.json
    """
)
```

### 6. Timeout Management

**Prevent hanging subagents**:

```python
def spawn_with_timeout(description, prompt, timeout_seconds=300):
    """Spawn subagent with timeout"""

    subagent = spawn_subagent_async(
        description=description,
        prompt=f"""
    {prompt}

    IMPORTANT: Complete within {timeout_seconds} seconds.
    If you reach this limit, save progress to /vps/checkpoints/
    so work can be resumed.
    """
    )

    start_time = time.time()

    while subagent.is_running():
        elapsed = time.time() - start_time
        if elapsed > timeout_seconds:
            # Try to terminate gracefully
            subagent.request_stop()
            time.sleep(5)
            if subagent.is_running():
                subagent.force_stop()
            break

        time.sleep(10)

    return subagent.get_result()
```

### 7. Logging and Debugging

**Always add logging for subagent activities**:

```python
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def spawn_with_logging(description, prompt):
    """Spawn subagent with comprehensive logging"""

    logger.info(f"Spawning: {description}")
    logger.debug(f"Prompt:\n{prompt}")

    try:
        result = spawn_and_wait_subagent(
            description=description,
            prompt=prompt
        )

        logger.info(f"Completed: {description}")
        logger.debug(f"Result: {result}")

        return result

    except Exception as e:
        logger.error(f"Failed: {description}")
        logger.exception(f"Error: {e}")
        raise
```

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
2. Reduce max_concurrent setting
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

## Quick Start Examples

### Example 1: Simple Review Cycle

```python
# Write code
code = generate_python_function()

# Get review
review = spawn_and_wait_subagent(
    description="Code Reviewer",
    prompt=f"Review this Python code:\n{code}\nList issues."
)

# Fix based on review
if "issues" in review.lower():
    code = spawn_and_wait_subagent(
        description="Code Fixer",
        prompt=f"Fix these issues:\n{review}\nOriginal code:\n{code}"
    )

# Final review
final_review = spawn_and_wait_subagent(
    description="Code Reviewer",
    prompt=f"Final check on this code:\n{code}"
)
```

### Example 2: Parallel Content Generation

```python
sections = ['introduction', 'methods', 'results', 'conclusion']
tasks = []

for section in sections:
    task = spawn_subagent_async(
        description=f"Write {section}",
        prompt=f"Write the {section} section for a research paper on AI ethics"
    )
    tasks.append((section, task))

# Gather results
paper = ""
for section, task in tasks:
    content = task.wait_for_result()
    paper += f"## {section.title()}\n\n{content}\n\n"
```

### Example 3: Worker Pool with VPS

```python
# Create tasks
for i in range(100):
    add_to_vps_queue({
        "id": i,
        "task": f"Process item {i}"
    })

# Spawn workers
workers = []
for i in range(5):
    worker = spawn_subagent_async(
        description=f"Worker-{i}",
        prompt=WORKER_INSTRUCTIONS
    )
    workers.append(worker)

# Workers run independently; check progress
while has_pending_tasks():
    status = get_queue_status()
    print(f"Progress: {status['completed']}/{status['total']}")
    time.sleep(30)
```

---

## Additional Resources

- See `knowledge/02-vps-multi-agent-architecture.md` for VPS system details
- See `knowledge/03-stop-hooks-worker-persistence.md` for worker persistence
- See `knowledge/04-vps-api-specification.md` for VPS API reference
- See `knowledge/05-task-queue-coordination.md` for task queue details

---

**Last Updated**: 2025-11-09
**Version**: 1.0
**Status**: Complete
