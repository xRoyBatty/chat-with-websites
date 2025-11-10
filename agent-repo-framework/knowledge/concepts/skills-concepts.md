# Skills: Conceptual Overview

**Version:** 1.0
**Last Updated:** 2025-11-09

---

## Table of Contents

1. [Skills System Overview](#skills-system-overview)
2. [Skill Types & Locations](#skill-types--locations)
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

### What are Skills?

Skills are modular capabilities that extend Claude's functionality through organized folders containing instructions, scripts, and resources.

**Key Characteristics:**
- Defined by a skill definition file with metadata
- Can include supporting files (scripts, docs, templates)
- Load at session start to extend capabilities
- Can restrict tool access for security

**Three Types:**
1. **Personal Skills** - Individual use, stored in user directory
2. **Project Skills** - Team-shared via git in project directory
3. **Plugin Skills** - Distributed with Claude Code plugins

---

## Skill Types & Locations

### Personal Skills

**Purpose:** Individual workflows and configurations

**Use When:**
- Personal workflows and preferences
- Machine-specific configurations
- Private tools and scripts
- Experimental features

**Advantages:**
- Private to individual user
- No need to commit to version control
- Quick iteration and testing
- Can include personal credentials (with caution)

**Limitations:**
- Not shared with team
- Not portable across machines
- Lost if user directory is deleted

**Example Use Cases:**
- Personal API key management
- Custom database connection helpers
- Machine-specific path configurations
- Private productivity workflows

---

### Project Skills

**Purpose:** Team-shared project workflows

**Use When:**
- Team-shared workflows
- Project-specific automation
- Onboarding helpers
- Enforcing project conventions

**Advantages:**
- Shared via version control
- Version controlled for team consistency
- Automatically available to all team members

**Limitations:**
- Public in repository (no secrets!)
- Requires team coordination
- Changes affect entire team

**Example Use Cases:**
- Project-specific testing workflows
- Deployment automation
- Code review checklists
- Database migration helpers
- API documentation generation

---

### Plugin Skills

**Purpose:** Community distribution

**Use When:**
- Distributing to broader community
- Framework-specific helpers
- Tool integrations
- Reusable across multiple projects

**Advantages:**
- Wide distribution potential
- Professional packaging
- Centralized updates
- Discoverable by users

**Limitations:**
- More complex to create
- Requires plugin infrastructure
- Less customizable

---

## Skill Structure & Components

### Minimal Skill Structure

The simplest skill requires only:
- A skill definition file with metadata and instructions

### Full-Featured Skill Structure

A comprehensive skill can include:
- **Main definition file** - Instructions and metadata
- **Documentation** - For human readers
- **Scripts directory** - Executable automation scripts
- **Templates directory** - Reusable file templates
- **Documentation directory** - Schema, conventions, guides
- **Examples directory** - Concrete usage examples

### Skill Metadata

Skills use metadata to define:
- **Name** - Unique identifier (lowercase, hyphens, max 64 characters)
- **Description** - Trigger-rich description of when to use
- **Allowed Tools** (optional) - Restrict which tools can be used

**Description Best Practices:**
- Include trigger words users would mention
- Be specific about when to use
- Good: "Extract text, fill forms, merge PDFs. Use when working with PDF files"
- Bad: "PDF helper"

**Tool Restrictions:**
- Limits Claude to specific tools within the skill
- Useful for read-only skills
- Useful for security-sensitive operations
- Omit for full tool access

---

## Sub-Skills & Modular Architecture

Skills can be organized in three architectural patterns:

### Approach 1: Multiple Files Referenced in Main Skill

**Structure Concept:**
- Main skill file acts as orchestrator
- Separate files for each specialized capability
- Main skill references sub-skill files

**Advantages:**
- Modular and organized
- Easy to update individual parts
- Clear separation of concerns
- Progressive loading (context efficient)

**Limitations:**
- More files to manage
- Requires good organization
- Slightly more complex

**Best For:** Large skills with distinct specialized capabilities

---

### Approach 2: Inline Sub-Skills in Single File

**Structure Concept:**
- Single skill file contains all instructions
- Organized into sections for different capabilities

**Advantages:**
- Single file - simpler structure
- All information in one place
- Easier to maintain for small skills

**Limitations:**
- Large file can become unwieldy
- Loads entire skill into context at once
- Harder to navigate for large skills

**Best For:** Smaller skills with related capabilities

---

### Approach 3: Separate Skills That Reference Each Other

**Structure Concept:**
- Multiple independent skills
- Skills can invoke or reference each other
- Orchestrator skill coordinates specialized skills

**Advantages:**
- Maximum modularity
- Skills can be used independently
- Easy to add new capabilities
- Clear single responsibility per skill

**Limitations:**
- More complex structure
- Skill coordination overhead
- Potential for circular references

**Best For:** Complex systems where capabilities are useful independently

---

## Skill Interconnections

### Pattern 1: Orchestrator Skill

**Concept:** One main skill delegates to specialized skills

```
testing-orchestrator
    ↓
    ├─→ unit-testing
    ├─→ integration-testing
    └─→ e2e-testing
```

**Best For:**
- Complex workflows with distinct phases
- When sub-skills are useful independently
- When team needs both guided and expert modes

---

### Pattern 2: Pipeline Skills

**Concept:** Skills form a sequential workflow

```
design-skill → implementation-skill → testing-skill → deployment-skill
```

**How It Works:**
- Each skill defines prerequisites
- Skills output artifacts for next skill
- Clear progression through workflow stages

**Best For:**
- Structured development processes
- Ensuring proper order of operations
- Onboarding workflows

---

### Pattern 3: Complementary Skills

**Concept:** Skills that work together but aren't sequential

```
        code-review-skill
             ↙    ↘
    security-skill  performance-skill
```

**How It Works:**
- Main skill identifies when to use complementary skills
- Complementary skills provide specialized analysis
- Results combined for comprehensive output

**Best For:**
- Multi-faceted analysis
- Optional deep-dives based on context
- Comprehensive reviews

---

### Pattern 4: Skill Composition

**Concept:** Building complex skills from simple, reusable components

```
database-migration-skill
    ↓
    ├─→ backup-skill
    ├─→ schema-validation-skill
    ├─→ migration-execution-skill
    └─→ rollback-skill
```

**Best For:**
- Critical operations requiring multiple steps
- Each step is reusable in other contexts
- Clear separation of concerns

---

## Database Query Skills

### Concept Overview

Database query skills provide structured approaches to database interactions with:
- Connection configuration management
- Query templates for common operations
- Safety checks and validation
- Performance analysis guidance

### Typical Components

**Query Workflow:**
1. Read schema documentation
2. Construct query using templates
3. Execute query safely
4. Analyze performance if needed

**Query Type Patterns:**
- **Read queries** - Guidelines for efficient data retrieval
- **Insert queries** - Validation and transaction patterns
- **Update queries** - Safety checks and testing before execution
- **Delete queries** - Extra caution with backup and verification

**Safety Mechanisms:**
- Backup before destructive operations
- Test queries with limited scope first
- Verify affected row counts
- Use transactions
- Maintain rollback plans

### Multi-Database Support

Skills can be created for different database types:
- **SQL databases** - Template-based query construction
- **NoSQL databases** - Document query patterns
- **Graph databases** - Relationship traversal patterns

Each provides database-specific best practices and patterns.

---

## CLAUDE.md Files

### What is CLAUDE.md?

A special file that provides context to Claude about your project at session start.

**Purpose:**
- Project overview and architecture
- Coding conventions and standards
- Common commands and workflows
- Important context and gotchas
- Pointers to detailed documentation

### Architecture Approaches

#### Single Root CLAUDE.md

**Concept:** All project context in one central file

**Advantages:**
- Simple structure
- All context in one place
- Easy to maintain

**Limitations:**
- Can become very large
- Not modular
- Loads all context every time

**Best For:** Smaller projects with unified context

---

#### Multiple CLAUDE.md Files

**Concept:** Hierarchical context files in subdirectories

Structure concept:
- Root file provides overview and references
- Subdirectory files provide focused context
- Progressive context loading

**Advantages:**
- Modular context organization
- Focused documentation per area
- Better for monorepos and large projects
- Team members can own their sections

**Limitations:**
- More complex structure
- Need to navigate references
- Potential for outdated cross-references

**Best For:** Large projects, monorepos, multi-team projects

---

### CLAUDE.md Best Practices

**Include:**
- Project architecture overview
- Key conventions and patterns
- Common commands
- Navigation guide (where to find things)
- Important gotchas and warnings

**Avoid:**
- Detailed API documentation (link to it instead)
- Complete file listings
- Boilerplate code examples
- Sensitive information

**Keep It:**
- Concise (1-2 pages max per file)
- Up to date with major changes
- Actionable (focus on what Claude needs to know)

### Progressive Context Loading

**Concept:** Reference detailed documentation rather than embedding it

CLAUDE.md provides:
- Overview and high-level concepts
- Pointers to detailed documentation

When Claude needs details:
1. Reads CLAUDE.md (gets overview + pointers)
2. Reads referenced docs as needed
3. Only loads what's necessary for current task

This approach optimizes context usage and reduces overhead.

---

## Skills vs Scripts vs Automation

### Pure AI Inference (Skills Only)

**Concept:** Skill provides detailed instructions without automation scripts

**How It Works:**
- Skill contains step-by-step instructions
- Claude uses judgment and reasoning
- Flexible adaptation to situations

**Advantages:**
- Flexible (AI adapts to situation)
- Handles edge cases well
- Can provide nuanced feedback
- No script maintenance required

**Limitations:**
- Slower (AI reasoning time)
- Less consistent results
- Higher token usage
- Requires AI judgment

**Best For:**
- Complex analysis requiring judgment
- Situations with many variables
- Tasks requiring creativity
- When consistency isn't critical

**Examples:** Code review, refactoring, bug diagnosis, documentation writing

---

### Hybrid (Skills + Scripts)

**Concept:** Skill orchestrates, scripts handle deterministic operations

**How It Works:**
- Scripts perform well-defined, repeatable tasks
- AI handles complex judgment and analysis
- Skill instructions coordinate both

**Advantages:**
- Fast for automatable parts
- Consistent automated checks
- AI focuses on complex judgment
- Best of both worlds

**Limitations:**
- Requires script maintenance
- Scripts may break with environment changes
- More initial setup required

**Best For:**
- Well-defined checks combined with complex analysis
- Performance-critical operations
- Repeated tasks with consistent components

**Examples:** Code review (linting + architecture analysis), testing (running tests + analyzing failures), security scanning (tools + prioritization)

---

### Pure Automation (Scripts Only)

**Concept:** Minimal AI inference, primarily script execution

**How It Works:**
- Skill primarily triggers automated scripts
- Minimal AI decision-making
- Deterministic, repeatable outcomes

**Advantages:**
- Extremely fast execution
- Perfectly consistent results
- Low token usage
- No AI uncertainty

**Limitations:**
- Inflexible (can't adapt to exceptions)
- Requires comprehensive script coverage
- High maintenance burden
- Can't handle unexpected situations well

**Best For:**
- Well-defined workflows with no variations
- Critical operations requiring perfect consistency
- Performance-sensitive operations
- Simple, repetitive tasks

**Examples:** Deployment, database migrations, build processes

---

### Decision Framework

Consider these factors when choosing an approach:

**Task Complexity:**
- Simple, repeatable → Pure automation
- Mixed deterministic + judgment → Hybrid
- Complex, variable → Pure AI

**Consistency Requirements:**
- Must be identical every time → Pure automation
- Flexible but guided → Hybrid
- Adaptive to context → Pure AI

**Performance Sensitivity:**
- Speed critical → Pure automation or hybrid
- Speed less important → Any approach

**Maintenance Capacity:**
- Limited maintenance → Pure AI
- Can maintain scripts → Hybrid or pure automation

---

## Advanced Patterns

### Pattern: Skill State Management

**Problem:** Skills need to remember information across invocations

**Solution:** Use files in project to store state

**How It Works:**
- State file stores previous run information
- Skill reads state before executing
- Skill updates state after executing
- Enables incremental work and progress tracking

**Benefits:**
- Avoid redundant work
- Track progress over time
- Enable incremental operations
- Resume interrupted workflows

**Use Cases:** Incremental testing, deployment tracking, migration progress

---

### Pattern: Skill Composition with Context Passing

**Problem:** Need to pass data between skills in a workflow

**Solution:** Use intermediate artifact files

**How It Works:**
- Each skill outputs artifacts to known locations
- Subsequent skills read artifacts as input
- Clear data flow through workflow stages

**Benefits:**
- Clear data flow between skills
- Resumable workflows (can pause/resume)
- Auditable decision history
- Independent skill development

**Use Cases:** Design → Implementation → Testing workflows, multi-stage analysis

---

### Pattern: Skill Versioning

**Problem:** Skills evolve, need to manage breaking changes

**Solution:** Version skills and provide migration guides

**How It Works:**
- Skill metadata includes version number
- Documentation explains breaking changes
- Migration guides help users upgrade
- Deprecated features documented

**Benefits:**
- Smooth transitions for users
- Clear communication of changes
- Backward compatibility guidance

---

### Pattern: Skill Testing

**Problem:** Need to verify skill works correctly before use

**Solution:** Include test scripts and verification procedures

**How It Works:**
- Test scripts validate skill functionality
- Self-test instructions in skill documentation
- Verification before first use

**Benefits:**
- Confidence in skill reliability
- Early detection of environment issues
- Documentation of expected behavior

---

## Best Practices

### Skill Design Principles

1. **Single Responsibility**
   - One skill = one capability
   - Split complex skills into orchestrator + specialists
   - Clear, focused purpose

2. **Clear Triggers**
   - Description should include user-facing terms
   - Make it obvious when to use this skill
   - Help Claude decide when to invoke

3. **Progressive Disclosure**
   - Start simple, reference details
   - Don't overwhelm with everything upfront
   - Guide users from overview to specifics

4. **Examples Over Explanations**
   - Show concrete examples
   - Provide templates
   - Demonstrate rather than describe

5. **Safe Defaults**
   - Default to safe operations
   - Require explicit confirmation for destructive actions
   - Fail safely and explicitly

---

### Organization Principles

1. **Flat When Possible**
   - Don't create nested directories unless needed
   - Simpler is better
   - Easy navigation

2. **Consistent Structure**
   - Predictable organization across skills
   - Standard directory names for standard purposes
   - Team-wide consistency

3. **Self-Documenting**
   - Separate human documentation from skill instructions
   - Clear, descriptive file names
   - Obvious purpose from structure

---

### Maintenance Practices

1. **Version Control**
   - Commit project skills to version control
   - Tag versions for breaking changes
   - Track evolution over time

2. **Documentation**
   - Update when skill changes
   - Document breaking changes clearly
   - Provide migration guides for upgrades

3. **Testing**
   - Test skills after changes
   - Especially test automation scripts
   - Verify before deploying to team

4. **Cleanup**
   - Remove unused skills
   - Archive deprecated skills
   - Keep skill set lean and relevant

---

**Key Takeaway:** Skills extend Claude's capabilities through modular, organized instructions and automation. Choose the right skill architecture, automation level, and organizational pattern for your specific needs. Maintain skills as living documentation that evolves with your project.

---

*End of Skills Conceptual Overview. Last updated: 2025-11-09*
