---
type: skill
id: update-md
last_updated: 2026-06-26
source: ~/.config/opencode/skills/update-md/SKILL.md
category: kb-maintenance
projects: [truck, mcky.space, clientdata, habby]
---

# update-md Skill

**Purpose:** Read project AGENTS.md + KB status, update KB with latest project changes.

## Trigger
`update .md` or `update kb` — all projects

## Workflow
1. Determine project from context (cwd, conversation)
2. Read project's `AGENTS.md` + `~/AI-KB/status/<project>-status.md`
3. Read `~/AI-KB/agents/<project>-agent.md` for trigger instructions
4. Read `~/AI-KB/status/_template.md` to confirm section order
5. Update sections in `~/AI-KB/status/<project>-status.md`:
   - Stack, Routes, Components, API (if applicable), Design System, Data Model
   - Changelogs (from git log), PWA, Tests, Known Issues
6. Sync `~/AI-KB/agents/<project>-agent.md` if architecture, patterns, or stack changed

## Status File Structure (all projects)

Every status file `~/AI-KB/status/<project>-status.md` must have these sections (empty if N/A):

1. Current State
2. Stack
3. Routes
4. Components
5. API
6. Design System
7. Data Model
8. Changelog
9. PWA
10. Tests
11. Known Issues

See `~/AI-KB/status/_template.md` for the exact format.

## Per-Project

| Project | Stack | Notes |
|---------|-------|-------|
| truck | React 19 + Vite 8 + Supabase | PWA, 16 tests, edge functions |
| mcky.space | Astro 7 + Alpine.js | No PWA, no tests |
| clientdata | Next.js 16 + Drizzle + Neon | PWA, 16 tests |
| habby | Vite 6 + Express 5 + Redis | PWA, no tests |

(End of file - total 43 lines)