# GitHub CLI Research - Navigation Hub

Research documentation for GitHub CLI operations, extensions, and AI-powered workflows.

---

## 📚 Documents in This Category

### 1. **EXTENSIONS.md** - GitHub CLI Extensions Ecosystem

**Complete guide to GitHub CLI extensions tested and verified:**

- **Recommended Extensions:**
  - gh-grep (k1LoW/gh-grep) - File search with regex support
  - gh-models (github/gh-models) - AI assistance (official)
- **Rejected Extensions:**
  - gh-label (outdated, use native `gh label`)
  - gh-milestone (outdated, use `gh api`)
- **Installation, verification, and usage patterns**
- **Extension vs native commands comparison**

**Use when:** Selecting tools for GitHub CLI automation

**Location:** `/Users/terryli/eon/claude-code-skills-github-issues/docs/research/github-cli/EXTENSIONS.md`

---

### 2. **SEARCH_CAPABILITIES.md** - Native GitHub Search Reference

**Complete reference for GitHub's native search capabilities:**

- **30+ search qualifiers** (labels, dates, users, state, milestones)
- **Content search** (title, body, comments with `in:` qualifiers)
- **Quick start guide** + comprehensive reference
- **Structured query examples**
- **Limitations** (no regex, no wildcards)

**Use when:** Building search queries for GitHub Issues/PRs

**Location:** `/Users/terryli/eon/claude-code-skills-github-issues/docs/research/github-cli/SEARCH_CAPABILITIES.md`

---

### 3. **GH_MODELS_POC_RESULTS.md** - AI Assistance POC Results

**Empirical testing results for gh-models AI assistance:**

- **5 POC tests** with effectiveness metrics:
  - Issue Summarization: 94% accuracy
  - Auto-Labeling: 96% accuracy
  - Knowledge Base Q&A: 88% accuracy
  - Documentation Generation: 91% accuracy
  - Batch Processing: 80% effectiveness
- **Detailed test cases and results**
- **Performance metrics** (3-5 sec response times)
- **Limitations and best practices**

**Use when:** Evaluating AI assistance for automation workflows

**Location:** `/Users/terryli/eon/claude-code-skills-github-issues/docs/research/github-cli/GH_MODELS_POC_RESULTS.md`

---

## 🎯 Quick Navigation

**By Task:**

- **Install extensions** → EXTENSIONS.md
- **Search issues** → SEARCH_CAPABILITIES.md
- **AI automation** → GH_MODELS_POC_RESULTS.md

**By Tool:**

- **gh-grep** → EXTENSIONS.md
- **gh-models** → EXTENSIONS.md + GH_MODELS_POC_RESULTS.md
- **gh search** → SEARCH_CAPABILITIES.md

---

## 🔗 Related Documentation

**Operational Guide:**

- [AI_AGENT_OPERATIONAL_GUIDE.md](/docs/guides/AI_AGENT_OPERATIONAL_GUIDE.md) - Complete operational guide for AI agents

**Complete API Reference:**

- [github-cli-issues-comprehensive-guide.md](/docs/references/github-cli-issues-comprehensive-guide.md) - 200+ test cases

**Plugin System:**

- [claude-code-plugins/](/docs/research/claude-code-plugins/) - How to distribute these workflows as Claude Code plugins

---

## 📊 Research Methodology

All research in this category is:

- ✅ **Empirically tested** (200+ test cases)
- ✅ **Version tracked** (tested 2025-10-23)
- ✅ **Actively maintained** (verified maintenance status)
- ✅ **Effectiveness measured** (88% avg for AI operations)

---

## 📖 Reading Order

**For New Users:**

1. Start with SEARCH_CAPABILITIES.md (Quick Start section)
2. Browse EXTENSIONS.md (Quick Installation section)
3. Review GH_MODELS_POC_RESULTS.md (Executive Summary)

**For Advanced Users:**

1. SEARCH_CAPABILITIES.md (Complete Reference)
2. EXTENSIONS.md (Feature Comparison tables)
3. GH_MODELS_POC_RESULTS.md (Detailed test cases)

---

**Last Updated:** 2025-10-25
**Category:** GitHub CLI Research
**Documents:** 3
