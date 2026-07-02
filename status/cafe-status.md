---
type: project-status
project: cafe
last_updated: 2026-07-01
id: cafe-status
title: cafe-status
timestamp: 2026-07-01T20:40:00Z
---

# Project Status — cafe

## Current State

Full-featured cafe ordering system: admin dashboard with kanban, LIFF customer ordering via LINE, phone-based login with session persistence, LINE notifications with receipt images, sound alerts, shared HTML receipt template (playwright for LINE, html2canvas for website), delivery fee system with GPS-based distance calculation, light theme with shadcn standard, and Cloudflare R2 receipt storage.

## Stack

- **Framework**: Next.js 15.5.19 (App Router)
- **UI Library**: React 19.2.1, TypeScript 5.9.3
- **Styling**: Tailwind CSS 4.1.11 + PostCSS
- **Animation**: motion 12.23.24
- **Icons**: lucide-react 0.553.0
- **Database**: Supabase (@supabase/supabase-js 2.108.2) + in-memory fallback
- **Storage**: Cloudflare R2 (receipt images, 10GB free)
- **Utils**: clsx 2.1.1, tailwind-merge 3.3.1, class-variance-authority 0.7.1
- **Payment**: PromptPay QR payload generator (CRC16-XModem)
- **LINE**: @line/bot-sdk (messaging API)
- **Receipt**: playwright (headless Chromium) + html2canvas (client-side, 6x scale)
- **Sound**: Web Audio API (no audio files)
- **Auth**: jose (JWT), admin@admin.com restriction
- **Lint**: ESLint 9.39.1 + eslint-config-next 16.0.8
- **GPS**: Haversine formula for delivery distance calculation

## Routes

| Route | Type | Description |
|-------|------|-------------|
| `/` | Page | Admin Dashboard — kanban, POS, sales |
| `/liff` | Page | Customer LIFF ordering (LINE) — pick-up, delivery, drive-through |
| `/settings` | Page | Menu & category & customization settings (tabbed) |
| `/api/menus` | API | Menu CRUD |
| `/api/orders` | API | Orders CRUD (accepts deliveryFee) |
| `/api/recipes` | API | Recipe CRUD |
| `/api/customers` | API | Customer CRUD |
| `/api/customers/history` | API | Customer order history |
| `/api/auth/login` | API | Admin login (email + password) |
| `/api/auth/verify` | API | JWT verification |
| `/api/line-notify` | API | LINE push notifications (ready + receipt image) |
| `/api/line/webhook` | API | LINE webhook handler |
| `/api/line/setup-richmenu` | API | LINE rich menu setup |
| `/api/seed` | API | Menu auto-seed |

## Components

| Component | File | Purpose |
|-----------|------|---------|
| ReceiptModal | `components/admin/ReceiptModal.tsx` | Wraps `<ReceiptViewer>` |
| ReceiptViewer | `components/ReceiptViewer.tsx` | Canonical shared receipt **do not modify** |
| SlipModal | `components/admin/SlipModal.tsx` | Payment slip viewer, uses shadcn Dialog |
| OrderCard | `components/admin/OrderCard.tsx` | Kanban card, uses shadcn Card + Badge |
| KanbanColumn | `components/admin/KanbanColumn.tsx` | Column wrapper, uses shadcn Card |
| TabBar | `components/admin/TabBar.tsx` | Tab navigation, uses shadcn Tabs |
| SalesSummary | `components/admin/SalesSummary.tsx` | Sales table, uses shadcn Card + Table + Badge |
| PosTab | `components/admin/PosTab.tsx` | POS ordering, uses shadcn Card |
| PosModal | `components/admin/PosModal.tsx` | POS modal, uses shadcn Card + Button |
| MenuManager | `components/settings/MenuManager.tsx` | Menu CRUD + R2 photo upload, uses shadcn Card + Button + Input |
| CategoryManager | `components/settings/CategoryManager.tsx` | Category CRUD, uses shadcn Card + Button + Input |
| CustomizationManager | `components/settings/CustomizationManager.tsx` | Option CRUD by type, uses shadcn Card + Button + Input |
| RecipeManager | `components/settings/RecipeManager.tsx` | Recipe CRUD |
| Input | `components/ui/input.tsx` | shadcn-style input |
| DatePicker | `components/ui/date-picker.tsx` | Date picker with `z-[100]` |
| Button | `components/ui/button.tsx` | shadcn Button (cva: default/outline/ghost/destructive/link, sm/lg/icon) |
| Card | `components/ui/card.tsx` | Card + CardHeader + CardTitle + CardDescription + CardContent + CardFooter |
| Badge | `components/ui/badge.tsx` | default/secondary/destructive/outline/success/warning |
| Dialog | `components/ui/dialog.tsx` | motion-based, no Radix |
| Tabs | `components/ui/tabs.tsx` | Tabs + TabsList + TabsTrigger + TabsContent |
| Table | `components/ui/table.tsx` | Table + TableHeader + TableBody + TableRow + TableHead + TableCell |
| Label | `components/ui/label.tsx` | shadcn Label |
| Separator | `components/ui/separator.tsx` | shadcn Separator |
| CategoryIcon | `lib/category-icons.tsx` | Per-category Lucide icon mapping |

