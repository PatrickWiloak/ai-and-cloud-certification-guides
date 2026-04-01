# High-Yield Scenarios and Patterns - CloudOps Engineer (SOA-C03)

## Monitoring and Remediation Scenarios

### CloudWatch Alarm Remediation
**Scenario**: An application running on EC2 experiences intermittent CPU spikes causing user-facing latency. The operations team needs automated remediation.

**Solution Pattern**:
- **Detection**: CloudWatch alarm on CPUUtilization > 80% for 5 minutes
- **Notification**: SNS topic sends alert to operations team
- **Remediation**: EventBridge rule triggers SSM Automation runbook
- **Action**: Runbook restarts the application service or adds instances via Auto Scaling

**Common Distractors**:
- Manual SSH to restart (wrong - not automated)
- Lambda function to reboot instance (wrong - SSM Automation is more appropriate for operational tasks)
- CloudWatch Events only (wrong - EventBridge is the current service name, but they are the same)

### Log Analysis and Troubleshooting
**Scenario**: Application errors are increasing but the team cannot identify the root cause. They need centralized log analysis.

**Solution Pattern**:
- **Collection**: CloudWatch agent on EC2 instances sending application logs
- **Analysis**: CloudWatch Logs Insights queries to find error patterns
- **Metrics**: Metric filters to extract error counts from logs
- **Alerting**: CloudWatch alarm on error metric filter

**Common Distractors**:
- SSH into each instance to check logs (wrong - not scalable)
- Send logs only to S3 (wrong - no real-time analysis capability)
- Use X-Ray alone (wrong - X-Ray is for tracing, not log analysis)

### Distributed Tracing
**Scenario**: A microservices application has increased latency but no single service shows issues. The team needs to identify bottlenecks.

**Solution Pattern**:
- **Tracing**: AWS X-Ray SDK instrumented in each microservice
- **Analysis**: X-Ray service map to visualize request flow
- **Identification**: Trace analysis to find slow segments
- **Remediation**: Address specific service or network bottleneck

**Common Distractors**:
- CloudWatch metrics only (wrong - cannot trace across services)
- VPC Flow Logs (wrong - network-level, not application-level)
- CloudTrail (wrong - API auditing, not application performance)

## Reliability and Business Continuity Scenarios

### Multi-AZ High Availability
**Scenario**: A company needs a web application that can survive an AZ failure with minimal downtime.

**Solution Pattern**:
- **Compute**: Auto Scaling Group across 3 AZs with min 2 instances
- **Load Balancing**: ALB with cross-zone load balancing enabled
- **Database**: RDS Multi-AZ with automatic failover
- **Session State**: ElastiCache Redis with Multi-AZ replication

**Common Distractors**:
- Single AZ with larger instances (wrong - no AZ failure protection)
- Manual failover process (wrong - should be automatic)
- Storing sessions on EC2 instances (wrong - sessions lost on failure)

### Disaster Recovery - Pilot Light
**Scenario**: Company needs cross-region DR with RPO of 1 hour and RTO of 30 minutes for a critical database application.

**Solution Pattern**:
- **Primary Region**: Full production stack with RDS Multi-AZ
- **DR Region**: RDS cross-region read replica (always running)
- **Failover**: Route 53 failover routing with health checks
- **Recovery**: Promote read replica, scale up compute in DR region

**Common Distractors**:
- Backup and restore only (wrong - RTO too high for 30-minute requirement)
- Multi-site active-active (wrong - exceeds requirements, too expensive)
- Same-region read replica (wrong - not cross-region DR)

### Auto Scaling Troubleshooting
**Scenario**: Auto Scaling Group is not launching new instances despite high CPU utilization alarms firing.

**Solution Pattern**:
- **Check**: Verify ASG max capacity is not reached
- **Check**: Verify launch template references valid AMI and instance type
- **Check**: Verify IAM role has permissions to launch instances
- **Check**: Verify subnet has available IP addresses
- **Check**: Review ASG activity history for error messages

