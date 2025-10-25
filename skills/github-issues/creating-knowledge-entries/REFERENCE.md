# Creating Knowledge Entries - Complete Reference

Detailed automation pipeline, templates, and examples for one-shot knowledge capture.

## Automatic Processing Pipeline

### 1. Type Detection

Analyze content for keywords to determine entry type:

**Tip:**
- Keywords: "useful", "tip", "trick", "quick", "FYI", "note"
- Indicators: Short (< 500 chars), actionable advice
- Default choice if ambiguous

**How-To:**
- Keywords: "how to", "steps", "first", "then", numbered list
- Indicators: Sequential instructions, procedural
- Structure: Problem → Solution steps

**Troubleshooting:**
- Keywords: "error", "fix", "solved", "problem", "issue", "failed"
- Indicators: Error messages, solutions
- Structure: Problem → Solution → Root Cause

**Reference:**
- Keywords: "documentation", "complete", "reference", "guide"
- Indicators: Long content (> 1000 chars), comprehensive
- Structure: Multiple sections, detailed

**Example:**
- Keywords: "example", "here's how", code blocks
- Indicators: Contains code, demonstrates concept
- Structure: Example → Explanation

**Question:**
- Keywords: "?", "how do I", "why does", "anyone know"
- Indicators: Interrogative, seeking answer
- Structure: Clear question format

### 2. Title Extraction (AI-Powered)

Use gh-models for intelligent title generation:

```bash
CONTENT="[user's pasted content]"

TITLE=$(gh models run "openai/gpt-4.1" \
  "Extract a clear, searchable title (60 chars max) from this content.
   Format: 'Context: Specific Action or Topic'
   Examples:
   - 'Git: Reset to Remote State'
   - 'Claude Code: Using Plan Mode Effectively'
   - 'Terminal: Persistent tmux Sessions'

   Content: $CONTENT")
```

Fallback rules if gh-models unavailable:
- Use first sentence if clear and < 80 chars
- Extract from markdown `# Header` if present
- Generate from main topic + action verb
- Prefix with detected context (Git, Claude Code, Terminal, etc.)

### 3. Content Formatting

Apply structure based on detected type:

#### Tip Template

```markdown
# {Title}

## What It Does
{Extracted main concept - 1-2 sentences}

## When to Use It
{Extracted use case - 1-2 sentences}

## How to Use
{Extracted steps or commands}

{Code blocks if detected}

{Additional notes if any}
```

#### How-To Template

```markdown
# {Title}

## Problem
{What this solves}

## Prerequisites
{Requirements if mentioned}

## Steps

1. {Step 1}
2. {Step 2}
3. {Step 3}

## Expected Outcome
{What success looks like}

## Common Issues
{Troubleshooting if mentioned}
```

#### Troubleshooting Template

```markdown
# {Title}

## Problem

```
{Error message or symptom}
```

## When This Occurs
{Context when error happens}

## Solution

```bash
{Commands or steps to fix}
```

## Root Cause
{Why this happened}

## Prevention
{How to avoid in future}
```

#### Reference Template

```markdown
# {Title}

## Overview
{High-level description}

## Details
{Extracted sections with ## headers}

## Usage
{How to use if mentioned}

## Related
{Links if mentioned}
```

#### Example Template

```markdown
# {Title}

## What It Demonstrates
{Purpose of example}

## Example

```{language}
{Code block}
```

## How It Works
{Line-by-line explanation if provided}

## Use Cases
{When to use this pattern}
```

#### Question Template

```markdown
# {Title}

{Original question formatted clearly}

## Context
{Background if provided}

## What I've Tried
{Attempts if mentioned}
```

### 4. Code Block Detection

Transformations:
- Detect inline code → wrap in backticks
- Detect command lines → format as ```bash
- Detect code blocks → add appropriate language tag
- Detect file paths → format as `code`

Language detection heuristics:
- `$`, `#` prefix → bash
- `def`, `import` → python
- `function`, `const`, `let` → javascript
- `gh ` commands → bash
- URLs, paths → text

