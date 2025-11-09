# Multi-Agent VPS Coordination System

A research implementation of a distributed multi-agent system where multiple Claude Code agents collaborate in real-time through a shared VPS workspace.

## 🎯 What Is This?

This is not a traditional software project - it's a **meta-system** that enables multiple Claude agents to work together on the same codebase simultaneously, with true real-time collaboration.

**Key Innovation:** Instead of each agent working in isolated GitHub branches, all agents share a workspace on a VPS, enabling:
- Real-time file sharing
- Task queue coordination
- Distributed work assignment
- Persistent worker agents

## 🏗️ Architecture Overview

```
┌─────────────────┐
│  GitHub Repo    │  ← Contains ONLY instructions and tooling
│  (This repo)    │     NOT the actual project code
└─────────┬───────┘
          │
          ↓
┌─────────────────────────────┐
│  Multiple Claude Sessions   │
│  - 1 Coordinator Agent      │
│  - N Worker Agents          │
└────────┬────────────────────┘
         │
         ↓
┌─────────────────────────────┐
│  VPS Shared Workspace       │
│  - Actual code lives here   │
│  - Task queue               │
│  - Worker status            │
│  - Communication logs       │
└─────────────────────────────┘
```

## 🚀 Quick Start

### For the Next Session

1. **Read `CLAUDE.md`** - Start here for complete instructions
2. **Read all knowledge files** in `knowledge/` directory (required!)
3. **Follow `TO_DO.md`** - Step-by-step implementation guide
4. **Verify environment** has `VPS_API_KEY` configured

### Prerequisites

- Claude Code on the web (Pro or Max subscription)
- Access to VPS at `51.75.162.195:5555`
- Environment named "vps-dev" with:
  - `VPS_API_KEY` configured
  - Full network access enabled

## 📚 Documentation Structure

| File | Purpose |
|------|---------|
| `CLAUDE.md` | **START HERE** - Main instructions for agents |
| `TO_DO.md` | Step-by-step implementation checklist |
| `knowledge/01-environment-benefits.md` | Understanding Claude Code environments |
| `knowledge/02-vps-multi-agent-architecture.md` | The multi-agent system architecture |
| `knowledge/03-stop-hooks-worker-persistence.md` | How to keep workers alive |
| `knowledge/04-vps-api-specification.md` | VPS API documentation |
| `knowledge/05-task-queue-coordination.md` | Task queue system design |

## 🎭 Key Concepts

### GitHub as "Thin Client"

The GitHub repo contains:
- ✅ Instructions (CLAUDE.md)
- ✅ Skills (.claude/skills/)
- ✅ Hooks (.claude/hooks/)
- ✅ Templates
- ❌ NO actual project code

### VPS as Shared Workspace

The VPS hosts:
- ✅ Actual project code
- ✅ Task queue (JSON files)
- ✅ Worker status tracking
- ✅ Inter-agent communication

### Multi-Agent Collaboration

- **Coordinator Agent**: You talk to this one
  - Breaks down user requests into tasks
  - Monitors worker health
  - Reports progress

- **Worker Agents**: Run autonomously
  - Poll task queue continuously
  - Claim and execute available tasks
  - Use Stop hooks to stay alive while needed

## 🔧 How It Works

### 1. User Interaction
```
You → Coordinator: "Build a REST API with authentication"
```

### 2. Task Creation
```
Coordinator → VPS Task Queue:
  - Task 1: Create database models
  - Task 2: Build auth endpoints
  - Task 3: Write tests
  - Task 4: Create documentation
```

### 3. Worker Execution
```
Worker 1 (Backend): Claims Task 1 & 2
Worker 2 (Testing): Claims Task 3
Worker 3 (Docs): Claims Task 4

All working simultaneously on same VPS workspace
```

### 4. Completion
```
All tasks complete → Workers shutdown gracefully
Coordinator → You: "Done! API is live on VPS"
```

## ✨ Benefits

### vs. GitHub Branches (Standard Approach)

| Feature | GitHub Branches | VPS Workspace |
|---------|----------------|---------------|
| Real-time collaboration | ❌ No | ✅ Yes |
| State sharing | ❌ Isolated | ✅ Shared |
| Merge overhead | ❌ High | ✅ None |
| Privacy | ⚠️ Code on GitHub | ✅ Code on VPS |
| Session persistence | ⚠️ Lost | ✅ Persists |

### Key Advantages

1. **Privacy**: Code never touches GitHub
2. **Collaboration**: Multiple agents see same files instantly
3. **Persistence**: Work survives session interruptions
4. **Scalability**: Add more workers as needed
5. **Real Environment**: Work on actual deployment server

## 📦 Implementation Status

**Current Status:** Documentation Phase Complete

**Next Steps:**
1. Test VPS connection
2. Build VPS deployment skill
3. Implement task queue system
4. Create Stop hooks
5. Test with multiple agents

See `TO_DO.md` for detailed implementation checklist.

## 🎯 Use Cases

Perfect for:
- ✅ Large refactoring projects
- ✅ Building complex applications
- ✅ Parallel feature development
- ✅ Privacy-sensitive codebases
- ✅ Direct-to-production workflows

Not ideal for:
- ❌ Simple single-file changes
- ❌ Code review workflows
- ❌ Open source collaboration
- ❌ Projects requiring GitHub history

## 🔒 Security Considerations

- **API Key**: Stored in environment variable, never committed
- **VPS Access**: Restricted by API authentication
- **Network**: Configurable (full, limited, or no internet)
- **Isolation**: Each project in separate VPS directory
- **Audit**: All agent actions logged in communication file

## 🐛 Known Limitations

- **Rate Limits**: Multiple agents = multiplied token usage
- **Cost**: Running 4+ agents simultaneously is expensive
- **Network Latency**: Every operation is an API call
- **Worker Management**: Workers timeout after idle period
- **GitHub Integration**: Minimal (by design)

## 🤝 Contributing

This is a research implementation exploring multi-agent coordination patterns. If you're implementing this:

1. Read ALL documentation first
2. Follow `TO_DO.md` steps sequentially
3. Test thoroughly at each step
4. Document any issues or improvements

## 📝 License

This is experimental research code. Use at your own risk.

## 🙏 Acknowledgments

Built on:
- Claude Code on the web (Anthropic)
- Flask VPS API
- Multi-agent coordination patterns

---

**Ready to build?** Open `CLAUDE.md` and start reading! 📖
