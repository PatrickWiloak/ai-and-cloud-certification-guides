# Databricks Data Engineer Professional - Study Plan

## 6-Week Study Schedule

### Week 1: Advanced Pipeline Design (Domain 1 - Part 1)

#### Day 1-2: Medallion Architecture and Idempotent Design
- [ ] Review advanced medallion architecture patterns
- [ ] Understand idempotent pipeline design principles
- [ ] Practice CREATE OR REPLACE TABLE and INSERT OVERWRITE patterns
- [ ] Review Notes: `notes/01-pipeline-design.md`
- [ ] Read: [Medallion Architecture](https://docs.databricks.com/en/lakehouse/medallion.html)

#### Day 3-4: Change Data Capture
- [ ] Enable and read Change Data Feed (CDF) on Delta tables
- [ ] Understand `_change_type` values: insert, update_preimage, update_postimage, delete
- [ ] Practice reading CDF in batch and streaming modes
- [ ] Combine CDF with MERGE for incremental layer propagation
- [ ] Read: [Change Data Feed](https://docs.databricks.com/en/delta/delta-change-data-feed.html)

#### Day 5-6: Slowly Changing Dimensions
- [ ] Implement SCD Type 1 with simple MERGE
- [ ] Implement SCD Type 2 with effective dates and current flags
- [ ] Practice the two-step MERGE pattern for history tracking
- [ ] Understand surrogate keys in SCD Type 2
- [ ] Read: [MERGE INTO](https://docs.databricks.com/en/sql/language-manual/delta-merge-into.html)

#### Day 7: Week 1 Review
- [ ] Review CDC and SCD patterns together
- [ ] Practice writing complex MERGE statements from scratch
- [ ] Quiz yourself on CDF change types

### Week 2: Advanced Pipeline Design and Incremental Processing (Domains 1-2)

#### Day 8-9: Complex Data Processing
- [ ] Practice semi-structured data handling (dot notation, colon notation)
- [ ] Master higher-order functions: transform, filter, aggregate, exists
- [ ] Practice explode, inline, and array functions
- [ ] Work with nested structs and variant types
- [ ] Read: [Semi-structured Data](https://docs.databricks.com/en/optimizations/semi-structured.html)

#### Day 10-11: Advanced Structured Streaming
- [ ] Implement stream-stream joins with watermarks
- [ ] Practice stream-static joins for dimension enrichment
- [ ] Understand the foreachBatch sink for custom processing
- [ ] Learn streaming deduplication patterns
- [ ] Review Notes: `notes/02-incremental-processing.md`
- [ ] Read: [Stream-Stream Joins](https://docs.databricks.com/en/structured-streaming/joining-streams.html)

#### Day 12-13: Advanced Auto Loader
- [ ] Configure file notification mode vs directory listing
- [ ] Practice schema evolution with all four modes
- [ ] Understand schema hints and rescue data column
- [ ] Compare availableNow trigger with continuous processing
- [ ] Read: [Auto Loader Options](https://docs.databricks.com/en/ingestion/auto-loader/options.html)

#### Day 14: Week 2 Review
- [ ] Review streaming join requirements (watermarks, time bounds)
- [ ] Practice foreachBatch with MERGE operations
- [ ] Compare Auto Loader configuration options

### Week 3: Data Governance (Domain 3)

#### Day 15-16: Advanced Unity Catalog
- [ ] Implement dynamic views for row-level and column-level security
- [ ] Practice is_member() and current_user() functions
- [ ] Understand storage credentials and external locations
- [ ] Review Notes: `notes/03-data-governance.md`
- [ ] Read: [UC Best Practices](https://docs.databricks.com/en/data-governance/unity-catalog/best-practices.html)

#### Day 17-18: System Tables and Auditing
- [ ] Query system.billing.usage for cost analysis
- [ ] Query system.access.audit for security auditing
- [ ] Explore system.compute.clusters for operational monitoring
- [ ] Practice building monitoring dashboards from system tables
- [ ] Read: [System Tables](https://docs.databricks.com/en/administration-guide/system-tables/index.html)

#### Day 19-20: Advanced Governance Patterns
- [ ] Understand privilege inheritance and WITH GRANT OPTION
- [ ] Learn Delta Sharing provider/recipient model
- [ ] Practice enterprise catalog organization patterns
- [ ] Understand data lineage for impact analysis
- [ ] Read: [Delta Sharing](https://docs.databricks.com/en/delta-sharing/index.html)

#### Day 21: Week 3 Review
- [ ] Review all governance patterns
- [ ] Practice writing dynamic views from scratch
- [ ] Quiz yourself on system table names and purposes

### Week 4: Performance Optimization (Domain 4)

#### Day 22-23: Data Layout Optimization
- [ ] Practice OPTIMIZE with and without ZORDER
- [ ] Understand liquid clustering and when to use it
- [ ] Know partitioning guidelines and anti-patterns
- [ ] Practice VACUUM with different retention periods
- [ ] Review Notes: `notes/04-performance-optimization.md`
- [ ] Read: [Liquid Clustering](https://docs.databricks.com/en/delta/clustering.html)

#### Day 24-25: Query and Spark Optimization
- [ ] Understand AQE features: partition coalescing, join conversion, skew handling
- [ ] Practice broadcast join hints
- [ ] Learn key Spark configuration parameters
- [ ] Understand caching strategies (disk cache vs memory cache)
- [ ] Read: [AQE](https://docs.databricks.com/en/optimizations/aqe.html)

#### Day 26-27: Monitoring and Troubleshooting
- [ ] Learn to interpret Spark UI: stages, tasks, shuffle, spill
- [ ] Diagnose data skew from task metrics
- [ ] Practice using DESCRIBE HISTORY and DESCRIBE DETAIL
- [ ] Understand query profile for SQL analysis
- [ ] Review Notes: `notes/05-monitoring-troubleshooting.md`
- [ ] Read: [Spark UI](https://docs.databricks.com/en/compute/sparkling/index.html)

#### Day 28: Week 4 Review
- [ ] Compare liquid clustering vs Z-ordering vs partitioning
- [ ] Review AQE features and when they activate
- [ ] Practice diagnosing performance issues from Spark UI metrics

### Week 5: Integration and Scenario Practice

#### Day 29-30: End-to-End Pipeline Design
- [ ] Design a complete pipeline: ingest, transform, serve
- [ ] Combine CDC, streaming, and governance patterns
- [ ] Practice multi-task job orchestration with dependencies
- [ ] Review all notes files for integration points

#### Day 31-32: Practice Scenarios
- [ ] Work through `scenarios.md` exam-style questions
- [ ] Focus on scenario-based questions (largest portion of professional exam)
- [ ] Practice identifying the best approach among valid options
- [ ] Review incorrect answers and understand reasoning

#### Day 33-35: Weak Area Focus
- [ ] Identify weakest domains from practice results
- [ ] Re-read documentation for weak areas
- [ ] Practice additional scenarios in weak domains
- [ ] Create summary notes for quick review

### Week 6: Final Exam Preparation

#### Day 36-37: Comprehensive Review
- [ ] Re-read all notes and fact sheet
- [ ] Focus on pipeline design (34%) - the largest domain
- [ ] Review key code patterns and syntax
- [ ] Create a one-page cheat sheet of commands

#### Day 38-39: Timed Practice
- [ ] Take full-length practice exams under timed conditions
- [ ] Practice 2 minutes per question pacing
- [ ] Review all incorrect answers
- [ ] Focus on understanding why wrong answers are wrong

#### Day 40-42: Final Review and Exam
- [ ] Light review of key differentiators
- [ ] Review common pitfalls and exam tactics
- [ ] Ensure exam logistics are ready
- [ ] Take the exam with confidence

## Study Tips

### Time Allocation by Domain Weight
| Domain | Weight | Suggested Hours |
|--------|--------|----------------|
| Pipeline Design | 34% | 20-25 hours |
| Incremental Processing | 20% | 12-15 hours |
| Data Governance | 18% | 10-12 hours |
| Performance Optimization | 15% | 8-10 hours |
| Monitoring and Troubleshooting | 13% | 7-9 hours |

### Recommended Daily Schedule
- **45 min** reading documentation and notes
- **45 min** hands-on practice with complex scenarios
- **15 min** reviewing key concepts and patterns
- **Total: ~1.75 hours/day**
