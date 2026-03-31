# Certified Kubernetes Administrator (CKA) Fact Sheet

## Exam Overview

**Exam Code:** CKA
**Exam Name:** Certified Kubernetes Administrator
**Duration:** 2 hours
**Format:** Performance-based (hands-on terminal tasks on live Kubernetes clusters)
**Passing Score:** 66%
**Cost:** $395 USD (includes one free retake and two killer.sh simulator sessions)
**Valid For:** 3 years
**Delivery:** PSI online proctoring (remote only)
**Kubernetes Version:** Tracks latest stable release

**[Official CKA Exam Page](https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/)** - Registration and exam details
**[CKA Exam Curriculum](https://github.com/cncf/curriculum)** - Official exam objectives and domain weights
**[Candidate Handbook](https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2)** - Rules, policies, and exam day procedures
**[Exam FAQ](https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks)** - Frequently asked questions

## Target Audience

This certification is designed for:
- Kubernetes administrators managing production clusters
- DevOps engineers responsible for container orchestration
- Platform engineers building internal developer platforms
- SREs ensuring reliability of Kubernetes-based systems
- System administrators transitioning to cloud-native infrastructure
- Cloud engineers working with managed Kubernetes services (EKS, GKE, AKS)

**[CNCF Certification Program](https://www.cncf.io/training/certification/)** - All CNCF certifications
**[Kubestronaut Program](https://www.cncf.io/training/kubestronaut/)** - Earn all 5 K8s certifications

## Exam Domains

### Domain 1: Cluster Architecture, Installation & Configuration (25%)

This is the second-largest domain. You need to understand how Kubernetes clusters are built, configured, and maintained.

#### 1.1 Cluster Architecture

**Control Plane Components:**
- kube-apiserver - the front-end for the Kubernetes control plane
- etcd - consistent and highly-available key value store for cluster data
- kube-scheduler - assigns pods to nodes based on resource requirements and constraints
- kube-controller-manager - runs controller processes (node, replication, endpoints, etc.)
- cloud-controller-manager - integrates with underlying cloud provider APIs

**[Kubernetes Components](https://kubernetes.io/docs/concepts/overview/components/)** - Overview of all cluster components
**[kube-apiserver](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/)** - API server reference
**[etcd](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/)** - etcd administration
**[kube-scheduler](https://kubernetes.io/docs/concepts/scheduling-eviction/kube-scheduler/)** - Scheduler overview

**Worker Node Components:**
- kubelet - agent that ensures containers are running in a Pod
- kube-proxy - maintains network rules on nodes for Service connectivity
- Container runtime - software responsible for running containers (containerd, CRI-O)

**[Node Components](https://kubernetes.io/docs/concepts/architecture/nodes/)** - Node architecture
**[kubelet](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/)** - kubelet reference
**[kube-proxy](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-proxy/)** - kube-proxy reference
**[Container Runtimes](https://kubernetes.io/docs/setup/production-environment/container-runtimes/)** - Supported runtimes

#### 1.2 Cluster Installation with kubeadm

**Key Tasks:**
- Initialize a control plane node with `kubeadm init`
- Join worker nodes with `kubeadm join`
- Configure pod network (CNI plugin installation)
- Set up kubeconfig for cluster access

**[Creating a cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)** - Step-by-step cluster creation
**[kubeadm init](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/)** - Initialize control plane
**[kubeadm join](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-join/)** - Join nodes to cluster
**[kubeadm token](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-token/)** - Manage bootstrap tokens

#### 1.3 Cluster Upgrades

**Upgrade Process:**
1. Upgrade kubeadm on control plane node
2. Run `kubeadm upgrade plan` to check available versions
3. Run `kubeadm upgrade apply` on first control plane node
4. Drain the node, upgrade kubelet and kubectl, restart kubelet, uncordon
5. Repeat for additional control plane nodes and worker nodes

**[Upgrading kubeadm clusters](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)** - Complete upgrade procedure
**[kubeadm upgrade](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-upgrade/)** - Upgrade command reference
**[Safely drain a node](https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/)** - Draining nodes during upgrades

#### 1.4 etcd Backup and Restore

**Backup Command:**
```bash
ETCDCTL_API=3 etcdctl snapshot save /path/to/backup.db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key
```

**Restore Command:**
```bash
ETCDCTL_API=3 etcdctl snapshot restore /path/to/backup.db \
  --data-dir=/var/lib/etcd-restore
```

**[Operating etcd clusters](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/)** - etcd administration guide
**[etcd Disaster Recovery](https://etcd.io/docs/v3.5/op-guide/recovery/)** - Official etcd recovery docs

#### 1.5 RBAC Configuration

**RBAC Resources:**
- Role - grants permissions within a specific namespace
- ClusterRole - grants permissions cluster-wide or across namespaces
- RoleBinding - binds a Role to users/groups/service accounts in a namespace
- ClusterRoleBinding - binds a ClusterRole to users/groups/service accounts cluster-wide

**[RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)** - Complete RBAC documentation
**[Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)** - Roles and bindings
**[Service Accounts](https://kubernetes.io/docs/concepts/security/service-accounts/)** - Service account management
**[Managing Service Accounts](https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin/)** - Admin guide for service accounts

### Domain 2: Workloads & Scheduling (15%)

This domain focuses on deploying and managing applications on Kubernetes.

#### 2.1 Deployments and Updates

**Key Concepts:**
- Deployments manage ReplicaSets which manage Pods
- Rolling updates gradually replace old pods with new ones
- Rollbacks revert to a previous deployment revision
- `maxUnavailable` and `maxSurge` control the update strategy

**[Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)** - Deployment management
**[ReplicaSets](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)** - ReplicaSet controller
**[Performing a Rolling Update](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/)** - Update tutorial

#### 2.2 StatefulSets and DaemonSets

**StatefulSets:**
- Provide guarantees about ordering and uniqueness of pods
- Stable, persistent storage per pod
- Ordered, graceful deployment and scaling
- Use cases: databases, distributed systems requiring stable identity

**DaemonSets:**
- Ensure a copy of a pod runs on all (or selected) nodes
- Use cases: log collectors, monitoring agents, network plugins

**[StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)** - StatefulSet documentation
**[DaemonSets](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)** - DaemonSet documentation

#### 2.3 Jobs and CronJobs

**Jobs:**
- Run a task to completion (one or more pods)
- Configurable completions, parallelism, and backoff limits
- `restartPolicy` must be `Never` or `OnFailure`

**CronJobs:**
- Schedule Jobs to run periodically using cron syntax
- Configure concurrency policy, deadline, and history limits

**[Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/)** - Job documentation
**[CronJobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)** - CronJob documentation
**[Automatic Cleanup for Finished Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/ttlafterfinished/)** - TTL controller

#### 2.4 Resource Management

**Requests and Limits:**
- `requests` - minimum resources guaranteed to the container
- `limits` - maximum resources the container can use
- Scheduler uses requests to find suitable nodes
- Kubelet enforces limits (CPU throttling, OOM kill for memory)

**[Resource Management for Pods](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)** - Resource requests and limits
**[LimitRange](https://kubernetes.io/docs/concepts/policy/limit-range/)** - Default limits per namespace
**[ResourceQuota](https://kubernetes.io/docs/concepts/policy/resource-quotas/)** - Namespace resource quotas

#### 2.5 Scheduling

**Node Selection:**
- `nodeSelector` - simple label-based scheduling
- `nodeAffinity` - expressive rules for node selection (required/preferred)
- `podAffinity/podAntiAffinity` - schedule relative to other pods

**Taints and Tolerations:**
- Taints are applied to nodes to repel pods
- Tolerations are applied to pods to allow scheduling on tainted nodes
- Effects: `NoSchedule`, `PreferNoSchedule`, `NoExecute`

**[Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)** - Node selectors and affinity
**[Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)** - Taint/toleration reference
**[Pod Priority and Preemption](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/)** - Priority classes

#### 2.6 ConfigMaps and Secrets

**ConfigMaps:**
- Store configuration data as key-value pairs
- Consumed as environment variables, command-line arguments, or volume mounts
- Changes to ConfigMaps are reflected in mounted volumes (with delay)

**Secrets:**
- Store sensitive data with base64 encoding
- Types: Opaque, kubernetes.io/tls, kubernetes.io/dockerconfigjson, etc.
- Can be mounted as volumes or exposed as environment variables

**[ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)** - ConfigMap documentation
**[Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)** - Secret documentation
**[Configure a Pod to Use a ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/)** - ConfigMap usage tutorial

### Domain 3: Services & Networking (20%)

This domain covers Kubernetes networking concepts and service exposure.

#### 3.1 Service Types

**ClusterIP (default):**
- Internal-only IP address
- Accessible only from within the cluster
- Use case: internal microservice communication

**NodePort:**
- Exposes the service on each node's IP at a static port (30000-32767)
- Accessible from outside the cluster via `<NodeIP>:<NodePort>`
- Automatically creates a ClusterIP

**LoadBalancer:**
- Exposes the service externally using a cloud provider's load balancer
- Automatically creates NodePort and ClusterIP
- Use case: production external access

**ExternalName:**
- Maps a service to a DNS name (CNAME record)
- No proxying, just DNS resolution
- Use case: accessing external services through Kubernetes DNS

**[Services](https://kubernetes.io/docs/concepts/services-networking/service/)** - Complete service documentation
**[Service Types](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)** - Service type reference
**[Connecting Applications with Services](https://kubernetes.io/docs/tutorials/services/connect-applications-service/)** - Service tutorial

#### 3.2 Ingress

**Key Concepts:**
- Ingress resources define rules for routing external HTTP/HTTPS traffic to services
- Ingress controllers implement the rules (NGINX, Traefik, HAProxy, etc.)
- Support for host-based routing, path-based routing, and TLS termination

**[Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)** - Ingress documentation
**[Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)** - Available controllers
**[NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)** - Popular ingress controller

#### 3.3 Network Policies

**Key Concepts:**
- Restrict ingress and egress traffic for pods
- Selected by pod labels, namespace selectors, and CIDR blocks
- Require a CNI plugin that supports Network Policies (Calico, Cilium, Weave Net)
- Default behavior: all traffic allowed (no policies applied)
- When a policy selects a pod, all traffic not explicitly allowed is denied

**[Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)** - Network Policy documentation
**[Declare Network Policy](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy/)** - Network Policy tutorial

#### 3.4 DNS in Kubernetes

**CoreDNS:**
- Default DNS server in Kubernetes clusters
- Provides DNS resolution for services and pods
- Service DNS: `<service-name>.<namespace>.svc.cluster.local`
- Pod DNS: `<pod-ip-dashed>.<namespace>.pod.cluster.local`

**[DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)** - DNS documentation
**[Customizing DNS Service](https://kubernetes.io/docs/tasks/administer-cluster/dns-custom-nameservers/)** - CoreDNS configuration
**[Debugging DNS Resolution](https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/)** - DNS troubleshooting

#### 3.5 CNI Plugins

**Common CNI Plugins:**
- Calico - network policies, BGP routing, high performance
- Flannel - simple overlay network, easy setup
- Cilium - eBPF-based, advanced network policies and observability
- Weave Net - mesh networking, encryption support

**[Cluster Networking](https://kubernetes.io/docs/concepts/cluster-administration/networking/)** - Networking model
**[Install a Network Policy Provider](https://kubernetes.io/docs/tasks/administer-cluster/network-policy-provider/)** - CNI installation

### Domain 4: Storage (10%)

This is the smallest domain but still carries significant weight. Storage tasks tend to be straightforward if you know the PV/PVC model.

#### 4.1 Persistent Volumes

**Key Concepts:**
- PVs are cluster-level storage resources provisioned by administrators
- Access Modes: ReadWriteOnce (RWO), ReadOnlyMany (ROX), ReadWriteMany (RWX)
- Reclaim Policies: Retain (keep data), Delete (remove storage), Recycle (deprecated)
- Volume Modes: Filesystem (default) or Block

**[Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)** - PV documentation
**[Configure a Pod to Use a PersistentVolume](https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/)** - PV tutorial

#### 4.2 Persistent Volume Claims

**Key Concepts:**
- PVCs are user requests for storage
- PVCs bind to PVs based on size, access mode, and storage class
- Pods reference PVCs in their volume specifications
- PVCs can request specific storage classes

**[Persistent Volume Claims](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims)** - PVC documentation

#### 4.3 Storage Classes

**Key Concepts:**
- Enable dynamic provisioning of PVs
- Define the provisioner, parameters, and reclaim policy
- `storageClassName` in PVC links to the Storage Class
- Default storage class provisions volumes when no class is specified

**[Storage Classes](https://kubernetes.io/docs/concepts/storage/storage-classes/)** - Storage Class documentation
**[Dynamic Volume Provisioning](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/)** - Dynamic provisioning guide
**[Change Default StorageClass](https://kubernetes.io/docs/tasks/administer-cluster/change-default-storage-class/)** - Managing default class

#### 4.4 Volume Types

**Common Volume Types:**
- `emptyDir` - temporary storage, deleted when pod is removed
- `hostPath` - mounts a file or directory from the host node
- `configMap` - mounts ConfigMap data as files
- `secret` - mounts Secret data as files
- `persistentVolumeClaim` - mounts a PVC

**[Volumes](https://kubernetes.io/docs/concepts/storage/volumes/)** - Volume types reference
**[Projected Volumes](https://kubernetes.io/docs/concepts/storage/projected-volumes/)** - Combine multiple sources

### Domain 5: Troubleshooting (30%)

This is the LARGEST domain - nearly a third of the exam. Strong troubleshooting skills are essential.

#### 5.1 Application Troubleshooting

**Common Pod States and Issues:**
- `Pending` - scheduler cannot find a suitable node (resource constraints, node selectors, taints)
- `CrashLoopBackOff` - container starts and crashes repeatedly (check logs)
- `ImagePullBackOff` - cannot pull container image (wrong name, missing credentials)
- `ContainerCreating` - volume mount issues, init container failures
- `Error` - container exited with non-zero exit code

**Troubleshooting Commands:**
```bash
kubectl get pods -o wide                    # Pod status and node placement
kubectl describe pod <name>                  # Detailed pod info and events
kubectl logs <pod> [-c container]            # Container logs
kubectl logs <pod> --previous                # Logs from previous crash
kubectl exec -it <pod> -- /bin/sh            # Shell into container
kubectl get events --sort-by=.metadata.creationTimestamp  # Recent events
```

**[Troubleshoot Applications](https://kubernetes.io/docs/tasks/debug/debug-application/)** - Application debugging guide
**[Debug Pods](https://kubernetes.io/docs/tasks/debug/debug-application/debug-pods/)** - Pod debugging
**[Debug Running Pods](https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pods/)** - Live debugging
**[Get a Shell to a Running Container](https://kubernetes.io/docs/tasks/debug/debug-application/get-shell-running-container/)** - Container shell access

#### 5.2 Cluster Component Troubleshooting

**Control Plane Issues:**
- Check component status: `kubectl get componentstatuses` (deprecated but useful)
- Check system pods: `kubectl get pods -n kube-system`
- Review component logs: `kubectl logs -n kube-system <component-pod>`
- Check static pod manifests: `/etc/kubernetes/manifests/`
- Check kubelet: `systemctl status kubelet`, `journalctl -u kubelet`

**[Troubleshoot Clusters](https://kubernetes.io/docs/tasks/debug/debug-cluster/)** - Cluster debugging guide
**[Debugging Kubernetes Nodes with crictl](https://kubernetes.io/docs/tasks/debug/debug-cluster/crictl/)** - Container runtime debugging

#### 5.3 Node Troubleshooting

**Common Node Conditions:**
- `Ready` - node is healthy and can accept pods
- `NotReady` - kubelet is not responding or node has issues
- `DiskPressure` - disk capacity is low
- `MemoryPressure` - node memory is running low
- `PIDPressure` - too many processes on the node
- `NetworkUnavailable` - network is not correctly configured

**Node Debugging:**
```bash
kubectl get nodes                           # Node status overview
kubectl describe node <name>                # Detailed node info
ssh <node> && systemctl status kubelet      # Check kubelet status
ssh <node> && journalctl -u kubelet -f      # Stream kubelet logs
ssh <node> && systemctl status containerd   # Check container runtime
```

**[Node Health Monitoring](https://kubernetes.io/docs/tasks/debug/debug-cluster/monitor-node-health/)** - Node monitoring
**[Safely Drain a Node](https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/)** - Node maintenance

#### 5.4 Networking Troubleshooting

**Common Issues:**
- Service not routing traffic - check selectors and endpoints
- Pod cannot reach another pod - check Network Policies and CNI
- DNS resolution failures - check CoreDNS pods and configuration
- External access not working - check Service type and Ingress

**Debugging Commands:**
```bash
kubectl get svc                              # List services
kubectl get endpoints <svc>                  # Check service endpoints
kubectl run test --image=busybox --rm -it -- nslookup <svc>  # DNS test
kubectl run test --image=busybox --rm -it -- wget -O- <svc>:<port>  # Connectivity test
```

**[Debug Services](https://kubernetes.io/docs/tasks/debug/debug-application/debug-service/)** - Service debugging guide
**[Debugging DNS Resolution](https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/)** - DNS troubleshooting

## Exam Environment Tips

### Allowed Resources During the Exam
You are allowed to open ONE additional browser tab to access:
- **[https://kubernetes.io/docs/](https://kubernetes.io/docs/)** - Official Kubernetes documentation
- **[https://kubernetes.io/blog/](https://kubernetes.io/blog/)** - Kubernetes blog
- **[https://github.com/kubernetes/](https://github.com/kubernetes/)** - Kubernetes GitHub repos

Subdomains and deep links within these domains are allowed. Bookmark important pages before the exam.

### Key Pages to Bookmark
- **[kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)** - Essential quick reference
- **[kubectl Reference](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands)** - Complete command reference
- **[API Reference](https://kubernetes.io/docs/reference/kubernetes-api/)** - Resource specifications

### Terminal Environment
- The exam uses a remote desktop via PSI Secure Browser
- You have access to a Linux terminal with kubectl pre-installed
- Multiple Kubernetes cluster contexts are provided
- You must switch contexts as instructed: `kubectl config use-context <name>`

### Time-Saving Tips
- Use imperative commands instead of writing YAML from scratch
- Use `kubectl explain <resource>` to check field names
- Use `--dry-run=client -o yaml` to generate YAML templates
- Set up aliases at the start: `alias k=kubectl`
- Enable kubectl autocompletion: `source <(kubectl completion bash)`
- Use `kubectl -h` for quick help on any command
- Copy/paste from the kubernetes.io docs when you need YAML examples

## Quick Reference - Domain Weight Summary

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| Troubleshooting | 30% | Logs, events, describe, node issues, networking |
| Cluster Architecture | 25% | kubeadm, RBAC, etcd, upgrades |
| Services & Networking | 20% | Services, Ingress, Network Policies, DNS |
| Workloads & Scheduling | 15% | Deployments, scheduling, resources, ConfigMaps |
| Storage | 10% | PV, PVC, Storage Classes, volume types |

## Common Imperative Commands Cheat Sheet

```bash
# Pods
kubectl run nginx --image=nginx
kubectl run nginx --image=nginx --port=80 --labels="app=web,tier=frontend"

# Deployments
kubectl create deployment web --image=nginx --replicas=3
kubectl scale deployment web --replicas=5
kubectl set image deployment/web nginx=nginx:1.25
kubectl rollout status deployment/web
kubectl rollout undo deployment/web
kubectl rollout history deployment/web

# Services
kubectl expose pod nginx --port=80 --target-port=80 --type=ClusterIP
kubectl expose deployment web --port=80 --type=NodePort
kubectl create service clusterip my-svc --tcp=80:80

# ConfigMaps and Secrets
kubectl create configmap app-config --from-literal=DB_HOST=mysql --from-file=config.properties
kubectl create secret generic db-secret --from-literal=password=mysecret

# RBAC
kubectl create role pod-reader --verb=get,list,watch --resource=pods
kubectl create clusterrole node-reader --verb=get,list --resource=nodes
kubectl create rolebinding pod-reader-binding --role=pod-reader --user=jane
kubectl create clusterrolebinding node-reader-binding --clusterrole=node-reader --user=jane
kubectl create serviceaccount my-sa

# Debugging
kubectl get all -A
kubectl top nodes
kubectl top pods
kubectl auth can-i create pods --as=jane
kubectl auth can-i list secrets --as=system:serviceaccount:default:my-sa
```

---

**Study Tip:** Print or bookmark this fact sheet. Review it regularly and practice every command in a real cluster. The CKA rewards muscle memory and speed - if you have to think about command syntax during the exam, you will run out of time.
