# AWS DevOps Engineer Professional (DOP-C02) Practice Questions

40 scenario-based questions weighted by exam domain.

## Exam Domain Breakdown
| Domain | Weight | Questions |
|--------|--------|-----------|
| SDLC Automation | 22% | 9 |
| Configuration Management and IaC | 17% | 7 |
| Resilient Cloud Solutions | 15% | 6 |
| Monitoring and Logging | 15% | 6 |
| Incident and Event Response | 14% | 6 |
| Security and Compliance | 17% | 6 |

---

## Domain 1: SDLC Automation (Questions 1-9)

### Question 1
**Scenario:** A development team wants to implement a CI/CD pipeline that automatically deploys to production after passing tests in staging. However, they need a manual approval gate before production deployment and want to roll back automatically if CloudWatch alarms trigger within 10 minutes of deployment.

A. Use CodePipeline with manual approval action, CodeDeploy with CloudWatch alarms for automatic rollback
B. Use Jenkins with AWS plugins and custom rollback scripts
C. Use CodePipeline with Lambda approval function and CodeDeploy blue/green deployment
D. Use Step Functions to orchestrate deployment with manual approval and rollback logic

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** CodePipeline supports manual approval actions natively. CodeDeploy integrates with CloudWatch alarms to automatically roll back deployments when alarms trigger. This is the AWS-native solution requiring minimal custom code. Jenkins (B) requires managing infrastructure. Lambda approval (C) doesn't provide manual approval UI. Step Functions (D) adds unnecessary complexity.

