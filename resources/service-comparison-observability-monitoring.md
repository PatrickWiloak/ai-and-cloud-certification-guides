# Service Comparison - Observability and Monitoring

## Overview

This guide compares monitoring, logging, tracing, and alerting services across AWS, Azure, and Google Cloud. Observability is a foundational topic for cloud operations, SRE, and DevOps certification exams.

---

## Core Monitoring Services

### CloudWatch vs Azure Monitor vs Cloud Monitoring

| Feature | AWS CloudWatch | Azure Monitor | Google Cloud Monitoring |
|---------|---------------|---------------|--------------------------|
| Metrics Collection | Automatic (AWS services) | Automatic (Azure services) | Automatic (GCP services) |
| Custom Metrics | CloudWatch PutMetricData | Custom metrics API | Custom metrics / OpenTelemetry |
| Metric Resolution | 1-second (high-res), 60-second (standard) | 1-minute (standard) | 10-second (custom), 60-second (default) |
| Metric Retention | 15 months (varies by resolution) | 93 days (platform), configurable | 24 months |
| Dashboards | CloudWatch Dashboards | Azure Dashboards + Workbooks | Cloud Monitoring Dashboards |
| Cross-Account | CloudWatch cross-account observability | Azure Lighthouse | Multi-project monitoring |
| Anomaly Detection | CloudWatch Anomaly Detection (ML) | Smart detection (App Insights) | N/A (use MQL queries) |
| Composite Alarms | Yes | N/A | Yes (MQL alert policies) |
| Pricing | Per metric, per API call, per dashboard | Per GB ingested, per alert rule | Per MB ingested (free allotment) |
| Free Tier | 10 custom metrics, 10 alarms, 3 dashboards | First 5 GB/month | First 150 MB/month + free allotment |

### Metric Types and Namespaces

| Aspect | AWS CloudWatch | Azure Monitor | Google Cloud Monitoring |
|--------|---------------|---------------|--------------------------|
| Namespace Format | AWS/ServiceName | Microsoft.ServiceName | compute.googleapis.com |
| Dimensions | Up to 30 per metric | Dimension filtering | Labels (up to 30) |
| Statistics | Sum, Average, Min, Max, p50-p99 | Aggregations (Avg, Sum, Min, Max, Count) | Aligners and reducers |
| Query Language | CloudWatch Metrics Insights | Kusto Query Language (KQL) | Monitoring Query Language (MQL) |
| Math Expressions | Metric math | KQL functions | MQL functions |
| Cross-Service Queries | Yes (Metrics Insights) | Yes (KQL) | Yes (MQL) |

---

## Logging Services

### CloudWatch Logs vs Azure Monitor Logs vs Cloud Logging

| Feature | AWS CloudWatch Logs | Azure Monitor Logs | Google Cloud Logging |
|---------|--------------------|--------------------|----------------------|
| Log Ingestion | CloudWatch agent, SDKs, API | Azure Monitor agent, SDKs | Logging agent, SDKs, API |
| Structured Logging | JSON (Embedded Metric Format) | Structured (KQL parsing) | JSON (structured payloads) |
| Query Language | CloudWatch Logs Insights | Kusto Query Language (KQL) | Cloud Logging filter syntax |
| Log Groups/Tables | Log groups + log streams | Log Analytics workspaces + tables | Log buckets + log views |
| Retention | 1 day to 10 years (configurable) | 30-730 days (workspace), up to 12 years (archive) | 1-3,650 days (configurable) |
| Archive Storage | S3 export | Archive tier (Blob Storage) | Cloud Storage export |
| Real-time Streaming | Kinesis Data Firehose, Lambda | Event Hubs | Pub/Sub |
| Log-based Metrics | Metric filters | KQL-based alerts | Log-based metrics |
| Cross-Account | Cross-account log sharing | Cross-workspace queries | Cross-project log sinks |
| Pricing | Ingestion + storage + queries | Ingestion + retention | Ingestion + storage (free 50 GB/month) |
| Free Tier | 5 GB ingestion, 5 GB storage | 5 GB ingestion/month | 50 GB ingestion/month |

