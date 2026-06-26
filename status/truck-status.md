---
type: project-status
project: truck
last_updated: 2026-06-26
id: truck-status
last_commit: 95c380f
title: truck-status
timestamp: 2026-06-26T17:55:39Z
---

# Project Status — truck

## Current State

Active Development — 16/16 tests passing, 0 ESLint errors, clean `tsc --noEmit`

## Stack

- React 19 + Vite 8 + TypeScript 6 + Supabase (timestamptz, Asia/Bangkok)
- react-router-dom v7, @tanstack/react-query v5
- PWA via vite-plugin-pwa (injectManifest)
- Custom themes.css (16 themes, default: clean-light)
- Telegram Bot API for account requests
- Node v22.14.0 (ARM64 binary)

## Routes

| Route | Component | Description |
|-------|-----------|-------------|
| `/` or `/daily` | DailyView | บันทึกกะรายวัน — DateSlider, ShiftBadge, OdometerCard, CounterCard, LeaveCard |
| `/shifts` | ShiftCalendar | ตารางกะรายเดือน + leave summary |
| `/income` | IncomeView | รายได้/ภาษีรายเดือน — HeroCard, SalaryBreakdown, TaxSummary |
| `/history` | History | ตารางประวัติรายเดือน |
| `/profile` | ProfilePage | โปรไฟล์ + KPI ปี + อีเมล/รหัสผ่าน + แผงแอดมิน |
| `/changelog` | Changelog | What's New — 5 รายการ/หน้า + load more |

## Components

### Common
- **PageHeader** — back button `<` + title (22px, 900 weight) + optional description + children in 6fr/4fr grid
- **MonthYearSelector** — prev/next buttons + clickable label → MonthYearPopup (42px, radius 12px)
- **Skeleton** — theme-aware shimmer (`var(--skeleton-base)`/`var(--skeleton-shine)`), props: width/height/borderRadius/className
- **ConfirmModal** — reusable dialog with `.confirm-overlay` + `.confirm-dialog`
- **Skeletons**: DailyViewSkeleton, ShiftCalendarSkeleton, IncomeViewSkeleton (matching real 2-column layouts)

### DailyView
- **DailyView** — ShiftBadge (solid card), OdometerCard (summary banner: ระยะทาง/รอบ/จุดส่ง + ไมล์เข้า/ออก/OT/สาย, dashed dividers), CounterCard (4 steppers: รอบ/จุด + งานช่วย/งานแก้, 2×2 layout, dashed dividers), LeaveCard (ลา, glow animation)
- 2-column desktop: left = ShiftBadge + OdometerCard, right = CounterCard + Save

### Profile
- **ProfilePage** — avatar, display name, email, KPI ปี (8 items, 2 columns + income/tax + leave remaining), year picker, email/password change (2 columns), what's new, logout (red bg)
- **EmailChangeModal** / **PasswordChangeModal** / **ProfileEditModal** — reauthenticate via `signInWithPassword()` ก่อน `updateUser()`
- **AdminPanel** — จัดการผู้ใช้งาน / ตั้งค่ารายได้
- **UserManagement** — tabs (all/pending/approved/rejected), search, approve/reject/reset password
- **IncomeSettings** — 11 ค่า (เงินเดือน, ค่ารอบ, ค่า OT, ฯลฯ) → upsert `income_settings`

### Header / Auth / ErrorBoundary
- **Header** — avatar 32px + display name + pending-sync badge → profile link
- **AuthScreen** — tab bar "เข้าสู่ระบบ" / "ขอบัญชีใหม่" → Supabase signInWithPassword / Telegram bot
- **ErrorBoundary** — class component wrapping lazy routes, RouteError fallback with "ลองใหม่" retry

### ShiftCalendar / History / IncomeView
- **ShiftCalendar** — CalendarGrid (3-row cells: date, ★/⚡, shift time + purple 'x2' badge for special days) + ShiftModal (Clock/Lightning/Trash icons) + ShiftSummary (yearly logs, ChartBar icon)
- **History** — DailyList with 'x2' badge for special days
- **IncomeView** — MonthYearSelector + HeroCard (net income) + SalaryBreakdown (left) + TaxSummary (right) in 2-col grid. Uses `calculateIncome(logs, daysInMonth, settings)`

## Design System

