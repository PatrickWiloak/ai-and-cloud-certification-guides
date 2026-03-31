# CKAD Study Strategy

## Overview

The CKAD exam is a performance-based, hands-on terminal exam. Unlike multiple-choice certifications, you must demonstrate practical skills by executing commands and creating Kubernetes resources in a live cluster. Your strategy should prioritize speed and muscle memory over memorization.

## Three-Phase Study Approach

### Phase 1: Foundation (Weeks 1-2)

**Goal:** Understand core Kubernetes concepts and get comfortable with kubectl.

**Activities:**
- Read the official Kubernetes documentation for each exam domain
- Set up a local cluster (minikube or kind) and practice daily
- Learn the core resource types: Pods, Deployments, Services, ConfigMaps, Secrets
- Understand YAML structure and how Kubernetes manifests are organized
- Practice imperative commands for resource creation
- Study multi-container Pod patterns (sidecar, init, ambassador)

**Focus Areas:**
- What each resource type does and when to use it
- The relationship between Deployments, ReplicaSets, and Pods
- How Services expose Pods and how DNS works in Kubernetes
- Volume types and how PVCs work

**Mindset:** Do not worry about speed yet. Focus on understanding why things work, not just how. Experiment with breaking things and fixing them.

### Phase 2: Hands-On Practice (Weeks 3-4)

**Goal:** Build speed and fluency with kubectl and YAML editing.

**Activities:**
- Work through all scenarios in `scenarios.md` repeatedly
- Practice creating every resource type imperatively and declaratively
- Time yourself on common tasks and try to reduce your completion time
- Learn to use `--dry-run=client -o yaml` to generate YAML templates
- Set up your shell aliases and practice using them
- Focus on the highest-weighted domain (Application Environment, Configuration and Security at 25%)
- Practice debugging - intentionally break Pods and Services, then fix them

**Speed Benchmarks to Target:**
- Create a Pod with a specific image: under 15 seconds
- Create a Deployment with replicas and expose it: under 30 seconds
- Create a ConfigMap and mount it in a Pod: under 2 minutes
- Create a NetworkPolicy from requirements: under 3 minutes
- Debug a failing Pod (identify and fix the issue): under 3 minutes

**Mindset:** Repetition builds speed. Do the same tasks over and over until they become automatic. This is where you build the muscle memory that will carry you through the exam.

### Phase 3: Exam Preparation (Week 5)

**Goal:** Simulate exam conditions and fine-tune weak areas.

**Activities:**
- Take the killer.sh practice exam (one session is included with your exam purchase)
- Simulate full 2-hour exam sessions with no breaks
- Practice context switching between clusters (the exam uses multiple clusters)
- Learn to navigate kubernetes.io/docs quickly to find YAML snippets
- Review every mistake from practice exams and create targeted drills
- Practice time management - learn when to skip a question and come back

**Exam Readiness Checklist:**
- [ ] Can create any common resource type in under 30 seconds
- [ ] Comfortable editing YAML in vim or nano
- [ ] Can navigate kubernetes.io docs to find examples in under 1 minute
- [ ] Can debug a failing Pod within 2-3 minutes
- [ ] Can complete 15+ tasks in 2 hours in practice exams
- [ ] Know all imperative kubectl commands by heart

---

## Developer-Focused Study Approach

As a developer taking the CKAD, think about Kubernetes from an application perspective:

### Think Like an App Developer
- How do I deploy my application? - Deployments, rolling updates
- How do I configure my application? - ConfigMaps, Secrets, environment variables
- How do I expose my application? - Services, Ingress
- How do I make my application reliable? - Probes, resource limits, replicas
- How do I secure my application? - SecurityContexts, ServiceAccounts, NetworkPolicies
- How do I debug my application? - Logs, describe, exec, events
- How do I run batch tasks? - Jobs, CronJobs

### Map to Real-World Development
- ConfigMaps and Secrets are your `.env` files and config files
- Deployments are your application release process
- Services are your load balancers and service discovery
- Probes are your health check endpoints
- Resource limits prevent your app from consuming all cluster resources
- NetworkPolicies are your firewall rules

---

## Speed Tips for the Exam

### Before You Start
Set up your environment at the very beginning of the exam:
```bash
# Essential aliases
alias k=kubectl
alias kn='kubectl config set-context --current --namespace'
export do="--dry-run=client -o yaml"
export now="--force --grace-period=0"

# Verify setup
k version --short
```

