# Claude Code Plugin System: Architecture Diagrams

**Last Updated:** 2025-10-25
**Purpose:** Visual representations of plugin system architecture

---

## System Overview

```
┌───────────────────────────────────────────────────────────────┐
│                    CLAUDE CODE CLI                            │
└────────────────┬──────────────────────────────────────────────┘
                 │
                 │ Loads marketplaces from
                 ▼
┌───────────────────────────────────────────────────────────────┐
│                  MARKETPLACE LAYER                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │   GitHub    │  │   GitLab    │  │   Local     │          │
│  │   Repos     │  │   Repos     │  │   Files     │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
│                                                               │
│  Each contains: marketplace.json                             │
│  {                                                            │
│    "name": "my-marketplace",                                 │
│    "plugins": [...]                                          │
│  }                                                            │
└────────────────┬──────────────────────────────────────────────┘
                 │
                 │ References plugins at
                 ▼
┌───────────────────────────────────────────────────────────────┐
│                    PLUGIN LAYER                               │
│  ┌─────────────────────────────────────────────┐            │
│  │  Plugin Directory                           │            │
│  │  ├── .claude-plugin/                        │            │
│  │  │   └── plugin.json (manifest)             │            │
│  │  ├── commands/                               │            │
│  │  ├── agents/                                 │            │
│  │  ├── skills/                                 │            │
│  │  ├── hooks/hooks.json                        │            │
│  │  └── .mcp.json                               │            │
│  └─────────────────────────────────────────────┘            │
└────────────────┬──────────────────────────────────────────────┘
                 │
                 │ Contains 5 component types
                 ▼
┌───────────────────────────────────────────────────────────────┐
│                  COMPONENT LAYER                              │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐        │
│  │Commands │  │ Agents  │  │ Skills  │  │  Hooks  │        │
│  │ (User)  │  │(Claude) │  │(Claude) │  │ (Auto)  │        │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘        │
│                            ┌─────────┐                       │
│                            │   MCP   │                       │
│                            │ Servers │                       │
│                            └─────────┘                       │
└───────────────────────────────────────────────────────────────┘
```

---

## Plugin File Structure

```
my-plugin/                              ← Plugin root
│
├── .claude-plugin/                     ← Configuration directory
│   └── plugin.json                     ← REQUIRED manifest
│       {
│         "name": "my-plugin",
│         "version": "1.0.0",
│         "description": "...",
│         "author": {...}
│       }
│
├── commands/                           ← User-invoked slash commands
│   ├── hello.md                        ← /hello command
│   └── deploy.md                       ← /deploy command
│
├── agents/                             ← Claude-invoked specialists
│   ├── code-reviewer.md                ← Code review agent
│   └── security-auditor.md             ← Security agent
│
├── skills/                             ← Model-invoked capabilities
│   ├── analyze-performance/
│   │   ├── SKILL.md                    ← Skill definition
│   │   ├── config.yaml                 ← Configuration
│   │   └── templates/                  ← Supporting files
│   └── database-migration/
│       └── SKILL.md
│
├── hooks/                              ← Event automation
│   ├── hooks.json                      ← Hook configuration
│   └── scripts/
│       ├── format.sh                   ← PostToolUse formatter
│       └── validate.sh                 ← PreToolUse validator
│
└── .mcp.json                           ← MCP server config
    {
      "database-tools": {
        "command": "${CLAUDE_PLUGIN_ROOT}/servers/db",
        "args": ["--config", "..."]
      }
    }
```

---

## Marketplace Distribution Flow

