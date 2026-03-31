# Kubernetes and Cloud Native Security Associate (KCSA) Fact Sheet

## Exam Overview

**Exam Code:** KCSA
**Exam Name:** Kubernetes and Cloud Native Security Associate
**Duration:** 90 minutes
**Format:** Multiple choice (60 questions)
**Passing Score:** 75%
**Cost:** $250 USD (includes one free retake)
**Valid For:** 3 years
**Delivery:** Online proctored via PSI
**Prerequisites:** None (KCNA recommended)

**[📖 Official KCSA Exam Page](https://training.linuxfoundation.org/certification/kubernetes-and-cloud-native-security-associate-kcsa/)** - Registration and exam details
**[📖 KCSA Exam Curriculum](https://github.com/cncf/curriculum)** - Official exam objectives and domains
**[📖 CNCF Certification FAQ](https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks)** - Frequently asked questions

## Target Audience

This certification is designed for:
- Security-conscious developers working with Kubernetes
- DevOps engineers building secure cloud native platforms
- Security analysts evaluating Kubernetes security posture
- IT professionals pursuing the CKS and wanting a stepping stone
- Compliance officers overseeing containerized environments

**[📖 Cloud Native Security Overview](https://kubernetes.io/docs/concepts/security/overview/)** - The 4C's of cloud native security
**[📖 Kubernetes Security Documentation](https://kubernetes.io/docs/concepts/security/)** - Security concepts

## Exam Domains

### Domain 1: Overview of Cloud Native Security (14%)

This domain covers the foundational security model for cloud native environments.

#### 1.1 The 4C's of Cloud Native Security

**Layers (outside in):**
- **Cloud**: Infrastructure security - IAM, network controls, encryption, shared responsibility
- **Cluster**: Kubernetes security - API server, RBAC, network policies, audit logging
- **Container**: Image security - minimal images, scanning, runtime isolation, read-only filesystem
- **Code**: Application security - input validation, dependency management, secure communication

Each layer builds on the security of the layer beneath it. A weakness at any layer compromises the layers above.

**[📖 Cloud Native Security](https://kubernetes.io/docs/concepts/security/overview/)** - 4C's model explained

#### 1.2 Security Principles

**Key Principles:**
- **Least Privilege**: Grant only the minimum permissions needed
- **Defense in Depth**: Multiple layers of security controls
- **Zero Trust**: Never trust, always verify - authenticate and authorize every request
- **Shift Left**: Integrate security early in the development lifecycle
- **Immutability**: Do not modify running infrastructure - replace it

**[📖 Securing a Cluster](https://kubernetes.io/docs/tasks/administer-cluster/securing-a-cluster/)** - Cluster security best practices

### Domain 2: Kubernetes Cluster Component Security (22%)

This domain covers securing the core Kubernetes components.

#### 2.1 API Server Security

**Authentication Methods:**
- X.509 client certificates (most common for cluster components)
- Bearer tokens and service account tokens
- OpenID Connect (OIDC) for external identity providers
- Webhook token authentication

**Authorization Modes:**
- RBAC (standard for production)
- Node (restricts kubelet access)
- Webhook (external authorization)
- ABAC (legacy, not recommended)

**Admission Control:**
- Validating and mutating admission webhooks
- Built-in controllers (PodSecurity, LimitRanger, ResourceQuota)
- OPA Gatekeeper for custom policy enforcement

**[📖 Controlling Access](https://kubernetes.io/docs/concepts/security/controlling-access/)** - Authentication, authorization, admission
**[📖 Admission Controllers](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)** - Built-in admission controllers

#### 2.2 etcd Security

**Key Concerns:**
- etcd stores all cluster state - including Secrets in plain text by default
- Must enable encryption at rest (EncryptionConfiguration)
- TLS required for client-to-server and peer-to-peer communication
- Access should be restricted to the API server only
- Regular backups are essential for disaster recovery

**[📖 Encrypting Data at Rest](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/)** - etcd encryption configuration

#### 2.3 kubelet Security

**Key Settings:**
- Disable anonymous authentication (`--anonymous-auth=false`)
- Enable webhook authorization (`--authorization-mode=Webhook`)
- Restrict read-only port (`--read-only-port=0`)
- Enable certificate rotation
- Protect the kubelet API endpoint

#### 2.4 CIS Kubernetes Benchmark

**Key Facts:**
- Industry-standard security configuration guide for Kubernetes
- Covers control plane, worker nodes, policies, and managed services
- kube-bench automates benchmark assessment
- Categories: Control Plane Components, etcd, Control Plane Configuration, Worker Nodes, Policies

**[📖 CIS Benchmarks](https://www.cisecurity.org/benchmark/kubernetes)** - CIS Kubernetes Benchmark
**[📖 kube-bench](https://github.com/aquasecurity/kube-bench)** - Automated CIS benchmark tool

### Domain 3: Kubernetes Security Fundamentals (22%)

This domain covers the native security mechanisms in Kubernetes.

#### 3.1 RBAC

**Components:**
| Resource | Scope | Purpose |
|----------|-------|---------|
| Role | Namespace | Defines permissions within a namespace |
| ClusterRole | Cluster | Defines permissions cluster-wide |
| RoleBinding | Namespace | Binds Role/ClusterRole to subjects in a namespace |
| ClusterRoleBinding | Cluster | Binds ClusterRole to subjects cluster-wide |

**Best Practices:**
- Follow least privilege - avoid wildcards (*) for verbs and resources
- Use namespace-scoped Roles over ClusterRoles when possible
- Never bind cluster-admin to service accounts
- Regularly audit RBAC bindings

**[📖 RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)** - RBAC configuration reference
**[📖 RBAC Good Practices](https://kubernetes.io/docs/concepts/security/rbac-good-practices/)** - Security recommendations

#### 3.2 Pod Security Standards

**PSA Levels:**
| Level | Description |
|-------|-------------|
| Privileged | Unrestricted, allows all capabilities |
| Baseline | Prevents known privilege escalations |
| Restricted | Heavily restricted, current hardening best practices |

**PSA Modes:**
| Mode | Behavior |
|------|----------|
| enforce | Rejects violating pods |
| audit | Logs violations but allows pods |
| warn | Shows warnings but allows pods |

**[📖 Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)** - PSA level definitions
**[📖 Pod Security Admission](https://kubernetes.io/docs/concepts/security/pod-security-admission/)** - PSA configuration

#### 3.3 Network Policies

**Key Concepts:**
- Control pod-to-pod traffic at the network level
- Default-deny policies for defense in depth
- Label-based selection of pods and namespaces
- Require a CNI plugin that supports NetworkPolicy (Calico, Cilium)
- Policy types: Ingress, Egress, or both

**[📖 Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)** - NetworkPolicy documentation

#### 3.4 Service Account Security

**Key Concepts:**
- Disable automatic token mounting (`automountServiceAccountToken: false`)
- Create dedicated service accounts per workload
- Use projected (bound) service account tokens
- Minimize permissions on service accounts
- Default service account should have no additional permissions

**[📖 Service Accounts](https://kubernetes.io/docs/concepts/security/service-accounts/)** - Service account management

#### 3.5 Security Context

**Pod-Level Settings:**
- `runAsUser` / `runAsGroup` - specify UID/GID
- `runAsNonRoot` - prevent running as root
- `fsGroup` - set group ownership on volumes
- `seccompProfile` - system call filtering

**Container-Level Settings:**
- `allowPrivilegeEscalation` - prevent privilege escalation
- `readOnlyRootFilesystem` - prevent writes to container filesystem
- `capabilities` - add or drop Linux capabilities
- `privileged` - run with all host capabilities (avoid)

**[📖 Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)** - Configuring security context

### Domain 4: Kubernetes Threat Model (16%)

This domain covers understanding threats and attack vectors in Kubernetes environments.

#### 4.1 STRIDE Threat Model

| Threat | Description | Kubernetes Example |
|--------|-------------|-------------------|
| Spoofing | Impersonating another entity | Stolen service account token |
| Tampering | Modifying data or code | Container image manipulation |
| Repudiation | Denying actions performed | Missing audit logs |
| Information Disclosure | Exposing sensitive data | Secrets in environment variables |
| Denial of Service | Making service unavailable | Resource exhaustion attack |
| Elevation of Privilege | Gaining unauthorized access | Container escape to host |

#### 4.2 Common Attack Vectors

**External Attacks:**
- Exposed API server without proper authentication
- Vulnerable application in a pod (entry point)
- Exploiting exposed services (NodePort, LoadBalancer)

**Internal Attacks (Lateral Movement):**
- Compromised pod accessing the API server via service account
- Pod-to-pod network access without Network Policies
- Reading Secrets from the API or etcd
- Container escape to host via privileged mode or kernel exploits

**Supply Chain Attacks:**
- Malicious or vulnerable container images
- Compromised dependencies in application code
- Tampered CI/CD pipeline artifacts

### Domain 5: Platform Security (16%)

This domain covers securing the platform infrastructure and container lifecycle.

#### 5.1 Image Security

**Best Practices:**
- Use minimal base images (distroless, scratch, Alpine)
- Scan images for vulnerabilities (Trivy, Grype)
- Sign images with cosign/Sigstore
- Pin image versions (never use `latest`)
- Use private registries with access control

**[📖 Trivy](https://aquasecurity.github.io/trivy/)** - Container vulnerability scanner

#### 5.2 Runtime Security

**Key Tools:**
- **Falco**: Runtime threat detection via syscall monitoring
- **gVisor**: Application-level kernel sandbox
- **Kata Containers**: Lightweight VM isolation
- **seccomp**: System call filtering
- **AppArmor/SELinux**: Mandatory access control

**[📖 Falco](https://falco.org/docs/)** - Runtime security documentation

#### 5.3 Admission Controllers

**Key Controllers:**
- **PodSecurity**: Enforces Pod Security Standards
- **ImagePolicyWebhook**: Controls which images can be deployed
- **OPA Gatekeeper**: Custom policy enforcement using Rego
- **LimitRanger**: Enforces default resource limits
- **ResourceQuota**: Limits resource consumption per namespace

### Domain 6: Compliance and Security Frameworks (10%)

#### 6.1 CIS Kubernetes Benchmark
- Comprehensive security configuration guide
- Automated checking with kube-bench
- Sections cover control plane, worker nodes, and policies
- Regular assessment is part of compliance programs

#### 6.2 NIST Cybersecurity Framework
- Five functions: Identify, Protect, Detect, Respond, Recover
- Maps to Kubernetes security controls at each function
- Widely adopted framework for security programs

#### 6.3 Audit Logging
- Kubernetes audit logs record all API requests
- Audit levels: None, Metadata, Request, RequestResponse
- Critical for compliance evidence and incident investigation
- Should be forwarded to centralized logging systems

**[📖 Auditing](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/)** - Kubernetes audit logging

## Exam Tips

### MCQ Strategy
1. **Focus on the 22% domains** - Cluster Component Security and Security Fundamentals are the highest weighted
2. **Know the 4C's model** - Understand what security controls belong at each layer
3. **Understand RBAC deeply** - Components, best practices, and common mistakes
4. **Study threat modeling** - Know STRIDE and common Kubernetes attack vectors
5. **Know compliance frameworks** - CIS Benchmark categories and NIST functions
6. **Eliminate wrong answers** - Remove options that violate security principles

### Common Pitfalls
- Confusing authentication vs authorization vs admission control
- Not understanding the difference between PSA levels (Privileged vs Baseline vs Restricted)
- Mixing up RBAC scope (Role vs ClusterRole, namespace vs cluster)
- Not knowing which security controls belong to which 4C layer
- Confusing compliance frameworks (CIS vs NIST vs SOC 2)

---

**Key Takeaway:** The KCSA tests your understanding of the Kubernetes security landscape. Know the 4C's model, how RBAC and Pod Security Standards work, common threat vectors, and compliance frameworks. This is conceptual - focus on understanding why each security mechanism exists and when to apply it.
