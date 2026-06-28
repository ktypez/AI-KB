---
type: agent-prompt
id: clientdata-agent
project: clientdata
domain: data.mcky.space
last_updated: 2026-06-28T10:00
status_ref: STATUS.md in project root
personality: data goblin
stack:
  - Next.js 16 (App Router, webpack — not turbopack)
  - React 19
  - Drizzle ORM + Neon Postgres (lazy proxy in lib/db/index.ts)
  - Cloudflare R2 for image storage (lib/r2.ts)
  - Admin auth: scrypt + HMAC tokens, local JSON fallback
  - SPA on app/page.tsx with History API
  - shadcn/ui components (Base UI + cva variants)
  - next-themes for dark mode (@custom-variant dark in globals.css)
  - Vitest 1.6 + @testing-library/react + jsdom 24 for testing (16 tests)
  - Deployment: Vercel (build: next build --webpack)
branch: master
commands:
  dev: npm run dev (port 3002, host 0.0.0.0)
  build: npm run build (next build --webpack)
  test: pnpm test (16 tests)
  test:watch: pnpm test:watch
  lint: npm run lint
  db-push: npm run db:push
  db-migrate: npm run db:migrate
  deploy: node /data/data/com.termux/files/usr/bin/vercel --prod
triggers:
  "update .md": Read STATUS.md + AGENTS.md, update components/patterns/known → sync KB
  "cleanup": Scan unused → lint + tsc check → present findings → update docs
env_vars:
  - DATABASE_URL (Neon Postgres)
  - R2_PUBLIC_URL, R2_BUCKET_NAME, R2_ACCOUNT_ID, R2_ACCESS_KEY_ID, R2_SECRET_ACCESS_KEY
  - TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID
  - ADMIN_PASSWORD
---

# clientdata Agent

## Overview

Client management & CRM — Next.js 16 with Drizzle + Neon Postgres, Cloudflare R2 file storage, and PWA support.

## Stack

| Layer | Tech |
|-------|------|
| Framework | Next.js 16 (App Router, webpack) |
| Language | React 19 + TypeScript |
| Database | Neon Postgres (Drizzle ORM) |
| Storage | Cloudflare R2 |
| Auth | scrypt + HMAC tokens |
| Testing | Vitest 1.6 + @testing-library/react |
| PWA | Serwist removed (cleanup-only sw) |
| Styling | Tailwind + CSS custom properties + shadcn/ui components |
| Deployment | Vercel |

## Architecture

| Directory | Purpose |
|-----------|---------|
| `app/` | App Router pages, API routes (`api/`), public pages (`c/`), providers, CSS |
| `components/` | Reusable UI — views, forms, maps, modals + `ui/` primitives (Base UI) |
| `lib/` | Core logic — DB (Drizzle ORM), auth, client CRUD, R2 upload, suggestions, utilities |
| `hooks/` | Custom React hooks (`useDebounce`) |
| `types/` | Ambient type declarations for untyped packages |
| `scripts/` | One-off migration scripts |
| `public/` | Static assets — PWA manifest, icons, service worker |

### Animation Map

| Component | Animation |
|-----------|-----------|
| LoginModal | `animate-in fade-in zoom-in-95` |
| RouteModal | `slide-in-from-bottom-10` |
| DesktopCardView | hover lift `-translate-y-0.5` |
| SelectionToolbar | `slide-in-from-bottom-2` |
| SuggestionBadge | `zoom-in-75` |
| EmptyState | `fade-in duration-500` |
| CopyDropdown | `zoom-in-95` |
| PageHeader search | `transition-all duration-200` |
| (removed) | sonner toast deleted — delete is immediate without undo |
| LoadingScreen | skeleton layout (no spinner) |

### Components

| Component | File | Purpose |
|-----------|------|---------|
| Button | `components/ui/button.tsx` | shadcn Button with variants (default, outline, secondary, ghost, destructive, link) — size "icon" = size-8 |
| Card | `components/ui/card.tsx` | shadcn Card — `data-slot="card"`, `ring-1 ring-foreground/10`, overflow-visible |
| Dialog | `components/ui/dialog.tsx` | shadcn Dialog modal — `@base-ui/react/dialog`, `showCloseButton` prop |
| Sheet | `components/ui/sheet.tsx` | Side panel overlay |
| Tooltip | `components/ui/tooltip.tsx` | Hover tooltip |
| TableSkeleton | `components/TableSkeleton.tsx` | Table row loading placeholder |
| SearchDropdown | `components/SearchDropdown.tsx` | Map view search results dropdown |
| Sidebar | `components/Sidebar.tsx` | Sheet drawer with collapsible groups, hamburger visible on desktop |
| InlineMap | `components/InlineMap.tsx` | Full-page cluster map with geolocation + route |
| PageHeader | `components/PageHeader.tsx` | Header bar — sidebar toggle, search, "+ add" button (right side), theme toggle |

