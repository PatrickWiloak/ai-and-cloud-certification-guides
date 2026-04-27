# AWS Solutions Architect Professional (SAP-C02) Study Plan

## 12-Week Intensive Study Schedule

> **Prerequisites**: AWS Certified Solutions Architect Associate (or equivalent) + 2+ years AWS experience
> **Time Commitment**: 15-20 hours/week
> **Difficulty**: Advanced/Professional Level

---

## Week 1-2: Advanced Compute & Container Strategies

### Week 1: Enterprise Compute Optimization

#### Day 1-2: Advanced EC2 Strategies
- [ ] Deep dive into EC2 purchasing options (Reserved, Savings Plans, Spot Fleet)
- [ ] Study placement groups for HPC and low-latency workloads
- [ ] Master EC2 Instance Store vs. EBS performance trade-offs
- [ ] Learn Dedicated Hosts for licensing compliance
- [ ] Hands-on: Build cost-optimized EC2 architecture with mixed purchasing
- [ ] Lab: Implement Spot Fleet with automatic fallback strategies
- [ ] Review Notes: `compute-containers.md` (EC2 section)

#### Day 3-4: Lambda at Scale
- [ ] Study Lambda concurrency models (reserved, provisioned, unreserved)
- [ ] Learn Lambda@Edge and CloudFront Functions use cases
- [ ] Understand VPC Lambda and PrivateLink patterns
- [ ] Master Lambda performance optimization and cold start mitigation
- [ ] Hands-on: Build multi-region serverless architecture
- [ ] Lab: Implement Lambda with Step Functions for orchestration
- [ ] Review Notes: `compute-containers.md` (Lambda section)

#### Day 5-7: Container Orchestration (ECS/EKS)
- [ ] Compare ECS vs. EKS architectural decisions
- [ ] Study Fargate vs. EC2 launch types for containers
- [ ] Learn EKS networking (VPC CNI, service mesh)
- [ ] Master container image management with ECR
- [ ] Hands-on: Deploy multi-tier application on EKS
- [ ] Lab: Implement blue/green deployment with ECS
- [ ] Lab: Set up EKS with Cluster Autoscaler and HPA
- [ ] Review Notes: `compute-containers.md` (Container section)

### Week 2: Advanced Architecture Patterns

#### Day 8-10: Well-Architected Framework Deep Dive
- [ ] Master all 6 pillars with enterprise scenarios
- [ ] Study multi-account landing zone architectures
- [ ] Learn AWS Control Tower and AWS Organizations patterns
- [ ] Understand Service Control Policies (SCPs) for governance
- [ ] Design multi-region active-active architectures
- [ ] Hands-on: Set up Control Tower with AWS Organizations
- [ ] Lab: Implement multi-account VPC sharing
- [ ] Review Notes: `architecture-pillars.md`

#### Day 11-14: Migration & Modernization
- [ ] Study 7 Rs of migration (Rehost, Replatform, Refactor, etc.)
- [ ] Learn Application Discovery Service and Migration Hub
- [ ] Master Database Migration Service (DMS) patterns
- [ ] Understand AWS Migration Evaluator for cost analysis
- [ ] Study VMware Cloud on AWS for hybrid scenarios
- [ ] Hands-on: Plan and execute a database migration with DMS
- [ ] Lab: Use AWS Application Migration Service (MGN)
- [ ] Practice: Create migration strategy for complex workloads

---

## Week 3-4: Advanced Networking

### Week 3: Complex Networking Architectures

#### Day 15-17: Transit Gateway & Hybrid Connectivity
- [ ] Master Transit Gateway hub-and-spoke architectures
- [ ] Study Transit Gateway route tables and attachments
- [ ] Learn Transit Gateway Connect and SD-WAN integration
- [ ] Understand Direct Connect with VPN failover (active-passive)
- [ ] Study Direct Connect Gateway for multi-region connectivity
- [ ] Hands-on: Build Transit Gateway multi-account network
- [ ] Lab: Configure Direct Connect with LAG and VIF
- [ ] Review Notes: `networking.md` (Transit Gateway section)

