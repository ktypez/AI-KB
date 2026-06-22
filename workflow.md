---
type: workflow
id: kb-workflow
last_updated: 2026-06-22
---
# AI-KB Workflow

## 1. Quick Start
| You say | What happens |
|---------|-------------|
| "update .md" | Read AGENTS.md + KB status → update `status/<project>-status.md` → sync agent file |
| "cleanup" | Scan unused deps/files → health check → present findings → update status |
| "sync KB" | Validate frontmatter → update agent/task indexes → sync to shared storage |
| "summarize" | Read diff/status → write changelog or step-by-step docs |

## 2. Daily Workflow
**update .md** — Read project AGENTS.md + status file → read source files → update status (components/routes/data flow) → update agent file if patterns changed.

**cleanup** — Read project status → scan unused imports, console.log, TODO/FIXME → run health check (build/test/lint) → present findings → update status.

**sync KB** — Validate all .md files have YAML frontmatter (type, id, last_updated) → update AGENTS.md index → update tasks/overview.md → run `bash ~/AI-KB/sync-to-shared.sh`.

**summarize** — Read relevant KB files → write changelog or instructions per user's style rules.

## 3. Project-Specific Notes
- **truck** — React 19 + Vite 6 + Supabase PWA. Dev: `node node_modules/.bin/vite`. Build: `node node_modules/vite/bin/vite.js build`. Test: `node node_modules/.bin/vitest run`.
- **mcky.space** — Next.js 14 App Router + Pure CSS. Dev/build: `npm run dev` / `npm run build`.
- **clientdata** — Next.js 16 + Drizzle + Neon. Dev: `npm run dev` (port 3002). Deploy: `node /path/to/vercel --prod`.

## 4. Communication Rules
- Thai or English only — no Chinese anywhere
- Concise, direct — under 4 lines when possible
- Skip intros ("I'll help you with...")
- Use contractions (I'll, don't)
- No emojis unless asked
- Answer first, then act

## 5. KB Structure
| Directory | Role |
|-----------|------|
| `agents/` | Agent profiles (one per project + writer). AGENTS.md is the index. |
| `status/` | Centralized project status — replaces local STATUS.md. |
| `memory/` | User profile + projects summary (stack, commands). |
| `tasks/` | Shared trigger definitions. Update when adding/removing triggers. |

Auto-sync: `sync-watcher.sh` daemon syncs to `~/storage/shared/AI-KB` automatically.
