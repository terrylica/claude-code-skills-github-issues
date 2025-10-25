# Plugin vs Marketplace vs Skills: Complete Comparison

**Last Updated:** 2025-10-25
**Purpose:** Clarify differences between core Claude Code plugin system concepts

---

## Quick Answer

```
┌──────────────────────────────────────────────────────────────┐
│                    WHAT'S WHAT?                              │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  MARKETPLACE = Catalog (JSON file listing plugins)          │
│  PLUGIN      = Container (bundles components)               │
│  SKILL       = Component (model-invoked capability)         │
│                                                              │
│  Analogy:                                                    │
│  Marketplace = App Store                                     │
│  Plugin      = Application                                   │
│  Skill       = Feature within application                    │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## Comprehensive Comparison Table

| Aspect              | Marketplace                           | Plugin                               | Skill                            |
| ------------------- | ------------------------------------- | ------------------------------------ | -------------------------------- |
| **Purpose**         | Lists available plugins               | Bundles functionality                | Autonomous capability            |
| **File Type**       | `marketplace.json`                    | Directory with `plugin.json`         | `SKILL.md` in skills/ directory  |
| **Location**        | GitHub/Git/Local                      | Referenced by marketplace            | Inside plugin or project         |
| **Contains**        | Plugin references                     | Commands, Agents, Skills, Hooks, MCP | Instructions + config            |
| **Distribution**    | Repository URL                        | Via marketplace                      | Via plugin or git                |
| **Activation**      | `/plugin marketplace add`             | `/plugin install`                    | Automatic by Claude              |
| **User Action**     | Add once                              | Install/enable                       | None (autonomous)                |
| **Versioning**      | Marketplace version + plugin versions | Plugin version                       | Inherited from plugin/project    |
| **Scope**           | Collection of plugins                 | Single distributable unit            | Single task/capability           |
| **Required Fields** | name, owner, plugins[]                | name in plugin.json                  | name, description in frontmatter |

---

## Detailed Breakdown

### Marketplace

**What it is:**

> "A marketplace is fundamentally a JSON file that lists available plugins and describes where to find them."
> **Source:** https://docs.claude.com/en/docs/claude-code/plugin-marketplaces.md

**Purpose:**

- Central catalog of available plugins
- Distribution mechanism
- Team organization

**Structure:**

```json
{
  "name": "my-marketplace",
  "owner": { "name": "Marketplace Owner" },
  "plugins": [
    { "name": "plugin1", "source": "./plugin1" },
    { "name": "plugin2", "source": { "source": "github", "repo": "user/repo" } }
  ]
}
```

**Hosted on:**

- GitHub repositories
- GitLab/other Git services
- Local filesystem
- Direct URLs

**Commands:**

```bash
/plugin marketplace add owner/repo
/plugin marketplace list
/plugin marketplace update marketplace-name
/plugin marketplace remove marketplace-name
```

**Lifecycle:**

1. Created by plugin author/organization
2. Added by users via `/plugin marketplace add`
3. Updated periodically to refresh plugin listings
4. Removed when no longer needed

**One marketplace can contain:**

- Multiple plugins
- Plugins from different sources (local, GitHub, Git URLs)
- Version specifications
- Metadata and descriptions

---

### Plugin

**What it is:**
Container for distributing Claude Code extensions (Commands, Agents, Skills, Hooks, MCP Servers)

**Purpose:**

- Bundle related functionality
- Distribute components as a unit
- Version management
- Team collaboration

**Structure:**

```
plugin-directory/
├── .claude-plugin/plugin.json  (manifest)
├── commands/                    (optional)
├── agents/                      (optional)
├── skills/                      (optional)
├── hooks/                       (optional)
└── .mcp.json                    (optional)
```

**Manifest (plugin.json):**

```json
{
  "name": "my-plugin",
  "description": "What this plugin does",
  "version": "1.0.0",
  "author": {"name": "Plugin Author"},
  "commands": "./commands",
  "mcpServers": {...}
}
```

**Commands:**

```bash
/plugin install plugin-name@marketplace-name
/plugin enable plugin-name@marketplace-name
/plugin disable plugin-name@marketplace-name
/plugin uninstall plugin-name@marketplace-name
/plugin  # Browse interactively
```

**Lifecycle:**

1. Created by developer with `.claude-plugin/plugin.json`
2. Listed in marketplace
3. Installed by users
4. Enabled/disabled as needed
5. Updated via marketplace refresh

**One plugin can contain:**

- Multiple commands
- Multiple agents
- Multiple skills
- Hook configurations
- MCP server definitions

---

### Skill

**What it is:**

> "Skills are model-invoked—Claude autonomously uses them based on the task context."
> **Source:** https://docs.claude.com/en/docs/claude-code/plugins.md

**Purpose:**

- Model-invoked capabilities
- Autonomous task completion
- Contextual activation
- Tool access restriction

**Structure:**

```
skills/
└── my-skill/
    ├── SKILL.md          (required)
    ├── config.yaml       (optional)
    └── templates/        (optional)
