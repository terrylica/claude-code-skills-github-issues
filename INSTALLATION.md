# Installation & Lifecycle Guide

Complete guide for installing, using, updating, and uninstalling the GitHub Issues Skills plugin for Claude Code.

---

## Prerequisites

- **Claude Code** installed and running (version 2.0.13+)
- **GitHub CLI** (`gh`) installed and authenticated
- **Optional Extensions:**
  - `gh-grep` for file search: `gh extension install k1LoW/gh-grep`
  - `gh-models` for AI operations: `gh extension install github/gh-models`

---

## Installation

### Method 1: GitHub Marketplace (Recommended)

**Step 1:** Add the marketplace to Claude Code

```bash
/plugin marketplace add terrylica/claude-code-skills-github-issues
```

This command:
- Fetches the marketplace catalog from GitHub
- Makes the plugin available for installation
- No files are installed yet

**Step 2:** Install the plugin

```bash
/plugin install github-issues-operations@terrylica/claude-code-skills-github-issues
```

Or use the interactive menu:

```bash
/plugin
```

Then select "Install Plugin" → "github-issues-operations"

**Step 3:** Verify installation

```bash
/help
```

Check that the 5 GitHub Issues skills are loaded and available.

---

### Method 2: Local Development (Testing Only)

For local testing before pushing to GitHub:

```bash
/plugin marketplace add file:///absolute/path/to/claude-code-skills-github-issues
/plugin install github-issues-operations@local-marketplace-name
```

**Note:** This method is for development only. End users should use Method 1.

---

## Usage

Once installed, the 5 skills auto-activate when working with GitHub Issues:

### Skills Available

1. **searching-issues** - Issue/PR search with 30+ qualifiers
2. **managing-lifecycle** - CRUD operations for issues
3. **ai-assisted-operations** - AI-powered summarization and labeling
4. **file-searching** - Regex-based file search (gh-grep)
5. **label-management** - Label and milestone management

### Verification

Test that skills are working:

```bash
# Should trigger searching-issues skill
gh search issues "authentication" --repo=your-org/your-repo

# Should trigger managing-lifecycle skill
gh issue create --title "Test issue"

# Should trigger ai-assisted-operations skill
gh models list
```

The skills load **progressively** - only the relevant skill activates based on your task, saving 73-95% context compared to loading full documentation.

---

## Plugin Management

### Check Plugin Status

```bash
/plugin
```

Shows:
- Installed plugins
- Enabled/disabled state
- Available marketplaces

### Enable/Disable (Without Uninstalling)

```bash
# Temporarily disable (keeps installation)
/plugin disable github-issues-operations@terrylica/claude-code-skills-github-issues

# Re-enable
/plugin enable github-issues-operations@terrylica/claude-code-skills-github-issues
```

**Use Case:** Temporarily disable skills without losing installation when troubleshooting or testing.

---

## Updating to New Versions

When a new version is released (check [CHANGELOG.md](/CHANGELOG.md)):

### Step 1: Update the marketplace catalog

```bash
/plugin marketplace update terrylica/claude-code-skills-github-issues
```

This refreshes the plugin listings and fetches the latest version metadata.

### Step 2: Reinstall to get the latest version

```bash
/plugin uninstall github-issues-operations@terrylica/claude-code-skills-github-issues
/plugin install github-issues-operations@terrylica/claude-code-skills-github-issues
```

Or use the interactive menu:

```bash
/plugin
```

Then "Uninstall" → "Install" to get the latest version.

### Step 3: Verify new version

Check the changelog or plugin details to confirm you have the latest version:

```bash
/plugin
```

Select "Manage Plugins" → "github-issues-operations" to view details.

---

## Uninstallation

### Complete Removal

**Step 1:** Uninstall the plugin

```bash
/plugin uninstall github-issues-operations@terrylica/claude-code-skills-github-issues
```

Or via interactive menu:

```bash
/plugin
```

Select "Uninstall Plugin" → "github-issues-operations"

**Step 2:** (Optional) Remove the marketplace

```bash
/plugin marketplace remove terrylica/claude-code-skills-github-issues
```

**Warning:** Removing the marketplace will uninstall all plugins from it.

### Temporary Disabling (Keeps Installation)

