---
type: task
id: tasks-overview
last_updated: 2026-06-26
shared_triggers:
  - trigger: update .md
    action: Read KB/status/<project>-status.md + AGENTS.md, update KB/status/<project>-status.md, sync KB/agents/<agent>.md if needed
    applies_to: [truck, mcky.space, clientdata, habby]
  - trigger: cleanup
    action: Scan unused → health check → present findings → update KB/status/<project>-status.md + KB
    applies_to: [truck, mcky.space, clientdata, habby]
  - trigger: wrap-day
    action: Read diff, update Changelog.tsx + KB/status/truck-status.md, commit
    applies_to: [truck]
---

# Task Triggers Overview

See [INSTRUCTION.md](/root/AI-KB/INSTRUCTION.md) for the full usage guide.

## Shared Task Patterns

| Trigger | Description | Projects |
|---------|-------------|----------|
| `update .md` | Read KB/status + AGENTS.md, update status, sync agent files | truck, mcky.space, clientdata, habby |
| `cleanup` | Scan unused → health check → present findings → update KB | truck, mcky.space, clientdata, habby |
| `wrap-day` | Review today's diff, write changelog entry, update truck status, commit | truck |

## Task Checklist

Before editing any project file:
1. Read the project's AGENTS.md for rules
2. Read the project's status in `~/AI-KB/status/<project>-status.md`
3. Read the relevant source file (always latest version)

After making changes to any file in AI-KB:
- The change is already centralized — no sync needed
