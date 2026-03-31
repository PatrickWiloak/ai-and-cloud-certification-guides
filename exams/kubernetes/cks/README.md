# Certified Kubernetes Security Specialist (CKS)

## Exam Overview

The Certified Kubernetes Security Specialist (CKS) exam validates a candidate's ability to secure container-based applications and Kubernetes platforms during build, deployment, and runtime. This is a performance-based exam that requires hands-on proficiency with Kubernetes security tooling and techniques. CKS is considered one of the most challenging Kubernetes certifications due to its breadth of security topics and requirement for real-time problem solving in a live cluster environment.

**Exam Details:**
- **Exam Code:** CKS
- **Duration:** 2 hours (120 minutes)
- **Format:** Performance-based (hands-on tasks in a live environment)
- **Passing Score:** 67%
- **Cost:** $395 USD (includes one free retake)
- **Delivery:** Online proctored via PSI
- **Validity:** 2 years
- **Prerequisites:** Must hold an active CKA (Certified Kubernetes Administrator) certification
- **Kubernetes Version:** Based on a recent stable release (check CNCF site for current version)

**Important:** This exam is entirely hands-on. You will work with real Kubernetes clusters to solve security-related tasks. There are no multiple choice questions.

## Exam Domains

### Domain 1: Cluster Setup (10%)
- Use network security policies to restrict cluster-level access
- Use CIS benchmark to review the security configuration of Kubernetes components (etcd, kubelet, kubedns, kubeapi)
- Properly set up Ingress objects with security control
- Protect node metadata and endpoints
- Minimize use of, and access to, GUI elements
- Verify platform binaries before deploying

**Key Concepts:**
- NetworkPolicy resources for pod-to-pod traffic control
- CIS Kubernetes Benchmark and kube-bench
- Ingress TLS termination and authentication
- Cloud provider metadata API protection
- Kubernetes Dashboard security
- Binary verification with SHA checksums

### Domain 2: Cluster Hardening (15%)
- Restrict access to Kubernetes API
- Use Role-Based Access Controls to minimize exposure
- Exercise caution in using service accounts (e.g., disable defaults, minimize permissions on newly created ones)
- Update Kubernetes frequently

**Key Concepts:**
- API server authentication and authorization modes
- RBAC Roles, ClusterRoles, RoleBindings, and ClusterRoleBindings
- Service account token management and automountServiceAccountToken
- Kubernetes version upgrade strategies
- Anonymous authentication and insecure port disabling
- Audit logging for API server requests

### Domain 3: System Hardening (15%)
- Minimize host OS footprint (reduce attack surface)
- Minimize IAM roles
- Minimize external access to the network
- Appropriately use kernel hardening tools such as AppArmor, seccomp

**Key Concepts:**
- Linux security modules (AppArmor, SELinux)
- Seccomp profiles for system call filtering
- Host-level firewall rules (iptables, UFW)
- Reducing the host attack surface (unnecessary services, packages)
- Cloud IAM role minimization
- Network segmentation and external access controls

### Domain 4: Minimize Microservice Vulnerabilities (20%)
- Setup appropriate OS-level security domains (e.g., using PSA, OPA Gatekeeper)
- Manage Kubernetes secrets
- Use container runtime sandboxes in multi-tenant environments (e.g., gVisor, Kata Containers)
- Implement pod-to-pod encryption by use of mTLS

**Key Concepts:**
- Pod Security Admission (PSA) - Privileged, Baseline, Restricted
- OPA Gatekeeper and constraint templates
- Kubernetes Secrets management and encryption at rest
- Runtime sandboxes (gVisor/runsc, Kata Containers)
- Service mesh for mTLS (Istio, Linkerd)
- SecurityContext and PodSecurityContext settings

### Domain 5: Supply Chain Security (20%)
- Minimize base image footprint
- Secure your supply chain: whitelist allowed registries, sign and validate images
- Use static analysis of user workloads (e.g., Kubernetes resources, Docker files)
- Scan images for known vulnerabilities

