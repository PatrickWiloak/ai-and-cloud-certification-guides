# PromQL (Prometheus Query Language)

**[📖 PromQL Basics](https://prometheus.io/docs/prometheus/latest/querying/basics/)** - Query language fundamentals
**[📖 PromQL Operators](https://prometheus.io/docs/prometheus/latest/querying/operators/)** - Operators reference
**[📖 PromQL Functions](https://prometheus.io/docs/prometheus/latest/querying/functions/)** - Functions reference

## Data Types

| Type | Description | Example |
|------|-------------|---------|
| **Instant Vector** | Set of time series, each with one value at a given time | `http_requests_total{status="200"}` |
| **Range Vector** | Set of time series, each with a range of values over time | `http_requests_total[5m]` |
| **Scalar** | Simple numeric floating-point value | `42` or `3.14` |
| **String** | Simple string value (rarely used) | `"hello"` |

**Key Distinction:**
- Instant vectors return the most recent value for each time series
- Range vectors return all values within a time window
- Many functions require range vectors (e.g., rate, increase, avg_over_time)
- Grafana panels typically display instant vector results

## Selectors and Matchers

### Label Matchers

| Matcher | Description | Example |
|---------|-------------|---------|
| `=` | Exact equality | `{job="api"}` |
| `!=` | Not equal | `{status!="200"}` |
| `=~` | Regex match | `{method=~"GET\|POST"}` |
| `!~` | Negative regex | `{instance!~"test.*"}` |

### Time Selection
- Range: `metric[5m]` - last 5 minutes of data
- Offset: `metric offset 1h` - data from 1 hour ago
- At: `metric @ 1609459200` - data at specific Unix timestamp
- Duration units: `s` (seconds), `m` (minutes), `h` (hours), `d` (days), `w` (weeks), `y` (years)

## Rate Functions (For Counters)

### rate()
- Per-second average rate of increase over a time range
- Handles counter resets automatically
- Best for: alerting rules, slow-moving counters, recording rules
- `rate(http_requests_total[5m])` - average requests per second over 5 minutes

### irate()
- Per-second instant rate using the last two data points in the range
- More responsive to spikes but noisier
- Best for: volatile, fast-moving counters on dashboards
- `irate(http_requests_total[5m])` - instant rate (uses only last 2 points from 5m window)

### increase()
- Total increase over a time range
- Equivalent to `rate() * seconds_in_range`
- Handles counter resets automatically
- `increase(http_requests_total[1h])` - total requests in the last hour

### When to Use Each

| Function | Smoothness | Responsiveness | Best For |
|----------|-----------|---------------|----------|
| `rate()` | Smooth | Averaged | Alerting, recording rules |
| `irate()` | Noisy | Instant | Dashboards showing spikes |
| `increase()` | Smooth | Averaged | Total counts over time periods |

**Important:** All three require range vectors and are designed for counters. Using them on gauges produces incorrect results.

## Aggregation Operators

### Basic Aggregations

| Operator | Description | Example |
|----------|-------------|---------|
| `sum` | Sum of all values | `sum(rate(http_requests_total[5m]))` |
| `avg` | Average value | `avg(node_cpu_seconds_total)` |
| `min` | Minimum value | `min(node_memory_MemAvailable_bytes)` |
| `max` | Maximum value | `max(node_cpu_seconds_total)` |
| `count` | Number of time series | `count(up)` |
| `stddev` | Standard deviation | `stddev(rate(http_requests_total[5m]))` |
| `stdvar` | Standard variance | `stdvar(rate(http_requests_total[5m]))` |

### Grouping Aggregations

| Operator | Description | Example |
|----------|-------------|---------|
| `topk` | Top K elements by value | `topk(5, rate(http_requests_total[5m]))` |
| `bottomk` | Bottom K elements by value | `bottomk(3, node_memory_MemFree_bytes)` |
| `count_values` | Count series by value | `count_values("version", build_info)` |
| `quantile` | Calculate quantile | `quantile(0.95, rate(http_requests_total[5m]))` |

### by and without Clauses
- `by (label)` - Keep only specified labels in the result
- `without (label)` - Remove specified labels from the result
- `sum by (method)(rate(http_requests_total[5m]))` - sum per HTTP method
- `sum without (instance)(rate(http_requests_total[5m]))` - sum across all instances

## Binary Operators

### Arithmetic
- `+` (addition), `-` (subtraction), `*` (multiplication)
- `/` (division), `%` (modulo), `^` (exponentiation)

### Comparison
- `==`, `!=`, `>`, `<`, `>=`, `<=`
- With `bool` modifier: returns 0 or 1 instead of filtering
- `http_requests_total > 100` - returns only series with value > 100
- `http_requests_total > bool 100` - returns 1 for true, 0 for false

### Logical (set operations)
- `and` - intersection
- `or` - union
- `unless` - complement (left side minus right side matches)

### Vector Matching
- **One-to-one**: Default, matches series with identical labels
- `on(label)` - Match only on specified labels
- `ignoring(label)` - Match ignoring specified labels
- **Many-to-one/one-to-many**: `group_left(labels)` or `group_right(labels)`

## Key Functions

### Histogram Functions
- `histogram_quantile(q, v)` - Calculate the q-th quantile from histogram buckets
- Must preserve the `le` label: `histogram_quantile(0.95, sum by (le)(rate(metric_bucket[5m])))`
- `le` means "less than or equal" - defines bucket boundaries

### Gauge Functions
- `changes(v[t])` - Number of times a gauge changed value
- `delta(v[t])` - Difference between first and last value in range
- `deriv(v[t])` - Per-second derivative using linear regression
- `predict_linear(v[t], s)` - Predict value in s seconds using linear regression
- `avg_over_time(v[t])` - Average value over time range
- `min_over_time(v[t])`, `max_over_time(v[t])` - Min/max over time range

### Utility Functions
- `absent(v)` - Returns 1 if the vector has no elements (useful for "is this metric missing?" alerts)
- `absent_over_time(v[t])` - Returns 1 if no samples exist in the range
- `label_replace(v, dst, replacement, src, regex)` - Modify labels
- `label_join(v, dst, separator, src1, src2, ...)` - Join label values
- `sort(v)`, `sort_desc(v)` - Sort results
- `time()` - Current Unix timestamp
- `vector(s)` - Convert scalar to vector

## Recording Rules

Pre-compute expensive or frequently used queries and store results as new time series.

```yaml
groups:
  - name: http_rules
    interval: 30s
    rules:
    - record: job:http_requests:rate5m
      expr: sum by (job)(rate(http_requests_total[5m]))
    - record: job:http_errors:rate5m
      expr: sum by (job)(rate(http_requests_total{status=~"5.."}[5m]))
    - record: job:http_error_ratio:rate5m
      expr: job:http_errors:rate5m / job:http_requests:rate5m
```

**Naming Convention:**
- `level:metric:operations` format
- `level` = aggregation level (job, instance, etc.)
- `metric` = original metric name
- `operations` = list of operations applied (rate5m, sum, etc.)

**Benefits:**
- Faster dashboard loading (pre-computed results)
- Enables alerting on complex expressions
- Reduces query-time load on Prometheus
- Consistent results across dashboards and alerts

## Common Query Patterns

### Error Rate Percentage
```
sum(rate(http_requests_total{status=~"5.."}[5m]))
/
sum(rate(http_requests_total[5m]))
* 100
```

### P95 Latency
```
histogram_quantile(0.95, sum by (le)(rate(http_request_duration_seconds_bucket[5m])))
```

### Top 5 Pods by CPU
```
topk(5, sum by (pod)(rate(container_cpu_usage_seconds_total[5m])))
```

### Disk Full Prediction (24 hours)
```
predict_linear(node_filesystem_avail_bytes[6h], 24*3600) < 0
```

### Missing Metric Alert
```
absent(up{job="my-service"})
```
