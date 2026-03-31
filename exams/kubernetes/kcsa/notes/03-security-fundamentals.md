# Kubernetes Security Fundamentals

**[📖 RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)** - Using RBAC authorization
**[📖 Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)** - PSA level definitions

## RBAC (Role-Based Access Control)

### RBAC Components

| Resource | Scope | Purpose |
|----------|-------|---------|
| **Role** | Namespace | Defines permissions within a specific namespace |
| **ClusterRole** | Cluster | Defines permissions cluster-wide or across namespaces |
| **RoleBinding** | Namespace | Binds a Role or ClusterRole to subjects within a namespace |
| **ClusterRoleBinding** | Cluster | Binds a ClusterRole to subjects across the entire cluster |

### Subjects
- **User**: External user identity (no Kubernetes User object - managed externally)
- **Group**: Collection of users (e.g., `system:masters` has cluster-admin access)
- **ServiceAccount**: Identity for pods, namespaced Kubernetes resource

### RBAC Rules
A rule consists of:
- **apiGroups**: API group (empty string for core, "apps", "networking.k8s.io", etc.)
- **resources**: What resources (pods, deployments, secrets, etc.)
- **verbs**: What actions (get, list, watch, create, update, patch, delete)
- **resourceNames**: (optional) Specific named resources

### RBAC Best Practices

