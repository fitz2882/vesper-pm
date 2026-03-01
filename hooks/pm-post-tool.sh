#!/bin/bash
# PM Post-Tool Hook
# After file modifications (Write, Edit), check if the modified file
# belongs to a PM task and update task tracking accordingly.
# Install: Add to hooks.PostToolUse (matcher: Write, Edit) in .claude/settings.json

PM_DIR=".pm"

if [ ! -d "$PM_DIR" ]; then
  exit 0
fi

# Append to changelog with timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

if [ -f "$PM_DIR/changelog.md" ]; then
  echo "- [$TIMESTAMP] File modified by agent" >> "$PM_DIR/changelog.md"
fi

exit 0