- **16 themes**: 5 light (clean-light, retro-pastel, modern, neobrutalist, summer-morning), 5 dark (clean-dark, retro-dark, midnight-ocean, twilight, sunset), 6 shinchan
- **Picker**: 2-column grid (light/dark) + collapsible "ชินจัง (6)" section; closes on selection
- **Clean light/dark**: gradient bg (160°) + SVG noise texture overlay (feTurbulence, 8% opacity)
- **Shinchan**: glass effect (`backdrop-filter: blur(8px)`) on `.card`, `.summary-banner`, `.cal-cell`, `.shift-badge-wrapper`, `.mys-chip`; solid bg + 3px border on `.modal-content`, `.month-bar`; dark-on-gradient text for light shinchan themes
- **Neobrutalist**: vivid yellow `#fde047` bg, blue `#2563eb` primary, 3px black borders, offset shadows
- CSS custom properties `--primary`/`--primary-bg`/`--secondary` use attribute selector specificity (no `!important`)
- Spacing system: `--space-2xs`(2px) to `--space-3xl`(30px) used across all margin/padding/gap
- `toBuddhistYear(year)` from `@/constants` แทน inline `+ 543`

## Data Model

- **Income Settings**: `income_settings` table (key/value/label, 11 defaults, RLS: select all / write admin) → `useQuery(['income-settings'])` → `calculateIncome()` with merge + `DEFAULT_SETTINGS`
- **Leave Counts**: Monthly from `monthly-logs` query, yearly from `yearly-logs` query — both invalidated on upsert/delete
- **Yearly KPI**: Group yearly logs by month → `calculateIncome()` per month → sum totals (rounds, points, OT, work/sick/personal days, netIncome, totalTax, totalKm)
- **Back Exit Confirm**: `navDepthRef` tracks forward nav depth; popstate decrements; confirm dialog on ≤ 0; `pushState` on mount to prevent accidental close
- **Offline Queue**: `src/lib/offlineQueue.ts` — `saveLog()`/`removeLog()` attempt Supabase, fallback to localStorage queue + optimistic cache update; `replayQueue()` iterates queued mutations (continues on error, retries remaining); dedup: same-day upsert replaces previous
- **Focus chain**: `useRef` + `.current?.focus()` แทน `document.getElementById`
- **Performance**: DailyView handlers wrapped in `useCallback` + `formRef` (single ref mirroring form state, decouples handler identity from form value changes)

## Themes

- **16 themes**: 5 light (clean-light, retro-pastel, modern, neobrutalist, summer-morning), 5 dark (clean-dark, retro-dark, midnight-ocean, twilight, sunset), 6 shinchan
- **Picker**: 2-column grid (light/dark) + collapsible "ชินจัง (6)" section; closes on selection
- **Clean light/dark**: gradient bg (160°) + SVG noise texture overlay (feTurbulence, 8% opacity)
- **Shinchan**: glass effect (`backdrop-filter: blur(8px)`) on `.card`, `.summary-banner`, `.cal-cell`, `.shift-badge-wrapper`, `.mys-chip`; solid bg + 3px border on `.modal-content`, `.month-bar`; dark-on-gradient text for light shinchan themes
- **Neobrutalist**: vivid yellow `#fde047` bg, blue `#2563eb` primary, 3px black borders, offset shadows
- CSS custom properties `--primary`/`--primary-bg`/`--secondary` use attribute selector specificity (no `!important`)
- Spacing system: `--space-2xs`(2px) to `--space-3xl`(30px) used across all margin/padding/gap
- `toBuddhistYear(year)` from `@/constants` แทน inline `+ 543`

## Tests (16)

| File | Tests | Coverage |
|------|-------|----------|
| `calculator.test.ts` | 4 | base, round+OT, holiday, custom settings |
| `OdometerCard.test.tsx` | 7 | render, values, focus chain, save |
| `OfflineBanner.test.tsx` | 3 | online/offline toggling |
| *(added in review round 2)* | 2 | useMemo pattern, type safety |

Command: `node node_modules/.pnpm/vitest@3.2.6_jsdom@29.1.1_lightningcss@1.32.0_terser@5.48.0/node_modules/vitest/vitest.mjs run`

## PWA

- **Install banner** (`PwaInstallBanner.tsx`): floats above navtab (bottom: 88px), dismissed state in localStorage, 5s fallback for iOS
- **SW**: `registerSW({ immediate })` from `virtual:pwa-register`, cache version `ezzy-truck-v3`
- **Cache strategies**: `/assets/` JS → network-first with reload on 404; non-JS assets → cacheFirstWithFallback; icons/fonts → staleWhileRevalidate; pages/Supabase → networkFirst
- **Shortcuts**: บันทึกกะ (`/daily?today=1`), ตารางกะ (`/shifts`), รายได้ (`/income`), โปรไฟล์ (`/profile`)
- **Lesson**: cache-first for hashed assets caused "Failed to fetch dynamically imported module" — switched to network-first