```

**SKILL.md Format:**

```yaml
---
name: skill-name
description: What it does and when Claude should use it
allowed-tools:
  - Read
  - Grep
---
# Skill Instructions

Detailed instructions for Claude...
```

**No user commands** - Skills activate automatically when Claude detects matching context

**Lifecycle:**

1. Created as SKILL.md file
2. Placed in one of three locations:
   - Personal: `~/.claude/skills/`
   - Project: `.claude/skills/`
   - Plugin: `plugins/*/skills/`
3. Loaded automatically by Claude Code
4. Activated autonomously by Claude when context matches
5. Executes with optional tool restrictions

**Three skill sources:**

- **Personal Skills** (`~/.claude/skills/`) - Individual workflows
- **Project Skills** (`.claude/skills/`) - Team-shared, version-controlled
- **Plugin Skills** (`plugins/*/skills/`) - Distributed with plugins

---

## Hierarchical Relationships

```
Marketplace
├── Plugin 1
│   ├── Command A
│   ├── Command B
│   ├── Agent X
│   ├── Skill Alpha
│   │   └── SKILL.md
│   ├── Skill Beta
│   │   └── SKILL.md
│   ├── Hooks
│   └── MCP Server
├── Plugin 2
│   ├── Command C
│   ├── Skill Gamma
│   │   └── SKILL.md
│   └── Hooks
└── Plugin 3
    ├── Agent Y
    ├── Skill Delta
    │   └── SKILL.md
    └── MCP Server
```

**Key Insight:**

- Marketplace **contains** plugins
- Plugin **contains** skills (and other components)
- Skill is a **leaf component** (doesn't contain other things)

---

## Activation Comparison

### Marketplace Activation

**User-initiated, explicit:**

```bash
/plugin marketplace add owner/repo
```

**Result:**

- Marketplace registered
- Plugins become browsable
- No automatic installation

---

### Plugin Activation

**User-initiated, explicit:**

```bash
/plugin install plugin-name@marketplace-name
/plugin enable plugin-name@marketplace-name
```

**Result:**

- Plugin components loaded
- Commands available via slash commands
- Skills/Agents registered for auto-activation
- Hooks start executing
- MCP servers start

**Alternative: Automatic via team settings**

```json
{
  "extraKnownMarketplaces": {...},
  "enabledPlugins": ["plugin@marketplace"]
}
```

---

### Skill Activation

**Claude-initiated, autonomous:**

No user command needed. Claude activates when:

1. User message matches skill description
2. Task context aligns with skill purpose
3. Skill's triggering conditions met

**Example:**

```
User: "Analyze this database query performance"

Claude detects:
- Keywords: analyze, performance, database
- Available skill: analyze-performance/SKILL.md
  description: "Analyze database query performance..."

Result: Skill activates automatically ✓
```

---

## Distribution Comparison

### Marketplace Distribution

**Hosting:**

- GitHub repository (recommended)
- GitLab or other Git services
- Local directory
- Direct URL to JSON file

**Sharing:**

```bash
# Share repository URL
"Add our marketplace: /plugin marketplace add company/plugins"

