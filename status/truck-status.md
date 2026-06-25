---
last_updated: 2026-06-25
project: truck
type: status
last_commit: 6bfda29
---

# Project Status — truck

## Stack

- React 19 + Vite 8 + TypeScript 6 + Supabase (timestamptz, Asia/Bangkok timezone)
- react-router-dom v7, tanstack/react-query v5
- PWA via vite-plugin-pwa (injectManifest)
- Custom themes.css (16 themes, default: clean-light)
- Telegram Bot API for account requests

## Key Patterns

- `useToast()` from ToastContext — ใช้แทน alert/console ทุกครั้ง
- Timezone: regex extract hh:mm จาก Supabase string โดยตรง, `Intl.DateTimeFormat('sv-SE')` สำหรับ local timestamp
- Last-saved display: `lastSavedAt = lastSavedTime(localStorage) || serverLastSaved(updated_at regex)`
- manualChunks: function form (`id.includes('node_modules/react/')`)
- `updated_at` ต้อง set ใน upsert payload ทุกครั้ง (`new Date().toISOString()`)
- Focus chain ใช้ `useRef` + `.current?.focus()` แทน `document.getElementById`
- `getBangkokTimestamp()` module-level function (Intl.DateTimeFormat cached)
- Modal pattern: animation classes `.modal-backdrop` (fadeIn 0.2s) + `.modal-content`/`.confirm-dialog` (scaleIn 0.22s, scale 0.92→1). Glassmorphism styles (background, backdrop-filter, border, border-radius, padding, box-shadow) are in the CSS classes — modals only override width/maxWidth/overflowY inline. Dialog MUST be a child node of backdrop (flexbox centering on parent). All 6 modals + MonthYearPopup use the same pattern. ConfirmModal uses `.confirm-overlay` + `.confirm-dialog` same pattern.
- Profile modals: reauthenticate via `sb.auth.signInWithPassword()` ก่อน updateUser
- **Spacing**: CSS custom property system `--space-2xs`(2px) / `--space-xs`(4px) / `--space-sm`(8px) / `--space-md`(12px) / `--space-lg`(16px) / `--space-xl`(20px) / `--space-2xl`(24px) / `--space-3xl`(30px). All margin/padding/gap across the site uses these variables.
- **Card margin**: `.card` has NO margin-bottom. Spacing between cards handled by parent container `gap` (Daily/History/Shift/Income grid containers) or `.view > .card + .card { margin-top: var(--space-md) }` (Profile/Admin).
- **Buddhist year**: Use `toBuddhistYear(year)` from `@/constants` instead of inline `+ 543`

## CI/CD — GitHub Actions

- Workflow: `.github/workflows/deploy-edge-functions.yml`
- Trigger: push to `master` ที่เปลี่ยนไฟล์ใน `supabase/functions/**`
- Steps: checkout (fetch-depth:0) → supabase/setup-cli@v1 → `supabase link --project-ref rmkevbdpmixsydldkiwv` → git diff หาฟังก์ชันที่เปลี่ยน → deploy ทีละอัน
- `SUPABASE_ACCESS_TOKEN` (secret) + hardcoded ref ID (`rmkevbdpmixsydldkiwv`)
- Edge functions: `approve-user`, `get-all-users`, `notify-telegram`

## Responsive

- Mobile-first (PWA) with desktop support
- Desktop: `content-area` max-width 1400px centered, nav-tabs max-width 1400px centered
- Media queries: `@media (min-width: 768px)` for full-width desktop, `@media (min-width: 1024px)` for 2-column grid layouts
- 2-column grids: `.daily-grid`, `.history-grid`, `.shift-grid`, `.income-grid` with `grid-template-columns: 1fr 1fr` at ≥1024px
- NavTabs stays at bottom on all viewport sizes (no `order: -1`)
- Profile page: full-width on desktop (`max-width: none` via `:has()` selector)
- Admin/Profile/Changelog: single column on all screen sizes (no grid overrides)

## Bundle (dist) — after vendor chunk split

