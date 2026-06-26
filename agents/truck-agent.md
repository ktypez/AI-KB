---
type: agent
id: truck-agent
project: truck
last_updated: 2026-06-26
status_ref: STATUS.md in project root
personality: overtime enthusiast
stack:
  - React 19 + Vite 8 + TypeScript 6 + Supabase + PWA
  - react-router-dom v7, tanstack/react-query v5
  - Custom themes.css (16 themes, default: clean-light)
  - Telegram Bot API for account requests
path_alias: "@/" → "./src/"
supabase_client: sb from src/lib/supabase.ts
commands:
  dev: node node_modules/.bin/vite
  build: node node_modules/vite/bin/vite.js build
  test: node node_modules/.bin/vitest run
  lint: node node_modules/.bin/eslint src/
  format: node node_modules/.bin/prettier --write src/
prettier: no semi, single quotes, trailing comma all, 100 width
deployment: Vercel (SPA rewrite in vercel.json)
triggers:
  "update .md": Read STATUS.md + AGENTS.md, update Components/Data Flow/Constraints
  "wrap-day": Read diff → update Changelog.tsx + STATUS.md → git commit
  "cleanup": Scan unused → health check → present findings → update docs
env_vars:
  - VITE_SUPABASE_URL
  - VITE_SUPABASE_ANON_KEY
  - VITE_TELEGRAM_BOT_TOKEN
  - VITE_TELEGRAM_CHAT_ID
---

# Truck Agent

## Code Editing Rules
- `oldString` must be short & precise — no long code blocks (avoid "Could not find oldString")
- Always read the latest file version before editing

## Termux Environment
| Tool | Status |
|------|--------|
| Node.js | Use `node` directly — `node node_modules/.bin/<cmd>` |
| Supabase CLI | ❌ Not on Termux (CI only: `supabase/setup-cli@v1` in GitHub Actions) |
| cwebp | ✅ Available — `cwebp -q 80 input.jpg -o output.webp` |
| sharp / ffmpeg | ❌ Not available |

## Directory Map
| Directory | Responsibility |
|-----------|---------------|
| `.github/workflows/` | CI/CD — deploy edge functions on push to master |
| `supabase/functions/` | Edge functions (approve-user, get-all-users, notify-telegram) |
| `src/lib/` | Supabase client (`sb`), offline mutation queue (`offlineQueue`) |
| `src/hooks/` | `useOnlineStatus`, `useFocusTrap`, `usePendingSyncCount` |
| `src/utils/` | `calculateIncome()`, shift helpers |
| `src/components/` | UI — 6 views + shared components |
| `src/components/daily/` | Daily logging (DateSlider, ShiftBadge, OdometerCard, CounterCard, LeaveCard) |
| `src/components/shifts/` | Monthly calendar (CalendarGrid, ShiftModal, ShiftSummary) |
| `src/components/history/` | Historical browsing |
| `src/components/income/` | Salary breakdown (HeroCard, SalaryBreakdown, TaxSummary) |
| `src/components/profile/` | Profile management modals |
| `src/components/skeletons/` | Loading skeletons (DailyView, ShiftCalendar, IncomeView) |

## Architecture
```
main.tsx → App.tsx (auth gate + session + theme)
         → AppRoutes.tsx (lazy-loaded: DailyView, ShiftCalendar, History, IncomeView, ProfilePage, Changelog, AdminPanel, UserManagement, IncomeSettings)
         → ErrorBoundary wrapper per route (catch-all, RouteError fallback)
         → Supabase (sb) + ReactQuery (monthly-logs, day-log, income, yearly-logs)
         → offlineQueue (localStorage mutation queue, auto-replay on reconnect)
         → AuthScreen (sign-in / request account via Telegram)
```