# Share Git URL
"Add marketplace: /plugin marketplace add https://gitlab.com/team/tools.git"
```

**Update mechanism:**

```bash
/plugin marketplace update marketplace-name
```

---

### Plugin Distribution

**Only via marketplace** - plugins must be listed in a marketplace.json

**Marketplace references plugin source:**

```json
{
  "plugins": [
    {
      "name": "my-plugin",
      "source": "./relative/path" // Same repo
    },
    {
      "name": "github-plugin",
      "source": {
        "source": "github",
        "repo": "owner/plugin-repo" // Different repo
      }
    },
    {
      "name": "git-plugin",
      "source": {
        "source": "url",
        "url": "https://gitlab.com/team/p.git" // Any Git URL
      }
    }
  ]
}
```

**Cannot install plugins directly** - must be in marketplace first

---

### Skill Distribution

**Three methods:**

1. **Via Plugin (Recommended)**

   > "The documentation recommends distributing skills through plugins as the primary sharing mechanism."
   > **Source:** https://docs.claude.com/en/docs/claude-code/skills.md

   ```
   plugin/skills/my-skill/SKILL.md
   ```

2. **Via Project Git**

   ```
   .claude/skills/team-skill/SKILL.md
   ```

   Team members get skill when they clone/pull

3. **Personal Installation**
   ```
   ~/.claude/skills/personal-skill/SKILL.md
   ```
   Manual file placement

---

## Versioning Comparison

### Marketplace Versioning

**Optional but recommended:**

```json
{
  "name": "my-marketplace",
  "metadata": {
    "version": "1.5.0"
  },
  "plugins": [...]
}
```

**Marketplace version** = catalog version

- Tracks marketplace structure changes
- Independent of plugin versions

---

### Plugin Versioning

**Required in plugin.json:**

```json
{
  "name": "my-plugin",
  "version": "2.1.0"
}
```

**Semantic versioning:**

- MAJOR.MINOR.PATCH
- MAJOR: Breaking changes
- MINOR: New features
- PATCH: Bug fixes

**Can be overridden in marketplace:**

```json
{
  "plugins": [
    {
      "name": "my-plugin",
      "version": "2.0.0" // Override plugin's declared version
    }
  ]
}
```

---

### Skill Versioning

**No explicit skill versioning**

Skills inherit version from their container:

- Plugin skills → plugin version
- Project skills → project/repo version (Git tags)
- Personal skills → no formal versioning

**Version control via:**

- Git commits for project skills
- Plugin version for plugin skills
- Manual management for personal skills

---

## Use Cases

### When to Create a Marketplace

✅ **Create marketplace when:**

- Distributing multiple related plugins
- Organizing team/company plugins
- Curating plugin collections
- Maintaining plugin catalog for organization

❌ **Don't create marketplace when:**

- Only have one plugin (use existing marketplace)
- Just testing locally (use local directory)
- Contributing to existing ecosystem (submit to existing marketplace)

**Example:**

```
Company has 10 internal plugins → Create company marketplace
Individual developer has 1 plugin → Submit to community marketplace
```

---

### When to Create a Plugin

✅ **Create plugin when:**

- Bundling related functionality (commands + skills + hooks)
- Distributing reusable components
- Managing versions as a unit
- Sharing with team or community

❌ **Don't create plugin when:**

- Only need a single skill (use project skills)
- Personal workflow (use personal skills in ~/.claude/skills/)
- One-off automation (create command or hook directly)

**Example:**

```
Database toolkit: commands + MCP server + skills → Plugin ✓
Single analysis skill for project → .claude/skills/ ✓
Personal git workflow → ~/.claude/skills/ ✓
```

---

### When to Create a Skill

✅ **Create skill when:**

- Want Claude to autonomously handle specific tasks
- Need context-based activation
- Require tool access restrictions
- Building reusable capabilities

❌ **Don't create skill when:**

- Need explicit user control (use command instead)
- One-time operation (direct Claude instruction)
- Simple prompt template (use command)

**Skills vs Commands:**

| Use Skill                | Use Command              |
| ------------------------ | ------------------------ |
| Autonomous activation    | Explicit user invocation |
| Context-based            | User chooses when        |
| "Analyze code quality"   | "Run linter"             |
| "Optimize performance"   | "Show metrics"           |
| Tool restrictions needed | Full tool access OK      |

---

## Commands Reference

### Marketplace Commands

```bash
# Add marketplace
/plugin marketplace add owner/repo
/plugin marketplace add https://git.host/repo.git
/plugin marketplace add ./local/path
/plugin marketplace add https://url/marketplace.json