| Chunk                                | Size    | gzip           |
| ------------------------------------ | ------- | -------------- |
| vendor-react                         | 194 KB  | 60 KB          |
| vendor-supabase                      | 208 KB  | 54 KB          |
| vendor-icons (@phosphor-icons/react) | 139 KB  | 32 KB          |
| vendor-query (@tanstack-query)       | 39 KB   | 12 KB          |
| vendor-router                        | 36 KB   | 13 KB          |
| index (main)                         | 29 KB   | 10 KB          |
| DailyView                            | 25 KB   | 7 KB           |
| ProfilePage                          | 20 KB   | 5 KB           |
| Route chunks                         | 9-11 KB | 3-4 KB         |
| PWA precache                         | ~1960 KB | — (55 entries) |

## Tests (14)

- calculator.test.ts — 4 tests (base, round+OT, holiday, custom settings)
- OdometerCard.test.tsx — 7 tests (render, values, focus chain, save)
- OfflineBanner.test.tsx — 3 tests (online/offline toggling)

## Accessibility

- role="dialog" + aria-modal + aria-label on Modals, ShiftModal
- role="tablist" + role="tab" + aria-selected on NavTabs
- role="log" + aria-live="polite" on ToastContainer
- aria-label on AuthScreen inputs, theme buttons

## Themes

- 16 themes total (default: `clean-light`)
- 5 light: clean-light, retro-pastel, modern, neobrutalist, summer-morning
- 5 dark: clean-dark, retro-dark, midnight-ocean, twilight, sunset
- 6 shinchan: shinchan, shinchan-blue, shinchan-bath, shinchan-sleep, shinchan-cute, shinchan-white
- Theme picker: 2-column grid (light/dark) + collapsible "ชินจัง (6)" section at bottom
- Theme modal closes on selection (theme flash effect visible)
- `clean-light` / `clean-dark`: gradient bg (160°) + SVG noise texture overlay (feTurbulence, 8% opacity)
- All themes use `.hero-card` selector for HeroCard overrides
- All shinchan `.tab` has separate rules (not grouped with wiggle selector)
- Shinchan light themes (shinchan, shinchan-blue, shinchan-bath) use dark-on-gradient pattern (active buttons/hero/dateslider have dark text like shinchan-white)
- shinchan/shinchan-blue/shinchan-bath have `.modal-content, .month-bar` override (solid bg + 3px border)
- Shinchan themes (all 6) apply `backdrop-filter: blur(8px)` + semi-transparent bg to `.card`, `.summary-banner`, `.cal-cell`, `.shift-badge-wrapper`, `.mys-chip` (glass effect)
- CSS custom properties `--primary`, `--primary-bg`, `--secondary` no longer use `!important` (attribute selector specificity is sufficient)
- **Neobrutalist**: vivid yellow bg (`#fde047`), blue primary (`#2563eb`), thick 3px black borders, offset box-shadows (`4px 4px 0px #1a1a1a`), rounded 12px corners

## Hooks

- `useOnlineStatus()` — extract from OfflineBanner
- `useFocusTrap()` — trap focus within a container (modal/dialog): `useFocusTrap(active, ref, onClose?)`. Queries focusable elements, cycles Tab/Shift+Tab, Escape calls onClose, restores previous focus on cleanup. Applied to all 6 modals.
- `usePendingSyncCount()` — count pending offline mutations from localStorage keys matching `offline-mutation-*`. Returns `number`.
- `useRef` patterns — OdometerCard (focus chain), AuthScreen (password ref)
- `src/hooks/` folder: `useOnlineStatus.ts`, `useFocusTrap.ts`, `usePendingSyncCount.ts`

## Library — offlineQueue

- `src/lib/offlineQueue.ts` — offline mutation queue using localStorage:
  - `saveLog()` / `removeLog()`: attempt Supabase upsert/delete; if offline, queue to localStorage + optimistically update cache
  - `replayQueue(userId, queryClient?, onNotify?)`: iterate queued mutations → execute Supabase upsert/delete → dequeue on success, `continue` on error (skip failing item, retry remaining)
  - `getPendingCount(userId?)`: return count of pending mutations
  - Deduplication: same-day upsert replaces previous; delete after upsert removes the upsert

## Components

### Common

