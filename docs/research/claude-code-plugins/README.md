# Claude Code Plugin System Documentation Index

**Last Updated:** 2025-10-25
**Research Date:** 2025-10-25
**Documentation Source:** https://docs.claude.com/en/docs/claude-code/

---

## Quick Navigation

**New to the plugin system?** Start here:

1. [Plugin vs Marketplace vs Skills Comparison](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_VS_MARKETPLACE_VS_SKILLS.md) - Understand the core concepts
2. [Quick Reference](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_SYSTEM_QUICK_REFERENCE.md) - Common commands and patterns
3. [Architecture Diagrams](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_ARCHITECTURE_DIAGRAMS.md) - Visual system overview

**Building plugins?** Go to:

- [Complete Plugin System Guide](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/CLAUDE_CODE_PLUGIN_SYSTEM.md) - Full technical reference

---

## Documentation Files

### 1. Plugin vs Marketplace vs Skills Comparison

**File:** [PLUGIN_VS_MARKETPLACE_VS_SKILLS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_VS_MARKETPLACE_VS_SKILLS.md)
**Size:** ~630 lines
**Purpose:** Clarify differences between core concepts

**What's inside:**

- Quick definitions and analogies
- Comprehensive comparison tables
- Activation model differences
- Distribution mechanism comparisons
- Versioning strategies
- Use case decision trees
- Real-world examples
- Common confusion points explained

**Best for:**

- Understanding "What's the difference between X and Y?"
- Deciding which approach to use
- Explaining concepts to team members

---

### 2. Quick Reference Guide

**File:** [PLUGIN_SYSTEM_QUICK_REFERENCE.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_SYSTEM_QUICK_REFERENCE.md)
**Size:** ~343 lines
**Purpose:** Fast lookup for common operations

**What's inside:**

- Essential file structures
- Minimal configuration examples
- Common commands cheat sheet
- Component types summary
- Development workflow
- Troubleshooting guide
- Best practices checklist

**Best for:**

- Quick command lookup
- Copy-paste templates
- Troubleshooting common issues
- Daily development reference

---

### 3. Architecture Diagrams

**File:** [PLUGIN_ARCHITECTURE_DIAGRAMS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_ARCHITECTURE_DIAGRAMS.md)
**Size:** ~671 lines
**Purpose:** Visual representations of system architecture

**What's inside:**

- System overview diagram
- Plugin file structure visualization
- Marketplace distribution flow
- Component activation model
- Skills discovery process
- Hook lifecycle integration
- MCP server integration
- Team distribution workflow
- Security model diagram
- Error handling flowchart

**Best for:**

- Understanding system architecture
- Visualizing component relationships
- Explaining workflows to team
- Architecture documentation

---

### 4. Complete Plugin System Guide

**File:** [CLAUDE_CODE_PLUGIN_SYSTEM.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/CLAUDE_CODE_PLUGIN_SYSTEM.md)
**Size:** ~950 lines
**Purpose:** Comprehensive technical reference

**What's inside:**

- Complete system architecture
- File structure requirements
- plugin.json full schema
- marketplace.json full schema
- Distribution mechanisms
- All five component types (Commands, Agents, Skills, Hooks, MCP)
- Skills system deep dive
- Best practices
- Direct quotes from official docs
- Debugging guide

**Best for:**

- Plugin development
- Complete technical reference
- Schema specifications
- Official documentation quotes

---

## Topic-Based Navigation

### Understanding Core Concepts

**"What's the difference between plugins, marketplaces, and skills?"**
→ [PLUGIN_VS_MARKETPLACE_VS_SKILLS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_VS_MARKETPLACE_VS_SKILLS.md)

**"How does the system work overall?"**
→ [PLUGIN_ARCHITECTURE_DIAGRAMS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_ARCHITECTURE_DIAGRAMS.md) - System Overview section

**"What are the five component types?"**
→ [CLAUDE_CODE_PLUGIN_SYSTEM.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/CLAUDE_CODE_PLUGIN_SYSTEM.md) - Component Types section

