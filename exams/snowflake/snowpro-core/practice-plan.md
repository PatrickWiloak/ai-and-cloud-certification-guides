# SnowPro Core Study Plan

## 6-Week Comprehensive Study Schedule

### Week 1: Architecture and Platform Fundamentals

#### Day 1-2: Three-Layer Architecture
- [ ] Study storage layer: micro-partitions, columnar format, compression
- [ ] Study compute layer: virtual warehouses, sizing, credits
- [ ] Study cloud services layer: metadata, optimization, security
- [ ] Hands-on: Create trial account and explore Snowsight
- [ ] Hands-on: Create warehouses of different sizes and observe credit usage
- [ ] Review Notes: `notes/01-architecture.md`

#### Day 3-4: Virtual Warehouses Deep Dive
- [ ] Learn warehouse sizing (X-Small through 6X-Large)
- [ ] Study auto-suspend and auto-resume behavior
- [ ] Understand multi-cluster warehouses (Enterprise+)
- [ ] Learn scaling policies: standard vs economy
- [ ] Hands-on: Create multi-cluster warehouse and test concurrency
- [ ] Hands-on: Test auto-suspend timing and resume behavior

#### Day 5-6: Editions and Connectivity
- [ ] Compare all four Snowflake editions and their features
- [ ] Study connectivity options (Snowsight, SnowSQL, drivers)
- [ ] Learn about Snowflake's support for AWS, Azure, and GCP
- [ ] Hands-on: Connect using SnowSQL CLI
- [ ] Hands-on: Test Python connector with simple queries

#### Day 7: Week 1 Review
- [ ] Complete architecture practice questions
- [ ] Review micro-partition and clustering concepts
- [ ] Create flashcards for edition-specific features
- [ ] Identify weak areas for additional review

### Week 2: Account Access and Security

#### Day 8-9: Role-Based Access Control
- [ ] Learn system-defined roles and their hierarchy
- [ ] Study RBAC model and privilege inheritance
- [ ] Practice GRANT and REVOKE statements
- [ ] Understand ownership and managed access schemas
- [ ] Hands-on: Create role hierarchy with custom roles
- [ ] Hands-on: Grant and test privileges at different levels
- [ ] Review Notes: `notes/02-security.md`

#### Day 10-11: Authentication and Network Security
- [ ] Study MFA enrollment and enforcement
- [ ] Learn key pair authentication setup
- [ ] Understand federated authentication (SAML 2.0)
- [ ] Study OAuth integration options
- [ ] Hands-on: Set up key pair authentication
- [ ] Hands-on: Create and test network policies

#### Day 12-13: Data Security Features
- [ ] Learn encryption at rest and in transit
- [ ] Study column-level security and masking policies
- [ ] Understand row access policies
- [ ] Learn about Tri-Secret Secure (Business Critical+)
- [ ] Hands-on: Create masking policies on sensitive columns
- [ ] Hands-on: Implement row access policies

#### Day 14: Week 2 Review
- [ ] Complete security domain practice questions
- [ ] Draw role hierarchy from memory
- [ ] Review authentication method comparison
- [ ] Practice security scenario questions

### Week 3: Performance Concepts

#### Day 15-16: Caching Mechanisms
- [ ] Study result cache behavior and invalidation
- [ ] Learn warehouse cache (local disk) mechanics
- [ ] Understand metadata cache and query pruning
- [ ] Hands-on: Test result cache with identical queries
- [ ] Hands-on: Observe warehouse cache by running similar queries
- [ ] Hands-on: Test cache invalidation after data changes
- [ ] Review Notes: `notes/03-performance.md`

#### Day 17-18: Clustering and Pruning
- [ ] Learn clustering key concepts and selection
- [ ] Study automatic clustering (Enterprise+)
- [ ] Understand SYSTEM$CLUSTERING_INFORMATION()
- [ ] Study SYSTEM$CLUSTERING_DEPTH()
- [ ] Hands-on: Create table with clustering key
- [ ] Hands-on: Monitor clustering depth over time

#### Day 19-20: Query Optimization
- [ ] Master Query Profile interpretation
- [ ] Learn to identify spillage, exploding joins, full scans
- [ ] Study warehouse sizing strategies for performance
- [ ] Understand resource monitors and alerts
- [ ] Hands-on: Analyze slow queries with Query Profile
- [ ] Hands-on: Set up resource monitors with thresholds

#### Day 21: Week 3 Review
- [ ] Complete performance practice questions
- [ ] Create comparison chart of caching types
- [ ] Review clustering key decision framework
- [ ] Practice Query Profile analysis scenarios

### Week 4: Data Loading, Unloading, and Transformations

#### Day 22-23: Data Loading
- [ ] Learn stage types: user, table, named, external
- [ ] Master COPY INTO syntax and options
- [ ] Study file formats: CSV, JSON, Parquet, Avro, ORC, XML
- [ ] Understand ON_ERROR and VALIDATION_MODE options
- [ ] Hands-on: Load data from internal stages
- [ ] Hands-on: Load data from external S3 stage
- [ ] Hands-on: Test different ON_ERROR scenarios
- [ ] Review Notes: `notes/04-data-loading.md`

