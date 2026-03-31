# Domain 4: Application Environment, Configuration and Security (25%)

## Overview

This is the highest-weighted domain on the CKAD exam. It covers ConfigMaps, Secrets, SecurityContexts, ServiceAccounts, resource management (requests, limits, quotas), admission controllers, and extending Kubernetes with Custom Resources and Operators.

## ConfigMaps

**[📖 ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)** - ConfigMap concepts
**[📖 Configure a Pod to Use a ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/)** - Consuming ConfigMaps in Pods

### Creating ConfigMaps

**Imperative:**
```bash
# From literals
kubectl create configmap app-config \
  --from-literal=DB_HOST=localhost \
  --from-literal=DB_PORT=5432 \
  --from-literal=LOG_LEVEL=info

# From a file
kubectl create configmap app-config --from-file=config.properties

# From an env file
kubectl create configmap app-config --from-env-file=config.env

# From a directory (each file becomes a key)
kubectl create configmap app-config --from-file=./config-dir/

# Generate YAML
kubectl create configmap app-config --from-literal=key=value --dry-run=client -o yaml
```

**Declarative:**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  DB_HOST: "localhost"
  DB_PORT: "5432"
  LOG_LEVEL: "info"
  config.properties: |
    server.port=8080
    server.host=0.0.0.0
    logging.level=INFO
```

### Consuming ConfigMaps

**Method 1: Individual environment variables**
```yaml
spec:
  containers:
    - name: app
      image: myapp:1.0
      env:
        - name: DATABASE_HOST
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: DB_HOST
        - name: DATABASE_PORT
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: DB_PORT
```

**Method 2: All keys as environment variables**
```yaml
spec:
  containers:
    - name: app
      image: myapp:1.0
      envFrom:
        - configMapRef:
            name: app-config
          prefix: APP_    # Optional: prefix all keys
```

**Method 3: Volume mount (keys become files)**
```yaml
spec:
  containers:
    - name: app
      image: myapp:1.0
      volumeMounts:
        - name: config-volume
          mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        name: app-config
```

**Method 4: Mount specific keys**
```yaml
spec:
  containers:
    - name: app
      image: myapp:1.0
      volumeMounts:
        - name: config-volume
          mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        name: app-config
        items:
          - key: config.properties
            path: app.properties    # Mounted as /etc/config/app.properties
```

### ConfigMap Updates
- Volume-mounted ConfigMaps are eventually updated (can take up to the kubelet sync period)
- Environment variables from ConfigMaps are NOT updated after Pod creation
- To pick up env var changes, the Pod must be restarted

---

## Secrets

**[📖 Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)** - Secret concepts and types
**[📖 Managing Secrets using kubectl](https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-kubectl/)** - Creating Secrets
**[📖 Distribute Credentials Securely](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/)** - Using Secrets securely

### Secret Types

| Type | Usage |
|------|-------|
| `Opaque` | Generic key-value pairs (default) |
| `kubernetes.io/dockerconfigjson` | Docker registry credentials |
| `kubernetes.io/tls` | TLS certificate and private key |
| `kubernetes.io/basic-auth` | Basic authentication (username/password) |
| `kubernetes.io/ssh-auth` | SSH authentication (private key) |
| `kubernetes.io/service-account-token` | ServiceAccount token |

### Creating Secrets

```bash
# Generic (Opaque) Secret
kubectl create secret generic db-credentials \
  --from-literal=username=admin \
  --from-literal=password='s3cur3P@ss'

# From files
kubectl create secret generic tls-data \
  --from-file=cert.pem \
  --from-file=key.pem

# Docker registry Secret
kubectl create secret docker-registry my-registry \
  --docker-server=registry.example.com \
  --docker-username=user \
  --docker-password=password

# TLS Secret
kubectl create secret tls my-tls \
  --cert=path/to/cert.pem \
  --key=path/to/key.pem
```

**Declarative (values must be base64-encoded):**
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-credentials
type: Opaque
data:
  username: YWRtaW4=           # echo -n "admin" | base64
  password: czNjdXIzUEBzcw==  # echo -n "s3cur3P@ss" | base64
```

**Using `stringData` (plain text, automatically encoded):**
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-credentials
type: Opaque
stringData:
  username: admin
  password: s3cur3P@ss
```

### Consuming Secrets

Secrets are consumed the same way as ConfigMaps:

**As environment variables:**
```yaml
spec:
  containers:
    - name: app
      image: myapp:1.0
      env:
        - name: DB_USER
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: username
        - name: DB_PASS
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: password
      envFrom:
        - secretRef:
            name: db-credentials
```

**As volume mounts:**
```yaml
spec:
  containers:
    - name: app
      image: myapp:1.0
      volumeMounts:
        - name: secret-volume
          mountPath: /etc/secrets
          readOnly: true
  volumes:
    - name: secret-volume
      secret:
        secretName: db-credentials
        defaultMode: 0400    # Read-only for owner
