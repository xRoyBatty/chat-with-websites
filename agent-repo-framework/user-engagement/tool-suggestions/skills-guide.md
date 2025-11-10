# Skills Tool Suggestion Guide

**Reference:** `knowledge/concepts/skills-concepts.md`

---

## What Are Skills?

Skills are modular instruction packages that extend Claude's capabilities. Think of them as custom tools:

- **Structured instructions** for accomplishing specific tasks
- **Bundled resources** (scripts, templates, documentation)
- **Automatically loaded** at session start
- **Team-shareable** via version control (project skills)

**Key point:** Skills aren't magic. They're organized instructions that help Claude work more effectively on your specific tasks.

---

## When to Use Skills vs Other Tools

### Use a Skill When:
- **Recurring workflows** - You do this task repeatedly
- **Complex procedures** - Multi-step processes need consistent guidance
- **Team coordination** - Multiple people need the same approach
- **Specialized knowledge** - Domain-specific expertise to capture

### Use Built-In Tools Instead When:
- **Simple, one-time tasks** - Direct tool use is faster
- **Ad-hoc exploratory work** - No workflow established yet
- **Quick commands** - Native CLI tool is simpler
- **Testing/experimentation** - Skill overhead isn't justified

**Decision point:** If you'd explain the same process twice to Claude, it's time for a skill.

---

## Skill Types: Choose Your Scope

### Personal Skills
**For:** Individual workflows, private tools, experimental features

**Pros:**
- ✅ Private (not in version control)
- ✅ Quick iteration without team coordination
- ✅ Can include personal credentials

**Cons:**
- ❌ Not shared with team
- ❌ Lost if user directory deleted
- ❌ Not portable across machines

**When to use:** Personal productivity workflows, machine-specific setups, tools you're still refining

**Example:** Your personal code review preferences, debug scripts for your dev environment

### Project Skills
**For:** Team-shared workflows, project conventions, onboarding automation

**Pros:**
- ✅ Version controlled (team consistency)
- ✅ Automatically available to all team members
- ✅ Evolve with project

**Cons:**
- ❌ Public repository (never store secrets)
- ❌ Changes affect entire team
- ❌ Requires team coordination

**When to use:** Deployment procedures, testing workflows, code review standards, API documentation generation

**Example:** "Deploy to staging," "Run full test suite," "Generate API docs"

### Plugin Skills
**For:** Community distribution, framework-specific helpers, reusable across projects

**Pros:**
- ✅ Wide distribution potential
- ✅ Professional packaging
- ✅ Discoverable by other users

**Cons:**
- ❌ Complex to create
- ❌ Less customizable for users
- ❌ Requires plugin infrastructure

**When to use:** Publishing reusable solutions, framework-specific integrations, tools for broad audience

**Example:** Django migration helper (reusable across projects), security scanner for Go code

---

## Custom Skills vs Built-In Tools

### Build Custom Skills When:

**Multi-step workflows:**
- Complex procedures requiring consistent order
- Safety guardrails needed
- Decision trees to follow

**Specialized instruction:**
- Domain-specific conventions
- Team-specific practices
- Best practices you want enforced

**Automation + judgment:**
- Scripts handling routine parts
- AI judgment for complex parts
- Need both consistency and flexibility

### Use Built-In Tools Directly When:

**Simple operations:**
- Single API call or command
- Standard tool does what you need
- No special workflow required

**One-time tasks:**
- Task doesn't repeat
- Different approach each time
- Skill overhead unjustified

**Exploration phase:**
- Still figuring out the process
- Requirements not stable
- Building skill would be premature

**Decision formula:**
```
Task Complexity × Frequency × Need for Consistency = Skill Priority

High × High × High = Build skill immediately
Low × Low × Low = Use built-in tools directly
Mixed = Evaluate each factor
```

---

## Use Cases by Domain

### Software Development
| Task | Recommendation | Skill Type |
|------|---|---|
| Code review process | Project skill | Multi-step checklist |
| Deployment to production | Project skill | Automation + safety gates |
| Local dev environment setup | Personal skill | Machine-specific config |
| Test result analysis | Skill (hybrid) | Scripts + AI judgment |
| Generate changelog | Project skill | Format consistency |

