# AI-Knowledge-Base

Centralized knowledge base for all AI-assisted projects — agent profiles, project status, user memory, and task triggers.

## Structure

```
├── agents/     Agent profiles (one per project + writer)
├── status/     Project status files (centralized, replaces local STATUS.md)
├── memory/     User profile and projects summary
├── tasks/      Shared triggers and task patterns
├── blog/       Blog posts
├── sync-watcher.sh   Daemon to sync to ~/storage/shared/AI-KB
└── sync-to-shared.sh One-shot sync script
```

## Projects

| Project | Framework | Path |
|---------|-----------|------|
| [truck](https://truck.ezzy.dev) | React 19 + Vite 6 + Supabase | `~/truck` |
| [mcky.space](https://mcky.space) | Next.js 14 | `~/mcky.space` |
| [clientdata](https://data.mcky.space) | Next.js 16 + Neon | `~/clientdata` |

## Usage

- `update .md` — Re-read project AGENTS.md + centralized status, update files
- `cleanup` — Scan unused files, health check, update status
- `สรุปวัน` — Daily changelog + status update (truck only)
