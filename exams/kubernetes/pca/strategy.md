# PCA Study Strategy

## Study Approach

### Phase 1: Foundations (Week 1-2)
1. **Observability Concepts**
   - Three pillars of observability (metrics, logs, traces)
   - Monitoring vs observability distinction
   - Golden signals, RED method, USE method
   - SLIs, SLOs, and SLAs
   - Push vs pull monitoring models

2. **Prometheus Architecture**
   - Core components (server, TSDB, service discovery, rule engine)
   - Configuration structure (global, scrape_configs, rules, alerting)
   - Data model (metric name, labels, time series)
   - Service discovery mechanisms (Kubernetes, file, DNS, static)
   - Storage model (local TSDB, retention, WAL)

3. **Metric Types**
   - Counter: cumulative, only increases, use rate() for meaningful data
   - Gauge: current value, goes up and down
   - Histogram: bucketed distribution, aggregatable
   - Summary: pre-calculated quantiles, not aggregatable

### Phase 2: PromQL Deep Dive (Weeks 2-3)
1. **Query Fundamentals**
   - Selectors and matchers (=, !=, =~, !~)
   - Instant vectors vs range vectors
   - Scalar and string types
   - Time durations and offsets

2. **Functions and Aggregations**
   - rate(), irate(), increase() for counters
   - sum, avg, min, max, count aggregations
   - by() and without() clauses for grouping
   - topk(), bottomk() for ranking
   - histogram_quantile() for percentiles
   - absent() for missing metrics detection
   - predict_linear() for forecasting

3. **Advanced PromQL**
   - Binary operators and vector matching
   - on() and ignoring() for label matching
   - group_left and group_right for many-to-one matching
   - Recording rules for query optimization
   - Subqueries for nested range operations

4. **Practice Queries**
   - Calculate request rate by endpoint
   - Compute error rate percentages
   - Calculate 95th percentile latency from histograms
   - Identify top resource consumers
   - Create alerting expressions

### Phase 3: Instrumentation, Alerting, and Exam Prep (Weeks 3-4)
1. **Instrumentation**
   - Client libraries and metric exposition
   - Naming conventions and label best practices
   - Common exporters (Node, Blackbox, kube-state-metrics)
   - Pushgateway use cases and limitations
   - Custom metric instrumentation patterns

2. **Alerting**
   - Alerting rules in Prometheus
   - Alertmanager routing tree
   - Grouping, inhibition, and silencing
   - Notification receivers (Slack, email, PagerDuty)
   - Alert severity levels

3. **Dashboarding**
   - Grafana and Prometheus integration
   - Dashboard design best practices
   - Variables and templating
   - Panel types for different data

4. **Practice Exams**
   - Take practice tests and review weak areas
   - Focus heavily on PromQL questions (28% of exam)
   - Review all metric type differences

## Study Resources

### Primary Resources
- **[Prometheus Documentation](https://prometheus.io/docs/)** - Complete official docs
- **[PromQL Reference](https://prometheus.io/docs/prometheus/latest/querying/basics/)** - Query language docs
- **[PCA Exam Curriculum](https://github.com/cncf/curriculum)** - Official exam objectives
- **Prometheus: Up and Running (O'Reilly)** - Comprehensive reference book

### Supplementary Resources
- **[Alertmanager Documentation](https://prometheus.io/docs/alerting/latest/alertmanager/)** - Alerting pipeline
- **[Grafana Documentation](https://grafana.com/docs/)** - Dashboard creation
- **[PromLens](https://promlens.com/)** - PromQL query builder and explainer
- **[Prometheus Best Practices](https://prometheus.io/docs/practices/)** - Naming and instrumentation

### Community and Forums
- **CNCF Slack #prometheus** - Prometheus channel
- **r/PrometheusMonitoring** - Reddit community
- **Prometheus GitHub Discussions** - Community Q&A

### Video Courses
1. **KodeKloud PCA** - Comprehensive with labs
2. **Udemy PCA Courses** - Multiple options with practice exams
3. **Prometheus LFD259** - Linux Foundation training
4. **TechWorld with Nana** - Prometheus tutorial on YouTube

## Exam Tactics

### Time Management (90 minutes, 60 questions)
- Average 1.5 minutes per question
- PromQL questions may take longer - budget extra time
- Answer confident questions first
- Flag uncertain questions for review
- Reserve 10-15 minutes for flagged questions

### Question Strategy
1. **Read PromQL carefully** - brackets, parentheses, and function order matter
2. **Check units** - seconds vs milliseconds, bytes vs kilobytes
3. **Counter vs gauge** - using rate() on a gauge is wrong, not using rate() on a counter gives meaningless raw data
4. **Histogram vs summary** - know when aggregation matters
5. **Eliminate wrong answers** - incorrect PromQL syntax eliminates options quickly

### Domain Prioritization
- **PromQL (28%)** - Largest domain, requires the most practice
- **Prometheus Fundamentals (20%)** - Architecture, config, data model
- **Observability Concepts (18%)** - Theory and methodology
- **Instrumentation and Exporters (16%)** - Metric types, exporters
- **Alerting (10%)** - Alertmanager, routing, grouping
- **Dashboarding (8%)** - Grafana basics

## Common Pitfalls

### Study Mistakes
- **Not practicing PromQL** - Reading about queries is not the same as writing them. Set up a local Prometheus and practice
- **Ignoring observability theory** - 18% of the exam covers concepts, not just Prometheus specifics
- **Skipping alerting** - Alertmanager concepts are testable and often misunderstood
- **Not understanding metric types** - The distinction between counter, gauge, histogram, and summary is fundamental

### Content Mistakes
- Using rate() on a gauge (rate is for counters only)
- Confusing rate() with irate() (rate is smoothed, irate uses last two points)
- Thinking summaries can be aggregated across instances (they cannot)
- Not understanding that counters reset on restart (rate() handles this)
- Mixing up scrape_interval with evaluation_interval
- Not knowing that absent() returns 1 when the metric is missing (useful for alerting)

## Progress Tracking

### Self-Assessment Questions

**Phase 1:**
- Can I explain the three pillars of observability?
- Can I describe all Prometheus components and their roles?
- Do I know all four metric types and when to use each?
- Can I explain the Prometheus data model (metric name + labels)?

**Phase 2:**
- Can I write rate(), increase(), and histogram_quantile() queries?
- Do I understand the difference between instant and range vectors?
- Can I use aggregation operators with by() and without()?
- Can I create recording rules?

**Phase 3:**
- Do I know common exporters and their purposes?
- Can I explain Alertmanager routing, grouping, and inhibition?
- Can I design a basic Grafana dashboard with Prometheus?
- Am I scoring 80%+ on practice exams?

### Readiness Indicators
You are ready for the exam when:
- [ ] You can write PromQL queries for common monitoring scenarios
- [ ] You understand all four metric types and their trade-offs
- [ ] You can explain the Prometheus architecture end to end
- [ ] You understand Alertmanager routing and notification flow
- [ ] You score 80%+ consistently on practice exams
