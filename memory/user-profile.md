---
type: memory
id: user-profile
last_updated: 2026-06-22
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
termux:
  - node: use directly (no npx)
  - vite: node node_modules/vite/bin/vite.js build
  - eslint: node node_modules/.pnpm/eslint@10.5.0/node_modules/eslint/bin/eslint.js src/
  - test: node node_modules/.pnpm/vitest@3.2.6_jsdom@29.1.1_lightningcss@1.32.0_terser@5.48.0/node_modules/vitest/vitest.mjs run
  - npm: works normally
  - shebang: unavailable (/usr/bin/env broken)
node_ver: 22.14.0 (downloaded ARM64 binary, symlinked over v18 in /usr/local/node-v22.14.0-linux-arm64/)
git:
  - no push without explicit instruction
  - commit only when asked
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
