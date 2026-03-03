--- 
name: release-chart
description: Releases a new version of a Helm chart with semantic version bump
usage: /release-chart [chart_name] [version_type]
parameters:
  - name: chart_name
    type: string 
    required: false
    description: Name of the chart to release (default: fdp)
  - name: version_type
    type: string
    required: false
    description: Type of version bump (patch, minor, major). If not provided, will prompt user.
examples:
  - "/release-chart fdp major"
  - "/release-chart"
  - "/release-chart fdp patch"
---

# Helm Chart Release Slash Command

## Command Logic

This command handles the complete Helm chart release workflow:

### 1. Branch Validation
- Checks current git branch
- Confirms release intent if not on main branch
- Prevents accidental releases from feature branches

### 2. Chart Selection
- Defaults to 'fdp' chart if none specified
- Validates chart exists in charts/ directory
- Reads current version from Chart.yaml

### 3. Version Bump Selection
- Prompts for version type if not provided
- Supports semantic versioning (patch, minor, major)
- Validates input and confirms before proceeding

### 4. Version Update
- Parses current version from Chart.yaml
- Calculates new version based on selected bump type
- Updates Chart.yaml with new version
- Updates appVersion if needed

### 5. Commit and Push
- Creates commit with release information
- Pushes changes to remote
- Tags the release if on main branch

## Semantic Versioning Rules

- **patch**: Backward-compatible bug fixes (0.1.8 → 0.1.9)
- **minor**: Backward-compatible new features (0.1.8 → 0.2.0)
- **major**: Breaking changes (0.1.8 → 1.0.0)

## Implementation

The implementation follows the logic described above. The command is designed to be safe and provide clear feedback at each step of the process.
#!/bin/bash