**Key Concepts:**
- Distroless and minimal base images
- Image signing with cosign/Sigstore and Notary
- Admission controllers for image policy (ImagePolicyWebhook)
- Static analysis tools (kubesec, conftest, checkov)
- Image vulnerability scanning (Trivy, Grype, Clair)
- Private container registries and image pull policies
- Dockerfile best practices for security

### Domain 6: Monitoring, Logging and Runtime Security (20%)
- Perform behavioral analytics of syscall process and file activities at the host and container level to detect malicious activities
- Detect threats within physical infrastructure, apps, networks, data, users, and workloads
- Detect all phases of attack regardless where it occurs and how it spreads
- Perform deep analytical investigation and identification of bad actors within environment
- Ensure immutability of containers at runtime
- Use Audit Logs to monitor access

**Key Concepts:**
- Falco for runtime threat detection
- Sysdig for system call monitoring
- Container immutability (read-only root filesystem)
- Kubernetes audit logging and audit policies
- Log aggregation and analysis
- Threat detection across the attack lifecycle
- Forensic analysis of compromised containers

## Core Tools and Technologies

### Security Scanning and Analysis
- **Trivy** - Comprehensive vulnerability scanner for containers, filesystems, and IaC
- **kubesec** - Security risk analysis for Kubernetes resources
- **kube-bench** - CIS Kubernetes Benchmark checker
- **Falco** - Cloud-native runtime security and threat detection
- **OPA/Gatekeeper** - Policy engine for Kubernetes admission control
- **AppArmor** - Linux kernel security module for mandatory access control
- **seccomp** - System call filtering for containers

### Kubernetes-Native Security
- **NetworkPolicy** - Pod-level network segmentation
- **RBAC** - Role-based access control for API authorization
- **Pod Security Admission** - Pod security standards enforcement
- **Secrets** - Sensitive data management in Kubernetes
- **Audit Logging** - API server request logging and monitoring
- **ServiceAccount** - Identity for pods accessing the API server

### Runtime and Supply Chain
- **gVisor** - Application kernel sandbox for containers
- **Kata Containers** - Lightweight VMs for container isolation
- **cosign** - Container image signing and verification
- **Notary** - Trust management for container images
- **Istio/Linkerd** - Service mesh for mTLS and traffic encryption

## Security Best Practices Quick Reference

### Pod Security
- Never run containers as root (use `runAsNonRoot: true`)
- Always set `readOnlyRootFilesystem: true` when possible
- Drop all capabilities and add only what is needed
- Use Pod Security Admission with Restricted profile
- Set resource limits to prevent DoS attacks
- Avoid privileged containers and hostPID/hostNetwork

### Network Security
- Default deny all ingress/egress with NetworkPolicy
- Allow only required communication paths
- Use TLS for all external communication
- Implement mTLS for pod-to-pod encryption
- Restrict access to cloud metadata endpoints

### Secret Management
- Enable encryption at rest for Secrets in etcd
- Use external secret management (Vault, cloud KMS)
- Never store secrets in container images or environment variables when avoidable
- Rotate secrets regularly
- Use short-lived tokens where possible

### Image Security
- Use minimal base images (distroless, Alpine)
- Scan images in CI/CD pipelines before deployment
- Enforce image signing and verification
- Use specific image tags, never `latest`
- Restrict allowed registries with admission controllers

## Hands-on Practice Requirements

**CRITICAL:** This is a performance-based exam. You MUST practice hands-on.

### Essential Practice Tasks
1. Create and apply NetworkPolicies for pod isolation
2. Configure RBAC roles and bindings with least privilege
3. Set up and analyze Falco rules for runtime detection
4. Write and apply AppArmor and seccomp profiles
5. Configure Pod Security Admission for namespace enforcement
6. Scan images with Trivy and remediate vulnerabilities
7. Enable and configure Kubernetes audit logging
8. Set up OPA Gatekeeper with custom constraints
9. Configure Secrets encryption at rest in etcd
10. Run kube-bench and remediate CIS benchmark findings

