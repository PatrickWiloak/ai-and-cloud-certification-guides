# Confluent Platform

**[📖 Confluent Platform Overview](https://docs.confluent.io/platform/current/overview.html)** - Platform documentation
**[📖 Confluent Platform Installation](https://docs.confluent.io/platform/current/installation/index.html)** - Installation guide

## Confluent Control Center

**[📖 Control Center](https://docs.confluent.io/platform/current/control-center/index.html)** - Control Center documentation

### Overview
- Web-based management and monitoring interface for Confluent Platform
- Real-time visibility into brokers, topics, and consumer groups
- Message inspection and production
- Schema Registry management
- Kafka Connect and ksqlDB management
- Alerting and notification

### Key Features

**Cluster Monitoring:**
- Broker health and throughput metrics
- Topic-level metrics (messages in/out, bytes in/out)
- Partition distribution and leader balance
- Under-replicated partition alerts
- Cluster capacity trends

**Consumer Group Monitoring:**
- Consumer lag visualization (per partition)
- Consumer group state and membership
- Consumption rate and commit frequency
- Historical lag trends

**Topic Management:**
- Create, delete, and configure topics
- Browse messages (key, value, headers, timestamp)
- Schema viewing and management
- Partition details and replica status

**Alerting:**
- Pre-configured alerts for critical metrics
- Custom alert triggers
- Email, PagerDuty, and Slack notifications
- Alert history and acknowledgment

### Control Center Configuration

**Key Settings:**
```properties
# Connect to Kafka cluster
bootstrap.servers=broker1:9092,broker2:9092,broker3:9092

# Internal topic configuration
confluent.controlcenter.internal.topics.replication=3
confluent.controlcenter.internal.topics.partitions=12

# Monitoring interceptor configuration
confluent.controlcenter.streams.num.stream.threads=4

# Schema Registry connection
confluent.controlcenter.schema.registry.url=http://schema-registry:8081

# Connect cluster connection
confluent.controlcenter.connect.cluster=http://connect:8083

# ksqlDB connection
confluent.controlcenter.ksql.ksqldb1.url=http://ksqldb-server:8088
confluent.controlcenter.ksql.ksqldb1.advertised.url=http://ksqldb-server:8088

# Data retention
confluent.controlcenter.data.retention.ms=604800000
```

### Monitoring Interceptors
- Producer and consumer interceptors for enhanced monitoring
- Provide end-to-end latency metrics
- Enable message-level monitoring in Control Center
- Add to client configuration:
```properties
producer.interceptor.classes=io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor
consumer.interceptor.classes=io.confluent.monitoring.clients.interceptor.MonitoringConsumerInterceptor
```

## Schema Registry Administration

**[📖 Schema Registry](https://docs.confluent.io/platform/current/schema-registry/index.html)** - Schema Registry documentation

### Architecture
- Stores schemas in the `_schemas` internal Kafka topic
- Single writer (primary/leader) with multiple readers (secondary)
- Leader election via Kafka group protocol
- REST API on default port 8081
- Supports Avro, Protobuf, and JSON Schema

### High Availability Configuration

**Deployment Pattern:**
- Deploy 3+ Schema Registry instances
- All instances share the same `schema.registry.group.id`
- Place behind a load balancer
- Primary handles writes; any instance handles reads
- Automatic failover if primary fails

**Configuration:**
```properties
# Kafka connection
kafkastore.bootstrap.servers=broker1:9092,broker2:9092,broker3:9092

# Schema storage topic
kafkastore.topic=_schemas
kafkastore.topic.replication.factor=3

# Group ID for leader election
schema.registry.group.id=schema-registry-cluster

# Leader eligibility
master.eligibility=true

# Listener
listeners=http://0.0.0.0:8081

# Security (if Kafka uses SASL_SSL)
kafkastore.security.protocol=SASL_SSL
kafkastore.sasl.mechanism=SCRAM-SHA-256
kafkastore.sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username="schema-registry" password="password";
```

### Schema Registry Management

**Global Configuration:**
```bash
# Get global compatibility
curl http://localhost:8081/config

# Set global compatibility
curl -X PUT -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  --data '{"compatibility": "BACKWARD"}' \
  http://localhost:8081/config

# Set per-subject compatibility
curl -X PUT -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  --data '{"compatibility": "FULL"}' \
  http://localhost:8081/config/my-topic-value
```

**Schema Management:**
```bash
# List subjects
curl http://localhost:8081/subjects

# Get schema versions
curl http://localhost:8081/subjects/my-topic-value/versions

# Delete subject (soft delete)
curl -X DELETE http://localhost:8081/subjects/my-topic-value

# Permanent delete
curl -X DELETE http://localhost:8081/subjects/my-topic-value?permanent=true
```

### Schema Registry Security
- Basic authentication via REST proxy
- HTTPS with SSL/TLS
- Kafka ACLs for the `_schemas` topic
- RBAC integration in Confluent Platform

## Kafka Connect Management

**[📖 Connect Administration](https://docs.confluent.io/platform/current/connect/index.html)** - Connect documentation

### Distributed Mode Deployment

**Worker Configuration:**
```properties
# Kafka connection
bootstrap.servers=broker1:9092,broker2:9092,broker3:9092

# Connect cluster identity
group.id=connect-cluster

# Internal topic configuration
config.storage.topic=connect-configs
config.storage.replication.factor=3
offset.storage.topic=connect-offsets
offset.storage.replication.factor=3
offset.storage.partitions=25
status.storage.topic=connect-status
status.storage.replication.factor=3
status.storage.partitions=5

# Converter defaults
key.converter=org.apache.kafka.connect.json.JsonConverter
value.converter=io.confluent.connect.avro.AvroConverter
value.converter.schema.registry.url=http://schema-registry:8081

# REST API
rest.port=8083
rest.advertised.host.name=connect-worker1

# Plugin path
plugin.path=/usr/share/confluent-hub-components
```

### Connect REST API Operations

**Connector Lifecycle:**
```bash
# Create connector
curl -X POST -H "Content-Type: application/json" \
  --data '{
    "name": "jdbc-source",
    "config": {
      "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
      "connection.url": "jdbc:postgresql://db:5432/mydb",
      "table.whitelist": "users,orders",
      "tasks.max": "3",
      "mode": "incrementing",
      "incrementing.column.name": "id"
    }
  }' http://localhost:8083/connectors

# Get connector status
curl http://localhost:8083/connectors/jdbc-source/status

# Pause connector
curl -X PUT http://localhost:8083/connectors/jdbc-source/pause

# Resume connector
curl -X PUT http://localhost:8083/connectors/jdbc-source/resume

# Restart connector
curl -X POST http://localhost:8083/connectors/jdbc-source/restart

# Restart specific task
curl -X POST http://localhost:8083/connectors/jdbc-source/tasks/0/restart

# Delete connector
curl -X DELETE http://localhost:8083/connectors/jdbc-source
```

### Connect Cluster Management

**Worker Scaling:**
- Add workers to the Connect cluster by starting new instances with same `group.id`
- Tasks automatically rebalance across workers
- Remove workers by stopping them - tasks redistribute

**Plugin Management:**
- Install plugins via Confluent Hub: `confluent-hub install confluentinc/kafka-connect-jdbc:latest`
- Or manually place JARs in `plugin.path` directory
- Use plugin isolation (each connector in its own subdirectory)
- Restart workers after adding new plugins

**Monitoring Connect:**
- REST API status endpoints for health checks
- JMX metrics for connector and task performance
- Control Center for visual monitoring
- Monitor Connect internal topics for configuration and offset status

### Common Connect Issues

| Issue | Cause | Resolution |
|-------|-------|------------|
| Task FAILED status | Error in connector logic | Check task status for stack trace, fix config |
| Frequent rebalances | Workers joining/leaving | Check worker health, network stability |
| Slow throughput | Insufficient tasks | Increase `tasks.max`, add workers |
| Data loss | Converter mismatch | Verify converter configuration matches data |
| Out of memory | Large messages or too many tasks | Increase heap, reduce tasks per worker |

## ksqlDB Administration

**[📖 ksqlDB Administration](https://docs.confluent.io/platform/current/ksqldb/operate-and-deploy/index.html)** - ksqlDB operations guide

### Deployment Modes

**Interactive Mode:**
- Queries submitted via CLI or REST API
- Good for development and ad-hoc queries
- Queries can be added/removed at any time

**Headless Mode:**
- Queries loaded from a file at startup
- Recommended for production deployments
- No interactive query submission
- Configuration: `ksql.queries.file=/path/to/queries.sql`

### ksqlDB Server Configuration

```properties
# Kafka connection
bootstrap.servers=broker1:9092,broker2:9092,broker3:9092

# ksqlDB service ID (consumer group prefix)
ksql.service.id=my-ksqldb-cluster

# Listener
listeners=http://0.0.0.0:8088

# State directory
ksql.streams.state.dir=/var/lib/ksqldb

# Processing threads
ksql.streams.num.stream.threads=4

# Schema Registry
ksql.schema.registry.url=http://schema-registry:8081

# Connect integration
ksql.connect.url=http://connect:8083

# Internal topic replication
ksql.internal.topic.replicas=3

# Headless mode (production)
# ksql.queries.file=/etc/ksqldb/queries.sql
```

### ksqlDB Cluster Management

**Scaling:**
- Add ksqlDB servers with the same `ksql.service.id`
- Persistent queries automatically distribute across servers
- Processing parallelism based on input topic partitions

**Health Monitoring:**
```bash
# Server health check
curl http://localhost:8088/healthcheck

# Server info
curl http://localhost:8088/info

# List running queries
curl -X POST http://localhost:8088/ksql \
  -H "Content-Type: application/vnd.ksql.v1+json" \
  -d '{"ksql": "SHOW QUERIES;"}'
```

**Resource Management:**
- Monitor state store size on disk (`ksql.streams.state.dir`)
- Monitor JVM heap usage
- Set processing thread count based on partitions
- Configure RocksDB cache size for state stores

## Confluent Platform Components Summary

| Component | Default Port | Purpose |
|-----------|-------------|---------|
| Kafka Broker | 9092 | Message broker |
| ZooKeeper | 2181 | Metadata store (legacy) |
| Schema Registry | 8081 | Schema management |
| Kafka Connect | 8083 | Data integration |
| ksqlDB | 8088 | Stream processing |
| Control Center | 9021 | Web UI monitoring |
| REST Proxy | 8082 | REST API for Kafka |

### Internal Topics

| Topic | Purpose |
|-------|---------|
| `__consumer_offsets` | Consumer group offset storage |
| `__transaction_state` | Transactional producer state |
| `_schemas` | Schema Registry storage |
| `connect-configs` | Connect connector configurations |
| `connect-offsets` | Connect source connector offsets |
| `connect-status` | Connect connector/task status |
| `__cluster_metadata` | KRaft cluster metadata |
| `_confluent-command` | Control Center commands |
| `_confluent-metrics` | Monitoring metrics |
