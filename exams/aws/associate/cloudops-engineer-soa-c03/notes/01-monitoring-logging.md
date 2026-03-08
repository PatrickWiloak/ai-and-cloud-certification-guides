# Domain 1: Monitoring, Logging, and Performance Optimization (22%)

## 📋 Overview

This domain covers the observability tools and techniques needed to monitor, log, and optimize AWS workloads. It is the foundation of cloud operations, ensuring you can detect issues, analyze root causes, and maintain performance across your infrastructure.

## 🎯 Key Services and Concepts

### Amazon CloudWatch

**📖 [Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html)** - Monitoring and observability service

#### CloudWatch Metrics

- **Standard Metrics**: Automatically collected for AWS services (EC2 CPU, EBS I/O, ELB requests)
- **Custom Metrics**: Published via PutMetricData API or CloudWatch agent
- **High-Resolution Metrics**: 1-second granularity (vs standard 1-minute or 5-minute)
- **Namespaces**: Logical groupings (e.g., `AWS/EC2`, `AWS/RDS`, custom namespaces)
- **Dimensions**: Name-value pairs that identify a metric (e.g., InstanceId, AutoScalingGroupName)
- **Metric Math**: Combine metrics using mathematical expressions for derived insights
- **Cross-Account Metrics**: Share metrics across accounts using CloudWatch cross-account observability

**📖 [CloudWatch Metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/working_with_metrics.html)** - Working with metrics
**📖 [Custom Metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/publishingMetrics.html)** - Publishing custom metrics
**📖 [Metric Math](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/using-metric-math.html)** - Metric calculations

#### Key EC2 Metrics to Know

| Metric | Type | Description |
|--------|------|-------------|
| CPUUtilization | Standard | Percentage of allocated CPU used |
| NetworkIn/Out | Standard | Bytes transferred in/out |
| DiskReadOps | Standard | Completed read operations (instance store) |
| StatusCheckFailed | Standard | Instance and system status checks |
| MemoryUtilization | **Custom** | Requires CloudWatch agent |
| DiskSpaceUsed | **Custom** | Requires CloudWatch agent |

> **Exam Tip:** Memory and disk space metrics are NOT standard EC2 metrics. They require the CloudWatch unified agent.

#### CloudWatch Alarms

- **Metric Alarms**: Monitor a single metric against a threshold
- **Composite Alarms**: Combine multiple alarms with AND/OR logic
- **Alarm States**: OK, ALARM, INSUFFICIENT_DATA
- **Alarm Actions**: SNS notifications, Auto Scaling actions, EC2 actions (stop, terminate, reboot, recover)
- **Evaluation Periods**: Number of consecutive periods the threshold must be breached
- **Treat Missing Data**: Options include missing, notBreaching, breaching, ignore

**📖 [CloudWatch Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html)** - Creating alarms
**📖 [Composite Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Create_Composite_Alarm.html)** - Complex alarm logic

#### CloudWatch Logs

- **Log Groups**: Logical containers for log streams (e.g., one per application)
- **Log Streams**: Individual sequences of log events (e.g., one per instance)
- **Retention Policies**: Configure from 1 day to 10 years or never expire
- **Metric Filters**: Extract metric data from log events using filter patterns
- **Subscription Filters**: Stream logs to Lambda, Kinesis, or Firehose in real time
- **Log Insights**: SQL-like query language for interactive log analysis
- **Cross-Account Log Aggregation**: Centralize logs from multiple accounts

**📖 [CloudWatch Logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html)** - Log service
**📖 [Logs Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AnalyzingLogData.html)** - Query and analyze logs
**📖 [Metric Filters](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/MonitoringLogData.html)** - Extract metrics from logs

#### CloudWatch Logs Insights - Key Query Syntax

```
# Find top 20 most recent error messages
fields @timestamp, @message
| filter @message like /ERROR/
| sort @timestamp desc
| limit 20

# Count errors per hour
fields @timestamp
| filter @message like /ERROR/
| stats count() as errorCount by bin(1h)

# Parse and aggregate structured logs
fields @timestamp, @message
| parse @message "StatusCode: *" as statusCode
| stats count() by statusCode
```

