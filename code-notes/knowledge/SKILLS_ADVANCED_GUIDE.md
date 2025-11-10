# Skills: Advanced Architecture Guide

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

**What are skills?**
Skills are modular capabilities that extend Claude's functionality through organized folders containing instructions, scripts, and resources.

**Key characteristics:**
- Defined by `SKILL.md` file with YAML frontmatter
- Can include supporting files (scripts, docs, templates)
- Load at session start
- Can restrict tool access via `allowed-tools`

**Three types:**
1. **Personal** (`~/.claude/skills/`) - Individual use
2. **Project** (`.claude/skills/`) - Team-shared via git
3. **Plugin** - Distributed with Claude Code plugins

---

## Skill Types & Locations

### Personal Skills
**Location:** `~/.claude/skills/skill-name/`

**Use when:**
- Personal workflows
- Machine-specific configurations
- Private tools and scripts
- Experimental features

**Pros:**
- ✅ Private to you
- ✅ No need to commit to git
- ✅ Quick iteration
- ✅ Can include secrets (carefully!)

**Cons:**
- ❌ Not shared with team
- ❌ Not portable across machines
- ❌ Lost if ~/.claude deleted

**Example use cases:**
- Personal API key management
- Custom database connection helpers
- Machine-specific path configurations
- Private productivity workflows

---

### Project Skills
**Location:** `.claude/skills/skill-name/`

**Use when:**
- Team-shared workflows
- Project-specific automation
- Onboarding helpers
- Project conventions

**Pros:**
- ✅ Shared via git
- ✅ Version controlled
- ✅ Team consistency
- ✅ Auto-available to all team members

**Cons:**
- ❌ Public in repo (no secrets!)
- ❌ Requires team buy-in
- ❌ Changes affect everyone

**Example use cases:**
- Project-specific testing workflows
- Deployment automation
- Code review checklists
- Database migration helpers
- API documentation generation

---

### Plugin Skills
**Location:** Managed by plugin system

**Use when:**
- Distributing to community
- Framework-specific helpers
- Tool integrations
- Reusable across projects

**Pros:**
- ✅ Wide distribution
- ✅ Professional packaging
- ✅ Centralized updates
- ✅ Discoverable

**Cons:**
- ❌ More complex to create
- ❌ Requires plugin infrastructure
- ❌ Less customizable

---

## Skill Structure & Components

### Minimal Skill
```
~/.claude/skills/my-skill/
└── SKILL.md
```

**SKILL.md:**
```yaml
---
name: my-skill
description: What it does and when to use it
---

# My Skill

## Instructions
Step-by-step instructions for Claude to follow.

## Examples
Concrete usage examples.
```

### Full-Featured Skill
```
.claude/skills/database-helper/
├── SKILL.md                    # Main skill definition
├── README.md                   # Documentation for humans
├── scripts/
│   ├── migrate.sh             # Migration script
│   ├── seed.sh                # Seed data script
│   └── backup.sh              # Backup script
├── templates/
│   ├── migration.sql.template # SQL migration template
│   └── model.py.template      # Model template
├── docs/
│   ├── schema.md              # Database schema docs
│   └── conventions.md         # Naming conventions
└── examples/
    ├── example-migration.sql  # Example migration
    └── example-model.py       # Example model
```

### SKILL.md Frontmatter Options

```yaml
---
name: skill-name                # Required: lowercase, hyphens, max 64 chars
description: Specific trigger-rich description  # Required
allowed-tools:                  # Optional: restrict tools
  - Read
  - Write
  - Bash
  - Grep
---
```

**Name requirements:**
- Lowercase letters, numbers, hyphens only
- Maximum 64 characters
- Descriptive and unique

**Description best practices:**
- Include trigger words users would mention
- Be specific about when to use
- Examples:
  - ✅ "Extract text, fill forms, merge PDFs. Use when working with PDF files"
  - ❌ "PDF helper"

**allowed-tools:**
- Restricts Claude to specific tools within this skill
- Useful for read-only skills
- Useful for security-sensitive skills
- Omit for full tool access

---

## Sub-Skills & Modular Architecture

