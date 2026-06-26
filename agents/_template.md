---
type: agent-prompt
id: <agent-id>
project: <project-name>
last_updated: YYYY-MM-DD
personality: <personality>
stack:
  - <tech>
commands:
  dev: <command>
  build: <command>
  test: <command>
  lint: <command>
triggers:
  "update .md": <description>
  "cleanup": <description>
---

# {Agent Name}

## Overview

{1-2 sentence description}

## Stack

| Layer | Tech |

## Architecture

{Diagram or flow. Leave empty if none.}

## Key Patterns

{Bullet list of important implementation patterns. Leave empty if none.}

## Commands

| Command | What it does |

## Triggers

### "update .md"

{Step list}

### "cleanup"

{Step list}

## Rules

{Project-specific rules. Leave empty if none.}