#### CloudWatch Unified Agent

- Collects both metrics and logs from EC2 instances and on-premises servers
- Configured via JSON configuration file or Systems Manager Parameter Store
- Collects OS-level metrics (memory, disk, swap, netstat, processes)
- Supports StatsD and collectd protocols for custom metrics
- Runs on Linux and Windows

**📖 [CloudWatch Agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html)** - Agent installation
**📖 [Agent Configuration](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html)** - Configuration file

#### CloudWatch Dashboards

- Custom visualizations of metrics and logs
- Cross-account and cross-region dashboards
- Automatic dashboards for AWS services
- Shareable via dashboard sharing or CloudWatch console

---

### AWS CloudTrail

**📖 [AWS CloudTrail](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html)** - API logging and auditing

#### Event Types

| Event Type | Description | Example |
|-----------|-------------|---------|
| **Management Events** | Control plane operations | CreateBucket, RunInstances, CreateUser |
| **Data Events** | Data plane operations | GetObject, PutItem, InvokeFunction |
| **Insights Events** | Anomalous API activity | Unusual volume of API calls |

#### Trail Configuration

- **Single-Region Trail**: Logs events in one region
- **Multi-Region Trail**: Logs events across all regions (recommended)
- **Organization Trail**: Logs events for all accounts in an organization
- **Log File Integrity Validation**: SHA-256 hashing to detect tampering
- **Log File Encryption**: SSE-KMS encryption for trail logs in S3

**📖 [Creating Trails](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-create-and-update-a-trail.html)** - Trail setup
**📖 [CloudTrail Insights](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-insights-events-with-cloudtrail.html)** - Anomaly detection

#### CloudTrail Integration

- **CloudWatch Logs**: Stream trail events for real-time analysis and alarming
- **EventBridge**: Trigger automated responses to specific API calls
- **S3**: Store trail logs for long-term retention and analysis
- **Athena**: Query trail logs using standard SQL

---

### AWS X-Ray

