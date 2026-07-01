---
type: index
id: agents-index
last_updated: 2026-06-30
projects:
  - id: mcky-agent
    path: agents/mcky-agent.md
  - id: truck-agent
    path: agents/truck-agent.md
  - id: clientdata-agent
    path: agents/clientdata-agent.md
  - id: habby-agent
    path: agents/habby-agent.md
  - id: cafe-agent
    path: agents/cafe-agent.md
  - id: writer-agent
    path: agents/writer-agent.md
---

# AI Agents Overview

Centralized index of all AI agents across the knowledge base.
**This is the entry point** — any AI tool should read this file first.

## Agent Registry

| Agent | Project | Role | Personality |
|-------|---------|------|-------------|
| mcky-agent | mcky.space | Terminal-style personal website (Astro 7 + Alpine.js) | terminal hipster |
| truck-agent | truck | Shift logging & income PWA (React 19 + Supabase) | overtime enthusiast |
| clientdata-agent | clientdata | Client management & CRM (Next.js 16 + Neon) | data goblin |
| habby-agent | habby | Gamification UI Kit (Vite 6 + vanilla HTML/CSS/JS) | trophy goblin |
| cafe-agent | cafe | Cafe LIFF ordering & management (Next.js 15 + Supabase) | barista engineer |
| writer-agent | global | Content writer & summarizer | word goblin |

## Directory Layout

```
~/AI-KB/
├── INDEX.md             ← THIS FILE — start here
├── INSTRUCTION.md       ← How to use this KB
├── agents/              ← Agent profiles (one per project)
├── skills/              ← Specialized skills (INDEX.md + 8 skills)
├── status/              ← Live project status
├── memory/              ← User profile + projects summary
├── tasks/               ← Shared triggers and task patterns
└── .opencode/           ← Rules & plugins (opencode integration)
```

## Project AGENTS.md Pattern

Each project's `AGENTS.md` is **ultra-thin** — contains only:
1. `## KB` section linking to the correct KB agent file
2. `## Local` section for project-specific notes (env files, status files)

All context lives in this KB.

## Skills Index

See [skills INDEX](skills/INDEX.md) for all 8 specialized skills:
- **update-md** — KB maintenance (sync project state to KB)
- **cleanup-project** — Project health (scan unused, health check)
- **code-review** — Code quality, bug detection, security, performance, best practices
- **kb-manage** — KB maintenance (frontmatter, index, sync)
- **frontend-dev** — Expert frontend engineering
- **design-skill-os** — Elite design reasoning (gestalt, 60-30-10, heuristics)
- **supabase-postgres-best-practices** — Postgres performance optimization
- **web-dev** — Modern web apps (semantic HTML5, CSS Grid/Flexbox, vanilla JS)
- **writer-work** — Content writing (summaries, changelogs, instructions)

## Cross-Project Triggers

| Trigger | truck | mcky.space | clientdata | habby | cafe |
|---------|-------|------------|------------|-------|------|
| `update kb` | ✅ | ✅ | ✅ | ✅ | ✅ |
| `update .md` | ✅ | ✅ | ✅ | ✅ | ✅ |
| `cleanup` | ✅ | ✅ | ✅ | ✅ | ✅ |
| `wrap-day` | ✅ | — | — | — | — |

`update .md` is an alias for `update kb` — both do the same thing (update centralized KB files in `~/AI-KB/`).

## Global Rules

- **No Chinese characters** in chat or code — Thai or English only
- Concise, direct responses — under 4 lines when possible
- Priority: read `INDEX.md` + project `AGENTS.md` + linked KB files before starting work
- All files use YAML frontmatter + Markdown body (OKF standard)
- Never update KB files unless explicitly told (via triggers above)
- Never commit or push unless told

## How AI Tools Should Use This

1. Read this file (`INDEX.md`) — understand the project roster and rules
2. Read `./AGENTS.md` in the project root you're working on
3. Follow the `## KB` links in that file to load full context
4. Read [user profile](memory/user-profile.md) for user preferences
5. Start working

See [INSTRUCTION.md](INSTRUCTION.md) for full usage guide and universal prompt.
