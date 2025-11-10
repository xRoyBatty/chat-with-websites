# Plan Generation

This directory helps you design custom Claude Code repositories tailored to your specific needs.

## Purpose

Plan generation is the **design phase** of building a custom repository. After understanding your requirements through the discovery process (`../user-engagement/`), you use planning tools to architect how your repository will be organized and function.

**When to use plan generation:**
- You've completed the discovery process (user-engagement/)
- You need custom architecture beyond the provided templates
- You want to document your repository design before implementation
- You're building multi-agent systems or complex workflows

## Quick Start

### 1. Use Templates (Recommended for Most Cases)

Templates provide pre-built architecture patterns you customize for your needs.

**When to use templates:**
- You have a clear problem that matches a template category
- You want to implement quickly with proven patterns
- You need multi-agent coordination, async workflows, or task queues
- You prefer working from structure rather than blank slate

**How to use templates:**

1. **Browse** `plan-templates/` for available architecture patterns
2. **Select** the template that best matches your needs
3. **Copy** the template content
4. **Fill in placeholders** with your specifics:
   - `[YOUR_PROJECT_NAME]` → Your actual project name
   - `[DESCRIPTION]` → What your project does
   - `[AGENT_TYPE]` → coordinator, worker, standalone, etc.
   - `[FEATURE_NAME]` → Your specific features
   - `[CONTEXT_FILE]` → Paths to your context files

5. **Adapt** the architecture to your exact requirements

### 2. Create Custom Plans

For unique needs not covered by templates.

**When to create custom:**
- Your use case is novel or highly specialized
- You need to combine multiple patterns
- You have specific constraints or requirements
- Templates feel too different from your vision

**How to create custom:**

1. **Define objectives** - What will this repository accomplish?
2. **List features** - What capabilities are needed?
3. **Choose patterns** - Review examples to understand what patterns exist
4. **Document architecture** - How will components interact?
5. **Plan file structure** - How will files be organized?
6. **Identify workflows** - What processes will run? How will they coordinate?

## Reference Examples

Examples show real implementations and reference structures.

**How to use examples:**

- **For structure** - See how directories are organized
- **For features** - Understand what capabilities are implemented
- **For patterns** - Learn multi-agent coordination, async workflows, etc.
- **For naming** - See file naming conventions and documentation style
- **For inspiration** - Combine patterns from multiple examples

Examples are **read-only references**. Study them, understand the approach, then build your own plan.

## Plan Components

A complete plan typically includes:

```
Your Plan:
├── Project name and description
├── Repository purpose and goals
├── User type (personal, team, multi-agent, etc.)
├── Key features required
├── Agent types and roles (if multi-agent)
├── File structure and organization
├── Communication patterns (how agents coordinate)
├── Data persistence strategy (how state is stored)
├── Workflow diagrams (if complex)
└── Implementation phases (if large project)
```

## Tips for Effective Planning

### 1. Start with Examples
Don't start from scratch. Review examples first to understand what's possible and what patterns are proven.

### 2. Define Clear Boundaries
What will your repository do? What will it NOT do? Clear scope prevents feature creep.

### 3. Document Assumptions
Write down assumptions about how components will interact. This becomes critical for multi-agent systems where workers have no conversation context.

### 4. Plan for File-Based Communication
In Claude Code systems (especially multi-agent), all persistent communication happens through files. Design your file structure and update mechanisms upfront:
- Task queues (for coordinating work)
- Status files (for tracking progress)
- Context files (for sharing information)
- Memory files (for persistent state between sessions)

### 5. Consider Scalability
- Can one file handle all tasks, or do you need directories?
- How large will queues or logs grow?
- Will you need archiving mechanisms?

### 6. Test Your Architecture
Before implementing, validate your plan mentally:
- Can all agents find the information they need?
- What happens if an agent crashes mid-task?
- How will you monitor progress?
- Can you run two agents simultaneously?

### 7. Use Checklists for Validation
Ensure your plan addresses:
- [ ] Clear project objectives
- [ ] Defined agent types/roles (if applicable)
- [ ] File structure designed
- [ ] Communication patterns documented
- [ ] Data persistence strategy planned
- [ ] Edge cases considered (agent crashes, race conditions, etc.)

## Next Steps

1. **Review examples/** to see reference implementations
2. **Select or adapt a template** from plan-templates/
3. **Document your plan** - Write it as a markdown file for your project
4. **Validate** - Check against the checklist above
5. **Implement** - Use `../knowledge/full/` guides for syntax and patterns
6. **Test** - Run incrementally, validate each component

## Related Resources

- **Discovery** - `../user-engagement/` (clarify needs before planning)
- **Knowledge Base** - `../knowledge/` (reference when implementing)
- **Ready Templates** - `../templates/` (deploy pre-built solutions)
- **Implementation Tools** - `../utilities/` (helper scripts)

## Workflow

The full custom repository process:

```
Discovery (user-engagement/)
     ↓
Planning (plan-generation/) ← You are here
     ↓
Implementation (knowledge/full/ + templates/)
     ↓
Testing & Iteration
     ↓
Deployment
```

---

**Remember:** A good plan is half the implementation. Take time to design thoroughly, and your implementation will be cleaner and faster.
