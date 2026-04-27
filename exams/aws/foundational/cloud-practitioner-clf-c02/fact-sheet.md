# AWS Certified Cloud Practitioner (CLF-C02) - Fact Sheet

## Quick Reference

**Exam Code:** CLF-C02
**Duration:** 90 minutes
**Questions:** 65 (50 scored + 15 unscored)
**Format:** Multiple choice and multiple response
**Passing Score:** 700 / 1000
**Cost:** $100 USD
**Validity:** 3 years
**Languages:** English, Japanese, Korean, Simplified Chinese, French, German, Italian, Portuguese, Spanish

**Official resources:**

- **[📖 Official Exam Page](https://aws.amazon.com/certification/certified-cloud-practitioner/)**
- **[📖 Exam Guide PDF](https://d1.awsstatic.com/training-and-certification/docs-cloud-practitioner/AWS-Certified-Cloud-Practitioner_Exam-Guide.pdf)**
- **[📖 Sample Questions](https://d1.awsstatic.com/training-and-certification/docs-cloud-practitioner/AWS-Certified-Cloud-Practitioner_Sample-Questions.pdf)**
- **[📖 AWS Skill Builder Exam Prep](https://skillbuilder.aws/)** - Free official prep
- **[📖 AWS Cloud Practitioner Essentials](https://aws.amazon.com/training/learn-about/cloud-practitioner/)** - Free course

---

## Exam Domains and Weights

| # | Domain | Weight | Approx. scored questions |
|---|---|---|---|
| 1 | Cloud Concepts | 24% | ~12 |
| 2 | Security and Compliance | 30% | ~15 |
| 3 | Cloud Technology and Services | 34% | ~17 |
| 4 | Billing, Pricing, and Support | 12% | ~6 |

---

## Domain 1 - Cloud Concepts (24%)

### Cloud computing benefits

- **Trade capital expense for variable expense** (CapEx → OpEx)
- **Benefit from massive economies of scale**
- **Stop guessing capacity** (provision what you need, scale up/down)
- **Increase speed and agility** (resources in minutes, not weeks)
- **Stop spending money running and maintaining data centers**
- **Go global in minutes**

### AWS Well-Architected Framework (6 pillars)

| Pillar | Focus |
|---|---|
| **Operational Excellence** | Run and monitor systems; continuous improvement |
| **Security** | Protect data, systems, and assets |
| **Reliability** | Recover from failures; meet customer demand |
| **Performance Efficiency** | Use IT and computing resources efficiently |
| **Cost Optimization** | Avoid unnecessary costs |
| **Sustainability** | Minimize environmental impact |

**[📖 Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)**

### Cloud deployment models

- **Cloud-native (cloud)**: All infrastructure runs in the cloud
- **Hybrid**: Mix of cloud and on-premises with seamless integration (Direct Connect, VPN, AWS Outposts, Storage Gateway)
- **On-premises (private cloud)**: Traditional data center, possibly using cloud-style technologies

### Service models

- **IaaS** (Infrastructure as a Service): EC2, EBS, VPC - you manage OS+
- **PaaS** (Platform as a Service): Elastic Beanstalk, RDS - AWS manages platform
- **SaaS** (Software as a Service): Amazon WorkMail, Chime - end-user app

---

## Domain 2 - Security and Compliance (30%)

### AWS Shared Responsibility Model

- **AWS responsible for security OF the cloud:** physical hardware, hypervisor, networking infrastructure, managed service control planes
- **Customer responsible for security IN the cloud:** OS patching (EC2), IAM users/policies, application code, data encryption configuration, network rules (Security Groups, NACLs)
- **Inherited controls:** physical/environmental controls
- **Shared controls:** patch management (AWS patches managed services; customer patches EC2 OS), configuration management, awareness/training

**[📖 Shared Responsibility Model](https://aws.amazon.com/compliance/shared-responsibility-model/)**

### Identity and Access Management (IAM)

- **Users** - human or programmatic identities (long-term credentials)
- **Groups** - collections of users sharing permissions
- **Roles** - temporary credentials assumed by services or other accounts (preferred over IAM users for AWS-to-AWS auth)
- **Policies** - JSON documents describing permissions (Allow/Deny on Action+Resource+Condition)
- **MFA** - Multi-Factor Authentication; required for root user, recommended for all users

#### IAM best practices

- Lock down the **root account** (use only for billing or absolutely-required tasks). Enable MFA on root.
- Use **IAM Identity Center** (formerly AWS SSO) for human users in multi-account orgs
- Use **roles** instead of access keys for EC2 / Lambda / cross-account
- **Least privilege**: grant minimum permissions needed
- **Rotate credentials** regularly
- Use **IAM Access Analyzer** to identify resources shared externally

### AWS security services

- **AWS Shield** - DDoS protection (Standard is free; Advanced is paid)
- **AWS WAF** - Web Application Firewall (filter HTTP/S traffic)
- **AWS Firewall Manager** - centrally manage firewall rules across accounts
- **Amazon GuardDuty** - threat detection (CloudTrail/VPC Flow Logs/DNS analysis)
- **Amazon Inspector** - automated vulnerability scanning for EC2 / ECR / Lambda
- **Amazon Macie** - PII discovery in S3
- **AWS Security Hub** - aggregator for security findings across services
- **AWS KMS** - managed encryption key service
- **AWS Secrets Manager** - rotate database credentials and API keys
- **AWS CloudHSM** - dedicated hardware security modules (FIPS 140-2 Level 3)
- **AWS Artifact** - on-demand access to AWS compliance reports (SOC, ISO, PCI)

### Compliance

- **Compliance programs**: SOC 1/2/3, PCI DSS, HIPAA, GDPR, FedRAMP, ISO 27001, IRAP, etc.
- **AWS Artifact** is where customers download compliance reports
- AWS publishes a compliance "shared responsibility matrix" per framework

---

## Domain 3 - Cloud Technology and Services (34%)

### Global infrastructure

- **Regions** - geographic areas (e.g., us-east-1). Each Region has multiple AZs.
- **Availability Zones (AZs)** - one or more discrete data centers, isolated from each other but interconnected with low-latency.
- **Edge Locations** - 450+ CloudFront / Route 53 PoPs worldwide for content delivery.
- **Local Zones** - extend a region into a metro area for low-latency to specific cities.
- **Wavelength Zones** - 5G network edge for ultra-low-latency mobile.
- **Outposts** - AWS hardware in your data center, fully managed by AWS.

### Core compute services

- **Amazon EC2** - virtual servers (instances). Instance types (m5.large, c6i.xlarge, etc.), AMIs, Security Groups.
  - **Pricing models**: On-Demand, Reserved (1/3-year, biggest discount when you commit), Spot (up to 90% off, can be interrupted), Savings Plans (flexible commitment), Dedicated Hosts/Instances (compliance / BYOL).
- **AWS Lambda** - serverless functions. Pay per invocation + duration. 15-min max.
- **Amazon ECS / EKS / Fargate** - containers (Docker). ECS = AWS-native. EKS = managed Kubernetes. Fargate = serverless containers (no instance management).
- **AWS Elastic Beanstalk** - PaaS that manages EC2 / Auto Scaling / Load Balancer for your app.
- **AWS Lightsail** - simplified VPS for small workloads.

### Storage services

- **Amazon S3** - object storage. Storage classes: Standard, Standard-IA, One Zone-IA, Intelligent-Tiering, Glacier (Instant/Flexible Retrieval, Deep Archive). Lifecycle policies.
- **Amazon EBS** - block storage attached to EC2. Volume types: gp3 (general-purpose SSD, default), io1/io2 (provisioned IOPS), st1 (throughput HDD), sc1 (cold HDD).
- **Amazon EFS** - managed NFS. Multi-AZ.
- **Amazon FSx** - managed Windows File Server / Lustre / NetApp ONTAP / OpenZFS.
- **AWS Storage Gateway** - hybrid storage to bridge on-prem to S3 / cloud.
- **AWS Backup** - centralized backup across services.

### Database services

- **Amazon RDS** - managed relational DB (MySQL, PostgreSQL, MariaDB, Oracle, SQL Server).
- **Amazon Aurora** - cloud-native MySQL/PostgreSQL-compatible. Higher performance, more expensive than RDS.
- **Amazon DynamoDB** - managed NoSQL key-value/document. Single-digit ms latency.
- **Amazon Redshift** - data warehouse (analytics, OLAP).
- **Amazon ElastiCache** - in-memory cache (Redis or Memcached).
- **Amazon Neptune** - graph database.
- **Amazon DocumentDB** - MongoDB-compatible.
- **Amazon Timestream** - time-series database.

### Networking services

- **Amazon VPC** - virtual private network in AWS. Subnets (public/private), Route Tables, Internet Gateway, NAT Gateway.
- **Security Groups** - stateful firewall at the instance level (allow rules only).
- **Network ACLs** - stateless firewall at the subnet level (allow + deny rules).
- **AWS Direct Connect** - dedicated network connection from on-prem to AWS.
- **AWS Site-to-Site VPN** - encrypted connection over the internet.
- **Amazon Route 53** - DNS service with health checks and traffic policies.
- **Amazon CloudFront** - global CDN.
- **AWS Global Accelerator** - improves availability/performance via AWS global network.
- **Elastic Load Balancing**: ALB (HTTP/S, layer 7), NLB (TCP/UDP, layer 4), GWLB (third-party appliances).

### Management and governance

- **AWS Management Console** - web UI
- **AWS CLI** - command-line tool
- **AWS SDKs** - language-specific (Python boto3, Java, JavaScript, etc.)
- **AWS CloudFormation** - infrastructure as code (JSON/YAML templates)
- **AWS CDK** - infrastructure as code in real programming languages (TypeScript, Python)
- **AWS Systems Manager** - patch management, automation, parameter store
- **AWS Config** - track resource configuration history and compliance
- **AWS CloudTrail** - audit log of all API calls
- **Amazon CloudWatch** - metrics, alarms, dashboards, logs, events
- **AWS Trusted Advisor** - automated checks for cost, security, performance, fault tolerance
- **AWS Health Dashboard** - personalized health view of services and account
- **AWS Organizations** - multi-account management; consolidated billing; Service Control Policies (SCPs)
- **AWS Control Tower** - governance for multi-account environments
- **AWS Service Catalog** - approved service catalog for organizations

### Application integration

- **Amazon SQS** - managed message queue (decoupling)
- **Amazon SNS** - pub/sub notifications (email, SMS, Lambda, SQS, HTTP)
- **Amazon EventBridge** - event bus for SaaS / AWS service integration
- **AWS Step Functions** - workflow orchestration (state machines)
- **Amazon MQ** - managed Apache ActiveMQ / RabbitMQ

### Analytics and AI/ML (high-level recognition)

- **Amazon Athena** - serverless SQL on S3
- **Amazon QuickSight** - BI dashboards
- **AWS Glue** - serverless ETL
- **Amazon Kinesis** - streaming (Data Streams, Firehose, Data Analytics, Video Streams)
- **Amazon SageMaker** - ML platform
- **Amazon Bedrock** - generative AI foundation models
- **Amazon Q** - AI assistant for AWS

### Migration services

- **AWS Migration Hub** - tracks migration progress
- **AWS Application Migration Service (MGN)** - lift-and-shift servers
- **AWS Database Migration Service (DMS)** - migrate databases
- **AWS Schema Conversion Tool (SCT)** - convert DB schemas
- **AWS Snow Family** - Snowcone (small) / Snowball (medium) / Snowmobile (XL) for offline data transfer
- **AWS DataSync** - online bulk file transfer

---

## Domain 4 - Billing, Pricing, and Support (12%)

### Pricing fundamentals

- **Pay-as-you-go** - pay for what you use, when you use it
- **Save when you reserve** - Reserved Instances / Savings Plans for steady workloads (up to 75% off)
- **Pay less by using more** - tiered volume pricing on S3, data transfer, etc.
- **Pay less as AWS grows** - AWS reduces prices as economies of scale improve
- **Custom pricing** - large enterprises can negotiate Enterprise Discount Programs (EDP)

### Free Tier

- **12 months free** (from account creation) - 750 hr/mo of t2.micro/t3.micro EC2, 5 GB S3 Standard, 750 hr RDS, etc.
- **Always free** - 1M Lambda requests/month, 25 GB DynamoDB, 5 GB CloudWatch logs ingestion, etc.
- **Trials** - one-time free trial of specific services (Inspector 90 days, etc.)

### Cost management tools

- **AWS Pricing Calculator** - estimate costs before deploying
- **AWS Cost Explorer** - 13 months historical + 12 months forecast cost views
- **AWS Budgets** - alerts when spend exceeds threshold
- **AWS Cost and Usage Reports (CUR)** - granular hourly billing data delivered to S3
- **AWS Cost Allocation Tags** - cost attribution by team / project / environment
- **AWS Billing Console** - invoices, payment methods, account-level billing settings
- **Consolidated Billing** (AWS Organizations) - one bill for many accounts

### AWS support plans

| Plan | Price | Best for |
|---|---|---|
| **Basic** | Free | All accounts; documentation, whitepapers, AWS re:Post community |
| **Developer** | From $29/mo | Single user; business hours email support; <12-24 hr response |
| **Business** | From $100/mo | Multi-user; 24/7 phone, email, chat; <1-4 hr response; full Trusted Advisor |
| **Enterprise On-Ramp** | $5,500/mo+ | Larger orgs; pool of TAMs; <30-min response on production-down |
| **Enterprise** | $15,000/mo+ | Largest orgs; dedicated TAM; <15-min response on business-critical down |

**Key features by tier:**
- Trusted Advisor: Basic has 7 core checks; Business+ unlocks all checks
- Technical Account Manager (TAM): only Enterprise On-Ramp+ get dedicated TAMs
- Concierge support team: Enterprise only
- Infrastructure Event Management (IEM): Business (paid add-on) + Enterprise (included)

### AWS Marketplace

- Catalog of third-party software with AWS integration
- Charges appear on your AWS bill
- BYOL or pay-per-use options

---

## High-yield exam triggers

- "Pay-as-you-go vs reserved" → Reserved Instances/Savings Plans = best when usage is predictable and steady
- "Up to 90% discount on flexible workloads" → Spot Instances
- "Lift and shift Windows servers to AWS" → AWS Application Migration Service
- "Cheapest way to store rarely accessed archive" → S3 Glacier Deep Archive
- "Web Application Firewall in front of CloudFront/ALB/API Gateway" → AWS WAF
- "DDoS protection" → AWS Shield (Standard free for all; Advanced $$ for higher protection)
- "Centralized identity for multi-account org with SAML SSO" → IAM Identity Center
- "Manage multiple accounts under one bill" → AWS Organizations + Consolidated Billing
- "Audit who did what in AWS" → CloudTrail
- "Track configuration changes" → AWS Config
- "Performance / cost / security / fault tolerance / service limits checks" → Trusted Advisor
- "Storage Gateway types" → File (NFS/SMB), Volume (block via iSCSI), Tape (VTL)

---

## High-yield study facts

1. **6 Well-Architected pillars** - Operational Excellence, Security, Reliability, Performance Efficiency, Cost Optimization, Sustainability
2. **Shared Responsibility Model**: AWS does *security OF the cloud*, customer does *security IN the cloud*
3. **Region vs AZ vs Edge** - Regions contain AZs; AZs are isolated DCs; Edge Locations are CDN/DNS PoPs
4. **EC2 pricing models** - On-Demand, Reserved (1/3-yr), Spot (up to 90% off), Savings Plans, Dedicated Hosts
5. **S3 storage classes** - Standard / Standard-IA / One Zone-IA / Intelligent-Tiering / Glacier Instant / Flexible / Deep Archive
6. **Database options** - RDS (relational), Aurora (cloud-native MySQL/PG), DynamoDB (NoSQL), Redshift (warehouse), ElastiCache (cache), Neptune (graph)
7. **Support plans** - Basic (free) / Developer / Business / Enterprise On-Ramp / Enterprise; TAM only on Enterprise tiers
8. **Trusted Advisor** - 5 categories (cost, security, performance, fault tolerance, service limits); full set requires Business+ support
9. **Free Tier** types - 12-month, Always Free, Trials
10. **Migration tools** - MGN (servers), DMS (databases), DataSync (files), Snow Family (offline bulk)
11. **CloudFront** = CDN; **Route 53** = DNS; **Global Accelerator** = network optimization
12. **VPC components** - Subnets, Route Tables, IGW, NAT Gateway, Security Groups (stateful, instance-level), NACLs (stateless, subnet-level)

---

## What's NOT on the exam

CLF-C02 is foundational - you don't need to:

- Configure specific services hands-on
- Write CloudFormation templates
- Understand IAM policy syntax in detail
- Know specific instance types or pricing in dollars
- Implement networking architectures
- Optimize SQL queries

The exam tests **awareness and identification** - "which service does X" rather than "configure Y."

---

## Hands-on practice priorities

If you can only build a few labs, prioritize:

1. Sign up for a Free Tier account; explore the console
2. Launch an EC2 instance, SSH into it, terminate it
3. Create an S3 bucket; upload a file; set lifecycle policy
4. Create an RDS MySQL DB; connect with a SQL client
5. Set up a billing alarm and a $20 budget
6. Tour the IAM console; create a user with MFA
7. Try AWS Pricing Calculator for a sample architecture

These cover ~80% of practical questions.

---

## Recommended study time

| Background | Estimated Prep Time |
|---|---|
| Existing IT / cloud experience | 2-3 weeks (5-10 hr/wk) |
| Some technical background, no cloud | 4-6 weeks (5-10 hr/wk) |
| New to IT entirely | 8-10 weeks (10-15 hr/wk) |

Most candidates pass with **20-40 total hours of study**. Cloud Practitioner is the entry-level exam and assumes no prior AWS hands-on.

---

## After CLF-C02

Common next steps based on career direction:

- **Solutions architect track**: SAA-C03 (Solutions Architect Associate)
- **Developer track**: DVA-C02 (Developer Associate)
- **Operations track**: SOA-C03 (CloudOps Engineer Associate)
- **Data track**: DEA-C01 (Data Engineer Associate)
- **AI/ML track**: AIF-C01 (AI Practitioner) → MLA-C01 (ML Engineer Associate)
- **Multi-cloud track**: GCP Cloud Digital Leader or Azure AZ-900

The Associate-level certs cover similar breadth but with technical depth.
