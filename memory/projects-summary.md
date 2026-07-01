---
type: memory
id: projects-summary
last_updated: 2026-06-30
projects:
  - id: truck
    path: ~/truck
    domain: truck.mcky.space (Vercel SPA)
  - id: mcky.space
    path: ~/mcky.space
    domain: mcky.space (Vercel)
  - id: clientdata
    path: ~/clientdata
    domain: data.mcky.space (Vercel)
  - id: habby
    path: ~/habby
    domain: habby.mcky.space (Vercel)
  - id: cafe
    path: ~/cafe
    domain: pongwashira-sroywongsas-projects/cafe (Vercel)
---

# Projects Summary

## Project Comparison

| Aspect | truck | mcky.space | clientdata | habby | cafe |
|--------|-------|------------|------------|-------|------|
| Framework | React 19 + Vite 8 + TypeScript 6 | Astro 7.0.2 + Alpine.js | Next.js 16 (webpack) | Vite 6 + Express 5 | Next.js 15 (App Router) |
| Database | Supabase (Postgres) | Supabase (todos/auth) + .md files (blog) | Neon Postgres (Drizzle) | Redis (Upstash) | Supabase (Postgres) |
| Storage | Supabase Storage | Supabase | Cloudflare R2 | None | Supabase Storage |
| State | tanstack/react-query v5 | Alpine.js x-data | custom fetch + React state | None | React state |
| Auth | Supabase Auth | SHA-256 header-based auth | scrypt + HMAC tokens | SHA-256 header-based auth | jose JWT (admin@admin.com) |
| PWA | ✅ (injectManifest) | ❌ | ✅ (cleanup-only sw) | ✅ (Service Worker) | ✅ (LIFF) |
| Testing | vitest (16 tests) | ❌ | Vitest (16 tests) | ❌ | ❌ |
| Theme | 16 themes, CSS vars | Aura dark terminal, shimmer skeleton | Tailwind | 5 accent-color themes | Dark (amber accent) |
| CI/CD | GitHub Actions (edge functions) | Vercel | Vercel | Vercel | Vercel |

## Dev Commands

**truck** (Termux):
- `node node_modules/.bin/vite` — dev
- `node node_modules/vite/bin/vite.js build` — build
- `node node_modules/.bin/vitest run` — test (16 tests)
- `node node_modules/.bin/eslint src/` — lint
- Node v22.14.0

**mcky.space**:
- `npm run dev` — dev
- `npm run build` — build (prebuild + astro build)

**clientdata** (Termux):
- `npm run dev` — dev (port 3002, host 0.0.0.0)
- `npm run build` — build (`next build --webpack`)
- `npm run lint` — ESLint
- `npm run db:push` — push Drizzle schema
- `npm run db:migrate` — run migration
- `pnpm test` — Vitest (16 tests)
- `node /data/data/com.termux/files/usr/bin/vercel --prod` — deploy

**habby**:
- `yarn dev` — dev (Express + Vite)
- `yarn build` — build (Vite)
- `node server.js` — local full-stack (port 3001)
- Access password: stored in Redis (SHA-256), default `mewmew`
- Deploy: push to GitHub → Vercel auto-deploys

**cafe** (Termux):
- `node node_modules/next/dist/bin/next dev` — dev
- `node node_modules/next/dist/bin/next build` — build
- Deploy: push to GitHub → Vercel auto-deploys
