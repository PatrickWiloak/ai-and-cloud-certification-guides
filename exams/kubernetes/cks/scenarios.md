# CKS High-Yield Scenarios and Patterns

## Scenario 1: NetworkPolicy Isolation

### Problem
A development team reports that pods in the `production` namespace can communicate with pods in the `staging` namespace. You need to isolate the `production` namespace so that only pods within it can communicate with each other, and only the `monitoring` namespace can scrape metrics on port 9090.

### Solution Pattern
- Create a default-deny ingress and egress NetworkPolicy in the `production` namespace
- Add an allow policy for intra-namespace communication
- Add an allow policy for monitoring namespace access on port 9090
- Allow DNS egress (port 53 UDP/TCP) so pods can resolve names

### Key Configuration
```yaml
# Default deny all
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: production
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
---
# Allow intra-namespace + monitoring + DNS
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-production-traffic
  namespace: production
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: production
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: monitoring
    ports:
    - port: 9090
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: production
  - ports:
    - port: 53
      protocol: UDP
    - port: 53
      protocol: TCP
```

### Common Mistakes
- Forgetting to allow DNS egress (pods cannot resolve service names)
- Using podSelector instead of namespaceSelector for cross-namespace rules
- Not setting both Ingress and Egress in policyTypes (only listed types are affected)
- Missing the namespace label on the target namespace

---

## Scenario 2: RBAC Least Privilege

### Problem
A security audit reveals that the `developer` service account in the `app` namespace has `cluster-admin` privileges via a ClusterRoleBinding. You need to replace this with least-privilege access that allows only: listing and getting pods, viewing logs, and creating deployments in the `app` namespace only.

### Solution Pattern
- Remove the overly permissive ClusterRoleBinding
- Create a namespace-scoped Role with only the required permissions
- Create a RoleBinding to bind the Role to the service account
- Verify with `kubectl auth can-i`

