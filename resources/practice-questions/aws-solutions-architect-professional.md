# AWS Solutions Architect Professional (SAP-C02) Practice Questions

40 scenario-based questions weighted by exam domain.

## Exam Domain Breakdown
| Domain | Weight | Questions |
|--------|--------|-----------|
| Design Solutions for Organizational Complexity | 26% | 10 |
| Design for New Solutions | 29% | 12 |
| Continuous Improvement for Existing Solutions | 25% | 10 |
| Accelerate Workload Migration and Modernization | 20% | 8 |

---

## Domain 1: Design Solutions for Organizational Complexity (Questions 1-10)

### Question 1
**Scenario:** A multinational corporation has AWS accounts in multiple regions managed by different business units. They need to implement a centralized logging solution that aggregates CloudTrail logs from all accounts while ensuring each business unit can only access their own logs. Security team needs access to all logs.

A. Create an S3 bucket in each account and use S3 replication to a central bucket
B. Use AWS Organizations with CloudTrail organization trail to a central S3 bucket, implement bucket policies and IAM roles for access control
C. Deploy CloudWatch Logs agents in each account streaming to a central CloudWatch Logs group
D. Use Amazon Kinesis Data Firehose in each account to stream logs to a central S3 bucket

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** AWS Organizations with organization trails provides native multi-account CloudTrail aggregation to a centralized S3 bucket. Bucket policies can restrict access by account/business unit while IAM roles provide security team cross-account access. Option A requires manual replication setup and doesn't leverage Organizations. Option C doesn't work for CloudTrail logs natively. Option D adds unnecessary complexity and cost.

**Key Concept:** [AWS Organizations CloudTrail](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/creating-trail-organization.html)
</details>

### Question 2
**Scenario:** A company is implementing a multi-account strategy using AWS Control Tower. They need to ensure all new accounts automatically have encryption enabled for EBS volumes, S3 buckets must block public access, and IAM users cannot create access keys. How should they implement these requirements?

A. Create custom AWS Config rules and deploy them using StackSets
B. Implement Service Control Policies (SCPs) at the organization root and preventive guardrails in Control Tower
C. Use AWS Systems Manager Automation documents triggered by account creation events
D. Deploy Lambda functions that run compliance checks after account creation

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Service Control Policies provide preventive controls that cannot be bypassed by any user including root. Control Tower guardrails (both preventive and detective) are designed specifically for this use case. SCPs can deny CreateAccessKey, enforce EBS encryption, and block public S3 access. Config rules (A) are detective, not preventive. Options C and D are reactive, not preventive, and can be bypassed.

