---
last_updated: 2026-06-21
project: mcky.space
type: status
---

# Project Status — mcky.space

## Routes

| Path | Status | Description |
|------|--------|-------------|
| `/` | ✅ Live | Terminal sim homepage with typewriter animation |
| `/about` | ✅ Live | About page with terminal-style bio |
| `/blog` | ✅ Live | Blog with markdown support (react-markdown + remark-gfm) |
| `/habits` | ✅ Live | Habit tracker (3 tabs: habits, stats, profile) |
| `/task` | ✅ Live | Todo list with localStorage persistence (3 tabs) |
| `/projects` | ✅ Live | Project showcase with cat project.txt |

## Tech Stack

- **Framework:** Next.js 14.2.5 (App Router)
- **Language:** TypeScript
- **Styling:** Pure CSS via `globals.css` (no Tailwind classes used)
- **Font:** JetBrains Mono (Google Fonts)
- **Data:** localStorage (client-side only), Supabase (blog posts)
- **Markdown:** react-markdown + remark-gfm + remark-breaks
- **Deployment:** Vercel

## Design System

- Dark theme (Aura — `#15141b` bg)
- Accent colors: purple, mint, peach, blue, pink
- CSS variables in `:root` — no magic numbers
- Page headers use `2px dashed` terminal-style dividers
- All pages follow terminal/retro aesthetic

## Recent Updates

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
- `2026-06-20` — Fix: remove emojis from UI, fix JSX build errors
- `2026-06-20` — Feat: /task route with full todo app
- `2026-06-20` — Feat: homepage + /habits route

## Known Issues

- None (all recent build issues resolved)

## Upcoming

- None
