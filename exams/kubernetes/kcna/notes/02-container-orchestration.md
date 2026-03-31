# Container Orchestration

**[📖 Containers Overview](https://kubernetes.io/docs/concepts/containers/)** - Container concepts in Kubernetes

## Container Fundamentals

### Containers vs Virtual Machines

| Aspect | Containers | Virtual Machines |
|--------|-----------|-----------------|
| Isolation | Process-level (shared kernel) | Hardware-level (separate kernel) |
| Size | Megabytes | Gigabytes |
| Startup | Seconds | Minutes |
| Overhead | Minimal | Significant (full OS per VM) |
| Density | High (many per host) | Lower (fewer per host) |
| Portability | Highly portable | Less portable |

### Container Images
- Immutable templates for creating containers
- Built in layers (each instruction in a Dockerfile creates a layer)
- Layers are cached and shared between images for efficiency
- Stored in container registries (Docker Hub, GCR, ECR, GHCR)
- Images are identified by name:tag or name@digest

### Container Runtimes
- Software responsible for running containers on a host
- Kubernetes uses the Container Runtime Interface (CRI) to communicate with runtimes
- **containerd**: Most widely used runtime, CNCF Graduated project
- **CRI-O**: Lightweight runtime specifically designed for Kubernetes
- Docker was removed as a direct runtime in v1.24, but Docker-built images still work

**[📖 Container Runtimes](https://kubernetes.io/docs/setup/production-environment/container-runtimes/)** - Supported runtimes

### OCI Standards
- **Open Container Initiative (OCI)**: Industry standards for container formats
- **Image Spec**: Standard format for container images
- **Runtime Spec**: Standard for running containers
- **Distribution Spec**: Standard for distributing container images
- Ensures interoperability between different container tools

## Why Container Orchestration

### Problems Orchestration Solves
1. **Scheduling**: Deciding which host should run each container based on resource availability
2. **Self-healing**: Automatically restarting failed containers and replacing unhealthy ones
3. **Scaling**: Adding or removing container instances based on demand
4. **Load balancing**: Distributing traffic across container instances
5. **Service discovery**: Containers finding and communicating with each other
6. **Rolling updates**: Deploying new versions without downtime
7. **Secret management**: Securely managing sensitive configuration data
8. **Storage orchestration**: Automatically mounting storage volumes

### Kubernetes Orchestration Features

#### Scheduling and Resource Management
- **Resource Requests**: Minimum CPU/memory a container needs (used for scheduling decisions)
- **Resource Limits**: Maximum CPU/memory a container can use (enforced at runtime)
- **Node Selectors**: Schedule pods on nodes with specific labels
- **Node Affinity**: Advanced scheduling rules (preferred vs required)
- **Taints and Tolerations**: Restrict which pods can run on specific nodes
- **Pod Affinity/Anti-Affinity**: Schedule pods relative to other pods

**[📖 Scheduling](https://kubernetes.io/docs/concepts/scheduling-eviction/)** - Pod scheduling and eviction

#### Self-Healing

**Health Checks (Probes):**

| Probe | Purpose | Failure Action |
|-------|---------|---------------|
| Liveness | Is the container alive? | Restart the container |
| Readiness | Is the container ready to serve traffic? | Remove from Service endpoints |
| Startup | Has the container started? | Delay liveness/readiness checks |

- Probe methods: HTTP GET, TCP socket, exec command, gRPC
- Kubernetes restarts containers that fail liveness checks
- Kubernetes removes pods from Service endpoints that fail readiness checks

**[📖 Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)** - Probes and lifecycle hooks

#### Scaling

**Horizontal Pod Autoscaler (HPA):**
- Automatically scales the number of pod replicas
- Based on CPU utilization, memory utilization, or custom metrics
- Configurable min and max replica counts
- Checks metrics at regular intervals (default 15 seconds)

**Cluster Autoscaler:**
- Scales the number of nodes in the cluster
- Adds nodes when pods cannot be scheduled due to insufficient resources
- Removes underutilized nodes to reduce costs
- Cloud-provider specific implementation

**Vertical Pod Autoscaler (VPA):**
- Adjusts resource requests and limits for containers
- Useful when workloads have variable resource requirements
- Can recommend or automatically apply changes

**[📖 Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)** - HPA documentation

#### Deployment Strategies

**Rolling Update (default):**
- Gradually replaces old pods with new pods
- Configurable via `maxSurge` and `maxUnavailable`
- No downtime during deployment
- Easy rollback with `kubectl rollout undo`

**Recreate:**
- Terminates all old pods before creating new ones
- Results in brief downtime
- Use when the application cannot run multiple versions simultaneously

**Blue-Green Deployment:**
- Run both old and new versions simultaneously
- Switch traffic from old to new via Service selector change
- Requires double the resources temporarily
- Implemented using labels and Service selectors

**Canary Deployment:**
- Route a small percentage of traffic to the new version
- Gradually increase traffic if the new version is stable
- Implemented using multiple Deployments with shared Service labels

## Configuration Management

### ConfigMaps
- Store non-sensitive configuration as key-value pairs
- Can be mounted as files in a volume or exposed as environment variables
- Changes to ConfigMaps are reflected in mounted volumes (eventually)
- Decouples configuration from container images

### Secrets
- Store sensitive data (passwords, tokens, TLS certificates)
- Base64-encoded by default (not encrypted unless encryption at rest is configured)
- Can be mounted as files or exposed as environment variables
- Types: Opaque, kubernetes.io/tls, kubernetes.io/dockerconfigjson

### Best Practices
- Never bake configuration into container images
- Use ConfigMaps for non-sensitive data, Secrets for sensitive data
- Consider external secret management for production (Vault, cloud KMS)
- Use immutable ConfigMaps/Secrets when values should not change