# Manage marketplaces
/plugin marketplace list
/plugin marketplace update marketplace-name
/plugin marketplace remove marketplace-name
```

---

### Plugin Commands

```bash
# Install & manage
/plugin install plugin-name@marketplace-name
/plugin enable plugin-name@marketplace-name
/plugin disable plugin-name@marketplace-name
/plugin uninstall plugin-name@marketplace-name

# Browse
/plugin  # Interactive menu

# Validation
claude plugin validate .
claude --debug
```

---

### Skill Commands

**No explicit commands** - Skills are managed via their storage location:

**Personal Skills:**

```bash
# Create
mkdir -p ~/.claude/skills/my-skill
cat > ~/.claude/skills/my-skill/SKILL.md <<EOF
---
name: my-skill
description: What it does
---
Instructions...
EOF

# Claude loads automatically
```

**Project Skills:**

```bash
# Create in project
mkdir -p .claude/skills/team-skill
# Create SKILL.md
# Commit to version control
git add .claude/skills/
git commit -m "Add team skill"

# Team members get skill via git pull
```

**Plugin Skills:**

```bash
# Created as part of plugin
# Distributed via plugin installation
# No separate management needed
```

---

## File Structure Comparison

### Marketplace Structure

```
marketplace-repo/
├── .claude-plugin/
│   └── marketplace.json     ← Single required file
├── README.md                 (recommended)
└── plugins/                  (if hosting plugins in same repo)
    ├── plugin-1/
    └── plugin-2/
```

**Minimal marketplace:**

```
marketplace.json only (can be standalone file)
```

---

### Plugin Structure

```
plugin-repo/
├── .claude-plugin/
│   └── plugin.json          ← Required manifest
├── commands/                 (optional)
│   ├── cmd1.md
│   └── cmd2.md
├── agents/                   (optional)
│   └── agent.md
├── skills/                   (optional)
│   ├── skill-1/
│   │   └── SKILL.md
│   └── skill-2/
│       └── SKILL.md
├── hooks/                    (optional)
│   └── hooks.json
├── .mcp.json                 (optional)
└── README.md                 (recommended)
```

**Minimal plugin:**

```
.claude-plugin/plugin.json only (empty plugin)
```

---

### Skill Structure

```
skill-directory/
├── SKILL.md                  ← Required
├── config.yaml               (optional)
├── templates/                (optional)
│   └── template.md
└── scripts/                  (optional)
    └── helper.sh
```

**Minimal skill:**

```yaml
# SKILL.md only
---
name: skill-name
description: Description
---
# Instructions
```

---

## Security Implications

### Marketplace Security

**Trust boundary: Repository**

When you add a marketplace, you're trusting:

- The marketplace maintainer
- All plugins listed in the marketplace
- Plugin sources referenced

**Verification:**

```bash
# Review marketplace.json before adding
curl https://raw.githubusercontent.com/owner/repo/main/.claude-plugin/marketplace.json

# Check plugin sources
# Review repository contents
```

---

### Plugin Security

**Trust boundary: Plugin components**

When you install a plugin, you're enabling:

- Commands (user-invoked, lower risk)
- Skills (auto-invoked, review descriptions)
- Agents (auto-invoked, review capabilities)
- **Hooks (auto-execute with your credentials!)** ⚠️
- MCP servers (run with your environment)

**Critical from official docs:**

> "Hooks run automatically during the agent loop with your current environment's credentials"
> **Source:** https://docs.claude.com/en/docs/claude-code/hooks-guide.md

**Review before enabling:**

```bash
# Examine plugin contents
gh repo clone owner/plugin-repo
cd plugin-repo
cat .claude-plugin/plugin.json
cat hooks/hooks.json
ls -la hooks/scripts/
```

---

### Skill Security

**Trust boundary: Tool access**

Skills can restrict their own tool access via `allowed-tools`:

**Restricted skill (safer):**

```yaml
---
name: analyze-code
description: Analyze code quality
allowed-tools:
  - Read
  - Grep
