# AWS CloudOps Engineer Associate (SOA-C03) Study Plan

## 📋 6-Week Comprehensive Study Schedule

### Week 1: Monitoring and Observability Foundations

#### Day 1-2: Amazon CloudWatch Deep Dive
- [ ] CloudWatch metrics: standard vs custom, namespaces, dimensions
- [ ] CloudWatch alarms: metric alarms, composite alarms, alarm actions
- [ ] CloudWatch Logs: log groups, log streams, retention policies
- [ ] CloudWatch Logs Insights query syntax and analysis
- [ ] Hands-on: Create custom metrics and alarms for EC2 instances
- [ ] Lab: Build a CloudWatch dashboard with metric math expressions
- [ ] Review Notes: `notes/01-monitoring-logging.md`

**📖 [CloudWatch Getting Started](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/GettingStarted.html)** - Hands-on introduction

#### Day 3-4: CloudTrail and AWS Config
- [ ] CloudTrail trails: management events, data events, insights events
- [ ] CloudTrail log file integrity validation
- [ ] CloudTrail integration with CloudWatch Logs and EventBridge
- [ ] AWS Config rules: managed rules, custom rules, conformance packs
- [ ] AWS Config remediation actions and aggregators
- [ ] Hands-on: Set up organization-wide CloudTrail trail
- [ ] Lab: Create Config rules with automatic remediation

**📖 [CloudTrail Getting Started](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-getting-started.html)** - Trail setup guide

#### Day 5-6: AWS X-Ray and Systems Manager
- [ ] X-Ray service maps, traces, segments, and subsegments
- [ ] X-Ray daemon configuration and SDK integration
- [ ] X-Ray sampling rules and trace filtering
- [ ] Systems Manager Session Manager for secure instance access
- [ ] Systems Manager Run Command and Patch Manager
- [ ] Parameter Store: standard vs advanced parameters, encryption
- [ ] Hands-on: Instrument an application with X-Ray tracing
- [ ] Lab: Configure Systems Manager for fleet management

