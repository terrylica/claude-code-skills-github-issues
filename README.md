# Knowledge Base

Engineering knowledge base for team collaboration, documentation, and workflow automation.

**Repository:** https://github.com/terrylica/knowledgebase

---

## Quick Links

- 📖 **[Documentation](/docs/)** - Guides, research, and references
- 🛠️ **[Tools](/tools/)** - Automation scripts and utilities
- 🔍 **[Quick Start: Search](/docs/guides/QUICK_START_SEARCH.md)** - How to search with full power

---

## What This Repository Contains

### 1. Knowledge Base Platform Research
Comprehensive analysis of using GitHub Issues as a knowledge base:
- Search capabilities (GitHub vs ripgrep)
- Hybrid search solution (100% ripgrep power)
- Complete GitHub CLI probing and testing

### 2. Powerful Search Tool
**[gh-rg](/tools/search/)** - Search GitHub issues with full ripgrep power:
```bash
gh-rg --repo terrylica/knowledgebase "pattern"
```

### 3. Automation Scripts
Production-ready automation for GitHub issue management:
- Batch operations (labels, state, assignments)
- Advanced workflows (triage, planning, reports)
- JQ integration examples
- API integration patterns

---

## Getting Started

### Search Your Knowledge Base
```bash
# Install is already done: ~/.local/bin/gh-rg

# Search with full regex power
gh-rg --repo terrylica/knowledgebase "authentication"

# See guide
cat docs/guides/QUICK_START_SEARCH.md
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
│   ├── QUICK_START_SEARCH.md
│   └── HYBRID_SEARCH_SOLUTION.md
├── research/         Platform analysis and comparisons
│   ├── github-knowledge-base-analysis.md
│   └── SEARCH_POWER_COMPARISON.md
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
├── automation/       Batch operations and workflows
│   ├── batch-label-operations.sh
│   ├── batch-state-operations.sh
│   ├── batch-assignment-operations.sh
│   ├── advanced-workflows.sh
│   ├── jq-integration-examples.sh
│   ├── api-integration-examples.sh
│   ├── real-world-workflows.sh
│   └── README.md
└── search/          Search utilities
    └── gh-rg        (→ ~/.local/bin/gh-rg)
```

---

## Key Features

### ✅ Hybrid Search Solution
Combine GitHub's structure with ripgrep's power:
- **Publish:** GitHub Issues (collaboration, metadata)
- **Search:** ripgrep (regex, context, 20x faster)
- **Best of both worlds!**

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

### GitHub Issues Search Power
- **Basic search:** ~17% of ripgrep's capabilities
- **With metadata:** Excellent for structured queries
- **Hybrid approach:** 100% ripgrep power locally

See: [SEARCH_POWER_COMPARISON.md](/docs/research/SEARCH_POWER_COMPARISON.md)

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
gh-rg "authentication"

# Regex patterns
gh-rg "Bug.*auth.*failure"

# Context lines
gh-rg -A 3 -B 1 "SQL injection"

# Complex patterns
gh-rg "priority:(high|critical)"
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
- **ripgrep:** https://github.com/BurntSushi/ripgrep

---

**Version:** 1.0.0
**Last Updated:** 2025-10-23
**Maintainer:** Terry Li (@terrylica)
