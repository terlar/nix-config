---
name: jira-cli-operations
description: Use when working with JIRA from the terminal. Use when asked to look up, create, update, transition, assign, or comment on JIRA issues. Use for sprint or epic operations.
---

# JIRA CLI Operations

## Overview

`jira` CLI (ankitpokhrel/jira-cli) wraps JIRA REST API. Config at `~/.config/.jira/.config.yml`. Default project from config, override with `-p PROJECT`.

## Quick Reference

| Task | Command |
|------|---------|
| List issues | `jira issue list [--status "In Progress"] [-a email] [-t Bug] [-l label] [--created month]` |
| View issue | `jira issue view ISSUE-123 [--comments 3] [--raw] [--plain]` |
| Create issue | `jira issue create -t Task -s "Summary" [-b "Description"] [-a email] [-y High] [-l bug] [--no-input]` |
| Edit issue | `jira issue edit ISSUE-123 -s "New summary" [--no-input]` |
| Transition | `jira issue move ISSUE-123 "In Progress" [--comment "starting work"]` |
| Assign | `jira issue assign ISSUE-123 user@example.com` |
| Assign to self | `jira issue assign ISSUE-123 $(jira me)` |
| Unassign | `jira issue assign ISSUE-123 x` |
| Comment | `jira issue comment add ISSUE-123 "Message here"` |
| Log work | `jira issue worklog add ISSUE-123 "2h 30m" [--comment "desc"] [--no-input]` |
| Link issues | `jira issue link ISSUE-123 ISSUE-456 "Blocks"` |
| Delete issue | `jira issue delete ISSUE-123 [--cascade]` |
| Open in browser | `jira open ISSUE-123` |
| List sprints | `jira sprint list [--table] [--state active,closed] [--plain]` |
| Current sprint issues | `jira sprint list --current [--plain --columns key,summary,status]` |
| Add to sprint | `jira sprint add SPRINT-ID ISSUE-123` |
| List epics | `jira epic list` |
| Add to epic | `jira epic add EPIC-123 ISSUE-456` |

## Common Patterns

### Scripting / Automation

Use `--no-input` to skip prompts, `--raw` for JSON output:

```bash
jira issue create -t Bug -s "Fix login crash" -y Critical --no-input
jira issue list --raw | jaq '.[].key'
```

### Piping Body from stdin

```bash
echo "Detailed description here" | jira issue create -t Task -s "Summary"
```

### Body from template file

```bash
jira issue create -t Story -s "Feature" --template /path/to/template.md
```

### Remove labels/components/fixVersions

Prefix with minus:

```bash
jira issue edit ISSUE-123 --label -deprecated --component -BE
```

### Plain table output (non-interactive)

```bash
jira issue list --plain --columns key,summary,status,assignee
jira issue list --plain --no-headers --delimiter "|"
```

### Custom fields

```bash
jira issue create -t Story -s "Task" --custom story-points=5
```

### Raw JQL

```bash
jira issue list -q "project = PROJ AND status != Closed ORDER BY priority DESC"
```

### Filter shortcuts

```bash
jira issue list --created month -s "In Progress" -a $(jira me)
```

### Scripting: create + capture key

```bash
KEY=$(jira issue create -t Task -s "Summary" --no-input --raw | jaq -r '.key')
jira issue move "$KEY" "In Progress"
```

## Common Workflows

### Daily triage: list → move → comment

```bash
# Find your open work
jira issue list -a $(jira me) -s "In Progress" --plain --columns key,summary,status

# Move forward
jira issue move ISSUE-123 "Code Review" --comment "Ready, please review"

# Log time
jira issue worklog add ISSUE-123 "1h 30m" --comment "Implemented fix" --no-input
```

### Bug report: create → assign → link to epic

```bash
KEY=$(jira issue create -t Bug -s "Login fails on empty input" -y High -l bug --no-input --raw | jaq -r '.key')
jira issue assign "$KEY" dev@company.com
jira epic add EPIC-42 "$KEY"
```

### Sprint review prep

```bash
jira sprint list --current --plain --columns key,summary,status,assignee
```

## Common Mistakes

- **Missing `--no-input` in scripts** — command hangs waiting for input. Always add for automation.
- **Using `-s` for status in `list`** — `-s` is summary in `create`/`edit`, status in `list`. Context-dependent flag.
- **Omitting issue key in `view`/`edit`/`move`** — positional arg, required.
- **Pipe forgetting `--no-input`** — stdin goes to body, but prompts still block. Add `--no-input`.
- **Unknown transition name** — `jira issue move ISSUE-123 "Done"` might fail if workflow uses "Closed". Check board workflow or use `jira issue view` to see available transitions.
- **Forgetting `--type` on create** — prompts interactively without `--no-input` and `--type`.
