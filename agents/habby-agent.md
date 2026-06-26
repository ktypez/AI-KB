---
type: agent
id: habby-agent
last_updated: 2026-06-26
personality: trophy goblin
capabilities:
  - Vite 6 + vanilla HTML/CSS/JS
  - Express 5 + ioredis (Upstash)
  - SHA-256 access password auth
  - XP/leveling gamification system
  - daily notes per habit
  - productivity timer
  - push notifications (Service Worker)
  - daily digest + stats dashboard
  - theme picker (5 themes)
---

# Habby Agent

## Overview

Gamified habit tracker — Vite frontend + Express 5 backend + Redis (Upstash). Password-protected, neobrutalist design, 5 accent-color themes.

## Stack

| Layer | Tech |
|-------|------|
| Frontend | Vite 6 + vanilla HTML/CSS/JS |
| Backend | Express 5 (serverless via Vercel) |
| Database | Redis (ioredis → Upstash) |
| Auth | SHA-256 header-based access password |
| Deploy | Vercel (static + serverless function) |
| PWA | Service Worker (push notifications, install prompt) |

## Features

- **Habits**: CRUD with emoji picker, name, color
- **Check-ins**: Daily toggle, streak calculation, XP rewards
- **XP/Levels**: +10-40 XP per check-in (streak bonus), level up every 100 XP
- **Notes**: Daily notes per habit, edit/delete
- **Timer**: Per-habit stopwatch with total accumulation
- **Stats**: Total habits, XP, best streak, weekly completion %, bar chart
- **Digest**: Daily summary with done/pending counts and streaks
- **Notifications**: Configurable daily reminder (browser notif)
- **Themes**: 5 accent-color themes (default, ocean, sunset, forest, midnight)
- **Auth**: Access password stored in Redis (SHA-256), persistent login via localStorage

## Data Model

```
habit:{id} → hash { name, emoji, color, archived, created_at }
habit:{id}:dates → set of ISO date strings
habit:{id}:note:{date} → string
habit:{id}:timer:running → timestamp
habit:{id}:timer:total → seconds
habits:all → sorted set (ordered by creation)
user:xp → integer
app:password → SHA-256 hash string
notifications:enabled → boolean
notifications:time → HH:MM string
```

## Dev Commands

- `yarn dev` — dev server (Express + Vite)
- `yarn build` — production build (Vite)
- Local: `node server.js` — full stack on port 3001
- Deploy: push to GitHub → Vercel auto-deploys
