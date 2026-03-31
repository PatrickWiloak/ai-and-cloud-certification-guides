# Troubleshooting

## Overview

This is the LARGEST domain on the CKA exam at 30%. Nearly one-third of the exam focuses on your ability to diagnose and fix issues in Kubernetes clusters. You must be methodical and efficient with troubleshooting commands.

**[Troubleshooting](https://kubernetes.io/docs/tasks/debug/)** - Kubernetes debugging overview

## Troubleshooting Methodology

Follow a systematic approach for every troubleshooting task:

1. **Read the problem carefully** - understand what is expected to work
2. **Check the current state** - `kubectl get` to see resource status
3. **Describe the resource** - `kubectl describe` for events and conditions
4. **Check logs** - `kubectl logs` for application output
5. **Verify configuration** - check YAML definitions for errors
6. **Test connectivity** - use temporary pods for network testing
7. **Fix and verify** - apply the fix and confirm the issue is resolved

## Application Troubleshooting

### Pod Status Reference

| Status | Meaning | First Steps |
|--------|---------|-------------|
| `Pending` | Not scheduled to a node | Check resources, selectors, taints, PVCs |
| `ContainerCreating` | Scheduled but containers not running | Check image pull, volume mounts, init containers |
| `Running` | Container is running | Check if application is healthy (logs, readiness) |
| `CrashLoopBackOff` | Container crashes repeatedly | Check logs, command/args, resource limits |
| `ImagePullBackOff` | Cannot pull container image | Check image name, registry credentials, network |
| `ErrImagePull` | Initial image pull failure | Same as ImagePullBackOff |
| `Error` | Container exited with error | Check logs for error message |
| `Completed` | Container ran to completion | Normal for Jobs, check if expected for other pods |
| `Terminating` | Pod is being deleted | Check finalizers, may need force delete |
| `Unknown` | Node communication lost | Check node status and kubelet |

### Troubleshooting Pending Pods

```bash
# Check pod events
kubectl describe pod <pod-name> | grep -A 20 Events

# Common causes:
# - Insufficient CPU/memory on nodes
# - Node selector or affinity rules cannot be satisfied
# - Taints on nodes without matching tolerations
# - PVC not bound (waiting for PV or storage class)
# - Too many pods on nodes (pod limit reached)

# Check node resources
kubectl describe nodes | grep -A 5 "Allocated resources"

# Check if PVCs are bound
kubectl get pvc
```

### Troubleshooting CrashLoopBackOff

```bash
# Check current logs
kubectl logs <pod-name>

# Check logs from previous crash
kubectl logs <pod-name> --previous

# Check for multi-container pods
kubectl logs <pod-name> -c <container-name>

# Check the pod spec for errors
kubectl get pod <pod-name> -o yaml

# Common causes:
# - Application error (check logs)
# - Wrong command or arguments
# - Missing environment variables or config files
# - Insufficient memory (OOMKilled)
# - Permission issues (security context)
# - Liveness probe failing
```

### Troubleshooting ImagePullBackOff

```bash
# Check events for the specific error
kubectl describe pod <pod-name> | grep -A 5 "Events"

# Common causes:
# - Image name or tag is wrong
# - Image does not exist in the registry
# - Private registry requires imagePullSecrets
# - Network issues reaching the registry

# Fix: Check image name
kubectl get pod <pod-name> -o jsonpath='{.spec.containers[*].image}'

# Fix: Add image pull secret
kubectl create secret docker-registry regcred \
  --docker-server=<registry> \
  --docker-username=<user> \
  --docker-password=<pass>
```

### Checking Pod Events and Conditions

```bash
# Detailed pod information
kubectl describe pod <pod-name>

# Get events sorted by time
kubectl get events --sort-by=.metadata.creationTimestamp

# Get events for a specific namespace
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp

# Filter events for a specific resource
kubectl get events --field-selector involvedObject.name=<pod-name>
```

### Debugging Running Pods

```bash
# Execute a command in a running container
kubectl exec -it <pod-name> -- /bin/sh
kubectl exec -it <pod-name> -c <container> -- /bin/bash

# Check if a process is running
kubectl exec <pod-name> -- ps aux

# Check network from inside the pod
kubectl exec <pod-name> -- cat /etc/resolv.conf
kubectl exec <pod-name> -- nslookup kubernetes.default
kubectl exec <pod-name> -- wget -O- http://service-name:port

# Check environment variables
kubectl exec <pod-name> -- env

# Check mounted volumes
kubectl exec <pod-name> -- ls -la /path/to/mount

# Use ephemeral debug containers (Kubernetes 1.25+)
kubectl debug <pod-name> -it --image=busybox
```

**[Debug Pods](https://kubernetes.io/docs/tasks/debug/debug-application/debug-pods/)** - Pod debugging guide
**[Debug Running Pods](https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pods/)** - Live debugging
**[Troubleshoot Applications](https://kubernetes.io/docs/tasks/debug/debug-application/)** - Application debugging overview

## Cluster Component Troubleshooting

### Control Plane Components

Control plane components run as static pods on control plane nodes. Their manifests are in `/etc/kubernetes/manifests/`.

```bash
# Check control plane pod status
kubectl get pods -n kube-system

# Check individual component logs
kubectl logs -n kube-system kube-apiserver-controlplane
kubectl logs -n kube-system kube-scheduler-controlplane
kubectl logs -n kube-system kube-controller-manager-controlplane
kubectl logs -n kube-system etcd-controlplane

# If kubectl is not working (API server down), check static pod manifests
cat /etc/kubernetes/manifests/kube-apiserver.yaml
cat /etc/kubernetes/manifests/kube-scheduler.yaml
cat /etc/kubernetes/manifests/kube-controller-manager.yaml
cat /etc/kubernetes/manifests/etcd.yaml

# Check component health
kubectl get componentstatuses  # Deprecated but may still work
kubectl cluster-info
```

### Common API Server Issues

```bash
# API server not starting
# Check the static pod manifest for syntax errors
cat /etc/kubernetes/manifests/kube-apiserver.yaml

# Check kubelet logs for API server container issues
journalctl -u kubelet | grep apiserver

# Common causes:
# - Wrong certificate paths in manifest
# - Incorrect etcd endpoint
# - Port conflicts
# - Invalid flags or arguments
```

### Common Scheduler Issues

```bash
# Scheduler not working - pods stay in Pending
kubectl logs -n kube-system kube-scheduler-<node>

# Common causes:
# - Scheduler static pod manifest has errors
# - Scheduler is not bound to the leader endpoint
# - Authentication/authorization issues with API server
```

### Common etcd Issues

```bash
# Check etcd health
kubectl exec -n kube-system etcd-controlplane -- etcdctl \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  endpoint health

# Check etcd member list
kubectl exec -n kube-system etcd-controlplane -- etcdctl \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  member list
```

**[Troubleshoot Clusters](https://kubernetes.io/docs/tasks/debug/debug-cluster/)** - Cluster debugging guide

## Node Troubleshooting

### Checking Node Status

```bash
# Overview of all nodes
kubectl get nodes

# Detailed node information
kubectl describe node <node-name>

# Check node conditions
kubectl get nodes -o custom-columns=NAME:.metadata.name,STATUS:.status.conditions[-1].type,READY:.status.conditions[-1].status
```

### Node Conditions

| Condition | Normal Value | Issue When |
|-----------|-------------|------------|
| Ready | True | False or Unknown - kubelet issue |
| MemoryPressure | False | True - node is running out of memory |
| DiskPressure | False | True - node disk capacity is low |
| PIDPressure | False | True - too many processes |
| NetworkUnavailable | False | True - network not configured |

### Troubleshooting NotReady Nodes

```bash
# SSH to the node
ssh <node-ip>

# Check kubelet status
systemctl status kubelet
systemctl is-active kubelet

# Check kubelet logs
journalctl -u kubelet -f
journalctl -u kubelet --no-pager | tail -50

# Common fixes:
# Restart kubelet
systemctl restart kubelet

# Check kubelet configuration
cat /var/lib/kubelet/config.yaml

# Check container runtime
systemctl status containerd
systemctl restart containerd

# Check disk space
df -h

# Check memory
free -m

# Check for certificate issues
ls -la /etc/kubernetes/pki/
```

### Common Node Issues and Fixes

**kubelet not running:**
```bash
systemctl start kubelet
systemctl enable kubelet
# Check for errors in config
journalctl -u kubelet | tail -20
```

**Certificate expired:**
```bash
# Check certificate expiry
openssl x509 -in /var/lib/kubelet/pki/kubelet-client-current.pem -text -noout | grep -A2 Validity
# Renew certificates
kubeadm certs renew all
```

**Container runtime not running:**
```bash
systemctl start containerd
systemctl enable containerd
```

**Disk pressure:**
```bash
# Clean up unused containers and images
crictl rmi --prune
# Remove old logs
journalctl --vacuum-size=100M
```

**[Node Health Monitoring](https://kubernetes.io/docs/tasks/debug/debug-cluster/monitor-node-health/)** - Node monitoring
**[Safely Drain a Node](https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/)** - Node maintenance

## Networking Troubleshooting

### Service Not Routing Traffic

```bash
# 1. Check the service exists and has the right selector
kubectl get svc <service-name>
kubectl describe svc <service-name>

# 2. Check endpoints - if empty, selector does not match any pods
kubectl get endpoints <service-name>

# 3. Check that pods have matching labels
kubectl get pods --show-labels

# 4. Check that pods are Ready
kubectl get pods

# 5. Test connectivity from within the cluster
kubectl run test --image=busybox:1.28 --rm -it --restart=Never -- \
  wget -O- -T 5 http://<service-name>:<port>
```

### DNS Resolution Issues

```bash
# Check CoreDNS pods are running
kubectl get pods -n kube-system -l k8s-app=kube-dns

# Check CoreDNS logs
kubectl logs -n kube-system -l k8s-app=kube-dns

# Test DNS from a pod
kubectl run dnstest --image=busybox:1.28 --rm -it --restart=Never -- \
  nslookup kubernetes.default.svc.cluster.local

# Check /etc/resolv.conf in a pod
kubectl exec <pod> -- cat /etc/resolv.conf

# Check CoreDNS ConfigMap
kubectl get configmap coredns -n kube-system -o yaml
```

### Pod-to-Pod Connectivity Issues

```bash
# Get pod IPs
kubectl get pods -o wide

# Test direct pod connectivity
kubectl exec <pod-a> -- ping <pod-b-ip>
kubectl exec <pod-a> -- wget -O- -T 5 http://<pod-b-ip>:<port>

# Check Network Policies
kubectl get networkpolicies -A

# Check CNI plugin is running
kubectl get pods -n kube-system | grep -E "calico|flannel|weave|cilium"

# Check CNI configuration
ls /etc/cni/net.d/
cat /etc/cni/net.d/*.conf
```

### Ingress Troubleshooting

```bash
# Check ingress controller is running
kubectl get pods -n ingress-nginx  # or relevant namespace

# Check ingress resource
kubectl describe ingress <ingress-name>

# Check the backend service exists and has endpoints
kubectl get svc <backend-service>
kubectl get endpoints <backend-service>

# Check ingress controller logs
kubectl logs -n ingress-nginx <controller-pod>

# Test from outside
curl -H "Host: <hostname>" http://<ingress-ip>
```

**[Debug Services](https://kubernetes.io/docs/tasks/debug/debug-application/debug-service/)** - Service debugging
**[Debugging DNS Resolution](https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/)** - DNS debugging

## Log Analysis

### Container Logs

```bash
# View current logs
kubectl logs <pod-name>

# Follow logs in real-time
kubectl logs -f <pod-name>

# View logs from a specific container
kubectl logs <pod-name> -c <container-name>

# View logs from previous container instance
kubectl logs <pod-name> --previous

# View last N lines
kubectl logs <pod-name> --tail=100

# View logs since a time
kubectl logs <pod-name> --since=1h
kubectl logs <pod-name> --since-time="2024-01-15T10:00:00Z"

# View logs for all pods with a label
kubectl logs -l app=nginx --all-containers
```

### System Component Logs

```bash
# kubelet logs
journalctl -u kubelet -f
journalctl -u kubelet --since "1 hour ago"

# Container runtime logs
journalctl -u containerd -f

# Control plane component logs (if running as static pods)
kubectl logs -n kube-system kube-apiserver-<node>
kubectl logs -n kube-system etcd-<node>

# If kubectl is not available
crictl ps       # List containers
crictl logs <container-id>  # View container logs
```

**[Logging Architecture](https://kubernetes.io/docs/concepts/cluster-administration/logging/)** - Logging in Kubernetes

## Common Troubleshooting Scenarios

### Scenario: Deployment Not Creating Pods

```bash
# Check deployment status
kubectl get deployment <name>
kubectl describe deployment <name>

# Check ReplicaSet
kubectl get rs

# Common causes:
# - Image pull failure
# - ResourceQuota exceeded
# - PodSecurityPolicy/PodSecurityAdmission blocking
# - Invalid pod template
```

### Scenario: Service Returns 503 or No Response

```bash
# Verify endpoints exist
kubectl get endpoints <svc>

# If no endpoints: fix selector or check pod readiness
# If endpoints exist: check target port matches container port

kubectl describe svc <svc>
# Look for: Selector, TargetPort, Endpoints
```

### Scenario: Pod Cannot Mount Volume

```bash
# Check PVC status
kubectl get pvc

# If Pending: check PV availability and storage class
kubectl get pv
kubectl get sc

# Check pod events for mount errors
kubectl describe pod <pod>
```

### Scenario: RBAC Permission Denied

```bash
# Check what the user/SA can do
kubectl auth can-i --list --as=<user>
kubectl auth can-i <verb> <resource> --as=<user> -n <namespace>

# Check existing bindings
kubectl get rolebindings -n <namespace>
kubectl get clusterrolebindings

# Describe specific binding
kubectl describe rolebinding <binding-name> -n <namespace>
```

## Key Exam Tips for This Domain

1. **This is 30% of the exam** - spend the most study time here
2. **Be systematic** - always start with `kubectl get`, then `kubectl describe`, then `kubectl logs`
3. **Check events first** - `kubectl describe` shows events at the bottom that often reveal the cause
4. **Know how to SSH to nodes** and check kubelet/containerd when kubectl does not work
5. **Practice with broken clusters** - intentionally break things and fix them
6. **Use `--previous` flag** for logs when pods are in CrashLoopBackOff
7. **Remember `journalctl -u kubelet`** for node-level issues
8. **Test connectivity** with temporary busybox pods
9. **Check labels and selectors** - mismatched labels are a very common exam trap
10. **Time management** - do not spend more than 7-8 minutes on any single troubleshooting task
