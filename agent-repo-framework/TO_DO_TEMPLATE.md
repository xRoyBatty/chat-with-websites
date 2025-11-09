# TODO Template for Custom Repositories

Use this template when planning implementation of a custom Claude Code repository.

---

## Project: [PROJECT_NAME]

**Created:** [DATE]
**Target Completion:** [DATE]
**Current Phase:** [PHASE_NAME]

---

## Overview

**Purpose:** [Brief description of what this repository does]

**Success Criteria:**
- [ ] [Measurable outcome 1]
- [ ] [Measurable outcome 2]
- [ ] [Measurable outcome 3]

---

## Phase 1: Foundation

**Goal:** [What this phase accomplishes]
**Duration:** [Estimated time]

### Tasks

- [ ] Set up repository structure
  - [ ] Create `.claude/` directory
  - [ ] Create main directories
  - [ ] Initialize git repository

- [ ] Create CLAUDE.md
  - [ ] Define agent role and responsibilities
  - [ ] Specify file-reading patterns
  - [ ] Document workflows

- [ ] Set up core data files
  - [ ] `datasets/user-profile.md` (if applicable)
  - [ ] `datasets/preferences.md` (if applicable)
  - [ ] Configuration files

- [ ] Test foundation
  - [ ] Verify CLAUDE.md is read on session start
  - [ ] Test basic workflows
  - [ ] Validate directory structure

**Phase 1 Complete When:**
- [ ] Repository structure matches plan
- [ ] CLAUDE.md orchestrates correctly
- [ ] Basic functionality works

---

## Phase 2: Core Features

**Goal:** [What this phase accomplishes]
**Duration:** [Estimated time]

### Tasks

- [ ] Implement primary feature 1
  - [ ] [Subtask]
  - [ ] [Subtask]
  - [ ] Test and validate

- [ ] Implement primary feature 2
  - [ ] [Subtask]
  - [ ] [Subtask]
  - [ ] Test and validate

- [ ] Create supporting utilities
  - [ ] [Helper script/skill]
  - [ ] [Helper script/skill]

- [ ] Integration testing
  - [ ] Test features working together
  - [ ] Validate data flows
  - [ ] Check error handling

**Phase 2 Complete When:**
- [ ] All core features implemented
- [ ] Integration tests pass
- [ ] System provides value to user

---

## Phase 3: Enhancement

**Goal:** [What this phase accomplishes]
**Duration:** [Estimated time]

### Tasks

- [ ] Add advanced feature 1
  - [ ] [Subtask]
  - [ ] [Subtask]
  - [ ] Test and validate

- [ ] Add advanced feature 2
  - [ ] [Subtask]
  - [ ] [Subtask]
  - [ ] Test and validate

- [ ] Optimize workflows
  - [ ] Reduce manual steps
  - [ ] Improve automation
  - [ ] Enhance user experience

- [ ] Create documentation
  - [ ] README.md
  - [ ] Usage guide
  - [ ] Troubleshooting guide

**Phase 3 Complete When:**
- [ ] Advanced features working
- [ ] Documentation complete
- [ ] System optimized for daily use

---

## Phase 4: Polish & Deployment

**Goal:** [What this phase accomplishes]
**Duration:** [Estimated time]

### Tasks

- [ ] Final testing
  - [ ] End-to-end workflows
  - [ ] Edge cases
  - [ ] Error recovery

- [ ] Performance optimization
  - [ ] Reduce token usage if needed
  - [ ] Optimize file reading patterns
  - [ ] Improve response times

- [ ] User acceptance testing
  - [ ] Real-world usage for [X] days
  - [ ] Gather feedback
  - [ ] Iterate on pain points

- [ ] Deployment preparation
  - [ ] Clean up test files
  - [ ] Final documentation review
  - [ ] Create deployment checklist

**Phase 4 Complete When:**
- [ ] All tests pass
- [ ] Documentation is complete
- [ ] System ready for production use

---

## Multi-Agent Work Distribution

If using multiple agents (VPS, coordinator + workers, etc.):

### Coordinator Responsibilities
- [ ] Create task queue
- [ ] Write instruction files
- [ ] Monitor worker status
- [ ] Report progress

### Worker Responsibilities
- [ ] Poll task queue
- [ ] Read instruction files
- [ ] Execute tasks
- [ ] Update status files

See `WORK_DISTRIBUTION.md` for detailed guidance.

---

## File-Based Memory Checklist

For repositories with persistent memory:

- [ ] Create `datasets/user-profile.md`
- [ ] Create `datasets/preferences.md`
- [ ] Create `datasets/tools-available.md`
- [ ] Create `datasets/history/` directory
- [ ] Update CLAUDE.md to read datasets on session start
- [ ] Test memory persistence across sessions

---

## Skills Checklist

If creating custom skills:

- [ ] Create `.claude/skills/[skill-name]/` directory
- [ ] Create `skill.md` with skill documentation
- [ ] Create helper Python scripts (if needed)
- [ ] Test skill activation
- [ ] Document skill usage in main CLAUDE.md

---

## Testing Checklist

### Unit Tests
- [ ] Test individual functions/features in isolation
- [ ] Verify data validation
- [ ] Check error handling

### Integration Tests
- [ ] Test features working together
- [ ] Verify file-based communication
- [ ] Check workflow sequences

### End-to-End Tests
- [ ] Test complete user workflows
- [ ] Verify across multiple sessions
- [ ] Test with real data

### User Acceptance Tests
- [ ] Daily usage for [X] days
- [ ] Feedback collection
- [ ] Iteration based on real usage

---

## Documentation Checklist

- [ ] README.md (what it does, how to use)
- [ ] CLAUDE.md (agent instructions)
- [ ] Usage guide (step-by-step for users)
- [ ] Troubleshooting guide (common issues)
- [ ] Contributing guide (if open source)
- [ ] Examples (sample workflows)

---

## Deployment Checklist

- [ ] All tests pass
- [ ] Documentation complete
- [ ] Test files removed
- [ ] Git history clean
- [ ] README accurate
- [ ] License added (if applicable)
- [ ] deploy_me.sh script (if template)
- [ ] Final commit message clear

---

## Known Issues & Future Enhancements

### Issues
- [ ] [Issue description and workaround]
- [ ] [Issue description and workaround]

### Future Enhancements
- [ ] [Enhancement idea]
- [ ] [Enhancement idea]

---

## Notes

[Add any notes, learnings, or context here]

---

## Progress Tracking

**Completed Phases:** [0/4]

**Current Status:** [Brief update on where you are]

**Blockers:** [Any blockers or dependencies]

**Next Steps:**
1. [Immediate next task]
2. [Following task]
3. [After that]

---

## Success Metrics

Track these to measure project success:

- **Time to Deploy:** [Target: X hours/days]
- **Daily Usage Time:** [Target: X minutes]
- **Value Delivered:** [Measurable outcome]
- **User Satisfaction:** [Feedback/rating]

---

*Update this TODO regularly to track progress and stay organized.*
