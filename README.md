# AI-KB

Centralized knowledge base for all projects — agent profiles, status, user memory, task triggers.

## Structure

```
├── agents/       Agent profiles (project-a, project-b, project-c, writer)
├── status/       Centralized project status (replaces local STATUS.md)
├── memory/       User profile & projects summary
├── tasks/        Shared trigger definitions
└── workflow.md   Step-by-step instruction workflow
```

## Skills (OpenCode)

Tasks run via `~/.config/opencode/skills/`:

| Skill | Trigger | Action |
|-------|---------|--------|
| `update-md` | "update .md" | Sync status + agent files |
| `cleanup-project` | "cleanup" | Unused scan + health check |

| `writer-work` | "summarize" / "wrap-day" | Docs & changelogs |

## Projects

| Project | Stack | Path |
|---------|-------|------|
| project-a | React 19 + Vite 6 + Supabase | `~/project-a` |
| project-b | Next.js 14 | `~/project-b` |
| project-c | Next.js 16 + Neon | `~/project-c` |
