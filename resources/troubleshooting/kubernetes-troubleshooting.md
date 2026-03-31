# Kubernetes Troubleshooting Guide

Systematic approaches to diagnosing and resolving common Kubernetes issues.

---

## Pod Issues

### CrashLoopBackOff

The pod starts, crashes, and Kubernetes keeps restarting it with exponential backoff.

**Diagnosis**
```bash
# Check pod status and restart count
kubectl get pod my-pod -o wide

# View pod events
kubectl describe pod my-pod

# Check current and previous container logs
kubectl logs my-pod
kubectl logs my-pod --previous
```

**Common Causes**
- Application error or unhandled exception on startup
- Missing configuration (ConfigMap, Secret not mounted or wrong key)
- Database or external service unreachable
- Liveness probe failing too quickly - increase `initialDelaySeconds`
- Binary or entrypoint not found in the container image

**Resolution Steps**
1. Check logs from the previous container: `kubectl logs my-pod --previous`
2. Verify ConfigMaps and Secrets exist and have expected keys
3. Test the image locally: `docker run --rm -it IMAGE_NAME /bin/sh`
4. Temporarily remove liveness probes to let the container start
5. Check if resource limits are too low (OOMKilled shows as a different status)

---

### ImagePullBackOff

Kubernetes cannot pull the container image.

**Diagnosis**
```bash
kubectl describe pod my-pod | grep -A 10 Events
```

**Common Causes**
- Image name or tag is wrong (typo, wrong registry)
- Private registry and no imagePullSecret configured
- Image tag does not exist (especially `latest` after rebuild)
- Registry is unreachable (network policy, firewall, DNS)

**Resolution Steps**
```bash
# Verify the image exists
docker pull my-registry/my-image:tag

# Check imagePullSecrets on the pod spec
kubectl get pod my-pod -o jsonpath='{.spec.imagePullSecrets}'

# Create an image pull secret
kubectl create secret docker-registry my-secret \
  --docker-server=my-registry.example.com \
  --docker-username=user \
  --docker-password=pass \
  --docker-email=email@example.com

# Verify the secret is in the correct namespace
kubectl get secrets -n my-namespace
```

---

### Pending Pods

Pod stays in Pending state and never gets scheduled.

**Diagnosis**
```bash
kubectl describe pod my-pod | grep -A 20 Events
```

**Common Causes**
- Insufficient resources - no node has enough CPU or memory
- Node selector or affinity rules cannot be satisfied
- Taints on nodes with no matching tolerations
- PersistentVolumeClaim in Pending state
- Pod topology spread constraints cannot be satisfied
- ResourceQuota exceeded in the namespace

**Resolution Steps**
```bash
# Check node resources
kubectl describe nodes | grep -A 5 "Allocated resources"

# Check for taints
kubectl get nodes -o json | jq '.items[].spec.taints'

# Check resource quotas
kubectl describe resourcequota -n my-namespace

# Check PVC status
kubectl get pvc -n my-namespace
```

---

### OOMKilled

Container is killed because it exceeded its memory limit.

**Diagnosis**
```bash
kubectl describe pod my-pod | grep -A 5 "Last State"
# Look for: Reason: OOMKilled
```

**Resolution Steps**
1. Increase the memory limit in the pod spec
2. Profile the application to find memory leaks
3. Check if the JVM or runtime has its own memory settings that conflict with the container limit
4. Set memory requests equal to limits to guarantee QoS class "Guaranteed"

```yaml
resources:
  requests:
    memory: "512Mi"
  limits:
    memory: "1Gi"
```

---

### CreateContainerConfigError

Container cannot be created due to a configuration issue.

**Diagnosis**
```bash
kubectl describe pod my-pod | grep -A 10 Events
```

**Common Causes**
- Referenced ConfigMap or Secret does not exist
- Key referenced from ConfigMap/Secret does not exist
- ServiceAccount does not exist
- SecurityContext settings incompatible with the node

