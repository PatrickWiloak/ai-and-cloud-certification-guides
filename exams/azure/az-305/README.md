# Azure AZ-305: Designing Microsoft Azure Infrastructure Solutions

The AZ-305 certification validates skills in designing cloud and hybrid solutions that run on Microsoft Azure, including compute, network, storage, monitoring, and security.

## 📋 Quick Links

- [**Fact Sheet**](fact-sheet.md) - Exam logistics and objectives
- [**Practice Plan**](practice-plan.md) - Structured study schedule

## 📚 Study Materials

### Core Notes
- [Compute Containers](notes/compute-containers.md)
- [Databases](notes/databases.md)
- [Networking](notes/networking.md)
- [Security IAM](notes/security-iam.md)
- [Storage](notes/storage.md)
## 🎯 Exam Focus Areas

The AZ-305 exam measures ability to accomplish:

1. **Design Identity, Governance, and Monitoring Solutions** (25-30%)
   - Design governance solutions
   - Design authentication and authorization solutions
   - Design monitoring and logging solutions

2. **Design Data Storage Solutions** (25-30%)
   - Design data storage solutions for relational data
   - Design data storage solutions for semi-structured and unstructured data
   - Design data integration solutions

3. **Design Business Continuity Solutions** (10-15%)
   - Design backup and disaster recovery solutions
   - Design high availability solutions

4. **Design Infrastructure Solutions** (25-30%)
   - Design compute solutions
   - Design network solutions
   - Design migration solutions

## 🎓 Prerequisites & Skills

### Required Knowledge
- **Azure Fundamentals**: AZ-900 or equivalent knowledge
- **Azure Administrator**: AZ-104 experience recommended
- **Enterprise Experience**: Understanding of business requirements
- **Networking**: TCP/IP, DNS, VPN, routing concepts
- **Security**: Identity management, encryption, compliance

### Technical Skills
- Design solutions that meet business and technical requirements
- Understand Azure service capabilities and limitations
- Plan for cost optimization and resource governance
- Design for security, compliance, and disaster recovery
- Evaluate trade-offs between services and design options

## 🌟 Azure Service Coverage

### Identity and Governance
- **Azure Active Directory**: B2B, B2C, Conditional Access
- **Managed Identities**: System-assigned, User-assigned
- **Azure Policy**: Built-in and custom policies
- **Resource Locks**: CanNotDelete, ReadOnly
- **Management Groups**: Organizational hierarchy
- **RBAC**: Built-in and custom roles
- **Privileged Identity Management**: Just-in-time access

### Compute Solutions
- **Virtual Machines**: Availability sets, zones, scale sets
- **Azure App Service**: Plans, deployment slots, authentication
- **Azure Functions**: Consumption, Premium, Dedicated plans
- **Container Instances**: Serverless containers
- **Azure Kubernetes Service**: Node pools, scaling, monitoring
- **Azure Batch**: Large-scale parallel workloads
- **Virtual Machine Scale Sets**: Auto-scaling, updates

### Storage Solutions
- **Azure Storage Accounts**: Performance tiers, replication
- **Blob Storage**: Access tiers, lifecycle management
- **Azure Files**: SMB and NFS, File Sync
- **Azure NetApp Files**: Enterprise file shares
- **Managed Disks**: Standard, Premium, Ultra
- **Data Lake Storage Gen2**: Hierarchical namespace
- **Azure Archive Storage**: Long-term retention

### Database Solutions
- **Azure SQL Database**: Single database, elastic pools, hyperscale
- **Azure SQL Managed Instance**: Compatibility, VNet integration
- **Cosmos DB**: Multi-model, global distribution, consistency levels
- **Azure Database for PostgreSQL**: Single server, flexible server
- **Azure Database for MySQL**: Single server, flexible server
- **Azure Synapse Analytics**: Dedicated pools, serverless pools
- **Azure Cache for Redis**: Clustering, persistence, geo-replication

### Networking Solutions
- **Virtual Networks**: Subnets, NSGs, route tables
- **VPN Gateway**: Site-to-site, point-to-site, VNet-to-VNet
- **ExpressRoute**: Private connectivity, FastPath, Global Reach
- **Azure Load Balancer**: Standard, Basic, cross-region
- **Application Gateway**: v2 SKU, WAF, autoscaling
- **Azure Front Door**: Global routing, caching, WAF
- **Azure Firewall**: Standard, Premium, forced tunneling
- **Azure Bastion**: Secure RDP/SSH access
- **Private Link**: Private endpoints, private link service
- **NAT Gateway**: Outbound connectivity

