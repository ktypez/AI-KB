---
type: project-status
project: habby
last_updated: 2026-06-26
id: habby-status
title: habby-status
timestamp: 2026-06-26T17:55:38Z
---

# Project Status — habby

## Stack

| Layer | Tech |
|-------|------|
| Frontend | Vite 6 + vanilla HTML/CSS/JS |
| Backend | Express 5 (serverless via Vercel) |
| Database | Redis (ioredis → Upstash) |
| Auth | SHA-256 header-based access password |
| Deploy | Vercel (static + serverless function) |
| PWA | Service Worker (push notifications, install prompt) |

## Routes

| Path | Purpose |
|------|---------|
| `/` | Main dashboard — habit grid, daily check-in, this week overview |
| `/stats` | Stats dashboard — 6 cards + bar chart (XP, streaks, completion %) |
| `/settings` | Auth, notifications config, theme picker |

## Components

## API

## Design System

- **Theme**: 5 accent-color themes (default, ocean, sunset, forest, midnight)
- **Style**: Neobrutalist-inspired, clean and minimal
- **Components**: cards, buttons, modals, form inputs
- **Typography**: system font stack

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

## Changelog

### Week 2026-06-22
- **Launch**: deployed to habby.mcky.space (Vercel) as Vite 6 + Express 5 + Upstash Redis
- **Auth**: access password `mewmew` stored in Redis (SHA-256) + login screen + persistent logout
- **Theme picker**: 5 themes (default, ocean, sunset, forest, midnight), removed dark theme
- **Cleanup**: removed archive feature, categories, unused `$$` helper, dead CSS
- **Fixes**: login button contrast on dark themes, orphaned archived habits migration
- All core features: habit CRUD, daily check-ins, streaks, XP/leveling, notes, timer, digest, stats, PWA notifications

### 2026-06-15
- Initial rebuild as Vite + vanilla HTML/CSS/JS

## PWA

- Service Worker for push notifications + install prompt
- Configurable daily reminder via browser notification

## Tests

## Known Issues

- Login button contrast needs improvement on dark/midnight themes
- Toast shadow uses `var(--shadow)` instead of hardcoded rgba
