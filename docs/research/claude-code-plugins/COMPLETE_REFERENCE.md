# Claude Code Plugin System: Comprehensive Research Report

**Research Date:** 2025-10-25
**Documentation Source:** https://docs.claude.com/en/docs/claude-code/
**Report Version:** 1.0.0

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [System Architecture](#system-architecture)
3. [Plugin File Structure](#plugin-file-structure)
4. [Plugin Manifest (plugin.json)](#plugin-manifest-pluginjson)
5. [Marketplace System](#marketplace-system)
6. [Distribution Mechanisms](#distribution-mechanisms)
7. [Component Types](#component-types)
8. [Skills System](#skills-system)
9. [Best Practices](#best-practices)
10. [Official Documentation References](#official-documentation-references)

---

## Executive Summary

The Claude Code plugin system provides a comprehensive framework for extending the CLI's capabilities through five core component types: **Commands**, **Agents**, **Skills**, **Hooks**, and **MCP Servers**. Plugins are distributed via marketplaces (JSON manifests hosted on GitHub, Git repositories, or local filesystems) and follow a standardized directory structure with a `.claude-plugin/` configuration folder.

**Key Distinctions:**

- **Plugins** = Containers for distributing functionality
- **Marketplaces** = JSON catalogs listing available plugins
- **Skills** = Model-invoked capabilities (autonomous activation by Claude)
- **Commands** = User-invoked slash commands (explicit activation)

**Distribution Model:** Marketplace-based system supports GitHub repos, Git URLs, and local paths with automatic team installation via `.claude/settings.json`.

---

## System Architecture

### Three-Tier Distribution Model

```
┌─────────────────────────────────────────────────────┐
│              Marketplace Layer                      │
│  (marketplace.json files on GitHub/Git/Local)       │
└────────────────┬────────────────────────────────────┘
                 │
                 │ References
                 ▼
┌─────────────────────────────────────────────────────┐
│               Plugin Layer                          │
│  (.claude-plugin/plugin.json + components)          │
└────────────────┬────────────────────────────────────┘
                 │
                 │ Contains
                 ▼
┌─────────────────────────────────────────────────────┐
│            Component Layer                          │
│  (Commands, Agents, Skills, Hooks, MCP)             │
└─────────────────────────────────────────────────────┘
```

### Skill Storage Hierarchy

The system supports three skill storage locations with different scopes:

1. **Personal Skills** (`~/.claude/skills/`) - Individual workflows across all projects
2. **Project Skills** (`.claude/skills/`) - Team-shared, version-controlled
3. **Plugin Skills** (`plugins/*/skills/`) - Distributed with plugin installations

> **Official Documentation:** "All three types function identically within Claude Code's discovery mechanism."
> **Source:** https://docs.claude.com/en/docs/claude-code/skills.md

---

## Plugin File Structure

### Standard Directory Layout

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest (REQUIRED)
├── commands/                 # Custom slash commands (optional)
│   └── hello.md
├── agents/                   # Custom agents (optional)
│   └── helper.md
├── skills/                   # Agent Skills (optional)
│   └── my-skill/
│       └── SKILL.md
├── hooks/                    # Event handlers (optional)
│   └── hooks.json
└── .mcp.json                 # MCP server config (optional)
```

> **Critical Principle:** "Directories exist at the plugin root, not inside `.claude-plugin/`"
> **Source:** https://docs.claude.com/en/docs/claude-code/plugins.md

### Path Configuration Rules

From the plugins reference documentation:

> "Custom paths supplement default directories - they don't replace them. All paths must be relative and start with `./`"
> **Source:** https://docs.claude.com/en/docs/claude-code/plugins-reference.md

**Important:** Component directories (commands, agents, skills, hooks) must exist at the plugin root level, not within `.claude-plugin/`.

---

## Plugin Manifest (plugin.json)

### Complete Schema Specification

**Location:** `.claude-plugin/plugin.json` (required)

**Required Field:**

- `name` (string): Unique identifier in kebab-case format

**Metadata Fields:**

| Field         | Type   | Description         | Example                                             |
| ------------- | ------ | ------------------- | --------------------------------------------------- |
| `version`     | string | Semantic versioning | `"2.1.0"`                                           |
| `description` | string | Purpose summary     | `"A simple greeting plugin"`                        |
| `author`      | object | Creator information | `{"name": "Your Name", "email": "you@example.com"}` |
| `homepage`    | string | Documentation URL   | `"https://docs.example.com"`                        |
| `repository`  | string | Source code URL     | `"https://github.com/user/plugin"`                  |
| `license`     | string | License identifier  | `"MIT"`                                             |
| `keywords`    | array  | Discovery tags      | `["automation", "workflow"]`                        |

**Component Path Fields:**

| Field        | Type          | Description                         |
| ------------ | ------------- | ----------------------------------- |
| `commands`   | string/array  | Paths to command markdown files     |
| `agents`     | string/array  | Paths to agent definitions          |
| `hooks`      | string/object | Path to hooks.json or inline config |
| `mcpServers` | object        | MCP server configurations           |

### Minimal Example

```json
{
  "name": "my-first-plugin",
  "description": "A simple greeting plugin to learn the basics",
  "version": "1.0.0",
  "author": {
    "name": "Your Name"
  }
}
```

### Complete Example

```json
{
  "name": "enterprise-tools",
  "version": "2.1.0",
  "description": "Enterprise workflow automation tools",
  "author": {
    "name": "Enterprise Team",
    "email": "enterprise@company.com"
  },
  "homepage": "https://docs.company.com/plugins/enterprise-tools",
  "repository": "https://github.com/company/enterprise-plugin",
  "license": "MIT",
  "keywords": ["enterprise", "workflow", "automation"],
  "commands": ["./commands/core/", "./commands/enterprise/"],
  "agents": ["./agents/security-reviewer.md"],
  "mcpServers": {
    "plugin-api": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/api-server",
      "args": ["--port", "8080"]
    }
  }
}
```

---

## Marketplace System

### marketplace.json Schema

**Purpose:** As stated in the official docs:

> "A marketplace is fundamentally a JSON file that lists available plugins and describes where to find them."
> **Source:** https://docs.claude.com/en/docs/claude-code/plugin-marketplaces.md

**Location:** `.claude-plugin/marketplace.json`

### Required Fields

| Field     | Type   | Purpose                                        |
| --------- | ------ | ---------------------------------------------- |
| `name`    | string | Marketplace identifier (kebab-case, no spaces) |
| `owner`   | object | Marketplace maintainer information             |
| `plugins` | array  | List of available plugins                      |

### Optional Metadata Fields

| Field                  | Type   | Description                           |
| ---------------------- | ------ | ------------------------------------- |
| `metadata.description` | string | Brief marketplace description         |
| `metadata.version`     | string | Marketplace version                   |
| `metadata.pluginRoot`  | string | Base path for relative plugin sources |

### Plugin Entry Schema

Each plugin entry in the `plugins` array requires:

**Required:**

- `name` (string): Plugin identifier (kebab-case)
- `source` (string/object): Where to fetch the plugin

**Optional Standard Fields:**

- `description`, `version`, `author`, `homepage`, `repository`, `license`
- `keywords`, `category`, `tags`
- `strict` (boolean): Require plugin.json in plugin folder (default: true)

**Component Configuration:**

- `commands`: Custom paths to command files/directories
- `agents`: Custom paths to agent files
- `hooks`: Custom hooks configuration or path
- `mcpServers`: MCP server configurations

### Complete Marketplace Example

```json
{
  "name": "enterprise-tools",
  "owner": {
    "name": "Enterprise Team",
    "email": "enterprise@company.com"
  },
  "metadata": {
    "description": "Enterprise productivity and automation plugins",
    "version": "1.0.0"
  },
  "plugins": [
    {
      "name": "my-first-plugin",
      "source": "./my-first-plugin",
      "description": "My first test plugin"
    },
    {
      "name": "github-plugin",
      "source": {
        "source": "github",
        "repo": "owner/plugin-repo"
      },
      "description": "GitHub integration tools",
      "category": "productivity"
    },
    {
      "name": "git-plugin",
      "source": {
        "source": "url",
        "url": "https://gitlab.com/team/plugin.git"
      },
      "description": "GitLab workflow automation",
      "keywords": ["git", "gitlab", "ci-cd"]
    }
  ]
}
```

### Plugin Source Types

**1. Relative Paths (Same Repository)**

```json
{
  "name": "my-plugin",
  "source": "./plugins/my-plugin"
}
```

**2. GitHub Repositories**

```json
{
  "name": "github-plugin",
  "source": {
    "source": "github",
    "repo": "owner/plugin-repo"
  }
}
```

**3. Git Repositories**

```json
{
  "name": "git-plugin",
  "source": {
    "source": "url",
    "url": "https://gitlab.com/team/plugin.git"
  }
}
```

### The `strict` Field

From the marketplace documentation:

> "The `strict` field determines behavior: when `true` (default), marketplace fields supplement those values; when `false`, the entry serves as the complete plugin manifest if no `plugin.json` exists."
> **Source:** https://docs.claude.com/en/docs/claude-code/plugin-marketplaces.md

---

## Distribution Mechanisms

### Adding Marketplaces

**GitHub Repositories:**

```bash
/plugin marketplace add owner/repo
```

**Git Repositories:**

```bash
/plugin marketplace add https://gitlab.com/company/plugins.git
```

**Local Development:**

```bash
/plugin marketplace add ./my-marketplace
/plugin marketplace add ./path/to/marketplace.json
/plugin marketplace add https://url.of/marketplace.json
```

### Installing Plugins

**Interactive Discovery:**

```bash
/plugin
```

> "Launches browsing interface with descriptions and features."
> **Source:** https://docs.claude.com/en/docs/claude-code/plugins.md

**Direct Installation:**

```bash
/plugin install plugin-name@marketplace-name
```

### Plugin Management Commands

| Operation         | Command                                          | Purpose                           |
| ----------------- | ------------------------------------------------ | --------------------------------- |
| Enable            | `/plugin enable plugin-name@marketplace-name`    | Activate plugin                   |
| Disable           | `/plugin disable plugin-name@marketplace-name`   | Deactivate plugin                 |
| Uninstall         | `/plugin uninstall plugin-name@marketplace-name` | Remove plugin                     |
| List Marketplaces | `/plugin marketplace list`                       | Shows all configured marketplaces |
| Update            | `/plugin marketplace update marketplace-name`    | Refresh plugin listings           |
| Remove            | `/plugin marketplace remove marketplace-name`    | Remove marketplace                |

**Warning from official docs:**

> "Removing a marketplace uninstalls associated plugins."
> **Source:** https://docs.claude.com/en/docs/claude-code/plugin-marketplaces.md

### Team Configuration

Configure automatic marketplace installation in `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "team-tools": {
      "source": {
        "source": "github",
        "repo": "your-org/claude-plugins"
      }
    },
    "project-specific": {
      "source": {
        "source": "git",
        "url": "https://git.company.com/project-plugins.git"
      }
    }
  }
}
```

> "When members trust the repository folder, Claude Code automatically installs these marketplaces and any plugins specified in the `enabledPlugins` field."
> **Source:** https://docs.claude.com/en/docs/claude-code/plugin-marketplaces.md

### Hosting & Distribution Options

**GitHub (Recommended):**

> "Repository-based distribution provides version control, issue tracking, and team collaboration features"
> **Source:** https://docs.claude.com/en/docs/claude-code/plugin-marketplaces.md

**Alternative Git Services:**
Any Git hosting platform works via URL:

```bash
/plugin marketplace add https://gitlab.com/company/plugins.git
```

**Local Testing:**

```bash
/plugin marketplace add ./my-local-marketplace
/plugin install test-plugin@my-local-marketplace
```

### Validation & Testing

```bash
claude plugin validate .  # Validate JSON syntax
```

**Pre-distribution Checklist:**

- ✅ Marketplace URL accessible
- ✅ `.claude-plugin/marketplace.json` exists at specified path
- ✅ Valid JSON syntax
- ✅ Plugin source URLs reachable
- ✅ Plugin directories contain required files
- ✅ Repository access permissions configured (for private repos)

---

## Component Types

### 1. Commands

**Purpose:** User-invoked slash commands integrated with Claude Code

**Location:** `commands/` directory at plugin root

**Format:** Markdown files with YAML frontmatter

**Example:**

```markdown
---
description: Greet the user with a personalized message
---

# Hello Command

Greet the user warmly and ask how you can help them today.
```

**Activation:** Explicit user invocation via `/command-name`

---

### 2. Agents

**Purpose:** Custom agent definitions for specialized tasks

**Location:** `agents/` directory at plugin root

**Format:** Markdown with frontmatter including `description` and `capabilities` array

**Behavior from official docs:**

> "Claude can invoke agents automatically based on task context"
> **Source:** https://docs.claude.com/en/docs/claude-code/plugins-reference.md

---

### 3. Skills

**Purpose:** Model-invoked capabilities for autonomous task completion

**Location:** `skills/` directory with subdirectories containing `SKILL.md`

**Key Distinction from official docs:**

> "Skills are model-invoked—Claude autonomously uses them based on the task context."
> **Source:** https://docs.claude.com/en/docs/claude-code/plugins.md

**SKILL.md Format Requirements:**

```yaml
---
name: lowercase-with-hyphens # Max 64 characters
description: What it does and when to use it # Max 1024 characters
allowed-tools: [Read, Grep] # Optional: restrict tool access
---
# Skill Instructions

Detailed instructions for Claude...
```

**allowed-tools Configuration:**

The `allowed-tools` frontmatter field enables:

- Read-only skills preventing file modifications
- Scope-limited operations (data analysis without file writing)
- Security-sensitive workflows with capability restrictions

> "When unspecified, Claude requests permission per standard protocols."
> **Source:** https://docs.claude.com/en/docs/claude-code/skills.md

**Description Field Critical Importance:**

> "The description field proves critical for discovery, as it communicates both functionality and activation triggers."
> **Source:** https://docs.claude.com/en/docs/claude-code/skills.md

**Plugin Integration:**

> "The documentation recommends distributing skills through plugins as the primary sharing mechanism."
> **Source:** https://docs.claude.com/en/docs/claude-code/skills.md

---

### 4. Hooks

**Purpose:** User-defined shell commands executing at specific agent lifecycle points

**Location:** `hooks/hooks.json` at plugin root or inline in `plugin.json`

**Key Characteristic from official docs:**

> "Hooks provide deterministic control over Claude Code's behavior, ensuring certain actions always happen rather than relying on the LLM to choose to run them."
> **Source:** https://docs.claude.com/en/docs/claude-code/hooks-guide.md

**Available Hook Events:**

| Event              | When It Fires                        |
| ------------------ | ------------------------------------ |
| `PreToolUse`       | Before tool calls (can block them)   |
| `PostToolUse`      | After tool calls complete            |
| `UserPromptSubmit` | When users submit prompts            |
| `Notification`     | When Claude Code sends notifications |
| `Stop`             | When Claude Code finishes responding |
| `SubagentStop`     | When subagent tasks complete         |
| `PreCompact`       | Before compact operations            |
| `SessionStart`     | On session initiation or resumption  |
| `SessionEnd`       | When sessions terminate              |

**Common Use Cases:**

- Automated code formatting
- Command logging
- Compliance tracking
- Custom permission systems
- Automated feedback mechanisms

**Security Warning from official docs:**

> "Hooks run automatically during the agent loop with your current environment's credentials, necessitating thorough review before implementation to prevent malicious data exfiltration."
> **Source:** https://docs.claude.com/en/docs/claude-code/hooks-guide.md

---

### 5. MCP Servers

**Purpose:** External tool integration via Model Context Protocol

**Location:** `.mcp.json` at plugin root or inline in `plugin.json`

**Configuration Methods:**

**Option 1: Separate `.mcp.json` file**

```json
{
  "database-tools": {
    "command": "${CLAUDE_PLUGIN_ROOT}/servers/db-server",
    "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"],
    "env": {
      "DB_URL": "${DB_URL}"
    }
  }
}
```

**Option 2: Inline in plugin.json**

```json
{
  "name": "my-plugin",
  "mcpServers": {
    "plugin-api": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/api-server",
      "args": ["--port", "8080"]
    }
  }
}
```

**Key Features:**

> "Plugins define MCP servers in `.mcp.json` at the plugin root or inline in `plugin.json`."
> **Source:** https://docs.claude.com/en/docs/claude-code/mcp.md

**Lifecycle Management:**

- Servers start automatically when plugins activate
- Claude Code requires restart to apply MCP configuration changes

**Environment Variable Support:**

The `${CLAUDE_PLUGIN_ROOT}` variable provides absolute plugin directory path for reliable script and resource references across different installation locations.

**Transport Support:**

- stdio
- SSE (Server-Sent Events)
- HTTP

**Discovery:**
Use `/mcp` command within Claude Code to view all configured servers, including plugin-provided ones.

---

## Skills System

### System Architecture

**Core Design Principle from official docs:**

> "Agent Skills function as model-invoked capabilities rather than user-triggered commands. Claude autonomously decides when to activate skills based on request context and skill descriptions, distinguishing them from slash commands requiring explicit user invocation."
> **Source:** https://docs.claude.com/en/docs/claude-code/skills.md

### Storage Hierarchy

```
Personal Skills (~/.claude/skills/)
├── Individual workflows
└── Available across all projects

Project Skills (.claude/skills/)
├── Team-shared expertise
├── Version-controlled
└── Auto-accessible after git pull

Plugin Skills (plugins/*/skills/)
├── Bundled with plugins
└── Auto-available on install
```

### Skills vs Commands Comparison

| Feature      | Skills                       | Commands              |
| ------------ | ---------------------------- | --------------------- |
| Activation   | Autonomous (Claude decides)  | Manual (user invokes) |
| Trigger      | Task context matching        | Explicit `/command`   |
| Discovery    | Description-based            | Menu listing          |
| Distribution | Plugins (recommended) or Git | Plugins only          |

### SKILL.md Structure

**Complete Template:**

```yaml
---
name: example-skill
description: |
  What this skill does and when Claude should use it.
  Be specific about activation triggers.
allowed-tools:
  - Read
  - Grep
  - Bash
---

# Skill Instructions

## Purpose
Detailed explanation of what this skill accomplishes.

## When to Use
Clear triggers for Claude to recognize.

## Procedure
Step-by-step instructions...

## Supporting Files
- config.yaml
- template.md
```

**Progressive Loading:**

> "Supporting files (scripts, templates, documentation) load progressively to manage context efficiently."
> **Source:** https://docs.claude.com/en/docs/claude-code/skills.md

### Tool Restriction Capabilities

The `allowed-tools` mechanism enables:

1. **Read-only skills** - Prevent file modifications during analysis
2. **Scope-limited operations** - Data analysis without file writing
3. **Security-sensitive workflows** - Restrict capabilities for sensitive tasks

Example restricting to read-only operations:

```yaml
---
name: analyze-codebase
description: Analyze code quality without making changes
allowed-tools:
  - Read
  - Grep
  - Glob
---
```

### Distribution Best Practices

**Official Recommendation:**

> "The documentation recommends distributing skills through plugins as the primary sharing mechanism."
> **Source:** https://docs.claude.com/en/docs/claude-code/skills.md

**Benefits of Plugin Distribution:**

- Automatic availability upon installation
- Version management
- Bundle with related commands/agents
- Centralized team access

**Alternative: Project Skills**

Direct Git-based sharing via `.claude/skills/` serves team-specific expertise not suitable for broader plugin distribution.

---

## Best Practices

### Plugin Development

**1. Directory Structure**

- ✅ Place component directories at plugin root
- ✅ Use `.claude-plugin/plugin.json` for manifest only
- ❌ Don't nest components inside `.claude-plugin/`

**2. Path Management**

- ✅ Use relative paths with `./` prefix
- ✅ Leverage `${CLAUDE_PLUGIN_ROOT}` for scripts
- ❌ Avoid absolute paths

**3. Manifest Validation**

```bash
claude plugin validate .
```

**4. Testing Workflow**

```bash
# Add local marketplace
/plugin marketplace add ./my-marketplace

# Install and test
/plugin install test-plugin@my-marketplace

# Debug if needed
claude --debug
```

### Marketplace Management

**1. Repository-Based Distribution (Recommended)**

- Version control via Git tags
- Issue tracking for bug reports
- Team collaboration features
- Automatic updates via marketplace refresh

**2. Validation Checklist**

- [ ] JSON syntax valid
- [ ] All plugin sources accessible
- [ ] Required files present (plugin.json)
- [ ] Repository permissions configured
- [ ] Documentation complete

**3. Team Configuration**
Add to `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "company-tools": {
      "source": {
        "source": "github",
        "repo": "company/claude-plugins"
      }
    }
  }
}
```

### Skills Development

**1. Description Quality**
Write descriptions that communicate:

- What the skill does
- When Claude should use it
- What triggers activation

**2. Tool Restrictions**
Apply `allowed-tools` for:

- Read-only analysis tasks
- Security-sensitive operations
- Compliance requirements

**3. Progressive Disclosure**
Structure supporting files for efficient context loading:

```
skills/
└── my-skill/
    ├── SKILL.md          # Core instructions
    ├── config.yaml       # Configuration
    └── examples/         # Reference materials
        └── template.md
```

### Hooks Development

**1. Security First**

From official security guidance:

> "Hooks run automatically during the agent loop with your current environment's credentials"
> **Source:** https://docs.claude.com/en/docs/claude-code/hooks-guide.md

Review all hooks thoroughly before implementation.

**2. Common Patterns**

- Code formatting: `PostToolUse` + file type matcher
- Compliance logging: `PreToolUse` + command logger
- Session tracking: `SessionStart`/`SessionEnd` + database

**3. Testing**
Test hooks in isolation before plugin integration:

```bash
# Test hook script directly
./hooks/format.sh test-file.py

# Enable plugin and verify
claude --debug
```

### MCP Server Integration

**1. Path Management**

```json
{
  "command": "${CLAUDE_PLUGIN_ROOT}/servers/my-server",
  "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"]
}
```

**2. Environment Variables**
Use environment variables for sensitive data:

```json
{
  "env": {
    "API_KEY": "${MY_API_KEY}",
    "DB_URL": "${DATABASE_URL}"
  }
}
```

**3. Lifecycle Awareness**

- Servers start when plugins enable
- Restart Claude Code after MCP changes
- Use `/mcp` command to verify server status

### Debugging

**Enable Debug Mode:**

```bash
claude --debug
```

**Debug Output Includes:**

- Plugin loading status
- Manifest validation results
- MCP server initialization
- Hook execution logs

**Common Issues:**

| Problem           | Cause                 | Solution                                        |
| ----------------- | --------------------- | ----------------------------------------------- |
| Plugin won't load | Invalid JSON          | Validate syntax with `claude plugin validate .` |
| Missing commands  | Wrong directory       | Move `commands/` to plugin root                 |
| Hooks not firing  | Missing permissions   | Apply `chmod +x` to scripts                     |
| MCP fails         | Missing path variable | Use `${CLAUDE_PLUGIN_ROOT}`                     |
| Path errors       | Absolute paths        | Use relative paths with `./`                    |

---

## Official Documentation References

### Primary Documentation Pages

1. **Plugins Overview**
   - URL: https://docs.claude.com/en/docs/claude-code/plugins.md
   - Topics: Plugin creation, installation, development workflow

2. **Plugin Marketplaces**
   - URL: https://docs.claude.com/en/docs/claude-code/plugin-marketplaces.md
   - Topics: marketplace.json schema, distribution, team configuration

3. **Plugin Reference**
   - URL: https://docs.claude.com/en/docs/claude-code/plugins-reference.md
   - Topics: Technical specifications, schemas, debugging

4. **Skills System**
   - URL: https://docs.claude.com/en/docs/claude-code/skills.md
   - Topics: SKILL.md format, allowed-tools, skill hierarchy

5. **Hooks Guide**
   - URL: https://docs.claude.com/en/docs/claude-code/hooks-guide.md
   - Topics: Hook events, security, common patterns

6. **MCP Integration**
   - URL: https://docs.claude.com/en/docs/claude-code/mcp.md
   - Topics: MCP server configuration, lifecycle management

### Documentation Map

Main documentation index:

- URL: https://docs.claude.com/en/docs/claude-code/claude_code_docs_map.md
- Purpose: Complete documentation navigation

---

## Appendix: Key Terminology

**Plugin:** Container for distributing Commands, Agents, Skills, Hooks, and MCP servers

**Marketplace:** JSON catalog listing available plugins with source locations

**Skill:** Model-invoked capability that Claude activates autonomously based on task context

**Command:** User-invoked slash command requiring explicit activation

**Agent:** Specialized subagent for domain-specific tasks

**Hook:** Shell command executing at specific agent lifecycle points

**MCP Server:** External tool integration via Model Context Protocol

**plugin.json:** Plugin manifest defining metadata and component locations

**marketplace.json:** Marketplace catalog listing available plugins

**SKILL.md:** Skill definition file with YAML frontmatter and instructions

**allowed-tools:** YAML frontmatter field restricting Claude's tool access during skill execution

**${CLAUDE_PLUGIN_ROOT}:** Environment variable resolving to plugin installation directory

---

## Document Maintenance

**Version:** 1.0.0
**Last Updated:** 2025-10-25
**Research Methodology:** WebFetch of official Claude Code documentation
**Documentation Snapshot:** October 2025

**Maintenance Notes:**

- This document represents official documentation as of October 2025
- Check official docs for updates: https://docs.claude.com/en/docs/claude-code/
- All quotes sourced directly from official documentation
- File paths and schemas verified against official examples

**Change History:**

- 1.0.0 (2025-10-25): Initial comprehensive research report
