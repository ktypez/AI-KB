---
type: status
id: habby-status
last_updated: 2026-06-26
title: habby-status
timestamp: 2026-06-26T17:55:38Z
---

# Habby Status

## Current State

Working habit tracker deployed at habby.mcky.space (Vercel). All core features operational.

## Features (active)

- ✅ Habit CRUD with emoji/color picker
- ✅ Daily check-in with streak tracking
- ✅ XP/leveling system
- ✅ Daily notes per habit
- ✅ Per-habit productivity timer
- ✅ Daily digest modal
- ✅ Stats dashboard (6 cards + bar chart)
- ✅ Push notifications with configurable time
- ✅ 5 accent-color themes (default, ocean, sunset, forest, midnight)
- ✅ Access password auth (SHA-256, stored in Redis)
- ✅ Persistent login (localStorage, logout button)
- ✅ This week overview grid

## Removed

- ❌ Categories (emoji/color picker + filter bar)
- ❌ Export/Import
- ❌ Dark theme (kept midnight)
- ❌ Archive feature

## Known Issues

- Login button contrast fixed for dark/midnight themes
- Toast shadow uses `var(--shadow)` instead of hardcoded rgba
