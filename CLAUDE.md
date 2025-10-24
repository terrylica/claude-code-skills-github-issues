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
┌─────────────────────────────────────────────────────────────┐
│                    DUAL NATURE EXPLAINED                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  THIS REPOSITORY (terrylica/knowledgebase)                  │
│  ├─ README.md, docs/, guides/                               │
│  ├─ Purpose: Operational guide for AI agents                │
│  └─ Content: How to perform operations                      │
│                                                              │
│  GITHUB ISSUES (in this repository)                         │
│  ├─ Issues #1, #2, #3...                                    │
│  ├─ Purpose: Actual knowledge base backend                  │
│  └─ Content: Team knowledge (Claude Code tips, etc.)        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Example:**
- **This guide** documents how to use `gh-models` for auto-labeling
- **The Issues** contain actual Claude Code tips that get auto-labeled

### Documented Operations (Complete List)

This guide provides empirically-tested workflows for **6 categories** of operations:

#### 1. AI-Powered Operations (gh-models)
- Issue summarization (94% effectiveness)
- Auto-labeling suggestions (96% accuracy)
- Knowledge base Q&A (88% relevance)
- Documentation generation (91% quality)
- Batch processing (80% effectiveness)
- Model inference (29+ models available)
- Prompt template testing
- Evaluation generation

#### 2. File Search Operations (gh-grep)
- Regex-based file search (Go regex support)
- Documentation file search
- Code example location
- Configuration file discovery
- Pattern occurrence counting
- Error pattern detection
- Multi-repository search

#### 3. Issue Search & Discovery (native gh)
- Issue content search (title/body/comments)
- Complex filtering (30+ qualifiers)
- Metadata filtering (labels, dates, users, state, milestones)
- Sorting by engagement metrics
- JSON output for automation
- Date range queries
- Boolean search operators

#### 4. Interactive Management (gh-dash)
- Terminal UI dashboard
- Multi-action support (view/comment/merge/diff/checkout/review)
- Multi-repository management
- YAML-based configuration
- Keyboard navigation
- Triage and assignment workflows
- **NOTE:** For humans only, NOT for automation (requires TTY)

#### 5. Issue Lifecycle Operations (native gh)
- Create issues (with templates)
- Read issues (view, list, status)
- Update issues (edit title, body, metadata)
- Delete issues (with confirmation)
- State management (open, close, reopen, transfer)
- Comment operations (add, edit, delete)
- Assignment operations (assign, unassign)
- Bulk operations (via xargs/loops)

#### 6. Label & Milestone Management (native gh)
- Label CRUD (create, read, update, delete)
- Label cloning across repositories
- Batch label application
- Milestone creation and management (via gh api)
- Label-based automation workflows

### Tool Ecosystem

**Native GitHub CLI:**
- No installation beyond `gh` itself
- 200+ test cases documented
- Complete API coverage
- JSON output (21 fields per issue)

**Extensions (652+ available, 3 recommended):**
- `gh-dash` - Interactive TUI (9k stars, actively maintained)
- `gh-grep` - File search with regex (211 stars, actively maintained)
- `gh-models` - AI assistance (official GitHub extension)

**Rejected Extensions:**
- `gh-label` - Last updated 2022, use native `gh label` instead
- `gh-milestone` - Last updated 2023, use `gh api` instead

---

## Documentation Structure

### Single Source of Truth Principle

Each topic has **EXACTLY ONE** authoritative document. All other references link to it.

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
- Interactive → `gh dash` (humans only)
- Labels → `gh label` (native)
- Milestones → `gh api`

**Effectiveness Metrics:**
- Overall AI assistance: 88/100
- Issue summarization: 94%
- Auto-labeling: 96%
- Knowledge Q&A: 88%
