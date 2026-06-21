---
type: agent
id: mcky-agent
project: mcky.space
last_updated: 2026-06-21
status_ref: STATUS.md in project root
stack:
  - Next.js 14.2.5 (App Router, src/app/)
  - TypeScript
  - Pure CSS (globals.css, no Tailwind classes)
  - JetBrains Mono (Google Fonts)
  - localStorage (client-side only)
  - Supabase (blog posts)
  - react-markdown + remark-gfm + remark-breaks
  - Deployment: Vercel
routes:
  - path: / — Terminal sim homepage with typewriter animation
  - path: /about — Terminal-style bio page
  - path: /blog — Blog with markdown support (react-markdown + remark-gfm)
  - path: /habits — Habit tracker (3 tabs: habits, stats, profile)
  - path: /task — Todo list (3 tabs)
  - path: /projects — Project showcase with cat project.txt
commands:
  dev: npm run dev
  build: npm run build
  lint: Built into npm run build (Next.js checks)
triggers:
  "update .md": Read STATUS.md + AGENTS.md, update routes/components/design → sync KB
  "cleanup": Scan unused → build check → present findings → update docs
---

# mcky.space Agent

## Design System
- Dark theme `#0a0e14` bg
- Accent colors: amber, green, cyan, blue, purple
- CSS variables in `:root` — no magic numbers
- Terminal/retro aesthetic

## Triggers

### "update .md"
1. Read STATUS.md + AGENTS.md
2. Update STATUS.md (Routes / Components / Design System / Recent Updates)
3. After updating STATUS.md — sync changes to `~/AI-Knowledge-Base/agents/mcky-agent.md`

### "cleanup"
1. Scan unused files, empty files, dead exports in `src/app/` and `src/components/`
2. Health check: `npm run build` (includes typecheck + lint)
3. Deep scan: leftover dirs, `console.log`, TODO/FIXME
4. Present findings for user to choose
5. Commit & Push if user says so
6. Update STATUS.md + KB agent file
7. Never cleanup `.env*`, `node_modules/`, `.next/`, `.git/`, or essential config

## Agent Guidelines
| Rule | Value |
|------|-------|
| Tone | Concise, direct, casual — like chatting with a buddy |
| Style | Contractions (I'll, don't), no emojis unless asked |
| Language | Thai or English only |
| Behavior | Answer first, then act |

- Prioritize reference design when given
- New routes must match existing terminal style exactly
- All pages `'use client'` — inline state + localStorage
- No external API calls, no database
