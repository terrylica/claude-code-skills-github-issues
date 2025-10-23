# GitHub Knowledge Base: Comparative Analysis & CLI Integration

**Research Date:** October 2025
**Target Audience:** Engineering leads building team knowledge bases
**Focus:** CLI-first workflows, automation, and native GitHub features

---

## Executive Summary

### Quick Comparison Matrix

| Feature             | GitHub Wiki            | GitHub Discussions                | GitHub Issues                   | GitHub Pages                       |
| ------------------- | ---------------------- | --------------------------------- | ------------------------------- | ---------------------------------- |
| **CLI Support**     | Git only (`.wiki.git`) | Extension only (`gh-discussions`) | Full native (`gh issue`)        | Git + Deploy automation            |
| **Version Control** | Separate repo          | N/A (threaded)                    | Native with repo                | In-repo (`/docs`)                  |
| **Search**          | Basic                  | Category-based                    | Labels + filters                | Site search (depends on generator) |
| **Structure**       | Flat pages             | Threaded discussions              | Issue tracker                   | Hierarchical docs                  |
| **Collaboration**   | Wiki editing           | Q&A + voting                      | Assignments + tracking          | PR review workflow                 |
| **Automation**      | Git hooks              | Limited API                       | Extensive API + templates       | CI/CD deployment                   |
| **Best For**        | Quick internal docs    | Community engagement              | Structured knowledge + tracking | Public documentation               |
| **Recommended?**    | ⚠️ Use `/docs` instead | ✓ For Q&A/community               | ✓✓ For structured KB            | ✓✓ For polished docs               |

**Key Finding:** The optimal knowledge base combines **GitHub Issues** (structured knowledge tracking) + **GitHub Pages** (polished documentation) + **GitHub Discussions** (community Q&A), all accessible via CLI workflows.

---

## 1. GitHub Wiki

### Overview

GitHub Wiki is a Git-backed wiki system (Gollum) that provides simple collaborative editing for project documentation.

### Capabilities

**Content Organization:**

- Flat page structure with manual sidebar organization
- Markdown support with GitHub Flavored Markdown
- Each page is a separate `.md` file
- Basic navigation through sidebar configuration

**CLI/API Support:**

```bash
# Clone wiki repository
git clone https://github.com/USERNAME/REPO.wiki.git

# Standard git workflow
cd REPO.wiki
echo "# New Page" > New-Page.md
git add New-Page.md
git commit -m "Add new documentation page"
git push origin master

# Wikis must have at least one page before cloning
```

**Automation Capabilities:**

- Standard Git hooks for automation
- GitHub Actions can update wikis with `actions/checkout` and `contents: write` permissions
- No native `gh wiki` commands in GitHub CLI
- Requires appending `.wiki.git` to repository URL

### Pros

- Simple setup and quick start
- Collaborative editing in browser or locally
- Git-backed version history
- Zero build process required

### Cons

- **Separate repository from code** - documentation not versioned with codebase
- **Not available when cloning main repo** - requires separate clone
- **Limited CLI integration** - no `gh` command support
- **Can become outdated** - tends to drift from codebase
- **Basic organization** - flat structure doesn't scale well
- **Considered anti-pattern by many developers** - recommendation is to use `/docs` folder instead

### Real-World Patterns

According to research, GitHub Wiki is increasingly seen as an anti-pattern:

- Documentation isn't versioned alongside code
- Documentation isn't available locally when someone clones the repo
- At some point docs will outgrow a single folder

**Expert Recommendation:** "Use /docs folder and GitHub Pages instead to keep docs in sync with code." - michaelheap.com

### CLI Workflow Example

```bash
# Initial setup
git clone https://github.com/yourorg/project.wiki.git wiki
cd wiki

# Edit workflow
vim Home.md
git add Home.md
git commit -m "docs: update home page"
git push

# Automation - sync from main repo docs
git clone https://github.com/yourorg/project.git
cd project
cp -r docs/* ../wiki/
cd ../wiki
git add .
git commit -m "sync: update from main repo"
git push
```

---

## 2. GitHub Discussions

### Overview

GitHub Discussions provides a threaded, asynchronous communication platform directly within repositories for open-ended conversations, Q&A, and community engagement.

### Capabilities

**Content Organization:**

- Category-based organization (Q&A, Announcements, Ideas, etc.)
- Threaded conversations with nested replies
- Upvoting and marking helpful answers
- Labels and emoji reactions
- Pinned discussions for important topics

**CLI/API Support:**

```bash
# Enable discussions (gh v2.22.0+)
gh repo edit --enable-discussions

# Third-party extension required for management
gh extension install antgrutta/gh-discussions

# With extension installed
gh discussions list
gh discussions create --title "Topic" --body "Content"
gh discussions view <number>

# GraphQL API example
gh api graphql -f query='
  query($owner: String!, $repo: String!) {
    repository(owner: $owner, name: $repo) {
      discussions(first: 10) {
        nodes {
          title
          url
          author { login }
        }
      }
    }
  }' -f owner=OWNER -f repo=REPO
```

**Automation Capabilities:**

