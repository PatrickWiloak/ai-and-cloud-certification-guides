# PCA High-Yield Scenarios and Practice Problems

## Scenario 1: Choosing the Right Metric Type

**Scenario**: An engineering team is instrumenting a new API service. They need to track: (1) total number of HTTP requests received, (2) current number of active connections, (3) distribution of request latencies, and (4) request latency percentiles calculated on the server. Which metric type should they use for each?

**Solution Pattern**:
- **Total HTTP requests**: Counter (`http_requests_total`) - cumulative value that only increases
- **Active connections**: Gauge (`http_active_connections`) - value that goes up and down
- **Latency distribution**: Histogram (`http_request_duration_seconds`) - buckets observations into configurable ranges, aggregatable across instances
- **Latency percentiles (server-side)**: Summary (`http_request_duration_seconds`) - calculates quantiles on the client side

**Common Distractors**:
- Using a gauge for total requests (gauges go up and down, counters only increase)
- Using a counter for active connections (counters cannot decrease)
- Confusing histogram with summary (histograms are aggregatable, summaries are not)

**Key Takeaway**: Match the metric type to the data behavior. Counters for cumulative totals, gauges for current values, histograms for aggregatable distributions, summaries for pre-calculated quantiles.

---

## Scenario 2: PromQL Rate Calculations

**Scenario**: Given the counter `http_requests_total{method="GET", status="200"}`, write PromQL queries to calculate:
1. The per-second request rate over the last 5 minutes
2. The total number of requests in the last hour
3. The per-second request rate grouped by HTTP method

**Solution Pattern**:
1. `rate(http_requests_total{method="GET", status="200"}[5m])`
2. `increase(http_requests_total{method="GET", status="200"}[1h])`
3. `sum by (method)(rate(http_requests_total{status="200"}[5m]))`

**Common Distractors**:
- Using `http_requests_total` without rate() (gives raw cumulative count, not rate)
- Using irate() instead of rate() for the average rate (irate gives instant rate from last two points)
- Forgetting the range vector selector `[5m]` (rate requires a range vector, not instant vector)
- Using `by` without `sum` (by is a clause on aggregation operators)

**Key Takeaway**: Always use rate() or increase() with counters. rate() gives per-second average, increase() gives total increase. Both require range vectors.

---

## Scenario 3: Histogram Quantile Calculation

**Scenario**: Your application exposes a histogram metric `http_request_duration_seconds` with buckets at 0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0, 2.5, 5.0, 10.0. Write a PromQL query to calculate the 95th percentile (p95) request latency across all instances.

**Solution Pattern**:
```
histogram_quantile(0.95, sum by (le)(rate(http_request_duration_seconds_bucket[5m])))
```

**Explanation**:
- `histogram_quantile(0.95, ...)` calculates the 95th percentile
- `rate(...[5m])` converts the counter-based buckets to per-second rates
- `sum by (le)` aggregates across all instances while preserving the bucket label (`le`)
- The `le` label (less than or equal) is required for histogram_quantile to work

**Common Distractors**:
- Forgetting to include `by (le)` in the aggregation (without it, histogram_quantile cannot calculate percentiles)
- Using `_count` or `_sum` suffix instead of `_bucket` (histogram_quantile needs bucket data)
- Not using rate() inside histogram_quantile (raw bucket counts can produce misleading results)
- Using a summary metric with histogram_quantile (summaries do not have buckets)

**Key Takeaway**: histogram_quantile() requires the `le` label to be preserved. Always use `sum by (le)` when aggregating across instances. Always wrap in rate() for meaningful results.

---

## Scenario 4: Error Rate Alerting

**Scenario**: Create an alerting rule that fires when the HTTP error rate (5xx responses) exceeds 5% of total requests for more than 5 minutes. The metric is `http_requests_total` with a `status` label.

**Solution Pattern**:
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
      annotations:
        summary: "HTTP error rate exceeds 5%"
        description: "Error rate is {{ $value | humanizePercentage }}"
