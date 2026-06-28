---
type: index
id: skills-index
last_updated: 2026-06-26
skills:
  - id: update-md
    path: skills/update-md.md
  - id: cleanup-project
    path: skills/cleanup-project.md
  - id: code-review
    path: skills/code-review.md
  - id: kb-manage
    path: skills/kb-manage.md
  - id: frontend-dev
    path: skills/frontend-dev.md
  - id: design-skill-os
    path: skills/design-skill-os.md
  - id: supabase-postgres-best-practices
    path: skills/supabase-postgres-best-practices.md
  - id: web-dev
    path: skills/web-dev.md
  - id: writer-work
    path: skills/writer-work.md
---

# AI Skills Overview

Centralized index of all specialized skills available for AI agents.
**Read this file first** when looking for skill capabilities.

## Skill Registry

| Skill | Category | Description |
|-------|----------|-------------|
| update-md | KB Maintenance | Read project AGENTS.md + KB status, update KB with latest project changes |
| cleanup-project | Project Health | Scan for unused deps/files, health check, present findings, update KB status |
| code-review | Engineering | Code quality, bug detection, security audit, performance, best practices |
| kb-manage | KB Maintenance | Maintain and validate the AI-KB — frontmatter checks, index updates, sync |
| frontend-dev | Engineering | Expert frontend — React 19, Next.js 16, Vue, Angular, Svelte, TypeScript |
| design-skill-os | Design | Elite design reasoning — gestalt, 60-30-10, modular scale, Nielsen heuristics |
| supabase-postgres-best-practices | Database | Postgres performance optimization from Supabase |
| web-dev | Engineering | Modern web apps — semantic HTML5, CSS Grid/Flexbox, vanilla JS |
| writer-work | Content | Concise summaries, changelogs, step-by-step instructions, documentation |

## Directory Layout

```
~/AI-KB/
├── skills/
│   ├── INDEX.md                    ← THIS FILE
│   ├── update-md.md
│   ├── cleanup-project.md
│   ├── code-review.md
│   ├── kb-manage.md
│   ├── frontend-dev.md
│   ├── design-skill-os.md
│   ├── supabase-postgres-best-practices.md
│   ├── web-dev.md
│   └── writer-work.md
```

## Usage

Skills are loaded automatically by opencode based on task context. Each skill has a `SKILL.md` in `~/.config/opencode/skills/<skill-name>/` with detailed instructions.

To invoke a skill manually, reference it by name in your task:
- "Use the **update-md** skill to sync the KB"
- "Apply **cleanup-project** to scan for unused files"
- "Follow **design-skill-os** principles for this UI"

## Adding New Skills

1. Create skill in `~/.config/opencode/skills/<skill-name>/SKILL.md`
2. Add entry to this `INDEX.md` (table + skills list in frontmatter)
3. Create `~/AI-KB/skills/<skill-name>.md` with summary — **always required**
4. Update `~/AI-KB/INDEX.md` skills section if it lists individual skills
5. Update `~/AI-KB/INSTRUCTION.md` skills count in directory tree

> **Rule**: Every skill MUST have a matching `~/AI-KB/skills/<skill-name>.md` doc. No skill without docs.

(End of file - total 79 lines)