# VPS Multi-Agent Coordination: Tool Suggestion Guide

## What Is VPS Multi-Agent Coordination?

VPS multi-agent coordination enables multiple Claude agents to collaborate in real-time through a **shared workspace on a remote server** (VPS). Instead of agents working in isolated GitHub branches, they all access the same files simultaneously, enabling true distributed teamwork.

**Key principle:** Agents coordinate through shared state files (task queues, status files, communication logs) rather than conversation context.

**References:** See `vps-multi-agent-full.md` (architecture), `task-queues-concepts.md` (coordination), `stop-hooks-concepts.md` (worker persistence)

---

## When to Use VPS Coordination

### Strong Use Cases ✅

**1. Complex Multi-Phase Projects**
- Breaking a large project into 20+ tasks
- Different parts require different expertise
- Need real-time progress visibility
- Example: Building a full-stack application (backend, frontend, testing, DevOps in parallel)

**2. Continuous Background Processing**
- Long-running work that doesn't fit in one session
- Need workers to persist idle, waiting for new tasks
- Example: Processing tasks as they arrive in a queue

**3. True Real-Time Collaboration**
- Multiple agents must see each other's work immediately
- Can't wait for PR merges or manual coordination
- Need automatic load balancing across workers
- Example: 4 workers simultaneously building different API endpoints

**4. Privacy-Sensitive Projects**
- Code must never touch GitHub
- Need shared development environment
- Compliance requirements (HIPAA, SOC2, etc.)
- Example: Healthcare software, financial systems

**5. Large-Scale Projects with Unlimited Storage**
- Codebase too large for GitHub
- Need gigabytes of data/logs/artifacts
- VPS storage is effectively unlimited

**6. Access to External Services**
- Need database connections
- Require API access to internal services
- Must run code in production/staging environment

---

## When NOT to Use VPS Coordination

### Poor Use Cases ❌

**1. Simple Single-Task Projects**
- Project fits in one session
- One agent can complete it entirely
- No multi-agent coordination needed
- **Use instead:** GitHub repo + Claude Code session

**2. Disconnected Work Streams**
- Agents genuinely don't need to interact
- Can work completely independently
- No shared state to coordinate
- **Use instead:** Separate GitHub repos with isolated agents

**3. Rapid Prototyping**
- Quick experiments and iterations
- Don't need persistence across sessions
- Focus on speed, not sophistication
- **Use instead:** Lightweight GitHub repo

**4. GitHub-Integrated Workflows**
- Must use GitHub Actions or branch protection
- Require PR reviews and CI/CD
- Need commit history for audit
- **Use instead:** Standard GitHub repo

**5. One-Time Knowledge Extraction**
- Research tasks that generate reports
- Knowledge work without persistent codebase
- No ongoing development
- **Use instead:** Personal knowledge base template

**6. Budget-Constrained Scenarios**
- Need to minimize token costs
- Running 4 agents simultaneously is expensive
- Token budget limited
- **Use instead:** Single-agent GitHub repo

---

## Practical Use Cases with Examples

### Example 1: E-Commerce Platform (GREAT FIT)

**Why VPS coordination works:**
- 4-5 workers in parallel: Backend, Frontend, Database, Testing, DevOps
- 50+ independent tasks in queue
- Agents need real-time visibility of progress
- Code is proprietary (stays on VPS)
- Long-running project (multiple weeks)

**Timeline:**
1. Coordinator breaks project into 50 tasks
2. 4 workers claim tasks continuously
3. Workers complete 8-12 tasks each per session
4. Progress accumulates across multiple sessions
5. Project completes in 2-3 weeks vs. 8+ weeks with one agent

**Cost:** ~500K tokens per worker session × 4-5 workers = 2-3M tokens total (still cheaper than human developer)

---

### Example 2: Research Literature Review (POOR FIT)

**Why VPS coordination doesn't work:**
- One researcher reading papers and taking notes
- No parallel work possible
- No coordination needed between steps
- Output is markdown files, not code
- Better suited to personal knowledge base

**Better approach:**
- Use `templates/personal-knowledge-base/`
- Claude accumulates knowledge across sessions
- No VPS complexity needed

---

### Example 3: Building a React Component Library (MODERATE FIT)

**Why it partially works:**
- Can parallelize: 5 components × 3 workers = 15 parallel development paths
- Each worker builds 2-3 components
- Testing can happen in parallel
- Documentation can be written in parallel

**Consideration:** Only worth VPS overhead if 20+ components or complex dependencies between components. For simple library, single agent is faster.

---

## Prerequisites for VPS Coordination

Before committing to VPS approach, verify:

### Technical Requirements

1. **VPS Access**
   - Leased VPS server (dedicated or shared)
   - Public IP with port access
   - SSH access or control panel
   - ~2GB minimum storage

2. **VPS API Endpoint**
   - Flask API running on VPS (typically port 5555)
   - Can list/upload/execute files
   - Authentication via API key

3. **Network Connectivity**
   - Claude Code environment has full network access
   - Can reach VPS IP:port
   - No firewall blocking

4. **Git Repository**
   - GitHub repo for instructions only
   - .claude/skills/ for VPS deployment skill
   - .claude/hooks/ for stop hooks (worker persistence)

### Knowledge Prerequisites

1. Understand **context isolation** - workers have zero conversation context
2. Understand **task queue coordination** - how to structure work
3. Understand **stop hooks** - how workers persist idle
4. Read `vps-multi-agent-full.md` before implementing

