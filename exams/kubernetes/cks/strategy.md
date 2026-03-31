# CKS Study Strategy

## Study Approach

### Phase 1: Security Foundations (Weeks 1-2)
1. **CKA Review**
   - Ensure cluster administration skills are sharp
   - Review kubeadm cluster setup and management
   - Practice kubectl commands until they are second nature
   - Refresh RBAC, networking, and pod management concepts

2. **Cluster Security Basics**
   - NetworkPolicy specification and enforcement
   - CIS Kubernetes Benchmark with kube-bench
   - API server authentication and authorization modes
   - Service account management and token security

### Phase 2: Advanced Security Implementation (Weeks 3-4)
1. **System and Workload Hardening**
   - AppArmor and seccomp profile creation and application
   - Pod Security Admission configuration
   - OPA Gatekeeper policy enforcement
   - Secrets encryption at rest
   - Container runtime sandboxes (gVisor, Kata)

2. **Supply Chain Security**
   - Image scanning with Trivy
   - Dockerfile security best practices
   - Image signing and verification (cosign)
   - Admission controllers for image policies
   - Static analysis of Kubernetes manifests

### Phase 3: Exam Preparation (Weeks 5-6)
1. **Runtime Security and Monitoring**
   - Falco installation and rule configuration
   - Kubernetes audit logging setup
   - Container immutability enforcement
   - Threat detection and incident response

2. **Practice Exams**
   - Complete killer.sh simulations (2 sessions included)
   - Time yourself on individual task types
   - Review and remediate weak areas
   - Practice documentation navigation speed

## Study Resources

