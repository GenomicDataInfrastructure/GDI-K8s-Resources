--- 
name: commit-and-push
description: Commits the last piece of work and pushes to the upstream of the current branch
usage: /commit-and-push [commit_message]
parameters:
  - name: commit_message
    type: string 
    required: false
    description: Optional commit message. If not provided, will be auto-generated based on changes.
examples:
  - "/commit-and-push :bug: Fix namespace reference in HTTPRoute template"
  - "/commit-and-push"
  - "/commit-and-push :sparkles: Add new configuration options"
---

# Commit and Push Slash Command Implementation

## Command Logic

This command performs the following steps:

### 1. Check Git Repository Status
- Verify we're in a git repository
- Get current branch information
- Check for upstream configuration

### 2. Analyze Changes
- Detect modified, added, and deleted files
- Calculate statistics (insertions, deletions)
- Determine change categories (features, fixes, docs, etc.)

### 3. Generate Commit Message (if not provided)
- Auto-generate message based on change analysis
- Follow gitmoji conventions
- Include relevant file changes
- Create meaningful commit summary

### 4. Execute Git Operations
- Stage all changes
- Create commit
- Push to upstream
- Provide detailed feedback

## Auto-Generation Algorithm

When no commit message is provided, the command generates one using:

1. **Change Analysis**:
   - Count file types changed (YAML, MD, etc.)
   - Detect patterns (config changes, documentation, bug fixes)
   - Calculate impact (lines changed)

2. **Gitmoji Selection**:
   - `:wrench:` for configuration changes
   - `:sparkles:` for new features
   - `:bug:` for bug fixes
   - `:memo:` for documentation
   - `:recycle:` for refactoring
   - `:arrow_up:` for dependency updates

3. **Message Structure**:
   ```
   :gitmoji: Auto-commit: [summary of changes]
   
   - [File 1]: [change description]
   - [File 2]: [change description]
   - [Statistics: +X -Y files]
   ```

## Implementation

The implementation follows the logic described above. The command is designed to be safe and provide clear feedback at each step of the process.
