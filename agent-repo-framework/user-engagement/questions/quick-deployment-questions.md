# Quick Deployment Questions

## Purpose
Fast-track questions to deploy a focused, single-purpose repository.

## Time Estimate
30 minutes - 1 hour total

## Target Use Cases
- Goal tracking only
- Knowledge management only
- Research automation only
- Language learning only
- One specific workflow

## Question Flow

### 1. What specific problem are you solving?

**Prompt to user:**
"Describe in one sentence what you want to accomplish with this repository."

**Examples to guide user:**
- "I want to track my career goals and get daily plans"
- "I need to organize research across multiple topics"
- "I'm learning Spanish and need vocabulary/practice tracking"
- "I want to automate competitive research"
- "I need a personal wiki for technical notes"

**What this reveals:**
- Primary use case category
- Scope of the solution
- Level of automation needed

---

### 2. Who will use this?

**Prompt to user:**
"Will this be just for you, shared with a team, or public for others to use?"

**Options:**
- **Just me** - Personal, private repository
- **Share with team** - Collaborative, shared access
- **Public template** - Example for others to clone

**What this affects:**
- Privacy settings
- Documentation style (minimal vs comprehensive)
- Generalization needs (specific vs flexible)

---

### 3. What does success look like?

**Prompt to user:**
"Describe a typical day/week using this system. What would you do, and what outputs would you see?"

**Guide questions:**
- What would you do daily/weekly?
- What outputs do you expect?
- How will you know it's working?

**Examples:**
- "Every morning I get a plan with 3 prioritized tasks aligned to my quarterly goals"
- "When I research a topic, all notes are automatically organized and searchable"
- "Each week I see my vocabulary progress and get personalized practice exercises"

**What this reveals:**
- Workflow patterns (daily, weekly, on-demand)
- Expected outputs (files, reports, notifications)
- Success metrics (what "working" means)

---

### 4. Any specific requirements?

**Prompt to user:**
"Do you have any technical requirements or integrations needed?"

**Common requirements:**
- **Integration needs:** APIs, tools, external services?
- **Data format preferences:** Markdown, JSON, CSV, database?
- **Existing workflows:** Need to match current tools/processes?
- **Automation level:** Fully automated vs manual trigger?

**Examples:**
- "Needs to integrate with Notion API"
- "Must output as CSV for Excel import"
- "Should match my current Obsidian folder structure"
- "Want it to run automatically every morning"

---

### 5. Constraints?

**Prompt to user:**
"What limitations or constraints should we consider?"

**Common constraints:**
- **Time budget:** How much time for setup? For daily maintenance?
- **Technical limitations:** API limits, storage, processing power?
- **Privacy concerns:** Sensitive data, local-only processing?
- **Budget:** Free tools only, or budget for paid services?

**What this affects:**
- Solution complexity (simple vs advanced)
- Tool selection (free vs paid)
- Architecture (cloud vs local, simple vs complex)

---

## Template Matching

Based on answers, recommend from available templates:

### Goal Tracking
- **Template:** `goal-tracker/`
- **Use when:** Needs daily planning, progress tracking, goal alignment
- **Indicators:** Words like "goals", "planning", "progress", "tasks", "priorities"

### Knowledge Management
- **Template:** `personal-knowledge-base/`
- **Use when:** Research accumulation, connected notes, searchable knowledge
- **Indicators:** Words like "notes", "research", "organize", "wiki", "knowledge"

### Research Automation
- **Template:** `research-automation/` (if exists)
- **Use when:** Multi-source research, parallel information gathering
- **Indicators:** Words like "automate", "research", "sources", "competitive", "monitor"

### Language Learning
- **Template:** `language-learning-assistant/` (if exists)
- **Use when:** Vocabulary building, grammar practice, progress tracking
- **Indicators:** Words like "language", "vocabulary", "practice", "learning", "flashcards"

### Custom Build
- **Template:** `basic-repo/`
- **Use when:** None of the above fit, needs custom solution
- **Indicators:** Very specific or unique requirements, combination of use cases

---

