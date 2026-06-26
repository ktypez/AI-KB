---
type: instruction
id: kb-instruction
last_updated: 2026-06-26
title: INSTRUCTION
timestamp: 2026-06-26T17:55:38Z
---

# AI-KB Instruction Manual

This knowledge base (`~/AI-KB/`) is a portable, self-documenting system for AI coding agents. It works with **any** AI tool — Cursor, Copilot, Windsurf, Cline, Continue.dev, OpenCode, Mimocode, etc.

---

## 1. Directory Layout

```
~/AI-KB/
├── INDEX.md              ← Entry point — read first
├── INSTRUCTION.md        ← This file — how to use the KB
├── agents/               ← Agent profiles (one per project + writer)
│   ├── mcky-agent.md
│   ├── truck-agent.md
│   ├── clientdata-agent.md
│   ├── habby-agent.md
│   └── writer-agent.md
├── skills/               ← Specialized skills (INDEX.md + skills)
├── status/               ← Live project status
│   ├── mcky-status.md
│   ├── truck-status.md
│   └── clientdata-status.md
├── memory/               ← Shared user data
│   ├── user-profile.md
│   └── projects-summary.md
├── tasks/                ← Shared trigger definitions
└── workflow.md
```

| Directory | Role |
|-----------|------|
| `agents/` | Agent profiles — architecture, components, patterns, triggers |
| `status/` | Live project status — replaces local STATUS.md |
| `memory/` | User profile + projects summary (stack, commands) |
| `skills/` | Specialized skill files for complex tasks |
| `tasks/` | Shared trigger and task pattern definitions |

---

## 2. File Format — OKF (Open Knowledge Format)

Every file in this KB uses **OKF** — YAML frontmatter + Markdown body.

```yaml
---
type: <type>
id: <unique-id>
last_updated: <YYYY-MM-DD>
---
```

| Field | Required | Description |
|-------|----------|-------------|
| `type` | Yes | File category (instruction, index, agent-prompt, project-status, memory, skill, task) |
| `id` | Yes | Unique identifier for cross-referencing |
| `last_updated` | Yes | ISO date of last modification |
| Other fields | No | Type-specific metadata |

---

## 3. How Any AI Tool Should Use This

Before starting any task, follow this bootstrap flow:

1. **Detect project** — check current working directory, find `./AGENTS.md` in project root
2. **Read INDEX.md** — `~/AI-KB/INDEX.md` for project roster + global rules
3. **Read AGENTS.md** — project root `./AGENTS.md` for KB links
4. **Follow links** — read every file in the `## KB` section of AGENTS.md
5. **Read user profile** — `~/AI-KB/memory/user-profile.md` for tone/style preferences
6. **Start task** — you now have full context

---

## 4. Projects

| Project | Root | Agent Profile | Status |
|---------|------|---------------|--------|
| mcky.space | `~/mcky.space` | [mcky-agent](agents/mcky-agent.md) | [mcky-status](status/mcky-status.md) |
| truck | `~/truck` | [truck-agent](agents/truck-agent.md) | [truck-status](status/truck-status.md) |
| clientdata | `~/clientdata` | [clientdata-agent](agents/clientdata-agent.md) | [clientdata-status](status/clientdata-status.md) |
| habby | `~/habby` | [habby-agent](agents/habby-agent.md) | [habby-status](status/habby-status.md) |

Shared files used by all projects:
- [user profile](memory/user-profile.md) — tone, language, style preferences
- [projects summary](memory/projects-summary.md) — comparison across projects

---

## 5. AGENTS.md Pattern

Each project root has an ultra-thin `AGENTS.md` with only 2 sections:

- `## KB` — links to the correct KB agent file + status file
- `## Local` — project-specific notes (env files, status files)

All context lives in this KB. No duplication.

---

## 6. Triggers & Maintenance

