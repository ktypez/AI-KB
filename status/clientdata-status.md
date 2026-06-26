---
type: project-status
project: clientdata
last_updated: 2026-06-26
id: clientdata-status
---

# Project Status — clientdata

## Current State

**STABLE** — 0 ESLint errors, clean `tsc --noEmit`, 16 tests passing

## Lint / TypeScript / Branch

- **ESLint**: 0 errors, 0 warnings
- **TypeScript**: `tsc --noEmit` — clean (no errors)
- **Branch**: `master`

## Stack

- **Framework**: Next.js 16.2.9 (App Router)
- **UI Library**: React 19.2.7, TypeScript 6.0.3
- **Styling**: Tailwind CSS 4.3.1 + PostCSS
- **Database**: Neon (Postgres) via server actions + API routes
- **Maps**: MapLibre GL JS (lazy-loaded via `next/dynamic`, 1MB / 266KB gz)
- **Auth**: Password-based (SHA-256), admin + viewer roles
- **Storage**: Supabase Storage (client images)
- **Deploy**: Vercel (serverless)
- **Font**: IBM Plex Sans Thai via `next/font/google` (self-hosted, subsets: thai+latin, weights 100-700)
- **Testing**: Vitest 1.6 + @testing-library/react + jsdom 24

## Routes

- `/` — Main SPA (Dashboard / Map / Admin views via History API)
- `/c/[id]` — Public client page (server wrapper pattern)
- `/api/clients` — CRUD endpoints
- `/api/suggestions` — Suggestions CRUD + approve/reject
- `/api/auth` — Password auth

## Components

| Component | Purpose |
|-----------|---------|
| `Skeleton` | Base animated skeleton primitive |
| `TableSkeleton` | Table row loading placeholder |
| `CardSkeleton` | Card grid loading placeholder |
| `SearchDropdown` | Map view search results dropdown |
| `MapPreviewDynamic` | Lazy-loaded map preview wrapper |

## API Endpoints

| Route | Method | Purpose |
|-------|--------|---------|
| `/api/clients` | GET | List all clients (with caching) |
| `/api/clients` | POST | Add client (duplicate check via `getClientById()`) |
| `/api/clients/[id]` | DELETE | Delete client (returns 404 if not found) |
| `/api/suggestions?clientId=X` | GET | Get suggestions for a client (auth-gated) |
| `/api/suggestions` | POST | Create suggestion |
| `/api/suggestions/[id]/approve` | POST | Approve suggestion (uses `db.transaction()`) |
| `/api/suggestions/[id]/reject` | POST | Reject suggestion |
| `/api/auth` | POST | Password verification |
| `/api/auth?check=setup` | GET | Check if auth is set up (graceful DB error fallback) |

## Design System

- Custom properties in `globals.css`: --surface, --text-*, --border-* tokens for light/dark
- Tailwind CSS with custom config
- Colors flow from CSS variables (no hardcoded hex after migration)
- Animations: CSS-only compositor (transform, opacity), 150-300ms
- Touch targets ≥ 44px, aria-labels on icon-only buttons

## Data Model

### Clients
- Table: `clients` (Neon Postgres via Drizzle ORM)
- Fields: id, name, phone, address, images[], lat, lng, notes, created_at, updated_at
- RLS: public read, admin write

### Suggestions
- Table: `suggestions` — client_id, field, old_value, new_value, status, created_by
- Approval: wrapped in db.transaction() to prevent double-approval

### Auth
- Admin accounts: scrypt + HMAC tokens, local `.auth-local.json` fallback

## Changelog

### Week 2026-06-22
- **Redesign**: sidebar → sheet drawer, hamburger on desktop, collapsible groups, Swiss default, remove dark mode
- **Style picker**: 10 presets + per-style CSS
- **Font**: IBM Plex Sans Thai via `next/font`
- **sonner removed**: deleted toast library, delete is immediate (no undo)
- **PWA tuned**: install dialog from 3 visits/30s → 2 visits/5s
- **Crash fix**: `/c/[id]` — `Array.isArray()` guard on suggestions data
- **Error boundary**: added + optional chaining on `client.images`
- **Tests**: Vitest 1.6 + Testing Library + jsdom 24 — 16 tests (utils + useDebounce)
- **Map**: pin color red → teal/green, maplibre-gl lazy-loaded (1MB → async)
- **Stack upgrade**: next 16.2.6→16.2.9, react 19.2.4→19.2.7, TS 5.9→6.0
- **Code review (15 issues)**: transaction-protected approvals, nav state fix, photo timer cleanup, auth checks, dead code removal
- **Design audit**: contrast bumps, 44px touch targets, ARIA labels, heading hierarchy
- **Hex→CSS vars**: 300+ hardcoded values → custom properties across 20 files
- **Skeletons**: Skeleton/TableSkeleton/CardSkeleton components, LoadingScreen uses layout
- **Empty states**: context-specific copy (filter name, search query)
- **Search**: debounce 200→150ms, SearchDropdown extracted
- **Route planning**: manual origin input when geolocation fails

### 2026-06-15
- Initial Next.js 16 + Drizzle + Neon setup

## Known Issues

- `/usr/bin/env` broken on Termux
- `useReducer` refactor of `page.tsx` deferred (30 tightly coupled `useState` hooks) — helpers extracted (`haversineKm`, `displayStep`) and tested, but page.tsx behavior itself untested
- sonner removed — delete is immediate without undo
- eslint 10 blocked — `eslint-config-next` doesn't support it yet
- PostCSS disabled in test config (avoids `lightningcss` native binding issue)

## Tests (16)

| Module | Tests | What's tested |
|--------|-------|---------------|
| `lib/utils.ts` | 14 | cn, getMapsUrl, formatDateTime, formatDate, generateId, haversineKm, displayStep |
| `hooks/useDebounce.ts` | 2 | initial value, delayed update |

- **Framework**: Vitest 1.6 + @testing-library/react + jsdom 24
- **Command**: `pnpm test` (or direct vitest path for Termux)
- **Config**: `vitest.config.mts` in project root, setup in `tests/setup.ts`
- **Not yet tested**: `page.tsx` (30 useState hooks), components, API routes, most hooks

## PWA

- Install prompt: 2 visits + 5s delay before showing; visit count tracked in `localStorage` (`ezzylist_pwa_visits`)
- Old Serwist `public/sw.js` (43KB) replaced with cleanup script
- `app/sw.ts` deleted