### Practice Environments
- **killer.sh** - CKS exam simulator (included with exam purchase)
- **KodeKloud CKS Course** - Hands-on labs and practice environment
- **Local clusters** - Use kubeadm or kind for practice
- **Kubernetes playground** - Killercoda free scenarios

## Study Strategy

### Recommended Timeline: 4-6 Weeks (with active CKA)

**Week 1-2: Security Foundations**
- Review CKA concepts and ensure cluster administration skills are solid
- Study Cluster Setup and Cluster Hardening domains
- Practice NetworkPolicies, RBAC, and CIS benchmarks
- Hands-on: Run kube-bench and remediate findings

**Week 3-4: Advanced Security**
- Study System Hardening and Microservice Vulnerabilities domains
- Practice AppArmor, seccomp, and PSA configuration
- Learn OPA Gatekeeper constraint templates
- Hands-on: Implement pod security standards across namespaces

**Week 5-6: Supply Chain and Runtime**
- Study Supply Chain Security and Monitoring domains
- Practice Trivy scanning and image policy enforcement
- Learn Falco rules and audit logging
- Hands-on: Full security audit of a practice cluster

### Exam Day Tips
1. Read each task completely before starting
2. Use `kubectl explain` and the allowed documentation
3. Manage your time - move on if stuck on a task
4. Use imperative commands when faster than YAML
5. Verify your work before moving to the next task
6. Bookmark frequently used documentation pages

## Common Exam Scenarios

### Scenario 1: NetworkPolicy Isolation
- Create a NetworkPolicy that allows only specific pod-to-pod communication
- Block all ingress/egress by default, then allow specific paths

### Scenario 2: RBAC Misconfiguration
- Identify overly permissive RBAC bindings
- Create least-privilege roles for specific service accounts

### Scenario 3: Runtime Threat Detection
- Configure Falco to detect suspicious activities
- Analyze Falco alerts and identify compromised containers

### Scenario 4: Image Security
- Scan container images and fix vulnerabilities
- Configure admission controllers to block unsigned or vulnerable images

### Scenario 5: Audit and Compliance
- Enable and configure audit logging
- Analyze audit logs to identify unauthorized access

## Study Resources

### Official Resources
- **[CKS Exam Page](https://training.linuxfoundation.org/certification/certified-kubernetes-security-specialist/)** - Registration and official details
- **[CKS Exam Curriculum](https://github.com/cncf/curriculum)** - Official exam objectives
- **[Kubernetes Security Documentation](https://kubernetes.io/docs/concepts/security/)** - Core security concepts
- **[Kubernetes RBAC Documentation](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)** - RBAC reference
- **[Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)** - PSA levels and policies
- **[Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)** - NetworkPolicy documentation

### Recommended Courses
1. **KodeKloud CKS Course** - Hands-on focused with practice labs
2. **Killer Shell CKS Simulator** - Included with exam purchase, closest to real exam
3. **Udemy - CKS by Kim Wuestkamp** - Comprehensive with hands-on scenarios
4. **A Cloud Guru CKS Course** - Good theoretical coverage

### Practice Platforms
1. **killer.sh** - HIGHLY RECOMMENDED, exam simulator included with purchase
2. **KodeKloud** - Interactive labs with guided practice
3. **Killercoda** - Free Kubernetes scenarios
4. **Local kubeadm clusters** - Best for full cluster security practice

### Community Resources
- **r/kubernetes** - Reddit community for Kubernetes discussions
- **CNCF Slack** - Official CNCF community channels
- **Kubernetes Security SIG** - Security Special Interest Group

---

**Good luck with your CKS certification!**

Remember: This exam is 100% hands-on. Reading alone will not prepare you. You need to practice every task type in a real cluster environment. Speed matters - practice until the commands and YAML patterns are second nature. The CKS builds directly on CKA skills, so ensure your cluster administration fundamentals are solid before focusing on security-specific topics.