- `PageHeader.tsx` — shared header component: back button `<` + title (font 22, weight 900) + optional description (14px) + optional children in 2-col grid (6fr/4fr). Hard text shadow on title+desc. Used by all 6 views.
- `MonthYearSelector.tsx` — prev/next `<` `>` buttons + clickable month/year label → opens `MonthYearPopup`. Height 42px, radius 12px, flex-fill.
- `Skeleton.tsx` — base skeleton component: CSS `var(--skeleton-base)`/`var(--skeleton-shine)` for theme-aware shimmer (animation `skeleton-pulse 1.4s ease-in-out infinite`). Props: `width`, `height`, `borderRadius` (default 8), `className`. Exported as named export + default.
- `skeletons/DailyViewSkeleton.tsx` — skeleton for DailyView: uses `daily-grid` with left/right columns matching real layout. Left: ShiftBadge skeleton (flex row with button + toggle) + OdometerCard skeleton (3 stats with dashed dividers + 4 input rows with dashed borders). Right: CounterCard skeleton (2×2 counters with dashed dividers + info pill) + Save button skeleton.
- `skeletons/ShiftCalendarSkeleton.tsx` — skeleton for ShiftCalendar: month bar (200x36) + legend row (80x16 + 80x16) + 4 rows × 6 columns of date cells (each 44x44, radius 10) in CSS grid `repeat(6, 1fr)`. Spacing: row gap 6px, col gap 4px.
- `skeletons/IncomeViewSkeleton.tsx` — skeleton for IncomeView: month selector row (200x36) + hero card (340x110) + heading (100x18) + 6 salary rows (label 80x14 + value 60x14) + tax summary (340x50). Two hero card rows: one large (140x28) + one small (80x18).
- `ConfirmModal.tsx` — reusable confirmation dialog with `.confirm-overlay` + `.confirm-dialog` pattern

### DailyView

- `DailyView.tsx` — หน้าบันทึกกะรายวัน: DateSlider เลือกวัน, ShiftBadge แสดงกะ (solid card, no glass), OdometerCard (รวม SummaryBanner: ระยะทาง/รอบ/จุดส่ง + ไมล์เข้า/ออก/OT/สาย คั่นด้วย dashed dividers ทั้งแนวตั้งและแนวนอน), CounterCard (4 steppers: รอบ/จุด + งานช่วย/งานแก้ ใน 2×2 layout คั่นด้วย dashed dividers), LeaveCard (ลา, มี glow animation)
- Left column (desktop ≥1024px): ShiftBadge + OdometerCard
- Right column (desktop ≥1024px): CounterCard + info pill + Save button
- **Deleted files**: `HelpFixWorkCard.tsx` (merged into CounterCard), `SummaryBanner.tsx` (merged into OdometerCard)

### ErrorBoundary

- `AppRoutes.tsx` wraps each lazy-loaded route with `<ErrorBoundary fallback={<RouteError />}>` (catch-all per view)
- `RouteError` component: fallback UI with error icon + "เกิดข้อผิดพลาด" message + "ลองใหม่" retry button
- `ErrorBoundary` class component: `componentDidCatch(error, errorInfo)` logs to console, `getDerivedStateFromError` sets hasError flag

### Profile

- `ProfilePage.tsx` — แสดง avatar, display name, email, KPI ปี (8 รายการ 2 คอลัมน์ + รายได้/ภาษี + วันลาคงเหลือ), เลือกปีได้ (ปุ่ม ◀ ▶), ปุ่มเปลี่ยนอีเมล/รหัสผ่าน (2 คอลัมน์), ปุ่ม What's New, ออกจากระบบ (พื้นหลังแดง). Admin panel visibility gated by `user_profiles.is_admin` DB query (not hardcoded email).
- `profile/EmailChangeModal.tsx` — modal เปลี่ยนอีเมล + ยืนยันรหัสผ่านปัจจุบัน
- `profile/PasswordChangeModal.tsx` — modal 3 ช่อง (รหัสปัจจุบัน / ใหม่ / ยืนยันใหม่)
- `profile/ProfileEditModal.tsx` — modal แก้ไข display name + อัปโหลด avatar ไปยัง Supabase Storage (bucket `avatars`)
- `profile/AdminPanel.tsx` — แผงควบคุมแอดมิน: เมนู "จัดการผู้ใช้งาน" + "ตั้งค่ารายได้" (single-page nav, no AdminLayout wrapper)
- `profile/UserManagement.tsx` — จัดการผู้ใช้: tabs (all/pending/approved/rejected), ค้นหา, อนุมัติ/ปฏิเสธ/รีเซ็ตรหัสผ่าน
- `profile/IncomeSettings.tsx` — ตั้งค่ารายได้: ฟอร์มแก้ 11 ค่า (เงินเดือน, ค่ารอบ, ค่า OT, ฯลฯ) → upsert `income_settings` table

