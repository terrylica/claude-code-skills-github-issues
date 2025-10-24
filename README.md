# AI Agent Operational Guide: GitHub Issues Knowledge Base

**Purpose:** Comprehensive operational guide for AI coding agents (Claude, Copilot, etc.) to manage engineering knowledge stored in GitHub Issues.

**What This Repository IS:**

- Complete operational guide for AI agents performing GitHub Issues operations
- Empirically-tested workflows and decision trees (200+ test cases, 88% avg AI effectiveness)
- Tool selection guidance (native gh CLI, extensions, AI models)

**What This Repository IS NOT:**

- The knowledge base itself (that's in GitHub Issues - the actual issues you create)
- Generic GitHub CLI documentation (see official docs for that)

**Repository:** https://github.com/terrylica/claude-code-skills-github-issues

---

## Quick Links

- 📖 **[Documentation](/docs/)** - Guides, research, and references
- 🔍 **[Search Guide](/docs/research/GITHUB_NATIVE_SEARCH_CAPABILITIES.md)** - Native GitHub CLI search (quick start + complete reference)
- 🤖 **[AI Agent Guide](/docs/guides/AI_AGENT_OPERATIONAL_GUIDE.md)** - Operational guide for AI coding agents
- 🔌 **[Extensions](/docs/research/GITHUB_CLI_EXTENSIONS.md)** - GitHub CLI extensions tested and recommended

---

## Installation

### Global Installation (Claude Code Skills)

Install this operational guide as Claude Code Skills for automatic context loading:

```bash
/plugin marketplace add terrylica/claude-code-skills-github-issues
```

This makes all 5 GitHub Issues operation skills available across your Claude Code sessions with progressive disclosure (saves 73-95% context).

### Project-Local Installation

Clone into your project for team-wide access:

```bash
git clone https://github.com/terrylica/claude-code-skills-github-issues.git .claude/plugins/github-issues
```

Or add as git submodule:

```bash
git submodule add https://github.com/terrylica/claude-code-skills-github-issues.git .claude/plugins/github-issues
```

### Plugin Lifecycle Management

**Complete Guide:** See [INSTALLATION.md](/INSTALLATION.md) for detailed instructions.

**Install:**
```bash
/plugin marketplace add terrylica/claude-code-skills-github-issues
/plugin install github-issues-operations@terrylica/claude-code-skills-github-issues
```

**Update to Latest Version:**
```bash
/plugin marketplace update terrylica/claude-code-skills-github-issues
/plugin uninstall github-issues-operations@terrylica/claude-code-skills-github-issues
/plugin install github-issues-operations@terrylica/claude-code-skills-github-issues
```

**Uninstall:**
```bash
/plugin uninstall github-issues-operations@terrylica/claude-code-skills-github-issues
/plugin marketplace remove terrylica/claude-code-skills-github-issues
```

**Version History:** See [CHANGELOG.md](/CHANGELOG.md)

---

> **🤖 For AI Agents:**
>
> This repository documents operations for managing knowledge in GitHub Issues.
> The actual knowledge base lives in Issues. This is your operational manual.
>
> **Quick Start:** See [AI_AGENT_OPERATIONAL_GUIDE.md](/docs/guides/AI_AGENT_OPERATIONAL_GUIDE.md) for complete tool selection decision trees and workflows.

---

## What This Repository Contains

### AI Agent Operations Documented

This guide documents **5 categories of operations** for AI agents managing knowledge in GitHub Issues:

1. **AI-Powered Operations** (gh-models) - Issue summarization, auto-labeling, Q&A, documentation generation
2. **File Search Operations** (gh-grep) - Regex-based file search, multi-repository search
3. **Issue Search & Discovery** (native gh CLI) - Content search, complex filtering, metadata queries
4. **Issue Lifecycle Operations** (native gh CLI) - CRUD operations, state management, comments, assignments
5. **Label & Milestone Management** (native gh CLI) - Label/milestone CRUD, cloning, batch operations

**Complete Details:** See [AI_AGENT_OPERATIONAL_GUIDE.md](/docs/guides/AI_AGENT_OPERATIONAL_GUIDE.md) for full operation reference, tool selection decision trees, and empirically-tested workflows.

---

## Getting Started

### Prerequisites

**Install GitHub CLI extensions** - See [GITHUB_CLI_EXTENSIONS.md](/docs/research/GITHUB_CLI_EXTENSIONS.md#quick-installation) for installation instructions.

### Search Your Knowledge Base

```bash
# Search issues with native GitHub CLI
gh search issues "authentication" --repo=terrylica/claude-code-skills-github-issues

# Search current repository
gh issue list --search "authentication"

# Filter by metadata
gh search issues --label=bug --state=open --assignee=@me

# Search files with regex (gh-grep extension)
gh grep "Bug.*critical" --owner terrylica --repo knowledgebase
```

### AI-Powered Workflows

```bash
# List available AI models
gh models list

# Get AI assistance
gh models run "openai/gpt-4.1" "Summarize this: $(gh issue view 123 --json body --jq .body)"
```

---

## Documentation Structure

```
docs/
├── guides/           Operational guides for AI agents and humans
│   └── AI_AGENT_OPERATIONAL_GUIDE.md       # Complete operational guide
├── research/         Platform analysis and capabilities
│   ├── GITHUB_CLI_EXTENSIONS.md            # Extension ecosystem (consolidated)
│   └── GITHUB_NATIVE_SEARCH_CAPABILITIES.md # Search guide (quick start + reference)
├── references/       Complete technical references
│   └── github-cli-issues-comprehensive-guide.md  # 200+ test cases
└── testing/          Test reports and POC results
    └── GH-MODELS-POC-RESULTS.md            # AI assistance POC (88% effectiveness)
```

---

## Key Features

### ✅ Native GitHub CLI Capabilities

Powerful built-in features:

- **Search:** Title, body, and comments
- **Filter:** 30+ qualifiers (labels, dates, users, state, milestones)
- **Sort:** Comments, reactions, dates
- **Output:** JSON for scripting and automation
- **Labels:** Full label management (create, edit, delete, clone)

### ✅ Community Extensions

Actively maintained extensions for AI agents (tested 2025-10-23):

- **gh-grep:** File search with regex (updated yesterday, 211 stars)
- **gh-models:** Official AI assistance (updated 9 days ago)

### ✅ Comprehensive Testing

200+ test cases covering:

- CRUD operations (create, read, update, delete)
- Search and filtering (60+ queries)
- Metadata and labels (40+ tests)
- State and lifecycle (30+ tests)
- Comments and interactions (40+ tests)
- Extension functionality verification
- AI assistance workflows (5 POC tests, 88% effectiveness)

### ✅ AI Agent Operational Guide

Complete guide for AI coding agents:

- Tool selection decision trees
- Empirical testing results
- Common workflows and patterns
- Error handling and best practices
- Limitations and constraints

---

## Research Findings

### GitHub Native Search Capabilities

- **Content search:** Title, body, and comments with `in:` qualifiers
- **Metadata filtering:** 30+ qualifiers for labels, dates, users, state
- **Structured queries:** Excellent for team collaboration and knowledge base
- **Limitations:** No regex, no wildcards, no context lines

See: [GITHUB_NATIVE_SEARCH_CAPABILITIES.md](/docs/research/GITHUB_NATIVE_SEARCH_CAPABILITIES.md)

### GitHub CLI Extensions Ecosystem

- **652+ extensions available** (as of 2025-10-23)
- **Top extensions tested and verified** for maintenance status
- **Outdated extensions identified** (gh-label: 2022, gh-milestone: 2023)
- **Recommended alternatives** to custom scripts

See: [GITHUB_CLI_EXTENSIONS.md](/docs/research/GITHUB_CLI_EXTENSIONS.md)

### GitHub CLI Capabilities

- **Complete coverage:** All 17 `gh issue` commands tested
- **JSON output:** 21 fields available
- **Automation:** Full API access via CLI
- **Native label commands:** No extension needed

See: [github-cli-issues-comprehensive-guide.md](/docs/references/github-cli-issues-comprehensive-guide.md)

---

## Quick Reference

### Search Examples

```bash
# Basic search
gh search issues "authentication"

# Search in specific field
gh search issues "database" --match=title

# Filter by metadata
gh search issues --label=bug --state=open --assignee=@me

# Date range
gh search issues --created="2025-01-01..2025-01-31"

# Sort by engagement
gh search issues --sort=comments --order=desc

# Search files with regex (gh-grep)
gh grep "Bug.*critical" --owner myorg --repo myrepo
```

### Extension Examples

```bash
# File search with regex
gh grep "authentication" --owner myorg --repo myrepo --line-number

# AI assistance
gh models run "openai/gpt-4.1" "Summarize this issue: $ISSUE_BODY"

# Label management (native)
gh label list
gh label create "priority:high" --color "ff0000"
```

---

## For AI Agents

**Comprehensive operational guide:** [AI_AGENT_OPERATIONAL_GUIDE.md](/docs/guides/AI_AGENT_OPERATIONAL_GUIDE.md)

Quick tool selection:

- Search issues → `gh search issues`
- Search files (with regex) → `gh grep`
- AI assistance → `gh models`
- Label operations → `gh label` (native)
- Milestone operations → `gh api repos/.../milestones`

---

## Demonstration: Claude Code Tips Knowledge Base

This repository **demonstrates the documented system** by storing our team's Claude Code tips and tricks as GitHub Issues.

**Dual Purpose:**

1. **Working example** of all documented AI agent workflows
2. **Actual knowledge base** for our team's Claude Code expertise

**Why This Approach:**

- Shows real-world usage of gh-models auto-labeling
- Demonstrates native search capabilities with actual content
- Provides templates for knowledge base setup
- Serves as proof-of-concept for the entire system

**Knowledge Base Labels:**

| Label             | Color    | Description                 |
| ----------------- | -------- | --------------------------- |
| `claude-code`     | `0366d6` | Claude Code tips and tricks |
| `github-cli`      | `2ea44f` | GitHub CLI workflows        |
| `workflow`        | `fbca04` | Development workflows       |
| `tips`            | `c5def5` | Tips and best practices     |
| `troubleshooting` | `d93f0b` | Common issues and solutions |
| `how-to`          | `bfdadc` | How-to guides               |
| `reference`       | `d4c5f9` | Reference documentation     |
| `example`         | `c2e0c6` | Code examples               |
| `git`             | `5319e7` | Git workflows               |
| `terminal`        | `0e8a16` | Terminal setup and usage    |
| `mcp`             | `f9d0c4` | MCP server integration      |

**Example Operations:**

```bash
# Search Claude Code tips
gh search issues "plan mode" --repo=terrylica/claude-code-skills-github-issues --label=claude-code

# Create new tip with auto-suggested labels (using gh-models)
gh issue create --title "Claude Code: Using Plan Mode" \
  --body-file tip.md \
  --repo=terrylica/claude-code-skills-github-issues

# Get AI-suggested labels for the new issue
BODY=$(gh issue view 1 --json body --jq .body)
gh models run "openai/gpt-4.1" "Suggest 2-3 labels from this list: claude-code, github-cli, workflow, tips, troubleshooting, how-to, reference, example, git, terminal, mcp. Issue body: $BODY"
```

---

## Contributing

This repository serves as a knowledge base and toolkit for team collaboration.

**Structure principles:**

- DRY (Don't Repeat Yourself)
- Single source of truth
- Clear organization
- Comprehensive documentation
- Use community-maintained extensions over custom code

---

## Links

- **Repository:** https://github.com/terrylica/claude-code-skills-github-issues
- **GitHub CLI:** https://cli.github.com/
- **GitHub Search Syntax:** https://docs.github.com/en/search-github/searching-on-github/searching-issues-and-pull-requests
- **gh-grep:** https://github.com/k1LoW/gh-grep
- **gh-models:** https://github.com/github/gh-models

---

**Version:** 4.0.0
**Last Updated:** 2025-10-23
**Maintainer:** Terry Li (@terrylica)
