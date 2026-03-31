# Kubernetes Cluster Component Security

**[📖 Controlling Access to the API](https://kubernetes.io/docs/concepts/security/controlling-access/)** - Authentication, authorization, admission control
**[📖 Admission Controllers](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)** - Built-in admission controllers

## API Server Security

The API server is the front door to the Kubernetes cluster. All requests pass through it, making its security critical.

### Authentication (Who Are You?)

**[📖 Authentication](https://kubernetes.io/docs/reference/access-authn-authz/authentication/)** - Supported authentication strategies

| Method | Description | Use Case |
|--------|-------------|----------|
| X.509 Certificates | Client certificates signed by cluster CA | Cluster components, admin users |
| Bearer Tokens | Static or dynamic tokens | Service accounts, external integrations |
| OIDC (OpenID Connect) | External identity provider | Enterprise SSO, external users |
| Webhook Token Auth | External authentication service | Custom authentication systems |
| ServiceAccount Tokens | JWT tokens for pod identity | Pod-to-API communication |

**Security Considerations:**
- Disable anonymous authentication (`--anonymous-auth=false`) in production
- Never use static token files or basic auth (deprecated and insecure)
- Prefer OIDC for human users and service account tokens for pods
- Enable certificate rotation for long-lived clusters

### Authorization (What Can You Do?)

**[📖 Authorization](https://kubernetes.io/docs/reference/access-authn-authz/authorization/)** - Authorization modes

| Mode | Description | When to Use |
|------|-------------|------------|
| RBAC | Role-based access control | Standard for all production clusters |
| Node | Restricts kubelet to its own node's resources | Always enable alongside RBAC |
| Webhook | External HTTP authorization service | Custom authorization logic |
| ABAC | Attribute-based access control | Legacy - not recommended |

**Recommended Configuration:**
- Use `--authorization-mode=Node,RBAC` (both enabled)
- RBAC is the standard for production environments
- Node authorization limits what kubelet can access
- ABAC requires API server restart for policy changes (avoid)

### Admission Control (Is This Request Allowed?)

**[📖 Admission Controllers Reference](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)** - Complete list

**Pipeline Order:**
1. **Mutating Admission Webhooks** - modify the request (add defaults, inject sidecars)
2. **Validating Admission Webhooks** - accept or reject the request

**Key Built-in Controllers:**
| Controller | Purpose |
|-----------|---------|
| PodSecurity | Enforces Pod Security Standards |
| LimitRanger | Sets default resource requests/limits |
| ResourceQuota | Enforces resource quotas per namespace |
| NodeRestriction | Limits kubelet to modify only its own node |
| ServiceAccount | Automates service account token management |

**OPA Gatekeeper:**
- External admission controller for custom policies
- Uses Rego policy language
- Constraint Templates define policy logic
- Constraints apply templates to specific resources
- Common policies: required labels, allowed registries, required resource limits

## etcd Security

etcd stores all cluster state, including Secrets. Its security is critical.

### Encryption at Rest

**[📖 Encrypting Data at Rest](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/)** - Configuration guide

- By default, Kubernetes Secrets are stored in etcd as base64-encoded text (not encrypted)
- EncryptionConfiguration enables encryption at rest
- Providers: aescbc, secretbox, aesgcm, kms
- The `identity` provider means no encryption (order matters - first provider is used for encryption)
- After enabling encryption, existing Secrets must be re-encrypted

### etcd Access Control
- Restrict access to etcd to the API server only
- Use TLS for client-to-server communication
- Use TLS for peer-to-peer communication (etcd cluster members)
- Never expose etcd ports to the network
- Regular backups with encrypted storage

### etcd TLS Configuration
- `--cert-file` and `--key-file` for server certificate
- `--client-cert-auth=true` to require client certificates
- `--trusted-ca-file` for CA certificate
- `--peer-cert-file` and `--peer-key-file` for peer communication

## kubelet Security

**Key Configuration Settings:**

| Setting | Recommended Value | Purpose |
|---------|------------------|---------|
| `--anonymous-auth` | `false` | Disable anonymous access to kubelet API |
| `--authorization-mode` | `Webhook` | Use API server for authorization |
| `--read-only-port` | `0` | Disable read-only port (10255) |
| `--protect-kernel-defaults` | `true` | Protect kernel tunable settings |
| `--streaming-connection-idle-timeout` | Non-zero | Timeout idle streaming connections |

**[📖 kubelet Configuration](https://kubernetes.io/docs/reference/config-api/kubelet-config.v1beta1/)** - kubelet configuration reference

## Control Plane Communication

### Certificate-Based Security
- All control plane components communicate over TLS
- Certificates are typically managed by kubeadm
- CA certificate is the root of trust
- Component certificates should be rotated regularly

### Communication Paths (All TLS-Encrypted)
- kubectl to API server
- API server to etcd
- API server to kubelet
- kubelet to API server
- kube-scheduler to API server
- kube-controller-manager to API server

## CIS Kubernetes Benchmark

**[📖 CIS Benchmarks](https://www.cisecurity.org/benchmark/kubernetes)** - CIS Kubernetes Benchmark
**[📖 kube-bench](https://github.com/aquasecurity/kube-bench)** - Automated assessment tool

### Benchmark Categories
1. **Control Plane Components** - API server, scheduler, controller manager configuration
2. **etcd** - etcd server security settings
3. **Control Plane Configuration** - Authentication, authorization, logging
4. **Worker Nodes** - kubelet, kube-proxy configuration
5. **Policies** - RBAC, Network Policies, Pod Security

### kube-bench
- Open source tool from Aqua Security
- Automates CIS Benchmark assessment
- Runs checks against cluster component configurations
- Reports PASS, FAIL, WARN, and INFO results
- Provides remediation guidance for failed checks
- Can run as a pod or directly on nodes

### Assessment Best Practices
- Run kube-bench regularly (not just once)
- Prioritize FAIL results over WARN
- Document exceptions for intentional deviations
- Include benchmark results in compliance reports
- Automate assessment as part of CI/CD or monitoring
