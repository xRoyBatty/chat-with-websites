# VPS API Concepts

## Overview

The VPS API is a remote interface that enables agents to manipulate files and execute commands on a shared server from their local Claude Code environments. This creates a shared workspace where multiple agents can collaborate on the same codebase.

**Core Purpose:**
- Deploy files to a remote server
- List directory contents remotely
- Execute commands on the server
- Provide a shared workspace for multi-agent collaboration

## Authentication

The API uses header-based authentication to secure endpoints.

**Authentication Approach:**
- Most endpoints require authentication
- Authentication credentials are passed via HTTP headers
- API keys should be stored in environment variables for security
- Environment variables are read at runtime by helper functions

**Security Best Practices:**
- Never commit API keys to version control
- Store credentials in environment variables only
- Environment variables should be configured in Claude Code environment settings
- Different environments can have different credentials

## Endpoints and Their Purpose

### Test Connection Endpoint

**Purpose:** Verify the API is reachable without requiring authentication

**Concept:**
- Provides a simple health check
- Returns a success indicator
- Useful for troubleshooting connectivity issues
- Does not require credentials

### List Files Endpoint

**Purpose:** Browse directory contents on the VPS

**Concept:**
- Takes a path parameter to specify which directory to list
- Returns file and directory information
- Provides metadata like file size, modification time, and type
- Works with relative paths from a base directory

**Use Cases:**
- Checking what files exist before deploying
- Verifying successful deployment
- Discovering existing project structure
- Monitoring file changes

### Deploy File Endpoint

**Purpose:** Create or update files on the VPS

**Concept:**
- Accepts a file path and content
- Creates parent directories automatically if needed
- Overwrites existing files
- Supports text encoding specification
- Returns confirmation with full server path

**Use Cases:**
- Deploying new source code files
- Updating configuration files
- Creating task instruction files
- Saving task queue state

**Key Behaviors:**
- Automatic directory creation
- Atomic file replacement
- Path validation to prevent security issues

### Execute Command Endpoint

**Purpose:** Run bash commands on the VPS

**Concept:**
- Accepts a command string
- Optionally accepts a working directory
- Returns standard output, error output, and exit code
- Executes with VPS user permissions

**Use Cases:**
- Running tests or linters
- Reading file contents
- Installing dependencies
- Managing processes
- Cleaning up temporary files

**Security Considerations:**
- Commands should be validated server-side
- Avoid passing untrusted input directly to commands
- Server should sanitize command strings
- Be aware of permission limitations

## Path Handling Concepts

### Base Directory Model

The API operates from a fixed base directory on the server. All paths are relative to this base.

**Conceptual Model:**
```
Base Directory (fixed server location)
├── Your files and directories here
├── Project subdirectories
└── Deployed application code
```

**Path Resolution:**
- Paths are interpreted relative to the base directory
- Empty string or dot notation refers to the base itself
- Subdirectory names are relative paths
- Absolute paths should not be used from client side

### Common Path Patterns

**Accessing the Root:**
- Use current directory notation to list the base
- Avoid trying to navigate to the base by name

**Accessing Subdirectories:**
- Use simple directory names as relative paths
- Paths can include multiple levels with separators
- API creates missing parent directories automatically

**Common Path Mistakes:**
- Don't use the base directory name as a path
- Don't construct absolute server paths client-side
- Don't assume filesystem navigation patterns

**Correct Mental Model:**
- "I'm always working inside the base directory"
- "All my paths are relative to that base"
- "The API handles the absolute path construction"

## Error Handling Concepts

### Consistent Error Format

The API returns errors in a predictable structure.

**Error Information Provided:**
- Status indicator (success vs error)
- Human-readable error message
- HTTP status codes for error categories

### Common Error Categories

**Authentication Errors:**
- Missing credentials
- Invalid or expired credentials
- Insufficient permissions

**Request Errors:**
- Missing required parameters
- Invalid parameter format
- Malformed requests

**Server Errors:**
- Path not found
- Permission denied on server
- Command execution failures
- Internal server problems

### Error Response Patterns

**For File Operations:**
- Path validation failures
- Permission denied
- Parent directory creation failures

**For Command Execution:**
- Command not found
- Non-zero exit codes (command failed)
- Timeout or resource issues

**Best Practices:**
- Always check status indicators before processing results
- Log error messages for debugging
- Handle common errors gracefully
- Validate inputs before making requests

## Web Accessibility

Files deployed to the VPS base directory may be accessible via HTTP.

**Concept:**
- The base directory serves as a web document root
- Files deployed become web-accessible
- URL structure mirrors file path structure
- Useful for hosting web applications or APIs

**Security Implications:**
- Be careful deploying sensitive files
- Understand what is publicly accessible
- Use appropriate file permissions
- Consider separate directories for private files

## Security Concepts

### API Key Protection