### Header

- `Header.tsx` — แสดง avatar วงกลม (32px) + display name (จาก `auth.user_metadata`) + pending-sync badge (usePendingSyncCount) พร้อมลิงก์ไปหน้า profile (ปุ่มออกจากระบบถูกลบออกแล้ว)

### Auth

- `AuthScreen.tsx` — หน้าเข้าสู่ระบบ: tab bar สลับ "เข้าสู่ระบบ" / "ขอบัญชีใหม่"
  - Tab เข้าสู่ระบบ: อีเมล + รหัสผ่าน → Supabase signInWithPassword
  - Tab ขอบัญชีใหม่: กรอกอีเมล → ส่ง Telegram bot → แสดง success message
  - Telegram bot token + chat ID อยู่ใน `.env.local` (VITE_TELEGRAM_BOT_TOKEN, VITE_TELEGRAM_CHAT_ID)

### Changelog

- `Changelog.tsx` — หน้า What's New แสดงประวัติเวอร์ชั่นรายวันตั้งแต่ 1 มิ.ย. 2026 (5 รายการต่อหน้า + load more)

### ShiftCalendar

- `ShiftCalendar.tsx` — ตารางกะรายเดือน พร้อม leave summary + loading spinner (@phosphor-icons/react). `upsertMutation` และ `deleteMutation` ต้อง invalidate `['income', userId, year, monthNum]` ด้วย (ไม่ใช่แค่ logs) — ป้องกัน stale ตอน user เลือกกะจาก calendar โดยไม่เปิด DailyView, IncomeView query จะไม่ refresh ถ้า invalidate แค่ logs
- `shifts/CalendarGrid.tsx` — ตารางปฏิทิน 3 แถว (วันที่, ★/⚡ indicator, เวลากะ) + Badge 'x2' (สีม่วง) สำหรับ day_type === 'special'
- `shifts/ShiftModal.tsx` — modal เลือกกะ/ลา (ใช้ @phosphor-icons/react: Clock, Lightning, Trash)
- `shifts/ShiftSummary.tsx` — แสดงสรุปวันทำงาน/หยุด/ลา (ใช้ yearly logs query, ChartBar icon)

### History

- `History.tsx` — ตารางประวัติรายเดือน แสดง day_type ใน merged data
- `history/DailyList.tsx` — แสดง Badge 'x2' ข้างกะ เมื่อ day_type === 'special'

### IncomeView

- `IncomeView.tsx` — หน้ารายได้/ภาษีรายเดือน: MonthYearSelector, HeroCard (ยอดสุทธิ, full-width top), SalaryBreakdown (ซ้าย), TaxSummary (ขวา) ใน 2-column grid desktop
  - ดึง `income_settings` จาก Supabase → ส่งเข้า `calculateIncome(logs, daysInMonth, settings)` → recalc อัตโนมัติเมื่อ settings เปลี่ยน
- `TaxSummary.tsx` — สรุปภาษีหัก ณ ที่จ่าย 3%: แสดง เงินเดือน/ภาษี/คงเหลือ per section (base, extras, total) ด้วย CSS grid (`1fr auto`) สำหรับ left-label / right-value alignment. รายได้เพิ่ม section ซ่อนเมื่อ `othersGross === 0`. Helper component `TaxRow` รับ `label`, `value`, `negative`, `bold`, `highlight` props

## Data Flow — Income Settings

- `income_settings` table (Supabase): key/value/label, seed 11 ค่า default, RLS select all / write admin only
- `IncomeSettings.tsx` (admin): ดึง settings → แก้ฟอร์ม → upsert ทีเดียว
- `IncomeView.tsx`: `useQuery(['income-settings'])` → map to `IncomeSettings` → ส่งไป `calculateIncome()`
- `calculateIncome()`: รับ optional `settings` param, merge กับ `DEFAULT_SETTINGS`, ใช้ `s.tax_rate / 100` แทน hardcoded
- Query key includes settings object → recompute when admin saves new values

