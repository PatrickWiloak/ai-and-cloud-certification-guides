# AWS Certified SysOps Administrator - Associate (SOA-C02) - RETIRED

> **This certification was retired on September 29, 2025** and replaced by the **[AWS Certified CloudOps Engineer - Associate (SOA-C03)](../cloudops-engineer-soa-c03/)**. The study materials below are preserved for reference, but new candidates should pursue SOA-C03.

## Exam Overview

The AWS Certified SysOps Administrator - Associate (SOA-C02) exam validates technical expertise in deployment, management, and operations of AWS workloads. This certification demonstrates proficiency in implementing and managing production operations on AWS.

### Exam Details
- **Exam Code**: SOA-C02
- **Duration**: 130 minutes
- **Format**: Multiple choice and multiple response
- **Number of Questions**: 65 scored questions
- **Passing Score**: 720/1000
- **Cost**: $150 USD
- **Language**: Available in multiple languages
- **Delivery**: Testing center or online proctoring
- **Validity**: 3 years

**Note**: As of March 28, 2023, this exam no longer includes exam labs.

## Exam Domains

### Domain 1: Monitoring, Logging, and Remediation (20% of scored content)
- Implement metrics, alarms, and notifications
- Recognize, correlate, and respond to events
- Configure logging and analyze logs
- Remediate issues based on monitoring and availability metrics

#### Key Focus Areas:
- CloudWatch metrics, alarms, dashboards, and logs
- CloudWatch Logs Insights for log analysis
- EventBridge for event-driven automation
- SNS and SQS for notifications
- Systems Manager for automation and patching
- AWS Config for configuration monitoring
- CloudTrail for API activity logging

### Domain 2: Reliability and Business Continuity (16% of scored content)
- Implement scalability and elasticity
- Implement high availability and resilience
- Implement backup and restore strategies

#### Key Focus Areas:
- Auto Scaling groups and scaling policies
- Elastic Load Balancing (ALB, NLB, Gateway Load Balancer)
- Multi-AZ and multi-region architectures
- RDS Multi-AZ, Read Replicas, and backups
- S3 cross-region replication and versioning
- Route 53 health checks and failover routing
- AWS Backup for centralized backup
- Disaster recovery strategies (backup/restore, pilot light, warm standby, multi-site)

### Domain 3: Deployment, Provisioning, and Automation (18% of scored content)
- Provision and maintain cloud resources
- Automate manual or repeatable processes

#### Key Focus Areas:
- CloudFormation templates and stack management
- Elastic Beanstalk deployment strategies
- Systems Manager automation documents
- AWS Lambda for automation
- EC2 Image Builder for AMI management
- Launch templates and Auto Scaling
- AWS Service Catalog for governance
- Infrastructure as Code best practices

### Domain 4: Security and Compliance (16% of scored content)
- Implement and manage security and compliance policies
- Implement data and infrastructure protection strategies

#### Key Focus Areas:
- IAM policies, roles, and permission management
- Security Groups and Network ACLs
- KMS encryption for data at rest
- SSL/TLS for data in transit
- AWS Systems Manager Session Manager for secure access
- AWS Config rules for compliance
- AWS Security Hub and GuardDuty
- S3 bucket policies and access control
- VPC security best practices

### Domain 5: Networking and Content Delivery (18% of scored content)
- Implement and maintain network features
- Configure domains, DNS services, and content delivery
- Troubleshoot network connectivity issues

#### Key Focus Areas:
- VPC design: subnets, route tables, internet/NAT gateways
- VPC Peering and Transit Gateway
- VPC endpoints (interface and gateway endpoints)
- Route 53 DNS management and routing policies
- CloudFront distributions and caching
- Direct Connect and VPN connections
- Network troubleshooting with VPC Flow Logs
- Elastic Network Interfaces (ENI)

### Domain 6: Cost and Performance Optimization (12% of scored content)
- Implement cost optimization strategies
- Implement performance optimization strategies

#### Key Focus Areas:
- Cost Explorer and Cost and Usage Reports
- AWS Budgets and billing alarms
- Reserved Instances and Savings Plans
- S3 storage classes and lifecycle policies
- EC2 right-sizing and instance optimization
- EBS volume types and optimization
- RDS performance optimization
- CloudWatch for performance monitoring
- Trusted Advisor recommendations