### Approach 1: Multiple Files Referenced in Main Skill

**Structure:**
```
.claude/skills/testing-suite/
├── SKILL.md                   # Main orchestrator
├── unit-testing.md            # Unit test sub-skill
├── integration-testing.md     # Integration test sub-skill
├── e2e-testing.md            # E2E test sub-skill
└── coverage-analysis.md       # Coverage sub-skill
```

**SKILL.md:**
```markdown
---
name: testing-suite
description: Comprehensive testing workflows for unit, integration, and E2E tests
---

# Testing Suite

## Overview
This skill orchestrates all testing workflows.

## Sub-Skills

### Unit Testing
See `unit-testing.md` for detailed unit test workflows.

### Integration Testing
See `integration-testing.md` for integration test workflows.

### E2E Testing
See `e2e-testing.md` for E2E test workflows.

### Coverage Analysis
See `coverage-analysis.md` for coverage workflows.

## Workflow
1. Determine test type needed
2. Reference appropriate sub-skill
3. Follow that sub-skill's instructions
```

**Pros:**
- ✅ Modular and organized
- ✅ Easy to update individual parts
- ✅ Clear separation of concerns
- ✅ Claude loads progressively (context efficient)

**Cons:**
- ❌ More files to manage
- ❌ Requires good organization
- ❌ Slightly more complex

---

### Approach 2: Inline Sub-Skills in Single File

**Structure:**
```
.claude/skills/testing-suite/
└── SKILL.md                   # All-in-one
```

**SKILL.md:**
```markdown
---
name: testing-suite
description: Comprehensive testing workflows
---

# Testing Suite

## Unit Testing
### When to Use
- Testing individual functions
- Testing isolated components

### Instructions
1. Identify function to test
2. Create test file
3. Write test cases
4. Run tests
5. Verify coverage

## Integration Testing
### When to Use
- Testing multiple components together
- Testing API endpoints

### Instructions
1. Identify integration points
2. Set up test environment
3. Write integration tests
4. Run tests
5. Verify interactions

## E2E Testing
### When to Use
- Testing full user workflows
- Testing critical paths

### Instructions
1. Define user journey
2. Set up E2E framework
3. Write E2E tests
4. Run tests
5. Verify complete flow

## Coverage Analysis
### When to Use
- After running any tests
- Before releases

### Instructions
1. Run tests with coverage
2. Analyze coverage report
3. Identify gaps
4. Write tests for gaps
5. Verify improvement
```

**Pros:**
- ✅ Single file - simpler structure
- ✅ All information in one place
- ✅ Easier to maintain for small skills

**Cons:**
- ❌ Large file can be unwieldy
- ❌ Loads entire skill into context at once
- ❌ Harder to navigate for large skills

---

### Approach 3: Separate Skills That Reference Each Other

**Structure:**
```
.claude/skills/
├── unit-testing/
│   └── SKILL.md
├── integration-testing/
│   └── SKILL.md
├── e2e-testing/
│   └── SKILL.md
└── testing-orchestrator/
    └── SKILL.md
```

**testing-orchestrator/SKILL.md:**
```markdown
---
name: testing-orchestrator
description: Determine which testing skill to use and coordinate testing workflows
---

# Testing Orchestrator

## Purpose
Analyze the testing need and delegate to appropriate testing skill.

## Decision Tree

### Need unit tests?
→ Use the `unit-testing` skill

### Need integration tests?
→ Use the `integration-testing` skill

### Need E2E tests?
→ Use the `e2e-testing` skill

### Need all tests?
1. Run `unit-testing` skill
2. Run `integration-testing` skill
3. Run `e2e-testing` skill
4. Coordinate results

## When to Use This Skill
Use when user asks for "testing" without specifying type.
```

**Pros:**
- ✅ Maximum modularity
- ✅ Skills can be used independently
- ✅ Easy to add new test types
- ✅ Clear single responsibility

**Cons:**
- ❌ More complex structure
- ❌ Skill coordination overhead
- ❌ Potential for circular references

---

## Skill Interconnections

### Pattern 1: Orchestrator Skill

