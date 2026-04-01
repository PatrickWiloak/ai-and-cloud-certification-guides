# AWS CloudOps Engineer Associate (SOA-C03) Study Plan

## 8-Week Comprehensive Study Schedule

### Week 1: Monitoring and Logging Fundamentals

#### Day 1-2: Amazon CloudWatch Deep Dive
- [ ] Study CloudWatch metrics - standard vs custom, dimensions, namespaces
- [ ] Learn CloudWatch alarms - metric alarms, composite alarms, alarm actions
- [ ] Understand CloudWatch dashboards - widgets, cross-account, cross-region
- [ ] Hands-on: Create custom metrics and alarms for EC2 instances
- [ ] Lab: Build operational dashboard with metric math expressions
- [ ] Review Notes: `notes/01-monitoring-logging.md`

#### Day 3-4: CloudWatch Logs and Insights
- [ ] Study log groups, log streams, and retention policies
- [ ] Learn metric filters and subscription filters
- [ ] Master CloudWatch Logs Insights query syntax
- [ ] Understand unified CloudWatch agent configuration
- [ ] Hands-on: Configure CloudWatch agent on EC2 instances
- [ ] Lab: Write Logs Insights queries to analyze application logs

#### Day 5-6: CloudTrail, X-Ray, and EventBridge
- [ ] Study CloudTrail event types - management, data, insights
- [ ] Learn X-Ray tracing concepts - segments, subsegments, service maps
- [ ] Understand EventBridge rules, targets, and event patterns
- [ ] Hands-on: Configure CloudTrail with CloudWatch Logs integration
- [ ] Lab: Set up EventBridge rules for automated remediation

#### Day 7: Week 1 Review and Practice
- [ ] Complete monitoring practice questions
- [ ] Build end-to-end monitoring architecture
- [ ] Review any weak areas identified

### Week 2: Systems Manager and Operational Tools

#### Day 8-9: Systems Manager Core Features
- [ ] Study Session Manager for secure instance access
- [ ] Learn Run Command for remote execution
- [ ] Understand Patch Manager baselines and patching
- [ ] Hands-on: Configure Session Manager and Run Command
- [ ] Lab: Set up automated patching with maintenance windows
- [ ] Review Notes: `notes/01-monitoring-logging.md` (SSM sections)

#### Day 10-11: Systems Manager Advanced Features
- [ ] Study Parameter Store - standard vs advanced, SecureString
- [ ] Learn Automation runbooks and document types
- [ ] Understand State Manager for configuration compliance
- [ ] Study OpsCenter for operational issue management
- [ ] Hands-on: Create Automation runbooks for common tasks
- [ ] Lab: Implement configuration management with State Manager

#### Day 12-13: Reliability Fundamentals
- [ ] Study EC2 Auto Scaling - launch templates, scaling policies
- [ ] Learn health checks - EC2, ELB, and custom
- [ ] Understand Elastic Load Balancing - ALB, NLB, GLB
- [ ] Hands-on: Configure Auto Scaling with target tracking
- [ ] Lab: Set up multi-AZ load balancing with health checks
- [ ] Review Notes: `notes/02-reliability-business-continuity.md`

#### Day 14: Week 2 Review and Integration
- [ ] Complete operational tools practice questions
- [ ] Design automated operations workflow
- [ ] Practice troubleshooting scenarios

### Week 3: Backup, DR, and High Availability

#### Day 15-16: Backup Strategies
- [ ] Study AWS Backup - plans, vaults, lifecycle policies
- [ ] Learn EBS snapshots and lifecycle management
- [ ] Understand RDS automated backups and snapshots
- [ ] Study cross-region and cross-account backup
- [ ] Hands-on: Configure centralized backup with AWS Backup
- [ ] Lab: Implement cross-region backup strategy

#### Day 17-18: Disaster Recovery
- [ ] Study DR strategies - backup/restore, pilot light, warm standby, multi-site
- [ ] Learn RPO and RTO planning
- [ ] Understand Route 53 failover routing and health checks
- [ ] Study AWS Elastic Disaster Recovery
- [ ] Hands-on: Implement pilot light DR architecture
- [ ] Lab: Configure Route 53 failover with health checks

#### Day 19-20: High Availability Patterns
- [ ] Study Multi-AZ deployments for RDS, ElastiCache, and EFS
- [ ] Learn Auto Scaling lifecycle hooks
- [ ] Understand connection draining and deregistration delay
- [ ] Hands-on: Build highly available web application
- [ ] Lab: Test failover scenarios and recovery procedures
- [ ] Review Notes: `notes/02-reliability-business-continuity.md`

#### Day 21: Week 3 Review and Practice
- [ ] Complete reliability practice questions
- [ ] Design end-to-end HA architecture
- [ ] Practice DR scenario planning

