# Kubernetes Fundamentals

**[📖 Kubernetes Components](https://kubernetes.io/docs/concepts/overview/components/)** - Cluster architecture and component overview

## Cluster Architecture

### Control Plane Components

The control plane makes global decisions about the cluster (scheduling, detecting and responding to cluster events).

#### kube-apiserver
- Front end for the Kubernetes control plane
- All communication goes through the API server (single point of entry)
- Handles authentication, authorization, and admission control
- Exposes the Kubernetes API via REST
- Only component that communicates directly with etcd

**[📖 API Server](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/)** - API server reference

#### etcd
- Consistent and highly available key-value store
- Stores all cluster state and configuration data
- Only accessed by the API server (never directly by other components)
- Requires regular backups for disaster recovery
- Uses the Raft consensus algorithm for distributed consistency

**[📖 etcd Documentation](https://etcd.io/docs/)** - etcd key-value store

#### kube-scheduler
- Watches for newly created Pods with no assigned node
- Selects the best node based on resource requirements, constraints, and policies
- Considers factors: resource requests/limits, node affinity, taints/tolerations, pod anti-affinity
- Does not run the pod - just decides where it should go

#### kube-controller-manager
- Runs controller loops that watch the cluster state and make changes
- Key controllers:
  - **Node Controller**: Monitors node health and responds to node failures
  - **Deployment Controller**: Manages Deployments and creates ReplicaSets
  - **ReplicaSet Controller**: Ensures the correct number of pod replicas
  - **Job Controller**: Watches for Job objects and creates Pods to run tasks
  - **ServiceAccount Controller**: Creates default ServiceAccounts for namespaces

#### cloud-controller-manager
- Integrates with cloud provider APIs (AWS, GCP, Azure)
- Manages cloud-specific resources (load balancers, storage volumes, node lifecycle)
- Only runs in cloud-hosted clusters (not in on-premises deployments)

### Worker Node Components

#### kubelet
- Agent that runs on every worker node
- Ensures containers are running in a pod as specified
- Communicates with the API server to receive pod specifications
- Reports node and pod status back to the API server
- Manages container lifecycle via the container runtime

#### kube-proxy
- Network proxy running on every node
- Maintains network rules for Service abstraction
- Implements Service routing (iptables or IPVS mode)
- Enables pod-to-Service communication across nodes
- Does NOT handle pod-to-pod networking (that is the CNI plugin's job)

#### Container Runtime
- Software responsible for running containers
- Kubernetes supports any runtime implementing the Container Runtime Interface (CRI)
- Common runtimes: containerd (most common), CRI-O
- Docker was removed as a direct runtime in Kubernetes v1.24 (containerd still works with Docker images)

## Kubernetes Objects

### Pods
- Smallest deployable unit in Kubernetes
- Contains one or more containers that share network and storage
- Each pod gets its own IP address
- Pods are ephemeral - they are not rescheduled; new pods replace them
- Multi-container patterns: sidecar, ambassador, adapter

**[📖 Pods](https://kubernetes.io/docs/concepts/workloads/pods/)** - Pod documentation

### Deployments
- Declarative way to manage ReplicaSets and Pods
- Supports rolling updates and rollbacks
- Defines the desired state (image, replicas, resources)
- The Deployment controller ensures actual state matches desired state
- Most common workload resource for stateless applications

### ReplicaSets
- Ensures a specified number of pod replicas are running
- Usually managed by a Deployment (rarely created directly)
- Uses label selectors to identify pods it manages

### StatefulSets
- For stateful applications that need stable identities
- Provides: stable network identity (ordered naming), persistent storage per pod, ordered deployment and scaling
- Use cases: databases, message queues, distributed systems
- Requires a Headless Service for DNS resolution

### DaemonSets
- Ensures a copy of a pod runs on every node (or a subset)
- Use cases: log collectors, monitoring agents, network plugins
- New pods are automatically created when new nodes join the cluster

### Services
| Type | Description | Use Case |
|------|-------------|----------|
| ClusterIP | Internal cluster IP (default) | Internal service-to-service communication |
| NodePort | Exposes on each node's IP at a static port (30000-32767) | Development/testing or simple external access |
| LoadBalancer | Provisions external cloud load balancer | Production external access in cloud environments |
| ExternalName | Maps to external DNS name (CNAME) | Referencing external services by internal DNS name |

**[📖 Services](https://kubernetes.io/docs/concepts/services-networking/service/)** - Service types and configuration

### Namespaces
- Virtual clusters within a physical cluster
- Provide resource scoping and isolation
- Default namespaces: default, kube-system, kube-public, kube-node-lease
- Resources can be namespace-scoped or cluster-scoped
- RBAC policies can be applied per namespace

### ConfigMaps and Secrets
- **ConfigMaps**: Store non-sensitive configuration data as key-value pairs
- **Secrets**: Store sensitive data (passwords, tokens, keys) - base64-encoded by default
- Both can be mounted as volumes or exposed as environment variables
- Decouples configuration from container images (12-factor principle)

## Storage

### Persistent Volumes (PV)
- Cluster-level storage resources provisioned by administrators
- Lifecycle independent of any pod that uses them
- Types: NFS, iSCSI, cloud provider disks (EBS, Persistent Disk, Azure Disk)

### Persistent Volume Claims (PVC)
- User request for storage
- Binds to an available PV that meets the requirements
- Pods reference PVCs to use persistent storage

### StorageClasses
- Describe "classes" of storage (fast SSD, standard HDD, etc.)
- Enable dynamic provisioning - PVs are created automatically when PVCs are submitted
- Eliminates the need for administrators to pre-provision storage

### Access Modes
- **ReadWriteOnce (RWO)**: Mounted read-write by a single node
- **ReadOnlyMany (ROX)**: Mounted read-only by many nodes
- **ReadWriteMany (RWX)**: Mounted read-write by many nodes

## Networking

### Kubernetes Networking Model
- Every pod gets its own IP address
- Pods can communicate with all other pods without NAT (flat network)
- Agents on a node can communicate with all pods on that node
- Implemented by Container Network Interface (CNI) plugins (Calico, Cilium, Flannel, Weave)

### DNS
- CoreDNS is the default DNS provider
- Services get DNS entries: `service-name.namespace.svc.cluster.local`
- Pods can resolve services by name within the same namespace

### Ingress
- HTTP/HTTPS routing to services based on hostname or path
- Requires an Ingress controller (nginx, Traefik, HAProxy)
- Supports TLS termination and virtual hosting
- More efficient than NodePort/LoadBalancer for HTTP traffic

**[📖 Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)** - Ingress resource and controllers