**📖 [AWS X-Ray](https://docs.aws.amazon.com/xray/latest/devguide/aws-xray.html)** - Distributed tracing service

#### Core Concepts

- **Traces**: End-to-end request path through distributed application
- **Segments**: Work done by a single service for a request
- **Subsegments**: Downstream calls made within a segment (e.g., DB queries, HTTP calls)
- **Annotations**: Indexed key-value pairs for filtering traces
- **Metadata**: Non-indexed data attached to segments
- **Service Map**: Visual representation of application architecture and dependencies

#### X-Ray Configuration

- **X-Ray Daemon**: Listens on UDP port 2000, batches and sends trace data to X-Ray API
- **X-Ray SDK**: Instrument application code to generate trace data
- **Sampling Rules**: Control the volume of traces collected (reservoir + fixed rate)
- **Groups**: Filter and organize traces by criteria

**📖 [X-Ray Concepts](https://docs.aws.amazon.com/xray/latest/devguide/xray-concepts.html)** - Tracing concepts
**📖 [X-Ray Daemon](https://docs.aws.amazon.com/xray/latest/devguide/xray-daemon.html)** - Daemon setup
**📖 [Service Maps](https://docs.aws.amazon.com/xray/latest/devguide/xray-console.html#xray-console-servicemap)** - Visualizing services

> **Exam Tip:** X-Ray integrates natively with Lambda (enable Active Tracing), API Gateway (enable X-Ray tracing in stage settings), and ECS (sidecar container pattern).

---

### VPC Flow Logs

**📖 [VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html)** - Network traffic logging

#### Flow Log Levels

- **VPC Level**: Capture all traffic in the VPC
- **Subnet Level**: Capture traffic for specific subnets
- **ENI Level**: Capture traffic for specific network interfaces

#### Key Fields

- Source/destination IP addresses and ports
- Protocol number
- Packets and bytes transferred
- Action (ACCEPT or REJECT)
- Log status

#### Destinations

- CloudWatch Logs
- S3 bucket
- Kinesis Data Firehose

> **Exam Tip:** Flow Logs do NOT capture DNS traffic to Route 53 Resolver, DHCP traffic, or traffic to the instance metadata service (169.254.169.254).

---

### AWS Config

**📖 [AWS Config](https://docs.aws.amazon.com/config/latest/developerguide/WhatIsConfig.html)** - Configuration management and compliance

#### Core Features

- **Configuration Recorder**: Records resource configurations and changes
- **Configuration History**: Timeline of configuration changes per resource
- **Config Rules**: Evaluate resource configurations against desired settings
  - **Managed Rules**: Pre-built rules maintained by AWS (100+ available)
  - **Custom Rules**: Lambda-backed rules for organization-specific requirements
- **Conformance Packs**: Collections of Config rules and remediation actions
- **Aggregator**: Aggregate Config data across accounts and regions
- **Remediation Actions**: Automatic remediation using SSM Automation documents

**📖 [Config Rules](https://docs.aws.amazon.com/config/latest/developerguide/evaluate-config.html)** - Compliance checks
**📖 [Conformance Packs](https://docs.aws.amazon.com/config/latest/developerguide/conformance-packs.html)** - Compliance frameworks
**📖 [Remediation](https://docs.aws.amazon.com/config/latest/developerguide/remediation.html)** - Auto-remediation

---

### AWS Systems Manager

**📖 [AWS Systems Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/what-is-systems-manager.html)** - Operations hub

#### Key Components

| Component | Purpose |
|-----------|---------|
| **Session Manager** | Secure shell access without SSH keys or bastion hosts |
| **Run Command** | Execute commands across fleet of instances remotely |
| **Patch Manager** | Automate OS and software patching with patch baselines |
| **Parameter Store** | Centralized configuration and secrets management |
| **State Manager** | Maintain desired state configuration |
| **Inventory** | Collect metadata about instances and installed software |
| **OpsCenter** | Centralized operational issue management |
| **Automation** | Runbooks for common operational tasks |

**📖 [Session Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html)** - Secure shell access
**📖 [Run Command](https://docs.aws.amazon.com/systems-manager/latest/userguide/execute-remote-commands.html)** - Remote commands
**📖 [Patch Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager.html)** - Patch management
**📖 [Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html)** - Configuration management

#### Parameter Store vs Secrets Manager

| Feature | Parameter Store | Secrets Manager |
|---------|----------------|-----------------|
| Cost | Free (standard) | $0.40/secret/month |
| Rotation | Manual | Automatic with Lambda |
| Max Size | 8 KB (advanced) | 64 KB |
| Cross-Account | Via IAM policies | Native support |
| Best For | Configuration data | Database credentials, API keys |

> **Exam Tip:** Systems Manager requires the SSM Agent installed on instances and an IAM instance profile with the `AmazonSSMManagedInstanceCore` policy.

---

## 📚 Performance Optimization

### Compute Optimizer

**📖 [Compute Optimizer](https://docs.aws.amazon.com/compute-optimizer/latest/ug/what-is-compute-optimizer.html)** - Right-sizing recommendations

- Analyzes CloudWatch metrics to recommend optimal instance types
- Covers EC2, Auto Scaling groups, EBS volumes, Lambda functions, ECS on Fargate
- Provides savings estimates for over-provisioned resources

### Trusted Advisor

**📖 [AWS Trusted Advisor](https://docs.aws.amazon.com/awssupport/latest/user/trusted-advisor.html)** - Best practice checks

- Cost optimization, performance, security, fault tolerance, service limits
- Basic checks available to all accounts; full checks require Business or Enterprise Support

---

## Key Exam Scenarios

1. **EC2 instance running out of memory** - Install CloudWatch unified agent to collect memory metrics; create CloudWatch alarm with Auto Scaling action
2. **Tracking API changes for compliance** - Enable CloudTrail with multi-region trail; enable log file integrity validation; deliver to S3 with KMS encryption
3. **Diagnosing slow API responses** - Enable X-Ray tracing on API Gateway and Lambda; use service map to identify bottlenecks
4. **Ensuring resources meet compliance standards** - Use AWS Config rules with automatic remediation via SSM Automation
5. **Centralizing logs from multiple accounts** - Use CloudWatch cross-account observability or CloudTrail organization trail
