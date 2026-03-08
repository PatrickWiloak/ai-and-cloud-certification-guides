# Domain 1: Monitoring, Logging, and Performance Optimization (22%)

## 📋 Overview

This domain covers the observability pillar of cloud operations: monitoring infrastructure and application health, collecting and analyzing logs, tracing distributed systems, and optimizing performance. It is the largest domain by question count and represents the core competency of a CloudOps engineer.

## 🎯 Key Services

### Amazon CloudWatch

**📖 [Amazon CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html)** - Monitoring and observability service

#### CloudWatch Metrics

- **Standard Metrics**: Automatically collected for AWS services (EC2 CPU, ELB request count, RDS connections)
- **Custom Metrics**: Published via API, CLI, or CloudWatch agent (application-level data)
- **High-Resolution Metrics**: 1-second granularity (standard is 5-minute for EC2, 1-minute for detailed monitoring)
- **Metric Dimensions**: Name/value pairs that identify a metric (e.g., InstanceId, AutoScalingGroupName)
- **Namespaces**: Containers for metrics (e.g., AWS/EC2, AWS/RDS, Custom/MyApp)
- **Metric Math**: Perform calculations across metrics (e.g., error rate = errors / total requests)

**📖 [CloudWatch Metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/working_with_metrics.html)** - Working with metrics
**📖 [Custom Metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/publishingMetrics.html)** - Publishing custom metrics
**📖 [Metric Math](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/using-metric-math.html)** - Metric calculations

**Key EC2 Metrics to Know:**
| Metric | Type | Notes |
|--------|------|-------|
| CPUUtilization | Standard | Percentage of allocated CPU |
| NetworkIn/Out | Standard | Bytes transferred |
| DiskReadOps/WriteOps | Standard | I/O operations count |
| StatusCheckFailed | Standard | Instance and system status |
| MemoryUtilization | Custom | Requires CloudWatch agent |
| DiskSpaceUtilization | Custom | Requires CloudWatch agent |

#### CloudWatch Alarms

- **Metric Alarms**: Monitor a single metric against a threshold
- **Composite Alarms**: Combine multiple alarms with AND/OR logic
- **Alarm States**: OK, ALARM, INSUFFICIENT_DATA
- **Alarm Actions**: SNS notifications, Auto Scaling actions, EC2 actions (stop, terminate, reboot, recover)
- **Evaluation Periods**: Number of consecutive periods a metric must breach threshold
- **Datapoints to Alarm**: Minimum breaching datapoints within evaluation window

**📖 [CloudWatch Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html)** - Creating alarms
**📖 [Composite Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Create_Composite_Alarm.html)** - Complex alarm logic

#### CloudWatch Logs

- **Log Groups**: Collection of log streams with shared retention and access settings
- **Log Streams**: Sequence of log events from a single source
- **Retention Policies**: 1 day to 10 years, or never expire
- **Metric Filters**: Extract metric data from log events using filter patterns
- **Subscription Filters**: Real-time feed to Lambda, Kinesis, or Firehose
- **Cross-Account Log Aggregation**: Centralize logs from multiple accounts

**📖 [CloudWatch Logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html)** - Log management
**📖 [Metric Filters](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/MonitoringLogData.html)** - Extract metrics from logs
**📖 [Subscription Filters](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html)** - Real-time log processing

#### CloudWatch Logs Insights

- Query language for interactive log analysis
- Common query patterns:
  - Filter by field values
  - Parse unstructured log data
  - Aggregate statistics (count, sum, avg, min, max)
  - Sort and limit results
  - Visualize with time-series graphs

**📖 [CloudWatch Logs Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AnalyzingLogData.html)** - Query and analyze logs
**📖 [Logs Insights Query Syntax](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL_QuerySyntax.html)** - Query language reference

#### CloudWatch Agent

- **Unified Agent**: Collects both metrics and logs from EC2 and on-premises servers
- Collects OS-level metrics not available by default (memory, disk, swap)
- Sends application and system logs to CloudWatch Logs
- Configuration via JSON file or Systems Manager Parameter Store
- Supports StatsD and collectd protocols for custom metrics

**📖 [CloudWatch Agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html)** - Agent installation
**📖 [Agent Configuration](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html)** - Configuration reference

---

### AWS CloudTrail

**📖 [AWS CloudTrail](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html)** - API activity logging

#### Event Types

- **Management Events**: Control plane operations (CreateBucket, RunInstances, CreateUser)
  - Read events: Describe*, List*, Get*
  - Write events: Create*, Delete*, Put*, Update*
- **Data Events**: Data plane operations (S3 GetObject/PutObject, Lambda Invoke, DynamoDB GetItem)
  - Must be explicitly enabled (not logged by default)
  - Higher volume, additional cost
- **Insights Events**: Detect unusual API activity patterns (call rate anomalies, error rate anomalies)

**📖 [CloudTrail Events](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-management-events-with-cloudtrail.html)** - Event types
**📖 [CloudTrail Insights](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/logging-insights-events-with-cloudtrail.html)** - Anomaly detection

#### Trail Configuration

- **Organization Trail**: Logs events for all accounts in AWS Organizations
- **Multi-Region Trail**: Applies to all regions (recommended)
- **Log File Integrity**: SHA-256 digest files for tamper detection
- **S3 Delivery**: Logs delivered to S3 bucket with configurable prefix
- **CloudWatch Logs Integration**: Stream events to CloudWatch for real-time alerting
- **EventBridge Integration**: Trigger automated responses to API events

**📖 [Creating Trails](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-create-and-update-a-trail.html)** - Trail setup
**📖 [Log File Integrity](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-log-file-validation-intro.html)** - Tamper detection

