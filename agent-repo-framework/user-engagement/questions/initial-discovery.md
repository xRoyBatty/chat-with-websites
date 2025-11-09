# Initial Discovery Questions

## Purpose

These questions help understand what the user needs before recommending a solution approach. The goal is to guide users to the right architecture without overwhelming them with options or under-delivering with a solution that doesn't meet their needs.

**Key Principle:** Match complexity to need. Don't build a spaceship when they need a bicycle.

---

## The Big Question First

### "Do you want a separate focused repository, or an all-in-one integrated system?"

This single question determines the entire consultation path:

| Approach | Setup Time | Use Case | Complexity |
|----------|------------|----------|------------|
| **Separate Focused Repo** | 30 min - 1 hour | Single specific purpose | Low - Deploy and use |
| **All-in-One Life OS** | 5-10 hours setup + ongoing | Multiple interconnected systems | High - Continuous evolution |

**Why this matters:**
- **Separate repos** are like specialized tools: goal tracker, knowledge base, project manager - each does one thing well
- **Life OS** is like an operating system: everything integrates, shares context, evolves together

**Most users should start with separate repos.** You can always build a Life OS later by connecting them.

---

## Understanding Context

### 1. What are you trying to accomplish?

**The Core Question:** What's the main goal?

**Follow-up questions:**
- Is this for work, learning, personal productivity, or hobby?
- Single purpose or multiple interconnected needs?
- What problem are you trying to solve?
- What would success look like in 3 months?

**Red flags for complexity mismatch:**
- User says "I need everything" but can't articulate specific needs → Start simple
- User describes 5+ interconnected workflows → Life OS candidate
- User wants "just a simple thing" but lists complex requirements → Needs education on scope

**Example responses:**

✅ **Good for focused repo:** "I want to track my goals and review them weekly"

✅ **Good for Life OS:** "I want goals that inform my learning, which creates knowledge entries, which feed into projects, which generate new goals..."

⚠️ **Needs clarification:** "I want to be more organized" (too vague)

### 2. What's your background?

**Why we ask:** This calibrates how we explain things, not whether we help.

**Key areas:**
- **Technical skill level:** Non-technical, beginner, intermediate, advanced?
- **Familiar with git/GitHub?** Impacts onboarding steps
- **Comfortable with command line?** Affects how much hand-holding needed
- **Programming experience?** Determines if they can customize later

**Response framework:**
- **Non-technical:** Explain everything, provide exact commands, focus on templates
- **Technical beginner:** Explain concepts, provide guidance, encourage exploration
- **Experienced:** High-level architecture, point to docs, trust their judgment

**Important:** Never gate-keep based on skill level. A non-technical user with clear needs gets just as much support as an experienced developer.

### 3. How much time can you invest?

**Three time horizons:**

#### A. Setup Time
- **Quick (30 min - 1 hour):** Deploy existing template, minimal customization
- **Moderate (2-4 hours):** Deploy + customize + configure integrations
- **Extensive (5-10 hours):** Design from scratch, complex workflows, Life OS

**Ask:** "How much time do you have in the next week to get this set up?"

#### B. Learning Time
- Do you want to understand how it works, or just use it?
- Willing to read documentation?
- Prefer hands-on experimentation or step-by-step guides?

**Ask:** "Would you rather spend time learning the system deeply, or just get started quickly?"

#### C. Ongoing Maintenance
- **Passive:** Set and forget (automation-heavy)
- **Light:** Weekly check-ins (15-30 min/week)
- **Active:** Daily interaction (built into workflow)
- **Intensive:** Continuous evolution (learning system)

**Ask:** "How much time can you dedicate to this weekly?"

**Decision impact:**
- Limited time available → Start with simple template
- Lots of setup time but little maintenance time → Heavy automation focus
- Daily interaction expected → Build it into existing workflows
- Wants to tinker → Give them extensible foundation

### 4. What tools do you have access to?

**Critical infrastructure:**

#### VPS or Cloud Server?
- **Yes:** Full capabilities unlocked
  - Multi-agent systems
  - Persistent workers
  - Complex automations
  - Database-backed systems
- **No:** Local-only or GitHub-only
  - Single-agent workflows
  - Git-based storage
  - Manual triggers
  - File-based data

**Ask:** "Do you have a VPS or cloud server available? If not, is that something you're willing to set up?"

#### API Keys
Common needs:
- **Gemini API:** Free tier available, good for most use cases
- **Other LLM APIs:** OpenAI, Anthropic (if already have access)
- **Service APIs:** Notion, Todoist, etc. (for integrations)

**Ask:** "Do you have API access to any AI services? Which ones?"

#### Development Environment
- **GitHub account?** (Required)
- **Claude Code access?** (Presumably yes if asking)
- **Local development tools?** (VS Code, terminal, etc.)

**Ask:** "Are you comfortable with GitHub? Do you have an account?"

