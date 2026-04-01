# Claude Elephant Plugin

Standards-aware development intelligence for Claude Code. Auto-validates code against RFCs, enforces MUST/SHOULD/MAY rules, learns project conventions, and injects relevant context per project.

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI installed
- The `elephant` binary built from the main project (`make build`)

## Installation

### From GitHub (recommended)

```bash
claude plugin add kodabase/kdb-elephant-plugin
```

### Manual installation

1. Clone this repository (or copy the `plugin/` directory):

```bash
git clone https://github.com/kodabase/kdb-elephant-plugin.git
cd kdb-elephant-plugin
```

2. Install as a local plugin:

```bash
claude plugin add ./
```

### Verify installation

After installing, restart Claude Code. On session start you should see:

```
Elephant v1.0.0 ready | X standards, Y rules loaded
```

## What gets installed

The plugin registers the following components in Claude Code:

### MCP Server

An MCP server (`elephant mcp`) providing 5 tools:

- `search_standards` — Find applicable standards for your code
- `get_standard` — Get full details of specific RFCs/ADRs
- `validate_code` — Check code against specific rules
- `list_standards` — List all active standards
- `compliance_report` — Generate a compliance report

### Hooks

| Event | Behavior |
|-------|----------|
| **SessionStart** | Starts the Elephant worker daemon and loads standards context |
| **PreToolUse** (Write/Edit) | Checks code changes against standards before applying |
| **PostToolUse** (Write/Edit) | Tracks changes asynchronously for compliance analysis |
| **Stop** | Saves session data |
| **SessionEnd** | Cleans up session |

### Agent

- **standards-reviewer** — A read-only agent that reviews code changes against project RFCs and reports violations with compliance scores.

### Slash Commands

| Command | Description |
|---------|-------------|
| `/std-ingest <path>` | Import standards documents (RFCs, ADRs, guidelines) |
| `/std-search <query>` | Search standards and rules |
| `/std-validate [file]` | Validate code against standards |
| `/std-report` | Generate a compliance report |

## Configuration

The plugin stores data in `~/.claude-elephant/`. You can customize behavior with environment variables (`ELEPHANT_*`) or by editing `~/.claude-elephant/settings.json`.

## Ingesting standards

Before validation works, you need to import your standards documents:

```
/std-ingest ./docs/rfcs/
```

Supported formats:
- Markdown with YAML frontmatter
- Inline markdown metadata (`# RFC-001: Title` + `**Status**: **APPROVED**`)
- Document types: RFC, ADR, Guideline, Spec, Pattern

## Uninstall

```bash
claude plugin remove claude-elephant
```
