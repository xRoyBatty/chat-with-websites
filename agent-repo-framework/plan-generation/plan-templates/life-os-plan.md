# Life OS Plan Template

A comprehensive template for building integrated Life Operating Systems covering multiple interconnected domains and life areas.

---

## User Profile Summary

**Name:** [USER_NAME]
**Vision Statement:** [CONCISE_VISION_STATEMENT]
**Life Stage:** [LIFE_STAGE: student/early-career/mid-career/family/sabbatical/retirement]
**Primary Challenges:** [TOP_3_CURRENT_CHALLENGES]

### Core Values
- [VALUE_1]
- [VALUE_2]
- [VALUE_3]

### Success Metrics (12-month)
- [METRIC_1]: [TARGET]
- [METRIC_2]: [TARGET]
- [METRIC_3]: [TARGET]

---

## Domains to Include

### Domain Checklist
- [ ] **Health & Wellness** - Physical health, mental wellbeing, fitness tracking
- [ ] **Knowledge** - Learning system, research notes, skill development
- [ ] **Projects** - [SPECIFIC_PROJECTS_LIST]
- [ ] **Goals & Planning** - Strategic goals, quarterly planning, progress tracking
- [ ] **Work & Career** - Professional development, job search, portfolio
- [ ] **Finance** - Budget, investments, spending patterns, financial goals
- [ ] **Relationships** - Contacts, relationship management, communication logs
- [ ] **Automation** - Workflows, task management, habit tracking
- [ ] **Content** - Writing, media, creative work, publishing
- [ ] **Time & Calendar** - Schedule optimization, energy patterns, time blocking
- [ ] **[CUSTOM_DOMAIN_1]** - [DESCRIPTION]
- [ ] **[CUSTOM_DOMAIN_2]** - [DESCRIPTION]

### Selected Domains for Phase 1
1. [DOMAIN_A] - Justification: [WHY_FIRST]
2. [DOMAIN_B] - Justification: [WHY_SECOND]
3. [DOMAIN_C] - Justification: [WHY_THIRD]

### Domain Interdependencies
```
[DOMAIN_A] ←→ [DOMAIN_B]
   ↓          ↓
[CENTRAL_COORDINATION_POINT]
   ↑          ↑
[DOMAIN_C] ←→ [DOMAIN_D]
```

Example flow: Health insights inform Goal prioritization; Goals drive Project planning; Project status affects Time allocation.

---

## Repository Architecture

```
life-os-[USER_NAME]/
├── CLAUDE.md                          # Orchestration strategy
├── TO_DO.md                           # Implementation roadmap
├── docs/
│   ├── system-overview.md             # Architecture diagram
│   ├── domain-specs/
│   │   ├── [DOMAIN_A]-spec.md
│   │   ├── [DOMAIN_B]-spec.md
│   │   └── [DOMAIN_C]-spec.md
│   ├── api-guide.md                   # VPS API usage
│   └── evolution-strategy.md          # Long-term growth plan
├── datasets/                          # Core data store
│   ├── user-profile.json              # Demographics, preferences
│   ├── preferences.json               # System behavior config
│   ├── tools-inventory.json           # Connected services/tools
│   ├── integration-settings.json      # API keys, credentials (encrypted)
│   ├── communication-history.jsonl    # Agent-to-agent comms
│   └── domain-data/
│       ├── health/
│       │   ├── metrics.json
│       │   ├── habits.json
│       │   └── goals.json
│       ├── knowledge/
│       │   ├── learning-goals.json
│       │   ├── research-topics.json
│       │   └── skill-map.json
│       ├── projects/
│       │   ├── [PROJECT_NAME]/
│       │   │   ├── spec.md
│       │   │   ├── status.json
│       │   │   └── artifacts/
│       │   └── projects-index.json
│       ├── goals/
│       │   ├── yearly-goals.json
│       │   ├── quarterly-goals.json
│       │   └── goal-progress.json
│       └── [OTHER_DOMAINS]/
├── workflows/                         # Automation & orchestration
│   ├── daily-standup.py               # Morning review
│   ├── weekly-review.py               # Sunday planning
│   ├── domain-sync.py                 # Cross-domain alignment
│   ├── insight-generation.py          # Intelligence engine
│   └── [CUSTOM_WORKFLOW].py
├── templates/
│   ├── DAILY_AGENT_CLAUDE.md          # Daily execution agent
│   ├── WEEKLY_AGENT_CLAUDE.md         # Weekly review agent
│   ├── [DOMAIN_A]_AGENT_CLAUDE.md     # Domain specialist
│   └── [DOMAIN_B]_AGENT_CLAUDE.md
├── .claude/
│   ├── settings.json                  # Session configuration
│   ├── hooks/
│   │   ├── worker-stop-check.py       # VPS persistence
│   │   └── context-isolation-check.py # Multi-agent safety
│   └── skills/
│       ├── vps-interface/
│       │   ├── skill.md
│       │   └── vps_helper.py
│       └── life-os-core/
│           ├── skill.md
│           └── life_os_functions.py
└── README.md                          # User entry point
```

