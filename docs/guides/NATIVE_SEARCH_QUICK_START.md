# GitHub Native Search - Quick Start Guide

**Quick start guide for searching GitHub Issues using ONLY native GitHub CLI commands**

**Version:** 1.0.0
**Last Updated:** 2025-10-23

---

## Prerequisites

Install GitHub CLI:
```bash
# Already installed if you can run:
gh --version
```

Authenticate:
```bash
gh auth login
```

---

## Basic Searches

### Search Current Repository

```bash
# Search issues in current repo
gh issue list --search "authentication"

# Search for exact phrase
gh issue list --search "connection timeout error"

# Search in specific fields
gh issue list --search "in:title database"
gh issue list --search "in:body SQL query"
gh issue list --search "in:comments resolved"
```

### Search Across Multiple Repositories

```bash
# Search your organization
gh search issues "authentication" --owner=myorg

# Search specific repository
gh search issues "bug" --repo=owner/repo

# Search multiple repos
gh search issues "security" --repo=org/repo1 --repo=org/repo2
```

---

## Filter by Metadata

### By State

```bash
# Open issues only (default)
gh issue list --state=open

# Closed issues
gh issue list --state=closed

# All issues
gh issue list --state=all
```

### By Labels

```bash
# Single label
gh search issues --label=bug

# Multiple labels (AND logic)
gh search issues --label=bug --label=urgent

# Issues without labels
gh search issues --no-label

# Exclude label
gh search issues -- -label:wontfix
```

### By Users

```bash
# Assigned to me
gh search issues --assignee=@me --state=open

# Created by me
gh search issues --author=@me

# Involving me (any role)
gh search issues --involves=@me

# Specific user
gh search issues --assignee=john --state=open
```

### By Dates

```bash
# Created this year
gh search issues --created=">=2025-01-01"

# Updated recently
gh search issues --updated=">=2025-10-01"

# Closed in date range
gh search issues --closed="2025-01-01..2025-01-31"

# Stale issues (not updated in 6 months)
gh search issues --state=open --updated="<2025-04-23"
```

### By Milestone

```bash
# Issues in milestone
gh search issues --milestone="v2.0"

# Issues without milestone
gh search issues --no-milestone
```

---

## Advanced Queries

### Combine Multiple Filters

```bash
# Open bugs assigned to me
gh search issues --label=bug --assignee=@me --state=open

# High-engagement issues
gh search issues --comments=">20" --reactions=">10"

# Recent unassigned bugs
gh search issues --label=bug --no-assignee --created=">=2025-10-01"
```

### Using Raw Search Syntax

```bash
# Search with in: qualifiers
gh search issues "authentication in:title,body"

# Multiple conditions
gh search issues "bug label:urgent state:open"

# Exclude with minus
gh search issues "error" -- -label:wontfix -state:closed
```

### Content-Specific Searches

```bash
# Search only titles
gh search issues "database" --match=title

# Search titles and bodies
gh search issues "SQL injection" --match=title,body

# Search comments
gh search issues "resolved" --match=comments
```

---

## Knowledge Base Workflows

### Find Documentation

```bash
# All documentation issues
gh search issues --label=documentation --state=all

# How-to guides
gh search issues "how to" --label=guide

# Configuration examples
gh search issues "configure" in:title --label=example
```

### Search by Topic

```bash
# Authentication-related
gh search issues authentication --label=auth in:title,body

# Database issues
gh search issues database --label=backend

# Frontend issues
gh search issues --label=frontend --state=open
```

### Find Unresolved Questions

```bash
# Open questions
gh search issues --label=question --state=open

# Unanswered (no comments)
gh search issues --label=question --comments=0 --state=open

# Questions without assignee
gh search issues --label=question --no-assignee
```

---

## Output and Formatting

### JSON Output

```bash
# Get URLs only
gh search issues --label=bug --json url --jq '.[].url'

# Get number and title
gh search issues --state=open --json number,title

# Complete issue data
gh search issues --label=bug --json number,title,body,labels,state,url
```

### Custom Formatting

```bash
# Pipe to jq for filtering
gh search issues --label=bug --json title,url --jq '.[] | select(.title | contains("critical"))'

# Extract specific fields
gh search issues --state=open --json number,title --jq '.[] | "#\(.number): \(.title)"'
```

