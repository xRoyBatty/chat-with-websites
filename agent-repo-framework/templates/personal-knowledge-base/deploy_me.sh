#!/bin/bash

# Personal Knowledge Base - Deploy Script
# Uses GitHub CLI to create and push a new repository

set -e  # Exit on error

echo "=================================================="
echo "Personal Knowledge Base - Deployment Script"
echo "=================================================="
echo ""

# Check for GitHub CLI
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) not found!"
    echo "Please install: https://cli.github.com/"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ GitHub CLI not authenticated!"
    echo "Please run: gh auth login"
    exit 1
fi

echo "✅ GitHub CLI is ready"
echo ""

# Get repository name
read -p "Enter repository name (e.g., my-knowledge-base): " REPO_NAME

if [ -z "$REPO_NAME" ]; then
    echo "❌ Repository name cannot be empty"
    exit 1
fi

# Get visibility
echo ""
echo "Repository visibility:"
echo "1) Private (recommended for personal knowledge)"
echo "2) Public"
read -p "Choose (1 or 2): " VISIBILITY_CHOICE

if [ "$VISIBILITY_CHOICE" = "1" ]; then
    VISIBILITY="--private"
else
    VISIBILITY="--public"
fi

# Confirm
echo ""
echo "=================================================="
echo "Ready to deploy:"
echo "  Name: $REPO_NAME"
echo "  Visibility: $([ "$VISIBILITY_CHOICE" = "1" ] && echo "Private" || echo "Public")"
echo "=================================================="
read -p "Proceed? (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ]; then
    echo "Deployment cancelled"
    exit 0
fi

# Create temporary directory
TEMP_DIR=$(mktemp -d)
echo ""
echo "📦 Creating repository structure..."

# Copy template to temp directory
cp -r structure "$TEMP_DIR/"
cp -r scripts "$TEMP_DIR/" 2>/dev/null || true
cp -r .claude "$TEMP_DIR/"

# Create additional files
cat > "$TEMP_DIR/README.md" << 'EOF'
# My Personal Knowledge Base

A Zettelkasten-style knowledge management system powered by Claude Code.

## Quick Start

1. **Add a note:**
   ```
   Create a note about [topic]
   ```

2. **Search knowledge:**
   ```
   What do I know about [topic]?
   ```

3. **Find connections:**
   ```
   Show me how [topic A] relates to [topic B]
   ```

## Structure

- `notes/` - Your atomic notes (one concept per file)
- `index/` - Auto-maintained indices (by topic, date, etc.)
- `connections/` - Knowledge graph and backlinks

## Usage

Start a Claude Code session and say:
```
Read .claude/CLAUDE.md and help me manage my knowledge base
```

Claude will:
- Create properly formatted notes
- Maintain indices automatically
- Create backlinks between related notes
- Help you find and synthesize information

## Tips

- Keep notes atomic (one concept each)
- Link liberally using [[note-name]] syntax
- Review weekly to identify patterns
- Let Claude maintain organization

---

*Built from the Claude Code Consultation Repository template*
EOF

# Create .claude/CLAUDE.md
cat > "$TEMP_DIR/.claude/CLAUDE.md" << 'EOF'
# Personal Knowledge Base - Claude Instructions

## Your Role

You are a **knowledge management assistant** for this personal knowledge base.

## Repository Structure

- `notes/` - Atomic notes (numbered: 001-topic.md, 002-topic.md, etc.)
- `index/` - Indices you maintain
  - `by-topic.md` - Organized by topic/category
  - `by-date.md` - Chronological list
  - `backlinks.md` - Which notes link to which
- `connections/` - Knowledge graph
  - `graph.md` - Visual representation of connections

## Note Format

Each note follows this template:

```markdown
# [Title]

**Created:** YYYY-MM-DD
**Tags:** #tag1 #tag2 #tag3
**Related:** [[other-note]], [[another-note]]

## Concept

[Main explanation]

## Key Points

- Point 1
- Point 2
- Point 3

## Examples

[Concrete examples]

## Connections

How this relates to other notes:
- [[note-1]]: [relationship]
- [[note-2]]: [relationship]

## Questions

- [Open question]
- [Open question]

## Sources

- [Source 1]
- [Source 2]
```

## Your Responsibilities

### When User Adds a Note

1. **Get next note number:**
   - Check `index/by-date.md` for latest number
   - Increment by 1

2. **Create the note:**
   - Use template above
   - Fill with provided content
   - Add appropriate tags
   - Identify related notes from existing knowledge base

3. **Update indices:**
   - Add to `index/by-date.md`
   - Add to appropriate topic in `index/by-topic.md`
   - Update `index/backlinks.md`

4. **Update connections:**
   - Add new links to `connections/graph.md`
   - Update related notes with backlink to this note

### When User Searches

1. **Understand query:**
   - Extract key concepts
   - Identify relevant tags

2. **Search across:**
   - Note titles
   - Note content
   - Tags
   - Connections

3. **Synthesize answer:**
   - Cite specific notes (with numbers)
   - Show connections between notes
   - Identify gaps if any

4. **Suggest follow-up:**
   - Related notes to explore
   - Potential new notes to create
   - Missing connections to document

### Maintenance Tasks

**When asked to "review knowledge base":**
1. Find orphaned notes (no links in/out)
2. Suggest connections
3. Identify topic clusters
4. Recommend areas for growth

**When asked to "synthesize insights":**
1. Identify patterns across notes
2. Find contradictions to resolve
3. Suggest meta-notes (notes about groups of notes)
4. Generate learning path recommendations

## Principles

