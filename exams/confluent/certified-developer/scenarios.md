# High-Yield Scenarios and Patterns

## Producer Scenarios

### High-Throughput Producer
**Scenario**: Application needs to send 1 million messages per second with acceptable data loss tolerance.

**Solution Pattern**:
- `acks=1` - Leader acknowledgment only for speed
- `batch.size=65536` - Larger batches (64 KB)
- `linger.ms=20` - Allow batching time
- `compression.type=lz4` - Fast compression
- `buffer.memory=67108864` - 64 MB buffer

**Common Distractors**:
- `acks=all` (wrong - adds latency for durability not required)
- `linger.ms=0` (wrong - prevents batching, reduces throughput)
- No compression (wrong - increases network overhead)

### Exactly-Once Producer
**Scenario**: Financial application requires no duplicate messages and atomic writes across multiple topics.

**Solution Pattern**:
- `enable.idempotence=true`
- `acks=all`
- `max.in.flight.requests.per.connection=5` (or less)
- Use transactional API for cross-topic atomicity
- `transactional.id=<unique-id>` for transactional producer

**Common Distractors**:
- `acks=1` with retries (wrong - can produce duplicates)
- Idempotence alone without transactions (wrong - only prevents duplicates per partition)
- `max.in.flight.requests.per.connection=1` (wrong - unnecessarily limits throughput, idempotence handles ordering up to 5)

### Producer Error Handling
**Scenario**: Producer must handle broker failures gracefully without losing messages.

**Solution Pattern**:
- `acks=all` with `min.insync.replicas=2`
- `retries=Integer.MAX_VALUE` (default with idempotence)
- `delivery.timeout.ms=120000` - Overall delivery timeout
- Implement callback for async error handling
- Log failed records to a dead letter topic or file

**Common Distractors**:
- `retries=0` (wrong - no retry on transient failures)
- Only sync send (wrong - blocks producer, reduces throughput)
- `acks=0` (wrong - no delivery guarantee)

## Consumer Scenarios

### At-Least-Once Processing
**Scenario**: Application processes orders and must not miss any messages, but can handle duplicates.

**Solution Pattern**:
- `enable.auto.commit=false`
- Process message first, then commit offset
- Use `commitSync()` after successful processing
- Implement idempotent processing on consumer side
- `auto.offset.reset=earliest` for new consumer groups

**Common Distractors**:
- `enable.auto.commit=true` (wrong - may commit before processing completes)
- `commitAsync()` without callback (wrong - may silently fail)
- `auto.offset.reset=latest` (wrong - may miss messages on new group)

### Consumer Lag Management
**Scenario**: Consumer group is falling behind and accumulating lag across all partitions.

**Solution Pattern**:
- Increase `max.poll.records` to process more per poll
- Add more consumers to the group (up to partition count)
- Increase partition count on the topic
- Optimize processing logic to reduce per-message time
- Monitor `records-lag-max` metric

**Common Distractors**:
- Adding consumers beyond partition count (wrong - idle consumers)
- Reducing `max.poll.interval.ms` (wrong - causes more rebalances)
- Using multiple consumer groups (wrong - duplicates processing)

### Consumer Rebalance Handling
**Scenario**: Application uses stateful processing and needs graceful handling during consumer rebalances.

**Solution Pattern**:
- Implement `ConsumerRebalanceListener`
- In `onPartitionsRevoked()`: commit offsets and flush state
- In `onPartitionsAssigned()`: initialize state for new partitions
- Use cooperative sticky assignor to minimize disruption
- `partition.assignment.strategy=org.apache.kafka.clients.consumer.CooperativeStickyAssignor`

**Common Distractors**:
- Ignoring rebalance events (wrong - may lose uncommitted work)
- Eager rebalancing (wrong - stops all partitions during rebalance)
- Committing offsets only in poll loop (wrong - miss commits on revocation)

## Kafka Streams Scenarios

### Real-Time Aggregation
**Scenario**: Count page views per user in 5-minute tumbling windows.

**Solution Pattern**:
```
KStream<String, PageView> views = builder.stream("page-views");
KTable<Windowed<String>, Long> counts = views
    .groupByKey()
    .windowedBy(TimeWindows.ofSizeWithNoGrace(Duration.ofMinutes(5)))
    .count(Materialized.as("page-view-counts"));
```

**Key Points**:
- Tumbling windows have fixed size with no overlap
- State is stored in RocksDB by default
- Results are emitted as the window advances
- Grace period controls late-arriving data handling

**Common Distractors**:
- Using hopping windows (wrong - hopping windows overlap)
- Not materializing state store (wrong - needed for interactive queries)
- Using KStream instead of KTable for result (wrong - aggregation produces a table)

