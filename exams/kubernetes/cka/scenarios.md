# CKA Hands-On Scenario Practice

## About These Scenarios

These scenarios simulate the types of tasks you will encounter on the CKA exam. Each scenario provides a task description (similar to what you would see on the exam), the approach to solve it, and common mistakes to avoid.

**Important:** Practice these in a real Kubernetes cluster. Reading the solutions is not enough - you must type the commands and build the muscle memory.

---

## Scenario 1: Cluster Upgrade with kubeadm

### Task

Upgrade the Kubernetes cluster from v1.28.0 to v1.29.0. The cluster has one control plane node (`controlplane`) and one worker node (`worker-1`). Upgrade the control plane node first, then the worker node. Ensure workloads continue running during the upgrade.

### Solution Approach

**Control Plane Node:**
```bash
# SSH to control plane node
ssh controlplane

# 1. Upgrade kubeadm
apt-mark unhold kubeadm
apt-get update && apt-get install -y kubeadm=1.29.0-1.1
apt-mark hold kubeadm

# 2. Check upgrade plan
kubeadm upgrade plan

# 3. Apply upgrade
kubeadm upgrade apply v1.29.0

# 4. Drain the node
kubectl drain controlplane --ignore-daemonsets --delete-emptydir-data

# 5. Upgrade kubelet and kubectl
apt-mark unhold kubelet kubectl
apt-get update && apt-get install -y kubelet=1.29.0-1.1 kubectl=1.29.0-1.1
apt-mark hold kubelet kubectl

# 6. Restart kubelet
systemctl daemon-reload
systemctl restart kubelet

# 7. Uncordon
kubectl uncordon controlplane
```

**Worker Node:**
```bash
# SSH to worker node
ssh worker-1

# 1. Upgrade kubeadm
apt-mark unhold kubeadm
apt-get update && apt-get install -y kubeadm=1.29.0-1.1
apt-mark hold kubeadm

# 2. Upgrade node config
kubeadm upgrade node

# 3. From control plane: drain the worker
kubectl drain worker-1 --ignore-daemonsets --delete-emptydir-data

# 4. On worker: upgrade kubelet and kubectl
apt-mark unhold kubelet kubectl
apt-get update && apt-get install -y kubelet=1.29.0-1.1 kubectl=1.29.0-1.1
apt-mark hold kubelet kubectl

# 5. Restart kubelet
systemctl daemon-reload
systemctl restart kubelet

# 6. From control plane: uncordon
kubectl uncordon worker-1
```

### Common Mistakes
- Forgetting to drain the node before upgrading kubelet
- Using `kubeadm upgrade apply` on worker nodes (use `kubeadm upgrade node` instead)
- Not restarting kubelet after the upgrade
- Forgetting to uncordon the node after the upgrade
- Not running `systemctl daemon-reload` before restarting kubelet

---

## Scenario 2: etcd Backup and Restore

### Task

Create a backup of the etcd cluster data and save it to `/opt/etcd-backup.db`. Then restore the cluster from a previous backup file located at `/opt/etcd-backup-previous.db`.

### Solution Approach

**Backup:**
```bash
# Find etcd certificate paths (check the static pod manifest)
cat /etc/kubernetes/manifests/etcd.yaml | grep -E "\-\-cert|\-\-key|\-\-cacert"

# Take the backup
ETCDCTL_API=3 etcdctl snapshot save /opt/etcd-backup.db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key

# Verify
ETCDCTL_API=3 etcdctl snapshot status /opt/etcd-backup.db --write-table
```

**Restore:**
```bash
# Restore to a new data directory
ETCDCTL_API=3 etcdctl snapshot restore /opt/etcd-backup-previous.db \
  --data-dir=/var/lib/etcd-restored

# Update etcd static pod to use the new data directory
vi /etc/kubernetes/manifests/etcd.yaml
# Change: --data-dir=/var/lib/etcd-restored
# Change the hostPath volume:
#   volumes:
#   - hostPath:
#       path: /var/lib/etcd-restored
#       type: DirectoryOrCreate
#     name: etcd-data

# Wait for etcd to restart with the restored data
kubectl get pods -n kube-system | grep etcd
```

