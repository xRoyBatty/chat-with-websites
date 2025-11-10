# Skills: Advanced Architecture Concepts

**Version:** 1.0 (Concepts-Only Edition)
**Last Updated:** 2025-11-09

---

## Table of Contents

1. [Skills System Overview](#skills-system-overview)
2. [Skill Types & Strategic Locations](#skill-types--strategic-locations)
3. [Skill Structure & Components](#skill-structure--components)
4. [Sub-Skills & Modular Architecture](#sub-skills--modular-architecture)
5. [Skill Interconnections](#skill-interconnections)
6. [Database Query Skills](#database-query-skills)
7. [CLAUDE.md Files](#claudemd-files)
8. [Skills vs Scripts vs Automation](#skills-vs-scripts-vs-automation)
9. [Advanced Patterns](#advanced-patterns)
10. [Best Practices](#best-practices)

---

## Skills System Overview

### What are skills?

Skills are **modular capabilities** that extend Claude's functionality through organized instruction packages. Think of them as specialized workflows that Claude can invoke when appropriate.

### Key characteristics:

**Defined by metadata**
- Skills have a primary definition file with metadata describing their purpose
- Metadata includes name, description, and optional tool restrictions

**Can include supporting resources**
- Supporting files provide templates, documentation, or utilities
- All resources live together in a skill folder for modularity

**Load at session start**
- Skills become available when a session begins
- Claude recognizes skills based on their descriptions

**Can restrict tool access**
- Some skills may limit available tools for safety
- Useful for read-only operations or security-sensitive tasks

### Three types of skills:

1. **Personal** - Individual use, private to your machine
2. **Project** - Team-shared via version control
3. **Plugin** - Distributed through plugin ecosystem

---

## Skill Types & Strategic Locations

### Personal Skills

**Concept:** Skills stored in your personal Claude directory, private to you

**Use when:**
- Personal workflows unique to you
- Machine-specific configurations
- Private tools and utilities
- Experimental features you're testing

**Strategic advantages:**
- ✅ Private to you - no sharing required
- ✅ No need to commit to version control
- ✅ Quick iteration and experimentation
- ✅ Can include environment-specific settings

**Strategic disadvantages:**
- ❌ Not shared with team
- ❌ Not portable across machines
- ❌ Lost if personal directory is deleted

**Example use cases:**
- Personal API key management workflows
- Custom database connection helpers for your setup
- Machine-specific path configurations
- Private productivity workflows

---

### Project Skills

**Concept:** Skills stored in the project repository, shared with all team members

**Use when:**
- Team-shared workflows everyone should use
- Project-specific automation
- Onboarding helpers for new team members
- Project conventions and standards

**Strategic advantages:**
- ✅ Shared via version control
- ✅ Version controlled with the project
- ✅ Team consistency in workflows
- ✅ Auto-available to all team members

**Strategic disadvantages:**
- ❌ Public in repo (no secrets!)
- ❌ Requires team buy-in and consensus
- ❌ Changes affect everyone on the team

**Example use cases:**
- Project-specific testing workflows
- Deployment automation procedures
- Code review checklists
- Database migration helpers
- API documentation generation

---

### Plugin Skills

**Concept:** Skills distributed through the plugin system to the broader community

**Use when:**
- Distributing capabilities to community
- Framework-specific helpers
- Tool integrations for popular tools
- Reusable patterns across many projects

**Strategic advantages:**
- ✅ Wide distribution potential
- ✅ Professional packaging
- ✅ Centralized updates
- ✅ Discoverable by others

**Strategic disadvantages:**
- ❌ More complex creation process
- ❌ Requires plugin infrastructure
- ❌ Less customizable by end users

---

## Skill Structure & Components

### Minimal Skill

**Concept:** At its simplest, a skill is just a folder with one definition file.

The definition file contains:
- **Metadata section** - Name, description, optional tool restrictions
- **Instructions section** - Step-by-step instructions for Claude
- **Examples section** - Concrete usage examples

### Full-Featured Skill

**Concept:** Complex skills organize supporting resources into logical subdirectories.

**Typical organization:**
- **Main definition** - Primary skill instructions
- **Human documentation** - README for team members
- **Utility resources** - Scripts, automation, helpers
- **Templates** - Starting points for common tasks
- **Documentation** - Schema, conventions, reference material
- **Examples** - Sample outputs or use cases

### Definition File Metadata

**Name requirements:**
- Descriptive and unique identifier
- Follows naming conventions (lowercase, limited characters)
- Maximum length constraints

**Description best practices:**
- Include trigger words users would naturally mention
- Be specific about when to invoke this skill
- Examples:
  - ✅ "Extract text, fill forms, merge PDFs. Use when working with PDF files"
  - ❌ "PDF helper"

**Tool restrictions concept:**
- Skills can optionally limit which tools Claude can use
- Useful for read-only operations
- Useful for security-sensitive workflows
- Omit restrictions for full tool access

---

## Sub-Skills & Modular Architecture

### Architectural Philosophy

Complex capabilities benefit from **modular decomposition** - breaking large skills into smaller, focused pieces. Three approaches exist, each with different trade-offs.

---

### Approach 1: Multiple Files Referenced in Main Skill

**Concept:** One orchestrating skill references multiple sub-skill documents.

**Structure pattern:**
- Main skill file acts as coordinator
- Separate files for each specialized capability
- Main skill directs Claude to appropriate sub-skill

**Example domains:**
- Testing suite with unit, integration, E2E sub-skills
- Code review with security, performance, style sub-skills
- Development workflow with design, implementation, testing sub-skills

**Strategic advantages:**
- ✅ Modular and organized
- ✅ Easy to update individual parts
- ✅ Clear separation of concerns
- ✅ Progressive context loading (efficiency)

**Strategic disadvantages:**
- ❌ More files to manage
- ❌ Requires disciplined organization
- ❌ Slightly more complex navigation

**Best for:** Large skills where different sub-skills are complex enough to warrant separate documentation.

---

### Approach 2: Inline Sub-Skills in Single File

**Concept:** All capabilities documented in one comprehensive file.

**Structure pattern:**
- Single skill definition file
- Multiple sections for different capabilities
- All instructions in one place

**Strategic advantages:**
- ✅ Single file - simpler structure
- ✅ All information in one place
- ✅ Easier to maintain for small skills
- ✅ No need to navigate between files

**Strategic disadvantages:**
- ❌ Large file can be unwieldy
- ❌ Loads entire skill into context at once
- ❌ Harder to navigate for very large skills
- ❌ Can't load sub-capabilities independently

**Best for:** Medium-complexity skills where all sub-capabilities are closely related and not too large.

---

### Approach 3: Separate Skills That Reference Each Other

**Concept:** Independent skills that can work alone or be orchestrated together.

**Structure pattern:**
- Each capability is a standalone skill
- Orchestrator skill coordinates between them
- Skills can be invoked independently or together

**Example:**
- Independent skills for unit testing, integration testing, E2E testing
- Orchestrator skill that determines which to use and coordinates results

**Strategic advantages:**
- ✅ Maximum modularity
- ✅ Skills can be used independently
- ✅ Easy to add new capabilities
- ✅ Clear single responsibility per skill
- ✅ Can mix and match as needed

**Strategic disadvantages:**
- ❌ More complex structure
- ❌ Skill coordination overhead
- ❌ Potential for circular references
- ❌ More skills to maintain

**Best for:** Complex domains where sub-capabilities are useful independently and may be reused across contexts.

---

### Decision Framework: Which Approach?

**Use Approach 1 (Referenced Files) when:**
- Skill has 3-5 major sub-capabilities
- Sub-capabilities are complex but always used together
- You want progressive context loading
- Organization is more important than simplicity

**Use Approach 2 (Single File) when:**
- Skill has 2-3 simple sub-capabilities
- Total documentation is < 500 lines
- Sub-capabilities are tightly coupled
- Simplicity is more important than modularity

**Use Approach 3 (Separate Skills) when:**
- Sub-capabilities are useful independently
- Different teams might own different capabilities
- Skills might be reused across projects
- Maximum flexibility is required

---

## Skill Interconnections

### Architectural Patterns for Skill Relationships

Skills can connect in multiple patterns, each serving different workflow needs.

---

### Pattern 1: Orchestrator Skill

**Concept:** One main skill delegates to specialized skills based on needs.

**Visual pattern:**
```
orchestrator-skill
    ↓
    ├─→ specialized-skill-1
    ├─→ specialized-skill-2
    └─→ specialized-skill-3
```

**How it works:**
- Main skill analyzes the task
- Delegates to appropriate specialist
- Coordinates results if needed

**Best for:**
- Complex workflows with distinct phases
- When sub-skills are useful independently
- When users need both guided and expert modes
- Providing different expertise levels

**Example domains:**
- Testing orchestrator → unit/integration/E2E specialists
- Code review orchestrator → security/performance/style specialists
- Research orchestrator → web/academic/internal specialists

---

### Pattern 2: Pipeline Skills

**Concept:** Skills form a sequential workflow, each preparing inputs for the next.

**Visual pattern:**
```
skill-1 → skill-2 → skill-3 → skill-4
```

**How it works:**
- Each skill completes a phase
- Output of one becomes input to next
- Ensures proper order of operations

**Best for:**
- Structured development processes
- Ensuring dependencies are met
- Onboarding workflows
- Quality gates that must pass sequentially

**Example domains:**
- Design → Implementation → Testing → Deployment
- Research → Analysis → Documentation → Publishing
- Planning → Execution → Review → Retrospective

---

### Pattern 3: Complementary Skills

**Concept:** Skills that work together but aren't sequential - they provide different perspectives on the same artifact.

**Visual pattern:**
```
        main-skill
             ↙    ↘
    aspect-skill-1  aspect-skill-2
```

**How it works:**
- Main skill coordinates analysis
- Invokes complementary skills as needed
- Combines insights from multiple perspectives

**Best for:**
- Multi-faceted analysis
- Optional deep-dives based on context
- Comprehensive reviews
- Different expertise domains

**Example domains:**
- Code review → (security analysis + performance analysis)
- Document review → (accuracy check + style check)
- Design review → (UX analysis + technical feasibility)

---

### Pattern 4: Skill Composition

**Concept:** Building complex capabilities from reusable simple ones.

**Visual pattern:**
```
complex-skill
    ↓
    ├─→ utility-skill-1
    ├─→ utility-skill-2
    ├─→ utility-skill-3
    └─→ utility-skill-4
```

**How it works:**
- Complex skill orchestrates multiple utilities
- Each utility is reusable elsewhere
- Clear separation of concerns

**Best for:**
- Critical operations requiring multiple steps
- Each step is reusable in other contexts
- Clear separation of concerns
- Building libraries of reusable capabilities

**Example domains:**
- Database migration → (backup + validation + execution + rollback)
- Deployment → (build + test + upload + verify)
- Release → (version + changelog + tag + publish)

---

## Database Query Skills

### Conceptual Purpose

Database query skills encapsulate:
- **Safe query patterns** - Templates that prevent common mistakes
- **Connection management** - Standardized ways to connect
- **Safety procedures** - Checks before destructive operations
- **Performance guidance** - Best practices for efficient queries

### Architectural Components

**Connection configuration**
- Standardized connection string locations
- Environment-specific settings
- Security considerations

**Query templates**
- Starting points for common operations
- Safe patterns built-in
- Comments guiding customization

**Safety workflows**
- Pre-flight checks for destructive operations
- Backup procedures
- Rollback plans
- Verification steps

**Performance tools**
- Query explanation and analysis
- Index suggestions
- Optimization guidance

### Multi-Database Strategy

**Approach 1: Database-Specific Skills**
- Separate skill for SQL, MongoDB, etc.
- Each optimized for its database type
- Pros: Specialized patterns, no confusion
- Cons: More skills to maintain

**Approach 2: Unified Database Skill**
- One skill handles multiple databases
- Detects database type and adapts
- Pros: Single interface, less duplication
- Cons: More complex, may not leverage database-specific features

**Approach 3: Orchestrator + Specialists**
- Orchestrator detects database type
- Delegates to specialist skill
- Pros: Best of both worlds
- Cons: More complex architecture

### Safety Philosophy

**Critical operations require multiple safeguards:**

1. **Backup before destructive operations**
2. **Test queries with SELECT first**
3. **Verify affected row count**
4. **Use transactions where possible**
5. **Have rollback plan ready**

**Example workflow for DELETE:**
1. Invoke backup skill
2. Run SELECT with same WHERE clause
3. Verify count matches expectation
4. Execute DELETE in transaction
5. Verify result
6. Commit or rollback

---

## CLAUDE.md Files

### Conceptual Purpose

CLAUDE.md provides **project context** to Claude at session start. Think of it as the "orientation document" that helps Claude understand your project quickly.

### What to Include

**Project overview:**
- High-level purpose
- Key technologies
- Architecture patterns

**Coding conventions:**
- Style guidelines
- Naming patterns
- Project-specific standards

**Common operations:**
- Frequent commands
- Development workflows
- Testing procedures

**Navigation aids:**
- Important file locations
- Where different types of code live
- Documentation locations

### What NOT to Include

- ❌ Detailed API documentation (link to it instead)
- ❌ Complete file listings (Claude can explore)
- ❌ Boilerplate code examples
- ❌ Sensitive information (never!)

### Strategic Length

- **Target:** 1-2 pages per file
- **Principle:** Progressive disclosure - overview plus pointers
- **Pattern:** "For X, see file Y"

---

### Single CLAUDE.md vs Multiple

#### Approach 1: Single Root CLAUDE.md

**Concept:** All project context in one central document at repository root.

**Strategic advantages:**
- ✅ Simple structure - one place to look
- ✅ All context in one file
- ✅ Easy to maintain
- ✅ Clear single source of truth

**Strategic disadvantages:**
- ❌ Can become very large
- ❌ Not modular
- ❌ Loads all context every session (even if not needed)
- ❌ Hard to navigate when large

**Best for:**
- Small to medium projects
- Single-team projects
- Projects with unified architecture

---

#### Approach 2: Multiple CLAUDE.md Files

**Concept:** Hierarchical CLAUDE.md files - main overview with sub-project specific contexts.

**Structure pattern:**
- Root CLAUDE.md provides overview + references
- Sub-directory CLAUDE.md files for specialized contexts
- Each team/module can own their context

**Strategic advantages:**
- ✅ Modular context organization
- ✅ Focused documentation per area
- ✅ Better for monorepos
- ✅ Team members can own their sections
- ✅ Only load what's needed

**Strategic disadvantages:**
- ❌ More complex structure
- ❌ Need to navigate references
- ❌ Potential for outdated cross-references
- ❌ Requires discipline to maintain

**Best for:**
- Large projects or monorepos
- Multi-team projects
- Projects with distinct sub-systems
- When different domains need different context

---

### Progressive Context Loading

**Concept:** Reference detailed documentation rather than including it inline.

**Pattern:**
- CLAUDE.md provides overview and pointers
- Detailed docs live in dedicated files
- Claude reads only what's needed for current task

**Benefits:**
- Efficient context usage
- Up-to-date references (single source of truth)
- Flexibility to deep-dive when needed
- Keeps CLAUDE.md concise

**Example pattern:**
- Architecture overview in CLAUDE.md → Links to detailed architecture doc
- API summary in CLAUDE.md → Links to full API reference
- Common commands in CLAUDE.md → Links to comprehensive runbook

---

## Skills vs Scripts vs Automation

### Philosophical Spectrum

Skills can range from **pure AI inference** (no automation) to **pure automation** (minimal AI). Each point on the spectrum has different trade-offs.

---

### Pure AI Inference (Skills)

**Concept:** Skill provides detailed instructions; Claude executes using judgment.

**Characteristics:**
- No scripts or automation
- Claude reads files, analyzes, decides
- Adapts to specific situation
- Provides nuanced feedback

**Strategic advantages:**
- ✅ Flexible - AI adapts to situation
- ✅ Handles edge cases well
- ✅ Can provide nuanced, contextual feedback
- ✅ No script maintenance burden
- ✅ Works for novel situations

**Strategic disadvantages:**
- ❌ Slower (AI reasoning time)
- ❌ Less consistent across runs
- ❌ Higher token usage
- ❌ Requires AI judgment (may vary)

**Best for:**
- Complex analysis requiring judgment
- Situations with many variables
- Tasks requiring creativity
- When consistency isn't critical
- Novel or changing situations

**Example domains:**
- Code review (architecture, design decisions)
- Refactoring (requires understanding)
- Bug diagnosis (investigative)
- Documentation writing (creative)

---

### Hybrid (Skills + Scripts)

**Concept:** Skill orchestrates; scripts handle automatable parts; AI handles judgment.

**Characteristics:**
- Scripts do repetitive/mechanical work
- AI analyzes results and makes decisions
- Best of both worlds

**Strategic advantages:**
- ✅ Fast for automatable parts
- ✅ Consistent automated checks
- ✅ AI focuses on complex judgment
- ✅ Efficient token usage
- ✅ Combines speed and flexibility

**Strategic disadvantages:**
- ❌ Requires script maintenance
- ❌ Scripts may break with environment changes
- ❌ More complex setup
- ❌ Need to maintain both skill instructions and scripts

**Best for:**
- Well-defined checks + complex analysis
- Performance-critical operations
- Repeated tasks with consistent parts
- When you want speed AND flexibility

**Example domains:**
- Code review (linters automate style, AI reviews architecture)
- Testing (scripts run tests, AI analyzes failures)
- Security scanning (tools find issues, AI prioritizes/explains)
- Performance analysis (tools gather metrics, AI interprets)

---

### Pure Automation (Scripts Only)

**Concept:** Minimal AI inference; mostly automated scripts with simple orchestration.

**Characteristics:**
- Scripts do nearly everything
- AI just invokes scripts in right order
- Minimal decision-making needed

**Strategic advantages:**
- ✅ Extremely fast execution
- ✅ Perfectly consistent
- ✅ Low token usage
- ✅ No AI uncertainty
- ✅ Predictable outcomes

**Strategic disadvantages:**
- ❌ Inflexible - can't adapt to changes
- ❌ Requires comprehensive scripts
- ❌ High maintenance burden
- ❌ Can't handle exceptions well
- ❌ Brittle to environment changes

**Best for:**
- Well-defined workflows that rarely change
- Critical operations requiring perfect consistency
- Performance-sensitive operations
- Simple, repetitive tasks
- When flexibility isn't needed

**Example domains:**
- Deployment (consistent process)
- Database migrations (too risky for improvisation)
- Build processes (mechanical)
- Backup procedures (must be consistent)

---

### Decision Matrix

**Choose Pure AI when:**
- Task requires judgment and context understanding
- Situations vary significantly
- Creativity or nuance needed
- Scripting would be more complex than the task

**Choose Hybrid when:**
- Part of task is mechanical, part requires judgment
- You want speed AND quality
- Consistent checks + contextual analysis
- Best overall value

**Choose Pure Automation when:**
- Task is perfectly defined and consistent
- Speed and consistency are critical
- No judgment needed
- Too risky to allow variation

---

## Advanced Patterns

### Pattern: Skill State Management

**Problem:** Skills need to remember state across invocations (what was done last time, progress tracking, etc.)

**Solution Concept:** Use persistent files to track state.

**How it works:**
- Skill defines a state file location
- Before executing, skill reads state file
- After executing, skill updates state file
- State persists across sessions

**Benefits:**
- Incremental workflows (don't repeat completed work)
- Progress tracking over time
- Avoid redundant operations
- Historical context

**Example use cases:**
- Testing skill tracks last test run, only re-runs changed tests
- Deployment skill tracks last deployed version
- Research skill tracks already-explored sources

---

### Pattern: Skill Composition with Context Passing

**Problem:** Need to pass data between skills in a workflow.

**Solution Concept:** Use intermediate artifact files.

**How it works:**
- Each skill in the pipeline reads inputs from designated files
- Each skill writes outputs to designated files
- Next skill reads those outputs as inputs
- Creates clear data flow

**Benefits:**
- Clear data flow and dependencies
- Resumable workflows (can restart at any stage)
- Auditable decisions (artifacts persist)
- Debugging easier (inspect intermediate outputs)

**Example workflow:**
- Design skill writes design decisions to artifact file
- Implementation skill reads design artifact, writes implementation notes
- Testing skill reads implementation notes, writes test results
- Each stage builds on previous

---

### Pattern: Skill Versioning

**Problem:** Skills evolve; need backward compatibility or migration paths.

**Solution Concept:** Version your skills and provide migration guidance.

**How it works:**
- Include version in skill metadata or documentation
- Document breaking changes clearly
- Provide migration guides for major versions
- Consider compatibility layers for gradual transitions

**Benefits:**
- Users can understand what changed
- Smoother transitions between versions
- Clear communication of breaking changes
- Historical context for why changes were made

---

### Pattern: Skill Testing

**Problem:** Need to verify skill works correctly before deploying to team.

**Solution Concept:** Include self-tests with the skill.

**How it works:**
- Skill includes test utilities or validation scripts
- Can be run before first use or after changes
- Verifies skill setup is correct
- Catches configuration issues early

**Benefits:**
- Confidence skill will work
- Catches environment issues
- Documentation through test cases
- Easier onboarding (run tests to verify setup)

---

## Best Practices

### Skill Design Principles

**1. Single Responsibility**
- One skill = one well-defined capability
- Split complex skills into orchestrator + specialists
- Each skill should have a clear, focused purpose

**2. Clear Triggers**
- Description should include user-facing language
- Make it obvious when to invoke this skill
- Include trigger words users would naturally say

**3. Progressive Disclosure**
- Start with simple overview
- Reference detailed docs as needed
- Don't overwhelm with everything upfront
- Guide users through complexity gradually

**4. Examples Over Explanations**
- Show concrete examples
- Provide templates as starting points
- Demonstrate patterns rather than describing abstractly

**5. Safe Defaults**
- Default to safe, non-destructive operations
- Require explicit confirmation for destructive actions
- Build safety checks into workflows
- Make it hard to do dangerous things accidentally

---

### Organizational Principles

**1. Flat When Possible**
- Don't create nested structure unless needed
- Simpler organization is better
- Only add complexity when it adds value

**2. Consistent Structure**
- Use standard subdirectory names across skills
- Makes navigation predictable
- Team members know where to look

**3. Self-Documenting**
- Use clear, descriptive file names
- Separate human docs from AI instructions
- Include context in file names and locations

---

### Maintenance Principles

**1. Version Control**
- Commit project skills to version control
- Tag significant versions
- Document breaking changes in commits

**2. Living Documentation**
- Update skills when they change
- Document breaking changes clearly
- Provide migration guides for major changes
- Keep documentation in sync with implementation

**3. Regular Testing**
- Test skills after making changes
- Especially test any automation/scripts
- Verify on fresh environment periodically

**4. Continuous Cleanup**
- Remove unused skills
- Archive deprecated skills (don't delete)
- Keep active skill set lean
- Reduce cognitive overhead

---

### Collaboration Principles

**1. Team Consensus**
- Project skills require team buy-in
- Discuss before adding to shared repo
- Consider impact on all team members

**2. Clear Ownership**
- Document who maintains each skill
- Assign responsibility for updates
- Make it clear who to ask about issues

**3. Discoverable**
- Maintain index or catalog of skills
- Document when to use each skill
- Help team members find right tool

---

*See also: CLAUDE_CODE_COMPLETE_MANUAL.md, ASYNC_WORKFLOWS.md*

---

*End of Skills Advanced Concepts Guide. Last updated: 2025-11-09*
