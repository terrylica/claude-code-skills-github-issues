# Claude Code Plugin System: Quick Reference

**Last Updated:** 2025-10-25
**Full Documentation:** [CLAUDE_CODE_PLUGIN_SYSTEM.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/CLAUDE_CODE_PLUGIN_SYSTEM.md)

---

## Quick Definitions

```
Plugin      = Container for distributing functionality
Marketplace = JSON catalog listing available plugins
Skill       = Model-invoked (autonomous by Claude)
Command     = User-invoked (explicit /command)
```

---

## Essential File Structure

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json          # REQUIRED manifest
├── commands/                 # User slash commands
├── agents/                   # Specialized subagents
├── skills/                   # Model-invoked capabilities
│   └── my-skill/SKILL.md
├── hooks/hooks.json          # Event automation
└── .mcp.json                 # External tools
```

**Critical:** Components at plugin root, NOT inside `.claude-plugin/`

---

## Minimal plugin.json

```json
{
  "name": "my-plugin",
  "description": "What this plugin does",
  "version": "1.0.0",
  "author": { "name": "Your Name" }
}
```

---

## Minimal marketplace.json

```json
{
  "name": "my-marketplace",
  "owner": { "name": "Your Name" },
  "plugins": [
    {
      "name": "my-plugin",
      "source": "./my-plugin"
    }
  ]
}
```

---

## Common Commands

```bash
# Add marketplace
/plugin marketplace add owner/repo
/plugin marketplace add https://gitlab.com/repo.git
/plugin marketplace add ./local-path

# Install plugin
/plugin install plugin-name@marketplace-name

# Browse interactively
/plugin

# Manage plugins
/plugin enable plugin-name@marketplace-name
/plugin disable plugin-name@marketplace-name
/plugin uninstall plugin-name@marketplace-name

# Marketplace operations
/plugin marketplace list
/plugin marketplace update marketplace-name
/plugin marketplace remove marketplace-name

# Validation & debugging
claude plugin validate .
claude --debug
```

---

## Plugin Source Types

**Local:**

```json
{ "name": "local", "source": "./path/to/plugin" }
```

**GitHub:**

```json
{
  "name": "github-plugin",
  "source": { "source": "github", "repo": "owner/repo" }
}
```

**Git URL:**

```json
{
  "name": "git-plugin",
  "source": { "source": "url", "url": "https://gitlab.com/team/plugin.git" }
}
```

---

## SKILL.md Template

```yaml
---
name: skill-name
description: What it does and when to use it
allowed-tools: # Optional: restrict tools
  - Read
  - Grep
---
# Skill Instructions

Clear instructions for Claude...
```

---

## MCP Server Configuration

**In .mcp.json:**

```json
{
  "server-name": {
    "command": "${CLAUDE_PLUGIN_ROOT}/servers/my-server",
    "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"],
    "env": { "API_KEY": "${MY_API_KEY}" }
  }
}
```

**In plugin.json:**

```json
{
  "mcpServers": {
    "server-name": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/my-server"
    }
  }
}
```

---

## Team Auto-Install

**In .claude/settings.json:**

```json
{
  "extraKnownMarketplaces": {
    "team-tools": {
      "source": {
        "source": "github",
        "repo": "org/claude-plugins"
      }
    }
  }
}
```

Marketplaces install automatically when team members trust the repo.

---

## Component Types Summary

| Type     | Location            | Activation     | Purpose                    |
| -------- | ------------------- | -------------- | -------------------------- |
| Commands | `commands/*.md`     | User `/cmd`    | Custom slash commands      |
| Agents   | `agents/*.md`       | Auto by Claude | Specialized tasks          |
| Skills   | `skills/*/SKILL.md` | Auto by Claude | Model-invoked capabilities |
| Hooks    | `hooks/hooks.json`  | Event-driven   | Lifecycle automation       |
| MCP      | `.mcp.json`         | Auto on enable | External tools             |

---

## Available Hook Events

- PreToolUse, PostToolUse
- UserPromptSubmit, Notification
- Stop, SubagentStop
- PreCompact
- SessionStart, SessionEnd

---

## Common Issues

| Problem           | Solution                             |
| ----------------- | ------------------------------------ |
| Plugin won't load | `claude plugin validate .`           |
| Missing commands  | Move `commands/` to plugin root      |
| Hooks not running | `chmod +x` on scripts                |
| MCP fails         | Use `${CLAUDE_PLUGIN_ROOT}` variable |
| Path errors       | Use relative paths with `./`         |

---

## Development Workflow

```bash
# 1. Create plugin structure
mkdir -p my-plugin/.claude-plugin
cd my-plugin
cat > .claude-plugin/plugin.json <<EOF
{
  "name": "my-plugin",
  "description": "Plugin description",
  "version": "1.0.0",
  "author": {"name": "Your Name"}
}
EOF

