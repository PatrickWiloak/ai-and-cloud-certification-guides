# Kafka Fundamentals

**[📖 Apache Kafka Introduction](https://kafka.apache.org/documentation/#introduction)** - Official introduction to Kafka concepts and terminology

## Topics and Partitions

**[📖 Topic Configuration](https://docs.confluent.io/platform/current/installation/configuration/topic-configs.html)** - Complete topic configuration reference

### Topics
- A topic is a category or feed name to which records are published
- Topics are multi-subscriber - a topic can have zero, one, or many consumers
- Topics are split into partitions for parallelism and scalability
- Each topic has configurable retention (time-based or size-based)
- Topics can be configured for log compaction or log deletion

### Partitions
- Each partition is an ordered, immutable sequence of records
- Records within a partition are assigned a sequential offset
- Kafka guarantees ordering within a partition, not across partitions
- The number of partitions determines the maximum consumer parallelism
- Partitions are distributed across brokers for load balancing

**Partition Assignment:**
- Records with the same key always go to the same partition (with consistent partition count)
- Null keys use round-robin or sticky partition assignment
- Custom partitioners can implement custom routing logic
- Default partitioner uses murmur2 hash of the key

**[📖 Partitioning](https://kafka.apache.org/documentation/#intro_concepts_and_terms)** - How partitioning works in Kafka

### Partition Count Guidelines
- More partitions = higher throughput (more parallel consumers)
- More partitions = more file handles, memory, and leader elections
- Cannot decrease partition count after creation
- Increasing partitions breaks key ordering for existing keys
- Rule of thumb: start with number of brokers x 3, adjust based on throughput

## Brokers

**[📖 Broker Configuration](https://docs.confluent.io/platform/current/installation/configuration/broker-configs.html)** - Complete broker configuration reference

### Broker Architecture
- A Kafka cluster consists of one or more brokers
- Each broker is identified by a unique broker ID
- Brokers store topic partitions as log segments on disk
- Any broker can serve metadata requests for any partition
- One broker acts as the controller (manages partition leaders)

### Controller Broker
- Elected among brokers (first to register with ZooKeeper/KRaft)
- Responsible for partition leader election
- Notifies other brokers of leadership changes
- Manages broker registration and deregistration
- In KRaft mode, controller responsibilities are distributed

### Log Segments
- Each partition is stored as a series of log segment files
- Active segment receives new writes; older segments are read-only
- Segment files are named by the base offset they contain
- Segment size controlled by `log.segment.bytes` (default: 1 GB)
- Segment roll controlled by `log.roll.ms` / `log.roll.hours`
- Index files map offsets to file positions for fast lookups

**[📖 Log Compaction](https://kafka.apache.org/documentation/#compaction)** - How log compaction works

## Replication

**[📖 Replication](https://kafka.apache.org/documentation/#replication)** - Kafka replication design and guarantees

### Replication Model
- Each partition has one leader and zero or more followers
- All reads and writes go through the partition leader
- Followers replicate the leader's log passively
- Replication factor determines the total number of copies (including leader)
- Recommended production replication factor: 3

### In-Sync Replicas (ISR)
- ISR is the set of replicas that are fully caught up with the leader
- A follower is in-sync if it has replicated all messages within `replica.lag.time.max.ms`
- Default `replica.lag.time.max.ms`: 30000 (30 seconds)
- `min.insync.replicas` - Minimum ISR count for acks=all writes to succeed
- If ISR drops below `min.insync.replicas`, producers with acks=all get NotEnoughReplicasException

### Leader Election
- When a leader fails, a new leader is elected from the ISR
- Unclean leader election (`unclean.leader.election.enable=false` by default) - prevents non-ISR replicas from becoming leader
- Enabling unclean leader election risks data loss but improves availability
- Preferred leader election restores original leader assignments

**ISR and acks Interaction:**

| acks | Behavior | Durability |
|------|----------|------------|
| 0 | No acknowledgment | Lowest - may lose data |
| 1 | Leader acknowledges | Medium - may lose if leader fails before replication |
| all | All ISR replicas acknowledge | Highest - survives broker failures |

## Topic Configuration

### Retention Settings
- `retention.ms` - Time-based retention (default: 604800000 ms / 7 days)
- `retention.bytes` - Size-based retention per partition (default: -1 / unlimited)
- `cleanup.policy=delete` - Delete old segments beyond retention
- `cleanup.policy=compact` - Keep latest value per key (log compaction)
- `cleanup.policy=compact,delete` - Both compaction and deletion

### Log Compaction
- Ensures at least the last known value for each key is retained
- Useful for changelogs, state stores, and configuration topics
- Compaction runs in the background on closed segments
- Tombstone records (null value) mark keys for deletion
- `min.compaction.lag.ms` - Minimum time before a record can be compacted
- `delete.retention.ms` - Time tombstones are retained after compaction

**[📖 Topic-Level Configs](https://kafka.apache.org/documentation/#topicconfigs)** - All configurable topic settings

### Compression
- `compression.type` - Topic-level compression setting
- Options: `producer` (use producer setting), `none`, `gzip`, `snappy`, `lz4`, `zstd`
- Compression is applied per batch
- `zstd` offers best compression ratio
- `lz4` offers best compression speed
- `snappy` offers good balance of speed and ratio

## ZooKeeper and KRaft

### ZooKeeper Mode (Legacy)
- Stores cluster metadata, broker registration, and topic configuration
- Manages controller election
- Stores consumer group offsets (pre-0.9, now in __consumer_offsets)
- Manages ACLs and quotas
- Being replaced by KRaft in newer versions

### KRaft Mode (Modern)
- Apache Kafka Raft - built-in consensus protocol
- Eliminates ZooKeeper dependency
- Controller nodes form a Raft quorum
- Metadata stored in an internal __cluster_metadata topic
- Faster broker startup and recovery
- Simplified operations and deployment

**[📖 KRaft Overview](https://docs.confluent.io/platform/current/kafka-metadata/kraft.html)** - KRaft migration and configuration

## Message Format

### Record Structure
- **Key** - Optional, used for partitioning and compaction
- **Value** - The message payload
- **Headers** - Key-value metadata pairs
- **Timestamp** - CreateTime (producer) or LogAppendTime (broker)
- **Offset** - Sequential ID assigned by the broker

### Timestamp Types
- `CreateTime` - Set by the producer (default)
- `LogAppendTime` - Set by the broker on append
- Controlled by `message.timestamp.type` topic config
- Timestamps used for time-based retention and windowing

## Key Metrics for Developers

| Metric | Description |
|--------|-------------|
| `records-per-request-avg` | Average records per produce request |
| `record-send-rate` | Records sent per second |
| `record-error-rate` | Records that failed to send |
| `request-latency-avg` | Average request latency |
| `records-lag` | Consumer offset lag |
| `records-consumed-rate` | Records consumed per second |
| `commit-rate` | Consumer commit rate |
| `rebalance-rate-per-hour` | Consumer group rebalance frequency |
