#!/bin/bash
# PM Stop Validator Hook
# Checks if all PM tasks are complete before allowing session to end.
# Exit code 2 forces Claude to continue working.
# Install: Add to hooks.Stop in .claude/settings.json
#
# This prevents premature session termination when PM work is in progress.

PM_DIR=".pm"

if [ ! -d "$PM_DIR" ]; then
  exit 0  # No active project, OK to stop
fi

if [ ! -f "$PM_DIR/dag.yaml" ]; then
  exit 0  # No task DAG, OK to stop
fi

# Check project status
PROJECT_STATUS=$(grep "status:" "$PM_DIR/project.yaml" 2>/dev/null | head -1 | sed 's/.*status: *//' | tr -d '"')

# If project is delivered, OK to stop
if [ "$PROJECT_STATUS" = "delivered" ]; then
  exit 0
fi

# Count incomplete tasks
IN_PROGRESS=$(grep -c 'status: "in_progress"' "$PM_DIR/dag.yaml" 2>/dev/null || echo 0)

# If tasks are actively in progress, warn but don't force
# (the user might be intentionally pausing)
if [ "$IN_PROGRESS" -gt 0 ]; then
  echo "[PM Warning] $IN_PROGRESS tasks are still in progress. Use /vesper-pm-status to check state. The project can be resumed later with /vesper-pm-resume."
  exit 0  # Allow stop but with warning
fi

exit 0
