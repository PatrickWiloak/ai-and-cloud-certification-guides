# Producer and Consumer API

**[📖 Producer API](https://kafka.apache.org/documentation/#producerapi)** - Official Producer API documentation
**[📖 Consumer API](https://kafka.apache.org/documentation/#consumerapi)** - Official Consumer API documentation

## Producer API

### Creating a Producer

**Essential Configuration:**
```java
Properties props = new Properties();
props.put("bootstrap.servers", "localhost:9092");
props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");
KafkaProducer<String, String> producer = new KafkaProducer<>(props);
```

**Required Properties:**
- `bootstrap.servers` - Comma-separated list of broker addresses
- `key.serializer` - Serializer class for record keys
- `value.serializer` - Serializer class for record values

**[📖 Producer Configuration](https://docs.confluent.io/platform/current/installation/configuration/producer-configs.html)** - Complete producer configuration reference

### Sending Messages

**Fire and Forget:**
```java
producer.send(new ProducerRecord<>("topic", "key", "value"));
```

**Synchronous Send:**
```java
RecordMetadata metadata = producer.send(
    new ProducerRecord<>("topic", "key", "value")).get();
```

**Asynchronous Send with Callback:**
```java
producer.send(new ProducerRecord<>("topic", "key", "value"),
    (metadata, exception) -> {
        if (exception != null) {
            // Handle error
        } else {
            // Success - metadata.partition(), metadata.offset()
        }
    });
```

### Producer Configuration Deep Dive

**Acknowledgment Settings:**

| Setting | Behavior | Latency | Durability |
|---------|----------|---------|------------|
| `acks=0` | No wait | Lowest | None |
| `acks=1` | Leader ack | Medium | Leader only |
| `acks=all` / `acks=-1` | All ISR ack | Highest | Full ISR |

**Batching and Throughput:**
- `batch.size` (default: 16384 / 16 KB) - Maximum batch size in bytes
- `linger.ms` (default: 0) - Time to wait for more records before sending
- Higher `linger.ms` = more batching = higher throughput but higher latency
- Batch is sent when either `batch.size` is reached OR `linger.ms` expires

**Buffering:**
- `buffer.memory` (default: 33554432 / 32 MB) - Total memory for unsent records
- When buffer is full, `send()` blocks for up to `max.block.ms` (default: 60000)
- If still full after `max.block.ms`, throws TimeoutException

**Reliability:**
- `retries` (default: 2147483647 with idempotence) - Number of retry attempts
- `retry.backoff.ms` (default: 100) - Backoff between retries
- `delivery.timeout.ms` (default: 120000 / 2 min) - Total time for delivery including retries
- `max.in.flight.requests.per.connection` (default: 5) - Max unacknowledged requests

**Compression:**
- `compression.type` (default: none) - Options: none, gzip, snappy, lz4, zstd
- Applied at the batch level
- Trade-off: CPU usage vs network/storage savings
- `zstd` - Best ratio, higher CPU
- `lz4` - Best speed, moderate ratio
- `snappy` - Good balance

### Idempotent Producer

**[📖 Idempotent Producer](https://docs.confluent.io/platform/current/installation/configuration/producer-configs.html#enable-idempotence)** - Configuration for exactly-once delivery

**Configuration:**
- `enable.idempotence=true` (default: true since Kafka 3.0)
- Automatically sets: `acks=all`, `retries=Integer.MAX_VALUE`
- Requires `max.in.flight.requests.per.connection <= 5`

**How It Works:**
- Producer is assigned a unique Producer ID (PID) by the broker
- Each message gets a sequence number per partition
- Broker deduplicates messages with the same PID and sequence number
- Survives producer retries without creating duplicates

### Transactional Producer

**[📖 Transactions](https://docs.confluent.io/platform/current/installation/configuration/producer-configs.html#transactional-id)** - Transactional messaging configuration

**Configuration:**
```java
props.put("transactional.id", "my-transactional-id");
```

**Usage Pattern:**
```java
producer.initTransactions();
try {
    producer.beginTransaction();
    producer.send(record1);
    producer.send(record2);
    producer.sendOffsetsToTransaction(offsets, consumerGroupId);
    producer.commitTransaction();
} catch (Exception e) {
    producer.abortTransaction();
}
```

**Key Points:**
- Enables atomic writes across multiple partitions and topics
- `sendOffsetsToTransaction()` - Commits consumer offsets as part of the transaction
- Consumers must set `isolation.level=read_committed` to see only committed data
- Transactional ID must be unique per producer instance

### Custom Partitioner

```java
public class CustomPartitioner implements Partitioner {
    public int partition(String topic, Object key, byte[] keyBytes,
                        Object value, byte[] valueBytes, Cluster cluster) {
        // Return partition number
        return Math.abs(key.hashCode()) % cluster.partitionCountForTopic(topic);
    }
}
```

- Default partitioner: murmur2 hash of key bytes
- Null keys: sticky partitioner (batches to random partition, changes per batch)
- Custom partitioners registered via `partitioner.class` config

## Consumer API

### Creating a Consumer

**Essential Configuration:**
```java
Properties props = new Properties();
props.put("bootstrap.servers", "localhost:9092");
props.put("group.id", "my-consumer-group");
props.put("key.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
props.put("value.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
KafkaConsumer<String, String> consumer = new KafkaConsumer<>(props);
```

**[📖 Consumer Configuration](https://docs.confluent.io/platform/current/installation/configuration/consumer-configs.html)** - Complete consumer configuration reference

### Consumer Groups

**[📖 Consumer Groups](https://kafka.apache.org/documentation/#intro_consumers)** - How consumer groups work

**Key Concepts:**
- Each consumer belongs to a consumer group (identified by `group.id`)
- Each partition is assigned to exactly one consumer within a group
- Multiple consumer groups can independently consume the same topic
- Maximum effective consumers per group = number of partitions
- Extra consumers beyond partition count sit idle as standby

**Partition Assignment Strategies:**
- `RangeAssignor` - Assigns contiguous partition ranges per topic
- `RoundRobinAssignor` - Round-robin across all partitions of all topics
- `StickyAssignor` - Minimizes partition movement during rebalances
- `CooperativeStickyAssignor` - Cooperative incremental rebalancing (recommended)

### Consumer Poll Loop

```java
consumer.subscribe(Arrays.asList("topic1", "topic2"));
while (running) {
    ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(100));
    for (ConsumerRecord<String, String> record : records) {
        // Process record
        System.out.println(record.key() + ": " + record.value());
    }
}
consumer.close();
```

**Poll Behavior:**
- `poll()` fetches records, sends heartbeats, and triggers rebalances
- Returns up to `max.poll.records` records (default: 500)
- Must call `poll()` within `max.poll.interval.ms` (default: 300000 / 5 min)
- Exceeding `max.poll.interval.ms` triggers consumer removal and rebalance

### Offset Management

**[📖 Offset Management](https://docs.confluent.io/platform/current/clients/consumer.html#offset-management)** - Managing consumer offsets

**Auto-Commit (Default):**
- `enable.auto.commit=true` (default)
- `auto.commit.interval.ms=5000` (default)
- Offsets committed automatically during `poll()`
- Risk: may commit before processing completes (at-most-once)

**Manual Commit - Synchronous:**
```java
consumer.commitSync(); // Blocks until committed
consumer.commitSync(Map.of(
    new TopicPartition("topic", 0),
    new OffsetAndMetadata(lastOffset + 1)
)); // Commit specific offsets
```

**Manual Commit - Asynchronous:**
```java
consumer.commitAsync(); // Non-blocking
consumer.commitAsync((offsets, exception) -> {
    if (exception != null) {
        // Handle commit failure
    }
});
```

**Best Practice Pattern:**
```java
try {
    while (running) {
        ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(100));
        for (ConsumerRecord<String, String> record : records) {
            processRecord(record);
        }
        consumer.commitAsync();
    }
} finally {
    consumer.commitSync(); // Final sync commit on shutdown
    consumer.close();
}
```

**auto.offset.reset Options:**
- `earliest` - Start from the beginning of the partition
- `latest` - Start from the end of the partition (default)
- `none` - Throw exception if no committed offset exists

### Consumer Rebalance Listener

```java
consumer.subscribe(Arrays.asList("topic"),
    new ConsumerRebalanceListener() {
        public void onPartitionsRevoked(Collection<TopicPartition> partitions) {
            // Commit offsets, flush state before losing partitions
            consumer.commitSync();
        }
        public void onPartitionsAssigned(Collection<TopicPartition> partitions) {
            // Initialize state for newly assigned partitions
        }
    });
```

**Rebalance Triggers:**
- Consumer joins or leaves the group
- Consumer crashes (heartbeat timeout)
- Consumer exceeds `max.poll.interval.ms`
- Topic partition count changes
- Group coordinator changes

### Consumer Tuning

**Throughput Tuning:**
- `fetch.min.bytes` (default: 1) - Minimum data per fetch request
- `fetch.max.wait.ms` (default: 500) - Max wait for fetch.min.bytes
- `max.partition.fetch.bytes` (default: 1048576 / 1 MB) - Max per partition
- `max.poll.records` (default: 500) - Max records per poll

**Reliability Tuning:**
- `session.timeout.ms` (default: 45000) - Heartbeat timeout
- `heartbeat.interval.ms` (default: 3000) - Heartbeat frequency
- `max.poll.interval.ms` (default: 300000) - Max processing time between polls
- Rule: `heartbeat.interval.ms` should be less than 1/3 of `session.timeout.ms`

## Serialization

**[📖 Serialization](https://docs.confluent.io/platform/current/schema-registry/fundamentals/serdes-develop/index.html)** - Serialization with Schema Registry

### Built-in Serializers
- `StringSerializer` / `StringDeserializer`
- `IntegerSerializer` / `IntegerDeserializer`
- `LongSerializer` / `LongDeserializer`
- `ByteArraySerializer` / `ByteArrayDeserializer`
- `ByteBufferSerializer` / `ByteBufferDeserializer`

### Avro Serialization with Schema Registry
```java
props.put("key.serializer", "io.confluent.kafka.serializers.KafkaAvroSerializer");
props.put("value.serializer", "io.confluent.kafka.serializers.KafkaAvroSerializer");
props.put("schema.registry.url", "http://localhost:8081");
```

### JSON Schema Serialization
```java
props.put("value.serializer", "io.confluent.kafka.serializers.json.KafkaJsonSchemaSerializer");
props.put("schema.registry.url", "http://localhost:8081");
```

### Protobuf Serialization
```java
props.put("value.serializer", "io.confluent.kafka.serializers.protobuf.KafkaProtobufSerializer");
props.put("schema.registry.url", "http://localhost:8081");
```

## AdminClient API

**[📖 AdminClient](https://kafka.apache.org/documentation/#adminapi)** - Administrative API reference

### Common Operations
```java
AdminClient admin = AdminClient.create(props);

// Create topic
NewTopic topic = new NewTopic("my-topic", 6, (short) 3);
admin.createTopics(Collections.singleton(topic));

// List topics
admin.listTopics().names().get();

// Describe topics
admin.describeTopics(Collections.singleton("my-topic")).all().get();

// Delete topics
admin.deleteTopics(Collections.singleton("my-topic"));

// Alter topic configuration
ConfigResource resource = new ConfigResource(ConfigResource.Type.TOPIC, "my-topic");
admin.incrementalAlterConfigs(Map.of(resource,
    Collections.singleton(new AlterConfigOp(
        new ConfigEntry("retention.ms", "86400000"),
        AlterConfigOp.OpType.SET))));
```
