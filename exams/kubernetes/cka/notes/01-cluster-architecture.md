# Cluster Architecture, Installation & Configuration

## Overview

This domain represents 25% of the CKA exam. It covers the fundamental architecture of Kubernetes clusters, how to install and upgrade clusters using kubeadm, etcd backup and restore, and RBAC configuration.

**[Kubernetes Components](https://kubernetes.io/docs/concepts/overview/components/)** - Official architecture overview

## Control Plane Components

The control plane makes global decisions about the cluster (scheduling, detecting and responding to events). Control plane components can run on any node, but are typically deployed on dedicated control plane nodes.

### kube-apiserver

The API server is the front-end for the Kubernetes control plane. All communication between components goes through the API server.

**Key Facts:**
- Exposes the Kubernetes API (REST interface)
- Only component that communicates directly with etcd
- Validates and processes API requests
- Handles authentication, authorization, and admission control
- Horizontally scalable - you can run multiple instances behind a load balancer
- Static pod manifest: `/etc/kubernetes/manifests/kube-apiserver.yaml`

**[kube-apiserver Reference](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/)** - Command-line reference
**[API Server](https://kubernetes.io/docs/concepts/overview/kubernetes-api/)** - API overview

### etcd

A distributed, consistent key-value store used as Kubernetes' backing store for all cluster data.

**Key Facts:**
- Stores all cluster state - every resource definition, configuration, and status
- Uses the Raft consensus algorithm for distributed consistency
- Default port: 2379 (client), 2380 (peer)
- Data loss in etcd means complete loss of cluster state
- Typically runs as a static pod on control plane nodes
- Can be run as an external cluster for high availability
- Certificate files are located at `/etc/kubernetes/pki/etcd/`

**[etcd Administration](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/)** - Operating etcd
**[etcd Clustering Guide](https://etcd.io/docs/v3.5/op-guide/clustering/)** - HA etcd setup

### kube-scheduler

The scheduler watches for newly created Pods that have no node assigned and selects a node for them to run on.

**Key Facts:**
- Considers resource requirements, affinity/anti-affinity, taints/tolerations
- Uses a two-step process: filtering (find feasible nodes) then scoring (rank them)
- Respects pod priority and preemption
- Static pod manifest: `/etc/kubernetes/manifests/kube-scheduler.yaml`

**Scheduling Factors:**
- Resource requests and limits
- Node selectors and node affinity
- Pod affinity and anti-affinity
- Taints and tolerations
- Data locality
- Inter-workload interference

**[kube-scheduler](https://kubernetes.io/docs/concepts/scheduling-eviction/kube-scheduler/)** - Scheduler overview
**[Scheduling Framework](https://kubernetes.io/docs/concepts/scheduling-eviction/scheduling-framework/)** - Extension points

### kube-controller-manager

Runs controller processes that regulate the state of the cluster. Each controller watches the current state via the API server and works to move toward the desired state.

**Key Controllers:**
- **Node Controller** - monitors node health, evicts pods from unhealthy nodes
- **Replication Controller** - maintains the correct number of pods for replication objects
- **Endpoints Controller** - populates endpoint objects (joins Services and Pods)
- **ServiceAccount Controller** - creates default service accounts for new namespaces
- **Deployment Controller** - manages deployment rollouts and rollbacks
- **Job Controller** - watches for Job objects and creates pods to run tasks

**[kube-controller-manager](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-controller-manager/)** - Controller manager reference

### cloud-controller-manager

Embeds cloud-specific control logic. It lets you link your cluster to a cloud provider's API. Only relevant when running Kubernetes on a cloud provider.

**[Cloud Controller Manager](https://kubernetes.io/docs/concepts/architecture/cloud-controller/)** - Cloud integration

## Worker Node Components

### kubelet

The primary agent that runs on each node. It ensures that containers described in PodSpecs are running and healthy.

**Key Facts:**
- Registers the node with the API server
- Receives PodSpecs from the API server
- Manages container lifecycle through the container runtime interface (CRI)
- Reports node and pod status back to the API server
- Runs health checks (liveness, readiness, startup probes)
- Manages static pods from `/etc/kubernetes/manifests/` on the node
- Configuration: `/var/lib/kubelet/config.yaml`
- Service management: `systemctl status kubelet`, `systemctl restart kubelet`

**[kubelet Reference](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/)** - kubelet options
**[Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)** - Pod states and probes

### kube-proxy

Maintains network rules on nodes that allow network communication to pods from inside or outside the cluster.

**Key Facts:**
- Implements Service abstraction by managing iptables/IPVS rules
- Runs on every node as a DaemonSet
- Modes: iptables (default), IPVS (better performance at scale), userspace (legacy)
- Handles ClusterIP, NodePort, and LoadBalancer service types

**[kube-proxy Reference](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-proxy/)** - kube-proxy options

### Container Runtime

The software responsible for running containers. Kubernetes supports any CRI-compliant runtime.

**Common Runtimes:**
- **containerd** - most widely used, default in many distributions
- **CRI-O** - lightweight, designed specifically for Kubernetes
- **Docker Engine** - no longer directly supported (dockershim removed in v1.24), but containerd (used by Docker) works

**[Container Runtimes](https://kubernetes.io/docs/setup/production-environment/container-runtimes/)** - Setup guide

## etcd Backup and Restore

This is a high-value exam topic. You must be able to backup and restore etcd from memory.

### Backup Procedure

```bash
# Find etcd pod and its configuration
kubectl describe pod etcd-controlplane -n kube-system

# Check etcd certificates (look in the pod spec or static pod manifest)
cat /etc/kubernetes/manifests/etcd.yaml | grep -E "cert|key|cacert"

# Take a snapshot backup
ETCDCTL_API=3 etcdctl snapshot save /opt/etcd-backup.db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key

# Verify the backup
ETCDCTL_API=3 etcdctl snapshot status /opt/etcd-backup.db --write-table
```

### Restore Procedure

```bash
# Stop the API server (move static pod manifest temporarily)
mv /etc/kubernetes/manifests/kube-apiserver.yaml /tmp/

# Restore from backup to a new data directory
ETCDCTL_API=3 etcdctl snapshot restore /opt/etcd-backup.db \
  --data-dir=/var/lib/etcd-restore

# Update the etcd static pod to use the new data directory
# Edit /etc/kubernetes/manifests/etcd.yaml
# Change --data-dir to /var/lib/etcd-restore
# Change the hostPath volume to point to /var/lib/etcd-restore

# Move the API server manifest back
mv /tmp/kube-apiserver.yaml /etc/kubernetes/manifests/

# Wait for etcd and API server to restart
kubectl get pods -n kube-system
```

**[Operating etcd](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/)** - Backup and restore guide

## Cluster Installation with kubeadm

### Prerequisites

Before initializing a cluster:
1. Disable swap on all nodes: `swapoff -a`
2. Install a container runtime (containerd recommended)
3. Install kubeadm, kubelet, and kubectl
4. Enable required kernel modules: `br_netfilter`, `overlay`
5. Set required sysctl parameters: `net.bridge.bridge-nf-call-iptables = 1`

**[Installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)** - Prerequisites and installation

### Initialize the Control Plane

```bash
# Initialize with a pod network CIDR (required for most CNI plugins)
kubeadm init --pod-network-cidr=10.244.0.0/16

# Set up kubeconfig for the admin user
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Install a CNI plugin (example: Calico)
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

### Join Worker Nodes

```bash
# On the control plane, generate a join command
kubeadm token create --print-join-command

# On each worker node, run the join command
kubeadm join <control-plane-ip>:6443 \
  --token <token> \
  --discovery-token-ca-cert-hash sha256:<hash>
```

**[Creating a cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)** - Full walkthrough

## Cluster Upgrades with kubeadm

Cluster upgrades must follow the version skew policy: kubelet can be up to two minor versions behind the API server, but not ahead.

### Upgrade Process (Control Plane Node)

```bash
# 1. Check available versions
apt update && apt-cache madison kubeadm

# 2. Upgrade kubeadm
apt-mark unhold kubeadm
apt-get update && apt-get install -y kubeadm=1.29.0-1.1
apt-mark hold kubeadm

# 3. Verify upgrade plan
kubeadm upgrade plan

# 4. Apply the upgrade (first control plane node only)
kubeadm upgrade apply v1.29.0

# 5. Drain the node
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data

# 6. Upgrade kubelet and kubectl
apt-mark unhold kubelet kubectl
apt-get update && apt-get install -y kubelet=1.29.0-1.1 kubectl=1.29.0-1.1
apt-mark hold kubelet kubectl

# 7. Restart kubelet
systemctl daemon-reload
systemctl restart kubelet

# 8. Uncordon the node
kubectl uncordon <node-name>
```

### Upgrade Process (Worker Nodes)

```bash
# 1. Upgrade kubeadm on the worker node
apt-mark unhold kubeadm
apt-get update && apt-get install -y kubeadm=1.29.0-1.1
apt-mark hold kubeadm

# 2. Upgrade node configuration
kubeadm upgrade node

# 3. From control plane: drain the worker node
kubectl drain <worker-node> --ignore-daemonsets --delete-emptydir-data

# 4. Upgrade kubelet and kubectl on the worker
apt-mark unhold kubelet kubectl
apt-get update && apt-get install -y kubelet=1.29.0-1.1 kubectl=1.29.0-1.1
apt-mark hold kubelet kubectl

# 5. Restart kubelet
systemctl daemon-reload
systemctl restart kubelet

# 6. From control plane: uncordon the worker node
kubectl uncordon <worker-node>
```

**[Upgrading kubeadm clusters](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)** - Official upgrade guide

## Managing kubeconfig

The kubeconfig file defines clusters, users, and contexts for kubectl.

```bash
# View current config
kubectl config view

# View current context
kubectl config current-context

# List all contexts
kubectl config get-contexts

# Switch context
kubectl config use-context <context-name>

# Set a new context
kubectl config set-context mycontext --cluster=mycluster --user=myuser --namespace=mynamespace
```

**Default location:** `$HOME/.kube/config`
**Override with:** `KUBECONFIG` environment variable or `--kubeconfig` flag

**[Configure Access to Multiple Clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/)** - Multi-cluster kubeconfig

## Key Exam Tips for This Domain

1. **etcd backup/restore is almost guaranteed** - practice until you can do it from memory
2. **Know the kubeadm upgrade sequence** - control plane first, then workers, one at a time
3. **Remember certificate paths** - `/etc/kubernetes/pki/etcd/` for etcd certs
4. **Static pod manifests** are in `/etc/kubernetes/manifests/` - editing these restarts components
5. **RBAC tasks are common** - practice creating roles, cluster roles, and bindings imperatively
6. **Always check which cluster context you should be on** before starting each task
