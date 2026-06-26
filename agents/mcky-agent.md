---
type: agent-prompt
id: mcky-agent
project: mcky.space
last_updated: 2026-06-26
status_ref: STATUS.md in project root
personality: terminal hipster
stack:
  - Astro 7.0.2 (server output, Vercel adapter)
  - TypeScript
  - Pure CSS — Neobrutalism (globals.css, no Tailwind)
  - JetBrains Mono via Google Fonts (400–800)
  - Supabase (todos/auth) — habits on habby.mcky.space
  - Blog: .md files compiled to TypeScript at build time
  - Client UI: Alpine.js via CDN (x-data/x-init patterns)
  - Markdown: `marked` (lightweight, no React dependency)
  - Data Fetching: Plain fetch for all client data
  - API: Astro endpoints (8 routes in src/pages/api/)
  - Auth: SHA-256 password via Web Crypto API, header-based gating
  - Deployment: Vercel via @astrojs/vercel
components:
  - taskApp: Alpine.js data object — todo CRUD, priority cycling, list grouping, stats
  - require-auth.ts: Middleware — validates x-auth-hash header, returns 401/503
  - fetchWithAuth: Utility that attaches x-auth-hash header on mutating requests
commands:
  dev: npm run dev
  build: npm run build (runs prebuild hook for blog index first)
  build-blog: node scripts/build-blog-posts.mjs
  start: npm run start
  test: Not configured
  lint: Not configured (pure CSS, no framework lint)
triggers:
  "update .md": Read STATUS.md + AGENTS.md, update routes/components/design → sync KB
  "cleanup": Scan unused → build check → present findings → update docs
---

# mcky.space Agent

## Overview

Terminal-style personal website on mcky.space. Neobrutalist design with Alpine.js interactivity, Astro 7 server output, and SHA-256 auth.

## Stack

| Layer | Tech |
|-------|------|
| Framework | Astro 7.0.2 (server output, Vercel adapter) |
| Language | TypeScript |
| Styling | Pure CSS — Neobrutalism (globals.css) |
| Font | JetBrains Mono 400–800 via Google Fonts |
| Database | Supabase (todos/auth) |
| Blog | .md files compiled to TS at build time |
| Client UI | Alpine.js via CDN (x-data/x-init patterns) |
| Markdown | `marked` |
| Auth | SHA-256 via Web Crypto API, header-based gating |
| Deployment | Vercel via @astrojs/vercel |

## Architecture

| Route | Description |
|-------|-------------|
| `/` | Neobrutalist homepage — terminal sim in neo-card, tech stack tags |
| `/about` | About page — neo-cards for bio, stack badges, contact |
| `/blog` | Blog listing — neo-card per post, badge dates |
| `/blog/[slug]` | Blog post — neo-styled content, code blocks with shadows |
| `/task` | Todo list — Alpine.js x-data (CRUD, priority, stats in neo-cards) |
| `/projects` | Project showcase — neo-cards with colored tags |
| `habby.mcky.space` (external) | Sidebar + homepage link (new tab) |

## Key Patterns

- Alpine.js x-data + x-init for client-side interactivity (no React bundle)
- `marked` for lightweight markdown rendering (no React dependency)
- Plain fetch for all API calls (no SWR/React Query)
- Astro static pages for non-interactive content (about, projects)
- Blog .md compiled to TS at build time (no runtime filesystem access)
- CSS-only skeleton loading (.skel class with shimmer keyframe)
- SHA-256 auth hash stored in localStorage as auth_hash

### Design System

- **Neobrutalism** — light default (`#f5f5f0` bg), dark mode supported
- Thick 3px black borders, hard offset shadows (`4px 4px 0`)
- Bright saturated accents: green, amber, red, blue, purple, orange, pink
- Components: `.neo-card` (shadow cards), `.neo-tag` (colored labels), `.neo-badge` (inline chips)
- CSS variables in `:root` — no magic numbers
- JetBrains Mono 400–800 via Google Fonts

## Commands

| Command | What it does |
|---------|-------------|
| `npm run dev` | Dev server |
| `npm run build` | Build (prebuild blog index + astro build) |
| `node scripts/build-blog-posts.mjs` | Build blog index manually |
| `npm run start` | Start production server |
| test | Not configured |
| lint | Not configured (pure CSS, no framework lint) |

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
- Interactive pages (task) use Alpine.js x-data directives inline in .astro templates
- Blog is read-only — edit via Git (.md files + rebuild)
- All mutating API endpoints require `x-auth-hash` header (validated via `require-auth` middleware)
- No external API calls, no database (except Supabase for todos/auth)
- Build: `npm run build` runs `prebuild` (blog index) + `astro build`
