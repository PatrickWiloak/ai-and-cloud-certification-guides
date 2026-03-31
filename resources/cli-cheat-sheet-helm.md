# Helm CLI Cheat Sheet

Quick reference for Helm commands used in Kubernetes package management and deployment workflows.

**Official Documentation:** https://helm.sh/docs/helm/

---

## Table of Contents

- [Chart Management](#chart-management)
- [Repository Management](#repository-management)
- [Release Management](#release-management)
- [Template and Debugging](#template-and-debugging)
- [Values Management](#values-management)
- [Plugin Commands](#plugin-commands)
- [Environment and Configuration](#environment-and-configuration)

---

## Chart Management

```bash
# Create a new chart scaffold
helm create my-chart

# Package a chart into an archive
helm package my-chart/

# Package with a specific version
helm package my-chart/ --version 1.2.3

# Package with app version
helm package my-chart/ --app-version 2.0.0

# Install a chart from a repository
helm install my-release stable/nginx

# Install a chart from a local directory
helm install my-release ./my-chart

# Install a chart from a .tgz archive
helm install my-release my-chart-1.0.0.tgz

# Install a chart from a URL
helm install my-release https://example.com/charts/my-chart-1.0.0.tgz

# Install with a specific namespace
helm install my-release ./my-chart -n my-namespace

# Install and create namespace if it does not exist
helm install my-release ./my-chart -n my-namespace --create-namespace

# Install with custom values file
helm install my-release ./my-chart -f custom-values.yaml

# Install with inline value overrides
helm install my-release ./my-chart --set image.tag=v2.0

# Install with a generated name
helm install --generate-name ./my-chart

# Install and wait for resources to be ready
helm install my-release ./my-chart --wait --timeout 5m

# Install with atomic (rollback on failure)
helm install my-release ./my-chart --atomic

# Upgrade a release
helm upgrade my-release ./my-chart

# Upgrade or install if not present
helm upgrade --install my-release ./my-chart

# Upgrade with custom values
helm upgrade my-release ./my-chart -f values-prod.yaml

# Upgrade with atomic rollback on failure
helm upgrade my-release ./my-chart --atomic

# Upgrade and reuse previous values
helm upgrade my-release ./my-chart --reuse-values

# Upgrade and reset values to chart defaults
helm upgrade my-release ./my-chart --reset-values

# Upgrade with wait
helm upgrade my-release ./my-chart --wait --timeout 5m

# Rollback to a previous revision
helm rollback my-release 1

# Rollback with wait
helm rollback my-release 1 --wait

# Uninstall a release
helm uninstall my-release

# Uninstall but keep release history
helm uninstall my-release --keep-history

# Uninstall from a specific namespace
helm uninstall my-release -n my-namespace

# Show chart information
helm show chart ./my-chart

# Show chart default values
helm show values ./my-chart

# Show chart README
helm show readme ./my-chart

# Show all chart info
helm show all ./my-chart

# Download a chart without installing
helm pull stable/nginx

# Download and extract
helm pull stable/nginx --untar

# Download a specific version
helm pull stable/nginx --version 1.2.3

# Verify chart dependencies
helm dependency list ./my-chart

# Download chart dependencies
helm dependency update ./my-chart

# Rebuild dependency charts
helm dependency build ./my-chart
```

---

## Repository Management

```bash
# Add a chart repository
helm repo add bitnami https://charts.bitnami.com/bitnami

# Add common repositories
helm repo add stable https://charts.helm.sh/stable
helm repo add jetstack https://charts.jetstack.io
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts

# Update repository index
helm repo update

# List configured repositories
helm repo list

# Remove a repository
helm repo remove bitnami

# Search for charts in added repositories
helm search repo nginx

# Search with version constraints
helm search repo nginx --version ">=1.0.0"

# Show all versions of a chart
helm search repo nginx --versions

# Search Docker Hub (Artifact Hub)
helm search hub nginx

# Generate repository index file
helm repo index ./my-charts/

# Generate index with a base URL
helm repo index ./my-charts/ --url https://charts.example.com
```

---

## Release Management

```bash
# List releases in current namespace
helm list

# List releases in all namespaces
helm list -A

# List releases with a filter
helm list --filter 'nginx'

# List all releases (including failed, uninstalling)
helm list -a

# List deployed releases only
helm list --deployed

# List pending releases
helm list --pending

# List failed releases
helm list --failed

# Show release status
helm status my-release

# Show release status in a specific namespace
helm status my-release -n my-namespace

# Show release history
helm history my-release

# Get release manifest (rendered templates)
helm get manifest my-release

# Get release values (user-supplied)
helm get values my-release

# Get all release values (including defaults)
helm get values my-release --all

# Get release values as YAML
helm get values my-release -o yaml

# Get release hooks
helm get hooks my-release

# Get release notes
helm get notes my-release

# Get all release information
helm get all my-release

# Test a release (run test pods)
helm test my-release

# Test with cleanup
helm test my-release --cleanup
```

---

## Template and Debugging

```bash
# Render templates locally (without installing)
helm template my-release ./my-chart

# Render with custom values
helm template my-release ./my-chart -f custom-values.yaml

# Render specific templates
helm template my-release ./my-chart -s templates/deployment.yaml

# Render with debug output
helm template my-release ./my-chart --debug

# Render with namespace
helm template my-release ./my-chart -n production

# Lint a chart for issues
helm lint ./my-chart

# Lint with strict mode
helm lint ./my-chart --strict

# Lint with custom values
helm lint ./my-chart -f values-prod.yaml

# Dry-run an install (server-side rendering)
helm install my-release ./my-chart --dry-run

# Dry-run with debug output
helm install my-release ./my-chart --dry-run --debug

# Dry-run an upgrade
helm upgrade my-release ./my-chart --dry-run

# Verify a chart with provenance
helm verify ./my-chart-1.0.0.tgz

# Sign a chart
helm package --sign --key 'my-key' --keyring ~/.gnupg/secring.gpg ./my-chart
```

---

## Values Management

### Value Override Priority (lowest to highest)

1. Chart default values (values.yaml)
2. Parent chart values
3. Values file (-f / --values)
4. Individual values (--set)

### Setting Values

```bash
# Set a simple value
helm install my-release ./my-chart --set replicaCount=3

# Set a nested value
helm install my-release ./my-chart --set image.repository=nginx,image.tag=latest

# Set a string value (force string type)
helm install my-release ./my-chart --set-string version="1.0"

# Set a value from a file
helm install my-release ./my-chart --set-file config=./app-config.yaml

# Set a JSON value
helm install my-release ./my-chart --set-json 'resources={"limits":{"cpu":"200m"}}'

# Set array values
helm install my-release ./my-chart --set 'ingress.hosts[0]=example.com'

# Multiple values files (later files override earlier)
helm install my-release ./my-chart \
  -f values.yaml \
  -f values-prod.yaml

# Override with both file and set (set wins)
helm install my-release ./my-chart \
  -f values-prod.yaml \
  --set image.tag=v2.0

# Escape special characters in values
helm install my-release ./my-chart --set nodeSelector."kubernetes\.io/os"=linux

# Set values with commas (use backslash)
helm install my-release ./my-chart --set tags="tag1\,tag2\,tag3"
```

### Values File Example

```yaml
# values.yaml
replicaCount: 3

image:
  repository: nginx
  tag: "1.25"
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: true
  hosts:
    - host: example.com
      paths:
        - path: /
          pathType: Prefix

resources:
  limits:
    cpu: 200m
    memory: 256Mi
  requests:
    cpu: 100m
    memory: 128Mi

nodeSelector:
  kubernetes.io/os: linux

tolerations: []

affinity: {}
```

---

## Plugin Commands

```bash
# List installed plugins
helm plugin list

# Install a plugin
helm plugin install https://github.com/databus23/helm-diff

# Install a specific version
helm plugin install https://github.com/databus23/helm-diff --version 3.9.0

# Update a plugin
helm plugin update diff

# Remove a plugin
helm plugin uninstall diff

# Popular plugins:
# helm-diff     - Show diff between revisions
# helm-secrets  - Manage encrypted values
# helm-s3       - Use S3 as chart repository
# helm-git      - Use Git repos as chart source
# helm-unittest - Unit testing for charts

# Using helm-diff
helm diff upgrade my-release ./my-chart -f new-values.yaml

# Using helm-secrets
helm secrets enc secrets.yaml
helm secrets dec secrets.yaml
helm secrets install my-release ./my-chart -f secrets://secrets.yaml
```

---

## Environment and Configuration

```bash
# View Helm environment variables
helm env

# Key environment variables
HELM_CACHE_HOME       # Cache directory
HELM_CONFIG_HOME      # Config directory
HELM_DATA_HOME        # Data directory
HELM_DRIVER           # Storage driver (configmap, secret, sql)
HELM_NAMESPACE        # Default namespace
HELM_KUBECONTEXT      # Default kubeconfig context
HELM_MAX_HISTORY      # Max release history (default 10)

# Set storage driver to secrets (default is configmap in older versions)
export HELM_DRIVER=secret

# Set default namespace
export HELM_NAMESPACE=production

# Helm version
helm version

# Helm completion (bash)
source <(helm completion bash)
echo 'source <(helm completion bash)' >> ~/.bashrc

# Helm completion (zsh)
source <(helm completion zsh)
echo 'source <(helm completion zsh)' >> ~/.zshrc

# Helm OCI registry support
helm registry login registry.example.com
helm registry logout registry.example.com

# Push chart to OCI registry
helm push my-chart-1.0.0.tgz oci://registry.example.com/charts

# Pull chart from OCI registry
helm pull oci://registry.example.com/charts/my-chart --version 1.0.0
```

---

## Resources

- Helm Documentation: https://helm.sh/docs/
- Helm CLI Reference: https://helm.sh/docs/helm/
- Chart Template Guide: https://helm.sh/docs/chart_template_guide/
- Chart Best Practices: https://helm.sh/docs/chart_best_practices/
- Artifact Hub (Chart Search): https://artifacthub.io/
- Helm GitHub: https://github.com/helm/helm
