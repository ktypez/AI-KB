---
type: agent
id: truck-agent
project: truck
last_updated: 2026-06-22
status_ref: STATUS.md in project root
personality: overtime enthusiast
stack:
  - React 19 + Vite 6 + TypeScript + Supabase + PWA
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
| `src/lib/` | Supabase client (`sb`) |
| `src/hooks/` | `useOnlineStatus` |
| `src/utils/` | `calculateIncome()`, shift helpers |
| `src/components/` | UI — 6 views + shared components |
| `src/components/daily/` | Daily logging (DateSlider, ShiftBadge, OdometerCard, etc.) |
| `src/components/shifts/` | Monthly calendar (CalendarGrid, ShiftModal, ShiftSummary) |
| `src/components/history/` | Historical browsing |
| `src/components/income/` | Salary breakdown (HeroCard, SalaryBreakdown, TaxSummary) |
| `src/components/profile/` | Profile management modals |

## Architecture
```
main.tsx → App.tsx (auth gate + session + theme)
         → AppRoutes.tsx (lazy-loaded: DailyView, ShiftCalendar, History, IncomeView, ProfilePage, Changelog, AdminPanel, UserManagement, IncomeSettings)
         → Supabase (sb) + ReactQuery (monthly-logs, day-log, income, yearly-logs)
         → utils/calculator.ts (calculateIncome) + utils/shift-helpers.ts
         → AuthScreen (sign-in / request account via Telegram)
```

## Key Patterns
- **Auth gate**: App.tsx checks Supabase session → AuthScreen or main app
- **Toast**: `useToast()` from ToastContext — never `alert()` or `console.log()`
- **Modal pattern**: `.modal-backdrop` (fadeIn) + `.modal-content` (scaleIn, glassmorphism)
- **Theme**: CSS custom properties + `data-theme` (16 themes), saved in localStorage
- **Back button guard**: popstate handler + `navDepthRef` for PWA exit confirmation
- **LocalStorage key**: `last-saved-{userId}-{year}-{month}-{day}`
- **Timezone**: regex extract hh:mm from Supabase, `Intl.DateTimeFormat('sv-SE')` for local
- **Focus chain**: `useRef` + `.current?.focus()` — never `document.getElementById`
- **Modal pattern**: All 6 modals + MonthYearPopup use `.modal-backdrop` + `.modal-content`

## Triggers

### "update .md"
1. Read STATUS.md + AGENTS.md
2. Update STATUS.md (Components / Data Flow / Constraints)
3. Update project AGENTS.md if needed

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