---

### Getting Started

**"How do I install a plugin?"**
→ [PLUGIN_SYSTEM_QUICK_REFERENCE.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_SYSTEM_QUICK_REFERENCE.md) - Common Commands section

**"What files do I need to create a plugin?"**
→ [PLUGIN_SYSTEM_QUICK_REFERENCE.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_SYSTEM_QUICK_REFERENCE.md) - Essential File Structure section

**"Show me the minimal plugin example"**
→ [CLAUDE_CODE_PLUGIN_SYSTEM.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/CLAUDE_CODE_PLUGIN_SYSTEM.md) - Plugin Manifest section

---

### Development Tasks

**"How do I create a marketplace?"**
→ [CLAUDE_CODE_PLUGIN_SYSTEM.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/CLAUDE_CODE_PLUGIN_SYSTEM.md) - Marketplace System section

**"What's the plugin.json schema?"**
→ [CLAUDE_CODE_PLUGIN_SYSTEM.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/CLAUDE_CODE_PLUGIN_SYSTEM.md) - Plugin Manifest section

**"How do I create a skill?"**
→ [CLAUDE_CODE_PLUGIN_SYSTEM.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/CLAUDE_CODE_PLUGIN_SYSTEM.md) - Skills System section

**"How do MCP servers work in plugins?"**
→ [CLAUDE_CODE_PLUGIN_SYSTEM.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/CLAUDE_CODE_PLUGIN_SYSTEM.md) - Component Types > MCP Servers

---

### Architecture & Design

**"How does skill discovery work?"**
→ [PLUGIN_ARCHITECTURE_DIAGRAMS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_ARCHITECTURE_DIAGRAMS.md) - Skills Discovery & Activation

**"What's the plugin distribution flow?"**
→ [PLUGIN_ARCHITECTURE_DIAGRAMS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_ARCHITECTURE_DIAGRAMS.md) - Marketplace Distribution Flow

**"How do hooks integrate with the lifecycle?"**
→ [PLUGIN_ARCHITECTURE_DIAGRAMS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_ARCHITECTURE_DIAGRAMS.md) - Hook Lifecycle Integration

**"How does team distribution work?"**
→ [PLUGIN_ARCHITECTURE_DIAGRAMS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_ARCHITECTURE_DIAGRAMS.md) - Team Distribution Workflow

---

### Troubleshooting

**"My plugin won't load"**
→ [PLUGIN_SYSTEM_QUICK_REFERENCE.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_SYSTEM_QUICK_REFERENCE.md) - Common Issues section

**"Commands are missing"**
→ [PLUGIN_SYSTEM_QUICK_REFERENCE.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_SYSTEM_QUICK_REFERENCE.md) - Common Issues section

**"How do I debug plugins?"**
→ [CLAUDE_CODE_PLUGIN_SYSTEM.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/CLAUDE_CODE_PLUGIN_SYSTEM.md) - Best Practices > Debugging

---

### Comparisons & Decisions

**"Skill vs Command - which should I use?"**
→ [PLUGIN_VS_MARKETPLACE_VS_SKILLS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_VS_MARKETPLACE_VS_SKILLS.md) - Confusion Point 5

**"When should I create a marketplace vs plugin vs skill?"**
→ [PLUGIN_VS_MARKETPLACE_VS_SKILLS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_VS_MARKETPLACE_VS_SKILLS.md) - Use Cases section

**"What's the difference in activation?"**
→ [PLUGIN_VS_MARKETPLACE_VS_SKILLS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_VS_MARKETPLACE_VS_SKILLS.md) - Activation Comparison section

---

### Real-World Examples

**"Company internal tools example"**
→ [PLUGIN_VS_MARKETPLACE_VS_SKILLS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_VS_MARKETPLACE_VS_SKILLS.md) - Example 1

**"Open source community plugin"**
→ [PLUGIN_VS_MARKETPLACE_VS_SKILLS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_VS_MARKETPLACE_VS_SKILLS.md) - Example 2

