# Pod Security Standards for CKS

**[📖 Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)** - Detailed policy definitions for each PSA level
**[📖 Pod Security Admission](https://kubernetes.io/docs/concepts/security/pod-security-admission/)** - PSA controller configuration

## Pod Security Admission (PSA)

### Overview
Pod Security Admission is a built-in Kubernetes admission controller that enforces Pod Security Standards at the namespace level. It replaced the deprecated PodSecurityPolicy (PSP) starting in Kubernetes 1.25.

### PSA Profiles

#### Privileged
- Unrestricted policy - allows everything
- Intended for system and infrastructure workloads (kube-system)
- No restrictions on capabilities, volumes, or host access
- Should only be used for trusted, essential system components

#### Baseline
- Minimally restrictive policy that prevents known privilege escalations
- Suitable for most non-critical workloads
- Blocks: hostNetwork, hostPID, hostIPC, privileged containers, host ports
- Allows: most capabilities, volume types, running as root

**Baseline restrictions:**
- No hostNetwork, hostPID, hostIPC
- No privileged containers
- No host port bindings (or limited range)
- No proc mount types other than Default
- No unsafe sysctls
- Restricted volume types (no hostPath)
- No Windows HostProcess

#### Restricted
- Heavily restricted policy following current pod hardening best practices
- Required for security-sensitive workloads
- Blocks everything Baseline blocks, plus additional restrictions

**Restricted additional requirements:**
- Must run as non-root (`runAsNonRoot: true`)
- Must not allow privilege escalation (`allowPrivilegeEscalation: false`)
- Must drop ALL capabilities (may add NET_BIND_SERVICE only)
- Must use a seccomp profile (RuntimeDefault or Localhost)
- Restricted volume types (only configMap, emptyDir, projected, secret, downwardAPI, PVC, ephemeral)

### PSA Modes

| Mode | Behavior |
|------|----------|
| **enforce** | Violations reject the pod |
| **audit** | Violations logged in audit log but pod is allowed |
| **warn** | Violations generate user-facing warnings but pod is allowed |

### Configuring PSA with Namespace Labels

```bash
# Enforce restricted in production
kubectl label namespace production \
  pod-security.kubernetes.io/enforce=restricted \
  pod-security.kubernetes.io/enforce-version=latest

# Warn and audit in staging (don't block, just alert)
kubectl label namespace staging \
  pod-security.kubernetes.io/warn=restricted \
  pod-security.kubernetes.io/warn-version=latest \
  pod-security.kubernetes.io/audit=restricted \
  pod-security.kubernetes.io/audit-version=latest

# Baseline for general workloads
kubectl label namespace general \
  pod-security.kubernetes.io/enforce=baseline \
  pod-security.kubernetes.io/enforce-version=latest \
  pod-security.kubernetes.io/warn=restricted \
  pod-security.kubernetes.io/warn-version=latest
```

**[📖 Enforce Pod Security Standards with Namespace Labels](https://kubernetes.io/docs/tasks/configure-pod-container/enforce-standards-namespace-labels/)** - Step-by-step guide

### Pod That Passes Restricted PSA

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: restricted-pod
  namespace: production
spec:
  securityContext:
    runAsNonRoot: true
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: app
    image: myapp:v1.0
    securityContext:
      allowPrivilegeEscalation: false
      capabilities:
        drop: ["ALL"]
      readOnlyRootFilesystem: true
      runAsNonRoot: true
    resources:
      limits:
        memory: "128Mi"
        cpu: "500m"
```

## SecurityContext Deep Dive

**[📖 Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)** - Configuring security context for pods and containers

### Pod-Level SecurityContext
```yaml
spec:
  securityContext:
    runAsUser: 1000           # UID for all containers
    runAsGroup: 3000          # Primary GID for all containers
    fsGroup: 2000             # GID for volume ownership
    runAsNonRoot: true        # Prevent running as root
    seccompProfile:           # Seccomp profile for all containers
      type: RuntimeDefault
    supplementalGroups: [4000] # Additional GIDs
```

### Container-Level SecurityContext
```yaml
containers:
- name: app
  securityContext:
    allowPrivilegeEscalation: false  # Prevent gaining more privileges
    privileged: false                 # Not a privileged container
    readOnlyRootFilesystem: true     # Immutable filesystem
    runAsNonRoot: true               # Must not run as UID 0
    runAsUser: 1000                  # Specific UID
    capabilities:
      drop: ["ALL"]                  # Drop all Linux capabilities
      add: ["NET_BIND_SERVICE"]      # Add only what's needed
    seccompProfile:
      type: RuntimeDefault           # Use default seccomp profile
```

### Linux Capabilities

**Common Capabilities:**
| Capability | Purpose | Risk |
|-----------|---------|------|
| NET_BIND_SERVICE | Bind to ports < 1024 | Low - often needed |
| NET_RAW | Use raw sockets | Medium - network sniffing |
| SYS_ADMIN | Broad system admin | HIGH - near root |
| SYS_PTRACE | Debug processes | HIGH - can read memory |
| DAC_OVERRIDE | Bypass file permissions | HIGH - access any file |
| CHOWN | Change file ownership | Medium |
| SETUID/SETGID | Change UID/GID | HIGH - privilege escalation |

**Best Practice:** Drop ALL capabilities and add only what is specifically needed:
```yaml
securityContext:
  capabilities:
    drop: ["ALL"]
    add: ["NET_BIND_SERVICE"]  # Only if needed
```

## OPA Gatekeeper

**[📖 OPA Gatekeeper](https://open-policy-agent.github.io/gatekeeper/website/docs/)** - Kubernetes admission control with OPA
**[📖 Gatekeeper Library](https://open-policy-agent.github.io/gatekeeper-library/website/)** - Pre-built constraint templates

### How Gatekeeper Works
1. **ConstraintTemplate** - Defines the policy logic using Rego language
2. **Constraint** - Applies a template with specific parameters to target resources
3. Gatekeeper acts as a ValidatingAdmissionWebhook
4. Every resource create/update is evaluated against matching constraints
5. Violations prevent the resource from being created

### Installing Gatekeeper
```bash
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/release-3.14/deploy/gatekeeper.yaml
```

### Common Constraint Templates

#### Required Labels
```yaml
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8srequiredlabels
spec:
  crd:
    spec:
      names:
        kind: K8sRequiredLabels
      validation:
        openAPIV3Schema:
          type: object
          properties:
            labels:
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8srequiredlabels
        violation[{"msg": msg}] {
          provided := {label | input.review.object.metadata.labels[label]}
          required := {label | label := input.parameters.labels[_]}
          missing := required - provided
          count(missing) > 0
          msg := sprintf("Missing required labels: %v", [missing])
        }
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sRequiredLabels
metadata:
  name: require-team-label
spec:
  match:
    kinds:
    - apiGroups: [""]
      kinds: ["Namespace"]
  parameters:
    labels: ["team", "environment"]
```

#### Block Latest Tag
```yaml
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8sdisallowedtags
spec:
  crd:
    spec:
      names:
        kind: K8sDisallowedTags
      validation:
        openAPIV3Schema:
          type: object
          properties:
            tags:
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8sdisallowedtags
        violation[{"msg": msg}] {
          container := input.review.object.spec.containers[_]
          tag := split(container.image, ":")[1]
          tag == input.parameters.tags[_]
          msg := sprintf("container <%v> uses disallowed tag <%v>", [container.name, tag])
        }
        violation[{"msg": msg}] {
          container := input.review.object.spec.containers[_]
          not contains(container.image, ":")
          msg := sprintf("container <%v> has no tag (defaults to latest)", [container.name])
        }
```

## Secrets Management

**[📖 Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)** - Kubernetes Secret objects
**[📖 Good Practices for Secrets](https://kubernetes.io/docs/concepts/security/secrets-good-practices/)** - Secret management recommendations

### Encryption at Rest

**[📖 Encrypting Secret Data at Rest](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/)** - Configuration guide

```yaml
# /etc/kubernetes/enc/encryption-config.yaml
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
    - secrets
    providers:
    - aescbc:
        keys:
        - name: key1
          secret: <base64-encoded-32-byte-key>
    - identity: {}  # Fallback for reading unencrypted secrets
```

**Provider order matters:**
- First provider is used for encryption of new secrets
- All providers are tried for decryption (in order)
- `identity: {}` means no encryption (plain text)
- If `identity` is first, secrets are NOT encrypted

### External Secret Management
- **HashiCorp Vault** - External secret store with Kubernetes integration
- **AWS Secrets Manager / Azure Key Vault / GCP Secret Manager** - Cloud-native options
- **External Secrets Operator** - Syncs external secrets to Kubernetes
- **Sealed Secrets** - Encrypt secrets for safe storage in Git

## Runtime Sandboxes

**[📖 Runtime Class](https://kubernetes.io/docs/concepts/containers/runtime-class/)** - Container runtime selection

### gVisor (runsc)
- Application-level kernel that intercepts system calls
- Provides an additional layer of isolation between containers and the host
- Runs in user space - no direct kernel access from containers
- Trade-off: some performance overhead and limited syscall compatibility

### Kata Containers
- Lightweight VMs that provide hardware-level isolation
- Each container runs in its own VM with a dedicated kernel
- Stronger isolation than gVisor but higher resource overhead
- Good for multi-tenant environments with untrusted workloads

### RuntimeClass Configuration
```yaml
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  name: gvisor
handler: runsc
---
apiVersion: v1
kind: Pod
metadata:
  name: sandboxed-pod
spec:
  runtimeClassName: gvisor
  containers:
  - name: app
    image: myapp:v1.0
```

## Key Takeaways

1. **PSA over PSP** - Pod Security Admission is the current standard; PodSecurityPolicy is removed
2. **Restricted level** - Know all requirements (non-root, no escalation, drop capabilities, seccomp)
3. **SecurityContext** - Understand both pod-level and container-level settings
4. **Capabilities** - Drop ALL, add only what is needed; know which capabilities are dangerous
5. **Gatekeeper** - Understand ConstraintTemplate and Constraint relationship
6. **Secrets** - Enable encryption at rest; provider order determines encryption behavior
7. **Sandboxes** - gVisor for syscall filtering, Kata for VM isolation; use RuntimeClass
