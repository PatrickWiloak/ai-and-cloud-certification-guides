# KCNA Study Plan

## 4-Week Knowledge-Based Study Schedule

### Week 1: Kubernetes Fundamentals (Core Focus)

#### Day 1-2: Cluster Architecture
- [ ] Study control plane components (API server, etcd, scheduler, controller manager)
- [ ] Study worker node components (kubelet, kube-proxy, container runtime)
- [ ] Understand the communication flow between components
- [ ] Draw the architecture diagram from memory
- [ ] Review Notes: `notes/01-kubernetes-fundamentals.md`

#### Day 3-4: Kubernetes Objects and Workloads
- [ ] Study Pods, Deployments, ReplicaSets, DaemonSets
- [ ] Understand StatefulSets and when to use them vs Deployments
- [ ] Learn about Jobs and CronJobs
- [ ] Study the pod lifecycle and states
- [ ] Understand labels, selectors, and annotations

#### Day 5-6: Services and Networking
- [ ] Study all Service types (ClusterIP, NodePort, LoadBalancer, ExternalName)
- [ ] Understand Kubernetes networking model (flat network, CNI)
- [ ] Learn about Ingress resources and controllers
- [ ] Study DNS in Kubernetes (CoreDNS)
- [ ] Review Notes: `notes/02-container-orchestration.md`

#### Day 7: Week 1 Review
- [ ] Take a practice quiz on Kubernetes fundamentals
- [ ] Review any weak areas from the quiz
- [ ] Re-draw the architecture diagram and explain each component

### Week 2: Containers and Orchestration

#### Day 8-9: Container Fundamentals
- [ ] Study containers vs virtual machines (key differences)
- [ ] Understand container images, layers, and registries
- [ ] Learn about container runtimes (containerd, CRI-O)
- [ ] Study OCI standards and specifications
- [ ] Understand Dockerfile basics and image building

#### Day 10-11: Orchestration and Scheduling
- [ ] Study why container orchestration is needed
- [ ] Learn about scheduling constraints and node affinity
- [ ] Understand resource requests and limits
- [ ] Study Horizontal Pod Autoscaler (HPA)
- [ ] Learn about rolling updates and rollback strategies

#### Day 12-13: Storage Concepts
- [ ] Study Persistent Volumes (PV) and Persistent Volume Claims (PVC)
- [ ] Understand StorageClasses and dynamic provisioning
- [ ] Learn about volume types (emptyDir, hostPath, configMap, secret)
- [ ] Study access modes (ReadWriteOnce, ReadOnlyMany, ReadWriteMany)

#### Day 14: Week 2 Review
- [ ] Take a practice quiz covering containers and orchestration
- [ ] Review the relationship between orchestration concepts
- [ ] Identify any gaps in understanding

### Week 3: Cloud Native Ecosystem

#### Day 15-16: Cloud Native Architecture
- [ ] Study the CNCF Cloud Native Definition
- [ ] Learn the 12-factor application methodology
- [ ] Understand microservices vs monolithic architecture
- [ ] Study declarative configuration and immutable infrastructure
- [ ] Review Notes: `notes/03-cloud-native-architecture.md`

#### Day 17-18: CNCF Projects and Ecosystem
- [ ] Study CNCF project maturity levels (Sandbox, Incubating, Graduated)
- [ ] Learn key graduated projects and their purposes
- [ ] Explore the CNCF Landscape
- [ ] Understand service mesh concepts (Istio, Linkerd)
- [ ] Study serverless concepts (Knative, CloudEvents)

#### Day 19-20: Observability
- [ ] Study the three pillars of observability (metrics, logs, traces)
- [ ] Learn Prometheus architecture and concepts
- [ ] Understand Fluentd/Fluent Bit for log aggregation
- [ ] Study OpenTelemetry and Jaeger for distributed tracing
- [ ] Learn Grafana dashboarding basics
- [ ] Review Notes: `notes/04-observability-and-delivery.md`

#### Day 21: Week 3 Review
- [ ] Take a practice quiz on cloud native architecture and ecosystem
- [ ] Review CNCF terminology using the glossary
- [ ] Map CNCF tools to the three pillars of observability

### Week 4: Application Delivery and Exam Prep

#### Day 22-23: Application Delivery
- [ ] Study GitOps principles and workflows
- [ ] Learn ArgoCD and Flux concepts
- [ ] Understand Helm charts and package management
- [ ] Study Kustomize for manifest customization
- [ ] Learn CI/CD pipeline concepts and deployment strategies

#### Day 24-25: Comprehensive Review
- [ ] Review all four domain areas systematically
- [ ] Focus extra time on Kubernetes Fundamentals (46% of exam)
- [ ] Create flashcards for key terms and definitions
- [ ] Review all notes files

#### Day 26-27: Practice Exams
- [ ] Take a full-length practice exam (timed, 90 minutes)
- [ ] Review all incorrect answers and understand why
- [ ] Identify weak areas and do targeted review
- [ ] Take a second practice exam focusing on improvement

#### Day 28: Pre-Exam Preparation
- [ ] Light review of key concepts and terminology
- [ ] Review CNCF glossary one more time
- [ ] Verify exam environment and system requirements
- [ ] Rest and mental preparation

## Daily Study Routine (1-2 hours/day)

### Recommended Schedule
1. **30 minutes**: Read documentation and study materials
2. **30 minutes**: Watch video content or read blog posts
3. **30 minutes**: Practice questions and self-assessment

### Weekend Extended Sessions (3-4 hours)
1. **1 hour**: Deep dive into a complex topic
2. **1 hour**: Practice exams and review
3. **1-2 hours**: Hands-on exploration (optional but helpful for understanding)

## Study Resources

### Quick Links
- **[KCNA Exam Page](https://training.linuxfoundation.org/certification/kubernetes-cloud-native-associate/)** - Registration
- **[Kubernetes Docs](https://kubernetes.io/docs/)** - Official documentation
- **[CNCF Landscape](https://landscape.cncf.io/)** - Cloud native ecosystem map
- **[CNCF Glossary](https://glossary.cncf.io/)** - Terminology reference

### Practice Platforms
- **Killer Shell KCNA** - Practice exam simulator
- **KodeKloud KCNA** - Course with practice tests
- **Udemy KCNA courses** - Multiple options with practice exams
- **YouTube** - Free KCNA preparation content

---

## Final Exam Checklist

### One Week Before
- [ ] Scoring 80%+ consistently on practice exams
- [ ] All domain areas reviewed
- [ ] Weak areas addressed with additional study
- [ ] CNCF terminology memorized

### Day Before Exam
- [ ] Light review of key concepts
- [ ] Test exam environment (webcam, microphone, browser)
- [ ] Prepare workspace per PSI requirements
- [ ] Get adequate rest

### Exam Day
- [ ] Log in 15 minutes early for environment setup
- [ ] Read each question fully before answering
- [ ] Eliminate obviously wrong answers first
- [ ] Flag uncertain questions and return later
- [ ] Do not change answers unless you have a clear reason
- [ ] Use the full 90 minutes - review flagged questions at the end