- GitHub Actions for automated discussion creation
- GraphQL API for programmatic access
- Third-party extension `gh-discussions` for CLI management
- Can import discussions from CSV files
- Webhook events for CI/CD integration

### Pros

- **Native to repository** - lives where your community is
- **Reduces context switching** - no external forum needed
- **Asynchronous by design** - better for distributed teams
- **Historical knowledge** - saves FAQs and discussions
- **Upvoting system** - community can highlight best answers
- **Easy transition to issues** - move conversations to tracked work
- **Big picture thinking** - brainstorm before committing to implementation

### Cons

- **No native CLI support** - requires third-party extensions
- **Topic duplication risk** - overlap between discussions and issues
- **Not structured documentation** - better for conversations than reference
- **Maintainer burden** - community expects responses
- **Limited automation** - fewer scripting options than issues
- **Search limitations** - harder to find specific technical details

### Real-World Patterns

Best used for:

- Community Q&A and support
- Feature brainstorming and feedback
- Announcements and updates
- "Pre-issue" discussions to scope work
- Building institutional knowledge through conversation

According to GitHub research: "Developers face the problem of topic duplication between Discussions and Issues, and maintainers working on open source voluntarily feel the demand for answering questions constantly."

### CLI Workflow Example

```bash
# Setup third-party extension
gh extension install antgrutta/gh-discussions

# Create discussion from CLI
gh discussions create \
  --category "Q&A" \
  --title "How to configure X feature?" \
  --body "$(cat question.md)"

# List recent discussions
gh discussions list --limit 20

# Automation: Create discussion when issue is labeled "needs-discussion"
# .github/workflows/discussion-automation.yml
# on:
#   issues:
#     types: [labeled]
# jobs:
#   create-discussion:
#     if: github.event.label.name == 'needs-discussion'
#     runs-on: ubuntu-latest
#     steps:
#       - uses: actions/checkout@v4
#       - run: gh extension install antgrutta/gh-discussions
#       - run: |
#           gh discussions create \
#             --category "Ideas" \
#             --title "${{ github.event.issue.title }}" \
#             --body "From issue #${{ github.event.issue.number }}"
```

---

## 3. GitHub Issues

### Overview

GitHub Issues is a full-featured tracking system that doubles as an excellent structured knowledge base with extensive CLI support, automation, and organization features.

### Capabilities

**Content Organization:**

- Labels for categorization (documentation, how-to, FAQ, etc.)
- Milestones for grouping related topics
- Projects for kanban-style organization
- Assignees for ownership
- Issue templates for consistency
- Cross-referencing with `#number` syntax
- Saved searches for quick access

**CLI/API Support:**

```bash
# Native gh CLI commands - extensive support
gh issue create --title "Title" --body "Content" --label "documentation"
gh issue list --label "documentation" --state "all"
gh issue view <number>
gh issue edit <number> --add-label "reviewed"
gh issue close <number>

# Template-based creation
gh issue create --template knowledge-base.md

# JSON output for scripting
gh issue list --json number,title,labels --jq '.[] | select(.labels[].name == "documentation")'

# Batch operations
gh issue list --label "needs-review" --json number | \
  jq -r '.[].number' | \
  xargs -I {} gh issue edit {} --add-label "reviewed"
```

**Automation Capabilities:**

- Issue templates with YAML frontmatter
- Automatic label assignment
- GitHub Actions integration
- GraphQL API for complex queries
- Webhooks for external integrations
- GitHub Projects automation
- Extensive filtering and search

### Pros

- **Best CLI support** - native `gh issue` commands
- **Highly automatable** - templates, actions, API
- **Structured tracking** - status, labels, assignments
- **Version controlled** - tied to repository
- **Powerful search** - labels, filters, saved searches
- **Cross-referencing** - link issues, PRs, commits
- **Notification system** - mentions and subscriptions
- **JSON output** - perfect for scripting
- **Integration ecosystem** - works with projects, actions, etc.

### Cons

- **Issue tracker UI** - not traditional documentation interface
- **Can feel "bug-focused"** - mental model mismatch
- **Flat structure** - no hierarchical organization
- **Open by default** - need to close knowledge items
- **Mixed content** - documentation among bugs/features
- **Requires labeling discipline** - needs consistent taxonomy

### Real-World Patterns

Using Issues as a knowledge base:

- Create issue templates for different knowledge types
- Use labels: `documentation`, `how-to`, `FAQ`, `architecture`, `decision-record`
- Pin critical issues for visibility
- Close issues once knowledge is transferred to formal docs
- Use projects to organize by domain/team
- Link issues to code with commit references

GitHub's own best practice: "Create a CONTRIBUTING.md file that defines the process and expectations for interacting with the repository."

### CLI Workflow Example

