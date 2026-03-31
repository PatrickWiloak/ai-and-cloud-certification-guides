# Prometheus Certified Associate (PCA) Fact Sheet

## Exam Overview

**Exam Code:** PCA
**Exam Name:** Prometheus Certified Associate
**Duration:** 90 minutes
**Format:** Multiple choice (60 questions)
**Passing Score:** 75%
**Cost:** $250 USD (includes one free retake)
**Valid For:** 3 years
**Delivery:** Online proctored via PSI
**Prerequisites:** None

**[📖 Official PCA Exam Page](https://training.linuxfoundation.org/certification/prometheus-certified-associate/)** - Registration and exam details
**[📖 PCA Exam Curriculum](https://github.com/cncf/curriculum)** - Official exam objectives and domains
**[📖 Prometheus Documentation](https://prometheus.io/docs/)** - Complete Prometheus documentation

## Target Audience

This certification is designed for:
- DevOps engineers implementing monitoring solutions
- SREs managing Prometheus-based monitoring stacks
- Platform engineers building observability infrastructure
- Developers instrumenting applications with Prometheus metrics
- Cloud native practitioners working with CNCF observability tools

**[📖 Prometheus Overview](https://prometheus.io/docs/introduction/overview/)** - What is Prometheus
**[📖 Prometheus Best Practices](https://prometheus.io/docs/practices/)** - Recommended practices

## Exam Domains

### Domain 1: Observability Concepts (18%)

This domain covers the theoretical foundations of observability and monitoring.

#### 1.1 Three Pillars of Observability

| Pillar | Description | Tool Examples |
|--------|-------------|--------------|
| **Metrics** | Numerical time-series data | Prometheus, Datadog, CloudWatch |
| **Logs** | Timestamped event records | Fluentd, Loki, Elasticsearch |
| **Traces** | Request flow across services | Jaeger, Tempo, Zipkin |

#### 1.2 Monitoring Methodologies

**Golden Signals (Google SRE):**
- **Latency**: Time to serve a request
- **Traffic**: Amount of demand on the system
- **Errors**: Rate of failed requests
- **Saturation**: How full the system is

**RED Method (Request-focused):**
- **Rate**: Requests per second
- **Errors**: Number of failed requests
- **Duration**: Time per request (latency)

**USE Method (Resource-focused):**
- **Utilization**: Percentage of time a resource is busy
- **Saturation**: Amount of work queued
- **Errors**: Count of error events

#### 1.3 SLIs, SLOs, and SLAs

| Term | Description | Example |
|------|-------------|---------|
| **SLI** | Service Level Indicator - measured metric | 99.5% of requests under 200ms |
| **SLO** | Service Level Objective - target for SLI | 99.9% availability per month |
| **SLA** | Service Level Agreement - contract with consequences | 99.95% uptime or credits issued |

**[📖 Google SRE Book - Monitoring](https://sre.google/sre-book/monitoring-distributed-systems/)** - Monitoring distributed systems

### Domain 2: Prometheus Fundamentals (20%)

This domain covers Prometheus architecture, configuration, and data model.

#### 2.1 Architecture

**Core Components:**
- **Prometheus Server**: Scrapes targets, stores data, evaluates rules, serves queries
- **TSDB**: Local time-series database for efficient storage
- **Service Discovery**: Dynamically finds scrape targets
- **Rule Engine**: Evaluates recording rules and alerting rules
- **HTTP API**: Serves queries from Grafana, API clients, etc.

**[📖 Prometheus Architecture](https://prometheus.io/docs/introduction/overview/#architecture)** - Architecture diagram and description

#### 2.2 Data Model

**Time Series Structure:**
- `metric_name{label1="value1", label2="value2"}` at timestamp = value
- Every unique combination of metric name + labels = one time series
- Labels provide dimensional data (filter, aggregate, group)

**Naming Conventions:**
- Metric names: `snake_case`, descriptive, include unit suffix
- Example: `http_requests_total`, `node_cpu_seconds_total`, `process_memory_bytes`
- Suffixes: `_total` (counter), `_bytes` (size), `_seconds` (duration), `_info` (metadata)

**[📖 Data Model](https://prometheus.io/docs/concepts/data_model/)** - Prometheus data model reference

#### 2.3 Configuration

**Key Configuration Sections:**
- `global`: Scrape interval, evaluation interval, external labels
- `scrape_configs`: Target definitions, service discovery, relabeling
- `rule_files`: Recording and alerting rule file paths
- `alerting`: Alertmanager connection configuration
- `remote_write` / `remote_read`: Long-term storage integration

**Service Discovery:**
| Type | Use Case |
|------|----------|
| `kubernetes_sd_configs` | Discover Kubernetes pods, services, nodes |
| `file_sd_configs` | Read targets from JSON/YAML files |
| `dns_sd_configs` | Discover targets via DNS |
| `consul_sd_configs` | Discover targets from Consul |
| `static_configs` | Manually defined targets |

**[📖 Configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)** - Configuration reference

#### 2.4 Storage

**Local Storage (TSDB):**
- Write-ahead log (WAL) for crash recovery
- Compressed blocks for older data
- Default retention: 15 days (configurable)
- Efficient for recent data queries

**Remote Storage:**
- `remote_write`: Send samples to external systems (Thanos, Cortex, Mimir)
- `remote_read`: Query external systems
- Enables long-term retention and global queries
- Federation for hierarchical Prometheus setups

### Domain 3: PromQL (28%)

This is the most heavily tested domain.

#### 3.1 Data Types

| Type | Description | Example |
|------|-------------|---------|
| **Instant Vector** | Set of time series with one value per series at a point in time | `http_requests_total` |
| **Range Vector** | Set of time series with a range of values per series | `http_requests_total[5m]` |
| **Scalar** | Single numeric value | `42` |
| **String** | Single string value (rarely used) | `"hello"` |

#### 3.2 Selectors and Matchers

| Matcher | Description | Example |
|---------|-------------|---------|
| `=` | Exact match | `job="api"` |
| `!=` | Not equal | `status!="200"` |
| `=~` | Regex match | `method=~"GET\|POST"` |
| `!~` | Negative regex | `instance!~"test.*"` |

#### 3.3 Key Functions

**Rate Functions (for counters):**
- `rate(v[t])` - Per-second average rate of increase over time range
- `irate(v[t])` - Per-second instant rate using last two data points
- `increase(v[t])` - Total increase over time range (rate * seconds)

**Aggregation Operators:**
- `sum`, `avg`, `min`, `max`, `count`
- `topk(k, v)`, `bottomk(k, v)`
- `count_values`, `quantile`
- Group by: `sum by (label)(metric)` or `sum without (label)(metric)`

**Common Functions:**
- `histogram_quantile(q, v)` - Calculate quantile from histogram buckets
- `label_replace()` - Modify label values
- `absent()` - Returns 1 if the metric does not exist
- `changes()` - Number of times a gauge changed value
- `delta()` - Difference between first and last value in a range
- `predict_linear()` - Linear regression prediction

**[📖 PromQL Basics](https://prometheus.io/docs/prometheus/latest/querying/basics/)** - Query language reference
**[📖 PromQL Functions](https://prometheus.io/docs/prometheus/latest/querying/functions/)** - Function reference
**[📖 PromQL Operators](https://prometheus.io/docs/prometheus/latest/querying/operators/)** - Operator reference

#### 3.4 Recording Rules

- Pre-compute frequently used or expensive queries
- Stored as new time series with a custom name
- Reduces query-time computation
- Defined in rule files loaded by Prometheus

```yaml
groups:
  - name: example
    rules:
    - record: job:http_requests:rate5m
      expr: sum by (job)(rate(http_requests_total[5m]))
```

### Domain 4: Instrumentation and Exporters (16%)

#### 4.1 Metric Types

| Type | Behavior | Use Case | Example |
|------|----------|----------|---------|
| **Counter** | Only increases (resets on restart) | Total requests, errors, bytes | `http_requests_total` |
| **Gauge** | Goes up and down | Temperature, memory usage, queue size | `node_memory_MemFree_bytes` |
| **Histogram** | Buckets observations into configurable ranges | Request duration distribution | `http_request_duration_seconds` |
| **Summary** | Pre-calculates quantiles on the client side | Request duration quantiles | `go_gc_duration_seconds` |

**Histogram vs Summary:**
| Aspect | Histogram | Summary |
|--------|-----------|---------|
| Aggregation | Can be aggregated across instances | Cannot be aggregated |
| Quantile calculation | Server-side (PromQL) | Client-side |
| Accuracy | Depends on bucket configuration | Configurable precision |
| Performance | More efficient server-side | More expensive client-side |
| Recommendation | Preferred in most cases | Use when exact quantiles needed |

**[📖 Metric Types](https://prometheus.io/docs/concepts/metric_types/)** - Metric type documentation
**[📖 Histograms and Summaries](https://prometheus.io/docs/practices/histograms/)** - When to use each

#### 4.2 Common Exporters

| Exporter | Purpose |
|----------|---------|
| **Node Exporter** | Linux host metrics (CPU, memory, disk, network) |
| **Blackbox Exporter** | Probe external endpoints (HTTP, TCP, DNS, ICMP) |
| **kube-state-metrics** | Kubernetes object state (pods, deployments, nodes) |
| **cAdvisor** | Container resource usage metrics |
| **MySQL Exporter** | MySQL database metrics |
| **PostgreSQL Exporter** | PostgreSQL database metrics |

**[📖 Exporters List](https://prometheus.io/docs/instrumenting/exporters/)** - Available exporters

#### 4.3 Pushgateway
- For short-lived batch jobs that cannot be scraped
- Jobs push metrics to the Pushgateway
- Prometheus scrapes the Pushgateway
- Metrics persist until manually deleted or Pushgateway restarts
- Not for long-running services (use normal scraping)

### Domain 5: Dashboarding (8%)

#### 5.1 Grafana Integration
- Connect Prometheus as a data source
- Use PromQL in dashboard panel queries
- Dashboard panels: time series, gauge, stat, bar chart, table, heatmap
- Variables for dynamic filtering (dropdown selectors)
- Dashboard provisioning via JSON/YAML for infrastructure as code

### Domain 6: Alerting (10%)

#### 6.1 Alerting Pipeline

```
Prometheus (alerting rules) -> Alertmanager (routing/grouping) -> Receivers (notifications)
```

#### 6.2 Alerting Rules
- Defined in Prometheus configuration
- PromQL expression that triggers when true for a specified duration
- `for` clause prevents flapping (alert must be true for the entire duration)
- Labels and annotations for metadata

#### 6.3 Alertmanager Features

| Feature | Purpose |
|---------|---------|
| **Routing** | Direct alerts to specific receivers based on labels |
| **Grouping** | Combine related alerts into a single notification |
| **Inhibition** | Suppress lower-severity alerts when higher-severity ones fire |
| **Silencing** | Temporarily mute specific alerts |
| **Deduplication** | Prevent duplicate notifications |

**[📖 Alerting Rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/)** - Alerting rule configuration
**[📖 Alertmanager](https://prometheus.io/docs/alerting/latest/alertmanager/)** - Alertmanager documentation

## Exam Tips

### MCQ Strategy
1. **Focus on PromQL (28%)** - The single largest domain. Practice writing queries
2. **Know metric types** - Understand when to use counter, gauge, histogram, summary
3. **Understand the architecture** - Know all components and their roles
4. **Rate vs irate vs increase** - Common source of confusion
5. **Histogram vs summary** - Know the trade-offs and when to use each
6. **Alertmanager features** - Grouping, inhibition, and silencing concepts

### Common Pitfalls
- Confusing rate() with irate() (rate is smoothed average, irate is instant)
- Not understanding that counters only go up (use rate() to get useful data from counters)
- Confusing histograms with summaries (histograms can be aggregated, summaries cannot)
- Not knowing the difference between instant vectors and range vectors
- Mixing up Prometheus components and their responsibilities

---

**Key Takeaway:** The PCA tests your understanding of Prometheus as a monitoring system. PromQL at 28% deserves the most study time. Know the metric types, key functions, and aggregation operators. Understand the full monitoring pipeline from instrumentation to alerting.
