# Cluster Hardening for CKS

**[📖 Controlling Access to the Kubernetes API](https://kubernetes.io/docs/concepts/security/controlling-access/)** - Authentication, authorization, and admission control overview

## API Server Security

**[📖 API Server Authentication](https://kubernetes.io/docs/reference/access-authn-authz/authentication/)** - Supported authentication strategies

### Authentication Methods

#### X.509 Client Certificates
- Most common for cluster components and admin users
- Certificates signed by the cluster CA
- CN (Common Name) used as username, O (Organization) used as group
- Configured with `--client-ca-file` on the API server

#### Service Account Tokens
- Used by pods to authenticate to the API server
- JWT tokens mounted into pods automatically (unless disabled)
- Bound tokens are time-limited and audience-scoped
- Created with `kubectl create token` or automatically mounted

#### OpenID Connect (OIDC)
- External identity provider integration
- Supports providers like Dex, Keycloak, Azure AD
- Configured with `--oidc-issuer-url`, `--oidc-client-id`, etc.
- Good for enterprise user management

#### Static Token Files and Basic Auth
- **INSECURE** - Should never be used in production
- `--token-auth-file` and `--basic-auth-file` are deprecated approaches
- CKS exam may test knowledge of disabling these

### Authorization Modes

**[📖 Authorization Overview](https://kubernetes.io/docs/reference/access-authn-authz/authorization/)** - Authorization modes and configuration

#### RBAC (Role-Based Access Control)
- Standard authorization mode for production clusters
- Configured with `--authorization-mode=RBAC`
- Controls access based on roles bound to users, groups, or service accounts

#### Node Authorization
- Special-purpose authorizer for kubelet requests
- Configured with `--authorization-mode=Node`
- Limits kubelet to accessing only resources related to its own node

#### Webhook Authorization
- External HTTP callback for authorization decisions
- Useful for integration with external policy engines
- Configured with `--authorization-mode=Webhook`

#### Always Use Multiple Modes
- Recommended: `--authorization-mode=Node,RBAC`
- Modes are evaluated in order; if one denies, the next is checked
- Never use `--authorization-mode=AlwaysAllow` in production

### API Server Hardening Flags

**Critical Security Flags:**
```
--anonymous-auth=false              # Disable anonymous requests
--enable-admission-plugins=...       # Enable required admission controllers
--audit-policy-file=/path/to/policy  # Enable audit logging
--encryption-provider-config=/path   # Enable secrets encryption
--profiling=false                    # Disable profiling endpoint
--insecure-port=0                    # Disable insecure port (deprecated but check)
--kubelet-certificate-authority=...  # Verify kubelet serving certificates
```

## RBAC Deep Dive

**[📖 Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)** - Complete RBAC reference

### Role and ClusterRole

**Role** - Namespace-scoped permissions:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: app
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
- apiGroups: [""]
  resources: ["pods/log"]
  verbs: ["get"]
```

**ClusterRole** - Cluster-wide permissions:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: node-reader
rules:
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["get", "list", "watch"]
```

### API Groups Reference

| Resource | API Group | Common Verbs |
|----------|-----------|-------------|
| pods, services, secrets, configmaps | `""` (core) | get, list, create, update, delete |
| deployments, replicasets, daemonsets | `apps` | get, list, create, update, delete, patch |
| ingresses, networkpolicies | `networking.k8s.io` | get, list, create, update, delete |
| roles, rolebindings | `rbac.authorization.k8s.io` | get, list, create, bind |
| clusterroles, clusterrolebindings | `rbac.authorization.k8s.io` | get, list, create, bind |

### RBAC Escalation Prevention

Kubernetes prevents privilege escalation through RBAC:
- Users can only create/update roles with permissions they already have
- `bind` verb on roles is required to create bindings to a role
- `escalate` verb is required to grant permissions you do not have
- These checks prevent a user from granting themselves more access

**[📖 RBAC Good Practices](https://kubernetes.io/docs/concepts/security/rbac-good-practices/)** - Security recommendations for RBAC

### Auditing RBAC

```bash
# List all ClusterRoleBindings with cluster-admin role
kubectl get clusterrolebindings -o json | jq '.items[] | select(.roleRef.name=="cluster-admin") | .metadata.name'

# Check what a service account can do
kubectl auth can-i --list --as=system:serviceaccount:default:my-sa

# Check specific permission
kubectl auth can-i create deployments --as=system:serviceaccount:app:developer -n app

# Find all subjects with cluster-admin
kubectl get clusterrolebindings -o wide | grep cluster-admin
```

## Service Account Security

**[📖 Service Accounts](https://kubernetes.io/docs/concepts/security/service-accounts/)** - Service account management
**[📖 Configure Service Accounts for Pods](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)** - Pod-level service account configuration

### Default Service Account Risks
- Every namespace has a `default` service account
- Pods automatically mount the default service account token
- Default service account often has more permissions than needed
- Token auto-mounting provides API access from every pod

### Hardening Service Accounts

**Disable Token Automounting:**
```yaml
# On the ServiceAccount
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-sa
  namespace: app
automountServiceAccountToken: false

# Or on the Pod (overrides SA setting)
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  serviceAccountName: my-sa
  automountServiceAccountToken: false
```

**Create Dedicated Service Accounts:**
```bash
# Create per-workload service account
kubectl create sa app-sa -n app

# Bind minimal role
kubectl create role app-role --verb=get,list --resource=configmaps -n app
kubectl create rolebinding app-binding --role=app-role --serviceaccount=app:app-sa -n app
```

### Projected Service Account Tokens

- Bound to specific audience (API server, external service)
- Time-limited (default 1 hour, auto-refreshed)
- Bound to the pod - token is invalidated when pod is deleted
- More secure than legacy non-expiring tokens

## Admission Controllers

**[📖 Admission Controllers Reference](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)** - Complete list of admission controllers

### Key Admission Controllers for CKS

| Controller | Purpose |
|-----------|---------|
| `PodSecurity` | Enforces Pod Security Standards |
| `NodeRestriction` | Limits kubelet to modifying its own node and pods |
| `ImagePolicyWebhook` | External image policy validation |
| `ValidatingAdmissionWebhook` | Custom validation (used by Gatekeeper) |
| `MutatingAdmissionWebhook` | Custom mutation (used by Istio sidecar injection) |

### Enabling Admission Controllers
```
# In API server manifest
--enable-admission-plugins=NodeRestriction,PodSecurity,ServiceAccount
```

## Kubernetes Version Upgrades

**[📖 Upgrading kubeadm clusters](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)** - Step-by-step upgrade process

### Upgrade Process
1. Upgrade kubeadm on control plane node
2. Run `kubeadm upgrade plan` to check available versions
3. Run `kubeadm upgrade apply v1.XX.Y` on control plane
4. Drain worker nodes one at a time
5. Upgrade kubelet and kubectl on each node
6. Uncordon nodes to resume scheduling

### Version Skew Policy
- kubelet can be up to 2 minor versions behind API server
- kubectl can be 1 minor version ahead or behind API server
- Always upgrade control plane before worker nodes
- Never skip minor versions during upgrades

## Key Takeaways

1. **API Server** - Secure with proper authentication, authorization, and admission control
2. **RBAC** - Always use least privilege; audit regularly for excessive permissions
3. **Service Accounts** - Disable token automounting; create dedicated SAs per workload
4. **Admission Controllers** - Enable NodeRestriction, PodSecurity, and webhook controllers
5. **Upgrades** - Keep clusters updated; follow version skew policy
6. **Audit** - Use `kubectl auth can-i` to verify permissions are correct
