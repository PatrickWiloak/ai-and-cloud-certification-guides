# Prometheus Certified Associate (PCA)

## Exam Overview

The Prometheus Certified Associate (PCA) certification demonstrates a candidate's foundational knowledge of observability and monitoring using Prometheus. This exam validates understanding of Prometheus architecture, PromQL queries, instrumentation, dashboarding, and alerting in cloud native environments. It is ideal for DevOps engineers, SREs, and platform engineers working with Prometheus in Kubernetes and cloud native stacks.

**Exam Details:**
- **Exam Code:** PCA
- **Duration:** 90 minutes
- **Number of Questions:** 60 multiple choice questions
- **Passing Score:** 75%
- **Cost:** $250 USD (includes one free retake)
- **Delivery:** Online proctored via PSI
- **Validity:** 3 years
- **Prerequisites:** None
- **Format:** Multiple choice only - no hands-on component

**Important:** This is a knowledge-based exam. Focus on understanding Prometheus architecture, PromQL syntax and semantics, metric types, and the alerting pipeline. Hands-on experience with Prometheus is strongly recommended for understanding the concepts.

## Exam Domains

### Domain 1: Observability Concepts (18%)
Understanding the principles and pillars of observability.

- Three pillars of observability: metrics, logs, traces
- Metrics types and their use cases
- Push vs pull monitoring models
- Monitoring vs observability
- SLIs, SLOs, and SLAs
- RED method (Rate, Errors, Duration) and USE method (Utilization, Saturation, Errors)
- Golden signals of monitoring

**Key Concepts:**
- Metrics are numerical measurements collected over time (time-series data)
- Prometheus uses a pull-based model (scrapes targets)
- Observability provides insight into system behavior, monitoring detects known failure modes
- Golden signals: latency, traffic, errors, saturation

### Domain 2: Prometheus Fundamentals (20%)
Core architecture and configuration of Prometheus.

- Prometheus architecture and components
- Configuration and service discovery
- Data model (metrics, labels, time series)
- Storage and retention
- Federation and remote storage
- Prometheus Operator and Kubernetes integration
- Metric naming conventions and best practices

**Key Concepts:**
- Prometheus server: scrapes, stores, and serves metrics
- Service discovery: Kubernetes, file-based, DNS, Consul
- Time series identified by metric name + labels
- TSDB (Time Series Database) for local storage
- Remote write/read for long-term storage

### Domain 3: PromQL (28%)
Querying and analyzing metrics data using PromQL.

- Selectors and matchers (exact, regex, negation)
- Functions and aggregations
- Rate, irate, increase calculations
- Histogram and summary queries
- Range vectors vs instant vectors
- Binary operators and vector matching
- Subqueries and recording rules

**Key Concepts:**
- PromQL is the most heavily tested domain (28%)
- Understand the difference between instant vectors and range vectors
- rate() for counters, changes over time
- Aggregation operators: sum, avg, min, max, count, topk, bottomk
- group by (label) for dimensional analysis

### Domain 4: Instrumentation and Exporters (16%)
Exposing metrics from applications and infrastructure.

- Client libraries (Go, Python, Java, etc.)
- Metric types: counter, gauge, histogram, summary
- Naming conventions and label best practices
- Node Exporter, Blackbox Exporter, and other common exporters
- Custom metrics and instrumentation patterns
- Pushgateway for short-lived jobs

**Key Concepts:**
- Counters only go up (track cumulative values)
- Gauges go up and down (current values)
- Histograms provide bucketed distribution data
- Summaries provide pre-calculated quantiles
- Exporters bridge non-Prometheus systems to the Prometheus format

### Domain 5: Dashboarding (8%)
Visualizing Prometheus metrics.

- Grafana integration with Prometheus
- Dashboard design best practices
- Panel types and visualization options
- Variables and templating
- Dashboard provisioning and sharing

**Key Concepts:**
- Grafana is the standard visualization tool for Prometheus
- Dashboard design: purpose-driven, clear hierarchy, appropriate panel types
- Variables enable dynamic dashboards (dropdown selectors)

### Domain 6: Alerting (10%)
Configuring and managing alerts with Prometheus and Alertmanager.

- Alerting rules configuration
- Alertmanager architecture and routing
- Notification receivers (email, Slack, PagerDuty, webhook)
- Alert grouping, inhibition, and silencing
- Alert severity levels and escalation

**Key Concepts:**
- Alerting rules are defined in Prometheus and sent to Alertmanager
- Alertmanager handles routing, grouping, deduplication, and notification
- Grouping reduces alert noise by combining related alerts
- Inhibition suppresses alerts when higher-severity alerts are firing
- Silences temporarily mute specific alerts

## Core Components

### Prometheus Server
- **Retrieval**: Scrapes metrics from configured targets
- **TSDB**: Stores time-series data locally
- **HTTP Server**: Serves the web UI and API for queries
- **Rule Engine**: Evaluates recording and alerting rules

### Alertmanager
- Receives alerts from Prometheus
- Routes alerts to appropriate receivers
- Groups related alerts to reduce noise
- Handles deduplication, silencing, and inhibition

### Pushgateway
- Allows short-lived jobs to push metrics
- Metrics persist until manually deleted
- Use only for batch jobs that cannot be scraped
- Not a replacement for the pull model

### Exporters
- Bridge metrics from non-Prometheus systems
- Node Exporter: Linux host metrics (CPU, memory, disk, network)
- Blackbox Exporter: Probe endpoints (HTTP, TCP, DNS, ICMP)
- MySQL, PostgreSQL, Redis exporters: Database metrics
- kube-state-metrics: Kubernetes object state metrics

## Study Resources

### Official Resources
- **[📖 Official PCA Exam Page](https://training.linuxfoundation.org/certification/prometheus-certified-associate/)** - Registration and details
- **[📖 PCA Exam Curriculum](https://github.com/cncf/curriculum)** - Official exam objectives
- **[📖 Prometheus Documentation](https://prometheus.io/docs/)** - Complete Prometheus docs
- **[📖 PromQL Documentation](https://prometheus.io/docs/prometheus/latest/querying/basics/)** - PromQL reference
- **[📖 Alertmanager Documentation](https://prometheus.io/docs/alerting/latest/alertmanager/)** - Alertmanager configuration

### Recommended Courses
1. **KodeKloud PCA Course** - Comprehensive with hands-on labs
2. **Prometheus: Up and Running (O'Reilly)** - Excellent reference book
3. **Udemy PCA Courses** - Multiple options with practice exams

### Practice Platforms
- **PromLens** - PromQL query builder and visualizer
- **Local Prometheus stack** - Docker Compose with Prometheus, Grafana, Alertmanager
- **Killercoda** - Free Prometheus scenarios

### Community Resources
- **r/PrometheusMonitoring** - Reddit community
- **CNCF Slack #prometheus** - Official Prometheus channel
- **Prometheus GitHub Discussions** - Community Q&A

---

**Good luck with your PCA certification!**

Remember: PromQL is 28% of the exam - the single largest domain. Spend significant time practicing queries. Understand metric types, aggregation operators, and rate/increase functions thoroughly. Hands-on practice with a running Prometheus instance is the best way to learn PromQL.
