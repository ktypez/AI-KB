---
type: agent-prompt
id: mcky-agent
project: mcky.space
last_updated: 2026-07-01
status_ref: ~/AI-KB/status/mcky-status.md
personality: terminal hipster
stack:
  - Astro 7.0.2 (server output, Vercel adapter)
  - TypeScript
  - Pure CSS — Neobrutalism (globals.css, no Tailwind)
  - JetBrains Mono (self-hosted WOFF2 variable font, font-display:swap)
  - Supabase (auth) — habits on habby.mcky.space
  - Blog: .md files compiled to TypeScript at build time
  - Client UI: Alpine.js via CDN (x-data/x-init patterns)
  - Markdown: `marked` (lightweight, no React dependency)
  - Deployment: Vercel via @astrojs/vercel
  - Cache: immutable for /fonts/ and /_astro/
  - Security: X-Content-Type-Options, X-Frame-Options, Referrer-Policy
components:
  - PageHeader: Reusable page header with back link + title
  - TerminalLine: Reusable terminal prompt line
  - Layout: Base layout with sidebar, noscript, theme toggle
commands:
  dev: npm run dev
  build: npm run build (runs prebuild hook for blog index first)
  build-blog: node scripts/build-blog-posts.mjs
  start: npm run start
  test: Not configured (skip tests)
  lint: Not configured (pure CSS, no framework lint)
triggers:
  "update .md": Read STATUS.md + AGENTS.md, update routes/components/design → sync KB
  "cleanup": Scan unused → present findings → update docs
---

# mcky.space Agent

## Overview

Terminal-style personal website on mcky.space. Neobrutalist design with responsive layout (320px–1440px+), Alpine.js interactivity, Astro 7 server output, and SHA-256 auth.

## Stack

| Layer | Tech |
|-------|------|
| Framework | Astro 7.0.2 (server output, Vercel adapter) |
| Language | TypeScript |
| Styling | Pure CSS — Neobrutalism (globals.css) |
| Font | JetBrains Mono (self-hosted WOFF2 variable font) |
| Database | Supabase (auth) |
| Blog | .md files compiled to TS at build time |
| Client UI | Alpine.js via CDN (x-data/x-init patterns) |
| Markdown | `marked` |
| Auth | SHA-256 via Web Crypto API, header-based gating |
| Deployment | Vercel with cache + security headers |

## Architecture

| Route | Description |
|-------|-------------|
| `/` | Terminal-style homepage — neo-card with terminal sim, tech stack tags |
| `/about` | About page — neo-cards for bio, stack badges, contact |
| `/blog` | Blog listing — neo-card per post, badge dates, empty state |
| `/blog/[slug]` | Blog post — neo-styled content, prev/next nav |
| `/projects` | Project showcase — neo-cards with colored tags, empty state |
| `/404` | Styled 404 page with terminal prompt |
| `habby.mcky.space` (external) | Sidebar + homepage link (new tab) |

## Responsive Breakpoints

| Breakpoint | Behavior |
|------------|----------|
| `<768px` | Mobile-first: sidebar hidden, top-nav, 560px max-width |
| `≥768px` | Sidebar visible (220px), app borders removed |
| `≥1024px` | Wider padding (32px), fluid typography |
| `≥1440px` | Max-width container (720px), wider sidebar (260px) |

## Key Patterns

- Alpine.js x-data + x-init for client-side interactivity (no React bundle)
- `marked` for lightweight markdown rendering (no React dependency)
- Astro static pages for non-interactive content (about, projects)
- Blog .md compiled to TS at build time (no runtime filesystem access)
- CSS-only skeleton loading (.skel class with shimmer keyframe)
- SHA-256 auth hash stored in localStorage as auth_hash
- Self-hosted fonts with font-display:swap (no external CDN)
- prefers-reduced-motion for all animations
- :focus-visible on all interactive elements
- ARIA landmarks on navigation and main content
- env(safe-area-inset-*) for notched device support

### Design System

- **Neobrutalism** — light default (`#f5f5f0` bg), dark mode via `[data-theme="dark"]`
- Thick 3px borders, hard offset shadows (`4px 4px 0`)
- Bright saturated accents: green, amber, red, blue, purple, orange, cyan, pink
- Components: `.neo-card` (shadow cards), `.neo-tag` (colored labels), `.neo-badge` (inline chips), `.stub` (empty state)
- CSS variables in `:root` — no magic numbers
- JetBrains Mono self-hosted WOFF2 variable font
- Fluid typography via clamp() for h1, h2
- CSS containment on .neo-card and .todo-row

## Commands

| Command | What it does |
|---------|-------------|
| `npm run dev` | Dev server |
| `npm run build` | Build (prebuild blog index + astro build) |
| `node scripts/build-blog-posts.mjs` | Build blog index manually |
| `npm run start` | Start production server |
| test | Not configured (skip tests) |
| lint | Not configured (pure CSS, no framework lint) |

## Triggers

### "update .md"

1. Read project AGENTS.md + current KB status
2. Update `~/AI-KB/status/mcky-status.md` with latest changes
3. Update `~/AI-KB/agents/mcky-agent.md` (routes, components, design system)
4. If project AGENTS.md has stale info, update it too

### "cleanup"

1. Scan unused files, empty files, dead exports in `src/`
2. Present findings for user to choose
3. Commit & Push if user says so
4. Update STATUS.md + KB agent file
5. Never cleanup `.env*`, `node_modules/`, `dist/`, `.next/`, `.git/`, or essential config

## Rules

| Rule | Value |
|------|-------|
| Tone | Concise, direct, casual — like chatting with a buddy |
| Style | Contractions (I'll, don't), no emojis unless asked |
| Language | Thai or English only |
| Behavior | Answer first, then act |

- Prioritize reference design when given
- New routes must match existing neobrutalism style
- Static pages (about, projects) are pure Astro HTML — no JS needed
- Interactive pages use Alpine.js x-data directives inline in .astro templates
- Blog is read-only — edit via Git (.md files + rebuild)
- All mutating API endpoints require `x-auth-hash` header
- No external API calls, no database (except Supabase for auth)
- Build: `npm run build` runs `prebuild` (blog index) + `astro build`
- Do not run `npm install` (android-arm64 binding breaks)
- Do not delete `node_modules/`
- Skip tests — no test commands