### Stream-Table Join for Enrichment
**Scenario**: Enrich order events with customer profile data.

**Solution Pattern**:
```
KStream<String, Order> orders = builder.stream("orders");
KTable<String, Customer> customers = builder.table("customers");
KStream<String, EnrichedOrder> enriched = orders.join(
    customers,
    (order, customer) -> new EnrichedOrder(order, customer)
);
```

**Key Points**:
- KStream-KTable join is non-windowed
- Join key must be the same (re-key if needed with `selectKey()`)
- KTable uses latest value for each key
- For broadcast-style joins, use GlobalKTable (no key requirement)

**Common Distractors**:
- KStream-KStream join without window (wrong - requires window)
- Not re-keying before join (wrong - join key must match)
- Using KTable-KTable join (wrong - produces table, not stream)

## Schema Registry Scenarios

### Schema Evolution - Adding a Field
**Scenario**: Need to add a new optional field to an Avro schema without breaking existing consumers.

**Solution Pattern**:
- Add field with a default value
- Use BACKWARD compatibility mode (default)
- New consumers can read old data (field uses default)
- Old consumers ignore unknown fields

**Compatibility Check**:
- BACKWARD: New schema reads old data - adding field with default is backward compatible
- FORWARD: Old schema reads new data - adding field with default is forward compatible
- FULL: Both directions - adding field with default is fully compatible

**Common Distractors**:
- Adding required field without default (wrong - breaks backward compatibility)
- Using NONE compatibility (wrong - no safety guarantees)
- Changing field type (wrong - breaks all compatibility modes)

### Schema Evolution - Removing a Field
**Scenario**: Need to remove a deprecated field from the schema.

**Solution Pattern**:
- Field being removed must have a default value in the previous schema
- Use FORWARD or FULL compatibility
- Old consumers reading new data will use the default value
- Deploy new producers first, then update consumers

**Common Distractors**:
- Removing field without default in old schema (wrong - breaks forward compatibility)
- Using BACKWARD only (wrong - removing field without default breaks backward)
- Removing and adding in same version (wrong - complex, test carefully)

## Kafka Connect Scenarios

### Database Change Data Capture
**Scenario**: Stream database changes from PostgreSQL to Kafka topics in real-time.

**Solution Pattern**:
- Use Debezium PostgreSQL source connector
- Configure `tasks.max` based on number of tables
- Use Avro converter with Schema Registry
- Enable `snapshot.mode=initial` for initial load
- Configure `transforms` to route tables to separate topics

**Common Distractors**:
- JDBC source connector for CDC (wrong - JDBC polls, Debezium captures changes)
- JSON converter without schema (wrong - loses schema information)
- Single task for many tables (wrong - limits parallelism)

### Dead Letter Queue Pattern
**Scenario**: Sink connector encounters invalid records that should not stop the pipeline.

**Solution Pattern**:
- `errors.tolerance=all` - Skip bad records
- `errors.deadletterqueue.topic.name=dlq-topic` - Route failures to DLQ
- `errors.deadletterqueue.context.headers.enable=true` - Add error context
- Monitor DLQ topic for failed records
- Process DLQ records separately for remediation

**Common Distractors**:
- `errors.tolerance=none` (wrong - stops connector on first error)
- No DLQ configuration (wrong - silently drops errors)
- Retry without DLQ (wrong - retries may not fix data issues)

## ksqlDB Scenarios

### Real-Time Filtering and Routing
**Scenario**: Filter high-value transactions and route them to a separate topic.

**Solution Pattern**:
```sql
CREATE STREAM high_value_transactions AS
  SELECT *
  FROM transactions
  WHERE amount > 10000
  EMIT CHANGES;
```

**Key Points**:
- CREATE STREAM AS SELECT creates a persistent query
- Results are written to a new Kafka topic
- Query runs continuously until terminated
- EMIT CHANGES makes it a push query

### Materialized View for Lookups
**Scenario**: Maintain a real-time count of orders per customer for point-in-time queries.

**Solution Pattern**:
```sql
CREATE TABLE order_counts AS
  SELECT customer_id, COUNT(*) AS total_orders
  FROM orders
  GROUP BY customer_id
  EMIT CHANGES;

-- Pull query for lookup
SELECT * FROM order_counts WHERE customer_id = 'C123';
```

**Key Points**:
- CREATE TABLE AS SELECT with GROUP BY creates materialized view
- Pull queries return current state without subscribing
- Materialized views are backed by Kafka state stores
- Only tables (not streams) support pull queries