## Hooks

| Hook | File | Purpose |
|------|------|---------|
| useLiff | `hooks/use-liff.ts` | LIFF init, loginWithLiff() |
| useCustomer | `hooks/use-customer.ts` | Customer state, findOrCreateCustomer, calculatePoints (flat 10) |
| useSound | `hooks/use-sound.ts` | Web Audio API sounds (6 types) |
| useAuth | `hooks/use-auth.ts` | Admin auth (email + password → JWT) |
| useToast | `hooks/use-toast.ts` | Toast notifications |

## API

| Endpoint | Methods | Auth | Purpose |
|----------|---------|------|---------|
| `/api/menus` | GET, POST, DELETE | None | Menu CRUD |
| `/api/orders` | GET, POST, PUT, DELETE | None | Orders CRUD (accepts deliveryFee) |
| `/api/recipes` | GET, POST | None | Recipe CRUD |
| `/api/customers` | GET, POST, PUT | None | Customer CRUD |
| `/api/customers/history` | GET | None | Customer order history |
| `/api/auth/login` | POST | None | Admin login |
| `/api/auth/verify` | POST | JWT | Verify token |
| `/api/line-notify` | POST | Admin JWT | LINE push (ready text / receipt image) |
| `/api/line/webhook` | POST | None | LINE webhook |
| `/api/line/setup-richmenu` | POST | None | Rich menu setup |
| `/api/seed` | POST | None | Auto-seed menus |
| `/api/categories` | GET, POST | None | Category CRUD |
| `/api/customization-options` | GET, POST | None | Option CRUD (GET ?type= filter) |
| `/api/shop-status` | GET, PUT | GET public, PUT admin | Shop open/close toggle |
| `/api/upload-menu-image` | POST | None | R2 image upload to `menu-images/` |

## Design System

- **Theme**: Claude-inspired warm amber preset — `--color-background: hsl(0 0% 100%)`, `--color-foreground: hsl(20 35% 4%)`, `--color-primary: hsl(30 100% 40%)` (amber)
- **Accent**: Primary color as main action color
- **Cards**: `<Card>` shadcn component (cva + cn + forwardRef) with `rounded-xl`, `border border-border`, `bg-card`
- **Badges**: `<Badge>` shadcn component (default/secondary/destructive/outline/success/warning)
- **Dialogs**: `<Dialog>` shadcn component (motion-based, no Radix)
- **Tabs**: `<Tabs>` shadcn component with TabsList + TabsTrigger + TabsContent
- **Tables**: `<Table>` shadcn component with TableHeader + TableBody + TableRow + TableHead + TableCell
- **Labels**: `<Label>` shadcn component
- **Separators**: `<Separator>` shadcn component
- **Status colors**: primary (pending), blue (cooking), emerald (ready), stone (completed)
- **Buttons**: shadcn `<Button>` component with cva (default/outline/ghost/secondary/destructive/link + sm/lg/icon)
- **Styling pattern**: all shadcn components use `class-variance-authority` (cva) + `clsx` + `tailwind-merge` + `forwardRef`
- **Animations**: `tw-animate-css` for enter/exit animations
- **Category icons**: per-category mapping in `lib/category-icons.tsx` (`coffee`→Coffee, `non-coffee`/`frappe`/`smoothie`→CupSoda, `bakery`→Cake, `special`→Sparkles, `matcha`→Leaf, `chocolate`→Candy, `hot-tea`→Coffee)
- **Menu images**: optional R2 upload (no text URL), fallback to category icon
- **Receipt**: Shared HTML template (720px wide, compact text ~30% smaller) — auto-scales to viewport
- **Receipt Download**: 6x html2canvas → JPEG 0.88 (sharp text, reasonable file size)
- **ReceiptViewer**: extracted to `components/ReceiptViewer.tsx` — **do not modify without instruction**

