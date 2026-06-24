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
  - Client UI: Alpine.js via CDN (x-data/x-init patterns for interactivity)
  - Markdown: `marked` (lightweight, no React dependency)
  - Data Fetching: Plain fetch for all client data
  - API: Astro endpoints (8 routes in src/pages/api/)
  - Auth: SHA-256 password via Web Crypto API, header-based gating
  - Deployment: Vercel via @astrojs/vercel
routes:
  - path: / — Terminal sim homepage — Astro page (static HTML, CSS cursor blink)
  - path: /about — Terminal-style bio page (Astro static, pure HTML)
  - path: /blog — Blog — Astro page (static .md data, read-only)
  - path: /blog/[slug] — Blog post by slug — Astro dynamic page (read-only, .md source)
  - path: /habits — Habit tracker — Astro page + Alpine.js x-data (3 views: day, week, month)
  - path: /task — Todo list — Astro page + Alpine.js x-data (CRUD, priority, stats heatmap)
  - path: /projects — Project showcase (Astro static, pure HTML)
components:
  - habitsApp: Alpine.js data object — day/week/month views, toggle/delete/add habits
  - habitsStats: Alpine.js data object — overview stats (completion, streaks, DOW)
  - taskApp: Alpine.js data object — todo CRUD, priority cycling, list grouping, stats heatmap
  - require-auth.ts: Middleware — validates x-auth-hash header, returns 401/503
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
  - Alpine.js x-data + x-init for client-side interactivity (no React bundle)
  - `marked` for lightweight markdown rendering (no React dependency)
  - Plain fetch for all API calls (no SWR/React Query)
  - Astro static pages for non-interactive content (about, projects)
  - Blog .md compiled to TS at build time (no runtime filesystem access)
  - JetBrains Mono via CSS @import (Google Fonts)
  - CSS-only skeleton loading (.skel class with shimmer keyframe)
  - SHA-256 auth hash stored in localStorage as auth_hash
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
- Static pages (about, projects) are pure Astro HTML — no JS needed
- Interactive pages (habits, task) use Alpine.js x-data directives inline in .astro templates
- Blog is read-only — edit via Git (.md files + rebuild)
- All mutating API endpoints require `x-auth-hash` header (validated via `require-auth` middleware)
- No external API calls, no database (except Supabase for habits/todos/auth)
- Build: `npm run build` runs `prebuild` (blog index) + `astro build`