```bash
# Create issue template
mkdir -p .github/ISSUE_TEMPLATE
cat > .github/ISSUE_TEMPLATE/knowledge-base.yml <<EOF
name: Knowledge Base Entry
description: Document technical knowledge or decisions
title: "[KB] "
labels: ["documentation", "knowledge-base"]
body:
  - type: markdown
    attributes:
      value: "## Knowledge Base Entry"
  - type: input
    id: topic
    attributes:
      label: Topic
      description: What is this knowledge about?
    validations:
      required: true
  - type: textarea
    id: content
    attributes:
      label: Content
      description: Detailed information
    validations:
      required: true
EOF

# Use template
gh issue create --template knowledge-base.yml

# Query knowledge base
gh issue list --label "knowledge-base" --state "all" --json number,title,url

# Create knowledge base index
gh issue list --label "knowledge-base" --state "all" --json number,title,labels | \
  jq -r '.[] | "- [#\(.number)] \(.title)"' > KB-INDEX.md

# Automation: Convert closed issues to documentation
gh issue list --label "knowledge-base" --state "closed" --json number,title,body | \
  jq -r '.[] | "# \(.title)\n\n\(.body)\n\n---\n"' > docs/knowledge-base.md

# Search knowledge base
gh issue list --search "authentication in:title,body" --label "knowledge-base"
```

---

## 4. GitHub Pages

### Overview

GitHub Pages provides free static site hosting with CI/CD deployment, perfect for polished, professional documentation that's versioned with your codebase.

### Capabilities

**Content Organization:**

- Hierarchical folder structure
- Navigation menus and sidebars
- Full-text search (with plugins)
- Custom themes and branding
- Markdown + HTML support
- Multi-page documentation sites

**CLI/API Support:**

```bash
# Setup with Jekyll (GitHub's native support)
mkdir docs
cd docs
cat > _config.yml <<EOF
theme: jekyll-theme-minimal
title: Project Knowledge Base
description: Engineering team documentation
EOF

# Standard git workflow
git add docs/
git commit -m "docs: initialize GitHub Pages"
git push

# Enable via gh CLI
gh repo edit --enable-pages --pages-branch main --pages-path /docs

# Alternative: MkDocs (requires custom GitHub Actions)
pip install mkdocs mkdocs-material
mkdocs new .
mkdocs build
mkdocs gh-deploy  # Deploys to gh-pages branch

# GitHub Actions deployment
cat > .github/workflows/pages.yml <<EOF
name: Deploy Pages
on:
  push:
    branches: [main]
    paths: ['docs/**']
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v4
        with:
          python-version: 3.x
      - run: pip install mkdocs-material
      - run: mkdocs gh-deploy --force
EOF
```

**Automation Capabilities:**

- GitHub Actions for automated builds
- Custom deployment workflows
- Preview deployments for PRs
- Scheduled rebuilds
- Integration with static site generators
- Custom domains with HTTPS

### Pros

- **Versioned with code** - documentation in `/docs` folder
- **Available locally** - clone repo, get docs
- **Professional appearance** - themes and customization
- **Full-text search** - with proper plugins
- **Custom domains** - brand your documentation
- **Free hosting** - no infrastructure costs
- **CI/CD integration** - automated deployments
- **Multiple generator support** - Jekyll, MkDocs, Hugo, etc.
- **PR review process** - docs reviewed like code

### Cons

- **Build complexity** - requires static site generator
- **Setup overhead** - more initial configuration
- **Technical knowledge** - need to understand generators
- **Build times** - large sites can be slow
- **Static only** - no dynamic content
- **Separate build step** - not instant like wiki

### Real-World Patterns

**Jekyll (Native GitHub Support):**

- Zero-config deployment from `/docs` folder
- Theme system for quick setup
- Liquid templating for customization
- Built-in blogging features

**MkDocs (Python-based, documentation-focused):**

- Designed specifically for documentation
- Hierarchical navigation auto-generation
- Material theme is industry standard
- Requires custom GitHub Actions
- Python ecosystem familiar to data/ML teams

**Best Practice:** "Use the /docs folder with GitHub Pages for the highest effort-to-reward ratio while building out a new product, as documentation is versioned alongside your code."

### CLI Workflow Example

```bash
# Jekyll workflow
cd project
mkdir -p docs
cd docs

# Initialize Jekyll site
cat > _config.yml <<'EOF'
title: Engineering Knowledge Base
description: Team documentation and best practices
theme: jekyll-theme-cayman
markdown: kramdown
highlighter: rouge
EOF

# Create home page
cat > index.md <<'EOF'
---
layout: default
title: Home
---

# Engineering Knowledge Base

## Quick Links
- [Architecture](architecture.md)
- [Onboarding](onboarding.md)
- [Deployment Guide](deployment.md)
EOF

# Enable Pages
gh repo edit --enable-pages --pages-branch main --pages-path /docs

# Standard commit workflow
git add docs/
git commit -m "docs: add knowledge base"
git push

# Local preview
cd docs
bundle exec jekyll serve --livereload
# Visit http://localhost:4000

# MkDocs alternative
pip install mkdocs-material
mkdocs new .
cat > mkdocs.yml <<'EOF'
site_name: Engineering Knowledge Base
theme:
  name: material
  features:
    - navigation.tabs
    - navigation.sections
    - toc.integrate
    - search.suggest
nav:
  - Home: index.md
  - Architecture: architecture.md
  - Guides:
    - Onboarding: guides/onboarding.md
    - Deployment: guides/deployment.md
EOF

# Deploy to GitHub Pages
mkdocs gh-deploy

# Automation: Build on every push to docs/
# .github/workflows/docs.yml
cat > .github/workflows/docs.yml <<'EOF'
name: Documentation
on:
  push:
    branches: [main]
    paths: ['docs/**', 'mkdocs.yml']
  pull_request:
    paths: ['docs/**', 'mkdocs.yml']
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v4
        with:
          python-version: '3.12'
      - run: pip install mkdocs-material
      - run: mkdocs build --strict
      - name: Deploy
        if: github.event_name == 'push'
        run: mkdocs gh-deploy --force
EOF
```

