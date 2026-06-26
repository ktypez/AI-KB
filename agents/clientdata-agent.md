---
type: agent-prompt
id: clientdata-agent
project: clientdata
domain: data.mcky.space
last_updated: 2026-06-26T08:00
status_ref: STATUS.md in project root
personality: data goblin
stack:
  - Next.js 16 (App Router, webpack — not turbopack)
  - React 19
  - Drizzle ORM + Neon Postgres (lazy proxy in lib/db/index.ts)
  - Cloudflare R2 for image storage (lib/r2.ts)
  - Admin auth: scrypt + HMAC tokens, local JSON fallback
  - SPA on app/page.tsx with History API
  - CSS custom properties for theming (surface, text, border tokens)
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
| Styling | Tailwind + CSS custom properties |
| Deployment | Vercel |

## Breaking Change Warning

This is NOT the Next.js you know — APIs, conventions, and file structure may differ from training data. Read `node_modules/next/dist/docs/` before writing code.

## Directory Overview

| Directory | Purpose |
|-----------|---------|
| `app/` | App Router pages, API routes (`api/`), public pages (`c/`), providers, CSS |
| `components/` | Reusable UI — views, forms, maps, modals + `ui/` primitives (Base UI) |
| `lib/` | Core logic — DB (Drizzle ORM), auth, client CRUD, R2 upload, suggestions, utilities |
| `hooks/` | Custom React hooks (`useDebounce`) |
| `types/` | Ambient type declarations for untyped packages |
| `scripts/` | One-off migration scripts |
| `public/` | Static assets — PWA manifest, icons, service worker |

## Animation Map

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

## Components

| Component | File | Purpose |
|-----------|------|---------|
| Skeleton | `components/ui/skeleton.tsx` | Base animated skeleton primitive |
| TableSkeleton | `components/TableSkeleton.tsx` | Table row loading placeholder |
| CardSkeleton | `components/CardSkeleton.tsx` | Card grid loading placeholder |
| SearchDropdown | `components/SearchDropdown.tsx` | Map view search results dropdown |

## CSS Tokens

Custom properties in `globals.css` for consistent theming:
- `--surface`, `--surface-hover`, `--surface-dark`, `--surface-card`, `--surface-elevated`
- `--text-primary`, `--text-secondary`, `--text-muted`, `--text-subtle`
- `--text-dark-primary`, `--text-dark-secondary`, `--text-dark-muted`, `--text-dark-accent`
- `--border`, `--border-strong`, `--border-dark`

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

## Termux

- `/usr/bin/env` broken — use `node /path/to/bin` instead of `npx`
- `oc` alias = normal opencode, `occ` alias = termux-chroot with HOME override
- Plugins: opencode-mem, opencode-command-inject, opencode-background-agents, DCP, termux-notify

## Notes

- `lib/auth.ts` uses `.auth-local.json` fallback when DATABASE_URL is unset
- `public/sw.js` is a cleanup-only script (Serwist removed)
- `useReducer` refactor of page.tsx deferred (20+ tightly coupled useState hooks)
- Auth setup check handles DB failures gracefully (defaults to configured)
- `fetchClients` in `page.tsx` calls `setCachedClients(data)` to sync localStorage cache
- `ClientDetail` uses `AbortController` for suggestions fetch to discard stale responses
- `pushNav` writes distinct query-param URLs per view (detail, edit, add, map, suggestions)
- Delete is immediate (no undo toast) — on failure, client restored via `onClientUpdated()`
- `/c/[id]` page uses server wrapper pattern (`client-page.tsx` receives `id` as prop, not `useParams()`)
- Suggestions API `/api/suggestions?clientId=X` returns `{ error: 'Unauthorized' }` for non-admin — `ClientDetail.tsx` guards with `if (!Array.isArray(data)) return` before calling `data.map()`
- sonner removed — no toast library installed