#### Day 18-19: Advanced VPC Networking
- [ ] Study VPC peering vs. Transit Gateway vs. PrivateLink
- [ ] Learn VPC endpoint policies and interface endpoints
- [ ] Master IPv6 dual-stack VPC architectures
- [ ] Understand VPC sharing with AWS Resource Access Manager
- [ ] Hands-on: Implement PrivateLink for SaaS applications
- [ ] Lab: Configure VPC endpoints for AWS services
- [ ] Review Notes: `networking.md` (VPC section)

#### Day 20-21: DNS & Content Delivery
- [ ] Master Route 53 routing policies (geoproximity, latency, failover)
- [ ] Study Route 53 Resolver for hybrid DNS
- [ ] Learn CloudFront advanced features (Lambda@Edge, field-level encryption)
- [ ] Understand Global Accelerator for global traffic management
- [ ] Hands-on: Implement multi-region DNS failover with health checks
- [ ] Lab: Configure CloudFront with custom origins and signed URLs
- [ ] Review Notes: `networking.md` (DNS & CDN section)

### Week 4: Security & Compliance

#### Day 22-24: Advanced IAM & Identity
- [ ] Master cross-account IAM roles and trust policies
- [ ] Study IAM permission boundaries and SCPs
- [ ] Learn Attribute-Based Access Control (ABAC)
- [ ] Understand AWS SSO (IAM Identity Center) for workforce access
- [ ] Study Cognito for customer identity scenarios
- [ ] Hands-on: Implement cross-account access with external ID
- [ ] Lab: Set up AWS SSO with SAML federation
- [ ] Review Notes: `security-iam.md` (IAM section)

#### Day 25-27: Security in Depth
- [ ] Study KMS multi-region keys and key policies
- [ ] Learn AWS Secrets Manager rotation strategies
- [ ] Master GuardDuty, Security Hub, and Detective
- [ ] Understand Macie for sensitive data discovery
- [ ] Study AWS Config rules for compliance automation
- [ ] Hands-on: Implement encryption at rest and in transit
- [ ] Lab: Set up Security Hub with automated remediation
- [ ] Lab: Configure GuardDuty with EventBridge integration
- [ ] Review Notes: `security-iam.md` (Security Services section)

#### Day 28: Week 3-4 Review
- [ ] Complete networking and security practice questions
- [ ] Design end-to-end secure multi-account architecture
- [ ] Practice complex troubleshooting scenarios

---

## Week 5-6: Data Management & Analytics

### Week 5: Advanced Storage Solutions

#### Day 29-31: S3 Advanced Features
- [ ] Master S3 lifecycle policies with Intelligent-Tiering
- [ ] Study S3 Replication (CRR, SRR, batch replication)
- [ ] Learn S3 Object Lock and Glacier Vault Lock (compliance)
- [ ] Understand S3 Inventory, Analytics, and Storage Lens
- [ ] Study S3 Select and Athena for query-in-place
- [ ] Hands-on: Implement S3 cross-region replication with encryption
- [ ] Lab: Configure S3 Object Lock for WORM compliance
- [ ] Review Notes: `storage.md` (S3 section)

#### Day 32-33: Hybrid Storage & FSx
- [ ] Study Storage Gateway modes (File, Volume, Tape)
- [ ] Learn FSx for Windows, Lustre, ONTAP, and OpenZFS
- [ ] Understand DataSync for large-scale migrations
- [ ] Master AWS Backup for centralized backup management
- [ ] Hands-on: Configure Storage Gateway with caching strategies
- [ ] Lab: Deploy FSx for Lustre for HPC workloads
- [ ] Review Notes: `storage.md` (Hybrid & FSx section)

