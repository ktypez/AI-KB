---
last_updated: 2026-06-26T08:30:00Z
project: clientdata
type: status
---

# Project Status — clientdata — STABLE

## Lint

- ESLint — **0 errors**, 0 warnings

## TypeScript

- `tsc --noEmit` — **Clean** (no errors)

## Branch

- `master`

## Changelog

### 2026-06-26 — IBM Plex Sans Thai via next/font
- **Added**: `lib/fonts.ts` with `IBM_Plex_Sans_Thai` — self-hosted via `next/font/google`, subsets: thai+latin, weights 100-700
- **Updated**: `globals.css` — `--font-sans`, `--font-display`, `--font-heading` now use `var(--font-ibm-plex)` with system fallbacks

### 2026-06-26 — `/c/[id]` Crash Fix + sonner Removal + PWA Tune
- **Fixed**: `/c/[id]` crash `e.map is not a function` — suggestions API returns `{ error: 'Unauthorized' }` for non-admin users, `setSuggestions()` updater called `data.map()` without checking `Array.isArray`. Added `if (!Array.isArray(data)) return` guard.
- **Refactored**: Replaced `useParams()` with server wrapper pattern (`use(params)` → `id` prop) in `client-page.tsx`
- **Cleaned**: Replaced stale 43KB Serwist `public/sw.js` with cleanup script; deleted `app/sw.ts`
- **Removed**: sonner toast library — deleted `components/ui/sonner.tsx`, removed `<Toaster>` from layout, removed all `toast.*` calls, simplified delete handler to direct `deleteClient()`, removed `.delete-toast` CSS
- **Tuned**: PWA install dialog reduced from 3 visits / 30s delay → 2 visits / 5s delay
- **Added**: Optional chaining on `client.images?.map()` and `client.images?.length` in ClientDetail.tsx

### 2026-06-26 — Test Setup (Vitest + Testing Library)
- **Added**: Vitest 1.6 + @testing-library/react + @testing-library/jest-dom + jsdom 24
- **Added**: `vitest.config.mts` — React plugin, jsdom env, `@/` path alias, PostCSS disabled
- **Added**: `tests/setup.ts` — jest-dom matchers auto-import
- **Added**: `test` / `test:watch` scripts to package.json
- **Added**: `vitest/globals` to tsconfig.json types
- **Added**: 9 tests covering `lib/utils.ts` (cn, getMapsUrl, formatDateTime, formatDate, generateId) and `hooks/useDebounce.ts`

### 2026-06-25 — Map Pin Fix + Color Update
- **Fixed**: Map pins not rendering after style changes (theme toggle) — `addLayers()` now explicitly cleans up stale layers/source before re-adding instead of guarding with `getSource()` which could return stale references during style transitions
- **Updated**: Map pin colors from hardcoded red (`#c80008`) to design system primary teal/green (`#1a8a6a` light, `#2ebd8a` dark)
- **Updated**: `lib/pin.ts` HTML pin markers to match new teal/green primary colors

### 2026-06-25 — Bundle Optimization & Cleanup
- Added `@next/bundle-analyzer`, identified maplibre-gl (1MB/266KB gz) as 46% of client bundle
- Created `MapPreviewDynamic.tsx` wrapper with `next/dynamic` (same pattern as `MapPickerDynamic.tsx`)
- Changed `ClientDetail.tsx` to import `MapPreviewDynamic` instead of `MapPreview` — maplibre now async
- Removed `@next/bundle-analyzer` after analysis complete
- Cleaned `package.json` `allowScripts` (removed unused msw/sharp refs)
- Removed stale `.next/analyze` directory

### 2026-06-25 — Tech Stack Upgrade
- next: 16.2.6 → 16.2.9
- react/react-dom: 19.2.4 → 19.2.7
- typescript: 5.9.3 → 6.0.3
- @types/node: 20.x → 26.x
- @aws-sdk/client-s3: 3.1055.0 → 3.1075.0
- @base-ui/react: 1.5.0 → 1.6.0
- tailwindcss: 4.3.0 → 4.3.1
- @tailwindcss/postcss: 4.3.0 → 4.3.1
- @types/react: 19.2.15 → 19.2.17
- eslint-config-next: 16.2.6 → 16.2.9
- Added `"types": ["geojson"]` to tsconfig.json (TS6 `types: []` default broke global GeoJSON namespace)
- eslint 10 blocked — `eslint-config-next` doesn't support it yet

