# Confluent Certified Administrator for Apache Kafka - Fact Sheet

## 📋 Exam Overview

**Exam Name:** Confluent Certified Administrator for Apache Kafka
**Duration:** 90 minutes
**Questions:** 60 multiple-choice questions
**Passing Score:** 70%
**Cost:** $150 USD
**Valid For:** 2 years
**Delivery:** Online proctored

**[📖 Official Certification Page](https://www.confluent.io/certification/)** - Registration and official details
**[📖 Kafka Operations Guide](https://kafka.apache.org/documentation/#operations)** - Core administration reference
**[📖 Confluent Platform Docs](https://docs.confluent.io/platform/current/overview.html)** - Platform documentation

## 🎯 Target Audience

This certification is designed for:
- System administrators managing Kafka clusters
- DevOps engineers deploying and maintaining Kafka infrastructure
- Site reliability engineers responsible for Kafka availability
- Platform engineers building self-service Kafka platforms
- Professionals with 6+ months of Kafka administration experience

## 📚 Exam Domains

### Domain 1: Kafka Fundamentals (15%)

**Broker Architecture:**
- Each broker is a JVM process identified by a unique `broker.id`
- Brokers store partition log segments on local disk
- One broker serves as the controller (leader election, partition management)
- `log.dirs` - Directories for log segment storage (comma-separated for multiple disks)
- `num.partitions` - Default partition count for new topics (default: 1)
- `default.replication.factor` - Default replication factor (default: 1)

**Replication:**
- Replication factor determines total copies (including leader)
- ISR (In-Sync Replicas) - replicas fully caught up with the leader
- `replica.lag.time.max.ms` (default: 30000) - Max time before follower removed from ISR
- `min.insync.replicas` - Minimum ISR for acks=all writes
- `unclean.leader.election.enable` (default: false) - Allow non-ISR leader election

**Log Segments:**
- `log.segment.bytes` (default: 1073741824 / 1 GB) - Maximum segment size
- `log.roll.ms` / `log.roll.hours` (default: 168 hours / 7 days) - Segment roll time
- `log.index.size.max.bytes` (default: 10485760 / 10 MB) - Max index file size
- Active segment is the only segment receiving writes
- Index files map offsets to physical positions

**[📖 Broker Configuration](https://docs.confluent.io/platform/current/installation/configuration/broker-configs.html)** - All broker settings

### Domain 2: Managing and Operating (30%)

**Topic Management Commands:**
```bash
# Create topic
kafka-topics --bootstrap-server localhost:9092 --create --topic my-topic \
  --partitions 6 --replication-factor 3

# List topics
kafka-topics --bootstrap-server localhost:9092 --list

# Describe topic
kafka-topics --bootstrap-server localhost:9092 --describe --topic my-topic

# Alter partition count (increase only)
kafka-topics --bootstrap-server localhost:9092 --alter --topic my-topic --partitions 12

# Delete topic
kafka-topics --bootstrap-server localhost:9092 --delete --topic my-topic

# Override topic config
kafka-configs --bootstrap-server localhost:9092 --alter --entity-type topics \
  --entity-name my-topic --add-config retention.ms=86400000
```

**Partition Reassignment:**
```bash
# Generate reassignment plan
kafka-reassign-partitions --bootstrap-server localhost:9092 \
  --topics-to-move-json-file topics.json --broker-list "1,2,3" --generate

# Execute reassignment
kafka-reassign-partitions --bootstrap-server localhost:9092 \
  --reassignment-json-file plan.json --execute

# Verify reassignment
kafka-reassign-partitions --bootstrap-server localhost:9092 \
  --reassignment-json-file plan.json --verify
```

**Rolling Upgrade Process:**
1. Update broker configuration files
2. Restart brokers one at a time
3. Set `inter.broker.protocol.version` to old version initially
4. After all brokers upgraded, update `inter.broker.protocol.version`
5. Set `log.message.format.version` to new version
6. Restart brokers again (if protocol version changed)

**[📖 Upgrading Kafka](https://kafka.apache.org/documentation/#upgrade)** - Upgrade procedures

### Domain 3: Monitoring and Troubleshooting (20%)

**Critical JMX Metrics:**

| Metric | Description | Alert Threshold |
|--------|-------------|-----------------|
| `UnderReplicatedPartitions` | Partitions with fewer ISR than replication factor | > 0 |
| `ActiveControllerCount` | Number of active controllers (should be 1) | != 1 |
| `OfflinePartitionsCount` | Partitions without an active leader | > 0 |
| `IsrShrinksPerSec` | Rate of ISR shrinks | Sustained > 0 |
| `IsrExpandsPerSec` | Rate of ISR expansions | After shrinks |
| `RequestHandlerAvgIdlePercent` | Request handler thread idle ratio | < 0.3 |
| `NetworkProcessorAvgIdlePercent` | Network thread idle ratio | < 0.3 |
| `TotalTimeMs` (Produce/Fetch) | Request latency percentiles | p99 > threshold |
| `BytesInPerSec` / `BytesOutPerSec` | Broker throughput | Capacity threshold |
| `MessagesInPerSec` | Message rate | Capacity threshold |

**Consumer Lag Monitoring:**
```bash
kafka-consumer-groups --bootstrap-server localhost:9092 \
  --describe --group my-consumer-group
```

**[📖 Monitoring Kafka](https://docs.confluent.io/platform/current/kafka/monitoring.html)** - Monitoring best practices

### Domain 4: Security (15%)

**Authentication Mechanisms:**

| Mechanism | Protocol | Description |
|-----------|----------|-------------|
| SASL/PLAIN | SASL_PLAINTEXT, SASL_SSL | Username/password (simple, not recommended for production without SSL) |
| SASL/SCRAM | SASL_PLAINTEXT, SASL_SSL | Salted Challenge Response (secure password-based) |
| SASL/GSSAPI | SASL_PLAINTEXT, SASL_SSL | Kerberos authentication |
| SASL/OAUTHBEARER | SASL_PLAINTEXT, SASL_SSL | OAuth 2.0 token-based |
| SSL | SSL | Mutual TLS (certificate-based) |

**Security Protocols:**
- `PLAINTEXT` - No authentication, no encryption
- `SSL` - TLS encryption + optional mutual TLS auth
- `SASL_PLAINTEXT` - SASL auth, no encryption
- `SASL_SSL` - SASL auth + TLS encryption (recommended for production)

**ACL Management:**
```bash
# Add ACL
kafka-acls --bootstrap-server localhost:9092 --add \
  --allow-principal User:alice --operation Read --topic my-topic

# List ACLs
kafka-acls --bootstrap-server localhost:9092 --list --topic my-topic

# Remove ACL
kafka-acls --bootstrap-server localhost:9092 --remove \
  --allow-principal User:alice --operation Read --topic my-topic
```

**[📖 Kafka Security](https://docs.confluent.io/platform/current/security/index.html)** - Security configuration guide

### Domain 5: Confluent Platform (20%)

**Confluent Control Center:**
- Web-based management and monitoring UI
- Real-time broker, topic, and consumer group monitoring
- Message inspection and schema management
- Alert configuration and notification
- Connect and ksqlDB management

**Schema Registry HA:**
- Multiple Schema Registry instances behind a load balancer
- One primary instance (handles writes), others are secondaries (read-only)
- Leader election via Kafka (using `_schemas` topic)
- `schema.registry.group.id` for clustered deployment

**Connect Cluster Management:**
- Distributed workers share configuration via Kafka topics
- REST API for connector lifecycle management
- Worker rebalancing on add/remove/failure
- Plugin isolation with `plugin.path`

**[📖 Control Center](https://docs.confluent.io/platform/current/control-center/index.html)** - Control Center documentation
**[📖 Confluent Platform Operations](https://docs.confluent.io/platform/current/installation/index.html)** - Installation and operations

## 🔑 Critical Numbers to Remember

| Setting | Default Value |
|---------|--------------|
| `log.segment.bytes` | 1073741824 (1 GB) |
| `log.retention.hours` | 168 (7 days) |
| `log.retention.bytes` | -1 (unlimited) |
| `num.partitions` | 1 |
| `default.replication.factor` | 1 |
| `min.insync.replicas` | 1 |
| `replica.lag.time.max.ms` | 30000 (30 sec) |
| `num.io.threads` | 8 |
| `num.network.threads` | 3 |
| `num.recovery.threads.per.data.dir` | 1 |
| `log.cleaner.threads` | 1 |
| `zookeeper.session.timeout.ms` | 18000 (18 sec) |
| `broker.rack` | null |
