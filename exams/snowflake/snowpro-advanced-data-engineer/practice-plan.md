# SnowPro Advanced - Data Engineer Study Plan

## 6-Week Intensive Study Schedule

### Phase 1: Foundation Building (Weeks 1-2)

#### Week 1: Data Loading and Ingestion

#### Day 1-2: Snowpipe Deep Dive
- [ ] Study Snowpipe architecture and auto-ingest mechanism
- [ ] Learn cloud event notification setup (S3 SQS, Azure Event Grid, GCS Pub/Sub)
- [ ] Understand Snowpipe serverless billing model
- [ ] Practice SYSTEM$PIPE_STATUS and monitoring views
- [ ] **Lab:** Create Snowpipe with auto-ingest from external stage

#### Day 3-4: Snowpipe Streaming
- [ ] Study Snowpipe Streaming architecture and Ingest SDK
- [ ] Understand row-level API-based ingestion model
- [ ] Learn Kafka connector Snowpipe Streaming mode
- [ ] Compare Snowpipe vs Snowpipe Streaming for different latency needs
- [ ] **Lab:** Review Ingest SDK documentation and code examples

#### Day 5-7: Bulk Loading and Stages
- [ ] Master COPY INTO with all file format options (CSV, JSON, Parquet, Avro, ORC)
- [ ] Study ON_ERROR options: CONTINUE, SKIP_FILE, ABORT_STATEMENT
- [ ] Learn transformation during load (column reordering, casting, expressions)
- [ ] Practice external stage configuration and storage integrations
- [ ] **Lab:** Load data from multiple file formats with error handling

### Week 2: Change Data Capture

#### Day 1-2: Streams
- [ ] Study stream architecture and offset tracking
- [ ] Learn standard vs append-only vs insert-only streams
- [ ] Understand METADATA$ columns (ACTION, ISUPDATE, ROW_ID)
- [ ] Practice stream consumption patterns
- [ ] **Lab:** Create streams on tables, perform DML, observe change tracking

#### Day 3-4: Tasks and DAGs
- [ ] Study task scheduling (CRON and interval-based)
- [ ] Learn task tree (DAG) construction with AFTER clause
- [ ] Understand serverless tasks vs warehouse-based tasks
- [ ] Practice conditional execution with WHEN clause
- [ ] **Lab:** Build multi-step task DAG with stream-triggered execution

#### Day 5-7: Task + Stream Patterns
- [ ] Implement MERGE pattern with stream consumption
- [ ] Study SYSTEM$STREAM_HAS_DATA for conditional task execution
- [ ] Practice error handling and task retry configuration
- [ ] Learn task monitoring with TASK_HISTORY
- [ ] **Lab:** Build complete CDC pipeline with task + stream

### Phase 2: Core Skills (Weeks 3-4)

#### Week 3: Dynamic Tables and Snowpark

#### Day 1-2: Dynamic Tables
- [ ] Study dynamic table architecture and incremental refresh
- [ ] Learn target lag configuration and refresh scheduling
- [ ] Practice chaining dynamic tables for multi-step pipelines
- [ ] Compare dynamic tables vs tasks/streams trade-offs
- [ ] **Lab:** Build a dynamic table pipeline chain with multiple stages

#### Day 3-4: Snowpark Fundamentals
- [ ] Study Snowpark session management and configuration
- [ ] Master DataFrame API operations (filter, select, join, aggregate)
- [ ] Learn lazy evaluation and action triggers
- [ ] Practice reading from tables and writing results
- [ ] **Lab:** Write Snowpark Python code for data transformations

#### Day 5-7: Snowpark Advanced
- [ ] Develop Python UDFs and vectorized UDFs
- [ ] Create UDTFs for row-expanding transformations
- [ ] Write stored procedures for multi-step pipeline logic
- [ ] Integrate Snowpark procedures with tasks
- [ ] **Lab:** Build a Snowpark stored procedure called by a scheduled task

### Week 4: Advanced Patterns and Optimization