## Key AWS Services for SysOps Administrators

### Monitoring and Management

#### Amazon CloudWatch
- **Metrics**: Standard and custom metrics collection
- **Alarms**: Threshold-based and anomaly detection alarms
- **Dashboards**: Custom monitoring dashboards
- **Logs**: Centralized logging with Logs Insights
- **Events/EventBridge**: Event-driven automation
- **Application Insights**: Application monitoring
- **Synthetics**: API and website monitoring

#### AWS Systems Manager
- **Session Manager**: Secure shell access without SSH keys
- **Run Command**: Execute commands across multiple instances
- **Patch Manager**: Automated OS patching
- **State Manager**: Maintain consistent configuration
- **Automation**: Runbook automation
- **Parameter Store**: Configuration and secrets management
- **Inventory**: Asset management and tracking
- **Maintenance Windows**: Scheduled maintenance tasks

#### AWS Config
- **Configuration Recording**: Track resource configurations
- **Config Rules**: Compliance evaluation
- **Remediation**: Automated compliance fixes
- **Conformance Packs**: Pre-packaged compliance frameworks
- **Multi-Account Aggregation**: Organization-wide monitoring

### Deployment and Automation

#### AWS CloudFormation
- **Templates**: JSON/YAML infrastructure definitions
- **Stacks**: Resource provisioning and management
- **Stack Sets**: Multi-account and multi-region deployment
- **Change Sets**: Preview changes before execution
- **Drift Detection**: Identify manual configuration changes
- **StackPolicy**: Prevent accidental updates/deletions

#### AWS Elastic Beanstalk
- **Platform Management**: Automated platform updates
- **Deployment Policies**: Rolling, immutable, blue/green
- **Environment Configuration**: .ebextensions customization
- **Monitoring**: Integrated CloudWatch monitoring
- **Auto Scaling**: Automatic scaling based on load

### High Availability and DR

#### Elastic Load Balancing
- **Application Load Balancer**: Layer 7 (HTTP/HTTPS)
- **Network Load Balancer**: Layer 4 (TCP/UDP), ultra-low latency
- **Gateway Load Balancer**: Third-party virtual appliances
- **Health Checks**: Monitor target health
- **Cross-Zone Load Balancing**: Distribute traffic evenly
- **Sticky Sessions**: Session affinity

#### Amazon Route 53
- **DNS Management**: Domain registration and hosted zones
- **Routing Policies**: Simple, weighted, latency, failover, geolocation, geoproximity, multivalue
- **Health Checks**: Endpoint monitoring and automatic failover
- **Traffic Flow**: Visual traffic policy editor
- **DNSSEC**: DNS security extensions

### Security

#### AWS IAM
- **Users and Groups**: Identity management
- **Roles**: Service permissions and cross-account access
- **Policies**: Permission management
- **MFA**: Multi-factor authentication
- **Access Keys**: Programmatic access credentials
- **IAM Access Analyzer**: Identify external access

#### AWS KMS
- **Customer Managed Keys**: Full key control
- **AWS Managed Keys**: Service-specific encryption
- **Key Policies**: Access control
- **Automatic Rotation**: Annual key rotation
- **CloudTrail Integration**: Audit key usage

## Study Strategy

### Phase 1: Monitoring and Operations (Weeks 1-2)
1. **CloudWatch Mastery**
   - Metrics, alarms, dashboards
   - Log aggregation and analysis
   - EventBridge automation

2. **Systems Manager**
   - Session Manager, Run Command
   - Patch Manager, State Manager
   - Automation documents

### Phase 2: High Availability and DR (Weeks 3-4)
1. **Load Balancing and Auto Scaling**
   - ALB, NLB configuration
   - Auto Scaling policies
   - Health checks and monitoring

2. **Backup and Recovery**
   - AWS Backup configuration
   - RDS backup strategies
   - S3 versioning and replication
   - Disaster recovery architectures

### Phase 3: Automation and Deployment (Weeks 5-6)
1. **CloudFormation**
   - Template development
   - Stack management
   - Drift detection