**Use case:** One main skill delegates to specialized skills

```
testing-orchestrator
    ↓
    ├─→ unit-testing
    ├─→ integration-testing
    └─→ e2e-testing
```

**Best for:**
- Complex workflows with distinct phases
- When sub-skills are useful independently
- When team needs both guided and expert modes

---

### Pattern 2: Pipeline Skills

**Use case:** Skills form a sequence

```
design-skill → implementation-skill → testing-skill → deployment-skill
```

**Example:**
```markdown
# Implementation Skill

## Prerequisites
Ensure the design-skill has been completed first.

## Instructions
1. Review output from design-skill
2. Implement according to design
3. Create tests (trigger testing-skill when done)

## Next Step
After implementation complete, trigger testing-skill.
```

**Best for:**
- Structured development processes
- Ensuring proper order of operations
- Onboarding workflows

---

### Pattern 3: Complementary Skills

**Use case:** Skills that work together but aren't sequential

```
        code-review-skill
             ↙    ↘
    security-skill  performance-skill
```

**Example:**
```markdown
# Code Review Skill

## Workflow
1. Review code quality
2. If security-sensitive code: Also use security-skill
3. If performance-critical code: Also use performance-skill
4. Combine all findings
```

**Best for:**
- Multi-faceted analysis
- Optional deep-dives
- Comprehensive reviews

---

### Pattern 4: Skill Composition

**Use case:** Building complex skills from simple ones

```
database-migration-skill
    ↓
    ├─→ backup-skill
    ├─→ schema-validation-skill
    ├─→ migration-execution-skill
    └─→ rollback-skill
```

**Best for:**
- Critical operations requiring multiple steps
- Each step is reusable elsewhere
- Clear separation of concerns

---

## Database Query Skills

### Example: SQL Query Helper Skill

```
.claude/skills/sql-helper/
├── SKILL.md
├── scripts/
│   ├── query.sh
│   └── explain.sh
├── templates/
│   ├── select.sql
│   ├── insert.sql
│   ├── update.sql
│   └── delete.sql
└── docs/
    └── schema.md
```

**SKILL.md:**
```yaml
---
name: sql-helper
description: Execute SQL queries, analyze query plans, optimize queries. Use for database interactions.
allowed-tools:
  - Read
  - Bash
  - Write
---

# SQL Helper Skill

## Database Connection
Default connection string stored in: `.env.local`

## Query Workflow

### 1. Read Schema
First, check `docs/schema.md` for table structure.

### 2. Construct Query
Use templates in `templates/` as starting point.

### 3. Execute Query
```bash
./scripts/query.sh "SELECT * FROM users WHERE id = ?"
```

### 4. Analyze Performance
```bash
./scripts/explain.sh "SELECT * FROM users WHERE id = ?"
```

## Query Types

### SELECT Queries
Template: `templates/select.sql`
- Always specify columns (avoid SELECT *)
- Use WHERE clauses for filtering
- Add LIMIT for large tables

### INSERT Queries
Template: `templates/insert.sql`
- Validate data before inserting
- Use transactions for multiple inserts

### UPDATE Queries
Template: `templates/update.sql`
- ALWAYS include WHERE clause
- Test with SELECT first
- Use transactions

### DELETE Queries
Template: `templates/delete.sql`
- EXTREMELY CAREFUL
- Backup first (use backup-skill)
- Test WHERE with SELECT first

## Safety Checks
Before any destructive operation:
1. Backup database (trigger backup-skill)
2. Run SELECT with same WHERE clause
3. Verify affected row count
4. Use transactions
5. Have rollback plan ready
```

**scripts/query.sh:**
```bash
#!/bin/bash
set -euo pipefail

source .env.local

QUERY="$1"

psql "$DATABASE_URL" -c "$QUERY"
```

**templates/select.sql:**
```sql
-- SELECT Template
-- Replace <table>, <columns>, <conditions>

SELECT
  <column1>,
  <column2>,
  <column3>
FROM <table>
WHERE <condition>
  AND <condition>
ORDER BY <column> DESC
LIMIT 100;
```

---

