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
termux:
  - node: use directly (no npx)
  - vite: node node_modules/.bin/vite
  - build: node node_modules/vite/bin/vite.js build (truck)
  - npm: works normally
  - shebang: unavailable (/usr/bin/env broken)
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