### Log Collection Agents

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Primary Agent | CloudWatch unified agent | Azure Monitor Agent (AMA) | Ops Agent |
| Legacy Agent | CloudWatch Logs agent | Log Analytics agent (MMA) - deprecated | Legacy Logging agent |
| Container Logging | Fluent Bit (FireLens) | Container Insights (AMA) | Fluent Bit (GKE) |
| Configuration | SSM Parameter Store / JSON config | Data Collection Rules (DCR) | YAML configuration |
| Multi-Destination | Limited | Multiple workspaces | Multiple sinks |
| OpenTelemetry | ADOT Collector | Azure Monitor OpenTelemetry | Google Cloud OpenTelemetry |

---

## Distributed Tracing

### X-Ray vs Application Insights vs Cloud Trace

| Feature | AWS X-Ray | Azure Application Insights | Google Cloud Trace |
|---------|-----------|---------------------------|---------------------|
| Type | Distributed tracing | APM + distributed tracing | Distributed tracing |
| Auto-Instrumentation | X-Ray SDK, ADOT | Auto-instrumentation (codeless) | Auto-instrumentation |
| Language Support | Java, Python, Node.js, .NET, Go, Ruby | Java, Python, Node.js, .NET, JavaScript | Java, Python, Node.js, Go, .NET, Ruby |
| OpenTelemetry | ADOT (AWS Distro for OpenTelemetry) | Native OpenTelemetry support | Native OpenTelemetry support |
| Sampling | Fixed rate, reservoir | Adaptive sampling | Automatic / fixed rate |
| Service Map | X-Ray service map | Application Map | Trace overview |
| Trace Analysis | Trace analytics (filter/group) | Transaction diagnostics | Trace list and details |
| Latency Analysis | Response time distribution | Performance blade | Latency analysis |
| Error Analysis | Error/fault tracking | Failure analysis | Error reporting (separate) |
| Correlation | Trace ID propagation | Operation ID / W3C trace context | W3C trace context |
| Pricing | Per trace recorded + scanned | Per GB ingested | $0.20/million spans |
| Free Tier | 100,000 traces/month | 5 GB/month | First 2.5 million spans/month |

---

## Application Performance Monitoring (APM)

### Full APM Comparison

| Feature | AWS (X-Ray + CloudWatch) | Azure Application Insights | Google Cloud (Trace + Error Reporting) |
|---------|--------------------------|---------------------------|----------------------------------------|
| End-to-End APM | Partial (multiple services) | Yes (unified) | Partial (multiple services) |
| Real User Monitoring | CloudWatch RUM | Browser SDK (RUM) | N/A (use third-party) |
| Synthetic Monitoring | CloudWatch Synthetics | Availability tests | Uptime checks |
| Profiling | CodeGuru Profiler | Application Insights Profiler | Cloud Profiler |
| Dependency Tracking | X-Ray subsegments | Auto-dependency tracking | Trace spans |
| Live Metrics | N/A | Live Metrics Stream | N/A |
| Smart Detection | Anomaly Detection | Smart Detection alerts | N/A |
| Snapshot Debugging | N/A | Snapshot Debugger | Cloud Debugger (deprecated) |

---

## Alerting and Notification

### Alert Services Comparison

| Feature | AWS CloudWatch Alarms | Azure Monitor Alerts | Google Cloud Alerting |
|---------|----------------------|---------------------|-----------------------|
| Metric Alerts | Standard + Composite | Metric alerts | Metric-based policies |
| Log Alerts | Metric filters + alarms | Log search alerts (KQL) | Log-based alerts |
| Anomaly Alerts | Anomaly detection band | Dynamic thresholds | N/A (use MQL) |
| Multi-Condition | Composite alarms | Multi-resource alerts | Multi-condition policies |
| Action Types | SNS, Lambda, EC2, Auto Scaling | Action groups (email, SMS, webhook, Logic Apps, Functions) | Notification channels (email, SMS, Slack, PagerDuty, webhooks) |
| Severity Levels | OK, ALARM, INSUFFICIENT_DATA | Sev 0-4 | No severity (critical/warning via policy) |
| Alert Suppression | N/A | Alert processing rules | Snooze |
| Pricing | $0.10/alarm/month (standard) | Per alert rule/month | Per policy/month |
| Evaluation Frequency | 10-second to 1-day | 1-minute to 1-day | 30-second to 1-day |