### Sort Results

```bash
# Most commented first
gh search issues --sort=comments --order=desc

# Recently created
gh search issues --sort=created --order=desc

# Most reactions
gh search issues --sort=reactions --order=desc --limit=10

# Recently updated
gh search issues --sort=updated --order=desc
```

### Limit Results

```bash
# Default: 30 results
gh search issues bug

# Get 10 results
gh search issues bug --limit=10

# Get 100 results
gh search issues --state=open --limit=100
```

---

## Common Search Patterns

### Personal Dashboard

```bash
# My open assignments
gh search issues --assignee=@me --state=open

# My recent activity
gh search issues --involves=@me --updated=">=2025-10-01"

# Issues I created
gh search issues --author=@me --state=all
```

### Team Management

```bash
# Team's open work
gh search issues --owner=myorg --state=open

# Unassigned issues
gh search issues --owner=myorg --no-assignee --state=open

# Needs triage
gh search issues --label="needs-triage" --state=open
```

### Bug Tracking

```bash
# All open bugs
gh search issues --label=bug --state=open

# Critical bugs
gh search issues --label=bug --label=critical

# Recently reported bugs
gh search issues --label=bug --created=">=2025-10-01"

# High-engagement bugs (many comments)
gh search issues --label=bug --comments=">20"
```

### Release Planning

```bash
# Issues in milestone
gh search issues --milestone="v2.0" --state=all

# Completed in milestone
gh search issues --milestone="v2.0" --state=closed

# Remaining work
gh search issues --milestone="v2.0" --state=open
```

---

## Tips and Best Practices

### 1. Use Appropriate Command

```bash
# Single repo → gh issue list
gh issue list --search "error"

# Multiple repos → gh search issues
gh search issues "error" --owner=myorg
```

### 2. Quote Multi-Word Phrases

```bash
# Correct
gh search issues "connection timeout"

# Wrong (searches two separate words)
gh search issues connection timeout
```

### 3. Use @me for Personal Queries

```bash
gh search issues --assignee=@me --state=open
gh search issues --author=@me
gh search issues --involves=@me
```

### 4. Save Common Queries as Aliases

Add to `~/.bashrc` or `~/.zshrc`:
```bash
alias gh-my-issues='gh search issues --assignee=@me --state=open'
alias gh-my-bugs='gh search issues --assignee=@me --label=bug --state=open'
alias gh-team-work='gh search issues --owner=myorg --state=open'
```

### 5. Use -- for Exclusions

```bash
# Exclude labels or other qualifiers
gh search issues -- -label:wontfix
gh search issues bug -- -author:bot -state:closed
```

### 6. Combine with jq for Scripting

```bash
# Get issue numbers only
gh search issues --label=bug --json number --jq '.[].number'

# Create formatted list
gh search issues --state=open --json number,title --jq '.[] | "#\(.number): \(.title)"'
```

---

## What Native Search CAN Do

✅ Search title, body, and comments
✅ Filter by labels, state, dates, users
✅ Sort by comments, reactions, dates
✅ JSON output for scripting
✅ Repository scoping
✅ Multi-word phrase matching
✅ Exclude with `-` prefix
✅ Date ranges
✅ Comment/reaction count filters

---

## What Native Search CANNOT Do

❌ Regex patterns (no `Bug.*auth.*failure`)
❌ Wildcards (no `auth*` or `?`)
❌ Context lines (no ripgrep's `-A`, `-B`, `-C`)
❌ Cross-line pattern matching
❌ Offline search
❌ Case-sensitive matching (all searches case-insensitive)

---

## Getting Help

```bash
# Command help
gh search issues --help
gh issue list --help

# Full documentation
man gh-search-issues
man gh-issue-list
```

**Online documentation:**
- GitHub CLI: https://cli.github.com/manual/gh_search_issues
- Search syntax: https://docs.github.com/en/search-github/searching-on-github/searching-issues-and-pull-requests

**Complete reference:**
- [GitHub Native Search Capabilities](/docs/research/GITHUB_NATIVE_SEARCH_CAPABILITIES.md)

---

**Version:** 1.0.0
**Last Updated:** 2025-10-23