If you want to keep the plugin but temporarily disable it:

```bash
/plugin disable github-issues-operations@terrylica/claude-code-skills-github-issues
```

Re-enable later:

```bash
/plugin enable github-issues-operations@terrylica/claude-code-skills-github-issues
```

---

## Troubleshooting

### Plugin Not Loading

**Problem:** Skills don't activate when working with GitHub Issues

**Solutions:**

1. Verify plugin is installed and enabled:
   ```bash
   /plugin
   ```

2. Check GitHub CLI is working:
   ```bash
   gh auth status
   ```

3. Reinstall the plugin:
   ```bash
   /plugin uninstall github-issues-operations@terrylica/claude-code-skills-github-issues
   /plugin install github-issues-operations@terrylica/claude-code-skills-github-issues
   ```

4. Restart Claude Code

### Marketplace Not Found

**Problem:** `/plugin marketplace add terrylica/claude-code-skills-github-issues` fails

**Solutions:**

1. Check GitHub repository exists and is public:
   ```bash
   gh repo view terrylica/claude-code-skills-github-issues
   ```

2. Verify `.claude-plugin/marketplace.json` exists in the repository

3. Check your internet connection

4. Try the full GitHub URL:
   ```bash
   /plugin marketplace add https://github.com/terrylica/claude-code-skills-github-issues
   ```

### Skills Not Auto-Activating

**Problem:** Skills available but not auto-activating based on context

**Solutions:**

1. Skills activate based on context - ensure you're actually working with GitHub Issues operations

2. Check skill paths are correct:
   ```bash
   claude plugin validate /path/to/plugin
   ```

3. Verify all SKILL.md files exist:
   ```bash
   ls -la skills/github-issues/*/SKILL.md
   ```

### Update Not Working

**Problem:** After updating, still seeing old version

**Solutions:**

1. Completely uninstall first:
   ```bash
   /plugin uninstall github-issues-operations@terrylica/claude-code-skills-github-issues
   ```

2. Clear marketplace cache by removing and re-adding:
   ```bash
   /plugin marketplace remove terrylica/claude-code-skills-github-issues
   /plugin marketplace add terrylica/claude-code-skills-github-issues
   ```

3. Reinstall fresh:
   ```bash
   /plugin install github-issues-operations@terrylica/claude-code-skills-github-issues
   ```

4. Restart Claude Code

---

## Version History

See [CHANGELOG.md](/CHANGELOG.md) for complete version history and update notes.

**Current Version:** 4.0.0

---

## Support

**Issues:** https://github.com/terrylica/claude-code-skills-github-issues/issues

**Repository:** https://github.com/terrylica/claude-code-skills-github-issues

**Documentation:** Complete operational guide at [AI_AGENT_OPERATIONAL_GUIDE.md](/docs/guides/AI_AGENT_OPERATIONAL_GUIDE.md)

---

## Advanced: Team Distribution

### Automatic Installation for Team Projects

Add to your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": [
    "terrylica/claude-code-skills-github-issues"
  ],
  "enabledPlugins": [
    "github-issues-operations@terrylica/claude-code-skills-github-issues"
  ]
}
```

This automatically:
- Adds the marketplace when team members open the project
- Installs and enables the plugin
- Ensures consistent tooling across the team

### Version Pinning (Recommended for Teams)

In your marketplace.json (if hosting internally), pin specific versions:

```json
{
  "plugins": [
    {
      "name": "github-issues-operations",
      "version": "4.0.0",
      "source": "https://github.com/terrylica/claude-code-skills-github-issues.git#v4.0.0"
    }
  ]
}
```

This ensures all team members use the same tested version.

---

## Clean Uninstallation Checklist

To completely remove all traces:

- [ ] Uninstall plugin: `/plugin uninstall github-issues-operations@terrylica/claude-code-skills-github-issues`
- [ ] Remove marketplace: `/plugin marketplace remove terrylica/claude-code-skills-github-issues`
- [ ] (Optional) Check `~/.claude/settings.json` and remove any references
- [ ] Restart Claude Code to clear any cached state

---

**Last Updated:** 2025-10-24
**Plugin Version:** 4.0.0
**Minimum Claude Code Version:** 2.0.13