---

## 5. CLI Capabilities Deep Dive

### GitHub CLI (`gh`) Core Features

**Installation & Authentication:**

```bash
# Install (macOS)
brew install gh

# Authenticate
gh auth login

# Check status
gh auth status
```

**Available Commands:**

```bash
gh issue      # Full support ✓✓
gh pr         # Full support ✓✓
gh repo       # Full support ✓✓
gh release    # Full support ✓✓
gh workflow   # Full support ✓✓
gh run        # Full support ✓✓
gh api        # GraphQL/REST API access ✓✓

# Limited/Extension Required
gh discussion # Extension: gh-discussions
gh wiki       # Not available (use git)
```

### GraphQL API Access

**Direct API Queries:**

```bash
# Query with gh api
gh api graphql -f query='
  query {
    viewer {
      login
      repositories(first: 5) {
        nodes {
          name
          description
        }
      }
    }
  }'

# Paginated queries
gh api graphql --paginate -f query='...'

# Variables
gh api graphql -f query='...' -f owner=OWNER -f repo=REPO
```

**Knowledge Base Automation Examples:**

```bash
# Get all documentation issues
gh api graphql -f query='
  query($owner: String!, $repo: String!) {
    repository(owner: $owner, name: $repo) {
      issues(
        first: 100
        labels: ["documentation"]
        states: OPEN
      ) {
        nodes {
          number
          title
          body
          url
          labels(first: 10) {
            nodes { name }
          }
        }
      }
    }
  }' -f owner=yourorg -f repo=yourrepo | \
  jq -r '.data.repository.issues.nodes[] | "[\(.number)] \(.title): \(.url)"'

# Get discussion topics
gh api graphql -f query='
  query($owner: String!, $repo: String!) {
    repository(owner: $owner, name: $repo) {
      discussions(first: 20, orderBy: {field: CREATED_AT, direction: DESC}) {
        nodes {
          title
          url
          author { login }
          category { name }
          answerChosenAt
        }
      }
    }
  }' -f owner=yourorg -f repo=yourrepo
```

### GitHub CLI Extensions

**Installing Extensions:**

```bash
# Install discussions extension
gh extension install antgrutta/gh-discussions

# List installed extensions
gh extension list

# Search for extensions
gh extension search wiki
gh extension search documentation
```

**Available Knowledge Base Extensions:**

- `gh-discussions` - Manage GitHub Discussions from CLI
- `gh-project` - Manage GitHub Projects

### Scripting & Automation Patterns

**Batch Operations:**

```bash
# Add label to all documentation issues
gh issue list --label "documentation" --json number | \
  jq -r '.[].number' | \
  xargs -I {} gh issue edit {} --add-label "reviewed"

# Create issues from CSV
while IFS=, read -r title body; do
  gh issue create --title "$title" --body "$body" --label "knowledge-base"
done < knowledge-items.csv

# Weekly documentation report
gh issue list --label "documentation" \
  --search "created:>=$(date -v-7d +%Y-%m-%d)" \
  --json number,title,createdAt | \
  jq -r '.[] | "- #\(.number): \(.title) (\(.createdAt))"'
```

**GitHub Actions Integration:**

```yaml
# .github/workflows/knowledge-base-automation.yml
name: Knowledge Base Automation

on:
  issues:
    types: [closed]
  schedule:
    - cron: "0 0 * * 0" # Weekly

jobs:
  generate-index:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Generate KB Index
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          cat > docs/KB-INDEX.md <<EOF
          # Knowledge Base Index

          Generated: $(date)

          ## Documentation Issues
          EOF

          gh issue list --label "knowledge-base" --state "all" \
            --json number,title,labels,url | \
            jq -r '.[] | "- [#\(.number)] \(.title) - \(.url)"' \
            >> docs/KB-INDEX.md

      - name: Commit index
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add docs/KB-INDEX.md
          git commit -m "docs: update KB index [skip ci]" || exit 0
          git push
```

### Advanced CLI Workflows

**Knowledge Base Search:**

```bash
# Search across all KB sources
kb_search() {
  local query="$1"
  echo "=== Issues ==="
  gh issue list --search "in:title,body $query" --label "knowledge-base"

  echo -e "\n=== Discussions ==="
  gh api graphql -f query="
    query(\$q: String!) {
      search(query: \$q, type: DISCUSSION, first: 10) {
        nodes {
          ... on Discussion {
            title
            url
          }
        }
      }
    }" -f q="repo:$(gh repo view --json nameWithOwner -q .nameWithOwner) $query"

  echo -e "\n=== Documentation ==="
  gh repo view --web docs/
}

# Usage
kb_search "authentication"
```