**Resolution Steps**
```bash
# Verify ConfigMap exists and has expected keys
kubectl get configmap my-config -o yaml

# Verify Secret exists
kubectl get secret my-secret

# Check ServiceAccount
kubectl get serviceaccount my-sa -n my-namespace
```

---

## Service and Networking

### Service Endpoints Not Ready

**Diagnosis**
```bash
# Check if endpoints exist for the service
kubectl get endpoints my-service

# Verify selector matches pod labels
kubectl get svc my-service -o jsonpath='{.spec.selector}'
kubectl get pods -l app=my-app --show-labels
```

**Common Causes**
- Selector on the service does not match any pod labels
- Pods exist but are not Ready (failing readiness probe)
- Pods are in a different namespace than the service

**Resolution Steps**
1. Verify the service selector matches pod labels exactly
2. Check pod readiness: `kubectl get pods -o wide`
3. Fix readiness probe if pods are running but not Ready
4. Ensure service and pods are in the same namespace

---

### DNS Resolution Failures

**Diagnosis**
```bash
# Run a DNS test from inside a pod
kubectl run dns-test --rm -it --image=busybox -- nslookup my-service
kubectl run dns-test --rm -it --image=busybox -- nslookup my-service.my-namespace.svc.cluster.local

# Check CoreDNS/kube-dns pods
kubectl get pods -n kube-system -l k8s-app=kube-dns
kubectl logs -n kube-system -l k8s-app=kube-dns
```

**Common Causes**
- CoreDNS pods are not running or are crashlooping
- NetworkPolicy blocking DNS traffic (port 53 UDP/TCP to kube-system)
- ndots setting causing excessive DNS queries (default ndots:5)
- Service name typo or wrong namespace in the DNS name

**DNS Name Format**
```
<service>.<namespace>.svc.cluster.local
<pod-ip-with-dashes>.<namespace>.pod.cluster.local
```

---

### Network Policies Blocking Traffic

**Diagnosis**
```bash
# List network policies in the namespace
kubectl get networkpolicies -n my-namespace

# Describe a specific policy
kubectl describe networkpolicy my-policy -n my-namespace
```

**Common Causes**
- A default deny policy exists without corresponding allow policies
- Egress policies blocking outbound traffic (including DNS)
- Label selectors in the policy do not match expected pods
- Missing namespace selectors for cross-namespace traffic

**Resolution Steps**
```bash
# Temporarily check by removing network policies (non-production only)
kubectl delete networkpolicy my-policy -n my-namespace

# Always include DNS egress in policies
# Example: allow egress to kube-dns
```

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns
spec:
  podSelector: {}
  policyTypes:
    - Egress
  egress:
    - to:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: kube-system
      ports:
        - protocol: UDP
          port: 53
        - protocol: TCP
          port: 53
```

---

## Node Issues

### Node NotReady

**Diagnosis**
```bash
kubectl describe node my-node | grep -A 10 Conditions
```

**Common Causes**
- kubelet not running or crashed on the node
- Node ran out of disk space, memory, or PIDs
- Network connectivity lost between node and control plane
- Container runtime (containerd, CRI-O) not responding
- Certificate expired

**Resolution Steps**
```bash
# SSH to the node and check kubelet
systemctl status kubelet
journalctl -u kubelet --since "10 minutes ago"

# Check container runtime
systemctl status containerd

# Check disk space
df -h

# Check memory
free -m
```

---

### Disk Pressure, Memory Pressure, PID Pressure

**Diagnosis**
```bash
kubectl describe node my-node | grep -A 5 Conditions
```

**Disk Pressure (DiskPressure=True)**
- Node available disk is below threshold (default: 15% for imagefs, 10% for nodefs)
- Kubernetes starts evicting pods
- Clean up unused images: `crictl rmi --prune`
- Clean up unused containers and logs

**Memory Pressure (MemoryPressure=True)**
- Available memory is below threshold (default: 100Mi)
- Pods are evicted starting with BestEffort QoS class
- Check for pods without resource limits consuming excessive memory

**PID Pressure (PIDPressure=True)**
- Available PIDs are below threshold
- Usually caused by a process fork bomb or application spawning too many threads
- Check: `ps aux | wc -l` on the node

---

### Cordon and Drain

```bash
# Prevent new pods from being scheduled on a node
kubectl cordon my-node

