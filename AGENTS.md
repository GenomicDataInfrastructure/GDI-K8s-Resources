# AGENTS.md - Guidelines for Agentic Coding in GDI-K8s-Resources

This document provides guidelines for AI agents and developers working on the GDI-K8s-Resources repository, which contains Kubernetes Helm charts for deploying FAIR Data Point (FDP) systems.

## Repository Overview

- **Primary Language**: YAML (Helm charts, Kubernetes manifests)
- **Purpose**: Kubernetes deployment resources for FDP systems
- **Main Components**: FDP Server, FDP Client, MongoDB, GraphDB, Gateway
- **Build System**: Helm chart packaging and release

## Build/Lint/Test Commands

### Helm Chart Operations

```bash
# Validate Helm chart templates
helm lint ./charts/fdp

# Dry run installation to validate templates
helm template fdp ./charts/fdp -f ./charts/fdp/values-dev.yaml

# Package the Helm chart
helm package ./charts/fdp

# Install chart in development environment
helm install fdp ./charts/fdp -f ./charts/fdp/values-dev.yaml --namespace fdp --create-namespace

# Upgrade existing installation
helm upgrade fdp ./charts/fdp -f ./charts/fdp/values-dev.yaml --namespace fdp

# Uninstall the release
helm uninstall fdp --namespace fdp
```

### Testing Individual Components

```bash
# Test template rendering for a specific component
test_template() {
  local component=$1
  helm template fdp ./charts/fdp -f ./charts/fdp/values-dev.yaml --show-only "templates/${component}/*"
}

# Example: Test only the FDP server deployment
test_template "fdp-server"

# Validate Kubernetes manifests before applying
kubectl apply --dry-run=server -f <(helm template fdp ./charts/fdp -f ./charts/fdp/values-dev.yaml)
```

### CI/CD Commands

```bash
# Run the GitHub Actions release workflow locally using act
act -j release

# Validate chart before release
ct lint --charts ./charts/fdp
```

## Code Style Guidelines

### YAML Formatting

1. **Indentation**: Use 2 spaces (standard for Kubernetes/Helm)
2. **Line Length**: Keep lines under 120 characters
3. **Quoting**: Use quotes for strings that contain special characters or start with special symbols
4. **Multi-line Strings**: Use `|` for multi-line strings, `>` for folded strings
5. **Comments**: Use `#` for comments, place them above the relevant line

### Naming Conventions

1. **Resource Names**: Use kebab-case (e.g., `fdp-server`, `graphdb-config`)
2. **Template Files**: Use kebab-case with component grouping (e.g., `templates/fdp-server/deployment.yaml`)
3. **Values Keys**: Use camelCase for nested values (e.g., `server.image.repository`)
4. **Labels**: Use standard Kubernetes label prefixes (e.g., `app.kubernetes.io/name`)
5. **Secrets**: Use meaningful names that indicate purpose (e.g., `fdp-jwt-secret`)

### Template Structure

1. **File Organization**: Group templates by component in subdirectories
2. **Template Names**: Use descriptive names that match the resource type
3. **Helpers**: Place helper templates in `_helpers.tpl` files
4. **Partial Templates**: Use `{{-` and `-}}` to trim whitespace in templates

### Values Organization

1. **Default Values**: Place in `values.yaml`
2. **Environment-specific Values**: Use separate files (`values-dev.yaml`, `values-staging.yaml`, `values-prod.yaml`)
3. **Group Related Values**: Use logical nesting (e.g., `server.env.*`, `mongodb.auth.*`)
4. **Documentation**: Include comments explaining each major section

### Error Handling

1. **Required Values**: Use `required` function for mandatory values
   ```yaml
   {{ required "A valid JWT secret is required" .Values.server.jwt.secretKey }}
   ```

2. **Default Values**: Provide sensible defaults where possible
   ```yaml
   {{ .Values.server.replicaCount | default 1 }}
   ```

3. **Validation**: Use Helm's validation features in Chart.yaml
4. **Fail Fast**: Include validation in templates to catch issues early

### Security Best Practices

1. **Secrets Management**: Never commit secrets to version control
2. **Sensitive Values**: Use `--set` or external secrets managers in production
3. **RBAC**: Follow principle of least privilege in role definitions
4. **Network Policies**: Use network policies to restrict pod communication
5. **Image Security**: Use specific image tags, not `latest`

### Documentation Standards

1. **README**: Maintain comprehensive README.md for each chart
2. **Values Documentation**: Document all configurable parameters in tables
3. **Examples**: Include installation examples for different environments
4. **Troubleshooting**: Document common issues and solutions
5. **Architecture**: Explain the overall architecture and component interactions

## Helm Chart Development Guidelines

### Adding New Components

1. Create template files in appropriate subdirectory
2. Add configuration options to `values.yaml`
3. Update documentation in README.md
4. Test thoroughly with `helm lint` and `helm template`
5. Validate in a test namespace before production

### Versioning

1. Follow semantic versioning for chart versions
2. Update `Chart.yaml` with each release
3. Document breaking changes in release notes
4. Maintain backward compatibility where possible

