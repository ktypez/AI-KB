---
last_updated: 2026-06-21
project: truck
type: status
---

# Project Status — truck

## Stack

- React 19 + Vite 6 + TypeScript + Supabase (timestamptz, Asia/Bangkok timezone)
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

## CI/CD — GitHub Actions

- Workflow: `.github/workflows/deploy-edge-functions.yml`
- Trigger: push to `master` ที่เปลี่ยนไฟล์ใน `supabase/functions/**`
- Steps: checkout (fetch-depth:0) → supabase/setup-cli@v1 → `supabase link --project-ref rmkevbdpmixsydldkiwv` → git diff หาฟังก์ชันที่เปลี่ยน → deploy ทีละอัน
- `SUPABASE_ACCESS_TOKEN` (secret) + hardcoded ref ID (`rmkevbdpmixsydldkiwv`)
- Edge functions: `approve-user`, `get-all-users`, `notify-telegram`

## Bundle (dist) — after vendor chunk split

| Chunk                                | Size    | gzip           |
| ------------------------------------ | ------- | -------------- |
| vendor-react                         | 194 KB  | 60 KB          |
| vendor-supabase                      | 208 KB  | 54 KB          |
| vendor-icons (@phosphor-icons/react) | 107 KB  | 25 KB          |
| vendor-query (@tanstack-query)       | 39 KB   | 12 KB          |
| vendor-router                        | 36 KB   | 13 KB          |
| index (main)                         | 21 KB   | 7 KB           |
| DailyView                            | 19 KB   | 5 KB           |
| ProfilePage                          | 20 KB   | 5 KB           |
| Route chunks                         | 5-8 KB  | 2-3 KB         |
| PWA precache                         | 1931 KB | — (53 entries) |

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
- 5 light: clean-light, retro-pastel, modern, cotton-candy, summer-morning
- 5 dark: clean-dark, retro-dark, midnight-ocean, twilight, sunset
- 6 shinchan: shinchan, blue-sky, shinchan-bath, shinchan-sleep, shinchan-cute, shinchan-white
- Theme picker: 2-column grid (light/dark) + collapsible "ชินจัง (6)" section at bottom
- Theme modal closes on selection (theme flash effect visible)
- `clean-light` / `clean-dark`: gradient bg (160°) + SVG noise texture overlay (feTurbulence, 8% opacity)
- All themes use `.hero-card` selector for HeroCard overrides
- All shinchan `.tab` has separate rules (not grouped with wiggle selector)
- Shinchan light themes (shinchan, blue-sky, shinchan-bath) use dark-on-gradient pattern (active buttons/hero/dateslider have dark text like shinchan-white)
- shinchan/blue-sky/shinchan-bath now have `.modal-content, .month-bar` override (solid bg + 3px border)

## Hooks

- `useOnlineStatus()` — extract from OfflineBanner
- `useRef` patterns — OdometerCard (focus chain), AuthScreen (password ref)
- `src/hooks/` folder: `useOnlineStatus.ts`

## Components

### Common

- `PageHeader.tsx` — shared header component: back button `<` + title (font 22, weight 900) + optional description (14px) + optional children in 2-col grid (6fr/4fr). Hard text shadow on title+desc. Used by all 6 views.
- `MonthYearSelector.tsx` — prev/next `<` `>` buttons + clickable month/year label → opens `MonthYearPopup`. Height 42px, radius 12px, flex-fill.

### DailyView

- `DailyView.tsx` — หน้าบันทึกกะรายวัน: DateSlider เลือกวัน, ShiftBadge แสดงกะ, OdometerCard (เลขไมล์), CounterCard (เที่ยว/ OT), HelpFixWorkCard (ช่วยซ่อม), LeaveCard (ลา, มี glow animation), SummaryBanner สรุปท้ายวัน (ปุ่มบันทึกถูกลบออกแล้ว)

### Profile

- `ProfilePage.tsx` — แสดง avatar, display name, email, KPI ปี (8 รายการ 2 คอลัมน์ + รายได้/ภาษี + วันลาคงเหลือ), เลือกปีได้ (ปุ่ม ◀ ▶), ปุ่มเปลี่ยนอีเมล/รหัสผ่าน (2 คอลัมน์), ปุ่ม What's New, ออกจากระบบ (พื้นหลังแดง)
- `profile/EmailChangeModal.tsx` — modal เปลี่ยนอีเมล + ยืนยันรหัสผ่านปัจจุบัน
- `profile/PasswordChangeModal.tsx` — modal 3 ช่อง (รหัสปัจจุบัน / ใหม่ / ยืนยันใหม่)
- `profile/ProfileEditModal.tsx` — modal แก้ไข display name + อัปโหลด avatar ไปยัง Supabase Storage (bucket `avatars`)
- `profile/AdminPanel.tsx` — แผงควบคุมแอดมิน: เมนู "จัดการผู้ใช้งาน" + "ตั้งค่ารายได้"
- `profile/UserManagement.tsx` — จัดการผู้ใช้: tabs (all/pending/approved/rejected), ค้นหา, อนุมัติ/ปฏิเสธ/รีเซ็ตรหัสผ่าน
- `profile/IncomeSettings.tsx` — ตั้งค่ารายได้: ฟอร์มแก้ 11 ค่า (เงินเดือน, ค่ารอบ, ค่า OT, ฯลฯ) → upsert `income_settings` table

