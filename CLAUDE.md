# Claude Code Project Memory: GitHub Issues Knowledge Base Operations

**Last Updated:** 2025-10-23
**Version:** 4.0.0

---

## Repository Purpose

### Primary Purpose: AI Agent Operational Guide

**This repository IS:**

- **Comprehensive operational manual** for AI coding agents (Claude, Copilot, etc.)
- **Tool selection decision trees** for GitHub Issues operations
- **Empirically-tested workflows** with effectiveness metrics
- **Complete reference** for native gh CLI, extensions, and AI-powered operations

**This repository IS NOT:**

- The knowledge base itself (that's stored in **GitHub Issues**)
- A fork of GitHub CLI documentation
- A generic GitHub tutorial

### Critical Understanding

```
┌──────────────────────────────────────────────────────────────┐
│                   DUAL NATURE EXPLAINED                      │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  THIS REPOSITORY (terrylica/knowledgebase)                   │
│  ├─ README.md, docs/, guides/                                │
│  ├─ Purpose: Operational guide for AI agents                 │
│  └─ Content: How to perform operations                       │
│                                                              │
│  GITHUB ISSUES (in this repository)                          │
│  ├─ Issues #1, #2, #3...                                     │
│  ├─ Purpose: Actual knowledge base backend                   │
│  └─ Content: Team knowledge (Claude Code tips, etc.)         │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

**Example:**

- **This guide** documents how to use `gh-models` for auto-labeling
- **The Issues** contain actual Claude Code tips that get auto-labeled

### Documented Operations (Complete List)

This guide provides empirically-tested workflows for **5 categories** of operations:

1. **AI-Powered Operations** (gh-models) - Issue summarization, auto-labeling, Q&A, documentation generation
2. **File Search Operations** (gh-grep) - Regex-based file search, multi-repository search, pattern detection
3. **Issue Search & Discovery** (native gh CLI) - Content search, complex filtering (30+ qualifiers), metadata queries
4. **Issue Lifecycle Operations** (native gh CLI) - CRUD operations, state management, comments, bulk processing
5. **Label & Milestone Management** (native gh CLI) - Label/milestone CRUD, cloning, batch operations

**Full Details:** [AI_AGENT_OPERATIONAL_GUIDE.md](/docs/guides/AI_AGENT_OPERATIONAL_GUIDE.md)

### Tool Ecosystem

**Native GitHub CLI:**

- No installation beyond `gh` itself
- 200+ test cases documented
- Complete API coverage
- JSON output (21 fields per issue)

**Extensions (652+ available, 2 recommended for AI agents):**

- `gh-grep` - File search with regex (211 stars, actively maintained)
- `gh-models` - AI assistance (official GitHub extension)

**Rejected Extensions:**

- `gh-label` - Last updated 2022, use native `gh label` instead
- `gh-milestone` - Last updated 2023, use `gh api` instead

---

## Documentation Structure

### Single Source of Truth Principle

Each topic has **EXACTLY ONE** authoritative document. All other references link to it.

**Canonical Source Map:**

| Topic                          | Canonical Location                                           | What It Contains                       |
| ------------------------------ | ------------------------------------------------------------ | -------------------------------------- |
| **Operation Categories**       | `/docs/guides/AI_AGENT_OPERATIONAL_GUIDE.md`                 | Full details of 5 operation categories |
| **Tool Selection**             | `/docs/guides/AI_AGENT_OPERATIONAL_GUIDE.md`                 | Decision trees, when to use what       |
| **Extension Details**          | `/docs/research/GITHUB_CLI_EXTENSIONS.md`                    | gh-grep & gh-models complete docs      |
| **Installation Instructions**  | `/docs/research/GITHUB_CLI_EXTENSIONS.md#quick-installation` | How to install extensions              |
| **Search Syntax**              | `/docs/research/GITHUB_NATIVE_SEARCH_CAPABILITIES.md`        | Complete qualifier reference (30+)     |
| **Effectiveness Metrics**      | `/docs/testing/GH-MODELS-POC-RESULTS.md`                     | Empirical test results (88% avg)       |
| **API Reference**              | `/docs/references/github-cli-issues-comprehensive-guide.md`  | Complete gh CLI testing (200+ cases)   |
| **Workflows & Best Practices** | `/docs/guides/AI_AGENT_OPERATIONAL_GUIDE.md`                 | Common workflows, error handling       |

**Core Documents:**

1. `/docs/guides/AI_AGENT_OPERATIONAL_GUIDE.md` - Complete operational guide (primary reference)
2. `/docs/research/GITHUB_CLI_EXTENSIONS.md` - Extension ecosystem (consolidated)
3. `/docs/research/GITHUB_NATIVE_SEARCH_CAPABILITIES.md` - Search capabilities (quick start + reference)
4. `/docs/references/github-cli-issues-comprehensive-guide.md` - Complete API reference (200+ tests)
5. `/docs/testing/GH-MODELS-POC-RESULTS.md` - AI assistance POC results

### DRY Principle

**Never duplicate content.** Link to single source of truth.

❌ **Bad:** Copy search syntax to multiple files
✅ **Good:** Link to `GITHUB_NATIVE_SEARCH_CAPABILITIES.md`

❌ **Bad:** Duplicate installation instructions in 4 files
✅ **Good:** Link to `GITHUB_CLI_EXTENSIONS.md#quick-installation`

---

## For Future Claude Instances

### When Working With This Repository

**You are reading the guide, NOT the knowledge base.**

- Knowledge base content lives in **GitHub Issues**
- This repository documents **how to operate** on those issues
- Always distinguish between "the guide" and "the issues"

### Common Operations

**Search for knowledge:**

```bash
gh search issues "claude code plan mode" --repo=terrylica/knowledgebase
```

**Add knowledge:**

```bash
gh issue create --repo=terrylica/knowledgebase \
  --title "Claude Code: How to use Plan Mode" \
  --label "claude-code,tips,how-to" \
  --body-file tip.md
```

**Auto-label with AI:**

```bash
BODY=$(gh issue view 123 --json body --jq .body)
gh models run "openai/gpt-4.1" "Suggest 2-3 labels for this: $BODY"
```

### Decision Trees

**Refer to:**

- `AI_AGENT_OPERATIONAL_GUIDE.md` - Tool selection decision tree
- `GITHUB_CLI_EXTENSIONS.md` - When to use extensions vs native commands

---

## Demonstration: Claude Code Tips

This repository **demonstrates the documented system** by maintaining our team's Claude Code tips as GitHub Issues.

**This serves dual purposes:**

1. Working example of all documented workflows
2. Actual knowledge base for our team

**Issue Labels:**

- `claude-code`, `github-cli`, `workflow`, `tips`, `troubleshooting`
- `how-to`, `reference`, `example`
- `git`, `terminal`, `mcp`

---

## Version Management

**Current Version:** 4.0.0 (DRY consolidation - 62.5% file reduction)

**Version History:**

- 4.0.0 (2025-10-23): DRY consolidation, 16 files → 6 files
- 3.x: POC testing and empirical validation
- 2.x: Extension ecosystem research
- 1.x: Initial comprehensive testing

**Semantic Versioning:**

- MAJOR: Breaking changes to guide structure
- MINOR: New operations documented
- PATCH: Corrections, updates, clarifications

---

## Critical Maintenance Notes

### Before Adding Content

**Ask yourself:**

1. Is this about **how to operate** on Issues? → Add to guide (this repo)
2. Is this **knowledge to store**? → Create Issue (knowledge base)

### Maintaining Single Source of Truth

Before creating new document:

1. Search existing docs for similar content
2. If exists: link to it, don't duplicate
3. If doesn't exist: create ONE authoritative document
4. Update this CLAUDE.md with location

### Testing Claims

**All operational guidance MUST be empirically tested.**

❌ **Bad:** "gh-models can probably do X"
✅ **Good:** "gh-models Test 3 shows 88% effectiveness for X (see GH-MODELS-POC-RESULTS.md:142)"

---

## Quick Reference

**Primary Guide:** `/docs/guides/AI_AGENT_OPERATIONAL_GUIDE.md`

**Tool Selection:**

- Issue search → `gh search issues`
- File search → `gh grep`
- AI operations → `gh models`
- Labels → `gh label` (native)
- Milestones → `gh api`

**Effectiveness Metrics:** See [GH-MODELS-POC-RESULTS.md](/docs/testing/GH-MODELS-POC-RESULTS.md) for complete empirical test results and effectiveness metrics.