## CI/CD — GitHub Actions

- Workflow: `.github/workflows/deploy-edge-functions.yml`
- Trigger: push to `master` changing `supabase/functions/**`
- Steps: checkout → `supabase link` → git diff → deploy changed functions
- Secret: `SUPABASE_ACCESS_TOKEN`, hardcoded ref `rmkevbdpmixsydldkiwv`

## Bundle (dist)

| Chunk | Size | gzip |
|-------|------|------|
| vendor-react | 194 KB | 60 KB |
| vendor-supabase | 208 KB | 54 KB |
| vendor-icons (@phosphor) | 139 KB | 32 KB |
| vendor-query | 39 KB | 12 KB |
| vendor-router | 36 KB | 13 KB |
| index (main) | 29 KB | 10 KB |
| DailyView | 25 KB | 7 KB |
| ProfilePage | 20 KB | 5 KB |
| Route chunks | 9-11 KB | 3-4 KB |
| PWA precache | ~1960 KB | — (55 entries) |

## API — Supabase Edge Functions

### `approve-user`
- Trigger: Admin approves pending user in-app
- Purpose: Sets `pending_users.status = 'approved'`, inserts into `user_profiles`, sends Telegram notification

### `get-all-users`
- Trigger: Admin opens UserManagement panel
- Purpose: Returns all users (id, email, display_name, status, role) — admin-only

### `notify-telegram`
- Trigger: New account request or approved/rejected
- Purpose: Sends Telegram message to admin chat with user details + status

## Hooks

- **`useOnlineStatus()`** — online/offline tracking
- **`useFocusTrap(active, ref, onClose?)`** — focus trap for modals: queries focusable elements, cycles Tab/Shift+Tab, Escape → onClose, restores previous focus on cleanup. Applied to all 6 modals.
- **`usePendingSyncCount()`** — counts pending offline mutations from `offline-mutation-*` localStorage keys
- All hooks in `src/hooks/` folder

## Accessibility

- `role="dialog"` + `aria-modal` + `aria-label` on Modals, ShiftModal
- `role="tablist"` + `role="tab"` + `aria-selected` on NavTabs
- `role="log"` + `aria-live="polite"` on ToastContainer
- `aria-label` on AuthScreen inputs, theme buttons

## Responsive

- Mobile-first (PWA) with desktop support
- Desktop: `content-area` max-width 1400px centered, nav-tabs centered
- Media queries: `≥768px` full-width, `≥1024px` 2-column grids (`.daily-grid`, `.history-grid`, `.shift-grid`, `.income-grid`)
- NavTabs bottom on all viewports (no `order: -1`)
- Profile/Admin/Changelog: single column on all sizes

## Icons

- `@phosphor-icons/react` (tree-shaking via npm, replaces unpkg CDN)
- 17 component files use Phosphor icons
- Prop pattern: `<Icon size={20} weight="duotone" />` or `ComponentType<{size, weight, style}>`

## Constraints

- ห้าม `@ts-ignore`, `@ts-expect-error` (ใช้ `as Record<string, any>` แทน `as any`)
- CSS overrides ใช้ `!important` เฉพาะเมื่อต้องชนะ base style (ยกเว้น `--primary`/`--primary-bg`/`--secondary`)
- Module-level `Intl.DateTimeFormat` instance (ไม่สร้างซ้ำใน render)
- localStorage key pattern: `last-saved-{userId}-{year}-{month}-{day}`
- Reauthentication: `signInWithPassword()` ก่อน `updateUser()`
- Avatar: Supabase Storage bucket `avatars`, path `{userId}/avatar.{ext}`, ≤2MB, upsert, RLS: SELECT public / write owner-only
- Telegram bot token/chat ID in `.env.local` (gitignored)

## Changelog

