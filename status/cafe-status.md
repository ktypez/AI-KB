---
type: project-status
project: cafe
last_updated: 2026-06-30
id: cafe-status
title: cafe-status
timestamp: 2026-06-30T22:00:00Z
---

# Project Status — cafe

## Current State

Full-featured cafe ordering system: admin dashboard with kanban, LIFF customer ordering via LINE, phone-based login with session persistence, LINE notifications with receipt images, sound alerts, and shared HTML receipt template (playwright for LINE, html2canvas for website).

## Stack

- **Framework**: Next.js 15.5.19 (App Router)
- **UI Library**: React 19.2.1, TypeScript 5.9.3
- **Styling**: Tailwind CSS 4.1.11 + PostCSS
- **Animation**: motion 12.23.24
- **Icons**: lucide-react 0.553.0
- **Database**: Supabase (@supabase/supabase-js 2.108.2) + in-memory fallback
- **Utils**: clsx 2.1.1, tailwind-merge 3.3.1, class-variance-authority 0.7.1
- **Payment**: PromptPay QR payload generator (CRC16-XModem)
- **LINE**: @line/bot-sdk (messaging API)
- **Receipt**: playwright (headless Chromium) + html2canvas (client-side)
- **Sound**: Web Audio API (no audio files)
- **Auth**: jose (JWT), admin@admin.com restriction
- **Lint**: ESLint 9.39.1 + eslint-config-next 16.0.8

## Routes

| Route | Type | Description |
|-------|------|-------------|
| `/` | Page | Admin Dashboard — kanban, POS, sales, receipts |
| `/liff` | Page | Customer LIFF ordering (LINE) |
| `/settings` | Page | Menu & recipe management |
| `/api/menus` | API | Menu CRUD |
| `/api/orders` | API | Orders CRUD |
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
| ReceiptModal | `components/admin/ReceiptModal.tsx` | Shared HTML receipt with html2canvas download |
| SlipModal | `components/admin/SlipModal.tsx` | Payment slip viewer + confirm |
| MenuManager | `components/settings/MenuManager.tsx` | Menu CRUD |
| RecipeManager | `components/settings/RecipeManager.tsx` | Recipe CRUD |
| Input | `components/ui/input.tsx` | shadcn-style input |
| DatePicker | `components/ui/date-picker.tsx` | Date picker component |

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
| `/api/orders` | GET, POST, PUT, DELETE | None | Orders CRUD |
| `/api/recipes` | GET, POST | None | Recipe CRUD |
| `/api/customers` | GET, POST, PUT | None | Customer CRUD |
| `/api/customers/history` | GET | None | Customer order history |
| `/api/auth/login` | POST | None | Admin login |
| `/api/auth/verify` | POST | JWT | Verify token |
| `/api/line-notify` | POST | Admin JWT | LINE push (ready text / receipt image) |
| `/api/line/webhook` | POST | None | LINE webhook |
| `/api/line/setup-richmenu` | POST | None | Rich menu setup |
| `/api/seed` | POST | None | Auto-seed menus |

## Design System

- **Dark theme**: `from-[#1a1714] to-[#2d2824]` gradient bg
- **Accent**: Amber-500 as primary action color
- **Glassmorphism**: `backdrop-blur-md`, `bg-white/5`, `border-white/10`
- **Cards**: `rounded-2xl` with `border border-white/10` + `shadow-lg`
- **Status colors**: amber (pending), blue (cooking), emerald (ready), stone (completed)
- **Receipt**: Shared HTML template (inline CSS + Kanit font) — identical for website + LINE

## Data Model

### Tables (Supabase)
- **menus**: id, name, th_name, description, price, category, image_url, available
- **orders**: id, line_user_id, line_display_name, line_picture_url, type, table_number, pickup_time, delivery_address, phone_number, items (jsonb), total, slip_url, status, payment_method, payment_confirmed, customer_arrived, queue_number, car_info, created_at, updated_at
- **customers**: id (text), phone_number, line_user_id, line_display_name, line_picture_url, points, created_at

### In-Memory Store
- `globalForDb.orders` — Order[]
- `globalForDb.menuItems` — MenuItem[] (seeded from `initialMenuItems`)
- `globalForRecipes.recipes` — Recipe[] (seeded from `recipes`)

### Storage
- **public** bucket: receipt images (`receipts/{orderId}-{timestamp}.jpg`)

## Changelog

### 2026-06-30
- **Receipt overhaul**: shared HTML template (`lib/receipt-html.ts`) — identical rendering for website + LINE
- **Playwright for LINE**: headless Chromium screenshot (3x resolution, 1920×2400px, ~280KB)
- **html2canvas for website**: captures shared template → inline JPG image
- **LINE receipt images**: `generateReceiptImage()` → Supabase Storage → LINE image push
- **Kanit font**: full TTF from Google Fonts (not fontsource subset)
- **Bigger fonts**: shop name 36px, items 24px, total 34px for sharp rendering
- **Removed**: /api/receipt, lib/receipt.ts, @resvg/resvg-js, old noto fonts, IBMPlexSansThai
- **Phone-only login**: removed "Login with LINE" button, LINE auto-links after phone login
- **Session persistence**: 30-day localStorage, key: "pun tung session"
- **Logout button**: "ออกจากระบบ" in member tab
- **LIFF member tab LINE linking**: shows badge if linked, connect button if in LINE but not linked
- **Sound alerts** (`hooks/use-sound.ts`): Web Audio API with 6 sound types
- **Dashboard sounds**: new order, arrived, status change, payment confirm, ready
- **LIFF sounds**: order status changes on tracked order
- **LINE Messaging API** (`lib/line-bot.ts`): `sendPushMessage()`, `buildReadyMessage()`, `buildReceiptFlexMessage()`
- **LINE notification API** (`/api/line-notify`): admin auth required, triggers on `ready` and `completed`
- **Auth**: admin@admin.com restriction (client + server), use-auth.ts hook
- **confirmPayment**: now advances order to `ready` status

### 2026-06-29
- Initial MVP: admin dashboard, LIFF customer page, settings
- Removed VAT 7% from checkout receipts

## Known Issues

- No testing setup yet
- Slip upload uses client-side `URL.createObjectURL` (no persistent storage)
- Admin page is a single monolithic component (~850+ lines)
- App title in layout still says "My Google AI Studio App"
- LIFF page is ~1600 lines (could be split into smaller components)
