# Confluent Certified Developer - Study Strategy

## 🎯 Study Approach

### Phase 1: Kafka Fundamentals (1-2 weeks)
1. **Core Architecture**
   - Understand brokers, topics, partitions, and replication
   - Learn how producers and consumers interact with the cluster
   - Study the role of ZooKeeper and KRaft mode

2. **Hands-on Setup**
   - Install Confluent Platform locally or use Docker
   - Create topics, produce and consume messages via CLI
   - Experiment with partition counts and replication factors

### Phase 2: Producer and Consumer Deep Dive (2-3 weeks)
1. **Producer Mastery**
   - Study all critical producer configurations
   - Understand acks, retries, and idempotence
   - Practice with different serializers (String, Avro, JSON)
   - Build sample producers in Java or Python

2. **Consumer Mastery**
   - Understand consumer groups and partition assignment
   - Study offset management (auto-commit vs manual commit)
   - Learn rebalance protocols and strategies
   - Build sample consumers with error handling

### Phase 3: Streams, Connect, and Schema Registry (2-3 weeks)
1. **Kafka Streams**
   - Build simple stream processing applications
   - Practice KStream and KTable operations
   - Implement windowed aggregations
   - Understand state stores and interactive queries

2. **Kafka Connect and Schema Registry**
   - Deploy source and sink connectors
   - Configure Single Message Transforms
   - Register schemas and test compatibility modes
   - Practice with Avro serialization end-to-end

### Phase 4: Exam Preparation (1 week)
1. **Practice Questions**
   - Take practice exams and review incorrect answers
   - Focus on configuration-heavy questions
   - Review domain weightings and adjust study focus

2. **Final Review**
   - Review fact sheet and key configuration values
   - Practice scenario-based problem solving
   - Review all compatibility modes and their rules

## 📚 Study Resources

### Official Confluent Resources
- **[📖 Confluent Developer](https://developer.confluent.io/)** - Free courses and tutorials
- **[📖 Kafka Tutorials](https://developer.confluent.io/tutorials/)** - Hands-on guided tutorials
- **[📖 Confluent Training](https://www.confluent.io/training/)** - Official instructor-led training
- **[📖 Apache Kafka Documentation](https://kafka.apache.org/documentation/)** - Core Kafka reference

### Recommended Courses
- **[📖 Apache Kafka for Developers (Confluent)](https://developer.confluent.io/courses/)** - Free foundational course
- **[📖 Kafka Streams 101](https://developer.confluent.io/courses/kafka-streams/get-started/)** - Free streams course
- **[📖 ksqlDB 101](https://developer.confluent.io/courses/ksqldb/intro/)** - Free ksqlDB course
- **[📖 Schema Registry 101](https://developer.confluent.io/courses/schema-registry/key-concepts/)** - Free Schema Registry course

### Practice and Hands-on
- **[📖 Confluent Examples](https://github.com/confluentinc/examples)** - GitHub repo with code examples
- **[📖 Kafka Quickstart](https://kafka.apache.org/quickstart)** - Getting started with Apache Kafka
- **[📖 Docker Compose for Confluent](https://github.com/confluentinc/cp-all-in-one)** - Quick local setup

## 🧠 Exam Tactics

### Question Strategy
1. **Configuration Questions** - Know default values and when to change them
2. **Architecture Questions** - Understand trade-offs between different approaches
3. **API Questions** - Know method signatures and return types
4. **Scenario Questions** - Map requirements to the right Kafka features

### Time Management
- **1.5 minutes per question** average
- **Flag and move** - Do not spend more than 2 minutes on any question
- **Reserve 10-15 minutes** for reviewing flagged questions
- **Easy wins first** - Answer questions you are confident about

### Domain Priorities (by weight)
1. **Development (30%)** - Highest weight, focus heavily on producer/consumer APIs
2. **Application Design (15%)** - Architecture and design patterns
3. **Kafka Streams (15%)** - Stream processing concepts and API
4. **Kafka Connect (15%)** - Connector configuration and management
5. **Schema Registry (15%)** - Schema evolution and compatibility
6. **ksqlDB (10%)** - SQL-based stream processing

### Key Areas to Master
- Producer and consumer configuration defaults and tuning
- Consumer group rebalancing and partition assignment
- Schema compatibility rules (backward, forward, full)
- Kafka Streams KStream vs KTable semantics
- Connect worker modes and REST API operations
- Exactly-once semantics configuration

## ⚠️ Common Pitfalls

1. **Confusing KStream and KTable semantics** - KStream is append-only, KTable is update
2. **Schema compatibility direction** - BACKWARD means new schema reads old data
3. **Consumer offset commit timing** - Auto-commit happens on poll(), not after processing
4. **Partition count changes** - Cannot decrease partitions, keys may reroute on increase
5. **acks=all vs acks=1** - acks=all requires all ISR replicas, not all replicas
6. **Windowing types** - Know the difference between tumbling, hopping, sliding, and session
7. **Connect converters vs transforms** - Converters handle serialization, transforms modify records
