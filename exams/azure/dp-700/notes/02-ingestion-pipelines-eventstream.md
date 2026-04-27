# 02 - Ingestion: Pipelines, Dataflows, Eventstream, Mirroring

Fabric offers **four** ingestion patterns. Picking the right one matters - exam tests this.

---

## 1. Data Pipelines (Data Factory in Fabric)

Visual orchestration for batch / mini-batch ingestion. Familiar if you've used Azure Data Factory or Synapse Pipelines.

### Activities

- **Copy Data** - the bulk copy primitive (200+ connectors)
- **Notebook** - run a Fabric notebook
- **Spark Job Definition** - parameterized Spark job
- **Dataflow Gen2** - run a dataflow
- **Stored Procedure** - on Fabric Warehouse or Azure SQL
- **Lookup**, **For Each**, **If Condition**, **Until**, **Wait**, **Web** (HTTP), **Azure Function**, **Set Variable**

### Triggers

- Schedule (cron-like)
- Event-based (file arrival in Azure Storage / OneLake)
- Tumbling window
- On-demand

### Use when

- You need orchestration: multiple steps, retries, branching, parameter passing
- Source/sink connector exists in Copy Data
- You want a visual canvas

---

## 2. Dataflows Gen2

Power Query-based low-code transforms. Best for analyst-style work or simple ETL.

### Properties

- M language under the hood (same as Excel Power Query / Power BI)
- 200+ connectors
- Output to Lakehouse Tables, Warehouse, KQL DB, or Azure SQL DB
- Supports incremental refresh

### Use when

- Power Query mindset (filter, pivot, merge, append)
- You want low-code; analysts can build/maintain
- Lightweight transforms; not heavy joins or aggregations

### Avoid when

- Heavy Spark workload (use notebooks instead)
- High-volume streaming (use Eventstream)

---

## 3. Notebooks (Spark)

Interactive PySpark / Spark SQL / Scala / R. Use for:

- Heavy transforms with joins, aggregations, ML feature engineering
- Code-first development
- Schema evolution control
- Integration with non-tabular data

### Spark cluster modes

- **Starter Pool** - shared, fast startup, good for development
- **Custom Pool** - configurable nodes, version, libraries; better for prod jobs
- **Workspace-default Spark settings** - applied if pool not specified

### Notebook environments

- Reusable conda environments for library management
- Pin to specific Python / Spark / Delta versions

### Schedule

Notebooks don't run themselves - schedule via Pipeline (Notebook activity) or Spark Job Definition.

---

## 4. Eventstream

Streaming ingestion with built-in transforms.

### Sources

- Azure Event Hubs
- Azure IoT Hub
- Apache Kafka
- Azure SQL DB CDC
- AWS Kinesis Streams (newer)
- Google Pub/Sub (newer)
- Custom App via REST endpoint
- Sample data (for testing)

### Destinations

- **Lakehouse** - lands as Delta in OneLake
- **KQL Database / Eventhouse** - real-time analytics
- **Reflex** - reactive item that triggers actions on conditions
- **Custom endpoint** - send to your own listener

### Built-in transforms

- Filter, Aggregate (over windows), Manage Fields (rename/drop), Group By, Join (between streams), Expand
- No-code; drag-and-drop

### Use when

- Real-time / near-real-time event processing
- Hot path = KQL for sub-second analytics; warm path = Lakehouse for downstream batch

---

## 5. Mirroring (zero-ETL)

Continuous replication with no pipeline required. Microsoft maintains the replication for you.

### Supported sources (as of 2026-04)

- Azure Cosmos DB
- Snowflake
- Azure SQL Database
- Azure Database for PostgreSQL
- More on the roadmap

### How it works

1. Configure mirroring on the source via the Fabric workspace
2. Initial backfill copies existing data
3. Ongoing CDC keeps Fabric in sync (typically seconds-to-minutes lag)
4. Data lands as **Delta tables in OneLake** under the mirrored item
5. Queryable from Lakehouse SQL endpoint, Warehouse (via shortcut), Power BI Direct Lake

### Use when

- You need operational data in Fabric for analytics, fresh, no engineering effort
- Source is one of the supported types

---

## Choosing between patterns

| Need | Pattern |
|---|---|
| Continuous CDC from Cosmos / SQL DB / Snowflake, no ETL | **Mirroring** |
| Real-time event ingest (IoT, Kafka, etc.) | **Eventstream** |
| Bulk batch with orchestration, branching, retries | **Pipeline** with Copy Data + activities |
| Low-code Power Query transforms | **Dataflow Gen2** |
| Heavy Spark logic | **Notebook** scheduled in a Pipeline |
| Low-code + lots of joins/aggregations? | **Dataflow Gen2** if lightweight, else **Notebook** |

---

## Common patterns

### Bronze-silver-gold lakehouse

```
Source → Pipeline (Copy Data) → Lakehouse Bronze (raw)
                              → Notebook → Lakehouse Silver (cleaned, deduped)
                                         → Notebook → Warehouse Gold (joined, aggregated)
                                                    → Power BI semantic model (Direct Lake)
```

### Streaming + batch (Lambda)

```
Stream sources → Eventstream → KQL DB (hot, sub-second BI dashboards)
                             → Lakehouse Bronze (warm, batch analytics)
                                            → Notebook → Silver/Gold
```

### Hybrid analytical + operational

```
Cosmos DB → Mirroring → Fabric (Delta in OneLake)
SQL DB    → Mirroring → Fabric

   ↓ joined in Warehouse SQL ↓
Power BI Direct Lake → Reports
```

---

## Common exam triggers

- "Continuous CDC from Cosmos DB without code" → Mirroring
- "Real-time IoT events into a Delta table" → Eventstream → Lakehouse
- "Power Query transform writes to Warehouse" → Dataflow Gen2
- "Spark transform that joins 3 sources" → Notebook scheduled in Pipeline
- "Schedule a notebook nightly with email-on-failure" → Pipeline with Notebook activity + scheduled trigger + Web activity for email (or built-in alerts)
- "Multi-step ELT with conditional branches" → Pipeline with If/ForEach activities
- "Subscribe to Kafka topic, filter, write to Lakehouse" → Eventstream