### Dependencies

1. Declare chart dependencies in `Chart.yaml`
2. Use version ranges carefully to avoid breaking changes
3. Document dependency requirements

## Working with Kubernetes Manifests

### Resource Definition Standards

1. **API Version**: Use stable API versions (avoid alpha/beta when possible)
2. **Kind**: Use appropriate resource types
3. **Metadata**: Include standard labels and annotations
4. **Spec**: Follow Kubernetes best practices for each resource type

### Labels and Annotations

1. **Standard Labels**: Use `app.kubernetes.io` labels
2. **Custom Labels**: Add only when necessary for selection/identification
3. **Annotations**: Use for non-identifying metadata

### Resource Management

1. **Requests/Limits**: Always specify resource requests and limits
2. **Probes**: Include liveness and readiness probes
3. **Lifecycle Hooks**: Use when appropriate for initialization/cleanup

## Testing and Validation

### Pre-commit Checks

```bash
# Run these before committing changes
helm lint ./charts/fdp
helm template fdp ./charts/fdp -f ./charts/fdp/values-dev.yaml > /dev/null
kubectl apply --dry-run=server -f <(helm template fdp ./charts/fdp -f ./charts/fdp/values-dev.yaml)
```

### Test Environments

1. **Development**: Use `values-dev.yaml` with minimal resources
2. **Staging**: Use `values-staging.yaml` with production-like configuration
3. **Production**: Use `values-prod.yaml` with full production settings

### Debugging

```bash
# Common debugging commands
helm status fdp --namespace fdp
kubectl get all -l app.kubernetes.io/name=fdp --namespace fdp
kubectl logs -l app.kubernetes.io/name=fdp --namespace fdp
kubectl describe pods -l app.kubernetes.io/name=fdp --namespace fdp
```

## Agent-Specific Instructions

### For AI Coding Agents

1. **Scope Understanding**: This is a Helm chart repository, not an application codebase
2. **Primary Tasks**: YAML template creation, Kubernetes manifest generation, values management
3. **Tool Focus**: Use Helm and Kubernetes tools, not application development tools
4. **Validation**: Always validate templates before suggesting changes
5. **Security**: Be especially careful with secrets and security configurations

### Common Agent Tasks

1. **Template Creation**: Generate new Kubernetes resource templates
2. **Values Management**: Add/update configuration options
3. **Documentation**: Update README with new features
4. **Validation**: Run lint and template tests
5. **Troubleshooting**: Help diagnose installation issues

### Task Execution Flow

1. Read existing templates and values
2. Understand the component architecture
3. Make minimal, focused changes
4. Validate with Helm lint
5. Test template rendering
6. Document changes

### Git Workflow Guidelines

1. **Commit Message Format**: Use gitmoji conventions for all commit messages
   - Example: `:bug: Fix namespace reference in HTTPRoute template`
   - Example: `:sparkles: Add new gateway configuration options`
   - Example: `:memo: Update documentation for MongoDB setup`
   - Common gitmoji:
     - `:bug:` for bug fixes
     - `:sparkles:` for new features
     - `:memo:` for documentation changes
     - `:wrench:` for configuration changes
     - `:arrow_up:` for dependency updates
     - `:recycle:` for refactoring
     - `:bookmark:` for version releases

2. **Branch Strategy**: 
   - NEVER push changes directly to the `main` branch unless explicitly asked
   - Create feature branches for all changes (e.g., `feature/gateway-fix`, `bug/httproute-namespace`)
   - Use descriptive branch names that follow kebab-case convention

3. **Pull Request Process**:
   - Create pull requests for all changes
   - Include clear descriptions of what was changed and why
   - Reference related issues or tickets
   - Wait for review and approval before merging

4. **Commit Hygiene**:
   - Make atomic commits (one logical change per commit)
   - Write clear, concise commit messages
   - Include relevant context in commit messages
   - Never commit secrets, credentials, or sensitive information

## Environment-Specific Notes

### Development Environment

- Use `values-dev.yaml` for local testing
- Minimal resource requirements
- Debugging enabled
- Local storage classes

### Production Environment

- Use `values-prod.yaml` for production deployments
- Proper resource requests/limits
- External secrets management
- Production-grade storage
- Multiple replicas where appropriate

## Best Practices Summary

1. **Consistency**: Follow existing patterns and conventions
2. **Simplicity**: Keep templates and values as simple as possible
3. **Documentation**: Document all changes and new features
4. **Testing**: Validate all changes before committing
5. **Security**: Always consider security implications
6. **Performance**: Optimize resource usage
7. **Maintainability**: Write templates that are easy to understand and modify

## Additional Resources

- [Helm Documentation](https://helm.sh/docs/)
- [Kubernetes Documentation](https://kubernetes.io/docs/home/)
- [FAIR Data Point](https://fairdatapoint.org/)
- [Chart Releaser Action](https://github.com/helm/chart-releaser-action)

This AGENTS.md file provides comprehensive guidelines for working with the GDI-K8s-Resources repository, focusing on Helm chart development, Kubernetes best practices, and agent-specific instructions.