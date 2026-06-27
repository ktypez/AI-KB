---
type: skill
id: anthropic-design
last_updated: 2026-06-27
category: design-system
tags:
  - design-tokens
  - typography
  - color-palette
  - accessibility
  - warm-aesthetic
---

# Anthropic Design System

Warm, restrained canvas built around off-white parchment and terracotta rust. More academic journal than startup landing page.

## Core Tokens

| Token | Hex | Usage |
|-------|-----|-------|
| primary | #C2522D | CTAs, brand moments |
| canvas | #FAF9F7 | Page background |
| ink | #1A1A18 | Headings, body text |
| surface-1 | #F2F0EC | Card backgrounds |
| border | #D8D4CC | Hairline separators |

## Typography

- **Display**: Styrene A/B, 52px, weight 500, line-height 1.08
- **Body**: Styrene A, 17px, weight 400, line-height 1.65
- Long-form reading configuration; generous body size signals reading comfort is a value

## Layout

- Max content width: 960px (body), 1200px (marketing)
- Section padding: 96-128px vertical
- Generous whitespace signals confidence, not emptiness

## Accessibility

- Primary on canvas: 4.6:1 (passes AA)
- Ink on canvas: 17.2:1 (passes AAA)
- Touch target: 44x44px minimum
- Focus: 2px primary outline, 2px offset
- Respects prefers-reduced-motion

## When to Use

- Landing pages with intellectual warmth
- Research documentation sites
- Academic or editorial projects
- Any project needing warm, humanistic aesthetic

## Full Skill

See `~/.config/opencode/skills/anthropic-design/SKILL.md` for complete tokens, Tailwind config, component patterns, and dark mode adaptation.

## Related Skills

- `design-skill-os` — Elite design reasoning (gestalt, 60-30-10, heuristics)
- `frontend-dev` — Expert frontend engineering
- `web-dev` — Modern web apps with semantic HTML5
