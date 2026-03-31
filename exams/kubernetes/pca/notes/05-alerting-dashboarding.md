# Alerting and Dashboarding

**[📖 Alerting Rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/)** - Rule configuration
**[📖 Alertmanager](https://prometheus.io/docs/alerting/latest/alertmanager/)** - Alertmanager documentation
**[📖 Grafana Prometheus](https://grafana.com/docs/grafana/latest/datasources/prometheus/)** - Grafana Prometheus data source

## Alerting Pipeline

```
Prometheus -> Alertmanager -> Notification Receivers
(rules)       (routing)       (Slack, PagerDuty, email)
```

1. **Prometheus** evaluates alerting rules at each evaluation interval
2. When a rule's expression is true, Prometheus sends the alert to **Alertmanager**
3. **Alertmanager** routes, groups, and deduplicates alerts
4. **Alertmanager** sends notifications to configured receivers

## Alerting Rules

### Rule Configuration

```yaml
groups:
  - name: http_alerts
    rules:
    - alert: HighErrorRate
      expr: |
        sum(rate(http_requests_total{status=~"5.."}[5m]))
        /
        sum(rate(http_requests_total[5m]))
        > 0.05
      for: 5m
      labels:
        severity: critical
        team: backend
      annotations:
        summary: "HTTP error rate exceeds 5%"
        description: "Error rate is {{ $value | humanizePercentage }} for the last 5 minutes"
        runbook_url: "https://wiki.example.com/runbook/high-error-rate"

    - alert: TargetDown
      expr: up == 0
      for: 2m
      labels:
        severity: warning
      annotations:
        summary: "Target {{ $labels.instance }} is down"
```

### Key Fields

| Field | Purpose |
|-------|---------|
| `alert` | Name of the alert |
| `expr` | PromQL expression - alert fires when true |
| `for` | Duration the expression must be true before firing (prevents flapping) |
| `labels` | Additional labels attached to the alert (used for routing) |
| `annotations` | Non-identifying metadata (summary, description, runbook URL) |

### Alert States
1. **Inactive**: Expression is false
2. **Pending**: Expression is true but `for` duration has not elapsed
3. **Firing**: Expression has been true for the entire `for` duration

### Common Alert Patterns

**High Error Rate:**
```yaml
expr: sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) > 0.05
```

**Target Down:**
```yaml
expr: up == 0
```

**High Memory Usage:**
```yaml
expr: (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes > 0.9
```

**Disk Space Running Low:**
```yaml
expr: predict_linear(node_filesystem_avail_bytes[6h], 24*3600) < 0
```

**Missing Metric:**
```yaml
expr: absent(up{job="critical-service"})
```

## Alertmanager

### Configuration Structure

```yaml
global:
  resolve_timeout: 5m
  slack_api_url: 'https://hooks.slack.com/services/...'

route:
  receiver: 'default-slack'
  group_by: ['alertname', 'cluster']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h
  routes:
  - match:
      severity: critical
    receiver: 'pagerduty'
  - match:
      severity: warning
    receiver: 'slack-warnings'

receivers:
- name: 'default-slack'
  slack_configs:
  - channel: '#alerts'
- name: 'pagerduty'
  pagerduty_configs:
  - service_key: '<key>'
- name: 'slack-warnings'
  slack_configs:
  - channel: '#alerts-warning'

inhibit_rules:
- source_match:
    severity: 'critical'
  target_match:
    severity: 'warning'
  equal: ['alertname', 'cluster']
```

### Key Features

#### Routing
- Hierarchical routing tree based on alert labels
- Child routes inherit from parent and can override settings
- First matching route wins
- Default route catches all unmatched alerts

#### Grouping
- Combines related alerts into a single notification
- `group_by` specifies which labels to group on
- `group_wait`: Time to wait for additional alerts before sending (batching)
- `group_interval`: Time between notifications for the same group
- `repeat_interval`: Time before re-sending for ongoing alerts
- Reduces notification noise significantly

#### Inhibition
- Automatically suppress lower-severity alerts when higher-severity ones are firing
- `source_match`: The alert that triggers inhibition
- `target_match`: The alert that gets suppressed
- `equal`: Labels that must match between source and target
- Example: Suppress warning when critical is firing for the same service

#### Silencing
- Temporarily mute specific alerts
- Created manually (via UI or API)
- Based on label matchers
- Has a start time and end time
- Use cases: maintenance windows, known issues being worked on

#### Deduplication
- Prevents sending duplicate notifications for the same alert
- Based on alert fingerprint (combination of labels)
- Automatically handled by Alertmanager

### Notification Receivers

| Receiver | Use Case |
|----------|----------|
| Slack | Team notifications, low-urgency alerts |
| PagerDuty | On-call escalation, critical alerts |
| Email | Compliance notifications, broad distribution |
| Webhook | Custom integrations, incident management tools |
| OpsGenie | Alternative on-call management |
| VictorOps | Incident response platform |

## Dashboarding with Grafana

### Prometheus as Data Source
- Connect Grafana to Prometheus via URL (usually `http://prometheus:9090`)
- PromQL queries are used in dashboard panels
- Grafana sends queries to Prometheus and visualizes the results
- Supports both instant and range queries

### Panel Types

| Panel | Best For |
|-------|---------|
| **Time Series** | Metrics over time (CPU, request rate, latency) |
| **Stat** | Single value display (current error rate, uptime) |
| **Gauge** | Current value against thresholds (disk usage, memory) |
| **Bar Chart** | Comparing values across categories |
| **Table** | Tabular data display |
| **Heatmap** | Distribution over time (latency buckets, histogram data) |
| **Logs** | Log panel (with Loki data source) |

### Variables and Templating
- Dashboard variables create dropdown selectors
- Query variables populate from Prometheus label values
- Example: `label_values(up, job)` populates a dropdown with all job names
- Variables can be used in panel queries: `rate(http_requests_total{job="$job"}[5m])`
- Enable a single dashboard to work for multiple services/environments

### Dashboard Best Practices
- **Purpose-driven**: Each dashboard should answer a specific question
- **Hierarchy**: Overview dashboards link to detailed dashboards
- **Consistent layout**: Standard placement for common metrics
- **USE/RED/Golden Signals**: Organize panels around a monitoring methodology
- **Thresholds**: Add visual thresholds for SLO boundaries
- **Annotations**: Mark deployments and incidents on time series

### Dashboard Provisioning
- Store dashboards as JSON files in version control
- Grafana provisioning reads from configurable paths
- Enables GitOps for dashboard management
- Dashboards can be imported/exported via the Grafana UI or API