### Research & Writing
| Task | Recommendation | Skill Type |
|------|---|---|
| Literature review | Project skill | Structured analysis framework |
| Research organization | Personal skill | Your personal system |
| Paper outline generation | Skill (pure AI) | No automation needed |
| Citation formatting | Project skill | Consistency across work |
| Interview transcription analysis | Project skill | Multi-step process |

### Knowledge Management
| Task | Recommendation | Skill Type |
|------|---|---|
| Zettelkasten entry creation | Project skill | Link discovery + formatting |
| Daily note template | Skill (pure AI) | No automation |
| Regular review process | Project skill | Spaced repetition schedule |
| Cross-file linking | Skill (hybrid) | Scripts find, AI links |
| Archive old notes | Personal skill | Your retention policy |

---

## Complexity Levels & Skill Architecture

### Simple Skill (1 file, no scripts)
**When:** Single coherent workflow, no automation
- **Size:** < 2KB
- **Components:** Just instructions
- **Example:** Code review checklist

**Cost-benefit:** Low effort, low overhead, good for simple processes

### Medium Skill (1-2 files, optional scripts)
**When:** Established workflow with some routine parts
- **Size:** 2-5KB
- **Components:** Instructions + helper scripts
- **Example:** Test running + analysis

**Cost-benefit:** Moderate effort, good efficiency gain for regular use

### Complex Skill (Multiple files, orchestration)
**When:** Multi-step workflow with sub-specialties
- **Size:** 5-15KB
- **Components:** Main orchestrator + specialized sub-skills
- **Example:** Full deployment pipeline

**Cost-benefit:** High effort, significant efficiency for team or frequent use

**Don't over-engineer:** Start with simple, add complexity as needed.

---

## Decision-Focused Scenarios

### Scenario 1: "I keep explaining the same process to Claude"
**Decision:** Build a skill
- **Type:** Personal (private) or Project (shared)?
- **Complexity:** Simple skill with instructions
- **Timeline:** 30 minutes to build

### Scenario 2: "Our team needs consistent approach to X"
**Decision:** Project skill
- **Include:** Team conventions, safety checks, decision guidelines
- **Version control:** Commit to repo
- **Timeline:** 1-2 hours with team input

### Scenario 3: "I have a complex workflow with scripts"
**Decision:** Skill with hybrid approach
- **Structure:** Main skill orchestrates + scripts handle automation
- **Scripts:** Version control and maintain
- **Timeline:** 2-4 hours initial, ongoing maintenance

### Scenario 4: "This is my first time doing this"
**Decision:** Don't build a skill yet
- **Action:** Do it with direct tool use
- **Timing:** Build skill after 2-3 repetitions
- **Benefit:** Understand process before codifying

### Scenario 5: "This needs to be bulletproof"
**Decision:** Hybrid skill with heavy testing
- **Structure:** Scripts for deterministic parts, AI for judgment
- **Safety:** Explicit confirmations for risky operations
- **Testing:** Comprehensive test cases included

### Scenario 6: "This could be useful to others"
**Decision:** Plugin skill
- **Audience:** Clear target users
- **Documentation:** Comprehensive examples
- **Timeline:** 4-8 hours + plugin infrastructure

---

## Quick Decision Tree

```
Does this task repeat?
├─ NO → Use built-in tools directly
└─ YES → Does it have consistent steps?
   ├─ NO → Use built-in tools, add skill later
   └─ YES → Is it complex (5+ steps)?
      ├─ NO → Simple skill (instructions only)
      └─ YES → Is it routine + judgment mix?
         ├─ YES → Medium skill (scripts + AI)
         └─ NO → Check automation complexity
            ├─ Simple → Simple skill
            └─ Complex → Complex skill (orchestration)

Is this personal or team?
├─ Personal → Personal skill
├─ Team → Project skill
└─ Broader → Consider plugin skill
```

---

## Key Takeaway

**Skills are for capturing recurring, complex workflows.**

- Start with direct tool use
- Build skills after you've done something 2-3 times
- Choose simple skills until you need complexity
- Keep personal skills private, project skills version-controlled
- Remember: the goal is helping Claude help you better, not complexity for its own sake

---

## Next Steps

1. **Identify** your recurring workflows
2. **Test** simple skill creation with one workflow
3. **Gather** team feedback if project skill
4. **Iterate** based on actual usage
5. **Reference** `knowledge/concepts/skills-concepts.md` for implementation details

*For implementation guidance, see `knowledge/full/skills-full.md`*
