# Personal Knowledge Base Template

A Zettelkasten-style knowledge management system powered by Claude Code.

## What This Does

- **Connected Notes:** Atomic notes with backlinks
- **Topic Index:** Auto-maintained organization
- **Knowledge Graph:** Visual connections between concepts
- **Smart Search:** Find notes by topic, keyword, or connection
- **Progressive Accumulation:** Builds knowledge over time

## Perfect For

- Researchers organizing findings
- Students building study materials
- Professionals tracking industry knowledge
- Lifelong learners accumulating expertise
- Anyone who reads/learns and wants to retain knowledge

## How It Works

1. **Create atomic notes** - One concept per note
2. **Link related notes** - Use `[[note-name]]` syntax
3. **Claude maintains indices** - Automatic organization
4. **Query your knowledge** - Natural language search
5. **Synthesize insights** - Claude finds patterns

## Structure

```
your-knowledge-base/
├── notes/               # Your atomic notes
│   ├── 001-topic.md
│   ├── 002-topic.md
│   └── ...
├── index/               # Auto-maintained indices
│   ├── by-topic.md
│   ├── by-date.md
│   └── backlinks.md
├── connections/         # Knowledge graph
│   └── graph.md
└── .claude/
    ├── CLAUDE.md       # Instructions for Claude
    └── skills/
        ├── note-creator/
        ├── note-linker/
        └── knowledge-search/
```

## Usage Examples

### Creating a Note

```
You: "Add note about React hooks"

Claude creates:
- notes/005-react-hooks.md (atomic note with content)
- Updates index/by-topic.md
- Updates index/by-date.md
- Creates backlinks to related notes
- Updates knowledge graph
```

### Finding Information

```
You: "What do I know about async programming?"

Claude searches:
- Finds all related notes
- Shows connections
- Synthesizes answer from your knowledge base
```

### Building on Knowledge

```
You: "I'm learning about distributed systems.
      Add today's learnings about consensus algorithms."

Claude:
- Creates new note
- Links to existing notes (if any about databases, networking, etc.)
- Identifies gaps in knowledge
- Suggests next learning topics
```

## Deployment

Run `./deploy_me.sh` and follow prompts.

You'll be asked for:
- Repository name (e.g., `my-knowledge-base`)
- Whether to make it public or private

## After Deployment

1. Clone your new repository
2. Start Claude Code session
3. Say: "Read .claude/CLAUDE.md and help me start my knowledge base"
4. Begin adding notes!

## Customization

Edit `.claude/CLAUDE.md` to:
- Change note format
- Add custom tags/categories
- Adjust linking style
- Modify search behavior

## Tips for Success

1. **Keep notes atomic** - One concept per note
2. **Link liberally** - Connect related ideas
3. **Review regularly** - Claude can generate review schedules
4. **Synthesize periodically** - Ask Claude to find patterns
5. **Don't worry about organization** - Claude maintains it

## Example Workflow

**Daily:**
- Add 3-5 new notes from reading/learning
- 5 minutes per day

**Weekly:**
- Review new connections (auto-generated)
- Synthesize insights (ask Claude)
- 15 minutes per week

**Monthly:**
- Generate knowledge graph visualization
- Identify learning gaps
- Plan next month's learning
- 30 minutes per month

**Result:** After 6 months, you have a comprehensive, searchable knowledge base containing hundreds of connected notes representing your learning journey.

## Examples from Real Use

**Research Student:**
- 300+ notes on machine learning
- Auto-linked by concept
- Quick paper review lookup
- Thesis writing support

**Product Manager:**
- 200+ notes on product patterns
- Competitive analysis
- User insights
- Strategic planning support

**Language Learner:**
- 500+ vocabulary notes
- Grammar concepts linked
- Usage examples
- Spaced repetition schedules

---

*Deploy this template to start building your personal knowledge empire!*