| Trigger | Action |
|---------|--------|
| `update kb` or `update .md` | Read project state → update status file → sync agent profile in KB |
| `cleanup` | Scan unused files/deps → run health check → present findings → update status |
| `wrap-day` | Read git diff → add changelog entry → update status → commit (truck only) |

### Detailed workflow

**update .md**
1. Read project AGENTS.md + current status file
2. Read source files to discover changes (components, routes, data flow)
3. Update status file with latest state
4. Update agent profile if patterns changed

**cleanup**
1. Read project status
2. Scan unused imports, empty files, dead exports, `console.log`, TODO/FIXME
3. Run health check (build / test / lint / tsc)
4. Present findings for user to choose
5. Never touch `.env*`, `node_modules/`, `dist/`, `.next/`, `.git/`, or essential config

**wrap-day** (truck only)
1. Read `git diff` + `Changelog.tsx`
2. Add `vYYYY.MM.DD` entry with Thai summary
3. Update STATUS.md
4. `git add` + commit `"docs: wrap-day YYYY-MM-DD"`

---

## 7. Communication Rules

- Thai or English only — no Chinese characters anywhere
- Concise, direct responses — under 4 lines when possible
- Skip intros ("I'll help you with...")
- Use contractions (I'll, don't)
- No emojis unless explicitly asked
- Answer first, then act

---

## 8. Universal Prompt

Copy the block below into your AI tool's custom instructions / system prompt:

---

You have access to a shared knowledge base at `~/AI-KB/`. Before any task:

1. Read `~/AI-KB/INDEX.md` — understand the project roster and global rules
2. Read `./AGENTS.md` in the current project root — follow its `## KB` links
3. Read every file linked in that `## KB` section — they contain full context
4. Read `~/AI-KB/memory/user-profile.md` for user preferences
5. Start working

**Projects:**

| Project | Root | Agent | Status |
|---------|------|-------|--------|
| mcky.space | `~/mcky.space` | [agent](~/AI-KB/agents/mcky-agent.md) | [status](~/AI-KB/status/mcky-status.md) |
| truck | `~/truck` | [agent](~/AI-KB/agents/truck-agent.md) | [status](~/AI-KB/status/truck-status.md) |
| clientdata | `~/clientdata` | [agent](~/AI-KB/agents/clientdata-agent.md) | [status](~/AI-KB/status/clientdata-status.md) |
| habby | `~/habby` | [agent](~/AI-KB/agents/habby-agent.md) | [status](~/AI-KB/status/habby-status.md) |

Shared: `~/AI-KB/memory/user-profile.md`, `~/AI-KB/memory/projects-summary.md`

**Rules:**
- No Chinese characters — Thai or English only
- Concise, direct answers (< 4 lines when possible)
- Read INDEX.md + AGENTS.md + linked KB files before writing code
- Don't update KB files unless told (valid triggers: `update kb`, `update .md`, `cleanup`)
- Never commit or push unless told
- Don't create README or docs files unless asked

---

## 9. Per-Tool Setup

Where to paste the universal prompt:

| Tool | Location |
|------|----------|
| Cursor | `.cursorrules` in project root, or Settings > General > Custom Instructions |
| GitHub Copilot | `.github/copilot-instructions.md` in project root |
| Windsurf | `.windsurfrules` in project root |
| Cline | Settings > Custom Instructions (Markdown) |
| Continue.dev | `config.json` → `experimental.customInstructions` |
| Mimocode | Settings > Custom Instructions (global or per-project) |
| OpenCode | `~/.config/opencode/opencode.jsonc` → subagents config |
| Any tool | Instruct it at the start of every session |

Each project AGENTS.md already has a `## KB` section. No setup needed — just point your AI tool at it.

---

## 10. Migration

This KB is self-contained in `~/AI-KB/`. To migrate to a new machine or tool:

1. Copy `~/AI-KB/` to the target environment
2. Update any absolute paths (e.g., `~/AI-KB/` → new location)
3. Paste the universal prompt into your AI tool's custom instructions
4. Done — no other configuration needed
