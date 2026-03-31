# Confluent Certified Developer for Apache Kafka - Fact Sheet

## 📋 Exam Overview

**Exam Name:** Confluent Certified Developer for Apache Kafka
**Duration:** 90 minutes
**Questions:** 60 multiple-choice questions
**Passing Score:** 70%
**Cost:** $150 USD
**Valid For:** 2 years
**Delivery:** Online proctored

**[📖 Official Certification Page](https://www.confluent.io/certification/)** - Registration and official details
**[📖 Confluent Developer](https://developer.confluent.io/)** - Free tutorials and courses
**[📖 Apache Kafka Documentation](https://kafka.apache.org/documentation/)** - Core Kafka reference

## 🎯 Target Audience

This certification is designed for:
- Software engineers building applications with Apache Kafka
- Data engineers implementing streaming data pipelines
- Backend developers working with event-driven architectures
- DevOps engineers managing Kafka-based applications
- Professionals with 6+ months of Kafka development experience

## 📚 Exam Domains

### Domain 1: Application Design (15%)

**Core Topics:**
- Event-driven architecture patterns
- Topic design and partitioning strategies
- Key selection for ordering guarantees
- Exactly-once semantics (EOS) configuration
- Idempotent producer design

**Key Facts:**
- Kafka guarantees ordering within a partition, not across partitions
- Default partition count cannot be decreased after topic creation
- Idempotent producers require `enable.idempotence=true`
- Transactional producers enable atomic writes across multiple partitions
- Retention can be time-based (`retention.ms`) or size-based (`retention.bytes`)

**[📖 Kafka Design](https://kafka.apache.org/documentation/#design)** - Architecture and design principles
**[📖 Topic Configuration](https://docs.confluent.io/platform/current/installation/configuration/topic-configs.html)** - Topic-level configuration reference

### Domain 2: Development (30%)

**Producer Configuration - Critical Settings:**
- `acks=all` - Wait for all in-sync replicas to acknowledge
- `acks=1` - Wait for leader acknowledgment only
- `acks=0` - No acknowledgment (fire and forget)
- `retries` - Number of retry attempts (default: Integer.MAX_VALUE with idempotence)
- `batch.size` - Batch size in bytes (default: 16384)
- `linger.ms` - Delay before sending batch (default: 0)
- `buffer.memory` - Total memory for buffering (default: 32MB)
- `max.in.flight.requests.per.connection` - Max unacknowledged requests (set to 5 or less with idempotence)
- `compression.type` - Compression codec (none, gzip, snappy, lz4, zstd)

**Consumer Configuration - Critical Settings:**
- `group.id` - Consumer group identifier
- `auto.offset.reset` - Behavior when no offset exists (earliest, latest, none)
- `enable.auto.commit` - Automatic offset commit (default: true)
- `auto.commit.interval.ms` - Auto-commit frequency (default: 5000)
- `max.poll.records` - Max records per poll (default: 500)
- `max.poll.interval.ms` - Max time between polls before rebalance (default: 300000)
- `session.timeout.ms` - Consumer heartbeat timeout (default: 45000)
- `fetch.min.bytes` - Minimum fetch size (default: 1)
- `fetch.max.wait.ms` - Max wait for fetch.min.bytes (default: 500)

**[📖 Producer API](https://kafka.apache.org/documentation/#producerapi)** - Producer API reference
**[📖 Consumer API](https://kafka.apache.org/documentation/#consumerapi)** - Consumer API reference
**[📖 Producer Configuration](https://docs.confluent.io/platform/current/installation/configuration/producer-configs.html)** - All producer settings
**[📖 Consumer Configuration](https://docs.confluent.io/platform/current/installation/configuration/consumer-configs.html)** - All consumer settings

### Domain 3: Kafka Streams (15%)

**Key Abstractions:**
- **KStream** - Record stream (insert semantics, each record is independent)
- **KTable** - Changelog stream (upsert semantics, latest value per key)
- **GlobalKTable** - Fully replicated table on each instance (for enrichment joins)

**Supported Operations:**
- **Stateless**: filter, map, flatMap, mapValues, branch, merge, selectKey
- **Stateful**: aggregate, count, reduce, join, window
- **Windowing**: Tumbling, Hopping, Sliding, Session windows

**Key Facts:**
- KStream-KStream joins require a windowed join
- KTable-KTable joins produce a new KTable
- KStream-KTable joins are non-windowed (latest table value)
- State stores use RocksDB by default
- Exactly-once processing requires `processing.guarantee=exactly_once_v2`

**[📖 Kafka Streams Concepts](https://docs.confluent.io/platform/current/streams/concepts.html)** - Core concepts guide
**[📖 Kafka Streams Developer Guide](https://docs.confluent.io/platform/current/streams/developer-guide/index.html)** - Complete developer reference

### Domain 4: ksqlDB (10%)

**Key Concepts:**
- **Streams** - Immutable, append-only collections (backed by Kafka topics)
- **Tables** - Mutable collections with latest value per key
- **Push Queries** - Continuous queries that emit results as data changes (`EMIT CHANGES`)
- **Pull Queries** - Point-in-time lookups against materialized views
- **Persistent Queries** - Continuously running queries that write to topics

**Important Syntax:**
- `CREATE STREAM` - Define a stream from a topic
- `CREATE TABLE` - Define a table from a topic
- `CREATE STREAM AS SELECT` - Create derived stream (persistent query)
- `INSERT INTO` - Insert data into a stream
- `SHOW QUERIES` - List running persistent queries

**[📖 ksqlDB Documentation](https://docs.confluent.io/platform/current/ksqldb/index.html)** - Complete ksqlDB reference
**[📖 ksqlDB Quickstart](https://docs.confluent.io/platform/current/ksqldb/quickstart.html)** - Getting started guide

### Domain 5: Kafka Connect (15%)

**Architecture:**
- **Workers** - Processes that run connectors and tasks
- **Connectors** - Define the source/sink and configuration
- **Tasks** - Units of work that move data
- **Converters** - Handle serialization (JSON, Avro, Protobuf)

**Key Configuration:**
- `connector.class` - Connector implementation class
- `tasks.max` - Maximum number of tasks
- `key.converter` / `value.converter` - Serialization format
- `transforms` - Single Message Transforms chain
- `errors.tolerance` - Error handling (none, all)
- `errors.deadletterqueue.topic.name` - DLQ topic for failed records

**[📖 Kafka Connect](https://docs.confluent.io/platform/current/connect/index.html)** - Connect framework documentation
**[📖 Connect REST API](https://docs.confluent.io/platform/current/connect/references/restapi.html)** - REST API reference

### Domain 6: Schema Registry (15%)

**Compatibility Modes:**
- **BACKWARD** (default) - New schema can read old data
- **FORWARD** - Old schema can read new data
- **FULL** - Both backward and forward compatible
- **BACKWARD_TRANSITIVE** - Backward compatible with all previous versions
- **FORWARD_TRANSITIVE** - Forward compatible with all previous versions
- **FULL_TRANSITIVE** - Full compatibility with all previous versions
- **NONE** - No compatibility checking

**Key Facts:**
- Default subject naming: `<topic>-key` and `<topic>-value`
- Schema IDs are globally unique integers
- Supports Avro, Protobuf, and JSON Schema
- Schemas are stored in the `_schemas` internal topic
- Adding a field with a default is backward compatible
- Removing a field with a default is forward compatible

**[📖 Schema Registry](https://docs.confluent.io/platform/current/schema-registry/index.html)** - Schema Registry documentation
**[📖 Schema Evolution](https://docs.confluent.io/platform/current/schema-registry/fundamentals/schema-evolution.html)** - Compatibility and evolution guide

## 🔑 Critical Numbers to Remember

| Setting | Default Value |
|---------|--------------|
| `batch.size` (producer) | 16384 bytes (16 KB) |
| `linger.ms` (producer) | 0 ms |
| `buffer.memory` (producer) | 33554432 bytes (32 MB) |
| `max.poll.records` (consumer) | 500 |
| `max.poll.interval.ms` (consumer) | 300000 ms (5 min) |
| `session.timeout.ms` (consumer) | 45000 ms (45 sec) |
| `auto.commit.interval.ms` | 5000 ms (5 sec) |
| Default replication factor | 1 (production: 3) |
| Default partitions | 1 |
| Default retention | 7 days (168 hours) |
