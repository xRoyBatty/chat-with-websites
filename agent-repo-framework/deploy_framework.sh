#!/bin/bash

# Agent Repository Framework - Deploy Script
# Deploys this framework as a new GitHub repository

set -e

echo "========================================================="
echo "Claude Code Agent Repository Framework - Deployment"
echo "========================================================="
echo ""
echo "This will create a new GitHub repository containing the"
echo "complete agent-repo-framework with all knowledge, templates,"
echo "and tools."
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

# Verify we're in the right directory
if [ ! -f "CLAUDE.md" ] || [ ! -d "knowledge" ] || [ ! -d "templates" ]; then
    echo "❌ Error: This script must be run from the agent-repo-framework directory"
    echo ""
    echo "Expected structure:"
    echo "  agent-repo-framework/"
    echo "  ├── CLAUDE.md"
    echo "  ├── knowledge/"
    echo "  ├── templates/"
    echo "  └── deploy_framework.sh (this script)"
    echo ""
    exit 1
fi

echo "✅ Directory structure verified"
echo ""

# Get repository name
read -p "Repository name (e.g., claude-code-framework): " REPO_NAME
[ -z "$REPO_NAME" ] && echo "❌ Name required" && exit 1

# Visibility
echo ""
echo "Repository visibility:"
echo "1) Private (recommended if you'll customize it)"
echo "2) Public (if you want to share with others)"
read -p "Choose (1/2): " VIS
VISIBILITY=$([ "$VIS" = "1" ] && echo "--private" || echo "--public")

# Check if already a git repository
IS_GIT_REPO=false
if [ -d ".git" ]; then
    echo ""
    echo "⚠️  This directory is already a git repository."
    echo ""
    read -p "Remove existing git history and create fresh repo? (y/n): " FRESH_START

    if [ "$FRESH_START" = "y" ]; then
        echo "Removing existing .git directory..."
        rm -rf .git
        IS_GIT_REPO=false
    else
        IS_GIT_REPO=true
    fi
fi

# Confirm
echo ""
echo "Ready to deploy:"
echo "  Repository: $REPO_NAME"
echo "  Visibility: $([ "$VIS" = "1" ] && echo "Private" || echo "Public")"
echo "  Location: $(pwd)"
echo ""
read -p "Proceed? (y/n): " CONFIRM
[ "$CONFIRM" != "y" ] && echo "Cancelled" && exit 0

echo ""
echo "📦 Deploying framework..."
echo ""

# Initialize git if needed
if [ "$IS_GIT_REPO" = "false" ]; then
    echo "1. Initializing git repository..."
    git init -b main

    echo "2. Adding all files..."
    git add .

    echo "3. Creating initial commit..."
    git commit -m "Initial commit: Claude Code Agent Repository Framework

Complete framework including:
- Knowledge base (concepts + full versions)
- User engagement workflow (questions, profiles, tools)
- Plan generation templates
- Ready-to-deploy templates (5 templates)
- Utilities and helper scripts

This framework helps users design and build specialized Claude Code repositories."

fi

# Create GitHub repository and push
echo "4. Creating GitHub repository and pushing..."
gh repo create "$REPO_NAME" $VISIBILITY --source=. --push

echo ""
echo "========================================================="
echo "✅ Deployment Complete!"
echo "========================================================="
echo ""
echo "Your framework is now available at:"
gh repo view --web --json url -q .url 2>/dev/null || echo "https://github.com/$(gh api user -q .login)/$REPO_NAME"
echo ""
echo "Next steps:"
echo ""
echo "1. Clone to a new location (if needed):"
echo "   gh repo clone $REPO_NAME"
echo ""
echo "2. Open in Claude Code and start using:"
echo "   - Read CLAUDE.md for complete guide"
echo "   - Explore knowledge/ for learning"
echo "   - Use templates/ for quick deployment"
echo "   - Customize for your needs"
echo ""
echo "3. Start helping users build custom repositories!"
echo ""
echo "Framework deployed! 🚀"
echo ""