## Data Model

### Tables (Supabase)
- **menus**: id, name, th_name, description, price, category (text), image_url (R2 public URL), available, customization (jsonb), created_at
- **categories**: id, name, slug, sort_order, created_at
- **customization_options**: id, type (sweetness/milk/extra_shot), label, value, price_modifier, sort_order, created_at
- **orders**: id, line_user_id, line_display_name, line_picture_url, type, table_number, pickup_time, delivery_address, phone_number, items (jsonb), total, delivery_fee, slip_url, status, payment_method, payment_confirmed, customer_arrived, queue_number, car_info, created_at, updated_at
- **shop_settings**: id, open (boolean), created_at
- **customers**: id (text), phone_number, line_user_id, line_display_name, line_picture_url, points, created_at

### In-Memory Store (`lib/db-store.ts`)
- `globalForDb.orders` — Order[]
- `globalForDb.menuItems` — MenuItem[] (seeded from `initialMenuItems`)
- `globalForRecipes.recipes` — Recipe[] (seeded from `recipes`)
- `categoriesStore` — Category[]
- `customizationOptionsStore` — CustomizationOption[]
- `menuStore` — MenuItem[] (reactive)
- `ordersStore` — Order[] (reactive)
- `shopSettingsStore` — { open: boolean }
- All stores load from Supabase on init + reload on mutations

### Storage
- **Cloudflare R2**: receipt images (`receipts/{orderId}-{timestamp}.jpg`) + menu images (`menu-images/{itemId}-{timestamp}.jpg`)
  - Bucket: `cafe-receipts`
  - Public URL: `https://pub-e9be9f6e7d314ba9abbd803f4734d8cf.r2.dev`

## Changelog