---
```

**Unrestricted skill:**

```yaml
---
name: modify-code
description: Refactor code
# No allowed-tools = full access
---
```

**Best practice:**

> "Use `allowed-tools` to restrict skill capabilities"
> **Source:** Research findings from official docs

---

## Common Confusion Points

### Confusion 1: "Is a skill a type of plugin?"

**Answer:** No

- **Skill** = Component (capability)
- **Plugin** = Container (bundles components including skills)

A skill can exist in:

- A plugin (`plugin/skills/`)
- A project (`.claude/skills/`)
- Personal directory (`~/.claude/skills/`)

---

### Confusion 2: "Can I install skills directly?"

**Answer:** No explicit installation

Skills are:

- **Created** as files in specific directories
- **Loaded** automatically by Claude Code
- **Activated** autonomously by Claude based on context

Not installed like plugins with commands.

---

### Confusion 3: "Do I need a marketplace to use plugins?"

**Answer:** Yes, for distribution

```
Plugin must be → Listed in marketplace → Added to Claude Code
```

Cannot install plugin directly without marketplace.

**Workaround for testing:**

```bash
# Create minimal local marketplace
echo '{
  "name": "test",
  "owner": {"name": "Me"},
  "plugins": [{"name": "my-plugin", "source": "./my-plugin"}]
}' > marketplace.json

/plugin marketplace add ./marketplace.json
```

---

### Confusion 4: "Can a marketplace be a plugin?"

**Answer:** No

- **Marketplace** = JSON catalog listing plugins
- **Plugin** = Directory with components

Completely different purposes, cannot be combined.

---

### Confusion 5: "Are commands and skills the same?"

**Answer:** No - different activation models

| Commands                 | Skills                     |
| ------------------------ | -------------------------- |
| User types `/command`    | Claude decides when to use |
| Explicit activation      | Autonomous activation      |
| Always available in menu | Context-based discovery    |
| Manual trigger           | Automatic trigger          |

**Example:**

- **Command:** `/deploy` - User must type this
- **Skill:** deployment-automation - Claude uses when it detects deployment task

---

## Decision Tree

### Should I create a Marketplace, Plugin, or Skill?

```
START: I want to distribute functionality
│
├─ Multiple related plugins to organize?
│  YES → Create MARKETPLACE
│  NO → Continue
│
├─ Bundle multiple components together?
│  (commands + skills + hooks + MCP)
│  YES → Create PLUGIN
│  NO → Continue
│
├─ Single autonomous capability?
│  Activated by Claude based on context?
│  YES → Create SKILL
│  NO → Continue
│
├─ User-invoked functionality?
│  Explicit /command activation?
│  YES → Create COMMAND (in plugin or directly)
│  NO → Continue
│
└─ Event-driven automation?
   Hooks or MCP server?
   YES → Create HOOK/MCP CONFIG (in plugin)
```

---

## Real-World Examples

### Example 1: Company Internal Tools

**Scenario:** Company has database tools, deployment tools, and coding standards

**Solution:**

```
company/claude-plugins                     ← MARKETPLACE (GitHub repo)
├── .claude-plugin/marketplace.json
└── plugins/
    ├── database-toolkit/                  ← PLUGIN
    │   ├── .claude-plugin/plugin.json
    │   ├── commands/
    │   │   ├── db-query.md               (user runs /db-query)
    │   │   └── db-migrate.md             (user runs /db-migrate)
    │   ├── skills/
    │   │   ├── query-optimization/
    │   │   │   └── SKILL.md              ← SKILL (auto by Claude)
    │   │   └── schema-analysis/
    │   │       └── SKILL.md              ← SKILL (auto by Claude)
    │   └── .mcp.json                     (database MCP server)
    │
    ├── deploy-tools/                      ← PLUGIN
    │   ├── .claude-plugin/plugin.json
    │   ├── commands/
    │   │   └── deploy.md                 (user runs /deploy)
    │   └── hooks/
    │       └── hooks.json                (auto-run on deploy)
    │
    └── coding-standards/                  ← PLUGIN
        ├── .claude-plugin/plugin.json
        ├── skills/
        │   ├── code-review/
        │   │   └── SKILL.md              ← SKILL (auto by Claude)
        │   └── lint-check/
        │       └── SKILL.md              ← SKILL (auto by Claude)
        └── hooks/
            └── hooks.json                (auto-format on save)
