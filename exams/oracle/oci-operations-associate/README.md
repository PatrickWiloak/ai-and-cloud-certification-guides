# Oracle Cloud Infrastructure Operations Associate (1Z0-1067-24)

The OCI Operations Associate certification validates skills in managing, monitoring, and maintaining Oracle Cloud Infrastructure environments. This certification demonstrates proficiency in day-to-day operations, troubleshooting, automation, and ensuring the reliability of OCI resources.

## 📋 Quick Links

- [**Fact Sheet**](fact-sheet.md) - Exam logistics and objectives
- [**Practice Plan**](practice-plan.md) - Structured study schedule

## 📚 Study Materials

### Core Notes
- [Infrastructure Operations](notes/01-infrastructure-operations.md)
- [Monitoring Troubleshooting](notes/02-monitoring-troubleshooting.md)
- [Security Cost Management](notes/03-security-cost-management.md)
## 🎯 Exam Details

- **Exam Code**: 1Z0-1067-24
- **Duration**: 105 minutes
- **Number of Questions**: 55 questions
- **Passing Score**: 68%
- **Question Types**: Multiple choice, multiple select
- **Cost**: $150 USD
- **Validity**: Recertification required every 2 years
- **Language**: Available in multiple languages
- **Delivery**: Pearson VUE (online proctored or test center)

## 📖 Exam Domains

### 1. Manage OCI Resources (25%)

#### Resource Lifecycle Management
- **Compute Operations**
  - Start, stop, reboot, terminate instances
  - Change instance shape (vertical scaling)
  - Attach and detach VNIC, block volumes
  - Update instance metadata
  - Manage custom images and boot volumes
  - Console connections for troubleshooting

- **Storage Operations**
  - Create, resize, clone block volumes
  - Create and manage volume backups
  - Object Storage bucket management
  - Lifecycle policies for object storage
  - File Storage mount target management
  - Storage metrics and performance monitoring

- **Network Operations**
  - Manage VCN components (subnets, route tables, security lists)
  - Update NSG rules
  - Configure and test load balancers
  - VPN and FastConnect management
  - DNS zone and record management

- **Database Operations**
  - Start, stop, scale Autonomous Databases
  - Backup and restore databases
  - Clone databases for dev/test
  - Manage DB patches and updates
  - Monitor database performance

#### Resource Organization
- **Compartments**
  - Create compartment hierarchies
  - Move resources between compartments
  - Apply compartment quotas
  - Organize for governance and billing

- **Tagging**
  - Free-form tags for flexibility
  - Defined tags with tag namespaces
  - Tag defaults for automation
  - Cost tracking with tags
  - Tag-based policies

### 2. Monitoring and Observability (20%)

#### Monitoring Configuration
- **Metrics and Alarms**
  - Service metrics (automatic)
  - Custom metrics (application-specific)
  - Metric query language (MQL)
  - Alarm creation and configuration
  - Alarm suppression during maintenance
  - Alarm history and troubleshooting

- **Dashboards**
  - Create operational dashboards
  - Widget types (line, bar, gauge)
  - Share dashboards across teams
  - Clone and customize dashboards

- **Service Connector Hub**
  - Route logs to Object Storage
  - Stream metrics to third-party tools
  - Aggregate logs from multiple sources
  - Transform data during routing

#### Application Performance Monitoring
- **APM Domain Configuration**
  - Create and configure APM domains
  - Instrument applications for tracing
  - Distributed tracing setup
  - Performance baselines

- **Log Analytics**
  - Create log groups
  - Configure log sources
  - Query logs with search syntax
  - Create saved searches and visualizations
  - Set up log-based alerts

### 3. Logging and Auditing (15%)

#### Logging Management
- **Log Types**
  - Audit logs (who did what, when)
  - Service logs (VCN flow, load balancer, WAF)
  - Custom logs (application logs)
  - Enable logging for resources
  - Log retention policies

- **Log Configuration**
  - Enable logging for VCN flow logs
  - Configure load balancer access/error logs
  - Custom log ingestion
  - Log archival to Object Storage
  - Cross-region log replication

#### Audit and Compliance
- **Audit Log Analysis**
  - Search audit logs for specific events
  - Identify unauthorized access attempts
  - Track configuration changes
  - Compliance reporting
  - Integrate with SIEM tools

