# Knowledge Base

Engineering knowledge base for team collaboration, documentation, and workflow automation.

**Repository:** https://github.com/terrylica/knowledgebase

---

## Quick Links

- 📖 **[Documentation](/docs/)** - Guides, research, and references
- 🔍 **[Search Guide](/docs/research/GITHUB_NATIVE_SEARCH_CAPABILITIES.md)** - Native GitHub CLI search (quick start + complete reference)
- 🤖 **[AI Agent Guide](/docs/guides/AI_AGENT_OPERATIONAL_GUIDE.md)** - Operational guide for AI coding agents
- 🔌 **[Extensions](/docs/research/GITHUB_CLI_EXTENSIONS.md)** - GitHub CLI extensions tested and recommended

---

## What This Repository Contains

### 1. Knowledge Base Platform Research

Comprehensive analysis of using GitHub Issues as a knowledge base:

- Native GitHub CLI search capabilities
- GitHub CLI extensions ecosystem
- Complete search syntax and filtering
- Comprehensive testing (200+ test cases)

### 2. GitHub CLI Extensions

Tested and recommended extensions for issue management:

- **gh-dash** - Interactive TUI dashboard (9k stars, actively maintained)
- **gh-grep** - File search with regex support (211 stars, actively maintained)
- **gh-models** - AI-powered assistance (official GitHub extension)

### 3. Operational Guides

Documentation for both humans and AI agents:

- Native GitHub CLI commands
- Extension usage patterns
- Common workflows
- Best practices and error handling

---

## Getting Started

### Install GitHub CLI Extensions

```bash
# Install recommended extensions
gh extension install dlvhdr/gh-dash     # Interactive dashboard
gh extension install k1LoW/gh-grep      # File search with regex
gh extension install github/gh-models   # AI assistance
```

### Search Your Knowledge Base

```bash
# Search issues with native GitHub CLI
gh search issues "authentication" --repo=terrylica/knowledgebase

# Search current repository
gh issue list --search "authentication"

# Filter by metadata
gh search issues --label=bug --state=open --assignee=@me

# Search files with regex (gh-grep extension)
gh grep "Bug.*critical" --owner terrylica --repo knowledgebase
```

### Use Interactive Dashboard

```bash
# Launch gh-dash for interactive issue management
gh dash

# Configure your dashboard
vi ~/.config/gh-dash/config.yml
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

Actively maintained extensions (tested 2025-10-23):

- **gh-dash:** Interactive dashboard (updated yesterday, 9k stars)
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

See: [GITHUB_CLI_EXTENSIONS_ECOSYSTEM.md](/docs/research/GITHUB_CLI_EXTENSIONS_ECOSYSTEM.md)

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
# Interactive dashboard
gh dash

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
- Interactive management → `gh dash` (not for automation!)
- AI assistance → `gh models`
- Label operations → `gh label` (native)
- Milestone operations → `gh api repos/.../milestones`

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

- **Repository:** https://github.com/terrylica/knowledgebase
- **GitHub CLI:** https://cli.github.com/
- **GitHub Search Syntax:** https://docs.github.com/en/search-github/searching-on-github/searching-issues-and-pull-requests
- **gh-dash:** https://github.com/dlvhdr/gh-dash
- **gh-grep:** https://github.com/k1LoW/gh-grep
- **gh-models:** https://github.com/github/gh-models

---

**Version:** 4.0.0
**Last Updated:** 2025-10-23
**Maintainer:** Terry Li (@terrylica)