### Common Mistakes
- Forgetting `ETCDCTL_API=3` (defaults to v2 API which has different syntax)
- Using wrong certificate paths (always check the static pod manifest first)
- Restoring to the same directory `/var/lib/etcd` (use a new directory)
- Forgetting to update BOTH the `--data-dir` flag AND the `hostPath` volume in the static pod manifest
- Not waiting for etcd to restart before verifying

---

## Scenario 3: RBAC Configuration

### Task

Create a new user `developer` in the `development` namespace with the following permissions:
- Can create, get, list, and delete Pods
- Can get and list Deployments
- Can get and list Services
- Cannot access any other resources

### Solution Approach

```bash
# Create the namespace if it does not exist
kubectl create namespace development

# Create a Role with the specified permissions
kubectl create role developer-role \
  --verb=create,get,list,delete --resource=pods \
  --verb=get,list --resource=deployments \
  --verb=get,list --resource=services \
  -n development

# Note: The above command may not work correctly for different verbs per resource.
# Use YAML instead:
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: developer-role
  namespace: development
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["create", "get", "list", "delete"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "list"]
- apiGroups: [""]
  resources: ["services"]
  verbs: ["get", "list"]
EOF

# Bind the role to the user
kubectl create rolebinding developer-binding \
  --role=developer-role \
  --user=developer \
  -n development

# Verify
kubectl auth can-i create pods --as=developer -n development       # yes
kubectl auth can-i delete pods --as=developer -n development       # yes
kubectl auth can-i create deployments --as=developer -n development # no
kubectl auth can-i get services --as=developer -n development       # yes
kubectl auth can-i list secrets --as=developer -n development       # no
```

### Common Mistakes
- Forgetting the correct apiGroup (Deployments are in `apps`, Services and Pods are in `""`)
- Creating a ClusterRole instead of a Role (task specifies namespace-scoped)
- Forgetting to specify the namespace in the RoleBinding
- Not verifying permissions with `kubectl auth can-i`

---

## Scenario 4: Network Policy Creation

### Task

In the `production` namespace, create a Network Policy named `backend-policy` that:
- Applies to pods with label `role=backend`
- Allows ingress traffic only from pods with label `role=frontend` on port 8080
- Allows egress traffic only to pods with label `role=database` on port 5432
- Allows egress to DNS (port 53 UDP and TCP) for all destinations

### Solution Approach

```yaml
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-policy
  namespace: production
spec:
  podSelector:
    matchLabels:
      role: backend
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: frontend
    ports:
    - protocol: TCP
      port: 8080
  egress:
  - to:
    - podSelector:
        matchLabels:
          role: database
    ports:
    - protocol: TCP
      port: 5432
  - ports:
    - protocol: UDP
      port: 53
    - protocol: TCP
      port: 53
EOF
```

### Verification
```bash
# Test from frontend to backend (should work on port 8080)
kubectl exec -n production frontend-pod -- wget -O- -T 3 http://backend-pod:8080

# Test from a non-frontend pod (should fail)
kubectl exec -n production other-pod -- wget -O- -T 3 http://backend-pod:8080
```

### Common Mistakes
- Forgetting to specify `policyTypes` - without it, the policy may not enforce egress rules
- Forgetting DNS egress - pods cannot resolve service names without DNS access
- AND vs OR logic confusion - items in the same `from`/`to` entry use AND, separate entries use OR
- Not applying the policy to the correct namespace

---

## Scenario 5: Persistent Volume and Claim Setup

### Task

Create a Persistent Volume named `data-pv` with the following specifications:
- Capacity: 2Gi
- Access mode: ReadWriteOnce
- Host path: `/mnt/data`
- Storage class: `manual`

Create a Persistent Volume Claim named `data-pvc` that requests 1Gi of storage from the `manual` storage class.

Create a pod named `data-pod` using the `nginx` image that mounts the PVC at `/usr/share/nginx/html`.

### Solution Approach