**Key Concept:** [CodeDeploy Automatic Rollback](https://docs.aws.amazon.com/codedeploy/latest/userguide/deployments-rollback-and-redeploy.html)
</details>

### Question 2
**Scenario:** A company uses CodeCommit for source control. They want to enforce that all commits are GPG-signed and that no one can push directly to the main branch without a pull request review.

A. Configure CodeCommit repository settings to require signed commits
B. Use IAM policies to deny codecommit:GitPush to main branch and implement approval rule templates
C. Set up a Lambda trigger to reject unsigned commits
D. Use AWS Organizations SCP to enforce commit signing

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** CodeCommit approval rule templates enforce pull request reviews. IAM policies can deny direct pushes to specific branches using conditions. While CodeCommit doesn't natively verify GPG signatures, you can use a Lambda trigger on the repository to validate commits. The combination of IAM and approval rules provides the branch protection requested. Option A doesn't exist. SCPs (D) don't have CodeCommit-specific conditions for signing.

**Key Concept:** [CodeCommit Approval Rules](https://docs.aws.amazon.com/codecommit/latest/userguide/approval-rule-templates.html)
</details>

### Question 3
**Scenario:** A team wants to implement automated testing in their pipeline including unit tests, integration tests, and security scanning. Integration tests require a database, and security scanning should check for vulnerabilities in dependencies. What's the most efficient pipeline structure?

A. Run all tests sequentially in a single CodeBuild project
B. Use CodePipeline with parallel actions: CodeBuild for unit tests, CodeBuild with RDS for integration tests, and Amazon Inspector for security scanning
C. Use CodePipeline with parallel actions: CodeBuild for unit/integration tests with LocalStack, and CodeBuild with Snyk/Trivy for dependency scanning
D. Use GitHub Actions for testing and CodePipeline for deployment only

<details>
<summary>Answer</summary>

**Correct: C**

**Why:** Parallel CodeBuild actions run tests concurrently, reducing pipeline time. LocalStack provides local AWS service emulation for integration tests without provisioning real RDS. Dependency scanning tools like Snyk or Trivy in CodeBuild scan package vulnerabilities efficiently. Inspector (B) scans EC2/ECR for vulnerabilities, not dependency manifests. Sequential testing (A) is slow. GitHub Actions (D) doesn't leverage AWS-native tools.

**Key Concept:** [CodePipeline Parallel Actions](https://docs.aws.amazon.com/codepipeline/latest/userguide/actions-create-custom-action.html)
</details>

### Question 4
**Scenario:** A company wants to standardize their CI/CD pipelines across 50 microservices. Each service has similar build, test, and deploy stages but different configuration values. How should they implement this efficiently?

A. Create 50 separate CodePipeline definitions in CloudFormation
B. Use CodePipeline with a single reusable CloudFormation template and parameters for service-specific values
C. Implement CodeCatalyst workflows with reusable workflow templates
D. Create a custom CI/CD framework using Step Functions

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** A parameterized CloudFormation template for CodePipeline allows creating consistent pipelines across services with service-specific values (repo name, build commands, deployment targets) passed as parameters. StackSets or individual stacks can deploy the template. Creating 50 separate definitions (A) causes maintenance burden. CodeCatalyst (C) is newer and may not be available in all scenarios. Step Functions (D) reinvents CI/CD.

**Key Concept:** [CodePipeline CloudFormation](https://docs.aws.amazon.com/codepipeline/latest/userguide/tutorials-cloudformation.html)
</details>

### Question 5
**Scenario:** A development team deploys Lambda functions using SAM. They want to implement canary deployments where 10% of traffic goes to the new version for 10 minutes before full rollout. If errors increase, the deployment should automatically roll back.

A. Use SAM with DeploymentPreference type Canary10Percent10Minutes and configure alarms
B. Use Lambda aliases with manual traffic shifting
C. Deploy two Lambda versions behind API Gateway with weighted routing
D. Use CodeDeploy Lambda deployment with custom deployment configuration

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** SAM DeploymentPreference with Canary10Percent10Minutes automatically configures CodeDeploy for Lambda with 10% traffic shift for 10 minutes. Alarms configuration enables automatic rollback on errors. This is the simplest solution using SAM's built-in capabilities. Manual aliases (B) don't automate rollback. API Gateway weighting (C) requires manual configuration. Custom CodeDeploy (D) is more complex than using SAM's built-in preference.

**Key Concept:** [SAM Gradual Deployments](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/automating-updates-to-serverless-apps.html)
</details>

### Question 6
**Scenario:** A team needs to deploy an application to both development and production accounts. The pipeline runs in a central DevOps account. They want to use the same pipeline definition but deploy to different accounts based on the branch (develop → dev account, main → prod account).

A. Create separate pipelines for each account
B. Use CodePipeline with cross-account roles, branch-based triggers, and account-specific stages
C. Deploy from local machines using AWS CLI with different profiles
D. Use CodePipeline with account ID as a parameter that changes per deployment

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** CodePipeline supports cross-account deployments using IAM roles in target accounts. EventBridge can trigger different pipeline executions based on branch. Stages can deploy to different accounts using assumed roles. This provides a single pipeline with branch-based environment targeting. Separate pipelines (A) duplicate configuration. Local deployments (C) don't provide CI/CD. Runtime parameters (D) don't support automatic branch-based routing.

**Key Concept:** [Cross-Account CodePipeline](https://docs.aws.amazon.com/codepipeline/latest/userguide/pipelines-create-cross-account.html)
</details>

### Question 7
**Scenario:** A company wants to implement feature flags that can be changed without redeploying the application. Flags should support gradual rollouts (e.g., 10% of users see new feature) and instant kill switches. What AWS service should they use?

A. Systems Manager Parameter Store with Lambda to manage flag logic
B. AWS AppConfig with feature flags
C. DynamoDB with application-level caching
D. S3 with CloudFront for configuration file distribution

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** AppConfig supports feature flags with percentage-based rollouts, instant updates without deployment, and validation before deployment. It integrates with Lambda, EC2, and ECS. Built-in safeguards prevent bad configurations. Parameter Store (A) doesn't support percentage rollouts natively. DynamoDB (C) requires building flag logic. S3/CloudFront (D) has propagation delays.

**Key Concept:** [AWS AppConfig Feature Flags](https://docs.aws.amazon.com/appconfig/latest/userguide/appconfig-creating-feature-flag-and-feature-flag-configuration-data.html)
</details>

### Question 8
**Scenario:** A team uses CodeBuild for their builds. Build times have increased to 15 minutes, with 5 minutes spent downloading dependencies. How can they reduce build time?

A. Use a larger CodeBuild instance
B. Enable CodeBuild local caching and store dependencies in an S3 cache
C. Pre-install dependencies in a custom Docker image
D. Both B and C

<details>
<summary>Answer</summary>

**Correct: D**

**Why:** Both approaches complement each other. Local caching and S3 caching preserve downloaded dependencies between builds. Custom Docker images with pre-installed dependencies eliminate download time entirely for static dependencies. Dynamic dependencies (specific versions) can be cached. Larger instances (A) don't reduce download time.

**Key Concept:** [CodeBuild Build Caching](https://docs.aws.amazon.com/codebuild/latest/userguide/build-caching.html)
</details>

### Question 9
**Scenario:** A company needs to deploy to an on-premises data center as part of their hybrid CI/CD pipeline. The deployment target is a fleet of Linux servers behind a firewall that cannot accept inbound connections.

A. Install CodeDeploy agent with VPN connection back to AWS
B. Use CodeDeploy on-premises instances with the agent polling for deployments
C. Use Systems Manager Hybrid Activations with Run Command
D. Both B and C are valid approaches

<details>
<summary>Answer</summary>

**Correct: D**

**Why:** Both approaches work for servers that can't accept inbound connections. CodeDeploy agents poll for deployments (outbound only). Systems Manager agents also poll via hybrid activations, enabling Run Command for deployments. Choice depends on existing tooling - CodeDeploy integrates with CodePipeline; SSM provides broader management capabilities.

**Key Concept:** [CodeDeploy On-Premises](https://docs.aws.amazon.com/codedeploy/latest/userguide/instances-on-premises.html)
</details>

---

## Domain 2: Configuration Management and IaC (Questions 10-16)

### Question 10
**Scenario:** A company manages infrastructure across 20 AWS accounts using CloudFormation. They want to ensure all accounts have consistent VPC configurations, security groups, and IAM roles. Updates should roll out to all accounts with failure handling.

A. Manually deploy CloudFormation stacks to each account
B. Use CloudFormation StackSets with automatic deployment to organizational units
C. Use Terraform with multiple provider configurations
D. Create Lambda functions to deploy templates to each account

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** StackSets provide automated deployment to multiple accounts/regions with failure tolerance settings. Integration with AWS Organizations allows automatic deployment to new accounts. Concurrent deployment and rollback capabilities handle failures. Manual deployment (A) doesn't scale. Terraform (C) requires managing state across accounts. Lambda (D) reinvents StackSets functionality.

**Key Concept:** [CloudFormation StackSets](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/what-is-cfnstacksets.html)
</details>

### Question 11
**Scenario:** A team uses CloudFormation for infrastructure. They need to update an RDS instance from db.t3.medium to db.t3.large. The update requires replacement, which would cause data loss. How should they handle this?

A. Add a DeletionPolicy: Snapshot to the RDS resource
B. Create a new RDS instance with the larger size and migrate data manually
C. Use CloudFormation stack policies to prevent replacement
D. Modify the instance directly in the console and update the template

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** DeletionPolicy: Snapshot creates a snapshot before replacement, preserving data. The new instance can restore from this snapshot. Stack policies (C) prevent updates but don't solve the data preservation issue. Manual migration (B) is more complex. Console modifications (D) cause stack drift.

**Key Concept:** [CloudFormation DeletionPolicy](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-attribute-deletionpolicy.html)
</details>

### Question 12
**Scenario:** A team needs to manage secrets used by their CloudFormation-deployed applications. Secrets should be encrypted, rotatable, and not stored in version control. CloudFormation templates should reference secrets without exposing values.

A. Use CloudFormation parameters with NoEcho
B. Store secrets in Secrets Manager and use dynamic references in CloudFormation
C. Encrypt secrets in S3 and reference them in templates
D. Use SSM Parameter Store SecureString with KMS encryption

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Secrets Manager with CloudFormation dynamic references ({{resolve:secretsmanager:secret-id}}) retrieves secrets at deployment time without exposing values in templates or outputs. Secrets Manager supports automatic rotation. NoEcho (A) still requires passing secrets as parameters. S3 encryption (C) doesn't provide rotation. Parameter Store SecureString (D) works but doesn't have automatic rotation.

**Key Concept:** [CloudFormation Dynamic References](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/dynamic-references.html)
</details>

### Question 13
**Scenario:** A company uses AWS CDK for infrastructure. They want to implement a policy that requires all S3 buckets to have encryption and versioning enabled. This should be enforced before deployment, not after.

A. Use AWS Config rules to detect non-compliant buckets
B. Implement CDK Aspects to validate and modify constructs before synthesis
C. Use CloudFormation Guard to validate synthesized templates
D. Both B and C

<details>
<summary>Answer</summary>

**Correct: D**

**Why:** CDK Aspects can traverse the construct tree and validate/modify all S3 buckets before synthesis - adding encryption and versioning automatically or failing synthesis. CloudFormation Guard provides additional validation of synthesized templates as a second layer. Together they provide comprehensive pre-deployment compliance. Config rules (A) are post-deployment.

**Key Concept:** [CDK Aspects](https://docs.aws.amazon.com/cdk/v2/guide/aspects.html)
</details>

### Question 14
**Scenario:** A team wants to implement infrastructure testing. They need to verify that deployed infrastructure matches expected configuration (e.g., security groups have correct rules, instances are in the right subnets). What approach should they use?

A. Use CloudFormation drift detection
B. Implement infrastructure tests using AWS SDK calls in their CI/CD pipeline
C. Use Open Policy Agent (OPA) with Terraform
D. Use AWS Config conformance packs

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Infrastructure tests using AWS SDK (boto3, AWS SDK for JavaScript) in the CI/CD pipeline can verify actual deployed state matches expectations. Tools like Terratest or custom test suites query AWS APIs to validate configuration. Drift detection (A) compares to template, not business requirements. OPA (C) validates plans, not deployed infrastructure. Config (D) monitors compliance over time, not as part of deployment verification.

**Key Concept:** [Infrastructure Testing](https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/implement-infrastructure-tests-for-aws-cdk-applications.html)
</details>

### Question 15
**Scenario:** A company needs to automate AMI creation with security patches applied. AMIs should be tested before promotion to production. The process should run monthly.

A. Use EC2 Image Builder with image pipelines, test components, and distribution settings
B. Create a Lambda function that launches an instance, runs updates, and creates an AMI
C. Use Packer with CodeBuild scheduled by EventBridge
D. Manually update and create AMIs monthly

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** EC2 Image Builder provides managed AMI pipelines with components for installation/configuration, test components for validation, and distribution settings for cross-region/cross-account sharing. Scheduling is built-in. Lambda (B) requires building all logic. Packer (C) works but requires more setup. Manual (D) doesn't automate.

**Key Concept:** [EC2 Image Builder](https://docs.aws.amazon.com/imagebuilder/latest/userguide/what-is-image-builder.html)
</details>

### Question 16
**Scenario:** A team has CloudFormation stacks deployed across multiple regions. They need to update a parameter value (e.g., AMI ID) in all regions atomically. If any region fails, all should roll back.

A. Update stacks sequentially in each region
B. Use StackSets with SEQUENTIAL operation preference
C. Use StackSets with operation preferences for failure tolerance set to 0
D. Use CodePipeline with parallel deploy actions

<details>
<summary>Answer</summary>

**Correct: C**

**Why:** StackSets with failure tolerance of 0 stops operations on first failure. Combined with max concurrent operations, you can control rollout. However, StackSets don't provide atomic rollback across regions - they stop on failure but don't undo completed deployments. For true atomicity, you'd need custom orchestration. Option C is closest to the requirement within AWS native tools.

**Key Concept:** [StackSet Operations](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-concepts.html)
</details>

---

## Domain 3: Resilient Cloud Solutions (Questions 17-22)

### Question 17
**Scenario:** An application runs on EC2 in an Auto Scaling group. During deployments, the ASG scales up with new instances, but old instances must complete in-flight requests before termination (up to 5 minutes). How should this be configured?

A. Set the ASG health check grace period to 5 minutes
B. Use lifecycle hooks with a heartbeat timeout of 5 minutes on instance termination
C. Configure connection draining on the load balancer
D. Both B and C

<details>
<summary>Answer</summary>

**Correct: D**

**Why:** Lifecycle hooks on termination give instances time to complete work. Connection draining on ALB/NLB stops sending new requests to terminating instances while allowing existing connections to complete. Together they ensure graceful shutdown. Health check grace period (A) is for launch, not termination.

**Key Concept:** [ASG Lifecycle Hooks](https://docs.aws.amazon.com/autoscaling/ec2/userguide/lifecycle-hooks.html)
</details>

### Question 18
**Scenario:** A company wants to implement automatic recovery for their application. If the primary region becomes unavailable, traffic should failover to the DR region within 5 minutes. The application is stateless but requires a healthy instance to be running in DR.

A. Use Route 53 health checks with failover routing and maintain a warm standby in DR
B. Use CloudFront with origin failover
C. Implement Global Accelerator with endpoint health checks
D. All of the above can achieve the requirement

<details>
<summary>Answer</summary>

**Correct: D**

**Why:** All three options can provide automatic failover within 5 minutes. Route 53 health checks detect failures and route to DR. CloudFront origin failover switches to secondary origin on errors. Global Accelerator health checks failover to healthy endpoints. Choice depends on existing architecture - Route 53 for DNS-level, CloudFront for CDN-distributed apps, Global Accelerator for TCP/UDP applications needing static IPs.

**Key Concept:** [Route 53 Failover](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover-configuring.html)
</details>

### Question 19
**Scenario:** An application processes messages from SQS. If the application crashes, messages should not be lost and should be reprocessed. If a message fails repeatedly (poison pill), it should be moved aside for investigation. What configuration is needed?

A. Configure visibility timeout longer than processing time and set up a dead-letter queue with maxReceiveCount
B. Use FIFO queue with deduplication
C. Enable long polling
D. Use multiple consumers with message grouping

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Visibility timeout prevents duplicate processing during normal operation. If processing fails (message not deleted), it becomes visible again for retry. After maxReceiveCount failures, the message moves to DLQ for investigation. This handles both crash recovery and poison pills. FIFO (B) is for ordering. Long polling (C) is for efficient polling. Multiple consumers (D) don't address the failure scenario.

**Key Concept:** [SQS Dead-Letter Queues](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html)
</details>

### Question 20
**Scenario:** A company runs stateful containers on ECS. They need to ensure that when a container task fails, a new task is started and can access the same data. Tasks run in Fargate.

A. Use EBS volumes attached to tasks
B. Use EFS file systems mounted to tasks
C. Use S3 for data storage
D. Use instance store volumes

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** EFS provides persistent storage that can be mounted to Fargate tasks. When a task fails and a new one starts, it mounts the same EFS file system and accesses existing data. EBS (A) isn't supported with Fargate. S3 (C) requires application changes for file access patterns. Instance store (D) isn't applicable to Fargate.

**Key Concept:** [ECS with EFS](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/efs-volumes.html)
</details>

### Question 21
**Scenario:** A database application needs to survive an Availability Zone failure without data loss. It uses PostgreSQL and requires synchronous replication. What is the most appropriate AWS service?

A. RDS PostgreSQL with Multi-AZ deployment
B. Aurora PostgreSQL with read replicas
C. RDS PostgreSQL with cross-region read replica
D. Self-managed PostgreSQL on EC2 with synchronous replication

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** RDS Multi-AZ uses synchronous replication to a standby in another AZ. Failover is automatic with no data loss (RPO=0). Aurora (B) uses asynchronous replication to read replicas. Cross-region (C) is asynchronous. Self-managed (D) requires managing replication and failover.

**Key Concept:** [RDS Multi-AZ](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.MultiAZ.html)
</details>

### Question 22
**Scenario:** A company wants to implement chaos engineering to test system resilience. They want to randomly terminate EC2 instances during business hours to verify the application handles failures gracefully.

A. Write a Lambda function triggered by CloudWatch Events to randomly terminate instances
B. Use AWS Fault Injection Simulator (FIS) with EC2 actions
C. Use Systems Manager Automation documents to terminate instances
D. Manually terminate instances periodically

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** AWS FIS is purpose-built for chaos engineering with pre-built actions for EC2, ECS, RDS, and more. It provides guardrails (stop conditions), logging, and integration with CloudWatch. Lambda (A) requires building chaos logic. SSM (C) isn't designed for chaos experiments. Manual (D) isn't repeatable or controlled.

**Key Concept:** [AWS Fault Injection Simulator](https://docs.aws.amazon.com/fis/latest/userguide/what-is.html)
</details>

---

## Domain 4: Monitoring and Logging (Questions 23-28)

### Question 23
**Scenario:** A company needs centralized logging from EC2 instances, Lambda functions, and containers. They want to search logs, create dashboards, and set up alerts when error rates exceed thresholds.

A. Use CloudWatch Logs with Logs Insights, dashboards, and metric filters for alarms
B. Use Elasticsearch (OpenSearch) cluster with Kibana
C. Send all logs to S3 and use Athena for querying
D. Use third-party logging service

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** CloudWatch Logs natively receives logs from all three sources. Logs Insights provides SQL-like queries. Dashboards visualize data. Metric filters create custom metrics from log patterns, enabling alarms on error rates. It's fully managed with no infrastructure to manage. OpenSearch (B) requires cluster management. S3/Athena (C) has higher latency for real-time alerts.

**Key Concept:** [CloudWatch Logs Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AnalyzingLogData.html)
</details>

### Question 24
**Scenario:** A microservices application has high latency issues. The team needs to identify which service is causing the bottleneck. Requests pass through API Gateway, Lambda, and DynamoDB.

A. Enable CloudWatch detailed monitoring on all services
B. Implement AWS X-Ray tracing across all services
C. Add custom logging with timestamps at each service boundary
D. Use CloudWatch ServiceLens

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** X-Ray provides distributed tracing, showing request flow across services with latency at each hop. It identifies bottleneck services with service maps and trace analysis. API Gateway, Lambda, and DynamoDB have native X-Ray integration. ServiceLens (D) uses X-Ray data but X-Ray is the core requirement. Detailed monitoring (A) doesn't show request flow. Custom logging (C) requires correlation effort.

**Key Concept:** [AWS X-Ray](https://docs.aws.amazon.com/xray/latest/devguide/aws-xray.html)
</details>

### Question 25
**Scenario:** A company wants to monitor API Gateway for 4XX and 5XX errors and alert when error rate exceeds 5% of total requests over 5 minutes. How should they configure this?

A. Create CloudWatch alarms on Count metrics for 4XXError and 5XXError
B. Use CloudWatch metric math to calculate error rate: (4XX + 5XX) / Count * 100, create alarm on this expression
C. Enable API Gateway access logging and create metric filters
D. Use CloudWatch Contributor Insights

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** CloudWatch metric math can combine metrics to calculate percentages. The expression (4XXError + 5XXError) / Count * 100 gives error rate. An alarm on this with threshold 5 alerts on the percentage. Simple count alarms (A) don't account for traffic volume. Access logging (C) is for detailed request logs, not metrics. Contributor Insights (D) identifies top contributors, not rates.

**Key Concept:** [CloudWatch Metric Math](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/using-metric-math.html)
</details>

### Question 26
**Scenario:** A company needs to retain CloudWatch Logs for 7 years for compliance. They also need the ability to search recent logs (last 30 days) quickly. How should they configure retention?

A. Set CloudWatch Logs retention to 7 years
B. Set CloudWatch Logs retention to 30 days and create a subscription filter to stream logs to S3 for long-term storage
C. Set CloudWatch Logs retention to never expire
D. Export logs to S3 daily using Lambda

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** 30-day retention in CloudWatch Logs provides fast searching for recent logs. Subscription filter continuously streams to S3 (via Kinesis Firehose) for cost-effective long-term storage with Glacier lifecycle. S3 provides compliance-grade retention at lower cost than CloudWatch Logs. Long CloudWatch retention (A, C) is expensive. Daily exports (D) risk data gaps.

**Key Concept:** [CloudWatch Logs to S3](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/S3Export.html)
</details>

### Question 27
**Scenario:** A company wants to be notified immediately when someone logs into the AWS console as root user or when root credentials are used for API calls.

A. Create an EventBridge rule for AWS Console Sign-in events with root user filter
B. Create a CloudWatch alarm on root user API activity metrics
C. Use GuardDuty to detect root credential usage
D. Create EventBridge rules for both console sign-in and CloudTrail API events filtering for root

<details>
<summary>Answer</summary>

**Correct: D**

**Why:** Root user activity requires monitoring both console sign-in (AWS Console Sign-in event) and API usage (CloudTrail events). EventBridge rules can filter for userIdentity.type = "Root" and trigger SNS notifications. GuardDuty (C) monitors for threats but isn't designed for root user alerting specifically. Single rule (A) misses API usage.

**Key Concept:** [Monitor Root User Activity](https://docs.aws.amazon.com/IAM/latest/UserGuide/cloudtrail-integration.html)
</details>

### Question 28
**Scenario:** A company runs containers on EKS and needs to collect metrics from applications using Prometheus format. They want to visualize metrics in Grafana and store them long-term.

A. Deploy self-managed Prometheus and Grafana on EKS
B. Use Amazon Managed Service for Prometheus (AMP) and Amazon Managed Grafana
C. Use CloudWatch Container Insights with Prometheus metrics collection
D. Both B and C

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** AMP provides managed, scalable Prometheus-compatible service. Amazon Managed Grafana integrates with AMP for visualization. Both are fully managed, eliminating operational overhead of self-managed (A). Container Insights (C) provides container metrics but AMP is better for Prometheus-native workloads.

**Key Concept:** [Amazon Managed Service for Prometheus](https://docs.aws.amazon.com/prometheus/latest/userguide/what-is-Amazon-Managed-Service-Prometheus.html)
</details>

---

## Domain 5: Incident and Event Response (Questions 29-34)

### Question 29
**Scenario:** An Auto Scaling group has instances failing health checks and being replaced repeatedly. The team needs to troubleshoot but instances terminate before they can investigate. How should they approach this?

A. Increase the health check grace period
B. Suspend the ReplaceUnhealthy process, investigate, then resume
C. Remove health checks temporarily
D. SSH into instances before they fail

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Suspending ReplaceUnhealthy stops ASG from terminating unhealthy instances, allowing investigation. After fixing the issue, resume the process. Increasing grace period (A) delays detection but doesn't help investigation. Removing health checks (C) masks the problem. SSH timing (D) is unreliable.

**Key Concept:** [Suspend ASG Processes](https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-suspend-resume-processes.html)
</details>

### Question 30
**Scenario:** A company wants automated incident response when GuardDuty detects cryptocurrency mining activity. The response should isolate the affected instance, create a snapshot for investigation, and notify the security team.

A. Configure GuardDuty to send findings to CloudWatch Events and trigger a Lambda function for remediation
B. Configure GuardDuty to send findings to EventBridge, trigger Step Functions orchestrating remediation actions
C. Manually review GuardDuty findings daily
D. Use Security Hub to aggregate and respond to findings

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** EventBridge (successor to CloudWatch Events for this use case) receives GuardDuty findings. Step Functions orchestrates the multi-step response: modify security group to isolate, create EBS snapshot, send SNS notification. Step Functions provides better error handling and visibility than Lambda alone (A). Manual review (C) is too slow. Security Hub (D) aggregates but doesn't automate response.

**Key Concept:** [GuardDuty with EventBridge](https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_findings_cloudwatch.html)
</details>

### Question 31
**Scenario:** During a production incident, the team needs to quickly roll back an ECS service to the previous task definition version. What's the fastest approach?

A. Update the CloudFormation stack with the previous task definition
B. Use ECS UpdateService API to specify the previous task definition ARN
C. Redeploy through the CI/CD pipeline with previous code version
D. Create a new task definition and update the service

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** UpdateService with previous task definition ARN immediately starts rolling deployment to that version. It's the fastest approach requiring single API call. CloudFormation (A) requires stack update process. CI/CD (C) goes through full pipeline. New task definition (D) is unnecessary when previous version exists.

**Key Concept:** [ECS Rolling Updates](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/deployment-types.html)
</details>

### Question 32
**Scenario:** A company uses Systems Manager to manage their EC2 fleet. They need to automatically patch instances during maintenance windows and roll back if patching causes failures.

A. Use SSM Patch Manager with maintenance windows and patch baselines
B. Create custom SSM documents for patching
C. Use AWS-RunPatchBaseline with automatic rollback on failure
D. Schedule Lambda functions to apply patches

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Patch Manager with maintenance windows automates patching during defined periods. Patch baselines define which patches to apply. Integration with SSM allows compliance reporting. Note: automatic rollback requires custom implementation as Patch Manager doesn't natively rollback - you'd need AMI snapshots or custom automation. Custom documents (B) reinvent Patch Manager. Lambda (D) doesn't leverage SSM capabilities.

**Key Concept:** [SSM Patch Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-patch.html)
</details>

### Question 33
**Scenario:** A DynamoDB table is experiencing throttling. CloudWatch shows consumed capacity exceeding provisioned. The table uses provisioned capacity mode. What immediate action should be taken?

A. Switch to on-demand capacity mode
B. Increase provisioned read/write capacity
C. Enable DynamoDB auto scaling
D. Add a DAX cluster

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Immediately increasing provisioned capacity resolves active throttling. This is the fastest fix for an ongoing incident. Switching to on-demand (A) is an option but requires consideration of cost patterns. Auto scaling (C) helps prevent future issues but doesn't instantly resolve current throttling. DAX (D) helps with reads but takes time to deploy.

**Key Concept:** [DynamoDB Throughput](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.ReadWriteCapacityMode.html)
</details>

### Question 34
**Scenario:** A company needs to create runbooks for common operational tasks like restarting services, clearing caches, and rotating credentials. These should be executable by operators without requiring console access.

A. Create wiki documentation with CLI commands
B. Implement SSM Automation documents with approval workflows
C. Create Lambda functions for each task
D. Use Step Functions state machines

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** SSM Automation documents define runbooks as code. They support approval steps, conditional logic, and execute on target resources without console access. Operators can run them through CLI/API. Wiki docs (A) require manual execution and console access. Lambda (C) requires custom orchestration. Step Functions (D) works but SSM Automation is designed for this use case.

**Key Concept:** [SSM Automation](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-automation.html)
</details>

---

## Domain 6: Security and Compliance (Questions 35-40)

### Question 35
**Scenario:** A company needs to ensure all data at rest is encrypted across their AWS environment. They want automated detection of unencrypted resources and automatic remediation where possible.

A. Use AWS Config rules to detect unencrypted resources and Lambda for remediation
B. Use Security Hub with AWS Foundational Security Best Practices standard
C. Manually audit resources monthly
D. Use SCPs to prevent creation of unencrypted resources

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** AWS Config managed rules detect unencrypted EBS volumes, RDS instances, S3 buckets, etc. SSM Automation or Lambda can remediate by enabling encryption (where possible without recreation). Security Hub (B) detects but doesn't remediate automatically. Manual audits (C) are slow and error-prone. SCPs (D) prevent creation but don't detect existing unencrypted resources.

**Key Concept:** [AWS Config Remediation](https://docs.aws.amazon.com/config/latest/developerguide/remediation.html)
</details>

### Question 36
**Scenario:** A DevOps team needs access to production EC2 instances for troubleshooting but the security team doesn't want to manage SSH keys or open port 22. How should they provide secure access?

A. Use EC2 Instance Connect
B. Use Session Manager with IAM-based access control
C. Set up a bastion host with key management
D. Use AWS Cloud9 for instance access

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Session Manager provides shell access without SSH keys, open ports, or bastion hosts. Access is controlled via IAM policies. All sessions are logged to CloudWatch/S3. No agent installation needed on Amazon Linux 2+. Instance Connect (A) still uses SSH. Bastion (C) requires key management. Cloud9 (D) is for development, not operations.

**Key Concept:** [Session Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html)
</details>

### Question 37
**Scenario:** A CI/CD pipeline needs to deploy to AWS. The pipeline runs on self-hosted runners outside AWS. What's the most secure way to provide AWS credentials to the pipeline?

A. Store AWS access keys in the pipeline's secrets management
B. Use IAM Roles Anywhere with X.509 certificates
C. Store access keys in environment variables
D. Use EC2 instance roles

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** IAM Roles Anywhere allows workloads outside AWS to assume IAM roles using X.509 certificates. No long-lived credentials to manage. Certificate-based authentication is more secure than access keys. Access keys (A, C) are long-lived and can be leaked. Instance roles (D) only work for EC2 instances.

**Key Concept:** [IAM Roles Anywhere](https://docs.aws.amazon.com/rolesanywhere/latest/userguide/introduction.html)
</details>

### Question 38
**Scenario:** A company needs to scan container images for vulnerabilities before deployment. They use ECR for container registry. Scanning should happen automatically when images are pushed.

A. Enable ECR basic scanning on push
B. Enable ECR enhanced scanning with Amazon Inspector
C. Use third-party scanning tools in the CI/CD pipeline
D. Both A and B provide automatic scanning, but B provides deeper analysis

<details>
<summary>Answer</summary>

**Correct: D**

**Why:** Both ECR basic and enhanced scanning trigger on push. Basic scanning uses Clair for CVE detection. Enhanced scanning with Inspector provides deeper OS and programming language vulnerability detection, continuous monitoring, and AWS Security Hub integration. Enhanced is recommended for comprehensive coverage.

**Key Concept:** [ECR Image Scanning](https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-scanning.html)
</details>

### Question 39
**Scenario:** A company needs to rotate database credentials used by applications automatically. Applications run on Lambda and retrieve credentials at runtime. How should they implement this?

A. Store credentials in environment variables and redeploy Lambda when rotating
B. Use Secrets Manager with automatic rotation and Lambda retrieves credentials using the SDK
C. Store credentials in Parameter Store SecureString and rotate manually
D. Use IAM database authentication

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Secrets Manager supports automatic rotation for RDS credentials using Lambda rotation functions. Applications retrieve current credentials at runtime using the Secrets Manager SDK/API, always getting valid credentials even after rotation. Environment variables (A) require redeployment. Parameter Store (C) doesn't have automatic rotation. IAM auth (D) is great when supported but not all databases support it.

**Key Concept:** [Secrets Manager Rotation](https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotating-secrets.html)
</details>

### Question 40
**Scenario:** A company must ensure their AWS environment meets PCI DSS compliance. They need continuous compliance monitoring with evidence collection for auditors.

A. Use AWS Config with PCI DSS conformance pack
B. Hire auditors to manually check compliance quarterly
C. Use AWS Artifact for compliance reports only
D. Implement all controls manually and document

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** AWS Config conformance packs include PCI DSS templates that continuously evaluate resources against PCI requirements. They provide evidence of compliance status over time for auditors. Artifact (C) provides AWS's compliance certifications but not customer environment compliance. Manual approaches (B, D) don't provide continuous monitoring.

**Key Concept:** [AWS Config Conformance Packs](https://docs.aws.amazon.com/config/latest/developerguide/conformance-packs.html)
</details>

---

## Answer Key

| Question | Answer | Domain |
|----------|--------|--------|
| 1 | A | SDLC Automation |
| 2 | B | SDLC Automation |
| 3 | C | SDLC Automation |
| 4 | B | SDLC Automation |
| 5 | A | SDLC Automation |
| 6 | B | SDLC Automation |
| 7 | B | SDLC Automation |
| 8 | D | SDLC Automation |
| 9 | D | SDLC Automation |
| 10 | B | Configuration Management/IaC |
| 11 | A | Configuration Management/IaC |
| 12 | B | Configuration Management/IaC |
| 13 | D | Configuration Management/IaC |
| 14 | B | Configuration Management/IaC |
| 15 | A | Configuration Management/IaC |
| 16 | C | Configuration Management/IaC |
| 17 | D | Resilient Cloud Solutions |
| 18 | D | Resilient Cloud Solutions |
| 19 | A | Resilient Cloud Solutions |
| 20 | B | Resilient Cloud Solutions |
| 21 | A | Resilient Cloud Solutions |
| 22 | B | Resilient Cloud Solutions |
| 23 | A | Monitoring and Logging |
| 24 | B | Monitoring and Logging |
| 25 | B | Monitoring and Logging |
| 26 | B | Monitoring and Logging |
| 27 | D | Monitoring and Logging |
| 28 | B | Monitoring and Logging |
| 29 | B | Incident and Event Response |
| 30 | B | Incident and Event Response |
| 31 | B | Incident and Event Response |
| 32 | A | Incident and Event Response |
| 33 | B | Incident and Event Response |
| 34 | B | Incident and Event Response |
| 35 | A | Security and Compliance |
| 36 | B | Security and Compliance |
| 37 | B | Security and Compliance |
| 38 | D | Security and Compliance |
| 39 | B | Security and Compliance |
| 40 | A | Security and Compliance |
