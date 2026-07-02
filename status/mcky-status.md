---
type: project-status
project: mcky.space
last_updated: 2026-07-02
id: mcky-status
title: mcky-status
timestamp: 2026-07-02T00:00:00Z
---

# Project Status — mcky.space

## Stack

- **Framework**: Astro 7.0.2 (server output, `@astrojs/vercel`)
- **Language**: TypeScript
- **Styling**: Pure CSS — neobrutalism (3px borders, hard offset shadows, bright accents)
- **Font**: JetBrains Mono (self-hosted WOFF2 variable font, 400–800, `font-display:swap`)
- **Data**: Supabase (auth); blog from `.md` files; habits on habby.mcky.space
- **Markdown**: `marked` (lightweight, no React)
- **Client UI**: Alpine.js via CDN (`x-data`/`x-init` patterns)
- **Auth**: SHA-256 password, Web Crypto API, header-based gating
- **Blog**: `.md` files in `src/data/blog/` → TypeScript at build via `scripts/build-blog-posts.mjs`
- **Deployment**: Vercel with cache headers + security headers

## Routes

| Path | Status | Description |
|------|--------|-------------|
| `/` | ✅ Live | Terminal-style homepage — neo-card with terminal sim, tech stack tags |
| `/about` | ✅ Live | About page — neo-cards for bio, stack badges, contact |
| `/blog` | ✅ Live | Blog listing — neo-card per post, badge dates, empty state |
| `/blog/[slug]` | ✅ Live | Blog post by slug — neo-styled content, prev/next nav |
| `/projects` | ✅ Live | Project showcase — neo-cards with colored tags, empty state |
| `/404` | ✅ Live | Styled 404 page with terminal prompt |
| Habits | 🔗 External | Sidebar + homepage link to habby.mcky.space (new tab) |

## Components

| Component | File | Notes |
|-----------|------|-------|
| `PageHeader` | `src/components/PageHeader.astro` | Reusable page header with back link + title |
| `TerminalLine` | `src/components/TerminalLine.astro` | Reusable terminal prompt line |
| `Layout` | `src/layouts/Layout.astro` | Base layout with sidebar, noscript, theme toggle |

## Responsive Design

| Breakpoint | Behavior |
|------------|----------|
| `<768px` | Mobile-first: sidebar hidden, top-nav, 560px max-width |
| `≥768px` | Sidebar visible (220px), app borders removed |
| `≥1024px` | Wider padding (32px), fluid typography (clamp) |
| `≥1440px` | Max-width container (720px), wider sidebar (260px) |

## Accessibility

- `:focus-visible` on all interactive elements (2px solid outline)
- `prefers-reduced-motion` disables all animations
- Button press `:active` with `scale(0.97)`
- Touch targets: `.t-prio` ~43px, `.t-del` ~33px
- ARIA: `role="navigation"` on sidebar, `role="main"` on content
- `viewport-fit=cover` + `env(safe-area-inset-*)` for notched devices

## Design System

- **Theme**: Neobrutalism — light default (`#f5f5f0` bg), dark mode via `[data-theme="dark"]`
- **Borders**: 3px solid `var(--border)`
- **Shadows**: Hard offset (`4px 4px 0` / `2px 2px 0`)
- **Colors**: CSS custom properties — green, amber, red, blue, purple, orange, cyan, pink
- **Components**: `.neo-card` (shadow), `.neo-tag` (labels), `.neo-badge` (chips), `.stub` (empty state)
- **CSS variables** in `:root` — no hardcoded values outside tokens
- **Skeleton**: `.skel` class with `shimmer` keyframe (CSS-only)

## API

| Route | Method | Auth Required | Purpose |
|-------|--------|---------------|---------|
| `/api/auth` | POST | No | Password verification, returns `hash` on success |

## Performance

- Self-hosted fonts (no CDN round-trip)
- Vercel immutable cache for `/fonts/` and `/_astro/`
- Security headers: X-Content-Type-Options, X-Frame-Options, Referrer-Policy
- CSS containment on `.neo-card` and `.todo-row`
- `<noscript>` fallback for JS-disabled browsers

## SEO

- Open Graph: og:title, og:description, og:type, og:url
- Twitter Card: twitter:card, twitter:title, twitter:description
- Theme color: light (#f5f5f0) and dark (#1a1a2e)

## Changelog

### 2026-07-02 — Blog post, DESIGN.md docs, cleanup
- **Blog**: Published "Project Updates: Component Extraction & Design System"
- **Docs**: DESIGN.md updated to match actual CSS tokens + full Phase 1-4 docs
- **Cleanup**: Removed dead `/task` nav link, unreachable CSS, consolidated focus-visible
- **SEO**: Added `og:url` meta tag
- **Plans**: Added implementation plan docs for all 5 phases

### 2026-07-01 — Responsive Redesign (5 phases, 27 commits)
- **Phase 1 Foundation**: Self-hosted JetBrains Mono, extracted PageHeader/TerminalLine, safe-area insets, 44px touch targets, focus-visible, 100dvh, organized CSS
- **Phase 2 Responsive**: 1024px/1440px breakpoints, fluid typography (clamp), CSS containment
- **Phase 3 Interaction**: Button press animation, prefers-reduced-motion, 404 page, empty states
- **Phase 4 Content & Perf**: Vercel cache/security headers, ARIA landmarks, OG/Twitter meta tags
- **Phase 5 Polish**: Noscript fallback, CSS audit, DESIGN.md updated

### 2026-06-22
- Neobrutalism retheme, auth middleware, Astro 7 migration

### 2026-06-15
- Initial Astro 7 project setup with Alpine.js

## Known Issues

- Alpine.js loaded from CDN (intentional per stack definition)
- Dev server broken locally (shiki module corruption) — works on Vercel
- `npm install` breaks android-arm64 native binding — do not delete node_modules
