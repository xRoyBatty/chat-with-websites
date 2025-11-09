# Basic Repository Template

A minimal Claude Code repository for simple, focused projects.

## What This Does

Provides a clean, minimal starting point for custom Claude Code repositories without unnecessary complexity.

## Perfect For

- Quick prototypes or experiments
- Single-purpose tools or scripts
- Learning Claude Code basics
- When you want to start from scratch
- Small personal projects

## Features

- ✅ **Minimal Structure** - Only essential directories
- ✅ **Clean Slate** - No pre-configured workflows
- ✅ **Easy Customization** - Add only what you need
- ✅ **Quick Setup** - Deploy in under 5 minutes
- ✅ **Documentation Starter** - Basic README and CLAUDE.md templates

## Structure

```
your-repo/
├── docs/                 # Documentation (optional)
├── scripts/              # Helper scripts (optional)
├── data/                 # Data files (optional)
└── .claude/
    ├── CLAUDE.md        # Instructions for Claude
    └── skills/          # Custom skills (optional)
```

## What You Get

**Included:**
- Basic directory structure
- Starter CLAUDE.md with common patterns
- README template
- .gitignore for common files

**NOT Included:**
- Pre-configured workflows
- Complex automation
- Specialized domains (goals, knowledge management, etc.)

**Philosophy:** Start minimal, add what you need.

## Deployment

Run `./deploy_me.sh` and follow prompts.

You'll be asked for:
- Repository name (e.g., `my-project`)
- Whether to make it public or private

## After Deployment

1. Clone your new repository
2. Start Claude Code session
3. Customize `.claude/CLAUDE.md` for your specific use case
4. Begin building!

## Customization Ideas

### Convert to Specific Use Case:

**Development Project:**
```
Add: src/, tests/, CI/CD workflows
```

**Documentation Site:**
```
Add: content/, templates/, build scripts
```

**Data Analysis:**
```
Add: notebooks/, datasets/, analysis/
```

**Automation:**
```
Add: workflows/, schedules/, logs/
```

## Tips

1. **Start small** - Don't add structure you don't need yet
2. **Iterate** - Add directories as needs become clear
3. **Document** - Update CLAUDE.md as your patterns emerge
4. **Keep it simple** - Complexity only when beneficial

## When to Use This vs Other Templates

**Use Basic Repo when:**
- You know exactly what you want to build
- Other templates are too opinionated
- You want maximum flexibility
- Project doesn't fit existing templates

**Use Other Templates when:**
- Goal tracking → `goal-tracker/`
- Knowledge management → `personal-knowledge-base/`
- Multi-agent coordination → `vps-multi-agent/`
- Comprehensive system → `life-os/`

## Examples

**Personal Tool:**
```
my-tool/
├── scripts/
│   └── main.py
├── data/
│   └── config.json
└── .claude/
    └── CLAUDE.md  # "Help me maintain and improve this tool"
```

**Quick Prototype:**
```
experiment/
├── docs/
│   └── notes.md
├── code/
│   └── prototype.py
└── .claude/
    └── CLAUDE.md  # "Help me explore this idea"
```

---

*Deploy this template when you want a clean slate for custom projects!*
