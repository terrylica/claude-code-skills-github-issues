# GitHub Issues Skills

Claude Code Skills for comprehensive GitHub Issues management operations.

## What's Included

This plugin provides 5 specialized skills for AI agents to manage GitHub Issues:

1. **searching-issues** - Issue search and discovery with 30+ qualifiers
2. **managing-lifecycle** - Complete CRUD operations, state management, comments
3. **ai-assisted-operations** - AI-powered summarization, labeling, Q&A (gh-models)
4. **file-searching** - Regex-based file search across repositories (gh-grep)
5. **label-management** - Label and milestone CRUD, cloning, batch operations

## Installation

### Global Installation (Recommended for Individual Use)

Install via Claude Code plugin marketplace:

```bash
/plugin marketplace add terrylica/claude-code-skills-github-issues
/plugin install github-issues-operations@terrylica/claude-code-skills-github-issues
```

This makes the skills available across all your Claude Code sessions.

**Complete Installation Guide:** See [INSTALLATION.md](/INSTALLATION.md) for detailed instructions, troubleshooting, and lifecycle management.

### Project-Local Installation (Recommended for Teams)

Clone this repository into your project:

```bash
git clone https://github.com/terrylica/claude-code-skills-github-issues.git .claude/plugins/github-issues
```

Or add as a git submodule:

```bash
git submodule add https://github.com/terrylica/claude-code-skills-github-issues.git .claude/plugins/github-issues
```

### Verification

After installation, Claude Code will automatically discover and activate these skills when working with GitHub Issues.

## Plugin Lifecycle Management

### Update to New Version

When a new version is released (check [CHANGELOG.md](/CHANGELOG.md)):

```bash
# Refresh marketplace
/plugin marketplace update terrylica/claude-code-skills-github-issues

# Reinstall to get latest version
/plugin uninstall github-issues-operations@terrylica/claude-code-skills-github-issues
/plugin install github-issues-operations@terrylica/claude-code-skills-github-issues
```

### Uninstall

Complete removal:

```bash
# Remove plugin
/plugin uninstall github-issues-operations@terrylica/claude-code-skills-github-issues

# Remove marketplace (optional)
/plugin marketplace remove terrylica/claude-code-skills-github-issues
```

Temporary disable (keeps installation):

```bash
/plugin disable github-issues-operations@terrylica/claude-code-skills-github-issues
```

Re-enable later:

```bash
/plugin enable github-issues-operations@terrylica/claude-code-skills-github-issues
```

**Complete Guide:** [INSTALLATION.md](/INSTALLATION.md) has troubleshooting and advanced configuration.

## Prerequisites

- **GitHub CLI** (`gh`) installed and authenticated
- **Optional Extensions**:
  - `gh-grep` for file search: `gh extension install k1LoW/gh-grep`
  - `gh-models` for AI operations: `gh extension install github/gh-models`

## Documentation

Complete operational guide and reference documentation available in:

- [AI_AGENT_OPERATIONAL_GUIDE.md](/docs/guides/AI_AGENT_OPERATIONAL_GUIDE.md) - Complete operations reference
- [GITHUB_CLI_EXTENSIONS.md](/docs/research/GITHUB_CLI_EXTENSIONS.md) - Extension details
- [github-cli-issues-comprehensive-guide.md](/docs/references/github-cli-issues-comprehensive-guide.md) - Complete API reference

## Version

**Current Version:** 4.0.0 (DRY consolidation - production ready)

## License

MIT License - Copyright (c) 2025 Terry Li

## Support

Issues and feedback: https://github.com/terrylica/claude-code-skills-github-issues/issues
