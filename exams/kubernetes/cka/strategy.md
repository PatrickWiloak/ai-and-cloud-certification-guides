# CKA Study Strategy

## Study Approach

### Phase 1: Foundation (Weeks 1-2)

Build a solid understanding of Kubernetes architecture and core concepts.

1. **Kubernetes Architecture**
   - Understand control plane and worker node components
   - Learn how components communicate (all through the API server)
   - Know what each component does and where it runs
   - Study the static pod model for control plane components

2. **Core Resources**
   - Pods, Deployments, ReplicaSets, Services
   - ConfigMaps, Secrets, Namespaces
   - Persistent Volumes, Persistent Volume Claims
   - Practice creating every resource both imperatively and declaratively

3. **Cluster Setup**
   - Install a cluster with kubeadm at least 3 times
   - Understand the `kubeadm init` and `kubeadm join` workflow
   - Install and configure a CNI plugin
   - Set up kubeconfig for cluster access

**Goal:** Be able to explain every component in a Kubernetes cluster and create basic resources without looking at documentation.

### Phase 2: Hands-On Practice (Weeks 3-4)

This phase is where you build real skills. The CKA is a hands-on exam - reading documentation is not enough.

1. **Build and Break Clusters**
   - Practice cluster upgrades with kubeadm
   - Practice etcd backup and restore
   - Intentionally break cluster components and fix them
   - Practice RBAC configuration for different users and service accounts

2. **Networking and Storage**
   - Create all four Service types and test connectivity
   - Configure Ingress resources with path-based and host-based routing
   - Create Network Policies (default deny, selective allow)
   - Set up PV/PVC with different access modes and storage classes

3. **Workload Management**
   - Deploy applications with rolling updates and rollbacks
   - Configure scheduling with taints, tolerations, and affinity
   - Set up resource requests and limits
   - Create Jobs, CronJobs, DaemonSets, and StatefulSets

**Goal:** Complete any common Kubernetes task in under 5 minutes without referencing external notes.

### Phase 3: Exam Preparation (Weeks 5-6)

Focus on speed, accuracy, and exam-specific skills.

1. **Timed Practice**
   - Complete killer.sh exam simulations under exam conditions
   - Practice solving tasks with a 7-minute-per-task time limit
   - Focus on reading tasks carefully and solving them correctly the first time

2. **Speed Drills**
   - Create a Deployment and expose it: target 1 minute
   - Create PV + PVC + Pod: target 3 minutes
   - Create Role + RoleBinding: target 2 minutes
   - etcd backup: target 2 minutes
   - Troubleshoot a broken pod: target 3 minutes

3. **Exam Environment Mastery**
   - Practice switching cluster contexts
   - Set up your terminal environment (aliases, vim config) in under 2 minutes
   - Navigate kubernetes.io/docs quickly to find YAML examples

**Goal:** Score 80%+ on killer.sh mock exams (which are harder than the real exam).

## Study Resources

### Course Recommendations

**Primary Course (pick one):**
- **Mumshad Mannambeth - CKA with Practice Tests** (Udemy/KodeKloud) - best overall, includes hands-on labs
- **Linux Foundation - Kubernetes Fundamentals (LFS258)** - official course, comprehensive but expensive