### Integration and Messaging
- **Azure Service Bus**: Queues, topics, sessions
- **Azure Event Hubs**: Stream processing, capture, Kafka
- **Azure Event Grid**: Event-driven architectures
- **Logic Apps**: Workflows, connectors, integration
- **API Management**: Policies, products, developer portal
- **Azure Functions**: Event processing, durable functions

### Analytics and Big Data
- **Azure Synapse Analytics**: SQL pools, Spark pools, pipelines
- **Azure Databricks**: Apache Spark, collaborative notebooks
- **Azure Data Factory**: Data integration, mapping data flows
- **Azure Stream Analytics**: Real-time analytics
- **Azure Data Lake**: Storage and analytics
- **HDInsight**: Hadoop, Spark, Kafka, HBase

### Monitoring and Management
- **Azure Monitor**: Metrics, logs, dashboards
- **Application Insights**: APM, distributed tracing
- **Log Analytics**: KQL queries, workspaces
- **Azure Automation**: Runbooks, update management
- **Azure Backup**: Vaults, policies, recovery
- **Azure Site Recovery**: Disaster recovery, replication

## Study Strategy

### Recommended Timeline: 10-12 Weeks

**Weeks 1-2: Identity, Governance, and Monitoring**
- Azure AD and authentication patterns
- RBAC and custom roles
- Azure Policy and governance
- Monitoring and logging solutions

**Weeks 3-4: Data Storage Solutions**
- Storage account design
- Database selection and design
- Data integration patterns
- Backup and archival strategies

**Weeks 5-6: Business Continuity**
- High availability patterns
- Disaster recovery solutions
- Backup and restore strategies
- Cross-region replication

**Weeks 7-8: Infrastructure Solutions**
- Compute design patterns
- Network architecture design
- Load balancing solutions
- Migration strategies

**Weeks 9-10: Integration and Practice**
- Design comprehensive solutions
- Practice exams and scenarios
- Weak area remediation
- Final review and preparation

### Essential Hands-on Practice
- Design multi-tier application architectures
- Implement hub-and-spoke network topology
- Configure hybrid identity with Azure AD Connect
- Design disaster recovery with Azure Site Recovery
- Implement application monitoring with Application Insights
- Design multi-region solutions with Front Door
- Configure private connectivity with Private Link

## 📚 Study Resources

**👉 [Complete Azure Study Resources Guide](../../../.templates/resources-azure.md)**

### Quick Links (AZ-305 Specific)
- **[AZ-305 Official Exam Page](https://learn.microsoft.com/en-us/certifications/exams/az-305/)**
- **[Microsoft Learn - AZ-305 Path](https://learn.microsoft.com/en-us/certifications/azure-solutions-architect/)**
- **[Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/)**
- **[Azure Documentation](https://docs.microsoft.com/en-us/azure/)**
- **[Azure Free Account](https://azure.microsoft.com/en-us/free/)**

### Recommended Study Resources
1. **Microsoft Learn**: Official AZ-305 learning path (FREE)
2. **John Savill's AZ-305 Course**: YouTube (FREE)
3. **Pluralsight/Cloud Academy**: Comprehensive courses
4. **Practice Tests**: MeasureUp, Whizlabs
5. **Azure Documentation**: Service-specific deep dives

## Exam Tips

### Question Strategy
- Read case studies carefully and take notes
- Identify business vs. technical requirements
- Look for keywords indicating specific services
- Consider cost, compliance, and SLAs
- Think about hybrid and multi-region scenarios

### Common Question Themes
- Identity and access management design
- Hybrid connectivity patterns
- High availability and disaster recovery
- Database selection and design
- Application architecture patterns
- Monitoring and governance
- Migration strategies

### Time Management
- Review case studies (10-15 minutes each)
- Allocate time for complex scenario questions
- Flag uncertain questions for review
- Leave buffer time at the end

## 📈 Success Criteria

- Design resilient, scalable, and secure Azure solutions
- Understand Azure-specific architectural patterns
- Navigate Azure's resource organization model
- Demonstrate expertise in hybrid cloud scenarios
- Balance technical requirements with business constraints
- Apply Azure Well-Architected Framework principles
- Design for compliance, governance, and cost optimization