---
last_updated: 2026-06-24T23:30
project: mcky.space
type: status
---

# Project Status — mcky.space

## Routes

| Path | Status | Description |
|------|--------|-------------|
| `/` | ✅ Live | Terminal sim homepage — instant render, CSS cursor blink |
| `/about` | ✅ Live | About page with terminal-style bio (pure HTML + React island) |
| `/blog` | ✅ Live | Blog listing — Astro page + BlogApp React island (SWR, read-only) |
| `/blog/[slug]` | ✅ Live | Blog post by slug — Astro dynamic page + BlogPostApp (read-only, .md source) |
| `/habits` | ✅ Live | Habit tracker (3 views: day, week, month) |
| `/task` | ✅ Live | Todo list with stats heatmap |
| `/projects` | ✅ Live | Project showcase (pure HTML + React island) |

## Tech Stack

- **Framework:** Astro 7.0.2 (server output, Vercel adapter)
- **Language:** TypeScript
- **Styling:** Pure CSS via `globals.css` (no Tailwind classes used)
- **Font:** JetBrains Mono via Google Fonts CSS `@import`
- **Data:** Supabase (habits, todos, auth); blog from `.md` files (no Supabase dependency)
- **Markdown:** `marked` (lightweight, no React dependency)
- **Data Fetching:** Plain fetch for all client data
- **Client UI:** Alpine.js via CDN (`x-data`/`x-init` patterns for interactivity)
- **API:** Astro endpoints (8 routes in `src/pages/api/`)
- **Auth:** Password via SHA-256 hash in `app_config` table, Web Crypto API, header-based auth gating
- **Blog:** `.md` files in `src/data/blog/` compiled to TypeScript at build time via `scripts/build-blog-posts.mjs`
- **Deployment:** Vercel via `@astrojs/vercel`

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
| `habitsApp()` | Alpine.js data object — day/week/month views, toggle/delete/add habits |
| `habitsStats()` | Alpine.js data object — overview stats (completion, streaks, DOW) |
| `taskApp()` | Alpine.js data object — todo CRUD, priority cycling, list grouping, stats |
| `require-auth.ts` | Middleware — validates `x-auth-hash` header, returns 401/503 |
| `fetchWithAuth` | Utility that attaches `x-auth-hash` header to mutating requests |

## API Endpoints

| Route | Method | Auth Required | Purpose |
|-------|--------|---------------|---------|
| `/api/auth` | POST | No | Password verification, returns `hash` on success |
| `/api/blog` | GET | No | List all blog posts (from .md data) |
| `/api/blog/[slug]` | GET | No | Get single blog post by slug (from .md data) |
| `/api/habits` | GET | No | Get habits data for a date |
| `/api/habits` | POST | Yes | Create habit or seed initial data |
| `/api/habits/[id]` | PATCH | Yes | Update habit definition |
| `/api/habits/[id]` | DELETE | Yes | Delete habit definition |
| `/api/habits/toggle` | POST | Yes | Toggle habit check for a date |
| `/api/habits/stats` | GET | No | Week/month/habit stats |
| `/api/todos` | GET | No | List all todos |
| `/api/todos` | POST | Yes | Create todo (field-whitelisted) |
| `/api/todos/[id]` | PATCH | Yes | Update todo (field-whitelisted) |
| `/api/todos/[id]` | DELETE | Yes | Delete todo |

## Recent Updates

- `2026-06-24` — **Cleanup: removed stale `.next/` directory and unused `@napi-rs/wasm-runtime` dep** (leftover from old Next.js setup).
- `2026-06-24` — **Update: refreshed `/projects` page** with current stack info across all 3 projects (mcky.space stack → Astro 7/Alpine.js, renamed "data" → "clientdata", added route planning & OT calc features).
- `2026-06-24` — **Code review fixes**. Fixed `perfectDays`→`greenDays` in habit stats (was rendering `undefined`). Fixed month view DOW calc to use `T12:00:00` (DST-safe). Added missing `aggRes` error check in `buildHabitsData`. Simplified `goToDate` to use `d.date` directly. Replaced all bare `catch {}` with `console.warn` in habits + task Alpine apps. Added Supabase error check in `require-auth.ts` (returns 503 on outage).
- `2026-06-24` — **Security: auth gating on all mutating API endpoints**. Created `require-auth.ts` middleware (checks `x-auth-hash` header). Applied to all POST/PATCH/DELETE on habits and todos. Added `ALLOWED_FIELDS` whitelist to todos endpoints. Login now stores SHA-256 hash in localStorage as `auth_hash` (not `'1'`). Created `fetchWithAuth` utility — client components use it for mutating requests.
- `2026-06-24` — **Chore: code review fixes**. Added `prebuild` hook for blog index generation. Removed dead `@astrojs/node` dep. Renamed `PostNavNoNext` → `PostNav` with fixed fetcher error handling. Removed old `AuthPrompt.tsx`.
- `2026-06-24` — **Fix: page-level React islands instead of slot children**. Slot children in React islands render as static HTML (no hydration). Created `BlogPage`, `HabitsPage`, `TaskPage`, `HomePage`, `BlogPostPage` — each wraps `Providers` + page content directly in the React tree. Removed `Providers` from `Layout.astro`. Static pages (about, projects) use `Providers client:load` directly since their content is pure HTML.
- `2026-06-24` — Fix: login after Astro migration — replaced Node.js `crypto` with Web Crypto API (`crypto.subtle.digest`) for Vercel compatibility. Added `PUBLIC_SUPABASE_*` env vars to Vercel, removed old `NEXT_PUBLIC_*` ones.
- `2026-06-24` — Fix: login broken after RLS policy restricted `app_config` to `public_feature_flag` only — reverted to `USING (true)` since password is SHA-256 hashed
- `2026-06-24` — **Migration: Next.js 14 → Astro 7**. Full rewrite of build system, routing, layouts, and API endpoints. All 12 API routes ported to `astro:APIRoute` pattern. 7 pages converted to `.astro` with React islands. Vercel adapter replaces Node adapter. Env vars renamed from `NEXT_PUBLIC_` to `PUBLIC_`.
- `2026-06-24` — **Blog: migrated from Supabase to .md files**. Blog posts stored as `.md` files with YAML frontmatter in `src/data/blog/`. `scripts/build-blog-posts.mjs` compiles them into `src/data/blog/index.ts` at build time for Vercel bundling. All blog CRUD API routes removed — read-only. URLs use `/blog/[slug]` instead of `/blog/[id]`.

## Known Issues

- `_ld()` helper duplicated in both `habits.astro` and `task.astro` inline scripts — minor, could be hoisted to Layout

## Upcoming

- None