**Critical Security Principle:**
- API keys grant full access to the VPS
- Never commit keys to version control
- Store in environment variables only
- Treat as highly sensitive credentials

### Command Injection Prevention

**Potential Risk:**
- Executing arbitrary commands on the server
- Passing untrusted input to command execution

**Mitigation Strategies:**
- Server should sanitize command inputs
- Avoid string interpolation with user input
- Use parameterized approaches when possible
- Validate command patterns server-side

### Path Traversal Prevention

**Potential Risk:**
- Accessing files outside the base directory
- Reading or writing sensitive system files

**Mitigation Strategies:**
- Server validates all paths
- Paths are restricted to base directory
- Symbolic links are handled safely
- Absolute paths are rejected or normalized

### File Permissions

**Concept:**
- Deployed files inherit server user permissions
- Server process runs with specific user privileges
- File permissions may affect web accessibility
- Understand permission model for your use case

## Rate Limiting and Performance

### Rate Limiting Concepts

**Potential Limitations:**
- API may throttle excessive requests
- Prevents abuse and ensures fair access
- May not be explicitly documented

**Best Practices:**
- Add delays between rapid operations
- Batch similar operations when possible
- Monitor for rate limit responses
- Design systems to be rate-limit aware

### Performance Characteristics

**Latency Considerations:**
- Network round-trip time per request
- Geographic distance affects speed
- Each API call is synchronous
- Consider batching for efficiency

**Large File Handling:**
- Very large files may cause timeouts
- Consider chunking strategies
- Monitor request duration
- Test size limits in your environment

**Concurrent Requests:**
- May or may not be supported
- Test carefully before relying on parallelism
- Consider sequential operations for safety

## API Limitations

### File Operations

**What's Supported:**
- File creation and updates
- Directory listing with metadata
- Automatic directory creation

**What's Not Supported:**
- Direct file download/read via dedicated endpoint
- File deletion via dedicated endpoint
- Directory deletion via dedicated endpoint
- File moving or renaming via dedicated endpoint

**Workarounds:**
- Use command execution to read files
- Use command execution for delete/move operations
- Leverage standard shell commands for unsupported operations

### Command Execution

**What's Supported:**
- Arbitrary bash commands
- Custom working directory
- Capture of output and errors
- Exit code retrieval

**What's Not Supported:**
- Streaming output for long-running commands
- Interactive command input
- Real-time progress updates

### Data Transfer

**Characteristics:**
- All operations are synchronous (wait for completion)
- No chunked uploads or downloads
- Binary file handling requires encoding consideration
- Text encoding must be specified

## Multi-Agent Collaboration Benefits

The VPS API enables powerful multi-agent patterns:

### Shared Workspace

**Concept:**
- All agents deploy to the same base directory
- Changes are immediately visible to all agents
- No merge conflicts or branch synchronization
- True real-time collaboration

### State Coordination

**Concept:**
- Agents coordinate through shared files
- Task queues live on VPS, not in Git
- Agent status tracked in VPS files
- Communication happens through file reads/writes

### Privacy and Security

**Concept:**
- Actual code stays on VPS, not in GitHub
- GitHub repo contains only instructions and tooling
- Sensitive logic and data remain private
- API key controls access to workspace

### Direct Deployment

**Concept:**
- Deployed files can be immediately executable
- Web-accessible applications go live instantly
- No separate deployment step needed
- Development and production can share infrastructure

## Usage Patterns

### Testing Connection

**Pattern:**
- First test unauthenticated endpoint (health check)
- Then test authenticated endpoint (verify credentials)
- This confirms both connectivity and authorization

### Deploying Files

**Pattern:**
- Prepare file content locally
- Deploy to VPS with relative path
- Verify deployment by listing directory
- Optionally execute or test the deployed file

### Reading Remote Files

**Pattern:**
- Use command execution with file reading commands
- Parse output to get file contents
- Handle encoding appropriately

### Coordinating Multi-Agent Work

**Pattern:**
- Deploy task queue and instruction files
- Workers read queue to discover tasks
- Workers update status files
- Coordinator monitors via list and read operations
- All coordination happens through files, not conversation

## Summary

The VPS API provides a simple but powerful interface for:
- Remote file manipulation
- Command execution
- Shared workspace creation
- Multi-agent coordination

**Key Concepts:**
- Header-based authentication with environment variables
- Relative path model from a base directory
- Consistent error handling
- Security through validation and permissions
- Web accessibility for deployed files
- Real-time collaboration without Git merging

**Best Practices:**
- Protect API credentials carefully
- Understand the path model thoroughly
- Handle errors gracefully
- Test connectivity before operations
- Use command execution for unsupported operations
- Design with rate limits in mind

This API is the foundation for the multi-agent VPS coordination system, enabling agents to work together on shared code through a centralized workspace.