# 2. Add components
mkdir -p commands skills
echo "---\ndescription: Test command\n---\n\nTest!" > commands/test.md

# 3. Create marketplace
cd ..
mkdir marketplace
cat > marketplace/.claude-plugin/marketplace.json <<EOF
{
  "name": "test-marketplace",
  "owner": {"name": "Your Name"},
  "plugins": [
    {"name": "my-plugin", "source": "../my-plugin"}
  ]
}
EOF

# 4. Test locally
/plugin marketplace add ./marketplace
/plugin install my-plugin@test-marketplace

# 5. Push to GitHub and share
git init
git add .
git commit -m "Initial plugin"
git remote add origin https://github.com/user/repo.git
git push -u origin main

# Team members add with:
# /plugin marketplace add user/repo
```

---

## Key Best Practices

1. **Use relative paths** with `./` prefix
2. **Leverage `${CLAUDE_PLUGIN_ROOT}`** for scripts
3. **Validate before sharing:** `claude plugin validate .`
4. **Test locally first:** `./marketplace` before GitHub
5. **Review hooks thoroughly** (security implications)
6. **Write descriptive skill descriptions** (Claude uses for discovery)
7. **Use `allowed-tools`** to restrict skill capabilities
8. **Restart Claude Code** after MCP changes
9. **Enable debug mode** for troubleshooting: `claude --debug`
10. **GitHub for distribution** (version control + collaboration)

---

## Skills vs Commands

**Skills (Model-Invoked):**

- Claude decides when to use based on context
- Autonomous activation
- Description-based discovery
- Optional tool restrictions via `allowed-tools`

**Commands (User-Invoked):**

- Explicit `/command` activation
- Manual user trigger
- Menu-based discovery
- Full tool access (no restrictions)

---

## Distribution Channels

1. **GitHub repos** (recommended) - `/plugin marketplace add owner/repo`
2. **Git URLs** - `/plugin marketplace add https://git.host/repo.git`
3. **Local paths** - `/plugin marketplace add ./path`
4. **Direct URLs** - `/plugin marketplace add https://url/marketplace.json`

---

## Security Considerations

**Hooks Warning:**

> "Hooks run automatically during the agent loop with your current environment's credentials"

Review all hooks before implementation to prevent:

- Data exfiltration
- Credential leakage
- Unintended command execution

**MCP Best Practices:**

- Use environment variables for secrets
- Avoid hardcoding credentials
- Review server permissions

---

## Official Documentation

**Full Research Report:** [CLAUDE_CODE_PLUGIN_SYSTEM.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/CLAUDE_CODE_PLUGIN_SYSTEM.md)

**Official Docs:**

- Plugins: https://docs.claude.com/en/docs/claude-code/plugins.md
- Marketplaces: https://docs.claude.com/en/docs/claude-code/plugin-marketplaces.md
- Reference: https://docs.claude.com/en/docs/claude-code/plugins-reference.md
- Skills: https://docs.claude.com/en/docs/claude-code/skills.md
- Hooks: https://docs.claude.com/en/docs/claude-code/hooks-guide.md
- MCP: https://docs.claude.com/en/docs/claude-code/mcp.md

**Documentation Map:** https://docs.claude.com/en/docs/claude-code/claude_code_docs_map.md

---

**Version:** 1.0.0 | **Research Date:** 2025-10-25