---

## datasets/ Structure

### user-profile.json
```json
{
  "user_id": "[USER_ID]",
  "name": "[USER_NAME]",
  "email": "[USER_EMAIL]",
  "timezone": "[TIMEZONE]",
  "age": [AGE],
  "life_stage": "[LIFE_STAGE]",
  "location": "[LOCATION]",
  "work_status": "[EMPLOYMENT_STATUS]",
  "family_status": "[FAMILY_STATUS]",
  "created_date": "[ISO_DATE]",
  "last_major_review": "[ISO_DATE]",
  "learning_style": "[VISUAL/AUDITORY/KINESTHETIC/READING]",
  "communication_preference": "[PREFERENCE]",
  "timezone_offset": "[UTC_OFFSET]"
}
```

### preferences.json
```json
{
  "daily_standup_time": "[HH:MM]",
  "weekly_review_day": "[DAY_OF_WEEK]",
  "weekly_review_time": "[HH:MM]",
  "default_planning_horizon": [DAYS],
  "notification_frequency": "[FREQUENCY]",
  "automation_aggressiveness": "[LOW/MEDIUM/HIGH]",
  "cross_domain_insights": [true/false],
  "voice_preference": "[VOICE_ID]",
  "verbose_logging": [true/false],
  "vps_sync_interval_minutes": [INTERVAL]
}
```

### tools-inventory.json
```json
{
  "integrated_services": [
    {
      "name": "[SERVICE_NAME]",
      "type": "[calendar/notes/finance/health/automation]",
      "api_available": true,
      "sync_frequency": "[FREQUENCY]",
      "status": "[connected/pending/disabled]"
    }
  ],
  "external_apis": [
    {"service": "[SERVICE]", "endpoint": "[ENDPOINT]", "key_stored": true}
  ]
}
```

---

## CLAUDE.md Orchestration Strategy

### Execution Pattern: Coordinator + Domain Agents

**Coordinator Role:** [COORDINATOR_AGENT_NAME]
- Manages task queue
- Monitors domain agents
- Synthesizes insights across domains
- Triggers weekly/monthly reviews
- Maintains system health

**Domain Agents:** One per primary domain
- [DOMAIN_A]: [AGENT_NAME_A] - [RESPONSIBILITIES]
- [DOMAIN_B]: [AGENT_NAME_B] - [RESPONSIBILITIES]
- [DOMAIN_C]: [AGENT_NAME_C] - [RESPONSIBILITIES]

### Workflow Triggers
- **Daily (6am):** Daily standup agent reviews yesterday, previews today
- **Weekly ([DAY] 10am):** Weekly review agent synthesizes domain progress
- **On-Demand:** User can trigger domain deep-dives anytime
- **Automated:** [CUSTOM_TRIGGERS]

### Context Isolation Rules
- Agents cannot share conversation history
- All communication via task queue files
- Domain specialists have read-access to: own domain + user-profile.json + preferences.json
- Only coordinator reads all domains
- Instructions are self-contained in task files

### Inter-Agent Communication
- Coordinator writes to `tasks/` directory with detailed instructions
- Agents write results to `outputs/` directory
- Status updates via `agent-status.jsonl`
- Insights shared via `datasets/` JSON files

---

## Phase-by-Phase Build Plan

### Phase 1: Foundation ([DURATION])
**Domains:** [DOMAIN_A], [DOMAIN_B]
**Goal:** Establish core data model and basic automation

1. Create user-profile.json and preferences.json
2. Build [DOMAIN_A] data structure and initial agent
3. Build [DOMAIN_B] data structure and initial agent
4. Implement daily standup workflow
5. Test multi-agent communication via task queue

