# Domain 2: Application Deployment (20%)

## Overview

This domain covers deploying applications using Kubernetes Deployments, performing rolling updates and rollbacks, and using Helm and Kustomize for application packaging and configuration management.

## Deployments

**[📖 Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)** - Complete Deployment documentation
**[📖 Managing Resources](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/)** - Deployment management patterns
**[📖 Run a Stateless Application Using a Deployment](https://kubernetes.io/docs/tasks/run-application/run-stateless-application-deployment/)** - Deployment tutorial

### Deployment Fundamentals
- A Deployment manages a ReplicaSet, which manages Pods
- Provides declarative updates - you specify the desired state and the controller makes it happen
- Supports rolling updates, scaling, and rollback
- Maintains revision history for rollback capability

### Creating Deployments

**Imperative:**
```bash
# Create a Deployment
kubectl create deployment nginx --image=nginx:1.25 --replicas=3

# Generate YAML
kubectl create deployment nginx --image=nginx:1.25 --replicas=3 --dry-run=client -o yaml > deploy.yaml

# Create with port
kubectl create deployment nginx --image=nginx:1.25 --port=80
```

**Declarative:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
  labels:
    app: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
        - name: myapp
          image: myapp:1.0
          ports:
            - containerPort: 8080
          resources:
            requests:
              cpu: 100m
              memory: 64Mi
            limits:
              cpu: 200m
              memory: 128Mi
```

### Key Fields
- `spec.replicas`: Desired number of Pod replicas
- `spec.selector.matchLabels`: Must match `spec.template.metadata.labels`
- `spec.template`: Pod template used to create Pods
- `spec.strategy`: Update strategy (RollingUpdate or Recreate)
- `spec.revisionHistoryLimit`: Number of old ReplicaSets to keep (default 10)
- `spec.minReadySeconds`: Minimum seconds a Pod must be ready before considered available

### Scaling
```bash
# Scale imperatively
kubectl scale deployment myapp --replicas=5

# Autoscale (HPA)
kubectl autoscale deployment myapp --min=2 --max=10 --cpu-percent=80
```

---

## Rolling Updates

**[📖 Performing a Rolling Update](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/)** - Rolling update tutorial
**[📖 Rolling Update Strategy](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment)** - Strategy configuration

### Rolling Update Strategy

```yaml
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1      # Max Pods unavailable during update
      maxSurge: 1             # Max extra Pods above desired count
```

**Parameters:**
| Parameter | Default | Description |
|-----------|---------|-------------|
| `maxUnavailable` | 25% | Maximum Pods that can be unavailable. Can be a number or percentage. |
| `maxSurge` | 25% | Maximum Pods that can exist above the desired count. Can be a number or percentage. |

**Examples:**
- `maxUnavailable: 0`, `maxSurge: 1` - Zero-downtime update (always has at least desired count running)
- `maxUnavailable: 1`, `maxSurge: 0` - Conservative update (never exceeds desired count)
- `maxUnavailable: 25%`, `maxSurge: 25%` - Default balanced approach

### Recreate Strategy
```yaml
spec:
  strategy:
    type: Recreate
```
All existing Pods are killed before new ones are created. Results in downtime but is simpler. Useful when you cannot run two versions simultaneously.

### Performing Updates

```bash
# Update image
kubectl set image deployment/myapp myapp=myapp:2.0

# Update with edit
kubectl edit deployment myapp

# Patch a specific field
kubectl patch deployment myapp -p '{"spec":{"template":{"spec":{"containers":[{"name":"myapp","image":"myapp:2.0"}]}}}}'
```

### Rollout Management

```bash
# Check rollout status
kubectl rollout status deployment/myapp

# View rollout history
kubectl rollout history deployment/myapp

# View specific revision details
kubectl rollout history deployment/myapp --revision=2

# Undo last rollout (rollback)
kubectl rollout undo deployment/myapp

# Rollback to specific revision
kubectl rollout undo deployment/myapp --to-revision=1

# Pause a rollout (for canary-style testing)
kubectl rollout pause deployment/myapp

# Resume a paused rollout
kubectl rollout resume deployment/myapp

# Restart all Pods in a Deployment (rolling restart)
kubectl rollout restart deployment/myapp
```

---

## Blue-Green Deployment Strategy

**[📖 Canary Deployments](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/#canary-deployments)** - Deployment strategies overview

### How Blue-Green Works
Blue-Green uses two identical Deployments (blue = current, green = new). Traffic is switched instantly by updating the Service selector.

### Implementation Steps

**Step 1: Deploy the "blue" version (current production)**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-blue
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
      version: blue
  template:
    metadata:
      labels:
        app: myapp
        version: blue
    spec:
      containers:
        - name: myapp
          image: myapp:1.0
---
apiVersion: v1
kind: Service
metadata:
  name: myapp-svc
spec:
  selector:
    app: myapp
    version: blue      # Points to blue
  ports:
    - port: 80
      targetPort: 8080
```

**Step 2: Deploy the "green" version (new version)**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-green
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
      version: green
  template:
    metadata:
      labels:
        app: myapp
        version: green
    spec:
      containers:
        - name: myapp
          image: myapp:2.0
```

**Step 3: Switch traffic by updating the Service**
```bash
kubectl patch service myapp-svc -p '{"spec":{"selector":{"version":"green"}}}'
```

**Step 4: Rollback if needed**
```bash
kubectl patch service myapp-svc -p '{"spec":{"selector":{"version":"blue"}}}'
```

---

## Canary Deployment Strategy

### How Canary Works
Run a small number of Pods with the new version alongside the full production deployment. Both share the same Service label so traffic is distributed between them.

### Implementation

**Existing production Deployment (90% of traffic):**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-stable
spec:
  replicas: 9
  selector:
    matchLabels:
      app: myapp
      track: stable
  template:
    metadata:
      labels:
        app: myapp
        track: stable
    spec:
      containers:
        - name: myapp
          image: myapp:1.0
```

**Canary Deployment (10% of traffic):**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp
      track: canary
  template:
    metadata:
      labels:
        app: myapp
        track: canary
    spec:
      containers:
        - name: myapp
          image: myapp:2.0
```

**Service selects both (using the common label):**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp-svc
spec:
  selector:
    app: myapp          # Matches both stable and canary Pods
  ports:
    - port: 80
      targetPort: 8080
```

**Gradual rollout:**
```bash
# Scale up canary, scale down stable
kubectl scale deployment myapp-canary --replicas=3
kubectl scale deployment myapp-stable --replicas=7

# Continue until fully migrated
kubectl scale deployment myapp-canary --replicas=10
kubectl scale deployment myapp-stable --replicas=0

# Clean up old deployment
kubectl delete deployment myapp-stable
```

---

## Helm Package Manager

**[📖 Helm Documentation](https://helm.sh/docs/)** - Official Helm docs
**[📖 Helm Quickstart Guide](https://helm.sh/docs/intro/quickstart/)** - Getting started
**[📖 Using Helm](https://helm.sh/docs/intro/using_helm/)** - Core Helm concepts
**[📖 Chart Template Guide](https://helm.sh/docs/chart_template_guide/)** - Templating

### What is Helm?
Helm is the package manager for Kubernetes. A Helm chart is a collection of files that describe a related set of Kubernetes resources.

### Key Concepts
- **Chart**: A Helm package containing Kubernetes resource templates and metadata
- **Release**: A running instance of a chart in a cluster
- **Repository**: A location where charts are stored and shared
- **Values**: Configuration that is merged into chart templates

### Essential Helm Commands

```bash
# Repository management
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm repo list
helm repo remove bitnami

# Search for charts
helm search repo nginx                  # Search repos
helm search hub wordpress              # Search Artifact Hub

# Install a chart
helm install my-release bitnami/nginx
helm install my-release bitnami/nginx -n my-namespace
helm install my-release bitnami/nginx --set replicaCount=3
helm install my-release bitnami/nginx -f custom-values.yaml
helm install my-release bitnami/nginx --create-namespace -n new-ns

# List releases
helm list
helm list -n my-namespace
helm list --all-namespaces

# Get release info
helm status my-release
helm get values my-release
helm get manifest my-release

# Upgrade a release
helm upgrade my-release bitnami/nginx --set replicaCount=5
helm upgrade my-release bitnami/nginx -f updated-values.yaml

# Rollback
helm rollback my-release 1             # Rollback to revision 1
helm history my-release                # View revision history

# Uninstall
helm uninstall my-release
helm uninstall my-release -n my-namespace

# Show chart info (without installing)
helm show chart bitnami/nginx
helm show values bitnami/nginx
helm show all bitnami/nginx

# Template rendering (without installing)
helm template my-release bitnami/nginx --set replicaCount=3
```

### Chart Structure
```
mychart/
├── Chart.yaml          # Chart metadata (name, version, description)
├── values.yaml         # Default configuration values
├── charts/             # Dependency charts
├── templates/          # Kubernetes manifest templates
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   ├── _helpers.tpl    # Template helpers
│   └── NOTES.txt       # Post-install notes
└── .helmignore         # Files to ignore when packaging
```

---

## Kustomize

**[📖 Kustomize Overview](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/)** - Managing objects with Kustomize
**[📖 Declarative Management with Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/)** - Kustomize documentation

### What is Kustomize?
Kustomize lets you customize Kubernetes manifests without modifying the original YAML files. It is built into kubectl via `kubectl apply -k` and `kubectl kustomize`.

### Basic kustomization.yaml

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

# Resources to include
resources:
  - deployment.yaml
  - service.yaml

# Apply to all resources
namespace: production
commonLabels:
  app: myapp
  env: production
commonAnnotations:
  managed-by: kustomize

# Generate ConfigMaps
configMapGenerator:
  - name: app-config
    literals:
      - DB_HOST=db.production.svc
      - LOG_LEVEL=info
  - name: app-config-from-file
    files:
      - config.properties

# Generate Secrets
secretGenerator:
  - name: app-secrets
    literals:
      - DB_PASSWORD=secret123

# Image overrides
images:
  - name: myapp
    newName: registry.example.com/myapp
    newTag: "2.0"

# Patches
patches:
  - path: increase-replicas.yaml
```

### Overlay Pattern
```
project/
├── base/
│   ├── kustomization.yaml
│   ├── deployment.yaml
│   └── service.yaml
├── overlays/
│   ├── dev/
│   │   ├── kustomization.yaml
│   │   └── replica-patch.yaml
│   └── prod/
│       ├── kustomization.yaml
│       └── replica-patch.yaml
```

**base/kustomization.yaml:**
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - deployment.yaml
  - service.yaml
```

**overlays/prod/kustomization.yaml:**
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ../../base
namespace: production
commonLabels:
  env: production
patches:
  - path: replica-patch.yaml
```

**overlays/prod/replica-patch.yaml:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 5
```

### Using Kustomize

```bash
# Preview the output
kubectl kustomize ./overlays/prod/

# Apply directly
kubectl apply -k ./overlays/prod/

# Delete resources
kubectl delete -k ./overlays/prod/
```
