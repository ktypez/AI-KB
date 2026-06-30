---
type: project-status
project: cafe
last_updated: 2026-06-29
id: cafe-status
title: cafe-status
timestamp: 2026-06-29T10:00:00Z
---

# Project Status — cafe

## Current State

MVP complete with admin dashboard, LIFF customer page, and settings page.

## Stack

- **Framework**: Next.js 15.4.9 (App Router)
- **UI Library**: React 19.2.1, TypeScript 5.9.3
- **Styling**: Tailwind CSS 4.1.11 + PostCSS
- **Animation**: motion 12.23.24
- **Icons**: lucide-react 0.553.0
- **Database**: Supabase (@supabase/supabase-js 2.108.2) + in-memory fallback
- **Utils**: clsx 2.1.1, tailwind-merge 3.3.1, class-variance-authority 0.7.1
- **Payment**: PromptPay QR payload generator (CRC16-XModem)
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

## Features

- Kanban board with drag-and-drop order management (4 status columns)
- POS modal for walk-in orders with item customization
- PromptPay QR payment with slip upload
- LIFF customer flow: type selection → menu → checkout/payment → real-time tracking
- Settings page: menu CRUD + recipe CRUD
- Real-time order updates via Supabase Realtime + 4s polling fallback
- Hybrid data store (Supabase → in-memory fallback)
- Auto-seed menus table when empty
- Recipe modal with step-by-step timer

## API

| Endpoint | Methods | Purpose |
|----------|---------|---------|
| `/api/menus` | GET, POST, DELETE | List, create/update/toggle, delete menu items |
| `/api/orders` | GET, POST, PUT, DELETE | List, create, update status, clear all |
| `/api/recipes` | GET, POST | List, upsert/delete recipes |

## Data Model

### Tables (Supabase)
- **menus**: id, name, th_name, description, price, category, image_url, available
- **orders**: id, line_user_id, line_display_name, line_picture_url, type, table_number, pickup_time, delivery_address, phone_number, items (jsonb), total, slip_url, status, created_at, updated_at

### In-Memory Store
- `globalForDb.orders` — Order[]
- `globalForDb.menuItems` — MenuItem[] (seeded from `initialMenuItems`)
- `globalForRecipes.recipes` — Recipe[] (seeded from `recipes`)

## Design System

- **Dark theme**: `from-[#1a1714] to-[#2d2824]` gradient bg
- **Accent**: Amber-500 as primary action color
- **Glassmorphism**: `backdrop-blur-md`, `bg-white/5`, `border-white/10`
- **Cards**: `rounded-2xl` with `border border-white/10` + `shadow-lg`
- **Status colors**: amber (pending), blue (cooking), emerald (ready), stone (completed)
- **Receipt**: White card with dashed borders, print-friendly via `@media print`

## Changelog

### 2026-06-29
- Initial MVP: admin dashboard, LIFF customer page, settings
- Removed VAT 7% from checkout receipts

## Known Issues

- No testing setup yet
- LIFF page uses mock LINE user data (no actual LIFF SDK integration)
- Slip upload uses client-side `URL.createObjectURL` (no persistent storage)
- Admin page is a single monolithic component (~850+ lines)
- No authentication/authorization layer
- App title in layout still says "My Google AI Studio App"
