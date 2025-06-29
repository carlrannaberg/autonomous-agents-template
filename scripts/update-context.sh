#!/bin/bash

# Function to update a context file
update_context_file() {
  local context_file=$1
  local project_name=$(jq -r .name ../package.json)
  local project_description=$(jq -r .description ../package.json)
  local keywords=$(jq -r '.keywords | join(", ")' ../package.json)
  local repo_url=$(jq -r .repository.url ../package.json)

  # Update Project Context
  sed -i '' "s|<!-- Describe your project architecture, purpose, and key components -->|- Project: $project_name\n- Description: $project_description\n- Repository: $repo_url|" "../$context_file"

  # Update Technology Stack
  sed -i '' "s|<!-- List the main technologies, frameworks, and tools used -->|- Bash\n- jq\n- Node.js (for running scripts)|" "../$context_file"

  # Update Key Dependencies
  sed -i '' "s|<!-- List important libraries and their purposes -->|- Claude CLI or Gemini CLI: For interacting with the AI models.\n- jq: For parsing JSON in shell scripts.|" "../$context_file"
}

# Change to the script's directory
cd "$(dirname "$0")"

# Update both context files
update_context_file "CLAUDE.md"
update_context_file "GEMINI.md"

echo "CLAUDE.md and GEMINI.md have been updated."