**Common Distractors**:
- Increase alarm threshold (wrong - alarm is working correctly)
- Change instance type (wrong - investigate root cause first)
- Create new ASG (wrong - troubleshoot existing configuration)

## Deployment and Automation Scenarios

### CloudFormation Stack Update Failure
**Scenario**: A CloudFormation stack update failed and rolled back. The team needs to understand why and fix it.

**Solution Pattern**:
- **Investigation**: Check stack events for error messages
- **Common Causes**: Resource limit exceeded, IAM permissions, resource in use
- **Resolution**: Fix template, create change set to preview, then update
- **Prevention**: Use change sets before every update

**Common Distractors**:
- Delete and recreate stack (wrong - lose existing resources and data)
- Manually create the resource (wrong - breaks IaC management)
- Ignore rollback and proceed (wrong - stack is in ROLLBACK_COMPLETE state)

### Blue/Green Deployment
**Scenario**: Company needs zero-downtime deployments for a web application with the ability to quickly roll back.

**Solution Pattern**:
- **Green Environment**: Deploy new version to separate Auto Scaling Group
- **Testing**: Validate green environment independently
- **Switch**: Update Route 53 weighted record or ALB target group
- **Rollback**: Switch traffic back to blue environment if issues

**Common Distractors**:
- In-place update on running instances (wrong - causes downtime)
- Rolling deployment only (wrong - harder to roll back)
- Replace all instances simultaneously (wrong - causes outage)

### Infrastructure as Code Drift
**Scenario**: Resources managed by CloudFormation have been modified manually. The team needs to detect and remediate drift.

**Solution Pattern**:
- **Detection**: CloudFormation drift detection on stack
- **Analysis**: Review drift results to identify changes
- **Remediation**: Update template to match desired state, or update stack to overwrite drift
- **Prevention**: Use SCPs or IAM policies to prevent manual changes

**Common Distractors**:
- Delete drifted resources (wrong - may cause outage)
- Ignore drift (wrong - leads to configuration inconsistency)
- Recreate entire stack (wrong - unnecessary and disruptive)

## Security and Compliance Scenarios

### Unauthorized API Calls
**Scenario**: Security team detects unusual API calls from an IAM user. They need to investigate and remediate.

**Solution Pattern**:
- **Detection**: GuardDuty finding or CloudTrail log analysis
- **Investigation**: CloudTrail Insights for anomalous activity patterns
- **Immediate**: Disable IAM user access keys, revoke active sessions
- **Remediation**: Review and restrict IAM permissions, enable MFA

**Common Distractors**:
- Delete the IAM user (wrong - lose audit trail, may break applications)
- Block IP address only (wrong - attacker may use different IP)
- Wait for more evidence (wrong - act immediately on security issues)

### Non-Compliant Resources
**Scenario**: AWS Config detects S3 buckets without encryption enabled. The team needs automated remediation.

**Solution Pattern**:
- **Detection**: AWS Config rule `s3-bucket-server-side-encryption-enabled`
- **Notification**: Config sends finding to Security Hub
- **Remediation**: Config auto-remediation using SSM Automation document
- **Action**: SSM Automation enables default encryption on non-compliant buckets

**Common Distractors**:
- Manual bucket review (wrong - not scalable or automated)
- Lambda function triggered by Config (wrong - SSM Automation is the standard approach)
- SCP to prevent bucket creation (wrong - does not fix existing buckets)

### Multi-Account Security
**Scenario**: Organization needs centralized security monitoring across 50 AWS accounts.

**Solution Pattern**:
- **Organization**: AWS Organizations with delegated administrator
- **Detection**: GuardDuty enabled in all accounts with central admin
- **Compliance**: AWS Config aggregator for organization-wide compliance
- **Dashboard**: Security Hub for centralized security findings

**Common Distractors**:
- Individual account monitoring (wrong - not centralized)
- CloudTrail in each account independently (wrong - use Organization trail)
- Manual security reviews (wrong - not scalable for 50 accounts)

