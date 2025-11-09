# Goal Tracker & Proactive Planning System

An intelligent goal tracking system that gives you daily plans automatically.

## What This Does

When you say "Hello" each morning, Claude presents:
- Today's top 3 priorities (based on your long-term goals)
- Progress on weekly goals
- Blockers and how to resolve them
- Smart suggestions for the day

**No manual planning required.**

## Perfect For

- Busy professionals juggling multiple goals
- Students tracking academic progress
- Anyone with long-term aspirations
- People who want accountability without overhead

## How It Works

**Once (10 min):**
- Define your long-term goals

**Daily (5 min):**
- Say "Hello"
- Get personalized plan
- Work on priorities
- Update progress (automatic)

## Features

- ✅ **Proactive Planning** - Daily plans generated automatically
- ✅ **Progress Tracking** - See weekly/monthly progress
- ✅ **Blocker Identification** - Spot issues early
- ✅ **Smart Prioritization** - Focus on what matters
- ✅ **Weekly Reports** - Auto-generated summaries
- ✅ **Goal Alignment** - Tasks always connect to long-term goals

## Structure

```
your-goals/
├── goals/
│   ├── long-term/           # Your big goals (career, learning, health)
│   ├── short-term/          # This month/quarter
│   └── daily/               # Auto-generated daily plans
├── completed/               # Archive of completed goals
├── progress/                # Progress tracking
└── .claude/
    └── CLAUDE.md           # Instructions for Claude
```

## Example Session

**You:** "Hello"

**Claude:**
```
Good morning! Here's your plan for today:

🎯 Top Priorities:
1. Finish authentication module (aligns with: Career goal - Senior Engineer)
   - Est. time: 2 hours
   - Status: 70% complete

2. Review 2 PRs (aligns with: Career goal - Leadership)
   - Est. time: 1 hour
   - PRs: #123, #124

3. Read "Designing Data-Intensive Applications" Ch 3
   - Est. time: 1 hour
   - Aligns with: Career goal - System Design

📅 Weekly Progress:
- Auth module: 70% → Target 100% today ✨
- Code reviews: 2/5 done
- Reading: 2/10 chapters done

💡 Suggestion:
The auth module is well-defined. I can implement the
password reset endpoint while you handle PRs.
Want me to start in background?

Ready to begin?
```

## Deployment

Run `./deploy_me.sh` and follow prompts.

## After Deployment

1. Clone your new repository
2. Start Claude Code session
3. Define your long-term goals (one-time setup)
4. Say "Hello" each morning
5. Watch productivity soar

## Tips

- **Be specific** with long-term goals (e.g., "Become senior engineer by 2026" not "Get promoted")
- **Trust the system** - Claude's suggestions align with your stated goals
- **Review weekly** - Adjust goals as priorities change
- **Celebrate progress** - Claude tracks wins automatically

---

*Deploy this template and never manually plan your day again!*
