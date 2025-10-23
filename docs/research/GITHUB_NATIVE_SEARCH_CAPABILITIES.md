# GitHub Native Search Capabilities - Complete Guide

**Quick Start + Comprehensive Reference**
**Date:** 2025-10-23
**Status:** Complete research based on official documentation
**Version:** 2.0.0

---

## Table of Contents

1. [Quick Start](#quick-start) - Get started in 5 minutes
2. [Executive Summary](#executive-summary) - Key findings
3. [Native GitHub CLI Search Commands](#native-github-cli-search-commands) - Complete reference
4. [Native Search Syntax and Qualifiers](#native-search-syntax-and-qualifiers) - All filters
5. [Advanced Use Cases](#advanced-use-cases) - Real-world examples
6. [Limitations](#limitations) - What's NOT possible

---

## Quick Start

**Get started with GitHub native search in 5 minutes**

### Prerequisites

```bash
# Verify GitHub CLI is installed
gh --version

# Authenticate if needed
gh auth login
```

### Basic Searches

```bash
# Search issues in current repository
gh issue list --search "authentication"

# Search for exact phrase
gh issue list --search "connection timeout error"

# Search in specific fields
gh issue list --search "in:title database"
gh issue list --search "in:body SQL query"
gh issue list --search "in:comments resolved"
```

### Filter by Common Criteria

```bash
# Open issues only
gh issue list --state=open

# By label
gh search issues --label=bug

# Assigned to me
gh search issues --assignee=@me --state=open

# Created recently
gh search issues --created=">=2025-10-01"

# Multiple filters combined
gh search issues --label=bug --assignee=@me --state=open
```

### Search Across Multiple Repositories

```bash
# Search your organization
gh search issues "authentication" --owner=myorg

# Search specific repository
gh search issues "bug" --repo=owner/repo
```

**For comprehensive documentation, continue reading below.**

---

## Executive Summary

GitHub provides **robust native search capabilities** through its CLI and API that support searching issues and pull requests with extensive filtering. This document provides both a quick start guide and complete reference for ONLY the native features available through GitHub CLI (`gh`) without any third-party tools or workarounds.

### Key Findings

- ✅ **Native issue search IS available** via `gh search issues` and `gh issue list --search`
- ✅ **Searches title, body, AND comments** using `in:` qualifiers
- ✅ **Extensive filtering** with 30+ qualifiers (labels, dates, users, state, etc.)
- ✅ **Boolean operators** supported (-, ranges, quotes)
- ✅ **Quick start available above** for immediate use
- ❌ **No regex support** in API/CLI (only in web UI for code search)
- ❌ **No wildcards** in search patterns
- ❌ **No context lines** (ripgrep's -A/-B/-C features)

---

## Native GitHub CLI Search Commands

### 1. `gh search issues` - Cross-Repository Search

**Purpose:** Search issues across multiple repositories, organizations, or all of GitHub

**Basic Syntax:**

```bash
gh search issues [<query>] [flags]
```

**When to use:**

- Searching across multiple repositories
- Organization-wide searches
- Global GitHub searches with specific filters

**Examples:**

```bash
# Search for "authentication" in title, body, or comments
gh search issues authentication

# Search exact phrase
gh search issues "SQL injection vulnerability"

# Search in specific organization
gh search issues authentication --owner=myorg

# Search with state filter
gh search issues bug --state=open

# Include pull requests in search
gh search issues security --include-prs
```

### 2. `gh issue list --search` - Single Repository Search

**Purpose:** Search issues within a specific repository

**Basic Syntax:**

```bash
gh issue list --search "<query>" [flags]
```

**When to use:**

- Working within a single repository
- Repository-scoped searches
- Quick local issue queries

**Examples:**

```bash
# Search in current repository
gh issue list --search "database error"

# Search in specific repository
gh issue list --repo owner/repo --search "memory leak"

# Search with sorting
gh issue list --search "bug sort:updated-desc"
```

---

## Native Search Syntax and Qualifiers

All qualifiers below are **natively supported** by GitHub CLI and API.

### Content Search Qualifiers

| Qualifier       | Description                | Example                        |
| --------------- | -------------------------- | ------------------------------ |
| `in:title`      | Search issue titles only   | `in:title database`            |
| `in:body`       | Search issue body only     | `in:body "SQL query"`          |
| `in:comments`   | Search issue comments only | `in:comments resolved`         |
| `in:title,body` | Search multiple fields     | `in:title,body authentication` |

**Examples:**

```bash
# Search only in titles
gh search issues "authentication failure" --match=title

# Search in body and comments
gh search issues "stack trace" --match=body,comments

# Using raw syntax
gh search issues "in:title bug in:body database"
```

### State and Type Filters

| Qualifier      | Description                     | Example        |
| -------------- | ------------------------------- | -------------- |
| `state:open`   | Open issues only                | `state:open`   |
| `state:closed` | Closed issues only              | `state:closed` |
| `is:open`      | Alternative syntax              | `is:open`      |
| `is:closed`    | Alternative syntax              | `is:closed`    |
| `is:merged`    | Merged PRs (with --include-prs) | `is:merged`    |
| `type:issue`   | Issues only                     | `type:issue`   |
| `type:pr`      | Pull requests only              | `type:pr`      |

**Examples:**

```bash
# Open issues only
gh search issues bug --state=open

# Closed issues
gh search issues "won't fix" --state=closed

# Include pull requests
gh search issues security --include-prs
```

### User-Related Qualifiers

| Qualifier            | Description              | Example                  |
| -------------------- | ------------------------ | ------------------------ |
| `author:USERNAME`    | Created by user          | `author:octocat`         |
| `assignee:USERNAME`  | Assigned to user         | `assignee:@me`           |
| `mentions:USERNAME`  | Mentions user            | `mentions:octocat`       |
| `commenter:USERNAME` | User commented           | `commenter:alice`        |
| `involves:USERNAME`  | User involved (any role) | `involves:@me`           |
| `team-mentions:TEAM` | Team mentioned           | `team-mentions:security` |

**Examples:**

```bash
# Issues assigned to me
gh search issues --assignee=@me --state=open

# Issues I authored
gh search issues --author=@me

# Issues involving me
gh search issues --involves=@me

# Issues with specific author
gh search issues "bug" --author=john
```

### Repository Scope Qualifiers

| Qualifier         | Description               | Example        |
| ----------------- | ------------------------- | -------------- |
| `repo:OWNER/REPO` | Specific repository       | `repo:cli/cli` |
| `user:USERNAME`   | User's repositories       | `user:octocat` |
| `org:ORGNAME`     | Organization repositories | `org:github`   |
| `owner:NAME`      | Repository owner          | `owner:github` |

**Examples:**

```bash
# Search in specific repo
gh search issues "memory leak" --repo=myorg/myapp

# Search across organization
gh search issues security --owner=myorg

# Multiple repositories
gh search issues bug --repo=org/repo1 --repo=org/repo2
```

### Labels and Metadata

| Qualifier         | Description        | Example            |
| ----------------- | ------------------ | ------------------ |
| `label:LABEL`     | Has specific label | `label:bug`        |
| `no:label`        | Has no labels      | `no:label`         |
| `milestone:TITLE` | In milestone       | `milestone:"v2.0"` |
| `no:milestone`    | Has no milestone   | `no:milestone`     |
| `project:NUMBER`  | In project board   | `project:5`        |
| `no:project`      | Not in project     | `no:project`       |

**Examples:**

```bash
# Issues with "bug" label
gh search issues --label=bug

# Issues with multiple labels
gh search issues --label=bug --label=urgent

# Issues without labels
gh search issues --no-label

# Issues in milestone
gh search issues --milestone="Q1 2025"

# Exclude label using raw syntax
gh search issues -- -label:wontfix
```

### Date and Time Qualifiers

| Qualifier      | Description                  | Example               |
| -------------- | ---------------------------- | --------------------- |
| `created:DATE` | Created on/after/before date | `created:>2025-01-01` |
| `updated:DATE` | Updated on/after/before date | `updated:<2025-01-01` |
| `closed:DATE`  | Closed on/after/before date  | `closed:2025-01-15`   |
| `merged:DATE`  | Merged on/after/before date  | `merged:>=2025-01-01` |

**Date Formats:**

- Absolute: `YYYY-MM-DD`
- Relative: `created:>2025-01-01`
- Ranges: `created:2025-01-01..2025-01-31`

**Examples:**

```bash
# Issues created this year
gh search issues --created=">=2025-01-01"

# Issues updated recently
gh search issues --updated=">=2025-10-01"

# Issues closed in date range
gh search issues --closed="2025-01-01..2025-01-31"
```

### Quantitative Filters

| Qualifier        | Description          | Example            |
| ---------------- | -------------------- | ------------------ |
| `comments:N`     | Number of comments   | `comments:>10`     |
| `reactions:N`    | Number of reactions  | `reactions:>=5`    |
| `interactions:N` | Comments + reactions | `interactions:>50` |

**Operators:** `>`, `>=`, `<`, `<=`, `N..M` (ranges)

**Examples:**

```bash
# Issues with many comments
gh search issues --comments=">100"

# Issues with few reactions
gh search issues --reactions="<5"

# Issues with high engagement
gh search issues --interactions=">50"
```

### Repository Characteristics

| Qualifier         | Description          | Example             |
| ----------------- | -------------------- | ------------------- |
| `language:LANG`   | Repository language  | `language:python`   |
| `archived:BOOL`   | Archived status      | `archived:false`    |
| `is:public`       | Public repositories  | `is:public`         |
| `is:private`      | Private repositories | `is:private`        |
| `visibility:TYPE` | Visibility type      | `visibility:public` |

**Examples:**

```bash
# Issues in Python repos
gh search issues --language=python

# Exclude archived repos
gh search issues --archived=false

# Only public repos
gh search issues --visibility=public
```

### Review Status (Pull Requests)

| Qualifier                  | Description           | Example                    |
| -------------------------- | --------------------- | -------------------------- |
| `review:none`              | No reviews            | `review:none`              |
| `review:required`          | Review required       | `review:required`          |
| `review:approved`          | Approved              | `review:approved`          |
| `review:changes_requested` | Changes requested     | `review:changes_requested` |
| `reviewed-by:USER`         | Reviewed by user      | `reviewed-by:alice`        |
| `review-requested:USER`    | Review requested from | `review-requested:@me`     |
| `draft:BOOL`               | Draft status          | `draft:false`              |

**Examples:**

```bash
# PRs awaiting my review
gh search issues --include-prs --review-requested=@me --state=open

# Approved PRs
gh search issues --include-prs review:approved

# Non-draft PRs
gh search issues --include-prs draft:false
```

### Additional Filters

| Qualifier      | Description           | Example          |
| -------------- | --------------------- | ---------------- |
| `app:APP`      | Created by GitHub App | `app:dependabot` |
| `is:locked`    | Locked conversations  | `is:locked`      |
| `linked:pr`    | Issues linked to PRs  | `linked:pr`      |
| `linked:issue` | PRs linked to issues  | `linked:issue`   |

---

## Boolean Operators and Advanced Syntax

### Negation (Exclusion)

**Syntax:** Use `-` prefix or `--` flag separator

**Examples:**

```bash
# Exclude label "wontfix"
gh search issues -- -label:wontfix

# Exclude author
gh search issues -- -author:bot

# Exclude closed issues
gh search issues -- -state:closed
```

### Combining Multiple Qualifiers

**Default behavior:** Multiple qualifiers use AND logic

**Examples:**

```bash
# Multiple conditions (AND)
gh search issues bug --label=urgent --state=open --assignee=@me

# Using raw syntax
gh search issues "bug label:urgent state:open assignee:@me"
```

### Quoted Phrases

**Syntax:** Use quotes for exact multi-word matches

**Examples:**

```bash
# Exact phrase match
gh search issues "connection timeout error"

# Phrase with qualifiers
gh search issues "database migration" --label=bug
```

### Ranges

**Supported for:** Dates, numbers (comments, reactions, interactions)

**Syntax:** `qualifier:MIN..MAX`

**Examples:**

```bash
# Date range
gh search issues created:2025-01-01..2025-01-31

# Comment count range
gh search issues comments:10..50

# Reactions range
gh search issues reactions:5..20
```

---

## Output and Formatting Options

### JSON Output

**Available fields:**

- `assignees`
- `author`
- `authorAssociation`
- `body`
- `closedAt`
- `commentsCount`
- `createdAt`
- `id`
- `isLocked`
- `isPullRequest`
- `labels`
- `number`
- `repository`
- `state`
- `title`
- `updatedAt`
- `url`

**Examples:**

```bash
# Output as JSON
gh search issues bug --json number,title,state,url

# All fields
gh search issues bug --json assignees,author,body,labels,state,title

# With jq filtering
gh search issues bug --json title,url --jq '.[] | select(.title | contains("critical"))'
```

### Sorting and Ordering

**Sort options:**

- `comments` - By number of comments
- `created` - By creation date
- `interactions` - By total interactions
- `reactions` - By reactions count
- `updated` - By last update date
- Reaction types: `+1`, `-1`, `smile`, `tada`, `heart`

**Order:**

- `asc` - Ascending
- `desc` - Descending (default)

**Examples:**

```bash
# Most commented
gh search issues bug --sort=comments --order=desc

# Recently created
gh search issues feature --sort=created --order=desc

# Most reactions
gh search issues --sort=reactions --order=desc --limit=10
```

### Result Limits

**Default:** 30 results
**Maximum:** Up to 1000 results (API limit)

**Examples:**

```bash
# Limit to 10 results
gh search issues bug --limit=10

# Get 100 results
gh search issues --state=open --limit=100
```

### Web Browser Integration

**Open search in browser:**

```bash
gh search issues bug --web
gh issue list --web
```

---

## Practical Usage Patterns

### Knowledge Base Searches

```bash
# Find all documentation issues
gh search issues --label=documentation --state=all

# Search knowledge base content
gh search issues "how to configure" --label=howto

# Find unresolved questions
gh search issues --label=question --state=open --no-assignee

# Search by topic
gh search issues authentication in:title,body --label=guide
```

### Bug Tracking

```bash
# All open bugs
gh search issues --label=bug --state=open

# Critical bugs unassigned
gh search issues --label=bug --label=critical --no-assignee

# Recently reported bugs
gh search issues --label=bug --created=">=2025-10-01"

# High-engagement bugs
gh search issues --label=bug --comments=">20"
```

### Team Management

```bash
# My assigned issues
gh search issues --assignee=@me --state=open

# Team's open issues
gh search issues --owner=myorg --state=open

# Issues needing review
gh search issues --label="needs-review" --state=open

# Stale issues
gh search issues --state=open --updated="<2025-01-01"
```

### Release Planning

```bash
# Issues in milestone
gh search issues --milestone="v2.0" --state=all

# Completed in milestone
gh search issues --milestone="v2.0" --state=closed

# Remaining work
gh search issues --milestone="v2.0" --state=open --no-assignee
```

### Security and Compliance

```bash
# Security-labeled issues
gh search issues --label=security --state=all

# Dependabot alerts
gh search issues --app=dependabot --state=open

# Locked discussions
gh search issues is:locked
```

---

## Limitations of Native GitHub Search

### What GitHub Native Search CANNOT Do

1. **No Regex Support (CLI/API)**
   - Regex only available in web UI for code search
   - CLI and API searches do NOT support regex patterns
   - Cannot use patterns like `Bug.*auth.*failure`

2. **No Wildcards**
   - Cannot use `*` or `?` wildcards
   - Must use exact keywords or phrases

3. **No Context Lines**
   - No equivalent to ripgrep's `-A` (after), `-B` (before), `-C` (context)
   - Search results show only the matching content, not surrounding lines

4. **No Cross-Line Matching**
   - Searches work on preprocessed content
   - Cannot match patterns spanning multiple lines

5. **Repository Limits**
   - Access to 10,000+ repos requires scoping to specific org/user/repo
   - Cannot search globally across all accessible repositories simultaneously

6. **Rate Limits**
   - 30 requests/minute for authenticated searches
   - 10 requests/minute for code search

7. **No Full-Text Download**
   - Cannot download all issues for offline search
   - Must query API for each search

---

## Comparison: GitHub Native Search vs ripgrep

| Feature                | GitHub Native Search                       | ripgrep               |
| ---------------------- | ------------------------------------------ | --------------------- |
| **Search title**       | ✅ `in:title`                              | ✅ (if title in text) |
| **Search body**        | ✅ `in:body`                               | ✅                    |
| **Search comments**    | ✅ `in:comments`                           | ✅ (if downloaded)    |
| **Regex support**      | ❌ (API/CLI), ✅ (Web UI code search only) | ✅ Full PCRE2         |
| **Wildcards**          | ❌                                         | ✅ `*`, `?`           |
| **Context lines**      | ❌                                         | ✅ `-A`, `-B`, `-C`   |
| **Boolean AND/OR**     | ✅ (AND only via multiple flags)           | ✅ Via regex          |
| **Date filters**       | ✅ Extensive                               | ❌ (unless in text)   |
| **Label filters**      | ✅ Native                                  | ❌                    |
| **User filters**       | ✅ Native                                  | ❌                    |
| **State filters**      | ✅ Native                                  | ❌                    |
| **Speed**              | ~850ms (API)                               | ~45ms (local)         |
| **Offline**            | ❌                                         | ✅                    |
| **Multi-word phrases** | ✅ Quoted                                  | ✅                    |
| **Case sensitivity**   | ❌ (case-insensitive)                      | ✅ Configurable       |

**Power Rating:**

- GitHub native search: **8/10** for structured metadata queries
- GitHub native search: **3/10** for pattern matching (no regex in CLI)
- ripgrep: **10/10** for pattern matching
- ripgrep: **0/10** for metadata queries (unless downloaded and structured)

---

## Best Practices for Native GitHub Search

### 1. Use Appropriate Command for Scope

```bash
# Single repository - use gh issue list
gh issue list --search "database error"

# Multiple repositories - use gh search issues
gh search issues "database error" --owner=myorg
```

### 2. Combine Flags with Raw Syntax

```bash
# Mix flags and raw syntax for clarity
gh search issues "authentication" --label=bug --state=open -- -author:bot
```

### 3. Use JSON Output for Scripting

```bash
# Get structured data for processing
gh search issues --label=bug --state=open --json number,title,url --jq '.[] | .url'
```

### 4. Leverage Sorting for Prioritization

```bash
# Most commented issues first
gh search issues --state=open --sort=comments --order=desc --limit=20

# Recently updated
gh search issues --sort=updated --order=desc
```

### 5. Use `@me` for Personal Queries

```bash
# Quick personal dashboard
gh search issues --assignee=@me --state=open
gh search issues --author=@me --state=all
gh search issues --involves=@me
```

### 6. Save Complex Queries as Aliases

```bash
# In ~/.config/gh/config.yml or bash aliases
alias gh-my-issues='gh search issues --assignee=@me --state=open'
alias gh-team-bugs='gh search issues --owner=myorg --label=bug --state=open'
```

---

## Native GitHub CLI Architecture

```
┌─────────────────────────────────────────────────┐
│            GitHub Web Interface                 │
│  (Code Search with regex - web UI only)        │
└─────────────────────────────────────────────────┘
                      ▲
                      │
┌─────────────────────────────────────────────────┐
│              GitHub REST API                    │
│  • Search Issues/PRs                           │
│  • 30 req/min authenticated                    │
│  • No regex support in API                     │
│  • Returns JSON                                │
└─────────────────────────────────────────────────┘
                      ▲
                      │
┌─────────────────────────────────────────────────┐
│            GitHub CLI (gh)                      │
│  • gh search issues                            │
│  • gh issue list --search                      │
│  • Translates flags to API queries            │
│  • Formats output                              │
└─────────────────────────────────────────────────┘
                      ▲
                      │
                  Your Terminal
```

**Key Point:** All CLI searches use the REST API backend, which does NOT support regex. Only the web UI code search supports regex.

---

## Summary and Recommendations

### What GitHub Native Search Excels At

1. **Structured Metadata Queries** ⭐⭐⭐⭐⭐
   - Labels, milestones, assignees, dates
   - Repository scoping
   - State management
   - User involvement

2. **Team Collaboration Searches** ⭐⭐⭐⭐⭐
   - Finding your assignments
   - Team activity
   - Review requests
   - Triage workflows

3. **Time-Based Queries** ⭐⭐⭐⭐⭐
   - Date ranges
   - Recently updated
   - Stale issues

4. **Content Searches** ⭐⭐⭐
   - Keyword matching in title, body, comments
   - Multi-word phrases
   - Field-specific searches (`in:title`, `in:body`)

### What GitHub Native Search Cannot Do

1. **Pattern Matching** ❌
   - No regex in CLI/API
   - No wildcards
   - Limited to exact keyword matches

2. **Context Awareness** ❌
   - No surrounding lines
   - No multi-line patterns

3. **Offline Search** ❌
   - Requires API access
   - Rate limited

### Recommendation for Knowledge Base Use Case

**For your knowledge base on GitHub Issues, native GitHub search is SUFFICIENT if:**

✅ You primarily search by:

- Keywords and exact phrases
- Labels and metadata
- Issue state and dates
- User activity

✅ You can work within these constraints:

- No regex patterns needed
- No complex wildcard searches
- Online-only access acceptable

**Native GitHub search provides 80% of common search needs with excellent metadata integration.**

---

**Documentation Version:** 1.0.0
**Last Updated:** 2025-10-23
**Maintained By:** Terry Li (@terrylica)