## Decision Matrix

| Answer Pattern | Recommended Template |
|----------------|---------------------|
| Goals + Daily Planning + Progress | `goal-tracker/` |
| Research + Notes + Organization | `personal-knowledge-base/` |
| Automation + Data Collection + Monitoring | `research-automation/` |
| Language + Practice + Tracking | `language-learning-assistant/` |
| Mixed/Unique Requirements | `basic-repo/` (custom) |

---

## Next Steps After Questions

### 1. Show recommended template README
```
"Based on your answers, I recommend the [TEMPLATE NAME] template.

Here's what it provides:
[Show template README excerpt]

Does this fit your needs?"
```

### 2. Confirm fit
- **If YES:** Proceed to deployment
- **If NO:** Refine recommendation or suggest custom build
- **If PARTIAL:** Discuss modifications needed

### 3. Deploy
```bash
cd [template-directory]
./deploy_me.sh
```

### 4. Customize
- Walk through configuration options
- Set up initial data/structure
- Run first test workflow

### 5. Handoff
- Provide usage guide
- Show example workflows
- Clarify support/iteration process

---

## Consultation Script Example

**Agent:** "Let's get you set up with the perfect repository for your needs. This should take 30-60 minutes. First question: What specific problem are you solving? For example, are you tracking goals, organizing research, learning a language, or something else?"

**User:** "I want to track my career goals and get daily action items."

**Agent:** "Perfect, that's a great fit for our goal tracking system. Quick follow-ups:
1. Is this just for you, or will you share it with a team?
2. What does a successful morning look like? What would you see when you open this?
3. Any integrations needed, like calendar or task management tools?
4. How much time can you spend on setup today, and how much daily maintenance is acceptable?"

[Continue through questions...]

**Agent:** "Based on your answers, I recommend the `goal-tracker/` template. It provides:
- Quarterly and annual goal setting
- Daily task generation aligned to goals
- Progress tracking and visualization
- Weekly review automation

Does this sound like what you need?"

**User:** "Yes, that's exactly it!"

**Agent:** "Great! Let's deploy it now. [Runs deployment] Your repository is ready. Let me show you how to set your first goals and generate your first daily plan..."

---

## Tips for Effective Consultations

### Keep it focused
- Don't overwhelm with options
- One clear recommendation
- Simple yes/no decisions

### Listen for keywords
- "Track" → Tracking/monitoring features
- "Organize" → Structure/categorization features
- "Automate" → Background processes/scheduling
- "Learn" → Progress tracking/practice features

### Validate understanding
- Repeat back what you heard
- Show example outputs
- Ask "Is this what you mean?"

### Set expectations
- Time required
- What's included vs what's not
- Customization limits
- Support availability

### Fast path to value
- Deploy first, customize later
- Get them to "working" state ASAP
- Iterate based on actual use

---

## Success Metrics

A good quick deployment consultation should:
- ✅ Take 30-60 minutes total (including deployment)
- ✅ Result in a working repository
- ✅ User understands basic usage
- ✅ Clear next steps defined
- ✅ User feels confident to start using it

If it's taking longer or getting complex, consider:
- Simplifying requirements
- Using basic template with plan to iterate
- Scheduling follow-up for advanced features

---

## Common Pitfalls to Avoid

### Over-engineering
- Don't add features "they might want later"
- Start simple, iterate based on usage

### Under-specifying
- Don't skip questions to save time
- Wrong template = wasted deployment time

### Assumption-making
- Don't assume technical level
- Don't assume use patterns
- Always ask, never assume

### Feature creep
- Stick to single purpose
- Defer multi-purpose to comprehensive onboarding
- Say "We can add that later" liberally

---

## When NOT to Use Quick Deployment

Recommend comprehensive onboarding instead if:
- User wants multiple integrated use cases
- Requirements are vague or exploratory
- User needs extensive customization
- User is building for public/team use (needs polish)
- User mentions "not sure exactly" multiple times

Quick deployment is for **clear, focused, single-purpose** repositories. Everything else gets comprehensive treatment.
