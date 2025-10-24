# Changelog

All notable changes to the GitHub Issues Skills plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [4.0.0] - 2025-10-24

### Added

#### Plugin Infrastructure
- `.claude-plugin/marketplace.json` - Plugin marketplace metadata for distribution
- `.claude-plugin/plugin.json` - Skills configuration and plugin manifest
- `LICENSE` - MIT License (Copyright 2025 Terry Li)
- `INSTALLATION.md` - Complete installation, update, and uninstall guide
- `CHANGELOG.md` - Version history and update tracking (this file)

#### Skills (1,192 lines total)
- **searching-issues** (110 lines) - Issue/PR search with 30+ qualifiers, complete syntax reference
- **managing-lifecycle** (228 lines) - CRUD operations, state management, batch processing
- **ai-assisted-operations** (256 lines) - AI-powered summarization, auto-labeling, Q&A (88% effectiveness)
- **file-searching** (277 lines) - Regex-based file search with gh-grep extension
- **label-management** (321 lines) - Label and milestone CRUD, organization strategies

#### Progressive Disclosure Architecture
- Context savings: 73-95% compared to loading full documentation
- Auto-activation based on GitHub Issues operations
- Links to comprehensive documentation (5,000+ lines available on-demand)

### Changed

#### Repository Migration
- **Repository renamed:** `terrylica/knowledgebase` → `terrylica/claude-code-skills-github-issues`
- **URL updates:** 43 references updated across 6 documentation files
- **README.md enhanced:** Added installation section with global and project-local methods
- **skills/README.md:** Complete installation and verification guide

### Migration Path
From v3.x (pre-Skills) to v4.0.0:
1. Repository automatically redirects from old URL
2. Install as plugin: `/plugin marketplace add terrylica/claude-code-skills-github-issues`
3. Skills replace static documentation loading

---

## [3.0.0] - 2025-10-23

### Added
- DRY consolidation complete
- Single source of truth principle enforced
- Canonical source map in CLAUDE.md

### Changed
- Reduced from 16 documentation files to 6 core files
- 892 lines removed through consolidation (-968 deletions, +76 additions)
- Removed duplicate content across operational guide and extension docs

### Removed
- `gh-dash` extension (superseded by AI agent workflows)
- Duplicate installation instructions
- Redundant extension documentation

---

## [2.0.0] - 2025-10-22

### Added
- Complete extension ecosystem research (652+ extensions analyzed)
- gh-models POC testing (88% average effectiveness)
- Extension recommendations (gh-grep, gh-models)

### Changed
- Updated extension maintenance status
- Verified actively maintained extensions only

### Deprecated
- `gh-label` extension (last updated 2022) - Use native `gh label` instead
- `gh-milestone` extension (last updated 2023) - Use `gh api` instead

---

## [1.0.0] - 2025-10-21

### Added
- Complete GitHub CLI testing (200+ test cases)
- Native search capabilities documentation (30+ qualifiers)
- Issue lifecycle operations guide
- Label management reference

### Documented
- 5 operation categories
- Complete API coverage
- JSON output (21 fields)
- Search syntax and filters

---

## Version Strategy

### Semantic Versioning

**MAJOR.MINOR.PATCH**

- **MAJOR:** Breaking changes to plugin structure, skill organization, or documented workflows
- **MINOR:** New skills, new documentation sections, new operation categories
- **PATCH:** Bug fixes, documentation corrections, clarifications

### Examples

- **5.0.0:** Breaking changes to skill structure or plugin architecture
- **4.1.0:** Add new skill (e.g., "project-management" for GitHub Projects)
- **4.0.1:** Fix broken links, correct command examples, typo fixes

---

## How to Update

### For End Users

**Step 1:** Update marketplace catalog
```bash
/plugin marketplace update terrylica/claude-code-skills-github-issues
```

**Step 2:** Reinstall to get latest version
```bash
/plugin uninstall github-issues-operations@terrylica/claude-code-skills-github-issues
/plugin install github-issues-operations@terrylica/claude-code-skills-github-issues
```

**Step 3:** Verify update
```bash
/plugin
```

See [INSTALLATION.md](/INSTALLATION.md) for complete update guide.

### For Teams (Version Pinning)

In your internal marketplace.json:
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

---

## Upcoming Releases

### [4.1.0] - Planned

**Potential additions:**
- GitHub Projects integration skill
- GitHub Actions workflow skill
- Enhanced AI operations with custom prompts

**Request features:** https://github.com/terrylica/claude-code-skills-github-issues/issues

---

## Support

**Issues:** https://github.com/terrylica/claude-code-skills-github-issues/issues

**Documentation:** [AI_AGENT_OPERATIONAL_GUIDE.md](/docs/guides/AI_AGENT_OPERATIONAL_GUIDE.md)

**Installation Guide:** [INSTALLATION.md](/INSTALLATION.md)

---

## Links

- **Repository:** https://github.com/terrylica/claude-code-skills-github-issues
- **License:** MIT
- **Maintainer:** Terry Li <terry@eonlabs.com>

---

**Note:** This changelog is maintained manually. All changes are tracked in git commits and can be viewed with `git log`.