```
CREATION                    DISTRIBUTION                CONSUMPTION
────────                    ────────────                ───────────

Developer                   GitHub/GitLab               End User
creates plugin              hosts marketplace           installs plugin
    │                            │                           │
    ▼                            ▼                           ▼
┌─────────┐                ┌──────────┐              ┌──────────┐
│ Plugin  │  git push      │ Remote   │  /plugin     │  Claude  │
│ Files   │ ─────────────> │ Repo     │  marketplace │   Code   │
│         │                │          │  add         │   CLI    │
└─────────┘                └──────────┘              └──────────┘
    │                            │                           │
    │                            │                           │
    ▼                            ▼                           ▼
Creates:                   Contains:                   Executes:
• plugin.json             • marketplace.json          • /plugin install
• commands/               • Multiple plugins          • /plugin enable
• skills/                 • References to
• hooks/                    plugin sources
• .mcp.json

                                                      Claude accesses:
                                                      • Commands via /cmd
                                                      • Skills auto
                                                      • Agents auto
                                                      • Hooks auto
                                                      • MCP servers auto
```

---

## Component Activation Model

```
┌─────────────────────────────────────────────────────────────┐
│                    USER INTERACTION                         │
└──────┬──────────────────────────────────────────────────────┘
       │
       │ Types message or command
       ▼
┌─────────────────────────────────────────────────────────────┐
│                  CLAUDE CODE AGENT                          │
│                                                             │
│  ┌────────────────────────────────────────┐                │
│  │  1. Check for explicit slash command   │                │
│  │     /hello → Activate Command          │────┐           │
│  └────────────────────────────────────────┘    │           │
│                      │                          │           │
│                      │ No explicit command      │           │
│                      ▼                          │           │
│  ┌────────────────────────────────────────┐    │           │
│  │  2. Analyze task context               │    │           │
│  │     Match against skill descriptions   │    │           │
│  │     → Auto-activate relevant Skills    │────┤           │
│  └────────────────────────────────────────┘    │           │
│                      │                          │           │
│                      │                          │           │
│                      ▼                          │           │
│  ┌────────────────────────────────────────┐    │           │
│  │  3. Select specialized Agent if needed │    │           │
│  │     → Auto-delegate to Agent           │────┤           │
│  └────────────────────────────────────────┘    │           │
│                      │                          │           │
│                      │                          │           │
│                      ▼                          │           │
│  ┌────────────────────────────────────────┐    │           │
│  │  4. Execute tool operations            │    │           │
│  │     → Hooks fire at lifecycle points   │────┘           │
│  └────────────────────────────────────────┘                │
│                      │                                      │
│                      │ Throughout execution                │
│                      ▼                                      │
│  ┌────────────────────────────────────────┐                │
│  │  5. MCP Servers provide tools          │                │
│  │     → Always available when enabled    │                │
│  └────────────────────────────────────────┘                │
│                                                             │
└─────────────────────────────────────────────────────────────┘

ACTIVATION SUMMARY:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Commands:     USER → /command
Skills:       CLAUDE → Context match → Auto-activate
Agents:       CLAUDE → Task analysis → Auto-delegate
Hooks:        EVENT → Lifecycle point → Auto-execute
MCP Servers:  ENABLED → Always available
```

---

## Skills Discovery & Activation

```
USER REQUEST: "Analyze the performance of this database query"
│
▼
┌─────────────────────────────────────────────────────────────┐
│              CLAUDE ANALYZES TASK CONTEXT                   │
│  • Keywords: "analyze", "performance", "database"           │
│  • Intent: Investigation/analysis task                      │
└────────────────┬────────────────────────────────────────────┘
                 │
                 │ Scans available skills
                 ▼
┌─────────────────────────────────────────────────────────────┐
│               SKILL LIBRARY (3 sources)                     │
│                                                             │
│  Personal Skills (~/.claude/skills/)                        │
│  ├── terminal-optimization/SKILL.md                        │
│  └── git-workflow/SKILL.md                                 │
│                                                             │
│  Project Skills (.claude/skills/)                          │
│  ├── team-coding-standards/SKILL.md                        │
│  └── deployment-procedures/SKILL.md                        │
│                                                             │
│  Plugin Skills (plugins/*/skills/)                         │
│  ├── analyze-performance/SKILL.md  ← MATCH! ✓             │
│  │   "description: Analyze database query performance..."  │
│  ├── database-migration/SKILL.md                           │
│  └── code-quality/SKILL.md                                 │
└────────────────┬────────────────────────────────────────────┘
                 │
                 │ Loads matched skill
                 ▼
┌─────────────────────────────────────────────────────────────┐
│           SKILL ACTIVATION & EXECUTION                      │
│                                                             │
│  analyze-performance/SKILL.md loaded:                      │
│  ───────────────────────────────────────                   │
│  name: analyze-performance                                 │
│  description: Analyze database query performance...        │
│  allowed-tools: [Read, Grep, Bash]                        │
│  ───────────────────────────────────────                   │
│                                                             │
│  Tool restrictions applied: ✓                              │
│  • Can use: Read, Grep, Bash                               │
│  • Cannot use: Write, Edit (read-only analysis)            │
│                                                             │
│  Supporting files loaded progressively:                    │
│  • config.yaml                                             │
│  • templates/analysis-template.md                          │
└─────────────────────────────────────────────────────────────┘
```