### Week 4: Deployment and Automation

#### Day 22-23: AWS CloudFormation
- [ ] Study template anatomy - Resources, Parameters, Mappings, Outputs, Conditions
- [ ] Learn stack operations - create, update, delete, rollback
- [ ] Understand StackSets for multi-account deployment
- [ ] Study change sets and drift detection
- [ ] Hands-on: Write CloudFormation templates for multi-tier apps
- [ ] Lab: Deploy StackSets across multiple accounts
- [ ] Review Notes: `notes/03-deployment-automation.md`

#### Day 24-25: AWS CDK and Elastic Beanstalk
- [ ] Study CDK constructs - L1, L2, L3
- [ ] Learn CDK stacks, apps, and synthesis
- [ ] Understand Elastic Beanstalk environments and deployment options
- [ ] Study Beanstalk configuration files (.ebextensions)
- [ ] Hands-on: Build infrastructure with CDK
- [ ] Lab: Deploy application with Elastic Beanstalk blue/green

#### Day 26-27: CI/CD Pipelines
- [ ] Study CodePipeline stages, actions, and transitions
- [ ] Learn CodeBuild buildspec.yml and build environments
- [ ] Understand CodeDeploy deployment configurations
- [ ] Study deployment strategies - rolling, blue/green, canary
- [ ] Hands-on: Build end-to-end CI/CD pipeline
- [ ] Lab: Implement blue/green deployment with CodeDeploy

#### Day 28: Week 4 Review and Integration
- [ ] Complete deployment and automation practice questions
- [ ] Build automated infrastructure deployment pipeline
- [ ] Practice CloudFormation troubleshooting

### Week 5: Security and Compliance

#### Day 29-30: IAM and Identity Management
- [ ] Master IAM policies - identity-based, resource-based, permission boundaries
- [ ] Study IAM roles and trust policies
- [ ] Learn cross-account access patterns
- [ ] Understand identity federation with SAML and OIDC
- [ ] Hands-on: Implement least-privilege IAM policies
- [ ] Lab: Configure cross-account access with roles
- [ ] Review Notes: `notes/04-security-compliance.md`

#### Day 31-32: Multi-Account Management
- [ ] Study AWS Organizations - OUs, SCPs, account management
- [ ] Learn AWS Control Tower - landing zones, guardrails
- [ ] Understand AWS Config rules and conformance packs
- [ ] Study auto-remediation with Config and SSM
- [ ] Hands-on: Set up Organizations with SCPs
- [ ] Lab: Configure Config rules with auto-remediation

#### Day 33-34: Security Services
- [ ] Study GuardDuty for threat detection
- [ ] Learn Inspector for vulnerability scanning
- [ ] Understand Macie for sensitive data discovery
- [ ] Study Security Hub for centralized findings
- [ ] Study KMS encryption and key management
- [ ] Hands-on: Configure security monitoring pipeline
- [ ] Lab: Set up Security Hub with integrated services

#### Day 35: Week 5 Review and Practice
- [ ] Complete security practice questions
- [ ] Design defense-in-depth security architecture
- [ ] Practice compliance scenario planning

### Week 6: Networking and Content Delivery

#### Day 36-37: VPC Architecture
- [ ] Study VPC components - subnets, route tables, gateways
- [ ] Learn security groups (stateful) vs NACLs (stateless)
- [ ] Understand VPC endpoints - Gateway and Interface
- [ ] Study VPC Flow Logs for traffic analysis
- [ ] Hands-on: Build multi-tier VPC with public and private subnets
- [ ] Lab: Troubleshoot VPC connectivity issues
- [ ] Review Notes: `notes/05-networking.md`

#### Day 38-39: Connectivity and DNS
- [ ] Study VPN connections - site-to-site and client VPN
- [ ] Learn Direct Connect and virtual interfaces
- [ ] Understand Transit Gateway for hub-and-spoke
- [ ] Study Route 53 routing policies and health checks
- [ ] Hands-on: Configure Route 53 with weighted routing
- [ ] Lab: Set up VPC peering and Transit Gateway

#### Day 40-41: Content Delivery and Edge
- [ ] Study CloudFront distributions, origins, and cache behaviors
- [ ] Learn CloudFront Functions and Lambda@Edge
- [ ] Understand origin failover and origin groups
- [ ] Study Global Accelerator for performance
- [ ] Hands-on: Configure CloudFront with S3 and ALB origins
- [ ] Lab: Implement cache invalidation and TTL strategies

#### Day 42: Week 6 Review and Integration
- [ ] Complete networking practice questions
- [ ] Design global network architecture
- [ ] Practice network troubleshooting scenarios

