# Confluent Certified Developer - Study Plan

## 6-Week Comprehensive Study Schedule

### Week 1: Kafka Fundamentals and Architecture

#### Day 1-2: Core Concepts
- [ ] Study Kafka architecture (brokers, topics, partitions, segments)
- [ ] Understand replication (leader, follower, ISR)
- [ ] Learn about ZooKeeper role and KRaft mode
- [ ] Hands-on: Install Confluent Platform via Docker
- [ ] Lab: Create topics with different partition counts and replication factors
- [ ] Review Notes: `01-kafka-fundamentals.md`

#### Day 3-4: Topic Design and Configuration
- [ ] Study topic-level configurations (retention, cleanup policy, compression)
- [ ] Learn partitioning strategies and key selection
- [ ] Understand log compaction vs log deletion
- [ ] Hands-on: Configure topics with different retention and compaction settings
- [ ] Lab: Produce messages with keys and observe partition assignment
- [ ] Review Notes: `01-kafka-fundamentals.md`

#### Day 5-6: Message Delivery Semantics
- [ ] Study at-most-once, at-least-once, and exactly-once delivery
- [ ] Understand idempotent producers and transactional messaging
- [ ] Learn about consumer offset management
- [ ] Hands-on: Configure idempotent producer and observe behavior
- [ ] Lab: Implement transactional producer with atomic writes

#### Day 7: Week 1 Review
- [ ] Complete fundamentals practice questions
- [ ] Review any weak areas identified
- [ ] Summarize key configuration parameters

### Week 2: Producer API Deep Dive

#### Day 8-9: Producer Configuration
- [ ] Study all critical producer configs (acks, retries, batch.size, linger.ms)
- [ ] Understand buffering and batching behavior
- [ ] Learn compression options and trade-offs
- [ ] Hands-on: Build a Java/Python producer with custom configuration
- [ ] Lab: Benchmark throughput with different batch and compression settings
- [ ] Review Notes: `02-producer-consumer-api.md`

#### Day 10-11: Producer Patterns
- [ ] Implement custom partitioners
- [ ] Study callback-based asynchronous sending
- [ ] Learn error handling and retry strategies
- [ ] Hands-on: Build producer with custom partitioner and callbacks
- [ ] Lab: Implement producer with error handling and dead letter queue

#### Day 12-13: Serialization
- [ ] Study built-in serializers (String, Integer, ByteArray)
- [ ] Learn Avro serialization with Schema Registry
- [ ] Understand Protobuf and JSON Schema serialization
- [ ] Hands-on: Produce Avro messages with Schema Registry integration
- [ ] Lab: Test schema evolution with backward and forward changes

#### Day 14: Week 2 Review
- [ ] Complete producer API practice questions
- [ ] Review producer configuration defaults and tuning
- [ ] Build a production-ready producer application

### Week 3: Consumer API Deep Dive

#### Day 15-16: Consumer Groups and Rebalancing
- [ ] Study consumer group mechanics and partition assignment
- [ ] Understand rebalance triggers and protocols
- [ ] Learn cooperative vs eager rebalancing
- [ ] Hands-on: Run multiple consumers in a group and observe assignments
- [ ] Lab: Simulate consumer failures and observe rebalancing
- [ ] Review Notes: `02-producer-consumer-api.md`

#### Day 17-18: Offset Management
- [ ] Study auto-commit vs manual commit (sync and async)
- [ ] Understand auto.offset.reset behavior
- [ ] Learn offset storage and the __consumer_offsets topic
- [ ] Hands-on: Implement manual offset commit with at-least-once semantics
- [ ] Lab: Implement exactly-once consumption with manual offset management

#### Day 19-20: Consumer Tuning and Patterns
- [ ] Study max.poll.records, max.poll.interval.ms, session.timeout.ms
- [ ] Learn multi-threaded consumer patterns
- [ ] Understand consumer lag monitoring
- [ ] Hands-on: Tune consumer for high-throughput and low-latency scenarios
- [ ] Lab: Build consumer with graceful shutdown and rebalance listener

#### Day 21: Week 3 Review
- [ ] Complete consumer API practice questions
- [ ] Review consumer configuration defaults
- [ ] End-to-end producer-consumer application test

