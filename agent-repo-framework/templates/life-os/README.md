# Life OS Template

A comprehensive life operating system integrating all aspects of personal productivity, knowledge, and growth.

## What This Does

Life OS is an **all-in-one integrated system** that combines:
- Goal tracking and planning
- Knowledge management (Zettelkasten)
- Learning curricula
- Project management
- Daily planning and reflection
- Habit tracking
- Decision journaling
- Cross-domain intelligence

**Think of it as:** Your personal AI assistant with a complete understanding of your life, goals, and knowledge.

## Perfect For

- People seeking comprehensive life management
- Those juggling multiple domains (work, learning, health, projects)
- Users who want proactive AI assistance
- Anyone building a "second brain"
- Professionals wanting holistic productivity
- Lifelong learners accumulating cross-domain knowledge

## Philosophy

**Integrated, not fragmented:** Instead of separate tools for goals, notes, tasks, and learning, Life OS treats them as interconnected parts of your life.

**Proactive, not reactive:** Claude doesn't wait for commands—it suggests actions based on your goals, patterns, and context.

**File-based intelligence:** All data lives in structured files, creating true "memory" across sessions.

## Features

### 🎯 Goal & Project Management
- Long-term goal tracking
- Project breakdown and management
- Daily proactive planning
- Progress monitoring
- Blocker identification

### 📚 Knowledge Management
- Zettelkasten-style atomic notes
- Automatic linking and indexing
- Cross-domain synthesis
- Knowledge graph visualization
- Smart retrieval

### 📖 Learning System
- Structured curricula
- Spaced repetition
- Progress tracking
- Resource management
- Knowledge integration

### 📝 Daily Operations
- Morning briefings (goals + schedule + suggestions)
- Evening reflections
- Weekly reviews
- Monthly retrospectives
- Quarterly planning

### 🔗 Cross-Domain Intelligence
- Connections between goals, knowledge, and projects
- Pattern recognition across life domains
- Proactive suggestions based on holistic view
- Decision support using accumulated knowledge

## Structure

```
your-life-os/
├── goals/
│   ├── long-term/          # Big life goals
│   ├── short-term/         # This quarter/month
│   └── projects/           # Active projects
│
├── knowledge/
│   ├── notes/              # Atomic notes
│   ├── index/              # Auto-maintained indices
│   └── connections/        # Knowledge graph
│
├── learning/
│   ├── curricula/          # Learning plans
│   ├── resources/          # Books, courses, articles
│   └── progress/           # What you've learned
│
├── daily/
│   ├── plans/              # Daily plans (auto-generated)
│   ├── reflections/        # Evening reviews
│   └── logs/               # Activity logs
│
├── reviews/
│   ├── weekly/             # Weekly reviews
│   ├── monthly/            # Monthly retrospectives
│   └── quarterly/          # Quarterly planning
│
├── decisions/
│   ├── pending/            # Decisions to make
│   ├── archive/            # Past decisions with reasoning
│   └── principles/         # Decision-making frameworks
│
├── datasets/
│   ├── profile.md          # Who you are
│   ├── preferences.md      # Your preferences
│   ├── context.md          # Current life context
│   └── patterns.md         # Recognized patterns
│
└── .claude/
    ├── CLAUDE.md           # System instructions
    └── skills/             # Custom Life OS skills
```

## Daily Workflow Example

### Morning (5 minutes)

**You:** "Good morning"

**Claude:**
```
Good morning! Here's your briefing:

🎯 Today's Priorities (aligned with long-term goals):
1. [Project X - Task A] (2h) → Career Goal: Senior Engineer
2. [Learning Y - Module 3] (1h) → Learning Goal: System Design
3. [Health - Workout] (45m) → Health Goal: Fitness

📅 Schedule:
- 9am-11am: Deep work (Task A)
- 11am-12pm: Learning (Module 3)
- 2pm-3pm: Meetings (already on calendar)
- 5pm-6pm: Workout

📊 Weekly Progress:
- Project X: 60% → 75% (on track)
- System Design: 3/12 modules (ahead of schedule)
- Fitness: 2/4 workouts done this week

💡 Insights:
You've been most productive 9-11am this week. I've scheduled
your hardest task (Task A) during that window.

🔗 Knowledge Connection:
Your notes on "microservices" relate to today's Task A.
I've prepared a summary for reference.

⚠️ Reminder:
Decision pending: "Choose cloud provider for side project"
(in decisions/pending/). Should we address this today?

Ready to begin?
```

### Evening (5 minutes)

**You:** "Daily reflection"

