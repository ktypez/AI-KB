---
type: agent-prompt
id: cafe-agent
last_updated: 2026-07-01
project: cafe
root: ~/cafe
personality: barista engineer
stack:
  - Next.js 15 (App Router)
  - React 19
  - TypeScript 5.9
  - Tailwind CSS 4
  - motion (animation)
  - lucide-react (icons)
  - Supabase (database + realtime)
  - Cloudflare R2 (receipt storage)
  - clsx + tailwind-merge + cva (utils)
  - PromptPay QR (custom payload generator)
  - playwright (headless Chromium for receipt images)
  - html2canvas (client-side receipt capture, 6x scale)
  - jose (JWT auth)
  - Web Audio API (sound alerts)
  - @line/bot-sdk (LINE messaging)
  - Haversine formula (delivery distance calculation)
triggers:
  "update .md": Read STATUS.md + AGENTS.md, update Components/Data Flow → sync KB
  "cleanup": Scan unused → health check → present findings → update docs
env_vars:
  - APP_URL
  - NEXT_PUBLIC_SUPABASE_URL
  - NEXT_PUBLIC_SUPABASE_ANON_KEY
  - SUPABASE_SERVICE_ROLE_KEY
  - LINE_CHANNEL_ACCESS_TOKEN
  - LINE_CHANNEL_SECRET
  - R2_ACCOUNT_ID
  - R2_ACCESS_KEY_ID
  - R2_SECRET_ACCESS_KEY
  - R2_BUCKET_NAME
  - R2_PUBLIC_URL
  - NEXT_PUBLIC_CAFE_LAT
  - NEXT_PUBLIC_CAFE_LNG
---

# Cafe Agent

## Project Overview

Cafe LIFF — coffee shop ordering & management platform. Next.js 15 app router with drag-and-drop kanban, POS for walk-in orders, customer LIFF ordering via LINE, PromptPay payment, LINE notifications with receipt images, phone-based login with session persistence, menu/recipe management, delivery fee system with GPS distance calculation, and light theme with shadcn standard.

## Stack

| Layer | Tech |
|-------|------|
| Framework | Next.js 15.5.19 (App Router) + TypeScript 5.9.3 |
| UI | React 19.2.1 + Tailwind CSS 4.1.11 |
| Animation | motion 12.23.24 |
| Icons | lucide-react 0.553.0 |
| Database | Supabase (@supabase/supabase-js 2.108.2) |
| Storage | Cloudflare R2 (receipt images, 10GB free) |
| Utils | clsx 2.1.1, tailwind-merge 3.3.1, class-variance-authority 0.7.1 |
| Payment | PromptPay QR payload generator (CRC16-XModem) |
| LINE | @line/bot-sdk (messaging API) |
| Receipt | playwright (headless Chromium) + html2canvas (client-side, 6x scale) |
| Sound | Web Audio API (6 sound types) |
| Auth | jose (JWT), admin@admin.com restriction |
| GPS | Haversine formula for delivery distance |
| Lint | ESLint 9.39.1 + eslint-config-next 16.0.8 |

## Architecture

```
app/layout.tsx → RootLayout (globals.css @import "tailwindcss")
app/page.tsx → Admin Dashboard SPA (kanban / POS / sales)
app/liff/page.tsx → Customer LIFF ordering flow (LINE)
app/settings/page.tsx → Settings (menu + recipe management)
app/api/line-notify/route.ts → LINE push notifications (ready text / receipt image)
app/api/auth/login/route.ts → Admin login (email + password)
app/api/auth/verify/route.ts → JWT verification
lib/receipt-html.ts → Shared HTML receipt template (720px wide, compact)
lib/receipt-image.ts → Playwright screenshot → R2 Storage → LINE
lib/r2.ts → Cloudflare R2 S3 client + uploadReceipt()
lib/delivery-fee.ts → Haversine distance, calcDeliveryFee, formatDistance
lib/line-bot.ts → LINE Messaging API (sendPushMessage, buildReadyMessage)
lib/auth-server.ts → JWT verification (jose)
lib/db-store.ts → Hybrid: Supabase query → fallback in-memory global store
lib/supabase.ts → Supabase client + Realtime channel subscription
hooks/use-sound.ts → Web Audio API sound alerts (6 types)
hooks/use-liff.ts → LIFF init, loginWithLiff()
hooks/use-customer.ts → Customer state, findOrCreateCustomer, calculatePoints (flat 10)
hooks/use-auth.ts → Admin auth (email + password → JWT)
```

