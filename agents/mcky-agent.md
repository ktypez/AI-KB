---
type: agent
id: mcky-agent
project: mcky.space
last_updated: 2026-06-24
status_ref: STATUS.md in project root
personality: terminal hipster
stack:
  - Astro 7.0.2 (server output, Vercel adapter)
  - TypeScript
  - Pure CSS (globals.css, no Tailwind classes)
  - JetBrains Mono via Google Fonts CSS @import
  - Supabase (habits/todos/auth)
  - Blog: .md files compiled to TypeScript at build time (no Supabase dependency)
  - React 18 islands via @astrojs/react
  - react-markdown + remark-gfm + remark-breaks (client island)
  - SWR (blog data fetching)
  - Auth: SHA-256 password via Web Crypto API, header-based gating
  - Deployment: Vercel via @astrojs/vercel
routes:
  - path: / — Terminal sim homepage — Astro page + TerminalStatic React island
  - path: /about — Terminal-style bio page (Astro static + React island)
  - path: /blog — Blog — Astro page + BlogApp React island (SWR, read-only)
  - path: /blog/[slug] — Blog post by slug — Astro dynamic page + BlogPostApp (read-only, .md source)
  - path: /habits — Habit tracker — Astro page + HabitsPage React island
  - path: /task — Todo list — Astro page + TaskPage React island
  - path: /projects — Project showcase (Astro static + React island)
components:
  - TerminalStatic: Homepage terminal — Astro client:load island
  - BlogApp: Blog listing — SWR, read-only
  - BlogPostApp: Blog post view — SWR, Markdown rendering, PostNav
  - HabitsTab: Habit day/week/month views — HabitRow (memo), SectionBlock (memo), ViewModeBar
  - StatsTab: Weekly/monthly/habit-level stats
  - TaskApp: Todo list with heatmap — TodoRow (memo), period stats
  - PostNav: Prev/next blog navigation (SWR, renamed from PostNavNoNext)
  - FloatingButtons: Theme toggle + nav — client:only="react"
  - Markdown: Direct import for blog body rendering
  - Providers: ThemeProvider + AuthProvider + FloatingButtons
  - HomePage / BlogPage / BlogPostPage / HabitsPage / TaskPage: Page-level React islands wrapping Providers + content
  - fetchWithAuth: Utility that attaches x-auth-hash header on mutating requests
commands:
  dev: npm run dev
  build: npm run build (runs prebuild hook for blog index first)
  build-blog: node scripts/build-blog-posts.mjs
  start: npm run start
  lint: Not configured (pure CSS, no framework lint)
triggers:
  "update .md": Read STATUS.md + AGENTS.md, update routes/components/design → sync KB
  "cleanup": Scan unused → build check → present findings → update docs
perf_patterns:
  - Conditional render (tab === 'x' && ...) instead of display:none
  - React.memo for list items (HabitRow, TodoRow, SectionBlock)
  - useMemo for derived/computed data (openCount, rate, heatMap, periodStats)
  - useCallback for event handlers passed as props
  - Astro client:load / client:only directives for React islands
  - JetBrains Mono via CSS @import (Google Fonts)
  - SWR for data fetching with caching/dedup
  - Blog .md compiled to TS at build time (no runtime filesystem access)
---

# mcky.space Agent

## Design System
- Dark theme `#0a0e14` → `#15141b` (Aura)
- Accent colors: purple, mint, peach, blue, pink
- CSS variables in `:root` — no magic numbers
- Terminal/retro aesthetic
- 2px dashed terminal-style page dividers

## Triggers

### "update .md"
1. Read project AGENTS.md + current KB status
2. Update `~/AI-KB/status/mcky-status.md` with latest changes
3. Update `~/AI-KB/agents/mcky-agent.md` (routes, components, design system)
4. If project AGENTS.md has stale info, update it too

### "cleanup"
1. Scan unused files, empty files, dead exports in `src/`
2. Health check: `npm run build` (runs prebuild + astro build)
3. Deep scan: leftover dirs, `console.log`, TODO/FIXME
4. Present findings for user to choose
5. Commit & Push if user says so
6. Update STATUS.md + KB agent file
7. Never cleanup `.env*`, `node_modules/`, `dist/`, `.next/`, `.git/`, or essential config

## Agent Guidelines
| Rule | Value |
|------|-------|
| Tone | Concise, direct, casual — like chatting with a buddy |
| Style | Contractions (I'll, don't), no emojis unless asked |
| Language | Thai or English only |
| Behavior | Answer first, then act |

- Prioritize reference design when given
- New routes must match existing terminal style exactly
- Static pages (about, projects) are pure HTML + `<Providers client:load>` island
- Interactive pages use page-level React islands wrapping Providers + content directly
- Blog is read-only — edit via Git (.md files + rebuild)
- All mutating API endpoints require `x-auth-hash` header (validated via `require-auth` middleware)
- No external API calls, no database (except Supabase for habits/todos/auth)
- Build: `npm run build` runs `prebuild` (blog index) + `astro build`