**Automated Knowledge Migration:**

```bash
# Migrate closed KB issues to docs
migrate_to_docs() {
  gh issue list --label "knowledge-base,ready-for-docs" --state "closed" \
    --json number,title,body | \
  jq -c '.[]' | \
  while read -r issue; do
    number=$(echo "$issue" | jq -r '.number')
    title=$(echo "$issue" | jq -r '.title')
    body=$(echo "$issue" | jq -r '.body')

    filename="docs/kb-$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-').md"

    cat > "$filename" <<EOF
# $title

Source: Issue #$number

$body

---
*Migrated from #$number*
EOF

    gh issue comment "$number" -b "Migrated to documentation: $filename"
    gh issue edit "$number" --remove-label "ready-for-docs" --add-label "documented"
  done
}
```

---

## Comparative Analysis Summary

### Strengths & Weaknesses

#### GitHub Wiki

**Strengths:**

- Fastest to set up
- No build process
- Browser-based editing for non-technical users
- Git-backed versioning

**Weaknesses:**

- Separate repository (not versioned with code)
- Limited CLI support (git only)
- Flat structure doesn't scale
- Considered anti-pattern by many developers

**Use Case:** Quick internal project documentation when team prefers browser editing and version control alignment isn't critical.

#### GitHub Discussions

**Strengths:**

- Native community engagement
- Q&A with voting
- Converts to issues when ready
- Historical knowledge capture

**Weaknesses:**

- No native CLI support
- Not structured documentation
- Requires third-party extensions
- Can create maintainer burden

**Use Case:** Community Q&A, feature discussions, support forums, pre-issue brainstorming.

#### GitHub Issues

**Strengths:**

- Best CLI support (`gh issue`)
- Highly automatable (templates, actions, API)
- Structured tracking with labels/milestones
- JSON output for scripting
- Cross-referencing with commits/PRs

**Weaknesses:**

- Issue tracker UI (not documentation feel)
- Flat structure
- Mixed with bugs/features
- Requires labeling discipline

**Use Case:** Structured knowledge tracking, technical decisions, architecture documentation, team-internal knowledge.

#### GitHub Pages

**Strengths:**

- Professional appearance
- Versioned with codebase (in `/docs`)
- Full-text search
- CI/CD integration
- Available locally with clone

**Weaknesses:**

- Setup complexity
- Build process required
- Technical knowledge needed
- Not instant updates

**Use Case:** Polished public documentation, user guides, API references, team handbooks.

---

## Best Practices & Recommendations

### 1. Combined Approach (Recommended)

**Use all three primary modules together:**

```
GitHub Issues → Structured Knowledge Tracking
    ↓ (migrate when polished)
GitHub Pages → Formal Documentation
    ↓ (questions/discussion)
GitHub Discussions → Community Q&A
```

**Workflow:**

1. Capture knowledge in **Issues** with `knowledge-base` label
2. Track and organize with labels, projects, assignments
3. When knowledge is refined, migrate to **Pages** documentation
4. Use **Discussions** for community questions that reference docs
5. Update docs based on common discussion themes

### 2. Label Taxonomy for Issues

```bash
# Documentation types
knowledge-base      # All KB entries
how-to             # Step-by-step guides
architecture       # System design decisions
decision-record    # ADRs
troubleshooting    # Problem/solution pairs
FAQ                # Frequently asked questions
onboarding         # New team member resources

# Status
needs-review       # Waiting for validation
ready-for-docs     # Ready to migrate to Pages
documented         # Migrated to formal docs
```

### 3. CLI-First Workflow

**Daily workflow:**

```bash
# Morning: Check what needs attention
gh issue list --label "knowledge-base,needs-review" --assignee @me

# Create knowledge entry
gh issue create \
  --template knowledge-base.yml \
  --title "[KB] How to deploy to production" \
  --label "knowledge-base,how-to"

# Search knowledge base
gh issue list --search "deploy in:title,body" --label "knowledge-base"

# Generate index weekly
gh issue list --label "knowledge-base" --state "all" \
  --json number,title,labels,url | \
  jq -r '.[] | "- [#\(.number)] \(.title) - \(.url)"' > KB-INDEX.md
```

### 4. Issue Templates

**Create templates in `.github/ISSUE_TEMPLATE/`:**

```yaml
# .github/ISSUE_TEMPLATE/knowledge-base.yml
name: Knowledge Base Entry
description: Document technical knowledge or decisions
title: "[KB] "
labels: ["knowledge-base"]
body:
  - type: markdown
    attributes:
      value: |
        ## Knowledge Base Entry
        Document important technical knowledge, decisions, or procedures.

  - type: dropdown
    id: kb-type
    attributes:
      label: Type
      options:
        - How-to Guide
        - Architecture Decision
        - Troubleshooting
        - FAQ
        - Onboarding
    validations:
      required: true

  - type: input
    id: topic
    attributes:
      label: Topic/Title
      description: Short description of what this knowledge covers
    validations:
      required: true

  - type: textarea
    id: content
    attributes:
      label: Content
      description: Detailed knowledge, steps, or explanation
    validations:
      required: true

  - type: textarea
    id: related
    attributes:
      label: Related Issues/PRs
      description: Links to related issues, PRs, or documentation
```

