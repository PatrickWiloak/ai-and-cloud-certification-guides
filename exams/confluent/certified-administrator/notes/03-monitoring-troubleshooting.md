# Monitoring and Troubleshooting

**[📖 Monitoring Kafka](https://docs.confluent.io/platform/current/kafka/monitoring.html)** - Monitoring best practices
**[📖 Kafka Monitoring](https://kafka.apache.org/documentation/#monitoring)** - JMX metrics reference

## JMX Metrics

### Enabling JMX
```bash
# Set JMX port before starting broker
export JMX_PORT=9999
export KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote \
  -Dcom.sun.management.jmxremote.authenticate=false \
  -Dcom.sun.management.jmxremote.ssl=false"
```

### Critical Broker Metrics

#### Cluster Health Metrics

| MBean | Metric | Description | Alert |
|-------|--------|-------------|-------|
| `kafka.controller:type=KafkaController` | `ActiveControllerCount` | Active controllers | != 1 |
| `kafka.controller:type=KafkaController` | `OfflinePartitionsCount` | Offline partitions | > 0 |
| `kafka.server:type=ReplicaManager` | `UnderReplicatedPartitions` | Under-replicated | > 0 |
| `kafka.server:type=ReplicaManager` | `UnderMinIsrPartitionCount` | Below min ISR | > 0 |
| `kafka.server:type=ReplicaManager` | `IsrShrinksPerSec` | ISR shrink rate | Sustained > 0 |
| `kafka.server:type=ReplicaManager` | `IsrExpandsPerSec` | ISR expand rate | Monitor |
| `kafka.server:type=ReplicaManager` | `LeaderCount` | Leaders per broker | Imbalanced |
| `kafka.server:type=ReplicaManager` | `PartitionCount` | Total partitions | Capacity |

#### Request Performance Metrics

| MBean | Metric | Description | Alert |
|-------|--------|-------------|-------|
| `kafka.network:type=RequestMetrics,name=TotalTimeMs,request=Produce` | Mean, 99th | Produce latency | p99 > 100ms |
| `kafka.network:type=RequestMetrics,name=TotalTimeMs,request=FetchConsumer` | Mean, 99th | Fetch latency | p99 > 100ms |
| `kafka.network:type=RequestMetrics,name=RequestQueueTimeMs` | Mean, 99th | Queue wait time | p99 > 50ms |
| `kafka.network:type=RequestMetrics,name=LocalTimeMs` | Mean, 99th | Local processing | p99 > 50ms |
| `kafka.network:type=RequestMetrics,name=RemoteTimeMs` | Mean, 99th | Remote (ISR) wait | p99 > 100ms |
| `kafka.network:type=RequestMetrics,name=ResponseQueueTimeMs` | Mean, 99th | Response queue | p99 > 10ms |

#### Throughput Metrics

| MBean | Metric | Description |
|-------|--------|-------------|
| `kafka.server:type=BrokerTopicMetrics` | `BytesInPerSec` | Incoming bytes/sec |
| `kafka.server:type=BrokerTopicMetrics` | `BytesOutPerSec` | Outgoing bytes/sec |
| `kafka.server:type=BrokerTopicMetrics` | `MessagesInPerSec` | Messages produced/sec |
| `kafka.server:type=BrokerTopicMetrics` | `TotalProduceRequestsPerSec` | Produce requests/sec |
| `kafka.server:type=BrokerTopicMetrics` | `TotalFetchRequestsPerSec` | Fetch requests/sec |
| `kafka.server:type=BrokerTopicMetrics` | `FailedProduceRequestsPerSec` | Failed produces/sec |
| `kafka.server:type=BrokerTopicMetrics` | `FailedFetchRequestsPerSec` | Failed fetches/sec |

#### Resource Utilization Metrics

| MBean | Metric | Description | Alert |
|-------|--------|-------------|-------|
| `kafka.server:type=KafkaRequestHandlerPool` | `RequestHandlerAvgIdlePercent` | Handler idle % | < 0.3 (30%) |
| `kafka.network:type=SocketServer` | `NetworkProcessorAvgIdlePercent` | Network idle % | < 0.3 (30%) |
| `kafka.server:type=ReplicaFetcherManager` | `MaxLag` | Max replication lag | > threshold |
| `kafka.log:type=LogFlushStats` | `LogFlushRateAndTimeMs` | Flush rate/time | High latency |
| `kafka.server:type=SessionExpireListener` | `ZooKeeperExpiresPerSec` | ZK session expires | > 0 |

### Topic-Level Metrics

```
kafka.server:type=BrokerTopicMetrics,name=BytesInPerSec,topic=my-topic
kafka.server:type=BrokerTopicMetrics,name=BytesOutPerSec,topic=my-topic
kafka.server:type=BrokerTopicMetrics,name=MessagesInPerSec,topic=my-topic
```

## Consumer Lag Monitoring

### Using kafka-consumer-groups

```bash
# Full consumer group description
kafka-consumer-groups --bootstrap-server localhost:9092 \
  --describe --group my-group

# Output columns:
# TOPIC  PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG  CONSUMER-ID  HOST  CLIENT-ID
```

**Key Columns:**
- **CURRENT-OFFSET** - Last committed offset for the consumer
- **LOG-END-OFFSET** - Latest offset in the partition
- **LAG** - Difference (LOG-END-OFFSET - CURRENT-OFFSET)

### Consumer Lag Metrics (JMX)

| MBean | Description |
|-------|-------------|
| `kafka.consumer:type=consumer-fetch-manager-metrics,client-id=*` `records-lag-max` | Maximum lag across all partitions |
| `kafka.consumer:type=consumer-fetch-manager-metrics,client-id=*,topic=*,partition=*` `records-lag` | Lag for specific partition |
| `kafka.consumer:type=consumer-fetch-manager-metrics` `records-consumed-rate` | Records consumed per second |
| `kafka.consumer:type=consumer-coordinator-metrics` `commit-rate` | Offset commit rate |
| `kafka.consumer:type=consumer-coordinator-metrics` `rebalance-rate-per-hour` | Rebalance frequency |

### Consumer Lag Troubleshooting

**Common Causes of High Lag:**
1. Consumer processing too slow
2. Insufficient consumers (fewer than partitions)
3. Frequent rebalances wasting processing time
4. Consumer blocked on external dependencies
5. Network issues between consumer and brokers
6. Large message sizes causing slow deserialization

**Diagnostic Steps:**
1. Check lag trend - increasing, stable, or decreasing?
2. Check consumer count vs partition count
3. Monitor rebalance rate - frequent rebalances indicate instability
4. Check `max.poll.interval.ms` violations in consumer logs
5. Profile consumer processing time per record
6. Check for slow external dependencies (database, API calls)

## Under-Replicated Partitions

### Understanding URP

Under-replicated partitions (URPs) occur when one or more follower replicas fall behind the leader beyond `replica.lag.time.max.ms`.

**Checking URPs:**
```bash
# List under-replicated partitions
kafka-topics --bootstrap-server localhost:9092 --describe --under-replicated-partitions
```

### Common Causes

**Broker-Level Issues:**
1. **Disk I/O saturation** - Follower cannot write fast enough
2. **Network congestion** - Replication traffic bottleneck
3. **GC pauses** - Long JVM garbage collection pauses
4. **CPU saturation** - Compression/decompression overhead
5. **Too many partitions** - Single broker handling too many replicas

**Cluster-Level Issues:**
1. **Uneven partition distribution** - Some brokers overloaded
2. **Broker failure/restart** - Temporary URPs during recovery
3. **High produce throughput** - Followers cannot keep up
4. **Cross-rack replication** - Higher latency between racks

### Diagnostic Approach

```
1. Identify affected brokers
   └─ Are URPs concentrated on specific brokers?
   
2. Check broker resources
   ├─ Disk I/O: iostat, iotop
   ├─ Network: netstat, iftop
   ├─ CPU: top, vmstat
   ├─ Memory: free, vmstat
   └─ GC: JVM GC logs
   
3. Check broker logs
   ├─ Replication errors
   ├─ Disk errors
   └─ Connection timeouts
   
4. Check replication metrics
   ├─ IsrShrinksPerSec / IsrExpandsPerSec
   ├─ ReplicaFetcherManager.MaxLag
   └─ ReplicaManager.FailedIsrUpdatesPerSec
   
5. Resolution
   ├─ Fix resource bottleneck
   ├─ Reassign partitions to less loaded brokers
   ├─ Add more brokers
   └─ Increase replica.lag.time.max.ms (temporary)
```

## Performance Troubleshooting

### Producer Performance Issues

**Symptoms:** High produce latency, frequent retries, buffer full errors

**Diagnostic:**
1. Check `RequestQueueTimeMs` - high means request handler overloaded
2. Check `LocalTimeMs` - high means disk I/O issues
3. Check `RemoteTimeMs` - high means slow ISR acknowledgment (with acks=all)
4. Check `ResponseQueueTimeMs` - high means network thread overloaded

**Common Fixes:**
- Increase `num.io.threads` if handlers are saturated
- Add disks or use faster storage if disk I/O is bottleneck
- Reduce `min.insync.replicas` (trade-off: durability)
- Increase broker count and redistribute partitions

### Fetch Performance Issues

**Symptoms:** High consumer lag, slow fetch responses

**Diagnostic:**
1. Check `FetchConsumer` request metrics
2. Check disk read performance (cold reads from disk vs page cache)
3. Check network bandwidth utilization
4. Check consumer `fetch.min.bytes` and `fetch.max.wait.ms`

**Common Fixes:**
- Add more memory for page cache (reduces disk reads)
- Increase `fetch.max.bytes` for batch fetching
- Add more consumers to the group
- Optimize consumer processing speed

### Disk I/O Troubleshooting

```bash
# Check disk utilization
iostat -x 5

# Key metrics:
# %util  - Disk utilization (>80% is concerning)
# await  - Average wait time (>10ms for SSD is concerning)
# r/s, w/s - Read/write operations per second
# rkB/s, wkB/s - Read/write throughput
```

**Optimizations:**
- Use multiple `log.dirs` across multiple disks (JBOD)
- Separate OS disk from Kafka log disks
- Use SSD for lower latency
- Increase `log.flush.interval.messages` to reduce forced flushes
- Let the OS handle page cache flushing

## OS-Level Monitoring

### Key OS Metrics

| Metric | Tool | Concern Threshold |
|--------|------|-------------------|
| CPU utilization | top, mpstat | > 80% sustained |
| Memory usage | free, vmstat | < 1 GB free |
| Disk I/O utilization | iostat | > 80% util |
| Disk space | df | > 85% full |
| Network throughput | iftop, nethogs | > 80% capacity |
| File descriptors | ulimit -n, lsof | Approaching limit |
| TCP connections | netstat, ss | Approaching limit |

### OS Tuning for Kafka

**File Descriptors:**
```bash
# Kafka needs many file descriptors (segments, connections)
# Set in /etc/security/limits.conf
kafka soft nofile 100000
kafka hard nofile 100000
```

**VM Swappiness:**
```bash
# Reduce swapping (Kafka prefers page cache over swap)
vm.swappiness=1
```

**Network Tuning:**
```bash
# Increase socket buffer sizes
net.core.wmem_default=131072
net.core.rmem_default=131072
net.core.wmem_max=2097152
net.core.rmem_max=2097152
net.ipv4.tcp_wmem=4096 65536 2048000
net.ipv4.tcp_rmem=4096 65536 2048000
```

## Monitoring Tools Integration

### Prometheus + Grafana
- Use JMX Exporter agent to expose Kafka metrics to Prometheus
- Pre-built Grafana dashboards available for Kafka monitoring
- Alert rules for critical metrics

### Confluent Control Center
- Built-in monitoring for brokers, topics, and consumer groups
- Real-time metrics and historical trends
- Alert configuration and notification
- Consumer lag visualization

### Key Dashboards to Build
1. **Cluster Overview** - Broker count, partition count, controller status
2. **Throughput** - Bytes in/out, messages in per broker
3. **Latency** - Produce and fetch latency percentiles
4. **Replication Health** - URP count, ISR shrink/expand rates
5. **Consumer Groups** - Lag per group, rebalance frequency
6. **Resource Utilization** - Handler idle %, network idle %, disk I/O
