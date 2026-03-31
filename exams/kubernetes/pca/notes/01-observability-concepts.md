# Observability Concepts

**[📖 Google SRE Book - Monitoring](https://sre.google/sre-book/monitoring-distributed-systems/)** - Monitoring distributed systems
**[📖 Prometheus Overview](https://prometheus.io/docs/introduction/overview/)** - What is Prometheus

## Monitoring vs Observability

### Monitoring
- Collecting, processing, and displaying predefined metrics
- Answers: "Is the system working?"
- Detects known failure modes
- Based on dashboards and alerts for expected conditions

### Observability
- Ability to understand internal system state from external outputs
- Answers: "Why is the system not working?"
- Enables exploring unknown failure modes
- Based on rich telemetry data (metrics, logs, traces) that can be queried

## Three Pillars of Observability

### Metrics
- Numerical measurements collected over time (time-series data)
- Lightweight and efficient to collect and store
- Best for: aggregated system health, alerting, capacity planning
- Tools: Prometheus, Datadog, CloudWatch, InfluxDB

### Logs
- Timestamped, structured or unstructured event records
- Detailed context for specific events
- Best for: debugging specific issues, audit trails, error analysis
- Tools: Fluentd, Loki, Elasticsearch, Splunk

### Traces
- End-to-end tracking of requests across distributed services
- Shows the path and timing of a request through multiple services
- Best for: understanding latency bottlenecks, dependency mapping
- Tools: Jaeger, Zipkin, Tempo, OpenTelemetry

## Monitoring Methodologies

### Golden Signals (Google SRE)

The four signals that matter most for user-facing systems.

| Signal | Description | Prometheus Example |
|--------|-------------|-------------------|
| **Latency** | Time to serve a request | `histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))` |
| **Traffic** | Amount of demand | `sum(rate(http_requests_total[5m]))` |
| **Errors** | Rate of failed requests | `sum(rate(http_requests_total{status=~"5.."}[5m]))` |
| **Saturation** | How full the system is | `node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes` |

### RED Method (Request-focused)

Best for request-driven services (APIs, microservices).

| Metric | Description | Focus |
|--------|-------------|-------|
| **Rate** | Requests per second | Throughput |
| **Errors** | Failed requests per second | Reliability |
| **Duration** | Time per request | Performance |

### USE Method (Resource-focused)

Best for infrastructure and hardware resources.

| Metric | Description | Focus |
|--------|-------------|-------|
| **Utilization** | Percentage of time resource is busy | Capacity |
| **Saturation** | Amount of work queued | Overload |
| **Errors** | Count of error events | Health |

### When to Use Each

- **Golden Signals**: General-purpose, good default for any service
- **RED Method**: User-facing services where requests are the primary concern
- **USE Method**: Infrastructure components (CPU, memory, disk, network)

## SLIs, SLOs, and SLAs

### Service Level Indicator (SLI)
- A measurable metric that reflects service quality
- Quantitative measure of a specific aspect of service level
- Examples: request latency, error rate, availability percentage, throughput

### Service Level Objective (SLO)
- A target value or range for an SLI
- Internal goal for service reliability
- Examples: "99.9% of requests complete in under 200ms", "99.95% monthly availability"
- Error budget = 100% - SLO (e.g., 0.1% error budget with 99.9% SLO)

### Service Level Agreement (SLA)
- A contract between provider and customer
- Includes consequences for not meeting objectives (credits, penalties)
- Typically less strict than SLOs (SLOs are internal targets, SLAs are external commitments)
- Example: "99.95% monthly uptime or service credits issued"

### Relationship
- SLIs measure performance
- SLOs set targets for SLIs
- SLAs are contracts with consequences based on SLOs
- SLO should be stricter than SLA (catch issues before they become contract violations)

## Push vs Pull Monitoring

### Pull Model (Prometheus)
- Monitoring system scrapes targets at regular intervals
- Targets expose metrics at an HTTP endpoint
- **Advantages**: Targets are simpler (just expose metrics), easy to determine if a target is down, no overload risk on the monitoring system
- **Disadvantages**: Targets must be reachable from the monitoring system, service discovery needed

### Push Model (StatsD, Graphite)
- Applications push metrics to a central collector
- **Advantages**: Works for short-lived jobs, works behind firewalls
- **Disadvantages**: Harder to detect down targets, risk of overwhelming the collector, complex client-side batching
- Prometheus handles push via the Pushgateway (for batch jobs only)

## Prometheus in the Observability Stack

### What Prometheus Excels At
- Metrics collection and storage (time-series data)
- Dimensional data model with powerful query language (PromQL)
- Alerting based on metric conditions
- Service discovery in dynamic environments (Kubernetes)
- High reliability and operational simplicity

### What Prometheus Does Not Do
- Log collection or analysis (use Fluentd/Loki)
- Distributed tracing (use Jaeger/Tempo/OpenTelemetry)
- Long-term storage out of the box (use Thanos/Cortex/Mimir)
- Event processing or complex event correlation
- High-cardinality data storage (not designed for it)