---

## Hook Lifecycle Integration

```
USER MESSAGE SUBMITTED
│
▼
┌────────────────────────────────────────┐
│  UserPromptSubmit Hook                 │ ← Log user request
└────────────────┬───────────────────────┘
                 │
                 ▼
         Claude processes request
                 │
                 ▼
┌────────────────────────────────────────┐
│  PreToolUse Hook                       │ ← Validate operation
│  • Check permissions                   │
│  • Log command                         │
│  • Can BLOCK if validation fails       │
└────────────────┬───────────────────────┘
                 │
                 │ If approved
                 ▼
         Tool executes (Write, Edit, etc.)
                 │
                 ▼
┌────────────────────────────────────────┐
│  PostToolUse Hook                      │ ← Auto-format files
│  • Run linters/formatters              │
│  • Update documentation                │
│  • Generate artifacts                  │
└────────────────┬───────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────┐
│  Notification Hook                     │ ← Send alerts
│  • Team notifications                  │
│  • Status updates                      │
└────────────────┬───────────────────────┘
                 │
                 ▼
         Claude completes response
                 │
                 ▼
┌────────────────────────────────────────┐
│  Stop Hook                             │ ← Cleanup actions
│  • Save session state                  │
│  • Update metrics                      │
└────────────────────────────────────────┘

SUBAGENT PATH:
│
├─ SubagentStop Hook ──────────────────────→ Subagent cleanup
│
PRE-COMPACT PATH:
│
└─ PreCompact Hook ─────────────────────────→ Before compaction

SESSION LIFECYCLE:
SessionStart Hook ──→ Init ──→ ... ──→ SessionEnd Hook
```

---

## MCP Server Integration

```
┌─────────────────────────────────────────────────────────────┐
│                   PLUGIN WITH MCP SERVER                    │
│                                                             │
│  .claude-plugin/plugin.json:                               │
│  {                                                          │
│    "name": "database-tools",                               │
│    "mcpServers": {                                         │
│      "db-server": {                                        │
│        "command": "${CLAUDE_PLUGIN_ROOT}/servers/db",     │
│        "env": {"DB_URL": "${DATABASE_URL}"}               │
│      }                                                      │
│    }                                                        │
│  }                                                          │
└────────────────┬────────────────────────────────────────────┘
                 │
                 │ Plugin enabled
                 ▼
┌─────────────────────────────────────────────────────────────┐
│              MCP SERVER LIFECYCLE                           │
│                                                             │
│  1. Plugin Enable                                           │
│     /plugin enable database-tools@marketplace              │
│                                                             │
│  2. Claude Code Restart (required for MCP changes)         │
│                                                             │
│  3. Server Startup                                          │
│     Command: ${CLAUDE_PLUGIN_ROOT}/servers/db              │
│     Environment: DB_URL from user env                      │
│                                                             │
│  4. Server Running                                          │
│     ┌─────────────────────────────────┐                   │
│     │   MCP Server Process            │                   │
│     │   • Listens for requests        │                   │
│     │   • Provides tools to Claude    │                   │
│     │   • Access to DB_URL            │                   │
│     └─────────────────────────────────┘                   │
│                                                             │
│  5. Claude Invokes Tools                                    │
│     Claude ──query──> MCP Server ──SQL──> Database        │
│     Claude <─result─  MCP Server <─data─  Database        │
│                                                             │
│  6. Plugin Disable/Uninstall                               │
│     Server stops automatically                             │
└─────────────────────────────────────────────────────────────┘

VERIFICATION:
/mcp ──> Shows all active MCP servers including plugin-provided
```