```

**Common Distractors**:
- Using `status="500"` instead of regex `status=~"5.."` (misses 502, 503, etc.)
- Not using `for: 5m` (without it, the alert fires immediately on first evaluation, causing flapping)
- Dividing counts instead of rates (would give incorrect results due to counter resets)
- Using `increase()` instead of `rate()` in the ratio (both work, but rate is more standard for ratios)

**Key Takeaway**: Error rate alerts use a ratio of rate(errors) / rate(total). The `for` clause prevents flapping by requiring the condition to be true for the entire duration.

---

## Scenario 5: Alertmanager Routing and Grouping

**Scenario**: An organization needs to route alerts as follows:
- Critical alerts go to PagerDuty
- Warning alerts go to Slack
- All alerts for the `database` team go to a specific email
- During maintenance windows, silence alerts for the `staging` environment

**Solution Pattern**:
- **Routing tree**: Match on `severity` label for PagerDuty vs Slack, match on `team` label for database email
- **Grouping**: Group alerts by `alertname` and `cluster` to reduce notification volume
- **Silencing**: Create a silence in Alertmanager UI matching `environment="staging"` for the maintenance window

```yaml
route:
  group_by: ['alertname', 'cluster']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h
  receiver: 'slack-warnings'
  routes:
  - match:
      team: database
    receiver: 'database-email'
  - match:
      severity: critical
    receiver: 'pagerduty-critical'
```

**Common Distractors**:
- Confusing grouping with routing (grouping combines related alerts, routing directs to receivers)
- Not understanding that route matching is hierarchical (child routes override parent)
- Confusing inhibition with silencing (inhibition is automatic based on rules, silencing is manual)

**Key Takeaway**: Alertmanager routing uses a tree structure. Grouping reduces noise, routing directs to receivers, silencing temporarily mutes, and inhibition automatically suppresses.

---

## Scenario 6: Service Discovery and Relabeling

**Scenario**: In a Kubernetes cluster, you want Prometheus to automatically discover and scrape all pods that have the annotation `prometheus.io/scrape: "true"`. Pods expose metrics on different ports specified by the annotation `prometheus.io/port`.

**Solution Pattern**:
- Use `kubernetes_sd_configs` with role `pod`
- Use relabeling to filter pods with the scrape annotation
- Use relabeling to set the correct scrape port

```yaml
scrape_configs:
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
    - role: pod
    relabel_configs:
    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
      action: keep
      regex: true
    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_port]
      action: replace
      target_label: __address__
      regex: (.+)
```

**Common Distractors**:
- Using `role: service` instead of `role: pod` (pod role discovers individual pod endpoints)
- Not understanding relabeling actions (keep, drop, replace, labelmap)
- Confusing `relabel_configs` (before scrape) with `metric_relabel_configs` (after scrape)

**Key Takeaway**: Service discovery finds targets; relabeling filters and modifies them. In Kubernetes, pod annotations are a common pattern for controlling which pods are scraped.

---

## Scenario 7: Monitoring Methodology Application

**Scenario**: You are setting up monitoring for a microservices application. The product manager asks: "How do we know if our service is healthy?" Using the Golden Signals, what metrics should you track and what PromQL queries would you use?

**Solution Pattern**:

| Signal | Metric | PromQL |
|--------|--------|--------|
| **Latency** | Request duration | `histogram_quantile(0.99, sum by (le)(rate(http_request_duration_seconds_bucket[5m])))` |
| **Traffic** | Request rate | `sum(rate(http_requests_total[5m]))` |
| **Errors** | Error rate | `sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m]))` |
| **Saturation** | Resource usage | `node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes` |

**Common Distractors**:
- Using only error count instead of error rate (count without context is not meaningful)
- Measuring latency with averages instead of percentiles (averages hide outliers)
- Not tracking saturation (it is a leading indicator - predicts problems before they cause failures)

**Key Takeaway**: The four golden signals provide a comprehensive view of service health. Use percentiles for latency, rates for traffic and errors, and utilization for saturation.

## Key Decision Factors

### Domain Priority for Study
1. **PromQL (28%)** - Selectors, functions, aggregations, rate calculations
2. **Prometheus Fundamentals (20%)** - Architecture, config, data model, storage
3. **Observability Concepts (18%)** - Theory, methodologies, SLIs/SLOs
4. **Instrumentation and Exporters (16%)** - Metric types, exporters, Pushgateway
5. **Alerting (10%)** - Rules, Alertmanager, routing, grouping
6. **Dashboarding (8%)** - Grafana, panel types, variables

### Common Anti-Patterns
- Reading about PromQL without writing actual queries
- Not understanding the fundamental difference between metric types
- Ignoring observability theory (18% of the exam)
- Not practicing histogram_quantile() queries (commonly tested)
- Confusing Alertmanager features (grouping vs routing vs inhibition vs silencing)
