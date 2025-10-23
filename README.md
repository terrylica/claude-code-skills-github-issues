# Knowledge Base

Engineering knowledge base for team collaboration, documentation, and workflow automation.

**Repository:** https://github.com/terrylica/knowledgebase

---

## Quick Links

- 📖 **[Documentation](/docs/)** - Guides, research, and references
- 🛠️ **[Tools](/tools/)** - Automation scripts and utilities
- 🔍 **[Quick Start: Search](/docs/guides/NATIVE_SEARCH_QUICK_START.md)** - Native GitHub CLI search guide

---

## What This Repository Contains

### 1. Knowledge Base Platform Research

Comprehensive analysis of using GitHub Issues as a knowledge base:

- Native GitHub CLI search capabilities
- Complete search syntax and filtering
- Complete GitHub CLI probing and testing

### 2. Automation Scripts

Production-ready automation for GitHub issue management:

- Batch operations (labels, state, assignments)
- Advanced workflows (triage, planning, reports)
- JQ integration examples
- API integration patterns

---

## Getting Started

### Search Your Knowledge Base

```bash
# Search with native GitHub CLI
gh search issues "authentication" --repo=terrylica/knowledgebase

# Search current repository
gh issue list --search "authentication"

# Filter by metadata
gh search issues --label=bug --state=open --assignee=@me

# See guide
cat docs/guides/NATIVE_SEARCH_QUICK_START.md
```

### Use Automation Scripts

```bash
# Weekly report
./tools/automation/real-world-workflows.sh weekly report.md

# Bug triage
./tools/automation/real-world-workflows.sh bug-triage

# See all tools
ls tools/automation/
```

---

## Documentation Structure

```
docs/
├── guides/           Quick-start and how-to guides
│   └── NATIVE_SEARCH_QUICK_START.md
├── research/         Platform analysis and comparisons
│   ├── github-knowledge-base-analysis.md
│   ├── GITHUB_NATIVE_SEARCH_CAPABILITIES.md
│   └── NOTION_INVESTIGATION_PREP.md
├── references/       Complete technical references
│   └── github-cli-issues-comprehensive-guide.md
└── testing/          Test reports and probing results
    ├── PROBING_SUMMARY.md
    ├── LIVE_TEST_RESULTS.md
    ├── gh-cli-metadata-test-report.md
    └── github-cli-issue-lifecycle-test-report.md
```

---

## Tools Structure

```
tools/
└── automation/       Batch operations and workflows
    ├── batch-label-operations.sh
    ├── batch-state-operations.sh
    ├── batch-assignment-operations.sh
    ├── advanced-workflows.sh
    ├── jq-integration-examples.sh
    ├── api-integration-examples.sh
    ├── real-world-workflows.sh
    └── README.md
```

---

## Key Features

### ✅ Native GitHub CLI Search

Powerful native search capabilities:

- **Search:** Title, body, and comments
- **Filter:** 30+ qualifiers (labels, dates, users, state, milestones)
- **Sort:** Comments, reactions, dates
- **Output:** JSON for scripting and automation

### ✅ Comprehensive Testing

200+ test cases covering:

- CRUD operations (create, read, update, delete)
- Search and filtering (60+ queries)
- Metadata and labels (40+ tests)
- State and lifecycle (30+ tests)
- Comments and interactions (40+ tests)

### ✅ Production-Ready Automation

59 reusable functions across 7 scripts:

- Batch operations
- Workflow automation
- Data analysis and reporting

---

## Research Findings

### GitHub Native Search Capabilities

- **Content search:** Title, body, and comments with `in:` qualifiers
- **Metadata filtering:** 30+ qualifiers for labels, dates, users, state
- **Structured queries:** Excellent for team collaboration and knowledge base
- **Limitations:** No regex, no wildcards, no context lines

See: [GITHUB_NATIVE_SEARCH_CAPABILITIES.md](/docs/research/GITHUB_NATIVE_SEARCH_CAPABILITIES.md)

### GitHub CLI Capabilities

- **Complete coverage:** All 17 `gh issue` commands tested
- **JSON output:** 21 fields available
- **Automation:** Full API access via CLI

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
```

### Automation Examples

```bash
# Add label to multiple issues
./tools/automation/batch-label-operations.sh add "reviewed" "bug"

# Generate weekly report
./tools/automation/real-world-workflows.sh weekly /tmp/report.md

# Health check
./tools/automation/advanced-workflows.sh health
```

---

## Contributing

This repository serves as a knowledge base and toolkit for team collaboration.

**Structure principles:**

- DRY (Don't Repeat Yourself)
- Single source of truth
- Clear organization
- Comprehensive documentation

---

## Links

- **Repository:** https://github.com/terrylica/knowledgebase
- **GitHub CLI:** https://cli.github.com/
- **GitHub Search Syntax:** https://docs.github.com/en/search-github/searching-on-github/searching-issues-and-pull-requests

---

**Version:** 2.0.0
**Last Updated:** 2025-10-23
**Maintainer:** Terry Li (@terrylica)
