#!/bin/bash

# Basic Repo - Deploy Script

set -e

echo "=================================================="
echo "Basic Repository Template - Deployment"
echo "=================================================="
echo ""

# Check for GitHub CLI
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) not found!"
    echo "Install from: https://cli.github.com/"
    exit 1
fi

# Check authentication
if ! gh auth status &> /dev/null; then
    echo "❌ Please authenticate: gh auth login"
    exit 1
fi

# Get repository name
read -p "Repository name (e.g., my-project): " REPO_NAME
[ -z "$REPO_NAME" ] && echo "❌ Name required" && exit 1

# Visibility
echo ""
echo "1) Private (recommended)"
echo "2) Public"
read -p "Choose (1/2): " VIS
VISIBILITY=$([ "$VIS" = "1" ] && echo "--private" || echo "--public")

# Confirm
echo ""
echo "Creating: $REPO_NAME ($([ "$VIS" = "1" ] && echo "Private" || echo "Public"))"
read -p "Proceed? (y/n): " CONFIRM
[ "$CONFIRM" != "y" ] && echo "Cancelled" && exit 0

# Create temp directory
TEMP_DIR=$(mktemp -d)
echo ""
echo "📦 Creating repository..."

# Create basic structure
mkdir -p "$TEMP_DIR/docs"
mkdir -p "$TEMP_DIR/scripts"
mkdir -p "$TEMP_DIR/data"
mkdir -p "$TEMP_DIR/.claude/skills"

# README
cat > "$TEMP_DIR/README.md" << 'EOF'
# My Project

A custom Claude Code repository.

## Quick Start

1. Start Claude Code session
2. Say: "Read .claude/CLAUDE.md and help me understand this repository"
3. Begin working!

## Structure

- `docs/` - Documentation
- `scripts/` - Helper scripts
- `data/` - Data files
- `.claude/` - Claude Code configuration

## Customization

Edit `.claude/CLAUDE.md` to customize Claude's behavior for your project.

---

*Built with Claude Code Agent Repository Framework*
EOF

# CLAUDE.md
cat > "$TEMP_DIR/.claude/CLAUDE.md" << 'EOF'
# Project Instructions

## Your Role

You are assisting with this custom project. Follow the user's guidance and help them achieve their goals.

## Repository Structure

- `docs/` - Project documentation
- `scripts/` - Helper scripts and automation
- `data/` - Data files and configuration
- `.claude/skills/` - Custom skills for this project

## On Session Start

1. Read this file (CLAUDE.md)
2. Check for any recent changes in the repository
3. Ask the user: "What would you like to work on?"

## General Guidelines

- **Understand first** - Read relevant files before making changes
- **Document changes** - Keep docs/ updated
- **Test thoroughly** - Verify changes work as expected
- **Commit clearly** - Write descriptive commit messages
- **Ask when unclear** - Don't assume requirements

## Workflow

1. **User provides task**
2. **You analyze** - Understand requirements, read relevant files
3. **You propose** - Suggest approach if complex
4. **You implement** - Make changes
5. **You test** - Verify it works
6. **You document** - Update docs if needed

## File-Based Memory

This repository doesn't have automatic memory. Important information should be:
- Documented in `docs/`
- Tracked in git commits
- Stored in `data/` configuration files

## Customization

**Modify this file** to add:
- Project-specific instructions
- Domain knowledge
- Preferred patterns
- Workflow preferences
- Custom conventions

## Example Customizations

### For Development Projects:
Add sections about:
- Code style preferences
- Testing requirements
- Deployment procedures
- Architecture decisions

### For Data Projects:
Add sections about:
- Data formats
- Processing pipelines
- Analysis workflows
- Output requirements

### For Documentation Projects:
Add sections about:
- Writing style
- Structure conventions
- Review process
- Publishing workflow

---

*Customize this file to match your project's needs!*
EOF

# Placeholder files
cat > "$TEMP_DIR/docs/README.md" << 'EOF'
# Project Documentation

Add your project documentation here.

## Getting Started

[Your getting started guide]

## Reference

[Your reference documentation]

## Examples

[Your usage examples]
EOF

cat > "$TEMP_DIR/scripts/README.md" << 'EOF'
# Scripts

Add helper scripts here.

## Available Scripts

- [Script 1]: [Description]
- [Script 2]: [Description]
EOF

cat > "$TEMP_DIR/data/README.md" << 'EOF'
# Data Files

Add data files and configuration here.

## Files

- [File 1]: [Purpose]
- [File 2]: [Purpose]
EOF

# .gitignore
cat > "$TEMP_DIR/.gitignore" << 'EOF'
# OS
.DS_Store
Thumbs.db

# Temporary
*.tmp
*.log
*.swp
*~

# Python
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
venv/
env/

# Node
node_modules/
npm-debug.log

# IDE
.vscode/
.idea/
*.iml

# Build
dist/
build/
*.egg-info/
EOF

# Git init
cd "$TEMP_DIR"
git init -b main
git add .
git commit -m "Initial commit: Basic repository template"

# Create repo
echo ""
echo "📤 Creating GitHub repository..."
gh repo create "$REPO_NAME" $VISIBILITY --source=. --push

echo ""
echo "=================================================="
echo "✅ Deployment Complete!"
echo "=================================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Clone: gh repo clone $REPO_NAME"
echo ""
echo "2. Open in Claude Code"
echo ""
echo "3. Customize .claude/CLAUDE.md for your project"
echo ""
echo "4. Start building!"
echo ""
echo "Happy coding! 🚀"
echo ""

# Cleanup
cd - > /dev/null
rm -rf "$TEMP_DIR"
