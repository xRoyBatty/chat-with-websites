"""
Conference Table Helper - File-based communication for subagents
"""

import json
import time
import os
from datetime import datetime
from pathlib import Path

CONFERENCE_DIR = Path("/home/user/chat-with-websites/conference")
MESSAGES_FILE = CONFERENCE_DIR / "messages.jsonl"
AGENTS_FILE = CONFERENCE_DIR / "agents.json"

# Ensure conference directory exists
CONFERENCE_DIR.mkdir(exist_ok=True)

def join_conference(agent_id, role="participant"):
    """Join the conference table"""
    agents = {}
    if AGENTS_FILE.exists():
        with open(AGENTS_FILE, 'r') as f:
            agents = json.load(f)

    agents[agent_id] = {
        "joined_at": datetime.now().isoformat(),
        "role": role,
        "status": "active"
    }

    with open(AGENTS_FILE, 'w') as f:
        json.dump(agents, f, indent=2)

    print(f"✅ {agent_id} joined the conference as {role}")
    return {"status": "success", "participants": list(agents.keys())}

def post_message(agent_id, message, msg_type="statement"):
    """Post a message to the conference"""
    # Count existing messages for ID
    message_id = 1
    if MESSAGES_FILE.exists():
        with open(MESSAGES_FILE, 'r') as f:
            message_id = len(f.readlines()) + 1

    msg = {
        "id": message_id,
        "agent_id": agent_id,
        "message": message,
        "timestamp": datetime.now().isoformat(),
        "type": msg_type
    }

    # Append to messages file
    with open(MESSAGES_FILE, 'a') as f:
        f.write(json.dumps(msg) + '\n')

    print(f"📝 {agent_id} posted: {message[:80]}...")
    return {"status": "success", "message_id": message_id}

def get_messages(since_id=0):
    """Get messages from the conference"""
    if not MESSAGES_FILE.exists():
        return {"status": "success", "messages": [], "total": 0}

    messages = []
    with open(MESSAGES_FILE, 'r') as f:
        for line in f:
            if line.strip():
                msg = json.loads(line)
                if msg['id'] > since_id:
                    messages.append(msg)

    return {"status": "success", "messages": messages, "total": len(messages)}

def post_conclusion(agent_id, conclusion):
    """Post conclusion and leave conference"""
    agents = {}
    if AGENTS_FILE.exists():
        with open(AGENTS_FILE, 'r') as f:
            agents = json.load(f)

    if agent_id in agents:
        agents[agent_id]['status'] = 'concluded'
        agents[agent_id]['conclusion'] = conclusion
        agents[agent_id]['concluded_at'] = datetime.now().isoformat()

    with open(AGENTS_FILE, 'w') as f:
        json.dump(agents, f, indent=2)

    print(f"🏁 {agent_id} concluded")
    return {"status": "success"}

def get_conference_status():
    """Get current conference status"""
    agents = {}
    if AGENTS_FILE.exists():
        with open(AGENTS_FILE, 'r') as f:
            agents = json.load(f)

    message_count = 0
    if MESSAGES_FILE.exists():
        with open(MESSAGES_FILE, 'r') as f:
            message_count = len(f.readlines())

    return {
        "participants": agents,
        "message_count": message_count,
        "active_agents": len([a for a in agents.values() if a['status'] == 'active'])
    }

def wait_for_other_agent(my_id, expected_count=2, timeout=120):
    """Wait until expected number of agents have joined"""
    start = time.time()
    while time.time() - start < timeout:
        status = get_conference_status()
        if len(status['participants']) >= expected_count:
            print(f"✅ {expected_count} agents present, starting discussion")
            return True
        time.sleep(2)
    return False

def clear_conference():
    """Clear the conference table"""
    if MESSAGES_FILE.exists():
        MESSAGES_FILE.unlink()
    if AGENTS_FILE.exists():
        AGENTS_FILE.unlink()
    print("🧹 Conference table cleared")
