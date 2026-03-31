# CKA Study Plan

## 6-Week Hands-On Study Schedule

This study plan emphasizes hands-on practice over reading. The CKA is a performance-based exam - you must be able to execute commands and solve problems in a live terminal. Every day should include at least 60 minutes of practice in a real Kubernetes cluster.

### Practice Environment Setup

Before starting, set up your practice environment:
- [ ] Install Minikube, kind, or k3s on your local machine
- [ ] Alternatively, use KodeKloud or Play with Kubernetes for browser-based labs
- [ ] Install kubectl and verify it connects to your cluster
- [ ] Bookmark the [kubectl cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

---

### Week 1: Cluster Architecture & Core Concepts

**Focus:** Understand how clusters work, install a cluster with kubeadm, learn core resources.

#### Day 1-2: Kubernetes Architecture
- [ ] Study control plane components (API server, etcd, scheduler, controller manager)
- [ ] Study worker node components (kubelet, kube-proxy, container runtime)
- [ ] Practice: Inspect your cluster with `kubectl get pods -n kube-system`
- [ ] Practice: Run `kubectl describe` on each control plane component
- [ ] Practice: Check kubelet status with `systemctl status kubelet`
- [ ] Review Notes: `notes/01-cluster-architecture.md`

#### Day 3-4: Cluster Installation with kubeadm
- [ ] Set up two VMs (Vagrant, VirtualBox, or cloud VMs)
- [ ] Practice: Install a cluster from scratch using kubeadm
  - [ ] `kubeadm init` on control plane node
  - [ ] Install a CNI plugin (Calico or Flannel)
  - [ ] `kubeadm join` on worker node
- [ ] Practice: Verify cluster is functional with `kubectl get nodes`
- [ ] Practice: Destroy and rebuild the cluster at least twice
- [ ] Review: [Creating a cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)

#### Day 5-6: Pods, Namespaces, and Labels
- [ ] Practice: Create pods imperatively with `kubectl run`
- [ ] Practice: Create pods from YAML with `kubectl apply -f`
- [ ] Practice: Use `--dry-run=client -o yaml` to generate YAML templates
- [ ] Practice: Create and switch between namespaces
- [ ] Practice: Label pods and filter with `kubectl get pods -l app=nginx`
- [ ] Practice: Multi-container pods (sidecar pattern)

**Practice Commands:**
```bash
kubectl run nginx --image=nginx --port=80
kubectl run nginx --image=nginx --dry-run=client -o yaml > pod.yaml
kubectl create namespace dev
kubectl run nginx --image=nginx -n dev
kubectl label pod nginx env=prod
kubectl get pods -l env=prod
```

#### Day 7: Week 1 Review
- [ ] Rebuild a cluster with kubeadm from memory (no notes)
- [ ] Create 5 different pod configurations imperatively in under 10 minutes
- [ ] Review any weak areas from the week

---

### Week 2: Workloads, Scheduling & Configuration

**Focus:** Deployments, scaling, scheduling, ConfigMaps, and Secrets.

#### Day 8-9: Deployments and ReplicaSets
- [ ] Practice: Create Deployments imperatively and from YAML
- [ ] Practice: Scale deployments up and down
- [ ] Practice: Perform rolling updates by changing the image
- [ ] Practice: Rollback to a previous revision
- [ ] Practice: View rollout history and status
- [ ] Review Notes: `notes/02-workloads-scheduling.md`

**Practice Commands:**
```bash
kubectl create deployment web --image=nginx:1.24 --replicas=3
kubectl set image deployment/web nginx=nginx:1.25
kubectl rollout status deployment/web
kubectl rollout history deployment/web
kubectl rollout undo deployment/web --to-revision=1
kubectl scale deployment/web --replicas=5
```

#### Day 10-11: Jobs, CronJobs, DaemonSets, StatefulSets
- [ ] Practice: Create Jobs with completion counts and parallelism
- [ ] Practice: Create CronJobs with different schedules
- [ ] Practice: Create a DaemonSet from YAML
- [ ] Practice: Create a StatefulSet with a headless service
- [ ] Review each workload type's use cases

**Practice Commands:**
```bash
kubectl create job backup --image=busybox -- echo "backup done"
kubectl create cronjob report --image=busybox --schedule="*/5 * * * *" -- echo "report"
```

#### Day 12-13: Scheduling - Taints, Tolerations, Affinity
- [ ] Practice: Taint nodes and observe scheduling behavior
- [ ] Practice: Add tolerations to pods to schedule on tainted nodes
- [ ] Practice: Use nodeSelector to pin pods to specific nodes
- [ ] Practice: Write nodeAffinity rules (required and preferred)
- [ ] Practice: Write podAntiAffinity rules to spread pods across nodes

**Practice Commands:**
```bash
kubectl taint nodes worker-1 key=value:NoSchedule
kubectl taint nodes worker-1 key=value:NoSchedule-
kubectl label nodes worker-1 disktype=ssd
```

#### Day 14: ConfigMaps, Secrets, and Resource Limits
- [ ] Practice: Create ConfigMaps from literals and files
- [ ] Practice: Mount ConfigMaps as env vars and volumes
- [ ] Practice: Create Secrets and mount them in pods
- [ ] Practice: Set resource requests and limits on containers
- [ ] Practice: Create a LimitRange and ResourceQuota

---

### Week 3: Services, Networking & Ingress

**Focus:** Service types, Ingress, Network Policies, DNS.

#### Day 15-16: Services
- [ ] Practice: Create ClusterIP, NodePort, and LoadBalancer services
- [ ] Practice: Expose a deployment with `kubectl expose`
- [ ] Practice: Verify service endpoints with `kubectl get endpoints`
- [ ] Practice: Test service connectivity from within the cluster
- [ ] Practice: Create a headless service for a StatefulSet
- [ ] Review Notes: `notes/03-services-networking.md`

**Practice Commands:**
```bash
kubectl expose deployment web --port=80 --type=ClusterIP
kubectl expose deployment web --port=80 --type=NodePort
kubectl run test --image=busybox --rm -it -- wget -O- http://web:80
kubectl get endpoints web
```

#### Day 17-18: Ingress
- [ ] Install an NGINX Ingress controller in your cluster
- [ ] Practice: Create Ingress with path-based routing
- [ ] Practice: Create Ingress with host-based routing
- [ ] Practice: Configure TLS on an Ingress resource
- [ ] Practice: Troubleshoot Ingress routing issues

#### Day 19-20: Network Policies
- [ ] Practice: Create a default deny-all ingress policy
- [ ] Practice: Create a default deny-all egress policy
- [ ] Practice: Allow traffic from specific pods using podSelector
- [ ] Practice: Allow traffic from specific namespaces using namespaceSelector
- [ ] Practice: Combine ingress and egress rules in a single policy
- [ ] Practice: Test policies by running curl/wget from test pods

**Practice Exercise:**
```bash
# Create namespace with two apps
kubectl create ns netpol-test
kubectl run frontend --image=nginx -n netpol-test -l role=frontend
kubectl run backend --image=nginx -n netpol-test -l role=backend
# Create a network policy that only allows frontend to reach backend on port 80
# Test with: kubectl exec frontend -n netpol-test -- wget -O- backend:80
```

#### Day 21: DNS and Service Discovery
- [ ] Practice: Resolve service DNS names from within pods
- [ ] Practice: Use FQDN format: `<svc>.<ns>.svc.cluster.local`
- [ ] Practice: Check CoreDNS pods and configuration
- [ ] Practice: Troubleshoot DNS resolution failures

---

### Week 4: Storage & Security

**Focus:** PV/PVC, Storage Classes, RBAC, Security Contexts.

#### Day 22-23: Persistent Volumes and Claims
- [ ] Practice: Create a PV with hostPath
- [ ] Practice: Create a PVC that binds to the PV
- [ ] Practice: Mount the PVC in a pod
- [ ] Practice: Create a PV and PVC that do NOT bind (mismatched access mode or size)
- [ ] Practice: Fix the mismatch and make them bind
- [ ] Review Notes: `notes/04-storage.md`

#### Day 24-25: Storage Classes and Volume Types
- [ ] Practice: Create a Storage Class with `kubernetes.io/no-provisioner`
- [ ] Practice: Set a default storage class
- [ ] Practice: Mount emptyDir, hostPath, configMap, and secret volumes
- [ ] Practice: Expand a PVC (if volume expansion is enabled)

**Practice Exercise:**
```bash
# Create a complete PV -> PVC -> Pod chain from scratch in under 5 minutes
# Repeat until you can do it without referencing documentation
```

#### Day 26-27: RBAC
- [ ] Practice: Create Roles with specific verb/resource combinations
- [ ] Practice: Create ClusterRoles for cluster-scoped resources
- [ ] Practice: Create RoleBindings for users and service accounts
- [ ] Practice: Create ClusterRoleBindings
- [ ] Practice: Test permissions with `kubectl auth can-i`
- [ ] Practice: Create a service account and bind a role to it
- [ ] Review Notes: `notes/05-security-rbac.md`

**Practice Commands:**
```bash
kubectl create role dev-role --verb=get,list,create --resource=pods,deployments -n dev
kubectl create rolebinding dev-binding --role=dev-role --user=jane -n dev
kubectl auth can-i create pods --as=jane -n dev
kubectl create serviceaccount app-sa -n dev
kubectl create rolebinding sa-binding --role=dev-role --serviceaccount=dev:app-sa -n dev
kubectl auth can-i list pods --as=system:serviceaccount:dev:app-sa -n dev
```

#### Day 28: Security Contexts and Certificates
- [ ] Practice: Run a pod as a specific user (runAsUser)
- [ ] Practice: Set readOnlyRootFilesystem
- [ ] Practice: Drop all capabilities and add specific ones
- [ ] Practice: Create a CSR and approve it
- [ ] Practice: Check certificate expiration with kubeadm

---

### Week 5: Troubleshooting & etcd

**Focus:** The largest exam domain (30%). Practice diagnosing and fixing broken clusters.

#### Day 29-30: Application Troubleshooting
- [ ] Practice: Fix a pod stuck in Pending (resource limits too high)
- [ ] Practice: Fix a pod in CrashLoopBackOff (wrong command)
- [ ] Practice: Fix a pod in ImagePullBackOff (wrong image name)
- [ ] Practice: Debug a pod that starts but does not serve traffic (wrong port)
- [ ] Practice: Use `kubectl logs`, `kubectl describe`, and `kubectl exec`
- [ ] Review Notes: `notes/06-troubleshooting.md`

**Practice Exercise:**
```bash
# Create a broken deployment and fix it
kubectl create deployment broken --image=ngnix:latest  # typo in image name
kubectl describe pod <broken-pod>  # See the error
kubectl set image deployment/broken ngnix=nginx:latest  # Fix it
```

#### Day 31-32: Cluster Component Troubleshooting
- [ ] Practice: Break the kube-scheduler static pod manifest and fix it
- [ ] Practice: Break the kube-controller-manager manifest and fix it
- [ ] Practice: Stop kubelet on a worker node and observe NotReady status
- [ ] Practice: Fix kubelet by restarting the service
- [ ] Practice: Intentionally corrupt an etcd flag and fix it

**Practice Exercise:**
```bash
# SSH to control plane and intentionally break the scheduler
# Edit /etc/kubernetes/manifests/kube-scheduler.yaml (change port or image)
# Observe pods stuck in Pending
# Fix the manifest and verify scheduling resumes
```

#### Day 33-34: etcd Backup and Restore
- [ ] Practice: Take an etcd snapshot backup
- [ ] Practice: Restore etcd from a backup
- [ ] Practice: Verify the cluster state after restore
- [ ] Practice: Do the full backup/restore cycle 5+ times until memorized
- [ ] Review: [Operating etcd](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/)

**Practice Commands:**
```bash
# Backup
ETCDCTL_API=3 etcdctl snapshot save /opt/backup.db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key

# Restore
ETCDCTL_API=3 etcdctl snapshot restore /opt/backup.db --data-dir=/var/lib/etcd-new
# Then update etcd static pod manifest to use /var/lib/etcd-new
```

#### Day 35: Cluster Upgrade Practice
- [ ] Practice: Upgrade a cluster from one minor version to the next
- [ ] Practice: Upgrade control plane node (kubeadm, kubelet, kubectl)
- [ ] Practice: Upgrade worker node (drain, upgrade, uncordon)
- [ ] Practice: Do the full upgrade cycle at least 3 times

---

### Week 6: Mock Exams & Speed Drills

**Focus:** Timed practice, exam simulation, speed improvement.

#### Day 36-37: Killer.sh Exam Simulator (Session 1)
- [ ] Activate your first killer.sh session (included with exam purchase)
- [ ] Complete the full simulation under exam conditions (2 hours, no extra resources)
- [ ] Review every question, especially those you got wrong or skipped
- [ ] Note which topics need more practice
- [ ] Review Notes: `notes/07-exam-environment-tips.md`

#### Day 38-39: Targeted Practice on Weak Areas
- [ ] Based on killer.sh results, practice weak topics
- [ ] Do speed drills: complete common tasks in under 3 minutes each
  - [ ] Create a deployment, expose it, scale it
  - [ ] Create PV/PVC and mount in a pod
  - [ ] Create RBAC role and binding
  - [ ] Create a Network Policy
  - [ ] Perform etcd backup/restore
  - [ ] Troubleshoot a broken pod

#### Day 40-41: Killer.sh Exam Simulator (Session 2)
- [ ] Activate your second killer.sh session
- [ ] Complete the full simulation under exam conditions
- [ ] Target score: 80%+ (killer.sh is harder than the real exam)
- [ ] Review all mistakes and solidify understanding

#### Day 42: Final Review and Exam Day Prep
- [ ] Light review of key concepts only
- [ ] Practice your exam setup routine (aliases, vim config)
- [ ] Review the exam environment tips
- [ ] Confirm exam appointment and technical requirements
- [ ] Get a good night's sleep

---

## Daily Study Routine (2-3 hours/day)

### Recommended Schedule
1. **30 minutes**: Review study notes and documentation
2. **90 minutes**: Hands-on practice in a real cluster
3. **30 minutes**: Speed drills - repeat common tasks for muscle memory

### Weekend Extended Sessions (4-6 hours)
1. **2 hours**: Complex lab exercises (cluster setup, upgrades, troubleshooting)
2. **2 hours**: Timed mock exams or scenario practice
3. **1-2 hours**: Review and weak area remediation

## Progress Tracking

### Weekly Milestones
- [ ] Week 1: Can build a cluster with kubeadm and create basic resources
- [ ] Week 2: Can manage workloads, scheduling, and configuration
- [ ] Week 3: Can configure services, ingress, and network policies
- [ ] Week 4: Can set up storage and RBAC from memory
- [ ] Week 5: Can troubleshoot broken pods, nodes, and cluster components
- [ ] Week 6: Scoring 80%+ on killer.sh mock exams

### Speed Benchmarks
By exam day, you should be able to complete these tasks in the listed times:
- [ ] Create a deployment and expose it: under 1 minute
- [ ] Create PV + PVC + Pod with mount: under 3 minutes
- [ ] Create Role + RoleBinding: under 2 minutes
- [ ] etcd backup: under 2 minutes
- [ ] etcd restore: under 5 minutes
- [ ] Create a Network Policy: under 3 minutes
- [ ] Troubleshoot a broken pod: under 3 minutes
- [ ] Perform kubeadm cluster upgrade: under 10 minutes

## Study Resources

**[Complete Kubernetes Study Resources Guide](../../../resources/)**

### Quick Links (CKA Specific)
- **[CKA Official Exam Page](https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/)** - Registration
- **[Kubernetes Documentation](https://kubernetes.io/docs/)** - Allowed during the exam
- **[killer.sh](https://killer.sh/)** - Exam simulator (2 sessions with purchase)
- **[KodeKloud CKA Course](https://kodekloud.com/)** - Interactive labs

---

## Final Exam Checklist

### One Week Before
- [ ] Completed both killer.sh sessions with 80%+ score
- [ ] Can perform etcd backup/restore from memory
- [ ] Can upgrade a cluster with kubeadm from memory
- [ ] Comfortable with RBAC, Network Policies, and PV/PVC creation
- [ ] Can troubleshoot common pod and node issues efficiently

### Day Before Exam
- [ ] Light review only - do not cram
- [ ] Test your webcam, microphone, and internet connection
- [ ] Prepare your workspace (clean desk, quiet room)
- [ ] Have your government-issued ID ready
- [ ] Get adequate sleep

### Exam Day
- [ ] Log in 15-30 minutes early
- [ ] Set up aliases and vim config first (`alias k=kubectl`)
- [ ] Read each task completely before starting
- [ ] Always check cluster context before each task
- [ ] Flag difficult tasks and return to them
- [ ] Verify your work before moving on
