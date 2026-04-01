# Monitoring, Logging, and Remediation

**[Amazon CloudWatch Documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html)** - Complete CloudWatch guide

## Amazon CloudWatch Metrics

**[CloudWatch Metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/working_with_metrics.html)** - Working with metrics

### Standard vs Custom Metrics

**Standard Metrics** - automatically collected by AWS services:
- EC2: CPUUtilization, NetworkIn/Out, DiskReadOps (not memory or disk usage)
- EBS: VolumeReadOps, VolumeWriteOps, VolumeQueueLength
- ELB: RequestCount, HealthyHostCount, UnHealthyHostCount, Latency
- RDS: CPUUtilization, DatabaseConnections, FreeStorageSpace, ReadIOPS

**Custom Metrics** - published by your applications:
- Memory utilization (not available as standard metric)
- Disk space utilization
- Application-specific metrics (request latency, error counts)
- Published using PutMetricData API or CloudWatch agent

**[Publishing Custom Metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/publishingMetrics.html)** - Send custom data to CloudWatch

### Metric Details

**Namespaces** - containers for metrics (e.g., AWS/EC2, AWS/RDS, Custom/MyApp)
**Dimensions** - name/value pairs to identify metrics (e.g., InstanceId, AutoScalingGroupName)
**Resolution**:
- Standard resolution: 1-minute granularity (default for most services)
- High resolution: 1-second granularity (custom metrics, additional cost)

**Metric Math** - perform calculations across metrics:
- Arithmetic operations (+, -, *, /)
- Statistical functions (AVG, SUM, MIN, MAX)
- Conditional logic (IF)
- Use for creating derived metrics like error rates

**[Metric Math](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/using-metric-math.html)** - Performing calculations on metrics

### Cross-Account and Cross-Region

- Share CloudWatch data across accounts using cross-account observability
- CloudWatch cross-region dashboards aggregate metrics from multiple regions
- Requires IAM permissions for cross-account access

## CloudWatch Alarms

**[CloudWatch Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html)** - Creating alarms

### Alarm Types

**Metric Alarms** - watch a single metric or math expression:
- States: OK, ALARM, INSUFFICIENT_DATA
- Evaluation periods and datapoints to alarm
- Treat missing data: missing, notBreaching, breaching, ignore

**Composite Alarms** - combine multiple alarms with AND/OR logic:
- Reduce alarm noise by combining related alarms
- Example: High CPU AND High Memory = True performance issue
- Helps avoid false positives from individual metric spikes

**[Composite Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Create_Composite_Alarm.html)** - Combining alarm logic

### Alarm Actions

**SNS Notifications** - send alerts to email, SMS, Lambda, HTTP endpoints
**Auto Scaling Actions** - trigger scaling policies
**EC2 Actions** - stop, terminate, reboot, or recover instances
**Systems Manager Actions** - trigger OpsCenter OpsItems

### Alarm Best Practices
- Use appropriate evaluation periods to avoid false alarms
- Set up composite alarms for complex conditions
- Configure alarm actions for automated remediation
- Use anomaly detection for metrics with variable baselines

## CloudWatch Dashboards

**[CloudWatch Dashboards](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Dashboards.html)** - Building dashboards

### Dashboard Features
- Custom operational dashboards with multiple widget types
- Widgets: line graphs, stacked area, numbers, text, logs, alarms
- Cross-account and cross-region dashboards
- Automatic dashboards for AWS services
- Share dashboards publicly or with specific IAM users

### Best Practices
- Create service-specific dashboards (compute, database, networking)
- Include alarm status widgets for quick health checks
- Use text widgets for runbook links and documentation
- Add log widgets for quick log analysis

## CloudWatch Logs

**[CloudWatch Logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html)** - Log management service

### Core Concepts
- **Log Groups** - collection of log streams sharing retention and access settings
- **Log Streams** - sequence of log events from same source
- **Retention** - configurable from 1 day to 10 years, or never expire
- **Log Events** - individual records with timestamp and message

### Log Collection Methods
- **CloudWatch Agent** - unified agent for metrics and logs from EC2
- **SDK/API** - PutLogEvents for application logs
- **VPC Flow Logs** - network traffic logs
- **CloudTrail** - API activity logs
- **Lambda** - automatic function log streaming
- **ECS/EKS** - container log drivers

**[CloudWatch Agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html)** - Install and configure the agent

### Metric Filters
- Extract metric data from log events using filter patterns
- Create CloudWatch metrics from log data
- Example: Count HTTP 500 errors in application logs
- Pattern syntax supports exact match, JSON patterns, and space-delimited

**[Metric Filters](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/MonitoringLogData.html)** - Create metrics from logs

### CloudWatch Logs Insights
- Interactive query language for log analysis
- Query across multiple log groups simultaneously
- Built-in commands: fields, filter, stats, sort, limit, parse
- Save and share queries
- Visualize results with bar charts, line charts, stacked area

**[Logs Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AnalyzingLogData.html)** - Query and analyze logs

