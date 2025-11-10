# Researcher & Student Profile

## Who They Are

**Academic Researchers:**
- Graduate students (Master's, PhD)
- Postdoctoral researchers
- Faculty conducting research
- Research assistants

**Professional Researchers:**
- Industry R&D
- Think tanks
- Policy research
- Market research

## Common Pain Points

1. **Information Overload**
   - Reading 20-50 papers per month
   - Can't remember what they read
   - Can't find notes when needed
   - Duplicate effort (re-reading same concepts)

2. **Fragmented Knowledge**
   - Notes in multiple places (Zotero, Notion, Google Docs, paper notebooks)
   - No connections between related concepts
   - Hard to synthesize across topics
   - Difficult to write literature reviews

3. **Research Workflows**
   - Manual citation management
   - Copy-paste from papers to notes
   - Organizing by topic/project manually
   - Time-consuming literature reviews

4. **Collaboration Challenges**
   - Sharing findings with team
   - Tracking who contributed what
   - Version control for collaborative writing
   - Keeping everyone updated

## Typical Needs

### Core Need: Knowledge Management
- Store and organize research notes
- Link related concepts across papers
- Quick search and retrieval
- Synthesis for literature reviews

### Secondary Needs:
- **Citation management** - Track sources, generate bibliographies
- **Collaborative writing** - Co-author papers with version control
- **Progress tracking** - Research milestones, publication deadlines
- **Learning** - New methodologies, statistical techniques, domain expertise

## Recommended Solutions

### Quick Deployment: Personal Knowledge Base
**Template:** `personal-knowledge-base/`

**Why it fits:**
- Atomic notes for each concept
- Auto-linking related ideas
- Topic organization
- Search across all notes

**Setup time:** 30 minutes
**Daily use:** 10-15 minutes (adding notes after reading)
**Value:** Find information 10x faster, better synthesis

### Life OS: Research Operating System
**Template:** `life-os/` customized for research

**Domains to include:**
- `knowledge/` - Research notes and literature
- `projects/` - Current research projects
- `writing/` - Papers, proposals in progress
- `learning/` - Methods, statistics, domain knowledge
- `datasets/` - Preferences, research focus areas
- `collaboration/` - Shared notes, team updates

**Setup time:** 5-8 hours
**Daily use:** 20-30 minutes
**Value:** Comprehensive research management, proactive assistance

## Tool Suggestions

**Skills:**
- `literature-search/` - Automated paper finding
- `citation-formatter/` - Bibliography generation
- `note-linker/` - Auto-link related concepts
- `synthesis-generator/` - Literature review drafts

**Subagents:**
- Research assistant subagent - Parallel paper summarization
- Literature review generator - Synthesize notes into review sections

**Async Workflows:**
- Background literature searches - Find papers while you work
- Overnight synthesis - Generate literature review drafts

**VPS:**
- Not typically needed unless:
  - Running analysis code (R, Python, MATLAB)
  - Large dataset processing
  - Computational research

## Success Metrics

**After 1 month:**
- 50-100+ notes accumulated
- Finding information in <30 seconds
- Literature reviews 50% faster

**After 3 months:**
- 200-300+ notes
- Clear knowledge graph emerging
- Writing improved (better citations, synthesis)

**After 6 months:**
- 400-500+ notes
- Research domain expertise documented
- Significant time savings (5-10 hours/week)

## Implementation Priorities

**Phase 1 (Week 1):**
1. Set up knowledge base structure
2. Migrate 20-30 most important notes
3. Test search and linking
4. Establish daily note-taking habit

**Phase 2 (Weeks 2-4):**
1. Add citation management
2. Create project organization
3. Set up literature review templates
4. Add synthesis tools

**Phase 3 (Months 2-3):**
1. Add collaborative features (if needed)
2. Implement automated searches
3. Create paper writing workflows
4. Optimize based on usage

## Warning Signs This Profile Doesn't Fit

- User doesn't read many papers (< 5/month)
- Notes are simple todos, not knowledge
- No need for synthesis or connections
- Prefers existing tools (Zotero, Notion) and they work well

If these apply, consider simpler solution or different profile.

## Example User Stories

**PhD Student - Biology:**
"I'm reading 30 papers a month for my dissertation. I can't remember what I read last month. Literature review is taking forever."

→ Deploy personal-knowledge-base
→ Add citation formatter skill
→ Set up synthesis automation
→ Result: Literature review time cut by 60%

**Industry Researcher - AI:**
"I track developments in 5 AI subfields. Need to brief executives monthly. Can't keep up with papers + implementation news."

→ Deploy Life OS with knowledge + projects
→ Add automated literature monitoring
→ Set up monthly synthesis reports
→ Result: Briefings from 8 hours → 2 hours

Write this file with practical, actionable guidance.