**Supplementary Resources:**
- **[Kubernetes Documentation](https://kubernetes.io/docs/)** - your primary reference (allowed during exam)
- **[Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)** - deep understanding of components
- **[kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)** - essential quick reference

### Practice Environments

**Free Options:**
- **Minikube** - single-node cluster on your local machine
- **kind (Kubernetes in Docker)** - lightweight clusters in Docker containers
- **k3s** - lightweight Kubernetes distribution
- **[Play with Kubernetes](https://labs.play-with-k8s.com/)** - browser-based, free, 4-hour sessions

**Paid Options (highly recommended):**
- **[killer.sh](https://killer.sh/)** - exam simulator, 2 sessions included with exam purchase
- **[KodeKloud](https://kodekloud.com/)** - interactive browser-based labs with guided exercises

### Community Resources
- **r/kubernetes** - Reddit community, search for CKA exam experiences
- **Kubernetes Slack** - official community workspace (#cka-exam channel)
- **CNCF YouTube Channel** - conference talks and tutorials

## Exam Tactics

### Before the Exam Starts

1. **Set up your environment immediately** (first 2-3 minutes):
   ```bash
   alias k=kubectl
   source <(kubectl completion bash)
   complete -o default -F __start_kubectl k
   export EDITOR=vim
   ```

2. **Open your documentation browser tab** and navigate to the kubectl cheat sheet

3. **Quick sanity check:**
   ```bash
   k get nodes
   k config get-contexts
   ```

### During the Exam

1. **Read the FULL task before typing anything**
   - Identify what cluster context to use
   - Identify the namespace
   - Understand all requirements before starting

2. **Always switch context first**
   ```bash
   kubectl config use-context <context-name>
   ```

3. **Use imperative commands whenever possible**
   - Writing YAML from scratch wastes time
   - Use `--dry-run=client -o yaml` when you need to customize YAML
   - Copy YAML examples from kubernetes.io/docs when needed

4. **Verify your work before moving on**
   ```bash
   k get <resource>
   k describe <resource>
   ```

5. **Flag and skip** tasks that will take too long
   - Return to them in your second pass
   - A partially correct answer is better than no answer

### Task Approach Framework

For every task, follow this sequence:
1. **Read** - understand the requirements completely
2. **Context** - switch to the correct cluster context
3. **Namespace** - note the target namespace
4. **Execute** - solve the task using imperative commands or YAML
5. **Verify** - confirm the resource was created correctly
6. **Move on** - do not over-engineer or add extras

### Scoring Strategy

- **Passing score is 66%** - you do not need to be perfect
- **Do the easy tasks first** - secure the points you know
- **Partial credit exists** - even incomplete solutions may earn points
- **Focus on high-value tasks** - task weights are shown in the interface
- **Time allocation:** If a 4% task is taking 15 minutes, skip it and do three 4% tasks in the same time

## Time Management

### The Math
- 120 minutes total
- Approximately 17 tasks (varies per exam)
- Average 7 minutes per task
- Subtract 3 minutes for initial setup
- Subtract 5 minutes for final review
- Working time: ~112 minutes for 17 tasks = ~6.5 minutes per task

### Time Budgets by Task Type

| Task Type | Target Time | Example |
|-----------|------------|---------|
| Simple create | 2-3 min | Create a pod, service, configmap |
| RBAC setup | 3-4 min | Create role and binding |
| PV/PVC/Pod | 3-5 min | Create storage chain |
| Network Policy | 3-5 min | Create ingress/egress policy |
| Ingress | 3-5 min | Configure routing rules |
| etcd backup | 2-3 min | Snapshot save |
| etcd restore | 5-7 min | Snapshot restore + manifest update |
| Cluster upgrade | 8-10 min | Full kubeadm upgrade |
| Troubleshooting | 3-8 min | Depends on complexity |

### When You Are Running Out of Time

1. **Stop working on the current task** if you are stuck
2. **Scan remaining tasks** for quick wins (simple creates, label changes)
3. **Complete the easiest remaining tasks first**
4. **Return to hard tasks** only if time permits
5. **Submit partial work** - it may earn partial credit

## Common Pitfalls

### Study Pitfalls
- **Watching videos without practicing** - the CKA requires muscle memory, not just knowledge
- **Using only managed clusters (EKS, GKE)** - the exam uses kubeadm-based clusters
- **Not practicing with time limits** - speed matters as much as knowledge
- **Skipping troubleshooting practice** - 30% of the exam is troubleshooting
- **Memorizing YAML** instead of using imperative commands and `--dry-run`

### Exam Day Pitfalls
- **Wrong cluster context** - the number one exam mistake, costs full points
- **Wrong namespace** - always check and specify `-n <namespace>`
- **Not reading the full task** - missing a small requirement means lost points
- **Spending too long on one task** - better to get 80% of tasks right than 50% perfectly
- **Not verifying work** - a small typo can make an otherwise correct solution fail
- **Panic editing** - if you break something, stop, think, then fix it methodically
- **Not using the documentation** - it is there for a reason, use it for YAML examples
- **Over-engineering** - do exactly what is asked, nothing more

### Technical Pitfalls
- **YAML indentation errors** - validate with `kubectl apply --dry-run=client -f file.yaml`
- **Forgetting API groups** - Deployments are `apps`, Jobs are `batch`, core resources are `""`
- **Label/selector mismatches** - services cannot find pods if labels do not match
- **Forgetting `restartPolicy` for Jobs** - must be `Never` or `OnFailure`
- **Network Policy AND/OR confusion** - separate list items are OR, combined items are AND
- **PV/PVC binding failures** - storage class, access mode, and capacity must all match

## Weekly Self-Assessment

Ask yourself these questions each week:

### Week 1-2
- Can I build a cluster with kubeadm without documentation?
- Can I create pods, deployments, and services imperatively?
- Do I understand all control plane and worker node components?

### Week 3-4
- Can I configure RBAC, Network Policies, and Ingress?
- Can I set up PV/PVC storage and mount it in a pod?
- Can I perform etcd backup and restore from memory?

### Week 5-6
- Can I troubleshoot any pod issue in under 5 minutes?
- Can I upgrade a cluster with kubeadm from memory?
- Am I scoring 80%+ on killer.sh mock exams?
- Can I complete 17 tasks in 2 hours?

If the answer to any question is "no," focus your remaining study time on that area.

---

**Final Thought:** The CKA exam is not about what you know - it is about what you can do. Every minute spent reading should be matched with two minutes of hands-on practice. Build clusters, deploy applications, break things, fix them. That is how you pass the CKA.
