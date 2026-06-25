---
last_updated: 2026-06-25T09:00:00Z
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

### Undo Delete Toast
- Delete now shows 10s undo toast with progress bar (sonner)
- Server deletion deferred until toast auto-closes
- If undo clicked within 10s, client is restored without server call
- Progress bar: CSS `@keyframes toast-progress` on `.delete-toast` class

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
- Install prompt now waits for 3rd visit + 30s delay before showing
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

## Known

- No test runner
- `/usr/bin/env` broken on Termux
- `useReducer` refactor of page.tsx deferred (20+ tightly coupled useState hooks)