---

### AWS X-Ray

**📖 [AWS X-Ray](https://docs.aws.amazon.com/xray/latest/devguide/aws-xray.html)** - Distributed tracing

#### Core Concepts

- **Traces**: End-to-end request tracking across services
- **Segments**: Work done by a single service for a request
- **Subsegments**: Granular timing for downstream calls (AWS SDK, HTTP, SQL)
- **Annotations**: Indexed key-value pairs for filtering traces
- **Metadata**: Non-indexed data for additional context
- **Service Map**: Visual representation of application architecture and latencies

**📖 [X-Ray Concepts](https://docs.aws.amazon.com/xray/latest/devguide/xray-concepts.html)** - Core concepts
**📖 [Service Maps](https://docs.aws.amazon.com/xray/latest/devguide/xray-console.html#xray-console-servicemap)** - Visualizing architecture

#### X-Ray Configuration

- **X-Ray Daemon**: Listens on UDP port 2000, batches and sends trace data
- **X-Ray SDK**: Instrument code to create segments and subsegments
- **Sampling Rules**: Control trace volume (default: first request each second + 5% thereafter)
- **Groups**: Filter traces by expression for focused analysis

**📖 [X-Ray Daemon](https://docs.aws.amazon.com/xray/latest/devguide/xray-daemon.html)** - Daemon setup
**📖 [Sampling Rules](https://docs.aws.amazon.com/xray/latest/devguide/xray-console-sampling.html)** - Control trace volume

---

### VPC Flow Logs

**📖 [VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html)** - Network traffic logging

#### Flow Log Configuration

- **Capture Points**: VPC level, subnet level, or ENI level
- **Destinations**: CloudWatch Logs, S3, or Kinesis Data Firehose
- **Record Format**: Default or custom fields
- **Filter**: ALL traffic, ACCEPT only, or REJECT only
- **Key Fields**: Source/destination IP, ports, protocol, action (ACCEPT/REJECT), bytes, packets

#### Common Troubleshooting Patterns

| Symptom | Flow Log Shows | Likely Cause |
|---------|----------------|--------------|
| Cannot reach instance | REJECT on inbound | Security group or NACL blocking |
| Instance cannot reach internet | REJECT on outbound | No NAT Gateway or route |
| Intermittent connectivity | Mix of ACCEPT/REJECT | NACL rules (stateless) |
| No flow log entries | N/A | Flow logs not enabled or wrong level |

---

### AWS Config

**📖 [AWS Config](https://docs.aws.amazon.com/config/latest/developerguide/WhatIsConfig.html)** - Configuration tracking and compliance

#### Key Features

- **Configuration Recorder**: Records resource configuration changes
- **Configuration History**: Timeline of resource configuration states
- **Config Rules**: Evaluate resource configurations against desired state
  - **Managed Rules**: Pre-built rules (e.g., s3-bucket-versioning-enabled, ec2-instance-no-public-ip)
  - **Custom Rules**: Lambda-based evaluation logic
- **Conformance Packs**: Collection of Config rules and remediation actions as a single entity
- **Remediation Actions**: Automatic fixes via SSM Automation documents
- **Aggregator**: Multi-account, multi-region compliance view

**📖 [Config Rules](https://docs.aws.amazon.com/config/latest/developerguide/evaluate-config.html)** - Compliance evaluation
**📖 [Conformance Packs](https://docs.aws.amazon.com/config/latest/developerguide/conformance-packs.html)** - Compliance frameworks
**📖 [Remediation](https://docs.aws.amazon.com/config/latest/developerguide/remediation.html)** - Auto-remediation

---

## 📚 Performance Optimization

### EC2 Performance

- **Right-Sizing**: Use Compute Optimizer to match instance type to workload
- **Enhanced Networking**: ENA for up to 100 Gbps, EFA for HPC
- **Placement Groups**: Cluster (low latency), spread (fault tolerance), partition (large distributed systems)
- **EBS Optimization**: Choose appropriate volume type (gp3, io2, st1, sc1)

**📖 [Compute Optimizer](https://docs.aws.amazon.com/compute-optimizer/latest/ug/what-is-compute-optimizer.html)** - Right-sizing
**📖 [Placement Groups](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html)** - Instance placement

### Database Performance

- **RDS Proxy**: Connection pooling for Lambda and applications with many connections
- **DynamoDB DAX**: In-memory cache, microsecond read latency
- **Aurora Serverless v2**: Auto-scales capacity based on demand
- **Read Replicas**: Offload read traffic from primary database

**📖 [RDS Proxy](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy.html)** - Connection pooling
**📖 [DynamoDB DAX](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.html)** - In-memory cache

### Storage Performance

- **S3 Transfer Acceleration**: Speed up uploads using CloudFront edge locations
- **S3 Multipart Upload**: Parallel upload of large objects
- **EBS Volume Types**: gp3 (balanced), io2 (high IOPS), st1 (throughput), sc1 (cold)
- **Instance Store**: Highest I/O performance but ephemeral

---

## 🎯 Exam Tips for Domain 1

1. **Know which metrics require the CloudWatch agent** (memory, disk space)
2. **Understand alarm evaluation**: periods, datapoints to alarm, missing data treatment
3. **CloudTrail**: Know the difference between management events, data events, and insights
4. **X-Ray**: Understand when to use annotations (indexed, searchable) vs metadata (not indexed)
5. **Config vs CloudTrail**: Config tracks resource configurations; CloudTrail tracks API calls
6. **VPC Flow Logs**: Cannot capture actual packet content, only metadata
7. **Systems Manager**: Know Session Manager (no SSH needed), Run Command (remote execution), Patch Manager (OS patching)
