# Kubernetes Threat Model

**[📖 Kubernetes Threat Model](https://microsoft.github.io/Threat-Matrix-for-Kubernetes/)** - Microsoft's Threat Matrix for Kubernetes

## STRIDE Threat Model

STRIDE is a widely used threat modeling framework. Applied to Kubernetes, it identifies threats across six categories.

### Spoofing (Identity)
Pretending to be another entity to gain unauthorized access.

**Kubernetes Examples:**
- Stolen or leaked service account tokens used to access the API server
- Forged client certificates for API authentication
- DNS spoofing to redirect pod traffic to malicious services
- Impersonating another user via stolen OIDC tokens

**Mitigations:**
- Short-lived, bound service account tokens
- Certificate rotation and revocation
- OIDC authentication with MFA
- Disable anonymous API server authentication
- Network Policies to restrict DNS access

### Tampering (Integrity)
Unauthorized modification of data, code, or configuration.

**Kubernetes Examples:**
- Pushing a malicious image to a container registry
- Modifying ConfigMaps or Secrets via compromised service account
- Altering pod specifications to inject malicious containers
- Modifying etcd data directly

**Mitigations:**
- Image signing with cosign and verification on deployment
- RBAC restricting write access to critical resources
- Admission controllers validating resource specifications
- etcd access restricted to API server only
- Immutable ConfigMaps and container filesystems

### Repudiation (Accountability)
Denying that an action was performed, or lack of evidence.

**Kubernetes Examples:**
- API server requests with no audit logging enabled
- Deletion of pods or resources with no record
- Changes to RBAC policies without tracking

**Mitigations:**
- Enable Kubernetes audit logging
- Forward audit logs to a centralized, tamper-proof system
- Log at appropriate levels (Metadata for most, RequestResponse for Secrets)
- Cloud provider audit trails (CloudTrail, Cloud Audit Logs)

### Information Disclosure (Confidentiality)
Exposing sensitive data to unauthorized parties.

**Kubernetes Examples:**
- Reading Secrets from the API (insufficient RBAC)
- Accessing etcd directly to read stored Secrets
- Environment variables exposing sensitive data in pod specs
- Container logs containing sensitive information
- Cloud metadata API access from pods (instance credentials)

**Mitigations:**
- RBAC restricting access to Secrets
- Encryption at rest for etcd
- Mount Secrets as files instead of environment variables
- Network Policies blocking metadata endpoints (169.254.169.254)
- External secret management (Vault, cloud KMS)

### Denial of Service (Availability)
Making the service or cluster unavailable.

**Kubernetes Examples:**
- Pod without resource limits consuming all node CPU/memory
- Excessive API server requests overwhelming the control plane
- Fork bomb in a container without PID limits
- Network flooding between pods

**Mitigations:**
- Resource requests and limits on all containers
- LimitRange and ResourceQuota per namespace
- API server rate limiting
- Pod disruption budgets for availability
- Horizontal Pod Autoscaler for demand response

### Elevation of Privilege (Authorization)
Gaining higher access than intended.

**Kubernetes Examples:**
- Container escape to host via privileged mode
- Exploiting kernel vulnerabilities from a container
- Using hostPath volumes to access host filesystem
- Mounting the Docker socket or container runtime socket
- Exploiting overly permissive RBAC bindings

**Mitigations:**
- Pod Security Admission at Restricted level
- Drop all capabilities, add only what is needed
- No privileged containers, no hostPID, no hostNetwork
- Container runtime sandboxes (gVisor, Kata)
- seccomp and AppArmor profiles
- Regular RBAC audits

## Common Attack Vectors

### External to Cluster
1. **Exposed API Server**: API server accessible from the internet without proper auth
2. **Vulnerable Application**: Exploiting a web application to gain initial access to a pod
3. **Exposed Services**: NodePort or LoadBalancer exposing internal services unnecessarily
4. **Supply Chain**: Deploying a malicious or vulnerable container image

### Pod to Cluster (Lateral Movement)
1. **Service Account Abuse**: Using the pod's service account token to query the API server
2. **Secret Discovery**: Reading Secrets from the API using the pod's permissions
3. **Network Exploration**: Scanning the cluster network from a compromised pod
4. **DNS Enumeration**: Querying CoreDNS to discover other services

### Container to Host (Escape)
1. **Privileged Container**: Container with privileged flag can access host resources
2. **Kernel Exploit**: Exploiting a kernel vulnerability from within a container
3. **hostPath Mount**: Accessing the host filesystem via hostPath volumes
4. **Runtime Socket**: Accessing the container runtime socket to create new containers on the host

## Trust Boundaries

### Namespace Boundary
- Namespaces provide logical isolation (not security isolation by default)
- RBAC and Network Policies are needed to enforce namespace boundaries
- PSA levels can differ per namespace
- Cross-namespace access should be explicitly controlled

### Node Boundary
- Containers on the same node share the host kernel
- Container escape compromises the node and all pods on it
- Node-level security (AppArmor, seccomp) provides additional isolation
- Runtime sandboxes (gVisor) provide stronger isolation than default containers

### Cluster Boundary
- The cluster boundary separates the Kubernetes environment from external networks
- API server access control is the primary cluster boundary control
- Network-level controls (firewalls, security groups) protect the cluster perimeter
- Ingress controllers mediate external access to cluster services

## Threat Modeling Methodology

### Step 1: Identify Assets
- What are we protecting? (data, services, infrastructure)
- Where is sensitive data stored and processed?
- What are the critical services?

### Step 2: Map Data Flows
- How does data flow through the system?
- What are the communication paths between components?
- Where does data cross trust boundaries?

### Step 3: Identify Threats (STRIDE)
- Apply each STRIDE category to each component and data flow
- Consider external and internal threat actors
- Document threat scenarios

### Step 4: Evaluate and Prioritize
- Assess likelihood and impact of each threat
- Prioritize based on risk (high likelihood + high impact first)
- Consider existing controls and their effectiveness

### Step 5: Mitigate
- Apply appropriate Kubernetes security controls
- Defense in depth - multiple controls per threat
- Verify mitigations are effective
- Document residual risk