### Imperative Commands Save Time
Always try the imperative approach first:
```bash
# Pods
k run nginx --image=nginx --port=80 --labels="app=web,tier=frontend"
k run nginx --image=nginx $do > pod.yaml

# Deployments
k create deploy myapp --image=nginx --replicas=3
k create deploy myapp --image=nginx --replicas=3 $do > deploy.yaml

# Services
k expose deploy myapp --port=80 --target-port=8080 --type=NodePort
k expose pod mypod --port=80 --name=my-svc

# ConfigMaps
k create cm my-config --from-literal=key=value --from-file=config.txt

# Secrets
k create secret generic my-secret --from-literal=pass=secret123

# Jobs
k create job myjob --image=busybox -- echo "hello"

# CronJobs
k create cj mycj --image=busybox --schedule="*/5 * * * *" -- echo "hello"

# Ingress
k create ingress myingress --class=nginx --rule="host.com/path=svc:port"

# ServiceAccount
k create sa my-sa

# Namespace
k create ns my-namespace
```

### YAML Editing Efficiency

**Vim tips for the exam:**
```
:set number          # show line numbers
:set expandtab       # use spaces instead of tabs
:set tabstop=2       # set tab width to 2
:set shiftwidth=2    # set indent width to 2
:set autoindent      # enable auto-indent

# Quick navigation
gg          # go to top
G           # go to bottom
dd          # delete line
yy          # yank (copy) line
p           # paste below
/pattern    # search
n           # next search result
u           # undo
```

**Add to ~/.vimrc at exam start:**
```
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
```

### Documentation Navigation
- Bookmark the Tasks section: `kubernetes.io/docs/tasks/`
- Search with Ctrl+F on documentation pages
- Key pages to know how to find:
  - Pod spec reference
  - Deployment spec
  - Service types
  - NetworkPolicy examples
  - Ingress examples
  - Probe configuration
  - SecurityContext fields

### Time Management Strategy
1. **First pass (80 minutes):** Work through all tasks in order, skip anything that takes more than 8 minutes
2. **Second pass (30 minutes):** Return to skipped tasks, attempt the ones you are most confident about
3. **Final pass (10 minutes):** Verify completed work, attempt remaining tasks even if partial

**Point Estimation:**
- Each task is worth a certain percentage
- Higher-weighted domains likely have more tasks or higher-value tasks
- Partial credit may be awarded - always attempt something even if incomplete

---

## Common Pitfalls

### Exam Pitfalls
- **Not switching context:** Each task may use a different cluster/context. Always run the provided `kubectl config use-context` command at the start of each task.
- **Wrong namespace:** Always verify you are in the correct namespace. Use `kn <namespace>` or append `-n <namespace>` to every command.
- **YAML indentation:** A single space error breaks your manifest. Use `kubectl apply --dry-run=server -o yaml` to validate before applying.
- **Overthinking:** The exam tests practical skills, not deep theory. If a task seems simple, it probably is.
- **Not verifying:** Always check that your resource was created correctly (`kubectl get`, `kubectl describe`).

### Technical Pitfalls
- **Probes:** `initialDelaySeconds` is critical for slow-starting apps. Without it, the liveness probe may kill the container before it starts.
- **NetworkPolicies:** Remember that once any NetworkPolicy selects a Pod, all traffic not explicitly allowed is denied. You may need to add DNS egress rules.
- **Secrets:** Values must be base64-encoded in YAML manifests, but `kubectl create secret` handles this automatically.
- **SecurityContext:** Pod-level vs container-level fields are different. `runAsUser` can be at either level; `capabilities` is container-level only.
- **PVC access modes:** `ReadWriteOnce` means single node, not single Pod. Use `ReadWriteOncePod` for single-Pod access.

### Study Pitfalls
- **Only reading, not doing:** This exam is 100% hands-on. Reading docs without practicing in a cluster will not prepare you.
- **Memorizing YAML:** Instead of memorizing, learn to generate YAML with `--dry-run=client -o yaml` and edit from there.
- **Ignoring time pressure:** Practice under timed conditions. Being able to do a task in 20 minutes is not the same as doing it in 6 minutes.
- **Skipping security topics:** Domain 4 (Configuration and Security) is 25% of the exam - the largest single domain. Do not neglect it.

---

## Recommended Resources

| Resource | Type | Notes |
|----------|------|-------|
| [Kubernetes Official Docs](https://kubernetes.io/docs/home/) | Documentation | Your primary reference - allowed during the exam |
| [killer.sh](https://killer.sh/) | Practice Exam | Included with exam purchase, very realistic |
| [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) | Reference | Essential commands in one page |
| [Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way) | Tutorial | Deep understanding of cluster internals |
| [CKAD Exercises (GitHub)](https://github.com/dgkanatsios/CKAD-exercises) | Practice | Community-maintained exercise collection |
| [Play with Kubernetes](https://labs.play-with-k8s.com/) | Lab | Free browser-based cluster |
| [KodeKloud CKAD Course](https://kodekloud.com/) | Course | Structured video course with labs |
