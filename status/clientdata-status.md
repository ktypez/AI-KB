---
last_updated: 2026-06-21
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