## Key Patterns
- **Responsive**: mobile-first PWA, desktop uses max-width 1400px content-area centered. 2-column grids activated at 1024px. NavTabs stays at bottom on all viewport sizes.
- **Auth gate**: App.tsx checks Supabase session → AuthScreen or main app
- **Toast**: `useToast()` from ToastContext — never `alert()` or `console.log()`
- **Modal pattern**: `.modal-backdrop` (fadeIn) + `.modal-content` (scaleIn) — no glassmorphism on modals
- **Card margin**: `.card` has no margin-bottom; spacing via parent `gap` or `.view > .card + .card { margin-top: var(--space-md) }`
- **Spacing**: CSS var system `--space-2xs`(2px) through `--space-3xl`(30px) used across all margin/padding/gap
- **Theme**: CSS custom properties + `data-theme` (16 themes), saved in localStorage. `--primary`/`--primary-bg`/`--secondary` don't use `!important` (attribute selector specificity sufficient). Neobrutalist theme: vivid yellow bg, blue primary, thick black borders, offset shadows.
- **Shinchan glass**: All 6 shinchan themes apply `backdrop-filter: blur(8px)` + semi-transparent bg to `.card`, `.summary-banner`, `.cal-cell`, `.shift-badge-wrapper`, `.mys-chip`
- **Admin gate**: `user_profiles.is_admin` DB query (not hardcoded email)
- **Buddhist year**: `toBuddhistYear(year)` from `@/constants`
- **Back button guard**: popstate handler + `navDepthRef` for PWA exit confirmation
- **LocalStorage key**: `last-saved-{userId}-{year}-{month}-{day}`
- **Timezone**: regex extract hh:mm from Supabase, `Intl.DateTimeFormat('sv-SE')` for local
- **Focus chain**: `useRef` + `.current?.focus()` — never `document.getElementById`
- **Focus trap**: `useFocusTrap(active, ref, onClose?)` — traps Tab/Shift+Tab + Escape in modals, restores previous focus
- **Modal pattern**: All 6 modals + MonthYearPopup use `.modal-backdrop` + `.modal-content`
- **Skeleton loaders**: Theme-aware CSS skeleton (var(--skeleton-base)/var(--skeleton-shine) pulse animation) for DailyView, ShiftCalendar, IncomeView
- **Mutation invalidation contract**: any save that mutates `logs` must invalidate ALL of: `['monthly-logs', userId, year, month]`, `['yearly-logs', userId, year]`, `['income', userId, year, month]`. `App.tsx handleSaveSuccess` (DailyView path) and `ShiftCalendar.tsx` upsert/delete onSuccess must stay in sync — if one is updated, the other must be too. Lesson: X2/special days picked only from calendar were invisible to IncomeView because ShiftCalendar onSuccess only invalidated logs.
- **Performance ref pattern**: For handlers with many closure deps (e.g. `handleSave` reading 15+ form values), use a single `formRef` object updated every render + `useCallback` with minimal stable deps. The handler reads `formRef.current` instead of closure values. This prevents memo'd children from re-rendering when form state changes but handler identity is stable.

## Triggers

### "update .md"
1. Read project AGENTS.md + current KB status
2. Update `~/AI-KB/status/truck-status.md` with latest changes
3. Update `~/AI-KB/agents/truck-agent.md` (directory map, architecture, patterns)
4. If project AGENTS.md has stale info, update it too

### "wrap-day"
1. Read diff, Changelog, STATUS.md
2. Add Thai summary to `src/components/Changelog.tsx` as new `v{YYYY.MM.DD}` entry
3. Update STATUS.md — Components / Data Flow / Constraints
4. `git add` + commit `"docs: wrap-day {YYYY-MM-DD}"`
5. Only touch Changelog.tsx and STATUS.md

### "cleanup"
1. Scan unused imports, empty files, dead exports
2. Health check: `tsc --noEmit` + build
3. Deep scan: leftover dirs, `vite.log`, `console.log`, TODO/FIXME
4. Present findings for user to choose
5. Commit & Push if user says so
6. Update STATUS.md + project AGENTS.md
7. Never cleanup `.env*`, `node_modules/`, `dist/`, `.git/`, or essential config
