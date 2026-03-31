# Kafka Connect and Schema Registry

**[📖 Kafka Connect](https://docs.confluent.io/platform/current/connect/index.html)** - Connect framework documentation
**[📖 Schema Registry](https://docs.confluent.io/platform/current/schema-registry/index.html)** - Schema Registry documentation

## Kafka Connect Overview

### Architecture

**[📖 Connect Architecture](https://docs.confluent.io/platform/current/connect/concepts.html)** - Connect architecture and concepts

**Core Components:**
- **Workers** - JVM processes that execute connectors and tasks
- **Connectors** - Logical jobs that define source/sink configuration
- **Tasks** - Units of work that actually move data
- **Converters** - Serialize/deserialize data between Connect and Kafka
- **Transforms** - Optional record modifications (Single Message Transforms)

### Worker Modes

**Standalone Mode:**
- Single worker process
- Configuration stored in local files
- No fault tolerance or scalability
- Good for development and testing
- Started with: `connect-standalone.sh worker.properties connector.properties`

**Distributed Mode:**
- Multiple worker processes form a Connect cluster
- Configuration stored in Kafka topics (distributed, fault-tolerant)
- Automatic task distribution and rebalancing
- Managed via REST API
- Started with: `connect-distributed.sh worker.properties`

**[📖 Distributed Mode](https://docs.confluent.io/platform/current/connect/concepts.html#distributed-workers)** - Distributed worker configuration

### Worker Configuration

**Key Settings:**
- `bootstrap.servers` - Kafka cluster address
- `group.id` - Connect cluster group ID (distributed mode)
- `config.storage.topic` - Topic for connector configurations
- `offset.storage.topic` - Topic for source connector offsets
- `status.storage.topic` - Topic for connector/task status
- `key.converter` - Default key converter
- `value.converter` - Default value converter
- `plugin.path` - Directories for connector plugins

### Converters

| Converter | Class | Use Case |
|-----------|-------|----------|
| JSON | `org.apache.kafka.connect.json.JsonConverter` | Human-readable, schema optional |
| Avro | `io.confluent.connect.avro.AvroConverter` | Schema Registry, compact binary |
| Protobuf | `io.confluent.connect.protobuf.ProtobufConverter` | Schema Registry, language-neutral |
| JSON Schema | `io.confluent.connect.json.JsonSchemaConverter` | Schema Registry, JSON with schema |
| String | `org.apache.kafka.connect.storage.StringConverter` | Plain text |
| ByteArray | `org.apache.kafka.connect.converters.ByteArrayConverter` | Raw bytes |

**Important:** Converters handle serialization between Connect's internal data format and Kafka. They are configured at the worker level (default) or per connector (override).

## Connector Configuration

### Source Connectors
- Read data from external systems into Kafka topics
- Track source offsets for exactly-once delivery
- Examples: JDBC Source, Debezium (CDC), FileStream Source

### Sink Connectors
- Write data from Kafka topics to external systems
- Track consumer offsets for delivery guarantees
- Examples: JDBC Sink, Elasticsearch Sink, S3 Sink

### Common Configuration Properties

```json
{
  "name": "my-connector",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
    "tasks.max": "3",
    "key.converter": "org.apache.kafka.connect.storage.StringConverter",
    "value.converter": "io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url": "http://localhost:8081",
    "transforms": "route,timestamp",
    "transforms.route.type": "org.apache.kafka.connect.transforms.RegexRouter",
    "transforms.route.regex": "(.*)",
    "transforms.route.replacement": "prefix-$1"
  }
}
```

### Task Parallelism
- `tasks.max` - Maximum number of tasks for the connector
- Actual task count may be less than `tasks.max` (depends on data)
- Source connectors: tasks partition the data source
- Sink connectors: tasks are assigned Kafka partitions
- More tasks = higher parallelism (up to partition count for sinks)

## Single Message Transforms (SMTs)

**[📖 SMT Documentation](https://docs.confluent.io/platform/current/connect/transforms/overview.html)** - Available transforms and configuration

### Built-in Transforms

| Transform | Description |
|-----------|-------------|
| `InsertField` | Add a field using static value or record metadata |
| `ReplaceField` | Filter or rename fields |
| `MaskField` | Replace field value with valid null or zero equivalent |
| `ValueToKey` | Set the record key from a value field |
| `HoistField` | Wrap entire value as a single field |
| `ExtractField` | Extract a single field from a struct |
| `SetSchemaMetadata` | Modify schema name or version |
| `TimestampRouter` | Modify topic name based on timestamp |
| `RegexRouter` | Modify topic name based on regex |
| `Flatten` | Flatten nested structs |
| `Cast` | Cast fields to different types |
| `TimestampConverter` | Convert between timestamp formats |
| `Filter` | Drop records based on a predicate |
| `InsertHeader` | Add a header to the record |
| `HeaderFrom` | Move/copy fields to headers |
| `DropHeaders` | Remove headers |

### Transform Chain
```json
{
  "transforms": "addTimestamp,route",
  "transforms.addTimestamp.type": "org.apache.kafka.connect.transforms.InsertField$Value",
  "transforms.addTimestamp.timestamp.field": "processed_at",
  "transforms.route.type": "org.apache.kafka.connect.transforms.RegexRouter",
  "transforms.route.regex": "(.*)",
  "transforms.route.replacement": "processed-$1"
}
```
- Transforms are applied in the order listed
- Each transform can target key (`$Key`) or value (`$Value`)
- Transforms are lightweight - for complex logic use Kafka Streams

## Error Handling

**[📖 Error Handling](https://docs.confluent.io/platform/current/connect/index.html#error-handling-in-connect)** - Dead letter queues and error tolerance

### Error Tolerance
- `errors.tolerance=none` (default) - Fail on first error
- `errors.tolerance=all` - Skip bad records, continue processing

### Dead Letter Queue (DLQ)
```json
{
  "errors.tolerance": "all",
  "errors.deadletterqueue.topic.name": "my-connector-dlq",
  "errors.deadletterqueue.topic.replication.factor": 3,
  "errors.deadletterqueue.context.headers.enable": true
}
```
- DLQ topic receives records that caused errors
- Context headers include error details (exception, stack trace, connector name)
- Monitor DLQ topic for operational health
- Process DLQ records for remediation

### Error Logging
```json
{
  "errors.log.enable": true,
  "errors.log.include.messages": true
}
```

## Connect REST API

**[📖 REST API Reference](https://docs.confluent.io/platform/current/connect/references/restapi.html)** - Complete REST API documentation

### Key Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/connectors` | List all connectors |
| POST | `/connectors` | Create a new connector |
| GET | `/connectors/{name}` | Get connector info |
| GET | `/connectors/{name}/config` | Get connector config |
| PUT | `/connectors/{name}/config` | Update connector config |
| GET | `/connectors/{name}/status` | Get connector status |
| POST | `/connectors/{name}/restart` | Restart connector |
| PUT | `/connectors/{name}/pause` | Pause connector |
| PUT | `/connectors/{name}/resume` | Resume connector |
| DELETE | `/connectors/{name}` | Delete connector |
| GET | `/connectors/{name}/tasks` | List tasks |
| POST | `/connectors/{name}/tasks/{id}/restart` | Restart task |
| GET | `/connector-plugins` | List available plugins |
| PUT | `/connector-plugins/{name}/config/validate` | Validate config |

---

## Schema Registry

### Overview

**[📖 Schema Registry Overview](https://docs.confluent.io/platform/current/schema-registry/fundamentals/index.html)** - Schema Registry fundamentals

- Centralized schema management for Kafka
- Stores schemas for Kafka topics (key and value)
- Enforces schema compatibility rules
- Supports Avro, Protobuf, and JSON Schema
- Schemas stored in the `_schemas` internal topic
- REST API for schema management

### Subjects and Naming

**Subject Naming Strategies:**
- `TopicNameStrategy` (default) - Subject name: `<topic>-key` / `<topic>-value`
- `RecordNameStrategy` - Subject name: `<fully-qualified-record-name>`
- `TopicRecordNameStrategy` - Subject name: `<topic>-<fully-qualified-record-name>`

**[📖 Subject Name Strategy](https://docs.confluent.io/platform/current/schema-registry/fundamentals/serdes-develop/index.html#subject-name-strategy)** - Configuring subject naming

### Schema IDs
- Each schema version is assigned a globally unique integer ID
- IDs are sequential and never reused
- Producers include the schema ID in the message (first 5 bytes: magic byte + 4-byte ID)
- Consumers use the schema ID to retrieve the schema from the registry

## Schema Compatibility

**[📖 Schema Evolution](https://docs.confluent.io/platform/current/schema-registry/fundamentals/schema-evolution.html)** - Compatibility types and rules

### Compatibility Types

| Mode | Description | Allowed Changes |
|------|-------------|-----------------|
| BACKWARD | New schema reads old data | Add optional field, delete field |
| FORWARD | Old schema reads new data | Delete optional field, add field |
| FULL | Both backward and forward | Add/delete optional fields with defaults |
| BACKWARD_TRANSITIVE | Backward with all versions | Same as BACKWARD, checked against all |
| FORWARD_TRANSITIVE | Forward with all versions | Same as FORWARD, checked against all |
| FULL_TRANSITIVE | Full with all versions | Same as FULL, checked against all |
| NONE | No compatibility checks | Any change allowed |

### Compatibility Rules for Avro

**BACKWARD Compatible Changes:**
- Add a field with a default value
- Remove a field (that had a default in old schema)

**FORWARD Compatible Changes:**
- Remove a field that has a default value
- Add a field (that has a default in new schema)

**FULL Compatible Changes:**
- Add a field with a default value (when old schema also has default)
- Remove a field that has a default value

**Breaking Changes (all modes):**
- Change field type (int to string)
- Rename a field without alias
- Remove a required field (no default)
- Add a required field (no default)

### Compatibility Quick Reference

| Change | BACKWARD | FORWARD | FULL |
|--------|----------|---------|------|
| Add field with default | Yes | Yes | Yes |
| Add field without default | No | Yes | No |
| Remove field with default | Yes | Yes | Yes |
| Remove field without default | Yes | No | No |
| Change field type | No | No | No |

## Schema Registry REST API

**[📖 Schema Registry API](https://docs.confluent.io/platform/current/schema-registry/develop/api.html)** - Complete API reference

### Key Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/subjects` | List all subjects |
| GET | `/subjects/{subject}/versions` | List versions for a subject |
| GET | `/subjects/{subject}/versions/{version}` | Get schema by version |
| POST | `/subjects/{subject}/versions` | Register a new schema |
| POST | `/compatibility/subjects/{subject}/versions/{version}` | Test compatibility |
| GET | `/schemas/ids/{id}` | Get schema by global ID |
| GET | `/config` | Get global compatibility level |
| PUT | `/config` | Set global compatibility level |
| GET | `/config/{subject}` | Get subject compatibility level |
| PUT | `/config/{subject}` | Set subject compatibility level |
| DELETE | `/subjects/{subject}` | Delete subject (soft delete) |
| DELETE | `/subjects/{subject}?permanent=true` | Permanent delete |

### Schema Registration Example
```bash
# Register a new Avro schema
curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  --data '{"schema": "{\"type\":\"record\",\"name\":\"User\",\"fields\":[{\"name\":\"name\",\"type\":\"string\"},{\"name\":\"age\",\"type\":\"int\"}]}"}' \
  http://localhost:8081/subjects/users-value/versions

# Check compatibility
curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  --data '{"schema": "{\"type\":\"record\",\"name\":\"User\",\"fields\":[{\"name\":\"name\",\"type\":\"string\"},{\"name\":\"age\",\"type\":\"int\"},{\"name\":\"email\",\"type\":[\"null\",\"string\"],\"default\":null}]}"}' \
  http://localhost:8081/compatibility/subjects/users-value/versions/latest
```

## Avro, Protobuf, and JSON Schema

### Avro
- Binary format with schema
- Schema defined in JSON
- Compact serialization
- Rich type system (records, enums, arrays, maps, unions)
- Schema evolution with defaults and unions
- Most common format with Confluent Schema Registry

### Protobuf
- Binary format defined by Google
- Schema defined in `.proto` files
- Language-neutral with code generation
- Backward compatible by design (field numbers)
- Good for polyglot environments

### JSON Schema
- JSON format with schema validation
- Human-readable
- Larger payload size than Avro or Protobuf
- Good for debugging and web APIs
- Wide tooling support
