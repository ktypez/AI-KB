---
type: skill
id: cleanup-project
last_updated: 2026-06-26
source: ~/.config/opencode/skills/cleanup-project/SKILL.md
category: project-health
projects: [truck, mcky.space, clientdata, habby]
---

# cleanup-project Skill

**Purpose:** Scan for unused deps/files, health check, present findings, update KB status.

## Trigger
`cleanup` — shared trigger for truck, mcky.space, clientdata

## Workflow
1. Determine project from `~/AI-KB/status/` (cwd, project name)
2. Read project's status file to identify stack
3. Run stack-specific cleanup steps

## Common Steps (All Projects)
1. Scan unused imports, empty files, dead exports
2. Deep scan: leftover dirs (`vite.log`, `.openclaude/`, stale logs), `console.log`, TODO/FIXME
3. Present findings for user to choose what to remove/fix
4. Commit & push only if user says so
5. Update `~/AI-KB/status/<project>-status.md` with cleanup results
6. **Never cleanup:** `.env*`, `node_modules/`, `dist/`, `.next/`, `.git/`, `out/`, essential config

## Per-Project Health Checks

### truck (React 19 + Vite 8 + TypeScript 6 + Supabase)
- Health check: `node node_modules/.bin/vitest run` + `node node_modules/vite/bin/vite.js build`

### mcky.space (Astro 7 + TypeScript + Pure CSS)
- Health check: `npm run build` (includes typecheck + lint)

### clientdata (Next.js 16 + Drizzle + Neon)
- Health check: `npm run lint` + `tsc --noEmit`

### habby (Vite 6 + Express 5 + Redis)
- Health check: `yarn build` (Vite build)

(End of file - total 46 lines)