---
type: skill
id: update-md
last_updated: 2026-06-25
source: ~/.config/opencode/skills/update-md/SKILL.md
category: kb-maintenance
projects: [truck, mcky.space, clientdata]
---

# update-md Skill

**Purpose:** Read project AGENTS.md + KB status, update KB with latest project changes.

## Trigger
`update .md` or `update kb` — shared trigger for truck, mcky.space, clientdata

## Workflow
1. Determine project from context (cwd, conversation)
2. Read project's `AGENTS.md` + `~/AI-KB/status/<project>-status.md`
3. Read `~/AI-KB/agents/<project>-agent.md` for trigger instructions
4. Update `~/AI-KB/status/<project>-status.md` with latest changes
5. Sync `~/AI-KB/agents/<project>-agent.md` if patterns/architecture changed

## Per-Project Guidance

### truck
- Update STATUS.md sections: Components / Data Flow / Constraints
- Sync to `~/AI-KB/status/truck-status.md`
- Update `~/AI-KB/agents/truck-agent.md` if patterns changed

### mcky.space
- Update STATUS.md sections: Routes / Components / Design System / Recent Updates
- Sync to `~/AI-KB/status/mcky-status.md`
- Update `~/AI-KB/agents/mcky-agent.md` if routes/design changed

### clientdata
- Update STATUS.md sections: Changelog / Known / Components
- Sync to `~/AI-KB/status/clientdata-status.md`
- Update `~/AI-KB/agents/clientdata-agent.md` if breaking changes

(End of file - total 43 lines)