### Directory Map

| Directory | Responsibility |
|-----------|---------------|
| `app/` | App Router pages + API routes |
| `app/api/` | Menu, order, recipe, customer, auth, LINE, upload endpoints |
| `components/` | ReceiptViewer — shared receipt component (do not modify without instruction) |
| `components/admin/` | ReceiptModal, SlipModal, OrderCard, TabBar, AdminHeader |
| `components/settings/` | MenuManager, CategoryManager, CustomizationManager |
| `components/ui/` | Input, DatePicker, Button, Toaster |
| `lib/` | Types, data store, menu data, recipes, PromptPay, Supabase, auth, LINE bot, receipt, R2, delivery fee |
| `hooks/` | useLiff, useCustomer, useSound, useAuth, useToast, useIsMobile |
| `fonts/` | Kanit-Regular.ttf, Kanit-Bold.ttf (full TTF from Google Fonts) |

## Routes

| Route | Type | Description |
|-------|------|-------------|
| `/` | Page | Admin Dashboard — kanban, POS, sales summary |
| `/liff` | Page | Customer LIFF ordering — phone login → menu → checkout → tracking |
| `/settings` | Page | Menu & recipe management |
| `/api/menus` | API | Menu CRUD |
| `/api/orders` | API | Orders CRUD (accepts deliveryFee) |
| `/api/recipes` | API | Recipe CRUD |
| `/api/customers` | API | Customer CRUD |
| `/api/customers/history` | API | Customer order history |
| `/api/auth/login` | POST | Admin login |
| `/api/auth/verify` | POST | JWT verification |
| `/api/line-notify` | POST | LINE push (ready text / receipt image) |
| `/api/line/webhook` | POST | LINE webhook |
| `/api/line/setup-richmenu` | POST | Rich menu setup |
| `/api/seed` | POST | Auto-seed menus |

## Key Components

### Admin Dashboard (`app/page.tsx`)
- **Kanban Board** — 4-column drag-and-drop (pending_verify → cooking → ready → completed)
- **POS Modal** — Walk-in order creation with item customization (queue-only, no customer name)
- **Sales Summary** — Revenue today, order counts, sortable table with "ใบเสร็จ" column
- **Sound Alerts** — Web Audio API sounds for new order, status change, payment confirm, ready
- **LINE Notifications** — Triggers on ready (text) and completed (receipt image)

### LIFF Customer Page (`app/liff/page.tsx`)
- **Phone Login** — Primary auth, LINE auto-links after phone login
- **Session Persistence** — 30-day localStorage
- **Type Selection** — Pick-up / Delivery / Drive-through (card-style native buttons)
- **Delivery GPS** — Geolocation required, >10km blocks order, distance-based fee
- **Menu Ordering** — Category filter + search, item cards, customization
- **Checkout & Payment** — Cart review, PromptPay QR code, slip upload, delivery fee
- **Order Tracking** — Real-time progress bar, auto-refresh via polling + Realtime
- **Sound Alerts** — Order status changes on tracked order
- **Member Tab** — Points (flat 10), LINE linking, logout button

### Receipt System
- **Shared Component** (`components/ReceiptViewer.tsx`) — canonical receipt component, do not modify without instruction
- **Shared HTML Template** (`lib/receipt-html.ts`) — 720px wide, compact text (~30% smaller)
- **Auto-scale** — Dynamically scales to fit viewport width
- **Website** (admin + LIFF) — `<ReceiptViewer>` component → `dangerouslySetInnerHTML` → html2canvas (6x) → JPEG 0.88
- **LINE** — Playwright screenshot → R2 Storage → LINE image push
- **Item Customizations** — Shows sweetness, milk, extraShot per item
- **Delivery Fee** — Shows "ค่าจัดส่ง" line before total

### Settings (`app/settings/page.tsx`)
- **MenuManager** — List/create/edit/delete menu items
- **RecipeManager** — List/create/edit/delete brewing recipes linked to menu items

## Data Flow

- **Hybrid architecture**: Supabase queries with global in-memory fallback (survives hot reloads)
- **Fallback**: When `NEXT_PUBLIC_SUPABASE_URL`/`ANON_KEY` are unset, `supabase` stays `null`, all operations hit global arrays
- **Auto-seed**: Empty Supabase `menus` table auto-populated with 8 initial items
- **Real-time**: `subscribeToOrders()` subscribes to `postgres_changes` on `orders` table + 4s `setInterval` polling fallback
- **Mapping**: `mapDbOrder`/`mapAppOrder` convert snake_case DB ↔ camelCase app types (including `delivery_fee`)
- **LINE Notifications**: Admin triggers → `/api/line-notify` → text (ready) or receipt image (completed) → LINE push
- **Receipt Image**: `generateReceiptImage()` → playwright screenshot → R2 upload → public URL
- **Delivery Fee**: GPS coordinates → Haversine distance → fee calculation → stored in `delivery_fee` column

