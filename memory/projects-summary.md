---
type: memory
id: projects-summary
last_updated: 2026-06-21
projects:
  - id: truck
    path: ~/truck
    domain: truck.ezzy.dev (Vercel SPA)
  - id: mcky.space
    path: ~/mcky.space
    domain: mcky.space (Vercel)
  - id: clientdata
    path: ~/clientdata
    domain: data.mcky.space (Vercel)
---

# Projects Summary

## Project Comparison

| Aspect | truck | mcky.space | clientdata |
|--------|-------|------------|------------|
| Framework | React 19 + Vite 6 | Next.js 14.2.5 (App Router) | Next.js 16 |
| Database | Supabase (Postgres) | localStorage + Supabase (blog posts) | Neon Postgres (Drizzle) |
| Storage | Supabase Storage | localStorage | Cloudflare R2 |
| State | tanstack/react-query | inline useState | React Query |
| Auth | Supabase Auth | none | scrypt + HMAC tokens |
| PWA | ✅ (injectManifest) | ❌ | ✅ (Serwist) |
| Testing | vitest (14 tests) | ❌ | ❌ |
| Theme | 16 themes, CSS vars | Dark terminal (#0a0e14) | Tailwind |
| CI/CD | GitHub Actions (edge functions) | Vercel | Vercel |

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
