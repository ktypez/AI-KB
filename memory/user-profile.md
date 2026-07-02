---
type: memory
id: user-profile
last_updated: 2026-06-29
preferences:
  - concise responses
  - easy-to-understand summaries
  - step-by-step instructions
  - Thai or English only
  - casual friendly tone
  - no unnecessary intros
rules:
  - no Chinese characters in chat or code
  - answer first, then act
  - use contractions (I'll, don't)
  - emojis only when explicitly asked
  - README.md must use censored names: project-a, project-b, project-c (no real names/domains)
  - all KB files use OKF format (YAML frontmatter + Markdown body)
termux:
  - node: use directly (no npx)
  - vite: node node_modules/vite/bin/vite.js build
  - eslint: node node_modules/.pnpm/eslint@10.5.0/node_modules/eslint/bin/eslint.js src/
  - test: node node_modules/.pnpm/vitest@3.2.6_jsdom@29.1.1_lightningcss@1.32.0_terser@5.48.0/node_modules/vitest/vitest.mjs run
  - next dev: npx next dev -H localhost (shebang broken, -H localhost for network binding)
  - npm: works normally
  - shebang: unavailable (/usr/bin/env broken)
  - vercel: vercel CLI installed at /home/.npm-global/bin/vercel (v54.18.1), logged in as fall3n36
  - supabase: npx supabase (v2.108.0), logged in with access token
node_ver: 22.14.0 (downloaded ARM64 binary, symlinked over v18 in /usr/local/node-v22.14.0-linux-arm64/)
git:
  - no push without explicit instruction
  - commit only when asked
env:
  - SUPABASE_ACCESS_TOKEN: sbp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
opencode_permissions:
  global_config: /root/.config/opencode/opencode.jsonc
  external_directories:
    - ~/AI-KB/**
    - ~/truck/**
    - ~/mcky.space/**
    - ~/clientdata/**
    - ~/habby/**
    - ~/cafe/**
---

# User Profile

## Communication Preferences

| Preference | Detail |
|-----------|--------|
| Tone | Concise, direct, casual — like chatting with a buddy |
| Length | Under 4 lines when possible |
| Language | Thai or English |
| Emojis | Only when explicitly asked |
| Introductions | None — skip "I'll help you with..." |

## Workflow

- Always read AGENTS.md + STATUS.md before starting work
- `update .md` — re-read and update STATUS.md + AGENTS.md from latest state
- Ask before making changes unless the instruction is clear
- All KB files use OKF format (YAML frontmatter + Markdown body)
