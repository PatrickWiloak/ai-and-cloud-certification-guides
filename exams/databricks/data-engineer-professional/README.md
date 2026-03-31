# Databricks Certified Data Engineer Professional

## Exam Overview

The Databricks Certified Data Engineer Professional certification validates advanced data engineering skills on the Databricks Lakehouse Platform. This certification targets experienced data engineers who design, build, and maintain production-grade data pipelines with advanced performance optimization, monitoring, and governance capabilities.

**Exam Details:**
- **Exam Code:** Databricks Certified Data Engineer Professional
- **Duration:** 120 minutes
- **Number of Questions:** 60 multiple-choice questions
- **Passing Score:** 70% (approximately 42 correct answers)
- **Cost:** $300 USD
- **Delivery:** Online proctored
- **Validity:** 2 years
- **Prerequisites:** None (Data Engineer Associate recommended; 2+ years experience recommended)

## Exam Domains

### Domain 1: Designing and Implementing Data Pipelines (34%)
- Design complex multi-hop data pipelines
- Implement advanced ELT patterns
- Handle complex data transformations
- Implement Change Data Capture (CDC)
- Design for idempotency and data quality

**Key Concepts:**
- Advanced multi-hop (medallion) architecture design
- Change Data Capture with Delta Lake MERGE
- Slowly Changing Dimensions (SCD Type 1 and Type 2)
- Complex joins and window functions at scale
- Handling semi-structured and nested data
- Advanced UDF patterns and broadcast variables
- Idempotent pipeline design patterns
- Schema evolution strategies
- Multi-task workflow orchestration

### Domain 2: Incremental Data Processing (20%)
- Design incremental data ingestion architectures
- Implement advanced Structured Streaming patterns
- Optimize streaming performance
- Handle complex streaming scenarios

**Key Concepts:**
- Advanced Auto Loader configuration and rescue data
- Stream-stream joins and watermarking strategies
- Stateful streaming operations (mapGroupsWithState)
- foreachBatch pattern for custom sink operations
- Streaming deduplication
- Advanced trigger strategies
- Handling late-arriving and out-of-order data
- Streaming aggregations with windows
- Exactly-once semantics at scale

### Domain 3: Data Governance (18%)
- Implement enterprise-grade data governance
- Design access control strategies
- Manage data quality at scale
- Implement auditing and compliance

**Key Concepts:**
- Advanced Unity Catalog administration
- Fine-grained access control (row and column level)
- Dynamic views for data masking
- Data lineage at enterprise scale
- Information schema and system tables
- Audit logging and compliance reporting
- External locations and storage credentials
- Catalog federation
- Privilege inheritance model

### Domain 4: Performance Optimization (15%)
- Optimize query performance
- Tune Spark configurations
- Implement data layout optimization
- Manage cluster resources efficiently

**Key Concepts:**
- Z-ordering and data skipping
- File compaction (OPTIMIZE) strategies
- Liquid clustering (modern replacement for partitioning)
- Partition pruning and predicate pushdown
- Broadcast joins vs sort-merge joins
- Adaptive Query Execution (AQE)
- Spark memory management and spill
- Caching strategies (disk vs memory)
- Photon engine optimization
- Cost-based optimizer (CBO) statistics

### Domain 5: Monitoring and Troubleshooting (13%)
- Monitor pipeline health and performance
- Troubleshoot data quality issues
- Debug Spark applications
- Implement alerting and notification

**Key Concepts:**
- Spark UI interpretation (stages, tasks, shuffle)
- Identifying and resolving data skew
- Out-of-memory debugging strategies
- Query profile analysis
- Delta Lake metrics and table history
- System tables for monitoring
- Job and pipeline alerting
- Event log analysis
- Ganglia metrics and cluster monitoring

## Key Concepts to Master

### Advanced Delta Lake
- MERGE operation internals and optimization
- Change Data Feed (CDF) for downstream consumers
- Delta Lake log compaction and checkpointing
- Table cloning (shallow vs deep)
- RESTORE and time travel for data recovery
- Vacuum and retention policies at scale

### Pipeline Design Patterns
- Idempotent writes with MERGE
- Exactly-once processing guarantees
- Dead letter queues for error handling
- Schema evolution with mergeSchema
- Multi-table transactions
- Pipeline dependency management

### Performance Engineering
- Spark execution plans (explain)
- Shuffle optimization
- Join strategy selection
- Data skew mitigation (salting, repartitioning)
- Cluster sizing and autoscaling strategies
- Serverless vs classic compute tradeoffs

## Study Approach

### Phase 1: Advanced Foundations (Week 1-3)
1. Review advanced Spark internals (execution plans, shuffle, memory)
2. Master Delta Lake MERGE patterns and CDC implementation
3. Deep dive into Structured Streaming advanced features
4. Study Unity Catalog administration and governance

### Phase 2: Production Patterns (Week 4-6)
1. Practice complex pipeline design scenarios
2. Learn performance tuning methodology
3. Study monitoring and troubleshooting approaches
4. Implement end-to-end pipeline with governance

### Phase 3: Exam Preparation (Week 7-8)
1. Take practice exams under timed conditions
2. Review incorrect answers and identify patterns
3. Focus on scenario-based reasoning
4. Practice explaining design tradeoffs

## Study Resources

- **[Databricks Academy](https://www.databricks.com/learn)** - Advanced data engineering learning path
- **[Exam Guide](https://www.databricks.com/learn/certification/data-engineer-professional)** - Official exam page
- **[Databricks Documentation](https://docs.databricks.com/)** - Official documentation
- **[Delta Lake Internals](https://docs.databricks.com/en/delta/index.html)** - Delta Lake deep dive
- **[Spark Programming Guide](https://spark.apache.org/docs/latest/sql-programming-guide.html)** - Spark SQL reference

## Tips for Success

1. **Pipeline design is king** - Domain 1 is 34% of the exam; master complex pipeline scenarios
2. **Know the "why" behind optimizations** - Don't just memorize; understand when each technique applies
3. **CDC patterns are critical** - MERGE, SCD Type 1/2, and Change Data Feed appear frequently
4. **Spark UI fluency** - Be able to diagnose problems from Spark UI screenshots
5. **Think at scale** - Solutions must work for TB/PB of data, not just small datasets
6. **Governance is enterprise-grade** - Understand multi-catalog, cross-workspace governance
7. **Streaming edge cases** - Know how to handle late data, duplicates, and schema changes
8. **Performance tradeoffs** - Every optimization has a cost; know when to apply each
9. **Read scenarios completely** - Professional questions are longer and more nuanced
10. **Time management** - 2 minutes per question; some scenario questions need more time

## File Index

| File | Description |
|------|-------------|
| [fact-sheet.md](fact-sheet.md) | Comprehensive reference with documentation links |
| [practice-plan.md](practice-plan.md) | Week-by-week study schedule with checkboxes |
| [scenarios.md](scenarios.md) | Exam-style scenarios with solutions |
| [strategy.md](strategy.md) | Study phases, resources, and exam tactics |
| [notes/01-pipeline-design.md](notes/01-pipeline-design.md) | Advanced pipeline design patterns |
| [notes/02-incremental-processing.md](notes/02-incremental-processing.md) | Advanced streaming and CDC |
| [notes/03-data-governance.md](notes/03-data-governance.md) | Enterprise governance with Unity Catalog |
| [notes/04-performance-optimization.md](notes/04-performance-optimization.md) | Query and pipeline tuning |
| [notes/05-monitoring-troubleshooting.md](notes/05-monitoring-troubleshooting.md) | Debugging and monitoring |
