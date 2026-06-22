---
last_updated: 2026-06-22
project: clientdata
type: status
---

# Project Status — clientdata — STABLE

## Lint

- ESLint — **0 errors**, 4 warnings (all `_`-prefixed unused params)

## TypeScript

- `tsc --noEmit` — **Clean** (no errors)

## Branch

- `master` (design/animation merged + deleted)

## Changelog

### Stale Cache After Mutations — Server Response + Cache Invalidation
- Fixed: `lib/storage.ts` — `addClient`/`updateClient` now `await res.json()` and return server-processed Client (R2 URLs, server timestamps). Error messages parsed from server body. localStorage cache updated with server-processed data instead of raw user input. `deleteClient` now syncs localStorage cache too.
- Fixed: `app/page.tsx` — `handleDetailUpdate` and `onSave` handler now async, use server return values for React state. On error, `alert()` the server error message + `fetchClients()` rollback to restore fresh state.
- Fixed: `components/ClientDetail.tsx` — `handleDelete` uses `deleteClient` from `@/lib/storage` instead of raw `fetch`. Catches errors with `alert()`. localStorage cache now properly synced on delete.
- Fixed: `app/api/clients/route.ts` — removed `Cache-Control: public, max-age=10, stale-while-revalidate=30` from GET response (was causing stale data after mutations).
- Fixed: `app/api/clients/[id]/route.ts` — removed `Cache-Control: public, max-age=60` from GET response (same reason).

### PWA Install Alert
- Fixed: popup still showing after install (wrong SSR `isStandalone` initialization)
- Fixed: no install button on unsupported browsers (now hidden)
- Fixed: cannot dismiss
- Added: standalone mode detection (`display-mode: standalone`, `navigator.standalone`)
- Added: guard for unsupported browsers (non-iOS without beforeinstallprompt)

### Prettier
- `.prettierrc` created (no semi, single quotes, trailing commas, tabWidth 2, printWidth 100)
- Ignored: `.next`, `out`, `build`, `public/sw.js`, `node_modules`
- Formatted 70 files across the project

### Animations
All CSS-only, using `tw-animate-css`:

| Component         | Animation                       |
| ----------------- | ------------------------------- |
| LoginModal        | `animate-in fade-in zoom-in-95` |
| RouteModal        | `slide-in-from-bottom-10`       |
| DesktopCardView   | hover lift `-translate-y-0.5`   |
| SelectionToolbar  | `slide-in-from-bottom-2`        |
| SuggestionBadge   | `zoom-in-75`                    |
| EmptyState        | `fade-in duration-500`          |
| CopyDropdown      | `zoom-in-95`                    |
| PageHeader search | `transition-all duration-200`   |

### Plugins (global opencode)
- opencode-mem, opencode-command-inject, opencode-background-agents, @tarquinen/opencode-dcp, opencode-snip
- Local `plugins/termux-notify.ts`
- filesystem MCP

### Cleanup
- Removed unused `tests/`, `jest.config.js`, stale logs, codemap system
- Fixed `turbapack` typo, all lint errors/warnings
- Simplified `app/page.tsx`

### Deploy

- `TELEGRAM_CHAT_ID` updated on Vercel to `-1004343649661`
- Production deploy successful → `https://data.mcky.space`

### Suggestions

- Fixed: admin suggestions page not loading (missing `useEffect` call on mount)
- Fixed: approve/reject buttons stuck (added `processingSuggestion` state + spinner)
- Fixed: approve not updating client data locally (use suggestion data instead of `fetchClients()`)
- Fixed: race condition / SW cache overriding optimistic status (merge API state with local state in `useEffect`)
- Fixed: SW cache returning stale `/api/suggestions` and `/api/clients` responses (added `NetworkOnly` rule in `app/sw.ts` before `defaultCache`)

## Known

- No test runner
- `/usr/bin/env` broken on Termux