### 5. Automation Workflows

**Auto-label from commit messages:**

```yaml
# .github/workflows/auto-label-kb.yml
name: Auto-label KB Issues

on:
  issues:
    types: [opened]

jobs:
  label:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/github-script@v7
        with:
          script: |
            const title = context.payload.issue.title.toLowerCase();
            const labels = [];

            if (title.includes('[kb]')) labels.push('knowledge-base');
            if (title.includes('how to')) labels.push('how-to');
            if (title.includes('adr') || title.includes('decision')) labels.push('decision-record');
            if (title.includes('troubleshoot')) labels.push('troubleshooting');

            if (labels.length > 0) {
              await github.rest.issues.addLabels({
                owner: context.repo.owner,
                repo: context.repo.repo,
                issue_number: context.issue.number,
                labels: labels
              });
            }
```

**Weekly KB digest:**

```yaml
# .github/workflows/kb-digest.yml
name: Weekly KB Digest

on:
  schedule:
    - cron: "0 9 * * 1" # Monday 9 AM
  workflow_dispatch:

jobs:
  digest:
    runs-on: ubuntu-latest
    steps:
      - name: Generate digest
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          LAST_WEEK=$(date -d '7 days ago' +%Y-%m-%d)

          cat > digest.md <<EOF
          # Knowledge Base Digest - Week of $(date +%Y-%m-%d)

          ## New Knowledge Entries
          EOF

          gh issue list --label "knowledge-base" \
            --search "created:>=$LAST_WEEK" \
            --json number,title,url | \
            jq -r '.[] | "- [#\(.number)] \(.title) - \(.url)"' >> digest.md

          cat >> digest.md <<EOF

          ## Recently Updated
          EOF

          gh issue list --label "knowledge-base" \
            --search "updated:>=$LAST_WEEK" \
            --json number,title,url | \
            jq -r '.[] | "- [#\(.number)] \(.title) - \(.url)"' >> digest.md

          # Post to discussions
          gh api graphql -f query='...' -f body="$(cat digest.md)"
```

### 6. Search & Discovery

**Create search aliases:**

```bash
# Add to ~/.bashrc or ~/.zshrc
alias kb-search='gh issue list --search "in:title,body" --label "knowledge-base"'
alias kb-list='gh issue list --label "knowledge-base" --state "all"'
alias kb-recent='gh issue list --label "knowledge-base" --limit 10'

# Advanced search function
kb() {
  case "$1" in
    search)
      shift
      gh issue list --search "in:title,body $*" --label "knowledge-base"
      ;;
    create)
      gh issue create --template knowledge-base.yml
      ;;
    index)
      gh issue list --label "knowledge-base" --state "all" \
        --json number,title,labels | \
        jq -r 'group_by(.labels[].name) |
          map({type: .[0].labels[].name, issues: map("#\(.number): \(.title)")}) |
          .[]'
      ;;
    *)
      echo "Usage: kb {search|create|index}"
      ;;
  esac
}
```

### 7. Migration Strategy

**From Issues to Pages:**

```bash
#!/bin/bash
# migrate-kb-to-docs.sh

# Get all issues labeled "ready-for-docs"
gh issue list --label "knowledge-base,ready-for-docs" --state "closed" \
  --json number,title,body,labels | \
  jq -c '.[]' | \
while read -r issue; do
  number=$(echo "$issue" | jq -r '.number')
  title=$(echo "$issue" | jq -r '.title')
  body=$(echo "$issue" | jq -r '.body')

  # Extract KB type from labels
  kb_type=$(echo "$issue" | jq -r '.labels[] | select(.name | startswith("kb-")) | .name' | sed 's/kb-//')

  # Create directory structure
  mkdir -p "docs/${kb_type:-general}"

  # Generate filename
  filename="docs/${kb_type:-general}/$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-').md"

  # Write documentation file
  cat > "$filename" <<EOF
---
title: $title
source: Issue #$number
date: $(date +%Y-%m-%d)
---

# $title

$body

---

*This documentation was migrated from [#$number](https://github.com/\$(gh repo view --json nameWithOwner -q .nameWithOwner)/issues/$number)*
EOF

  # Update issue
  gh issue comment "$number" -b "📚 Migrated to documentation: \`$filename\`"
  gh issue edit "$number" --remove-label "ready-for-docs" --add-label "documented"

  echo "Migrated #$number to $filename"
done

# Commit changes
git add docs/
git commit -m "docs: migrate KB entries from issues"
git push
```

---

## Implementation Roadmap

### Phase 1: Foundation (Week 1)

**Day 1-2: Setup GitHub Issues as KB**