#### Day 24-25: Snowpipe and Data Unloading
- [ ] Study Snowpipe architecture and auto-ingest
- [ ] Learn Snowpipe REST API endpoints
- [ ] Understand Snowpipe billing model
- [ ] Practice data unloading with COPY INTO location
- [ ] Hands-on: Set up Snowpipe with auto-ingest
- [ ] Hands-on: Unload data to different file formats

#### Day 26-27: Semi-Structured Data and Transformations
- [ ] Master VARIANT, OBJECT, and ARRAY data types
- [ ] Practice dot notation and bracket notation for JSON
- [ ] Learn FLATTEN function with LATERAL joins
- [ ] Study type casting with :: operator
- [ ] Hands-on: Load and query JSON data
- [ ] Hands-on: FLATTEN nested arrays and objects
- [ ] Hands-on: Create views over semi-structured data
- [ ] Review Notes: `notes/05-transformations.md`

#### Day 28: Week 4 Review
- [ ] Complete data loading practice questions
- [ ] Compare COPY INTO vs Snowpipe scenarios
- [ ] Practice semi-structured data queries
- [ ] Review file format options and stage types

### Week 5: Streams, Tasks, Data Protection, and Sharing

#### Day 29-30: Streams and Tasks
- [ ] Learn stream types (standard, append-only, insert-only)
- [ ] Study stream metadata columns
- [ ] Understand task scheduling (cron and interval)
- [ ] Learn task trees and DAG dependencies
- [ ] Hands-on: Create stream on a table and track changes
- [ ] Hands-on: Build task tree for automated pipeline

#### Day 31-32: Data Protection
- [ ] Master Time Travel syntax (AT, BEFORE)
- [ ] Understand retention periods by edition
- [ ] Learn Fail-safe behavior and limitations
- [ ] Study zero-copy cloning
- [ ] Hands-on: Query historical data with Time Travel
- [ ] Hands-on: Restore dropped tables using UNDROP
- [ ] Hands-on: Clone databases and tables

#### Day 33-34: Data Sharing and Marketplace
- [ ] Learn direct data sharing setup (provider/consumer)
- [ ] Understand reader accounts and their billing
- [ ] Study Snowflake Marketplace
- [ ] Learn database replication across regions
- [ ] Hands-on: Create a share and add objects to it
- [ ] Hands-on: Browse Snowflake Marketplace listings

#### Day 35: Week 5 Review
- [ ] Complete data protection practice questions
- [ ] Create Time Travel vs Fail-safe comparison chart
- [ ] Review sharing scenarios and reader accounts
- [ ] Practice streams and tasks integration questions

### Week 6: Final Review and Practice Exams

#### Day 36-37: Full Practice Exams
- [ ] Take practice exam 1 (timed, 115 minutes)
- [ ] Review all incorrect answers thoroughly
- [ ] Document weak areas and knowledge gaps
- [ ] Re-read relevant documentation sections
- [ ] Take practice exam 2 (timed)
- [ ] Compare scores and track improvement

#### Day 38-39: Targeted Review
- [ ] Focus study on lowest-scoring domains
- [ ] Review all exam scenarios in scenarios.md
- [ ] Go through fact sheet for quick recall
- [ ] Create mental models for complex topics
- [ ] Review edition-specific features table
- [ ] Practice common trick question patterns

#### Day 40-41: Final Practice and Confidence Building
- [ ] Take practice exam 3 (timed)
- [ ] Target: 80%+ on all domains
- [ ] Quick review of any remaining weak areas
- [ ] Review exam tactics in strategy.md
- [ ] Prepare exam day logistics (ID, environment for online proctoring)

#### Day 42: Exam Day
- [ ] Light review of fact sheet only
- [ ] Verify exam environment and technical requirements
- [ ] Take the exam with confidence
- [ ] Use flagging strategy for uncertain questions
- [ ] Review flagged questions before submitting

## Progress Tracking

### Domain Mastery Targets

| Domain | Weight | Target Score | Actual Score |
|--------|--------|-------------|-------------|
| Architecture | 25% | 85%+ | ____% |
| Account Access & Security | 20% | 85%+ | ____% |
| Performance Concepts | 15% | 80%+ | ____% |
| Data Loading/Unloading | 10% | 85%+ | ____% |
| Data Transformations | 20% | 80%+ | ____% |
| Data Protection & Sharing | 10% | 85%+ | ____% |

### Practice Exam Scores

| Practice Exam | Date | Score | Weak Areas |
|--------------|------|-------|------------|
| Exam 1 | ____ | ____% | __________ |
| Exam 2 | ____ | ____% | __________ |
| Exam 3 | ____ | ____% | __________ |
