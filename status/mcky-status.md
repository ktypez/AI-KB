---
last_updated: 2026-06-26
project: mcky.space
type: status
---

# Project Status — mcky.space

## Routes

| Path | Status | Description |
|------|--------|-------------|
| `/` | ✅ Live | Neobrutalist homepage — terminal sim in neo-card, tech stack tags |
| `/about` | ✅ Live | About page — neo-cards for bio, stack badges, contact |
| `/blog` | ✅ Live | Blog listing — neo-card per post, badge dates |
| `/blog/[slug]` | ✅ Live | Blog post by slug — neo-styled content, code blocks with shadows |
| `/task` | ✅ Live | Todo list — Alpine.js x-data (CRUD, priority, stats in neo-cards) |
| `/projects` | ✅ Live | Project showcase — neo-cards with colored tags |
| Habits | 🔗 External | Sidebar + homepage link to habby.mcky.space (opens new tab) |

## Tech Stack

- **Framework:** Astro 7.0.2 (server output, Vercel adapter)
- **Language:** TypeScript
- **Styling:** Pure CSS via `globals.css` — Neobrutalism (thick borders, hard shadows, bright accents)
- **Font:** JetBrains Mono via Google Fonts (400–800 weights)
- **Data:** Supabase (todos, auth); blog from `.md` files; habits on habby.mcky.space
- **Markdown:** `marked` (lightweight, no React dependency)
- **Data Fetching:** Plain fetch for all client data
- **Client UI:** Alpine.js via CDN (`x-data`/`x-init` patterns for interactivity)
- **API:** Astro endpoints (8 routes in `src/pages/api/`)
- **Auth:** Password via SHA-256 hash in `app_config` table, Web Crypto API, header-based auth gating
- **Blog:** `.md` files in `src/data/blog/` compiled to TypeScript at build time via `scripts/build-blog-posts.mjs`
- **Deployment:** Vercel via `@astrojs/vercel`

## Design System

- **Theme:** Neobrutalism — light default (`#f5f5f0` bg), dark mode supported
- **Borders:** 3px solid black (var `--border-w`)
- **Shadows:** Hard offset (`4px 4px 0` / `2px 2px 0`)
- **Colors:** Bright saturated accents — green `#06d6a0`, amber `#ffe066`, red `#ff6b6b`, blue `#4361ee`, purple `#9b5de5`, orange `#ff9f43`, pink `#ff6b9d`
- **Components:** `.neo-card` (cards with shadow), `.neo-tag` (colored labels), `.neo-badge` (inline chips)
- **CSS variables in `:root` — no magic numbers**
- **Skeleton loading:** `.skel` class with `shimmer` keyframe (CSS-only)
- **Dark mode:** Adapted neobrutalism palette (`#1a1a2e` bg, light borders)

## Components

| Component | Notes |
|-----------|-------|
| `taskApp()` | Alpine.js data object — todo CRUD, priority cycling, list grouping, stats |
| `require-auth.ts` | Middleware — validates `x-auth-hash` header, returns 401/503 |
| `fetchWithAuth` | Utility that attaches `x-auth-hash` header to mutating requests |

## API Endpoints

| Route | Method | Auth Required | Purpose |
|-------|--------|---------------|---------|
| `/api/auth` | POST | No | Password verification, returns `hash` on success |
| `/api/blog` | GET | No | List all blog posts (from .md data) |
| `/api/blog/[slug]` | GET | No | Get single blog post by slug (from .md data) |
| `/api/todos` | GET | No | List all todos |
| `/api/todos` | POST | Yes | Create todo (field-whitelisted) |
| `/api/todos/[id]` | PATCH | Yes | Update todo (field-whitelisted) |
| `/api/todos/[id]` | DELETE | Yes | Delete todo |

## Recent Updates

- `2026-06-26` — **Neobrutalism retheme**. Full visual overhaul — thick 3px black borders, hard offset shadows, bright saturated colors, `.neo-card`/`.neo-tag`/`.neo-badge` components. Light default theme with dark mode support. All pages updated.
- `2026-06-26` — **Remove habits redirect page + dead CSS**. Deleted `habits.astro`, removed 306 lines of unused habit tracker CSS (`.week-strip`, `.heatmap-*`, `.habit-row`, etc.). Sidebar + homepage link directly to habby.mcky.space (external, new tab).
- `2026-06-26` — **Habits moved to habby.mcky.space**. Habit tracking is now a standalone project.
- `2026-06-24` — **Cleanup: removed stale `.next/` directory and unused `@napi-rs/wasm-runtime` dep**.
- `2026-06-24` — **Code review fixes**. Fixed `perfectDays`→`greenDays`, month view DST-safe DOW calc, bare `catch` cleanup, Supabase 503 error check.
- `2026-06-24` — **Security: auth gating on all mutating API endpoints**. `require-auth.ts` middleware, SHA-256 hash in localStorage, `fetchWithAuth` utility.
- `2026-06-24` — **Migration: Next.js 14 → Astro 7**. Full rewrite of build system, routing, layouts, API endpoints.

## Known Issues

- `_ld()` helper duplicated in `task.astro` — minor, could be hoisted to Layout

## Upcoming

- None