**[📖 RBAC Good Practices](https://kubernetes.io/docs/concepts/security/rbac-good-practices/)** - Security recommendations

- **Least Privilege**: Grant only the minimum permissions required
- **Namespace Scope**: Prefer Role/RoleBinding over ClusterRole/ClusterRoleBinding
- **No Wildcards**: Avoid `*` for verbs, resources, or apiGroups in production
- **No cluster-admin for workloads**: Never bind cluster-admin to service accounts
- **Regular Audits**: Periodically review bindings and remove unnecessary permissions
- **Dedicated Service Accounts**: Create specific service accounts per workload

### Common Misconfigurations
- ClusterRoleBinding with cluster-admin for a single-namespace workload
- Wildcards in production roles (grants more access than intended)
- Not removing default service account permissions
- Granting list/watch on Secrets (allows reading all Secret data)

## Pod Security Standards

**[📖 Pod Security Admission](https://kubernetes.io/docs/concepts/security/pod-security-admission/)** - PSA configuration

### PSA Levels

#### Privileged
- No restrictions at all
- Allows everything including host access, privileged containers, all capabilities
- Use only when absolutely required (monitoring agents, CNI plugins)
- Isolate in dedicated namespaces with strict RBAC

#### Baseline
- Prevents known privilege escalation techniques
- Blocks: hostNetwork, hostPID, hostIPC, privileged containers, hostPath volumes
- Allows: running as root, most capabilities, writable filesystem
- Good default for standard workloads that need some flexibility

#### Restricted
- Maximum security hardening
- Requires: non-root, no privilege escalation, seccomp profile, drop ALL capabilities
- Blocks: everything Baseline blocks plus root execution and most capabilities
- Recommended for sensitive workloads (financial, healthcare, compliance)

### PSA Modes

| Mode | Behavior | Use Case |
|------|----------|----------|
| **enforce** | Rejects pods that violate the policy | Production namespaces |
| **audit** | Logs violations but allows pods | Monitoring compliance |
| **warn** | Shows warnings to users but allows pods | Migration and awareness |

**Applied via namespace labels:**
```
pod-security.kubernetes.io/enforce: restricted
pod-security.kubernetes.io/enforce-version: latest
pod-security.kubernetes.io/audit: restricted
pod-security.kubernetes.io/warn: restricted
```

## Network Policies

**[📖 Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)** - NetworkPolicy documentation

### Key Concepts
- Control traffic flow between pods at the network level
- Without Network Policies, all pod-to-pod traffic is allowed
- Policies are namespace-scoped
- Require a CNI plugin that supports NetworkPolicy (Calico, Cilium, Weave)
- Policies are additive - multiple policies combine (union)

### Default Deny Pattern
- Create a NetworkPolicy that selects all pods but allows no traffic
- This establishes a "deny all" baseline
- Then create additional policies to explicitly allow needed traffic
- Best practice for defense in depth

### Policy Types
- **Ingress**: Controls incoming traffic to selected pods
- **Egress**: Controls outgoing traffic from selected pods
- Both should be controlled for complete isolation

### Important Notes
- Policies use label selectors to target pods and allowed sources/destinations
- Namespace selectors can restrict cross-namespace traffic
- Always allow DNS egress (port 53 UDP/TCP) when using egress policies
- Policies apply to the pod, not the Service

## Secrets Management

**[📖 Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)** - Kubernetes Secret objects
**[📖 Good Practices for Secrets](https://kubernetes.io/docs/concepts/security/secrets-good-practices/)** - Secret management recommendations

### Key Facts
- Secrets are base64-encoded by default (NOT encrypted)
- Encryption at rest requires explicit configuration (EncryptionConfiguration)
- Stored in etcd - anyone with etcd access can read them
- RBAC controls who can read Secrets via the API

### Secret Types
| Type | Description |
|------|-------------|
| Opaque | Generic key-value data (default) |
| kubernetes.io/tls | TLS certificate and key |
| kubernetes.io/dockerconfigjson | Docker registry credentials |
| kubernetes.io/service-account-token | Service account tokens |

### Best Practices
- Enable encryption at rest in etcd
- Use RBAC to restrict Secret access
- Avoid mounting Secrets as environment variables (visible in pod spec and logs)
- Consider external secret management (Vault, AWS Secrets Manager, GCP Secret Manager)
- Rotate secrets regularly
- Use short-lived tokens where possible
- Do not commit Secrets to version control

## Service Account Security

**[📖 Service Accounts](https://kubernetes.io/docs/concepts/security/service-accounts/)** - Service account management

### Key Concepts
- Every pod runs as a service account (default: `default` service account)
- Service account tokens are automatically mounted into pods
- Tokens provide API access - a compromised pod can use the token

### Security Best Practices
- Set `automountServiceAccountToken: false` on the default service account
- Create dedicated service accounts per workload
- Grant minimal RBAC permissions to service accounts
- Use projected (bound) service account tokens (time-limited, audience-scoped)
- Do not share service accounts across workloads

## Security Context

**[📖 Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)** - Pod and container security settings

### Pod-Level Fields
| Field | Purpose |
|-------|---------|
| `runAsUser` | Set the UID for all containers |
| `runAsGroup` | Set the GID for all containers |
| `runAsNonRoot` | Fail if container tries to run as root |
| `fsGroup` | Set group ownership on mounted volumes |
| `seccompProfile` | Apply seccomp profile to all containers |

### Container-Level Fields
| Field | Purpose |
|-------|---------|
| `allowPrivilegeEscalation` | Prevent gaining more privileges than parent |
| `readOnlyRootFilesystem` | Make container filesystem read-only |
| `capabilities.drop` | Remove Linux capabilities |
| `capabilities.add` | Add specific Linux capabilities |
| `privileged` | Run with all host capabilities (avoid) |

### Recommended Security Context
```yaml
securityContext:
  runAsNonRoot: true
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
  seccompProfile:
    type: RuntimeDefault
  capabilities:
    drop: ["ALL"]
```

## Resource Quotas and Limit Ranges

### Resource Quotas
- Limit total resource consumption per namespace
- Prevent one team from consuming all cluster resources
- Can limit: CPU, memory, storage, object counts (pods, services, etc.)

### Limit Ranges
- Set default, minimum, and maximum resource requests/limits per container
- Ensures all pods have resource constraints
- Prevents both resource starvation and excessive consumption
- Applied at the namespace level
