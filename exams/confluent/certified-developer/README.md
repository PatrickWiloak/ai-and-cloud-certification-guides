# Confluent Certified Developer for Apache Kafka

## Exam Overview

The Confluent Certified Developer for Apache Kafka exam validates the ability to develop applications using Apache Kafka and the Confluent Platform. This certification demonstrates proficiency in building event-driven architectures, implementing streaming data pipelines, and working with the Kafka ecosystem including Kafka Streams, ksqlDB, and Schema Registry.

**Exam Details:**
- **Exam Code:** Confluent Certified Developer
- **Duration:** 90 minutes
- **Number of Questions:** 60 multiple-choice questions
- **Passing Score:** 70%
- **Cost:** $150 USD
- **Delivery:** Online proctored
- **Validity:** 2 years
- **Prerequisites:** None (hands-on Kafka development experience recommended)

## Exam Domains

### Domain 1: Application Design (15%)
- Designing event-driven architectures with Kafka
- Choosing between different messaging models (publish/subscribe vs point-to-point)
- Data modeling for Kafka topics
- Partitioning strategies and key design
- Topic naming conventions and organization

**Key Concepts:**
- Event sourcing and CQRS patterns
- Exactly-once semantics (EOS)
- Idempotent producers
- Transactional messaging

### Domain 2: Development (30%)
- Producer API configuration and best practices
- Consumer API and consumer group management
- Offset management and commit strategies
- Error handling and retry patterns
- Serialization and deserialization

**Key APIs:**
- KafkaProducer (send, flush, partitioner)
- KafkaConsumer (subscribe, poll, commit)
- AdminClient (topic management)
- Serializers/Deserializers (String, Avro, JSON, Protobuf)

### Domain 3: Kafka Streams (15%)
- Stream processing topology design
- KStream and KTable abstractions
- Stateful and stateless transformations
- Windowing operations (tumbling, hopping, sliding, session)
- Interactive queries

**Key Concepts:**
- Stream-table duality
- GlobalKTable for enrichment
- State stores (RocksDB)
- Exactly-once stream processing

### Domain 4: ksqlDB (10%)
- Creating streams and tables
- Push and pull queries
- Materialized views
- User-defined functions
- Persistent queries

**Key Concepts:**
- Stream-stream joins
- Stream-table joins
- Aggregations and windowed aggregations
- ksqlDB REST API

### Domain 5: Kafka Connect (15%)
- Source and sink connectors
- Single Message Transforms (SMTs)
- Converter configuration
- Dead letter queues
- Connector lifecycle management

**Key Concepts:**
- Standalone vs distributed mode
- Worker configuration
- Task parallelism
- Connect REST API

### Domain 6: Schema Registry (15%)
- Schema evolution and compatibility modes
- Avro, Protobuf, and JSON Schema support
- Subject naming strategies
- Schema references
- Integration with producers and consumers

**Key Concepts:**
- Forward, backward, and full compatibility
- Schema ID and subject versioning
- Content types and serialization formats
- Schema Registry REST API

## Study Materials

### Official Resources
- **[📖 Apache Kafka Documentation](https://kafka.apache.org/documentation/)** - Complete Kafka reference documentation
- **[📖 Confluent Documentation](https://docs.confluent.io/)** - Confluent Platform and Cloud documentation
- **[📖 Confluent Developer](https://developer.confluent.io/)** - Tutorials, courses, and developer resources
- **[📖 Kafka Streams Documentation](https://kafka.apache.org/documentation/streams/)** - Stream processing API guide

### Study Guide Files
| Resource | Description |
|----------|-------------|
| [Fact Sheet](fact-sheet.md) | Quick reference with exam details and key facts |
| [Study Strategy](strategy.md) | Recommended study approach and timeline |
| [Practice Plan](practice-plan.md) | Week-by-week study schedule with hands-on labs |
| [Scenarios](scenarios.md) | High-yield exam scenarios and solution patterns |
| [Notes](notes/) | Detailed topic notes organized by domain |

### Notes Index
| File | Topics Covered |
|------|---------------|
| [01 - Kafka Fundamentals](notes/01-kafka-fundamentals.md) | Topics, partitions, brokers, replication |
| [02 - Producer & Consumer API](notes/02-producer-consumer-api.md) | Producer configs, consumer groups, offsets |
| [03 - Kafka Streams](notes/03-kafka-streams.md) | Topology, KStream/KTable, windowing |
| [04 - Connect & Schema Registry](notes/04-connect-and-schema-registry.md) | Connectors, transformations, Avro/Protobuf |
| [05 - ksqlDB](notes/05-ksqldb.md) | Queries, materialized views, push/pull |
