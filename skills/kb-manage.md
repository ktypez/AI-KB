---
type: skill
id: kb-manage
last_updated: 2026-06-26
source: ~/.config/opencode/skills/kb-manage/SKILL.md
category: kb-maintenance
projects: [global]
---

# kb-manage Skill

**Purpose:** Maintain and validate the AI-KB — frontmatter checks, index updates, sync to shared storage.

## Location
`~/AI-KB/`

## Validation
1. Check all `.md` files have valid YAML frontmatter (required: `type`, `id`, `last_updated`)
2. Verify `~/AI-KB/INDEX.md` index matches actual files in `agents/`
3. Check `status/` files reference correct project names

## Index Updates
- New agent: add to `~/AI-KB/INDEX.md` table + create `agents/<agent>.md` + `status/<project>-status.md`
- Rename/delete agent: update INDEX.md index

## Tasks Sync
- After adding/removing shared trigger: update `tasks/overview.md` tables

## Shared Storage Sync
- Sync to `~/storage/shared/AI-KB` via:
  - `bash ~/AI-KB/sync-watcher.sh status` — check daemon
  - `bash ~/AI-KB/sync-to-shared.sh` — manual sync

## Cleanup
- Remove stale index entries if agent file missing
- Remove stale `status/` files with no matching agent
- Update `last_updated` dates on modified files

(End of file - total 40 lines)