# Cloud Native Observability and Application Delivery

## Observability

**[📖 OpenTelemetry](https://opentelemetry.io/docs/)** - Observability framework documentation

### Three Pillars of Observability

#### Metrics
- Numerical measurements collected over time (time-series data)
- Examples: CPU usage, request rate, error rate, latency
- Tools: Prometheus (collection and storage), Grafana (visualization)
- Types: counters (always increase), gauges (go up and down), histograms (distribution of values)

#### Logs
- Timestamped, structured or unstructured text records of events
- Examples: application logs, access logs, error logs
- Tools: Fluentd/Fluent Bit (collection), Elasticsearch/Loki (storage), Kibana/Grafana (querying)
- Best practice: Log to stdout/stderr and let a log aggregator collect them

#### Traces
- End-to-end tracking of requests across distributed services
- Shows the path a request takes through multiple microservices
- Tools: Jaeger (CNCF Graduated), OpenTelemetry (CNCF Incubating), Zipkin
- Key concepts: spans (individual operations), trace ID (links spans together)

### Prometheus

**[📖 Prometheus Documentation](https://prometheus.io/docs/introduction/overview/)** - Monitoring and alerting system

**Architecture:**
- **Prometheus Server**: Scrapes and stores metrics
- **Exporters**: Expose metrics in Prometheus format (Node Exporter, kube-state-metrics)
- **Alertmanager**: Handles alert routing, grouping, and notification
- **Pushgateway**: For short-lived jobs that cannot be scraped
- **PromQL**: Query language for querying time-series data

**Key Concepts:**
- Pull-based model - Prometheus scrapes metric endpoints
- Targets are discovered via service discovery or static configuration
- Data stored as time-series with labels for dimensional data
- CNCF Graduated project

### Grafana
- Open source dashboarding and visualization platform
- Supports multiple data sources (Prometheus, Loki, Elasticsearch, etc.)
- Used for creating dashboards, alerts, and exploring data
- Not a CNCF project but deeply integrated with the cloud native ecosystem

### Fluentd and Fluent Bit

**[📖 Fluentd](https://www.fluentd.org/)** - CNCF Graduated log aggregator

- **Fluentd**: Full-featured log aggregator with plugin ecosystem
- **Fluent Bit**: Lightweight log forwarder, ideal for Kubernetes nodes
- Common pattern: Fluent Bit on nodes (DaemonSet) forwarding to Fluentd aggregators
- Supports multiple output destinations (Elasticsearch, S3, Kafka, etc.)

### OpenTelemetry

**[📖 OpenTelemetry](https://opentelemetry.io/)** - CNCF Incubating observability framework

- Unified standard for collecting metrics, logs, and traces
- Vendor-neutral instrumentation libraries
- OpenTelemetry Collector for receiving, processing, and exporting telemetry data
- Merges OpenTracing and OpenCensus projects
- Provides SDKs for most programming languages

## Application Delivery

### GitOps

**Principles:**
1. **Declarative**: The desired state of the system is described declaratively
2. **Versioned and immutable**: Desired state is stored in Git (versioned, auditable)
3. **Pulled automatically**: Software agents automatically pull and apply changes from Git
4. **Continuously reconciled**: Agents continuously ensure actual state matches desired state

**[📖 OpenGitOps](https://opengitops.dev/)** - GitOps principles specification

**Key Tools:**

**ArgoCD:**
- Declarative GitOps continuous delivery for Kubernetes
- CNCF Graduated project (part of Argo project)
- Syncs Kubernetes resources from Git repositories
- Web UI for visualizing application state and history
- Supports Helm, Kustomize, and plain manifests

**[📖 ArgoCD](https://argo-cd.readthedocs.io/)** - ArgoCD documentation

**Flux:**
- GitOps toolkit for Kubernetes
- CNCF Graduated project
- Lightweight and composable (separate controllers for different functions)
- Supports Helm, Kustomize, and OCI artifacts

**[📖 Flux](https://fluxcd.io/docs/)** - Flux documentation

### Helm

**[📖 Helm Documentation](https://helm.sh/docs/)** - Kubernetes package manager

- Package manager for Kubernetes (like apt or brew for Kubernetes)
- **Charts**: Packages of pre-configured Kubernetes resources
- **Releases**: Instances of charts deployed to a cluster
- **Repositories**: Collections of charts available for installation
- Supports templating for parameterized configurations
- Version management and rollback capabilities
- CNCF Graduated project

### Kustomize

**[📖 Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/)** - Kubernetes-native manifest customization

- Template-free customization of Kubernetes manifests
- Built into kubectl (`kubectl apply -k`)
- Uses overlays for environment-specific configurations (dev, staging, production)
- Supports patches, name prefixes, labels, and resource composition
- No templating language to learn (unlike Helm)

### CI/CD Concepts

**Continuous Integration (CI):**
- Developers merge code changes frequently
- Automated builds and tests on every merge
- Catches issues early in the development cycle
- Tools: GitHub Actions, GitLab CI, Jenkins, Tekton

**Continuous Delivery (CD):**
- Code is always in a deployable state
- Deployments to production are automated but may require manual approval
- Tools: ArgoCD, Flux, Spinnaker

**Continuous Deployment:**
- Every change that passes tests is automatically deployed to production
- No manual intervention required
- Requires high confidence in automated testing

### Deployment Patterns

| Pattern | Description | Risk Level |
|---------|-------------|-----------|
| Rolling Update | Gradual replacement of old with new | Low |
| Blue-Green | Two identical environments, switch traffic | Low |
| Canary | Small percentage of traffic to new version | Very Low |
| Recreate | Stop old, start new (brief downtime) | Medium |
| A/B Testing | Different versions for different user segments | Low |

### Infrastructure as Code Tools

**Terraform:**
- Declarative infrastructure provisioning
- Multi-cloud support (AWS, GCP, Azure, etc.)
- State management and plan/apply workflow
- HCL (HashiCorp Configuration Language)

**Pulumi:**
- Infrastructure as code using general-purpose programming languages
- Supports TypeScript, Python, Go, C#
- State management similar to Terraform

**Crossplane:**
- Kubernetes-native infrastructure management (CNCF Incubating)
- Extends Kubernetes API with custom resources for infrastructure
- Compose and manage infrastructure using Kubernetes manifests
