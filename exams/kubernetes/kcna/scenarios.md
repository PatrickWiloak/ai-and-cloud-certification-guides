# KCNA High-Yield Scenarios and Practice Problems

## Scenario 1: Kubernetes Architecture

**Scenario**: A team is deploying their first Kubernetes cluster. The lead engineer asks you to explain what happens when a user runs `kubectl apply -f deployment.yaml`. Which components are involved and in what order?

**Solution Pattern**:
- **kubectl** sends the request to the **kube-apiserver**
- The **API server** authenticates, authorizes, and validates the request
- The **API server** stores the Deployment object in **etcd**
- The **Deployment controller** (in kube-controller-manager) detects the new Deployment and creates a ReplicaSet
- The **ReplicaSet controller** creates Pod objects based on the replica count
- The **kube-scheduler** assigns each Pod to a suitable node
- The **kubelet** on the assigned node pulls the container image and starts the container via the container runtime

**Common Distractors**:
- The scheduler creates pods (incorrect - the controller manager creates pods, the scheduler assigns them to nodes)
- etcd communicates directly with kubelet (incorrect - all communication goes through the API server)
- kube-proxy schedules pods (incorrect - kube-proxy manages network rules for Services)

**Key Takeaway**: The API server is the single point of communication. All components interact through the API server, never directly with each other or etcd.

---

## Scenario 2: Choosing the Right Service Type

**Scenario**: A company has three applications in their Kubernetes cluster:
1. A backend API that only needs to be reached by other pods in the cluster
2. A web frontend that must be accessible from the internet
3. An external database hosted outside the cluster that internal services need to reference by name

**Solution Pattern**:
- **Backend API**: ClusterIP Service - internal-only access within the cluster
- **Web Frontend**: LoadBalancer Service (or NodePort behind a cloud load balancer) - external access from the internet
- **External Database**: ExternalName Service - creates a CNAME DNS record pointing to the external hostname

**Common Distractors**:
- Using NodePort for the backend (unnecessary external exposure)
- Using LoadBalancer for all services (wasteful and insecure for internal-only services)
- Using ClusterIP for the external database (ClusterIP is for internal pods, not external services)

**Key Takeaway**: Match Service type to access requirements. ClusterIP for internal, LoadBalancer for external, ExternalName for referencing external services.

---

## Scenario 3: Container Orchestration Benefits

**Scenario**: A startup is running 20 containers directly on three VMs using Docker Compose. They experience frequent downtime when containers crash, manual scaling during traffic spikes, and difficulty updating applications without downtime. Which Kubernetes features address each of these problems?

**Solution Pattern**:
- **Container crashes**: Self-healing via restart policies and liveness probes - Kubernetes automatically restarts failed containers
- **Manual scaling**: Horizontal Pod Autoscaler (HPA) scales pods based on CPU/memory metrics or custom metrics
- **Updates without downtime**: Rolling update strategy in Deployments - gradually replaces old pods with new ones

**Common Distractors**:
- Using DaemonSets for scaling (DaemonSets run one pod per node, not for scaling)
- Using ConfigMaps for self-healing (ConfigMaps store configuration, not health management)
- Using StatefulSets for the rolling update feature (StatefulSets are for ordered, stateful workloads)

**Key Takeaway**: Kubernetes solves the core operational challenges of running containers at scale - self-healing, auto-scaling, and zero-downtime deployments.

---

## Scenario 4: CNCF Ecosystem Tool Selection

**Scenario**: An engineering team needs to set up a complete observability stack for their Kubernetes cluster. They need to collect metrics from all pods, aggregate logs from all containers, implement distributed tracing across microservices, and create dashboards for visualization. Which CNCF ecosystem tools should they use?

**Solution Pattern**:
- **Metrics**: Prometheus (CNCF Graduated) - scrapes metrics endpoints, stores time-series data, supports alerting
- **Logs**: Fluentd (CNCF Graduated) or Fluent Bit - collects and forwards log data from containers
- **Tracing**: OpenTelemetry (CNCF Incubating) or Jaeger (CNCF Graduated) - distributed tracing across services
- **Dashboards**: Grafana - visualization and dashboarding for metrics, logs, and traces

**Common Distractors**:
- Using Prometheus for log collection (Prometheus is for metrics, not logs)
- Confusing Envoy (service proxy) with observability tools
- Using Helm for monitoring (Helm is for package management, not observability)

**Key Takeaway**: The three pillars of observability - metrics, logs, and traces - each have dedicated tools in the CNCF ecosystem. Know which tool serves which pillar.