#### Budget for Resources
- **Free tier only:** Work within constraints
- **Small budget ($5-10/month):** VPS + APIs
- **Flexible budget:** Sky's the limit

**Ask:** "Any budget constraints we should work within?"

### 5. Do you want to share this?

**Three sharing models:**

#### Public Repository (Template for Others)
- **Pros:** Help others, showcase work, community feedback
- **Cons:** No sensitive data, extra documentation burden
- **Structure:** Generic examples, clear README, setup automation

**Best for:** Educational projects, tools others could use, portfolio pieces

#### Private Repository (Just for You)
- **Pros:** Complete privacy, personalized to your needs, less documentation
- **Cons:** Solo maintenance, no community input
- **Structure:** Optimized for your workflow, can include personal context

**Best for:** Personal productivity, private journals, confidential work

#### Team Collaboration
- **Pros:** Shared workspace, collaborative features, distributed work
- **Cons:** Access control complexity, coordination overhead
- **Structure:** Multi-agent coordination, clear interfaces, shared knowledge

**Best for:** Team projects, shared research, collaborative writing

**Ask:** "Is this just for you, or will others use/see it?"

**Follow-up based on answer:**
- Public → "What would make this useful for others?"
- Private → "Any sensitive data we need to protect?"
- Team → "How many people? What are their roles?"

### 6. How often will you use this?

**Usage frequency determines architecture:**

#### Daily Use
- **Requirements:** Fast, frictionless, integrated into routine
- **Architecture:** Always-on workers, quick access, minimal friction
- **Examples:** Goal review, knowledge capture, task management

#### Weekly Use
- **Requirements:** Structured reviews, batch processing, summaries
- **Architecture:** Scheduled jobs, digest generation, periodic sync
- **Examples:** Progress reports, weekly planning, knowledge synthesis

#### Occasional Use
- **Requirements:** Easy to pick up after breaks, clear state
- **Architecture:** Simple interfaces, good documentation, state persistence
- **Examples:** Project kickoffs, quarterly reviews, research sprints

#### Continuous Background
- **Requirements:** Autonomous operation, error resilience, monitoring
- **Architecture:** Persistent workers, health checks, automatic recovery
- **Examples:** News monitoring, data collection, automated analysis

**Ask:** "How often do you expect to interact with this system?"

**Follow-up:** "What would a typical interaction look like?"

---

## Decision Path

Based on answers above, guide the user down the appropriate path:

### Path A: Quick Deployment (Focused Repository)

**Trigger conditions:**
- User wants ONE specific thing
- Limited setup time available
- Clear, simple use case
- Wants to get started fast

**Example:** "I just need goal tracking"

**Next steps:**
1. Go to `quick-deployment-questions.md`
2. Select appropriate template
3. Customize minimally
4. Deploy and test
5. Done in 30-60 minutes

**Available templates:**
- Goal Tracker
- Personal Knowledge Base
- Project Manager
- Learning Journal
- Habit Tracker
- Research Assistant
- (More as framework grows)

**Advantages:**
- Fast deployment
- Proven patterns
- Low complexity
- Easy to understand
- Quick wins

**Limitations:**
- Less customization
- Single purpose
- Manual integration with other tools
- Limited extensibility

### Path B: Life OS (Integrated System)

**Trigger conditions:**
- User wants MULTIPLE interconnected systems
- Willing to invest significant setup time
- Needs systems to share context
- Wants comprehensive solution
- Has ongoing time for evolution

**Example:** "I want goals + learning + projects + knowledge management, all working together"

**Next steps:**
1. Go to `life-os-questions.md`
2. Deep interview process
3. Architecture design session
4. Phased implementation plan
5. Iterative development
6. Continuous evolution

**Components might include:**
- Goal tracking
- Knowledge management
- Project coordination
- Learning system
- Habit tracking
- Research automation
- Writing assistant
- Decision journal
- Health tracking
- Financial planning
- (Customized to user needs)

**Advantages:**
- Everything integrated
- Shared context across systems
- Powerful automations
- Grows with you
- Highly personalized

**Challenges:**
- Significant time investment
- Ongoing maintenance
- Complexity management
- Requires commitment
- Learning curve

### Path C: User is Unsure

**Common scenario:** User isn't sure what they need yet.

**Approach:**

1. **Explain the trade-offs clearly:**

   "Think of it like buying software:

   - **Focused repo** = Buying Microsoft Word. It does one thing (documents) really well. Quick to start, easy to use.

   - **Life OS** = Building your own operating system. Everything works together exactly how you want, but takes significant time to build and maintain.

   Most people should start with the focused approach."

2. **Recommend starting simple:**

   "I recommend starting with a focused repository for your most pressing need. You can always:
   - Add more repos later (they can still work together)
   - Migrate to a Life OS when you're ready
   - Connect existing repos into an integrated system

   Starting simple means you get value immediately while learning how these systems work."

