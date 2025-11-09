# Multi-Agent VPS Coordination System

## 🎯 Project Overview

This repository implements a **VPS-based multi-agent coordination system** where multiple Claude Code agents collaborate on the same codebase through a shared workspace on a VPS.

**Key Innovation:** The GitHub repo contains only instructions and tooling - the actual code lives entirely on the VPS, enabling true real-time collaboration between agents.

---

## 📚 Required Reading (Read First!)

Before starting any work, you **MUST** read these knowledge files in order:

1. **`knowledge/01-environment-benefits.md`**
   - Explains Claude Code environments
   - Why VPS approach is beneficial
   - How environments relate to GitHub repos

2. **`knowledge/02-vps-multi-agent-architecture.md`**
   - The core architecture concept
   - How multiple agents collaborate via VPS
   - Why this is better than GitHub branches
   - Multi-agent patterns

3. **`knowledge/03-stop-hooks-worker-persistence.md`**
   - How Stop hooks keep workers alive
   - Idle time management (CRITICAL to understand)
   - How workers poll for tasks continuously

4. **`knowledge/04-vps-api-specification.md`**
   - VPS API endpoints and usage
   - Authentication with `VPS_API_KEY`
   - Path handling and common mistakes
   - Example requests and responses

5. **`knowledge/05-task-queue-coordination.md`**
   - Task queue data structures
   - Coordinator vs Worker functions
   - Workflow patterns
   - Best practices and error handling

**⚠️ DO NOT SKIP THE KNOWLEDGE FILES!** Everything you need to understand this system is documented there.

---

## 📋 Your Task

After reading the knowledge files, consult **`TO_DO.md`** for step-by-step implementation instructions.

**Your workflow:**
1. ✅ Read all 5 knowledge files above
2. ✅ Open and read `TO_DO.md`
3. ✅ Follow the phases and steps in order
4. ✅ Test thoroughly after each step
5. ✅ Update `TO_DO.md` with your progress

---

## 🔧 Environment Setup

**Before starting, verify:**

### 1. VPS API Key
```bash
echo $VPS_API_KEY
```
Should output your API key. If not set:
- Go to Claude Code environment settings
- Select environment "vps-dev"
- Verify `VPS_API_KEY=<your-key>` is configured

### 2. VPS API Reachable
```bash
curl http://51.75.162.195:5555/test
```
Should return: `{"status": "success", "message": "VPS API is running"}`

### 3. Network Access
- Ensure environment has "Full network access" enabled
- Verify no firewall blocking port 5555

---

## 🏗️ Project Structure

```
chat-with-websites/
├── CLAUDE.md                 ← You are here
├── TO_DO.md                  ← Step-by-step instructions
├── knowledge/                ← Essential reading
│   ├── 01-environment-benefits.md
│   ├── 02-vps-multi-agent-architecture.md
│   ├── 03-stop-hooks-worker-persistence.md
│   ├── 04-vps-api-specification.md
│   └── 05-task-queue-coordination.md
├── .claude/                  ← To be created
│   ├── skills/
│   │   └── vps-deploy/
│   │       ├── skill.md
│   │       └── vps_deploy_helper.py
│   ├── hooks/
│   │   └── worker-stop-check.py
│   └── settings.json
└── templates/                ← To be created
    ├── WORKER_CLAUDE.md
    └── COORDINATOR_CLAUDE.md
```

---

## 🎭 Understanding Your Role

This session is for **building the infrastructure**. You are not yet a coordinator or worker - you are the **system architect** implementing the multi-agent framework.

Once complete, future sessions will use:
- **Coordinator agents**: Orchestrate work by creating tasks
- **Worker agents**: Execute tasks from the queue

Your job is to build the tools they'll use.

---

## ⚡ Quick Reference

### VPS API Endpoints

```bash
# Test connection (no auth)
GET http://51.75.162.195:5555/test

# List directory (with auth)
GET http://51.75.162.195:5555/list?path=.
Headers: X-API-Key: $VPS_API_KEY

# Deploy file (with auth)
POST http://51.75.162.195:5555/deploy
Headers: X-API-Key: $VPS_API_KEY
Body: {"filepath": "test.py", "content": "print('hello')"}

# Execute command (with auth)
POST http://51.75.162.195:5555/execute
Headers: X-API-Key: $VPS_API_KEY
Body: {"command": "pwd", "workdir": null}
```

### VPS Details

