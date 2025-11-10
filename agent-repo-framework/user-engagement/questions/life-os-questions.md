# Life Operating System Questions

## Purpose
Deep interview to design a comprehensive, integrated personal AI system.

## Time Estimate
- Initial interview: 2-3 hours
- Incremental build: 5-10 hours over multiple sessions
- Never "done" - evolves continuously

## Target Users
- Want to improve across multiple life areas
- Willing to invest setup time for long-term value
- Regular Claude Code users (weekly or more)
- Building for personal use (not sharing)

## Interview Structure

### Part 1: Life Context (30-45 min)

**1.1 Who are you?**
- Background (career, education, interests)
- Current role and responsibilities
- Stage of life (student, professional, entrepreneur, retired)
- Constraints (time, resources, commitments)

**1.2 What are your long-term goals?** (Critical - everything aligns to this)
- Career aspirations (5-10 year vision)
- Learning goals (skills to acquire)
- Personal development (health, relationships, habits)
- Projects or creations (what do you want to build?)
- Financial goals (if relevant)

**1.3 What's your schedule?**
- Work hours (when are you busy?)
- Free time (when can you focus?)
- Screen time preferences (minimize or maximize?)
- Daily routines (morning, evening habits)

**1.4 What frustrates you currently?**
- Pain points in current workflows
- Things that take too much time
- Repetitive tasks
- Information overload
- Decision fatigue

### Part 2: Domain Needs (45-60 min)

For each domain, ask:
- Do you need this?
- How important (critical, helpful, nice-to-have)?
- Current approach (what do you do now)?
- Ideal outcome (what would perfect look like)?

**2.1 Knowledge Management**
- Taking notes from reading/learning?
- Research across topics?
- Need to find information later?
- Building expertise in domain(s)?

**2.2 Goal Tracking & Planning**
- Long-term goals defined?
- Daily/weekly planning?
- Progress tracking?
- Accountability needs?

**2.3 Project Development**
- Building applications/scripts?
- Need automation?
- Code generation?
- Testing and deployment?

**2.4 Learning & Skill Development**
- Learning new skills?
- Courses or self-study?
- Practice needed?
- Progress tracking?

**2.5 Automation & Efficiency**
- Daily routines to automate?
- Background tasks?
- Tool integrations needed?
- Minimize screen time?

**2.6 Content Creation** (if applicable)
- Writing (blog, documentation)?
- Teaching materials?
- Social media content?
- Research summaries?

### Part 3: Technical Context (15-20 min)

**3.1 Available Tools**
- VPS or cloud server access?
- API keys (Gemini CLI, other services)?
- Development environment setup?
- Budget for resources?

**3.2 Technical Comfort**
- Git/GitHub familiarity?
- Command line usage?
- Programming experience?
- Willing to learn new tools?

**3.3 Preferences**
- File formats (Markdown, JSON, databases)?
- UI preferences (minimal, detailed)?
- Notification style?
- Privacy requirements?

### Part 4: System Design (20-30 min)

**4.1 Architecture Discussion**
Based on their needs, propose structure:
```
your-life-os/
├── [domains they need]
├── datasets/ (required - your profile, preferences, tools)
├── context/ (required - cross-domain connections)
└── .claude/ (required - orchestration)
```

Show how domains interconnect via file cross-references.

**4.2 Proactivity Level**
- Daily greetings with context?
- Automatic task suggestions?
- Background task generation?
- Weekly summaries?

**4.3 Evolution Strategy**
- Build all at once or incrementally?
- Which domain to start with?
- Dependency order?

## Deliverables from Interview

After deep interview, create:

1. **`datasets/user-profile.md`** - Complete profile from interview
2. **`.claude/CLAUDE.md`** - Master orchestrator tailored to user
3. **`.claude/TODO.md`** - Phased build plan (20-50 tasks)
4. **Initial domain structure** - Directories for needed domains

## Example TODO.md Structure

```markdown
# Life OS Build Plan

## Phase 1: Foundation
- [ ] Set up datasets/ with user profile
- [ ] Create CLAUDE.md orchestrator
- [ ] Test session-start file reading

## Phase 2: Domain 1 (e.g., Goals)
- [ ] Create goals/ structure
- [ ] Implement goal tracking
- [ ] Add proactive planning
- [ ] Test goal-driven suggestions

## Phase 3: Domain 2 (e.g., Knowledge)
- [ ] Create knowledge/ structure
- [ ] Set up note-taking
- [ ] Add linking system
- [ ] Test knowledge queries

[Continue for each domain...]

## Phase N: Integration
- [ ] Add cross-domain connections
- [ ] Implement proactive intelligence
- [ ] Create automation layer
- [ ] Full system test
```

## Important Notes

- **Don't overwhelm**: Build incrementally, one domain at a time
- **Test frequently**: Each domain should add immediate value
- **Iterate**: Adjust based on actual usage
- **Evolve continuously**: Never "finished", always improving

Write this file to enable deep, effective Life OS consultations.
