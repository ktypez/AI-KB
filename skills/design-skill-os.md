---
type: skill
id: design-skill-os
last_updated: 2026-06-25
source: ~/.config/opencode/skills/design-skill-os/SKILL.md
category: design
projects: [global]
---

# design-skill-os Skill

**Purpose:** Elite design reasoning layer — gestalt principles, chromatic mastery (60-30-10), typographic modular scale (Golden Ratio), digital heuristics (Nielsen/Norman), Red Team audits, narrative synthesis for high-fidelity UI/UX.

## Core Principles

### Gestalt Sovereignty
Use proximity, similarity, closure, figure-ground to organize information naturally. Every layout must pass gestalt coherence check.

### Chromatic Mastery
- **60-30-10 Rule**: 60% dominant neutral, 30% secondary, 10% accent
- Palettes based on industry psychology (trust for fintech, energy for creative, calm for healthcare)
- WCAG AA contrast ratios (4.5:1 text, 3:1 large text)

### Typographic Modular Scale
- Golden Ratio (1.618) or Major Third (1.25) for type sizes
- Line-height: 1.5–1.618 × font-size for body text
- Pair typefaces: serif + sans-serif with distinct x-heights
- Max 3 typefaces, 4–6 size steps

### Digital Heuristics (Nielsen/Norman)
1. Visibility of system status
2. Match between system and real world
3. User control and freedom
4. Consistency and standards
5. Error prevention
6. Recognition rather than recall
7. Flexibility and efficiency
8. Aesthetic and minimalist design
9. Help users recognize, diagnose, recover from errors
10. Help and documentation

## Red Team Protocol
Every design runs adversarial audit:
1. **HEURISTICS** — Fix UX friction & logic errors
2. **ACCESSIBILITY** — Ensure WCAG AA compliance
3. **ANTI-SCHTICK** — Strip lazy AI trends for authentic branding

### Anti-Schtick Checks
- No generic gradients unless brand-specified
- No overused AI defaults (glassmorphism, generic shadows)
- Every visual choice ties back to brand/user need

## Narrative Synthesis
Every page defines:
- **Call to Adventure**: Entry point that hooks user
- **Emotional Arc**: Mood progression entry → engagement → action
- **Visual Hierarchy**: Scannable zones (primary CTA, secondary info, tertiary trust signals)

## Industry-Specific Modes
| Industry | Focus |
|----------|-------|
| SaaS & Tech | Efficiency, clarity, developer tooling |
| Fintech | Trust, precision, data density |
| Luxury & E-com | Emotion, elegance, storytelling |
| Healthcare | Accessibility, calm, information hierarchy |
| Creative Arts | Portfolios, branding, experimental UI |

## Layout & Spacing
- 4px or 8px base unit for spacing
- 12-column grid system
- Max content width: 1200px (desktop), 720px (tablet), full-bleed (mobile)
- White space as deliberate design element

## Accessibility Baseline
- Interactive targets ≥ 44×44px
- Focus indicators: `:focus-visible` with 2px offset ring
- Color not sole differentiator — use icons, labels, patterns
- Heading hierarchy (h1→h6) maps to visual hierarchy 1:1
- Alt text on meaningful images; `aria-hidden="true"` on decorative

## Verification Checklist
- [ ] Gestalt coherence
- [ ] 60-30-10 color balance
- [ ] Typographic scale follows modular ratio
- [ ] WCAG AA contrast ratios
- [ ] Touch targets ≥ 44px
- [ ] Nielsen heuristics pass
- [ ] Anti-schtick — no lazy AI defaults
- [ ] Narrative arc defined
- [ ] Responsive at all breakpoints

(End of file - total 80 lines)