- **Compliance Monitoring**
  - Cloud Guard for posture management
  - Security Zones for compliance enforcement
  - Vulnerability scanning
  - Compliance reports and dashboards

### 4. Backup, Recovery, and Business Continuity (15%)

#### Backup Strategies
- **Compute Backup**
  - Custom images from instances
  - Boot volume backups (manual and scheduled)
  - Block volume backups and clones
  - Cross-region backup copies
  - Backup retention policies

- **Database Backup**
  - Autonomous Database automatic backups
  - Manual on-demand backups
  - Long-term backup retention
  - DB Systems backup configuration
  - Point-in-time recovery (PITR)

- **Storage Backup**
  - Object Storage versioning
  - Object lifecycle management
  - File Storage snapshots
  - Cross-region object replication

#### Disaster Recovery
- **DR Planning**
  - Identify RTO and RPO requirements
  - DR strategies (backup/restore, pilot light, warm standby)
  - Runbooks for DR procedures
  - DR testing and validation

- **Recovery Operations**
  - Restore from backups
  - Database restore and recovery
  - Instance recreation from images
  - Cross-region failover procedures
  - Post-recovery validation

### 5. Automation and Infrastructure as Code (15%)

#### Resource Manager (Terraform)
- **Stack Management**
  - Create stacks from Terraform configurations
  - Plan, apply, destroy operations
  - Manage stack state
  - Stack versioning and rollback
  - Private endpoints for security

- **Configuration Management**
  - Terraform best practices on OCI
  - Modular configurations
  - Remote state management
  - Variable management and secrets
  - CI/CD integration

#### OCI CLI and SDKs
- **CLI Operations**
  - Install and configure OCI CLI
  - Authentication with API keys
  - Instance principal authentication
  - Common CLI commands for operations
  - Scripting and automation with CLI

- **Automation Tools**
  - Functions for event-driven automation
  - Events service for triggering actions
  - Automation runbooks
  - Scheduled automation tasks

### 6. Troubleshooting and Incident Response (10%)

#### Troubleshooting Methodology
- **Incident Identification**
  - Monitor alarms and alerts
  - Log analysis for errors
  - Performance metric review
  - User-reported issues

- **Problem Diagnosis**
  - Review service health dashboard
  - Check resource quotas and limits
  - Analyze logs and metrics
  - Network connectivity testing (ping, traceroute)
  - Console connections to instances

- **Resolution and Recovery**
  - Apply fixes and workarounds
  - Restart services and instances
  - Escalate to Oracle Support
  - Document resolution steps
  - Post-incident review

#### Common Issues
- **Compute Issues**
  - Instance won't start (capacity, quota)
  - Performance degradation (CPU, memory, I/O)
  - Network connectivity problems
  - Boot volume issues

- **Network Issues**
  - Routing configuration errors
  - Security list/NSG misconfiguration
  - VPN connectivity failures
  - Load balancer health check failures

- **Database Issues**
  - Connection failures (authentication, network)
  - Performance issues (query tuning, scaling)
  - Backup/restore failures
  - Storage exhaustion

## 🎓 Prerequisites & Recommended Experience

### Prerequisites
- **OCI Foundations (1Z0-1085-24)** - Recommended but not required
- Basic understanding of cloud operations
- Familiarity with Linux/Windows administration
- Basic scripting knowledge

### Recommended Experience
- 1 year working with OCI
- Experience with cloud operations and monitoring
- Hands-on with OCI Console, CLI, and APIs
- Understanding of DevOps practices

### Technical Skills
- Manage OCI resources through Console, CLI, API
- Configure monitoring, logging, and alerting
- Perform backup and recovery operations
- Automate tasks with Resource Manager and CLI
- Troubleshoot common issues
- Implement security best practices

## Study Strategy

### Recommended Timeline: 8-10 Weeks

**Weeks 1-2: Resource Management**
- OCI Console navigation and operations
- OCI CLI installation and configuration
- Resource lifecycle management
- Tagging and organization
- Hands-on: Manage compute, storage, networking resources

**Weeks 3-4: Monitoring and Observability**
- Configure metrics and alarms
- Build operational dashboards
- Log Analytics setup
- APM configuration
- Hands-on: Create comprehensive monitoring solution