### Primary Resources
- **[Kubernetes Security Documentation](https://kubernetes.io/docs/concepts/security/)** - Core security concepts and best practices
- **[CKS Exam Curriculum](https://github.com/cncf/curriculum)** - Official exam objectives (check for latest version)
- **[killer.sh CKS Simulator](https://killer.sh/)** - Exam simulation environment (included with purchase)
- **[KodeKloud CKS Course](https://kodekloud.com/courses/certified-kubernetes-security-specialist-cks/)** - Comprehensive hands-on course

### Supplementary Resources
- **[Kubernetes Security Best Practices](https://kubernetes.io/docs/concepts/security/overview/)** - Official security overview
- **[Falco Documentation](https://falco.org/docs/)** - Runtime security tool
- **[Trivy Documentation](https://aquasecurity.github.io/trivy/)** - Vulnerability scanning
- **[OPA Gatekeeper Docs](https://open-policy-agent.github.io/gatekeeper/website/docs/)** - Policy engine
- **[AppArmor in Kubernetes](https://kubernetes.io/docs/tutorials/security/apparmor/)** - AppArmor profiles
- **[Seccomp in Kubernetes](https://kubernetes.io/docs/tutorials/security/seccomp/)** - Seccomp profiles

### Community and Forums
- **r/kubernetes** - Reddit community for experience reports and tips
- **CNCF Slack #cks-exam-prep** - Exam preparation discussions
- **KodeKloud Community** - Course-specific help and study groups

### Video Courses
1. **KodeKloud CKS** - HIGHLY RECOMMENDED for hands-on practice
2. **Kim Wuestkamp CKS (Udemy)** - Comprehensive coverage with scenarios
3. **Killer Shell CKS** - Exam-focused practice
4. **A Cloud Guru CKS** - Good theoretical foundation

## Exam Tactics

### Time Management (120 minutes)
- Each task has different point values - prioritize higher-value tasks
- Spend no more than 8-10 minutes on any single task
- If stuck after 5 minutes, flag the task and move on
- Reserve 15-20 minutes at the end for flagged tasks
- Simple tasks (creating NetworkPolicies, RBAC) should take 3-5 minutes
- Complex tasks (Falco rules, admission controllers) may take 8-10 minutes

### During the Exam
1. **Read the full task description** before starting any work
2. **Check the namespace** - always switch to the correct context/namespace
3. **Use imperative commands** when they are faster than writing YAML
4. **Copy-paste from docs** - kubernetes.io is your friend
5. **Verify your work** - run `kubectl get`, `kubectl describe`, or test commands
6. **Use aliases** - set up `alias k=kubectl` at the start
7. **Tab completion** - ensure kubectl completion is enabled

### Documentation Strategy
Before the exam, bookmark these pages for quick access:
- NetworkPolicy examples and API reference
- RBAC configuration and examples
- Security Context specification
- Audit Policy configuration
- Pod Security Standards reference
- AppArmor tutorial
- Seccomp tutorial
- Secrets encryption at rest

### Imperative Command Patterns
```bash
# Quick namespace creation and labeling
kubectl create ns secure-ns
kubectl label ns secure-ns pod-security.kubernetes.io/enforce=restricted

# Quick RBAC creation
kubectl create role pod-reader --verb=get,list --resource=pods -n app
kubectl create rolebinding dev-read --role=pod-reader --serviceaccount=app:developer -n app

# Quick service account
kubectl create sa app-sa -n app

# Quick secret creation
kubectl create secret generic db-creds --from-literal=user=admin --from-literal=pass=secret123

# Quick pod with security context
kubectl run secure-pod --image=nginx --dry-run=client -o yaml > pod.yaml
# Then edit the YAML to add security context
```

## Common Pitfalls

### Study Mistakes
- **Theory over practice** - The CKS is 100% hands-on. Reading without practice will not prepare you. Aim for 70% hands-on, 30% theory.
- **Skipping CKA fundamentals** - CKS builds on CKA skills. If your cluster administration is rusty, spend time reviewing before diving into security topics.
- **Not using killer.sh** - The exam simulator is included with your purchase. It is the closest experience to the real exam. Complete both sessions.
- **Ignoring documentation navigation** - You can use kubernetes.io during the exam. Practice finding information quickly.

### Technical Mistakes
- **NetworkPolicy DNS** - Always allow DNS egress (port 53 UDP and TCP) when creating default-deny egress policies, or pods cannot resolve service names
- **RBAC scope confusion** - Use Role/RoleBinding for namespace-scoped access, ClusterRole/ClusterRoleBinding for cluster-wide access. Mixing them up is a common source of errors
- **API server restart** - After modifying static pod manifests in `/etc/kubernetes/manifests/`, the kubelet will automatically restart the pod. Wait for the API server to come back before proceeding
- **Volume mounts for API server** - When adding new configurations (audit policy, encryption config), remember to add both the volume AND volumeMount to the API server manifest
- **PSA namespace labels** - Do not apply restrictive PSA labels to kube-system or other control plane namespaces

### Exam Mistakes
- **Not reading the full question** - Tasks often have multiple parts. Missing a sub-task costs points
- **Wrong namespace** - Always verify you are working in the correct namespace before executing commands
- **Not verifying** - After completing a task, always verify it works (test a NetworkPolicy, check RBAC with `can-i`, verify Falco alerts)
- **Spending too long on one task** - Better to get partial credit on several tasks than full credit on just a few
- **Overwriting existing configurations** - Some tasks ask you to modify existing resources. Be careful not to delete or overwrite existing settings that should remain

## Progress Tracking

### Self-Assessment Questions
After each study week, verify you can answer these without references:

**Week 1-2:**
- Can I create default-deny NetworkPolicies and allow specific traffic?
- Can I run kube-bench and remediate common findings?
- Can I create least-privilege RBAC roles from scratch?
- Can I harden service accounts and disable token automounting?

**Week 3-4:**
- Can I create and apply AppArmor profiles to pods?
- Can I write seccomp profiles and apply them via security context?
- Can I configure Pod Security Admission with namespace labels?
- Can I set up OPA Gatekeeper constraints?
- Can I enable Secrets encryption at rest?

**Week 5-6:**
- Can I scan images with Trivy and interpret results?
- Can I configure Falco rules for specific detection scenarios?
- Can I set up Kubernetes audit logging with custom policies?
- Can I complete a full killer.sh simulation within time limits?

### Readiness Indicators
You are ready for the exam when:
- [ ] You can complete killer.sh scenarios within the time limit
- [ ] You score 75%+ consistently on practice exams
- [ ] You can create NetworkPolicies, RBAC, and PSA from memory
- [ ] You can configure Falco, audit logging, and Trivy without references
- [ ] You navigate kubernetes.io documentation quickly and efficiently
- [ ] You feel comfortable with vim/nano for YAML editing in the terminal