1. **Keep notes atomic** - One concept per note
2. **Link liberally** - Create connections
3. **Maintain indices** - Always up to date
4. **Be proactive** - Suggest connections user might not see
5. **Preserve structure** - Consistent formatting

## Example Interactions

**User:** "Add note about React hooks"

**You:**
1. Check latest note number (e.g., 004)
2. Create `notes/005-react-hooks.md`
3. Identify related notes (e.g., if there's a note on React)
4. Update all indices
5. Report: "Created note 005-react-hooks.md, linked to note 003-react-basics"

**User:** "What do I know about async programming?"

**You:**
1. Search for "async" in notes
2. Find relevant notes (e.g., 007, 015, 023)
3. Synthesize: "Based on your knowledge base, here's what you know..."
4. Cite specific notes with numbers
5. Suggest: "You might also want to review note 012-promises which is related"

**User:** "Show connections between databases and performance"

**You:**
1. Find all notes tagged #database
2. Find all notes tagged #performance
3. Analyze connections between them
4. Generate visual representation
5. Identify gaps: "You have notes on database indexing and query performance, but nothing on connection pooling"

## Advanced Features

### Spaced Repetition

If user wants to review:
1. Check `index/by-date.md` for note ages
2. Suggest notes to review based on spacing algorithm
3. Generate review questions

### Knowledge Graph

Maintain `connections/graph.md` as a Mermaid diagram:

```mermaid
graph TD
    001[Async Programming] --> 007[Promises]
    001 --> 015[Async Await]
    007 --> 023[Error Handling]
    015 --> 023
```

### Topic Clusters

Identify when user has 10+ notes on a topic:
- Suggest creating an index note
- Offer to synthesize into learning curriculum
- Recommend next subtopics to explore

## Your Personality

- **Helpful:** Proactively suggest connections
- **Organized:** Maintain perfect structure
- **Insightful:** Point out patterns
- **Encouraging:** Celebrate knowledge growth

## When User Returns After Long Absence

1. Read `index/by-date.md` to see last activity
2. Generate summary: "Since your last note on [date], you have X notes in Y topics"
3. Suggest: "Would you like to review recent notes or add new ones?"

---

*You are the curator of this knowledge base. Keep it organized, connected, and valuable!*
EOF

# Create starter notes
mkdir -p "$TEMP_DIR/notes"

cat > "$TEMP_DIR/notes/001-welcome.md" << 'EOF'
# Welcome to Your Knowledge Base

**Created:** $(date +%Y-%m-%d)
**Tags:** #meta #getting-started
**Related:** [[002-how-to-use]]

## Concept

This is your personal knowledge base - a place to accumulate and connect knowledge over time.

## Key Points

- Each note is atomic (one concept)
- Notes link to related notes
- Claude maintains organization automatically
- Knowledge compounds over time

## How to Use

1. Add notes about what you learn
2. Claude will link related concepts
3. Search your knowledge anytime
4. Review and synthesize periodically

## Next Steps

1. Create your first real note
2. Build the habit of daily notes
3. Watch your knowledge grow

## Questions

- What topics will you focus on?
- How often will you add notes?
- What's your first learning goal?

## Sources

- Claude Code Consultation Repository
EOF

# Create initial indices
mkdir -p "$TEMP_DIR/index"

cat > "$TEMP_DIR/index/by-topic.md" << 'EOF'
# Notes by Topic

## Meta
- [[001-welcome]] - Welcome to Your Knowledge Base

---

*This index is auto-maintained by Claude*
EOF

cat > "$TEMP_DIR/index/by-date.md" << 'EOF'
# Notes by Date

## $(date +%Y-%m-%d)
- 001: [[001-welcome]] - Welcome to Your Knowledge Base

---

Latest note: 001

*This index is auto-maintained by Claude*
EOF

cat > "$TEMP_DIR/index/backlinks.md" << 'EOF'
# Backlinks

No backlinks yet.

---

*This index is auto-maintained by Claude*
EOF

# Create knowledge graph
mkdir -p "$TEMP_DIR/connections"

cat > "$TEMP_DIR/connections/graph.md" << 'EOF'
# Knowledge Graph

```mermaid
graph TD
    001[Welcome]
```

---

*This graph is auto-maintained by Claude*
EOF

# Create .gitignore
cat > "$TEMP_DIR/.gitignore" << 'EOF'
# OS
.DS_Store
Thumbs.db

# Editor
.vscode/
.idea/
*.swp
*.swo

# Temp
*.tmp
.temp/
EOF

# Initialize git
cd "$TEMP_DIR"
git init -b main
git add .
git commit -m "Initial commit: Personal Knowledge Base template"

# Create GitHub repository
echo ""
echo "📤 Creating GitHub repository..."
gh repo create "$REPO_NAME" $VISIBILITY --source=. --push

echo ""
echo "=================================================="
echo "✅ Deployment Complete!"
echo "=================================================="
echo ""
echo "Your knowledge base is ready at:"
gh repo view --web 2>/dev/null || echo "https://github.com/$(gh api user -q .login)/$REPO_NAME"
echo ""
echo "Next steps:"
echo "1. Clone the repository:"
echo "   gh repo clone $REPO_NAME"
echo ""
echo "2. Open in Claude Code"
echo ""
echo "3. Start session with:"
echo "   'Read .claude/CLAUDE.md and help me manage my knowledge base'"
echo ""
echo "4. Add your first note:"
echo "   'Create a note about [topic you're learning]'"
echo ""
echo "Happy knowledge building! 🧠"
echo ""

# Cleanup
cd - > /dev/null
rm -rf "$TEMP_DIR"
