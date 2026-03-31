# Cloud Native Architecture

**[📖 CNCF Cloud Native Definition](https://github.com/cncf/toc/blob/main/DEFINITION.md)** - Official definition
**[📖 CNCF Landscape](https://landscape.cncf.io/)** - Visual map of the ecosystem

## Cloud Native Definition

Cloud native technologies empower organizations to build and run scalable applications in modern, dynamic environments such as public, private, and hybrid clouds. Containers, service meshes, microservices, immutable infrastructure, and declarative APIs exemplify this approach.

### Key Characteristics
1. **Containerized**: Applications packaged in containers for consistency and portability
2. **Dynamically orchestrated**: Managed by orchestration platforms like Kubernetes
3. **Microservices-oriented**: Loosely coupled, independently deployable services
4. **Declarative**: Desired state is declared, controllers reconcile actual state
5. **Observable**: Built-in telemetry for metrics, logs, and traces

## 12-Factor Application Methodology

**[📖 12-Factor App](https://12factor.net/)** - Full methodology reference

| Factor | Principle | Cloud Native Mapping |
|--------|-----------|---------------------|
| Codebase | One codebase tracked in VCS | Git repository per service |
| Dependencies | Explicitly declare dependencies | Container images, dependency files |
| Config | Store config in environment | ConfigMaps, Secrets, environment variables |
| Backing Services | Treat as attached resources | Kubernetes Services, external databases |
| Build, Release, Run | Strictly separate stages | CI/CD pipelines, container image tags |
| Processes | Execute as stateless processes | Stateless pods, external state stores |
| Port Binding | Export services via port binding | Kubernetes Service port mapping |
| Concurrency | Scale out via the process model | Horizontal Pod Autoscaler |
| Disposability | Fast startup and graceful shutdown | Pod lifecycle hooks, preStop |
| Dev/Prod Parity | Keep environments similar | Namespaces, Kustomize overlays |
| Logs | Treat logs as event streams | stdout/stderr, Fluentd collection |
| Admin Processes | Run admin tasks as one-off processes | Kubernetes Jobs |

## Microservices Architecture

### Microservices vs Monolithic

| Aspect | Monolithic | Microservices |
|--------|-----------|--------------|
| Deployment | Deploy entire application | Deploy individual services |
| Scaling | Scale the whole application | Scale each service independently |
| Technology | Single technology stack | Polyglot (different tech per service) |
| Failure | One failure can crash everything | Isolated failures per service |
| Development | Single team, shared codebase | Independent teams per service |
| Complexity | Simple to start, complex to maintain | Complex to start, easier to maintain at scale |

### Microservices Best Practices
- Each service has a single responsibility
- Services communicate via well-defined APIs (REST, gRPC)
- Each service manages its own data store
- Services are independently deployable and scalable
- Use API gateways for external client communication
- Implement circuit breakers for resilience

## CNCF Ecosystem

### Project Maturity Levels

| Level | Description | Examples |
|-------|-------------|---------|
| Graduated | Widely adopted, production-ready, strong governance | Kubernetes, Prometheus, Envoy, containerd, CoreDNS, Fluentd, Helm, Argo |
| Incubating | Growing adoption, maturing governance | OpenTelemetry, Flux, Knative, Cilium, Crossplane |
| Sandbox | Early stage, experimental, innovation | New and emerging projects with potential |

**[📖 CNCF Projects](https://www.cncf.io/projects/)** - Complete project list by maturity

### Key Graduated Projects

**Kubernetes** - Container orchestration platform
**Prometheus** - Monitoring and alerting system
**Envoy** - High-performance service proxy
**CoreDNS** - DNS server for service discovery
**containerd** - Container runtime
**Fluentd** - Log aggregation and forwarding
**Helm** - Kubernetes package manager
**Argo** - Workflow and GitOps tools
**Jaeger** - Distributed tracing

### Service Mesh

A service mesh is an infrastructure layer that handles service-to-service communication, providing features like traffic management, security, and observability without modifying application code.

**Key Features:**
- **mTLS**: Automatic encryption between services
- **Traffic management**: Routing, load balancing, retries, timeouts
- **Observability**: Metrics, logs, and traces for all service communication
- **Policy enforcement**: Access control and rate limiting

**Key Projects:**
- **Istio**: Most widely used service mesh, feature-rich
- **Linkerd**: Lightweight, Kubernetes-native service mesh (CNCF Graduated)
- **Cilium Service Mesh**: eBPF-based, high-performance

### Serverless and Event-Driven

**Knative**: Platform for building, deploying, and managing serverless workloads on Kubernetes
- **Knative Serving**: Request-driven compute, scale-to-zero
- **Knative Eventing**: Event-driven architecture and event routing

**CloudEvents**: Specification for describing event data in a common way

## Infrastructure as Code

### Declarative vs Imperative
- **Declarative**: Describe what the desired state should be (Kubernetes manifests, Terraform)
- **Imperative**: Describe the steps to achieve the state (shell scripts, manual commands)
- Cloud native strongly favors declarative approaches
- Kubernetes controllers continuously reconcile actual state with desired state

### Immutable Infrastructure
- Infrastructure is never modified after deployment
- Changes are made by deploying new instances (new container image, new pod)
- Benefits: consistency, reproducibility, easier rollback
- Container images are immutable - any change requires building a new image

## Cloud Native Security

### Defense in Depth
- Multiple layers of security controls
- No single point of failure in security posture
- Apply security at every layer: code, container, cluster, cloud

### Key Security Concepts
- **RBAC**: Role-based access control for API authorization
- **Network Policies**: Pod-level network segmentation
- **Pod Security Standards**: Restrict pod capabilities (Privileged, Baseline, Restricted)
- **Secrets Management**: Secure handling of sensitive data
- **Image Scanning**: Vulnerability detection in container images
- **Supply Chain Security**: Signing and verifying container images
