# Claude Code Agent Repository Framework

A comprehensive framework for building agent-based repositories with Claude Code.

## 🎯 What This Is

This framework provides everything you need to design and build specialized Claude Code repositories:

- **📚 Knowledge Base** - Complete guides (full + concept versions) covering all Claude Code patterns
- **🎭 Consultation Workflow** - Questions, profiles, and decision trees for understanding user needs
- **📋 Planning Tools** - Templates and examples for designing custom repositories
- **🚀 Ready Templates** - Pre-built repository structures you can deploy immediately
- **🛠️ Utilities** - Helper scripts for common patterns

## 🚀 Quick Start

### For First-Time Users

1. **Read** `CLAUDE.md` (the entry point - explains everything)
2. **Browse** `knowledge/concepts/` (quick overview of all patterns)
3. **Deploy** a template from `templates/` to get started
4. **Customize** based on your needs

### For Building Custom Repositories

1. **Discovery** - Use `user-engagement/questions/` to understand needs
2. **Planning** - Use `plan-generation/templates/` to design architecture
3. **Implementation** - Reference `knowledge/full/` for detailed guidance
4. **Deploy** - Create and test your custom repository

## 📚 What's Inside

### Knowledge Base (`knowledge/`)

**Two-Version System:**

- **`concepts/`** - Streamlined guides (24-58% shorter) focusing on ideas and architecture
- **`full/`** - Complete guides with code examples, syntax, and step-by-step tutorials
- **`reference/`** - Additional reference materials

**Reading Strategy:** Start with concepts for understanding, refer to full versions when implementing.

**Topics Covered:**
- Multi-agent coordination and context isolation
- Skills and modular architecture
- Subagents and parallel execution
- Async workflows and background execution
- Task queues and file-based coordination
- VPS integration and worker persistence
- Non-standard uses (research, learning, productivity)
- Unlimited week strategies (parallel productivity)

### User Engagement (`user-engagement/`)

**Consultation Framework:**

- **`questions/`** - Discovery questions for understanding user needs
  - Initial discovery (separate repo vs Life OS decision)
  - Quick deployment questions (30-60 min path)
  - Life OS questions (deep interview, 2-3 hours)

- **`profiles/`** - User profile templates
  - Researcher/Student
  - Busy Professional
  - Hobbyist Developer
  - Language Learner
  - Content Creator

- **`tool-suggestions/`** - Guidance on advanced tools
  - VPS multi-agent coordination
  - Skills system
  - Subagents
  - Decision trees for tool selection

### Plan Generation (`plan-generation/`)

**Repository Planning:**

- **`plan-templates/`** - Templates for designing custom repositories
  - Basic repo plan
  - Life OS plan

- **`examples/`** - Complete reference implementations
  - Goal tracker example (detailed)

### Templates (`templates/`)

**Ready-to-Deploy Repositories:**

- `goal-tracker/` - Goal tracking with proactive planning
- `personal-knowledge-base/` - Zettelkasten-style knowledge management
- `basic-repo/` - Minimal starting template
- `life-os/` - Comprehensive life operating system
- `vps-multi-agent/` - Multi-agent VPS coordination system

Each includes:
- Complete directory structure
- `CLAUDE.md` with instructions
- `README.md` with usage guide
- `deploy_me.sh` for easy setup

### Utilities (`utilities/`)

**Helper Scripts:**
- `conference_helper.py` - Multi-agent conference table coordination
- `conference_table_api.py` - API for agent communication

## 🎓 Learning Paths

### Beginner

1. Read `CLAUDE.md`
2. Browse `knowledge/concepts/` (2-3 hours)
3. Deploy `templates/goal-tracker/` or `templates/personal-knowledge-base/`
4. Experiment and customize

### Advanced

1. Read all concept files (quick overview)
2. Deep-dive into relevant full guides
3. Study `plan-generation/examples/`
4. Build custom Life OS or multi-agent system

## 🔧 Use Cases

### Personal Productivity
- Goal tracking and planning → `goal-tracker/`
- Knowledge management → `personal-knowledge-base/`
- Daily automation → Custom with `basic-repo/`

### Research & Learning
- Literature review → `personal-knowledge-base/` + research skills
- Language learning → Custom with spaced repetition
- Domain expertise building → `life-os/` with learning domain

### Development Projects
- Multi-agent builds → `vps-multi-agent/`
- Background automation → Custom with async workflows
- Code generation → Skills-based system