```yaml
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: data-pv
spec:
  capacity:
    storage: 2Gi
  accessModes:
  - ReadWriteOnce
  storageClassName: manual
  hostPath:
    path: /mnt/data
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-pvc
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: manual
  resources:
    requests:
      storage: 1Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: data-pod
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - name: data-volume
      mountPath: /usr/share/nginx/html
  volumes:
  - name: data-volume
    persistentVolumeClaim:
      claimName: data-pvc
EOF
```

### Verification
```bash
# Check PV is bound
kubectl get pv data-pv

# Check PVC is bound
kubectl get pvc data-pvc

# Check pod is running and volume is mounted
kubectl get pod data-pod
kubectl exec data-pod -- ls /usr/share/nginx/html
```

### Common Mistakes
- `storageClassName` not matching between PV and PVC
- Access mode not matching between PV and PVC
- PVC requesting more storage than the PV provides
- Putting `volumeMounts` under `spec` instead of `spec.containers[].volumeMounts`
- Putting `volumes` under `spec.containers` instead of `spec.volumes`

---

## Scenario 6: Deployment Scaling and Service Exposure

### Task

Create a Deployment named `web-app` with the `httpd:2.4` image and 2 replicas. Then:
1. Scale the deployment to 5 replicas
2. Expose it as a NodePort service named `web-app-svc` on port 80
3. Verify the service has 5 endpoints

### Solution Approach

```bash
# Create the deployment
kubectl create deployment web-app --image=httpd:2.4 --replicas=2

# Scale to 5 replicas
kubectl scale deployment web-app --replicas=5

# Wait for pods to be ready
kubectl rollout status deployment web-app

# Expose as NodePort service
kubectl expose deployment web-app --name=web-app-svc --port=80 --type=NodePort

# Verify endpoints
kubectl get endpoints web-app-svc
# Should show 5 IP addresses

# Test the service
kubectl run test --image=busybox --rm -it --restart=Never -- wget -O- -T 5 http://web-app-svc:80
```

### Common Mistakes
- Forgetting to wait for pods to be ready before checking endpoints
- Using wrong service name (task specifies `web-app-svc`, not `web-app`)
- Not verifying the endpoint count matches the replica count

---

## Scenario 7: Troubleshooting a Broken Pod

### Task

A pod named `web-server` in the `default` namespace is not running. Diagnose the issue and fix it so the pod runs successfully.

### Solution Approach

```bash
# Step 1: Check pod status
kubectl get pod web-server
# Example output: web-server   0/1   CrashLoopBackOff   5   3m

# Step 2: Describe the pod for events
kubectl describe pod web-server
# Look at Events section for clues

# Step 3: Check logs
kubectl logs web-server
kubectl logs web-server --previous  # If CrashLoopBackOff

# Step 4: Check the pod specification
kubectl get pod web-server -o yaml

# Common fixes based on diagnosis:

# Fix 1: Wrong image name
kubectl edit pod web-server  # Cannot edit most fields on a running pod
# Instead: get YAML, delete pod, fix YAML, recreate
kubectl get pod web-server -o yaml > web-server.yaml
kubectl delete pod web-server
# Edit web-server.yaml to fix the image
kubectl apply -f web-server.yaml

# Fix 2: Wrong command or args
# Same approach - export, delete, fix, recreate

# Fix 3: Missing ConfigMap or Secret
kubectl get configmaps
kubectl get secrets
# Create the missing resource

# Fix 4: Resource limits too restrictive
# Edit the YAML to increase memory/CPU limits

# Step 5: Verify the fix
kubectl get pod web-server  # Should show Running
```

### Common Mistakes
- Trying to edit immutable fields on a running pod (you need to delete and recreate)
- Not checking `--previous` logs for CrashLoopBackOff pods
- Fixing one issue but not checking for additional issues
- Not verifying the pod is actually running after the fix

---

## Scenario 8: Troubleshooting a NotReady Node

### Task

Worker node `worker-2` is in NotReady state. Diagnose and fix the issue to bring the node back to Ready state.

### Solution Approach