### Key Configuration
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: developer-role
  namespace: app
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log"]
  verbs: ["get", "list"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["create"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: developer-binding
  namespace: app
subjects:
- kind: ServiceAccount
  name: developer
  namespace: app
roleRef:
  kind: Role
  name: developer-role
  apiGroup: rbac.authorization.k8s.io
```

### Common Mistakes
- Using ClusterRole instead of Role when namespace scope is sufficient
- Forgetting to specify the correct apiGroup (apps vs core)
- Not specifying `pods/log` as a separate subresource
- Leaving the old ClusterRoleBinding in place after creating the new Role

---

## Scenario 3: Runtime Threat Detection with Falco

### Problem
Containers in the `web` namespace are suspected of being compromised. You need to configure Falco to detect: (1) shell processes spawning inside containers, (2) sensitive file access (/etc/shadow, /etc/passwd), and (3) outbound connections to unexpected ports.

### Solution Pattern
- Install Falco on the cluster nodes
- Create custom Falco rules for the specific detection requirements
- Configure alert output to a log file for analysis
- Monitor and verify alerts are triggered

### Key Configuration
```yaml
# Custom Falco rules
- rule: Shell Spawned in Container
  desc: Detect shell process started in a container
  condition: >
    spawned_process and container and
    proc.name in (bash, sh, zsh, dash, csh) and
    container.image.repository != "excluded-image"
  output: >
    Shell spawned in container
    (user=%user.name container=%container.name
    image=%container.image.repository
    shell=%proc.name parent=%proc.pname)
  priority: WARNING
  tags: [container, shell]

- rule: Sensitive File Access
  desc: Detect read of sensitive files in containers
  condition: >
    open_read and container and
    fd.name in (/etc/shadow, /etc/passwd) and
    container.image.repository != "excluded-image"
  output: >
    Sensitive file opened for reading
    (user=%user.name file=%fd.name
    container=%container.name
    image=%container.image.repository)
  priority: WARNING
  tags: [container, filesystem]
```

### Common Mistakes
- Not understanding Falco condition syntax (fields and macros)
- Confusing priority levels (Emergency, Alert, Critical, Error, Warning, Notice, Info, Debug)
- Not including container condition to limit rules to containers only
- Forgetting to restart Falco after rule changes

---

## Scenario 4: Supply Chain - Image Scanning and Policy

### Problem
Your organization requires that no container image with HIGH or CRITICAL vulnerabilities can be deployed to the cluster. You need to: scan existing images with Trivy, block vulnerable images from being deployed, and ensure only images from approved registries are allowed.

### Solution Pattern
- Use Trivy to scan all currently running images
- Configure an admission controller (OPA Gatekeeper or ImagePolicyWebhook) to block images from unapproved registries
- Set up CI/CD scanning pipeline for pre-deployment checks
- Create Gatekeeper constraint for registry whitelist

### Key Steps
```bash
# Scan images with Trivy
trivy image --severity HIGH,CRITICAL nginx:1.19
trivy image --severity HIGH,CRITICAL myregistry.io/app:v1.2

# Generate scan report
trivy image --format json --output report.json myregistry.io/app:v1.2
```

```yaml
# Gatekeeper ConstraintTemplate for allowed registries
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8sallowedrepos
spec:
  crd:
    spec:
      names:
        kind: K8sAllowedRepos
      validation:
        openAPIV3Schema:
          type: object
          properties:
            repos:
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8sallowedrepos
        violation[{"msg": msg}] {
          container := input.review.object.spec.containers[_]
          satisfied := [good | repo = input.parameters.repos[_]; good = startswith(container.image, repo)]
          not any(satisfied)
          msg := sprintf("container <%v> has an invalid image repo <%v>, allowed repos are %v", [container.name, container.image, input.parameters.repos])
        }
---
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sAllowedRepos
metadata:
  name: prod-repo-restriction
spec:
  match:
    kinds:
    - apiGroups: [""]
      kinds: ["Pod"]
    namespaces: ["production"]
  parameters:
    repos:
    - "myregistry.io/"
    - "gcr.io/my-project/"
```

### Common Mistakes
- Only scanning new images but not existing running images
- Using blocklist approach instead of allowlist for registries
- Not including init containers in admission policy checks
- Forgetting that Gatekeeper constraints need to match the right resource kinds

---

## Scenario 5: Secrets Encryption at Rest

### Problem
A compliance audit requires that all Kubernetes Secrets stored in etcd must be encrypted at rest. Currently, Secrets are stored in plain base64 encoding. You need to enable encryption and verify it is working.

### Solution Pattern
- Create an EncryptionConfiguration file with aescbc or secretbox provider
- Configure the API server to use the encryption configuration
- Verify that new secrets are encrypted
- Re-encrypt existing secrets

### Key Configuration
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
    - identity: {}
```

### Key Steps
```bash
# Generate encryption key
head -c 32 /dev/urandom | base64

# Add to API server manifest
# --encryption-provider-config=/etc/kubernetes/enc/encryption-config.yaml

# Verify encryption
kubectl create secret generic test-secret --from-literal=key=value -n default
# Check etcd directly - should be encrypted
ETCDCTL_API=3 etcdctl get /registry/secrets/default/test-secret \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key | hexdump -C

# Re-encrypt all existing secrets
kubectl get secrets --all-namespaces -o json | kubectl replace -f -
```

### Common Mistakes
- Putting the `identity` provider before `aescbc` (identity means no encryption)
- Forgetting to mount the encryption config file into the API server pod
- Not restarting the API server after configuration changes
- Forgetting to re-encrypt existing secrets (only new secrets use the new config)

---

## Scenario 6: Pod Security Admission Enforcement

### Problem
The security team requires that no privileged containers or containers running as root can be deployed to the `production` namespace. Other namespaces should log violations but not block them. Implement Pod Security Admission to enforce this.

### Solution Pattern
- Label the `production` namespace with PSA enforce at the Restricted level
- Label other application namespaces with audit and warn at Restricted level
- Verify that privileged pods are blocked in production
- Ensure system namespaces are not affected

### Key Configuration
```bash
# Enforce restricted in production
kubectl label namespace production \
  pod-security.kubernetes.io/enforce=restricted \
  pod-security.kubernetes.io/enforce-version=latest

# Audit and warn in staging
kubectl label namespace staging \
  pod-security.kubernetes.io/audit=restricted \
  pod-security.kubernetes.io/audit-version=latest \
  pod-security.kubernetes.io/warn=restricted \
  pod-security.kubernetes.io/warn-version=latest
```

### Common Mistakes
- Applying PSA labels to kube-system namespace (breaks control plane components)
- Not understanding the difference between enforce, audit, and warn modes
- Forgetting that Restricted level requires: non-root, no privilege escalation, seccomp profile, and dropped capabilities
- Not testing pod deployments after applying labels

---

## Scenario 7: Audit Logging Configuration

### Problem
You need to configure Kubernetes audit logging to capture: all requests to Secrets at the RequestResponse level, all write operations (create/update/delete) at the Request level, and metadata for everything else. Exclude health check endpoints.

### Solution Pattern
- Create an audit policy file with ordered rules
- Configure the API server with audit backend settings
- Verify audit logs are being generated
- Set up log rotation

### Key Configuration
```yaml
# /etc/kubernetes/audit/audit-policy.yaml
apiVersion: audit.k8s.io/v1
kind: Policy
omitStages:
  - "RequestReceived"
rules:
  # Don't log health checks
  - level: None
    nonResourceURLs:
    - "/healthz*"
    - "/readyz*"
    - "/livez*"

  # Log secret access at RequestResponse level
  - level: RequestResponse
    resources:
    - group: ""
      resources: ["secrets"]

  # Log write operations at Request level
  - level: Request
    verbs: ["create", "update", "patch", "delete"]
    resources:
    - group: ""
      resources: ["*"]
    - group: "apps"
      resources: ["*"]

  # Log everything else at Metadata level
  - level: Metadata
```

### Common Mistakes
- Not ordering rules correctly (first matching rule applies)
- Forgetting to add volume and volumeMount for audit policy in API server manifest
- Not configuring audit log rotation (logs grow quickly at RequestResponse level)
- Confusing audit levels: None, Metadata, Request, RequestResponse

---

## Scenario 8: AppArmor and Seccomp Hardening

### Problem
A container running an nginx web server needs to be hardened with both AppArmor and seccomp profiles. The AppArmor profile should restrict file writes to only /var/cache/nginx and /var/run. The seccomp profile should use RuntimeDefault.

### Solution Pattern
- Create and load an AppArmor profile on the node
- Apply the AppArmor profile annotation to the pod
- Set seccomp profile in the pod's security context
- Verify both profiles are active

### Key Configuration
```
# AppArmor profile (load on node)
# /etc/apparmor.d/k8s-nginx
#include <tunables/global>

profile k8s-nginx flags=(attach_disconnected) {
  #include <abstractions/base>
  #include <abstractions/nameservice>

  # Allow network access
  network inet tcp,
  network inet udp,

  # Allow reading nginx config and web content
  /etc/nginx/** r,
  /usr/share/nginx/** r,

  # Allow writing to specific directories only
  /var/cache/nginx/** rw,
  /var/run/** rw,

  # Deny everything else by default
  deny /etc/shadow r,
  deny /etc/passwd r,
}
```

```yaml
# Pod spec with AppArmor and seccomp
apiVersion: v1
kind: Pod
metadata:
  name: nginx-hardened
  annotations:
    container.apparmor.security.beta.kubernetes.io/nginx: localhost/k8s-nginx
spec:
  securityContext:
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: nginx
    image: nginx:1.25
    securityContext:
      allowPrivilegeEscalation: false
      runAsNonRoot: true
      runAsUser: 101
      capabilities:
        drop: ["ALL"]
        add: ["NET_BIND_SERVICE"]
```

### Common Mistakes
- Forgetting to load the AppArmor profile on the node before creating the pod
- Using wrong annotation format (must include container name)
- Not checking that AppArmor is enabled on the node (`aa-status`)
- Confusing seccomp profile types: RuntimeDefault vs Localhost vs Unconfined

## Key Decision Factors

### Domain Priority for Study
1. **Supply Chain Security (20%)** - Image scanning, admission control, signing
2. **Minimize Microservice Vulnerabilities (20%)** - PSA, Gatekeeper, Secrets, sandboxes
3. **Monitoring, Logging and Runtime Security (20%)** - Falco, audit logs, immutability
4. **Cluster Hardening (15%)** - RBAC, service accounts, API server
5. **System Hardening (15%)** - AppArmor, seccomp, host OS
6. **Cluster Setup (10%)** - NetworkPolicies, CIS benchmarks, Ingress

### Common Anti-Patterns
- Practicing theory without hands-on (this exam is 100% performance-based)
- Skipping DNS egress rules in NetworkPolicies
- Using overly broad RBAC permissions (wildcards)
- Not verifying work after applying configuration changes
- Spending too long on one task instead of flagging and moving on
- Not familiarizing yourself with kubernetes.io documentation navigation
