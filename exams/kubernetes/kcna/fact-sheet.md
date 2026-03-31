# Kubernetes and Cloud Native Associate (KCNA) Fact Sheet

## Exam Overview

**Exam Code:** KCNA
**Exam Name:** Kubernetes and Cloud Native Associate
**Duration:** 90 minutes
**Format:** Multiple choice (60 questions)
**Passing Score:** 75%
**Cost:** $250 USD (includes one free retake)
**Valid For:** 3 years
**Delivery:** Online proctored via PSI
**Prerequisites:** None

**[📖 Official KCNA Exam Page](https://training.linuxfoundation.org/certification/kubernetes-cloud-native-associate/)** - Registration and exam details
**[📖 KCNA Exam Curriculum](https://github.com/cncf/curriculum)** - Official exam objectives and domains
**[📖 CNCF Certification FAQ](https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks)** - Frequently asked questions

## Target Audience

This certification is designed for:
- Beginners entering the cloud native ecosystem
- Developers who want to understand Kubernetes concepts
- Operations staff transitioning to cloud native tooling
- Managers evaluating cloud native adoption
- Students preparing for advanced Kubernetes certifications (CKA, CKAD, CKS)

**[📖 Cloud Native Glossary](https://glossary.cncf.io/)** - CNCF terminology reference
**[📖 CNCF Landscape](https://landscape.cncf.io/)** - Visual map of cloud native technologies

## Exam Domains

### Domain 1: Kubernetes Fundamentals (46%)

This is the largest domain - nearly half the exam tests core Kubernetes knowledge.

#### 1.1 Kubernetes Architecture

**Key Concepts:**
- Control plane components: API server, etcd, scheduler, controller manager
- Worker node components: kubelet, kube-proxy, container runtime
- Communication flow between control plane and worker nodes
- High availability control plane configurations

**[📖 Kubernetes Components](https://kubernetes.io/docs/concepts/overview/components/)** - Cluster architecture overview
**[📖 Kubernetes Architecture](https://kubernetes.io/docs/concepts/architecture/)** - Detailed architecture documentation

#### 1.2 Kubernetes API and Objects

**Key Concepts:**
- Pod lifecycle and states (Pending, Running, Succeeded, Failed, Unknown)
- Deployments, ReplicaSets, and DaemonSets
- Services: ClusterIP, NodePort, LoadBalancer, ExternalName
- ConfigMaps and Secrets for configuration management
- Namespaces for resource scoping and isolation
- Labels, selectors, and annotations
- StatefulSets for stateful workloads

**[📖 Kubernetes Objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/)** - Understanding Kubernetes objects
**[📖 Workload Resources](https://kubernetes.io/docs/concepts/workloads/)** - Pods, Deployments, StatefulSets, etc.
**[📖 Services and Networking](https://kubernetes.io/docs/concepts/services-networking/)** - Service types and networking

#### 1.3 Storage and Networking

**Key Concepts:**
- Persistent Volumes (PV) and Persistent Volume Claims (PVC)
- StorageClasses and dynamic provisioning
- Container Network Interface (CNI) plugins
- Pod-to-pod networking model (flat network)
- DNS in Kubernetes (CoreDNS)
- Ingress resources and controllers

**[📖 Storage](https://kubernetes.io/docs/concepts/storage/)** - Kubernetes storage concepts
**[📖 Cluster Networking](https://kubernetes.io/docs/concepts/cluster-administration/networking/)** - Networking model

### Domain 2: Container Orchestration (22%)

#### 2.1 Container Fundamentals

**Key Concepts:**
- Container vs virtual machine architecture
- Container images, layers, and registries
- Container runtimes (containerd, CRI-O)
- OCI (Open Container Initiative) standards
- Dockerfile basics and multi-stage builds

**[📖 Containers Overview](https://kubernetes.io/docs/concepts/containers/)** - Container concepts in Kubernetes
**[📖 Container Runtimes](https://kubernetes.io/docs/setup/production-environment/container-runtimes/)** - Supported runtimes

#### 2.2 Orchestration Concepts

**Key Concepts:**
- Why container orchestration is needed (scaling, self-healing, load balancing)
- Scheduling and resource management
- Rolling updates and rollback strategies
- Horizontal Pod Autoscaler (HPA) and cluster autoscaling
- Health checks: liveness, readiness, and startup probes

**[📖 Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)** - Probes and lifecycle hooks
**[📖 Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)** - HPA configuration

### Domain 3: Cloud Native Architecture (16%)

#### 3.1 Cloud Native Principles

**Key Concepts:**
- 12-factor application methodology
- Microservices vs monolithic architecture
- Loosely coupled, scalable, resilient systems
- Declarative configuration and infrastructure as code
- Immutable infrastructure patterns

**[📖 CNCF Cloud Native Definition](https://github.com/cncf/toc/blob/main/DEFINITION.md)** - Official definition of cloud native
**[📖 12-Factor App](https://12factor.net/)** - Twelve-factor application methodology

#### 3.2 CNCF Ecosystem

**Key Concepts:**
- CNCF project maturity levels (Sandbox, Incubating, Graduated)
- Key graduated projects: Kubernetes, Prometheus, Envoy, CoreDNS, containerd, Fluentd
- Service mesh concepts (Istio, Linkerd)
- Serverless and event-driven architectures (Knative, CloudEvents)
- Cloud native storage solutions

**[📖 CNCF Projects](https://www.cncf.io/projects/)** - All CNCF projects by maturity level
**[📖 CNCF Trail Map](https://github.com/cncf/landscape/blob/master/README.md#trail-map)** - Recommended cloud native path

### Domain 4: Cloud Native Observability (8%)

#### 4.1 Observability Pillars

**Key Concepts:**
- Three pillars: metrics, logs, traces
- Prometheus for metrics collection and alerting
- Fluentd/Fluent Bit for log aggregation
- OpenTelemetry for distributed tracing
- Grafana for dashboarding and visualization
- Alerting and incident management

**[📖 Prometheus Overview](https://prometheus.io/docs/introduction/overview/)** - Prometheus monitoring system
**[📖 OpenTelemetry](https://opentelemetry.io/docs/)** - Observability framework
**[📖 Fluentd](https://www.fluentd.org/)** - Log aggregation

### Domain 5: Cloud Native Application Delivery (8%)

#### 5.1 Application Delivery Concepts

**Key Concepts:**
- GitOps principles and workflows
- ArgoCD and Flux for continuous delivery
- Helm charts for package management
- Kustomize for manifest customization
- CI/CD pipelines and deployment patterns (blue-green, canary)
- Infrastructure as Code (Terraform, Pulumi)

**[📖 Helm](https://helm.sh/docs/)** - Kubernetes package manager
**[📖 ArgoCD](https://argo-cd.readthedocs.io/)** - Declarative GitOps CD for Kubernetes
**[📖 Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/)** - Kubernetes manifest customization

## Quick Reference: Key Concepts

### Control Plane Components
| Component | Purpose |
|-----------|---------|
| kube-apiserver | Front end for the Kubernetes API |
| etcd | Consistent key-value store for cluster data |
| kube-scheduler | Assigns pods to nodes based on constraints |
| kube-controller-manager | Runs controller loops (Node, Deployment, etc.) |
| cloud-controller-manager | Cloud provider integrations |

### Worker Node Components
| Component | Purpose |
|-----------|---------|
| kubelet | Ensures containers are running in pods |
| kube-proxy | Manages network rules for Service abstraction |
| Container runtime | Runs containers (containerd, CRI-O) |

### Service Types
| Type | Description |
|------|-------------|
| ClusterIP | Internal-only cluster IP (default) |
| NodePort | Exposes on each node's IP at a static port |
| LoadBalancer | Provisions external load balancer |
| ExternalName | Maps to external DNS name via CNAME |

## Exam Tips

### MCQ Strategy
1. **Read carefully** - Pay attention to "which of the following" vs "which is NOT"
2. **Eliminate wrong answers** - Remove obviously incorrect options first
3. **Focus on the 46% domain** - Kubernetes Fundamentals is nearly half the exam
4. **Know the terminology** - Many questions test understanding of CNCF terms and concepts
5. **Understand relationships** - Know how components interact, not just what they do
6. **Flag and return** - Mark uncertain questions and come back after completing easier ones

### Common Pitfalls
- Confusing control plane components with worker node components
- Mixing up Service types and their use cases
- Not understanding the difference between Deployments and StatefulSets
- Confusing CNCF project maturity levels
- Not knowing which projects are CNCF graduated vs incubating

---

**Key Takeaway:** The KCNA is a conceptual exam - no hands-on. Focus on understanding the "why" behind cloud native technologies, how Kubernetes components work together, and the CNCF ecosystem. Kubernetes Fundamentals at 46% should receive the most study time.
