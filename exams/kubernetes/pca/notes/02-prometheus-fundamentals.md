# Prometheus Fundamentals

**[📖 Prometheus Architecture](https://prometheus.io/docs/introduction/overview/#architecture)** - Architecture overview
**[📖 Data Model](https://prometheus.io/docs/concepts/data_model/)** - Time series data model
**[📖 Configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)** - Configuration reference

## Architecture

### Core Components

**Prometheus Server:**
- **Retrieval**: Discovers and scrapes targets for metrics
- **TSDB**: Stores time-series data on local disk
- **HTTP Server**: Serves the web UI and PromQL API
- **Rule Engine**: Evaluates recording rules and alerting rules

**Alertmanager:**
- Receives alerts from Prometheus
- Routes alerts to notification receivers
- Handles grouping, deduplication, inhibition, and silencing
- Separate binary from Prometheus server

**Pushgateway:**
- Allows short-lived batch jobs to push metrics
- Prometheus scrapes the Pushgateway like any other target
- Use only when scraping is not possible (batch jobs)
- Not for replacing the pull model for long-running services

### Ecosystem Components
- **Client Libraries**: Instrument application code (Go, Python, Java, Ruby, etc.)
- **Exporters**: Expose metrics from third-party systems (Node, MySQL, Blackbox, etc.)
- **Service Discovery**: Dynamically discover scrape targets
- **Visualization**: Grafana for dashboards, Prometheus web UI for ad-hoc queries

## Data Model

### Time Series
- A time series is uniquely identified by its metric name and set of labels
- Format: `metric_name{label1="value1", label2="value2"}` value timestamp
- Example: `http_requests_total{method="GET", status="200"}` 1234 1711234567

### Metric Names
- Must match `[a-zA-Z_:][a-zA-Z0-9_:]*`
- Use snake_case
- Include unit suffix: `_seconds`, `_bytes`, `_total`
- Prefix with application or subsystem: `http_`, `node_`, `process_`

### Labels
- Key-value pairs that add dimensions to a metric
- Every unique label combination creates a new time series
- Too many label values = high cardinality (avoid unbounded labels like user ID)
- Reserved labels start with `__` (used internally, removed after scraping)

### Samples
- A single data point: (timestamp, float64 value)
- Timestamps are in milliseconds since epoch
- Values are 64-bit floating point numbers

## Configuration

### Key Configuration Sections

```yaml
global:
  scrape_interval: 15s       # How often to scrape targets
  evaluation_interval: 15s   # How often to evaluate rules
  scrape_timeout: 10s        # Timeout per scrape
  external_labels:            # Labels added to all time series
    cluster: production

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
    - targets: ['localhost:9090']

rule_files:
  - 'recording_rules.yml'
  - 'alerting_rules.yml'

alerting:
  alertmanagers:
  - static_configs:
    - targets: ['alertmanager:9093']

remote_write:
  - url: 'http://thanos-receive:19291/api/v1/receive'

remote_read:
  - url: 'http://thanos-query:9090/api/v1/read'
```

### Service Discovery

| Type | Configuration | Use Case |
|------|--------------|----------|
| `static_configs` | Manual target list | Development, static infrastructure |
| `kubernetes_sd_configs` | Auto-discover K8s resources | Kubernetes environments |
| `file_sd_configs` | Read from JSON/YAML files | Dynamic targets managed externally |
| `dns_sd_configs` | DNS SRV/A records | DNS-based service discovery |
| `consul_sd_configs` | Consul service catalog | Consul-based environments |
| `ec2_sd_configs` | AWS EC2 instances | AWS environments |
| `gce_sd_configs` | GCP instances | GCP environments |

### Kubernetes Service Discovery Roles

| Role | Discovers | Use Case |
|------|----------|----------|
| `node` | Kubernetes nodes | Node-level metrics (Node Exporter) |
| `pod` | Individual pods | Pod-level application metrics |
| `service` | Services | Service endpoints |
| `endpoints` | Endpoints behind services | More granular than service |
| `ingress` | Ingress resources | Probe ingress endpoints |

### Relabeling
- `relabel_configs`: Applied before scraping (filter targets, modify labels)
- `metric_relabel_configs`: Applied after scraping (filter/modify metrics)
- Actions: `keep`, `drop`, `replace`, `labelmap`, `labeldrop`, `labelkeep`, `hashmod`
- Common use: Keep only pods with `prometheus.io/scrape: "true"` annotation

## Storage

### Local Storage (TSDB)

**Architecture:**
- **WAL (Write-Ahead Log)**: Durability for recent writes (crash recovery)
- **Head Block**: In-memory block for the most recent data
- **Persistent Blocks**: Compressed, immutable blocks on disk (2-hour chunks)
- **Compaction**: Merges smaller blocks into larger ones for efficiency

**Retention:**
- Default: 15 days (`--storage.tsdb.retention.time`)
- Can also set by size (`--storage.tsdb.retention.size`)
- Oldest data is deleted when retention limit is reached

**Performance:**
- Optimized for recent data queries
- Compression reduces storage by 10-20x
- Single-node design (not distributed)

### Remote Storage

**Remote Write:**
- Sends samples to external long-term storage
- Compatible backends: Thanos, Cortex, Mimir, VictoriaMetrics
- Prometheus continues to serve local queries
- Buffered with WAL for reliability

**Remote Read:**
- Queries external storage transparently
- Prometheus merges local and remote data
- Used for querying historical data beyond local retention

### Federation
- Hierarchical Prometheus setup
- Higher-level Prometheus scrapes selected metrics from lower-level instances
- Use cases: aggregating metrics from multiple clusters, global view
- Only federate aggregated metrics (avoid scraping all raw metrics)

## Prometheus Operator (Kubernetes)

**Custom Resources:**
- **Prometheus**: Defines a Prometheus instance
- **ServiceMonitor**: Declares which services to monitor (auto-configures scrape targets)
- **PodMonitor**: Declares which pods to monitor
- **PrometheusRule**: Defines recording and alerting rules
- **Alertmanager**: Defines an Alertmanager instance

**Benefits:**
- Declarative configuration via Kubernetes manifests
- Automatic scrape target configuration
- Simplified management of recording and alerting rules
- GitOps-compatible monitoring configuration