### Subscription Filters
- Real-time log processing to destinations
- Destinations: Lambda, Kinesis Data Streams, Kinesis Data Firehose
- Use for real-time analysis, archival, or cross-account log aggregation

## AWS CloudTrail

**[AWS CloudTrail](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html)** - API logging and auditing

### Event Types
- **Management Events** - control plane operations (CreateBucket, RunInstances)
- **Data Events** - data plane operations (GetObject, PutItem) - must be explicitly enabled
- **Insights Events** - detect unusual API activity patterns

### Trail Configuration
- **Single-region trail** - logs events in one region
- **Multi-region trail** - logs events across all regions (recommended)
- **Organization trail** - logs events for all accounts in AWS Organizations
- **Log file integrity validation** - detect tampering with SHA-256 hashing

**[Creating Trails](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-create-and-update-a-trail.html)** - Trail setup

### Integration Points
- Send to CloudWatch Logs for real-time monitoring and alerting
- Store in S3 for long-term archival and analysis
- EventBridge integration for automated responses to API events
- Athena for SQL queries against CloudTrail logs in S3

## Amazon EventBridge

**[Amazon EventBridge](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html)** - Serverless event bus

### Core Concepts
- **Event Bus** - receives events from sources (default, custom, partner)
- **Rules** - match incoming events and route to targets
- **Targets** - destinations for matched events (Lambda, SNS, SQS, SSM, Step Functions)
- **Event Patterns** - JSON patterns to filter events

### Operational Use Cases
- Trigger Lambda on EC2 state change (running, stopped, terminated)
- Start SSM Automation when Config rule becomes non-compliant
- Send SNS notification on IAM policy changes via CloudTrail
- Schedule automated operations tasks using cron expressions

## AWS X-Ray

**[AWS X-Ray](https://docs.aws.amazon.com/xray/latest/devguide/aws-xray.html)** - Distributed tracing

### Core Concepts
- **Traces** - end-to-end request path across services
- **Segments** - data about work done by a service
- **Subsegments** - granular detail within a segment
- **Service Map** - visual representation of application architecture
- **Annotations** - indexed key-value pairs for filtering traces
- **Metadata** - non-indexed data for debugging

### X-Ray Integration
- **X-Ray SDK** - instrument application code
- **X-Ray Daemon** - listens on UDP port 2000, sends data to X-Ray API
- **Sampling** - control trace volume (reservoir and rate)
- **Supported Services** - Lambda, API Gateway, ECS, Elastic Beanstalk, EC2

**[X-Ray Concepts](https://docs.aws.amazon.com/xray/latest/devguide/xray-concepts.html)** - Understanding traces and segments

## AWS Systems Manager

**[AWS Systems Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/what-is-systems-manager.html)** - Operations management

### Session Manager
- Secure shell access to EC2 instances without SSH keys or bastion hosts
- No inbound ports required - uses SSM agent and IAM for authentication
- Session logging to CloudWatch Logs or S3 for audit
- Supports port forwarding for accessing applications

**[Session Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html)** - Secure instance access

### Run Command
- Execute commands across fleets of managed instances
- Use SSM documents (command documents) for predefined actions
- Rate control: concurrency and error thresholds
- Output to S3 or CloudWatch Logs

**[Run Command](https://docs.aws.amazon.com/systems-manager/latest/userguide/execute-remote-commands.html)** - Remote command execution

### Patch Manager
- Automate OS and application patching
- Patch baselines define approved/rejected patches
- Maintenance windows schedule patching activities
- Patch compliance reporting

**[Patch Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager.html)** - Patch management

### Parameter Store
- Centralized configuration and secrets storage
- Standard (free, 10K limit) vs Advanced (paid, 100K limit) tiers
- SecureString parameters encrypted with KMS
- Version tracking and change notification via EventBridge
- Hierarchical organization with paths (/app/prod/db-password)

**[Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html)** - Configuration management

### OpsCenter
- Central location for operational issues (OpsItems)
- Aggregates information from CloudWatch, Config, CloudTrail
- Automated OpsItem creation from EventBridge rules
- Runbook integration for remediation

### Automation
- Predefined and custom runbooks for operational tasks
- Step-by-step automation with approval workflows
- Rate control for safe execution across large fleets
- Integration with EventBridge for event-driven automation

**[SSM Automation](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-automation.html)** - Runbook automation

## Key Takeaways

1. **CloudWatch** is the central monitoring service - know metrics, alarms, logs, and dashboards
2. **CloudTrail** logs API calls - essential for security auditing and compliance
3. **EventBridge** enables event-driven automation and remediation
4. **X-Ray** provides distributed tracing across microservices
5. **Systems Manager** is the operations hub - Session Manager, Run Command, Patch Manager, Parameter Store
6. **Custom metrics** are needed for memory and disk utilization (not standard EC2 metrics)
7. **Composite alarms** reduce noise by combining multiple alarm conditions
8. **Logs Insights** provides SQL-like queries across CloudWatch log groups