#### Day 1-2: UDFs and Stored Procedures
- [ ] Study UDF types: scalar, vectorized, table functions
- [ ] Learn caller's rights vs owner's rights procedures
- [ ] Understand package management with Anaconda
- [ ] Practice importing custom packages from stages
- [ ] **Lab:** Create UDFs in Python, Java, and SQL

#### Day 3-4: Performance Optimization
- [ ] Study warehouse sizing for data engineering workloads
- [ ] Learn clustering key selection for pipeline output tables
- [ ] Understand materialized views vs dynamic tables
- [ ] Practice Query Profile analysis for pipeline queries
- [ ] **Lab:** Optimize a slow pipeline query using profiling

#### Day 5-7: Governance and Security
- [ ] Study RBAC for pipeline objects (tasks, streams, pipes)
- [ ] Learn masking policies applied to pipeline output
- [ ] Understand object tagging for data classification
- [ ] Practice ACCESS_HISTORY for pipeline audit
- [ ] **Lab:** Configure role hierarchy for a pipeline team

### Phase 3: Exam Preparation (Weeks 5-6)

#### Week 5: Integration and Practice

#### Day 1-2: End-to-End Pipeline
- [ ] Build a complete pipeline: ingest, transform, serve
- [ ] Use Snowpipe for ingestion, streams for CDC, tasks for orchestration
- [ ] Add dynamic tables for declarative transformation layer
- [ ] Include Snowpark UDF for custom logic
- [ ] **Lab:** Full pipeline from raw data to curated output

#### Day 3-4: Monitoring and Troubleshooting
- [ ] Master all INFORMATION_SCHEMA monitoring functions
- [ ] Practice diagnosing pipeline failures
- [ ] Study error notification and alerting patterns
- [ ] Review serverless credit tracking views
- [ ] **Lab:** Simulate pipeline failures and practice troubleshooting

#### Day 5-7: Practice Exam Round 1
- [ ] Take Snowflake official practice exam
- [ ] Review all incorrect answers with documentation
- [ ] Identify knowledge gaps by domain
- [ ] Create focused study notes for weak areas
- [ ] **Review:** Re-read fact sheet for weak domains

### Week 6: Final Review and Exam

#### Day 1-2: Gap Analysis
- [ ] Review data movement patterns and loading options
- [ ] Study pipeline orchestration patterns
- [ ] Review Snowpark capabilities and limitations
- [ ] Practice governance and monitoring scenarios
- [ ] **Practice:** Work through scenario-based questions

#### Day 3-4: Practice Exam Round 2
- [ ] Take second practice exam
- [ ] Target 80%+ score before scheduling real exam
- [ ] Focus on highest-weight domains
- [ ] Review common exam traps
- [ ] **Review:** Final review of fact sheet and key concepts

#### Day 5: Exam Day Preparation
- [ ] Light review of pipeline patterns
- [ ] Review Snowpipe vs Snowpipe Streaming decision criteria
- [ ] Review task DAG patterns and stream types
- [ ] Verify system requirements and test connection
- [ ] **Prepare:** Set up quiet workspace, check ID, ensure stable internet

#### Day 6-7: Exam and Post-Exam
- [ ] Take the exam
- [ ] Document questions you were unsure about
- [ ] If needed, plan retake strategy based on score report
- [ ] Celebrate your achievement

## Daily Study Routine

### Recommended Schedule (1.5-2 hours per day)
1. **Review (15 min):** Review previous day's notes
2. **Study (45 min):** New topic with documentation deep dive
3. **Practice (30 min):** Hands-on pipeline development
4. **Quiz (15 min):** Self-assessment on the day's topics

## Key Milestones

- [ ] **Week 1:** Can configure Snowpipe, Streaming, and COPY INTO
- [ ] **Week 2:** Can build task DAGs with streams for CDC
- [ ] **Week 3:** Can develop dynamic table pipelines and Snowpark procedures
- [ ] **Week 4:** Can optimize pipeline performance and configure governance
- [ ] **Week 5:** Score 70%+ on first practice exam
- [ ] **Week 6:** Score 80%+ on practice exam, pass certification