### 5. Label Suggestion (AI-Powered)

Use gh-models for intelligent labeling:

```bash
CONTENT="[formatted content]"

LABELS=$(gh models run "openai/gpt-4.1" \
  "Suggest 2-4 labels from this list:

   Available labels:
   - claude-code (Claude Code specific)
   - github-cli (GitHub CLI related)
   - git (Git operations)
   - workflow (Workflow/process)
   - tips (Quick tips)
   - troubleshooting (Problem solving)
   - how-to (Step-by-step guides)
   - reference (Reference docs)
   - example (Code examples)
   - terminal (Terminal/shell)
   - mcp (Model Context Protocol)
   - question (Unanswered questions)

   Content: $CONTENT

   Return ONLY label names, comma-separated.")
```

Fallback keyword-based labeling if AI unavailable:
- "Claude Code", "/plan", "plan mode" → claude-code
- "gh ", "github cli", "gh issue" → github-cli
- "git ", "commit", "branch" → git
- Contains error/fix → troubleshooting
- Numbered steps → how-to
- Contains "?" → question
- Use detected type as label (tips, how-to, etc.)

### 6. Related Knowledge Linking

Search for related issues:

```bash
# Extract keywords using AI
KEYWORDS=$(gh models run "openai/gpt-4.1" \
  "Extract 2-3 search keywords from: $CONTENT")

# Find related issues
RELATED=$(gh search issues "$KEYWORDS" \
  --repo=terrylica/claude-code-skills-github-issues \
  --limit=3 --json number,title,url)

# Add to body if found
if [ -n "$RELATED" ]; then
  echo "\n## Related Knowledge\n" >> body.md
  echo "$RELATED" | jq -r '.[] | "- [#\(.number)](\(.url)): \(.title)"' >> body.md
fi
```

### 7. Issue Creation

Create with full metadata:

```bash
# Save formatted content
cat > /tmp/knowledge-entry.md <<EOF
{formatted-markdown-content}
EOF

# Create issue
gh issue create \
  --repo terrylica/claude-code-skills-github-issues \
  --title "$GENERATED_TITLE" \
  --label "$AI_SUGGESTED_LABELS" \
  --body-file /tmp/knowledge-entry.md

# Capture issue number and URL
ISSUE_NUMBER=$(gh issue list --limit=1 --json number --jq '.[0].number')
ISSUE_URL=$(gh issue view $ISSUE_NUMBER --json url --jq '.url')
```

## Complete Examples

### Example 1: Rough Notes → Structured Tip

**User Input:**
```
tmux is great, you can use ctrl-b d to detach and tmux attach to reattach
useful when ssh connections drop
```

**Processing:**
- **Type detected:** Tip (keywords: "great", "useful")
- **Title generated:** "Terminal: Using tmux for Persistent SSH Sessions"
- **Labels suggested:** terminal, tips, workflow
- **Related found:** #15 (SSH best practices), #23 (Terminal multiplexers)

**Output:**
```markdown
# Terminal: Using tmux for Persistent SSH Sessions

## What It Does
tmux allows you to maintain persistent terminal sessions that survive
SSH disconnections.

## When to Use It
Essential for long-running operations over SSH where connection stability
is a concern.

## Key Commands

Detach from session:
```bash
Ctrl-b d
```

Reattach to session:
```bash
tmux attach
```

## Benefits
- Sessions survive SSH disconnections
- Resume work exactly where you left off
- Run long processes safely

## Related Knowledge
- [#15](https://github.com/.../issues/15): SSH Best Practices for Remote Work
- [#23](https://github.com/.../issues/23): Comparison of Terminal Multiplexers
```

### Example 2: Error Message → Troubleshooting

**User Input:**
```
Got "fatal: refusing to merge unrelated histories" when pulling
Fixed with git pull --allow-unrelated-histories
Happened because I initialized locally and on GitHub separately
```

