---
type: agent
id: mcky-agent
project: mcky.space
last_updated: 2026-06-22
status_ref: STATUS.md in project root
personality: terminal hipster
stack:
  - Next.js 14.2.5 (App Router, src/app/)
  - TypeScript
  - Pure CSS (globals.css, no Tailwind classes)
  - JetBrains Mono via next/font/google (was Google Fonts <link>)
  - localStorage (client-side only)
  - Supabase (blog posts)
  - react-markdown + remark-gfm + remark-breaks (dynamic import)
  - SWR (blog data fetching, replaces manual useEffect)
  - Deployment: Vercel
routes:
  - path: / — Terminal sim homepage with typewriter animation (dynamic import of TerminalAnimation)
  - path: /about — Terminal-style bio page (server component, no 'use client')
  - path: /blog — Blog with markdown support
  - path: /blog/[id] — Blog post page (SWR + dynamic Markdown)
  - path: /habits — Habit tracker (3 tabs: habits, stats, profile)
  - path: /task — Todo list (2 tabs: todos, stats)
  - path: /projects — Project showcase (server component, no 'use client')
components:
  - TerminalAnimation: Extracted from homepage, typewriter + blinking cursor
  - HabitRow: memo component from HabitsTab
  - SectionBlock: memo component from HabitsTab
  - ViewModeBar: extracted view-mode toggle from HabitsTab
  - TodoRow: memo component from task page
  - FloatingButtons: dynamic import (ssr: false)
  - Markdown: dynamic import (ssr: false)
commands:
  dev: npm run dev
  build: npm run build
  lint: Built into npm run build (Next.js checks)
triggers:
  "update .md": Read STATUS.md + AGENTS.md, update routes/components/design → sync KB
  "cleanup": Scan unused → build check → present findings → update docs
perf_patterns:
  - Conditional render (tab === 'x' && ...) instead of display:none
  - React.memo for list items (HabitRow, TodoRow, SectionBlock)
  - useMemo for derived/computed data (openCount, rate, heatMap, periodStats)
  - useCallback for event handlers passed as props
  - dynamic(() => import(...), { ssr: false }) for client-only components
  - next/font instead of external font link
  - SWR for data fetching with caching/dedup
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
1. Scan unused files, empty files, dead exports in `src/app/` and `src/components/`
2. Health check: `npm run build` (includes typecheck + lint)
3. Deep scan: leftover dirs, `console.log`, TODO/FIXME
4. Present findings for user to choose
5. Commit & Push if user says so
6. Update STATUS.md + KB agent file
7. Never cleanup `.env*`, `node_modules/`, `.next/`, `.git/`, or essential config

## Agent Guidelines
| Rule | Value |
|------|-------|
| Tone | Concise, direct, casual — like chatting with a buddy |
| Style | Contractions (I'll, don't), no emojis unless asked |
| Language | Thai or English only |
| Behavior | Answer first, then act |

- Prioritize reference design when given
- New routes must match existing terminal style exactly
- Static pages (about, projects) are server components — no `'use client'`
- Interactive pages use `dynamic(() => import(...), { ssr: false })` for client-only features
- All client components use inline state + localStorage
- No external API calls, no database