### 2026-07-01
- **Claude-inspired color palette**: warm amber primary, warm off-white bg, higher contrast for readability
- **All remaining raw buttons converted to shadcn**: LoginPage (Input/Button), OrderCard (ดูสลิป), PosTab/PosModal (qty +/-), date-picker, settings tabs, LIFF tabs + order type cards (Card) + qty/แก้ไข/slip delete buttons
- **Kanban column min-width**: `w-80` (320px) per column to prevent narrow layout
- **AdminHeader subtitle removed**: "ระบบสั่งซื้อกาแฟผ่านไลน์ & สรุปยอดขาย Real-time" deleted
- **Dashboard tab icons**: all 4 tabs now have icons (ClipboardList/ShoppingCart/DollarSign/Users)
- **Settings button full text**: always shows "ตั้งค่า" (no `hidden sm:inline`)
- **Extra shot price field**: CustomizationManager now shows price input for all types including extra_shot, with label captions
- **LIFF ?tab=member deep-link**: lazy initializer reads `window.location.search` for `?tab=member`
- **Rich menu updated**: left → LIFF ordering, center → LIFF member tab (`?tab=member`), right → Google Maps
- **Dialog onDrag type fixed**: removed `{...props}` spread causing motion type conflict
- **Receipt extracted to component**: `ReceiptViewer.tsx` — shared canonical component, ~170 lines duplicate logic removed (do not modify without instruction)
- **Full shadcn component library**: Card, Badge, Dialog, Tabs, Table, Label, Separator — all using cva + cn + forwardRef
- **All admin/settings components converted to shadcn**: OrderCard → Card + Badge, KanbanColumn → Card, SlipModal → Dialog, TabBar → Tabs, SalesSummary → Card + Table + Badge, CategoryManager → Card, CustomizationManager → Card, MenuManager → Card, PosTab → Card, PosModal → Card
- **Settings page header**: subtitle removed (only "ตั้งค่าร้าน" + tabbed ตั้งค่าสินค้า | หมวดหมู่ | ตัวเลือกเสริม)
- **Globals.css**: standard shadcn theme vars (radius, chart colors, animations via `tw-animate-css`)
- **Dynamic categories**: PosTab, PosModal, LIFF fetch from `/api/categories` API (not hardcoded)
- **Category API**: `/api/categories/route.ts` CRUD (GET + POST with action: update/delete)
- **Customization API**: `/api/customization-options/route.ts` CRUD with type filter
- **Per-category icons**: `lib/category-icons.tsx` with `CategoryIcon` component mapping by slug
- **R2 photo upload**: `/api/upload-menu-image` route, upload button in MenuManager (no text URL field)
- **DB migration**: `categories` and `customization_options` tables with seed data, `menus_category_check` removed
- **Receipt auto-scale**: dynamically scales to fit viewport width (no more hardcoded 0.58)
- **Receipt compact layout**: 720px wide card, ~30% smaller text, tighter spacing
- **Receipt sharpness**: 6x html2canvas export → JPEG 0.88 (downscale removed for max sharpness)
- **LIFF receipt modal**: matches admin ReceiptModal UI exactly
- **Delivery fee system**: GPS-based distance calculation (Haversine), ฿5 base ≤2km, +฿5/km, max ฿30
- **LIFF geolocation**: GPS required for delivery, >10km blocks order, no fallback
- **Admin OrderCard**: shows delivery fee for delivery orders
- **Receipt delivery fee line**: shows "ค่าจัดส่ง" before total
- **Light theme conversion**: all `bg-black/*` → semantic tokens, shadcn Button everywhere
- **Grey header fix**: `bg-black/40` → `bg-card` in AdminHeader, settings, LIFF
- **Color fixes**: MenuManager, ReceiptHistory, TabBar, selects for light theme
- **Sales table**: header `bg-muted/50`, `whitespace-nowrap`, date picker same line
- **ReceiptModal download**: fixed for popup blockers (uses `<a>` click)
- **Cloudflare R2**: migrated from Supabase Storage (10GB free vs 1GB)
- **DB migration**: `delivery_fee` column added to orders table

### 2026-06-30
- **Receipt overhaul**: shared HTML template (`lib/receipt-html.ts`)
- **Playwright for LINE**: headless Chromium screenshot (3x resolution)
- **html2canvas for website**: captures shared template → inline JPG
- **LINE receipt images**: `generateReceiptImage()` → R2 Storage → LINE image push
- **Phone-only login**: removed "Login with LINE" button
- **Session persistence**: 30-day localStorage
- **Sound alerts** (`hooks/use-sound.ts`): Web Audio API with 6 sound types
- **LINE Messaging API** (`lib/line-bot.ts`): `sendPushMessage()`, `buildReadyMessage()`, `buildReceiptFlexMessage()`
- **Auth**: admin@admin.com restriction (client + server)

### 2026-06-29
- Initial MVP: admin dashboard, LIFF customer page, settings
- Removed VAT 7% from checkout receipts

## Known Issues

- No testing setup yet
- Slip upload uses client-side `URL.createObjectURL` (no persistent storage)
- App title in layout still says "My Google AI Studio App"
- LIFF page is ~1600 lines (could be split into smaller components)
- Missing shadcn components: Select, Textarea, Switch (add as needed)
- Pre-existing `sharp` module missing for `/api/line/setup-richmenu` (Termux only — Vercel includes it)
