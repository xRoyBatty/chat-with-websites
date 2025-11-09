# VPS API Specification

## Overview

The user has a Flask API running on their VPS that allows remote file deployment and command execution.

**VPS Details:**
- Host: `51.75.162.195`
- Port: `5555`
- Base URL: `http://51.75.162.195:5555`
- Base Directory: `/var/www/vhosts/schoolfands.eu/httpdocs`
- Authentication: `X-API-Key` header
- API Key: Stored in `VPS_API_KEY` environment variable

## Authentication

All endpoints (except `/test`) require authentication via header:

```
X-API-Key: <your-api-key>
```

The API key should be:
1. Set in Claude Code environment as `VPS_API_KEY`
2. Read from environment in Python: `os.environ.get('VPS_API_KEY')`

## Endpoints

### 1. Test Connection (No Auth)

**GET** `/test`

Tests if the API is reachable.

**Request:**
```bash
curl http://51.75.162.195:5555/test
```

**Response:**
```json
{
  "status": "success",
  "message": "VPS API is running"
}
```

### 2. List Files

**GET** `/list?path=<path>`

Lists files and directories at the specified path.

**Query Parameters:**
- `path`: Relative path from BASE_DIR
  - Use `'.'` or `''` for main directory
  - Use directory name for subdirectories (e.g., `'playtry'`, `'ITArchitect'`)

**Request:**
```bash
curl -H "X-API-Key: your-key" \
  "http://51.75.162.195:5555/list?path=."
```

**Response:**
```json
{
  "status": "success",
  "path": "/var/www/vhosts/schoolfands.eu/httpdocs",
  "files": [
    {
      "name": "index.html",
      "is_directory": false,
      "size": 1024,
      "modified": "2025-11-09T10:00:00"
    },
    {
      "name": "myapp",
      "is_directory": true,
      "size": 4096,
      "modified": "2025-11-09T09:00:00"
    }
  ]
}
```

### 3. Deploy File

**POST** `/deploy`

Creates or overwrites a file with the given content.

**Request Body:**
```json
{
  "filepath": "path/to/file.py",
  "content": "print('Hello World')",
  "encoding": "utf-8"
}
```

**Request:**
```bash
curl -X POST \
  -H "X-API-Key: your-key" \
  -H "Content-Type: application/json" \
  -d '{"filepath": "test.py", "content": "print(\"Hello\")"}' \
  http://51.75.162.195:5555/deploy
```

**Response:**
```json
{
  "status": "success",
  "message": "File deployed successfully",
  "full_path": "/var/www/vhosts/schoolfands.eu/httpdocs/test.py"
}
```

**Notes:**
- Paths are relative to BASE_DIR
- Parent directories are created automatically
- Existing files are overwritten

### 4. Execute Command

**POST** `/execute`

Executes a bash command on the VPS.

**Request Body:**
```json
{
  "command": "ls -la",
  "workdir": null
}
```

**Fields:**
- `command`: Bash command to execute
- `workdir`: Optional working directory (defaults to BASE_DIR)

**Request:**
```bash
curl -X POST \
  -H "X-API-Key: your-key" \
  -H "Content-Type: application/json" \
  -d '{"command": "pwd"}' \
  http://51.75.162.195:5555/execute
```

**Response:**
```json
{
  "status": "success",
  "stdout": "/var/www/vhosts/schoolfands.eu/httpdocs\n",
  "stderr": "",
  "returncode": 0
}
```

**Error Response:**
```json
{
  "status": "error",
  "stdout": "",
  "stderr": "command not found: invalidcommand\n",
  "returncode": 127
}
```

## Path Handling

### Understanding BASE_DIR

The VPS API operates from:
```
BASE_DIR = /var/www/vhosts/schoolfands.eu/httpdocs
```

All operations are relative to this directory.

### Path Examples

| What You Want | Use This | Actual Path |
|---------------|----------|-------------|
| Main directory | `list_files('.')` | `/var/www/.../httpdocs` |
| Subdirectory | `list_files('playtry')` | `/var/www/.../httpdocs/playtry` |
| File in root | `deploy_file('test.py', ...)` | `/var/www/.../httpdocs/test.py` |
| File in subdir | `deploy_file('myapp/app.py', ...)` | `/var/www/.../httpdocs/myapp/app.py` |
| Execute in root | `execute_command('pwd')` | Runs in `/var/www/.../httpdocs` |
| Execute in subdir | `execute_command('pwd', workdir='myapp')` | Runs in `/var/www/.../httpdocs/myapp` |

### Common Mistakes

❌ **Wrong:**
```python
list_files('httpdocs')  # You're already IN httpdocs
list_files('/var/www/...')  # Don't use absolute paths
```

✅ **Correct:**
```python
list_files('.')  # Main directory
list_files('myapp')  # Subdirectory
```

## Error Responses

All endpoints return consistent error format:

```json
{
  "status": "error",
  "message": "Error description here"
}
```

**Common HTTP status codes:**
- `200`: Success
- `400`: Bad request (missing parameters)
- `401`: Unauthorized (missing or invalid API key)
- `403`: Forbidden (auth failed)
- `404`: Not found (path doesn't exist)
- `500`: Server error

## Web Accessibility

Files deployed to BASE_DIR are accessible via HTTP:

```
VPS File: /var/www/.../httpdocs/index.html
→ Web URL: http://schoolfands.eu/index.html

VPS File: /var/www/.../httpdocs/myapp/app.py
→ Web URL: http://schoolfands.eu/myapp/app.py
```

## Security Considerations

1. **API Key Protection**: Never commit API key to Git, use environment variables
2. **Command Injection**: API should sanitize commands (verify this)
3. **Path Traversal**: API should validate paths (verify this)
4. **File Permissions**: Deployed files inherit VPS user permissions
5. **Network Access**: API is exposed on public IP - ensure strong key

## Rate Limiting

The VPS API may have rate limits (not documented). If you encounter issues:
- Add delays between operations
- Batch operations when possible
- Monitor for 429 status codes

## Testing Connection

Before using the API, verify connectivity:

```python
import requests
import os

api_key = os.environ.get('VPS_API_KEY')
headers = {"X-API-Key": api_key}

# Test unauthenticated endpoint
response = requests.get("http://51.75.162.195:5555/test")
print(f"API reachable: {response.status_code == 200}")

# Test authenticated endpoint
response = requests.get(
    "http://51.75.162.195:5555/list?path=.",
    headers=headers
)
print(f"Auth works: {response.status_code == 200}")
```

## Limitations

1. **No streaming**: File operations are synchronous
2. **No file download**: API only supports deployment and listing, not retrieval
   - Use `execute_command('cat file.txt')` to read files
3. **No directory deletion**: Use `execute_command('rm -rf dir/')`
4. **No file metadata**: Limited info from list endpoint
5. **Binary files**: Encoding must be specified (default: utf-8)

## Performance

- **Latency**: ~50-200ms per request (depends on network)
- **Large files**: May timeout, consider chunking or size limits
- **Concurrent requests**: Not documented, test carefully

## Summary

The VPS API provides:
- ✅ File deployment (create/overwrite)
- ✅ Directory listing
- ✅ Command execution
- ✅ Simple authentication
- ✅ Web-accessible file hosting

For the multi-agent system, this enables:
- Shared workspace for all agents
- Real-time state coordination
- Direct deployment to production
- Privacy (code stays on VPS)
