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

### 2026-06-26 — Plex Sans Thai + Crash Fix + sonner Removal + PWA Tune
- **Added**: `lib/fonts.ts` with `IBM_Plex_Sans_Thai` — self-hosted via `next/font/google`
- **Updated**: `globals.css` — `--font-sans`, `--font-display`, `--font-heading` use `var(--font-ibm-plex)` with system fallbacks
- **Fixed**: `/c/[id]` crash `e.map is not a function` — `Array.isArray()` guard on suggestions data
- **Refactored**: `useParams()` → server wrapper pattern (`use(params)` → `id` prop) in `client-page.tsx`
- **Cleaned**: Replaced stale 43KB Serwist `public/sw.js` with cleanup script; deleted `app/sw.ts`
- **Removed**: sonner toast library — deleted `<Toaster>`, all `toast.*` calls, simplified delete handler to direct `deleteClient()`
- **Tuned**: PWA install dialog: 3 visits / 30s → 2 visits / 5s
- **Added**: Optional chaining on `client.images?.map()` and `client.images?.length` in ClientDetail

### 2026-06-26 — Test Setup
- **Added**: Vitest 1.6 + @testing-library/react + @testing-library/jest-dom + jsdom 24
- **Added**: `vitest.config.mts` — React plugin, jsdom env, `@/` path alias, PostCSS disabled
- **Added**: `tests/setup.ts` — jest-dom matchers auto-import
- **Added**: `test` / `test:watch` scripts to package.json
- **Added**: 9 tests covering `lib/utils.ts` (cn, getMapsUrl, formatDateTime, formatDate, generateId) and `hooks/useDebounce.ts`

### 2026-06-25 — Map Pin Fix + Bundle Optimization + Stack Upgrade + Code Review (15 issues) + Design Audit
- **Fixed**: Map pins not rendering after theme toggle — `addLayers()` explicitly cleans stale layers/source before re-adding
- **Updated**: Map pin colors from red (`#c80008`) to teal/green (`#1a8a6a` light, `#2ebd8a` dark)
- **Optimized**: maplibre-gl (1MB/266KB gz, 46% of client bundle) lazy-loaded via `MapPreviewDynamic.tsx` wrapper
- **Cleaned**: Removed `@next/bundle-analyzer`, stale `.next/analyze` directory, unused msw/sharp refs
- **Upgraded**: next 16.2.6→16.2.9, react/react-dom 19.2.4→19.2.7, typescript 5.9.3→6.0.3, @types/node 20→26, @aws-sdk/client-s3 3.1055→3.1075, @base-ui/react 1.5→1.6, tailwindcss 4.3→4.3.1
- **Fixed**: Added `"types": ["geojson"]` to tsconfig (TS6 `types: []` broke global GeoJSON namespace)
- **Fixed**: POST /api/clients duplicate check uses `getClientById()` instead of loading entire table
- **Fixed**: `approveSuggestion` wraps client + status update in `db.transaction()` — prevents double-approval
- **Fixed**: NavState stores `client`/`editClient` objects (eliminates stale closure)
- **Fixed**: Photo timer stored in ref, cleared on unmount in ClientDetail; try/catch around `addClient()` and approve/reject
- **Fixed**: Auth check on `GET /api/suggestions?clientId=X`; 4-char minimum password on first setup
- **Fixed**: DELETE returns 404 if client doesn't exist; Telegram error details logged server-side
- **Fixed**: Removed dead `localStorage.setItem('ezzylist_session')` and `getAdminToken()`/`x-admin-token` fallback
- **Added**: `formatDateTime`/`formatDate`/`generateId` extracted to `lib/utils.ts`
- **Fixed**: Design audit — contrast bumps (muted text #8a91a6→#6b7280, dark muted #666c83→#7d849a), .focus-visible utility, 44px touch targets (PageHeader buttons, sidebar links), aria-labels on icon-only buttons, heading hierarchy (sidebar headers → `<h3>`), EmptyState `aria-live="polite"`, search clear button 32px + focus ring
- **Updated**: ~300+ hardcoded hex values → CSS custom properties across 20 component files; added 5 new CSS vars (`--primary-hover`, `--accent-blue`, `--accent-blue-hover`, `--selection-bg`, `--border-hover` with dark mode variants)
- **Fixed**: InlineMap circle layers use `getComputedStyle` for `var(--primary)` (MapLibre GL WebGL color parsing limitation)
- **Fixed**: All nav callbacks reset view states to prevent split view on nav switches

### 2026-06-23 — Code Review Fixes (38146e6)
- **Fixed**: `fetchClients` calls `setCachedClients(data)` to keep localStorage cache in sync
- **Added**: `AbortController` to suggestions fetch in ClientDetail (prevents stale responses)
- **Fixed**: `pushNav` writes distinct URLs (`/?detail=id`, `/?edit=id`, `/?add=1`, etc.) instead of always `/`
- **Fixed**: Undo delete calls `addClient` instead of `updateClient` for proper re-insertion
- **Fixed**: `LoadingScreen` reuses `<TableSkeleton>` instead of duplicating JSX (21 lines removed)

### 2026-06-23 — UI/UX Improvements
- **Added**: 20+ CSS custom properties to `globals.css` (surface, text, border tokens for light/dark)
- **Updated**: 12 components to use CSS variables instead of hardcoded hex colors
- **Fixed**: Card hover transitions target `transition-[box-shadow,transform,border-color]` (not `transition-all`)
- **Fixed**: Mobile FAB button uses `bg-primary` instead of hardcoded `#c80008`

### 2026-06-23 — Skeleton Loading + Delete Behavior + Empty States + Search + Route Planning + PWA + Auth
- **Added**: `Skeleton`, `TableSkeleton`, `CardSkeleton` components; `LoadingScreen` shows full skeleton layout
- **Changed**: Delete is immediate (no undo toast); on failure, restored via `onClientUpdated()`
- **Added**: `EmptyState` accepts `filter` and `search` props — context-specific copy
- **Improved**: Search debounce 200ms→150ms; `SearchDropdown` extracted from `page.tsx`
- **Added**: Manual origin input (lat/lng fields) in RouteModal when geolocation fails
- **Tuned**: PWA install after 2nd visit + 5s delay
- **Fixed**: App is public for viewing (setup removed from page.tsx); auth setup check catches DB errors gracefully
- **Removed**: Unused `needsSetup`, `loginPassword`, `loginError`, `loginLoading`, `handleLogin` from page.tsx

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