# Evict pods from a node (for maintenance)
kubectl drain my-node --ignore-daemonsets --delete-emptydir-data

# Re-enable scheduling
kubectl uncordon my-node
```

**Drain Issues**
- PodDisruptionBudgets may prevent eviction - check: `kubectl get pdb -A`
- Pods with local storage need `--delete-emptydir-data`
- DaemonSet pods are skipped with `--ignore-daemonsets`
- Pods without a controller (bare pods) need `--force`

---

## Storage and PVC Issues

### PersistentVolumeClaim Stuck in Pending

**Diagnosis**
```bash
kubectl describe pvc my-pvc
kubectl get pv
kubectl get storageclass
```

**Common Causes**
- No PersistentVolume available that matches the claim
- StorageClass does not exist or has no provisioner
- Cloud provider quota exhausted (disk quota)
- WaitForFirstConsumer binding mode - PVC waits until a pod uses it
- Zone mismatch - PV is in a different zone than the node

**Resolution Steps**
1. Verify the StorageClass exists: `kubectl get sc`
2. Check the PVC request matches available PV sizes and access modes
3. For dynamic provisioning, verify the CSI driver is installed and running
4. Check cloud provider quotas for persistent disks

---

### Access Mode Mismatch

| Access Mode | Abbreviation | Description |
|---|---|---|
| ReadWriteOnce | RWO | Single node read-write |
| ReadOnlyMany | ROX | Many nodes read-only |
| ReadWriteMany | RWX | Many nodes read-write |
| ReadWriteOncePod | RWOP | Single pod read-write |

**Common Issues**
- Using RWO but trying to mount on multiple nodes (use RWX or switch to a shared filesystem)
- Not all storage backends support RWX (EBS does not, EFS does)
- RWOP is only supported in Kubernetes 1.27+

---

### StorageClass Issues

```bash
# List storage classes
kubectl get sc

# Check the default storage class
kubectl get sc -o jsonpath='{.items[?(@.metadata.annotations.storageclass\.kubernetes\.io/is-default-class=="true")].metadata.name}'
```

**Common Issues**
- No default StorageClass and PVC does not specify one
- Provisioner for the StorageClass is not installed (CSI driver missing)
- Storage class parameters are incorrect (disk type, encryption settings)
- Volume binding mode is `Immediate` but needs `WaitForFirstConsumer` for topology-aware provisioning

---

## RBAC Errors

### Forbidden / Unauthorized

**Diagnosis**
```bash
# Check if a user/service account can perform an action
kubectl auth can-i get pods --as=system:serviceaccount:my-namespace:my-sa
kubectl auth can-i create deployments --as=user@example.com -n my-namespace

# List roles and bindings
kubectl get roles,rolebindings -n my-namespace
kubectl get clusterroles,clusterrolebindings
```

**Common Causes**
- ServiceAccount does not have a RoleBinding or ClusterRoleBinding
- Role exists but is in a different namespace than the RoleBinding
- ClusterRole is bound with a RoleBinding (limits to namespace scope)
- The subject in the binding does not match the requesting identity

**Resolution Steps**
```bash
# Create a role
kubectl create role pod-reader --verb=get,list,watch --resource=pods -n my-namespace

# Bind the role to a service account
kubectl create rolebinding pod-reader-binding \
  --role=pod-reader \
  --serviceaccount=my-namespace:my-sa \
  -n my-namespace

