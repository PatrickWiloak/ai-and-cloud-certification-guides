# Certified Kubernetes Administrator (CKA) - Practice Questions

15 scenario-based questions for CKA prep. CKA is performance-based - these are conceptual reinforcement; for hands-on practice see [killer.sh](https://killer.sh) (free vouchers come with the exam) and the official docs.

> **Cert page:** [exams/kubernetes/cka/](../../exams/kubernetes/cka/)

---

### Question 1
**Scenario:** A pod is stuck in `Pending` state. `kubectl describe pod` shows `0/3 nodes are available: 3 Insufficient memory`. What's the right fix?

A. Delete and recreate the pod
B. Reduce the pod's memory `requests` or scale up the cluster
C. Drain a node
D. Restart the kubelet

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** "Insufficient memory" means the pod's memory requests don't fit on any node. Either reduce `resources.requests.memory` in the spec or add more node capacity. Recreating won't help - same scheduling problem. Draining reduces capacity. Kubelet restart is unrelated.
</details>

---

### Question 2
**Scenario:** You need to upgrade a 1.28 cluster to 1.29 using kubeadm. What's the correct order?

A. Upgrade all worker nodes, then control plane
B. Upgrade control plane (kubeadm + kubelet + kubectl), drain a worker, upgrade kubeadm + kubelet on that worker, uncordon, repeat
C. Upgrade kubelet on all nodes simultaneously
D. Upgrade etcd directly with binary replacement

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Kubernetes upgrade order is **always control plane first, then workers, one at a time**. The kubeadm process: `kubeadm upgrade plan` → `kubeadm upgrade apply v1.29.x` on first control plane → upgrade kubelet/kubectl → drain/upgrade/uncordon each worker. Worker-first violates the version-skew policy.
</details>

---

### Question 3
**Scenario:** A Deployment YAML has `replicas: 3` but only 1 pod is running. What's most likely?

A. Resource quota in the namespace caps pod count
B. Network policy blocking pod creation
C. The kubelet on 2 nodes is down
D. Any of the above

<details>
<summary>Answer</summary>

**Correct: D** (most likely A in practice; check `kubectl describe rs` events)

**Why:** Multiple causes. `kubectl describe replicaset` and `kubectl get events --sort-by=.metadata.creationTimestamp` are the diagnostic tools. ResourceQuota with a `pods` hard limit is the most common cause. Less commonly: insufficient cluster capacity, taints, or controller issues.
</details>

---

### Question 4
**Scenario:** You need to expose a Deployment so it's reachable on every node's IP at port 30080. What Service type?

A. ClusterIP
B. NodePort
C. LoadBalancer
D. ExternalName

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** NodePort exposes the service on each node's IP at the specified port (range 30000-32767). LoadBalancer adds a cloud LB on top of NodePort. ClusterIP is internal-only. ExternalName is a DNS CNAME.
</details>

---

### Question 5
**Scenario:** etcd backup task: take a snapshot of etcd on a control plane node. Which command?

A. `kubectl backup etcd`
B. `ETCDCTL_API=3 etcdctl snapshot save /backup/snap.db --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key`
C. `kubeadm reset etcd`
D. `systemctl backup etcd`

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** etcdctl with API v3 takes the snapshot. The TLS certs path is the kubeadm default. There's no `kubectl backup` command; `kubeadm reset` is destructive.
</details>

---

### Question 6
**Scenario:** A user `alice` should be able to read pods in namespace `dev` but nothing else. What objects?

A. ClusterRole + ClusterRoleBinding
B. Role + RoleBinding in `dev`
C. NetworkPolicy
D. ServiceAccount only

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Namespaced read = `Role` (not ClusterRole) in the `dev` namespace + `RoleBinding` for alice. ClusterRole+ClusterRoleBinding is cluster-wide. NetworkPolicy controls traffic, not RBAC. ServiceAccounts are for pods, not human users.
</details>

---

### Question 7
**Scenario:** A ConfigMap is mounted in a pod. You update the ConfigMap. The pod's mounted file isn't updating. Why?

A. ConfigMaps don't propagate to pods
B. Subkey mounts (volume.configMap.items) are not auto-updated; whole-volume mounts auto-refresh after a delay
C. You need to restart the cluster
D. ConfigMaps require a rolling update

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** When mounted as a volume **without** subPath, ConfigMap changes propagate (with a delay up to kubelet sync period, typically 60s). When mounted with `subPath`, the file is copied once and **not updated**. ConfigMaps as env vars also don't update. Use `kubectl rollout restart` if you need immediate refresh.
</details>

---

### Question 8
**Scenario:** PV is created but PVC stays `Pending` forever. The PV has accessModes `[ReadWriteMany]`, the PVC requests `[ReadWriteOnce]`. Why isn't it binding?

A. PV access modes must be a superset of PVC's, but they don't match exactly when `[RWX]` vs `[RWO]`
B. Storage class mismatch is more likely the cause
C. Capacity mismatch
D. Both A and B (PVC binding requires access mode in PV's set + storage class match + sufficient capacity)

<details>
<summary>Answer</summary>

**Correct: D**

**Why:** PVC binds to a PV when **all of**: PV's accessModes contains the PVC's requested mode, storageClassName matches (or both empty), and PV capacity >= PVC request. RWO + RWX in same PV is unusual; you'd need to look at all conditions.
</details>

---

### Question 9
**Scenario:** A node is unreachable. Pods on it stay running for 5 minutes, then start failing over. Why the delay?

A. `pod-eviction-timeout` defaults to 5 minutes; the controller waits before evicting
B. Kubelet stops responding immediately
C. Pods crash because etcd loses node state
D. There's a randomized backoff

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** `kube-controller-manager` waits `--pod-eviction-timeout` (default 5m) after a node becomes `NotReady` before evicting pods. This avoids unnecessary churn from transient network blips. Tunable on the kube-controller-manager flag.
</details>

---

### Question 10
**Scenario:** A pod must run only on nodes with a specific GPU type. You set a taint `gpu=v100:NoSchedule` on those nodes. What does the pod need?

A. nodeSelector with `gpu: v100`
B. A toleration matching the taint
C. Both A and B
D. Affinity rules

<details>
<summary>Answer</summary>

**Correct: C**

**Why:** Taints repel pods unless they have a matching toleration. But a toleration only **allows** the pod to land there; it doesn't **require** it. To force the pod onto GPU nodes specifically, also add nodeSelector or nodeAffinity matching the GPU label.
</details>

---

### Question 11
**Scenario:** Which command shows the resource usage of all pods sorted by CPU?

A. `kubectl top pods`
B. `kubectl top pods --sort-by=cpu`
C. `kubectl top pods -A --sort-by=cpu`
D. `kubectl describe pods | grep CPU`

<details>
<summary>Answer</summary>

**Correct: C**

**Why:** `kubectl top` requires the metrics-server to be installed. `-A` (all namespaces) + `--sort-by=cpu` gives the full picture sorted by CPU usage.
</details>

---

### Question 12
**Scenario:** A NetworkPolicy is created with `policyTypes: [Ingress]` and an empty ingress rule. What's the effect on selected pods?

A. All ingress allowed
B. All ingress blocked
C. No change
D. Egress also blocked

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** A NetworkPolicy that selects pods and has an empty `ingress: []` (or no ingress block but `policyTypes: [Ingress]`) means **all ingress is denied**. To allow some, add specific `ingress` rules.
</details>

---

### Question 13
**Scenario:** kube-proxy mode iptables vs IPVS - which scales better for thousands of services?

A. iptables; it's the default and battle-tested
B. IPVS; it uses hash tables for O(1) lookup vs iptables' O(n)
C. They scale identically
D. Neither - use a service mesh

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** With many services, iptables rule chains grow linearly and lookup gets slow. IPVS uses hash tables and scales much better. Most large clusters switch to IPVS at scale (and it supports more LB algorithms - rr, lc, sh, etc.).
</details>

---

### Question 14
**Scenario:** A Pod has a `livenessProbe` that fails. What happens?

A. The pod is deleted and rescheduled
B. The container is restarted (in-place); the pod stays scheduled
C. The pod is moved to another node
D. The deployment scales up

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Liveness failures restart the **container** in the same pod (kubelet kills + restarts according to restartPolicy). The pod itself stays scheduled. Readiness failures only remove the pod from Service endpoints; they don't restart anything.
</details>

---

### Question 15
**Scenario:** You need to drain a node for maintenance with active workloads. Which command?

A. `kubectl delete node <name>`
B. `kubectl drain <name> --ignore-daemonsets --delete-emptydir-data`
C. `kubectl cordon <name>`
D. `systemctl stop kubelet` on that node

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** `drain` cordons the node (no new pods scheduled) AND evicts running pods. `--ignore-daemonsets` is required because DaemonSet pods can't be evicted. `--delete-emptydir-data` is required if any pods use emptyDir volumes. `cordon` alone doesn't evict. `delete node` is destructive. Stopping kubelet kills the node uncleanly.
</details>

---

### Question 16
**Scenario:** A Service of type ClusterIP isn't reachable from inside the cluster. `kubectl get endpoints <svc>` returns no addresses. What's most likely?

A. The Service spec is wrong
B. The Service's `selector` doesn't match any Pod labels
C. The Pods are in a different namespace
D. CoreDNS is down

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Empty endpoints means no Pods match the Service's `selector`. Either the labels in the Service selector are wrong, or the Pods don't have those labels (yet). `kubectl get pods -l <selector>` confirms. CoreDNS being down would still show endpoints if the selector matched.
</details>

---

### Question 17
**Scenario:** You need to give a CI service account read-only access to all resources in the `staging` namespace. What's the minimal correct setup?

A. ClusterRole with full read permissions, ClusterRoleBinding to the service account
B. Role in `staging` namespace with `verbs: [get, list, watch]`, RoleBinding to the service account
C. Edit the kube-system service account
D. Run the CI as cluster-admin

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Role is namespace-scoped (matching "all resources in staging"); RoleBinding grants it. ClusterRole + ClusterRoleBinding (A) gives access to ALL namespaces. C is dangerous and wrong scope. D is least-privilege violation.
</details>

---

### Question 18
**Scenario:** A pod's container exits with `OOMKilled`. What's the right first action?

A. Lower `resources.limits.memory`
B. Increase `resources.limits.memory` (and `requests` if needed)
C. Disable OOM kills on the node
D. Switch to a different node

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** OOMKilled means the container exceeded its memory limit. The fix is to raise the limit (after profiling the actual need) or to fix the memory leak. Lowering makes it worse. Disabling OOM is dangerous. Different node won't help if the limit is the issue.
</details>

---

### Question 19
**Scenario:** You want to schedule a Pod only on nodes labeled `disk=ssd`. What's the standard mechanism?

A. `nodeSelector: { disk: ssd }`
B. `tolerations` for `disk=ssd`
C. Manually choose the node in the spec
D. `priorityClassName: ssd-only`

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** `nodeSelector` is the simplest matching mechanism. For more complex rules, `nodeAffinity` is the modern replacement. Tolerations are paired with taints (different concept - taints repel; tolerations let pods land on tainted nodes). Priority is for scheduling order, not target.
</details>

---

### Question 20
**Scenario:** A NetworkPolicy denies all ingress to namespace `app`. You need to allow traffic from namespace `web` only. What's the right rule?

A. NetworkPolicy with `podSelector: {}` and ingress from a `namespaceSelector` matching `web`
B. RBAC role
C. Service Account binding
D. Edit the CNI directly

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** NetworkPolicy is the K8s primitive for L3/L4 traffic control. `podSelector: {}` selects all pods in the policy's namespace; ingress from `namespaceSelector` allows traffic from another namespace. RBAC is API-level, not network-level. Editing CNI directly is wrong abstraction layer. Note: the cluster's CNI must support NetworkPolicy (Calico, Cilium yes; flannel without extensions no).
</details>

---

### Question 21
**Scenario:** You apply a Deployment manifest. Pods come up but immediately CrashLoopBackOff. `kubectl logs` shows the container can't connect to its database. What do you check first?

A. Service exists and resolves the DB hostname; ConfigMap / Secret with DB creds is mounted; NetworkPolicy doesn't block egress
B. Restart all nodes
C. Increase replica count
D. Disable health checks

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** CrashLoopBackOff with a connection error is almost always: wrong DB hostname / port (Service or DNS issue), wrong credentials (Secret not mounted), or NetworkPolicy blocking. Check those three. B/C/D don't address connectivity.
</details>

---

### Question 22
**Scenario:** A StatefulSet has 3 replicas. You delete pod-1 (the middle one). What happens?

A. K8s recreates pod-1 with the same name and same PVC binding
B. K8s renames the remaining pods sequentially (pod-0, pod-1)
C. The StatefulSet enters a degraded state
D. The PVC is deleted

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** StatefulSets give pods stable identities (`pod-0`, `pod-1`, `pod-2`). Deleting one causes K8s to recreate it with the same name and re-bind to the same PersistentVolumeClaim. This is what makes StatefulSets suitable for databases. Renaming would defeat the purpose. PVCs are not deleted with the pod.
</details>

---

### Question 23
**Scenario:** You need to expose a Deployment to the internet on a managed K8s service (EKS / AKS / GKE). What's the standard way?

A. `Service` of type `LoadBalancer`
B. Pod with `hostNetwork: true`
C. Manually configure cloud LB outside K8s
D. NodePort + manual cloud LB pointing at NodePort

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** `Service` type `LoadBalancer` provisions a cloud LB automatically (ELB/ALB on AWS, ALB on Azure, NLB on GCP). For HTTP/L7 you'd typically use Ingress + an Ingress controller, but for any single port the LoadBalancer Service is the K8s-native pattern. B is anti-pattern. D is what `LoadBalancer` does for you.
</details>

---

### Question 24
**Scenario:** etcd backup. What's the correct command to take a snapshot?

A. `etcdctl snapshot save backup.db --cacert ... --cert ... --key ...` (with appropriate cert paths and the etcd endpoint)
B. `kubectl backup etcd`
C. `cp -r /var/lib/etcd /backups/`
D. `systemctl stop etcd && tar -czf etcd.tar.gz /var/lib/etcd`

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** `etcdctl snapshot save` is the documented way to take a consistent backup of etcd while it's running. B isn't a kubectl subcommand. C copies live data files (not consistent). D works but takes the cluster down.
</details>

---

### Question 25
**Scenario:** You need to enforce that all pods in a namespace must have CPU/memory `requests` and `limits` set. What's the right tool?

A. LimitRange + ResourceQuota in the namespace
B. NetworkPolicy
C. PodSecurityPolicy
D. ClusterRole

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** LimitRange enforces per-pod / per-container defaults and constraints (default requests / limits, max / min). ResourceQuota enforces aggregate namespace limits. Together they ensure every pod has resource specs. NetworkPolicy is networking. PSP is deprecated (replaced by Pod Security Admission). ClusterRole is RBAC.
</details>

---

## Scoring guide

- **22-25 correct (85%+):** Strong. Combine with killer.sh for hands-on practice and schedule the exam.
- **17-21 correct (65-80%):** Re-read weak-area notes; do more hands-on with `kubectl`.
- **<17:** Spend more time on the official `kubernetes.io` docs and hands-on labs before retesting.

The CKA exam is **performance-based** with 15-20 hands-on tasks in 2 hours. These multiple-choice questions test conceptual understanding; you also need fluency with `kubectl` and YAML.
