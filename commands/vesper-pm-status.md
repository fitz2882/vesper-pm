# /vesper-pm-status — Check Project Status

Display current project status, progress, and any items needing attention.

## Usage
```
/vesper-pm-status              (summary)
/vesper-pm-status detailed     (full breakdown)
/vesper-pm-status blockers     (only blocked/escalated items)
```

## Instructions

1. Read `.pm/project.yaml` for project metadata and current phase
2. Read `.pm/dag.yaml` for task statuses
3. Query Vesper for recent activity:
   ```
   retrieve_memory:
     namespace: "{project-namespace}"
     query: "recent activity, blocked tasks, decisions, escalations"
     max_results: 10
   ```
4. Compile and present:

### Summary View (default)
```
Project: {name}
Phase: {current phase} ({phase description})
Progress: {completed}/{total} tasks ({percent}%)
Status: {on track / blocked / needs attention}
{If blocked: list blockers}
{If escalated: list escalations needing user input}
```

### Detailed View
- All tasks grouped by status (completed, in_progress, blocked, pending)
- Recent decisions made
- Agent performance summary
- Estimated remaining effort

### Blockers View
- Only blocked and escalated items
- For each: what's blocking, what's been tried, what options exist

## Mode
$ARGUMENTS
