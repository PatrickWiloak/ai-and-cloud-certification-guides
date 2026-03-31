# Security & RBAC

## Overview

RBAC is part of the Cluster Architecture domain (25%), but security concepts also appear in Troubleshooting and Services & Networking domains. RBAC configuration is one of the most commonly tested topics on the CKA exam.

**[Authorization Overview](https://kubernetes.io/docs/reference/access-authn-authz/authorization/)** - Kubernetes authorization mechanisms

## RBAC (Role-Based Access Control)

RBAC uses four API objects to control access to Kubernetes resources: Role, ClusterRole, RoleBinding, and ClusterRoleBinding.

### How RBAC Works

1. A **Subject** (user, group, or service account) wants to perform an action
2. The API server checks if a **RoleBinding** or **ClusterRoleBinding** links the subject to a **Role** or **ClusterRole**
3. The Role/ClusterRole defines what actions (verbs) are allowed on which resources
4. If no binding grants the permission, the request is denied (deny by default)

### Roles (Namespace-Scoped)

Roles grant permissions within a specific namespace.

```bash
# Create a role imperatively
kubectl create role pod-reader \
  --verb=get,list,watch \
  --resource=pods \
  --namespace=development
```

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: development
rules:
- apiGroups: [""]          # "" = core API group
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["pods/log"]
  verbs: ["get"]
```

### ClusterRoles (Cluster-Scoped)

ClusterRoles grant permissions cluster-wide or across all namespaces.

```bash
# Create a cluster role imperatively
kubectl create clusterrole node-reader \
  --verb=get,list,watch \
  --resource=nodes
```

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: node-reader
rules:
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["persistentvolumes"]
  verbs: ["get", "list"]
```

**Use ClusterRoles for:**
- Cluster-scoped resources (nodes, PVs, namespaces)
- Non-resource endpoints (`/healthz`, `/api`)
- Namespace resources across all namespaces (when used with ClusterRoleBinding)
- Reusable role templates (bind in different namespaces with RoleBindings)

### Common Verbs

| Verb | HTTP Method | Description |
|------|-------------|-------------|
| `get` | GET | Read a single resource |
| `list` | GET | List multiple resources |
| `watch` | GET (streaming) | Watch for changes |
| `create` | POST | Create a resource |
| `update` | PUT | Replace a resource |
| `patch` | PATCH | Partially modify a resource |
| `delete` | DELETE | Delete a resource |
| `deletecollection` | DELETE | Delete multiple resources |

### Common API Groups

| Group | Resources |
|-------|-----------|
| `""` (core) | pods, services, configmaps, secrets, nodes, PVs, PVCs, namespaces |
| `apps` | deployments, replicasets, statefulsets, daemonsets |
| `batch` | jobs, cronjobs |
| `networking.k8s.io` | networkpolicies, ingresses |
| `rbac.authorization.k8s.io` | roles, clusterroles, rolebindings, clusterrolebindings |
| `storage.k8s.io` | storageclasses |

### RoleBindings (Namespace-Scoped)

RoleBindings grant the permissions defined in a Role to a subject within a namespace.

```bash
# Bind a role to a user
kubectl create rolebinding pod-reader-binding \
  --role=pod-reader \
  --user=jane \
  --namespace=development

# Bind a role to a service account
kubectl create rolebinding pod-reader-sa \
  --role=pod-reader \
  --serviceaccount=development:my-sa \
  --namespace=development

# Bind a ClusterRole within a namespace (reusable pattern)
kubectl create rolebinding pod-reader-binding \
  --clusterrole=pod-reader \
  --user=jane \
  --namespace=development
```

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-reader-binding
  namespace: development
subjects:
- kind: User
  name: jane
  apiGroup: rbac.authorization.k8s.io
- kind: ServiceAccount
  name: my-sa
  namespace: development
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

### ClusterRoleBindings (Cluster-Scoped)

ClusterRoleBindings grant ClusterRole permissions cluster-wide.

```bash
# Bind a ClusterRole to a user cluster-wide
kubectl create clusterrolebinding node-reader-binding \
  --clusterrole=node-reader \
  --user=jane

# Bind to a group
kubectl create clusterrolebinding admin-binding \
  --clusterrole=cluster-admin \
  --group=admins
```

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: node-reader-binding
subjects:
- kind: User
  name: jane
  apiGroup: rbac.authorization.k8s.io
- kind: Group
  name: devops-team
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: node-reader
  apiGroup: rbac.authorization.k8s.io
```

### RBAC Binding Matrix

| Binding Type | Role Type | Scope |
|-------------|-----------|-------|
| RoleBinding | Role | Single namespace |
| RoleBinding | ClusterRole | Single namespace (limits ClusterRole to namespace) |
| ClusterRoleBinding | ClusterRole | All namespaces / cluster-wide |
| ClusterRoleBinding | Role | NOT valid - will not work |

### Testing Permissions

```bash
# Check if current user can perform an action
kubectl auth can-i create deployments
kubectl auth can-i delete pods --namespace=production

# Check as a specific user
kubectl auth can-i create pods --as=jane
kubectl auth can-i list secrets --as=jane --namespace=development

# Check as a service account
kubectl auth can-i get pods --as=system:serviceaccount:default:my-sa

# List all permissions for a user (whoami equivalent)
kubectl auth can-i --list --as=jane
```

**[RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)** - Complete RBAC documentation
**[Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)** - Detailed reference

## Service Accounts

Service accounts provide an identity for processes running in pods to interact with the Kubernetes API.

### Key Facts
- Every namespace has a `default` service account
- Pods use the `default` service account unless specified otherwise
- Service account tokens are automatically mounted at `/var/run/secrets/kubernetes.io/serviceaccount/`
- Kubernetes 1.24+ no longer auto-creates long-lived tokens for service accounts

### Managing Service Accounts

```bash
# Create a service account
kubectl create serviceaccount my-sa

# View service accounts
kubectl get serviceaccounts

# Create a token for a service account (Kubernetes 1.24+)
kubectl create token my-sa
```

### Using Service Accounts in Pods

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app
spec:
  serviceAccountName: my-sa
  automountServiceAccountToken: true  # Default is true
  containers:
  - name: app
    image: myapp:1.0
```

### Disabling Auto-Mounting

```yaml
# At the service account level
apiVersion: v1
kind: ServiceAccount
metadata:
  name: no-auto-mount-sa
automountServiceAccountToken: false

# At the pod level
spec:
  automountServiceAccountToken: false
```

**[Service Accounts](https://kubernetes.io/docs/concepts/security/service-accounts/)** - Service account concepts
**[Managing Service Accounts](https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin/)** - Admin guide
**[Configure Service Accounts for Pods](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)** - Pod configuration

## Security Contexts

Security contexts define privilege and access control settings for pods and containers.

### Pod-Level Security Context

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
    fsGroup: 2000
    runAsNonRoot: true
  containers:
  - name: app
    image: myapp:1.0
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities:
        drop:
        - ALL
        add:
        - NET_BIND_SERVICE
```

### Key Security Context Fields

**Pod Level:**
- `runAsUser` - UID to run all containers
- `runAsGroup` - GID for all containers
- `fsGroup` - GID for volume ownership
- `runAsNonRoot` - prevent running as root
- `supplementalGroups` - additional GIDs

**Container Level:**
- `allowPrivilegeEscalation` - prevent gaining more privileges than parent
- `readOnlyRootFilesystem` - make root filesystem read-only
- `capabilities` - add or drop Linux capabilities
- `privileged` - run container in privileged mode (dangerous)
- `seccompProfile` - Seccomp security profile

**[Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)** - Security context configuration
**[Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)** - Security profiles

## Network Policies for Pod Isolation

Network Policies are covered in detail in `03-services-networking.md`, but from a security perspective, key patterns include:

### Zero-Trust Namespace Isolation

```yaml
# Deny all traffic in the namespace
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
  namespace: production
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
---
# Then explicitly allow required traffic
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns
  namespace: production
spec:
  podSelector: {}
  policyTypes:
  - Egress
  egress:
  - to: []
    ports:
    - protocol: UDP
      port: 53
    - protocol: TCP
      port: 53
```

**[Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)** - Network Policy documentation

## Certificate Management

Kubernetes uses TLS certificates extensively for component communication.

### Certificate Locations

| Component | Certificate | Key |
|-----------|------------|-----|
| API Server | `/etc/kubernetes/pki/apiserver.crt` | `/etc/kubernetes/pki/apiserver.key` |
| API Server (client to etcd) | `/etc/kubernetes/pki/apiserver-etcd-client.crt` | `/etc/kubernetes/pki/apiserver-etcd-client.key` |
| etcd | `/etc/kubernetes/pki/etcd/server.crt` | `/etc/kubernetes/pki/etcd/server.key` |
| etcd CA | `/etc/kubernetes/pki/etcd/ca.crt` | `/etc/kubernetes/pki/etcd/ca.key` |
| Cluster CA | `/etc/kubernetes/pki/ca.crt` | `/etc/kubernetes/pki/ca.key` |
| kubelet | Varies by setup | Varies by setup |

### Checking Certificate Expiration

```bash
# Check API server certificate
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout | grep -A2 Validity

# Check all kubeadm certificates
kubeadm certs check-expiration

# Renew all certificates
kubeadm certs renew all
```

### Certificate Signing Requests (CSR)

For creating new user certificates:

```bash
# 1. Generate a private key
openssl genrsa -out jane.key 2048

# 2. Create a CSR
openssl req -new -key jane.key -out jane.csr -subj "/CN=jane/O=developers"

# 3. Create a Kubernetes CSR object
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: jane
spec:
  request: $(cat jane.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF

# 4. Approve the CSR
kubectl certificate approve jane

# 5. Get the signed certificate
kubectl get csr jane -o jsonpath='{.status.certificate}' | base64 -d > jane.crt
```

**[Certificates](https://kubernetes.io/docs/setup/best-practices/certificates/)** - Certificate management
**[Certificate Signing Requests](https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/)** - CSR documentation
**[kubeadm certs](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-certs/)** - Certificate management with kubeadm

## Key Exam Tips for This Domain

1. **RBAC tasks are very common** - practice creating roles, cluster roles, and bindings imperatively
2. **Use `kubectl auth can-i`** to verify permissions before and after RBAC changes
3. **Remember the binding matrix** - RoleBinding + ClusterRole limits the ClusterRole to one namespace
4. **Know common API groups** - `""` for core, `apps` for deployments, `batch` for jobs
5. **Service accounts** follow the format `system:serviceaccount:<namespace>:<name>` in subject references
6. **Security contexts** at the container level override pod-level settings
7. **Certificate paths** - know where to find etcd and API server certificates
8. **CSR workflow** - generate key, create CSR, submit, approve, retrieve certificate
