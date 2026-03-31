# Instrumentation and Exporters

**[📖 Metric Types](https://prometheus.io/docs/concepts/metric_types/)** - Metric type documentation
**[📖 Instrumentation](https://prometheus.io/docs/practices/instrumentation/)** - Best practices for instrumentation
**[📖 Exporters](https://prometheus.io/docs/instrumenting/exporters/)** - Available exporters

## Metric Types

### Counter
- **Behavior**: Monotonically increasing value (only goes up, resets to 0 on restart)
- **Use Cases**: Total requests, total errors, total bytes processed
- **Naming**: Suffix with `_total` (e.g., `http_requests_total`)
- **PromQL**: Always use `rate()` or `increase()` - raw counter values are rarely useful
- **Important**: Counter resets are handled automatically by rate() and increase()

### Gauge
- **Behavior**: Value that can go up and down
- **Use Cases**: Temperature, memory usage, active connections, queue size
- **Naming**: No specific suffix requirement (e.g., `node_memory_MemFree_bytes`)
- **PromQL**: Can use directly, or with `delta()`, `deriv()`, `predict_linear()`
- **Important**: Do not use rate() on gauges - it is designed for counters

### Histogram
- **Behavior**: Counts observations in configurable buckets
- **Exposed Metrics** (three time series per histogram):
  - `metric_bucket{le="..."}` - cumulative count per bucket (counter)
  - `metric_sum` - sum of all observed values (counter)
  - `metric_count` - total number of observations (counter)
- **Use Cases**: Request latency distribution, response size distribution
- **PromQL**: `histogram_quantile()` to calculate percentiles
- **Advantages**: Can be aggregated across instances, flexible quantile calculation server-side
- **Bucket Configuration**: Choose buckets that match your SLO thresholds

### Summary
- **Behavior**: Calculates streaming quantiles on the client side
- **Exposed Metrics**:
  - `metric{quantile="..."}` - pre-calculated quantile values (gauge)
  - `metric_sum` - sum of all observed values (counter)
  - `metric_count` - total number of observations (counter)
- **Use Cases**: When exact quantiles are needed and aggregation is not required
- **Important**: Cannot be aggregated across instances (quantiles are not aggregatable)

### Histogram vs Summary Comparison

| Aspect | Histogram | Summary |
|--------|-----------|---------|
| Quantile calculation | Server-side (PromQL) | Client-side (application) |
| Aggregation | Yes (sum by (le)) | No |
| Accuracy | Depends on bucket config | Configurable accuracy |
| Client cost | Low | Higher (calculates quantiles) |
| Flexibility | Can calculate any quantile | Fixed quantiles at creation |
| Recommendation | Preferred for most use cases | Rarely needed |

## Naming Conventions

**[📖 Naming Best Practices](https://prometheus.io/docs/practices/naming/)** - Official naming guidelines

### Rules
- Use `snake_case` for metric names
- Prefix with application or subsystem: `http_`, `process_`, `node_`
- Include the unit as suffix: `_seconds`, `_bytes`, `_total`
- Counters must end with `_total`
- Use base units (seconds not milliseconds, bytes not megabytes)

### Examples
| Good | Bad | Reason |
|------|-----|--------|
| `http_requests_total` | `httpRequests` | snake_case, _total suffix |
| `http_request_duration_seconds` | `http_request_duration_ms` | Use base units |
| `process_memory_bytes` | `process_memory_mb` | Use base units |
| `node_cpu_seconds_total` | `cpu_usage` | Prefix, unit, _total |

### Label Best Practices
- Use labels for dimensions you want to filter or aggregate on
- Keep cardinality manageable (avoid unbounded values like user IDs, email addresses)
- Use consistent label names across metrics (`instance`, `job`, `method`, `status`)
- Do not put metric name information in labels

## Client Libraries

### Supported Languages
- Go, Python, Java, Ruby, Rust, .NET, JavaScript/Node.js, PHP, Erlang, Haskell

### Instrumentation Pattern
1. Define metrics (counter, gauge, histogram, summary)
2. Register metrics with a registry
3. Update metric values in application code
4. Expose metrics via HTTP endpoint (usually `/metrics`)

### Common Instrumentation Points
- HTTP request count and duration (per method, status, endpoint)
- Database query count and duration
- Cache hit/miss ratios
- Queue sizes and processing times
- Business metrics (orders processed, payments completed)

## Common Exporters

### Node Exporter
- **Purpose**: Linux host metrics
- **Metrics**: CPU, memory, disk, network, filesystem
- **Key Metrics**:
  - `node_cpu_seconds_total` - CPU time per mode
  - `node_memory_MemTotal_bytes` - Total memory
  - `node_memory_MemAvailable_bytes` - Available memory
  - `node_filesystem_avail_bytes` - Available disk space
  - `node_network_receive_bytes_total` - Network bytes received

**[📖 Node Exporter](https://github.com/prometheus/node_exporter)** - Linux hardware and OS metrics

### Blackbox Exporter
- **Purpose**: Probe external endpoints
- **Protocols**: HTTP, HTTPS, TCP, DNS, ICMP
- **Use Cases**: External availability monitoring, SSL certificate expiry, DNS resolution
- **Key Metrics**:
  - `probe_success` - 1 if probe succeeded, 0 if failed
  - `probe_duration_seconds` - Total probe duration
  - `probe_http_status_code` - HTTP response status code
  - `probe_ssl_earliest_cert_expiry` - SSL certificate expiry timestamp

**[📖 Blackbox Exporter](https://github.com/prometheus/blackbox_exporter)** - Blackbox probing

### kube-state-metrics
- **Purpose**: Kubernetes object state metrics
- **Metrics**: Deployment replicas, pod status, node conditions, resource quotas
- **Key Metrics**:
  - `kube_pod_status_phase` - Pod phase (Pending, Running, etc.)
  - `kube_deployment_spec_replicas` - Desired replicas
  - `kube_deployment_status_replicas_available` - Available replicas
  - `kube_node_status_condition` - Node conditions

### cAdvisor
- **Purpose**: Container resource usage metrics
- **Metrics**: Container CPU, memory, network, filesystem usage
- **Built into kubelet**: No separate deployment needed in Kubernetes
- **Key Metrics**:
  - `container_cpu_usage_seconds_total` - Container CPU usage
  - `container_memory_usage_bytes` - Container memory usage

### Database Exporters
- **MySQL Exporter**: Query performance, connection stats, replication lag
- **PostgreSQL Exporter**: Query stats, connection counts, table sizes
- **Redis Exporter**: Memory usage, command stats, key counts
- **MongoDB Exporter**: Operation counts, connections, replication status

## Pushgateway

**[📖 Pushgateway](https://github.com/prometheus/pushgateway)** - Push acceptor for short-lived jobs

### When to Use
- Short-lived batch jobs that complete before Prometheus can scrape them
- Cron jobs, CI/CD pipelines, one-off tasks
- Jobs in environments where scraping is not possible

### When NOT to Use
- Long-running services (use normal scraping)
- As a replacement for the pull model
- When you want accurate up/down monitoring (Pushgateway does not report target health)

### Important Considerations
- Metrics persist until manually deleted or Pushgateway restarts
- Stale metrics are a common problem (job finishes but metrics remain)
- Multiple jobs pushing to the same grouping key overwrite each other
- Should be a last resort, not the default approach
