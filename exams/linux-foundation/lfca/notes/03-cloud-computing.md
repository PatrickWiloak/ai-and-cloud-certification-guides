# Domain 3: Cloud Computing Fundamentals (20%)

## Overview
This domain covers cloud service models, deployment models, virtualization, containers, and serverless computing. As one of the three highest-weighted domains, understand the conceptual differences between cloud models and technologies.

## Cloud Service Models

**[📖 NIST SP 800-145 - Cloud Computing Definition](https://csrc.nist.gov/publications/detail/sp/800-145/final)** - Authoritative cloud definitions

### IaaS (Infrastructure as a Service)
- **Provider manages:** Physical hardware, networking, virtualization
- **Customer manages:** Operating system, middleware, runtime, applications, data
- **You get:** Virtual machines, storage, networks
- **Examples:** AWS EC2, Azure Virtual Machines, Google Compute Engine
- **Best for:** Full control over infrastructure, lift-and-shift migrations

### PaaS (Platform as a Service)
- **Provider manages:** IaaS + operating system, middleware, runtime
- **Customer manages:** Applications and data only
- **You get:** A platform to deploy your code
- **Examples:** Heroku, AWS Elastic Beanstalk, Google App Engine, Azure App Service
- **Best for:** Developers who want to focus on code, not infrastructure

### SaaS (Software as a Service)
- **Provider manages:** Everything (entire application stack)
- **Customer manages:** Configuration and user access
- **You get:** Ready-to-use software
- **Examples:** Gmail, Salesforce, Microsoft 365, Slack, Zoom
- **Best for:** Standard business applications with minimal customization

### FaaS (Function as a Service) / Serverless
- **Provider manages:** Everything except your function code
- **Customer manages:** Function logic only
- **You get:** Event-driven code execution
- **Examples:** AWS Lambda, Azure Functions, Google Cloud Functions
- **Best for:** Event-driven tasks, APIs, short-running processes

### Shared Responsibility Model

```
                    IaaS        PaaS        SaaS
Data              Customer    Customer    Customer
Applications      Customer    Customer    Provider
Runtime           Customer    Provider    Provider
Middleware        Customer    Provider    Provider
Operating System  Customer    Provider    Provider
Virtualization    Provider    Provider    Provider
Hardware          Provider    Provider    Provider
```

**Key concept:** As you move from IaaS to SaaS, the provider manages more and you manage less.

## Cloud Deployment Models

### Public Cloud
- Resources shared across multiple organizations (multi-tenant)
- Managed by a cloud provider (AWS, Azure, GCP)
- Pay-as-you-go pricing
- Virtually unlimited scalability
- **Best for:** Variable workloads, cost optimization, rapid scaling

### Private Cloud
- Dedicated infrastructure for a single organization
- Can be on-premises or hosted by a provider
- Full control over hardware and security
- Higher cost but greater customization
- **Best for:** Regulated industries, sensitive data, compliance requirements

### Hybrid Cloud
- Combination of public and private cloud
- Workloads can move between environments
- Secure connectivity between environments
- **Best for:** Organizations needing both compliance and scalability

### Multi-Cloud
- Using services from multiple cloud providers
- Avoids vendor lock-in
- Leverages best-of-breed services from each provider
- More complex to manage
- **Best for:** Large enterprises, risk diversification

## Virtualization

### Virtual Machines

**What is a VM?**
- Software emulation of a physical computer
- Runs its own complete operating system
- Created and managed by a hypervisor
- Provides strong isolation between workloads

**Hypervisor Types:**
| Type | Description | Examples |
|------|-------------|---------|
| **Type 1 (Bare-metal)** | Runs directly on hardware | VMware ESXi, KVM, Hyper-V |
| **Type 2 (Hosted)** | Runs on top of an OS | VirtualBox, VMware Workstation |

**VM Characteristics:**
- Full OS per VM (gigabytes of disk)
- Strong isolation (separate kernel per VM)
- Boot time: minutes
- Higher resource overhead
- Can run any OS (Linux VM on Windows host, etc.)

### Containers

**[📖 Docker Getting Started](https://docs.docker.com/get-started/)** - Container fundamentals

**What is a Container?**
- Lightweight, isolated process running on the host OS
- Shares the host kernel (not a full OS)
- Packages application with all its dependencies
- Runs consistently across environments

**Docker Basics:**
- **Image** - Read-only template (like a VM snapshot)
- **Container** - Running instance of an image
- **Dockerfile** - Instructions to build an image
- **Registry** - Repository for storing images (Docker Hub)

**Container Commands:**
```bash
docker pull image              # download image
docker run image               # run container
docker ps                      # list running containers
docker stop container_id       # stop container
docker images                  # list downloaded images
docker build -t name .         # build image from Dockerfile
```

### VM vs Container Comparison

| Feature | Virtual Machine | Container |
|---------|----------------|-----------|
| **Isolation** | Full OS, separate kernel | Process-level, shared kernel |
| **Size** | Gigabytes | Megabytes |
| **Boot time** | Minutes | Seconds |
| **Resource overhead** | High | Low |
| **Density** | Fewer per host | Many per host |
| **OS flexibility** | Any OS | Same kernel as host |
| **Portability** | VM images (large) | Container images (small) |
| **Use case** | Different OS needs, legacy apps | Microservices, modern apps |

## Container Orchestration

**[📖 Kubernetes Concepts](https://kubernetes.io/docs/concepts/)** - Kubernetes basics

### Kubernetes (K8s)
- Open-source container orchestration platform
- Automates deployment, scaling, and management of containers
- Originally developed by Google, now maintained by CNCF

**Key Concepts:**
| Concept | Description |
|---------|-------------|
| **Pod** | Smallest unit - one or more containers |
| **Service** | Stable network endpoint for pods |
| **Deployment** | Manages pod replicas and updates |
| **Namespace** | Virtual cluster for resource isolation |
| **Node** | Physical or virtual machine in the cluster |
| **Cluster** | Set of nodes running containerized applications |

### Managed Kubernetes Services
- **Amazon EKS** - AWS managed Kubernetes
- **Azure AKS** - Azure managed Kubernetes
- **Google GKE** - Google managed Kubernetes

## Cloud Provider Overview

### Major Cloud Providers

| Provider | Key Services | Market Position |
|----------|-------------|-----------------|
| **AWS** | EC2, S3, Lambda, RDS | Largest market share |
| **Azure** | VMs, Blob Storage, Functions | Strong enterprise/hybrid |
| **GCP** | GCE, Cloud Storage, BigQuery | Strong in data/ML |

### Common Cloud Services (by category)

| Category | AWS | Azure | GCP |
|----------|-----|-------|-----|
| **Compute** | EC2 | Virtual Machines | Compute Engine |
| **Serverless** | Lambda | Functions | Cloud Functions |
| **Object Storage** | S3 | Blob Storage | Cloud Storage |
| **Database** | RDS | SQL Database | Cloud SQL |
| **Containers** | EKS/ECS | AKS | GKE |
| **Networking** | VPC | VNet | VPC |

## Cloud Concepts

### Scalability and Elasticity
- **Scalability** - Ability to handle increased load
  - **Vertical (scale up)** - Add more resources to existing instance
  - **Horizontal (scale out)** - Add more instances
- **Elasticity** - Automatically scale based on demand
  - Scale out during peak, scale in during low usage
  - Core economic advantage of cloud

### High Availability
- System remains accessible despite failures
- Achieved through redundancy across availability zones
- Load balancing distributes traffic
- Automated failover for component failures

### Cloud Storage Types
| Type | Description | Example |
|------|-------------|---------|
| **Object** | Unstructured data, HTTP access | S3, Blob Storage |
| **Block** | Low-latency, attached to VMs | EBS, Azure Disks |
| **File** | Shared filesystem (NFS/SMB) | EFS, Azure Files |

### Cloud Pricing Models
| Model | Description | Best For |
|-------|-------------|----------|
| **On-demand** | Pay per use, no commitment | Variable workloads |
| **Reserved** | 1-3 year commitment, lower price | Steady-state workloads |
| **Spot/Preemptible** | Unused capacity, deep discount | Fault-tolerant batch jobs |

---

## Key Takeaways for the Exam

1. Know the three main service models: IaaS (servers), PaaS (platform), SaaS (software)
2. Shared responsibility shifts with service model - SaaS = provider manages most
3. Containers share the host kernel; VMs each have their own OS
4. Docker is for creating containers; Kubernetes is for orchestrating them
5. Public cloud = shared, Private = dedicated, Hybrid = mix, Multi = multiple providers
6. Type 1 hypervisor runs on hardware; Type 2 runs on an OS
7. Horizontal scaling (add instances) vs vertical scaling (bigger instance)
8. Know the major cloud providers and their equivalent services