### Example: MongoDB Query Skill

```yaml
---
name: mongo-helper
description: Execute MongoDB queries, aggregations, and indexes. Use for MongoDB database operations.
---

# MongoDB Helper

## Connection
Default: `mongodb://localhost:27017/mydb`

## Query Patterns

### Find Documents
```javascript
db.collection.find({ field: value })
  .limit(10)
  .sort({ _id: -1 })
```

### Aggregation Pipeline
```javascript
db.collection.aggregate([
  { $match: { status: "active" } },
  { $group: { _id: "$category", count: { $sum: 1 } } },
  { $sort: { count: -1 } }
])
```

### Performance
Always create indexes for frequent queries:
```javascript
db.collection.createIndex({ field: 1 })
```

## Workflow
1. Check collection schema in `docs/collections.md`
2. Construct query using patterns above
3. Test query with .limit(1)
4. Execute full query
5. Analyze with .explain()
```

---

## CLAUDE.md Files

### What is CLAUDE.md?

**CLAUDE.md** is a special file that provides context to Claude about your project at session start.

**Location:** Project root (`.claude/CLAUDE.md` or just `CLAUDE.md`)

**Purpose:**
- Project overview
- Architecture documentation
- Coding conventions
- Common commands
- Important context

---

### Single CLAUDE.md vs Multiple

#### Approach 1: Single Root CLAUDE.md

**Structure:**
```
project/
├── .claude/
│   └── CLAUDE.md           # All project context
└── src/
```

**CLAUDE.md:**
```markdown
# Project Overview

## Architecture
- Frontend: React + TypeScript
- Backend: Node.js + Express
- Database: PostgreSQL

## Key Conventions
- Use camelCase for variables
- Components in src/components/
- Tests co-located with source

## Common Commands
- `npm run dev` - Start development
- `npm test` - Run tests
- `npm run build` - Build production

## Important Files
- `src/app.ts` - Main application entry
- `src/db/schema.sql` - Database schema
```

**Pros:**
- ✅ Simple structure
- ✅ All context in one place
- ✅ Easy to maintain

**Cons:**
- ❌ Can become very large
- ❌ Not modular
- ❌ Loads all context every time

---

#### Approach 2: Multiple CLAUDE.md Files

**Structure:**
```
project/
├── .claude/
│   └── CLAUDE.md                    # Main overview + references
├── frontend/
│   └── .claude/
│       └── CLAUDE.md                # Frontend-specific context
├── backend/
│   └── .claude/
│       └── CLAUDE.md                # Backend-specific context
└── docs/
    └── .claude/
        └── CLAUDE.md                # Documentation guidelines
```

**Root .claude/CLAUDE.md:**
```markdown
# Project Overview

This is a full-stack application with separate frontend and backend.

## Sub-Projects

### Frontend
See `frontend/.claude/CLAUDE.md` for frontend-specific context.

### Backend
See `backend/.claude/CLAUDE.md` for backend-specific context.

### Documentation
See `docs/.claude/CLAUDE.md` for documentation guidelines.

## Global Conventions
- Monorepo managed with npm workspaces
- All packages use TypeScript
- Jest for testing
```

**frontend/.claude/CLAUDE.md:**
```markdown
# Frontend Context

## Stack
- React 18
- TypeScript
- Vite
- TailwindCSS

## Structure
- `src/components/` - Reusable components
- `src/pages/` - Page components
- `src/hooks/` - Custom hooks

## Conventions
- Functional components only
- Custom hooks prefix with `use`
- Props interfaces suffix with `Props`
```

**Pros:**
- ✅ Modular context
- ✅ Focused documentation
- ✅ Better for monorepos
- ✅ Team members can own their sections

**Cons:**
- ❌ More complex structure
- ❌ Need to navigate references
- ❌ Potential for outdated cross-references

---

### CLAUDE.md Best Practices

**Do include:**
- ✅ Project architecture overview
- ✅ Key conventions and patterns
- ✅ Common commands
- ✅ Where to find things
- ✅ Important gotchas

**Don't include:**
- ❌ Detailed API documentation (link to it instead)
- ❌ Complete file listings (Claude can explore)
- ❌ Boilerplate code examples
- ❌ Sensitive information

**Keep it:**
- Concise (1-2 pages max per file)
- Up to date (update with major changes)
- Actionable (focus on what Claude needs to know)

---

### Referencing Other MD Files in CLAUDE.md

```markdown
# Project Context