### 2026-06-25 — Code Review Fixes (15 issues)
- **P1**: POST /api/clients duplicate check now uses `getClientById()` instead of loading entire table
- **Q5**: Removed dead `localStorage.setItem('ezzylist_session', ...)` in LoginModal
- **E5**: `approveSuggestion` wraps client update + status update in `db.transaction()` — prevents double-approval on crash
- **E6**: Added try/catch around approve/reject in suggestion API route
- **R1**: NavState stores `client`/`editClient` objects — fixes stale closure in `applyNav` (`clients.find()` no longer needed)
- **Q1**: Extracted `formatDateTime`/`formatDate` to `lib/utils.ts`, removed 3 duplicates
- **Q3**: Extracted `generateId()` to `lib/utils.ts`
- **Q4**: Removed dead `getAdminToken()` and `x-admin-token` header fallback from storage.ts
- **E3**: Photo timer stored in ref, cleared on unmount in ClientDetail
- **E4**: Added try/catch around `addClient()` in POST /api/clients
- **A2**: Added auth check to `GET /api/suggestions?clientId=X`
- **A5**: Added 4-char minimum password length on first setup
- **A6**: DELETE /api/clients/:id returns 404 if client doesn't exist
- **S6**: Telegram error details logged server-side, generic message sent to client

### 2026-06-25 — Design Audit Fixes
- **C1**: `--text-muted` bumped from #8a91a6 → #6b7280 (4.57:1 contrast, WCAG AA)
- **C3**: Added `.focus-visible` utility class for non-input focus rings
- **H1**: `--text-dark-muted` bumped from #666c83 → #7d849a (4.52:1 contrast, WCAG AA)
- **H10**: Muted oklch values bumped for light + dark themes
- **H4**: PageHeader menu/back buttons expanded to 44px
- **H5**: Sidebar links expanded to 44px (py-2→py-3), sidebar buttons expanded to 44px
- **H7**: CopyDropdown trigger expanded to 40px
- **H8**: Added `aria-label` to search input
- **H9**: Added `aria-label` to icon-only close buttons (RouteModal, InlineMap, ClientDetail lightbox/photo, ImageUpload)
- **M1**: Sidebar active link gets `border-l-2` indicator + stronger color
- **M4**: Sidebar section headers changed from `<p>` to `<h3>` for heading hierarchy
- **M5**: EmptyState container gets `aria-live="polite"` for screen readers
- Search clear button expanded to 32px with focus ring

### 2026-06-25 — Hardcoded Hex → CSS Variable Migration
- Added 5 new CSS variables to globals.css: `--primary-hover`, `--accent-blue`, `--accent-blue-hover`, `--selection-bg`, `--border-hover` (+ dark mode variants)
- Migrated ~300+ hardcoded hex values across 20 component files to use CSS custom properties
- Affected: ClientDetail, InlineMap, RouteModal, AdminSuggestionsInline, DesktopTableView, SuggestEditForm, CopyDropdown, MobileCardList, SelectionToolbar, ImageUpload, DesktopCardView, LoginModal, PageHeader, sheet, AddClientForm, InlineAddEditView, MapPickerDynamic, MapPreviewDynamic, MapPreview, SetupScreen, Logo, app/c/[id]/page.tsx
- Logo.tsx SVG fill converted to style prop for CSS variable compatibility
- All colors now flow from globals.css tokens — single source of truth

### 2026-06-25 — Map Pin + Split View Fixes
- InlineMap: replaced unparseable `var(--primary)` in circle layers with runtime `getComputedStyle` — resolves MapLibre GL WebGL color parsing limitation
- page.tsx: all nav callbacks (`navToDetail`, `navToMap`, `navToAdd`, `navToEdit`) now reset all view states to prevent split view when switching between suggestions and map

### 38146e6 — Code Review Fixes (2026-06-23)
- `fetchClients` now calls `setCachedClients(data)` to keep localStorage cache in sync
- `AbortController` added to suggestions fetch in `ClientDetail` to prevent stale responses
- `pushNav` writes distinct URLs per view (`/?detail=id`, `/?edit=id`, `/?add=1`, `/?map=1`, `/?suggestions=1`) instead of always `/`
- Undo delete in `ClientDetail` now calls `addClient` instead of `updateClient` for proper re-insertion
- `LoadingScreen` reuses `<TableSkeleton>` component instead of duplicating same JSX (21 lines removed)

