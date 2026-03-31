# KCNA Study Strategy

## Study Approach

### Phase 1: Kubernetes Core (Weeks 1-2)
1. **Kubernetes Architecture**
   - Learn control plane and worker node components
   - Understand the API server as the central communication hub
   - Study etcd's role as the cluster state store
   - Learn how the scheduler and controller manager work together

2. **Kubernetes Objects and Workloads**
   - Pods, Deployments, ReplicaSets, DaemonSets, StatefulSets
   - Services and their types (ClusterIP, NodePort, LoadBalancer)
   - ConfigMaps, Secrets, and configuration management
   - Namespaces, labels, selectors, and annotations

3. **Storage and Networking**
   - Persistent Volumes and Persistent Volume Claims
   - StorageClasses and dynamic provisioning
   - CNI plugins and the flat networking model
   - Ingress resources and controllers

### Phase 2: Container Orchestration and Architecture (Weeks 2-3)
1. **Container Fundamentals**
   - Containers vs virtual machines
   - Container images, layers, and registries
   - Container runtimes (containerd, CRI-O)
   - OCI standards and specifications

2. **Orchestration Concepts**
   - Why orchestration is needed (scaling, self-healing, rolling updates)
   - Health checks: liveness, readiness, startup probes
   - Horizontal Pod Autoscaler (HPA)
   - Resource requests and limits

3. **Cloud Native Architecture**
   - 12-factor application methodology
   - Microservices patterns and trade-offs
   - Declarative configuration and immutable infrastructure
   - CNCF Cloud Native Definition

### Phase 3: Ecosystem and Exam Prep (Weeks 3-4)
1. **CNCF Ecosystem**
   - CNCF project maturity levels (Sandbox, Incubating, Graduated)
   - Key graduated projects and their purposes
   - Service mesh concepts (Istio, Linkerd)
   - Serverless concepts (Knative)

2. **Observability**
   - Three pillars: metrics, logs, traces
   - Prometheus for metrics
   - Fluentd/Fluent Bit for logs
   - OpenTelemetry for distributed tracing
   - Grafana for visualization

3. **Application Delivery**
   - GitOps principles (ArgoCD, Flux)
   - Helm for package management
   - Kustomize for manifest customization
   - CI/CD pipeline concepts

4. **Practice Exams**
   - Take practice tests and review weak areas
   - Focus on the highest-weighted domain (Kubernetes Fundamentals at 46%)
   - Review CNCF terminology and definitions

## Study Resources

### Primary Resources
- **[Kubernetes Documentation](https://kubernetes.io/docs/)** - Official documentation (read Concepts sections thoroughly)
- **[KCNA Exam Curriculum](https://github.com/cncf/curriculum)** - Official exam objectives
- **[CNCF Cloud Native Glossary](https://glossary.cncf.io/)** - Terminology reference
- **[CNCF Landscape](https://landscape.cncf.io/)** - Visual map of the ecosystem

### Supplementary Resources
- **[Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)** - Deep architecture understanding
- **[CNCF YouTube Channel](https://www.youtube.com/c/cloudnativefdn)** - Talks and presentations
- **[Prometheus Documentation](https://prometheus.io/docs/)** - Monitoring concepts
- **[Helm Documentation](https://helm.sh/docs/)** - Package management
- **[12-Factor App](https://12factor.net/)** - Application design principles

### Community and Forums
- **r/kubernetes** - Reddit community for discussions and tips
- **CNCF Slack** - Official community channels
- **KodeKloud Community** - Study groups and discussions

### Video Courses
1. **KodeKloud KCNA** - Comprehensive with visual explanations
2. **A Cloud Guru Kubernetes Essentials** - Good for fundamentals
3. **TechWorld with Nana** - Kubernetes crash course on YouTube
4. **freeCodeCamp Kubernetes Course** - Free comprehensive introduction

## Exam Tactics

### Time Management (90 minutes, 60 questions)
- Average 1.5 minutes per question
- Answer confident questions first (aim for under 1 minute each)
- Flag uncertain questions for review
- Reserve 10-15 minutes at the end for flagged questions
- Do not spend more than 2 minutes on any single question in the first pass

### Question Strategy
1. **Read the full question** before looking at answer choices
2. **Eliminate obviously wrong answers** to improve your odds
3. **Look for keywords** - "best," "most," "primary," "NOT" change the meaning significantly
4. **Be wary of absolute statements** - answers with "always" or "never" are often incorrect
5. **Choose the most specific correct answer** when multiple options seem right
6. **Trust your first instinct** unless you have a clear reason to change your answer

### Domain Prioritization
- **Kubernetes Fundamentals (46%)** - Spend the most time here. This is nearly half the exam
- **Container Orchestration (22%)** - Second priority, builds on fundamentals
- **Cloud Native Architecture (16%)** - Understand principles and the CNCF ecosystem
- **Observability (8%)** - Know the three pillars and key tools
- **Application Delivery (8%)** - Understand GitOps, Helm, and CI/CD concepts

## Common Pitfalls

### Study Mistakes
- **Going too deep on hands-on** - This is a knowledge exam, not performance-based. Hands-on experience helps understanding, but do not spend all your time in a terminal
- **Ignoring the CNCF ecosystem** - Questions cover the broader cloud native landscape, not just Kubernetes
- **Skipping observability and delivery** - Even though they are only 8% each, that is 16% combined and easy points if you study them
- **Not reviewing CNCF terminology** - Many questions test your understanding of specific terms

### Content Mistakes
- Confusing etcd with the API server's role
- Not knowing which components run on control plane vs worker nodes
- Mixing up Deployment vs StatefulSet use cases
- Confusing CNCF project maturity levels (Sandbox vs Incubating vs Graduated)
- Not understanding when to use each Service type
- Thinking containers are lightweight VMs (they share the host kernel)

## Progress Tracking

### Self-Assessment Questions
After each study phase, verify you can answer these without references:

**Phase 1:**
- Can I name all control plane and worker node components and their roles?
- Do I understand the full pod lifecycle?
- Can I explain each Service type and when to use it?
- Do I know the difference between PV, PVC, and StorageClass?

**Phase 2:**
- Can I explain containers vs VMs and why orchestration is needed?
- Do I understand the 12-factor methodology?
- Can I describe what makes an application "cloud native"?
- Do I know the difference between liveness, readiness, and startup probes?

**Phase 3:**
- Can I name key CNCF graduated projects and their purposes?
- Do I understand the three pillars of observability?
- Can I explain GitOps principles and key tools?
- Am I scoring 80%+ on practice exams?

### Readiness Indicators
You are ready for the exam when:
- [ ] You can explain all Kubernetes components from memory
- [ ] You understand the CNCF ecosystem and project maturity levels
- [ ] You score 80%+ on practice exams consistently
- [ ] You can define all key cloud native terms
- [ ] You understand relationships between components, not just definitions
