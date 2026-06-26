---
type: project-status
project: mcky.space
last_updated: 2026-06-26
id: mcky-status
title: mcky-status
timestamp: 2026-06-26T17:55:39Z
---

# Project Status — mcky.space

## Stack

- **Framework**: Astro 7.0.2 (server output, `@astrojs/vercel`)
- **Language**: TypeScript
- **Styling**: Pure CSS — neobrutalism (3px black borders, hard offset shadows, bright accents)
- **Font**: JetBrains Mono (Google Fonts, 400–800)
- **Data**: Supabase (todos, auth); blog from `.md` files; habits on habby.mcky.space
- **Markdown**: `marked` (lightweight, no React)
- **Client UI**: Alpine.js via CDN (`x-data`/`x-init` patterns)
- **Auth**: SHA-256 password in `app_config` table, Web Crypto API, header-based gating
- **Blog**: `.md` files in `src/data/blog/` → TypeScript at build via `scripts/build-blog-posts.mjs`

## Routes

| Path | Status | Description |
|------|--------|-------------|
| `/` | ✅ Live | Neobrutalist homepage — terminal sim in neo-card, tech stack tags |
| `/about` | ✅ Live | About page — neo-cards for bio, stack badges, contact |
| `/blog` | ✅ Live | Blog listing — neo-card per post, badge dates |
| `/blog/[slug]` | ✅ Live | Blog post by slug — neo-styled content, code blocks with shadows |
| `/task` | ✅ Live | Todo list — Alpine.js x-data (CRUD, priority, stats in neo-cards) |
| `/projects` | ✅ Live | Project showcase — neo-cards with colored tags |
| Habits | 🔗 External | Sidebar + homepage link to habby.mcky.space (new tab) |

## Components

| Component | Notes |
|-----------|-------|
| `taskApp()` | Alpine.js data object — todo CRUD, priority cycling, list grouping, stats |
| `require-auth.ts` | Middleware — validates `x-auth-hash` header, returns 401/503 |
| `fetchWithAuth` | Utility that attaches `x-auth-hash` header to mutating requests |

## API

| Route | Method | Auth Required | Purpose |
|-------|--------|---------------|---------|
| `/api/auth` | POST | No | Password verification, returns `hash` on success |
| `/api/blog` | GET | No | List all blog posts |
| `/api/blog/[slug]` | GET | No | Get single blog post by slug |
| `/api/todos` | GET | No | List all todos |
| `/api/todos` | POST | Yes | Create todo (field-whitelisted) |
| `/api/todos/[id]` | PATCH | Yes | Update todo (field-whitelisted) |
| `/api/todos/[id]` | DELETE | Yes | Delete todo |

## Design System

- **Theme**: Neobrutalism — light default (`#f5f5f0` bg), dark mode supported
- **Borders**: 3px solid black (`--border-w`)
- **Shadows**: Hard offset (`4px 4px 0` / `2px 2px 0`)
- **Colors**: Bright saturated accents — green `#06d6a0`, amber `#ffe066`, red `#ff6b6b`, blue `#4361ee`, purple `#9b5de5`, orange `#ff9f43`, pink `#ff6b9d`
- **Components**: `.neo-card` (shadow), `.neo-tag` (colored labels), `.neo-badge` (inline chips)
- **CSS variables** in `:root` — no magic numbers
- **Skeleton**: `.skel` class with `shimmer` keyframe (CSS-only)

## Data Model

### Todos
- Table: `todos` (Supabase) — id, text, done, priority, created_at, updated_at
- RLS: user owns own todos

### Auth
- Table: `app_config` — stores SHA-256 password hash
- Auth: password → SHA-256 → compare with stored hash → return session hash → header-based gating

## Changelog

### Week 2026-06-22
- **Neobrutalism retheme**: thick 3px borders, hard offset shadows, `.neo-card`/`.neo-tag`/`.neo-badge` components, light default + dark mode
- **Habits spun off**: removed `habits.astro` + 306 lines dead CSS, links now go directly to habby.mcky.space
- **Auth**: SHA-256 header gating on all mutating API endpoints (`require-auth` middleware)
- **Migration**: Next.js 14 → Astro 7 (build system, routing, layouts, API endpoints)
- **Fixes**: `perfectDays`→`greenDays`, DST-safe DOW calc, bare `catch` cleanup, Supabase 503 handling
- **Cleanup**: removed stale `.next/` + unused `@napi-rs/wasm-runtime`

### 2026-06-15
- Initial Astro 7 project setup with Alpine.js

## PWA

## Tests

## Known Issues

- `_ld()` helper duplicated in `task.astro` — minor, could be hoisted to Layout
