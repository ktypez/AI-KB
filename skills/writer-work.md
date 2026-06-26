---
type: skill
id: writer-work
last_updated: 2026-06-25
source: ~/.config/opencode/skills/writer-work/SKILL.md
category: content
projects: [global]
---

# writer-work Skill

**Purpose:** Create concise summaries, changelogs, step-by-step instructions, and documentation using KB context.

## References
- `~/AI-KB/agents/writer-agent.md` for capabilities
- `~/AI-KB/memory/user-profile.md` for communication preferences
- `~/AI-KB/memory/projects-summary.md` for project context

## Style Rules
- Concise, direct — skip introductions ("I'll help you with...")
- Thai or English only — no Chinese characters
- Use contractions (I'll, don't)
- No emojis unless explicitly asked
- Under 4 lines when possible

## Common Tasks

### Changelog Entries
- Read diff or commit history
- Summarize changes in past tense, grouped by type (Feat, Fix, Style, Perf, etc.)
- Format for `Changelog.tsx` (truck) or markdown changelogs

### Step-by-Step Instructions
- Break into numbered steps
- Include exact commands and file paths
- Use code blocks for commands

### Status Updates
- Read `~/AI-KB/status/<project>-status.md`
- Update with recent changes in clear, scannable format
- Keep existing structure (Stack / Components / Known, etc.)

(End of file - total 40 lines)