## Entity Types

| Entity | Key Fields |
|--------|-----------|
| **Order** | id, lineUserId, lineDisplayName, type, tableNumber, pickupTime, deliveryAddress, phoneNumber, items (CartItem[]), total, deliveryFee, slipUrl, status, paymentMethod, paymentConfirmed, customerArrived, queueNumber, carInfo, createdAt, updatedAt |
| **MenuItem** | id, name, thName, description, price, category, imageUrl, available |
| **Recipe** | menuItemId, name, thName, ratio, grindSize, temperature, ingredients[{name, amount}], steps[{text, duration?}] |
| **CartItem** | id, name, price, quantity, sweetness, milk, extraShot |
| **Customer** | id (text), phoneNumber, lineUserId, lineDisplayName, linePictureUrl, points, createdAt |

## Environment

| Variable | Description |
|----------|-------------|
| `APP_URL` | Host URL for self-referential links |
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase project URL |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase anonymous API key |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase service role key (server-side) |
| `LINE_CHANNEL_ACCESS_TOKEN` | LINE Messaging API token |
| `LINE_CHANNEL_SECRET` | LINE channel secret |
| `R2_ACCOUNT_ID` | Cloudflare R2 account ID |
| `R2_ACCESS_KEY_ID` | Cloudflare R2 access key |
| `R2_SECRET_ACCESS_KEY` | Cloudflare R2 secret key |
| `R2_BUCKET_NAME` | R2 bucket name (`cafe-receipts`) |
| `R2_PUBLIC_URL` | R2 public URL for receipt images |
| `NEXT_PUBLIC_CAFE_LAT` | Cafe GPS latitude (16.439625) |
| `NEXT_PUBLIC_CAFE_LNG` | Cafe GPS longitude (102.828728) |

## LIFF Config

- **LIFF ID**: `2010543955-Dz0wuB1J`
- **Test LINE userId**: `U41a005cfe5f0e3267d544f7119f4767b`

## Triggers

### "update .md"

1. Read project AGENTS.md + current KB status
2. Update `~/AI-KB/status/cafe-status.md` with latest changes
3. Update `~/AI-KB/agents/cafe-agent.md` (architecture, routes, components)
4. If project AGENTS.md has stale info, update it too

### "cleanup"

1. Scan unused imports, empty files, dead exports
2. Health check: `npm run lint` + `tsc --noEmit`
3. Deep scan: leftover dirs, `console.log`, TODO/FIXME
4. Present findings for user to choose
5. Update STATUS.md + KB agent file
6. Never cleanup `.env*`, `node_modules/`, `.next/`, `.git/`, or essential config

## Rules

### Design
- Light theme with semantic CSS tokens (`--color-background`, `--color-foreground`)
- Cards: `bg-card` with `border border-border` + `shadow-sm`
- Buttons: shadcn `<Button>` component everywhere (except LIFF order type cards)
- Thai labels everywhere (admin + LIFF)
- Product customization: sweetness (4 levels), milk (fresh/oat/soy), extra shot (+฿15)

### Receipt
- Shared HTML template (`lib/receipt-html.ts`) — 720px wide, compact text
- `components/ReceiptViewer.tsx` is the canonical receipt component — do not modify without explicit instruction
- Auto-scales to viewport width (dynamic scale calculation)
- Playwright for LINE (3x resolution)
- html2canvas for website (6x scale, JPEG 0.88)
- Kanit font (full TTF from Google Fonts)
- Shows delivery fee if applicable
- Item customizations shown (sweetness/milk/extraShot)

### Delivery Fee
- GPS required (no fallback)
- Max distance 10km (beyond = not available)
- Fee: ฿5 for ≤2km, +฿5/km, max ฿30
- Stored as `delivery_fee` column on orders table
- Included in order total sent to API

### Auth
- Admin restricted to `admin@admin.com` only
- Phone number is primary login for LIFF
- LINE auto-links after phone login
- Session: 30-day localStorage

### Communication
- Thai or English only — no Chinese characters
- Concise, direct responses
- No emojis unless explicitly asked