### Notification Services

| Feature | AWS SNS | Azure Action Groups | Google Notification Channels |
|---------|---------|--------------------|-----------------------------|
| Email | Yes | Yes | Yes |
| SMS | Yes | Yes | Yes |
| Voice Call | No | Yes | No |
| Webhook | Yes (HTTP/S) | Yes | Yes |
| Slack | Via AWS Chatbot | Via Logic Apps | Yes (native) |
| PagerDuty | Via SNS subscription | Via Action Groups | Yes (native) |
| Teams | Via AWS Chatbot | Yes (native) | Via webhook |
| OpsGenie | Via SNS subscription | Via Action Groups | Yes (native) |
| Mobile Push | Yes (SNS push) | Azure mobile app | Google Cloud mobile app |

---

## Managed Prometheus and Grafana

| Feature | Amazon Managed Prometheus | Azure Monitor (Prometheus) | Google Managed Prometheus |
|---------|--------------------------|---------------------------|---------------------------|
| Collection | ADOT, Prometheus remote write | Azure Monitor agent (Prometheus) | Managed collection, self-deploy |
| Query | PromQL | PromQL (Azure Monitor Workspace) | PromQL (Cloud Monitoring) |
| Storage | Managed (AMP workspace) | Azure Monitor Workspace | Cloud Monitoring metrics store |
| Retention | 150 days | 18 months | 24 months |
| Grafana Integration | Amazon Managed Grafana | Azure Managed Grafana | Self-hosted / Cloud Monitoring |
| AlertManager | Managed AlertManager | Prometheus alert rules | N/A (use Cloud Alerting) |
| Pricing | Per metric sample ingested + stored + queried | Per metrics ingested | Per metric sample ingested |

---

## Infrastructure Monitoring

### VM/Instance Monitoring

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Basic Metrics | CloudWatch (5-min default) | Azure Monitor (1-min) | Cloud Monitoring (1-min) |
| Detailed Metrics | Detailed monitoring (1-min, paid) | VM Insights | Agent metrics |
| Process Monitoring | CloudWatch agent (procstat) | VM Insights (Map) | Ops Agent (process plugin) |
| Agent | CloudWatch unified agent | Azure Monitor Agent | Ops Agent |
| Guest OS Metrics | Agent-based | Agent-based | Agent-based |

### Container Monitoring

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Service | Container Insights | Container Insights | GKE Monitoring |
| Metrics | Node, pod, container, service | Node, pod, container | Node, pod, container, workload |
| Logs | CloudWatch Logs (Fluent Bit) | Log Analytics (ContainerLogV2) | Cloud Logging (Fluent Bit) |
| Prometheus | Amazon Managed Prometheus | Azure Monitor (Prometheus) | Google Managed Prometheus |
| Cost Visibility | Kubecost integration | AKS Cost Analysis | GKE Cost Allocation |
| Control Plane Logging | EKS control plane logging | AKS diagnostics | GKE system logs |

### Database Monitoring

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Performance Insights | RDS Performance Insights | Intelligent Insights | Query Insights |
| Slow Query Logs | CloudWatch Logs integration | Azure Monitor Logs | Cloud Logging |
| Metrics | CloudWatch RDS metrics | Azure Monitor metrics | Cloud Monitoring metrics |
| Recommendations | Trusted Advisor | Azure Advisor | Recommender |

---

