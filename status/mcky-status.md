---
last_updated: 2026-06-23
project: mcky.space
type: status
---

# Project Status — mcky.space

## Routes

| Path | Status | Description |
|------|--------|-------------|
| `/` | ✅ Live | Terminal sim homepage — instant render, CSS cursor blink (no entrance animation) |
| `/about` | ✅ Live | About page with terminal-style bio (server component) |
| `/blog` | ✅ Live | Blog with markdown support (react-markdown + remark-gfm) — 8 posts |
| `/blog/[id]` | ✅ Live | Blog post page with SWR caching + dynamic Markdown |
| `/habits` | ✅ Live | Habit tracker (3 tabs: habits, stats) |
| `/task` | ✅ Live | Todo list with localStorage persistence (2 tabs: todos, stats) |
| `/projects` | ✅ Live | Project showcase with cat project.txt (server component) |

## Tech Stack

- **Framework:** Next.js 14.2.5 (App Router)
- **Language:** TypeScript
- **Styling:** Pure CSS via `globals.css` (no Tailwind classes used)
- **Font:** JetBrains Mono via `next/font/google` (was Google Fonts <link>)
- **Data:** localStorage (client-side only), Supabase (blog posts)
- **Markdown:** react-markdown + remark-gfm + remark-breaks (dynamic import)
- **Data Fetching:** SWR for blog posts (replaced manual useEffect fetch)
- **Deployment:** Vercel

## Design System

- Dark theme (Aura — `#15141b` bg)
- Accent colors: purple, mint, peach, blue, pink
- CSS variables in `:root` — no magic numbers
- Page headers use `2px dashed` terminal-style dividers
- All pages follow terminal/retro aesthetic
- Skeleton loading: `.skel` class with `shimmer` keyframe (CSS-only, theme-aware)

## Components

| Component | Notes |
|-----------|-------|
| `FloatingButtons` | Dynamic import (ssr: false) in layout — theme toggle + nav |
| `TerminalAnimation` | Homepage terminal — instant render, CSS-only cursor blink (no JS animation) |
| `Markdown` | Dynamic import (ssr: false) in blog/[id] |
| `HabitsTab` | Extracted sub-components: `HabitRow` (memo), `SectionBlock` (memo), `ViewModeBar` |
| `StatsTab` | Uses useMemo for computed stats, conditional render |
| `TodoRow` | New memo component extracted from task page |
| `AuthPrompt` | Auth gate for blog/task features |

## Recent Updates

- `2026-06-23` — Fix: added RLS policies for `todos` (ALL) and `app_config` (SELECT) for anon role in `setup.sql` — fixes 500 errors on /task CRUD ops when RLS is enabled on Supabase
- `2026-06-23` — UI: homepage instant render — removed all JS typewriter/stagger animation, replaced with pure CSS `@keyframes blink` cursor
- `2026-06-23` — UI: shimmer skeleton loading for HabitsTab and StatsTab (CSS-only `@keyframes shimmer`, `.skel` class)
- `2026-06-22` — Blog: new post "Making mcky.space faster" (ID 8)
- `2026-06-22` — Perf: massive refactor across all pages — conditional render, React.memo, useMemo, useCallback
- `2026-06-22` — Perf: replaced Google Fonts <link> with `next/font` (JetBrains_Mono)
- `2026-06-22` — Perf: dynamic imports for FloatingButtons (layout), Markdown (blog), TerminalAnimation (homepage)
- `2026-06-22` — Perf: SWR for blog/[id] page (caching + dedup)
- `2026-06-22` — Refactor: homepage typewriter animation extracted into `TerminalAnimation` component
- `2026-06-22` — Refactor: task page — TodoRow (memo), useMemo for all computed values, conditional render
- `2026-06-22` — Refactor: habits — HabitRow (memo), SectionBlock (memo), ViewModeBar, useCallback on all handlers
- `2026-06-22` — Cleanup: removed `.page`/`.visible` CSS classes (unused after conditional render)
- `2026-06-22` — Cleanup: removed unused `mounted` state from theme-context, `weekSet` from habits route, `barLen` from StatsTab
- `2026-06-22` — Chore: about & projects pages are now pure server components (no `'use client'`)
- `2026-06-21` — Style: switch to Aura color scheme (purple/mint/peach)
- `2026-06-21` — Feat: /projects route with cat project.txt terminal output
- `2026-06-21` — Style: page headers use 2px dashed terminal dividers
- `2026-06-21` — Fix: FloatingButtons background solid (removed transition all, added hover bg states)
- `2026-06-21` — Fix: blog textarea height 50vh → 60vh
- `2026-06-21` — Fix: habits terminal prompts user[pro] → init, @init.Habits → @habits
- `2026-06-20` — Feat: blog post editor (create, edit, delete) + habit data export
- `2026-06-20` — Feat: weekly/monthly view toggle in habits tracker
- `2026-06-20` — Feat: dark/light theme toggle with localStorage persistence
- `2026-06-20` — Feat: /about and /blog routes
- `2026-06-20` — Perf: habit tracker optimizations (parallel queries, aggregate logs, client cache)
- `2026-06-20` — Feat: /task route with full todo app
- `2026-06-20` — Feat: homepage + /habits route

## Known Issues

- None (build passes clean)

## Upcoming

- None
