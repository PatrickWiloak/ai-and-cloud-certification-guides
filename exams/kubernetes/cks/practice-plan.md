# CKS Study Plan

## 6-Week Hands-On Study Schedule

### Week 1: Cluster Setup and CIS Benchmarks

#### Day 1-2: NetworkPolicy Deep Dive
- [ ] Review NetworkPolicy specification and selectors
- [ ] Practice creating default-deny ingress and egress policies
- [ ] Implement namespace isolation with NetworkPolicies
- [ ] Lab: Create policies allowing only specific pod-to-pod communication
- [ ] Lab: Test policy enforcement with curl/wget between pods
- [ ] Review Notes: `notes/network-security.md`

#### Day 3-4: CIS Benchmarks and kube-bench
- [ ] Install and run kube-bench against a kubeadm cluster
- [ ] Study CIS Kubernetes Benchmark sections for control plane
- [ ] Remediate common kube-bench failures (etcd, kubelet, API server)
- [ ] Lab: Fix API server configuration based on kube-bench output
- [ ] Lab: Harden etcd settings per CIS recommendations

#### Day 5-6: Ingress Security and Node Metadata
- [ ] Configure TLS termination on Ingress resources
- [ ] Study Ingress controller security annotations
- [ ] Block access to cloud metadata endpoints with NetworkPolicy
- [ ] Lab: Set up Ingress with TLS and authentication
- [ ] Lab: Create NetworkPolicy to block 169.254.169.254

#### Day 7: Week 1 Review
- [ ] Practice all NetworkPolicy patterns from scratch
- [ ] Run kube-bench and remediate without referencing notes
- [ ] Complete killer.sh practice questions for Cluster Setup domain

### Week 2: Cluster Hardening

#### Day 8-9: API Server Security
- [ ] Study API server authentication mechanisms (certs, tokens, OIDC)
- [ ] Review authorization modes (RBAC, Node, Webhook)
- [ ] Understand admission controller chain and configuration
- [ ] Lab: Configure API server with secure flags
- [ ] Lab: Disable anonymous authentication and insecure port
- [ ] Review Notes: `notes/cluster-hardening.md`

#### Day 10-11: RBAC Mastery
- [ ] Practice creating Roles, ClusterRoles, RoleBindings, ClusterRoleBindings
- [ ] Study RBAC aggregation and escalation prevention
- [ ] Learn to audit existing RBAC bindings for excessive permissions
- [ ] Lab: Create least-privilege roles for different personas
- [ ] Lab: Identify and fix overly permissive ClusterRoleBindings

#### Day 12-13: Service Account Hardening
- [ ] Disable default service account token mounting
- [ ] Create dedicated service accounts with minimal permissions
- [ ] Study projected service account tokens
- [ ] Lab: Configure workloads with custom service accounts
- [ ] Lab: Audit and remediate default service account usage

#### Day 14: Week 2 Review
- [ ] Create complete RBAC setup from scratch without references
- [ ] Practice service account hardening tasks
- [ ] Complete timed practice for Cluster Hardening domain

### Week 3: System Hardening and Kernel Security

#### Day 15-16: AppArmor Profiles
- [ ] Study AppArmor profile syntax and modes
- [ ] Learn how to load AppArmor profiles on nodes
- [ ] Practice applying AppArmor profiles to pods
- [ ] Lab: Create custom AppArmor profile for a web server
- [ ] Lab: Apply and verify AppArmor enforcement on containers

#### Day 17-18: Seccomp Profiles
- [ ] Study seccomp profile structure and syscall filtering
- [ ] Understand RuntimeDefault vs custom profiles
- [ ] Practice applying seccomp profiles to pods
- [ ] Lab: Create seccomp profile that blocks dangerous syscalls
- [ ] Lab: Apply seccomp profiles using security context fields

