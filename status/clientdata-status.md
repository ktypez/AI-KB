---
type: project-status
project: clientdata
last_updated: 2026-06-28
id: clientdata-status
title: clientdata-status
timestamp: 2026-06-28T10:00:00Z
---

# Project Status — clientdata

## Stack

- **Framework**: Next.js 16.2.9 (App Router)
- **UI Library**: React 19.2.7, TypeScript 6.0.3
- **Styling**: Tailwind CSS 4.3.1 + PostCSS + shadcn/ui components (Base UI)
- **Database**: Neon (Postgres) via server actions + API routes
- **Maps**: MapLibre GL JS (lazy-loaded via `next/dynamic`, 1MB / 266KB gz)
- **Auth**: Password-based (SHA-256), admin + viewer roles
- **Storage**: Supabase Storage (client images)
- **Deploy**: Vercel (serverless)
- **Font**: IBM Plex Sans Thai via `next/font/google` (self-hosted, subsets: thai+latin, weights 100-700)
- **Testing**: Vitest 1.6 + @testing-library/react + jsdom 24
- **Dark mode**: `next-themes` with `@custom-variant dark` in globals.css

## Routes

- `/` — Main SPA (Dashboard / Map / Admin views via History API)
- `/c/[id]` — Public client page (server wrapper pattern)
- `/api/clients` — CRUD endpoints
- `/api/suggestions` — Suggestions CRUD + approve/reject
- `/api/auth` — Password auth

## Components

| Component | Purpose |
|-----------|---------|
| Button | shadcn Button — variants: default, outline, secondary, ghost, destructive, link |
| Card | shadcn Card — `data-slot="card"`, `ring-1 ring-foreground/10` |
| Dialog | shadcn Dialog — `@base-ui/react/dialog`, `showCloseButton` prop |
| Sheet | shadcn Sheet — side panel overlay |
| Skeleton | Base animated skeleton primitive |
| TableSkeleton | Table row loading placeholder |
| SearchDropdown | Map view search results dropdown |
| MapPreviewDynamic | Lazy-loaded map preview wrapper |
| Sidebar | Sheet drawer with collapsible groups |

## API

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

- **shadcn starter palette** — `:root` `--background: oklch(1 0 0)`, `--primary: oklch(0.205 0 0)`
- Dark: `--background: oklch(0.145 0 0)`
- **IBM Plex Sans Thai** primary font, applied as `--font-ibm-plex` CSS variable
- `@custom-variant dark` in globals.css for `dark:` Tailwind classes
- **Button variants**: default, outline (`dark:border-white/30 dark:bg-transparent dark:text-white dark:hover:bg-white/10`), secondary, ghost, destructive, link
- **Button sizes**: default (h-8), sm (h-7), lg (h-9), icon (size-8), icon-sm, icon-lg
- Action buttons use `border-[var(--accent-blue)]` or `border-[var(--destructive)]`
- All inputs at `text-[14px] font-sans` — explicit font override for browsers

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

### Week 2026-06-28
- **"+" button moved to header right side** — after theme toggle, `size="icon"` same as other header buttons
- **Sidebar stays open on desktop** — `setSidebarOpen(false)` only on mobile (`window.innerWidth <= 900`)
- **Font fix**: `globals.css:59` — `--font-sans: var(--font-ibm-plex), system-ui, sans-serif` (was circular reference)
- **All inputs at 14px**: changed from `text-base` (16px) → `text-[14px]` across all forms
- **All inputs font-sans**: added explicit `font-sans` to override browser defaults
- **Outline button dark mode**: `dark:border-white/30 dark:bg-transparent dark:text-white dark:hover:bg-white/10`
- **Delete modal buttons**: `h-12`, `border-[var(--destructive)]`
- **Edit button**: `h-12`, `border-[var(--accent-blue)]`
- **User buttons** (photo request, suggest edit): `h-12`, `border-[var(--accent-blue)]`
- **Detail page action buttons**: moved outside Card, placed with explicit border colors
- **Detail page cards padding**: reduced from `p-5` to `px-3 py-2`
- **Photos+Map gap**: `gap-5` → `gap-2`
- **Lightbox**: removed Card wrapper, added backdrop-blur-sm, bigger nav buttons (w-11 h-11), buttons-only (no swipe)
- **Map view drawer**: increased button sizes to `h-12`, crosshair/X buttons `w-10 h-10`
- **RouteModal**: buttons increased to `h-12`

