# ksqlDB

**[📖 ksqlDB Documentation](https://docs.confluent.io/platform/current/ksqldb/index.html)** - Complete ksqlDB reference
**[📖 ksqlDB Reference](https://docs.confluent.io/platform/current/ksqldb/reference/index.html)** - SQL syntax reference

## ksqlDB Overview

### What is ksqlDB?
- SQL-based stream processing engine built on Kafka Streams
- Create stream processing applications using SQL statements
- No Java/Scala code required for stream processing
- Supports both streaming (push) and materialized view (pull) queries
- Runs as a cluster of ksqlDB servers

**[📖 ksqlDB Concepts](https://docs.confluent.io/platform/current/ksqldb/concepts/index.html)** - Core ksqlDB concepts

### Architecture
- ksqlDB server runs as a JVM process
- Multiple servers form a ksqlDB cluster
- Each server is backed by Kafka Streams
- Persistent queries are distributed across servers
- State stores backed by RocksDB and changelog topics
- REST API and CLI for query submission

### Deployment Modes
- **Interactive Mode** - Submit queries via CLI or REST API
- **Headless Mode** - Load queries from a file at startup (production recommended)

## Streams and Tables

### Streams
- Immutable, append-only collection of events
- Each event is independent and timestamped
- Backed by a Kafka topic
- Insert semantics (every record is a new event)
- Cannot be updated or deleted after creation

**Creating a Stream:**
```sql
CREATE STREAM orders (
    order_id VARCHAR KEY,
    customer_id VARCHAR,
    product VARCHAR,
    amount DECIMAL(10, 2),
    order_time TIMESTAMP
) WITH (
    KAFKA_TOPIC = 'orders',
    VALUE_FORMAT = 'AVRO',
    TIMESTAMP = 'order_time'
);
```

**Creating a Stream from Existing Topic:**
```sql
CREATE STREAM orders WITH (
    KAFKA_TOPIC = 'orders',
    VALUE_FORMAT = 'JSON'
);
```

### Tables
- Mutable collection with latest value per key
- Upsert semantics (new records update existing keys)
- Null values represent deletes (tombstones)
- Backed by a Kafka topic (compacted)
- Supports pull queries for point-in-time lookups

**Creating a Table:**
```sql
CREATE TABLE customers (
    customer_id VARCHAR PRIMARY KEY,
    name VARCHAR,
    email VARCHAR,
    tier VARCHAR
) WITH (
    KAFKA_TOPIC = 'customers',
    VALUE_FORMAT = 'AVRO'
);
```

### Differences Between Streams and Tables

| Feature | Stream | Table |
|---------|--------|-------|
| Semantics | Append-only | Upsert by key |
| Duplicate keys | Allowed | Latest value wins |
| Pull queries | No | Yes |
| Push queries | Yes | Yes (on changes) |
| Analogous to | Log / Event stream | Database table |

## Query Types

### Push Queries
- Continuous queries that emit results as data changes
- Use `EMIT CHANGES` clause
- Long-running - client connection stays open
- Used for real-time streaming applications

```sql
SELECT customer_id, COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
EMIT CHANGES;
```

### Pull Queries
- Point-in-time lookups against materialized views
- Returns current state and terminates
- Only supported on materialized tables (created with aggregation)
- Similar to a database SELECT query
- Must filter by primary key or use table scan

```sql
SELECT * FROM order_counts
WHERE customer_id = 'C123';
```

### Persistent Queries
- Queries that run continuously on the server
- Created with `CREATE STREAM AS SELECT` or `CREATE TABLE AS SELECT`
- Write results to a Kafka topic
- Survive server restarts
- Managed via `SHOW QUERIES`, `TERMINATE <query_id>`

```sql
CREATE STREAM high_value_orders AS
    SELECT *
    FROM orders
    WHERE amount > 1000
    EMIT CHANGES;
```

## Data Manipulation

### INSERT INTO
```sql
-- Insert into a stream
INSERT INTO orders (order_id, customer_id, product, amount)
VALUES ('O100', 'C001', 'Widget', 29.99);

-- Insert from another stream
INSERT INTO all_events
    SELECT * FROM orders EMIT CHANGES;
```

### Filtering
```sql
CREATE STREAM premium_orders AS
    SELECT *
    FROM orders
    WHERE amount > 500
    EMIT CHANGES;
```

### Transformations
```sql
CREATE STREAM enriched_orders AS
    SELECT
        order_id,
        customer_id,
        UCASE(product) AS product_upper,
        amount * 1.1 AS amount_with_tax,
        TIMESTAMPTOSTRING(order_time, 'yyyy-MM-dd') AS order_date
    FROM orders
    EMIT CHANGES;
```

## Aggregations

**[📖 Aggregation Functions](https://docs.confluent.io/platform/current/ksqldb/reference/aggregate-functions.html)** - Available aggregate functions

### Simple Aggregation
```sql
CREATE TABLE order_counts AS
    SELECT customer_id, COUNT(*) AS total_orders, SUM(amount) AS total_spent
    FROM orders
    GROUP BY customer_id
    EMIT CHANGES;
```

### Windowed Aggregation

**Tumbling Window:**
```sql
CREATE TABLE hourly_order_counts AS
    SELECT customer_id,
           COUNT(*) AS order_count,
           WINDOWSTART AS window_start,
           WINDOWEND AS window_end
    FROM orders
    WINDOW TUMBLING (SIZE 1 HOUR)
    GROUP BY customer_id
    EMIT CHANGES;
```

**Hopping Window:**
```sql
CREATE TABLE sliding_counts AS
    SELECT customer_id,
           COUNT(*) AS order_count
    FROM orders
    WINDOW HOPPING (SIZE 1 HOUR, ADVANCE BY 10 MINUTES)
    GROUP BY customer_id
    EMIT CHANGES;
```

**Session Window:**
```sql
CREATE TABLE session_counts AS
    SELECT customer_id,
           COUNT(*) AS order_count
    FROM orders
    WINDOW SESSION (30 MINUTES)
    GROUP BY customer_id
    EMIT CHANGES;
```

### Available Aggregate Functions
- `COUNT(*)` / `COUNT(col)` - Count records
- `SUM(col)` - Sum numeric values
- `AVG(col)` - Average of numeric values
- `MIN(col)` / `MAX(col)` - Minimum/maximum values
- `COLLECT_LIST(col)` - Collect values into an array
- `COLLECT_SET(col)` - Collect distinct values into an array
- `TOPK(col, k)` / `TOPKDISTINCT(col, k)` - Top K values
- `EARLIEST_BY_OFFSET(col)` / `LATEST_BY_OFFSET(col)` - First/last by offset
- `HISTOGRAM(col)` - Frequency distribution as a map

## Joins

**[📖 ksqlDB Joins](https://docs.confluent.io/platform/current/ksqldb/reference/sql/joins.html)** - Join types and syntax

### Stream-Stream Join
```sql
CREATE STREAM order_payments AS
    SELECT o.order_id, o.customer_id, o.amount, p.payment_method
    FROM orders o
    INNER JOIN payments p
        WITHIN 1 HOUR
        ON o.order_id = p.order_id
    EMIT CHANGES;
```
- Requires a WITHIN clause (time window)
- Supports INNER, LEFT, and FULL OUTER joins
- Both sides must be streams

### Stream-Table Join
```sql
CREATE STREAM enriched_orders AS
    SELECT o.order_id, o.amount, c.name, c.tier
    FROM orders o
    LEFT JOIN customers c
        ON o.customer_id = c.customer_id
    EMIT CHANGES;
```
- No WITHIN clause (uses current table state)
- Supports INNER and LEFT joins
- Left side must be a stream, right side must be a table

### Table-Table Join
```sql
CREATE TABLE customer_summary AS
    SELECT c.customer_id, c.name, s.total_spent
    FROM customers c
    INNER JOIN spending_summary s
        ON c.customer_id = s.customer_id
    EMIT CHANGES;
```
- No WITHIN clause
- Supports INNER, LEFT, FULL OUTER joins
- Both sides must be tables

## Materialized Views

### Creating Materialized Views
```sql
CREATE TABLE customer_spending AS
    SELECT customer_id,
           COUNT(*) AS order_count,
           SUM(amount) AS total_spent,
           AVG(amount) AS avg_order
    FROM orders
    GROUP BY customer_id
    EMIT CHANGES;
```

### Querying Materialized Views (Pull Queries)
```sql
-- Key lookup
SELECT * FROM customer_spending WHERE customer_id = 'C001';

-- Range scan (if supported)
SELECT * FROM customer_spending WHERE total_spent > 1000;
```

### Key Points
- Materialized views are tables created with aggregations
- Backed by Kafka state stores (RocksDB)
- Updated in real-time as new data arrives
- Pull queries return current state instantly
- Only tables (not streams) support pull queries

## User-Defined Functions (UDFs)

**[📖 Custom Functions](https://docs.confluent.io/platform/current/ksqldb/concepts/functions.html)** - Creating custom functions

### Types of Custom Functions
- **UDF** - Scalar function (one input row to one output value)
- **UDAF** - Aggregate function (many input rows to one output value)
- **UDTF** - Table function (one input row to zero or more output rows)

### Built-in Functions
- **String**: CONCAT, SUBSTRING, TRIM, LPAD, RPAD, REPLACE, UCASE, LCASE
- **Math**: ABS, CEIL, FLOOR, ROUND, SQRT, POWER, MOD
- **Date/Time**: UNIX_TIMESTAMP, DATETOSTRING, STRINGTODATE, TIMESTAMPTOSTRING
- **Conditional**: CASE, IFNULL, COALESCE
- **Type**: CAST, ARRAY, MAP, STRUCT

## ksqlDB REST API

**[📖 REST API](https://docs.confluent.io/platform/current/ksqldb/developer-guide/api.html)** - ksqlDB REST API reference

### Key Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/ksql` | Execute a ksqlDB statement |
| POST | `/query` | Run a push or pull query |
| POST | `/query-stream` | HTTP/2 streaming queries |
| GET | `/status` | Server status |
| GET | `/healthcheck` | Health check |
| GET | `/info` | Server info |

### Example REST API Call
```bash
# Execute a statement
curl -X POST http://localhost:8088/ksql \
  -H "Content-Type: application/vnd.ksql.v1+json" \
  -d '{"ksql": "SHOW STREAMS;", "streamsProperties": {}}'

# Run a pull query
curl -X POST http://localhost:8088/query \
  -H "Content-Type: application/vnd.ksql.v1+json" \
  -d '{"ksql": "SELECT * FROM customer_spending WHERE customer_id = '\''C001'\'';", "streamsProperties": {}}'
```

## Management Commands

### Query Management
```sql
SHOW QUERIES;                    -- List all running queries
EXPLAIN <query_id>;              -- Show query execution plan
TERMINATE <query_id>;            -- Stop a persistent query
TERMINATE ALL;                   -- Stop all persistent queries
```

### Stream/Table Management
```sql
SHOW STREAMS;                    -- List all streams
SHOW TABLES;                     -- List all tables
DESCRIBE <stream_or_table>;      -- Show schema
DESCRIBE EXTENDED <name>;        -- Show detailed info
DROP STREAM <name>;              -- Drop a stream
DROP TABLE <name>;               -- Drop a table
DROP STREAM <name> DELETE TOPIC; -- Drop and delete backing topic
```

### Topic and Connector Management
```sql
SHOW TOPICS;                     -- List Kafka topics
SHOW CONNECTORS;                 -- List Connect connectors
PRINT '<topic>' FROM BEGINNING;  -- Print topic contents
```

## Key Configuration

| Setting | Description | Default |
|---------|-------------|---------|
| `ksql.service.id` | ksqlDB cluster ID | default_ |
| `ksql.streams.auto.offset.reset` | Offset reset for new consumers | latest |
| `ksql.streams.num.stream.threads` | Processing threads | 4 |
| `ksql.schema.registry.url` | Schema Registry URL | - |
| `ksql.connect.url` | Kafka Connect URL | - |
| `ksql.queries.file` | Queries file for headless mode | - |
| `ksql.output.topic.name.prefix` | Prefix for output topics | - |