```

### Secret Security Notes
- Secrets are base64-encoded, NOT encrypted by default
- Enable encryption at rest for production clusters
- Use RBAC to restrict access to Secrets
- Consider using external secret management (Vault, AWS Secrets Manager)
- Set `readOnly: true` when mounting Secrets as volumes

---

## SecurityContexts

**[📖 Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)** - SecurityContext configuration
**[📖 Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)** - Privileged, Baseline, Restricted
**[📖 Pod Security Admission](https://kubernetes.io/docs/concepts/security/pod-security-admission/)** - Enforcing standards

### Pod-Level SecurityContext
Applies to all containers in the Pod:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
spec:
  securityContext:
    runAsUser: 1000          # UID for all containers
    runAsGroup: 3000         # Primary GID for all containers
    fsGroup: 2000            # Group for volume mounts
    runAsNonRoot: true       # Reject containers that run as root
    supplementalGroups:
      - 4000
  containers:
    - name: app
      image: myapp:1.0
```

### Container-Level SecurityContext
Applies to a specific container (overrides Pod-level where applicable):

```yaml
spec:
  containers:
    - name: app
      image: myapp:1.0
      securityContext:
        runAsUser: 1000
        runAsNonRoot: true
        readOnlyRootFilesystem: true
        allowPrivilegeEscalation: false
        privileged: false
        capabilities:
          drop:
            - ALL
          add:
            - NET_BIND_SERVICE
```

### Key SecurityContext Fields

**Pod-level only:**
- `fsGroup`: Group applied to all mounted volumes
- `supplementalGroups`: Additional groups for all containers

**Pod or container level:**
- `runAsUser`: UID to run the container process
- `runAsGroup`: GID for the container process
- `runAsNonRoot`: Fail if container tries to run as root (UID 0)

**Container-level only:**
- `readOnlyRootFilesystem`: Mount root filesystem as read-only
- `allowPrivilegeEscalation`: Allow child processes to gain more privileges
- `privileged`: Run container in privileged mode (avoid in production)
- `capabilities`: Add or drop Linux capabilities

### Common Capability Management
```yaml
securityContext:
  capabilities:
    drop:
      - ALL               # Drop all capabilities
    add:
      - NET_BIND_SERVICE  # Bind to ports below 1024
      - SYS_TIME          # Set system clock
```

### Pod Security Standards
| Level | Description |
|-------|-------------|
| **Privileged** | No restrictions - for system-level workloads |
| **Baseline** | Prevents known privilege escalations - reasonable default |
| **Restricted** | Heavily restricted - follows hardening best practices |

---

## ServiceAccounts