### Team Prerequisites

1. **Dedicated coordinator** - One person/agent manages the queue
2. **Process discipline** - Write tasks as self-contained instruction files
3. **Documentation** - Everything must be in files, not conversation
4. **Monitoring** - Someone checks progress regularly

---

## Setup Complexity Assessment

### Time Estimates

| Phase | Time | Difficulty |
|-------|------|------------|
| **Read knowledge files** | 2-3 hours | Easy |
| **VPS setup** | 1-2 hours | Medium (depends on VPS provider) |
| **Implement VPS skill** | 2-3 hours | Medium |
| **Implement task queue system** | 2-3 hours | Medium |
| **Create stop hooks** | 1-2 hours | Medium |
| **Test multi-worker system** | 2-3 hours | Medium |
| **First project deployment** | 2-4 hours | Easy (templates provided) |
| **Total** | **12-20 hours** | Medium overall |

### Ongoing Maintenance

- **Monitoring:** 15 minutes daily (check worker status, task queue)
- **Scaling:** 1 hour to add new worker template
- **Troubleshooting:** 30-60 minutes for common issues

---

## Cost Considerations

### Token Costs

**Single-agent traditional approach:**
- 1 session × 8 hours × 20K tokens/hour = 160K tokens
- Cost: ~$2.40

**4-worker VPS approach (same project, 4x speedup):**
- 4 agents × 2 hours each × 20K tokens/hour = 160K tokens
- Cost: ~$2.40 (same total, but 4x faster)
- Break-even: No cost difference if you value time

**Key insight:** VPS doesn't increase token costs; it trades time for the same tokens. Value proposition is **speed**, not efficiency.

### Infrastructure Costs

- **VPS server:** $5-20/month depending on provider
- **Storage:** Usually included in VPS
- **Bandwidth:** Usually unlimited or very cheap

**Total infrastructure:** $60-240/year

### When Cost Matters

- **Budget project:** Don't use VPS (traditional approach cheaper)
- **Time-critical project:** Use VPS (time value > $60/year)
- **Ongoing service:** VPS amortizes cost over many projects

---

## Decision Framework

Ask yourself these questions in order:

### 1. **Scope & Timeline**
- Is this project 50+ hours of work? → YES → Continue
- Can one agent finish in 1-2 sessions? → NO → Continue
- Would 3-4 parallel agents help? → YES → Continue
- ❌ If all NO → Don't use VPS

### 2. **Coordination Needs**
- Do agents need to see each other's work in real-time? → YES → Continue
- Is work easily parallelizable into 20+ tasks? → YES → Continue
- Would task queue approach work? → YES → Continue
- ❌ If all NO → Don't use VPS

### 3. **Technical Readiness**
- Do you have VPS access? → YES → Continue
- Can you run Flask API on VPS? → YES → Continue
- Can you commit to reading knowledge files? → YES → Continue
- ❌ If any NO → Set up prerequisites first

### 4. **Resource Availability**
- Can you afford $60-240/year for VPS? → YES → Continue
- Can you manage 4 simultaneous sessions? → YES → Use VPS
- ❌ If any NO → Single-agent approach

---

## Recommended Decision Tree

```
START: I want to build something

├─ Single session project?
│  ├─ YES → Use traditional GitHub repo
│  └─ NO ↓
│
├─ Multi-month project?
│  ├─ NO → Use traditional GitHub repo
│  └─ YES ↓
│
├─ Can parallelize into 20+ independent tasks?
│  ├─ NO → Use traditional GitHub repo
│  └─ YES ↓
│
├─ Want agents to see each other's work in real-time?
│  ├─ NO → Use traditional GitHub repo with coordination files
│  └─ YES ↓
│
├─ Have VPS access?
│  ├─ NO → Get VPS first, then use VPS approach
│  └─ YES ↓
│
└─ ✅ USE VPS MULTI-AGENT COORDINATION

   └─ Deploy vps-multi-agent template
      Read knowledge files first
      Start with single coordinator + 2 workers
      Scale up to 4-5 workers as needed
```

---

## Getting Started Checklist

If you've decided VPS coordination is right for you:

- [ ] Read `vps-multi-agent-full.md` (architecture overview)
- [ ] Read `task-queues-concepts.md` (understand coordination)
- [ ] Read `stop-hooks-concepts.md` (understand worker persistence)
- [ ] Verify VPS access and Flask API running
- [ ] Review `templates/vps-multi-agent/` structure
- [ ] Deploy template and run test with 2 workers
- [ ] Plan first project: break into 20-30 tasks
- [ ] Create instruction files for first 5 tasks
- [ ] Launch coordinator + 2 workers
- [ ] Monitor and adjust

---

## Quick Reference: When to Choose What

| Tool | When | Why |
|------|------|-----|
| **GitHub + 1 agent** | Single-session work | Simple, no overhead |
| **GitHub + coordination files** | Multi-session, single agent | Persistence without complexity |
| **GitHub + 2 workers** | Small parallel work | Some coordination benefit |
| **VPS + 4+ workers** | Large projects, true collaboration | Real-time coordination, major speedup |

---

**Reference Knowledge:**
- Full architecture: `knowledge/full/vps-multi-agent-full.md`
- Task queue patterns: `knowledge/concepts/task-queues-concepts.md`
- Worker persistence: `knowledge/concepts/stop-hooks-concepts.md`

**Ready to build?** → `templates/vps-multi-agent/` contains everything you need.