#### Day 19-20: Host OS Hardening
- [ ] Study minimal OS configurations for Kubernetes nodes
- [ ] Practice disabling unnecessary services and ports
- [ ] Implement host-level firewall rules
- [ ] Lab: Reduce attack surface on a Kubernetes node
- [ ] Lab: Configure UFW/iptables rules for node protection

#### Day 21: Week 3 Review
- [ ] Practice AppArmor and seccomp profile creation from memory
- [ ] Complete system hardening tasks under time pressure
- [ ] Review all Week 1-3 material

### Week 4: Microservice Vulnerabilities

#### Day 22-23: Pod Security Admission and OPA Gatekeeper
- [ ] Configure PSA with namespace labels (enforce, audit, warn)
- [ ] Study PSA profiles: Privileged, Baseline, Restricted
- [ ] Install and configure OPA Gatekeeper
- [ ] Lab: Enforce Restricted PSA on production namespaces
- [ ] Lab: Create Gatekeeper constraints for required labels and allowed registries
- [ ] Review Notes: `notes/pod-security-standards.md`

#### Day 24-25: Secrets and Runtime Sandboxes
- [ ] Configure encryption at rest for Kubernetes Secrets
- [ ] Study EncryptionConfiguration for etcd
- [ ] Learn RuntimeClass and sandbox configuration
- [ ] Lab: Enable Secrets encryption with aescbc provider
- [ ] Lab: Configure gVisor RuntimeClass and deploy sandboxed pods

#### Day 26-27: mTLS and Service Mesh
- [ ] Study mTLS concepts and service mesh basics
- [ ] Understand Istio or Linkerd mTLS configuration
- [ ] Practice SecurityContext settings (runAsNonRoot, capabilities)
- [ ] Lab: Deploy workloads with strict security contexts
- [ ] Lab: Implement container-level security restrictions

#### Day 28: Week 4 Review
- [ ] Practice PSA and Gatekeeper configuration from scratch
- [ ] Complete Secrets encryption setup without references
- [ ] Timed practice for Microservice Vulnerabilities domain

### Week 5: Supply Chain and Runtime Security

#### Day 29-30: Image Security and Scanning
- [ ] Study Dockerfile best practices for security
- [ ] Learn Trivy for image vulnerability scanning
- [ ] Practice multi-stage builds and minimal images
- [ ] Lab: Scan images with Trivy and remediate vulnerabilities
- [ ] Lab: Create secure Dockerfiles using distroless base images
- [ ] Review Notes: `notes/supply-chain-security.md`

#### Day 31-32: Admission Controllers and Image Policy
- [ ] Study ImagePolicyWebhook configuration
- [ ] Learn image signing with cosign
- [ ] Practice configuring allowed registries
- [ ] Lab: Set up ImagePolicyWebhook to enforce signed images
- [ ] Lab: Configure admission controller for registry restrictions

#### Day 33-34: Falco and Audit Logging
- [ ] Install and configure Falco for runtime detection
- [ ] Study default Falco rules and custom rule creation
- [ ] Configure Kubernetes audit logging and audit policies
- [ ] Lab: Write Falco rules to detect shell spawning in containers
- [ ] Lab: Enable audit logging and analyze audit events
- [ ] Review Notes: `notes/runtime-security.md`

#### Day 35: Week 5 Review
- [ ] Practice Trivy scanning and Falco configuration
- [ ] Create audit policies from scratch
- [ ] Complete timed practice for Supply Chain and Runtime domains

### Week 6: Full Exam Preparation

#### Day 36-37: killer.sh Exam Simulator
- [ ] Complete first killer.sh exam simulation (full 2 hours)
- [ ] Review all incorrect or incomplete answers
- [ ] Identify weak areas and create targeted practice plan
- [ ] Retake any tasks scored below expectations

#### Day 38-39: Weak Area Remediation
- [ ] Focus practice on lowest-scoring domains
- [ ] Repeat hands-on tasks for challenging topics
- [ ] Practice common exam task patterns
- [ ] Time yourself on individual task types