### Header

- `Header.tsx` — แสดง avatar วงกลม (32px) + display name (จาก `auth.user_metadata`) พร้อมลิงก์ไปหน้า profile (ปุ่มออกจากระบบถูกลบออกแล้ว)

### Auth

- `AuthScreen.tsx` — หน้าเข้าสู่ระบบ: tab bar สลับ "เข้าสู่ระบบ" / "ขอบัญชีใหม่"
  - Tab เข้าสู่ระบบ: อีเมล + รหัสผ่าน → Supabase signInWithPassword
  - Tab ขอบัญชีใหม่: กรอกอีเมล → ส่ง Telegram bot → แสดง success message
  - Telegram bot token + chat ID อยู่ใน `.env.local` (VITE_TELEGRAM_BOT_TOKEN, VITE_TELEGRAM_CHAT_ID)

### Changelog

- `Changelog.tsx` — หน้า What's New แสดงประวัติเวอร์ชั่นรายวันตั้งแต่ 1 มิ.ย. 2026 (5 รายการต่อหน้า + load more)

### ShiftCalendar

- `ShiftCalendar.tsx` — ตารางกะรายเดือน พร้อม leave summary + loading spinner (@phosphor-icons/react)
- `shifts/CalendarGrid.tsx` — ตารางปฏิทิน 3 แถว (วันที่, ★/⚡ indicator, เวลากะ) + Badge 'x2' (สีม่วง) สำหรับ day_type === 'special'
- `shifts/ShiftModal.tsx` — modal เลือกกะ/ลา (ใช้ @phosphor-icons/react: Clock, Lightning, Trash)
- `shifts/ShiftSummary.tsx` — แสดงสรุปวันทำงาน/หยุด/ลา (ใช้ yearly logs query, ChartBar icon)

### History

- `History.tsx` — ตารางประวัติรายเดือน แสดง day_type ใน merged data
- `history/DailyList.tsx` — แสดง Badge 'x2' ข้างกะ เมื่อ day_type === 'special'

### IncomeView

- `IncomeView.tsx` — หน้ารายได้/ภาษีรายเดือน: MonthYearSelector, HeroCard (ยอดสุทธิ), SalaryBreakdown (แยกค่ากะ/OT/โบนัสฯลฯ), TaxSummary (สรุปภาษี)
  - ดึง `income_settings` จาก Supabase → ส่งเข้า `calculateIncome(logs, daysInMonth, settings)` → recalc อัตโนมัติเมื่อ settings เปลี่ยน

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

## Cleanup (2026-06-18 + 2026-06-20)

- `src/types.ts` — removed (empty file, never imported)
- `src/constants.ts` — removed dead exports `MONTHS_SHORT`, `DAYS_SHORT`, `MAX_YEAR` (unused)
- `.openclaude/` — removed leftover directory
- `vite.log` — removed leftover log file

## PWA

- Install banner (`PwaInstallBanner.tsx`): ลอยเหนือ navtab (bottom: 88px), จำ dismissed ใน localStorage, fallback 5s สำหรับ iOS (ไม่มี beforeinstallprompt)
- SW registration: `registerSW({ immediate })` จาก `virtual:pwa-register` + `injectRegister: 'auto'` ใน vite.config
- Cache version: `ezzy-truck-v2`
- 404 fallback: `/assets/` fetch ได้ 404 → clear all caches + `postMessage({ type: 'FORCE_RELOAD' })` → client reload หน้าใหม่
- Client listener: `navigator.serviceWorker.addEventListener('message')` ใน main.tsx รับ `FORCE_RELOAD` แล้ว `window.location.reload()`

## Constraints

- ห้าม `as any`, `@ts-ignore`, `@ts-expect-error`
- CSS overrides ใช้ `!important` เมื่อต้องชนะ base style
- ใช้ module-level Intl.DateTimeFormat instance (ไม่สร้างซ้ำใน render)
- localStorage key pattern: `last-saved-{userId}-{year}-{month}-{day}`
- Reauthentication pattern: `sb.auth.signInWithPassword()` ก่อน `sb.auth.updateUser()` (email/password change)
- Avatar: Supabase Storage bucket `avatars`, path `{userId}/avatar.{ext}`, จำกัด ≤2MB, upsert enabled
- RLS policies: bucket `avatars` — `SELECT` public, `INSERT/UPDATE/DELETE` owner only (`auth.uid() = owner_id`)
- Telegram bot token: `VITE_TELEGRAM_BOT_TOKEN` in `.env.local` (gitignored)
- Telegram chat ID: `VITE_TELEGRAM_CHAT_ID` in `.env.local` (supergroup -1004343649661)