**Success Metrics:**
- [ ] All datasets populated with starter data
- [ ] Daily standup executes successfully
- [ ] No context isolation violations

### Phase 2: Extension ([DURATION])
**Domains:** [DOMAIN_C], [DOMAIN_D]
**Goal:** Expand coverage and add cross-domain intelligence

1. Onboard [DOMAIN_C] with specialist agent
2. Onboard [DOMAIN_D] with specialist agent
3. Build weekly review workflow synthesizing all domains
4. Implement insight engine for pattern detection
5. Add proactivity configuration

**Success Metrics:**
- [ ] Weekly review produces actionable insights
- [ ] Cross-domain patterns detected (2+ examples)
- [ ] User reports improved decision-making

### Phase 3: Intelligence ([DURATION])
**Goal:** Add predictive capabilities and automation

1. Build predictive models for [KEY_METRIC]
2. Implement habit formation tracking
3. Add anomaly detection (health, spending, etc.)
4. Create automated recommendation system
5. Build long-term trend analysis

**Success Metrics:**
- [ ] Predictions meet [ACCURACY_THRESHOLD]%
- [ ] Automated recommendations generated weekly
- [ ] User accepts [ACCEPTANCE_RATE]% of suggestions

### Phase 4: Optimization ([DURATION])
**Goal:** Maximize value and user engagement

1. Performance tuning on VPS
2. User experience improvements
3. Custom domain additions per feedback
4. Advanced automation workflows
5. Evolution strategy implementation

**Success Metrics:**
- [ ] System response time < [MS]
- [ ] User engagement daily: [TARGET]%
- [ ] ROI metrics show [EXPECTED_VALUE]

---

## File-Based Memory System

### Long-Term Memory (Persistent)
- **Location:** `datasets/` directory
- **Update Frequency:** [FREQUENCY]
- **Retention:** Permanent, versioned
- **Example:** goals.json, skill-map.json, project-history.json

### Working Memory (Session)
- **Location:** Task queue files in `tasks/` + `outputs/`
- **Lifetime:** Single agent session
- **Accessed by:** Single agent only
- **Auto-cleanup:** After task completion

### Episodic Memory (Event Log)
- **Location:** `datasets/communication-history.jsonl`
- **Format:** One JSON per line, chronological
- **Contains:** Agent actions, decisions, outcomes
- **Retention:** [DURATION]
- **Query:** Agent reads recent entries for context

### Semantic Memory (Knowledge Base)
- **Location:** `docs/domain-specs/`, markdown files
- **Type:** Structured knowledge about domains
- **Updates:** When user-driven changes occur
- **Access:** All agents can read (read-only)

---

## Cross-Domain Intelligence Patterns

### Pattern 1: Goal → Project → Time Cascade
```
Goals domain generates quarterly objective
  ↓ (triggers)
Projects domain creates project to achieve goal
  ↓ (triggers)
Time domain allocates weekly hours
  ↓ (triggers)
Health domain adjusts sleep/exercise to support capacity
```

### Pattern 2: Insight Synthesis
```
Health reports: Energy pattern (low 2-4pm)
Work reports: Meetings clustered 1-3pm
Finance reports: Spending patterns (coffee at 3:30pm)
  ↓ (synthesized by coordinator)
Recommendation: Move meetings to morning; schedule coffee at 4pm break
```

### Pattern 3: Risk Detection
```
Projects: Task delays accumulating
Goals: Quarterly milestone at risk
Health: Sleep quality declining
Finance: Overbudget in entertainment
Knowledge: Study time under target
  ↓ (coordinator alerts)
Action required: Escalate project risk; address health baseline; refocus on goals
```

### Pattern 4: Opportunity Discovery
```
Knowledge: Just completed ML course
Projects: No active AI/ML projects
Finance: Budget available for side project
Goals: Income growth target
Time: 5 hours/week available
  ↓ (coordinator suggests)
Opportunity: Launch ML consulting side project
```

---

## Proactivity Configuration

### Level 1: Passive (No Proactive Suggestions)
- Agents respond only to explicit user requests
- No automated recommendations
- Status-only updates

### Level 2: Notifications (Alerts Only)
- Alerts when anomalies detected (health dips, budget overrun, missed habits)
- Weekly review happens automatically
- No action suggestions