#### Day 34-35: Advanced Database Architectures
- [ ] Master RDS Multi-AZ and Read Replica strategies
- [ ] Study Aurora Global Database and Aurora Serverless v2
- [ ] Learn DynamoDB Global Tables and on-demand scaling
- [ ] Understand DynamoDB Streams and DAX caching
- [ ] Study database migration patterns (homogeneous and heterogeneous)
- [ ] Hands-on: Deploy Aurora Global Database with failover
- [ ] Lab: Implement DynamoDB Global Tables with conflict resolution
- [ ] Review Notes: `databases.md`

### Week 6: Data Analytics & Streaming

#### Day 36-38: Real-Time Data Processing
- [ ] Study Kinesis Data Streams vs. Firehose vs. Analytics
- [ ] Learn MSK (Managed Streaming for Kafka) architectures
- [ ] Understand Amazon EMR for big data processing
- [ ] Master AWS Glue for ETL and data catalog
- [ ] Study data lake architectures with Lake Formation
- [ ] Hands-on: Build real-time analytics pipeline with Kinesis
- [ ] Lab: Configure MSK with Schema Registry
- [ ] Review Notes: `integration-streaming.md` (Streaming section)

#### Day 39-41: Data Warehousing & Analytics
- [ ] Master Redshift cluster sizing and distribution strategies
- [ ] Study Redshift Spectrum for query-in-place on S3
- [ ] Learn Athena optimization and partitioning
- [ ] Understand QuickSight for BI dashboards
- [ ] Study data lake architecture patterns
- [ ] Hands-on: Build data warehouse with Redshift
- [ ] Lab: Query S3 data lake with Athena and partition optimization
- [ ] Review Notes: `databases.md` (Analytics section)

#### Day 42: Week 5-6 Review
- [ ] Complete storage and data practice questions
- [ ] Design data lake architecture with governance
- [ ] Practice migration and modernization scenarios

---

## Week 7-8: Integration, Messaging & Orchestration

### Week 7: Event-Driven Architectures

#### Day 43-45: Messaging Patterns
- [ ] Master SQS FIFO vs. Standard queues
- [ ] Study SNS fan-out patterns and message filtering
- [ ] Learn EventBridge for event-driven architectures
- [ ] Understand Amazon MQ for legacy message brokers
- [ ] Study SES for transactional email at scale
- [ ] Hands-on: Implement SQS with dead-letter queues
- [ ] Lab: Build event-driven architecture with EventBridge
- [ ] Review Notes: `integration-streaming.md` (Messaging section)

#### Day 46-48: Orchestration & Workflows
- [ ] Master Step Functions for complex workflows
- [ ] Study saga patterns for distributed transactions
- [ ] Learn SWF for long-running workflows (legacy)
- [ ] Understand AppFlow for SaaS integration
- [ ] Study API Gateway advanced features (caching, throttling, WAF)
- [ ] Hands-on: Build saga pattern with Step Functions
- [ ] Lab: Implement API Gateway with Lambda authorizers
- [ ] Review Notes: `integration-streaming.md` (Orchestration section)

### Week 8: Observability & Operational Excellence

#### Day 49-51: Monitoring & Logging
- [ ] Master CloudWatch Metrics, Logs, and Alarms
- [ ] Study CloudWatch Logs Insights and metric filters
- [ ] Learn X-Ray for distributed tracing
- [ ] Understand Container Insights for ECS/EKS
- [ ] Study centralized logging with CloudWatch cross-account
- [ ] Hands-on: Set up CloudWatch dashboards with composite alarms
- [ ] Lab: Implement X-Ray tracing for microservices
- [ ] Review Notes: `observability.md`

#### Day 52-53: Automation & Infrastructure as Code
- [ ] Master CloudFormation StackSets for multi-account deployments
- [ ] Study CloudFormation macros and custom resources
- [ ] Learn AWS CDK for infrastructure as code
- [ ] Understand Systems Manager for patch management and automation
- [ ] Study OpsWorks and Elastic Beanstalk migration patterns
- [ ] Hands-on: Deploy multi-account infrastructure with StackSets
- [ ] Lab: Build CDK application with custom constructs

