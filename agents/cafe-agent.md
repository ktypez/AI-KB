---
type: agent-prompt
id: cafe-agent
last_updated: 2026-06-29
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
  - clsx + tailwind-merge + cva (utils)
  - PromptPay QR (custom payload generator)
triggers:
  "update .md": Read STATUS.md + AGENTS.md, update Components/Data Flow → sync KB
  "cleanup": Scan unused → health check → present findings → update docs
env_vars:
  - APP_URL
  - NEXT_PUBLIC_SUPABASE_URL
  - NEXT_PUBLIC_SUPABASE_ANON_KEY
---

# Cafe Agent

## Project Overview

Cafe LIFF — coffee shop ordering & management platform. Next.js 15 app router with drag-and-drop kanban, POS for walk-in orders, customer LIFF ordering via LINE, PromptPay payment, and menu/recipe management.

## Stack

| Layer | Tech |
|-------|------|
| Framework | Next.js 15.4.9 (App Router) + TypeScript 5.9.3 |
| UI | React 19.2.1 + Tailwind CSS 4.1.11 |
| Animation | motion 12.23.24 |
| Icons | lucide-react 0.553.0 |
| Database | Supabase (@supabase/supabase-js 2.108.2) |
| Utils | clsx 2.1.1, tailwind-merge 3.3.1, class-variance-authority 0.7.1 |
| Payment | PromptPay QR payload generator (CRC16-XModem) |
| Lint | ESLint 9.39.1 + eslint-config-next 16.0.8 |

## Architecture

```
app/layout.tsx → RootLayout (globals.css @import "tailwindcss")
app/page.tsx → Admin Dashboard SPA (kanban / POS / sales / receipts)
app/liff/page.tsx → Customer LIFF ordering flow (LINE)
app/settings/page.tsx → Settings (menu + recipe management)
lib/db-store.ts → Hybrid: Supabase query → fallback in-memory global store
lib/supabase.ts → Supabase client + Realtime channel subscription
```

### Directory Map

| Directory | Responsibility |
|-----------|---------------|
| `app/` | App Router pages + API routes |
| `app/api/` | Menu, order, recipe CRUD endpoints |
| `components/settings/` | MenuManager + RecipeManager |
| `lib/` | Types, data store, menu data, recipes, PromptPay, Supabase client, utils |
| `hooks/` | `useIsMobile()` |
| `assets/` | Static assets |

## Routes

| Route | Type | Description |
|-------|------|-------------|
| `/` | Page | Admin Dashboard — kanban, POS, sales summary, receipt history |
| `/liff` | Page | Customer LIFF ordering — type select → menu → checkout → tracking |
| `/settings` | Page | Menu & recipe management |
| `/api/menus` | API | Menu CRUD (GET list, POST create/update/toggle, DELETE) |
| `/api/orders` | API | Orders CRUD (GET list, POST create, PUT status, DELETE all) |
| `/api/recipes` | API | Recipe CRUD (GET list, POST upsert/delete) |

## Key Components

### Admin Dashboard (`app/page.tsx`)
- **Kanban Board** — 3-column drag-and-drop (pending_verify → cooking → ready → completed), drag-to-move status updates
- **POS Modal** — Walk-in order creation: menu grid with category filter + search, item customization (sweetness, milk, extra shot), cart management, auto-skip payment (sets to cooking)
- **Sales Summary** — Revenue today, order counts, sortable table with status badges
- **Receipt History** — Searchable receipt list, print receipt modal
- **Slip Zoom Modal** — View uploaded payment slip, confirm button
- **Recipe Modal** — Step-by-step brewing guide with per-step timer (play/pause/reset), ingredient list

### LIFF Customer Page (`app/liff/page.tsx`)
- **Type Selection** — Dine-in / Pick-up / Delivery with phone + table/time/address input
- **Menu Ordering** — Category filter + search, item cards, add-to-cart with customization
- **Checkout & Payment** — Cart review, PromptPay QR code, slip upload (file picker + mock slip)
- **Order Tracking** — Real-time progress bar (4 steps), auto-refresh via polling + Realtime

### Settings (`app/settings/page.tsx`)
- **MenuManager** — List/create/edit/delete menu items
- **RecipeManager** — List/create/edit/delete brewing recipes linked to menu items

## Data Flow

- **Hybrid architecture**: Supabase queries with global in-memory fallback (survives hot reloads)
- **Fallback**: When `NEXT_PUBLIC_SUPABASE_URL`/`ANON_KEY` are unset, `supabase` stays `null`, all operations hit global arrays
- **Auto-seed**: Empty Supabase `menus` table auto-populated with 8 initial items
- **Real-time**: `subscribeToOrders()` subscribes to `postgres_changes` on `orders` table + 4s `setInterval` polling fallback
- **Mapping**: `mapDbOrder`/`mapAppOrder` convert snake_case DB ↔ camelCase app types

## Entity Types

| Entity | Key Fields |
|--------|-----------|
| **Order** | id, lineUserId, lineDisplayName, type (dine-in/pick-up/delivery), tableNumber, pickupTime, deliveryAddress, phoneNumber, items (CartItem[]), total, slipUrl, status (pending_verify/cooking/ready/completed), createdAt, updatedAt |
| **MenuItem** | id, name, thName, description, price, category (coffee/non-coffee/bakery/special), imageUrl, available |
| **Recipe** | menuItemId, name, thName, ratio, grindSize, temperature, ingredients[{name, amount}], steps[{text, duration?}] |
| **CartItem** | id, name, price, quantity, sweetness, milk, extraShot |

## Environment

| Variable | Description |
|----------|-------------|
| `APP_URL` | Host URL for self-referential links |
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase project URL |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase anonymous API key |

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
- Print-specific `.no-print` class on receipt modal UI buttons
- Product customization: sweetness (4 levels), milk (fresh/oat/soy), extra shot (+฿15)
