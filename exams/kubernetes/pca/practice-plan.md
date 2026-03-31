# PCA Study Plan

## 4-Week Study Schedule

### Week 1: Observability Concepts and Prometheus Fundamentals

#### Day 1-2: Observability Theory
- [ ] Study the three pillars of observability (metrics, logs, traces)
- [ ] Learn monitoring vs observability distinction
- [ ] Study golden signals, RED method, USE method
- [ ] Understand SLIs, SLOs, and SLAs with examples
- [ ] Review push vs pull monitoring models
- [ ] Review Notes: `notes/01-observability-concepts.md`

#### Day 3-4: Prometheus Architecture
- [ ] Study Prometheus components (server, TSDB, service discovery, rules)
- [ ] Learn the data model (metric name, labels, time series)
- [ ] Understand configuration structure (global, scrape_configs, rules)
- [ ] Study service discovery mechanisms (Kubernetes, file, DNS, static)
- [ ] Review Notes: `notes/02-prometheus-fundamentals.md`

#### Day 5-6: Storage and Federation
- [ ] Study local TSDB storage (WAL, blocks, retention)
- [ ] Learn remote write/read for long-term storage
- [ ] Understand federation for hierarchical setups
- [ ] Study metric naming conventions and best practices
- [ ] Optional: Set up local Prometheus with Docker Compose

#### Day 7: Week 1 Review
- [ ] Take a practice quiz on observability and Prometheus fundamentals
- [ ] Draw the Prometheus architecture from memory
- [ ] Review any weak areas

### Week 2: PromQL (Primary Focus)

#### Day 8-9: PromQL Basics
- [ ] Study selectors and matchers (=, !=, =~, !~)
- [ ] Understand instant vectors vs range vectors
- [ ] Practice basic queries with label filtering
- [ ] Learn time duration syntax and offset modifier
- [ ] Review Notes: `notes/03-promql.md`

#### Day 10-11: Rate Functions and Aggregations
- [ ] Study rate(), irate(), increase() for counters
- [ ] Practice aggregation operators (sum, avg, min, max, count)
- [ ] Learn by() and without() clauses for grouping
- [ ] Practice topk(), bottomk() queries
- [ ] Write queries combining rate and aggregation

#### Day 12-13: Advanced PromQL
- [ ] Study histogram_quantile() for percentile calculations
- [ ] Learn binary operators and vector matching
- [ ] Understand on(), ignoring(), group_left, group_right
- [ ] Practice absent() and predict_linear()
- [ ] Study recording rules and subqueries

#### Day 14: Week 2 Review
- [ ] Write PromQL queries for common monitoring scenarios
- [ ] Practice without references: rate, increase, histogram_quantile
- [ ] Complete PromQL-focused practice questions

### Week 3: Instrumentation, Alerting, and Dashboarding

#### Day 15-16: Metric Types and Instrumentation
- [ ] Study all four metric types in detail (counter, gauge, histogram, summary)
- [ ] Learn histogram vs summary trade-offs
- [ ] Understand naming conventions and label best practices
- [ ] Study client library instrumentation patterns
- [ ] Review Notes: `notes/04-instrumentation-exporters.md`

#### Day 17-18: Exporters and Pushgateway
- [ ] Study Node Exporter metrics and use cases
- [ ] Learn Blackbox Exporter (HTTP, TCP, DNS probing)
- [ ] Understand kube-state-metrics vs cAdvisor
- [ ] Study Pushgateway use cases and limitations
- [ ] Review other common exporters (database, message queue)

#### Day 19-20: Alerting and Dashboarding
- [ ] Study alerting rules configuration in Prometheus
- [ ] Learn Alertmanager routing tree, grouping, inhibition, silencing
- [ ] Understand notification receivers
- [ ] Study Grafana dashboard design basics
- [ ] Learn dashboard variables and templating
- [ ] Review Notes: `notes/05-alerting-dashboarding.md`

#### Day 21: Week 3 Review
- [ ] Take a practice quiz on instrumentation and alerting
- [ ] Write alerting rules for common scenarios
- [ ] Review all metric type differences

### Week 4: Comprehensive Review and Exam Prep

#### Day 22-23: Full Review - High-Weight Domains
- [ ] Deep review of PromQL (28%) - practice writing queries
- [ ] Review Prometheus Fundamentals (20%) - architecture, config, data model
- [ ] Review Observability Concepts (18%) - theory and methodologies

#### Day 24-25: Full Review - Remaining Domains
- [ ] Review Instrumentation (16%) - metric types, exporters
- [ ] Review Alerting (10%) - rules, Alertmanager features
- [ ] Review Dashboarding (8%) - Grafana basics
- [ ] Create flashcards for key concepts

#### Day 26-27: Practice Exams
- [ ] Take a full-length practice exam (timed, 90 minutes)
- [ ] Review all incorrect answers - especially PromQL questions
- [ ] Identify weak areas and do targeted review
- [ ] Take a second practice exam

#### Day 28: Pre-Exam Preparation
- [ ] Light review of key PromQL functions and patterns
- [ ] Review metric type differences one final time
- [ ] Verify exam environment and system requirements
- [ ] Rest and mental preparation

## Daily Study Routine (1-2 hours/day)

### Recommended Schedule
1. **30 minutes**: Read documentation and study materials
2. **30 minutes**: Practice PromQL queries (use PromLens or local Prometheus)
3. **30 minutes**: Practice questions and self-assessment

### Weekend Extended Sessions (3-4 hours)
1. **1 hour**: Complex PromQL query practice
2. **1 hour**: Practice exams and review
3. **1-2 hours**: Hands-on with local Prometheus stack

## Practice Environment Setup

### Recommended Lab Setup
- [ ] Docker Compose with Prometheus, Grafana, Alertmanager
- [ ] Node Exporter for host metrics
- [ ] A sample application generating HTTP metrics
- [ ] Alertmanager configured with test receivers
- [ ] PromLens for query visualization

## Study Resources

### Quick Links
- **[PCA Exam Page](https://training.linuxfoundation.org/certification/prometheus-certified-associate/)** - Registration
- **[Prometheus Docs](https://prometheus.io/docs/)** - Official documentation
- **[PromQL Reference](https://prometheus.io/docs/prometheus/latest/querying/basics/)** - Query language
- **[PCA Curriculum](https://github.com/cncf/curriculum)** - Official objectives

### Practice Resources
- **PromLens** - PromQL query builder and explainer
- **KodeKloud PCA** - Course with practice tests
- **Killercoda** - Free Prometheus scenarios
- **Local Prometheus stack** - Hands-on PromQL practice

---

## Final Exam Checklist

### One Week Before
- [ ] Scoring 80%+ consistently on practice exams
- [ ] Comfortable writing PromQL queries without references
- [ ] All domains reviewed
- [ ] Metric type differences clear

### Day Before Exam
- [ ] Light review of PromQL functions
- [ ] Test exam environment (webcam, microphone, browser)
- [ ] Prepare workspace per PSI requirements
- [ ] Get adequate rest

### Exam Day
- [ ] Log in 15 minutes early
- [ ] Read each question fully, especially PromQL syntax
- [ ] Check for correct metric type usage in answers
- [ ] Flag uncertain questions and return later
- [ ] Use the full 90 minutes