#### Day 54-56: Disaster Recovery & Business Continuity
- [ ] Study DR strategies (Backup/Restore, Pilot Light, Warm Standby, Active-Active)
- [ ] Learn RTO and RPO requirements and architectures
- [ ] Master Route 53 health checks and failover routing
- [ ] Understand multi-region deployment patterns
- [ ] Study AWS Backup for centralized DR
- [ ] Hands-on: Implement pilot light DR architecture
- [ ] Lab: Configure multi-region active-active with data replication
- [ ] Practice: Design DR strategy for various RTO/RPO requirements

---

## Week 9-10: Cost Optimization & Governance

### Week 9: Cost Management at Scale

#### Day 57-59: Cost Optimization Strategies
- [ ] Master Cost Explorer and cost allocation tags
- [ ] Study Reserved Instance and Savings Plans strategies
- [ ] Learn Spot Instance best practices and Spot Fleet
- [ ] Understand Compute Optimizer recommendations
- [ ] Study S3 Intelligent-Tiering and storage cost optimization
- [ ] Hands-on: Analyze costs with Cost Explorer and create budgets
- [ ] Lab: Implement rightsizing recommendations from Compute Optimizer
- [ ] Review Notes: `cost-governance.md` (Cost section)

#### Day 60-61: Multi-Account Billing & Chargeback
- [ ] Study AWS Organizations consolidated billing
- [ ] Learn cost allocation tags and cost categories
- [ ] Understand chargeback and showback models
- [ ] Master AWS Budgets with alerts and actions
- [ ] Study Trusted Advisor for cost optimization
- [ ] Hands-on: Set up multi-account cost allocation strategy
- [ ] Lab: Create cost anomaly detection with CloudWatch

#### Day 62-63: Enterprise Governance
- [ ] Master Service Control Policies (SCPs) for guardrails
- [ ] Study AWS Control Tower account factory
- [ ] Learn AWS Config for compliance as code
- [ ] Understand tag policies and resource tagging strategies
- [ ] Study AWS License Manager for software licenses
- [ ] Hands-on: Implement SCPs for security guardrails
- [ ] Lab: Set up AWS Config rules with auto-remediation
- [ ] Review Notes: `cost-governance.md` (Governance section)

### Week 10: Compliance & Regulatory Requirements

#### Day 64-66: Compliance Frameworks
- [ ] Study HIPAA compliance on AWS
- [ ] Learn PCI-DSS requirements and AWS services
- [ ] Understand SOC 2 and ISO 27001 certifications
- [ ] Master FedRAMP and GovCloud requirements
- [ ] Study GDPR data residency and privacy controls
- [ ] Hands-on: Design HIPAA-compliant architecture
- [ ] Lab: Implement PCI-DSS network segmentation
- [ ] Review Notes: `security-iam.md` (Compliance section)

#### Day 67-70: Practice Exams & Review
- [ ] Take full-length practice exam #1 (Tutorials Dojo or Whizlabs)
- [ ] Review all incorrect answers and weak areas
- [ ] Re-study weak domains identified in practice exam
- [ ] Complete additional practice questions on weak areas

---

## Week 11: Integration & Final Preparation

### Day 71-73: Complex Scenario Practice
- [ ] Practice multi-account architecture scenarios
- [ ] Work through hybrid cloud integration scenarios
- [ ] Design migration strategies for enterprise workloads
- [ ] Practice cost optimization at scale scenarios
- [ ] Review all architecture pillars with real-world examples

### Day 74-75: Service Comparisons & Decision Trees
- [ ] Review all "When to use X vs. Y" scenarios
- [ ] Study service comparison matrices
- [ ] Practice making architectural trade-off decisions
- [ ] Review decision trees for complex architectures

### Day 76-77: Official Practice Exam & Review
- [ ] Take AWS Official Practice Exam ($40)
- [ ] Thoroughly review all questions and explanations
- [ ] Identify final weak areas
- [ ] Create focused study plan for remaining gaps

