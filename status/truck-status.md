---
type: project-status
project: truck
last_updated: 2026-06-26
id: truck-status
title: truck-status
timestamp: 2026-06-26T17:55:39Z
---

# Project Status — truck

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

### Hooks
- **`useOnlineStatus()`** — online/offline tracking
- **`useFocusTrap(active, ref, onClose?)`** — focus trap for modals: queries focusable elements, cycles Tab/Shift+Tab, Escape → onClose, restores previous focus on cleanup. Applied to all 6 modals.
- **`usePendingSyncCount()`** — counts pending offline mutations from `offline-mutation-*` localStorage keys
- All hooks in `src/hooks/` folder

### Responsive
- Mobile-first (PWA) with desktop support
- Desktop: `content-area` max-width 1400px centered, nav-tabs centered
- Media queries: `≥768px` full-width, `≥1024px` 2-column grids (`.daily-grid`, `.history-grid`, `.shift-grid`, `.income-grid`)
- NavTabs bottom on all viewports (no `order: -1`)
- Profile/Admin/Changelog: single column on all sizes

## API

### Edge Function: `approve-user`
- Trigger: Admin approves pending user in-app
- Purpose: Sets `pending_users.status = 'approved'`, inserts into `user_profiles`, sends Telegram notification

### Edge Function: `get-all-users`
- Trigger: Admin opens UserManagement panel
- Purpose: Returns all users (id, email, display_name, status, role) — admin-only

### Edge Function: `notify-telegram`
- Trigger: New account request or approved/rejected
- Purpose: Sends Telegram message to admin chat with user details + status

### Deployment
- Workflow: `.github/workflows/deploy-edge-functions.yml`
- Trigger: push to `master` changing `supabase/functions/**`
- Steps: checkout → `supabase link` → git diff → deploy changed functions
- Secret: `SUPABASE_ACCESS_TOKEN`, hardcoded ref `rmkevbdpmixsydldkiwv`

## Design System

- **16 themes**: 5 light (clean-light, retro-pastel, modern, neobrutalist, summer-morning), 5 dark (clean-dark, retro-dark, midnight-ocean, twilight, sunset), 6 shinchan
- **Picker**: 2-column grid (light/dark) + collapsible "ชินจัง (6)" section; closes on selection
- **Clean light/dark**: gradient bg (160°) + SVG noise texture overlay (feTurbulence, 8% opacity)
- **Shinchan**: glass effect (`backdrop-filter: blur(8px)`) on `.card`, `.summary-banner`, `.cal-cell`, `.shift-badge-wrapper`, `.mys-chip`; solid bg + 3px border on `.modal-content`, `.month-bar`; dark-on-gradient text for light shinchan themes
- **Neobrutalist**: vivid yellow `#fde047` bg, blue `#2563eb` primary, 3px black borders, offset shadows
- CSS custom properties `--primary`/`--primary-bg`/`--secondary` use attribute selector specificity (no `!important`)
- Spacing system: `--space-2xs`(2px) to `--space-3xl`(30px) used across all margin/padding/gap
- `toBuddhistYear(year)` from `@/constants` แทน inline `+ 543`
- **Icons**: `@phosphor-icons/react` (tree-shaking via npm, replaces unpkg CDN); 17 component files use Phosphor icons; prop pattern `<Icon size={20} weight="duotone" />` or `ComponentType<{size, weight, style}>`
- **Accessibility**: `role="dialog"` + `aria-modal` + `aria-label` on Modals; `role="tablist"` + `role="tab"` + `aria-selected` on NavTabs; `role="log"` + `aria-live="polite"` on ToastContainer; `aria-label` on AuthScreen inputs, theme buttons

## Data Model