**"Personal productivity skills"**
→ [PLUGIN_VS_MARKETPLACE_VS_SKILLS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_VS_MARKETPLACE_VS_SKILLS.md) - Example 3

---

## Official Documentation References

All documentation in this collection is based on official Claude Code documentation from October 2025.

**Primary Sources:**

- **Plugins Guide:** https://docs.claude.com/en/docs/claude-code/plugins.md
- **Plugin Marketplaces:** https://docs.claude.com/en/docs/claude-code/plugin-marketplaces.md
- **Plugins Reference:** https://docs.claude.com/en/docs/claude-code/plugins-reference.md
- **Skills System:** https://docs.claude.com/en/docs/claude-code/skills.md
- **Hooks Guide:** https://docs.claude.com/en/docs/claude-code/hooks-guide.md
- **MCP Integration:** https://docs.claude.com/en/docs/claude-code/mcp.md

**Documentation Map:** https://docs.claude.com/en/docs/claude-code/claude_code_docs_map.md

---

## Research Methodology

**Date:** 2025-10-25

**Approach:**

1. Fetched official documentation using WebFetch tool
2. Extracted comprehensive information from all plugin-related pages
3. Organized findings into four complementary documents
4. Included direct quotes with source URLs
5. Created visual diagrams for complex concepts
6. Provided real-world examples and use cases

**Documentation Coverage:**

- ✅ Complete plugin.json schema
- ✅ Complete marketplace.json schema
- ✅ All five component types (Commands, Agents, Skills, Hooks, MCP)
- ✅ Distribution mechanisms (GitHub, Git, Local)
- ✅ Skills system architecture
- ✅ Team configuration
- ✅ Security considerations
- ✅ Best practices
- ✅ Troubleshooting guides
- ✅ Real-world examples

---

## Document Relationships

```
PLUGIN_SYSTEM_INDEX.md (This file)
├─── PLUGIN_VS_MARKETPLACE_VS_SKILLS.md
│    Purpose: Conceptual understanding
│    Audience: All users
│
├─── PLUGIN_SYSTEM_QUICK_REFERENCE.md
│    Purpose: Quick lookup
│    Audience: Daily users
│
├─── PLUGIN_ARCHITECTURE_DIAGRAMS.md
│    Purpose: Visual architecture
│    Audience: Visual learners, architects
│
└─── CLAUDE_CODE_PLUGIN_SYSTEM.md
     Purpose: Complete technical reference
     Audience: Plugin developers
```

**Complementary Nature:**

- **Comparison doc** clarifies concepts
- **Quick reference** provides commands
- **Diagrams** visualize architecture
- **Complete guide** gives full details
- **This index** helps navigate all four

---

## Recommended Reading Order

### For New Users

1. **Start:** [PLUGIN_VS_MARKETPLACE_VS_SKILLS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_VS_MARKETPLACE_VS_SKILLS.md) - Quick Answer section
2. **Then:** [PLUGIN_ARCHITECTURE_DIAGRAMS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_ARCHITECTURE_DIAGRAMS.md) - System Overview
3. **Finally:** [PLUGIN_SYSTEM_QUICK_REFERENCE.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_SYSTEM_QUICK_REFERENCE.md) - Common Commands

**Estimated time:** 15-20 minutes

---

### For Plugin Developers

1. **Start:** [CLAUDE_CODE_PLUGIN_SYSTEM.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/CLAUDE_CODE_PLUGIN_SYSTEM.md) - Plugin Manifest section
2. **Then:** [CLAUDE_CODE_PLUGIN_SYSTEM.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/CLAUDE_CODE_PLUGIN_SYSTEM.md) - Component Types section
3. **Review:** [PLUGIN_ARCHITECTURE_DIAGRAMS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_ARCHITECTURE_DIAGRAMS.md) - Plugin Development Workflow
4. **Reference:** [PLUGIN_SYSTEM_QUICK_REFERENCE.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_SYSTEM_QUICK_REFERENCE.md) - Development Workflow

