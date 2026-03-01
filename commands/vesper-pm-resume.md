# /vesper-pm-resume — Resume an Interrupted Project

Resume a project from where it was interrupted (session timeout, context exhaustion, manual pause).

## Usage
```
/vesper-pm-resume                    (resume from last checkpoint)
/vesper-pm-resume --phase 3          (restart from specific phase)
/vesper-pm-resume --task task-007    (resume specific failed/blocked task)
```

## Instructions

1. Read the PM skill: `.claude/skills/vesper-pm/SKILL.md`
2. Load project state:
   - `.pm/project.yaml` → current phase, namespace
   - `.pm/dag.yaml` → task statuses
   - `.pm/changelog.md` → recent actions (last 20 entries)
3. Query Vesper for session context:
   ```
   retrieve_memory:
     namespace: "{project-namespace}"
     query: "last session activity, in-progress work, pending decisions"
     max_results: 10
   ```
4. Determine resume point:
   - If `--phase N`: restart from that phase (re-read all prior outputs)
   - If `--task {id}`: retry that specific task
   - Otherwise: find the earliest incomplete phase and resume there
5. Report to user:
   "Resuming '{name}'. Last activity: {summary}. Current phase: {phase}. {N} tasks remaining. Continuing from {resume point}."
6. Continue execution from resume point

## Arguments
$ARGUMENTS
