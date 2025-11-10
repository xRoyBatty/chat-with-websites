# Environment Benefits in Claude Code on the Web

## What Are Environments?

In Claude Code on the web, **environments** are configuration profiles that define the runtime context where your code executes. They specify:

1. **Network access level** (none, limited, full)
2. **Environment variables** (API keys, tokens, credentials)
3. **SessionStart hooks** (dependency installation, setup scripts)

Think of environments like Docker Compose profiles or Kubernetes contexts - same code, different runtime configurations.

## How Environments Work with GitHub Repos

When you start a Claude Code task on the web:

1. You **select a GitHub repo + branch**
2. Claude **clones that repo** into the selected environment (cloud sandbox VM)
3. **All work happens in that environment** - edits, tests, commands
4. **Changes are pushed back** to a branch on GitHub when complete

## Key Benefits

### 1. Multiple Configurations for Same Repo

You can have different environments for the same repository:

```
my-app (GitHub repo)
├── Environment: "Production Testing"
│   ├── Network: Limited (only prod APIs)
│   ├── Env vars: PROD_API_KEY, DATABASE_URL
│   └── Hooks: npm install, setup prod db
│
├── Environment: "Development"
│   ├── Network: Full internet
│   ├── Env vars: DEV_API_KEY, DEBUG=true
│   └── Hooks: npm install, seed test data
│
└── Environment: "Secure - No Network"
    ├── Network: None (air-gapped)
    ├── Env vars: (none)
    └── Hooks: npm install (from cache)
```

### 2. Privacy & Security

- **Isolated sandboxes**: Each session runs in an isolated cloud container
- **Credentials never exposed**: Git credentials handled via secure proxy
- **Network controls**: Limit or disable internet access
- **84% fewer permission prompts**: Sandboxing allows Claude to work autonomously within safe boundaries

### 3. Work from Anywhere

- Access development environment from any browser
- No local setup required
- Continue work across different machines
- Perfect for mobile/tablet via Claude iOS app

### 4. Resource Optimization

- Use cloud compute power for heavy operations
- Keep local machine free
- Run multiple environments simultaneously

## VPS as an Environment Alternative

Instead of Anthropic's cloud sandbox, you can use your VPS:

**Cloud Sandbox (Default):**
- Clones repo → limited resources → controlled network → can't access internal services

**VPS (Custom):**
- Clones repo → your VPS resources → your network → can access databases, internal APIs, production systems

**Use case example:** Database migration script
- Cloud sandbox: Can't access your production database
- VPS: Already has database access, can test migrations directly

## GitHub Integration

Environments don't change the GitHub workflow:
- Repo is still cloned from GitHub
- Changes are still pushed to GitHub branches
- Pull requests are still created on GitHub

The environment only affects **WHERE the code runs**, not the source control flow.

## Limitations

- **Network dependency**: Requires stable internet
- **Cost**: Running multiple sessions uses more tokens
- **Setup complexity**: Initial configuration can be involved
- **Latency**: Remote operations slower than local

## Summary

Environments provide:
- ✅ Configuration isolation (dev/staging/prod)
- ✅ Security controls (network, permissions)
- ✅ Portability (work from anywhere)
- ✅ Resource flexibility (cloud or VPS)

But still rely on GitHub for source control and collaboration.
