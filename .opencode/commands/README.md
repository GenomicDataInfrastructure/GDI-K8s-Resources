# Opencode Slash Commands for GDI-K8s-Resources

This directory contains custom slash commands that can be used with opencode in this Helm chart project.

## Available Commands

### `/commit-and-push`

**Description**: Commits the last piece of work and pushes to the upstream of the current branch. Features auto-generated commit messages when none is provided.

---

### `/release-chart`

**Description**: Releases a new version of a Helm chart with semantic version bumping, branch validation, and automatic commit/push.

**Usage**:
```
/release-chart [chart_name] [version_type]
```

**Parameters**:
- `chart_name` (optional): Name of the chart to release (default: fdp)
- `version_type` (optional): Type of version bump (patch, minor, major). If omitted, will prompt for selection.

**Features**:
- **Branch Safety**: Validates current branch and warns if not on main
- **Semantic Versioning**: Supports patch, minor, and major version bumps
- **Interactive Prompts**: Asks for confirmation before making changes
- **Automatic Updates**: Updates Chart.yaml version and creates proper commit
- **Tag Creation**: Automatically creates git tags for releases on main branch
- **Comprehensive Feedback**: Provides detailed output at each step

**Semantic Versioning Rules**:
- **patch**: Backward-compatible bug fixes (0.1.8 → 0.1.9)
- **minor**: Backward-compatible new features (0.1.8 → 0.2.0)
- **major**: Breaking changes (0.1.8 → 1.0.0)

**Examples**:
```
/release-chart fdp major
/release-chart  # Prompts for chart and version type
/release-chart fdp patch
/release-chart my-chart minor
```

**Workflow**:
1. Checks current git branch (warns if not on main)
2. Validates chart exists in charts/ directory
3. Reads current version from Chart.yaml
4. Prompts for version bump type if not provided
5. Shows new version and asks for confirmation
6. Updates Chart.yaml with new version
7. Commits changes with release message
8. Creates git tag (if on main branch)
9. Pushes changes and tags to upstream
10. Provides next steps and release instructions

**Safety Features**:
- Requires explicit confirmation before making changes
- Validates all inputs before proceeding
- Provides clear feedback at each step
- Handles errors gracefully with helpful messages

---

### `/commit-and-push`

**Description**: Commits the last piece of work and pushes to the upstream of the current branch. Features auto-generated commit messages when none is provided.

**Usage**:
```
/commit-and-push [commit_message]
```

**Parameters**:
- `commit_message` (optional): Custom commit message. If omitted, the command will auto-generate one based on the changes.

**Features**:
- **Auto-generation**: When no message is provided, intelligently generates commit messages based on:
  - File types changed (YAML, MD, etc.)
  - Change patterns (configuration, documentation, features, fixes)
  - Git statistics (insertions, deletions, files changed)
  - Follows gitmoji conventions automatically

- **Smart categorization**: Detects change types and selects appropriate gitmoji:
  - `🔧` (:wrench:) for configuration changes
  - `✨` (:sparkles:) for new features
  - `🐛` (:bug:) for bug fixes
  - `📝` (:memo:) for documentation updates
  - `♻️` (:recycle:) for refactoring
  - `⬆️` (:arrow_up:) for dependency updates

- **Detailed feedback**: Provides step-by-step progress and success/failure notifications

**Examples**:
```
/commit-and-push :bug: Fix namespace reference in HTTPRoute template
/commit-and-push  # Auto-generates message
/commit-and-push :sparkles: Add new gateway configuration options
/commit-and-push :memo: Update documentation for MongoDB setup
```

**Auto-generated Message Example**:
```
🔧 Auto-commit: configuration updates

- Updated 3 file(s) with 42 insertions, 15 deletions
- Configuration: 2 file(s)
- Documentation: 1 file(s)
```

## Implementation Details

The slash commands are implemented as Markdown files with embedded YAML frontmatter in the `.opencode/commands/` directory. Each command file:

- Uses YAML frontmatter for command metadata (name, description, parameters)
- Contains detailed documentation in Markdown format
- Includes the implementation logic in code blocks
- Follows the project's git workflow guidelines
- Provides comprehensive examples and usage information

## Command File Structure

```markdown
---
name: command-name
description: Command description
usage: /command-name [parameters]
parameters:
  - name: param1
    type: string
    required: false
    description: Parameter description
examples:
  - "/command-name example"
---

# Command Name Documentation

## Command Logic

Detailed explanation of what the command does.

## Implementation

```bash
# Implementation code here
```
```

## Adding New Commands

To add a new slash command:
1. Create a new Markdown file in `.opencode/commands/`
2. Use the YAML frontmatter format for command metadata
3. Document the command thoroughly
4. Include implementation logic in code blocks
5. Add examples and usage information
6. Update this README with the new command

## Usage with Opencode

When using opencode, invoke commands directly:
```
User: /commit-and-push "Add FDP_HEALTH_SOLR and FDP_INFO_ENABLED config options"

Assistant: [Executes command and provides detailed output]
```

The opencode agent will:
1. Parse the command from the Markdown file
2. Execute the implementation logic
3. Provide real-time feedback
4. Handle errors appropriately
5. Follow the project's workflow guidelines

## Git Workflow Integration

All commands follow the project's git workflow as defined in AGENTS.md:
- Use gitmoji conventions for commit messages
- Follow semantic commit message structure
- Provide detailed change information
- Handle branch and upstream configuration properly
- Include proper error handling and user feedback