## Architecture
See `docs/architecture.md` for detailed architecture.

## API Documentation
See `docs/api/README.md` for API reference.

## Database Schema
See `backend/db/schema.md` for schema documentation.

## Deployment
See `ops/deployment.md` for deployment process.
```

**When Claude needs details:**
1. Read CLAUDE.md (gets overview + pointers)
2. Read referenced docs as needed
3. Only loads what's necessary for current task

**Progressive context loading!**

---

## Skills vs Scripts vs Automation

### Pure AI Inference (Skills)

**What:** Skill with detailed instructions, no scripts

**Example:**
```markdown
---
name: code-review
description: Comprehensive code review process
---

# Code Review

## Steps
1. Read all changed files
2. Check for:
   - Security vulnerabilities
   - Performance issues
   - Code style violations
   - Missing tests
3. Provide detailed feedback
4. Suggest improvements
```

**Pros:**
- ✅ Flexible (AI adapts to situation)
- ✅ Handles edge cases well
- ✅ Can provide nuanced feedback
- ✅ No script maintenance

**Cons:**
- ❌ Slower (AI reasoning time)
- ❌ Less consistent
- ❌ Higher token usage
- ❌ Requires AI judgment

**Best for:**
- Complex analysis requiring judgment
- Situations with many variables
- Tasks requiring creativity
- When consistency isn't critical

---

### Hybrid (Skills + Scripts)

**What:** Skill orchestrates, scripts do heavy lifting

**Example:**
```
.claude/skills/code-review/
├── SKILL.md
└── scripts/
    ├── lint.sh
    ├── type-check.sh
    ├── test.sh
    └── security-scan.sh
```

**SKILL.md:**
```markdown
# Code Review

## Automated Checks
1. Run `./scripts/lint.sh`
2. Run `./scripts/type-check.sh`
3. Run `./scripts/test.sh`
4. Run `./scripts/security-scan.sh`

## Manual Review
After automated checks, review:
- Code architecture
- Algorithm efficiency
- API design
- Documentation quality
```

**Pros:**
- ✅ Fast for automatable parts
- ✅ Consistent automated checks
- ✅ AI focuses on complex judgment
- ✅ Best of both worlds

**Cons:**
- ❌ Requires script maintenance
- ❌ Scripts may break with environment changes
- ❌ More setup required

**Best for:**
- Well-defined checks + complex analysis
- Performance-critical operations
- Repeated tasks with consistent parts

---

### Pure Automation (Scripts Only)

**What:** Minimal AI inference, mostly scripts

**Example:**
```
.claude/skills/deployment/
├── SKILL.md
└── scripts/
    ├── deploy.sh
    ├── rollback.sh
    └── health-check.sh
```

**SKILL.md:**
```markdown
# Deployment

## Deploy
Simply run: `./scripts/deploy.sh production`

## Rollback
If deploy fails: `./scripts/rollback.sh`

## Verify
Check health: `./scripts/health-check.sh`
```

**Pros:**
- ✅ Extremely fast
- ✅ Perfectly consistent
- ✅ Low token usage
- ✅ No AI uncertainty

**Cons:**
- ❌ Inflexible (can't adapt)
- ❌ Requires comprehensive scripts
- ❌ High maintenance burden
- ❌ Can't handle exceptions well

**Best for:**
- Well-defined workflows
- Critical operations requiring consistency
- Performance-sensitive operations
- Simple, repetitive tasks

---

### Decision Matrix

| Task Type | Recommended Approach |
|-----------|---------------------|
| Code review | Hybrid (scripts for linting, AI for architecture review) |
| Deployment | Pure Automation (scripts) |
| Refactoring | Pure AI (requires judgment and context) |
| Testing | Hybrid (scripts run tests, AI analyzes failures) |
| Documentation | Pure AI (requires understanding and writing) |
| Security scan | Hybrid (tools find issues, AI prioritizes/explains) |
| Database migration | Pure Automation (too risky for AI improvisation) |
| Bug diagnosis | Pure AI (requires investigation and reasoning) |

---

## Advanced Patterns

### Pattern: Skill State Management

**Problem:** Skills need to remember state across invocations

**Solution:** Use files in project

```markdown
# Testing Skill