```bash
# 1. Create issue templates
mkdir -p .github/ISSUE_TEMPLATE

# 2. Create knowledge-base.yml template (see example above)

# 3. Create label taxonomy
gh label create "knowledge-base" --color "0E8A16" --description "Knowledge base entries"
gh label create "how-to" --color "1D76DB" --description "Step-by-step guides"
gh label create "architecture" --color "5319E7" --description "System design and architecture"
gh label create "decision-record" --color "B60205" --description "Architecture decision records"
gh label create "troubleshooting" --color "D93F0B" --description "Problem-solution pairs"
gh label create "FAQ" --color "FBCA04" --description "Frequently asked questions"
gh label create "needs-review" --color "FBCA04" --description "Needs validation"
gh label create "ready-for-docs" --color "C2E0C6" --description "Ready to migrate to Pages"
gh label create "documented" --color "0E8A16" --description "Migrated to formal docs"

# 4. Create first KB issue
gh issue create --template knowledge-base.yml
```

**Day 3-4: Setup GitHub Pages**

```bash
# 1. Choose generator (MkDocs recommended for engineering teams)
pip install mkdocs-material

# 2. Initialize
mkdocs new .
mv mkdocs.yml docs/

# 3. Configure mkdocs.yml
cat > mkdocs.yml <<'EOF'
site_name: Engineering Knowledge Base
site_description: Team documentation and knowledge sharing
repo_url: https://github.com/yourorg/yourrepo

theme:
  name: material
  features:
    - navigation.tabs
    - navigation.sections
    - navigation.expand
    - toc.integrate
    - search.suggest
    - search.highlight
  palette:
    - scheme: default
      primary: indigo
      accent: indigo
      toggle:
        icon: material/brightness-7
        name: Switch to dark mode
    - scheme: slate
      primary: indigo
      accent: indigo
      toggle:
        icon: material/brightness-4
        name: Switch to light mode

nav:
  - Home: index.md
  - How-To Guides: how-to/
  - Architecture: architecture/
  - Troubleshooting: troubleshooting/
  - FAQ: faq.md

plugins:
  - search
  - tags

markdown_extensions:
  - admonition
  - pymdownx.details
  - pymdownx.superfences
  - pymdownx.tabbed
  - pymdownx.highlight
  - pymdownx.inlinehilite
  - toc:
      permalink: true
EOF

# 4. Deploy
mkdocs gh-deploy
```

**Day 5: Setup GitHub Discussions**

```bash
# 1. Enable discussions
gh repo edit --enable-discussions

# 2. Install CLI extension
gh extension install antgrutta/gh-discussions

# 3. Create initial categories (via web UI)
# - Q&A (for questions)
# - Show and Tell (for demos)
# - Ideas (for feature requests)
# - Announcements (for updates)
```

### Phase 2: Automation (Week 2)

**Day 1-3: Create GitHub Actions Workflows**

1. **Auto-label workflow** (see example above)
2. **KB digest workflow** (see example above)
3. **Docs deployment workflow**:

```yaml
# .github/workflows/docs.yml
name: Documentation

on:
  push:
    branches: [main]
    paths:
      - "docs/**"
      - "mkdocs.yml"
  pull_request:
    paths:
      - "docs/**"
      - "mkdocs.yml"

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - uses: actions/setup-python@v4
        with:
          python-version: "3.12"

      - name: Install dependencies
        run: |
          pip install mkdocs-material
          pip install mkdocs-git-revision-date-localized-plugin

      - name: Build docs
        run: mkdocs build --strict

      - name: Deploy to GitHub Pages
        if: github.event_name == 'push' && github.ref == 'refs/heads/main'
        run: mkdocs gh-deploy --force
```

**Day 4-5: Create CLI Utilities**

Save this as `~/.local/bin/kb`:

```bash
#!/bin/bash
# Knowledge Base CLI utility

set -euo pipefail

KB_LABEL="knowledge-base"

cmd_search() {
  local query="$*"
  echo "Searching knowledge base for: $query"
  gh issue list --search "in:title,body $query" --label "$KB_LABEL" --state "all"
}

cmd_create() {
  gh issue create --template knowledge-base.yml
}

cmd_list() {
  local filter="${1:-all}"
  case "$filter" in
    recent)
      gh issue list --label "$KB_LABEL" --limit 20
      ;;
    open)
      gh issue list --label "$KB_LABEL" --state "open"
      ;;
    *)
      gh issue list --label "$KB_LABEL" --state "all"
      ;;
  esac
}

cmd_view() {
  local number="$1"
  gh issue view "$number"
}

cmd_index() {
  echo "# Knowledge Base Index"
  echo ""
  echo "Generated: $(date)"
  echo ""

  # Group by labels
  for label in "how-to" "architecture" "troubleshooting" "FAQ"; do
    echo "## $(echo $label | tr '[:lower:]' '[:upper:]')"
    gh issue list --label "$KB_LABEL,$label" --state "all" \
      --json number,title,url | \
      jq -r '.[] | "- [#\(.number)] \(.title) - \(.url)"'
    echo ""
  done
}

cmd_migrate() {
  # Run migration script
  echo "Migrating ready KB entries to documentation..."
  bash "$(dirname "$0")/migrate-kb-to-docs.sh"
}

cmd_help() {
  cat <<EOF
Knowledge Base CLI

Usage: kb <command> [args]

Commands:
  search <query>    Search knowledge base
  create           Create new KB entry
  list [filter]    List entries (recent|open|all)
  view <number>    View specific entry
  index            Generate KB index
  migrate          Migrate ready entries to docs
  help             Show this help

Examples:
  kb search authentication
  kb list recent
  kb view 123
  kb index > KB-INDEX.md
EOF
}

# Main command router
case "${1:-help}" in
  search) shift; cmd_search "$@" ;;
  create) cmd_create ;;
  list) shift; cmd_list "$@" ;;
  view) shift; cmd_view "$@" ;;
  index) cmd_index ;;
  migrate) cmd_migrate ;;
  help|--help|-h) cmd_help ;;
  *) echo "Unknown command: $1"; cmd_help; exit 1 ;;
esac
```

