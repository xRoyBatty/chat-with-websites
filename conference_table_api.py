#!/usr/bin/env python3
"""
Conference Table API - A message board for subagents to communicate
"""

from flask import Flask, request, jsonify
import json
import time
from datetime import datetime
from threading import Lock

app = Flask(__name__)

# In-memory storage
messages = []
agents = {}
lock = Lock()

@app.route('/ping', methods=['GET'])
def ping():
    """Health check"""
    return jsonify({"status": "ok", "message": "Conference table is open"})

@app.route('/join', methods=['POST'])
def join():
    """Agent joins the conference"""
    data = request.json
    agent_id = data.get('agent_id')
    role = data.get('role', 'participant')

    with lock:
        agents[agent_id] = {
            "joined_at": datetime.now().isoformat(),
            "role": role,
            "status": "active"
        }

    return jsonify({
        "status": "success",
        "message": f"Agent {agent_id} joined as {role}",
        "participants": list(agents.keys())
    })

@app.route('/post', methods=['POST'])
def post_message():
    """Post a message to the conference"""
    data = request.json

    message = {
        "id": len(messages) + 1,
        "agent_id": data.get('agent_id'),
        "message": data.get('message'),
        "timestamp": datetime.now().isoformat(),
        "type": data.get('type', 'statement')  # statement, question, response, conclusion
    }

    with lock:
        messages.append(message)

    return jsonify({
        "status": "success",
        "message_id": message['id'],
        "total_messages": len(messages)
    })

@app.route('/messages', methods=['GET'])
def get_messages():
    """Get all messages"""
    agent_id = request.args.get('agent_id')
    since_id = request.args.get('since_id', 0, type=int)

    filtered = [m for m in messages if m['id'] > since_id]

    return jsonify({
        "status": "success",
        "messages": filtered,
        "total": len(filtered)
    })

@app.route('/conclude', methods=['POST'])
def conclude():
    """Agent posts their conclusion and leaves"""
    data = request.json
    agent_id = data.get('agent_id')
    conclusion = data.get('conclusion')

    with lock:
        if agent_id in agents:
            agents[agent_id]['status'] = 'concluded'
            agents[agent_id]['conclusion'] = conclusion

    return jsonify({
        "status": "success",
        "message": f"Agent {agent_id} concluded"
    })

@app.route('/status', methods=['GET'])
def status():
    """Get conference status"""
    return jsonify({
        "participants": agents,
        "message_count": len(messages),
        "active_agents": len([a for a in agents.values() if a['status'] == 'active'])
    })

if __name__ == '__main__':
    print("🎪 Conference Table API starting on http://127.0.0.1:5001")
    app.run(host='127.0.0.1', port=5001, debug=False)
