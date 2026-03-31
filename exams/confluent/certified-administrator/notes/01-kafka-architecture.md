# Kafka Architecture

**[📖 Kafka Design](https://kafka.apache.org/documentation/#design)** - Architecture design principles
**[📖 Broker Configuration](https://docs.confluent.io/platform/current/installation/configuration/broker-configs.html)** - Complete broker settings

## Broker Internals

### Broker Components
- **Network Layer** - Accepts client connections via `listeners` configuration
- **Request Handler Pool** - Processes API requests (`num.io.threads`, default: 8)
- **Network Thread Pool** - Handles network I/O (`num.network.threads`, default: 3)
- **Log Manager** - Manages partition log segments on disk
- **Replica Manager** - Handles replication between leader and followers
- **Group Coordinator** - Manages consumer group membership and offsets
- **Controller** - One broker elected as controller for cluster-wide operations

### Broker Configuration - Essential Settings

**Network:**
- `listeners` - Comma-separated list of URIs to listen on (e.g., `PLAINTEXT://0.0.0.0:9092`)
- `advertised.listeners` - Listeners published to clients (use hostname/IP clients can reach)
- `listener.security.protocol.map` - Map listener names to security protocols
- `inter.broker.listener.name` - Listener for inter-broker communication

**Storage:**
- `log.dirs` - Comma-separated directories for log segments (multiple dirs = multiple disks)
- `log.dir` - Single directory (use `log.dirs` for multiple)
- `log.segment.bytes` (default: 1073741824 / 1 GB) - Maximum segment file size
- `log.roll.hours` (default: 168 / 7 days) - Maximum time before rolling a new segment
- `log.index.size.max.bytes` (default: 10485760 / 10 MB) - Maximum offset index size

**Performance:**
- `num.io.threads` (default: 8) - I/O threads for request processing
- `num.network.threads` (default: 3) - Network threads for handling connections
- `num.recovery.threads.per.data.dir` (default: 1) - Threads for log recovery at startup
- `socket.send.buffer.bytes` (default: 102400) - Socket send buffer
- `socket.receive.buffer.bytes` (default: 102400) - Socket receive buffer
- `socket.request.max.bytes` (default: 104857600 / 100 MB) - Maximum request size

**[📖 Hardware Recommendations](https://docs.confluent.io/platform/current/installation/operating-systems.html)** - OS and hardware guidelines

### Log Segment Structure

**Per Partition Directory:**
```
my-topic-0/
  00000000000000000000.log      # Segment file (messages)
  00000000000000000000.index    # Offset index
  00000000000000000000.timeindex # Timestamp index
  00000000000000005432.log      # Next segment (starting at offset 5432)
  00000000000000005432.index
  00000000000000005432.timeindex
  leader-epoch-checkpoint        # Leader epoch information
  partition.metadata             # Partition metadata
```

**Segment Lifecycle:**
1. Active segment receives writes
2. Segment rolls when `log.segment.bytes` or `log.roll.ms` is reached
3. Closed segments are eligible for cleanup (delete or compact)
4. Retention enforcement runs periodically (`log.retention.check.interval.ms`)

**Index Files:**
- Offset index: Maps logical offset to physical file position
- Timestamp index: Maps timestamp to offset
- Indexes are memory-mapped for fast lookups
- Sparse indexing - not every message is indexed (`log.index.interval.bytes`)

## ZooKeeper

### ZooKeeper Role in Kafka
- Stores cluster metadata (broker list, topic config, partition assignments)
- Manages controller election (first broker to create /controller znode)
- Stores ACLs and client quotas
- Manages ISR information (written by controller)
- Broker registration and liveness detection

**[📖 ZooKeeper Configuration](https://docs.confluent.io/platform/current/installation/configuration/zookeeper-configs.html)** - ZooKeeper settings

### ZooKeeper Ensemble Configuration
- Odd number of nodes recommended (3 or 5)
- Quorum requires majority (N/2 + 1) nodes to be available
- 3-node ensemble tolerates 1 failure
- 5-node ensemble tolerates 2 failures
- `zookeeper.connect` - Connection string (e.g., `zk1:2181,zk2:2181,zk3:2181/kafka`)
- `zookeeper.session.timeout.ms` (default: 18000) - Session timeout
- `zookeeper.connection.timeout.ms` (default: null / uses session timeout) - Connection timeout

### ZooKeeper Znodes
- `/brokers/ids` - Registered brokers
- `/brokers/topics` - Topic configuration and partition assignments
- `/controller` - Current controller broker
- `/config/topics` - Topic-level configuration overrides
- `/config/users` - User quotas
- `/admin/reassign_partitions` - Pending partition reassignments
- `/consumers` - Legacy consumer group info (deprecated)

## KRaft Mode

**[📖 KRaft Mode](https://docs.confluent.io/platform/current/kafka-metadata/kraft.html)** - KRaft architecture and migration

### KRaft Architecture
- Eliminates ZooKeeper dependency
- Uses Raft consensus protocol for metadata management
- Controller nodes form a Raft quorum
- Metadata stored in internal `__cluster_metadata` topic
- Controllers can be dedicated or combined with brokers

### KRaft Configuration
- `process.roles` - `broker`, `controller`, or `broker,controller` (combined)
- `node.id` - Unique node identifier (replaces `broker.id`)
- `controller.quorum.voters` - Voter connection strings (e.g., `1@host1:9093,2@host2:9093,3@host3:9093`)
- `controller.listener.names` - Listener for controller communication

### KRaft vs ZooKeeper

| Feature | ZooKeeper | KRaft |
|---------|-----------|-------|
| External dependency | Yes | No |
| Metadata storage | ZooKeeper znodes | Internal Kafka topic |
| Controller election | Via ZooKeeper | Via Raft protocol |
| Broker startup | Slower (ZK sync) | Faster |
| Partition limit | ~200K recommended | Higher scalability |
| Operations | More complex | Simplified |

## ISR (In-Sync Replicas)

### ISR Mechanics
- ISR is maintained per partition
- Leader tracks which followers are "in-sync"
- A follower is in-sync if it has fetched all messages within `replica.lag.time.max.ms`
- Controller updates ISR in ZooKeeper/KRaft metadata
- ISR shrinks when followers fall behind; expands when they catch up

### ISR Configuration

| Setting | Default | Description |
|---------|---------|-------------|
| `replica.lag.time.max.ms` | 30000 | Max time before follower removed from ISR |
| `min.insync.replicas` | 1 | Minimum ISR for acks=all writes |
| `unclean.leader.election.enable` | false | Allow non-ISR leader election |
| `replica.fetch.wait.max.ms` | 500 | Max wait for follower fetch |
| `replica.fetch.min.bytes` | 1 | Minimum fetch size for replicas |
| `replica.fetch.max.bytes` | 1048576 | Maximum fetch size for replicas |

### ISR and Write Availability

| Scenario (RF=3, min.insync.replicas=2) | Writes (acks=all) | Reads |
|-----------------------------------------|-------------------|-------|
| 3 brokers up, ISR=3 | Yes | Yes |
| 1 broker down, ISR=2 | Yes | Yes |
| 2 brokers down, ISR=1 | No (NotEnoughReplicas) | Yes |
| Leader down, ISR=2 | Yes (new leader elected) | Yes |
| All brokers down | No | No |

### Leader Election
- Triggered when current leader fails or is shutting down
- Controller selects new leader from ISR
- Preferred leader election restores balanced leadership
- If ISR is empty and `unclean.leader.election.enable=true`, a non-ISR replica can become leader (data loss risk)
- If ISR is empty and `unclean.leader.election.enable=false`, partition remains offline

## Log Segments Deep Dive

### Retention Policies

**Time-Based Retention:**
- `log.retention.ms` / `log.retention.minutes` / `log.retention.hours` (default: 168 hours)
- Applies to closed segments based on the max timestamp in the segment
- `log.retention.check.interval.ms` (default: 300000 / 5 min) - How often to check

**Size-Based Retention:**
- `log.retention.bytes` (default: -1 / unlimited) - Per-partition size limit
- When exceeded, oldest segments are deleted
- Total partition size = sum of all segment sizes

### Log Compaction

**[📖 Log Compaction](https://kafka.apache.org/documentation/#compaction)** - Compaction mechanics

**How Compaction Works:**
- Log cleaner thread compacts closed segments in the background
- Keeps the latest value for each key
- Removes older duplicates
- Null values (tombstones) mark key for eventual deletion
- Active segment is never compacted

**Configuration:**
- `cleanup.policy=compact` - Enable compaction
- `min.cleanable.dirty.ratio` (default: 0.5) - Ratio of dirty log to trigger cleaning
- `min.compaction.lag.ms` (default: 0) - Minimum time before compaction
- `max.compaction.lag.ms` (default: infinity) - Maximum time without compaction
- `delete.retention.ms` (default: 86400000 / 24 hours) - Tombstone retention time
- `log.cleaner.threads` (default: 1) - Number of cleaner threads
- `log.cleaner.dedupe.buffer.size` (default: 134217728 / 128 MB) - Dedup buffer

## Hardware Recommendations

### Disk
- Use multiple log directories across multiple disks for I/O distribution
- SSD recommended for low-latency workloads
- RAID 10 for performance, or JBOD with multiple `log.dirs`
- ext4 or XFS filesystem
- Avoid NFS or remote filesystems

### Memory
- Kafka relies heavily on OS page cache
- JVM heap: 6-8 GB typically sufficient
- Remaining memory for page cache
- More page cache = fewer disk reads = lower latency
- 64 GB+ RAM recommended for production

### Network
- 1 Gbps minimum, 10 Gbps recommended
- Account for replication traffic (RF-1 times write throughput)
- Consumer fetch traffic can be significant
- Separate NIC for replication and client traffic if possible

### CPU
- Kafka is generally not CPU-bound
- Compression/decompression uses CPU
- SSL/TLS encryption uses CPU
- 8-16 cores typically sufficient
- Higher core count helps with many partitions
