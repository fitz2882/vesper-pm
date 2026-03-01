#!/bin/bash
# PM Session Start Hook
# Loads project state and Vesper context when a Claude Code session begins.
# Install: Add to hooks.SessionStart in .claude/settings.json
#
# This hook checks if a .pm/ directory exists and injects project context
# into the session so the PM agent has immediate awareness of project state.

PM_DIR=".pm"

if [ ! -d "$PM_DIR" ]; then
  exit 0  # No active project, nothing to load
fi

# Read project metadata
if [ -f "$PM_DIR/project.yaml" ]; then
  PROJECT_NAME=$(grep "name:" "$PM_DIR/project.yaml" | head -1 | sed 's/.*name: *//' | tr -d '"')
  PROJECT_STATUS=$(grep "status:" "$PM_DIR/project.yaml" | head -1 | sed 's/.*status: *//' | tr -d '"')
  PROJECT_NAMESPACE=$(grep "namespace:" "$PM_DIR/project.yaml" | head -1 | sed 's/.*namespace: *//' | tr -d '"')
fi

# Count task statuses from dag.yaml
if [ -f "$PM_DIR/dag.yaml" ]; then
  TOTAL=$(grep -c "status:" "$PM_DIR/dag.yaml" 2>/dev/null || echo 0)
  COMPLETED=$(grep -c 'status: "completed"' "$PM_DIR/dag.yaml" 2>/dev/null || echo 0)
  BLOCKED=$(grep -c 'status: "blocked"' "$PM_DIR/dag.yaml" 2>/dev/null || echo 0)
  FAILED=$(grep -c 'status: "failed"' "$PM_DIR/dag.yaml" 2>/dev/null || echo 0)
fi

# Count escalations
ESCALATION_COUNT=0
if [ -d "$PM_DIR/escalations" ]; then
  ESCALATION_COUNT=$(ls -1 "$PM_DIR/escalations"/*.yaml 2>/dev/null | wc -l | tr -d ' ')
fi

# Output context for Claude
cat << EOF
[PM Context Loaded]
Project: ${PROJECT_NAME:-unknown}
Namespace: ${PROJECT_NAMESPACE:-unknown}
Phase: ${PROJECT_STATUS:-unknown}
Tasks: ${COMPLETED:-0}/${TOTAL:-0} completed, ${BLOCKED:-0} blocked, ${FAILED:-0} failed
Escalations: ${ESCALATION_COUNT}

To continue this project, use /vesper-pm-resume.
To check status, use /vesper-pm-status.
To start a new project, use /vesper-pm-plan.

Remember: Read .claude/skills/pm/SKILL.md for the full PM operating manual.
EOF
