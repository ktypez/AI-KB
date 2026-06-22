# AI-KB

Centralized knowledge base for all projects — agent profiles, status, user memory, task triggers.

## Structure

```
├── agents/       Agent profiles (truck, mcky, clientdata, writer)
├── status/       Centralized project status (replaces local STATUS.md)
├── memory/       User profile & projects summary
├── tasks/        Shared trigger definitions
├── workflow.md   Step-by-step instruction workflow
├── blog/         Blog posts
├── sync-watcher.sh   Daemon → ~/storage/shared/AI-KB
└── sync-to-shared.sh One-shot sync
```

## Skills (OpenCode)

Tasks run via `~/.config/opencode/skills/`:

| Skill | Trigger | Action |
|-------|---------|--------|
| `update-md` | "update .md" | Sync status + agent files |
| `cleanup-project` | "cleanup" | Unused scan + health check |
| `kb-manage` | "sync KB" | Validate, index, sync |
| `writer-work` | "summarize" | Docs & changelogs |

## Projects

| Project | Stack | Path |
|---------|-------|------|
| [truck](https://truck.mcky.space) | React 19 + Vite 6 + Supabase | `~/truck` |
| [mcky.space](https://mcky.space) | Next.js 14 | `~/mcky.space` |
| [clientdata](https://data.mcky.space) | Next.js 16 + Neon | `~/clientdata` |