```bash
# Step 1: Check node status
kubectl get nodes
kubectl describe node worker-2
# Look at Conditions section and Events

# Step 2: SSH to the node
ssh worker-2

# Step 3: Check kubelet status
systemctl status kubelet
# Common finding: kubelet is not running (inactive/dead)

# Step 4: Check kubelet logs for errors
journalctl -u kubelet --no-pager | tail -30

# Common fixes:

# Fix 1: kubelet service stopped
systemctl start kubelet
systemctl enable kubelet

# Fix 2: kubelet config error
cat /var/lib/kubelet/config.yaml
# Fix any errors in the configuration
systemctl restart kubelet

# Fix 3: Container runtime not running
systemctl status containerd
systemctl start containerd
systemctl restart kubelet

# Fix 4: Certificate issue
# Check if kubelet certificates are expired
openssl x509 -in /var/lib/kubelet/pki/kubelet-client-current.pem -text -noout

# Step 5: Verify from control plane
exit  # Back to control plane
kubectl get nodes
# worker-2 should show Ready
```

### Common Mistakes
- Forgetting to SSH to the node (you cannot fix kubelet from the control plane with kubectl)
- Not checking the container runtime (containerd) if kubelet restarts but node stays NotReady
- Not checking `journalctl` for the actual error message
- Forgetting to `systemctl enable kubelet` so it starts on boot

---

## Scenario 9: Creating an Ingress Resource

### Task

Create an Ingress resource named `app-ingress` in the `default` namespace that:
- Routes traffic for host `app.example.com` with path `/api` to service `api-svc` on port 8080
- Routes traffic for host `app.example.com` with path `/web` to service `web-svc` on port 80
- Uses the `nginx` ingress class

### Solution Approach

```yaml
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-svc
            port:
              number: 8080
      - path: /web
        pathType: Prefix
        backend:
          service:
            name: web-svc
            port:
              number: 80
EOF
```

### Verification
```bash
kubectl get ingress app-ingress
kubectl describe ingress app-ingress
# Check that the rules and backends are correct
```

### Common Mistakes
- Forgetting `ingressClassName` (required in newer Kubernetes versions)
- Wrong API version (must be `networking.k8s.io/v1`)
- Confusing `port.number` (Ingress v1) with older `servicePort` (v1beta1)
- Not specifying `pathType` (required in v1)

---

## Scenario 10: Multi-Task Troubleshooting

### Task

A deployment named `frontend` in the `app` namespace is supposed to:
- Have 3 replicas running
- Be accessible via a ClusterIP service named `frontend-svc` on port 80
- Be accessible from pods in the `monitoring` namespace

Currently, nothing is working. Fix all issues.

### Solution Approach

```bash
# Step 1: Check the namespace exists
kubectl get namespace app
# If not: kubectl create namespace app

# Step 2: Check the deployment
kubectl get deployment frontend -n app
kubectl describe deployment frontend -n app
# Fix any issues (wrong image, missing namespace, etc.)

# Step 3: Check pods are running
kubectl get pods -n app -l app=frontend
# If pods are not running, check logs and describe

# Step 4: Check the service
kubectl get svc frontend-svc -n app
kubectl get endpoints frontend-svc -n app
# If service does not exist: create it
# If no endpoints: fix the selector to match pod labels

# Step 5: Verify service selector matches pod labels
kubectl get pods -n app --show-labels
kubectl describe svc frontend-svc -n app | grep Selector

# Step 6: Check Network Policies
kubectl get networkpolicies -n app
# If a deny policy exists, create an allow policy for monitoring namespace

# Step 7: Test from monitoring namespace
kubectl run test -n monitoring --image=busybox --rm -it --restart=Never -- \
  wget -O- -T 5 http://frontend-svc.app.svc.cluster.local:80
```

### Common Mistakes
- Only fixing one issue and assuming the task is complete
- Not testing the full chain (deployment -> pods -> service -> connectivity)
- Forgetting cross-namespace DNS requires FQDN: `<svc>.<ns>.svc.cluster.local`
- Not checking for Network Policies blocking cross-namespace traffic

---

## Practice Tips

1. **Time yourself** - each scenario should take 5-8 minutes maximum
2. **Do not look at the solution** until you have attempted the task
3. **Practice without documentation** first, then check the docs only when stuck
4. **Repeat scenarios** until you can complete them without hesitation
5. **Create your own broken scenarios** - the best learning comes from breaking and fixing things
6. **Use killer.sh** for the most realistic exam simulation