#### Day 40-41: Second Simulation and Speed Practice
- [ ] Complete second killer.sh exam simulation
- [ ] Focus on time management and task prioritization
- [ ] Practice switching between tasks efficiently
- [ ] Review documentation navigation speed

#### Day 42: Pre-Exam Preparation
- [ ] Light review of key concepts and commands
- [ ] Verify exam environment and system requirements
- [ ] Review allowed resources during the exam
- [ ] Rest and mental preparation

## Daily Study Routine (2-3 hours/day)

### Recommended Schedule
1. **30 minutes**: Review documentation and concepts
2. **90 minutes**: Hands-on lab practice in real clusters
3. **30 minutes**: Practice exam questions and review

### Weekend Extended Sessions (4-6 hours)
1. **2 hours**: Complex multi-step lab exercises
2. **2 hours**: Timed exam simulations
3. **1-2 hours**: Weak area remediation

## Practice Environment Setup

### Recommended Lab Setup
- [ ] Install kubeadm cluster (1 control plane + 1 worker minimum)
- [ ] Alternative: Use kind or minikube with appropriate configurations
- [ ] Install Falco on at least one node
- [ ] Install Trivy for image scanning
- [ ] Install OPA Gatekeeper
- [ ] Configure a CNI that supports NetworkPolicy (Calico or Cilium)

### Essential Tools to Master
- [ ] kubectl (imperative and declarative operations)
- [ ] vim or nano (YAML editing in terminal)
- [ ] systemctl (managing kubelet and other services)
- [ ] crictl (container runtime interface CLI)
- [ ] journalctl (viewing service logs)
- [ ] openssl (certificate inspection and creation)

## Progress Tracking

### Weekly Milestones
- [ ] Week 1: Fluent with NetworkPolicies and CIS benchmarks
- [ ] Week 2: RBAC and service account hardening mastered
- [ ] Week 3: AppArmor, seccomp, and system hardening practiced
- [ ] Week 4: PSA, Gatekeeper, and Secrets encryption solid
- [ ] Week 5: Supply chain and runtime security tools fluent
- [ ] Week 6: Scoring 75%+ consistently on practice exams

### Practice Exam Targets
- [ ] Week 3 end: Complete domain-specific tasks within time limits
- [ ] Week 4 end: Score 60%+ on first full practice exam
- [ ] Week 5 end: Score 70%+ on practice exams
- [ ] Week 6 end: Score 75%+ consistently on all practice attempts

## Study Resources

### Quick Links
- **[CKS Exam Page](https://training.linuxfoundation.org/certification/certified-kubernetes-security-specialist/)** - Registration
- **[Kubernetes Security Docs](https://kubernetes.io/docs/concepts/security/)** - Official security documentation
- **[killer.sh](https://killer.sh/)** - Exam simulator (included with exam purchase)
- **[KodeKloud CKS](https://kodekloud.com/courses/certified-kubernetes-security-specialist-cks/)** - Hands-on course

### Practice Platforms
- **killer.sh** - HIGHLY RECOMMENDED, closest to real exam
- **KodeKloud** - Interactive labs with step-by-step guidance
- **Killercoda** - Free Kubernetes scenarios
- **Local kubeadm clusters** - Best for full control and practice

---

## Final Exam Checklist

### One Week Before
- [ ] Complete all killer.sh simulation attempts
- [ ] Scoring consistently above passing threshold
- [ ] Comfortable with time management across all domains
- [ ] All weak areas addressed with additional practice

### Day Before Exam
- [ ] Light review of key commands and patterns
- [ ] Test exam environment (webcam, microphone, screen sharing)
- [ ] Prepare workspace per PSI requirements
- [ ] Get adequate rest

### Exam Day
- [ ] Log in 15 minutes early for environment setup
- [ ] Read each task fully before starting
- [ ] Use imperative commands when faster
- [ ] Flag difficult tasks and return later
- [ ] Verify each task before moving on
- [ ] Keep kubernetes.io documentation bookmarks ready