**Processing:**
- **Type detected:** Troubleshooting (keywords: "error", "fixed")
- **Title generated:** "Git: Fix 'refusing to merge unrelated histories' Error"
- **Labels suggested:** git, troubleshooting, how-to
- **Related found:** #8 (Git common errors)

**Output:**
```markdown
# Git: Fix 'refusing to merge unrelated histories' Error

## Problem

```
fatal: refusing to merge unrelated histories
```

## When This Occurs
When you've initialized a repository both locally and on GitHub separately,
Git sees them as unrelated.

## Solution

```bash
git pull --allow-unrelated-histories
```

## Root Cause
Separate initialization creates two independent Git histories with no
common ancestor.

## Prevention
Initialize in one location only, then clone or push to the other.

## Related Knowledge
- [#8](https://github.com/.../issues/8): Common Git Errors and Solutions
```

### Example 3: Code Snippet → Example

**User Input:**
```
Here's how to use jq to extract issue titles:
gh search issues bug --json title | jq -r '.[].title'
```

**Processing:**
- **Type detected:** Example (contains code, "here's how")
- **Title generated:** "GitHub CLI: Extract Issue Titles with jq"
- **Labels suggested:** github-cli, example, tips
- **Related found:** #12 (jq recipes)

**Output:**
```markdown
# GitHub CLI: Extract Issue Titles with jq

## What It Does
Extracts just the titles from GitHub issue search results using jq.

## Example

```bash
gh search issues bug --json title | jq -r '.[].title'
```

## How It Works
- `--json title` - Output only title field as JSON
- `jq -r '.[].title'` - Extract title from each array element, raw output

## Use Cases
- Quick scan of issue titles
- Pipe to grep for further filtering
- Generate reports or summaries

## Related Knowledge
- [#12](https://github.com/.../issues/12): jq Recipes for GitHub CLI
```

## Quality Enhancements

Applied automatically:
- **Spell check:** Common tech terms (gh, tmux, jq, etc.)
- **Emoji headers:** Add emoji based on type (💡 for tips, 🔧 for troubleshooting)
- **Horizontal rules:** Add `---` for visual separation
- **Code highlighting:** Ensure all code blocks have language tags
- **Link formatting:** Convert raw URLs to markdown links
- **Command formatting:** Wrap commands in ```bash blocks

## Validation Checks

Before creating issue:
- ✓ Title is clear and searchable (< 80 chars)
- ✓ Content is well-structured (has headers)
- ✓ At least 1 label present
- ✓ Markdown properly formatted
- ✓ Code blocks have syntax highlighting
- ✓ Content length > 20 chars

## Error Scenarios

**Scenario 1: Content Too Short**
```
Input: "tmux"

Response:
I need more content to create a useful knowledge entry.
Could you provide at least a sentence or two about what you want to share?
```

**Scenario 2: gh-models Unavailable**
```
Falls back to keyword-based processing:
- Title: Use first sentence or generate from keywords
- Labels: Use keyword detection instead of AI
- Proceed with creation using fallback values
```

**Scenario 3: Issue Creation Fails**
```
⚠️  Couldn't create issue automatically. Here's the formatted content:

[Shows formatted markdown]

You can create manually:
1. Save content to file: content.md
2. Run: gh issue create --title "..." --label "..." --body-file content.md
```

## Dependencies

Required:
- `gh` CLI (>= 2.0)
- Repository access (terrylica/claude-code-skills-github-issues)

Optional but recommended:
- `gh-models` extension (for AI labeling and title extraction)
- `jq` (for JSON processing)

Install dependencies:
```bash
# gh CLI (if not installed)
brew install gh

# gh-models extension
gh extension install github/gh-models

# jq
brew install jq
```

## Performance

- AI labeling: ~1-2 seconds
- Issue creation: ~500ms
- Related knowledge search: ~1 second
- **Total time:** < 4 seconds end-to-end

---

**Last Updated:** 2025-10-24
**Part of:** GitHub Issues Knowledge Base Operations
**Repository:** https://github.com/terrylica/claude-code-skills-github-issues
