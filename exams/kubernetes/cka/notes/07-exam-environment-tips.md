# Exam Environment Tips

## Overview

The CKA exam is delivered through PSI's secure browser environment. Understanding the exam environment and preparing your workflow in advance can save significant time during the exam.

## PSI Exam Environment

### System Requirements
- Stable internet connection (minimum 1 Mbps)
- Webcam and microphone (required for proctoring)
- Government-issued photo ID
- Clean desk and room - no papers, books, or secondary monitors
- No one else in the room during the exam
- Browser: PSI Secure Browser (downloaded during check-in)

### Environment Layout
- The exam runs in a remote desktop environment
- You have a Linux terminal (typically Ubuntu-based)
- A Firefox or Chromium browser is available for accessing allowed documentation
- Copy/paste works between the browser and terminal (use Ctrl+Shift+C/V in terminal)
- The exam interface shows the task description on one side and the terminal on the other

### Before the Exam
- Check in 15-30 minutes early
- Have your ID ready
- Close all applications except PSI Secure Browser
- Ensure your room is clean and quiet
- Test your webcam and microphone

## Allowed Resources During the Exam

You may open ONE additional browser tab to access these domains:

1. **https://kubernetes.io/docs/** - Official Kubernetes documentation
2. **https://kubernetes.io/blog/** - Kubernetes blog
3. **https://github.com/kubernetes/** - Kubernetes GitHub repositories

Any subdomains and deep links within these domains are allowed. You CANNOT access:
- Personal notes or bookmarks stored externally
- Other websites, forums, or blogs
- ChatGPT, Stack Overflow, or any other resource

### Pages to Pre-Study and Know How to Find

**High-Value Documentation Pages:**
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) - Quick command reference
- [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) - PV/PVC YAML
- [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) - Network Policy YAML
- [RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) - Role/Binding YAML
- [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) - Ingress YAML
- [Upgrading kubeadm clusters](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/) - Upgrade steps
- [Operating etcd](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/) - Backup/restore commands
- [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) - Toleration YAML
- [Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) - Affinity YAML

**Tip:** Practice navigating to these pages quickly. Use the documentation search bar - it works well and is faster than browsing the sidebar.

## Terminal Tips

### Initial Setup (First 2-3 Minutes of Exam)

Run these commands at the very start of the exam to set up your environment:

```bash
# Set up kubectl alias
alias k=kubectl

# Enable kubectl autocompletion
source <(kubectl completion bash)

# Make the alias work with autocompletion
complete -o default -F __start_kubectl k

# Set default editor (choose one)
export EDITOR=vim
# or
export EDITOR=nano

# Verify kubectl is working
k get nodes
```

### Vim Tips (If Using Vim)

```bash
# Add to ~/.vimrc for YAML editing
cat >> ~/.vimrc << 'EOF'
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set number
EOF
```

**Essential Vim Commands:**
- `i` - enter insert mode
- `Esc` - exit insert mode
- `:wq` - save and quit
- `:q!` - quit without saving
- `dd` - delete a line
- `yy` - copy a line
- `p` - paste below current line
- `u` - undo
- `/search` - search for text
- `:%s/old/new/g` - find and replace all
- `:set paste` - enable paste mode (prevents auto-indent issues)
- `Shift+G` - go to end of file
- `gg` - go to beginning of file

### Nano Tips (If Using Nano)

```bash
# Nano is simpler but slower for large edits
# Key shortcuts:
# Ctrl+O - save (write Out)
# Ctrl+X - exit
# Ctrl+K - cut line
# Ctrl+U - paste line
# Ctrl+W - search
# Ctrl+\ - find and replace
```

### tmux Tips

tmux may be available in the exam environment for split-pane terminals.

```bash
# Start tmux
tmux

# Split pane horizontally
Ctrl+b, then "

# Split pane vertically
Ctrl+b, then %

# Switch between panes
Ctrl+b, then arrow keys

# Close a pane
exit (or Ctrl+d)
```

**Note:** tmux is useful but not required. If you are not comfortable with tmux, do not waste time setting it up during the exam.

## Time Management

### Exam Structure
- **Duration:** 2 hours (120 minutes)
- **Tasks:** Approximately 15-20 tasks
- **Average time per task:** 6-8 minutes
- **Passing score:** 66%

### Task Weighting
- Tasks have different point values (shown in the exam interface)
- Some tasks are worth 2-4% each, others up to 7-8%
- Higher-weighted tasks are not necessarily harder

### Time Strategy

1. **First pass (90 minutes):** Work through all tasks in order
   - Skip tasks that seem too complex (flag them)
   - Aim to complete 12-15 tasks
   - Spend no more than 8 minutes on any single task

2. **Second pass (25 minutes):** Return to flagged tasks
   - Tackle the highest-value flagged tasks first
   - Partial solutions may earn partial credit