**Weeks 5-6: Backup, Recovery, and Automation**
- Backup strategies for all resource types
- DR planning and testing
- Resource Manager (Terraform)
- Automation with CLI and Functions
- Hands-on: Implement backup and automation

**Weeks 7-8: Security Operations and Troubleshooting**
- IAM operations and auditing
- Cloud Guard and Security Zones
- Common troubleshooting scenarios
- Incident response procedures
- Hands-on: Security configuration and incident response

**Weeks 9-10: Practice and Review**
- Practice exams (multiple attempts)
- Operational scenarios and case studies
- Review weak areas
- Final hands-on labs

### Essential Hands-on Labs
- Configure complete monitoring solution (metrics, alarms, dashboards)
- Implement automated backups for compute and databases
- Create and manage Resource Manager stacks
- Troubleshoot network connectivity issues
- Perform disaster recovery drill
- Automate resource management with OCI CLI
- Configure Cloud Guard and respond to findings
- Analyze logs with Log Analytics
- Implement cost tracking with tags and budgets

## 📚 Study Resources

### Official Oracle Resources
- **[OCI Operations Associate Learning Path](https://mylearn.oracle.com/ou/learning-path/become-an-oci-operations-associate-2024/136199)** - Official training (FREE)
- **[OCI Documentation](https://docs.oracle.com/en-us/iaas/Content/home.htm)** - Operations guides
- **[OCI CLI Documentation](https://docs.oracle.com/en-us/iaas/tools/oci-cli/latest/oci_cli_docs/)** - CLI reference
- **[Oracle Cloud Free Tier](https://www.oracle.com/cloud/free/)** - Hands-on practice environment
- **[OCI YouTube Channel](https://www.youtube.com/c/OracleCloudInfrastructure)** - Operations tutorials

### Recommended Materials
1. **Oracle University**: Official OCI Operations Associate course
2. **Practice Tests**: Oracle official practice exam
3. **OCI CLI Practice**: Extensive hands-on with CLI commands
4. **Terraform on OCI**: Hands-on with Resource Manager

### Community Resources
- OCI Operations best practices documentation
- OCI blogs and technical articles
- Oracle Cloud Infrastructure subreddit
- OCI community forums

## Exam Tips

### Question Strategy
- Practical, scenario-based questions
- Focus on "how to" perform operations
- Consider operational best practices
- Look for most efficient solution
- CLI commands and syntax awareness

### Common Question Themes
- Resource lifecycle management (start, stop, scale)
- Monitoring configuration (metrics, alarms, dashboards)
- Backup and recovery procedures
- Troubleshooting common issues
- OCI CLI commands and syntax
- Automation with Resource Manager
- Log analysis and auditing
- Tagging and cost management
- IAM operations and policies

### Operations Best Practices
- **Automate everything**: Use Resource Manager and CLI
- **Monitor proactively**: Set up alarms before issues occur
- **Tag all resources**: For organization and cost tracking
- **Regular backups**: Automated backup policies
- **Document procedures**: Runbooks for common operations
- **Test DR**: Regular DR drills
- **Secure by default**: Least privilege access
- **Log everything**: Enable logging for audit and troubleshooting

### Time Management
- 105 minutes for 55 questions = ~1.9 minutes per question
- Don't get stuck on CLI syntax questions
- Flag uncertain questions for review
- Leave 15 minutes for final review

## 📈 Success Criteria

- Manage OCI resources efficiently through Console, CLI, and API
- Configure comprehensive monitoring and alerting
- Implement backup and recovery strategies
- Automate operations with Resource Manager and scripting
- Troubleshoot common OCI issues
- Maintain security and compliance
- Optimize costs and performance
- Apply operational best practices

## Career Path and Next Steps

### After OCI Operations Associate
1. **OCI Architect Associate** - Design solutions on OCI
2. **OCI Developer Associate** - Application development
3. **OCI Security Professional** - Advanced security operations
4. **DevOps and SRE Roles** - Advanced automation and reliability

### Related Certifications
- **OCI Architect Associate** - For architectural knowledge
- **OCI Developer Associate** - For application development
- **Kubernetes Certifications** - For OKE operations

---

**Master the operations of Oracle Cloud Infrastructure!** ⚙️
