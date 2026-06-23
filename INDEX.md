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
**This is the entry point** — any AI tool should read this file first.

## Agent Registry

| Agent | Project | Role | Personality |
|-------|---------|------|-------------|
| mcky-agent | mcky.space | Terminal-style personal website (Next.js 14) | terminal hipster |
| truck-agent | truck | Shift logging & income PWA (React 19 + Supabase) | overtime enthusiast |
| clientdata-agent | clientdata | Client management & CRM (Next.js 16 + Neon) | data goblin |
| writer-agent | global | Content writer & summarizer | word goblin |
| code-review | global | Code quality, bug detection, security audit | code inspector |

## Directory Layout

```
~/AI-KB/
├── INDEX.md             ← THIS FILE — start here
├── USAGE.md             ← Universal prompt for any AI tool
├── agents/              ← Agent profiles (one per project)
├── status/              ← Live project status
├── memory/              ← User profile + projects summary
├── tasks/               ← Shared triggers and task patterns
├── blog/                ← KB internal notes
├── workflow.md          ← Workflow docs
├── sync-to-shared.sh    ← Sync script
└── sync-watcher.sh      ← Auto-sync daemon
```

## Project AGENTS.md Pattern

Each project's `AGENTS.md` is **ultra-thin** — contains only:
1. `## KB` section linking to the correct KB agent file
2. `## Local` section for project-specific notes (env files, status files)

All context lives in this KB.

## Cross-Project Triggers

| Trigger | truck | mcky.space | clientdata |
|---------|-------|------------|------------|
| `update kb` | ✅ | ✅ | ✅ |
| `update .md` | ✅ | ✅ | ✅ |
| `cleanup` | ✅ | ✅ | ✅ |
| `wrap-day` | ✅ | — | — |

`update .md` is an alias for `update kb` — both do the same thing (update centralized KB files in `~/AI-KB/`).

## Global Rules

- **No Chinese characters** in chat or code — Thai or English only
- Concise, direct responses — under 4 lines when possible
- Priority: read `INDEX.md` + project `AGENTS.md` + linked KB files before starting work
- All files use YAML frontmatter + Markdown body (OKF standard)
- Never update KB files unless explicitly told (via triggers above)
- Never commit or push unless told

## Auto-Sync to Shared Storage

A background watcher syncs changes to `~/storage/shared/AI-KB` automatically.

| Command | Action |
|---------|--------|
| `bash ~/AI-KB/sync-watcher.sh start` | Start daemon |
| `bash ~/AI-KB/sync-watcher.sh stop` | Stop daemon |
| `bash ~/AI-KB/sync-watcher.sh status` | Check if running |

Starts automatically on device boot (via Termux:Boot at `~/.termux/boot/ai-kb-sync`).

## How AI Tools Should Use This

1. Read this file (`INDEX.md`) — understand the project roster and rules
2. Read `./AGENTS.md` in the project root you're working on
3. Follow the `## KB` links in that file to load full context
4. Read `~/AI-KB/memory/user-profile.md` for user preferences
5. Start working

See `~/AI-KB/USAGE.md` for tool-specific setup and a copy-paste universal prompt.
