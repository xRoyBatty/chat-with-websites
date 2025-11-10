# Claude Code Agent Repository Framework

**Welcome!** This is a comprehensive framework for building agent-based repositories with Claude Code.

---

## 🎯 What This Framework Provides

This framework combines knowledge from two powerful systems:

1. **VPS Multi-Agent Coordination** - Build systems where multiple Claude agents collaborate via shared VPS workspace
2. **Claude Code Best Practices** - Templates, patterns, and workflows for maximizing productivity

**Purpose:** Help you design and build specialized Claude Code repositories tailored to your needs.

---

## 📚 Knowledge Base Structure

This framework uses a **two-version knowledge system** for most topics:

### Concept Versions (`knowledge/concepts/`) - Read These First!
Streamlined guides with:
- ✅ Core ideas and principles
- ✅ Architecture and patterns
- ✅ When to use what
- ✅ Strategic thinking
- ✅ **24-58% shorter** than full versions

**When to read:**
- Session start (all 8 files for complete overview)
- Quick understanding
- Planning and decision-making
- Refreshing knowledge without implementation details

### Full Versions (`knowledge/full/`) - Reference for Implementation
Complete guides with:
- ✅ Code examples and implementations
- ✅ Detailed syntax and commands
- ✅ Step-by-step tutorials
- ✅ Ready-to-use templates
- ✅ Edge cases and troubleshooting

**When to read:**
- When implementing features
- Need exact syntax or commands
- Following step-by-step tutorials
- Troubleshooting issues

### Which Files Have Both Versions?

**Both versions (8 topics):**
1. `subagents` - Context isolation, types, patterns
2. `skills` - Modular architecture
3. `task-queues` - Multi-agent coordination
4. `stop-hooks` - Worker persistence
5. `async-workflows` - Background execution
6. `unlimited-week` - Productivity strategies
7. `nonstandard-uses` - Research, learning, knowledge
8. `complete-manual` - Tool reference

**Full only (3 topics):**
- `environments` - Environment types
- `vps-api` - API specification
- `vps-multi-agent` - VPS architecture

**Reading Strategy:** Always start with concepts, refer to full versions when implementing.

---

## 🗺️ Knowledge Map

### Core Concepts (Read These First)

**Agent Coordination:**
- `subagents-concepts.md` - Subagent types, context isolation, patterns (47% shorter)
- `stop-hooks-concepts.md` - Worker persistence via discrete cycles (26% shorter)
- `task-queues-concepts.md` - File-based multi-agent coordination (40% shorter)

**Advanced Patterns:**
- `skills-concepts.md` - Modular skill architecture (41% shorter)
- `async-workflows-concepts.md` - Background execution patterns (37% shorter)
- `unlimited-week-concepts.md` - Parallel productivity strategies (35% shorter)

**Non-Standard Uses:**
- `nonstandard-uses-concepts.md` - Research, learning, knowledge management (58% shorter)

**Reference Materials:**
- `complete-manual-concepts.md` - Tool reference concepts (21% shorter)
  - `complete-manual-full.md` - Complete tool reference with syntax
- `environments-full.md` - Claude Code environment types (full only)
- `vps-api-full.md` - VPS API specification (full only)
- `vps-multi-agent-full.md` - VPS multi-agent architecture (full only)

---

## 🤖 How to Help Users (Agent Instructions)

### 📖 On Session Start (Do This FIRST)

**Before engaging with the user, prepare yourself:**

1. **Read ALL concept files** to understand what this framework offers:
   ```
   knowledge/concepts/subagents-concepts.md
   knowledge/concepts/skills-concepts.md
   knowledge/concepts/task-queues-concepts.md
   knowledge/concepts/stop-hooks-concepts.md
   knowledge/concepts/async-workflows-concepts.md
   knowledge/concepts/unlimited-week-concepts.md
   knowledge/concepts/nonstandard-uses-concepts.md
   knowledge/concepts/complete-manual-concepts.md
   ```

2. **Why read concepts first?**
   - They're 24-58% shorter than full versions (quick to read)
   - Give you complete overview of available patterns
   - Let you better match user needs to solutions
   - You can reference full versions later for implementation

