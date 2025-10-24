# AI Agent Operational Guide - GitHub CLI Extensions

**Purpose:** Comprehensive operational guidance for AI coding agents working with GitHub Issues as a knowledge base
**Based On:** Empirical testing (2025-10-23) of gh-grep, gh-models, and native gh commands
**Audience:** AI assistants (Claude, Copilot, etc.) and automated workflows
**Version:** 4.0.0

> **🤖 Primary Reference for AI Agents**
>
> This is the complete operational guide for AI coding agents managing knowledge in GitHub Issues.
> Contains tool selection decision trees, empirically-tested workflows, and comprehensive operation references.
>
> **What this guide documents:** How to perform operations on GitHub Issues (the knowledge base backend)
> **What this guide is NOT:** The knowledge base itself - that lives in the actual Issues you create

---

## Table of Contents

1. [Quick Reference](#quick-reference)
2. [Tool Selection Decision Tree](#tool-selection-decision-tree)
3. [Extensions: gh-grep & gh-models](#extensions-gh-grep--gh-models)
4. [Native gh Commands](#native-gh-commands)
5. [Common Workflows](#common-workflows)
6. [Error Handling](#error-handling)
7. [Best Practices](#best-practices)
8. [Limitations and Constraints](#limitations-and-constraints)

---

## Quick Reference

### When to Use What

| Task                              | Tool              | Command Example                        |
| --------------------------------- | ----------------- | -------------------------------------- |
| Search issue title/body/comments  | Native gh         | `gh search issues "query"`             |
| Search files in repo (with regex) | gh-grep           | `gh grep "pattern" --owner X --repo Y` |
| AI-powered analysis               | gh-models         | `gh models run "model" "prompt"`       |
| Label management                  | Native gh         | `gh label list/create/delete`          |
| Milestone management              | Native gh api     | `gh api repos/owner/repo/milestones`   |
| Batch operations                  | Native gh + loops | `gh issue list \| xargs`               |

### Installation

**Install required extensions** - See [GITHUB_CLI_EXTENSIONS.md](/docs/research/GITHUB_CLI_EXTENSIONS.md#quick-installation) for installation instructions.

```bash
# Verify installation
gh extension list | grep -E 'gh-grep|gh-models'
```

---

## Tool Selection Decision Tree

```
┌─────────────────────────────────────┐
│ What do you need to do?             │
└─────────────────────────────────────┘
                │
                ├─ Search ISSUES (title, body, comments)?
                │  ├─ Simple keyword → `gh search issues "keyword"`
                │  ├─ Complex filters → `gh search issues --label X --state Y`
                │  └─ With metadata → `gh search issues --created ">2025-01-01"`
                │
                ├─ Search FILES (code, docs)?
                │  ├─ Simple text → `gh grep "text" --owner X --repo Y`
                │  ├─ Regex pattern → `gh grep "Bug.*critical" --owner X --repo Y`
                │  └─ Specific files → `gh grep "API" --include "*.md"`
                │
                ├─ AI-powered task?
                │  ├─ Summarize → `gh models run "model" "Summarize: $TEXT"`
                │  ├─ Generate → `gh models run "model" "Generate docs for: $CODE"`
                │  └─ Classify → `gh models run "model" "Suggest labels for: $ISSUE"`
                │
                ├─ Label operations?
                │  ├─ List → `gh label list`
                │  ├─ Create → `gh label create NAME --color HEX`
                │  └─ Manage → `gh label edit/delete NAME`
                │
                ├─ Milestone operations?
                │  └─ Use → `gh api repos/owner/repo/milestones`
                │
                └─ Batch operations?
                   └─ Use → `gh issue list --json | jq | xargs`
```

---

## Extensions: gh-grep & gh-models

### Quick Overview

**Two recommended extensions for AI agents:**

1. **gh-grep** - File search with regex support (searches repository files, not issues)
2. **gh-models** - Official GitHub AI assistance (29+ models for summarization, generation, analysis)

**Key Distinction:**
- `gh search issues` → Searches ISSUES/PRs (title, body, comments)
- `gh grep` → Searches FILES (code, docs, configs)
- `gh models` → AI-powered operations

**Complete Documentation:** See [GITHUB_CLI_EXTENSIONS.md](/docs/research/GITHUB_CLI_EXTENSIONS.md) for:
- Installation instructions
- Complete command syntax and flags
- Empirical test results
- Use cases and examples
- Error handling
- Performance considerations

### Quick Examples

```bash
# gh-grep: Search files with regex
gh grep "authentication" --owner myorg --repo myrepo --include "*.md"

# gh-models: AI assistance
gh models run "openai/gpt-4.1" "Summarize: $ISSUE_BODY"
```

---

## Native gh Commands

### Overview

**Purpose:** Core GitHub CLI functionality (no extensions needed)
**Best For:** All basic operations, automation, CI/CD
**Documentation:** https://cli.github.com/manual/

### Issue Search

**Command:** `gh search issues [query] [flags]`

**Empirical Testing:** ✅ Fully tested in GITHUB_NATIVE_SEARCH_CAPABILITIES.md

#### Search Syntax

```bash
# Simple keyword
gh search issues "authentication"

# Exact phrase
gh search issues "connection timeout error"

# Field-specific
gh search issues "in:title bug in:body database"

# With metadata filters
gh search issues "bug" --label=critical --state=open --assignee=@me
```

#### Available Flags

| Flag              | Description      | Example                    |
| ----------------- | ---------------- | -------------------------- |
| `--assignee USER` | Assigned to user | `--assignee=@me`           |
| `--author USER`   | Created by user  | `--author=john`            |
| `--label LABEL`   | Has label        | `--label=bug`              |
| `--state STATE`   | Issue state      | `--state=open`             |
| `--created DATE`  | Created date     | `--created=">=2025-01-01"` |
| `--updated DATE`  | Updated date     | `--updated="<2025-01-01"`  |
| `--comments N`    | Comment count    | `--comments=">10"`         |
| `--match FIELD`   | Search field     | `--match=title,body`       |
| `--owner OWNER`   | Repository owner | `--owner=myorg`            |
| `--repo REPO`     | Repository       | `--repo=myrepo`            |
| `--json FIELDS`   | JSON output      | `--json number,title`      |
| `--jq EXPR`       | jq filter        | `--jq '.[] \| .url'`       |
| `--limit N`       | Result limit     | `--limit=50`               |

#### Practical Examples

```bash
# My open bugs
gh search issues --assignee=@me --label=bug --state=open

# Recent high-priority issues
gh search issues \
  --label="priority:high" \
  --created=">=2025-10-01" \
  --state=open

# Issues needing triage
gh search issues \
  --no-assignee \
  --no-label \
  --state=open \
  --owner=myorg

# High-engagement issues
gh search issues \
  --comments=">20" \
  --reactions=">10" \
  --state=open
```

### Label Management

**Commands:** `gh label [subcommand]`

**Empirical Testing:** ✅ Tested, works perfectly

#### Subcommands

```bash
gh label list                    # List all labels
gh label create NAME [flags]     # Create label
gh label edit NAME [flags]       # Edit label
gh label delete NAME             # Delete label
gh label clone SOURCE_REPO       # Clone labels from another repo
```

#### Flags for create/edit

| Flag                 | Description          | Example                       |
| -------------------- | -------------------- | ----------------------------- |
| `--color HEX`        | Label color          | `--color d73a4a`              |
| `--description TEXT` | Description          | `--description "Bug reports"` |
| `--name TEXT`        | New name (edit only) | `--name bug-report`           |

#### Empirical Test Results

```bash
$ gh label list --repo terrylica/knowledgebase --limit 10

# Result: ✅ SUCCESS
bug                  Something isn't working          #d73a4a
documentation        Improvements or additions        #0075ca
enhancement          New feature or request           #a2eeef
priority:high        High priority issue              #ff0000
[... 10 labels listed ...]
```

#### Practical Examples

```bash
# Create priority labels
gh label create "priority:critical" --color "ff0000" --description "Critical priority"
gh label create "priority:high" --color "ff6600" --description "High priority"
gh label create "priority:medium" --color "ffaa00" --description "Medium priority"
gh label create "priority:low" --color "ffff00" --description "Low priority"

# Clone labels from template
gh label clone my-org/template-repo --repo my-org/new-repo

# Edit label
gh label edit "bug" --color "d73a4a" --description "Something isn't working"

# Delete label
gh label delete "deprecated-label"
```

### Milestone Management

**Method:** Use `gh api` (no native milestone commands)

**Empirical Testing:** ✅ Documented, API method works

#### List Milestones

```bash
gh api repos/owner/repo/milestones
```

#### Create Milestone

```bash
gh api repos/owner/repo/milestones \
  -f title="v2.0" \
  -f description="Version 2.0 release" \
  -f due_on="2025-12-31T23:59:59Z" \
  -f state="open"
```

#### Get Milestone

```bash
gh api repos/owner/repo/milestones/NUMBER
```

#### Update Milestone

```bash
gh api -X PATCH repos/owner/repo/milestones/NUMBER \
  -f state="closed" \
  -f title="Updated Title"
```

#### Delete Milestone

```bash
gh api -X DELETE repos/owner/repo/milestones/NUMBER
```

#### Practical Example

```bash
# Create milestone
MILESTONE_ID=$(gh api repos/myorg/myrepo/milestones \
  -f title="Q1 2025" \
  -f description="Q1 2025 deliverables" \
  -f due_on="2025-03-31T23:59:59Z" \
  --jq .number)

# Assign issues to milestone
for issue in 10 11 12; do
  gh api -X PATCH repos/myorg/myrepo/issues/$issue \
    -f milestone=$MILESTONE_ID
done
```

### Issue Operations

#### List Issues

```bash
gh issue list [flags]
```

**Flags:**

- `--assignee USER`
- `--author USER`
- `--label LABEL`
- `--state STATE` (open, closed, all)
- `--search QUERY`
- `--json FIELDS`
- `--limit N`

#### View Issue

```bash
gh issue view NUMBER [flags]

# With JSON output
gh issue view 123 --json title,body,labels,assignees

# With jq filter
gh issue view 123 --json body --jq .body
```

#### Create Issue

```bash
gh issue create [flags]

# Interactive
gh issue create

# Non-interactive
gh issue create \
  --title "Bug: Memory leak" \
  --body "Description..." \
  --label bug \
  --label priority:high \
  --assignee @me
```

#### Edit Issue

```bash
gh issue edit NUMBER [flags]

# Add label
gh issue edit 123 --add-label "reviewed"

# Remove label
gh issue edit 123 --remove-label "needs-review"

# Change assignee
gh issue edit 123 --add-assignee alice

# Update milestone
gh api -X PATCH repos/owner/repo/issues/123 -f milestone=5
```

#### Close Issue

```bash
gh issue close NUMBER [flags]

# With reason
gh issue close 123 --reason "completed"
gh issue close 123 --reason "not planned"

# With comment
gh issue close 123 --comment "Fixed in PR #456"
```

#### Reopen Issue

```bash
gh issue reopen NUMBER [flags]

# With comment
gh issue reopen 123 --comment "Reopening due to regression"
```

---

## Common Workflows

### Workflow 1: Daily Issue Triage

```bash
#!/bin/bash
# Daily triage of new issues

REPO="myorg/myrepo"

echo "=== New Issues (Last 24 Hours) ==="
gh search issues \
  --repo "$REPO" \
  --created ">=2025-10-22" \
  --state open \
  --json number,title,author \
  --jq '.[] | "#\(.number): \(.title) (@\(.author.login))"'

echo ""
echo "=== Needs Triage (No Labels) ==="
gh search issues \
  --repo "$REPO" \
  --state open \
  --no-label \
  --json number,title \
  --jq '.[] | "#\(.number): \(.title)"'

echo ""
echo "=== High Activity (>10 comments) ==="
gh search issues \
  --repo "$REPO" \
  --state open \
  --comments ">10" \
  --json number,title,comments \
  --jq '.[] | "#\(.number): \(.title) (\(.comments) comments)"'
```

### Workflow 2: AI-Powered Auto-Labeling

```bash
#!/bin/bash
# Auto-label new issues using AI

REPO="myorg/myrepo"

# Get new issues
gh search issues \
  --repo "$REPO" \
  --created ">=2025-10-22" \
  --no-label \
  --json number,title,body | \
jq -c '.[]' | \
while read -r issue; do
  NUMBER=$(echo "$issue" | jq -r .number)
  TITLE=$(echo "$issue" | jq -r .title)
  BODY=$(echo "$issue" | jq -r .body)

  echo "Processing issue #$NUMBER..."

  # Ask AI to classify
  LABELS=$(gh models run "openai/gpt-4.1" \
    "Classify this issue. Select 1-3 labels from: bug, enhancement, documentation, question.
    Respond with only the label names, comma-separated.

    Title: ${TITLE}
    Body: ${BODY}")

  # Apply labels
  IFS=',' read -ra LABEL_ARRAY <<< "$LABELS"
  for label in "${LABEL_ARRAY[@]}"; do
    label=$(echo "$label" | xargs) # trim whitespace
    echo "  Adding label: $label"
    gh issue edit "$NUMBER" --add-label "$label" --repo "$REPO"
  done
done
```

### Workflow 3: Search Knowledge Base

```bash
#!/bin/bash
# Search knowledge base issues and files

QUERY="$1"
REPO="myorg/knowledge-base"

if [ -z "$QUERY" ]; then
  echo "Usage: $0 <search-query>"
  exit 1
fi

echo "=== Searching Issues for: $QUERY ==="
gh search issues "$QUERY" \
  --repo "$REPO" \
  --match title,body \
  --json number,title,url \
  --jq '.[] | "#\(.number): \(.title)\n  \(.url)"'

echo ""
echo "=== Searching Files for: $QUERY ==="
gh grep "$QUERY" \
  --owner myorg \
  --repo knowledge-base \
  --line-number \
  --include "*.md"
```

### Workflow 4: Generate Weekly Report

```bash
#!/bin/bash
# Generate weekly issue report

REPO="myorg/myrepo"
SINCE="2025-10-16" # 7 days ago

echo "# Weekly Issue Report"
echo "Week ending: $(date +%Y-%m-%d)"
echo ""

echo "## New Issues"
gh search issues \
  --repo "$REPO" \
  --created ">=$SINCE" \
  --json number,title,author \
  --jq '.[] | "- #\(.number): \(.title) (@\(.author.login))"'

echo ""
echo "## Closed Issues"
gh search issues \
  --repo "$REPO" \
  --closed ">=$SINCE" \
  --state closed \
  --json number,title \
  --jq '.[] | "- #\(.number): \(.title)"'

echo ""
echo "## Most Active Issues"
gh search issues \
  --repo "$REPO" \
  --updated ">=$SINCE" \
  --state open \
  --sort comments \
  --limit 5 \
  --json number,title,comments \
  --jq '.[] | "- #\(.number): \(.title) (\(.comments) comments)"'
```

### Workflow 5: Batch Close Stale Issues

```bash
#!/bin/bash
# Close issues inactive for 60+ days

REPO="myorg/myrepo"
CUTOFF_DATE="2025-08-24" # 60 days ago

echo "Finding stale issues..."
gh search issues \
  --repo "$REPO" \
  --state open \
  --updated "<$CUTOFF_DATE" \
  --json number,title,updatedAt | \
jq -c '.[]' | \
while read -r issue; do
  NUMBER=$(echo "$issue" | jq -r .number)
  TITLE=$(echo "$issue" | jq -r .title)
  UPDATED=$(echo "$issue" | jq -r .updatedAt)

  echo "Closing #$NUMBER: $TITLE (last updated: $UPDATED)"

  gh issue close "$NUMBER" \
    --reason "not planned" \
    --comment "Closing due to inactivity (60+ days). Please reopen if still relevant." \
    --repo "$REPO"
done
```

### Workflow 6: Find Related Issues

```bash
#!/bin/bash
# Find issues related to a specific topic

TOPIC="$1"
REPO="myorg/myrepo"

if [ -z "$TOPIC" ]; then
  echo "Usage: $0 <topic>"
  exit 1
fi

echo "=== Issues mentioning: $TOPIC ==="
echo ""

echo "In titles:"
gh search issues "$TOPIC" \
  --repo "$REPO" \
  --match title \
  --json number,title \
  --jq '.[] | "#\(.number): \(.title)"'

echo ""
echo "In code/docs (files):"
gh grep "$TOPIC" \
  --owner myorg \
  --repo myrepo \
  --name-only
```

---

## Error Handling

### Common Errors and Solutions

#### 1. Extension Not Installed

```bash
# Error
gh grep: command not found

# Check installed extensions
gh extension list

# Install if missing
gh extension install k1LoW/gh-grep
```

#### 2. Missing Required Flags

```bash
# Error
Error: required flag(s) "owner" not set

# Solution: Always include required flags
gh grep "pattern" --owner myorg --repo myrepo
```

#### 3. Rate Limiting

```bash
# Error (gh-models)
Error: rate limit exceeded

# Solution: Wait and retry
sleep 60
gh models run "model" "prompt"

# Or: Reduce frequency of calls
```

#### 5. jq Parse Errors

```bash
# Error
jq: parse error: Invalid string: control characters

# Solution: Handle potential null/empty values
gh issue view 123 --json body --jq '.body // ""'
```

#### 6. Authentication Required

```bash
# Error
Error: authentication required

# Solution: Authenticate
gh auth login

# Check status
gh auth status
```

### Defensive Programming Pattern

```bash
#!/bin/bash
set -euo pipefail  # Exit on error, undefined variables, pipe failures

# Check prerequisites
if ! command -v gh &> /dev/null; then
  echo "Error: gh CLI not installed"
  exit 1
fi

# Check authentication
if ! gh auth status &> /dev/null; then
  echo "Error: Not authenticated. Run: gh auth login"
  exit 1
fi

# Check extension installation
if ! gh extension list | grep -q "gh-grep"; then
  echo "Error: gh-grep not installed. Run: gh extension install k1LoW/gh-grep"
  exit 1
fi

# Validate inputs
REPO="${1:-}"
if [ -z "$REPO" ]; then
  echo "Usage: $0 <owner/repo>"
  exit 1
fi

# Execute with error handling
if ! gh search issues --repo "$REPO" --state open; then
  echo "Error: Failed to search issues"
  exit 1
fi
```

---

## Best Practices

### 1. Choose the Right Tool

**Decision Matrix:**

| Need                    | Use                | Not                    |
| ----------------------- | ------------------ | ---------------------- |
| Search issue content    | `gh search issues` | gh-grep                |
| Search files with regex | `gh grep`          | `gh search issues`     |
| AI assistance           | `gh models`        | -                      |
| Label operations        | `gh label`         | gh-label extension     |
| Milestones              | `gh api`           | gh-milestone extension |

### 2. Always Specify Repository

```bash
# ✅ Good: Explicit repository
gh search issues "bug" --repo myorg/myrepo

# ⚠️ Risky: Depends on current directory
gh search issues "bug"
```

### 3. Use JSON Output for Automation

```bash
# ✅ Good: Structured output
gh search issues --label bug --json number,title | jq -r '.[] | .number'

# ❌ Bad: Parsing human-readable output
gh search issues --label bug | grep "#" | cut -d: -f1
```

### 4. Handle Empty Results

```bash
# Check for empty results
RESULTS=$(gh search issues "nonexistent" --json number)
if [ "$(echo "$RESULTS" | jq length)" -eq 0 ]; then
  echo "No issues found"
  exit 0
fi
```

### 5. Quote Variables

```bash
# ✅ Good: Quoted variables
gh search issues "${QUERY}" --repo "${REPO}"

# ❌ Bad: Unquoted (fails with spaces)
gh search issues $QUERY --repo $REPO
```

### 6. Use Meaningful Output

```bash
# ✅ Good: Informative progress
for issue in "${issues[@]}"; do
  echo "Processing issue #${issue}..."
  gh issue edit "$issue" --add-label "processed"
  echo "✅ Labeled issue #${issue}"
done

# ❌ Bad: Silent operation (user doesn't know what's happening)
for issue in "${issues[@]}"; do
  gh issue edit "$issue" --add-label "processed"
done
```

### 7. Rate Limit Awareness

```bash
# For large operations, add delays
gh issue list --limit 100 --json number --jq '.[].number' | \
while read -r issue; do
  gh issue edit "$issue" --add-label "processed"
  sleep 0.5  # Avoid rate limiting
done
```

### 8. Use AI Models Appropriately

```bash
# ✅ Good: Specific, constrained prompt
gh models run "openai/gpt-4.1" \
  "Classify as: bug, feature, or question. One word only.
  Issue: ${BODY}"

# ❌ Bad: Open-ended, unreliable
gh models run "openai/gpt-4.1" "What do you think about this? ${BODY}"
```

---

## Limitations and Constraints

### gh-grep Limitations

1. **Searches Files, Not Issues** - Different from `gh search issues`

2. **Requires Owner Flag** - Must always specify `--owner`

3. **Rate Limited** - Subject to GitHub API limits (5,000 req/hour)

4. **Default Branch Only** - Unless `--branch` specified

5. **No Wildcard Repo Search** - Cannot search all repos in org without specifying

### gh-models Limitations

1. **Not for Production** - Free tier is for experimentation only

2. **Rate Limited** - Limits vary by model

3. **No Sensitive Data** - Azure hosted, not for confidential info

4. **Can Make Mistakes** - AI-generated, needs validation

5. **Internet Required** - Cannot work offline

### Native gh Commands Limitations

1. **No Regex in Issue Search** - `gh search issues` doesn't support regex patterns

2. **No Wildcards** - Cannot use `*` or `?` in searches

3. **No Context Lines** - No equivalent to ripgrep's `-A`, `-B`, `-C`

4. **Rate Limited** - API limits apply (5,000 authenticated req/hour)

5. **No Built-in Milestone Commands** - Must use `gh api`

### General Constraints

1. **Authentication Required** - All operations need `gh auth login`

2. **Repository Access** - Can only access repos you have permissions for

3. **Internet Required** - Cannot work offline (all tools use GitHub API)

4. **GitHub.com Only** - Extensions may not work with GitHub Enterprise (check docs)

---

## Maintenance

### Keep Extensions Updated

```bash
# List installed extensions with versions
gh extension list

# Upgrade all extensions
gh extension upgrade --all

# Upgrade specific extension
gh extension upgrade k1LoW/gh-grep
```

### Check Extension Status

```bash
# Verify installation for AI agents
gh extension list | grep -E "(gh-grep|gh-models)"

# Expected output:
# k1LoW/gh-grep
# github/gh-models
```

### Verify GitHub CLI Version

```bash
# Check gh version
gh --version

# Should be 2.0 or higher for full feature support
```

---

## Quick Reference Card

```
TOOL SELECTION QUICK GUIDE
==========================

Search Issues:      gh search issues "query" --repo X
Search Files:       gh grep "pattern" --owner X --repo Y
AI Assistance:      gh models run "model" "prompt"
Labels:             gh label list/create/delete
Milestones:         gh api repos/X/Y/milestones

WHEN TO USE WHAT (AI Agents)
============================

Issue Content → gh search issues
File Content → gh grep (supports regex!)
AI Tasks → gh models
Labels → gh label (native, no extension!)
Milestones → gh api
Batch Ops → Native gh + loops

NEVER USE
=========

gh-label extension → DEAD (use native gh label)
gh-milestone extension → DEAD (use gh api)

REMEMBER
========

✅ gh-grep: File searches with regex
✅ gh-models: AI assistance (free tier)
✅ Native gh: Automation and scripts
❌ Don't use outdated extensions
```

---

**Document Version:** 1.0.0
**Last Updated:** 2025-10-23
**Based On:** Empirical testing in /tmp/gh-extensions-test
**Tested Tools:** gh-grep v1.2.5, gh-models v0.0.25
**Target Audience:** AI coding agents and automated workflows
