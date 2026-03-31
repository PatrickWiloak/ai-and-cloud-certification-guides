# Domain 3: Deployment (23%)

## Overview
This domain covers migrating workloads to the cloud, automating infrastructure provisioning, container technologies, and CI/CD practices. As the heaviest-weighted domain, it requires thorough study of migration strategies, IaC tools, container orchestration, and deployment automation.

## Migration Planning

**[📖 CompTIA Cloud+ Exam Objectives](https://www.comptia.org/certifications/cloud#examdetails)** - Official exam objectives for deployment domain

### Migration Assessment

**Discovery Phase:**
- Inventory all applications, dependencies, and infrastructure
- Document current architecture and data flows
- Identify application owners and stakeholders
- Assess application complexity and cloud readiness
- Map dependencies between applications and services

**Analysis Phase:**
- Evaluate each application for migration suitability
- Determine migration strategy per application (7 Rs)
- Estimate costs - current vs cloud
- Identify compliance and regulatory requirements
- Assess skill gaps and training needs

**Planning Phase:**
- Define migration waves and priorities
- Establish migration timeline and milestones
- Plan network connectivity (VPN, direct connect)
- Define testing and validation criteria
- Create rollback plans for each migration wave

### The 7 Rs of Migration

**Rehost (Lift-and-Shift):**
- Move applications as-is to cloud infrastructure (IaaS)
- Minimal changes - same OS, same configuration
- Fastest migration approach with lowest initial effort
- May not take advantage of cloud-native features
- Good for: Quick migration, legacy applications, hardware refresh

**Replatform (Lift-and-Reshape):**
- Minor optimizations during migration
- Use managed services where possible (managed DB, managed containers)
- Operating system or database version upgrade
- Moderate effort with better cloud optimization than rehost
- Good for: Database migrations to managed services, OS upgrades

**Refactor (Re-architect):**
- Redesign application for cloud-native architecture
- Break monoliths into microservices
- Implement serverless, containers, managed services
- Highest effort but greatest long-term benefits
- Good for: Strategic applications, long-term cloud investment

**Repurchase (Replace):**
- Replace existing application with SaaS equivalent
- Drop existing application, adopt commercial SaaS product
- Example: On-premises email to Microsoft 365, CRM to Salesforce
- Good for: Commodity applications with SaaS alternatives

**Retire (Decommission):**
- Identify applications that are no longer needed
- Reduce portfolio complexity and cost
- Safely decommission and archive data
- Good for: Redundant, unused, or replaced applications

**Retain (Keep):**
- Keep on-premises for now (not ready to migrate)
- Reasons: Compliance, technical debt, recent investment, dependencies
- Revisit in future migration waves
- Good for: Recently upgraded, deeply integrated, or regulated applications

**Relocate (Hypervisor-Level Migration):**
- Move to different cloud/region at the infrastructure level
- Example: VMware on-premises to VMware Cloud on AWS
- Minimal application changes
- Good for: Data center evacuation, provider migration

### Data Migration Strategies

**Online Migration:**
- Continuous replication over network
- Suitable for databases and file systems
- Tools: Database replication, file sync, storage gateway
- Minimal downtime with cutover window

**Offline Migration:**
- Physical data transfer devices
- Suitable for large datasets (terabytes to petabytes)
- Tools: AWS Snowball, Azure Data Box
- Required when network transfer would take too long

**Hybrid Migration:**
- Initial bulk transfer offline, then online sync for changes
- Combines speed of offline with currency of online
- Best for very large datasets with ongoing changes

### Migration Testing

**Validation Types:**
- **Functional testing** - Application works correctly in cloud
- **Performance testing** - Meets performance requirements
- **Security testing** - Security controls are effective
- **Integration testing** - Connections to other systems work
- **User acceptance testing (UAT)** - End users validate functionality
- **Failover testing** - DR and HA mechanisms work

## Automation and Infrastructure as Code

### IaC Concepts

**Declarative vs Imperative:**
- **Declarative** - Define desired end state, tool figures out how (Terraform, CloudFormation)
- **Imperative** - Define step-by-step instructions (scripts, Ansible playbooks partially)

**Key Principles:**
- **Idempotency** - Running the same code produces the same result
- **Version control** - Store infrastructure code in Git
- **Modularity** - Reusable components and modules
- **State management** - Track current infrastructure state
- **Immutable infrastructure** - Replace rather than modify

### Terraform

**[📖 Terraform Documentation](https://developer.hashicorp.com/terraform/docs)** - Complete Terraform reference

**Core Concepts:**
- **Providers** - Plugins for cloud platforms (AWS, Azure, GCP)
- **Resources** - Infrastructure components to create
- **Data sources** - Read existing infrastructure data
- **Variables** - Input parameters for configurations
- **Outputs** - Export values from configurations
- **Modules** - Reusable configuration packages

**Workflow:**
```
terraform init    - Initialize providers and backend
terraform plan    - Preview changes
terraform apply   - Execute changes
terraform destroy - Remove all managed resources
```

**State Management:**
- State file tracks current infrastructure
- Remote backends (S3, Azure Blob, Terraform Cloud) for team collaboration
- State locking prevents concurrent modifications
- State file contains sensitive data - must be secured

**Best Practices:**
- Use remote state with locking
- Use modules for reusable patterns
- Use workspaces or variable files for environments
- Pin provider versions
- Store code in version control

### CloudFormation (AWS)
- AWS-native IaC service
- JSON or YAML templates
- Stack-based resource management
- Drift detection for configuration compliance
- Change sets for previewing updates
- StackSets for multi-account/multi-region deployments

### ARM Templates / Bicep (Azure)
- Azure Resource Manager templates (JSON)
- Bicep - Domain-specific language that compiles to ARM
- Deployment scopes: resource group, subscription, management group
- Template specs for sharing and versioning

### Configuration Management Tools

**Ansible:**
- **[📖 Ansible Documentation](https://docs.ansible.com/)** - Complete Ansible reference
- Agentless - uses SSH/WinRM
- YAML playbooks for task definitions
- Idempotent modules for configuration
- Inventory management for target hosts
- Roles for reusable configuration sets
- Best for: Ad-hoc tasks, configuration, orchestration

**Puppet:**
- Agent-based architecture (pull model)
- Puppet DSL for resource definitions
- Puppet Forge for shared modules
- Strong enforcement of desired state
- Best for: Large-scale configuration management

**Chef:**
- Agent-based architecture (pull model)
- Ruby-based DSL (recipes and cookbooks)
- Chef Supermarket for shared cookbooks
- Test Kitchen for testing
- Best for: Complex configurations, developer-friendly

### IaC vs Configuration Management

| Aspect | IaC (Terraform) | Config Management (Ansible) |
|--------|-----------------|----------------------------|
| **Purpose** | Provision infrastructure | Configure systems |
| **Scope** | Create VMs, networks, storage | Install software, configure OS |
| **State** | Maintains state file | Typically stateless |
| **Approach** | Declarative | Procedural/declarative hybrid |
| **When** | Before systems exist | After systems are provisioned |

## Containers and Orchestration

### Docker

**[📖 Docker Documentation](https://docs.docker.com/)** - Complete Docker reference

**Core Concepts:**
- **Image** - Read-only template with application and dependencies
- **Container** - Running instance of an image
- **Dockerfile** - Build instructions for creating images
- **Registry** - Repository for storing and sharing images
- **Volume** - Persistent data storage for containers
- **Network** - Communication between containers

**Dockerfile Example:**
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
EXPOSE 8080
CMD ["python", "app.py"]
```

**Container Benefits:**
- Consistent environment across development, testing, production
- Lightweight compared to virtual machines
- Fast startup times (seconds vs minutes)
- Efficient resource utilization
- Portability across environments and cloud providers

**Container vs Virtual Machine:**

| Aspect | Container | Virtual Machine |
|--------|-----------|-----------------|
| **Isolation** | Process-level | Hardware-level |
| **OS** | Shares host kernel | Full OS per VM |
| **Size** | Megabytes | Gigabytes |
| **Startup** | Seconds | Minutes |
| **Density** | High (many per host) | Lower |
| **Use case** | Microservices, stateless | Legacy, different OS needs |

### Container Registries
- **Docker Hub** - Public registry (free and paid tiers)
- **Amazon ECR** - AWS managed container registry
- **Azure Container Registry** - Azure managed registry
- **Google Container Registry/Artifact Registry** - GCP managed registry
- **Private registries** - Self-hosted (Harbor, GitLab Registry)

### Kubernetes

**[📖 Kubernetes Documentation](https://kubernetes.io/docs/)** - Complete Kubernetes reference

**Core Components:**
- **Pod** - Smallest deployable unit, one or more containers
- **Service** - Stable network endpoint for accessing pods
- **Deployment** - Declarative updates for pods and replica sets
- **ReplicaSet** - Ensures specified number of pod replicas
- **Namespace** - Virtual cluster within a physical cluster
- **ConfigMap** - Non-sensitive configuration data
- **Secret** - Sensitive data (passwords, tokens, keys)
- **Ingress** - HTTP/HTTPS routing rules for external access

**Kubernetes Services:**
- **ClusterIP** - Internal cluster communication only
- **NodePort** - Expose on each node's IP at a static port
- **LoadBalancer** - Cloud provider load balancer
- **ExternalName** - Maps to external DNS name

**Scaling:**
- **Horizontal Pod Autoscaler (HPA)** - Scale pods based on metrics
- **Vertical Pod Autoscaler (VPA)** - Adjust pod resource requests
- **Cluster Autoscaler** - Add/remove nodes based on pod scheduling

**Health Checks:**
- **Liveness probe** - Is the container alive? (restart if not)
- **Readiness probe** - Is the container ready for traffic? (remove from service if not)
- **Startup probe** - Has the container started? (delay other probes)

### Managed Kubernetes Services
- **Amazon EKS** - AWS managed Kubernetes
- **Azure AKS** - Azure managed Kubernetes
- **Google GKE** - Google managed Kubernetes
- Reduces operational overhead of managing control plane
- Provider handles upgrades, patching, and HA for control plane

## CI/CD Pipelines

### Continuous Integration (CI)
- Developers frequently merge code to shared repository
- Automated build triggered on each merge
- Automated testing (unit, integration, security)
- Fast feedback on code quality and issues
- Tools: Jenkins, GitLab CI, GitHub Actions, CircleCI

### Continuous Delivery (CD)
- Automated deployment to staging/production after CI passes
- Every change is potentially releasable
- Manual approval gate before production (continuous delivery)
- Fully automated deployment to production (continuous deployment)
- Tools: ArgoCD, Spinnaker, AWS CodePipeline, Azure DevOps

### Pipeline Stages

```
Source -> Build -> Test -> Stage -> Approve -> Deploy
```

1. **Source** - Code committed to version control
2. **Build** - Compile code, build artifacts, create container images
3. **Test** - Unit tests, integration tests, security scans
4. **Stage** - Deploy to staging environment for validation
5. **Approve** - Manual approval gate (for continuous delivery)
6. **Deploy** - Deploy to production environment

### Deployment Strategies

**Rolling Update:**
- Gradually replace old instances with new
- Some instances run old version during transition
- No additional infrastructure cost
- Rollback by continuing the rolling update with old version

**Blue/Green Deployment:**
- Two identical environments (blue = current, green = new)
- Deploy to green, test, then switch traffic
- Instant rollback by switching back to blue
- Higher cost (duplicate infrastructure temporarily)

**Canary Deployment:**
- Deploy to small subset of users first (canary group)
- Monitor for errors, then gradually increase traffic
- Quick rollback by routing all traffic away from canary
- Lower risk than full deployment

**A/B Testing:**
- Route different user segments to different versions
- Compare metrics and user behavior
- Feature flags for controlling rollout
- Data-driven deployment decisions

### Artifact Management
- Build artifacts stored in repositories (Nexus, Artifactory, cloud-native)
- Container images in container registries
- Versioned artifacts for traceability
- Immutable artifacts - never modify, create new versions

## Version Control

### Git Fundamentals
- Distributed version control system
- Branching and merging for parallel development
- Pull requests/merge requests for code review
- Tags for release versioning

### Branching Strategies
- **Feature branching** - Branch per feature, merge when complete
- **Gitflow** - develop, feature, release, hotfix branches
- **Trunk-based development** - Short-lived branches, frequent merges to main
- **Environment branching** - Branch per environment (dev, staging, prod)

---

## Key Takeaways for the Exam

1. Know the 7 Rs of migration and when each is appropriate
2. Understand the difference between IaC (provision) and configuration management (configure)
3. Terraform is multi-cloud, CloudFormation is AWS-only, ARM/Bicep is Azure-only
4. Know Docker concepts: images, containers, Dockerfiles, registries
5. Know Kubernetes basics: pods, services, deployments, namespaces, scaling
6. Understand CI/CD pipeline stages and their purposes
7. Know deployment strategies: rolling, blue/green, canary, and their trade-offs
8. State management in IaC is critical - remote state with locking
