# GitHub CLI Extensions - Maintenance Status Check

**Date:** 2025-10-23
**Checked:** Via `gh repo view` API

---

## ❌ OUTDATED EXTENSIONS (DO NOT USE)

### gh-label (heaths/gh-label)
- **Last Push:** 2022-01-20 (3 years ago!)
- **Stars:** 62
- **Status:** Not archived but DEAD
- **Verdict:** ❌ **REJECT** - No updates in 3 years

### gh-milestone (valeriobelli/gh-milestone)
- **Last Push:** 2023-12-18 (2 years ago!)
- **Stars:** 66
- **Status:** Not archived but STALE
- **Verdict:** ❌ **REJECT** - No updates in 2 years

**User's concern was CORRECT!** These extensions are outdated.

---

## ✅ ACTIVELY MAINTAINED EXTENSIONS (RECOMMENDED)

### 1. gh-dash (dlvhdr/gh-dash) ⭐⭐⭐⭐⭐
- **Last Push:** 2025-10-22 (YESTERDAY!)
- **Latest Release:** v4.18.0
- **Stars:** 9,000
- **Status:** ✅ ACTIVELY MAINTAINED
- **Commits:** Multiple commits in past week
- **Verdict:** ✅ **HIGHLY RECOMMENDED** - Active development, large community

### 2. gh-grep (k1LoW/gh-grep) ⭐⭐⭐⭐
- **Last Push:** 2025-10-22 (YESTERDAY!)
- **Latest Release:** v1.2.5
- **Stars:** 211
- **Status:** ✅ ACTIVELY MAINTAINED
- **Commits:** Regular dependency updates, maintenance commits
- **Verdict:** ✅ **RECOMMENDED** - Well maintained, useful for searching

### 3. gh-models (github/gh-models) ⭐⭐⭐⭐⭐
- **Last Push:** 2025-10-14 (9 days ago)
- **Latest Release:** v0.0.25
- **Stars:** 154
- **Status:** ✅ OFFICIAL GITHUB EXTENSION
- **Commits:** Regular updates from GitHub team
- **Free:** Yes (within rate limits)
- **Verdict:** ✅ **OFFICIAL** - GitHub-maintained, safe to use

---

## Alternative Solutions for Label/Milestone Management

Since gh-label and gh-milestone are outdated, we need alternatives:

### For Labels: Use Native `gh` Commands

Native GitHub CLI has built-in label commands (added in newer versions):

```bash
# List labels
gh label list

# Create label
gh label create LABEL --color COLOR --description DESC

# Delete label
gh label delete LABEL

# Edit label
gh label edit LABEL --color COLOR --name NEW-NAME
```

**Status:** ✅ BUILT-IN, no extension needed!

### For Milestones: Use `gh api`

Native gh CLI doesn't have milestone commands, but you can use gh api:

```bash
# List milestones
gh api repos/:owner/:repo/milestones

# Create milestone
gh api repos/:owner/:repo/milestones -f title="v2.0" -f description="Release 2.0"

# Close milestone
gh api -X PATCH repos/:owner/:repo/milestones/NUMBER -f state=closed
```

**Status:** ✅ Works with native gh api command

---

## Summary

### Extensions to Install:
1. **gh-dash** - TUI dashboard (9k stars, active)
2. **gh-grep** - Search across repos (211 stars, active)
3. **gh-models** - AI models (official, active)

### Extensions to AVOID:
1. ❌ **gh-label** - Dead (last update 2022)
2. ❌ **gh-milestone** - Dead (last update 2023)

### Use Native Commands Instead:
- **Labels:** Use built-in `gh label` commands
- **Milestones:** Use `gh api` endpoints

---

## Testing Plan

Next steps:
1. Install and test gh-dash
2. Install and test gh-grep
3. Install and test gh-models
4. Verify native gh label commands
5. Document findings
