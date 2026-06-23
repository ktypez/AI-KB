---
type: index
id: agents-index
last_updated: 2026-06-23
projects:
  - id: mcky-agent
    path: agents/mcky-agent.md
  - id: truck-agent
    path: agents/truck-agent.md
  - id: clientdata-agent
    path: agents/clientdata-agent.md
  - id: writer-agent
    path: agents/writer-agent.md
  - id: code-review
    path: agents/code-review.md
---

# AI Agents Overview

Centralized index of all AI agents across the knowledge base.

## Agent Registry

| Agent | Project | Role | Personality |
|-------|---------|------|-------------|
| mcky-agent | mcky.space | Terminal-style personal website (Next.js 14) | terminal hipster |
| truck-agent | truck | Shift logging & income PWA (React 19 + Supabase) | overtime enthusiast |
| clientdata-agent | clientdata | Client management & CRM (Next.js 16 + Neon) | data goblin |
| writer-agent | global | Content writer & summarizer | word goblin |
| code-review | global | Code quality, bug detection, security audit | code inspector |

## Related Directories

| Directory | Purpose |
|-----------|---------|
| `agents/` | Agent profiles (this directory) |
| `status/` | Project status files (centralized) |
| `memory/` | User profile + projects summary |
| `tasks/` | Shared triggers and task patterns |

## Project AGENTS.md Pattern

Each project's AGENTS.md is now **ultra-thin** — contains only:
1. `## KB` section linking to the correct KB agent file
2. `## Local` section for project-specific notes (env files, status files)

All context lives in this KB. The old local STATUS.md pattern is deprecated — use `update kb` (or the `update .md` alias) to update centralized status.

## Cross-Project Triggers

| Trigger | truck | mcky.space | clientdata |
|---------|-------|------------|------------|
| `update kb` | ✅ | ✅ | ✅ |
| `update .md` | ✅ (alias for `update kb`) | ✅ (alias for `update kb`) | ✅ (alias for `update kb`) |
| `cleanup` | ✅ | ✅ | ✅ |
| `wrap-day` | ✅ | — | — |

`update .md` is now an alias for `update kb` — both do the same thing (update centralized KB files in `~/AI-KB/`). The old local STATUS.md pattern is deprecated.

## Global Rules

- **No Chinese characters** in chat or code — Thai or English only
- Concise, direct responses — under 4 lines when possible
- Priority: read AGENTS.md + STATUS.md before starting work
- All files use YAML frontmatter + Markdown body (OKF standard)

## Auto-Sync to Shared Storage

A background watcher syncs changes to `~/storage/shared/AI-KB` automatically.

| Command | Action |
|---------|--------|
| `bash agents/../sync-watcher.sh start` | Start daemon |
| `bash agents/../sync-watcher.sh stop` | Stop daemon |
| `bash agents/../sync-watcher.sh status` | Check if running |

Starts automatically on device boot (via Termux:Boot at `~/.termux/boot/ai-kb-sync`).