- **Income Settings**: `income_settings` table (key/value/label, 11 defaults, RLS: select all / write admin) → `useQuery(['income-settings'])` → `calculateIncome()` with merge + `DEFAULT_SETTINGS`
- **Leave Counts**: Monthly from `monthly-logs` query, yearly from `yearly-logs` query — both invalidated on upsert/delete
- **Yearly KPI**: Group yearly logs by month → `calculateIncome()` per month → sum totals (rounds, points, OT, work/sick/personal days, netIncome, totalTax, totalKm)
- **Back Exit Confirm**: `navDepthRef` tracks forward nav depth; popstate decrements; confirm dialog on ≤ 0; `pushState` on mount to prevent accidental close
- **Offline Queue**: `src/lib/offlineQueue.ts` — `saveLog()`/`removeLog()` attempt Supabase, fallback to localStorage queue + optimistic cache update; `replayQueue()` iterates queued mutations (continues on error, retries remaining); dedup: same-day upsert replaces previous
- **Focus chain**: `useRef` + `.current?.focus()` แทน `document.getElementById`
- **Performance**: DailyView handlers wrapped in `useCallback` + `formRef` (single ref mirroring form state, decouples handler identity from form value changes)

## Changelog

### Week 2026-06-22
- **Node v22**: upgraded from v18 → v22.14.0 (ARM64) for Vite 8/ESLint 10/jsdom 29
- **Perf**: DailyView handlers wrapped in `useCallback` + `formRef` — stops memo'd children re-rendering
- **DB**: `logs` migration — unique idx `idx_logs_user_date`, RLS, `idx_logs_user_year_month`
- **Code quality**: explicit column selects (6 sites), removed dead `trucks` writes, shared `LogEntryFull`
- **Theme**: replaced cotton-candy → neobrutalist (yellow `#fde047` bg, blue `#2563eb` primary, 3px borders, offset shadows); removed Liquid Glass
- **Code review**: RLS hardened (`is_admin` check), admin gate from DB query (no hardcoded email), `!important` removed from 49 CSS decls, DOM leak fixed, `as any` → proper types, offline queue retries all items
- **Skeletons**: DailyView/ShiftCalendar/IncomeView rewritten to match real 2-column layouts
- **Deps**: removed unused `clsx`, `tailwind-merge`; constants extracted (`DAY_TYPE_*`, `LEAVE_*`)
- **Components merged**: `HelpFixWorkCard` → CounterCard, `SummaryBanner` → OdometerCard
- **Dead code cleanup**: removed empty `types.ts`, dead exports, `.opencode/` (62MB stale node_modules)

### 2026-06-15
- Initial project setup with React 19 + Vite 6 + Supabase

## PWA

- **Install banner** (`PwaInstallBanner.tsx`): floats above navtab (bottom: 88px), dismissed state in localStorage, 5s fallback for iOS
- **SW**: `registerSW({ immediate })` from `virtual:pwa-register`, cache version `ezzy-truck-v3`
- **Cache strategies**: `/assets/` JS → network-first with reload on 404; non-JS assets → cacheFirstWithFallback; icons/fonts → staleWhileRevalidate; pages/Supabase → networkFirst
- **Shortcuts**: บันทึกกะ (`/daily?today=1`), ตารางกะ (`/shifts`), รายได้ (`/income`), โปรไฟล์ (`/profile`)
- **Lesson**: cache-first for hashed assets caused "Failed to fetch dynamically imported module" — switched to network-first

## Tests

| File | Tests | Coverage |
|------|-------|----------|
| `calculator.test.ts` | 4 | base, round+OT, holiday, custom settings |
| `OdometerCard.test.tsx` | 7 | render, values, focus chain, save |
| `OfflineBanner.test.tsx` | 3 | online/offline toggling |
| *(added in review round 2)* | 2 | useMemo pattern, type safety |

Command: `node node_modules/.pnpm/vitest@3.2.6_jsdom@29.1.1_lightningcss@1.32.0_terser@5.48.0/node_modules/vitest/vitest.mjs run`

## Known Issues

- No `@ts-ignore`, `@ts-expect-error` (use `as Record<string, any>` instead of `as any`)
- CSS overrides use `!important` only when needed to win base styles (except `--primary`/`--primary-bg`/`--secondary`)
- Module-level `Intl.DateTimeFormat` instance (don't recreate in render)
- localStorage key pattern: `last-saved-{userId}-{year}-{month}-{day}`
- Reauthentication: `signInWithPassword()` before `updateUser()`
- Avatar: Supabase Storage bucket `avatars`, path `{userId}/avatar.{ext}`, ≤2MB, upsert, RLS: SELECT public / write owner-only
- Telegram bot token/chat ID in `.env.local` (gitignored)