## Data Flow — Leave Counts

- Monthly totals (`tot`): คำนวณจาก `monthly-logs` query → invalidate เมื่อ upsert/delete → update realtime
- Yearly totals (`yearTot`): คำนวณจาก `yearly-logs` query → invalidate พร้อมกับ monthly logs → update realtime
- Fix: ทั้ง `upsertMutation.onSuccess` และ `deleteMutation.onSuccess` invalidate ทั้ง monthly และ yearly logs

## Data Flow — Yearly KPI

- KPI ปี: Group yearly logs by month → `calculateIncome()` ต่อเดือน → รวมผล ลัพธ์ (rounds, points, otHours, workDays, sickDays, personalDays, netIncome, totalTax, totalKm)
- Off days: นับจาก logs ที่ `is_work === false || shift_time === 'หยุด' || day_type === 'วันหยุด'` และไม่มี `leave_type`
- Income/Tax: รวม `netIncome` และ `totalTax` จากทุกเดือน (ใช้ `calculateIncome` ที่มีอยู่แล้ว)

## Data Flow — Back Exit Confirm

- `App.tsx` `navDepthRef` (เริ่ม -1 → 0 ตอน mount) + `isBackNavRef` flag
- Forward navigation (React Router pathname change): increment `navDepthRef` (ข้ามถ้าเป็น popstate re-render)
- Popstate: decrement ถ้า navDepth > 0 (ยังมีหน้าในแอป) → set `isBackNavRef = true`; แสดง confirm ถ้า ≤ 0
- Confirm: pushState กลับถ้ายกเลิก, `window.close()` ถ้าตกลง (PWA standalone)
- `window.history.pushState(null, '', window.location.href)` ตอน mount เพื่อกันออกโดยไม่ตั้งใจ

## Icons

- `@phosphor-icons/react` (npm) แทน unpkg CDN — tree-shaking ดึงเฉพาะ icon ที่ใช้
- 17 component files ใช้ @phosphor-icons/react
- Prop pattern: `<Icon size={20} weight="duotone" />` หรือ `ComponentType<{size, weight, style}>`
- SalaryRow.tsx รับ icon เป็น ComponentType (ไม่ใช่ string class)

## Cleanup (2026-06-18 + 2026-06-20 + 2026-06-25)

### 2026-06-18 / 2026-06-20
- `src/types.ts` — removed (empty file, never imported)
- `src/constants.ts` — removed dead exports `APP_CONFIG` (unused)
- `src/utils/shift-helpers.ts` — removed dead export `getShiftLabel`
- `src/lib/offlineQueue.ts` — removed dead exports `QueuedOp` (interface), `getQueue` (function)
- `src/components/ToastContext.tsx` — removed dead export `ToastContext` (raw context, consumers use `useToast`)
- `src/components/shifts/ShiftModal.tsx` — dedup `ShiftType` (now imports from shift-helpers)
- `src/components/ShiftCalendar.tsx` — dedup `ShiftType` (now imports from shift-helpers)
- `.opencode/` — deleted (62 MB stale node_modules, plans dir), added to `.gitignore`

### 2026-06-25 — Code review fixes
- **RLS**: `pending_users` SELECT/UPDATE now requires `is_admin` (was any authenticated user)
- **Admin gate**: replaced hardcoded `email === 'mcky@mcky.space'` with `user_profiles.is_admin` DB query
- **CSS**: removed duplicate `box-shadow` in twilight/cotton-candy themes
- **CSS**: added missing `-webkit-backdrop-filter` on midnight-ocean `.shift-sheet`
- **CSS**: removed duplicate `.profile-grid-left/-right` selectors
- **CSS**: removed `!important` from `--primary`/`--primary-bg`/`--secondary` across all 16 themes (49 declarations)
- **DOM leak**: ThemeEffects now cleans up chocobi-fall container on unmount
- **Type safety**: replaced `as any` with `Session`, `Record<string, any>` in App/DailyView/ProfilePage
- **Deps**: removed unused `clsx` (`^2.1.1`) and `tailwind-merge` (`^3.6.0`)
- **Hover**: DailyList replaced inline `onMouseEnter/Leave` with `.daily-row:hover` CSS class
- **Buddhist year**: extracted `toBuddhistYear()` to `@/constants` (6 call sites unified)
- **Offline queue**: `replayQueue` now `continue`s on error instead of `break` (resilience)