### Week 2026-06-27
- **Palette reworked**: Claude warm palette both light and dark — softer foregrounds, warmer browns
- **Theme system deleted**: removed useStyleSettings.ts, StylePicker.tsx, all [data-*] CSS blocks (~487 lines removed)
- **Dark mode toggle**: Moon/Sun icon in header, localStorage persistence, FOUC script in head
- **Dark basemaps**: CartoDB voyager (light) / dark-matter (dark) via MutationObserver on html class

### Week 2026-06-26
- **Theme system split**: style (structural) + color (accent palette) + dark mode — 3 independent selectors
- **10 → 6 presets removed**: Modern, Retro/Y2K, Bento Grid, Neo-brutalism, Cyberpunk
- **StylePicker**: redesigned — wider 360px popup with 3 sections
- **Pin colors**: theme-aware (reads `--pin-color` hex via `getComputedStyle`)

### Week 2026-06-22
- **Redesign**: sidebar → sheet drawer, hamburger on desktop, collapsible groups, Swiss default
- **Font**: IBM Plex Sans Thai via `next/font`
- **sonner removed**: deleted toast library, delete is immediate (no undo)
- **PWA tuned**: install dialog from 3 visits/30s → 2 visits/5s
- **Tests**: Vitest 1.6 + Testing Library + jsdom 24 — 16 tests (utils + useDebounce)
- **Stack upgrade**: next 16.2.6→16.2.9, react 19.2.4→19.2.7, TS 5.9→6.0
- **Code review (15 issues)**: transaction-protected approvals, nav state fix, photo timer cleanup, auth checks, dead code removal
- **Design audit**: contrast bumps, 44px touch targets, ARIA labels, heading hierarchy
- **Hex→CSS vars**: 300+ hardcoded values → custom properties across 20 files
- **Skeletons**: Skeleton/TableSkeleton/CardSkeleton components, LoadingScreen uses layout
- **Route planning**: manual origin input when geolocation fails

### 2026-06-15
- Initial Next.js 16 + Drizzle + Neon setup

## PWA

- Install prompt: 2 visits + 5s delay before showing; visit count tracked in `localStorage` (`ezzylist_pwa_visits`)
- Old Serwist `public/sw.js` (43KB) replaced with cleanup script
- `app/sw.ts` deleted

## Tests

| Module | Tests | What's tested |
|--------|-------|---------------|
| `lib/utils.ts` | 14 | cn, getMapsUrl, formatDateTime, formatDate, generateId, haversineKm, displayStep |
| `hooks/useDebounce.ts` | 2 | initial value, delayed update |

- **Framework**: Vitest 1.6 + @testing-library/react + jsdom 24
- **Command**: `pnpm test` (or direct vitest path for Termux)
- **Config**: `vitest.config.mts` in project root, setup in `tests/setup.ts`
- **Not yet tested**: `page.tsx` (30 useState hooks), components, API routes, most hooks

## Known Issues

- `/usr/bin/env` broken on Termux
- `useReducer` refactor of `page.tsx` deferred (30 tightly coupled `useState` hooks)
- Delete is immediate without undo (sonner removed)
- eslint 10 blocked — `eslint-config-next` doesn't support it yet
- PostCSS disabled in test config (avoids `lightningcss` native binding issue)
- Cannot build locally (Node.js 18.19.1 too old for Next.js 16)
