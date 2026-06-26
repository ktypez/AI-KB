---
type: usage
id: universal-usage
last_updated: 2026-06-23
---

# AI-KB Universal Usage

This knowledge base (`~/AI-KB/`) works with **any** AI coding tool — Cursor, Copilot, Windsurf, Cline, Continue.dev, OpenCode, Mimocode, etc.

## Directory Layout

```
~/AI-KB/
├── INDEX.md             ← Entry point — read first
├── USAGE.md             ← This file
├── agents/              ← Agent profiles (one per project)
│   ├── mcky-agent.md
│   ├── truck-agent.md
│   ├── clientdata-agent.md
│   └── writer-agent.md
├── skills/              ← Specialized skills (INDEX.md + 8 skills)
├── status/              ← Live project status
│   ├── mcky-status.md
│   ├── truck-status.md
│   └── clientdata-status.md
├── memory/              ← Shared user data
│   ├── user-profile.md
│   └── projects-summary.md
├── tasks/               ← Shared triggers & task patterns
├── blog/                ← KB internal notes
└── workflow.md
```

## Projects

| Project | Root | Agent Profile | Status |
|---------|------|---------------|--------|
| mcky.space | `~/mcky.space` | `~/AI-KB/agents/mcky-agent.md` | `~/AI-KB/status/mcky-status.md` |
| truck | `~/truck` | `~/AI-KB/agents/truck-agent.md` | `~/AI-KB/status/truck-status.md` |
| clientdata | `~/clientdata` | `~/AI-KB/agents/clientdata-agent.md` | `~/AI-KB/status/clientdata-status.md` |
| habby | `~/habby` | `~/AI-KB/agents/habby-agent.md` | `~/AI-KB/status/habby-status.md` |

Shared files used by all projects:
- `~/AI-KB/memory/user-profile.md` — user preferences (tone, language, style)
- `~/AI-KB/memory/projects-summary.md` — comparison across all projects

## Workflow

1. **Detect project** — look at cwd, find `./AGENTS.md` in project root
2. **Read INDEX.md** — `~/AI-KB/INDEX.md` for project roster + global rules
3. **Read AGENTS.md** — project root `./AGENTS.md` for KB links
4. **Follow links** — read every file in the `## KB` section
5. **Read user profile** — `~/AI-KB/memory/user-profile.md` for tone/style
6. **Start task** — you now have full context

## Universal Prompt

Copy the block below into your AI tool's custom instructions / system prompt:

---

You have access to a shared knowledge base at `~/AI-KB/`. Before any task:

1. Read `~/AI-KB/INDEX.md` — understand the project roster and global rules
2. Read `./AGENTS.md` in the current project root — follow its `## KB` links
3. Read every file linked in that `## KB` section — they contain full project context (architecture, components, routes, design system, conventions, recent changes)
4. Read `~/AI-KB/memory/user-profile.md` for user preferences
5. Start working

**Projects:**

| Project | Root | Agent | Status |
|---------|------|-------|--------|
| mcky.space | `~/mcky.space` | `~/AI-KB/agents/mcky-agent.md` | `~/AI-KB/status/mcky-status.md` |
| truck | `~/truck` | `~/AI-KB/agents/truck-agent.md` | `~/AI-KB/status/truck-status.md` |
| clientdata | `~/clientdata` | `~/AI-KB/agents/clientdata-agent.md` | `~/AI-KB/status/clientdata-status.md` |

Shared: `~/AI-KB/memory/user-profile.md`, `~/AI-KB/memory/projects-summary.md`

**Rules:**
- No Chinese characters — Thai or English only
- Concise, direct answers (< 4 lines when possible)
- Read INDEX.md + AGENTS.md + linked KB files before writing code
- Don't update KB files unless told (valid triggers: `update kb`, `update .md`, `cleanup`)
- Never commit or push unless told
- Don't create README or docs files unless asked

---

## Per-Tool Setup

Where to paste the universal prompt above:

| Tool | Where to put it |
|------|----------------|
| **Cursor** | `.cursorrules` in project root, or Settings > General > Custom Instructions |
| **GitHub Copilot** | `.github/copilot-instructions.md` in project root |
| **Windsurf** | `.windsurfrules` in project root |
| **Cline** | Settings > Custom Instructions (Markdown) |
| **Continue.dev** | `config.json` → `experimental.customInstructions` |
| **Mimocode** | Settings > Custom Instructions (global or per-project) |
| **OpenCode** | `~/.config/opencode/opencode.jsonc` → subagents config |
| **Any tool** | Instruct it at the start of every session |

### Per-Project AGENTS.md (already in place)

Each project root has an `AGENTS.md` with a `## KB` section. No setup needed — just point your AI tool to read it.

```
~/mcky.space/AGENTS.md     → links to mcky-agent.md + mcky-status.md
~/truck/AGENTS.md          → links to truck-agent.md + truck-status.md
~/clientdata/AGENTS.md     → links to clientdata-agent.md + clientdata-status.md
```

## KB Maintenance

| Trigger | Action |
|---------|--------|
| `update kb` or `update .md` | Re-read project state → update status + agent files in KB |
| `cleanup` | Scan unused files → build check → present findings → update KB |

Only update KB files when explicitly asked.
