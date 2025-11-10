#!/bin/bash

# Agent Repository Framework - Quick Deploy Script
# Non-interactive deployment - just deploys the current folder to GitHub

set -e

echo "========================================================="
echo "Quick Deploy: Agent Repository Framework"
echo "========================================================="
echo ""

# Check for GitHub CLI
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) not found!"
    echo "Install from: https://cli.github.com/"
    exit 1
fi

# Check authentication
if ! gh auth status &> /dev/null; then
    echo "❌ Please authenticate with GitHub CLI first:"
    echo "   gh auth login"
    exit 1
fi

# Verify we're in the right directory
if [ ! -f "CLAUDE.md" ] || [ ! -d "knowledge" ] || [ ! -d "templates" ]; then
    echo "❌ Error: This script must be run from the agent-repo-framework directory"
    exit 1
fi

# Get repository name from current directory name
REPO_NAME=$(basename "$PWD")

echo "📦 Deploying framework as: $REPO_NAME"
echo "   Location: $PWD"
echo "   Visibility: Private"
echo ""

# Remove existing .git if present
if [ -d ".git" ]; then
    echo "Removing existing git history..."
    rm -rf .git
fi

# Initialize git
echo "Initializing git repository..."
git init -b main > /dev/null 2>&1

# Add all files
echo "Adding all files..."
git add . > /dev/null 2>&1

# Create commit
echo "Creating initial commit..."
git commit -m "Initial commit: Claude Code Agent Repository Framework

Complete framework including:
- Knowledge base (concepts + full versions)
- User engagement workflow (questions, profiles, tools)
- Plan generation templates
- Ready-to-deploy templates (5 templates)
- Utilities and helper scripts

This framework helps users design and build specialized Claude Code repositories." > /dev/null 2>&1

# Create and push to GitHub
echo "Creating GitHub repository and pushing..."
gh repo create "$REPO_NAME" --private --source=. --push > /dev/null 2>&1

echo ""
echo "========================================================="
echo "✅ Deployed!"
echo "========================================================="
echo ""
gh repo view --json url -q .url 2>/dev/null || echo "Repository: $REPO_NAME"
echo ""
echo "Next: Open in Claude Code and start using!"
echo ""