### Design System

**shadcn/ui + next-themes** — dark mode toggle (Moon/Sun in header)

- shadcn starter palette: `:root` `--background: oklch(1 0 0)`, `--primary: oklch(0.205 0 0)`
- Dark: `--background: oklch(0.145 0 0)`
- **IBM Plex Sans Thai** primary font, applied as `--font-ibm-plex` CSS variable
- `@custom-variant dark` in globals.css for `dark:` Tailwind classes
- All CSS vars in `globals.css`, `--pin-color` for MapLibre pins

### CSS Tokens

Custom properties in `globals.css` (light + dark):
- `--background`, `--foreground`, `--card`, `--card-foreground`
- `--surface`, `--surface-hover`, `--text-primary`, `--text-secondary`, `--text-muted`, `--text-subtle`
- `--border`, `--border-hover`, `--selection-bg`
- `--primary`, `--primary-hover`, `--ring`, `--destructive`
- `--pin-color` — `#cc785c` coral for MapLibre pin color
- Sidebar CSS variables retained for shadcn compatibility

## Key Patterns

- `lib/auth.ts` uses `.auth-local.json` fallback when DATABASE_URL is unset
- Auth setup check handles DB failures gracefully (defaults to configured)
- `fetchClients` in `page.tsx` calls `setCachedClients(data)` to sync localStorage cache
- `ClientDetail` uses `AbortController` for suggestions fetch to discard stale responses
- `pushNav` writes distinct query-param URLs per view (detail, edit, add, map, suggestions)
- Delete is immediate (no undo toast) — on failure, client restored via `onClientUpdated()`
- `/c/[id]` page uses server wrapper pattern (`client-page.tsx` receives `id` as prop, not `useParams()`)
- Suggestions API `/api/suggestions?clientId=X` returns `{ error: 'Unauthorized' }` for non-admin — `ClientDetail.tsx` guards with `if (!Array.isArray(data)) return` before calling `data.map()`
- `useReducer` refactor of page.tsx deferred (20+ tightly coupled useState hooks)
- **Pin colors**: MapLibre paint properties use runtime `getComputedStyle(document.documentElement).getPropertyValue('--pin-color')` since Maplibre can't parse CSS `var()` or `oklch()`
- **Dark mode**: `next-themes`, `@custom-variant dark` in globals.css, Moon/Sun toggle in header, localStorage persistence
- **Sidebar**: sheet drawer (`Sheet` from Base UI) with backdrop blur, collapsible groups, 240px wide, hamburger visible on desktop; stays open on desktop during nav
- **"+ add" button**: right side of PageHeader (after theme toggle), `size="icon"` same as other header buttons
- **Action button colors**: edit = `border-[var(--accent-blue)]`, delete = `border-[var(--destructive)]`
- **All inputs**: `text-[14px] font-sans` — explicit font + size override for browser consistency
- **Font fix**: `globals.css:59` — `--font-sans: var(--font-ibm-plex), system-ui, sans-serif` (was circular reference)
- **MapPreview**: simple single-style map (no dark/light toggle, no MutationObserver)
- **MapPicker**: uses `getPinColor()` to pass theme color to `pinHtml()` for draggable pin

## Commands

| Command | What it does |
|---------|-------------|
| `npm run dev` | Dev server (port 3002, host 0.0.0.0) |
| `npm run build` | Production build (`next build --webpack`) |
| `pnpm test` | Run tests (16 tests) |
| `npm run lint` | ESLint |
| `npm run db:push` | Push Drizzle schema |
| `npm run db:migrate` | Run migration |

## Triggers

### "update .md"

1. Read project AGENTS.md + current KB status
2. Update `~/AI-KB/status/clientdata-status.md` with latest changes
3. Update `~/AI-KB/agents/clientdata-agent.md` (directory map, components, patterns)
4. If project AGENTS.md has stale info, update it too

### "cleanup"

1. Scan unused imports, empty files, dead exports
2. Health check: `npm run lint` + `tsc --noEmit`
3. Deep scan: leftover dirs, `console.log`, TODO/FIXME
4. Present findings for user to choose
5. Commit & Push if user says so
6. Update STATUS.md + KB agent file
7. Never cleanup `.env*`, `node_modules/`, `.next/`, `.git/`, or essential config

## Rules

### Termux

- `/usr/bin/env` broken — use `node /path/to/bin` instead of `npx`
- `oc` alias = normal opencode, `occ` alias = termux-chroot with HOME override
- Plugins: opencode-mem, opencode-command-inject, opencode-background-agents, DCP, termux-notify

### Project

- `public/sw.js` is a cleanup-only script (Serwist removed)
- sonner removed — no toast library installed
- **shadcn standard**: all UI edits must use shadcn components (`components/ui/`) — Button, Card, Dialog, Skeleton, etc. No custom button/modal patterns when shadcn equivalent exists