---

## Scenario 5: Cloud Native Architecture Decision

**Scenario**: A company is refactoring a monolithic Java application into microservices for Kubernetes. The application has a user service, order service, payment service, and notification service. The architect asks about deployment and communication patterns. What cloud native best practices should they follow?

**Solution Pattern**:
- **Deployment**: Each microservice gets its own Deployment, Service, and namespace (or at minimum its own Deployment and Service)
- **Communication**: Services communicate via Kubernetes Services using DNS names (e.g., `order-service.orders.svc.cluster.local`)
- **Configuration**: Use ConfigMaps for non-sensitive config and Secrets for credentials - follow the 12-factor app principle of externalizing configuration
- **Resilience**: Implement readiness and liveness probes for each service; use circuit breaker patterns for inter-service calls
- **Scaling**: Each service scales independently based on its own resource requirements

**Common Distractors**:
- Running all microservices in a single pod (defeats the purpose of microservices)
- Hardcoding service URLs (violates cloud native principles - use DNS-based service discovery)
- Storing configuration in container images (violates 12-factor principle of separating config from code)

**Key Takeaway**: Cloud native applications are loosely coupled, independently deployable, and use Kubernetes-native primitives for configuration and communication.

---

## Scenario 6: Application Delivery with GitOps

**Scenario**: A platform team wants to adopt GitOps for deploying applications to their Kubernetes clusters. They currently deploy by running `kubectl apply` manually from developer laptops. What changes should they make?

**Solution Pattern**:
- **Git as source of truth**: Store all Kubernetes manifests in a Git repository
- **GitOps controller**: Deploy ArgoCD or Flux to the cluster to watch the Git repository
- **Workflow**: Developers push manifest changes to Git; the GitOps controller detects changes and syncs the cluster state to match
- **Benefits**: Audit trail via Git history, rollback via Git revert, consistent environments, no direct cluster access needed for deployments
- **Packaging**: Use Helm charts or Kustomize overlays for environment-specific configurations

**Common Distractors**:
- GitOps means using GitHub Actions for CI/CD (CI is separate from GitOps - GitOps is about continuous delivery from Git state)
- Developers still need direct kubectl access (GitOps eliminates this need for deployments)
- Helm replaces GitOps (Helm is a packaging tool that works alongside GitOps, not a replacement)

**Key Takeaway**: GitOps treats Git as the single source of truth for declarative infrastructure. Changes are made via Git commits, and a controller ensures the cluster matches the desired state.

---

## Scenario 7: Storage and StatefulSets

**Scenario**: A team needs to run a three-node PostgreSQL cluster on Kubernetes. Each database instance needs its own persistent storage that survives pod restarts and rescheduling. Which Kubernetes resources should they use?

**Solution Pattern**:
- **StatefulSet**: Provides stable network identities (postgres-0, postgres-1, postgres-2) and ordered deployment
- **PersistentVolumeClaim (PVC) template**: Each pod gets its own PVC, ensuring dedicated storage per instance
- **StorageClass**: Defines the storage backend (cloud SSD, NFS, etc.) with dynamic provisioning
- **Headless Service**: Allows direct DNS resolution to each pod (postgres-0.postgres-svc.namespace.svc.cluster.local)

**Common Distractors**:
- Using a Deployment with a shared PVC (multiple database instances cannot safely share one volume)
- Using DaemonSet for database nodes (DaemonSet runs on every node, not a fixed replica count)
- Using emptyDir volumes (data is lost when the pod is rescheduled to a different node)

**Key Takeaway**: StatefulSets are designed for stateful workloads that need stable identities and persistent storage. Deployments are for stateless workloads.

## Key Decision Factors

### Domain Priority for Study
1. **Kubernetes Fundamentals (46%)** - Architecture, objects, networking, storage
2. **Container Orchestration (22%)** - Containers, runtimes, scheduling, scaling
3. **Cloud Native Architecture (16%)** - Principles, CNCF ecosystem, microservices
4. **Cloud Native Observability (8%)** - Metrics, logs, traces, Prometheus, Grafana
5. **Cloud Native Application Delivery (8%)** - GitOps, Helm, Kustomize, CI/CD

### Common Anti-Patterns
- Memorizing commands instead of understanding concepts (this is a knowledge exam)
- Ignoring the CNCF ecosystem beyond Kubernetes
- Not understanding the relationships between components
- Confusing similar-sounding concepts (StatefulSet vs Deployment, ConfigMap vs Secret)
- Focusing only on Kubernetes while neglecting cloud native architecture principles