2. **Elastic Beanstalk**
   - Application deployment
   - Environment management
   - Deployment strategies

### Phase 4: Security and Networking (Weeks 7-8)
1. **Network Design**
   - VPC architecture
   - Security Groups and NACLs
   - VPC endpoints

2. **Security Implementation**
   - IAM policies and roles
   - Encryption with KMS
   - Security best practices

### Phase 5: Cost and Performance Optimization (Week 9)
1. **Cost Management**
   - Cost Explorer analysis
   - Reserved Instances
   - Resource optimization

2. **Performance Tuning**
   - CloudWatch metrics analysis
   - Resource right-sizing
   - Caching strategies

### Phase 6: Review and Practice (Week 10)
- Complete practice exams
- Review weak areas
- Hands-on lab scenarios

## Common Exam Scenarios

### Operations and Monitoring
- Configuring CloudWatch alarms for Auto Scaling
- Analyzing logs with CloudWatch Logs Insights
- Automated remediation with EventBridge and Lambda
- Patch management with Systems Manager
- Configuration compliance with AWS Config

### High Availability
- Multi-AZ RDS deployment with failover
- Auto Scaling group with ELB health checks
- Route 53 failover routing with health checks
- S3 cross-region replication for DR
- Multi-region application architecture

### Automation
- CloudFormation stack deployment and updates
- Systems Manager automation for instance management
- Elastic Beanstalk blue/green deployments
- Automated backup policies
- Event-driven automation workflows

### Security
- IAM role for EC2 to access S3
- Secure parameter storage with Systems Manager
- Network isolation with Security Groups
- Encryption at rest with KMS
- Secure remote access with Session Manager

### Cost Optimization
- Identifying cost optimization opportunities
- Right-sizing EC2 instances
- S3 Intelligent-Tiering and lifecycle policies
- Reserved Instance and Savings Plan selection
- Unused resource identification

## Exam Preparation Tips

### Study Approach
1. **Hands-on Practice**: Deploy and manage AWS resources
2. **AWS Documentation**: Read service user guides and best practices
3. **Practice Exams**: Take multiple practice tests
4. **AWS Training**: Complete AWS Skill Builder courses
5. **Real-world Experience**: Manage production AWS workloads

### Exam Strategy
1. **Time Management**: ~2 minutes per question
2. **Read Carefully**: Identify key requirements and constraints
3. **Eliminate Wrong Answers**: Rule out incorrect options
4. **Best Practices**: Choose AWS operational best practices
5. **Troubleshooting**: Understand common issues and solutions

### Common Pitfalls
- Not understanding CloudWatch metrics and dimensions
- Confusion between Security Groups and NACLs
- Missing Auto Scaling cooldown periods
- Not knowing Systems Manager capabilities
- Overlooking cost optimization opportunities

## 📚 Comprehensive Study Resources

**👉 [Complete AWS Study Resources Guide](../../../../.templates/resources-aws.md)**

For detailed information on courses, practice tests, hands-on labs, and more, see our comprehensive AWS study resources guide.

### Quick Links (SOA-C02 Specific)
- **[SOA-C02 Official Exam Page](https://aws.amazon.com/certification/certified-sysops-admin-associate/)** - Registration and exam details
- **[AWS Skill Builder - SOA-C02 Exam Prep](https://skillbuilder.aws/)** - FREE official exam preparation
- **[AWS SysOps Documentation](https://docs.aws.amazon.com/)** - Complete service documentation
- **[AWS Free Tier](https://aws.amazon.com/free/)** - 12 months free for hands-on practice

## Next Steps After Certification

### Career Advancement
- Pursue AWS Professional certifications (Solutions Architect, DevOps Engineer)
- Specialize in Security or Advanced Networking specialties
- Lead operations teams and architecture decisions
- Cloud operations and DevOps consulting roles

### Continuous Learning
- Stay updated with new AWS services and features
- Participate in AWS operations communities
- Attend AWS events and webinars
- Explore advanced automation and DevOps practices

### Practical Application
- Implement operational excellence in production
- Build automated operational runbooks
- Mentor junior operations engineers
- Share knowledge through blogs and presentations