### Week 4: Kafka Streams

#### Day 22-23: Stream Processing Basics
- [ ] Study Kafka Streams architecture (topology, tasks, threads)
- [ ] Learn KStream and KTable abstractions
- [ ] Understand stateless transformations (filter, map, flatMap, branch)
- [ ] Hands-on: Build a simple stream processing application
- [ ] Lab: Implement filtering and transformation pipeline
- [ ] Review Notes: `03-kafka-streams.md`

#### Day 24-25: Stateful Operations
- [ ] Study aggregations (count, aggregate, reduce)
- [ ] Learn windowing types (tumbling, hopping, sliding, session)
- [ ] Understand state stores and changelog topics
- [ ] Hands-on: Implement windowed aggregation application
- [ ] Lab: Build real-time analytics with count and aggregate

#### Day 26-27: Joins and Advanced Topics
- [ ] Study join types (KStream-KStream, KStream-KTable, KTable-KTable)
- [ ] Learn GlobalKTable for enrichment joins
- [ ] Understand interactive queries for state store access
- [ ] Hands-on: Implement stream-table join for data enrichment
- [ ] Lab: Build interactive query endpoint for state store

#### Day 28: Week 4 Review
- [ ] Complete Kafka Streams practice questions
- [ ] Review join semantics and windowing rules
- [ ] Build end-to-end stream processing application

### Week 5: Connect, Schema Registry, and ksqlDB

#### Day 29-30: Kafka Connect
- [ ] Study Connect architecture (workers, connectors, tasks)
- [ ] Learn standalone vs distributed mode
- [ ] Understand Single Message Transforms (SMTs)
- [ ] Hands-on: Deploy FileSource and FileSink connectors
- [ ] Lab: Configure JDBC source connector with transforms
- [ ] Review Notes: `04-connect-and-schema-registry.md`

#### Day 31-32: Schema Registry
- [ ] Study schema compatibility modes (backward, forward, full, transitive)
- [ ] Learn subject naming strategies
- [ ] Understand schema references and nested types
- [ ] Hands-on: Register schemas via REST API
- [ ] Lab: Test compatibility by evolving schemas through versions
- [ ] Review Notes: `04-connect-and-schema-registry.md`

#### Day 33-34: ksqlDB
- [ ] Study ksqlDB streams and tables
- [ ] Learn push queries vs pull queries
- [ ] Understand persistent queries and materialized views
- [ ] Hands-on: Create streams, tables, and persistent queries
- [ ] Lab: Build real-time dashboard with push queries
- [ ] Review Notes: `05-ksqldb.md`

#### Day 35: Week 5 Review
- [ ] Complete Connect, Schema Registry, and ksqlDB practice questions
- [ ] Review connector configuration and SMTs
- [ ] Review schema compatibility rules

### Week 6: Exam Preparation

#### Day 36-37: Full Practice Exams
- [ ] Take first full-length practice exam
- [ ] Review all incorrect answers with documentation
- [ ] Identify weak domains and knowledge gaps
- [ ] Create flashcards for missed concepts

#### Day 38-39: Targeted Review
- [ ] Focus study on weakest domains
- [ ] Review all configuration defaults and critical settings
- [ ] Practice scenario-based questions
- [ ] Review fact sheet and key numbers

#### Day 40-41: Final Review
- [ ] Take second full-length practice exam
- [ ] Review producer/consumer configuration table
- [ ] Review schema compatibility matrix
- [ ] Review Kafka Streams join requirements
- [ ] Light review of all notes

#### Day 42: Exam Day Preparation
- [ ] Quick review of fact sheet
- [ ] Review common pitfalls and tricky topics
- [ ] Ensure exam environment is ready
- [ ] Rest and prepare mentally

## 📊 Domain Study Time Allocation

| Domain | Weight | Recommended Hours |
|--------|--------|-------------------|
| Development | 30% | 20-25 hours |
| Application Design | 15% | 10-12 hours |
| Kafka Streams | 15% | 10-12 hours |
| Kafka Connect | 15% | 8-10 hours |
| Schema Registry | 15% | 8-10 hours |
| ksqlDB | 10% | 6-8 hours |
| **Total** | **100%** | **62-77 hours** |