### 2026-06-26 — Code Review Fix Round 2 + Node.js 22
- **Fixed**: IncomeView `useMemo` for incomeSettings (prevent query re-fire); DailyView redundant invalidation removed; PwaInstallBanner typed with `BeforeInstallPromptEvent`
- **Added**: `useMemo` to 5 derived data sites (`allDaysArray`, `merged`, `tot`/`yearTot`, `kpiItems`, `filteredUsers`)
- **Fixed**: ShiftCalendar local interface → shared `LogEntryFull`; removed `console.error` in production
- **Updated**: UserManagement `STATUS_CONFIG` → module-level constant; `filteredUsers` wrapped in `useMemo`; hardcoded colors → CSS var references; removed `123456` from password reset UI
- **Fixed**: `void load()` → proper async call in IncomeSettings
- **Replaced**: Emoji icons with Phosphor (`WifiX`, `DownloadSimple`) in OfflineBanner + PwaInstallBanner
- **Added**: Constants `SHIFT_TIMES`, `SHIFT_OFF`, `DAY_TYPE_*`, `LEAVE_*`, `OFF_TYPES` → migrated comparison sites across 9 files
- **Upgraded**: Node v18.19.1 → v22.14.0 (official ARM64 binary) for Vite 8 / ESLint 10 / jsdom 29 compatibility. Commands: `node node_modules/vite/bin/vite.js build`, `tsc --noEmit`, vitest via direct path

### 2026-06-26 — Database Audit + Code Review
- **Added**: `logs` table migration (table definition, unique index `idx_logs_user_date`, RLS policies — user owns own logs, admin read-all); index `idx_logs_user_year_month` for filtering
- **Fixed**: `select('*')` → explicit column select across 6 query sites; removed `trucks` column writes (dead column); added `help_work`/`fix_work` to `LogEntryShared` interface
- **Fixed**: `clearTimeout` in ThemeEffects overlay timer; `scheduledTimers` cleanup in PwaInstallBanner; `.catch()` on `replayQueue`, `getSession`, `getUser`, `user_profiles` promises
- **Added**: `useCallback` + `formRef` pattern for DailyView handlers (`handleSave`, `handleSaveShift`, `handleDeleteShift`, `handleToggleDayType`) — prevents re-renders of `memo(OdometerCard)` and `memo(CounterCard)`
- **Fixed**: Replaced index-as-key with label keys in ProfilePage, SummaryCard, ShiftSummary

### 2026-06-25 — Code Review Fixes + Theme Overhaul
- **Fixed**: RLS — `pending_users` SELECT/UPDATE now requires `is_admin` (was any authenticated user)
- **Fixed**: Admin gate replaced hardcoded `email === 'mcky@mcky.space'` with `user_profiles.is_admin` DB query
- **Fixed**: CSS — removed duplicate `box-shadow` in twilight/cotton-candy; added missing `-webkit-backdrop-filter` on midnight-ocean `.shift-sheet`; removed duplicate `.profile-grid-left/-right` selectors; removed `!important` from `--primary`/`--primary-bg`/`--secondary` across 16 themes (49 declarations)
- **Fixed**: ThemeEffects cleanup chocobi-fall container on unmount (DOM leak)
- **Fixed**: Type safety — replaced `as any` with `Session`, `Record<string, any>` in App/DailyView/ProfilePage
- **Removed**: Unused deps `clsx`, `tailwind-merge`
- **Fixed**: DailyList inline `onMouseEnter/Leave` → `.daily-row:hover` CSS class
- **Added**: `toBuddhistYear()` to `@/constants` (unified 6 call sites)
- **Fixed**: Offline queue `replayQueue` now `continue`s on error instead of `break` (resilience)
- **Updated**: Replaced cotton-candy theme with neobrutalist (vivid yellow `#fde047` bg, blue `#2563eb` primary, 3px black borders, offset shadows); removed Liquid Glass (unregistered in picker)
- **Updated**: Added localStorage migration `cotton-candy` → `neobrutalist`
- **Updated**: Dashed dividers consistently (OdometerCard vertical + horizontal, input-group border-bottom); DailyViewSkeleton rewritten for 2-column `daily-grid` layout
- **Removed**: Unused `getShiftLabel` from `shift-helpers.ts`

### 2026-06-24 — Component Consolidation
- **Merged**: `HelpFixWorkCard.tsx` → CounterCard (all 4 steppers in one card with horizontal divider)
- **Merged**: `SummaryBanner.tsx` → OdometerCard (stats row + horizontal divider + input fields)

### 2026-06-18/20 — Dead Code Cleanup
- **Removed**: Empty `src/types.ts`; dead exports `APP_CONFIG` (constants), `getShiftLabel` (shift-helpers), `QueuedOp`/`getQueue` (offlineQueue), `ToastContext` (ToastContext)
- **Deduped**: `ShiftType` imports in ShiftModal + ShiftCalendar
- **Deleted**: `.opencode/` (62 MB stale node_modules), added to `.gitignore`