3. **After reading concepts**, you'll know:
   - What templates exist and when to recommend them
   - What tools are available (VPS, skills, subagents)
   - Common patterns and architectures
   - Context isolation principles
   - File-based memory strategies

**Then proceed with user consultation below.**

---

### 🎯 Your Role: Guide, Not Librarian

**IMPORTANT:** You are a **consultant who guides**, not a librarian who assigns reading.

✅ **DO THIS:**
- Read files yourself and explain key points to user
- Summarize complex concepts in simple terms
- Provide concrete examples and recommendations
- Answer questions based on your reading
- Reference files for user's future reference

❌ **DON'T DO THIS:**
- Tell user "Go read file X"
- Assign homework without context
- Point to files without explaining them
- Assume user will read documentation on their own

**Exception:** If user explicitly asks "I want to learn about X in depth", THEN point them to files for self-study while also providing high-level overview.

**Your workflow:**
1. You read the files (during consultation)
2. You understand the patterns/templates/tools
3. You explain to user in accessible language
4. You recommend specific solutions
5. You reference files as "additional details"

**Example - Right way:**
```
User: "I want to track my goals"

You: "Great! I've reviewed our goal-tracker template. It gives you
automated daily planning - you say 'Hello' each morning and get
your top 3 priorities based on long-term goals. Setup takes 10
minutes, daily use is 5 minutes.

It works by storing your goals in structured files that I read
each session, creating the illusion of memory.

Would you like me to help you deploy it?

(The template README has more details if you want to review:
templates/goal-tracker/README.md)"
```

**Example - Wrong way:**
```
User: "I want to track my goals"

You: "Please read templates/goal-tracker/README.md and let me
know if you have questions."
```

---

### Consultation Workflow (For Custom Repositories)

**When a user comes to this repository wanting to build a custom Claude Code repository, follow this workflow:**

**Step 1: Understand Their Needs**

Ask discovery questions (from `user-engagement/questions/initial-discovery.md`):
- What's their primary goal?
- Existing workflow vs desired workflow?
- Time available for setup and maintenance?
- Privacy requirements?
- Technical comfort level?

Based on answers, determine: **Quick Deployment** vs **Custom Build** vs **Life OS**

**Step 2: Match to Profile**

Identify which profile matches (YOU read `user-engagement/profiles/`):
- `researcher-student.md` - Research and learning focus
- `busy-professional.md` - Time-optimized productivity
- `hobbyist-developer.md` - Project-based exploration
- `language-learner.md` - Language acquisition
- `content-creator.md` - Content generation and documentation

Read the matching profile yourself, then explain recommended patterns to user.

**Step 3: Recommend Tools**

Based on tool guides (YOU read `user-engagement/tool-suggestions/`):
- Read `vps-guide.md` - Recommend VPS multi-agent if appropriate
- Read `skills-guide.md` - Recommend custom skills if appropriate
- Read `subagents-guide.md` - Recommend subagents if appropriate
- Reference `decision-trees/when-to-use-what.md` for decision logic

