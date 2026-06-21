---
type: blog
id: centralizing-project-knowledge-with-okf
published: 2026-06-21
tags: [OKF, knowledge-base, agents, workflow]
---

# Centralizing Project Knowledge with Open Knowledge Format (OKF)

## How we consolidated 3 projects into a single AI-readable knowledge base

### The Problem

Three projects. Each with its own `AGENTS.md`, `STATUS.md`, and scattered context. Information was duplicated, inconsistent, and hard to maintain. When one project's stack changed, we had to remember to update the others.

Worse — onboarding an AI agent to work on a project meant re-reading the same patterns across different files with slightly different phrasing.

### The Solution: Open Knowledge Format (OKF)

We designed **OKF** — a directory-based knowledge system using Markdown files with YAML frontmatter. Every file has structured metadata (`type`, `id`, `last_updated`) followed by human-readable Markdown.

```
AI-Knowledge-Base/
├── agents/          ← Agent profiles (stack, commands, patterns, triggers)
│   ├── AGENTS.md    ← Registry index
│   ├── project-a-agent.md
│   ├── project-b-agent.md
│   └── project-c-agent.md
├── memory/          ← User profile + cross-project comparison
│   ├── user-profile.md
│   └── projects-summary.md
├── tasks/           ← Shared triggers & workflows
│   └── overview.md
└── blog/            ← Posts about the system itself
    └── this-file.md
```

### Step 1: Consolidate

We read `AGENTS.md` and `STATUS.md` from all three projects and extracted their essence into dedicated agent profile files under `AI-Knowledge-Base/agents/`. Each profile captures:

- **Stack & tooling** (frameworks, databases, deployment)
- **Directory structure** with responsibilities
- **Key patterns** (auth, theming, state management)
- **Project-specific triggers** (`update .md`, `cleanup`)
- **Environment variables** (without exposing values)

### Step 2: Thin the Projects

Each project's `AGENTS.md` was reduced to ~5 lines — just a reference to the central KB:

```markdown
# Project Name

## KB
- `~/AI-Knowledge-Base/agents/project-x-agent.md` — full context
- `~/AI-Knowledge-Base/memory/user-profile.md` — preferences
```

All operational context now lives in one place. When an AI opens a project, it reads the thin file, follows the link, and gets everything it needs.

### Step 3: Standardize Triggers

We normalized two core triggers across all projects:

| Trigger | Action |
|---------|--------|
| `update .md` | Re-read STATUS.md → update from latest state → sync back to KB |
| `cleanup` | Scan unused → health check → present findings → update STATUS.md + KB |

Each project's tooling is respected:
- **Project A** (React + Vite) runs `tsc --noEmit` + `vitest` + `eslint`
- **Project B** (Next.js 14) runs `npm run build` (built-in checks)
- **Project C** (Next.js 16 + Drizzle) runs `npm run lint` + `tsc --noEmit`

### Step 4: Auto-Sync to Shared Storage

Since the platform's filesystem doesn't support symlinks, we built a lightweight watcher daemon using `inotifywait`. It monitors the KB directory and syncs changes to a shared folder automatically. Starts on boot via platform init scripts.

### Results

- **Single source of truth** — one `update .md` now updates STATUS.md AND the central KB
- **Consistent AI behavior** — every agent reads the same user-profile, same rules
- **Ultra-thin project files** — AGENTS.md is now 5–9 lines per project
- **Cross-project visibility** — `memory/projects-summary.md` compares all 3 side-by-side
- **Auto-synced** — changes propagate to shared storage automatically

### Lessons

1. **YAML frontmatter is worth it** — it makes metadata machine-parseable while keeping files human-readable
2. **Centralization demands discipline** — when you update a project, remember to sync the KB
3. **Thin AGENTS.md forces you to keep KB clean** — if the KB is messy, the thin file loses its value