### Week 7: Cost Optimization and Review

#### Day 43-44: Cost and Performance Optimization
- [ ] Study Cost Explorer - reports, forecasting, recommendations
- [ ] Learn AWS Budgets - alerts, actions, and notifications
- [ ] Understand Trusted Advisor checks and recommendations
- [ ] Study Compute Optimizer for right-sizing
- [ ] Hands-on: Set up cost monitoring and alerting
- [ ] Lab: Implement right-sizing recommendations
- [ ] Review Notes: `notes/06-cost-performance.md`

#### Day 45-46: Comprehensive Practice Exams
- [ ] Take official AWS practice exam
- [ ] Complete third-party practice exams
- [ ] Identify and document weak areas
- [ ] Focus on scenario-based questions
- [ ] Review exam feedback and explanations

#### Day 47-48: Weak Area Remediation
- [ ] Review topics missed in practice exams
- [ ] Re-read relevant notes and documentation
- [ ] Complete additional hands-on labs for weak areas
- [ ] Take targeted practice questions per domain

#### Day 49: Week 7 Review
- [ ] Complete final set of practice questions
- [ ] Review all domain summaries
- [ ] Ensure 75%+ on practice exams

### Week 8: Final Review and Exam Preparation

#### Day 50-51: Full Practice Exams
- [ ] Take timed practice exams under exam conditions
- [ ] Review all incorrect answers with detailed analysis
- [ ] Focus on high-weight domains (Deployment 25%, Monitoring 20%, Security 20%)

#### Day 52-53: Operational Scenario Practice
- [ ] Practice troubleshooting operational scenarios
- [ ] Review CloudFormation error patterns
- [ ] Practice VPC connectivity troubleshooting
- [ ] Review monitoring and alerting patterns

#### Day 54-55: Final Knowledge Consolidation
- [ ] Review all notes and key concepts
- [ ] Review AWS service limits and quotas
- [ ] Practice explaining operational decisions
- [ ] Take final practice exam (target 80%+)

#### Day 56: Pre-Exam Preparation
- [ ] Light review of key concepts only
- [ ] Confirm exam logistics and requirements
- [ ] Prepare exam day materials and environment
- [ ] Get adequate rest and mental preparation

## Daily Study Routine (3-4 hours/day)

### Recommended Schedule
1. **60 minutes**: Read study materials and AWS documentation
2. **90 minutes**: Hands-on labs and practical exercises
3. **45 minutes**: Practice questions and review
4. **15 minutes**: Note-taking and concept reinforcement

### Weekend Extended Sessions (6-8 hours)
1. **2 hours**: Comprehensive lab exercises
2. **2 hours**: Practice exams and detailed review
3. **2 hours**: Operational scenario practice
4. **1-2 hours**: Weak area remediation

## Progress Tracking

### Weekly Milestones
- [ ] Week 1: Master CloudWatch, CloudTrail, and monitoring
- [ ] Week 2: Understand Systems Manager and operational tools
- [ ] Week 3: Implement backup, DR, and HA patterns
- [ ] Week 4: Deploy with CloudFormation, CDK, and CI/CD
- [ ] Week 5: Secure with IAM, Config, and security services
- [ ] Week 6: Configure networking and content delivery
- [ ] Week 7: Optimize costs and complete practice exams
- [ ] Week 8: Ready for exam with 80%+ practice scores

### Practice Exam Targets
- [ ] Week 3 end: Score 60%+ on practice exams
- [ ] Week 5 end: Score 70%+ on practice exams
- [ ] Week 7 end: Score 80%+ on practice exams
- [ ] Week 8 end: Score 85%+ consistently

## Study Resources

**Official:**
- **[SOA-C03 Official Exam Page](https://aws.amazon.com/certification/certified-cloudops-engineer-associate/)** - Registration
- **[AWS Skill Builder](https://skillbuilder.aws/)** - Free training and labs
- **[AWS Documentation](https://docs.aws.amazon.com/)** - Service documentation
- **[AWS Free Tier](https://aws.amazon.com/free/)** - Hands-on practice

---

## Final Exam Checklist

### One Week Before
- [ ] Complete all practice exams with target scores
- [ ] Review weak areas identified in practice
- [ ] Confirm exam appointment and requirements

### Day Before Exam
- [ ] Light review of key concepts
- [ ] Ensure technology setup works (for online proctoring)
- [ ] Prepare identification and workspace
- [ ] Get adequate sleep

### Exam Day
- [ ] Arrive early or log in 30 minutes before
- [ ] Bring required identification documents
- [ ] Stay calm and manage time (2 minutes per question)
- [ ] Read questions carefully and identify key requirements
- [ ] Use elimination strategy for multiple choice