---

## Week 12: Final Week - Intensive Review

### Day 78-79: Domain-Focused Review
- [ ] Review Domain 1: Organizational Complexity (26%)
- [ ] Review Domain 2: New Solutions (29%)
- [ ] Focus on multi-account and hybrid scenarios
- [ ] Practice migration and modernization patterns

### Day 80-81: Weak Area Deep Dive
- [ ] Deep dive into lowest-scoring practice exam areas
- [ ] Re-read notes for weak domains
- [ ] Practice additional questions on weak topics
- [ ] Hands-on labs for services you're least confident with

### Day 82: Full Practice Exam #2
- [ ] Take second full-length practice exam (different provider)
- [ ] Aim for 85%+ score
- [ ] Review any remaining weak areas
- [ ] Make final study notes

### Day 83: Cram Sheet Review
- [ ] Review all cheat sheets and decision trees
- [ ] Study service limits and quotas
- [ ] Review CLI commands and common parameters
- [ ] Practice quick recall of service comparisons

### Day 84: Final Review & Rest
- [ ] Light review of cram sheet only
- [ ] No new learning - trust your preparation
- [ ] Get good sleep
- [ ] Prepare exam environment (ID, quiet space, system test)

---

## 📚 Comprehensive Study Resources

**👉 [Complete AWS Study Resources Guide](../../../../.templates/resources-aws.md)**

For detailed information on courses, practice tests, hands-on labs, communities, and more, see our comprehensive AWS study resources guide.