```

**User experience:**

```bash
# One-time setup
/plugin marketplace add company/claude-plugins

# Install all company tools
/plugin install database-toolkit@company
/plugin install deploy-tools@company
/plugin install coding-standards@company

# Use commands explicitly
/db-query
/deploy

# Skills activate automatically
"Optimize this query" → query-optimization skill activates
"Review this code" → code-review skill activates
```

---

### Example 2: Open Source Community Plugin

**Scenario:** Developer creates Git workflow plugin for community

**Solution:**

```
GitHub: awesome-claude-plugins/marketplace  ← MARKETPLACE
└── .claude-plugin/marketplace.json
    {
      "plugins": [
        {
          "name": "git-workflow",
          "source": {
            "source": "github",
            "repo": "developer/git-workflow-plugin"
          }
        }
      ]
    }

GitHub: developer/git-workflow-plugin        ← PLUGIN
├── .claude-plugin/plugin.json
├── commands/
│   ├── git-pr.md                           (user runs /git-pr)
│   └── git-review.md                       (user runs /git-review)
└── skills/
    ├── commit-message-helper/
    │   └── SKILL.md                        ← SKILL (auto by Claude)
    └── branch-strategy/
        └── SKILL.md                        ← SKILL (auto by Claude)
```

**Community member experience:**

```bash
# Add community marketplace
/plugin marketplace add awesome-claude-plugins/marketplace

# Install git workflow plugin
/plugin install git-workflow@awesome-claude-plugins

# Commands available
/git-pr
/git-review

# Skills activate automatically
"Write a commit message for these changes" → commit-message-helper activates
"What branch should I use?" → branch-strategy activates
```

---

### Example 3: Personal Productivity Skills

**Scenario:** Individual wants personal productivity skills, not for distribution

**Solution:**

```
~/.claude/skills/                           ← PERSONAL SKILLS (no plugin)
├── daily-standup/
│   └── SKILL.md                            ← SKILL (auto by Claude)
├── meeting-notes/
│   └── SKILL.md                            ← SKILL (auto by Claude)
└── time-tracking/
    └── SKILL.md                            ← SKILL (auto by Claude)
```

**No marketplace, no plugin needed!**

**User experience:**

```bash
# Create skills manually
mkdir -p ~/.claude/skills/daily-standup
cat > ~/.claude/skills/daily-standup/SKILL.md <<EOF
---
name: daily-standup
description: Generate daily standup notes from git commits and calendar
---
Instructions...
EOF

# Skills activate automatically across all projects
"Generate my standup notes" → daily-standup activates
"Summarize this meeting" → meeting-notes activates
```

---

## Summary Table

| Aspect              | Marketplace               | Plugin                           | Skill                   |
| ------------------- | ------------------------- | -------------------------------- | ----------------------- |
| **Is it a...**      | Catalog                   | Container                        | Component               |
| **Contains**        | Plugin references         | Commands/Skills/Agents/Hooks/MCP | Instructions            |
| **File**            | marketplace.json          | Directory with plugin.json       | SKILL.md                |
| **Distributed via** | Repository URL            | Marketplace listing              | Plugin/Project/Personal |
| **User adds**       | `/plugin marketplace add` | `/plugin install`                | Create file             |
| **Activates**       | N/A (just a list)         | User enables                     | Claude auto-activates   |
| **Versioned**       | Optional                  | Required                         | Inherits from container |
| **Can contain**     | Plugins                   | Components                       | Supporting files        |
| **Required for**    | Distribution              | Bundling                         | Autonomous tasks        |

---

## Official Documentation

**Full Research Report:** [CLAUDE_CODE_PLUGIN_SYSTEM.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/CLAUDE_CODE_PLUGIN_SYSTEM.md)

**Official Docs:**

- Plugins: https://docs.claude.com/en/docs/claude-code/plugins.md
- Marketplaces: https://docs.claude.com/en/docs/claude-code/plugin-marketplaces.md
- Skills: https://docs.claude.com/en/docs/claude-code/skills.md

---

**Version:** 1.0.0 | **Created:** 2025-10-25