---

## Team Distribution Workflow

```
ORGANIZATION SETUP:
┌─────────────────────────────────────────────────────────────┐
│  GitHub: company/claude-plugins                             │
│                                                             │
│  .claude-plugin/marketplace.json:                          │
│  {                                                          │
│    "name": "company-tools",                                │
│    "plugins": [                                            │
│      {"name": "code-standards", "source": "./standards"},  │
│      {"name": "deploy-tools", "source": "./deploy"},      │
│      {"name": "security-audit", "source": "./security"}   │
│    ]                                                        │
│  }                                                          │
└────────────────┬────────────────────────────────────────────┘
                 │
                 │ Referenced in project
                 ▼
┌─────────────────────────────────────────────────────────────┐
│  Project Repository: company/backend-api                    │
│                                                             │
│  .claude/settings.json:                                    │
│  {                                                          │
│    "extraKnownMarketplaces": {                             │
│      "company-tools": {                                    │
│        "source": {                                         │
│          "source": "github",                               │
│          "repo": "company/claude-plugins"                  │
│        }                                                    │
│      }                                                      │
│    },                                                       │
│    "enabledPlugins": [                                     │
│      "code-standards@company-tools",                       │
│      "deploy-tools@company-tools"                          │
│    ]                                                        │
│  }                                                          │
└────────────────┬────────────────────────────────────────────┘
                 │
                 │ Team member clones project
                 ▼
┌─────────────────────────────────────────────────────────────┐
│  DEVELOPER MACHINE                                          │
│                                                             │
│  $ git clone company/backend-api                           │
│  $ cd backend-api                                          │
│  $ claude                                                  │
│                                                             │
│  Claude Code detects .claude/settings.json                 │
│  Prompts: "Trust this repository's settings?"              │
│                                                             │
│  Developer approves ✓                                       │
│                                                             │
│  AUTO-INSTALLATION:                                         │
│  1. Adds marketplace: company-tools                        │
│  2. Installs: code-standards@company-tools                 │
│  3. Installs: deploy-tools@company-tools                   │
│  4. Enables all installed plugins                          │
│                                                             │
│  Result: Immediate access to company tools ✓               │
└─────────────────────────────────────────────────────────────┘
```

---

## Plugin Development Workflow

```
LOCAL DEVELOPMENT                 TESTING                  DISTRIBUTION
─────────────────                 ───────                  ────────────

1. Create Plugin                  4. Local Testing         7. Push to GitHub
┌───────────┐                    ┌───────────┐            ┌───────────┐
│   Files   │                    │   Test    │            │  GitHub   │
│           │                    │Marketplace│            │   Repo    │
│ .claude-  │                    │           │            │           │
│  plugin/  │                    │ /plugin   │            │ owner/    │
│  plugin.  │                    │marketplace│            │ my-plugin │
│  json     │                    │ add ./    │            └───────────┘
│           │                    │           │                 │
│ commands/ │                    │ /plugin   │                 │
│ skills/   │                    │ install   │                 │
│ hooks/    │                    │ my-plugin │                 │
│ .mcp.json │                    └───────────┘                 │
└─────┬─────┘                          │                       │
      │                                │                       │
      ▼                                ▼                       ▼
2. Create Marketplace            5. Validate                8. Share URL
┌───────────┐                    ┌───────────┐            ┌───────────┐
│marketplace│                    │  claude   │            │  Team     │
│  .json    │                    │  plugin   │            │  Members  │
│           │                    │  validate │            │           │
│ {         │                    │     .     │            │  /plugin  │
│  "plugins"│                    └───────────┘            │marketplace│
│  : [...]  │                          │                  │  add      │
│ }         │                          │                  │  owner/   │
└─────┬─────┘                          ▼                  │  my-plugin│
      │                          6. Debug Mode            └───────────┘
      │                         ┌───────────┐
      ▼                         │  claude   │
3. Reference Plugin             │  --debug  │
   source: ./my-plugin          └───────────┘
```

