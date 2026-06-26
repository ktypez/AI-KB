---
type: memory
id: projects-summary
last_updated: 2026-06-26
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
---

# Projects Summary

## Project Comparison

| Aspect | truck | mcky.space | clientdata | habby |
|--------|-------|------------|------------|-------|
| Framework | React 19 + Vite 8 | Astro 7 + Alpine.js | Next.js 16 | Vite 6 + vanilla HTML/CSS/JS |
| Database | Supabase (Postgres) | Supabase (todos/auth) + .md files (blog) | Neon Postgres (Drizzle) | Redis (Upstash) |
| Storage | Supabase Storage | Supabase | Cloudflare R2 | None |
| State | tanstack/react-query | Alpine.js x-data | custom fetch + React state | None |
| Auth | Supabase Auth | SHA-256 header-based auth | scrypt + HMAC tokens | SHA-256 header-based auth |
| PWA | ✅ (injectManifest) | ❌ | ✅ (Serwist) | ✅ (Service Worker) |
| Testing | vitest (14 tests) | ❌ | ❌ | ❌ |
| Theme | 16 themes, CSS vars | Aura dark terminal, shimmer skeleton | Tailwind | 5 accent-color themes |
| CI/CD | GitHub Actions (edge functions) | Vercel | Vercel | Vercel |

## Dev Commands

**truck** (Termux):
- `node node_modules/.bin/vite` — dev
- `node node_modules/vite/bin/vite.js build` — build
- `node node_modules/.bin/vitest run` — test
- `node node_modules/.bin/eslint src/` — lint

**mcky.space**:
- `npm run dev` — dev
- `npm run build` — build

**clientdata** (Termux):
- `npm run dev` — dev (port 3002, host 0.0.0.0)
- `npm run build` — build (`next build --webpack`)
- `npm run lint` — ESLint
- `npm run db:push` — push Drizzle schema
- `npm run db:migrate` — run migration
- `node /data/data/com.termux/files/usr/bin/vercel --prod` — deploy

**habby**:
- `yarn dev` — dev (Express + Vite)
- `yarn build` — build (Vite)
- `node server.js` — local full-stack (port 3001)
- Access password: stored in Redis (SHA-256), default `mewmew`
- Deploy: push to GitHub → Vercel auto-deploys
