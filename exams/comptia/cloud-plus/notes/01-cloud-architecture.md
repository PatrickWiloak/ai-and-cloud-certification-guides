# Domain 1: Cloud Architecture (13%)

## Overview
This domain covers cloud deployment models, service models, design principles, and architectural concepts for building highly available, scalable, and resilient cloud solutions. While it carries the lowest weight, it forms the foundation for understanding all other domains.

## Cloud Deployment Models

**[📖 NIST SP 800-145 - Cloud Computing Definition](https://csrc.nist.gov/publications/detail/sp/800-145/final)** - Authoritative definitions of cloud deployment and service models

### Public Cloud
- Resources owned and operated by a third-party cloud provider
- Shared infrastructure across multiple tenants (multi-tenancy)
- Pay-as-you-go pricing model
- Provider manages hardware, networking, and virtualization
- Examples: AWS, Microsoft Azure, Google Cloud Platform

**Characteristics:**
- Virtually unlimited scalability
- No upfront capital expenditure
- Global availability and geographic distribution
- Shared security responsibility model
- Less control over infrastructure

**Best for:** Variable workloads, startups, web applications, development/testing

### Private Cloud
- Dedicated infrastructure for a single organization
- Can be on-premises or hosted by a third party
- Full control over hardware, networking, and security
- Higher cost but greater customization

**Types:**
- **On-premises private cloud** - Organization owns and manages everything
- **Hosted private cloud** - Third party hosts dedicated infrastructure
- **Virtual private cloud** - Logically isolated section within public cloud

**Best for:** Regulated industries, sensitive data, compliance requirements, legacy applications

### Hybrid Cloud
- Combination of public and private cloud environments
- Orchestration between environments for workload placement
- Secure connectivity between environments (VPN, dedicated connections)
- Data and applications can move between environments

**Key Concepts:**
- **Cloud bursting** - Overflow to public cloud during demand spikes
- **Data sovereignty** - Keep regulated data in private, use public for compute
- **Tiered architecture** - Different tiers in different environments
- **Unified management** - Single pane of glass for both environments

**Best for:** Organizations with mixed workload requirements, compliance with flexibility needs

### Multi-Cloud
- Services distributed across multiple cloud providers
- Avoids vendor lock-in and leverages best-of-breed services
- Increases complexity of management and integration
- Requires portable architectures and tooling

**Benefits:**
- Avoid vendor lock-in
- Best-of-breed service selection
- Geographic coverage and redundancy
- Negotiating leverage with providers

**Challenges:**
- Management complexity
- Data integration across providers
- Skill requirements across platforms
- Networking between providers

**Best for:** Large enterprises, regulatory requirements, risk mitigation

### Community Cloud
- Shared by organizations with common concerns (mission, security, compliance)
- Can be managed by member organizations or third party
- Costs shared among fewer organizations than public cloud

**Best for:** Government agencies, healthcare consortiums, research institutions

## Cloud Service Models

**[📖 NIST SP 800-146 - Cloud Computing Synopsis](https://csrc.nist.gov/publications/detail/sp/800-146/final)** - Detailed cloud computing overview and recommendations

### Infrastructure as a Service (IaaS)
**Provider manages:** Physical hardware, networking, virtualization
**Customer manages:** Operating system, middleware, runtime, applications, data

**Components:**
- Virtual machines and compute instances
- Virtual networks, subnets, and load balancers
- Block storage volumes and object storage
- Firewalls and security groups

**Examples:** AWS EC2, Azure Virtual Machines, Google Compute Engine

**Use cases:**
- Full control over operating system and software stack
- Lift-and-shift migration from on-premises
- Development and testing environments
- High-performance computing workloads

### Platform as a Service (PaaS)
**Provider manages:** IaaS + operating system, middleware, runtime
**Customer manages:** Applications, data

**Components:**
- Application hosting platforms
- Managed databases
- Development frameworks and tools
- Build and deployment services

**Examples:** AWS Elastic Beanstalk, Azure App Service, Google App Engine, Heroku

**Use cases:**
- Application development without infrastructure management
- Rapid prototyping and deployment
- Teams focused on code rather than operations
- Microservices and API development

### Software as a Service (SaaS)
**Provider manages:** Entire stack
**Customer manages:** Configuration, user access, data input

**Examples:** Microsoft 365, Salesforce, Google Workspace, Slack

**Use cases:**
- Standard business applications (email, CRM, collaboration)
- Quick deployment with minimal IT involvement
- Subscription-based software access
- Mobile and remote workforce tools

### Everything as a Service (XaaS)
**Function as a Service (FaaS):**
- Serverless compute - run functions without managing servers
- Event-driven execution model
- Pay only for execution time
- Examples: AWS Lambda, Azure Functions, Google Cloud Functions

**Database as a Service (DBaaS):**
- Managed database with automated backups, patching, scaling
- Customer controls schema, queries, and data
- Examples: AWS RDS, Azure SQL Database, Google Cloud SQL

**Container as a Service (CaaS):**
- Managed container orchestration platform
- Provider manages cluster infrastructure
- Examples: AWS ECS/EKS, Azure AKS, Google GKE

**Other XaaS models:**
- **Storage as a Service (STaaS)** - Object storage, file storage
- **Desktop as a Service (DaaS)** - Virtual desktop infrastructure
- **Security as a Service (SECaaS)** - Managed security services
- **Network as a Service (NaaS)** - Virtual networking

## Shared Responsibility Model

### Responsibility Boundaries by Service Model

```
                    IaaS        PaaS        SaaS
Data              Customer    Customer    Customer
Applications      Customer    Customer    Provider
Runtime           Customer    Provider    Provider
Middleware        Customer    Provider    Provider
Operating System  Customer    Provider    Provider
Virtualization    Provider    Provider    Provider
Servers           Provider    Provider    Provider
Storage           Provider    Provider    Provider
Networking        Provider    Provider    Provider
Physical Security Provider    Provider    Provider
```

### Key Principle
- The provider is always responsible for the **security OF the cloud** (infrastructure)
- The customer is always responsible for the **security IN the cloud** (data, access)
- The boundary shifts based on the service model

## Cloud Design Principles

### High Availability (HA)

**Goal:** Minimize downtime and ensure continuous operation

**Strategies:**
- **Redundancy** - Duplicate components at every layer
- **Geographic distribution** - Resources across multiple availability zones and regions
- **Load balancing** - Distribute traffic across healthy instances
- **Health monitoring** - Automated health checks with automatic failover
- **Clustering** - Active-active or active-passive configurations

**Availability Zones:**
- Physically separate data centers within a region
- Independent power, cooling, and networking
- Connected by low-latency, high-bandwidth links
- Deploy across multiple AZs for HA

### Scalability

**Vertical Scaling (Scale Up/Down):**
- Increase/decrease resources on existing instance (CPU, RAM, storage)
- Limited by maximum instance size
- May require downtime for resizing
- Simpler to implement

**Horizontal Scaling (Scale Out/In):**
- Add/remove instances to handle load
- Theoretically unlimited scaling
- Requires load balancing and stateless design
- More complex but more resilient

**Auto-Scaling:**
- Automatically adjust capacity based on demand
- Scale-out triggers: CPU threshold, queue depth, request count
- Scale-in triggers: Low utilization, schedule-based
- Cooldown periods to prevent rapid fluctuation
- Predictive scaling based on historical patterns

### Elasticity
- Ability to dynamically acquire and release resources
- Matches resource allocation to actual demand
- Eliminates over-provisioning and under-provisioning
- Core economic advantage of cloud computing

### Fault Tolerance
- System continues operating despite component failure
- No single point of failure (SPOF)
- Graceful degradation - reduced functionality rather than complete failure
- Self-healing - automatic detection and recovery from failures

### Loose Coupling
- Components interact through well-defined interfaces
- Services can be updated independently
- Use message queues, APIs, and event-driven patterns
- Reduces impact of individual component failures

**Patterns:**
- **Message queues** - Asynchronous communication between services
- **API gateways** - Centralized entry point with routing
- **Event-driven** - Services react to events rather than direct calls
- **Microservices** - Small, independent services with single responsibilities

### Design for Failure
- Assume components will fail and design accordingly
- Implement retry logic with exponential backoff
- Use circuit breaker patterns to prevent cascade failures
- Design idempotent operations for safe retries

## Disaster Recovery

**[📖 NIST SP 800-34 - Contingency Planning Guide](https://csrc.nist.gov/publications/detail/sp/800-34/rev-1/final)** - IT contingency planning guidance

### Key Metrics

**Recovery Time Objective (RTO):**
- Maximum acceptable downtime after a disaster
- Time from failure to full recovery
- Lower RTO = more expensive DR solution

**Recovery Point Objective (RPO):**
- Maximum acceptable data loss measured in time
- Time between last backup and disaster
- Lower RPO = more frequent backups/replication

### DR Strategies

**Backup and Restore:**
- Regular backups to separate location/region
- Restore infrastructure and data when needed
- Highest RTO (hours to days), lowest cost
- Suitable for non-critical workloads

**Pilot Light:**
- Core infrastructure components running in DR region
- Database replication active
- Compute resources provisioned but not running
- Scale up when disaster occurs (minutes to hours)

**Warm Standby:**
- Scaled-down version of production running in DR
- Can handle minimal traffic
- Scale up to full production capacity quickly (minutes)
- Balance of cost and recovery speed

**Hot Standby (Active-Active):**
- Full production environment in multiple regions
- Traffic distributed across regions
- Near-zero RTO and RPO
- Highest cost but best recovery capability

## Performance Optimization

### Caching Strategies
- **CDN caching** - Static content closer to users (edge locations)
- **Application caching** - Frequently accessed data in memory (Redis, Memcached)
- **Database caching** - Query result caching, read replicas
- **DNS caching** - Reduce DNS lookup latency

### Content Delivery Networks
- Distribute content to edge locations worldwide
- Reduce latency for geographically distributed users
- Offload origin server traffic
- Support for static and dynamic content acceleration

### Resource Placement
- Place resources close to users for low latency
- Use regions that match compliance requirements
- Consider data transfer costs between regions
- Use availability zones for HA within a region

## Cost Optimization Principles

### Right-Sizing
- Match resource allocation to actual workload needs
- Monitor utilization and adjust accordingly
- Use provider recommendations for instance sizing

### Pricing Models
- **On-demand** - Pay per use, no commitment (highest per-unit cost)
- **Reserved** - 1-3 year commitment for significant discount (up to 72%)
- **Spot/preemptible** - Unused capacity at deep discount (up to 90%)
- **Savings plans** - Flexible commitment-based discounts

### Cost Management
- Implement tagging for cost allocation
- Set budgets and alerts
- Regular cost reviews and optimization
- Use provider cost management tools

---

## Key Takeaways for the Exam

1. Know the five deployment models and when each is appropriate
2. Understand service model boundaries (who manages what)
3. The shared responsibility model shifts with the service model
4. HA and DR are different - HA prevents downtime, DR recovers from disaster
5. Know DR strategies and their cost/RTO trade-offs
6. Horizontal scaling is preferred for cloud-native design
7. Loose coupling and stateless design enable scalability
8. Cost optimization balances performance, availability, and spend
