---
type: agent-prompt
id: cafe-agent
last_updated: 2026-06-30
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
  - Supabase (database + realtime + storage)
  - clsx + tailwind-merge + cva (utils)
  - PromptPay QR (custom payload generator)
  - playwright (headless Chromium for receipt images)
  - html2canvas (client-side receipt capture)
  - jose (JWT auth)
  - Web Audio API (sound alerts)
  - @line/bot-sdk (LINE messaging)
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
---

# Cafe Agent

## Project Overview

Cafe LIFF — coffee shop ordering & management platform. Next.js 15 app router with drag-and-drop kanban, POS for walk-in orders, customer LIFF ordering via LINE, PromptPay payment, LINE notifications with receipt images, phone-based login with session persistence, and menu/recipe management.

## Stack

| Layer | Tech |
|-------|------|
| Framework | Next.js 15.5.19 (App Router) + TypeScript 5.9.3 |
| UI | React 19.2.1 + Tailwind CSS 4.1.11 |
| Animation | motion 12.23.24 |
| Icons | lucide-react 0.553.0 |
| Database | Supabase (@supabase/supabase-js 2.108.2) |
| Storage | Supabase Storage (receipt images) |
| Utils | clsx 2.1.1, tailwind-merge 3.3.1, class-variance-authority 0.7.1 |
| Payment | PromptPay QR payload generator (CRC16-XModem) |
| LINE | @line/bot-sdk (messaging API) |
| Receipt | playwright (headless Chromium) + html2canvas (client-side) |
| Sound | Web Audio API (6 sound types) |
| Auth | jose (JWT), admin@admin.com restriction |
| Lint | ESLint 9.39.1 + eslint-config-next 16.0.8 |

## Architecture

```
app/layout.tsx → RootLayout (globals.css @import "tailwindcss")
app/page.tsx → Admin Dashboard SPA (kanban / POS / sales / receipts)
app/liff/page.tsx → Customer LIFF ordering flow (LINE)
app/settings/page.tsx → Settings (menu + recipe management)
app/api/line-notify/route.ts → LINE push notifications (ready text / receipt image)
app/api/auth/login/route.ts → Admin login (email + password)
app/api/auth/verify/route.ts → JWT verification
lib/receipt-html.ts → Shared HTML receipt template (single source of truth)
lib/receipt-image.ts → Playwright screenshot → Supabase Storage → LINE
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
| `app/api/` | Menu, order, recipe, customer, auth, LINE endpoints |
| `components/admin/` | ReceiptModal, SlipModal |
| `components/settings/` | MenuManager + RecipeManager |
| `components/ui/` | Input, DatePicker |
| `lib/` | Types, data store, menu data, recipes, PromptPay, Supabase, auth, LINE bot, receipt |
| `hooks/` | useLiff, useCustomer, useSound, useAuth, useToast, useIsMobile |
| `fonts/` | Kanit-Regular.ttf, Kanit-Bold.ttf (full TTF from Google Fonts) |

## Routes

| Route | Type | Description |
|-------|------|-------------|
| `/` | Page | Admin Dashboard — kanban, POS, sales summary, receipt history |
| `/liff` | Page | Customer LIFF ordering — phone login → menu → checkout → tracking |
| `/settings` | Page | Menu & recipe management |
| `/api/menus` | API | Menu CRUD |
| `/api/orders` | API | Orders CRUD |
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
- **POS Modal** — Walk-in order creation with item customization
- **Sales Summary** — Revenue today, order counts, sortable table
- **Receipt History** — Searchable receipt list, receipt modal with html2canvas download
- **Sound Alerts** — Web Audio API sounds for new order, status change, payment confirm, ready
- **LINE Notifications** — Triggers on ready (text) and completed (receipt image)

### LIFF Customer Page (`app/liff/page.tsx`)
- **Phone Login** — Primary auth, LINE auto-links after phone login
- **Session Persistence** — 30-day localStorage
- **Type Selection** — Dine-in / Pick-up / Delivery with phone + table/time/address input
- **Menu Ordering** — Category filter + search, item cards, customization
- **Checkout & Payment** — Cart review, PromptPay QR code, slip upload
- **Order Tracking** — Real-time progress bar, auto-refresh via polling + Realtime
- **Sound Alerts** — Order status changes on tracked order
- **Member Tab** — Points (flat 10), LINE linking, logout button

### Receipt System
- **Shared HTML Template** (`lib/receipt-html.ts`) — Single source of truth, inline CSS + Kanit font
- **Website** (admin + LIFF) — `dangerouslySetInnerHTML` → html2canvas → inline JPG
- **LINE** — Playwright screenshot (3x, 1920×2400px) → Supabase Storage → LINE image push
- **Item Customizations** — Shows sweetness, milk, extraShot per item
- **No Address/Phone** — Clean receipt design

### Settings (`app/settings/page.tsx`)
- **MenuManager** — List/create/edit/delete menu items
- **RecipeManager** — List/create/edit/delete brewing recipes linked to menu items

## Data Flow

- **Hybrid architecture**: Supabase queries with global in-memory fallback (survives hot reloads)
- **Fallback**: When `NEXT_PUBLIC_SUPABASE_URL`/`ANON_KEY` are unset, `supabase` stays `null`, all operations hit global arrays
- **Auto-seed**: Empty Supabase `menus` table auto-populated with 8 initial items
- **Real-time**: `subscribeToOrders()` subscribes to `postgres_changes` on `orders` table + 4s `setInterval` polling fallback
- **Mapping**: `mapDbOrder`/`mapAppOrder` convert snake_case DB ↔ camelCase app types
- **LINE Notifications**: Admin triggers → `/api/line-notify` → text (ready) or receipt image (completed) → LINE push
- **Receipt Image**: `generateReceiptImage()` → playwright screenshot → Supabase Storage upload → public URL

## Entity Types

| Entity | Key Fields |
|--------|-----------|
| **Order** | id, lineUserId, lineDisplayName, type, tableNumber, pickupTime, deliveryAddress, phoneNumber, items (CartItem[]), total, slipUrl, status, paymentMethod, paymentConfirmed, customerArrived, queueNumber, carInfo, createdAt, updatedAt |
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
- Dark theme: `bg-gradient-to-br from-[#1a1714] to-[#2d2824]` with amber accent
- Glassmorphism: `backdrop-blur-md`, `bg-white/5`, `border border-white/10` throughout
- Sticky header with `bg-black/40 backdrop-blur-xl border-b border-white/10`
- Thai labels everywhere (admin + LIFF)
- Product customization: sweetness (4 levels), milk (fresh/oat/soy), extra shot (+฿15)

### Receipt
- Shared HTML template (`lib/receipt-html.ts`) — single source of truth
- Playwright for LINE (3x resolution, 1920×2400px)
- html2canvas for website (inline JPG)
- Kanit font (full TTF from Google Fonts)
- No address/phone on receipt
- Item customizations shown (sweetness/milk/extraShot)

### Auth
- Admin restricted to `admin@admin.com` only
- Phone number is primary login for LIFF
- LINE auto-links after phone login
- Session: 30-day localStorage

### Communication
- Thai or English only — no Chinese characters
- Concise, direct responses
- No emojis unless explicitly asked