Make executable:

```bash
chmod +x ~/.local/bin/kb
```

### Phase 3: Content Migration (Week 3-4)

**Week 3: Capture Existing Knowledge**

1. Audit existing documentation (wikis, Confluence, Google Docs)
2. Create issues for each knowledge item
3. Prioritize and assign owners
4. Begin review process

**Week 4: Polish & Publish**

1. Review and update KB issues
2. Migrate polished content to GitHub Pages
3. Set up weekly digest
4. Train team on workflow

### Phase 4: Adoption & Iteration (Ongoing)

**Metrics to Track:**

```bash
# Weekly stats
echo "## KB Statistics for $(date +%Y-%m-%d)"
echo ""
echo "Total KB Issues: $(gh issue list --label knowledge-base --state all --json number | jq '. | length')"
echo "Open KB Issues: $(gh issue list --label knowledge-base --state open --json number | jq '. | length')"
echo "This Week: $(gh issue list --label knowledge-base --search "created:>=$(date -v-7d +%Y-%m-%d)" --json number | jq '. | length')"
echo ""
echo "By Type:"
for label in "how-to" "architecture" "troubleshooting" "FAQ"; do
  count=$(gh issue list --label "knowledge-base,$label" --state all --json number | jq '. | length')
  echo "  $label: $count"
done
```

**Iteration Points:**

- Review label taxonomy monthly
- Adjust issue templates based on usage
- Optimize search workflows
- Gather team feedback
- Update documentation as patterns emerge

---

## Conclusion & Final Recommendations

### For Engineering Leads Creating Team Knowledge Bases

**Recommended Stack:**

1. **GitHub Issues** - Primary knowledge capture and tracking
2. **GitHub Pages** (MkDocs) - Polished documentation
3. **GitHub Discussions** - Community Q&A and brainstorming
4. **GitHub CLI** - Automation and scripting

**Why This Combination Works:**

✅ **CLI-First**: Full `gh` CLI support for Issues, API access for everything
✅ **Version Controlled**: Documentation lives in `/docs` with code
✅ **Automatable**: GitHub Actions + gh CLI = powerful workflows
✅ **Scalable**: Issues for capture, Pages for polish, Discussions for community
✅ **Free**: No external tools or hosting costs
✅ **Integrated**: One platform, one authentication, one workflow

### Key Success Factors

1. **Start with Issues** - Lowest friction for knowledge capture
2. **Use templates and labels** - Consistency and organization
3. **Automate everything** - GitHub Actions + gh CLI scripts
4. **Progressive disclosure** - Issues → Pages migration path
5. **CLI workflows** - Engineer-friendly, scriptable, fast

### Anti-Patterns to Avoid

❌ **Don't use Wiki** - Separate repo, poor CLI support, consider anti-pattern
❌ **Don't over-engineer** - Start simple, add complexity as needed
❌ **Don't skip templates** - Consistency saves time long-term
❌ **Don't ignore automation** - Manual processes don't scale
❌ **Don't mix contexts** - Keep KB issues separate with clear labels

### Next Steps

1. **Week 1**: Set up Issue templates and labels
2. **Week 2**: Initialize GitHub Pages with MkDocs
3. **Week 3**: Create automation workflows
4. **Week 4**: Build CLI utilities and train team
5. **Ongoing**: Iterate based on usage patterns

---

## Appendix: Additional Resources

### GitHub Documentation

- [GitHub CLI Manual](https://cli.github.com/manual/)
- [GitHub Issues Documentation](https://docs.github.com/issues)
- [GitHub Discussions](https://docs.github.com/discussions)
- [GitHub Pages](https://docs.github.com/pages)
- [GitHub Actions](https://docs.github.com/actions)

### CLI Extensions

- [gh-discussions](https://github.com/antgrutta/gh-discussions)
- [gh CLI extensions list](https://github.com/topics/gh-extension)

### Static Site Generators

- [MkDocs Material](https://squidfunk.github.io/mkdocs-material/)
- [Jekyll](https://jekyllrb.com/)
- [Hugo](https://gohugo.io/)

### Community Examples

- [18F Development Guide](https://github.com/18F/development-guide)
- [Kubernetes Documentation](https://github.com/kubernetes/website)
- [Python Developer's Guide](https://github.com/python/devguide)

---

**Document Version:** 1.0.0
**Last Updated:** October 2025
**Maintained by:** Engineering Leadership Team
