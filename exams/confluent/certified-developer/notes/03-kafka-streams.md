# Kafka Streams

**[📖 Kafka Streams Documentation](https://kafka.apache.org/documentation/streams/)** - Official Kafka Streams documentation
**[📖 Confluent Kafka Streams Guide](https://docs.confluent.io/platform/current/streams/index.html)** - Confluent developer guide

## Kafka Streams Architecture

### Overview
- Client library for building stream processing applications
- No separate cluster required - runs in your application process
- Leverages Kafka for fault tolerance, scalability, and exactly-once processing
- Uses consumer groups for parallel processing and partition assignment
- Input and output are Kafka topics

### Topology
- A topology is a directed acyclic graph (DAG) of stream processors
- **Source processors** - Read from Kafka topics
- **Stream processors** - Transform data (filter, map, join, aggregate)
- **Sink processors** - Write to Kafka topics
- Topologies are built using the StreamsBuilder DSL or Processor API

**[📖 Topology](https://docs.confluent.io/platform/current/streams/architecture.html#processor-topology)** - Understanding processor topologies

### Tasks and Threads
- A topology is divided into tasks based on input partition count
- Each task processes data from one or more partitions
- `num.stream.threads` controls the number of processing threads per instance
- Tasks are distributed across threads and application instances
- Maximum parallelism = number of input partitions

### State Stores
- Used by stateful operations (aggregation, joins, windowing)
- Backed by RocksDB by default (can use in-memory stores)
- Each state store has a changelog topic for fault tolerance
- Changelog topics enable state recovery on failure
- Interactive queries allow external access to state stores

**[📖 State Stores](https://docs.confluent.io/platform/current/streams/developer-guide/processor-api.html#state-stores)** - State store types and configuration

## KStream and KTable

### KStream (Record Stream)
- Represents an unbounded stream of records
- Each record is an independent, immutable event
- Insert semantics - every record is a new event
- Analogous to a database INSERT log
- Created from a topic: `builder.stream("topic")`

### KTable (Changelog Stream)
- Represents a table of latest values per key
- Upsert semantics - new records update or insert by key
- Records with null values are treated as deletes (tombstones)
- Analogous to a database table with primary key
- Created from a topic: `builder.table("topic")`
- Backed by a state store

### Stream-Table Duality
- Every stream can be viewed as a table (aggregating all changes)
- Every table can be viewed as a stream (changelog of updates)
- `KStream.toTable()` converts stream to table
- `KTable.toStream()` converts table to stream

### GlobalKTable
- Fully replicated table - all partitions on every instance
- Used for enrichment joins without repartitioning
- Created from a topic: `builder.globalTable("topic")`
- Supports join with KStream on any key (not just the partition key)
- Higher memory usage since all data is on each instance
- Not partitioned - reads all partitions regardless of assignment

## Stateless Transformations

**[📖 Stateless Transformations](https://docs.confluent.io/platform/current/streams/developer-guide/dsl-api.html#stateless-transformations)** - DSL reference for stateless operations

### filter / filterNot
```java
KStream<String, Long> filtered = stream.filter(
    (key, value) -> value > 100
);
```
- Passes records matching the predicate
- Does not change key or value types

### map / mapValues
```java
// map - can change key and value (triggers repartition if key changes)
KStream<String, String> mapped = stream.map(
    (key, value) -> KeyValue.pair(key.toUpperCase(), value.toString())
);

// mapValues - only changes value (no repartition)
KStream<String, String> mappedValues = stream.mapValues(
    value -> value.toString()
);
```
- **Important**: `map()` that changes the key triggers repartitioning
- Prefer `mapValues()` when only transforming values to avoid repartition

### flatMap / flatMapValues
```java
KStream<String, String> flatMapped = stream.flatMap(
    (key, value) -> {
        List<KeyValue<String, String>> result = new ArrayList<>();
        for (String word : value.split(" ")) {
            result.add(KeyValue.pair(word, word));
        }
        return result;
    }
);
```
- Produces zero, one, or many output records per input record
- `flatMap()` can change key (triggers repartition)
- `flatMapValues()` only changes values (no repartition)

### branch (split)
```java
// Kafka Streams 2.8+ uses split()
Map<String, KStream<String, Long>> branches = stream.split(Named.as("split-"))
    .branch((key, value) -> value > 100, Branched.as("high"))
    .branch((key, value) -> value > 10, Branched.as("medium"))
    .defaultBranch(Branched.as("low"));

KStream<String, Long> highStream = branches.get("split-high");
```
- Splits a stream into multiple streams based on predicates
- Each record goes to the first matching branch
- Default branch catches unmatched records

### selectKey
```java
KStream<String, Order> rekeyed = stream.selectKey(
    (key, value) -> value.getCustomerId()
);
```
- Changes the key of each record
- Triggers repartitioning (through an internal topic)

### merge
```java
KStream<String, String> merged = stream1.merge(stream2);
```
- Combines two streams into one
- No ordering guarantee between the merged streams

## Stateful Transformations

**[📖 Stateful Transformations](https://docs.confluent.io/platform/current/streams/developer-guide/dsl-api.html#stateful-transformations)** - DSL reference for stateful operations

### groupByKey / groupBy
```java
// groupByKey - uses existing key (no repartition)
KGroupedStream<String, Long> grouped = stream.groupByKey();

// groupBy - new key (triggers repartition)
KGroupedStream<String, Long> regrouped = stream.groupBy(
    (key, value) -> value.getCategory()
);
```
- Required before any aggregation operation
- `groupByKey()` avoids repartitioning
- `groupBy()` triggers repartitioning

### count
```java
KTable<String, Long> counts = grouped.count(
    Materialized.as("count-store")
);
```

### aggregate
```java
KTable<String, Double> aggregated = grouped.aggregate(
    () -> 0.0,                              // Initializer
    (key, value, aggregate) -> aggregate + value,  // Aggregator
    Materialized.as("aggregate-store")
);
```

### reduce
```java
KTable<String, Long> reduced = grouped.reduce(
    (value1, value2) -> value1 + value2,
    Materialized.as("reduce-store")
);
```
- Similar to aggregate but input and output types must be the same

## Windowing

**[📖 Windowing](https://docs.confluent.io/platform/current/streams/developer-guide/dsl-api.html#windowing)** - Window types and configuration

### Tumbling Windows
```java
KTable<Windowed<String>, Long> counts = grouped
    .windowedBy(TimeWindows.ofSizeWithNoGrace(Duration.ofMinutes(5)))
    .count();
```
- Fixed-size, non-overlapping windows
- Each event belongs to exactly one window
- Window size = advance interval

### Hopping Windows
```java
KTable<Windowed<String>, Long> counts = grouped
    .windowedBy(TimeWindows.ofSizeAndGrace(
        Duration.ofMinutes(5),
        Duration.ofMinutes(1))
        .advanceBy(Duration.ofMinutes(1)))
    .count();
```
- Fixed-size windows that advance by a specified interval
- Windows can overlap (event may belong to multiple windows)
- Advance interval < window size creates overlap

### Sliding Windows (Join Windows)
```java
KStream<String, String> joined = stream1.join(
    stream2,
    (value1, value2) -> value1 + "-" + value2,
    JoinWindows.ofTimeDifferenceWithNoGrace(Duration.ofMinutes(5))
);
```
- Used for stream-stream joins
- Window defined by a time difference
- Symmetric - looks both before and after the record timestamp

### Session Windows
```java
KTable<Windowed<String>, Long> counts = grouped
    .windowedBy(SessionWindows.ofInactivityGapWithNoGrace(Duration.ofMinutes(5)))
    .count();
```
- Dynamic-size windows based on activity
- Inactivity gap defines the session timeout
- Sessions merge when new events arrive within the gap
- Each key can have different window sizes

### Grace Period
- Time after window closes to accept late-arriving records
- Records arriving after the grace period are dropped
- `TimeWindows.ofSizeAndGrace(size, grace)`
- Default grace period: 24 hours (in older versions)
- Use `WithNoGrace` variants for zero grace period

## Joins

**[📖 Joins](https://docs.confluent.io/platform/current/streams/developer-guide/dsl-api.html#joining)** - Join semantics and types

### Join Types Summary

| Join | Left | Right | Windowed | Output |
|------|------|-------|----------|--------|
| KStream-KStream (inner) | KStream | KStream | Yes (required) | KStream |
| KStream-KStream (left) | KStream | KStream | Yes (required) | KStream |
| KStream-KStream (outer) | KStream | KStream | Yes (required) | KStream |
| KStream-KTable (inner) | KStream | KTable | No | KStream |
| KStream-KTable (left) | KStream | KTable | No | KStream |
| KTable-KTable (inner) | KTable | KTable | No | KTable |
| KTable-KTable (left) | KTable | KTable | No | KTable |
| KTable-KTable (outer) | KTable | KTable | No | KTable |
| KStream-GlobalKTable | KStream | GlobalKTable | No | KStream |

### Key Requirements
- KStream-KStream: Both sides must have the same key
- KStream-KTable: Both sides must have the same key (co-partitioned)
- KTable-KTable: Both sides must have the same key (co-partitioned)
- KStream-GlobalKTable: Custom key mapper allows joining on any field
- Co-partitioned topics must have the same number of partitions

### Co-Partitioning Requirements
- Same number of partitions on both sides
- Same partitioning strategy
- If not co-partitioned, use `selectKey()` + `repartition()` or use GlobalKTable

## Interactive Queries

**[📖 Interactive Queries](https://docs.confluent.io/platform/current/streams/developer-guide/interactive-queries.html)** - Querying state stores

```java
ReadOnlyKeyValueStore<String, Long> store =
    streams.store(StoreQueryParameters.fromNameAndType(
        "count-store", QueryableStoreTypes.keyValueStore()));

Long count = store.get("my-key");
```

- Access state stores from outside the stream processing topology
- Read-only access - cannot modify state
- Local queries only return data from partitions assigned to the instance
- For global queries, use RPC between instances or GlobalKTable

## Configuration

**Key Kafka Streams Settings:**
- `application.id` - Unique ID for the streams application (used as consumer group.id)
- `bootstrap.servers` - Kafka cluster connection
- `num.stream.threads` (default: 1) - Processing threads per instance
- `state.dir` (default: /tmp/kafka-streams) - Directory for state stores
- `processing.guarantee` - at_least_once (default) or exactly_once_v2
- `default.key.serde` / `default.value.serde` - Default serialization
- `cache.max.bytes.buffering` (default: 10485760 / 10 MB) - Record cache size
- `commit.interval.ms` (default: 30000 with at_least_once, 100 with exactly_once) - Commit frequency

**[📖 Kafka Streams Configuration](https://docs.confluent.io/platform/current/streams/developer-guide/config-streams.html)** - All configurable settings
