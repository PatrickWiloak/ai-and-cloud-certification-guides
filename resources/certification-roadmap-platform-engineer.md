# Certification Roadmap - Platform Engineer

A structured certification path for platform engineers responsible for building and maintaining internal developer platforms, infrastructure automation, and deployment systems.

---

## Table of Contents

- [Role Definition](#role-definition)
- [Recommended Certification Path](#recommended-certification-path)
- [Skills Roadmap](#skills-roadmap)
- [Career Progression and Salary Ranges](#career-progression-and-salary-ranges)
- [Hands-On Projects to Build](#hands-on-projects-to-build)
- [Learning Resources](#learning-resources)

---

## Role Definition

Platform engineers design, build, and maintain the internal platforms that development teams use to build, deploy, and operate applications. The role bridges the gap between traditional infrastructure/operations and software development.

### Core Responsibilities

- Build and maintain Internal Developer Platforms (IDPs)
- Design CI/CD pipelines and deployment workflows
- Manage Kubernetes clusters and container orchestration
- Implement Infrastructure as Code for all environments
- Create self-service capabilities for development teams
- Establish observability and monitoring standards
- Enforce security policies through automation
- Define golden paths and platform abstractions

### Key Differentiators from DevOps

- Focuses on building platforms as products for internal teams
- Emphasizes developer experience and self-service
- Treats infrastructure capabilities as APIs
- Applies product management thinking to internal tooling

---

## Recommended Certification Path

### Phase 1 - Foundations (0-6 months)

**Linux Foundation Certified IT Associate (LFCA)**
- Linux fundamentals, networking basics, cloud concepts
- Good starting point for those new to infrastructure
- Cost: ~$395
- Prep time: 4-6 weeks
- https://training.linuxfoundation.org/certification/certified-it-associate/

**CompTIA Cloud+ (CV0-004)**
- Vendor-neutral cloud concepts, architecture, security
- Covers multi-cloud fundamentals
- Cost: ~$369
- Prep time: 6-8 weeks
- https://www.comptia.org/certifications/cloud

### Phase 2 - Container Orchestration (6-12 months)

**Certified Kubernetes Administrator (CKA)**
- Cluster installation, configuration, and management
- Networking, storage, security, troubleshooting
- Performance-based exam (hands-on)
- Cost: ~$395
- Prep time: 8-12 weeks
- https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/

### Phase 3 - Infrastructure as Code (12-18 months)

**HashiCorp Terraform Associate (003)**
- Terraform workflow, state management, modules
- Provider configuration and HCL syntax
- Cost: ~$70.50
- Prep time: 4-6 weeks
- https://developer.hashicorp.com/terraform/tutorials/certification-003/associate-study-003

### Phase 4 - Cloud Provider (18-24 months)

Choose one based on your organization's primary cloud:

**AWS Solutions Architect Associate (SAA-C03)**
- Broad AWS service knowledge
- Architecture best practices
- Cost: ~$150
- https://aws.amazon.com/certification/certified-solutions-architect-associate/

**OR Azure Administrator Associate (AZ-104)**
- Azure resource management
- Identity, networking, compute, storage
- Cost: ~$165
- https://learn.microsoft.com/en-us/credentials/certifications/azure-administrator/

**OR Google Cloud Professional Cloud Architect**
- GCP architecture and design
- Migration and optimization
- Cost: ~$200
- https://cloud.google.com/learn/certification/cloud-architect

### Phase 5 - Security (24-30 months)

**Certified Kubernetes Security Specialist (CKS)**
- Cluster hardening, system hardening
- Supply chain security, runtime security
- Requires CKA as prerequisite
- Cost: ~$395
- Prep time: 6-8 weeks
- https://training.linuxfoundation.org/certification/certified-kubernetes-security-specialist/

### Phase 6 - GitOps and Advanced (30-36 months)

**Argo Project Associate (APA)**
- GitOps principles and Argo CD
- Progressive delivery with Argo Rollouts
- Cost: ~$250
- https://training.linuxfoundation.org/certification/argo-project-associate-apa/

**Prometheus Certified Associate (PCA)**
- Monitoring, alerting, PromQL
- Cloud-native observability
- Cost: ~$250
- https://training.linuxfoundation.org/certification/prometheus-certified-associate/

---

## Skills Roadmap

### Linux and OS Fundamentals
- Command line proficiency (bash scripting)
- File systems, permissions, processes
- Networking (TCP/IP, DNS, HTTP, TLS)
- systemd, package management
- Performance monitoring and tuning

### Containers
- Docker/OCI container building and management
- Image optimization and multi-stage builds
- Container registries (ECR, ACR, Artifact Registry, Harbor)
- Container security scanning
- Podman and containerd

### Kubernetes
- Cluster architecture and components
- Workload management (Deployments, StatefulSets, DaemonSets, Jobs)
- Networking (Services, Ingress, NetworkPolicies, CNI)
- Storage (PV, PVC, StorageClasses, CSI)
- RBAC and security contexts
- Helm chart development
- Custom Resource Definitions and Operators

### Infrastructure as Code
- Terraform (modules, state, workspaces, providers)
- Pulumi or Crossplane as alternatives
- Configuration management (Ansible)
- Policy as Code (OPA/Gatekeeper, Kyverno, Sentinel)

### CI/CD
- GitHub Actions, GitLab CI, or Jenkins
- Build systems (Gradle, Maven, npm)
- Artifact management (Artifactory, Nexus)
- GitOps (Argo CD, Flux)
- Progressive delivery (canary, blue-green)
- Feature flags

### Observability
- Metrics (Prometheus, Grafana, Datadog)
- Logging (ELK/EFK stack, Loki, CloudWatch)
- Tracing (Jaeger, Tempo, X-Ray)
- Alerting and on-call (PagerDuty, OpsGenie)
- SLIs, SLOs, SLAs, error budgets

### Security
- Secret management (Vault, AWS Secrets Manager, SOPS)
- Network security and zero trust
- Supply chain security (Sigstore, Cosign)
- Vulnerability scanning (Trivy, Snyk)
- Identity and access management

---

## Career Progression and Salary Ranges

Salary ranges are approximate for the US market (2025) and vary by location, company size, and industry.

### Junior Platform Engineer (0-2 years)
- Salary: $85,000 - $120,000
- Focus: Learning tools, following established patterns
- Certifications: LFCA, Cloud+, one cloud associate cert

### Platform Engineer (2-5 years)
- Salary: $120,000 - $170,000
- Focus: Building platform components, automation
- Certifications: CKA, Terraform Associate, cloud cert

### Senior Platform Engineer (5-8 years)
- Salary: $160,000 - $220,000
- Focus: Platform architecture, mentoring, cross-team initiatives
- Certifications: CKS, multiple cloud certs, GitOps certs

### Staff/Principal Platform Engineer (8+ years)
- Salary: $200,000 - $300,000+
- Focus: Platform strategy, organizational impact, technical leadership
- Certifications: Advanced certs, thought leadership

---

## Hands-On Projects to Build

### Project 1 - Internal Developer Platform (Beginner)
- Set up a Kubernetes cluster (EKS/AKS/GKE or kind/k3s)
- Deploy Argo CD for GitOps
- Create a golden path template for deploying microservices
- Add Prometheus and Grafana for monitoring

### Project 2 - CI/CD Pipeline Factory (Intermediate)
- Build reusable CI/CD pipeline templates (GitHub Actions or GitLab CI)
- Include build, test, security scan, and deploy stages
- Create a self-service mechanism for teams to adopt pipelines
- Implement progressive delivery with canary deployments

### Project 3 - Infrastructure Platform (Intermediate)
- Build Terraform modules for standard infrastructure patterns
- Implement remote state with locking
- Add policy checks with OPA or Sentinel
- Create a self-service Terraform workflow via Atlantis or Spacelift

### Project 4 - Developer Portal (Advanced)
- Deploy Backstage as a developer portal
- Create software catalog entries and templates
- Integrate with CI/CD, monitoring, and documentation
- Build custom plugins for your platform

### Project 5 - Multi-Environment Platform (Advanced)
- Build a multi-cluster Kubernetes platform
- Implement fleet management across environments
- Add cross-cluster observability
- Implement disaster recovery and failover

---

## Learning Resources

### Books
- "Team Topologies" by Matthew Skelton and Manuel Pais
- "Platform Engineering on Kubernetes" by Mauricio Salatino
- "Kubernetes in Action" by Marko Luksa
- "Infrastructure as Code" by Kief Morris

### Online Resources
- Platform Engineering Community: https://platformengineering.org/
- CNCF Landscape: https://landscape.cncf.io/
- Kubernetes Documentation: https://kubernetes.io/docs/
- Terraform Tutorials: https://developer.hashicorp.com/terraform/tutorials
- The New Stack: https://thenewstack.io/

### Practice Environments
- Killercoda (interactive scenarios): https://killercoda.com/
- KodeKloud (hands-on labs): https://kodekloud.com/
- A Cloud Guru (cloud labs): https://acloudguru.com/
- Play with Kubernetes: https://labs.play-with-k8s.com/
