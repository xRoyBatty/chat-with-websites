# Claude Code: Non-Standard Use Cases

**Version:** 1.0
**Last Updated:** 2025-11-09

---

## Table of Contents

1. [Research & Information Gathering](#research--information-gathering)
2. [Language Learning](#language-learning)
3. [Digital Brain / Knowledge Management](#digital-brain--knowledge-management)
4. [Building RAG Systems](#building-rag-systems)
5. [Self-Learning Repositories](#self-learning-repositories)
6. [Proactive Goal Management](#proactive-goal-management)
7. [Personal Productivity Systems](#personal-productivity-systems)

---

## Research & Information Gathering

### Fast Multi-Source Research

**Concept:** Use parallel agents to research from multiple sources simultaneously

**Setup:**
```
research-project/
├── .claude/
│   ├── skills/research-assistant/
│   │   └── SKILL.md
│   └── research/
│       ├── sources.md
│       ├── findings/
│       └── summaries/
└── notes/
```

**Workflow:**
```python
# Start parallel research
Task(
  subagent_type="general-purpose",
  prompt="Research topic X from academic papers.
          Use WebSearch to find papers, WebFetch to read them.
          Summarize key findings in .claude/research/findings/academic.md"
)

Task(
  subagent_type="general-purpose",
  prompt="Research topic X from industry blogs.
          Find recent articles, extract practical insights.
          Summarize in .claude/research/findings/industry.md"
)

Task(
  subagent_type="general-purpose",
  prompt="Research topic X from documentation.
          Find official docs, tutorials, examples.
          Summarize in .claude/research/findings/docs.md"
)

# All 3 agents run simultaneously
# Each writes findings to separate file

# When complete, synthesize:
Read(.claude/research/findings/academic.md)
Read(.claude/research/findings/industry.md)
Read(.claude/research/findings/docs.md)

"Comprehensive research summary:

Academic consensus: ...
Industry best practices: ...
Official recommendations: ...

Synthesis: ..."

# Write final summary
Write(.claude/research/summaries/topic-x-summary.md)
```

**Benefits:**
- 3x faster than sequential research
- Multiple perspectives
- Organized findings
- Reusable summaries

---

### Research Templates

**.claude/skills/research-assistant/SKILL.md:**
```yaml
---
name: research-assistant
description: Comprehensive research on any topic using multiple sources
---

# Research Assistant

## Research Workflow

### 1. Define Topic
Ask user for:
- Research question
- Specific aspects to focus on
- Depth required (quick/medium/thorough)

### 2. Identify Sources
Based on topic, determine sources:
- Academic: Google Scholar, arXiv, papers
- Industry: Blogs, case studies, whitepapers
- Official: Documentation, specifications
- Community: Forums, GitHub discussions

### 3. Parallel Research (if thorough)
Launch multiple agents to research each source type simultaneously.

### 4. Consolidate Findings
Read all findings files, synthesize into coherent summary.

### 5. Organize Output
Write to:
- .claude/research/findings/[source-type].md (raw findings)
- .claude/research/summaries/[topic]-summary.md (synthesis)
- .claude/research/sources.md (bibliography)

### 6. Generate Deliverables
Based on user need:
- Executive summary (1 page)
- Detailed report (5-10 pages)
- Presentation outline
- Further research questions
```

---

### Continuous Research Repository

**Concept:** Accumulate research over time

```
my-research/
├── topics/
│   ├── ai-safety/
│   │   ├── findings/
│   │   ├── summaries/
│   │   └── questions.md
│   ├── web-performance/
│   │   ├── findings/
│   │   ├── summaries/
│   │   └── questions.md
│   └── distributed-systems/
├── .claude/
│   └── skills/
│       └── research-continuation/
│           └── SKILL.md
└── README.md
```

**Each session:**
```python
# Read previous research
Read(topics/ai-safety/summaries/latest.md)
Read(topics/ai-safety/questions.md)

# Continue research on open questions
"Last time we identified 3 open questions.
Let me research question 1: ..."

# Add new findings
Write(topics/ai-safety/findings/2025-11-09.md)

# Update summary
Edit(topics/ai-safety/summaries/latest.md)

# Update questions
Edit(topics/ai-safety/questions.md)
```

**Benefits:**
- Build knowledge progressively
- Never lose context
- Track open questions
- Shareable research

---

## Language Learning

### Vocabulary Builder Repository

**Structure:**
```
language-learning/
├── vocabulary/
│   ├── daily/
│   │   ├── 2025-11-09.md
│   │   └── 2025-11-08.md
│   ├── by-topic/
│   │   ├── technology.md
│   │   ├── business.md
│   │   └── casual.md
│   └── review/
│       └── spaced-repetition.md
├── grammar/
│   └── exercises/
├── .claude/
│   └── skills/
│       ├── vocabulary-teacher/
│       └── grammar-coach/
└── progress.md
```

**Daily vocabulary session:**
```python
# Read progress
Read(progress.md)
# → "Last session: 50 words learned, 80% retention"

# Generate new lesson
"Today's vocabulary lesson (10 new words):

1. **ephemeral** (adj) - lasting a very short time
   - Example: The beauty of cherry blossoms is ephemeral.
   - Use case: Describing temporary states in programming
   - Related: temporary, transient, fleeting

2. **ubiquitous** (adj) - present everywhere
   - Example: Smartphones are ubiquitous in modern society.
   - Use case: Common patterns or technologies
   - Related: omnipresent, pervasive, universal

... (8 more words)

Practice exercises:
1. Fill in the blank: The _____ nature of cloud storage...
2. Use 'ubiquitous' in a sentence about technology...
3. What's the opposite of 'ephemeral'?
"

# Save lesson
Write(vocabulary/daily/2025-11-09.md)

# Add to topic lists
Edit(vocabulary/by-topic/technology.md, append new words)

# Generate spaced repetition schedule
Edit(vocabulary/review/spaced-repetition.md)
```

---

### Grammar Practice with Instant Feedback

**.claude/skills/grammar-coach/SKILL.md:**
```yaml
---
name: grammar-coach
description: Interactive grammar practice with explanations and corrections
---

# Grammar Coach

## Practice Modes

### 1. Exercise Generation
Generate exercises based on user's level and focus area:
- Tenses (present perfect, past continuous, etc.)
- Conditionals (if-clauses, wish/if only)
- Passive voice
- Reported speech
- Articles (a/an/the)

### 2. Instant Correction
When user submits answers:
- Highlight errors
- Explain why it's wrong
- Show correct version
- Provide similar examples

### 3. Contextual Learning
Don't just correct - explain:
- Grammar rule
- Common mistakes
- When to use vs not use
- Cultural/usage notes

### 4. Progress Tracking
Track in progress.md:
- Topics covered
- Accuracy rate
- Common mistakes
- Areas needing more practice
```

**Session example:**
```python
User: "I want to practice conditionals"

"Great! Let's practice second conditionals (hypothetical situations).

Exercise 1: Complete the sentence:
If I _____ (be) rich, I _____ (travel) the world.

Your answer: If I was rich, I will travel the world.

Feedback:
❌ "was" should be "were" (second conditional uses 'were' for all subjects)
❌ "will" should be "would" (second conditional uses 'would')

✅ Correct: If I were rich, I would travel the world.

Explanation:
Second conditional structure: If + past simple, ... would + infinitive
Used for unlikely or hypothetical situations in the present/future.

Try again: If you _____ (win) the lottery, what _____ (you/do)?"

# Save session
Write(grammar/exercises/2025-11-09-conditionals.md)

# Update progress
Edit(progress.md, add: "Conditionals: 60% accuracy, needs more practice")
```

---

### Conversation Practice Repository

```
conversation-practice/
├── dialogues/
│   ├── business-meeting.md
│   ├── casual-chat.md
│   ├── job-interview.md
│   └── technical-discussion.md
├── feedback/
│   └── session-logs/
└── .claude/
    └── skills/
        └── conversation-partner/
```

**Interactive dialogue:**
```python
"Let's practice a job interview. I'll be the interviewer.

Interviewer: Tell me about yourself.

Your response: [user types in their language]

Feedback:
✅ Good structure and relevant information
⚠️  \"I am working\" → \"I work\" (simple present for current job)
⚠️  Pronunciation note: \"experience\" has stress on second syllable

Improved version:
\"I work as a software engineer with 5 years of experience...\"

Interviewer: What are your strengths?
"

# Log session
Write(feedback/session-logs/2025-11-09-interview.md)
```

---

## Digital Brain / Knowledge Management

### Zettelkasten-Style Repository

**Concept:** Connected atomic notes with backlinks

```
knowledge-base/
├── notes/
│   ├── 001-async-programming.md
│   ├── 002-event-loop.md
│   ├── 003-promises.md
│   └── 004-async-await.md
├── index/
│   ├── by-topic.md
│   ├── by-date.md
│   └── backlinks.md
├── .claude/
│   └── skills/
│       ├── note-creator/
│       ├── note-linker/
│       └── knowledge-query/
└── graph.md
```

**Note template (001-async-programming.md):**
```markdown
# Async Programming

**Created:** 2025-11-09
**Tags:** #programming #javascript #async
**Related:** [[002-event-loop]], [[003-promises]]

## Concept
Asynchronous programming allows code to run without blocking...

## Key Points
- Non-blocking I/O
- Event-driven
- Callbacks, Promises, Async/Await

## Examples
\`\`\`javascript
// Example code
\`\`\`

## Connections
- Requires understanding of [[002-event-loop]]
- Implemented via [[003-promises]] in modern JS
- Syntactic sugar: [[004-async-await]]

## Questions
- How does this compare to multi-threading?
- What are performance implications?

## Sources
- https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Asynchronous
- JavaScript: The Good Parts (book)
```

**Creating new note:**
```python
User: "Add note about React hooks"

# Generate note ID
Read(index/by-date.md)  # Find latest ID: 004
# New note: 005

# Create note
Write(notes/005-react-hooks.md, """
# React Hooks

**Created:** 2025-11-09
**Tags:** #react #javascript #frontend
**Related:** [[006-useState]], [[007-useEffect]]

## Concept
Hooks let you use state and lifecycle in function components...

## Key Hooks
- useState - state management
- useEffect - side effects
- useContext - context access
- useReducer - complex state

## Examples
...

## Connections
- Related to [[003-async-programming]] for useEffect
- Replaced class components (need note on this)

## Questions
- Custom hooks best practices?
- Performance optimization?
""")

# Update indices
Edit(index/by-topic.md, add: "React: [[005-react-hooks]]")
Edit(index/by-date.md, add: "2025-11-09: [[005-react-hooks]]")

# Update backlinks
Edit(notes/003-async-programming.md, add link to 005)

# Update graph
Edit(graph.md, add connections)
```

---

### Personal Wiki with Claude

**Structure:**
```
personal-wiki/
├── concepts/
├── projects/
├── people/
├── companies/
├── tools/
├── .claude/
│   └── skills/
│       ├── wiki-search/
│       ├── wiki-update/
│       └── wiki-connect/
└── index.md
```

**.claude/skills/wiki-search/SKILL.md:**
```yaml
---
name: wiki-search
description: Search personal wiki by keyword, topic, or connection
---

# Wiki Search

## Search Methods

### 1. Keyword Search
Use Grep to find all mentions:
```bash
grep -r "keyword" concepts/ projects/ people/
```

### 2. Topic Search
Read index, find related pages:
```bash
# index.md has topic → pages mapping
```

### 3. Connection Search
Find pages linking to given page:
```bash
grep -r "\\[\\[page-name\\]\\]" .
```

### 4. Smart Search
Combine multiple methods, rank results by relevance.

## Output Format
Return:
- Matching pages (ranked)
- Relevant excerpts
- Related pages via backlinks
- Suggested next reads
```

---

## Building RAG Systems

### Code Documentation RAG

**Concept:** Build searchable, queryable documentation for your codebase

```
project-rag/
├── docs/
│   ├── api/
│   ├── architecture/
│   ├── guides/
│   └── references/
├── embeddings/
│   └── index.json
├── .claude/
│   └── skills/
│       ├── doc-indexer/
│       ├── doc-search/
│       └── doc-query/
└── src/
```

**.claude/skills/doc-indexer/SKILL.md:**
```yaml
---
name: doc-indexer
description: Index codebase for semantic search and RAG queries
---

# Documentation Indexer

## Indexing Workflow

### 1. Extract Documentation
Find all docstrings, comments, README files:
```python
# Use Grep to find all docstrings
Grep(pattern='""".*"""', multiline=true)
Grep(pattern='//.*', glob="*.js")
```

### 2. Parse and Structure
For each code file:
- Extract function signatures
- Extract docstrings
- Extract inline comments
- Extract type annotations

Output structure:
```json
{
  "file": "auth.py",
  "functions": [
    {
      "name": "login",
      "signature": "login(username: str, password: str) -> User",
      "docstring": "Authenticate user and create session...",
      "line": 45
    }
  ]
}
```

### 3. Build Index
Write to embeddings/index.json:
```json
{
  "documents": [
    {
      "id": "auth.py:login",
      "content": "login function: Authenticate user and create session. Takes username and password, returns User object...",
      "metadata": {
        "file": "auth.py",
        "line": 45,
        "type": "function"
      }
    }
  ]
}
```

### 4. Create Search Interface
User can query:
- "How do I authenticate users?" → Points to login function
- "What functions modify the database?" → Lists all DB functions
- "Show me error handling patterns" → Finds relevant code
```

**Querying:**
```python
User: "How do I add a new user?"

# Read index
Read(embeddings/index.json)

# Search for relevant entries
# (In real RAG, you'd use vector similarity)
# Here, use keyword matching as approximation:
matches = [
  "auth.py:create_user",
  "users.py:add_user",
  "db.py:insert_user"
]

# Retrieve full context
Read(src/auth.py, lines around create_user)

"To add a new user, use the `create_user` function in auth.py:

```python
def create_user(username: str, email: str, password: str) -> User:
    \"\"\"
    Create new user account.

    Args:
        username: Unique username
        email: User's email
        password: Plain text password (will be hashed)

    Returns:
        User: Created user object

    Raises:
        UserExistsError: If username/email already taken
    \"\"\"
    # Implementation...
```

Usage example:
```python
user = create_user('john', 'john@example.com', 'secure123')
```

Related functions:
- `users.py:add_user` - Lower-level user creation
- `db.py:insert_user` - Direct database insertion
"
```

---

### Personal Knowledge RAG

**Concept:** Queryable personal knowledge base

```
knowledge-rag/
├── sources/
│   ├── books/
│   ├── articles/
│   ├── videos/
│   └── courses/
├── processed/
│   ├── summaries/
│   └── extracts/
├── index/
│   └── knowledge-index.json
└── .claude/
    └── skills/
        ├── knowledge-ingest/
        └── knowledge-query/
```

**Ingestion workflow:**
```python
User: "I want to add this article to my knowledge base"
User: [provides URL]

# Fetch article
WebFetch(url, prompt="Extract main concepts, key points, examples")

# Process
"""
Article: "Async Programming Patterns"

Key Concepts:
1. Event Loop
2. Callbacks
3. Promises
4. Async/Await

Key Points:
- Async allows non-blocking I/O
- Promises solve callback hell
- Async/await is syntactic sugar

Examples:
[Code examples...]
"""

# Save
Write(sources/articles/async-programming-patterns.md)
Write(processed/summaries/async-programming-patterns.md)

# Index
Edit(index/knowledge-index.json, add:
{
  "id": "async-programming-patterns",
  "type": "article",
  "concepts": ["event-loop", "callbacks", "promises", "async-await"],
  "related": ["javascript", "nodejs", "concurrency"]
})
```

**Query workflow:**
```python
User: "What do I know about handling async errors?"

# Search index
Read(index/knowledge-index.json)
# Find entries with "async" and "error"

# Matches:
# - async-programming-patterns
# - error-handling-nodejs
# - promise-rejection-best-practices

# Read summaries
Read(processed/summaries/async-programming-patterns.md)
Read(processed/summaries/error-handling-nodejs.md)
Read(processed/summaries/promise-rejection-best-practices.md)

# Synthesize answer
"Based on your knowledge base, here's what you know about async error handling:

**From 'Async Programming Patterns':**
- Use try/catch with async/await
- Always handle promise rejections
- Example: [code]

**From 'Error Handling in Node.js':**
- unhandledRejection event
- process.on('unhandledRejection', handler)

**From 'Promise Rejection Best Practices':**
- Always return promises
- Use .catch() for promise chains
- Avoid swallowing errors

**Related resources in your knowledge base:**
- error-boundaries-react.md
- debugging-async-code.md

Would you like me to dive deeper into any of these?"
```

---

## Self-Learning Repositories

### Concept

Repository that becomes specialized over time by accumulating knowledge and patterns specific to a domain.

**Structure:**
```
ml-learning-repo/
├── concepts/
│   ├── fundamentals/
│   ├── algorithms/
│   └── applications/
├── implementations/
│   ├── from-scratch/
│   └── with-libraries/
├── experiments/
│   └── results/
├── learnings/
│   └── insights/
├── .claude/
│   ├── CLAUDE.md
│   └── skills/
│       ├── ml-experiment/
│       ├── result-analyzer/
│       └── insight-extractor/
└── knowledge-graph.md
```

**.claude/CLAUDE.md** (evolves over time):
```markdown
# Machine Learning Learning Repository

**Domain:** Machine Learning
**Specialization Level:** Intermediate (updated 2025-11-09)
**Focus Areas:** Neural Networks, Computer Vision

## What We've Learned

### Fundamental Concepts (Mastered)
- Linear Regression: See concepts/fundamentals/linear-regression.md
- Gradient Descent: implementations/from-scratch/gradient-descent.py
- Backpropagation: concepts/fundamentals/backpropagation.md

### Advanced Concepts (In Progress)
- Convolutional Neural Networks: 60% complete
- Transfer Learning: 30% complete
- GANs: Just started

### Experiments Completed
1. MNIST Classifier (99.2% accuracy) - experiments/results/mnist-001.md
2. Image Augmentation Study - experiments/results/augmentation-002.md
3. Learning Rate Comparison - experiments/results/lr-comparison-003.md

## Current Knowledge Gaps
- Reinforcement Learning (not started)
- Transformers (not started)
- Model Deployment (basic understanding)

## Preferred Approaches
Based on past experiments:
- PyTorch preferred over TensorFlow (better debugging)
- Adam optimizer generally best for our use cases
- Batch size 32 works well for our data sizes
- Always use data augmentation for images

## Common Patterns
See learnings/patterns.md for:
- Our standard training loop
- Preferred model architectures
- Debugging approaches that work for us

## Next Steps
See knowledge-graph.md for learning path.
```

**Each session builds on previous:**
```python
# Session 1: Start learning CNNs
"Let's learn about Convolutional Neural Networks"

# Create notes
Write(concepts/fundamentals/cnn-basics.md)

# Update CLAUDE.md
Edit(.claude/CLAUDE.md, add: "Advanced Concepts (In Progress): CNNs 20% complete")

# Session 2: Implement CNN
"Let's implement a simple CNN for MNIST"

Write(implementations/with-libraries/cnn-mnist.py)

# Run experiment
Bash("python implementations/with-libraries/cnn-mnist.py", background=true)

# Record results
Write(experiments/results/cnn-mnist-004.md)

# Extract insights
"Key insight: Learned that 3x3 kernels work better than 5x5 for MNIST"
Write(learnings/insights/kernel-sizes.md)

# Update CLAUDE.md
Edit(.claude/CLAUDE.md, add: "CNNs 40% complete")
Edit(.claude/CLAUDE.md, add: "Preferred kernel size: 3x3")

# Session 3: Advanced CNN techniques
Read(.claude/CLAUDE.md)  # See we're 40% into CNNs
Read(learnings/insights/kernel-sizes.md)  # Recall kernel preference

"Building on what we learned, let's explore batch normalization..."
# Continue building knowledge
```

**After many sessions:**
```python
Read(.claude/CLAUDE.md)
# → "CNNs: Mastered"
# → "Preferred architecture: ResNet-style with skip connections"
# → "Batch norm after each conv layer"
# → "Common pitfall: Overfitting - use dropout 0.5"

# Repository has specialized in CNNs
# Next session can immediately use this knowledge
# No re-learning required
```

---

## Proactive Goal Management

### Self-Updating Task System

**Structure:**
```
goals-system/
├── goals/
│   ├── long-term/
│   │   ├── career.md
│   │   ├── learning.md
│   │   └── projects.md
│   ├── short-term/
│   │   └── this-week.md
│   └── daily/
│       └── 2025-11-09.md
├── completed/
│   └── archive/
├── priorities/
│   └── current.md
├── progress/
│   └── tracking.md
└── .claude/
    ├── skills/
    │   ├── goal-planner/
    │   ├── task-delegator/
    │   └── progress-reporter/
    └── state/
        └── last-session.json
```

**.claude/skills/goal-planner/SKILL.md:**
```yaml
---
name: goal-planner
description: Proactive daily planning based on user's goals and progress
---

# Goal Planner

## Daily Planning Workflow

### 1. Load Context
Read:
- goals/long-term/*.md (understand big picture)
- goals/short-term/this-week.md (weekly goals)
- priorities/current.md (current priorities)
- progress/tracking.md (what's been done)
- .claude/state/last-session.json (last session info)

### 2. Analyze Status
Calculate:
- Progress on weekly goals
- Overdue tasks
- Blockers
- Time since last work on each goal

### 3. Generate Daily Plan
Create goals/daily/[today].md:
- Top 3 priorities (from long-term goals)
- Tasks to complete today (specific, actionable)
- Time estimates
- Dependencies
- Delegation opportunities

### 4. Proactive Suggestions
When user says "hello":
"Good morning! Here's your plan for today:

🎯 **Top Priorities:**
1. [Task from long-term goal X]
2. [Task from long-term goal Y]
3. [Task from short-term goal Z]

⚠️  **Blockers:**
- [Blocker 1] - Need to resolve before task A

📅 **This Week's Progress:**
- Goal 1: 60% complete (ahead of schedule!)
- Goal 2: 30% complete (on track)
- Goal 3: 10% complete (behind - needs attention)

💡 **Suggestions:**
- Delegate task X to subagent (low priority, automatable)
- Focus on Goal 3 today (catching up)
- Schedule time for blocker resolution

Ready to start?"

### 5. Continuous Updates
After each task:
- Update progress/tracking.md
- Adjust priorities if needed
- Check dependencies
- Suggest next task

### 6. End-of-Day Summary
Before session ends:
- Write what was accomplished
- Update goals status
- Identify tomorrow's priorities
- Save state to .claude/state/last-session.json
```

**Example session:**
```python
User: "hello"

# Load all context
Read(goals/long-term/career.md)
# → "Become senior engineer by 2026"
# → "Key: Deep system design knowledge, leadership experience"

Read(goals/short-term/this-week.md)
# → "This week: Complete authentication module, review 3 PRs"

Read(priorities/current.md)
# → "1. Authentication (HIGH), 2. Code reviews (MEDIUM), 3. Learning (LOW)"

Read(progress/tracking.md)
# → "Auth: 70% done, Reviews: 1/3 done, Learning: 0% this week"

Read(.claude/state/last-session.json)
# → "Last session: 2025-11-08, completed login endpoint"

# Generate plan
"Good morning! Here's your plan for today:

🎯 **Top Priorities:**
1. ✅ Finish authentication module (30% left - should complete today!)
   - Remaining: password reset endpoint
   - Estimated time: 2 hours
   - Aligns with: Career goal (technical depth)

2. 📝 Review 2 more PRs (to hit weekly goal of 3)
   - PR #123: Frontend changes (easy, 30 min)
   - PR #124: Database migration (complex, 1 hour)
   - Aligns with: Career goal (leadership/mentoring)

3. 📚 Start system design learning (behind this week)
   - Read: "Designing Data-Intensive Applications" Ch 1
   - Estimated time: 1 hour
   - Aligns with: Career goal (system design knowledge)

⚠️  **Blockers:** None currently

📅 **Weekly Progress:**
- Auth module: 70% → Should hit 100% today! 🎉
- Code reviews: 33% → Will be 100% after today
- Learning: 0% → Will start today

💡 **Delegation Opportunity:**
The password reset endpoint is well-defined. I can:
- Implement it in background while you review PRs
- Run tests automatically
- You just review and approve

Sound good? Want me to start on the password reset while you handle other tasks?"

# User works on tasks
# After each completion:
Edit(progress/tracking.md, update percentages)
Edit(priorities/current.md, rerank if needed)

# End of day:
Write(.claude/state/last-session.json, {
  "date": "2025-11-09",
  "completed": ["auth-module", "2-code-reviews", "learning-chapter-1"],
  "in_progress": [],
  "blockers": [],
  "tomorrow_focus": ["start-payment-module"]
})

"Great session! Summary:

✅ **Completed Today:**
- Auth module: 100% done! (was 70%)
- Code reviews: 3/3 done! (weekly goal met!)
- Learning: Chapter 1 done

📊 **Weekly Progress:**
- Auth module: ✅ COMPLETE
- Code reviews: ✅ COMPLETE
- Learning: 20% done (good start!)

🎯 **Tomorrow's Focus:**
Based on your long-term goal of becoming senior engineer, I suggest:
1. Start payment module (technical depth)
2. Continue system design learning (Ch 2)
3. Help junior dev with question (leadership)

**Long-term Goal Progress:**
Career goal: +5% progress this week
- Technical depth: ✅ Auth module demonstrates expertise
- Leadership: ✅ Code reviews show mentoring
- System design: 📈 Started learning

See you tomorrow! 👋"
```

---

### Smart Task Delegation

**.claude/skills/task-delegator/SKILL.md:**
```yaml
---
name: task-delegator
description: Analyze tasks and delegate to subagents or automation when possible
---

# Task Delegator

## Delegation Analysis

For each task, evaluate:

### 1. Is it automatable?
- Well-defined requirements? → Yes = automatable
- Requires creativity/judgment? → No = keep with user
- Repetitive? → Yes = automate

### 2. Can subagent handle it?
- Exploratory research? → Use Explore agent
- Code analysis? → Use general-purpose agent
- Testing? → Use background Bash + scripts

### 3. Risk assessment
- Critical/risky? → User should do it
- Low-risk? → Safe to delegate
- Reversible? → Safe to delegate

## Delegation Workflow

### High-confidence delegation:
"This task is well-suited for delegation:
- [Task description]
- Why: [Reason it's delegatable]
- Risk: LOW
- Estimated time saved: [X hours]

I can handle this in the background while you [other task].
Shall I proceed?"

### Medium-confidence delegation:
"This task could potentially be delegated:
- [Task description]
- Why: [Reason]
- Risk: MEDIUM
- Trade-off: Faster but may need review

Would you like me to:
A) Do it completely (you review after)
B) Do it partially (you finish critical parts)
C) You do it (I assist)
"

### Low-confidence (don't delegate):
"This task requires your expertise:
- [Task description]
- Why: [Reason not delegatable]
- I can assist by: [How I can help]
"

## Delegation Execution

### Create delegation instruction file:
Write(.claude/delegated-tasks/[task-id].md):
```markdown
# Task: [Name]

**Delegated to:** Subagent / Background script
**Priority:** HIGH / MEDIUM / LOW
**Deadline:** [Date/time]
**Status:** In Progress

## Objective
[Clear objective]

## Acceptance Criteria
1. [Criterion 1]
2. [Criterion 2]

## Approach
[How subagent/script should handle it]

## Output Location
Results in: [file path]

## Review Required
YES / NO
```

### Monitor and Report
Check delegated tasks periodically, report completion.
```

---

## Personal Productivity Systems

### Context-Aware Session Startup

**Goal:** Each session starts with full context, zero manual catch-up

**.claude/state/user-context.json:**
```json
{
  "user": {
    "name": "Alex",
    "role": "Software Engineer",
    "focus_areas": ["backend", "databases", "system-design"],
    "learning_goals": ["distributed-systems", "kubernetes"],
    "work_style": "prefers-async-work",
    "availability": "mostly-mobile"
  },
  "current_projects": [
    {
      "name": "auth-service",
      "status": "active",
      "progress": 75,
      "next_steps": ["password-reset", "2fa"],
      "blockers": []
    },
    {
      "name": "payment-service",
      "status": "planning",
      "progress": 10,
      "next_steps": ["design-review"],
      "blockers": ["waiting-for-api-access"]
    }
  ],
  "recent_topics": [
    "async-programming",
    "database-indexing",
    "docker-optimization"
  ],
  "preferences": {
    "testing": "pytest",
    "linting": "black + ruff",
    "commit_style": "conventional-commits",
    "documentation": "docstrings + README"
  },
  "last_updated": "2025-11-09T10:30:00Z"
}
```

**Session startup skill:**
```python
# Every session starts by reading context
Read(.claude/state/user-context.json)
Read(goals/daily/today.md)
Read(priorities/current.md)

# Proactive greeting
"Hey Alex! 👋

**Current Projects:**
- auth-service: 75% done, next: password reset
- payment-service: 10% done, blocked on API access

**Today's Plan:**
1. Finish password reset (auth-service)
2. Review system design docs (learning goal)
3. Check on API access for payment-service

**Since Last Time:**
You were working on login endpoint (completed ✅).
The build passed, tests green, PR merged.

**Quick Wins Available:**
- 2FA implementation (well-defined, can delegate to subagent)
- Database index optimization (I found 3 slow queries)

Ready to dive in? What would you like to tackle first?"
```

**Context automatically updates:**
```python
# After working on password reset:
Edit(.claude/state/user-context.json, {
  "current_projects[0].progress": 85,
  "current_projects[0].next_steps": ["2fa"],
  "recent_topics": ["async-programming", "database-indexing", "docker-optimization", "password-reset-security"]
})

# After expressing preference:
User: "Let's use FastAPI for the payment service"

Edit(.claude/state/user-context.json, {
  "preferences.framework": "FastAPI",
  "preferences.api_style": "async"
})

# Next session automatically knows:
Read(.claude/state/user-context.json)
# → "User prefers FastAPI with async"
# → Suggests FastAPI patterns without being asked
```

---

### Automated Progress Reporting

**Weekly report automation:**

**.claude/skills/progress-reporter/SKILL.md:**
```yaml
---
name: progress-reporter
description: Generate weekly progress reports automatically
---

# Progress Reporter

## Report Generation

### Every Sunday or on demand:

Read all sources:
- goals/daily/*.md (this week's daily goals)
- progress/tracking.md
- completed/archive/*.md
- .claude/state/user-context.json

Calculate:
- Tasks completed vs planned
- Time spent per goal area
- Blockers encountered and resolved
- Learning progress
- Project progress

Generate report in progress/weekly-reports/YYYY-WW.md:

```markdown
# Weekly Report: Week 45, 2025

## 📊 Summary
- Tasks completed: 23/25 (92%)
- Hours logged: 35
- Main focus: Authentication service
- Learning: System design (5 hours)

## ✅ Achievements
1. ✅ Auth service: 70% → 100% (COMPLETED!)
   - Login endpoint
   - Registration
   - Password reset
   - Session management

2. ✅ Code reviews: 12 PRs reviewed
   - Mentored 2 junior developers
   - Found critical security issue

3. 📚 Learning progress:
   - System Design: Chapter 1-3 complete
   - Completed "Designing Data-Intensive Applications"

## 🚧 Challenges
1. API access delay (payment service blocked 3 days)
   - Resolved: Got access on Thursday
2. Database migration took longer than expected
   - Reason: Data inconsistencies
   - Learned: Always validate data first

## 📈 Progress Toward Long-term Goals
- **Career Goal (Senior Engineer):**
  - Technical depth: +8% (auth service completion)
  - Leadership: +5% (mentoring, code reviews)
  - System design: +10% (learning progress)
  - Overall: 45% → 53% (+8%)

## 🎯 Next Week Plan
1. Start payment service implementation
2. Continue system design learning (Ch 4-6)
3. Present auth service in team meeting

## 💡 Insights
- Async work style very effective (92% completion rate)
- Mobile reviews work well for code review
- Need to allocate more buffer time for migrations
```

## Auto-send to user:
(If configured) Send via email, Slack, etc.
```
```

---

*See also: CLAUDE_CODE_COMPLETE_MANUAL.md, SKILLS_ADVANCED_GUIDE.md, ASYNC_WORKFLOWS.md*

*End of Non-Standard Uses Guide. Last updated: 2025-11-09*