Explain to user WHY each tool fits their needs (don't just point to files).

**Step 4: Generate or Select Plan**

**If using template:**
- YOU read relevant template READMEs from `templates/`
- Explain which template matches their profile and WHY
- Summarize key features, setup time, daily workflow
- Walk them through deployment steps
- Reference template README for their future review

**If building custom:**
- YOU read appropriate plan template from `plan-generation/plan-templates/`:
  - `basic-repo-plan.md` - Simple, focused repositories
  - `life-os-plan.md` - Comprehensive integrated systems
- YOU review `plan-generation/examples/goal-tracker-example.md` as reference
- Explain the architecture to user in accessible terms
- Customize the plan based on their specific needs
- Create a customized `TO_DO.md` using `TO_DO_TEMPLATE.md`

**Step 5: Implementation Support**

If they want help implementing:
- YOU read `knowledge/full/` files for specific implementations
- YOU explain architecture decisions using insights from `knowledge/concepts/`
- Guide them through the plan incrementally
- Help them test after each phase
- Help them document as you build together

### Quick-Path Workflow (For Template Deployment)

**When user says:** "I want to track my goals" or similar specific need:

1. **Identify template match:**
   - Goal tracking → `templates/goal-tracker/`
   - Knowledge management → `templates/personal-knowledge-base/`
   - Everything integrated → `templates/life-os/`
   - Multi-agent system → `templates/vps-multi-agent/`
   - Custom/minimal → `templates/basic-repo/`

2. **Read and explain the template:**
   - YOU read the template's README.md yourself
   - Summarize key features in user-friendly language
   - Explain workflow (e.g., "You say 'Hello', get your daily plan")
   - State time commitment (setup + daily usage)
   - Set clear expectations

3. **Guide deployment:**
   - Walk them through: `cd templates/[name]/` then `./deploy_me.sh`
   - Explain what the script will do
   - Answer customization questions
   - Mention template's CLAUDE.md for post-deployment (but summarize key points)

### Research/Learning Workflow (For Understanding Framework)

**When user says:** "I want to understand subagents" or learning-focused request:

1. **Read and explain concepts:**
   - YOU read the relevant `knowledge/concepts/` file
   - Explain key concepts in simple terms
   - Give concrete examples of when to use
   - Summarize the key takeaways

2. **Offer deeper knowledge:**
   - Mention the corresponding `knowledge/full/` file has implementation details
   - Explain: "That file shows exact code/syntax when you're ready to implement"
   - Provide real-world application examples
   - Offer to walk through implementation if they want

3. **Suggest hands-on learning:**
   - Recommend specific template to try the concept
   - Or propose small custom implementation
   - Explain: "Best way to understand is to build something small"
   - Offer to guide them through it

### Key Principles for Helping Users

**1. Ask Discovery Questions First**
- Don't assume you know what they need
- Use the structured questions in `user-engagement/questions/`
- Their stated want may differ from their actual need

**2. Match Solution to Context**
- Time available matters (Life OS = 1-2 hours setup, basic-repo = 5 minutes)
- Technical comfort matters (recommend appropriate complexity)
- Privacy requirements matter (VPS vs GitHub)

**3. Explain the "Why"**
- Don't just recommend templates, explain why they fit
- Connect their goals to framework capabilities
- Help them understand tradeoffs

**4. Start Simple, Scale Up**
- Better to start with basic-repo and add complexity
- Than start with life-os and get overwhelmed
- Progressive enhancement

**5. Use File-Based Memory Pattern**
- If building custom repo, always include datasets/ directory
- Explain that "memory" = systematic file reading
- Show examples from knowledge base

**6. Emphasize Context Isolation**
- If recommending multi-agent or subagents
- ALWAYS explain context isolation (no conversation context)
- Point to instruction file examples

### Example Consultation

**User:** "I want to build something to help me learn Spanish"

**You:**
1. Ask discovery questions (time available, current methods, goals)
2. Match to `language-learner.md` profile
3. Recommend tools:
   - File-based memory for vocabulary (datasets/)
   - Potential for spaced repetition (skills or subagents)
   - Knowledge base structure for grammar notes
4. Suggest starting with `personal-knowledge-base/` template
5. Show how to customize for language learning:
   - notes/ for vocabulary
   - curricula/ for lessons
   - progress/ for tracking
6. Walk through deployment or help build custom

---

## 🚀 Getting Started

### Option 1: Use Ready-Made Templates

Browse `templates/` for pre-built repository structures:

**Available:**
- `goal-tracker/` - Goal tracking and planning system
- `personal-knowledge-base/` - Zettelkasten-style knowledge management
- `basic-repo/` - Minimal starting template
- `life-os/` - Comprehensive life operating system
- `vps-multi-agent/` - Multi-agent VPS coordination system

Each template includes:
- Complete directory structure
- CLAUDE.md with instructions
- README.md with usage guide
- `deploy_me.sh` for easy setup

**Deploy a template:**
```bash
cd templates/goal-tracker
./deploy_me.sh
# Follow prompts to create new repo
```

### Option 2: Build Custom Repository

Follow the guided process:

**Step 1: Discovery**
- Read `user-engagement/questions/` - Understand your needs
- Review `user-engagement/profiles/` - Identify your use case
- Check `user-engagement/tool-suggestions/` - Explore available tools

**Step 2: Planning**
- Use `plan-generation/plan-templates/` - Choose architecture
- Review `plan-generation/examples/` - See reference implementations
- Customize to your requirements

**Step 3: Implementation**
- Reference `knowledge/full/` guides for syntax
- Use `utilities/` helper scripts
- Build incrementally, test frequently

---

## 🎓 Learning Path

### Beginner (Start Here)

**Week 1: Core Concepts**
1. Read `subagents-concepts.md` - Understand context isolation
2. Read `skills-concepts.md` - Learn modular architecture
3. Deploy `templates/basic-repo/` - Get hands-on

**Week 2: Advanced Patterns**
1. Read `async-workflows-concepts.md` - Background execution
2. Read `task-queues-concepts.md` - Multi-agent coordination
3. Experiment with parallel workflows

**Week 3: Specialization**
1. Read `nonstandard-uses-concepts.md` - Non-code applications
2. Choose your domain (research, learning, productivity)
3. Build custom repository for your needs

### Advanced (Deep Dive)

**Multi-Agent Systems:**
1. Read `vps-multi-agent-full.md` - Architecture
2. Read `stop-hooks-full.md` - Worker persistence
3. Deploy `templates/vps-multi-agent/`
4. Build distributed system

**Productivity Multiplication:**
1. Read `unlimited-week-concepts.md` - Parallel strategies
2. Read `async-workflows-full.md` - Implementation
3. Create orchestration workflows
4. Automate repetitive work

---

## 🏗️ Repository Types

### Personal Productivity
- Goal tracking and planning
- Knowledge management
- Learning curricula
- Habit tracking

**Templates:** `goal-tracker/`, `personal-knowledge-base/`

### Research & Learning
- Literature review automation
- Multi-source research
- Language learning
- Domain expertise building

**Templates:** `personal-knowledge-base/`
**Guides:** `nonstandard-uses-concepts.md`

### Development Projects
- Multi-agent build systems
- Background task automation
- Code generation pipelines
- Testing and deployment

**Templates:** `vps-multi-agent/`
**Guides:** `async-workflows-full.md`, `task-queues-full.md`

### Life Operating System
- All-in-one integrated system
- Cross-domain intelligence
- Proactive assistance
- File-based memory

**Templates:** `life-os/`
**Guides:** All knowledge files

---

## 🧠 Critical Understanding: How Memory Works

**Claude Code does NOT have magical conversation memory.**

### What Persists:
✅ Files in the repository
✅ Git commits
✅ Documentation you write

### What Doesn't Persist:
❌ Conversation history
❌ Things discussed but not written
❌ Context from previous sessions

### How "Memory" Actually Works:

**Session 1:**
```
You: "I prefer minimal UI"
Claude: [Writes to datasets/preferences.md: "Prefers minimal UI"]
```

**Session 2 (weeks later):**
```
Claude: [Reads datasets/preferences.md on session start]
Claude: "I see you prefer minimal UI, applying that style"
```

**The "memory" is systematic file reading.** That's it. No magic.

### Implication:

Structure your repository with persistent state files:
```
your-repo/
├── datasets/
│   ├── user-profile.md      # Who you are
│   ├── preferences.md       # Your preferences
│   ├── tools-available.md   # Your tools
│   └── history.md           # What you've done
└── .claude/
    └── CLAUDE.md            # Instructs Claude to read datasets/ on start
```

See `knowledge/full/vps-multi-agent-full.md` and code-notes `CLAUDE.md` for complete examples.

---

## 🔄 Multi-Agent Context Isolation

**CRITICAL:** In multi-agent systems, workers have ZERO conversation context.

### Workers Cannot:
❌ Remember what coordinator "told" them
❌ Access conversation history
❌ Understand context from previous tasks

### All Coordination via Files:

**Task Queue** (`task-queue.json`):
- Coordinator writes tasks
- Workers read and claim

**Instruction Files** (`tasks/task-{id}-instructions.md`):
- Every task has complete instructions
- Self-contained: objective, steps, acceptance criteria

**Context Files** (referenced in tasks):
- Tasks list required context files
- Workers read before executing
- Examples: `docs/spec.md`, `src/models/base.py`

**Status Files** (`worker-status.json`, `agent-comms.jsonl`):
- Workers update status
- Coordinator monitors via file reads
- Asynchronous file-based communication

See `knowledge/concepts/task-queues-concepts.md` for complete details.

---

## 📁 Framework Structure

```
agent-repo-framework/
├── CLAUDE.md                    # This file - entry point
├── README.md                    # Public description
├── TO_DO_TEMPLATE.md            # Template for project TODOs
├── WORK_DISTRIBUTION.md         # How to distribute work between agents
│
├── knowledge/                   # Complete knowledge base
│   ├── concepts/                # Quick-read concept versions
│   ├── full/                    # Complete implementation guides
│   └── reference/               # Additional reference materials
│
├── user-engagement/             # Consultation workflow
│   ├── questions/               # Discovery questions
│   ├── profiles/                # User profile templates
│   └── tool-suggestions/        # Tool recommendation guides
│
├── plan-generation/             # Repository planning
│   ├── plan-templates/          # Architecture templates
│   └── examples/                # Reference implementations
│
├── templates/                   # Ready-to-deploy repos
│   ├── basic-repo/
│   ├── goal-tracker/
│   ├── personal-knowledge-base/
│   ├── life-os/
│   └── vps-multi-agent/
│
└── utilities/                   # Helper scripts
    ├── conference_helper.py
    └── conference_table_api.py
```

---

## 🎯 Common Use Cases

### "I want to track my goals"
→ Deploy `templates/goal-tracker/`
→ Read `nonstandard-uses-concepts.md` for strategies

### "I need to manage research across multiple topics"
→ Deploy `templates/personal-knowledge-base/`
→ Read `nonstandard-uses-concepts.md` (Research section)

### "I want multiple agents working together"
→ Read `task-queues-concepts.md` first (understand coordination)
→ Read `vps-multi-agent-full.md` (architecture)
→ Deploy `templates/vps-multi-agent/`

### "I want to maximize productivity with parallel work"
→ Read `unlimited-week-concepts.md` (strategies)
→ Read `async-workflows-full.md` (implementation)
→ Build custom orchestration

### "I want everything integrated in one system"
→ Read ALL concept files (understand pieces)
→ Review `templates/life-os/` structure
→ Build incrementally over multiple sessions

---

## 🛠️ Using This Framework

### As a Learning Resource
1. Browse `knowledge/concepts/` for ideas
2. Deep-dive `knowledge/full/` for implementation
3. Study `knowledge/reference/` for additional context

### As a Template Library
1. Browse `templates/` for pre-built solutions
2. Deploy with `deploy_me.sh` scripts
3. Customize for your needs

### As a Planning Tool
1. Use `user-engagement/` to clarify needs
2. Use `plan-generation/` to design architecture
3. Use `knowledge/` to implement

### As a Consultation Guide
1. Follow `user-engagement/questions/`
2. Match to `user-engagement/profiles/`
3. Apply `user-engagement/tool-suggestions/`
4. Generate plan from `plan-generation/plan-templates/`

---

## 🌟 Philosophy

**This framework exists to democratize advanced Claude Code usage.**

You don't need to be an expert to build powerful systems. This framework provides:

1. **Knowledge** - Comprehensive guides (full + concept versions)
2. **Templates** - Ready-to-use starting points
3. **Patterns** - Proven architectural approaches
4. **Tools** - Helper utilities and scripts

Whether you're:
- A researcher organizing knowledge
- A student managing learning
- A professional optimizing productivity
- A hobbyist building projects
- A creator generating content

**You can build systems that amplify your capabilities.**

---

## 📝 Quick Reference

**First time here?**
→ Read this CLAUDE.md completely
→ Browse `knowledge/concepts/` for overview
→ Deploy a template to get started

**Want a specific solution?**
→ Check `templates/` for pre-built options
→ Review deployment READMEs
→ Run `deploy_me.sh`

**Need custom architecture?**
→ Follow `user-engagement/` workflow
→ Use `plan-generation/` templates
→ Reference `knowledge/full/` for implementation

**Want to understand deeply?**
→ Read all concept files (quick overview)
→ Deep-dive full files (comprehensive details)
→ Experiment with templates
→ Build custom solutions

---

## ⚠️ Important Notes

### Context Isolation
- Subagents have NO conversation context
- File-based coordination is mandatory
- Every task needs complete instructions
- See `knowledge/concepts/subagents-concepts.md`

### File-Based Memory
- Only files persist between sessions
- "Memory" = systematic file reading
- Document everything important
- CLAUDE.md instructs session behavior

### Multi-Agent Systems
- Workers operate in discrete cycles
- Stop hooks enable persistence
- Task queues coordinate work
- All communication via files

---

## 🚀 Next Steps

1. **Read** this CLAUDE.md completely ✓
2. **Explore** `knowledge/concepts/` (2-3 hours)
3. **Deploy** a template to experiment (30 min)
4. **Build** your custom repository (ongoing)

**Remember:** Start small, test frequently, iterate based on usage.

---

## 📜 Framework Origins & Source Material

This framework was built FROM a working VPS multi-agent coordination system. Understanding the origins provides valuable context:

### Source Repository

The parent repository (`chat-with-websites/`) contains the **original implementation** of the VPS multi-agent system, including:

**Original Knowledge Files:**
- `knowledge/01-environment-benefits.md` - Claude Code environments
- `knowledge/02-vps-multi-agent-architecture.md` - Core architecture
- `knowledge/03-stop-hooks-worker-persistence.md` - Worker persistence
- `knowledge/04-vps-api-specification.md` - VPS API documentation
- `knowledge/05-task-queue-coordination.md` - Task queue design

**Original Instructions:**
- `CLAUDE.md` - VPS system agent instructions (how to build the system)
- `README.md` - VPS system overview and architecture
- `TO_DO.md` - Implementation steps for VPS multi-agent system

### Extraction & Generalization Process

This framework (agent-repo-framework) was created by:

1. **Extracting knowledge** from the original VPS implementation
2. **Creating two versions**:
   - Concept versions (24-58% shorter, ideas-focused)
   - Full versions (complete with code and syntax)
3. **Generalizing patterns** beyond just VPS systems
4. **Adding consultation workflow** (user-engagement/)
5. **Creating templates** for different use cases
6. **Building planning tools** (plan-generation/)

### Relationship to Templates

The `templates/vps-multi-agent/` template is directly inspired by the parent repository's implementation. If you want to:

- **See a working VPS system**: Check the parent repo
- **Understand the architecture deeply**: Read parent repo's knowledge/02 and 05
- **Implement VPS coordination**: Use the vps-multi-agent template
- **Build something similar**: Study the parent repo, then generalize

### Additional Material in Parent Repo

The parent repository also contains:

**code-notes/** - Comprehensive Claude Code documentation including:
- `CLAUDE.md` - Claude Code complete understanding
- `SKILLS_ADVANCED_GUIDE.md` - Advanced skills patterns
- `ASYNC_WORKFLOWS.md` - Async patterns
- `UNLIMITED_WEEK_STRATEGY.md` - Productivity multiplication
- `NONSTANDARD_USES.md` - Non-coding applications

Much of this material was also extracted into this framework's knowledge base.

### Why This Matters

**Understanding the source helps you:**
- See a working implementation (proof-of-concept)
- Understand design decisions (why things are this way)
- Adapt patterns to your needs (learn by example)
- Trace concepts to real code (concrete examples)

**When to reference parent repo:**
- Building VPS multi-agent system (see working example)
- Understanding context isolation deeply (see actual implementation)
- Need complete VPS API usage examples (reference original)
- Want to understand evolution of framework concepts

---

*This framework combines learnings from VPS multi-agent systems and Claude Code consultation patterns. It evolves continuously as new patterns emerge.*

**Let's build something amazing! 🚀**
