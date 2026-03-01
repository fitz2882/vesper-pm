# /vesper-pm-plan — Start a New Project

Start a new project from a brief. This command activates the PM skill and begins Phase 0 (Discovery & Clarification).

## Usage
```
/vesper-pm-plan "Build an e-commerce platform with product catalog and checkout"
/vesper-pm-plan   (interactive — PM will ask for the brief)
```

## Instructions

1. Read the PM skill: `.claude/skills/vesper-pm/SKILL.md`
2. If `$ARGUMENTS` is provided, use it as the project brief
3. If no arguments, ask the user for a project brief
4. Initialize the `.pm/` directory using the template at `.claude/skills/vesper-pm/templates/project.yaml`
5. Begin Phase 0: Discovery & Clarification
6. Proceed through all phases autonomously, pausing only at Phase 0 (clarification) and Phase 2 (design approval)

## Pre-flight Checks

Before starting:
- Check if `.pm/` already exists. If so, warn: "An active project exists. Use `/vesper-pm-resume` to continue it, or confirm you want to start fresh."
- Check if Vesper MCP is available. If not, warn but proceed (memory features will be degraded).
- Check if Figma MCP is available. Note availability for Phase 2.

## Project Brief
$ARGUMENTS
