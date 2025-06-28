# Autonomous Agents Template

A template repository for creating autonomous AI agents using Claude. This template provides scripts and structure for task-based autonomous agent workflows.

## Features

- 🤖 Autonomous task execution with Claude
- 📋 Issue and plan management system with todo tracking
- 🎨 Beautiful formatted output with progress tracking
- 🔄 Single task or continuous execution modes
- 📝 Structured issue and plan templates

## Prerequisites

- [Claude CLI](https://claude.ai/code) installed and configured
- Bash shell (macOS/Linux)
- `jq` for JSON parsing (install with `brew install jq` or `apt-get install jq`)

## Available Commands

This template provides npm scripts for all operations:

```bash
npm run agent         # Run the agent for one task
npm run agent:auto    # Run the agent continuously for all tasks
npm run issue         # Create a new issue
npm run bootstrap     # Create a bootstrap issue from master plan
npm run complete      # Manually mark an issue as complete
npm run test          # Run all tests
npm run test:unit     # Run unit tests only
```

## Quick Start

1. **Clone this template**
   ```bash
   git clone <your-repo-url>
   cd autonomous-agents-template
   ```

2. **Create your first issue**
   ```bash
   npm run issue "Build a REST API for user management"
   ```

3. **Run the agent**
   ```bash
   # Run a single task
   npm run agent

   # Run all tasks continuously
   npm run agent:auto
   ```

## Bootstrapping from a Master Plan

When you have a comprehensive plan or specification document, you can bootstrap your entire project structure:

### 1. **Create Master Plan**
First, create a detailed plan document:
```bash
echo "Your comprehensive project plan..." > master-plan.md
```

### 2. **Create Bootstrap Issue**

#### Using the Bootstrap Command (Recommended)
```bash
# Create bootstrap issue with default master-plan.md
npm run bootstrap

# Or specify a custom plan file
npm run bootstrap -- --plan my-project-spec.md

# Open in editor after creation
npm run bootstrap -- --editor
```

#### Manual Method
```bash
npm run issue "Bootstrap Project from Master Plan"
# Then manually edit the issue to add bootstrap instructions
```

The `create-bootstrap.sh` command automatically creates a properly formatted bootstrap issue that instructs Claude to:
- Read and analyze your master plan document
- Decompose it into individual, actionable issues
- Create implementation plans for each issue
- Update todo.md with all new tasks in proper sequence

### 3. **Run the Agent**
```bash
npm run agent
```

Claude will read your master plan and automatically:
- Break it down into logical issues
- Create detailed implementation plans
- Set up the entire project structure
- Prepare everything for autonomous execution

### 4. **Execute the Generated Issues**
Once bootstrapping is complete:
```bash
# Review the generated issues and plans
ls issues/
ls plans/

# Run all issues autonomously
npm run agent:auto
```

This bootstrapping approach is perfect for:
- Large projects with detailed specifications
- Converting existing documentation into actionable tasks
- Migrating from other project management systems
- Setting up complex multi-phase implementations

## Project Structure

```
autonomous-agents-template/
├── scripts/
│   ├── run-agent.sh      # Main agent runner
│   ├── create-issue.sh   # Create new issues with plans
│   ├── create-bootstrap.sh # Create bootstrap issue from master plan
│   └── complete-issue.sh # Manually mark issues as complete
├── issues/               # Issue definitions (created automatically)
├── plans/                # Implementation plans (created automatically)
├── docs/                 # Documentation
├── examples/             # Example issues and workflows
├── todo.md              # Issue tracking file
├── CLAUDE.md            # Claude-specific project instructions
└── README.md            # This file
```

## Scripts

All scripts can be run via npm commands. Use `npm run <command>` instead of calling shell scripts directly.

### `run-agent.sh` (via `npm run agent`)
The main script that runs Claude on your tasks.

**Usage:**
```bash
npm run agent        # Run the next pending issue only
npm run agent:auto   # Run all pending issues continuously
```

**Options:**
- `agent:auto`: Run all pending issues continuously
- `agent`: Run the next pending issue only

### `create-issue.sh` (via `npm run issue`)
Creates a new issue file with corresponding plan and adds it to todo.md.

**Usage:**
```bash
npm run issue [-- --editor] "Issue title"
```

**Options:**
- `--editor`: Open the created issue in your $EDITOR

**Example:**
```bash
npm run issue -- --editor "Implement authentication system"
```

### `create-bootstrap.sh` (via `npm run bootstrap`)
Create a bootstrap issue that decomposes a master plan into individual tasks.

**Usage:**
```bash
npm run bootstrap [-- [--plan <plan-file>] [--editor]]
```

**Options:**
- `--plan <file>`: Path to the plan markdown file (default: master-plan.md)
- `--editor`: Open the created bootstrap issue in your $EDITOR
- `-h, --help`: Show help message

**Examples:**
```bash
# Use default master-plan.md
npm run bootstrap

# Use custom plan file
npm run bootstrap -- --plan docs/project-spec.md

# Open in editor after creation
npm run bootstrap -- --editor
```

### `complete-issue.sh` (via `npm run complete`)
Manually mark an issue as complete (useful if an issue was completed outside the agent).

**Usage:**
```bash
npm run complete <issue_number>
```

**Example:**
```bash
npm run complete 3
```

## Issue and Plan Format

### Issues
Issues are markdown files in the `issues/` directory:

```markdown
# Issue N: Title

## Requirement
[Main requirement or problem to solve]

## Acceptance Criteria
- [ ] Specific criterion 1
- [ ] Specific criterion 2

## Technical Details
[Technical constraints or notes]

## Resources
[Documentation or references]
```

### Plans
Each issue has a corresponding plan in the `plans/` directory:

```markdown
# Plan for Issue N: Title

## Implementation Plan
### Phase 1: Setup
- [ ] Initial tasks

### Phase 2: Core Implementation
- [ ] Main implementation tasks

### Phase 3: Testing & Validation
- [ ] Testing tasks

## Technical Approach
[Architecture decisions]

## Potential Challenges
[Anticipated issues]
```

## Customization

### Claude Instructions
Create a `CLAUDE.md` file in the root directory to provide project-specific instructions:

```markdown
# Project Context
- Architecture: [Your architecture]
- Tech stack: [Your technologies]
- Conventions: [Your coding standards]

# Special Instructions
[Any specific guidelines for the agent]
```

### Environment Variables
- `AUTO_COMMIT`: Set to "true" to auto-commit after each issue completion (requires git)
- `EDITOR`: Your preferred text editor for the --editor flag

## Examples

### Example 1: Web Development Project
```bash
# Create issues for a web app
./scripts/create-issue.sh "Set up Express.js server with TypeScript"
./scripts/create-issue.sh "Create user authentication endpoints"
./scripts/create-issue.sh "Add PostgreSQL database integration"

# Run all issues
./scripts/run-agent.sh --auto
```

### Example 2: Data Processing Pipeline
```bash
# Create data pipeline issues
./scripts/create-issue.sh "Parse CSV files from input directory"
./scripts/create-issue.sh "Transform data according to schema"
./scripts/create-issue.sh "Export results to JSON format"

# Run issues one by one with review
./scripts/run-agent.sh
# Review results...
./scripts/run-agent.sh
# Review results...
./scripts/run-agent.sh
```

## Best Practices

1. **Clear Issue Definitions**: Be specific about requirements and acceptance criteria
2. **Detailed Plans**: Create comprehensive implementation plans
3. **Incremental Issues**: Break large projects into smaller, testable issues
3. **Context Matters**: Include relevant project context in CLAUDE.md
4. **Review Output**: In non-auto mode, review agent output before proceeding
5. **Version Control**: Commit your issues, plans, and todo.md for tracking

## Troubleshooting

**"claude: command not found"**
- Install Claude CLI from https://claude.ai/code

**"jq: command not found"**
- macOS: `brew install jq`
- Ubuntu/Debian: `sudo apt-get install jq`
- Other: See https://stedolan.github.io/jq/download/

**Issue not being marked complete**
- Check that the agent successfully completed the issue
- Use `./scripts/complete-issue.sh N` to manually mark complete

## Contributing

This is a template repository. Fork it and customize for your needs!

## License

MIT License - See LICENSE file for details