# KCSA Study Plan

## 4-Week Knowledge-Based Study Schedule

### Week 1: Cloud Native Security and Cluster Components

#### Day 1-2: The 4C's of Cloud Native Security
- [ ] Study the 4C's model (Cloud, Cluster, Container, Code)
- [ ] Understand defense in depth and layered security
- [ ] Learn the shared responsibility model
- [ ] Study security principles: least privilege, zero trust, shift left
- [ ] Map security controls to each 4C layer
- [ ] Review Notes: `notes/01-cloud-native-security.md`

#### Day 3-4: API Server and Authentication
- [ ] Study API server authentication methods (certs, tokens, OIDC, webhooks)
- [ ] Learn authorization modes (RBAC, Node, Webhook, ABAC)
- [ ] Understand the admission control pipeline (mutating then validating)
- [ ] Study API server security flags and hardening
- [ ] Review Notes: `notes/02-cluster-component-security.md`

#### Day 5-6: etcd, kubelet, and CIS Benchmarks
- [ ] Study etcd security requirements (encryption at rest, TLS, access control)
- [ ] Learn kubelet security configuration
- [ ] Understand CIS Kubernetes Benchmark categories
- [ ] Study kube-bench and how it assesses compliance
- [ ] Review control plane communication security (TLS certificates)

#### Day 7: Week 1 Review
- [ ] Take a practice quiz on cloud native security and cluster components
- [ ] Draw the 4C's model and list controls at each layer
- [ ] Review any weak areas from the quiz

### Week 2: Kubernetes Security Fundamentals

#### Day 8-9: RBAC Deep Dive
- [ ] Study RBAC components (Role, ClusterRole, RoleBinding, ClusterRoleBinding)
- [ ] Understand RBAC subjects (users, groups, service accounts)
- [ ] Learn least privilege best practices
- [ ] Study common RBAC misconfigurations
- [ ] Understand aggregated ClusterRoles
- [ ] Review Notes: `notes/03-security-fundamentals.md`

#### Day 10-11: Pod Security and Security Context
- [ ] Study Pod Security Standards levels (Privileged, Baseline, Restricted)
- [ ] Learn Pod Security Admission modes (enforce, audit, warn)
- [ ] Understand security context fields (runAsNonRoot, capabilities, readOnlyRootFilesystem)
- [ ] Study the difference between pod-level and container-level security context
- [ ] Learn when to use each PSA level

#### Day 12-13: Network Policies and Secrets
- [ ] Study NetworkPolicy specification and selectors
- [ ] Learn default-deny patterns (ingress and egress)
- [ ] Understand Secrets management and encryption at rest
- [ ] Study service account security (token automounting, dedicated accounts)
- [ ] Learn about external secret management concepts (Vault, cloud KMS)

#### Day 14: Week 2 Review
- [ ] Take a practice quiz on Kubernetes security fundamentals
- [ ] Explain RBAC, PSA, and Network Policies without references
- [ ] Review all Week 1-2 material

### Week 3: Threat Model and Platform Security

#### Day 15-16: Kubernetes Threat Model
- [ ] Study the STRIDE threat model
- [ ] Apply STRIDE to Kubernetes attack scenarios
- [ ] Learn common attack vectors (API server exposure, container escape, lateral movement)
- [ ] Understand trust boundaries in Kubernetes
- [ ] Study supply chain attack patterns
- [ ] Review Notes: `notes/04-threat-model.md`

#### Day 17-18: Platform and Runtime Security
- [ ] Study image security (minimal images, scanning, signing)
- [ ] Learn about container runtime sandboxes (gVisor, Kata Containers)
- [ ] Understand runtime threat detection (Falco)
- [ ] Study admission controllers for policy enforcement
- [ ] Learn about OPA Gatekeeper concepts
- [ ] Review Notes: `notes/05-platform-and-compliance.md`

#### Day 19-20: Compliance Frameworks
- [ ] Study CIS Kubernetes Benchmark categories and assessment
- [ ] Learn NIST Cybersecurity Framework (Identify, Protect, Detect, Respond, Recover)
- [ ] Understand audit logging for compliance evidence
- [ ] Study SOC 2 and PCI DSS considerations for Kubernetes
- [ ] Learn policy as code concepts for automated compliance

#### Day 21: Week 3 Review
- [ ] Take a practice quiz on threats, platform security, and compliance
- [ ] Apply STRIDE to a sample Kubernetes architecture
- [ ] Map Kubernetes controls to NIST Framework functions

### Week 4: Comprehensive Review and Exam Prep

#### Day 22-23: Full Review - High-Weight Domains
- [ ] Deep review of Cluster Component Security (22%)
- [ ] Deep review of Security Fundamentals (22%)
- [ ] Practice questions for both domains
- [ ] Create flashcards for key terms and concepts

#### Day 24-25: Full Review - Remaining Domains
- [ ] Review Threat Model (16%) and Platform Security (16%)
- [ ] Review Cloud Native Security (14%) and Compliance (10%)
- [ ] Practice questions across all domains
- [ ] Review all notes files

#### Day 26-27: Practice Exams
- [ ] Take a full-length practice exam (timed, 90 minutes)
- [ ] Review all incorrect answers thoroughly
- [ ] Identify weak areas and do targeted review
- [ ] Take a second practice exam

#### Day 28: Pre-Exam Preparation
- [ ] Light review of key concepts and definitions
- [ ] Review the 4C's model one final time
- [ ] Verify exam environment and system requirements
- [ ] Rest and mental preparation

## Daily Study Routine (1-2 hours/day)

### Recommended Schedule
1. **30 minutes**: Read documentation and study materials
2. **30 minutes**: Watch video content or review diagrams
3. **30 minutes**: Practice questions and self-assessment

### Weekend Extended Sessions (3-4 hours)
1. **1 hour**: Deep dive into a complex domain
2. **1 hour**: Practice exams and review
3. **1-2 hours**: Review weak areas and create study aids

## Study Resources

### Quick Links
- **[KCSA Exam Page](https://training.linuxfoundation.org/certification/kubernetes-and-cloud-native-security-associate-kcsa/)** - Registration
- **[Kubernetes Security Docs](https://kubernetes.io/docs/concepts/security/)** - Security documentation
- **[CIS Benchmark](https://www.cisecurity.org/benchmark/kubernetes)** - CIS reference
- **[KCSA Curriculum](https://github.com/cncf/curriculum)** - Official objectives

### Practice Resources
- **KodeKloud KCSA** - Course with practice tests
- **Killer Shell KCSA** - Practice exam simulator
- **Udemy KCSA courses** - Multiple options with exams

---

## Final Exam Checklist

### One Week Before
- [ ] Scoring 80%+ consistently on practice exams
- [ ] All six domains reviewed
- [ ] Weak areas addressed with additional study
- [ ] Key terminology memorized

### Day Before Exam
- [ ] Light review of key concepts
- [ ] Test exam environment (webcam, microphone, browser)
- [ ] Prepare workspace per PSI requirements
- [ ] Get adequate rest

### Exam Day
- [ ] Log in 15 minutes early
- [ ] Read each question fully before answering
- [ ] Eliminate obviously wrong answers first
- [ ] Flag uncertain questions and return later
- [ ] Think about which 4C layer the question targets
- [ ] Use the full 90 minutes - review flagged questions at the end