**Key Concept:** [AWS Control Tower Guardrails](https://docs.aws.amazon.com/controltower/latest/userguide/guardrails.html)
</details>

### Question 3
**Scenario:** A financial services company needs to share specific AMIs and AWS License Manager configurations with partner organizations while maintaining strict access controls. They want to track which partners use which resources and revoke access immediately if needed.

A. Make AMIs public and share license configurations via S3
B. Use AWS Resource Access Manager (RAM) with resource shares to specific AWS accounts
C. Copy AMIs to partner accounts using cross-account AMI copy permissions
D. Create an AWS Marketplace private listing for the AMIs

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** AWS RAM allows sharing resources like AMIs and License Manager configurations with specific accounts or Organizations. It provides centralized management, usage tracking via CloudTrail, and immediate revocation capability. Public AMIs (A) have no access control. Cross-account copy (C) transfers ownership and prevents revocation. Marketplace (D) is for selling, not controlled sharing.

**Key Concept:** [AWS Resource Access Manager](https://docs.aws.amazon.com/ram/latest/userguide/what-is.html)
</details>

### Question 4
**Scenario:** An enterprise is migrating to AWS and needs to establish network connectivity between their on-premises data centers and 50+ VPCs across 10 AWS accounts. They require transitive routing between VPCs, consistent network policies, and centralized traffic inspection.

A. Create VPC peering connections between all VPCs and VPN connections to on-premises
B. Deploy AWS Transit Gateway with RAM sharing, attach VPCs and VPN/Direct Connect, and use Transit Gateway route tables
C. Use AWS PrivateLink to connect all VPCs with a hub-and-spoke model
D. Implement a transit VPC pattern using EC2-based VPN appliances

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Transit Gateway provides transitive routing, scales to thousands of VPCs, supports RAM sharing across accounts, and integrates with Direct Connect and VPN. Route tables enable segmentation and policy enforcement. Centralized inspection is possible via appliance mode. VPC peering (A) doesn't support transitive routing and doesn't scale (50 VPCs = 1,225 peering connections). PrivateLink (C) is for service endpoints, not general routing. Transit VPC (D) is legacy pattern with scalability limits.

**Key Concept:** [AWS Transit Gateway](https://docs.aws.amazon.com/vpc/latest/tgw/what-is-transit-gateway.html)
</details>

### Question 5
**Scenario:** A company has implemented AWS Organizations with multiple OUs. The security team needs to ensure that specific sensitive workloads can only be deployed in approved regions (us-east-1 and eu-west-1) while other workloads can use any region. How should they implement this?

A. Use IAM policies attached to all users to restrict region access
B. Create separate OUs for sensitive workloads and attach SCPs that deny actions outside approved regions
C. Implement AWS Config rules to detect and auto-remediate non-compliant resources
D. Use VPC endpoints to restrict API calls to specific regions

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** SCPs attached to specific OUs provide preventive guardrails that cannot be bypassed. Resources requiring region restrictions go in the restricted OU, while other workloads go in unrestricted OUs. IAM policies (A) can be modified by account admins. Config rules (C) are detective/reactive, not preventive. VPC endpoints (D) don't restrict regions.

**Key Concept:** [SCP Region Restriction](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples_general.html)
</details>

### Question 6
**Scenario:** A global company needs to implement identity federation for 50,000 employees across multiple AWS accounts. They use Microsoft Active Directory on-premises and require single sign-on with role-based access. Users should not need separate AWS credentials.

A. Create IAM users in each AWS account synchronized with Active Directory
B. Use AWS IAM Identity Center (SSO) with Active Directory Connector, configure permission sets mapped to AD groups
C. Implement SAML 2.0 federation directly with each AWS account's IAM
D. Deploy AWS Directory Service for Microsoft AD and create IAM roles with trust policies

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** IAM Identity Center provides centralized SSO for multi-account environments in AWS Organizations. AD Connector integrates with existing on-premises AD without synchronization. Permission sets define access levels and can be mapped to AD groups, automatically creating roles in target accounts. Creating IAM users (A) defeats federation purpose. Direct SAML per account (C) doesn't scale to 50+ accounts. AWS Managed AD (D) requires synchronization and more complex role management.

**Key Concept:** [IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html)
</details>

### Question 7
**Scenario:** A company needs to ensure all AWS API calls across their organization are logged, the logs are immutable for 7 years, and alerts are generated for specific high-risk API calls like IAM policy changes. What architecture meets these requirements?

A. Enable CloudTrail in each account with S3 Glacier storage class
B. Create an organization trail with log file validation, S3 Object Lock in compliance mode, and EventBridge rules for high-risk events
C. Use AWS Config to track all API changes with delivery to S3
D. Enable VPC Flow Logs with CloudWatch Logs integration and metric filters

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Organization trail captures all API calls across all accounts in the organization. Log file validation ensures integrity. S3 Object Lock in compliance mode provides immutability that cannot be bypassed even by root. EventBridge integration allows real-time alerting on specific API patterns. CloudTrail per account (A) doesn't provide centralization and Glacier doesn't provide immutability. Config (C) tracks resource changes, not all API calls. VPC Flow Logs (D) are for network traffic, not API calls.

**Key Concept:** [CloudTrail Log File Integrity](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-log-file-validation-intro.html)
</details>

### Question 8
**Scenario:** A healthcare company needs to provide third-party auditors temporary access to specific AWS resources for compliance reviews. Auditors should have read-only access to CloudTrail logs, Config resources, and IAM policies. Access must be time-limited and fully audited.

A. Create IAM users with temporary passwords that expire
B. Use IAM roles with cross-account trust, implement STS AssumeRole with session duration limits, and require MFA
C. Share AWS credentials through a secrets manager with automatic rotation
D. Create a separate auditor AWS account with resource replication

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Cross-account IAM roles with AssumeRole provide secure, temporary, time-limited access. MFA requirement adds security. All access is logged via CloudTrail. Session duration can be limited (1-12 hours). The role policy restricts to read-only on specific services. IAM users (A) provide permanent credentials. Shared credentials (C) cannot be individually tracked. Separate account (D) requires data replication and adds complexity.

**Key Concept:** [Cross-Account IAM Roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_cross-account-with-roles.html)
</details>

### Question 9
**Scenario:** A company is implementing a data lake architecture where the data engineering team needs to manage Glue jobs and Athena queries, while data scientists need read access to query results but cannot modify data pipelines. Both teams work across 5 AWS accounts. How should permissions be structured?

A. Create IAM users in each account with appropriate policies
B. Use AWS Lake Formation with tag-based access control and IAM Identity Center for cross-account access with different permission sets
C. Implement resource-based policies on each Glue database and S3 bucket
D. Deploy a central data lake account and require all access through that account only

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Lake Formation provides centralized governance for data lakes with fine-grained access control using tags. It simplifies managing permissions across Glue, Athena, and S3. IAM Identity Center with permission sets enables role-based access across multiple accounts. Data engineers get data administrator permissions while scientists get data analyst permissions. Individual IAM users (A) don't scale. Resource policies (C) are complex to manage across many resources. Single account (D) creates bottlenecks and doesn't leverage Organizations benefits.

**Key Concept:** [AWS Lake Formation](https://docs.aws.amazon.com/lake-formation/latest/dg/how-it-works.html)
</details>

### Question 10
**Scenario:** An organization wants to implement a tagging strategy across all AWS accounts to enable cost allocation, resource management, and compliance tracking. They need to ensure all resources have required tags and prevent creation of untagged resources.

A. Create Lambda functions that terminate untagged resources
B. Implement tag policies in AWS Organizations and use SCPs to require tags on resource creation
C. Use AWS Config rules to detect untagged resources
D. Deploy CloudFormation hooks to validate tags

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Tag policies define standardized tags across the organization. SCPs can enforce tag requirements at creation time using aws:RequestTag conditions, preventing untagged resources from being created. This is preventive rather than reactive. Lambda termination (A) is destructive and reactive. Config rules (C) are detective only. CloudFormation hooks (D) only work for CloudFormation-deployed resources.

**Key Concept:** [Tag Policies](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_tag-policies.html)
</details>

---

## Domain 2: Design for New Solutions (Questions 11-22)

### Question 11
**Scenario:** A media company needs to build a video processing pipeline that transcodes uploaded videos into multiple formats. Videos range from 100MB to 50GB. The pipeline should scale automatically, process videos in parallel, and minimize cost for sporadic workloads.

A. Use EC2 Auto Scaling groups with SQS queues for job coordination
B. Implement AWS Elemental MediaConvert triggered by S3 events via Lambda
C. Deploy ECS Fargate tasks triggered by S3 events through EventBridge and Step Functions
D. Use AWS Batch with Fargate compute environment, triggered by S3 events

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** MediaConvert is a fully managed transcoding service designed specifically for video processing. It scales automatically, supports multiple output formats, handles files up to 100GB, and charges only for processing time - ideal for sporadic workloads. EC2 Auto Scaling (A) requires managing infrastructure. ECS Fargate (C) requires building transcoding logic. Batch (D) is better for general compute workloads, not specialized video processing.

**Key Concept:** [AWS Elemental MediaConvert](https://docs.aws.amazon.com/mediaconvert/latest/ug/what-is.html)
</details>

### Question 12
**Scenario:** A financial trading application requires sub-millisecond latency for database reads. The workload is read-heavy (95% reads) with occasional writes. Data must be strongly consistent, and the database should scale automatically based on load.

A. Amazon Aurora with read replicas
B. Amazon DynamoDB with DAX (DynamoDB Accelerator)
C. Amazon ElastiCache for Redis in front of RDS
D. Amazon MemoryDB for Redis

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** DynamoDB provides single-digit millisecond latency with automatic scaling. DAX provides microsecond latency for reads (sub-millisecond) with strong consistency support. This combination handles read-heavy workloads efficiently and scales automatically. Aurora (A) has millisecond latency, not sub-millisecond. ElastiCache (C) adds complexity and eventual consistency concerns. MemoryDB (D) is for Redis-compatible workloads, not purpose-built for this pattern.

**Key Concept:** [DynamoDB DAX](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.html)
</details>

### Question 13
**Scenario:** A company is building a serverless application that processes customer orders. Orders must be processed exactly once, processing order doesn't matter, but failed orders should be retried up to 3 times before being moved to a dead-letter queue for manual review.

A. Use SQS Standard queue with Lambda trigger and maxReceiveCount of 3
B. Use SQS FIFO queue with Lambda trigger and redrive policy
C. Use SNS with SQS subscription and Lambda
D. Use Kinesis Data Streams with Lambda and checkpointing

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** SQS Standard queue with Lambda provides at-least-once delivery. Lambda automatically retries failed invocations. Setting maxReceiveCount to 3 in the redrive policy moves messages to DLQ after 3 failures. Since order doesn't matter, FIFO isn't needed. SQS Standard with visibility timeout handles concurrent processing. FIFO (B) has lower throughput and adds ordering overhead not needed. SNS (C) doesn't have built-in retry with DLQ for Lambda. Kinesis (D) is for streaming data, not job queues.

**Key Concept:** [SQS Dead-Letter Queues](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html)
</details>

### Question 14
**Scenario:** A company needs to build an API that receives webhook calls from 200+ third-party services. Each webhook type requires different processing logic. The API must handle traffic spikes of 100,000 requests per second and maintain high availability.

A. Use Application Load Balancer with EC2 Auto Scaling group running the processing logic
B. Use API Gateway with Lambda integration, using Lambda aliases for different webhook types
C. Use API Gateway HTTP API with Lambda integration using dynamic routing based on path parameters
D. Use CloudFront with Lambda@Edge for initial processing and SQS for backend processing

<details>
<summary>Answer</summary>

**Correct: C**

**Why:** API Gateway HTTP APIs are optimized for webhooks with lower latency and cost than REST APIs. Dynamic routing based on path parameters (e.g., /webhook/{service}) routes to the appropriate Lambda function. Lambda scales automatically to handle spikes. API Gateway handles 100,000+ requests/second. ALB with EC2 (A) requires capacity planning. Lambda aliases (B) are for versions, not routing. Lambda@Edge (D) has 5-second execution limit and regional limitations.

**Key Concept:** [API Gateway HTTP APIs](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api.html)
</details>

### Question 15
**Scenario:** A healthcare company needs to build a patient portal that stores sensitive PHI data. The application must encrypt data at rest and in transit, use customer-managed encryption keys, allow key rotation without re-encrypting data, and provide detailed audit logs of all key usage.

A. Use S3 with SSE-S3 encryption and enable versioning
B. Use S3 with SSE-KMS using customer-managed CMK, enable automatic key rotation, and CloudTrail logging
C. Use S3 with SSE-C (customer-provided keys)
D. Use S3 with client-side encryption using AWS Encryption SDK

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** SSE-KMS with customer-managed CMK provides AWS-managed encryption with customer key control. Automatic key rotation rotates the backing key annually without re-encrypting data (data keys remain valid). CloudTrail logs all KMS API calls including key usage. SSE-S3 (A) uses AWS-managed keys without customer control. SSE-C (C) requires managing keys externally and doesn't support automatic rotation. Client-side encryption (D) adds complexity and doesn't provide native audit logging.

**Key Concept:** [KMS Key Rotation](https://docs.aws.amazon.com/kms/latest/developerguide/rotate-keys.html)
</details>

### Question 16
**Scenario:** A company is building a machine learning inference pipeline that needs to process images in real-time. The model requires GPU acceleration, requests are variable (10-10,000 per minute), and they want to minimize costs during low-traffic periods.

A. Deploy on EC2 P3 instances with Auto Scaling based on queue depth
B. Use SageMaker real-time inference endpoints with auto-scaling
C. Use SageMaker serverless inference endpoints
D. Deploy on ECS with GPU task definitions and Fargate

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** SageMaker real-time endpoints support GPU instances (ml.g4dn, ml.p3) with automatic scaling based on invocations. This handles variable traffic efficiently. During low traffic, endpoints scale down (minimum 1 instance). EC2 (A) requires managing infrastructure. Serverless inference (C) doesn't support GPU and has cold start limitations. ECS Fargate (D) doesn't support GPU instances - only EC2 launch type supports GPU.

**Key Concept:** [SageMaker Real-time Inference](https://docs.aws.amazon.com/sagemaker/latest/dg/realtime-endpoints.html)
</details>

### Question 17
**Scenario:** A retail company needs to implement a real-time recommendation engine that processes clickstream data from their website. The engine should provide recommendations within 100ms, handle 50,000 events per second, and recommendations should update based on the last hour of user activity.

A. Use Kinesis Data Streams with Lambda for processing and DynamoDB for serving recommendations
B. Use Kinesis Data Firehose to S3, Athena for processing, and ElastiCache for serving
C. Use Amazon Personalize with real-time event ingestion
D. Use MSK (Kafka) with Flink for processing and OpenSearch for serving

<details>
<summary>Answer</summary>

**Correct: C**

**Why:** Amazon Personalize is purpose-built for real-time recommendations. It handles real-time event ingestion, automatically updates models based on recent activity, and provides recommendations via API with low latency. It's managed and doesn't require ML expertise. Kinesis+Lambda+DynamoDB (A) requires building recommendation logic. Firehose+Athena (B) has high latency. MSK+Flink (D) requires significant ML engineering.

**Key Concept:** [Amazon Personalize](https://docs.aws.amazon.com/personalize/latest/dg/what-is-personalize.html)
</details>

### Question 18
**Scenario:** A company is designing a multi-tier web application. The web tier must handle SSL termination, the application tier runs containers that scale based on CPU, and the database tier requires automatic failover. All communication between tiers must be encrypted.

A. CloudFront → ALB → ECS Fargate → RDS Multi-AZ with SSL connections
B. CloudFront → NLB → EC2 Auto Scaling → Aurora Serverless
C. ALB → EKS → DynamoDB
D. API Gateway → Lambda → Aurora Global Database

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** CloudFront provides edge SSL termination and caching. ALB terminates HTTPS and can re-encrypt to ECS. Fargate automatically scales containers based on CPU/memory. RDS Multi-AZ provides automatic failover. SSL/TLS can be enabled on all connections (ALB→ECS via HTTPS, ECS→RDS via SSL). NLB (B) doesn't terminate SSL. DynamoDB (C) isn't mentioned as a requirement and changes the architecture. Lambda (D) isn't container-based as specified.

**Key Concept:** [End-to-End Encryption](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html)
</details>

### Question 19
**Scenario:** A company needs to build a disaster recovery solution for their critical application. The application runs on EC2 with data in EBS volumes and RDS databases. RTO is 15 minutes and RPO is 5 minutes. Cost optimization is important.

A. Pilot light with AMIs, automated EBS snapshots every 5 minutes, and RDS read replica in DR region
B. Warm standby with smaller EC2 instances, RDS cross-region read replica, and automated failover scripts
C. Multi-site active-active with Route 53 health checks
D. Backup and restore with daily EBS snapshots and RDS automated backups

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Warm standby meets 15-minute RTO (scale up running instances) and 5-minute RPO (cross-region read replica has near-real-time replication). Smaller instances reduce cost while maintaining quick recovery. Pilot light (A) typically has 15-30 minute RTO for starting instances. Multi-site (C) exceeds requirements and is expensive. Backup/restore (D) has hours of RTO/RPO.

**Key Concept:** [DR Strategies](https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/disaster-recovery-options-in-the-cloud.html)
</details>

### Question 20
**Scenario:** A company needs to implement a search solution for 500 million product documents with faceted search, typo tolerance, and results ranked by relevance and recency. Search latency must be under 200ms.

A. Amazon OpenSearch Service with index lifecycle management
B. Amazon CloudSearch
C. Amazon Kendra
D. DynamoDB with Global Secondary Indexes

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** OpenSearch (Elasticsearch) excels at full-text search with faceting, typo tolerance (fuzzy matching), and custom relevance scoring. It handles hundreds of millions of documents with proper sharding. Index lifecycle management handles document aging for recency ranking. CloudSearch (B) has limited scalability and features. Kendra (C) is for enterprise search with AI, not product catalogs. DynamoDB (D) doesn't support full-text search or relevance ranking.

**Key Concept:** [Amazon OpenSearch Service](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/what-is.html)
</details>

### Question 21
**Scenario:** A company is building an event-driven architecture where a single order event must trigger inventory updates, notification sends, and analytics recording. Each downstream process must receive the event independently and process it at their own pace.

A. Use SQS with multiple consumers reading from the same queue
B. Use SNS with SQS subscriptions for each downstream service (fanout pattern)
C. Use EventBridge with multiple targets
D. Use Kinesis Data Streams with multiple consumers

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** SNS fanout to SQS provides independent queues for each service. Each service processes at its own pace without affecting others. Failed processing in one queue doesn't impact others. Messages are durable in SQS. Single SQS queue (A) means only one consumer processes each message. EventBridge (C) works but SQS subscriptions provide better durability and retry handling. Kinesis (D) is for streaming data with ordering requirements, not independent processing.

**Key Concept:** [SNS Fanout Pattern](https://docs.aws.amazon.com/sns/latest/dg/sns-common-scenarios.html)
</details>

### Question 22
**Scenario:** A startup is building a SaaS application with unpredictable traffic patterns. They need a relational database that scales automatically during traffic spikes and scales to zero during inactive periods to minimize cost. The database must be PostgreSQL-compatible.

A. RDS PostgreSQL with provisioned IOPS
B. Aurora PostgreSQL with Auto Scaling read replicas
C. Aurora Serverless v2 PostgreSQL
D. Amazon Redshift Serverless

<details>
<summary>Answer</summary>

**Correct: C**

**Why:** Aurora Serverless v2 scales instantly based on load (0.5 to 128 ACUs), handles traffic spikes automatically, and scales down during low activity. It's PostgreSQL-compatible and fully managed. While it doesn't scale to absolute zero, it scales to minimal capacity (0.5 ACU). RDS (A) requires manual scaling. Aurora with read replicas (B) requires provisioned capacity. Redshift (D) is for analytics, not OLTP.

**Key Concept:** [Aurora Serverless v2](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.html)
</details>

---

## Domain 3: Continuous Improvement for Existing Solutions (Questions 23-32)

### Question 23
**Scenario:** A company's application on EC2 is experiencing intermittent performance issues. They need to identify whether the issue is CPU, memory, disk I/O, or network related. The solution should not require installing additional agents.

A. Enable detailed CloudWatch monitoring and analyze metrics
B. Use CloudWatch Application Insights
C. Enable AWS X-Ray tracing
D. Use EC2 Instance Connect for real-time debugging

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Detailed CloudWatch monitoring provides 1-minute metric resolution for EC2 (CPU, disk, network) without agents. However, for memory metrics, the CloudWatch agent IS required. Given the constraint of no additional agents, detailed monitoring provides CPU, disk, and network insights. Option B requires agent installation. X-Ray (C) is for distributed tracing, not system metrics. Instance Connect (D) is for SSH access, not monitoring.

**Key Concept:** [CloudWatch EC2 Metrics](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/viewing_metrics_with_cloudwatch.html)
</details>

### Question 24
**Scenario:** A company's Lambda function is experiencing high latency on cold starts, affecting user experience. The function uses a 512MB memory configuration and connects to RDS through VPC. They want to reduce cold start latency without over-provisioning.

A. Increase memory to 10GB
B. Use provisioned concurrency based on traffic patterns
C. Move the database connection outside the handler
D. Use Lambda SnapStart for Java functions

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Provisioned concurrency keeps functions initialized and ready, eliminating cold starts. It can be scheduled based on traffic patterns to optimize cost. Memory increase (A) helps but doesn't eliminate cold starts. Connection pooling (C) is a best practice but doesn't address cold starts. SnapStart (D) is Java-only and the scenario doesn't specify Java.

**Key Concept:** [Lambda Provisioned Concurrency](https://docs.aws.amazon.com/lambda/latest/dg/provisioned-concurrency.html)
</details>

### Question 25
**Scenario:** A company's S3 bucket costs have increased significantly. Analysis shows they have 50TB of data with lifecycle patterns: 20% accessed weekly, 30% accessed monthly, and 50% not accessed in the past year. How should they optimize costs?

A. Enable S3 Intelligent-Tiering on all objects
B. Create lifecycle rules: Standard for 30 days, Standard-IA for 60 days, Glacier for older
C. Use S3 Storage Lens to identify and manually move objects
D. Enable S3 Intelligent-Tiering with Archive Access tiers

<details>
<summary>Answer</summary>

**Correct: D**

**Why:** S3 Intelligent-Tiering with Archive Access tier automatically moves objects between tiers based on actual access patterns - no lifecycle rules to manage. The archive tier handles the 50% not accessed in a year. There's no retrieval fee for Intelligent-Tiering. Fixed lifecycle rules (B) may not match actual access patterns. Storage Lens (C) provides visibility but requires manual action. Basic Intelligent-Tiering (A) doesn't include archive tier.

**Key Concept:** [S3 Intelligent-Tiering](https://docs.aws.amazon.com/AmazonS3/latest/userguide/intelligent-tiering.html)
</details>

### Question 26
**Scenario:** A company's RDS MySQL database is experiencing slow query performance. They've identified that read traffic is 80% of the load. They want to improve read performance without application code changes.

A. Create read replicas and update connection strings in application
B. Enable RDS Proxy to automatically distribute read traffic
C. Add an ElastiCache layer and update application to use cache-aside pattern
D. Migrate to Aurora MySQL for better read scaling

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** While read replicas require updating connection strings (minimal change), this is simpler than other options and doesn't require code logic changes - just configuration. RDS Proxy (B) doesn't automatically route read traffic to replicas; applications must explicitly connect to the read endpoint. ElastiCache (C) requires code changes for cache-aside pattern. Aurora migration (D) is a larger undertaking.

**Key Concept:** [RDS Read Replicas](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html)
</details>

### Question 27
**Scenario:** A company is running a monolithic application on a single large EC2 instance. They want to improve availability and enable zero-downtime deployments without re-architecting to microservices.

A. Deploy to larger instance type for redundancy
B. Create an AMI and deploy behind an ALB with Auto Scaling group (min: 2)
C. Use EC2 instance recovery to handle failures
D. Deploy using AWS Elastic Beanstalk with blue-green deployment

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** ALB with Auto Scaling (minimum 2 instances across AZs) provides high availability. Rolling updates or blue-green deployments (via launch templates) enable zero-downtime updates without re-architecting. Larger instance (A) doesn't improve availability. Instance recovery (C) causes downtime during recovery. Elastic Beanstalk (D) works but adds platform complexity; the question asks for improvement without major changes.

**Key Concept:** [Auto Scaling Rolling Updates](https://docs.aws.amazon.com/autoscaling/ec2/userguide/asg-instance-refresh.html)
</details>

### Question 28
**Scenario:** A company's CloudFront distribution is showing a low cache hit ratio (40%). The origin is an S3 bucket with static assets. How can they improve the cache hit ratio?

A. Increase the TTL on all objects
B. Normalize query strings and headers in cache key settings, remove unnecessary query parameters
C. Add more edge locations
D. Enable Origin Shield

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Low cache hit ratio often results from unnecessary query string parameters or headers creating unique cache keys for identical content. Normalizing query strings (sorting, removing unused) and minimizing headers in cache key increases cache hits. TTL increase (A) helps but doesn't address the root cause of cache key fragmentation. Edge locations (C) don't affect hit ratio. Origin Shield (D) adds a caching layer but doesn't fix cache key issues.

**Key Concept:** [CloudFront Cache Key](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/controlling-the-cache-key.html)
</details>

### Question 29
**Scenario:** A company runs batch processing jobs using EC2 Spot Instances. Jobs are frequently interrupted, causing restarts and increased costs. Jobs typically run for 2-4 hours and can checkpoint progress. How can they improve reliability?

A. Switch to On-Demand instances
B. Use Spot Fleet with capacity-optimized allocation strategy and implement checkpointing
C. Use Reserved Instances
D. Switch to AWS Batch with Fargate

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Capacity-optimized allocation strategy selects Spot pools with highest availability, reducing interruptions. Checkpointing allows resuming from last state after interruption instead of full restart. This maintains cost savings while improving reliability. On-Demand (A) and Reserved (C) eliminate cost savings. Fargate (D) can use Spot but has the same interruption risk; the capacity-optimized strategy specifically addresses the interruption problem.

**Key Concept:** [Spot Fleet Allocation Strategy](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-fleet-allocation-strategy.html)
</details>

### Question 30
**Scenario:** A company's DynamoDB table has hot partition issues causing throttling. The table uses user_id as the partition key, and some users generate significantly more traffic than others. How can they resolve this without changing the application significantly?

A. Increase provisioned throughput capacity
B. Add a random suffix to the partition key
C. Use DynamoDB Accelerator (DAX) to absorb hot partition traffic
D. Enable DynamoDB auto scaling with aggressive scale-up settings

<details>
<summary>Answer</summary>

**Correct: C**

**Why:** DAX caches frequently accessed items, absorbing read traffic from hot partitions without application changes. For write-heavy hot partitions, write sharding (B) is better, but that requires application changes. Simply increasing capacity (A) doesn't fix hot partition issues - the partition limit is 3,000 RCU/1,000 WCU regardless of table capacity. Auto scaling (D) doesn't help with partition-level limits.

**Key Concept:** [DynamoDB Hot Partitions](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/bp-partition-key-uniform-load.html)
</details>

### Question 31
**Scenario:** A company needs to improve their disaster recovery testing process. Currently, DR tests require weeks of planning and coordination. They want to automate DR testing to run monthly with minimal manual intervention.

A. Create runbooks in AWS Systems Manager and schedule automation
B. Use AWS Resilience Hub to set up and automate DR testing
C. Write CloudFormation templates for DR infrastructure and use scheduled StackSets
D. Use AWS Backup with cross-region copy and scheduled restore tests

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Resilience Hub provides continuous resilience assessment, generates recovery procedures, and can automate DR testing. It integrates with existing resources and provides recommendations. SSM runbooks (A) require manual creation of DR procedures. CloudFormation (C) requires building DR automation from scratch. AWS Backup (D) handles data backup but not full application DR testing.

**Key Concept:** [AWS Resilience Hub](https://docs.aws.amazon.com/resilience-hub/latest/userguide/what-is.html)
</details>

### Question 32
**Scenario:** A company wants to identify unused and underutilized resources across their AWS accounts to reduce costs. They need recommendations specific to their usage patterns, not generic best practices.

A. Use AWS Trusted Advisor
B. Use AWS Cost Explorer right-sizing recommendations with EC2 metrics
C. Use AWS Compute Optimizer for right-sizing across EC2, Lambda, and EBS
D. Use AWS Cost Anomaly Detection

<details>
<summary>Answer</summary>

**Correct: C**

**Why:** Compute Optimizer analyzes usage patterns and provides specific right-sizing recommendations for EC2, Lambda, EBS, and ECS. It uses machine learning to analyze CloudWatch metrics and provide instance type recommendations. Trusted Advisor (A) provides generic recommendations without deep analysis. Cost Explorer right-sizing (B) is EC2-only and less sophisticated. Cost Anomaly Detection (D) identifies unusual spending, not optimization opportunities.

**Key Concept:** [AWS Compute Optimizer](https://docs.aws.amazon.com/compute-optimizer/latest/ug/what-is-compute-optimizer.html)
</details>

---

## Domain 4: Accelerate Workload Migration and Modernization (Questions 33-40)

### Question 33
**Scenario:** A company needs to migrate 500 VMware virtual machines to AWS within 6 months. They want to minimize downtime during cutover and maintain consistent state between source and target during migration. What approach should they use?

A. Export VMs as OVA files and import using VM Import/Export
B. Use AWS Application Migration Service (MGN) with continuous replication
C. Use AWS Server Migration Service (SMS)
D. Rebuild applications using CloudFormation

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Application Migration Service (MGN) provides continuous block-level replication, keeping target instances synchronized with source until cutover. This minimizes downtime (minutes) and maintains consistency. It supports VMware and 500+ servers. VM Import/Export (A) requires downtime during export/import. SMS (C) is being deprecated in favor of MGN. Rebuilding (D) doesn't leverage existing VMs.

**Key Concept:** [AWS Application Migration Service](https://docs.aws.amazon.com/mgn/latest/ug/what-is-application-migration-service.html)
</details>

### Question 34
**Scenario:** A company is migrating a legacy Oracle database (50TB) to AWS. They want to reduce licensing costs and have flexibility to use open-source databases. The database contains complex PL/SQL stored procedures. What migration approach minimizes risk?

A. Use AWS DMS for direct Oracle to PostgreSQL migration
B. Migrate to Amazon RDS for Oracle first, then use AWS SCT and DMS to convert to Aurora PostgreSQL
C. Export data using Oracle Data Pump and import to PostgreSQL
D. Use AWS DMS with ongoing replication directly to Aurora PostgreSQL

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Two-phase migration reduces risk: first lift-and-shift to RDS Oracle (same engine, quick migration), then convert to PostgreSQL. AWS Schema Conversion Tool (SCT) handles PL/SQL to PL/pgSQL conversion with manual review of complex procedures. DMS handles data migration. Direct conversion (A, D) risks compatibility issues with complex PL/SQL. Data Pump (C) causes extended downtime and doesn't convert code.

**Key Concept:** [AWS Schema Conversion Tool](https://docs.aws.amazon.com/SchemaConversionTool/latest/userguide/CHAP_Welcome.html)
</details>

### Question 35
**Scenario:** A company wants to containerize their legacy .NET Framework application (not .NET Core) running on Windows Server 2012. They want to run it on AWS with minimal changes. What's the best approach?

A. Rewrite the application in .NET Core and deploy to Linux containers on ECS
B. Use AWS App2Container to containerize and deploy to ECS on Windows
C. Deploy to AWS Lambda with container image support
D. Use AWS Elastic Beanstalk with Windows platform

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** App2Container analyzes and containerizes existing .NET Framework applications without code changes. It creates Windows container images and generates ECS task definitions. .NET Framework requires Windows containers, which ECS supports. Rewriting (A) requires significant effort. Lambda (C) doesn't support Windows containers. Elastic Beanstalk (D) doesn't containerize existing applications.

**Key Concept:** [AWS App2Container](https://docs.aws.amazon.com/app2container/latest/UserGuide/what-is-a2c.html)
</details>

### Question 36
**Scenario:** A company is migrating to AWS and needs to discover all applications in their data center, map dependencies, and create migration waves. They have 2,000 servers with unknown interdependencies.

A. Use AWS Application Discovery Service with Agentless Discovery Connector
B. Manually document dependencies using network diagrams
C. Use AWS Application Discovery Service with Discovery Agent for detailed dependency mapping
D. Use AWS Migration Hub Refactor Spaces

<details>
<summary>Answer</summary>

**Correct: C**

**Why:** Discovery Agent provides detailed dependency mapping including process-level network connections, crucial for 2,000 servers with unknown interdependencies. It identifies which servers communicate and should migrate together. Agentless (A) provides less detail (no process-level connections). Manual documentation (B) doesn't scale. Refactor Spaces (D) is for building migration paths, not discovery.

**Key Concept:** [AWS Application Discovery Service](https://docs.aws.amazon.com/application-discovery/latest/userguide/what-is-appdiscovery.html)
</details>

### Question 37
**Scenario:** A company wants to modernize their monolithic e-commerce application. They want to start extracting microservices incrementally while keeping the monolith running. They need to route traffic between old and new services during the transition.

A. Use ALB path-based routing to split traffic between monolith and microservices
B. Use AWS Migration Hub Refactor Spaces to create a strangler fig environment
C. Deploy microservices on separate infrastructure and update DNS
D. Rewrite the entire application as microservices before deploying

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Migration Hub Refactor Spaces is designed for strangler fig pattern, providing infrastructure to route traffic between monolith and microservices during incremental modernization. It manages the transition environment and traffic routing. ALB routing (A) works but requires manual management of the transition. DNS updates (C) cause cutover issues. Full rewrite (D) is high risk and doesn't support incremental migration.

**Key Concept:** [Migration Hub Refactor Spaces](https://docs.aws.amazon.com/migrationhub-refactor-spaces/latest/userguide/what-is-mhub-refactor-spaces.html)
</details>

### Question 38
**Scenario:** A company needs to transfer 100TB of data to AWS for a machine learning project. Their internet connection is 1Gbps but fully utilized by production traffic. They need the data in AWS within 2 weeks.

A. Use AWS DataSync over the internet with bandwidth throttling
B. Order AWS Snowball Edge devices
C. Set up AWS Direct Connect
D. Use S3 Transfer Acceleration

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Snowball Edge can transfer 100TB within the 2-week window (device shipping + local transfer). 1Gbps fully utilized means no bandwidth for online transfer. Direct Connect (C) takes weeks to provision and still needs bandwidth. DataSync (A) and S3 Transfer Acceleration (D) require available internet bandwidth. Calculation: 100TB over 1Gbps = ~10 days of dedicated bandwidth, which isn't available.

**Key Concept:** [AWS Snowball Edge](https://docs.aws.amazon.com/snowball/latest/developer-guide/whatisedge.html)
</details>

### Question 39
**Scenario:** A company is migrating SAP HANA workloads to AWS. The database requires 24TB of memory and high I/O performance. Which EC2 instance type should they use?

A. r5.24xlarge
B. x2idn.metal
C. u-24tb1.metal
D. c5.24xlarge

<details>
<summary>Answer</summary>

**Correct: C**

**Why:** High Memory (u-) instances are designed specifically for SAP HANA with up to 24TB of memory. The u-24tb1.metal provides exactly 24TB RAM and is SAP certified. x2idn (B) maxes out at 4TB memory. r5 (A) maxes out at 768GB. c5 (D) is compute-optimized with limited memory.

**Key Concept:** [SAP on AWS Instance Types](https://docs.aws.amazon.com/sap/latest/general/architecture-guidance-btp-hana-cloud.html)
</details>

### Question 40
**Scenario:** A company has migrated their application to AWS but is still using traditional architecture. They want to adopt well-architected practices. How should they assess their current architecture and identify improvements?

A. Hire AWS Professional Services for an assessment
B. Use AWS Well-Architected Tool to perform a review and implement recommendations
C. Read AWS Well-Architected Framework whitepapers
D. Use AWS Trusted Advisor

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** The Well-Architected Tool provides a structured framework to assess workloads against AWS best practices across all six pillars. It generates specific improvement recommendations with action items. It's self-service and free. Professional Services (A) is expensive for initial assessment. Whitepapers (C) provide knowledge but not workload-specific assessment. Trusted Advisor (D) focuses on specific checks, not comprehensive architectural review.

**Key Concept:** [AWS Well-Architected Tool](https://docs.aws.amazon.com/wellarchitected/latest/userguide/intro.html)
</details>

---

## Answer Key

| Question | Answer | Domain |
|----------|--------|--------|
| 1 | B | Organizational Complexity |
| 2 | B | Organizational Complexity |
| 3 | B | Organizational Complexity |
| 4 | B | Organizational Complexity |
| 5 | B | Organizational Complexity |
| 6 | B | Organizational Complexity |
| 7 | B | Organizational Complexity |
| 8 | B | Organizational Complexity |
| 9 | B | Organizational Complexity |
| 10 | B | Organizational Complexity |
| 11 | B | New Solutions |
| 12 | B | New Solutions |
| 13 | A | New Solutions |
| 14 | C | New Solutions |
| 15 | B | New Solutions |
| 16 | B | New Solutions |
| 17 | C | New Solutions |
| 18 | A | New Solutions |
| 19 | B | New Solutions |
| 20 | A | New Solutions |
| 21 | B | New Solutions |
| 22 | C | New Solutions |
| 23 | A | Continuous Improvement |
| 24 | B | Continuous Improvement |
| 25 | D | Continuous Improvement |
| 26 | A | Continuous Improvement |
| 27 | B | Continuous Improvement |
| 28 | B | Continuous Improvement |
| 29 | B | Continuous Improvement |
| 30 | C | Continuous Improvement |
| 31 | B | Continuous Improvement |
| 32 | C | Continuous Improvement |
| 33 | B | Migration & Modernization |
| 34 | B | Migration & Modernization |
| 35 | B | Migration & Modernization |
| 36 | C | Migration & Modernization |
| 37 | B | Migration & Modernization |
| 38 | B | Migration & Modernization |
| 39 | C | Migration & Modernization |
| 40 | B | Migration & Modernization |