**Claude:**
```
Let's reflect on your day:

✅ Completed:
- [Task A] ✓ (took 2.5h instead of 2h)
- [Learning Module 3] ✓
- [Workout] ✓

Progress updated:
- Project X: 60% → 72% (close to target!)
- System Design: 4/12 modules (accelerated!)
- Fitness: 3/4 workouts this week

🎯 Goal Impact:
Today moved 3 different long-term goals forward.
This kind of balanced progress is optimal.

💭 Reflection Questions:
1. What went well today?
2. What was challenging?
3. What did you learn?
4. What should change tomorrow?

[Your answers recorded to daily/reflections/YYYY-MM-DD.md]

📚 Knowledge Added:
I see you learned about consensus algorithms today.
I've created a note and linked it to your existing
distributed systems knowledge.

Tomorrow's plan is ready. Sleep well!
```

## Setup Time

**Initial Setup:** 1-2 hours
- Define long-term goals across life domains
- Set up knowledge structure
- Establish preferences
- Create first curriculum

**Daily Usage:** 10-15 minutes
- Morning briefing (5 min)
- Evening reflection (5 min)
- Ad-hoc knowledge capture (5 min)

**Weekly Maintenance:** 30 minutes
- Review weekly progress
- Adjust priorities
- Plan next week

**Return on Investment:** Significant productivity gains, reduced decision fatigue, accumulated knowledge, holistic life progress

## Deployment

Run `./deploy_me.sh` and follow prompts.

**Note:** The initial setup wizard will guide you through:
1. Life domains configuration
2. Long-term goal setting
3. Knowledge base initialization
4. Learning curriculum planning
5. Daily routine preferences

## After Deployment

1. Clone your new repository
2. Start Claude Code session
3. Say: "Help me set up Life OS"
4. Complete guided setup (1-2 hours)
5. Start daily practice

## Key Differences from Other Templates

| Feature | Goal Tracker | Knowledge Base | Life OS |
|---------|--------------|----------------|---------|
| Goal tracking | ✅ Deep | ❌ | ✅ Deep |
| Knowledge management | ❌ | ✅ Deep | ✅ Deep |
| Learning system | ❌ | ⚠️ Basic | ✅ Deep |
| Daily planning | ✅ | ❌ | ✅ |
| Cross-domain integration | ❌ | ❌ | ✅ |
| Proactive suggestions | ✅ | ⚠️ Basic | ✅ |
| Decision journaling | ❌ | ❌ | ✅ |
| Complexity | Low | Medium | High |
| Setup time | 10 min | 15 min | 1-2 hours |

## Who Should Use Life OS

**Choose Life OS if you:**
- Want everything integrated
- Value holistic progress tracking
- Enjoy comprehensive systems
- Have time for initial setup
- Want proactive AI assistance
- Accumulate cross-domain knowledge

**Choose simpler templates if you:**
- Need only goals → `goal-tracker/`
- Need only knowledge → `personal-knowledge-base/`
- Want minimal complexity → `basic-repo/`
- Want quick deployment → any simpler template

## Success Stories (Hypothetical Examples)

**Software Engineer + Student:**
- Tracks career goals, learning goals, side projects
- Knowledge base grows with each learning session
- Daily briefings keep all areas progressing
- 6 months: Promoted + completed course + launched side project

**Researcher:**
- Literature notes automatically linked
- Research goals tracked
- Daily writing integrated with knowledge
- 1 year: Published 3 papers with comprehensive knowledge graph

**Entrepreneur:**
- Business goals + personal development
- Decision journal for strategic choices
- Learning new skills while building
- 1 year: Launched product + acquired 10 new skills

## Advanced Features

### Proactive Intelligence
Claude analyzes patterns and proactively suggests:
- "Your learning stagnated—want to switch resources?"
- "Project X blocking Project Y—should we reprioritize?"
- "You're behind on health goals—schedule adjustment?"

### Cross-Domain Synthesis
- "Your notes on negotiation apply to the client meeting tomorrow"
- "This coding pattern relates to system design concepts you learned"
- "Your decision framework from business applies here"

### Knowledge Integration
- New learning automatically linked to existing knowledge
- Gaps identified: "You know X and Z but not Y"
- Synthesis: "Here's how all your distributed systems notes connect"

## Tips for Success

1. **Commit to setup** - Invest the 1-2 hours upfront
2. **Daily practice** - Morning + evening routine is key
3. **Trust the system** - Let Claude guide your day
4. **Capture everything** - All learning goes into knowledge base
5. **Review regularly** - Weekly/monthly reviews maintain quality
6. **Iterate** - Adjust as you discover what works

## When NOT to Use Life OS

- You want something simple and quick
- You don't need cross-domain integration
- Setup time feels too high
- You prefer fragmented tools
- You're just starting with Claude Code

Start with simpler templates, graduate to Life OS later.

---

*Deploy this template to build your personal life operating system!*