3. **Final check (5 minutes):** Quick verification
   - Make sure you are on the right cluster context for each task
   - Verify critical tasks by checking resource status

### When to Skip a Task
- You do not know how to start after reading it twice
- It requires complex YAML that you cannot find in the docs quickly
- You have been working on it for more than 8 minutes with no progress
- The task is worth few points relative to its difficulty

## Common kubectl Shortcuts and Imperative Commands

### Must-Know Imperative Commands

```bash
# Create resources quickly
k run nginx --image=nginx                              # Pod
k create deployment web --image=nginx --replicas=3     # Deployment
k expose deployment web --port=80 --type=NodePort      # Service
k create configmap cfg --from-literal=key=value        # ConfigMap
k create secret generic sec --from-literal=pass=123    # Secret
k create serviceaccount mysa                           # ServiceAccount
k create namespace dev                                 # Namespace
k create job myjob --image=busybox -- echo hello       # Job
k create cronjob mycj --image=busybox --schedule="*/5 * * * *" -- echo hi  # CronJob

# RBAC
k create role myrole --verb=get,list --resource=pods
k create clusterrole mycr --verb=get,list --resource=nodes
k create rolebinding myrb --role=myrole --user=jane
k create clusterrolebinding mycrb --clusterrole=mycr --user=jane

# Generate YAML without creating
k run nginx --image=nginx --dry-run=client -o yaml > pod.yaml
k create deployment web --image=nginx --dry-run=client -o yaml > deploy.yaml

# Quick edits
k edit deployment web
k set image deployment/web nginx=nginx:1.26
k scale deployment web --replicas=5
k label pod nginx env=prod
k annotate pod nginx description="my pod"

# Quick info
k get all -A                    # All resources in all namespaces
k get pods -o wide              # Pods with node and IP info
k get pods --show-labels        # Pods with labels
k explain pod.spec.containers   # API documentation for a field
k api-resources                 # List all resource types
```

### Context Switching (Critical for Exam)

Every task specifies which cluster context to use. Always switch context before starting a task.

```bash
# Switch to the specified context
kubectl config use-context <context-name>

# Verify you are on the right context
kubectl config current-context

# List all available contexts
kubectl config get-contexts
```

**Warning:** Working on the wrong cluster is the single most common exam mistake. It results in 0 points for the task even if your solution is correct.

### Output Formatting

```bash
# JSON output for scripting
k get pod nginx -o json

# YAML output for editing
k get pod nginx -o yaml

# Custom columns
k get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase

# JSONPath for specific fields
k get pods -o jsonpath='{.items[*].metadata.name}'
k get nodes -o jsonpath='{.items[*].status.addresses[0].address}'

# Sort by a field
k get pods --sort-by=.metadata.creationTimestamp
k get events --sort-by=.metadata.creationTimestamp
```

### Using kubectl explain

`kubectl explain` is an in-terminal API reference - extremely useful during the exam.

```bash
# Top-level fields
k explain pod
k explain pod.spec

# Drill into nested fields
k explain pod.spec.containers
k explain pod.spec.containers.resources
k explain pod.spec.affinity.nodeAffinity

# Show recursive structure
k explain pod.spec --recursive | grep -A5 volumes
```

## Common Exam Mistakes to Avoid

1. **Wrong cluster context** - always verify with `kubectl config current-context`
2. **Wrong namespace** - check if the task specifies a namespace, use `-n <namespace>`
3. **Typos in resource names** - double-check pod names, service names, etc.
4. **YAML indentation errors** - use `kubectl apply --dry-run=client -f file.yaml` to validate
5. **Forgetting to save in vim** - always `:wq` before applying
6. **Not reading the full task** - some tasks have multiple subtasks
7. **Over-engineering** - do the minimum required, do not add extras
8. **Not verifying your work** - always check that the resource was created correctly
9. **Spending too long on one task** - flag it and move on after 8 minutes
10. **Not using imperative commands** - writing YAML from scratch wastes time

## Pre-Exam Checklist

- [ ] Can you create pods, deployments, services imperatively from memory?
- [ ] Can you write PV/PVC YAML from memory or find it quickly in docs?
- [ ] Can you create RBAC resources (roles, bindings) imperatively?
- [ ] Can you backup and restore etcd without looking at notes?
- [ ] Can you perform a cluster upgrade with kubeadm?
- [ ] Can you create Network Policies by finding examples in the docs?
- [ ] Can you troubleshoot a broken pod (Pending, CrashLoopBackOff)?
- [ ] Can you troubleshoot a node that is NotReady?
- [ ] Can you configure Ingress resources?
- [ ] Are you comfortable with vim or nano for editing YAML?
- [ ] Do you know how to switch cluster contexts?
- [ ] Have you completed at least one killer.sh practice session?