**Estimated time:** 45-60 minutes

---

### For Marketplace Creators

1. **Start:** [CLAUDE_CODE_PLUGIN_SYSTEM.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/CLAUDE_CODE_PLUGIN_SYSTEM.md) - Marketplace System section
2. **Then:** [PLUGIN_ARCHITECTURE_DIAGRAMS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_ARCHITECTURE_DIAGRAMS.md) - Marketplace Distribution Flow
3. **Review:** [PLUGIN_VS_MARKETPLACE_VS_SKILLS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_VS_MARKETPLACE_VS_SKILLS.md) - Example 1 (Company Internal Tools)
4. **Reference:** [PLUGIN_SYSTEM_QUICK_REFERENCE.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_SYSTEM_QUICK_REFERENCE.md) - Team Auto-Install

**Estimated time:** 30-40 minutes

---

### For Team Leads

1. **Start:** [PLUGIN_ARCHITECTURE_DIAGRAMS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_ARCHITECTURE_DIAGRAMS.md) - Team Distribution Workflow
2. **Then:** [CLAUDE_CODE_PLUGIN_SYSTEM.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/CLAUDE_CODE_PLUGIN_SYSTEM.md) - Distribution > Team Configuration
3. **Review:** [PLUGIN_VS_MARKETPLACE_VS_SKILLS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_VS_MARKETPLACE_VS_SKILLS.md) - Real-World Examples
4. **Security:** [PLUGIN_ARCHITECTURE_DIAGRAMS.md](/Users/terryli/eon/claude-code-skills-github-issues/docs/research/PLUGIN_ARCHITECTURE_DIAGRAMS.md) - Security Model

**Estimated time:** 35-45 minutes

---

## Quick Reference Tables

### File Locations

| File Type          | Location                          | Purpose              |
| ------------------ | --------------------------------- | -------------------- |
| `marketplace.json` | `.claude-plugin/marketplace.json` | Marketplace manifest |
| `plugin.json`      | `.claude-plugin/plugin.json`      | Plugin manifest      |
| `SKILL.md`         | `skills/skill-name/SKILL.md`      | Skill definition     |
| `hooks.json`       | `hooks/hooks.json`                | Hook configuration   |
| `.mcp.json`        | `.mcp.json`                       | MCP server config    |
| Commands           | `commands/*.md`                   | User slash commands  |
| Agents             | `agents/*.md`                     | Specialized agents   |

---

### Essential Commands

```bash
# Marketplace management
/plugin marketplace add owner/repo
/plugin marketplace list

# Plugin management
/plugin install plugin-name@marketplace-name
/plugin enable plugin-name@marketplace-name
/plugin

# Validation & debugging
claude plugin validate .
claude --debug
```

---

### Key Concepts

**Marketplace** = JSON catalog listing plugins
**Plugin** = Directory bundling components
**Skill** = Model-invoked capability
**Command** = User-invoked slash command
**Hook** = Event-driven automation
**MCP Server** = External tool integration

---

## Version History

**1.0.0 (2025-10-25):**

- Initial comprehensive research
- Four complementary documentation files
- Complete coverage of official docs
- Visual architecture diagrams
- Real-world examples
- Troubleshooting guides

---

## Maintenance Notes

**Documentation Snapshot:** October 2025

**Update Procedure:**

1. Check official docs for changes: https://docs.claude.com/en/docs/claude-code/
2. Use WebFetch to retrieve updated pages
3. Update relevant sections in all four documents
4. Maintain single source of truth principle
5. Update version numbers and change history

**Next Review:** When official documentation updates significantly

---

## Feedback & Contributions

**Questions about plugin system?**

- Check official docs: https://docs.claude.com/en/docs/claude-code/
- Review FAQ sections in comparison doc
- Check troubleshooting guides

**Found an issue in this documentation?**

- Verify against official docs
- Document source URL
- Update with direct quotes from official source

---

**Index Version:** 1.0.0
**Last Updated:** 2025-10-25
**Total Documentation Lines:** 2,594 across 4 files
