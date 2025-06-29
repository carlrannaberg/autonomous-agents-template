#!/bin/bash

# This script creates a new issue to update the context files (CLAUDE.md and GEMINI.md)

# The issue title
ISSUE_TITLE="Update CLAUDE.md and GEMINI.md context files"

# The issue content
ISSUE_CONTENT="# Issue: Update Context Files\n\n## Requirement\nUpdate the \`CLAUDE.md\` and \`GEMINI.md\` files with the latest project information.\n\n## Acceptance Criteria\n- [ ] Analyze the current project structure, dependencies, and scripts.\n- [ ] Read the \`package.json\` file to understand the project\'s metadata.\n- [ ] Read the \`README.md\` file for a high-level overview.\n- [ ] Populate the \`Project Context\`, \`Technology Stack\`, and \`Key Dependencies\` sections in both \`CLAUDE.md\` and \`GEMINI.md\`.
"

# Create the issue
./scripts/create-issue.sh "$ISSUE_TITLE" "$ISSUE_CONTENT"

