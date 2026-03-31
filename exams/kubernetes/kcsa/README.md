# Kubernetes and Cloud Native Security Associate (KCSA)

## Exam Overview

The Kubernetes and Cloud Native Security Associate (KCSA) certification demonstrates a candidate's foundational knowledge of security concepts and best practices in Kubernetes and cloud native environments. This is a knowledge-based exam that validates understanding of the security landscape without requiring hands-on tasks. It bridges the gap between KCNA and CKS, making it ideal for those who want to demonstrate security awareness before pursuing the hands-on CKS certification.

**Exam Details:**
- **Exam Code:** KCSA
- **Duration:** 90 minutes
- **Number of Questions:** 60 multiple choice questions
- **Passing Score:** 75%
- **Cost:** $250 USD (includes one free retake)
- **Delivery:** Online proctored via PSI
- **Validity:** 3 years
- **Prerequisites:** None (KCNA recommended but not required)
- **Format:** Multiple choice only - no hands-on component

**Important:** This is a knowledge-based exam. Unlike CKS, there are no hands-on tasks. Focus on understanding security concepts, threat models, compliance frameworks, and the 4C's of cloud native security.

## Exam Domains

### Domain 1: Overview of Cloud Native Security (14%)
Understanding security principles and the layered security model for cloud native environments.

- The 4C's of cloud native security (Cloud, Cluster, Container, Code)
- Defense in depth strategy
- Cloud provider security responsibilities (shared responsibility model)
- Security principles: least privilege, zero trust, defense in depth
- Attack surface reduction
- Security across the application lifecycle (build, deploy, runtime)

**Key Concepts:**
- 4C's model and how each layer contributes to overall security
- Shared responsibility between cloud provider and customer
- Shift-left security philosophy (integrate security early in the pipeline)
- Security as a continuous process, not a one-time activity

### Domain 2: Kubernetes Cluster Component Security (22%)
Securing the core components of a Kubernetes cluster.

- API server security (authentication, authorization, admission control)
- etcd security (encryption at rest, access control, backup)
- Kubelet security configuration
- Kube-proxy security considerations
- Control plane component communication (TLS certificates)
- CIS Kubernetes Benchmark compliance

**Key Concepts:**
- API server as the single point of entry - securing it is critical
- Certificate-based authentication for cluster components
- etcd encryption at rest and TLS for etcd communication
- kubelet authentication and authorization modes
- CIS Benchmark categories and how to assess compliance

### Domain 3: Kubernetes Security Fundamentals (22%)
Core security mechanisms built into Kubernetes.

- RBAC (Role-Based Access Control)
- Pod Security Standards and Pod Security Admission
- Network Policies for pod-to-pod traffic control
- Secrets management and encryption
- Service account security
- Security contexts for pods and containers
- Resource quotas and limit ranges

**Key Concepts:**
- RBAC components: Role, ClusterRole, RoleBinding, ClusterRoleBinding
- Pod Security Standards levels: Privileged, Baseline, Restricted
- Network Policy default-deny patterns and allow rules
- Service account token management and automount settings
- Security context fields: runAsNonRoot, readOnlyRootFilesystem, capabilities

### Domain 4: Kubernetes Threat Model (16%)
Understanding threats, attack vectors, and threat modeling for Kubernetes environments.

- STRIDE threat model applied to Kubernetes
- Common attack vectors (compromised container, lateral movement, privilege escalation)
- Kubernetes-specific threats (API server exposure, etcd access, kubelet exploit)
- Container escape techniques and mitigations
- Supply chain attacks (malicious images, compromised dependencies)
- Threat modeling methodology for Kubernetes workloads

**Key Concepts:**
- STRIDE: Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege
- Attack paths: external to cluster, pod to pod, container to host
- Trust boundaries in Kubernetes (namespace, node, cluster)
- Common CVEs and their impact on Kubernetes security

### Domain 5: Platform Security (16%)
Securing the underlying platform and infrastructure.

- Node security and host OS hardening
- Container runtime security
- Image security and scanning
- Supply chain security (signing, verification, SBOM)
- Runtime security and threat detection
- Network security and segmentation
- Admission controllers for policy enforcement

**Key Concepts:**
- Minimal base images and multi-stage builds
- Image signing with cosign/Sigstore
- Container runtime sandboxes (gVisor, Kata Containers)
- Runtime threat detection (Falco)
- OPA Gatekeeper for admission control
- Binary authorization and image policy webhooks

### Domain 6: Compliance and Security Frameworks (10%)
Understanding compliance standards and security frameworks relevant to Kubernetes.

- CIS Kubernetes Benchmark
- NIST Cybersecurity Framework
- SOC 2 compliance in Kubernetes environments
- PCI DSS considerations for containerized workloads
- GDPR and data protection in cloud native environments
- Audit logging and compliance evidence
- Security policy automation

**Key Concepts:**
- CIS Benchmark sections and how to use kube-bench
- NIST Framework functions: Identify, Protect, Detect, Respond, Recover
- Audit logging for compliance evidence
- Policy as code for automated compliance enforcement
- Continuous compliance monitoring vs point-in-time assessments

## The 4C's of Cloud Native Security

### Cloud
- Cloud provider security controls (IAM, network, encryption)
- Shared responsibility model
- Cloud-level network security (VPCs, security groups)
- Identity and access management at the cloud layer

### Cluster
- API server hardening and authentication
- RBAC configuration and least privilege
- etcd encryption and access control
- Network policies and cluster networking
- Audit logging and monitoring

### Container
- Minimal base images and vulnerability scanning
- Image signing and verification
- Runtime security and isolation
- Read-only root filesystems
- Dropping capabilities

### Code
- Application-level security (input validation, encryption)
- Dependency management and scanning
- Secret handling in application code
- Secure communication (TLS, mTLS)

## Study Resources

### Official Resources
- **[📖 KCSA Exam Page](https://training.linuxfoundation.org/certification/kubernetes-and-cloud-native-security-associate-kcsa/)** - Registration and official details
- **[📖 KCSA Exam Curriculum](https://github.com/cncf/curriculum)** - Official exam objectives
- **[📖 Kubernetes Security Documentation](https://kubernetes.io/docs/concepts/security/)** - Core security concepts
- **[📖 Cloud Native Security](https://kubernetes.io/docs/concepts/security/overview/)** - The 4C's of cloud native security

### Recommended Courses
1. **KodeKloud KCSA Course** - Comprehensive with practice tests
2. **A Cloud Guru** - Good theoretical coverage
3. **Udemy KCSA Courses** - Multiple options with practice exams

### Key References
- **[📖 CIS Kubernetes Benchmark](https://www.cisecurity.org/benchmark/kubernetes)** - CIS compliance reference
- **[📖 NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)** - NIST framework overview
- **[📖 RBAC Documentation](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)** - RBAC reference
- **[📖 Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)** - PSA levels
- **[📖 Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)** - NetworkPolicy reference

### Community Resources
- **r/kubernetes** - Reddit community for discussions
- **CNCF Slack** - Official CNCF community channels
- **Kubernetes Security SIG** - Security Special Interest Group

---

**Good luck with your KCSA certification!**

Remember: This is a knowledge-based exam - no hands-on. Focus on understanding the 4C's model, how Kubernetes security mechanisms work, common threat vectors, and compliance frameworks. Hands-on experience is helpful for understanding but the exam tests conceptual knowledge, not command-line skills.