## Networking Scenarios

### VPC Connectivity Troubleshooting
**Scenario**: EC2 instance in a private subnet cannot reach the internet to download software updates.

**Solution Pattern**:
- **Check**: Verify NAT Gateway exists in public subnet
- **Check**: Verify private subnet route table has 0.0.0.0/0 pointing to NAT Gateway
- **Check**: Verify NAT Gateway's public subnet has route to Internet Gateway
- **Check**: Verify security group allows outbound traffic
- **Check**: Verify NACL allows outbound and return traffic

**Common Distractors**:
- Add Internet Gateway route to private subnet (wrong - makes it public)
- Assign public IP to instance (wrong - defeats purpose of private subnet)
- Use VPC peering (wrong - peering does not provide internet access)

### Secure Hybrid Connectivity
**Scenario**: Company needs to connect on-premises data center to AWS VPC with encrypted traffic and consistent latency.

**Solution Pattern**:
- **Primary**: AWS Direct Connect for dedicated bandwidth
- **Encryption**: Site-to-Site VPN over Direct Connect for encryption
- **Redundancy**: Second Direct Connect connection or VPN backup
- **DNS**: Route 53 Resolver for hybrid DNS resolution

**Common Distractors**:
- VPN only (wrong - does not provide consistent latency)
- Direct Connect only (wrong - traffic not encrypted by default)
- Public internet with TLS (wrong - no consistent latency guarantee)

### CloudFront Cache Issues
**Scenario**: CloudFront is serving stale content after application updates. Users see old versions of pages.

**Solution Pattern**:
- **Immediate**: Create CloudFront invalidation for updated paths
- **Long-term**: Implement cache busting with versioned file names
- **Configuration**: Review and adjust cache TTL settings
- **Headers**: Use Cache-Control headers from origin

**Common Distractors**:
- Delete and recreate distribution (wrong - causes extended downtime)
- Disable caching entirely (wrong - defeats purpose of CDN)
- Wait for TTL to expire (wrong - too slow for urgent updates)

## Cost and Performance Optimization Scenarios

### Right-Sizing Instances
**Scenario**: Company's EC2 instances consistently show CPU utilization below 10%. They need to reduce costs.

**Solution Pattern**:
- **Analysis**: AWS Compute Optimizer recommendations
- **Verification**: CloudWatch metrics history for utilization patterns
- **Action**: Resize instances to recommended types
- **Monitoring**: Set up Cost Explorer reports and Budgets alerts

**Common Distractors**:
- Switch all to Spot instances (wrong - may not be suitable for all workloads)
- Delete underutilized instances (wrong - they may still be needed)
- Buy Reserved Instances for current size (wrong - right-size first)

### Cost Anomaly Detection
**Scenario**: Monthly AWS bill increased by 40% unexpectedly. The team needs to identify the cause and prevent recurrence.

**Solution Pattern**:
- **Investigation**: Cost Explorer with daily granularity and service breakdown
- **Root Cause**: Identify service and resource causing cost spike
- **Prevention**: AWS Budgets with threshold alerts and budget actions
- **Monitoring**: Cost Anomaly Detection for automatic alerts

**Common Distractors**:
- Review only monthly total (wrong - need granular breakdown)
- Contact AWS support immediately (wrong - investigate first)
- Reduce all resources (wrong - identify specific cause)

## Key Decision Factors

### Operational Efficiency Criteria
1. **Automation**: Always prefer automated solutions over manual processes
2. **Managed Services**: Use AWS managed services to reduce operational burden
3. **Monitoring First**: Implement monitoring before making changes
4. **Least Privilege**: Apply minimum necessary permissions
5. **Infrastructure as Code**: Manage all resources through IaC

### Common Anti-Patterns
- Manual SSH access when Systems Manager Session Manager is available
- Individual resource management when CloudFormation should be used
- Reactive monitoring instead of proactive alerting
- Single-AZ deployments for production workloads
- Hardcoded credentials instead of IAM roles or Parameter Store