### Level 3: Moderate Proactivity (Suggestions + Insights)
- Agents generate 2-3 suggestions per week
- Predictive alerts (based on trends)
- Automated habit nudges
- Smart scheduling recommendations

### Level 4: High Proactivity (Autonomous Action)
- Agents auto-execute low-risk tasks (calendar blocking, habit reminders, budget rebalancing)
- Proactive outreach (check-ins, adjustment suggestions)
- Continuous optimization
- Requires explicit approval thresholds

**Current Proactivity Level:** [LEVEL]
**Recommendations By Domain:**
- Health: [LEVEL]
- Goals: [LEVEL]
- Projects: [LEVEL]
- Finance: [LEVEL]
- [OTHER_DOMAIN]: [LEVEL]

---

## Testing & Validation Plan

### Unit Tests (Per Domain)
```bash
# Health domain data integrity
python tests/test_health_data.py

# Projects status calculation
python tests/test_projects_logic.py

# Goal progress tracking
python tests/test_goals_tracking.py
```

### Integration Tests (Cross-Domain)
```bash
# Can coordinator read all domains?
python tests/test_coordinator_access.py

# Do daily standup workflows complete?
python tests/test_daily_workflow.py

# Can agents communicate via queue?
python tests/test_agent_comms.py
```

### End-to-End Tests (Full Workflow)
1. **Setup:** Populate all datasets with test data
2. **Daily Test:** Run daily standup, validate output
3. **Weekly Test:** Run weekly review, validate synthesis
4. **Cross-Domain Test:** Trigger pattern detection, validate insights
5. **Validation:** User review of recommendations

### Acceptance Criteria
- [ ] All unit tests pass
- [ ] All integration tests pass
- [ ] Daily workflow executes without errors
- [ ] Weekly review produces [N] meaningful insights
- [ ] No context isolation violations
- [ ] User confirms system accuracy: [THRESHOLD]%

---

## Evolution Strategy

### Quarterly Reviews ([DATES])
- Review system effectiveness: Are agents meeting SLAs?
- Analyze user feedback: What's working? What's not?
- Update domains: Add new domains or retire inactive ones
- Refresh agents: Update instructions, improve prompts
- Measure ROI: Hours saved, decisions improved, goals achieved

### Annual Refresh ([DATE])
- Conduct deep user re-interview
- Reassess life stage and priorities
- Refactor repository architecture if needed
- Upgrade automation capabilities
- Plan major feature additions

### Continuous Improvements
- **Bug Fixes:** Address agent errors immediately
- **Performance:** Monitor VPS load and response times
- **User Feedback:** Weekly polling on system usefulness
- **New Domains:** Fast-track promising new areas
- **Tool Integration:** Add new external services as needed

### Success Evolution
As system matures:
- Shift from data collection → insight generation
- Shift from manual input → automated capture
- Shift from notifications → proactive action
- Shift from single coordinator → specialized teams
- Shift from reactive → predictive

### Scaling Strategy (Future)
- **Multi-Agent Teams:** Separate agents per domain with specialists
- **Real-Time Sync:** Continuous data updates vs. scheduled
- **Advanced ML:** Predictive models and trend analysis
- **External Integration:** Direct API connections to tools
- **Voice Interface:** Natural language interaction layer

---

## Success Metrics Summary

### System Health
- Uptime: [TARGET]%
- Agent response time: < [MS]
- Data consistency: 99.9%

### User Engagement
- Daily usage: [TARGET] minutes
- Weekly review completion: [TARGET]%
- Automation adoption: [TARGET] workflows active

### Domain Progress
- Goals on-track: [TARGET]%
- Projects completing on-time: [TARGET]%
- Skills acquired: [TARGET] per quarter

### Business Value
- Decisions improved: [METRIC]
- Time saved: [HOURS] per week
- Stress reduced: [METRIC]
- Financial impact: [METRIC]

---

## Next Steps

1. **Customize this template** with [BRACKETS] filled in
2. **Create CLAUDE.md** using orchestration strategy section
3. **Initialize datasets/** with starter data
4. **Build Phase 1** starting with domain A
5. **Test and iterate** following validation plan

**Prepared by:** [YOUR_NAME]
**Date:** [DATE]
**Last Updated:** [DATE]