3. **Identify the highest-impact need:**

   "What's the ONE thing that, if you had it working smoothly, would make the biggest difference in your daily life right now?"

4. **Start there:**

   Once identified, move to Path A (Quick Deployment) for that specific need.

---

## Conversation Flow Example

Here's how a good discovery conversation might flow:

**Agent:** "Before we dive in, I need to understand what you're looking for. The big question is: **Do you want a focused repository for one specific purpose, or an all-in-one integrated system that handles multiple interconnected needs?**

Think of it like buying a specialized tool vs. building a workshop. What sounds more like what you need?"

**User:** "I'm not sure. I want to track my goals, but also manage my projects and capture what I learn..."

**Agent:** "Got it. Those could be separate tools that work together, or one integrated system. Let me ask a few more questions:

1. How much time can you invest in setup? Are we talking 30 minutes, or are you willing to spend a few days building something comprehensive?
2. How often would you use this? Daily, weekly, or occasionally?
3. Do these things need to share information? For example, does a project completion update your goals, or does learning something create a knowledge entry that informs your projects?"

**User:** "I can spend maybe an hour this weekend. I'd use it daily. And yes, they should share information - when I complete a project, that should count toward my goal progress."

**Agent:** "Perfect. Based on that, I recommend we start with a **Goal Tracker** that has some project management built in. We can deploy it in under an hour, and it'll handle both goals and projects with automatic connections between them.

Later, if you want to add knowledge management or other features, we can either:
- Add them to this repo, or
- Create separate repos that talk to this one

Sound good? If so, let me ask a few more quick questions to customize the goal tracker for you..."

**User:** "Yes, let's do that!"

**Agent:** *Proceeds to quick-deployment-questions.md*

---

## Red Flags and How to Handle

### 🚩 "I want everything but have no time"

**Response:** "I hear you! Let's prioritize. If you could only have ONE thing working perfectly right now, what would make the biggest impact? We'll start there and add more later."

### 🚩 "I'm not technical at all, is this for me?"

**Response:** "Absolutely! The templates are designed to work out of the box. I'll give you exact commands to run - you just copy and paste. Think of it like installing an app, not building one."

### 🚩 "Can this do [impossibly complex thing]?"

**Response:** "That's an interesting challenge. Let's break it down into pieces and see what's possible. What's the core functionality you need first?"

### 🚩 "I tried something like this before and it didn't work"

**Response:** "I appreciate you sharing that. What happened? Understanding what didn't work will help us avoid those pitfalls this time."

### 🚩 "How much will this cost?"

**Response:** "The code and templates are free. You might need:
- GitHub account (free)
- Claude Code access (you already have this)
- Optional: VPS for advanced features ($5-10/month)
- Optional: API keys (many have free tiers)

What's your comfort level with those?"

### 🚩 "Will this always work, or will it break?"

**Response:** "Great question. The templates are tested and stable. That said, any system needs occasional maintenance:
- GitHub changes: Rare, usually backward compatible
- API changes: We'll document how to update
- Your needs change: The system evolves with you

Think of it like a garden - plant it once, water occasionally, enjoy continuously."

---

## Success Criteria

A good initial discovery conversation results in:

✅ **Clear path selected:** Quick deployment OR Life OS OR specific next questions

✅ **User expectations set:** They know what to expect for time, complexity, capabilities

✅ **Blockers identified:** Missing tools, API keys, or skills documented

✅ **Excitement maintained:** User is motivated to continue, not overwhelmed

✅ **Next steps clear:** Both you and user know exactly what happens next

---

## Next Documents

Based on the decision path:

**Path A (Quick Deployment):**
→ Continue to `quick-deployment-questions.md`

**Path B (Life OS):**
→ Continue to `life-os-questions.md`

**Path C (Still Exploring):**
→ Share examples: `../examples/goal-tracker-showcase.md`
→ Or provide comparison: `../comparisons/focused-vs-integrated.md`

---

## Notes for Agents

**Remember:**
- This is a conversation, not an interrogation
- Adapt questions based on user's responses
- Skip questions if answer is already clear
- Combine questions that make sense together
- Use examples liberally
- Match user's energy and technical level
- Goal is clarity, not completion of all questions

**Common mistakes:**
- ❌ Asking all questions robotically
- ❌ Overwhelming user with options
- ❌ Under-promising when they want more
- ❌ Over-promising when they want simple
- ❌ Not listening to what they actually need

**Best practices:**
- ✅ Active listening
- ✅ Reflective responses ("So what I'm hearing is...")
- ✅ Examples from similar use cases
- ✅ Clear trade-offs explained
- ✅ Enthusiasm matched to user's energy
- ✅ Concrete next steps

**You're a guide, not a gatekeeper. Help users find the right solution for THEIR needs, not the most impressive solution you can build.**

---

*Last updated: 2025-11-09*