### 2026-06-25 — Theme + layout updates
- **Theme**: replaced cotton-candy with neobrutalist (vivid yellow `#fde047` bg, blue `#2563eb` primary, 3px black borders, offset shadows)
- **Theme**: removed Liquid Glass theme (glasscn-inspired, was unregistered in picker)
- **Theme migration**: `App.tsx` localStorage migration `cotton-candy` → `neobrutalist`
- **OdometerCard**: vertical dividers solid → dashed (`borderLeft: '1px dashed var(--border)'`)
- **OdometerCard**: horizontal divider already dashed, kept consistent
- **Input-group**: global `border-bottom` solid → dashed (`globals.css`)
- **DailyViewSkeleton**: rewritten to match `daily-grid` two-column layout (left: ShiftBadge + OdometerCard, right: CounterCard + Save)
- **Cleanup**: removed unused `getShiftLabel` function from `shift-helpers.ts`

## Deletions (2026-06-24)

- `HelpFixWorkCard.tsx` — merged into CounterCard (all 4 steppers in one card with horizontal divider)
- `SummaryBanner.tsx` — merged into OdometerCard (stats row + horizontal divider + input fields)

## PWA

- Install banner (`PwaInstallBanner.tsx`): ลอยเหนือ navtab (bottom: 88px), จำ dismissed ใน localStorage, fallback 5s สำหรับ iOS (ไม่มี beforeinstallprompt)
- SW registration: `registerSW({ immediate })` จาก `virtual:pwa-register` + `injectRegister: 'auto'` ใน vite.config
- Cache version: `ezzy-truck-v3`
- `/assets/` hashed chunks: **network-first** (`networkFirstWithReload`) — content-hash ทำให้ immutable, network-first ถูกต้อง. 404/fail → clear caches + FORCE_RELOAD
- `/assets/` non-JS: `cacheFirstWithFallback` สำหรับไฟล์อื่น
- Icons/fonts/images: `staleWhileRevalidate`
- Pages/navigation: `networkFirst`
- External (Supabase): `networkFirst`
- Client listener: `navigator.serviceWorker.addEventListener('message')` ใน main.tsx รับ `FORCE_RELOAD` แล้ว `window.location.reload()`
- PWA shortcuts (vite.config.ts manifest): บันทึกกะ (`/daily?today=1`), ตารางกะ (`/shifts`), รายได้ (`/income`), โปรไฟล์ (`/profile`)
- `today=1` URL param: DailyView detects `?today=1` → jump to current date (bypass last-saved date)
- Lesson: cache-first สำหรับ hashed assets ทำให้ React.lazy "Failed to fetch dynamically imported module" ถ้า SW ยังไม่ update precache manifest — เปลี่ยนเป็น network-first แล้ว

## Constraints

- ห้าม `@ts-ignore`, `@ts-expect-error` (ใช้ `as Record<string, any>` แทน `as any` เมื่อต้องทำงานกับ dynamic payloads)
- CSS overrides ใช้ `!important` เมื่อต้องชนะ base style (ยกเว้น `--primary`/`--primary-bg`/`--secondary` custom properties — attribute selector specificity ก็เพียงพอ)
- ใช้ module-level Intl.DateTimeFormat instance (ไม่สร้างซ้ำใน render)
- localStorage key pattern: `last-saved-{userId}-{year}-{month}-{day}`
- Reauthentication pattern: `sb.auth.signInWithPassword()` ก่อน `sb.auth.updateUser()` (email/password change)
- Avatar: Supabase Storage bucket `avatars`, path `{userId}/avatar.{ext}`, จำกัด ≤2MB, upsert enabled
- RLS policies: bucket `avatars` — `SELECT` public, `INSERT/UPDATE/DELETE` owner only (`auth.uid() = owner_id`)
- Telegram bot token: `VITE_TELEGRAM_BOT_TOKEN` in `.env.local` (gitignored)
- Telegram chat ID: `VITE_TELEGRAM_CHAT_ID` in `.env.local` (supergroup -1004343649661)
