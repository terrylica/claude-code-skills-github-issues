---
name: creating-knowledge-entries
description: Create structured GitHub Issue knowledge entries with one-shot input. Handles auto-formatting, AI labeling, title extraction, and publishing. Use when user wants to share tips, document solutions, create how-tos, or add any knowledge to the base.
---

# Creating Knowledge Entries

One-shot knowledge capture with full automation.

## Trigger Detection

Activate this skill when user says:
- "I want to share knowledge"
- "Let me document this"
- "Add to knowledge base"
- "Share a tip"
- "Document this solution"
- "Create how-to"

## Workflow

### Step 1: Single Prompt

```
I'll create a knowledge entry for you. Just paste your content below
(rough notes are fine - I'll format, extract title, suggest labels):

Paste your knowledge:
```

### Step 2: Automatic Processing

Process user input through automation pipeline:
- Type detection (tip, how-to, troubleshooting, reference, example, question)
- Title extraction using AI
- Content formatting with templates
- Label suggestion via gh-models
- Related knowledge linking
- GitHub Issue creation

See [REFERENCE.md](REFERENCE.md) for complete pipeline details.

### Step 3: Confirmation

```
✅ Created Issue #{number}!

📋 What I did:
─────────────────────────────────────────
Title:    "{extracted-title}"
          (extracted from your content)

Type:     {type-emoji} {type-name} (auto-detected)

Labels:   {label1, label2, label3}
          (AI-suggested based on content)

Format:   Structured with sections
          {list-of-sections-added}

Related:  Linked to #{n1}, #{n2} (if found)
─────────────────────────────────────────
🔗 {issue-url}

Search later: gh search issues "{keywords}" --label={primary-label}
```

## Quick Example

**Input:**
```
tmux is great for persistent sessions. ctrl-b d to detach and
tmux attach to reattach. Useful when ssh connections drop.
```

**Output:**
Formatted GitHub Issue:
- **Title:** "Terminal: Using tmux for Persistent SSH Sessions"
- **Labels:** terminal, tips, workflow
- **Content:** Structured with "What It Does", "When to Use It", "Key Commands" sections
- **Related:** Auto-linked to similar terminal tips

## Dependencies

- `gh` CLI (issue creation)
- `gh-models` extension (AI labeling, title extraction)
- `jq` (JSON processing)

## Error Handling

Content too short (< 20 chars):
```
I need more content to create a useful knowledge entry.
Could you provide at least a sentence or two?
```

API fails:
```
⚠️  Couldn't create issue automatically. Here's the formatted content:
[formatted markdown shown]

Create manually: gh issue create --title "..." --body-file content.md
```

## Complete Reference

For detailed automation pipeline, templates, and examples, see [REFERENCE.md](REFERENCE.md).

---

**Repository:** https://github.com/terrylica/claude-code-skills-github-issues