# For cluster-wide access, use ClusterRole and ClusterRoleBinding
kubectl create clusterrolebinding admin-binding \
  --clusterrole=admin \
  --serviceaccount=my-namespace:my-sa
```

**Aggregated ClusterRoles**
- `admin`, `edit`, and `view` are aggregated - custom roles can contribute to them via labels
- Modifying a base role (like `edit`) will not persist across cluster upgrades

---

## kubectl Debug Techniques

### Essential Commands

```bash
# Get detailed information about a resource
kubectl describe pod my-pod

# View logs (current and previous container)
kubectl logs my-pod
kubectl logs my-pod --previous
kubectl logs my-pod -c my-container    # specific container in multi-container pod
kubectl logs -l app=my-app --all-containers  # all pods with a label

# Execute commands inside a running container
kubectl exec -it my-pod -- /bin/sh
kubectl exec -it my-pod -c my-container -- /bin/sh

# Port forward to a pod or service
kubectl port-forward pod/my-pod 8080:80
kubectl port-forward svc/my-service 8080:80

# View cluster events sorted by time
kubectl get events --sort-by='.lastTimestamp'
kubectl get events -n my-namespace --sort-by='.lastTimestamp'
```

### Ephemeral Debug Containers

```bash
# Attach a debug container to a running pod (Kubernetes 1.23+)
kubectl debug -it my-pod --image=busybox --target=my-container

# Create a copy of a pod with a debug container
kubectl debug my-pod -it --image=ubuntu --copy-to=debug-pod --share-processes
```

### Network Debugging from Inside a Pod

```bash
# Run a temporary debug pod with networking tools
kubectl run netdebug --rm -it --image=nicolaka/netshoot -- /bin/bash

# Inside the pod
curl -v http://my-service:8080/health
nslookup my-service.my-namespace.svc.cluster.local
traceroute my-service
tcpdump -i eth0 port 8080
```

### Resource Usage

```bash
# View node resource usage (requires metrics-server)
kubectl top nodes

# View pod resource usage
kubectl top pods -n my-namespace --sort-by=memory

# View resource requests and limits
kubectl get pods -n my-namespace -o custom-columns=\
NAME:.metadata.name,\
CPU_REQ:.spec.containers[0].resources.requests.cpu,\
CPU_LIM:.spec.containers[0].resources.limits.cpu,\
MEM_REQ:.spec.containers[0].resources.requests.memory,\
MEM_LIM:.spec.containers[0].resources.limits.memory
```

### Useful JSONPath Queries

```bash
# Get all pod IPs
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.podIP}{"\n"}{end}'

# Get all images running in a namespace
kubectl get pods -n my-namespace -o jsonpath='{range .items[*].spec.containers[*]}{.image}{"\n"}{end}' | sort -u

# Get pods not in Running state
kubectl get pods --field-selector=status.phase!=Running
```

---

## Troubleshooting Flowchart

```
Pod not working?
  |
  +-- Pending? --> Check scheduling (resources, taints, PVC, quotas)
  |
  +-- ImagePullBackOff? --> Check image name, registry auth, network
  |
  +-- CrashLoopBackOff? --> Check logs (--previous), config, probes
  |
  +-- Running but not Ready? --> Check readiness probe
  |
  +-- Running and Ready but not reachable?
        |
        +-- Check Service selector matches pod labels
        +-- Check endpoints exist
        +-- Check NetworkPolicies
        +-- Check DNS resolution
        +-- Check ingress/load balancer configuration
```

---

## Additional Resources

- [Kubernetes Troubleshooting Documentation](https://kubernetes.io/docs/tasks/debug/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Debugging Pods](https://kubernetes.io/docs/tasks/debug/debug-application/debug-pods/)
- [Debugging Services](https://kubernetes.io/docs/tasks/debug/debug-application/debug-service/)
- [Cluster Troubleshooting](https://kubernetes.io/docs/tasks/debug/debug-cluster/)
