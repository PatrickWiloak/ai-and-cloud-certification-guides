# Cluster Operations

**[📖 Kafka Operations](https://kafka.apache.org/documentation/#operations)** - Official operations guide
**[📖 Confluent Operations](https://docs.confluent.io/platform/current/kafka/index.html)** - Confluent operations reference

## Topic Management

### Creating Topics

```bash
# Create with specific settings
kafka-topics --bootstrap-server localhost:9092 --create \
  --topic my-topic \
  --partitions 12 \
  --replication-factor 3 \
  --config retention.ms=604800000 \
  --config cleanup.policy=delete

# Create compacted topic
kafka-topics --bootstrap-server localhost:9092 --create \
  --topic my-compacted-topic \
  --partitions 6 \
  --replication-factor 3 \
  --config cleanup.policy=compact \
  --config min.compaction.lag.ms=3600000
```

**[📖 Topic Operations](https://kafka.apache.org/documentation/#basic_ops_add_topic)** - Topic management commands

### Describing Topics

```bash
# Describe single topic
kafka-topics --bootstrap-server localhost:9092 --describe --topic my-topic

# Describe all topics
kafka-topics --bootstrap-server localhost:9092 --describe

# Show topics with overridden configs
kafka-topics --bootstrap-server localhost:9092 --describe --topics-with-overrides

# Show under-replicated partitions
kafka-topics --bootstrap-server localhost:9092 --describe --under-replicated-partitions

# Show unavailable partitions
kafka-topics --bootstrap-server localhost:9092 --describe --unavailable-partitions
```

### Modifying Topics

```bash
# Increase partitions (cannot decrease)
kafka-topics --bootstrap-server localhost:9092 --alter \
  --topic my-topic --partitions 24

# Modify topic configuration
kafka-configs --bootstrap-server localhost:9092 --alter \
  --entity-type topics --entity-name my-topic \
  --add-config retention.ms=86400000,max.message.bytes=2097152

# Remove topic configuration override (revert to broker default)
kafka-configs --bootstrap-server localhost:9092 --alter \
  --entity-type topics --entity-name my-topic \
  --delete-config retention.ms

# Describe topic configuration
kafka-configs --bootstrap-server localhost:9092 --describe \
  --entity-type topics --entity-name my-topic
```

### Deleting Topics
```bash
kafka-topics --bootstrap-server localhost:9092 --delete --topic my-topic
```
- Requires `delete.topic.enable=true` (default: true)
- Deletion is asynchronous - log segments deleted in background
- Cannot be undone

## Topic Configuration Reference

### Retention Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `retention.ms` | 604800000 (7 days) | Time-based retention |
| `retention.bytes` | -1 (unlimited) | Size-based retention per partition |
| `cleanup.policy` | delete | delete, compact, or compact,delete |
| `segment.bytes` | 1073741824 (1 GB) | Segment file size |
| `segment.ms` | 604800000 (7 days) | Segment roll time |
| `min.compaction.lag.ms` | 0 | Min time before compaction |
| `max.compaction.lag.ms` | 9223372036854775807 | Max time without compaction |
| `delete.retention.ms` | 86400000 (24 hours) | Tombstone retention |

### Performance Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `max.message.bytes` | 1048588 (~1 MB) | Max message size |
| `min.insync.replicas` | 1 | Min ISR for acks=all |
| `flush.messages` | 9223372036854775807 | Messages before forced flush |
| `flush.ms` | 9223372036854775807 | Time before forced flush |
| `index.interval.bytes` | 4096 | Index entry interval |
| `compression.type` | producer | Compression at topic level |

## Partition Reassignment

**[📖 Partition Reassignment](https://kafka.apache.org/documentation/#basic_ops_cluster_expansion)** - Cluster expansion and reassignment

### Generate Reassignment Plan

**topics.json:**
```json
{
  "topics": [
    {"topic": "my-topic"},
    {"topic": "another-topic"}
  ],
  "version": 1
}
```

```bash
kafka-reassign-partitions --bootstrap-server localhost:9092 \
  --topics-to-move-json-file topics.json \
  --broker-list "1,2,3,4,5" \
  --generate
```
- Outputs current assignment and proposed reassignment
- Review proposed plan before executing

### Execute Reassignment

```bash
kafka-reassign-partitions --bootstrap-server localhost:9092 \
  --reassignment-json-file reassignment.json \
  --execute \
  --throttle 50000000  # 50 MB/s throttle
```
- Throttle prevents reassignment from overwhelming the cluster
- Data is replicated to new brokers while existing data remains available
- High throttle = faster reassignment but more cluster impact

### Verify Reassignment

```bash
kafka-reassign-partitions --bootstrap-server localhost:9092 \
  --reassignment-json-file reassignment.json \
  --verify
```
- Shows status: in-progress, completed, or failed
- Automatically removes throttle after completion

### Preferred Leader Election

```bash
# Trigger preferred leader election for all partitions
kafka-leader-election --bootstrap-server localhost:9092 \
  --election-type preferred --all-topic-partitions

# Trigger for specific topic
kafka-leader-election --bootstrap-server localhost:9092 \
  --election-type preferred --topic my-topic --partition 0
```

- Preferred leader is the first replica in the replica list
- `auto.leader.rebalance.enable` (default: true) - Automatic preferred election
- `leader.imbalance.check.interval.seconds` (default: 300) - Check interval
- `leader.imbalance.per.broker.percentage` (default: 10) - Threshold percentage

## Rolling Upgrades

### Pre-Upgrade Checklist
1. Verify current cluster health (no under-replicated partitions)
2. Review release notes for the target version
3. Check compatibility of client libraries
4. Back up configuration files
5. Test upgrade procedure in a staging environment

### Upgrade Procedure

**Step 1: Prepare configuration**
```properties
# Set inter.broker.protocol.version to current version
inter.broker.protocol.version=3.4
# Set log.message.format.version to current version (if applicable)
log.message.format.version=3.4
```

**Step 2: Rolling upgrade of binaries**
- For each broker (one at a time):
  1. Stop the broker gracefully
  2. Replace broker binaries with new version
  3. Start the broker with old protocol version in config
  4. Wait for all partitions to be in-sync before proceeding

**Step 3: Update protocol version**
```properties
# After ALL brokers are running new version
inter.broker.protocol.version=3.5
log.message.format.version=3.5
```

**Step 4: Final rolling restart**
- Restart each broker to pick up new protocol version
- Verify cluster health after each restart

### Graceful Shutdown
- `controlled.shutdown.enable` (default: true) - Move leaders before stopping
- `controlled.shutdown.max.retries` (default: 3) - Retry attempts
- Broker transfers partition leadership before stopping
- Reduces unavailability window during upgrades

## Consumer Group Management

### Describe Consumer Groups

```bash
# List all consumer groups
kafka-consumer-groups --bootstrap-server localhost:9092 --list

# Describe specific group
kafka-consumer-groups --bootstrap-server localhost:9092 \
  --describe --group my-consumer-group

# Show group state
kafka-consumer-groups --bootstrap-server localhost:9092 \
  --describe --group my-consumer-group --state

# Show members
kafka-consumer-groups --bootstrap-server localhost:9092 \
  --describe --group my-consumer-group --members
```

### Reset Consumer Offsets

```bash
# Reset to earliest
kafka-consumer-groups --bootstrap-server localhost:9092 \
  --group my-consumer-group --topic my-topic \
  --reset-offsets --to-earliest --execute

# Reset to latest
kafka-consumer-groups --bootstrap-server localhost:9092 \
  --group my-consumer-group --topic my-topic \
  --reset-offsets --to-latest --execute

# Reset to specific offset
kafka-consumer-groups --bootstrap-server localhost:9092 \
  --group my-consumer-group --topic my-topic:0 \
  --reset-offsets --to-offset 1000 --execute

# Reset by datetime
kafka-consumer-groups --bootstrap-server localhost:9092 \
  --group my-consumer-group --topic my-topic \
  --reset-offsets --to-datetime "2024-01-01T00:00:00.000" --execute

# Shift by offset
kafka-consumer-groups --bootstrap-server localhost:9092 \
  --group my-consumer-group --topic my-topic \
  --reset-offsets --shift-by -100 --execute
```

**Important:** Consumer group must be stopped (no active members) before resetting offsets.

## Client Quotas

**[📖 Quotas](https://kafka.apache.org/documentation/#design_quotas)** - Client quota management

### Configure Quotas

```bash
# Set produce quota (bytes/sec per client)
kafka-configs --bootstrap-server localhost:9092 --alter \
  --entity-type users --entity-name my-user \
  --add-config producer_byte_rate=10485760  # 10 MB/s

# Set consume quota
kafka-configs --bootstrap-server localhost:9092 --alter \
  --entity-type users --entity-name my-user \
  --add-config consumer_byte_rate=20971520  # 20 MB/s

# Set request percentage quota
kafka-configs --bootstrap-server localhost:9092 --alter \
  --entity-type users --entity-name my-user \
  --add-config request_percentage=25  # 25% of broker capacity

# Set default quota for all users
kafka-configs --bootstrap-server localhost:9092 --alter \
  --entity-type users --entity-default \
  --add-config producer_byte_rate=5242880  # 5 MB/s default
```

### Quota Types
- **Produce quota** - Limits bytes per second a client can produce
- **Consume quota** - Limits bytes per second a client can fetch
- **Request percentage** - Limits percentage of broker request handler time
- Quotas can be set per user, per client-id, or per user/client-id combination
- When quota is exceeded, broker throttles the client (delays response)

## Dynamic Configuration

### Broker Dynamic Configuration

```bash
# Set dynamic broker config (applies immediately, no restart needed)
kafka-configs --bootstrap-server localhost:9092 --alter \
  --entity-type brokers --entity-name 1 \
  --add-config log.retention.ms=172800000

# Set cluster-wide dynamic config
kafka-configs --bootstrap-server localhost:9092 --alter \
  --entity-type brokers --entity-default \
  --add-config log.retention.ms=172800000

# Describe dynamic configs
kafka-configs --bootstrap-server localhost:9092 --describe \
  --entity-type brokers --entity-name 1
```

**Dynamically Configurable Settings (partial list):**
- `log.retention.ms` / `log.retention.bytes`
- `min.insync.replicas`
- `unclean.leader.election.enable`
- `max.connections`
- `max.connections.per.ip`
- `num.io.threads` / `num.network.threads`
- `log.cleaner.threads`
- Various quota settings

### Configuration Precedence
1. Per-topic config (highest priority)
2. Per-broker dynamic config
3. Cluster-wide dynamic config
4. Static config in server.properties
5. Default values (lowest priority)