**📖 [X-Ray Getting Started](https://docs.aws.amazon.com/xray/latest/devguide/xray-gettingstarted.html)** - Tracing setup

#### Day 7: Week 1 Review
- [ ] Practice questions on monitoring and logging (target: 60%+)
- [ ] Review CloudWatch alarm action configurations
- [ ] Revisit Config rule evaluation and remediation workflows

---

### Week 2: Deployment and Infrastructure as Code

#### Day 8-9: AWS CloudFormation
- [ ] Template anatomy: Parameters, Mappings, Conditions, Resources, Outputs
- [ ] Intrinsic functions: Ref, GetAtt, Sub, Join, Select, ImportValue
- [ ] Stack operations: create, update, delete, drift detection
- [ ] Change sets for previewing updates
- [ ] Stack sets for multi-account, multi-region deployment
- [ ] Nested stacks and cross-stack references
- [ ] Hands-on: Build a multi-tier VPC with CloudFormation
- [ ] Lab: Deploy stack sets across multiple accounts

**📖 [CloudFormation Template Reference](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html)** - Resource reference

#### Day 10-11: AWS CDK and Elastic Beanstalk
- [ ] CDK constructs: L1, L2, L3 constructs
- [ ] CDK stacks, apps, and synthesis to CloudFormation
- [ ] CDK Pipelines for CI/CD automation
- [ ] Elastic Beanstalk environments and platform management
- [ ] Deployment policies: all-at-once, rolling, rolling with batch, immutable
- [ ] Blue/green deployments with URL swap
- [ ] Hands-on: Deploy infrastructure with AWS CDK (TypeScript or Python)
- [ ] Lab: Configure Elastic Beanstalk with custom .ebextensions

**📖 [CDK Workshop](https://cdkworkshop.com/)** - Interactive CDK tutorial

#### Day 12-13: Container Services and CI/CD
- [ ] ECS cluster management: EC2 and Fargate launch types
- [ ] ECS task definitions, services, and service auto scaling
- [ ] EKS managed node groups and Fargate profiles
- [ ] ECR image repositories, scanning, and lifecycle policies
- [ ] CodePipeline stages: source, build, test, deploy
- [ ] CodeBuild buildspec.yml and custom build environments
- [ ] CodeDeploy deployment configurations and appspec.yml
- [ ] Hands-on: Deploy containerized application on ECS Fargate
- [ ] Lab: Build CI/CD pipeline with CodePipeline end-to-end

**📖 [ECS Getting Started](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/getting-started.html)** - Container deployment

#### Day 14: Week 2 Review
- [ ] Practice questions on deployment and automation (target: 60%+)
- [ ] Compare CloudFormation vs CDK use cases
- [ ] Review ECS vs EKS decision criteria

---

### Week 3: Security and Compliance

#### Day 15-16: IAM and Multi-Account Management
- [ ] IAM policy evaluation logic: identity-based, resource-based, SCPs
- [ ] IAM roles for services, cross-account access, and federation
- [ ] Permission boundaries and session policies
- [ ] AWS Organizations: OUs, SCPs, and policy inheritance
- [ ] AWS Control Tower: landing zones, guardrails, account factory
- [ ] Cross-account IAM role assumption patterns
- [ ] Hands-on: Implement least-privilege IAM policies for an operations team
- [ ] Lab: Set up AWS Organizations with SCPs

**📖 [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)** - Security recommendations

#### Day 17-18: Data Protection and Encryption
- [ ] AWS KMS: customer managed keys, AWS managed keys, key policies
- [ ] Encryption at rest for EBS, S3, RDS, and DynamoDB
- [ ] Encryption in transit with TLS/SSL and ACM certificates
- [ ] AWS Secrets Manager for credential rotation
- [ ] Systems Manager Parameter Store for configuration data
- [ ] Hands-on: Configure KMS key policies and encrypt EBS volumes
- [ ] Lab: Automate secret rotation with Secrets Manager

**📖 [AWS KMS](https://docs.aws.amazon.com/kms/latest/developerguide/overview.html)** - Key management

#### Day 19-20: Security Monitoring and Threat Detection
- [ ] Amazon GuardDuty findings and threat intelligence
- [ ] AWS Security Hub standards and controls
- [ ] AWS Config rules for compliance monitoring
- [ ] VPC Flow Logs analysis and anomaly detection
- [ ] AWS WAF rules and web ACLs
- [ ] AWS Shield Standard and Advanced for DDoS protection
- [ ] Hands-on: Enable GuardDuty and review sample findings
- [ ] Lab: Configure Security Hub with AWS Foundational Security Best Practices

**📖 [GuardDuty Getting Started](https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_settingup.html)** - Threat detection setup

#### Day 21: Week 3 Review
- [ ] Practice questions on security and compliance (target: 65%+)
- [ ] Review SCP vs IAM policy differences and interaction
- [ ] Revisit encryption options for each storage service

---

### Week 4: Networking and Content Delivery

#### Day 22-23: VPC Architecture and Design
- [ ] VPC CIDR planning, subnets (public/private), and AZ distribution
- [ ] Route tables: main vs custom, route propagation
- [ ] Internet Gateway, NAT Gateway, and egress-only IGW
- [ ] VPC endpoints: Gateway endpoints (S3, DynamoDB) vs Interface endpoints
- [ ] Security groups (stateful) vs Network ACLs (stateless)
- [ ] VPC Flow Logs configuration and analysis
- [ ] Hands-on: Build a multi-tier VPC with public and private subnets
- [ ] Lab: Configure VPC endpoints for private S3 access

**📖 [VPC User Guide](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)** - VPC fundamentals

#### Day 24-25: Route 53 and CloudFront
- [ ] Route 53 hosted zones: public and private
- [ ] Routing policies: simple, weighted, latency, failover, geolocation, multivalue
- [ ] Route 53 health checks and DNS failover
- [ ] CloudFront distributions: origins, behaviors, cache policies
- [ ] CloudFront origin failover and origin groups
- [ ] Lambda@Edge and CloudFront Functions use cases
- [ ] Hands-on: Configure Route 53 failover routing with health checks
- [ ] Lab: Set up CloudFront distribution with S3 origin and OAC

**📖 [Route 53 Routing Policies](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html)** - Traffic routing options

#### Day 26-27: Hybrid Connectivity and Load Balancing
- [ ] Site-to-Site VPN configuration and monitoring
- [ ] AWS Direct Connect: connections, virtual interfaces, LAG
- [ ] Transit Gateway for hub-and-spoke and inter-region peering
- [ ] VPC peering: limitations and use cases
- [ ] ALB: path-based and host-based routing, target groups
- [ ] NLB: TCP/UDP load balancing, static IPs
- [ ] GLB: third-party appliance integration
- [ ] Hands-on: Configure ALB with path-based routing and Auto Scaling
- [ ] Lab: Set up Transit Gateway connecting multiple VPCs

**📖 [Direct Connect User Guide](https://docs.aws.amazon.com/directconnect/latest/UserGuide/Welcome.html)** - Dedicated connections

#### Day 28: Week 4 Review
- [ ] Practice questions on networking (target: 65%+)
- [ ] Review VPC endpoint types and use cases
- [ ] Compare ALB vs NLB selection criteria

---

### Week 5: Reliability, Backup, and Cost Optimization

#### Day 29-30: High Availability and Auto Scaling
- [ ] Multi-AZ architectures for EC2, RDS, and ElastiCache
- [ ] Auto Scaling groups: launch templates, scaling policies, cooldowns
- [ ] Target tracking, step scaling, and scheduled scaling
- [ ] ELB health checks and connection draining
- [ ] RDS Multi-AZ failover and Aurora cluster endpoints
- [ ] Aurora Serverless v2 scaling configuration
- [ ] Hands-on: Configure Auto Scaling with target tracking policy
- [ ] Lab: Test RDS Multi-AZ failover and measure recovery time

**📖 [EC2 Auto Scaling](https://docs.aws.amazon.com/autoscaling/ec2/userguide/what-is-amazon-ec2-auto-scaling.html)** - Scaling automation

#### Day 31-32: Backup and Disaster Recovery
- [ ] AWS Backup: plans, vaults, lifecycle policies, cross-region copies
- [ ] EBS snapshots: creation, lifecycle management with DLM
- [ ] RDS automated backups, snapshots, and point-in-time recovery
- [ ] S3 versioning, lifecycle rules, and cross-region replication
- [ ] DR strategies: backup/restore, pilot light, warm standby, active-active
- [ ] RPO and RTO requirements mapping to DR strategies
- [ ] AWS Elastic Disaster Recovery setup and testing
- [ ] Hands-on: Create AWS Backup plan with cross-region vault
- [ ] Lab: Implement pilot light DR architecture

**📖 [DR Whitepaper](https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/disaster-recovery-options-in-the-cloud.html)** - DR strategies

#### Day 33-34: Cost and Performance Optimization
- [ ] AWS Cost Explorer for cost analysis and forecasting
- [ ] AWS Budgets and billing alerts
- [ ] Cost allocation tags and cost categories
- [ ] Reserved Instances and Savings Plans comparison
- [ ] Spot Instances for fault-tolerant workloads
- [ ] Compute Optimizer for right-sizing recommendations
- [ ] RDS Proxy for database connection pooling
- [ ] DynamoDB DAX for in-memory caching
- [ ] Hands-on: Set up budgets and cost anomaly detection
- [ ] Lab: Use Compute Optimizer to right-size EC2 instances

**📖 [AWS Cost Management](https://docs.aws.amazon.com/cost-management/latest/userguide/what-is-costmanagement.html)** - Cost tools

#### Day 35: Week 5 Review
- [ ] Practice questions on reliability and cost (target: 70%+)
- [ ] Compare DR strategies by RPO/RTO requirements
- [ ] Review Savings Plans vs Reserved Instances

---

### Week 6: Review, Practice Labs, and Exam Preparation

#### Day 36-37: Comprehensive Review - Domains 1 & 2
- [ ] Review all monitoring and logging services
- [ ] Review CloudFormation and CDK key concepts
- [ ] Review container services and CI/CD pipelines
- [ ] Full-length practice exam #1 (target: 75%+)
- [ ] Deep-dive review of missed topics from practice exam

#### Day 38-39: Comprehensive Review - Domains 3, 4 & 5
- [ ] Review IAM, Organizations, and security services
- [ ] Review VPC architecture and networking
- [ ] Review HA, DR, and backup strategies
- [ ] Full-length practice exam #2 (target: 75%+)
- [ ] Deep-dive review of missed topics from practice exam

#### Day 40-41: Hands-On Exam Lab Practice
- [ ] Practice console-based lab scenarios:
  - [ ] Configure CloudWatch alarms and dashboards
  - [ ] Deploy infrastructure with CloudFormation
  - [ ] Set up VPC with subnets, route tables, and security groups
  - [ ] Configure Auto Scaling with load balancer
  - [ ] Set up AWS Backup with cross-region copy
- [ ] Time each lab (target: 20-40 minutes per lab)
- [ ] Review AWS console navigation shortcuts

#### Day 42: Final Review and Exam Preparation
- [ ] Final practice exam (target: 80%+)
- [ ] Review weak areas from all practice exams
- [ ] Quick reference review of key service limits and quotas
- [ ] Exam day logistics: ID, workspace, system check
- [ ] Rest and confidence building

---

## 📋 Daily Study Routine (2-3 hours/day)

### Recommended Schedule
1. **45 minutes**: Read AWS documentation and study materials
2. **75 minutes**: Hands-on labs and console practice
3. **30 minutes**: Practice questions and concept review
4. **15 minutes**: Note-taking and summary creation

---

## 🎯 Practice Exam Strategy

### Target Scores by Week
- [ ] Week 2: 60%+ on domain-specific practice questions
- [ ] Week 3: 65%+ on practice exams
- [ ] Week 4: 70%+ on practice exams
- [ ] Week 5: 75%+ on practice exams
- [ ] Week 6: 80%+ consistently on full-length practice exams

### Recommended Practice Resources
**📖 [AWS Skill Builder](https://skillbuilder.aws/)** - Free official exam prep and practice questions
**📖 [CloudOps Learning Plan](https://explore.skillbuilder.aws/learn/learning_plan/view/1994/cloudops-engineer-learning-plan)** - Official study plan
**📖 [Tutorials Dojo](https://tutorialsdojo.com/)** - Practice exams with detailed explanations
**📖 [AWS Free Tier](https://aws.amazon.com/free/)** - Hands-on lab practice

---

## 📚 Key Exam Topics Summary

### Monitoring, Logging, and Performance (22%)
- CloudWatch metrics, logs, alarms, and dashboards
- CloudTrail event types and log analysis
- X-Ray tracing and service maps
- Systems Manager operational tools
- Performance optimization strategies

### Deployment, Provisioning, and Automation (24%)
- CloudFormation templates and stack management
- AWS CDK constructs and deployment
- Container services (ECS, EKS, Fargate)
- CI/CD pipeline implementation
- Auto Scaling and launch templates

### Security and Compliance (18%)
- IAM policies, roles, and permission boundaries
- AWS Organizations and SCPs
- Encryption and key management
- GuardDuty, Security Hub, and Config rules
- Network security (security groups, NACLs)

### Networking and Content Delivery (16%)
- VPC design and subnet architecture
- Route 53 routing policies and failover
- CloudFront caching and distribution
- Hybrid connectivity (VPN, Direct Connect)
- Load balancer selection and configuration

### Reliability and Business Continuity (20%)
- Multi-AZ and Auto Scaling architectures
- Backup strategies and AWS Backup
- Disaster recovery approaches (RPO/RTO)
- Database high availability patterns
- S3 replication and versioning

---

## Final Exam Checklist

### Technical Preparation
- [ ] Hands-on experience with all core services
- [ ] Comfortable navigating AWS console for lab scenarios
- [ ] Understanding of multi-account management patterns
- [ ] Knowledge of container deployment options
- [ ] Experience with CloudFormation template creation

### Exam Day Strategy
- [ ] Complete hands-on labs first (most time-consuming)
- [ ] Time management: ~2.8 minutes per question plus lab time
- [ ] Read questions carefully for operational requirements
- [ ] Eliminate obviously incorrect answers
- [ ] Choose AWS best practices when multiple options work
- [ ] Flag uncertain questions for review if time permits