- **Host:** 51.75.162.195
- **Port:** 5555
- **Base Dir:** /var/www/vhosts/schoolfands.eu/httpdocs
- **Auth:** X-API-Key header
- **Key:** From `VPS_API_KEY` environment variable

---

## 🚨 Critical Concepts

### 1. Idle Time vs Total Time

**WRONG:**
```python
# Worker registered 9 minutes ago, task arrives now
# Worker would only have 1 minute left if checking total time ❌
```

**CORRECT:**
```python
# Idle timer RESETS when task is claimed or completed
# Worker gets full 10 minutes after finishing each task ✅
```

See `knowledge/03-stop-hooks-worker-persistence.md` for details.

### 2. Path Handling on VPS

**WRONG:**
```python
list_files('httpdocs')  # You're already IN httpdocs ❌
list_files('/var/www/...')  # Don't use absolute paths ❌
```

**CORRECT:**
```python
list_files('.')  # Main directory ✅
list_files('myproject')  # Subdirectory ✅
```

See `knowledge/04-vps-api-specification.md` for details.

### 3. GitHub vs VPS

**Remember:**
- GitHub repo = Instructions and tooling ONLY
- VPS = Actual code and project files
- Never commit actual project code to GitHub
- All file operations go through VPS API, not local tools

---

## 🔍 Testing Strategy

After implementing each component:

1. **Unit test**: Test the function/component in isolation
2. **Integration test**: Test it working with other components
3. **End-to-end test**: Test the full workflow

Example:
```python
# Unit test
deploy_file('test.txt', 'hello')  # Does it deploy?

# Integration test
task = add_task("Create test.txt")
claimed = claim_task('worker-1')  # Can it be claimed?

# End-to-end test
# Coordinator creates task → Worker claims → Worker executes → Task marked complete
```

---

## 📝 Progress Tracking

Update `TO_DO.md` as you work:

```markdown
## Current Status

**Phase:** 1 (Foundation)
**Last Step Completed:** Step 2 - Create VPS Deployment Skill
**Next Step:** Step 3 - Create Task Queue Coordination Functions
```

This helps future sessions (or you after a break) know where to continue.

---

## 🐛 Troubleshooting

### VPS_API_KEY not found
- Check environment settings in Claude Code web UI
- Ensure you're using the "vps-dev" environment
- Environment variables only apply to new bash commands/sessions

### VPS API unreachable
```bash
# Test basic connectivity
curl http://51.75.162.195:5555/test

# Test with auth
curl -H "X-API-Key: $VPS_API_KEY" \
  "http://51.75.162.195:5555/list?path=."
```

### Stop hook not working
- Check hook is registered in `.claude/settings.json`
- Verify hook script is executable
- Test hook manually: `python3 .claude/hooks/worker-stop-check.py`
- Check hook receives correct JSON input

### Workers stop immediately
- Stop hook may be returning "approve" instead of "block"
- Check `should_worker_continue()` logic
- Verify idle time calculation is correct
- Ensure tasks exist in queue

---

## 💡 Tips

1. **Read first, code later**: Understanding the architecture is crucial
2. **Test incrementally**: Don't build everything at once
3. **Use print statements**: Debug with frequent logging
4. **Check VPS state**: Use `list_files()` and `execute_command()` to inspect
5. **One step at a time**: Follow `TO_DO.md` sequentially
6. **Ask questions**: If confused, clarify before proceeding

---

## 🎯 Success Criteria

By the end, you should have:

- ✅ VPS skill with all helper functions
- ✅ Task queue coordination system
- ✅ Stop hooks for worker persistence
- ✅ Worker and Coordinator templates
- ✅ Successful multi-worker test
- ✅ Documentation and usage guide

---

## 🚀 Ready to Start?

1. **Open `knowledge/01-environment-benefits.md`** and start reading
2. After reading all knowledge files, **open `TO_DO.md`**
3. **Begin with Phase 1, Step 1**: Test VPS Connection
4. **Follow the steps in order**

Remember: You're building infrastructure for a multi-agent system. Take your time, test thoroughly, and enjoy the process!

---

## 📖 Additional Notes

- This is a **research preview implementation** - expect iteration
- The system enables **true distributed multi-agent collaboration**
- Code lives on VPS for **privacy and shared access**
- Task queue provides **automatic load balancing**
- Stop hooks create **persistent polling workers**

This architecture is fundamentally more powerful than standard GitHub branch workflows for complex, coordinated tasks.

**Good luck building the future of multi-agent systems! 🚀**