---

## Security Model

```
┌─────────────────────────────────────────────────────────────┐
│                   SECURITY LAYERS                           │
│                                                             │
│  USER TRUST BOUNDARY                                        │
│  ┌──────────────────────────────────────────────┐          │
│  │ Repository Settings (.claude/settings.json)  │          │
│  │ • User must explicitly trust repository      │          │
│  │ • Prevents auto-execution of untrusted code  │          │
│  └──────────────────────────────────────────────┘          │
│                          │                                  │
│                          ▼                                  │
│  PLUGIN VALIDATION                                          │
│  ┌──────────────────────────────────────────────┐          │
│  │ Manifest Verification                        │          │
│  │ • JSON syntax validation                     │          │
│  │ • Required fields present                    │          │
│  │ • Source URLs accessible                     │          │
│  └──────────────────────────────────────────────┘          │
│                          │                                  │
│                          ▼                                  │
│  COMPONENT ISOLATION                                        │
│  ┌──────────────────────────────────────────────┐          │
│  │ Skills: allowed-tools Restrictions           │          │
│  │ • Limit tool access per skill                │          │
│  │ • Read-only operations possible              │          │
│  │ • Prevent unintended side effects            │          │
│  └──────────────────────────────────────────────┘          │
│                          │                                  │
│                          ▼                                  │
│  EXECUTION ENVIRONMENT                                      │
│  ┌──────────────────────────────────────────────┐          │
│  │ Hooks: Environment Credential Access         │          │
│  │ ⚠️  Hooks run with user credentials          │          │
│  │ ⚠️  Review thoroughly before enabling        │          │
│  │ ⚠️  Potential data exfiltration risk         │          │
│  └──────────────────────────────────────────────┘          │
│                          │                                  │
│                          ▼                                  │
│  MCP SERVER SECURITY                                        │
│  ┌──────────────────────────────────────────────┐          │
│  │ Environment Variables for Secrets            │          │
│  │ • Never hardcode credentials                 │          │
│  │ • Use ${ENV_VAR} references                  │          │
│  │ • Server process isolation                   │          │
│  └──────────────────────────────────────────────┘          │
│                                                             │
└─────────────────────────────────────────────────────────────┘

TRUST MODEL:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Marketplaces:  User adds explicitly (/plugin marketplace add)
Plugins:       User installs explicitly OR via trusted settings
Hooks:         ⚠️  Auto-execute - REVIEW BEFORE ENABLING
Skills:        Tool restrictions via allowed-tools
MCP Servers:   Environment isolation + secret management
```

---

## Version Management Flow

