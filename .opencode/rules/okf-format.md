---
type: rule
id: okf-format-rule
description: Rules for handling OKF (Open Knowledge Format) files
---

# OKF Format Rules

OKF = YAML frontmatter + Markdown body. Every file in `~/AI-KB/` uses this format.

## Structure

```yaml
---
type: <category>
id: <unique-id>
last_updated: <YYYY-MM-DD>
---
```

## Rules

1. **Always preserve frontmatter** — do not strip or modify YAML frontmatter when editing OKF files
2. **Read frontmatter first** — before working with a file, parse its frontmatter to understand its `type` and `id`
3. **Frontmatter is metadata** — the `---` delimiters must remain intact; content after the second `---` is the Markdown body
4. **Reserved types**: `index`, `instruction`, `agent-prompt`, `project-status`, `memory`, `skill`, `task`, `rule`, `plugin`
5. **Date format**: always `YYYY-MM-DD` in `last_updated`
6. **No nested YAML** — frontmatter is flat or single-level lists only
