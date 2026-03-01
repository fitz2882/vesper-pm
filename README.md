# Autonomous PM Skill for Claude Code

An AI Project Manager that takes a project brief and autonomously manages the entire lifecycle — from clarification through design, specification, implementation, verification, and delivery — using hierarchical subagents with minimal user input.

## Features

- **8-phase project lifecycle**: Discovery → Architecture → Design → Specs → Siloing → Execution → Integration → Delivery
- **Aletheia GVR verification** at plan, task, and integration levels (Generate → Verify → Revise)
- **Figma MCP integration** for design-driven development — designs are created/referenced, approved, and code scaffolds extracted before implementation
- **Vesper Memory integration** for persistent decisions, cross-project learning, and context-efficient agent handoffs
- **DAG-based task management** with topological sorting for maximum parallelism
- **Task siloing** with interface contracts ensures parallel agents never conflict
- **Spec-first development** — every task gets a specification and test stubs before implementation
- **Three-layer error handling** — agent retry → PM retry → user escalation
- **Strategic context compaction** at phase boundaries for long-running projects

## Installation

### 1. Copy skill files into your project

```bash
# From your project root:
mkdir -p .claude/skills/vesper-pm .claude/commands .claude/hooks

# Copy the skill
cp vesper-pm/skills/vesper-pm/SKILL.md .claude/skills/vesper-pm/

# Copy commands
cp vesper-pm/commands/vesper-pm-plan.md .claude/commands/
cp vesper-pm/commands/vesper-pm-status.md .claude/commands/
cp vesper-pm/commands/vesper-pm-resume.md .claude/commands/

# Copy hooks
cp vesper-pm/hooks/*.sh .claude/hooks/
chmod +x .claude/hooks/*.sh

# Copy templates (used by the PM to initialize project structure)
mkdir -p .claude/skills/vesper-pm/templates
cp vesper-pm/templates/* .claude/skills/vesper-pm/templates/
```

### 2. Configure hooks

Merge the hook configuration from `settings-example.json` into your `.claude/settings.json`.

### 3. Optional: Vesper Memory

If you have [Vesper Memory](https://github.com/fitz2882/vesper-memory) installed as an MCP server, the PM will use it for:
- Persistent decision tracking with rationale
- Cross-project learning (estimation accuracy, agent effectiveness)
- Context-efficient agent handoffs via `share_context`
- Conflict detection between agent decisions

The PM works without Vesper but with degraded memory — decisions are only tracked in `.pm/` files and don't persist across projects.

### 4. Optional: Figma MCP

If you have the [Figma MCP](https://www.figma.com/developers) connected, the PM will use it in Phase 2 to:
- Inspect existing Figma designs
- Extract design specifications and reference code
- Download assets and design tokens
- Map Figma components to code components

Without Figma MCP, the PM generates design specifications as code artifacts or written specs instead.

## Usage

### Start a new project
```
/vesper-pm-plan "Build a real-time dashboard for monitoring server health with alerts"
```

### Check project status
```
/vesper-pm-status              # Summary
/vesper-pm-status detailed     # Full breakdown
/vesper-pm-status blockers     # Only blocked items
```

### Resume an interrupted project
```
/vesper-pm-resume                    # From last checkpoint
/vesper-pm-resume --phase 3          # Restart from specific phase
/vesper-pm-resume --task task-007    # Retry specific task
```

## How It Works

### Phase 0: Discovery & Clarification
The PM analyzes your brief, identifies gaps, and asks 5-10 targeted clarifying questions. It restates the requirements for your confirmation before proceeding.

### Phase 1: Architecture & Planning
Classifies the project, selects a role template, and decomposes into a task DAG. The plan is GVR-verified: every requirement traces to a task, no circular dependencies, effort estimates are reasonable.

### Phase 2: Design & Approval
For UI projects: creates or references Figma designs, checks for architecture impacts, and presents designs for your approval. Extracts code scaffolds from approved designs. **This is the last phase requiring your input until delivery.**

### Phase 3: Specification & Test Design
Writes detailed specs for every task with acceptance criteria, interface contracts, and test stubs. Specs are GVR-verified as a set for consistency.

### Phase 4: Task Siloing & Dispatch
Analyzes the DAG for parallelization. Verifies that parallel tasks have no file conflicts or hidden coupling. Prepares dispatch packages for each subagent.

### Phase 5: Execution & Monitoring
Spawns subagents to execute tasks in topological order. Uses dual-loop monitoring (project-level + task-level). Reports progress at each group completion. Handles errors with three-layer escalation.

### Phase 6: Integration & Verification
Merges all outputs. Runs full GVR verification: requirements traceability, design conformance, test suite, decision consistency via Vesper.

### Phase 7: Delivery & Retrospective
Presents the completed project. Captures lessons learned in Vesper for future projects: estimation accuracy, agent effectiveness, user preferences.

## Project Structure

When the PM is running, it creates a `.pm/` directory:

```
.pm/
├── project.yaml              # Metadata, status, phase
├── requirements.md           # Confirmed requirements
├── dag.yaml                  # Task DAG with dependencies
├── agents.yaml               # Agent registry
├── changelog.md              # Append-only action log
├── contracts/                # Shared interface definitions
├── specs/                    # Per-task specifications
├── design-scaffolds/         # Figma-extracted code
├── silos/                    # Parallel group analyses
├── results/                  # Per-task outcomes
└── escalations/              # Failed tasks for human review
```

## When the PM Asks for Your Input

The PM is designed for **minimal user interaction** after initial setup:

| Situation | Why |
|-----------|-----|
| Phase 0: Clarifying questions | Can't proceed without understanding requirements |
| Phase 2: Design approval | Visual design is subjective — needs human judgment |
| Escalated failures | All automated retry strategies exhausted |
| Phase 7: Delivery acceptance | User decides if the project is done |

Everything else — model selection, agent assignment, retry strategies, file organization, technical decisions within the plan — the PM handles autonomously.