## Network Monitoring

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Flow Logs | VPC Flow Logs | NSG Flow Logs | VPC Flow Logs |
| Traffic Analysis | Traffic Mirroring | Traffic Analytics | Packet Mirroring |
| Network Monitor | CloudWatch Network Monitor | Network Watcher | Network Intelligence Center |
| Connectivity Testing | Reachability Analyzer | Connection Monitor | Connectivity Tests |
| Latency Monitoring | CloudWatch Internet Monitor | Connection Monitor | Network Intelligence Center |
| DNS Logging | Route 53 query logs | DNS Analytics | Cloud DNS query logs |

---

## Synthetic Monitoring

| Feature | AWS CloudWatch Synthetics | Azure Availability Tests | Google Uptime Checks |
|---------|--------------------------|--------------------------|----------------------|
| HTTP Checks | Yes | Yes (URL ping, Standard) | Yes |
| Browser Tests | Canary scripts (Node.js) | Multi-step web tests | N/A |
| Custom Scripts | Puppeteer-based | N/A | N/A |
| Global Locations | 20+ regions | 16+ locations | 20+ regions |
| SSL Monitoring | Yes | Yes | Yes |
| Screenshot Capture | Yes | N/A | N/A |
| Frequency | 1-minute minimum | 5-minute minimum | 1-minute minimum |
| Pricing | Per canary run | Included / per web test | Free (basic), paid (advanced) |

---

## OpenTelemetry Integration

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Distribution | AWS Distro for OpenTelemetry (ADOT) | Azure Monitor OpenTelemetry Distro | Google Cloud OpenTelemetry |
| Auto-Instrumentation | ADOT auto-instrumentation | Auto-instrumentation (Java, .NET, Node.js, Python) | Auto-instrumentation |
| Collector | ADOT Collector | Azure Monitor Exporter | Google Cloud Exporter |
| Export Targets | X-Ray, CloudWatch, AMP | Application Insights, Azure Monitor | Cloud Trace, Cloud Monitoring |
| Kubernetes | ADOT add-on (EKS) | AKS OpenTelemetry | GKE auto-instrumentation |

---

## Certification Exam Focus Areas

### AWS SysOps Administrator / DevOps Professional
- CloudWatch Logs Insights query syntax
- CloudWatch agent configuration and custom metrics
- X-Ray trace analysis and service maps
- CloudWatch Synthetics canary scripts
- Composite alarms and anomaly detection
- Container Insights setup and metrics

### Azure Administrator / Monitor Workbook Author
- KQL query syntax for Log Analytics
- Azure Monitor agent vs legacy agents
- Application Insights configuration modes
- Alert processing rules and action groups
- VM Insights and dependency mapping
- Workbook authoring and visualization

### Google Cloud Operations / SRE
- Cloud Logging filter syntax and log-based metrics
- MQL (Monitoring Query Language) basics
- Uptime checks and alerting policies
- Cloud Trace integration with OpenTelemetry
- Error Reporting grouping and notifications
- SLO monitoring and error budgets

---

## Documentation Links

- AWS CloudWatch: https://docs.aws.amazon.com/cloudwatch/
- AWS X-Ray: https://docs.aws.amazon.com/xray/latest/devguide/
- Azure Monitor: https://learn.microsoft.com/en-us/azure/azure-monitor/
- Azure Application Insights: https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview
- Google Cloud Monitoring: https://cloud.google.com/monitoring/docs
- Google Cloud Logging: https://cloud.google.com/logging/docs
- Google Cloud Trace: https://cloud.google.com/trace/docs
- OpenTelemetry: https://opentelemetry.io/docs/

---

## Key Takeaways

1. **Azure Monitor** with Application Insights provides the most comprehensive single-platform APM experience
2. **CloudWatch** offers the deepest AWS integration but requires combining multiple services for full observability
3. **Google Cloud** provides the most generous free tier for logging (50 GB/month)
4. All three providers are converging on **OpenTelemetry** as the standard instrumentation framework
5. **Managed Prometheus** is available on all three platforms - PromQL skills are highly transferable
6. **KQL** (Azure) is the most powerful query language but has the steepest learning curve
7. For multi-cloud observability, consider third-party tools like Datadog, New Relic, or Grafana Cloud
8. Understanding log retention policies and archive strategies is critical for compliance exam questions
