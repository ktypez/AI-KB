---
type: agent-prompt
id: habby-agent
project: habby
last_updated: 2026-07-02
personality: trophy goblin
stack:
  - Vite 6 + vanilla HTML/CSS/JS
  - Express 5 + ioredis (Upstash)
  - SHA-256 access password auth
  - XP/leveling gamification system
  - daily notes per habit
  - productivity timer
  - push notifications (Service Worker)
  - daily digest + stats dashboard
  - theme picker (2 themes: light + dark)
  - mcky.space design system (JetBrains Mono, neobrutalist tokens)
commands:
  dev: yarn dev (Express + Vite)
  build: yarn build
  start: node server.js (port 3001)
  deploy: push to GitHub → Vercel auto-deploys
  test: Not configured
  lint: Not configured
triggers:
  "update .md": Read STATUS.md + AGENTS.md, update features/data model → sync KB
  "cleanup": Scan unused → build check → present findings → update docs
---

# Habby Agent

## Overview

Gamified habit tracker — Vite frontend + Express 5 backend + Redis (Upstash). Password-protected, neobrutalist design using mcky.space DESIGN.md tokens. 2 themes (light/dark), self-hosted JetBrains Mono font.

## Stack

| Layer | Tech |
|-------|------|
| Frontend | Vite 6 + vanilla HTML/CSS/JS |
| Backend | Express 5 (serverless via Vercel) |
| Database | Redis (ioredis → Upstash) |
| Auth | SHA-256 header-based access password |
| Deploy | Vercel (static + serverless function) |
| PWA | Service Worker (push notifications, install prompt) |

## Architecture

### Features

- **Habits**: CRUD with emoji picker, name, color
- **Check-ins**: Daily toggle, streak calculation, XP rewards
- **XP/Levels**: +10-40 XP per check-in (streak bonus), level up every 100 XP
- **Notes**: Daily notes per habit, edit/delete
- **Timer**: Per-habit stopwatch with total accumulation
- **Stats**: Total habits, XP, best streak, weekly completion %, bar chart
- **Digest**: Daily summary with done/pending counts and streaks
- **Notifications**: Configurable daily reminder (browser notif)
- **Themes**: 2 themes — light + dark via `data-theme` attribute
- **Auth**: Access password stored in Redis (SHA-256), persistent login via localStorage
- **Design**: mcky.space design system — JetBrains Mono, 3px borders, 6px radius, 4px shadows, terminal-style login

### Data Model

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

## Key Patterns

None yet.

## Commands

| Command | What it does |
|---------|-------------|
| `yarn dev` | Dev server (Express + Vite) |
| `yarn build` | Production build (Vite) |
| `node server.js` | Local full-stack (port 3001) |
| push to GitHub | Vercel auto-deploys |
| test | Not configured |
| lint | Not configured |

## Triggers

### "update .md"

1. Read project AGENTS.md + current KB status
2. Update `~/AI-KB/status/habby-status.md` with latest changes
3. Update `~/AI-KB/agents/habby-agent.md` (features, data model)
4. If project AGENTS.md has stale info, update it too

### "cleanup"

1. Scan unused files, empty files, dead exports
2. Health check: `yarn build`
3. Deep scan: leftover dirs, `console.log`, TODO/FIXME
4. Present findings for user to choose
5. Commit & Push if user says so
6. Update STATUS.md + KB agent file
7. Never cleanup `.env*`, `node_modules/`, `dist/`, `.git/`, or essential config

## Rules

None yet.