```
PLUGIN VERSIONING:
┌─────────────────────────────────────────────────────────────┐
│  plugin.json:                                              │
│  {                                                          │
│    "name": "my-plugin",                                    │
│    "version": "2.1.0"  ← Semantic versioning              │
│  }                                                          │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
MARKETPLACE VERSIONING:
┌─────────────────────────────────────────────────────────────┐
│  marketplace.json:                                         │
│  {                                                          │
│    "metadata": {                                           │
│      "version": "1.5.0"  ← Marketplace version            │
│    },                                                       │
│    "plugins": [                                            │
│      {                                                      │
│        "name": "my-plugin",                                │
│        "version": "2.1.0"  ← Can override plugin version  │
│      }                                                      │
│    ]                                                        │
│  }                                                          │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
UPDATE WORKFLOW:
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  Developer updates plugin:                                 │
│  1. Modify plugin files                                    │
│  2. Update plugin.json version                             │
│  3. Update marketplace.json if needed                      │
│  4. Git commit & tag: v2.1.0                               │
│  5. Push to repository                                     │
│                                                             │
│  Users update:                                              │
│  /plugin marketplace update marketplace-name               │
│  /plugin update plugin-name@marketplace-name (if exists)   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Error Handling & Validation

```
VALIDATION CHECKPOINTS:
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  1. MARKETPLACE ADD                                         │
│     /plugin marketplace add owner/repo                     │
│          │                                                  │
│          ├─ Check: Repository accessible? ✓/✗              │
│          ├─ Check: marketplace.json exists? ✓/✗            │
│          ├─ Check: Valid JSON syntax? ✓/✗                  │
│          └─ Check: Required fields present? ✓/✗            │
│                                                             │
│  2. PLUGIN INSTALL                                          │
│     /plugin install my-plugin@marketplace                  │
│          │                                                  │
│          ├─ Check: Plugin in marketplace? ✓/✗              │
│          ├─ Check: Source accessible? ✓/✗                  │
│          ├─ Check: plugin.json valid? ✓/✗                  │
│          ├─ Check: Components valid? ✓/✗                   │
│          └─ Check: Dependencies met? ✓/✗                   │
│                                                             │
│  3. COMPONENT LOADING                                       │
│     Plugin enabled, components load                        │
│          │                                                  │
│          ├─ Commands: Valid markdown + frontmatter? ✓/✗    │
│          ├─ Skills: SKILL.md format correct? ✓/✗           │
│          ├─ Hooks: Scripts executable? ✓/✗                 │
│          └─ MCP: Server binary exists? ✓/✗                 │
│                                                             │
│  4. RUNTIME VALIDATION                                      │
│     claude --debug                                         │
│          │                                                  │
│          ├─ Log: Marketplace loading status                │
│          ├─ Log: Plugin initialization                     │
│          ├─ Log: Component registration                    │
│          ├─ Log: MCP server startup                        │
│          └─ Error: Detailed failure messages               │
│                                                             │
└─────────────────────────────────────────────────────────────┘

COMMON ERRORS & FIXES:
┌──────────────────────────┬──────────────────────────────────┐
│ Error                    │ Solution                         │
├──────────────────────────┼──────────────────────────────────┤
│ Plugin won't load        │ claude plugin validate .         │
│ Missing commands         │ Move commands/ to plugin root    │
│ Hooks not executing      │ chmod +x hooks/*.sh              │
│ MCP initialization fails │ Use ${CLAUDE_PLUGIN_ROOT}        │
│ Path resolution errors   │ Use relative paths with ./       │
│ Marketplace not found    │ Check URL/repo accessibility     │
│ Permission denied        │ Review repository access rights  │
└──────────────────────────┴──────────────────────────────────┘
```

---

## Documentation References

**Full Research Report:** [CLAUDE_CODE_PLUGIN_SYSTEM.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/CLAUDE_CODE_PLUGIN_SYSTEM.md)

**Quick Reference:** [PLUGIN_SYSTEM_QUICK_REFERENCE.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_SYSTEM_QUICK_REFERENCE.md)

**Official Documentation:**

- https://docs.claude.com/en/docs/claude-code/plugins.md
- https://docs.claude.com/en/docs/claude-code/plugin-marketplaces.md
- https://docs.claude.com/en/docs/claude-code/plugins-reference.md
- https://docs.claude.com/en/docs/claude-code/skills.md
- https://docs.claude.com/en/docs/claude-code/hooks-guide.md
- https://docs.claude.com/en/docs/claude-code/mcp.md

---

**Version:** 1.0.0 | **Created:** 2025-10-25