### Quick Links (SAP-C02 Specific)
- **[SAP-C02 Official Exam Page](https://aws.amazon.com/certification/certified-solutions-architect-professional/)** - Registration and exam details
- **[AWS Skill Builder - SAP-C02 Exam Prep](https://skillbuilder.aws/)** - FREE official exam preparation
- **[AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)** - Essential reading
- **[AWS Whitepapers](https://aws.amazon.com/whitepapers/)** - Migration, security, and architecture guides
- **[AWS Documentation](https://docs.aws.amazon.com/)** - Complete service documentation
- **[AWS Free Tier](https://aws.amazon.com/free/)** - Hands-on practice environment

### Recommended Study Materials (SAP-C02)
- **Adrian Cantrill's SAP-C02 Course** - $40 (Most comprehensive, highly recommended)
- **Tutorials Dojo Practice Exams** - $15 (Best value, 6 full practice tests)
- **AWS Official Practice Exam** - $40 (Most accurate simulation)
- **"AWS Certified Solutions Architect Professional Official Study Guide"** - $50 (Optional)

**Budget:** $95-145 recommended

---

## 📊 Study Progress Tracker

### Domains & Weighting
- [ ] Domain 1: Design for Organizational Complexity (26%) - ~22 questions
- [ ] Domain 2: Design for New Solutions (29%) - ~24 questions
- [ ] Domain 3: Continuous Improvement (25%) - ~21 questions
- [ ] Domain 4: Migration & Modernization (20%) - ~17 questions

### Weekly Milestones
- [ ] Week 1-2: Compute, containers, and architecture patterns ✓
- [ ] Week 3-4: Networking and security mastery ✓
- [ ] Week 5-6: Data management and analytics ✓
- [ ] Week 7-8: Integration, messaging, and observability ✓
- [ ] Week 9-10: Cost optimization and governance ✓
- [ ] Week 11: Practice exams (aim for 75%+) ✓
- [ ] Week 12: Final review (aim for 85%+ on practice) ✓

### Practice Exam Scores
- [ ] Practice Exam 1 (Week 10): ___% (Target: 70%+)
- [ ] Official Practice Exam (Week 11): ___% (Target: 75%+)
- [ ] Practice Exam 2 (Week 12): ___% (Target: 85%+)

---

## 🎯 Exam Day Strategy

### Time Management (180 minutes, 75 questions)
- **Average time per question:** 2.4 minutes
- **First pass:** 90-120 minutes (flag difficult questions)
- **Second pass:** 45-60 minutes (review flagged questions)
- **Final review:** 15-30 minutes (check marked for review)

### Question Approach
1. **Read carefully** - Scenario-based questions can be long
2. **Identify key requirements** - Look for constraints (cost, performance, compliance)
3. **Eliminate wrong answers** - Usually 1-2 are obviously incorrect
4. **Choose best answer** - Not just "correct" but "most correct" for the scenario
5. **Flag and move on** - Don't spend >5 minutes on any question

### Common Traps
- ❌ Over-engineering solutions (choose simplest that meets requirements)
- ❌ Missing keyword constraints ("minimize cost", "highest availability", "compliance")
- ❌ Confusing similar services (FSx variants, Kinesis variants, etc.)
- ❌ Not considering multi-account/multi-region implications
- ❌ Forgetting migration/modernization best practices

---

## 💡 SAP-C02 Pro Tips

### Key Differences from SAA-C03
- **Enterprise scale**: Multi-account, multi-region architectures
- **Complex trade-offs**: Cost vs. performance vs. security vs. complexity
- **Migration focus**: 7 Rs, DMS, MGN, application modernization
- **Governance**: Organizations, Control Tower, SCPs, compliance frameworks
- **Advanced networking**: Transit Gateway, Direct Connect, hybrid architectures
- **Deep service knowledge**: Know the "why" not just the "what"

### High-Yield Study Topics (Based on Exam Frequency)
1. **Multi-account strategies** with AWS Organizations and Control Tower
2. **Transit Gateway** architectures and routing
3. **Direct Connect** with VPN backup and multi-region
4. **Aurora Global Database** and DynamoDB Global Tables
5. **Migration strategies** (7 Rs) and DMS patterns
6. **Cost optimization** (Reserved Instances, Savings Plans, Spot)
7. **Disaster recovery** architectures (RTO/RPO scenarios)
8. **EventBridge** and Step Functions for event-driven
9. **Well-Architected Framework** pillars in complex scenarios
10. **Security in depth** (KMS, encryption, GuardDuty, Security Hub)

### Don't Neglect These Topics
- AWS Backup for centralized backup management
- AWS Resilience Hub for resilience assessments
- AWS Application Migration Service (MGN)
- Route 53 Application Recovery Controller
- AWS DataSync for large-scale data transfer
- AWS Transfer Family for SFTP/FTPS
- CloudFormation StackSets for multi-account IaC

---

## 🏆 Final Checklist (Day Before Exam)

### Knowledge Verification
- [ ] Can design multi-account landing zone architecture
- [ ] Understand all Transit Gateway routing scenarios
- [ ] Know when to use each database service (RDS, Aurora, DynamoDB, etc.)
- [ ] Can explain all migration strategies (7 Rs)
- [ ] Understand cost optimization at scale (Reserved, Savings Plans, Spot)
- [ ] Know disaster recovery architectures (Backup, Pilot Light, Warm Standby, Active-Active)
- [ ] Can design hybrid connectivity (Direct Connect, VPN, hybrid DNS)
- [ ] Understand all messaging patterns (SQS, SNS, EventBridge, Kinesis)

### Logistics
- [ ] System compatibility test completed (Pearson VUE or PSI)
- [ ] Government-issued ID ready (name matches registration exactly)
- [ ] Quiet, clean workspace prepared (no papers, phones, watches)
- [ ] Stable internet connection verified
- [ ] Exam appointment confirmed

### Mental Preparation
- [ ] Reviewed cram sheet and key decision trees
- [ ] Confident in weak areas from practice exams
- [ ] Well-rested (8+ hours sleep night before)
- [ ] Scheduled exam for your peak mental time
- [ ] Calm and ready - you've got this! 🚀

---

**Good luck on your AWS Certified Solutions Architect - Professional journey!** Remember: This certification validates your ability to design complex, enterprise-grade AWS solutions. Take your time with scenarios, think about trade-offs, and trust your preparation. 💪
