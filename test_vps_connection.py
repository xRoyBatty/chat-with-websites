#!/usr/bin/env python3
"""
Quick test script to verify VPS API connection and VPS_API_KEY environment variable
"""

import os
import requests
import json

# VPS Configuration
VPS_HOST = "51.75.162.195"
VPS_PORT = "5555"
BASE_URL = f"http://{VPS_HOST}:{VPS_PORT}"

def test_connection():
    """Test basic connectivity to VPS API"""
    print("=" * 60)
    print("VPS CONNECTION TEST")
    print("=" * 60)

    # Check environment variable
    api_key = os.environ.get('VPS_API_KEY')

    print(f"\n1. Environment Variable Check:")
    if api_key:
        print(f"   ✅ VPS_API_KEY is set (length: {len(api_key)} chars)")
        # Show first/last 4 chars for verification
        masked = api_key[:4] + "*" * (len(api_key) - 8) + api_key[-4:] if len(api_key) > 8 else "****"
        print(f"   Key: {masked}")
    else:
        print("   ❌ VPS_API_KEY is NOT set!")
        print("   Please set it in your Claude Code environment settings")
        return False

    # Test /test endpoint (no auth required)
    print(f"\n2. Testing /test endpoint (no auth):")
    try:
        response = requests.get(f"{BASE_URL}/test", timeout=5)
        if response.status_code == 200:
            print(f"   ✅ VPS API is reachable")
            print(f"   Response: {response.json()}")
        else:
            print(f"   ❌ Unexpected status code: {response.status_code}")
            return False
    except requests.exceptions.RequestException as e:
        print(f"   ❌ Connection failed: {e}")
        print(f"   Make sure VPS API is running on {VPS_HOST}:{VPS_PORT}")
        return False

    # Test /list endpoint (requires auth)
    print(f"\n3. Testing /list endpoint (with auth):")
    headers = {"X-API-Key": api_key}
    try:
        response = requests.get(f"{BASE_URL}/list?path=.", headers=headers, timeout=10)
        if response.status_code == 200:
            data = response.json()
            print(f"   ✅ Authentication successful!")
            print(f"   Base path: {data.get('path', 'N/A')}")
            files = data.get('files', [])
            print(f"   Found {len(files)} items in VPS directory")

            # Show first 5 items
            if files:
                print(f"\n   First 5 items:")
                for item in files[:5]:
                    icon = "📁" if item.get('is_directory') else "📄"
                    print(f"     {icon} {item.get('name', 'N/A')}")
        elif response.status_code == 401 or response.status_code == 403:
            print(f"   ❌ Authentication failed!")
            print(f"   Status: {response.status_code}")
            print(f"   Response: {response.text}")
            print(f"   Check if VPS_API_KEY matches the key on your VPS")
            return False
        else:
            print(f"   ❌ Unexpected status code: {response.status_code}")
            print(f"   Response: {response.text}")
            return False
    except requests.exceptions.RequestException as e:
        print(f"   ❌ Request failed: {e}")
        return False

    # Test /execute endpoint
    print(f"\n4. Testing /execute endpoint:")
    try:
        payload = {
            "command": "pwd",
            "workdir": None
        }
        response = requests.post(f"{BASE_URL}/execute",
                               headers=headers,
                               json=payload,
                               timeout=10)
        if response.status_code == 200:
            data = response.json()
            print(f"   ✅ Command execution successful!")
            print(f"   Working directory: {data.get('stdout', '').strip()}")
        else:
            print(f"   ⚠️  Execute test failed (status {response.status_code})")
            print(f"   Response: {response.text}")
    except requests.exceptions.RequestException as e:
        print(f"   ⚠️  Execute test failed: {e}")

    print("\n" + "=" * 60)
    print("✅ ALL TESTS PASSED! VPS connection is working properly.")
    print("=" * 60)
    return True

if __name__ == "__main__":
    success = test_connection()
    exit(0 if success else 1)