## State File
State stored in: `.claude/skill-state/testing.json`

## Before Testing
1. Read `.claude/skill-state/testing.json`
2. Check: Have we run tests before?
3. If yes: Check what changed since last run
4. If no: Run full test suite

## After Testing
1. Update `.claude/skill-state/testing.json`:
```json
{
  "last_run": "2025-11-09T10:30:00Z",
  "last_commit": "abc123",
  "test_count": 150,
  "pass_count": 148,
  "fail_count": 2
}
```
```

**Benefits:**
- Incremental testing
- Avoid redundant work
- Track progress over time

---

### Pattern: Skill Composition with Context Passing

**Problem:** Need to pass data between skills

**Solution:** Use intermediate files

```markdown
# Design Skill

## Output
Design decisions written to: `.claude/artifacts/design.md`

# Implementation Skill

## Input
Read design from: `.claude/artifacts/design.md`

## Output
Implementation notes written to: `.claude/artifacts/implementation.md`

# Testing Skill

## Input
Read implementation notes from: `.claude/artifacts/implementation.md`
```

**Benefits:**
- Clear data flow
- Resumable workflows
- Auditable decisions

---

### Pattern: Skill Versioning

**Problem:** Skills evolve, need backward compatibility

**Solution:**
```
.claude/skills/database-migration/
├── SKILL.md          # Version 2.0
└── docs/
    └── v1-migration-guide.md
```

**SKILL.md:**
```markdown
# Database Migration Skill v2.0

## Breaking Changes from v1
- Now requires PostgreSQL 14+
- New backup format

## Migration from v1
See `docs/v1-migration-guide.md`
```

---

### Pattern: Skill Testing

**Problem:** Need to verify skill works correctly

**Solution:**
```
.claude/skills/deployment/
├── SKILL.md
├── scripts/
│   └── deploy.sh
└── tests/
    ├── test-deploy.sh
    └── test-rollback.sh
```

**SKILL.md:**
```markdown
# Deployment Skill

## Self-Test
Before first use, run:
```bash
./tests/test-deploy.sh
./tests/test-rollback.sh
```

Should see: "All tests passed"
```

---

## Best Practices

### Skill Design

1. **Single Responsibility**
   - One skill = one capability
   - Split complex skills into orchestrator + specialists

2. **Clear Triggers**
   - Description should include user-facing terms
   - Make it obvious when to use this skill

3. **Progressive Disclosure**
   - Start simple, reference details
   - Don't overwhelm with everything upfront

4. **Examples Over Explanations**
   - Show concrete examples
   - Use templates

5. **Safe Defaults**
   - Default to safe operations
   - Require explicit confirmation for destructive actions

---

### File Organization

1. **Flat When Possible**
   - Don't create nested directories unless needed
   - Simpler is better

2. **Consistent Structure**
   - scripts/ for executables
   - templates/ for file templates
   - docs/ for supporting documentation
   - examples/ for examples

3. **Self-Documenting**
   - README.md for human readers
   - SKILL.md for Claude
   - Clear file names

---

### Maintenance

1. **Version Control**
   - Commit skills to git (project skills)
   - Tag versions for breaking changes

2. **Documentation**
   - Update when skill changes
   - Document breaking changes
   - Provide migration guides

3. **Testing**
   - Test skills after changes
   - Especially test scripts

4. **Cleanup**
   - Remove unused skills
   - Archive deprecated skills
   - Keep it lean

---

*See also: CLAUDE_CODE_COMPLETE_MANUAL.md, ASYNC_WORKFLOWS.md*

---

*End of Skills Advanced Guide. Last updated: 2025-11-09*