### Life Operating System
- All-in-one integration → `life-os/`
- Cross-domain intelligence → Custom comprehensive system
- Proactive assistance → File-based memory system

## ⚠️ Critical Concepts

### File-Based Memory
**Claude Code has NO magical conversation memory.**

What persists:
- ✅ Files in the repository
- ✅ Git commits
- ✅ Documentation

What doesn't persist:
- ❌ Conversation history
- ❌ Things discussed but not written

**"Memory" = systematic file reading.** Structure your repo with `datasets/` containing user profile, preferences, tools, and history.

### Context Isolation
**In multi-agent systems, workers have ZERO conversation context.**

All coordination via files:
- Task queue (`task-queue.json`)
- Instruction files (`tasks/*.md`)
- Context files (referenced in tasks)
- Status files (`worker-status.json`, `agent-comms.jsonl`)

See `knowledge/concepts/task-queues-concepts.md` for details.

## 📖 Documentation

**Start Here:**
- `CLAUDE.md` - Complete framework overview and entry point

**Consultation:**
- `user-engagement/questions/initial-discovery.md` - First conversation with user
- `user-engagement/profiles/README.md` - Match user to profile

**Planning:**
- `plan-generation/README.md` - How to use planning tools
- `plan-generation/plan-templates/` - Architecture templates

**Implementation:**
- `knowledge/full/` - Detailed guides with code
- `templates/` - Working examples

## 🚀 Deployment

### Deploy This Framework to Your GitHub

If you want to create your own copy of this framework:

```bash
# From inside agent-repo-framework directory:
./deploy_framework.sh
# Follow prompts to create new GitHub repo
```

This creates a fresh GitHub repository with the complete framework.

### Using a Template

```bash
cd templates/goal-tracker
./deploy_me.sh
# Follow prompts
```

### Building Custom

1. Use `user-engagement/` workflow to understand needs
2. Create plan from `plan-generation/plan-templates/`
3. Implement using `knowledge/full/` guides
4. Test and iterate
5. Deploy to GitHub

## 🤝 Contributing

This framework evolves based on discoveries and patterns. To contribute:

1. Build something useful with Claude Code
2. Document your pattern/template
3. Share via pull request

## 📝 Framework Structure

```
agent-repo-framework/
├── CLAUDE.md                    # Entry point and orchestrator
├── README.md                    # This file
├── TO_DO_TEMPLATE.md            # Template for project TODOs
├── WORK_DISTRIBUTION.md         # Multi-agent work distribution guide
│
├── knowledge/                   # Complete knowledge base
│   ├── concepts/                # Quick-read concept versions (8 files)
│   ├── full/                    # Complete guides (11 files)
│   └── reference/               # Additional materials (3 files)
│
├── user-engagement/             # Consultation workflow
│   ├── questions/               # Discovery questions (3 files)
│   ├── profiles/                # User profiles (6 files)
│   └── tool-suggestions/        # Tool guides (4 files)
│
├── plan-generation/             # Repository planning
│   ├── plan-templates/          # Architecture templates (2 files)
│   └── examples/                # Reference implementations (1 file)
│
├── templates/                   # Ready-to-deploy repos (5 templates)
│   ├── basic-repo/
│   ├── goal-tracker/
│   ├── personal-knowledge-base/
│   ├── life-os/
│   └── vps-multi-agent/
│
└── utilities/                   # Helper scripts (2 files)
```

## 🌟 Philosophy

**Democratize advanced Claude Code usage.**

You don't need to be an expert to build powerful AI-assisted systems. This framework provides knowledge, templates, patterns, and tools to help anyone build systems that amplify their capabilities.

## 📞 Getting Help

1. Read `CLAUDE.md` completely
2. Browse relevant concept files
3. Study examples in `plan-generation/examples/`
4. Reference full guides for implementation details

## 🔍 Framework Origins

This framework was extracted and generalized from a working VPS multi-agent coordination system. The knowledge, patterns, and templates are based on real implementations and research into multi-agent systems, Claude Code best practices, and file-based coordination architectures.

**Source Material:**
- VPS multi-agent system implementation (parent repository)
- Claude Code consultation patterns
- Real-world template usage

See `CLAUDE.md` section "Framework Origins & Source Material" for complete details.

## 📄 License

This is a research framework. Use freely for your projects.

---

**Ready to build?** Open `CLAUDE.md` and start reading! 🚀

*Remember: Files = Memory. Context Isolation = Mandatory. Start Small = Win Big.*