### UI/UX Improvements
- Added 20+ CSS custom properties to `globals.css` (surface, text, border tokens for light/dark)
- Updated 12 components to use CSS variables instead of hardcoded hex colors (PageHeader, Sidebar, LoadingScreen, EmptyState, SearchDropdown, ErrorScreen, PwaInstallAlert, DesktopCardView, LoginModal, SetupScreen, LoadMore, SuggestionBadge)
- Fixed card hover transitions to use targeted `transition-[box-shadow,transform,border-color]` instead of `transition-all`
- Mobile FAB button now uses `bg-primary` (theme accent) instead of hardcoded `#c80008`

### Skeleton Loading
- Created `components/ui/skeleton.tsx` — base Skeleton primitive
- Created `components/TableSkeleton.tsx` — table row skeletons
- Created `components/CardSkeleton.tsx` — card grid skeletons
- Updated `LoadingScreen` to show full skeleton layout (sidebar + header + table) instead of spinner

### Delete Behavior
- Delete now calls `deleteClient()` immediately, no undo toast
- On failure, client is restored via `onClientUpdated()`

### Smarter Empty States
- `EmptyState` now accepts `filter` and `search` props
- Shows context-specific copy: filter name, search query, or generic message
- Updated DesktopTableView, DesktopCardView, MobileCardList to pass filter/search

### Search Improvements
- Debounce reduced from 200ms to 150ms
- `SearchDropdown` extracted from `page.tsx` to `components/SearchDropdown.tsx`

### Route Planning Fallback
- Added manual origin input (lat/lng fields) when geolocation fails
- RouteModal shows input form instead of just error message
- Added `showManualOrigin`, `manualOriginLat/Lng` state to page.tsx

### PWA Install Timing
- Install prompt now waits for 2nd visit + 5s delay before showing
- Tracks visit count in `localStorage` (`ezzylist_pwa_visits`)

### Auth Fixes
- Setup screen removed from page.tsx — app is public for viewing
- Auth setup check (`/api/auth?check=setup`) now catches DB errors gracefully (defaults to configured)
- Removed unused `needsSetup`, `loginPassword`, `loginError`, `loginLoading`, `handleLogin` from page.tsx

### Cleanup
- Removed `SetupScreen` import and setup-blocking logic from page.tsx
- Removed unused `check=setup` fetch from auth check useEffect

## Components

| Component | File | Purpose |
|-----------|------|---------|
| Skeleton | `components/ui/skeleton.tsx` | Base animated skeleton primitive |
| TableSkeleton | `components/TableSkeleton.tsx` | Table row loading placeholder |
| CardSkeleton | `components/CardSkeleton.tsx` | Card grid loading placeholder |
| SearchDropdown | `components/SearchDropdown.tsx` | Map view search results dropdown |
| MapPreviewDynamic | `components/MapPreviewDynamic.tsx` | Lazy-loaded map preview wrapper |

## Tests

- **Framework**: Vitest 1.6 + Testing Library + jsdom 24
- **Command**: `pnpm test` (or `node node_modules/vitest/vitest.mjs run`)
- **Tests**: 16 passing — see coverage below
- **Dir**: `tests/` — config in `vitest.config.mts`, setup in `tests/setup.ts`
- PostCSS disabled in test config (avoids native binding issue with lightningcss)

### Coverage

| Module | Tests | What's tested |
|--------|-------|---------------|
| `lib/utils.ts` | 14 | cn, getMapsUrl, formatDateTime, formatDate, generateId, haversineKm, displayStep |
| `hooks/useDebounce.ts` | 2 | initial value, delayed update |

### Not yet tested

- `app/page.tsx` — 30 useState hooks, filtering/search, nav state, route planning (useReducer refactor deferred)
- All components (EmptyState, ThemeToggle, Sidebar, forms, modals, etc.)
- API routes (`app/api/`)
- Hooks: none beyond useDebounce

## Known

- `/usr/bin/env` broken on Termux
- `useReducer` refactor of page.tsx deferred (30 useState hooks tightly coupled) — tests exist for extracted helpers (haversineKm, displayStep) but page.tsx behavior itself is untested
- `/c/[id]` page crash was caused by suggestions API returning `{ error: 'Unauthorized' }` for non-admin users — `Array.isArray()` guard added in `ClientDetail.tsx`
- sonner removed — no toast library currently; delete is immediate without undo
