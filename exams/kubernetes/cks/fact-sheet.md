# Certified Kubernetes Security Specialist (CKS) Fact Sheet

## Exam Overview

**Exam Code:** CKS
**Exam Name:** Certified Kubernetes Security Specialist
**Duration:** 120 minutes (2 hours)
**Format:** Performance-based (hands-on in live cluster)
**Passing Score:** 67%
**Cost:** $395 USD (includes one free retake)
**Valid For:** 2 years
**Delivery:** Online proctored via PSI
**Prerequisites:** Active CKA certification required

**[📖 Official CKS Exam Page](https://training.linuxfoundation.org/certification/certified-kubernetes-security-specialist/)** - Registration and exam details
**[📖 CKS Exam Curriculum](https://github.com/cncf/curriculum)** - Official exam objectives and domains
**[📖 CNCF Certification FAQ](https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks)** - Frequently asked questions

## Target Audience

This certification is designed for:
- Kubernetes administrators who want to specialize in cluster security
- DevSecOps engineers working with container orchestration
- Security engineers responsible for Kubernetes environments
- Platform engineers building secure multi-tenant clusters
- SREs focused on securing production Kubernetes workloads

**[📖 Kubernetes Security Overview](https://kubernetes.io/docs/concepts/security/)** - Security concepts in Kubernetes
**[📖 Cloud Native Security](https://kubernetes.io/docs/concepts/security/overview/)** - The 4C's of cloud native security

## Exam Domains

### Domain 1: Cluster Setup (10%)

This domain covers the foundational security configuration of Kubernetes clusters.

#### 1.1 Network Security Policies

**Key Concepts:**
- NetworkPolicy resources for controlling pod-to-pod traffic
- Default deny policies for ingress and egress
- Namespace-level network isolation
- Label-based traffic selection and filtering

**[📖 Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)** - NetworkPolicy specification and behavior
**[📖 Declare Network Policy](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy/)** - Creating NetworkPolicy resources
**[📖 Network Policy Recipes](https://github.com/ahmetb/kubernetes-network-policy-recipes)** - Common NetworkPolicy patterns

#### 1.2 CIS Benchmarks

**Key Concepts:**
- CIS Kubernetes Benchmark for component configuration review
- kube-bench tool for automated benchmark assessment
- Remediation of benchmark failures for etcd, kubelet, kubeapi
- Scoring and verification of security posture

**[📖 CIS Benchmarks](https://www.cisecurity.org/benchmark/kubernetes)** - CIS Kubernetes Benchmark documentation
**[📖 kube-bench](https://github.com/aquasecurity/kube-bench)** - Automated CIS benchmark checking tool

#### 1.3 Ingress Security

**Key Concepts:**
- TLS termination at Ingress controllers
- Ingress authentication and authorization
- Rate limiting and WAF integration
- Certificate management for Ingress resources

**[📖 Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)** - Ingress resource specification
**[📖 Ingress TLS](https://kubernetes.io/docs/concepts/services-networking/ingress/#tls)** - TLS configuration for Ingress
**[📖 Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)** - Available Ingress controller implementations

#### 1.4 Node Metadata Protection

**Key Concepts:**
- Cloud provider metadata API restrictions
- NetworkPolicy to block metadata endpoints (169.254.169.254)
- Node-level firewall rules for metadata protection
- Instance metadata service (IMDS) version enforcement

**[📖 Securing a Cluster](https://kubernetes.io/docs/tasks/administer-cluster/securing-a-cluster/)** - Cluster security best practices

### Domain 2: Cluster Hardening (15%)

This domain covers restricting access to the Kubernetes API and minimizing permissions.

#### 2.1 API Server Access Control

**Key Concepts:**
- Authentication methods (certificates, tokens, OIDC)
- Authorization modes (RBAC, ABAC, Webhook, Node)
- Admission controllers and their configuration
- API server flags for security hardening

**[📖 Controlling Access to the API](https://kubernetes.io/docs/concepts/security/controlling-access/)** - Authentication, authorization, admission control
**[📖 API Server Authentication](https://kubernetes.io/docs/reference/access-authn-authz/authentication/)** - Authentication strategies
**[📖 Admission Controllers](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)** - Admission controller reference

#### 2.2 RBAC Configuration

**RBAC Components:**
- Role: Namespace-scoped permissions
- ClusterRole: Cluster-wide permissions
- RoleBinding: Binds Role to subjects in a namespace
- ClusterRoleBinding: Binds ClusterRole to subjects cluster-wide

**Critical RBAC Rules:**
- Never use `*` (wildcard) for verbs or resources in production
- Avoid binding cluster-admin to service accounts
- Use namespace-scoped Roles over ClusterRoles when possible
- Regularly audit RBAC bindings for excessive permissions

**[📖 RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)** - Using RBAC authorization
**[📖 RBAC Good Practices](https://kubernetes.io/docs/concepts/security/rbac-good-practices/)** - RBAC security recommendations

#### 2.3 Service Account Security

**Key Concepts:**
- Disable automatic service account token mounting (`automountServiceAccountToken: false`)
- Create dedicated service accounts per workload
- Minimize service account permissions
- Use projected service account tokens (bound, time-limited)
- Clean up unused service accounts

**[📖 Service Accounts](https://kubernetes.io/docs/concepts/security/service-accounts/)** - Managing service accounts
**[📖 Configure Service Accounts](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)** - Service account configuration

#### 2.4 Kubernetes Upgrades

**Key Concepts:**
- Regular version upgrades to patch security vulnerabilities
- Upgrade path: control plane first, then worker nodes
- Version skew policy between components
- Testing upgrades in non-production environments

**[📖 Upgrading kubeadm Clusters](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)** - Step-by-step upgrade process
**[📖 Version Skew Policy](https://kubernetes.io/releases/version-skew-policy/)** - Component version compatibility

### Domain 3: System Hardening (15%)

This domain covers OS-level and infrastructure security for Kubernetes nodes.

#### 3.1 Host OS Hardening

**Key Concepts:**
- Remove unnecessary packages and services
- Disable unused kernel modules
- Apply security patches regularly
- Minimize installed software on nodes
- Use container-optimized OS distributions

**[📖 Node Security](https://kubernetes.io/docs/concepts/security/hardening-guide/authentication-mechanisms/)** - Node-level security considerations

#### 3.2 AppArmor Profiles

**Key Concepts:**
- AppArmor profile modes: enforce, complain, unconfined
- Loading profiles on nodes before pod scheduling
- Applying AppArmor annotations/fields to pods
- Creating custom AppArmor profiles for workloads

**[📖 AppArmor](https://kubernetes.io/docs/tutorials/security/apparmor/)** - Restricting container access with AppArmor

#### 3.3 Seccomp Profiles

**Key Concepts:**
- Seccomp (Secure Computing Mode) for syscall filtering
- Default, RuntimeDefault, and custom profiles
- Profile types: whitelist (allow) and blacklist (deny)
- Applying seccomp profiles to pods and containers

**[📖 Seccomp](https://kubernetes.io/docs/tutorials/security/seccomp/)** - Restricting syscalls with seccomp
**[📖 Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)** - Seccomp requirements per profile level

#### 3.4 Network Minimization

**Key Concepts:**
- Minimize external access to cluster nodes
- Use bastion hosts for SSH access
- Restrict port exposure on nodes
- Implement host-level firewall rules

### Domain 4: Minimize Microservice Vulnerabilities (20%)

This domain covers securing workloads and managing secrets in Kubernetes.

#### 4.1 Pod Security Admission (PSA)

**PSA Levels:**
- **Privileged:** Unrestricted policy, allows known privilege escalations
- **Baseline:** Minimally restrictive policy, prevents known privilege escalations
- **Restricted:** Heavily restricted policy, follows current pod hardening best practices

**PSA Modes:**
- **enforce:** Policy violations reject the pod
- **audit:** Policy violations are logged but allowed
- **warn:** Policy violations trigger user-facing warnings

**[📖 Pod Security Admission](https://kubernetes.io/docs/concepts/security/pod-security-admission/)** - PSA configuration and enforcement
**[📖 Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)** - Detailed policy definitions
**[📖 Enforce Pod Security Standards](https://kubernetes.io/docs/tasks/configure-pod-container/enforce-standards-namespace-labels/)** - Applying PSA with namespace labels

#### 4.2 OPA Gatekeeper

**Key Concepts:**
- Open Policy Agent for Kubernetes admission control
- Constraint Templates define the policy logic (Rego)
- Constraints apply templates to specific resources
- Common policies: required labels, allowed registries, resource limits

**[📖 OPA Gatekeeper](https://open-policy-agent.github.io/gatekeeper/website/docs/)** - Gatekeeper documentation
**[📖 Gatekeeper Library](https://open-policy-agent.github.io/gatekeeper-library/website/)** - Pre-built constraint templates

#### 4.3 Secrets Management

**Key Concepts:**
- Kubernetes Secrets are base64-encoded, NOT encrypted by default
- Enable encryption at rest with EncryptionConfiguration
- External secret stores: HashiCorp Vault, cloud provider KMS
- Secret rotation strategies
- Avoid mounting secrets as environment variables when possible

**[📖 Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)** - Kubernetes Secret objects
**[📖 Encrypt Secrets at Rest](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/)** - Encrypting data at rest in etcd
**[📖 Good Practices for Secrets](https://kubernetes.io/docs/concepts/security/secrets-good-practices/)** - Secret management recommendations

#### 4.4 Runtime Sandboxes

**Key Concepts:**
- gVisor (runsc) - Application-level kernel that intercepts syscalls
- Kata Containers - Lightweight VMs for container isolation
- RuntimeClass resource for selecting container runtimes
- Use cases: multi-tenant clusters, untrusted workloads

**[📖 Runtime Class](https://kubernetes.io/docs/concepts/containers/runtime-class/)** - Selecting container runtime configurations

#### 4.5 mTLS and Pod-to-Pod Encryption

**Key Concepts:**
- Service mesh implementations (Istio, Linkerd)
- Automatic certificate rotation
- Transparent encryption between pods
- Zero-trust networking principles

### Domain 5: Supply Chain Security (20%)

This domain covers securing the container image supply chain from build to deployment.

#### 5.1 Base Image Security

**Key Concepts:**
- Use minimal base images (distroless, scratch, Alpine)
- Multi-stage Docker builds to reduce image size
- Remove unnecessary tools and packages
- Run as non-root user in Dockerfile
- Pin specific image versions (never use `latest`)

**[📖 Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)** - Docker official best practices

#### 5.2 Image Signing and Verification

**Key Concepts:**
- cosign for signing and verifying container images
- Sigstore project for keyless signing
- Notary for content trust
- ImagePolicyWebhook admission controller
- Supply chain attestation with in-toto/SLSA

**[📖 cosign](https://docs.sigstore.dev/cosign/overview/)** - Container image signing tool
**[📖 ImagePolicyWebhook](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#imagepolicywebhook)** - Image policy admission controller

#### 5.3 Static Analysis

**Key Concepts:**
- kubesec for Kubernetes manifest security scanning
- conftest for policy testing against configurations
- checkov for infrastructure-as-code scanning
- Dockerfile linting with hadolint
- YAML validation for security misconfigurations

**[📖 kubesec](https://kubesec.io/)** - Security risk analysis for Kubernetes resources

#### 5.4 Vulnerability Scanning

**Key Concepts:**
- Trivy for comprehensive vulnerability scanning
- Grype for container image vulnerability analysis
- Scanning in CI/CD pipelines (shift-left security)
- CVE databases and vulnerability feeds
- Image allowlisting and blocklisting

**[📖 Trivy](https://aquasecurity.github.io/trivy/)** - Vulnerability scanner documentation

### Domain 6: Monitoring, Logging and Runtime Security (20%)

This domain covers detecting threats, analyzing attacks, and maintaining audit trails.

#### 6.1 Falco Runtime Security

**Key Concepts:**
- Falco rules for detecting abnormal behavior
- System call monitoring at the kernel level
- Default rule sets for common threats
- Custom Falco rules for specific detection needs
- Alert output channels (syslog, files, HTTP, gRPC)

**[📖 Falco](https://falco.org/docs/)** - Falco runtime security documentation
**[📖 Falco Rules](https://falco.org/docs/rules/)** - Writing and managing Falco rules
**[📖 Default Falco Rules](https://falco.org/docs/rules/default-rules/)** - Pre-built detection rules

#### 6.2 Container Immutability

**Key Concepts:**
- Read-only root filesystem (`readOnlyRootFilesystem: true`)
- Use emptyDir or tmpfs for writable temporary storage
- Prevent container image modification at runtime
- startupProbe and livenessProbe for runtime validation
- Immutable ConfigMaps and Secrets

**[📖 Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)** - Configuring security context for pods

#### 6.3 Kubernetes Audit Logging

**Key Concepts:**
- Audit policy levels: None, Metadata, Request, RequestResponse
- Audit policy rules for filtering events
- Audit backends: log file, webhook
- Analyzing audit logs for security incidents
- Configuring audit log rotation and retention

**[📖 Auditing](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/)** - Kubernetes audit logging
**[📖 Audit Policy](https://kubernetes.io/docs/reference/config-api/apiserver-audit.v1/)** - Audit policy API reference

#### 6.4 Threat Detection and Investigation

**Key Concepts:**
- Detecting privilege escalation attempts
- Identifying unauthorized API access patterns
- Container escape detection
- Cryptocurrency mining detection
- Lateral movement identification
- Forensic analysis of compromised containers

## Exam Tips

### Performance-Based Exam Strategy
1. **Speed is critical** - Practice until commands are muscle memory
2. **Use the docs** - kubernetes.io is allowed; bookmark key pages
3. **Imperative commands first** - Use `kubectl create` and `kubectl run` when faster than writing YAML
4. **Verify every task** - Always confirm your changes work before moving on
5. **Time management** - If stuck for more than 5 minutes, flag and move on
6. **Know your tools** - Be fluent with kubectl, vim/nano, systemctl, and crictl

### Key kubectl Commands for CKS
```
kubectl auth can-i --list --as=system:serviceaccount:namespace:sa-name
kubectl get networkpolicy -A
kubectl describe clusterrolebinding cluster-admin
kubectl logs -n kube-system kube-apiserver-controlplane
kubectl exec -it pod-name -- sh
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl api-resources --verbs=list --namespaced
```

### Common Pitfalls
- Forgetting to apply changes after editing static pod manifests (kubelet auto-restarts)
- Not testing NetworkPolicies from the correct source pod
- Incorrectly scoping RBAC (namespace vs cluster level)
- Missing the `automountServiceAccountToken: false` field
- Not restarting kubelet after configuration changes
- Forgetting to label namespaces for Pod Security Admission

### Documentation Pages to Bookmark
- **[📖 kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)** - Quick reference for kubectl
- **[📖 Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)** - Pod and container security settings
- **[📖 Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)** - NetworkPolicy examples
- **[📖 RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)** - RBAC configuration reference
- **[📖 Audit Logging](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/)** - Audit policy configuration
- **[📖 Secrets Encryption](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/)** - EncryptionConfiguration

---

**Key Takeaway:** The CKS exam tests your ability to secure a Kubernetes cluster end-to-end. You need hands-on fluency with security tools, RBAC, NetworkPolicies, admission controllers, runtime security, and supply chain security. Practice in real clusters until every task type feels routine.
