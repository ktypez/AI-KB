# AI-KB — Centralized Knowledge Base

Agent profiles, project status, user memory, task triggers, and skills for all projects.
Works with any AI tool (Cursor, Copilot, Windsurf, Cline, Continue.dev, OpenCode, etc.).

## Directory Layout

```
├── INDEX.md          Entry point — start here
├── INSTRUCTION.md    Usage guide (merged from USAGE.md + workflow.md)
├── agents/           Agent profiles (one per project + writer)
├── status/           Live project status (truck, mcky.space, clientdata, habby)
├── memory/           User profile + cross-project summary
├── skills/           Specialized skill files (update-md, cleanup-project, writer-work...)
├── tasks/            Shared trigger definitions
└── .opencode/        Rules & plugins
```

## Projects

| Project | Stack | Path |
|---------|-------|------|
| project-a | React 19 + Vite 8 + Supabase (PWA) | `~/project-a` |
| project-b | Astro 7 + TypeScript + Alpine.js (neobrutalist) | `~/project-b` |
| project-c | Next.js 16 + Drizzle + Neon | `~/project-c` |
| project-d | Vite 6 + Express 5 + Redis (gamification) | `~/project-d` |

## Skills

| Skill | Trigger | Action |
|-------|---------|--------|
| `update-md` | "update .md" | Sync status + agent files |
| `cleanup-project` | "cleanup" | Unused scan + health check |
| `writer-work` | "summarize" / "wrap-day" | Docs & changelogs |
