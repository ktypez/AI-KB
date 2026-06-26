---
type: skill
id: web-dev
last_updated: 2026-06-25
source: ~/.config/opencode/skills/web-dev/SKILL.md
category: engineering
projects: [global]
---

# web-dev Skill

**Purpose:** Build modern, responsive, accessible web apps with semantic HTML5, CSS Grid/Flexbox, and vanilla JS. Covers UI/UX design, cross-browser compat, performance, maintainable code.

## Workflow
1. Determine project scope and requirements
2. Scaffold structure (HTML entry, CSS, JS directories)
3. Build interface:
   - Semantic HTML5 (`<header>`, `<main>`, `<section>`, `<nav>`, `<article>`, `<footer>`)
   - CSS Grid/Flexbox layout — no framework, pure CSS
   - Vanilla JS interactivity (no libraries unless requested)
   - Modern UI principles (hierarchy, spacing, color, typography scale)
4. Ensure quality:
   - Cross-browser compatibility (Chrome, Firefox, Safari)
   - Accessibility (ARIA, keyboard nav, focus management, contrast, `alt`, `:focus-visible`)
   - Performance (minimal DOM reflows, debounced/throttled handlers, lazy-load, `will-change`, efficient selectors)
   - Responsiveness (mobile-first, fluid typography, touch targets ≥ 44px)
5. Maintainable code:
   - Descriptive class names (BEM or similar)
   - CSS custom properties for theming
   - Small, single-purpose JS functions
   - JSDoc on public functions

## Code Style
- **HTML**: semantic elements, valid markup, proper `lang`, viewport meta
- **CSS**: custom properties at `:root`, mobile-first media queries, logical properties (`margin-inline`, `padding-block`), `clamp()` for fluid sizing
- **JS**: `'use strict'` or ES modules, `const`/`let` (no `var`), event delegation, `requestAnimationFrame` for visual updates, `IntersectionObserver` for visibility

## Verification
- Open HTML in browser — confirm layout, interactivity, responsiveness
- Lighthouse audit (Performance, Accessibility, Best Practices, SEO)
- Resize viewport across mobile, tablet, desktop breakpoints
- Tab through interactive elements — verify keyboard navigation and focus rings

(End of file - total 46 lines)