**[📖 Service Accounts](https://kubernetes.io/docs/concepts/security/service-accounts/)** - ServiceAccount concepts
**[📖 Configure Service Accounts for Pods](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)** - Using ServiceAccounts in Pods
**[📖 Managing Service Accounts](https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin/)** - Administration

### ServiceAccount Basics
- Every namespace has a `default` ServiceAccount
- Pods use the `default` ServiceAccount unless you specify otherwise
- ServiceAccount tokens are automatically mounted at `/var/run/secrets/kubernetes.io/serviceaccount/`
- Use custom ServiceAccounts for fine-grained RBAC

### Creating and Using ServiceAccounts

```bash
# Create a ServiceAccount
kubectl create serviceaccount my-sa
kubectl create sa my-sa -n my-namespace
```

**Assign to a Pod:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  serviceAccountName: my-sa
  automountServiceAccountToken: true    # Default is true
  containers:
    - name: app
      image: myapp:1.0
```

**Disable automatic token mounting:**
```yaml
spec:
  serviceAccountName: my-sa
  automountServiceAccountToken: false
  containers:
    - name: app
      image: myapp:1.0
```

### RBAC with ServiceAccounts

**[📖 Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)** - RBAC documentation

```bash
# Create a Role
kubectl create role pod-reader \
  --verb=get,list,watch \
  --resource=pods \
  -n my-namespace

# Bind the Role to a ServiceAccount
kubectl create rolebinding pod-reader-binding \
  --role=pod-reader \
  --serviceaccount=my-namespace:my-sa \
  -n my-namespace

# Create a ClusterRole
kubectl create clusterrole secret-reader \
  --verb=get,list \
  --resource=secrets

# Bind with ClusterRoleBinding
kubectl create clusterrolebinding secret-reader-binding \
  --clusterrole=secret-reader \
  --serviceaccount=my-namespace:my-sa
```

---

## Resource Management

**[📖 Managing Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)** - Resource requests and limits
**[📖 Resource Quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/)** - Namespace-level quotas
**[📖 Limit Ranges](https://kubernetes.io/docs/concepts/policy/limit-range/)** - Default and max/min limits

### Requests and Limits

```yaml
spec:
  containers:
    - name: app
      image: myapp:1.0
      resources:
        requests:
          cpu: 100m         # 0.1 CPU core
          memory: 128Mi     # 128 mebibytes
        limits:
          cpu: 500m         # 0.5 CPU core
          memory: 256Mi     # 256 mebibytes
```

**Behavior:**
- **Requests**: Used by the scheduler to decide which node to place the Pod on. The node must have this capacity available.
- **Limits**: Maximum the container can use. CPU is throttled when exceeded. Memory causes OOMKill when exceeded.

**Resource Units:**
| Resource | Unit | Examples |
|----------|------|---------|
| CPU | Millicores | `100m` = 0.1 CPU, `1` = 1 CPU, `1500m` = 1.5 CPU |
| Memory | Bytes | `128Mi` = 128 MiB, `1Gi` = 1 GiB, `256M` = 256 MB |

### ResourceQuotas

Limit total resource consumption in a namespace:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: my-namespace
spec:
  hard:
    requests.cpu: "4"
    requests.memory: 8Gi
    limits.cpu: "8"
    limits.memory: 16Gi
    pods: "20"
    services: "10"
    persistentvolumeclaims: "5"
    configmaps: "10"
    secrets: "10"
```

```bash
# Create imperatively
kubectl create quota compute-quota -n my-namespace \
  --hard=requests.cpu=4,requests.memory=8Gi,limits.cpu=8,limits.memory=16Gi,pods=20

# View quota usage
kubectl describe quota compute-quota -n my-namespace
```

**Important:** When a ResourceQuota exists for CPU/memory, every Pod in the namespace MUST specify requests and limits. Otherwise, the Pod will be rejected.

### LimitRanges

Set default, min, and max resource constraints per container/Pod:

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: resource-limits
  namespace: my-namespace
spec:
  limits:
    - type: Container
      default:            # Default limits
        cpu: 200m
        memory: 256Mi
      defaultRequest:     # Default requests
        cpu: 100m
        memory: 128Mi
      min:                # Minimum allowed
        cpu: 50m
        memory: 64Mi
      max:                # Maximum allowed
        cpu: "1"
        memory: 1Gi
    - type: Pod
      max:
        cpu: "2"
        memory: 2Gi
```

**Key Points:**
- LimitRange applies to individual containers or Pods
- ResourceQuota applies to the total namespace
- LimitRange provides defaults, so Pods without resource specs get automatic values
- If a container exceeds LimitRange max, it will be rejected

---

## Admission Controllers

**[📖 Admission Controllers Reference](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)** - Built-in admission controllers
**[📖 Dynamic Admission Control](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/)** - Webhooks

### What Are Admission Controllers?
Admission controllers intercept requests to the API server after authentication and authorization but before the object is persisted. They can validate or mutate requests.

### Types
- **Validating**: Accept or reject a request (e.g., enforce policies)
- **Mutating**: Modify the request object (e.g., inject defaults)

### Important Admission Controllers for CKAD
| Controller | Purpose |
|------------|---------|
| `NamespaceLifecycle` | Rejects requests in non-existent or terminating namespaces |
| `LimitRanger` | Applies default resource requests/limits from LimitRange |
| `ResourceQuota` | Enforces ResourceQuota constraints |
| `ServiceAccount` | Auto-assigns ServiceAccount and mounts token |
| `PodSecurity` | Enforces Pod Security Standards (replaced PodSecurityPolicy) |
| `DefaultStorageClass` | Assigns default StorageClass to PVCs without one |

### Dynamic Admission Webhooks
- `ValidatingWebhookConfiguration`: External validation of resources
- `MutatingWebhookConfiguration`: External mutation of resources
- Used by tools like OPA Gatekeeper and Kyverno for policy enforcement

---

## Custom Resources and Operators

**[📖 Custom Resources](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/)** - Extending the API
**[📖 Custom Resource Definitions](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/)** - Creating CRDs
**[📖 Operator Pattern](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/)** - Operators

### Custom Resource Definitions (CRDs)
CRDs let you add new resource types to Kubernetes. Once a CRD is created, you can use kubectl to manage instances of the custom resource.

```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: backups.myapp.example.com
spec:
  group: myapp.example.com
  versions:
    - name: v1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                schedule:
                  type: string
                database:
                  type: string
  scope: Namespaced
  names:
    plural: backups
    singular: backup
    kind: Backup
    shortNames:
      - bk
```

### Operators
- Operators combine CRDs with custom controllers
- They automate the management of complex applications
- The controller watches for changes to custom resources and takes action
- Example: A database operator that handles provisioning, scaling, backups, and failover

### Working with Custom Resources
```bash
# List CRDs
kubectl get crd

# Get instances of a custom resource
kubectl get backups
kubectl get bk          # Using short name

# Describe a custom resource
kubectl describe backup my-backup
```
