# DP-700 Fabric Data Engineer Associate - Fact Sheet

## Quick Reference

**Exam Code:** DP-700
**Duration:** 100 minutes
**Format:** Multiple choice + multiple response + case studies + Labs (some sittings)
**Cost:** $165 USD
**Passing Score:** 700/1000
**Validity:** 1 year (free annual renewal via Microsoft Learn)

**[📖 Official DP-700 page](https://learn.microsoft.com/credentials/certifications/fabric-data-engineer-associate/)**
**[📖 Skills Measured](https://learn.microsoft.com/credentials/certifications/exams/dp-700/)**
**[📖 Microsoft Fabric Documentation](https://learn.microsoft.com/fabric/)**

---

## Microsoft Fabric architecture

Fabric unifies several Azure analytics services into a SaaS platform with shared storage (OneLake), unified billing (capacity units), and a single experience for engineering, science, BI, and real-time analytics.

### Workloads

| Workload | What it is |
|---|---|
| **Data Engineering** | Lakehouse, notebooks (Spark), Spark job definitions |
| **Data Factory** | Pipelines, Dataflows Gen2 (Power Query) |
| **Data Warehouse** | T-SQL warehouse with auto-distributed compute |
| **Real-Time Intelligence** | Eventstreams, KQL databases (Kusto), real-time dashboards |
| **Power BI** | Reports, dashboards, semantic models |
| **Data Science** | ML notebooks, models, experiments |
| **Databases (preview)** | OLTP databases (SQL DB) inside Fabric |

### OneLake

- Single, organization-wide data lake on top of ADLS Gen2
- "OneDrive for data"
- Default format: **Delta Parquet**
- Items in workspaces (Lakehouses, Warehouses) all sit in OneLake
- **Shortcuts** point to data in other Fabric workspaces or external systems (ADLS, S3, GCS, Dataverse)

### Capacity

- Compute is purchased as **Capacity Units (CU)** at SKU sizes (F2, F4, F8, F16, F32, F64, ...)
- Trial: F64 capacity for 60 days free
- Compute is shared across all workloads in workspaces assigned to a capacity
- Throttling kicks in when burstable consumption exceeds capacity for too long

---

## Ingestion patterns

### Data Pipelines (Data Factory)

- Visual orchestration; copy activity, dataflow activity, notebook activity, lookup, foreach, etc.
- 100+ connectors (similar to ADF)
- Schedule-based, event-based, or on-demand triggers

### Dataflows Gen2

- Power Query-based, M language
- Low-code; great for analyst/data-engineer-lite use
- Output to Lakehouse, Warehouse, KQL DB, or Azure SQL DB

### Notebooks (Spark)

- PySpark, Spark SQL, R, Scala
- Read/write Lakehouse Delta tables
- Schedule via pipelines or Spark Job Definitions

### Eventstream

- Streaming ingestion: Event Hubs, IoT Hubs, Kafka, Azure SQL CDC, AWS Kinesis, Google Pub/Sub
- Routes to Lakehouse, KQL DB, or Eventhouse
- Built-in transformations (filter, aggregate, manage fields)

### Mirroring

- Continuous replication of operational data into Fabric (zero-ETL)
- Sources: Azure Cosmos DB, Snowflake, Azure SQL DB
- Lands as Delta tables in OneLake; queryable immediately

---

## Lakehouse vs Warehouse

| Feature | Lakehouse | Warehouse |
|---|---|---|
| **Storage** | Files + Delta tables | Delta tables only |
| **Engine** | Spark + SQL endpoint (read-only) | Native T-SQL (read+write) |
| **Use case** | Engineering, ML, semi-structured | Analytics, BI, structured |
| **DML support** | Spark writes; SQL endpoint is read-only | Full T-SQL DDL/DML |
| **Schema** | Delta schema, schema-on-read for files | Strict T-SQL schema |
| **Compute** | Spark | MPP T-SQL engine |
| **Cost model** | Pay capacity for compute | Same |

**Choose Lakehouse for** raw + curated zones, Spark / Python development, ML.
**Choose Warehouse for** strict T-SQL, BI-style aggregations, transactional workloads inside the analytics layer.

Both share OneLake, so Power BI Direct Lake mode reads either.

---

## Security and governance

### Workspace roles

| Role | Permissions |
|---|---|
| **Admin** | Full control |
| **Member** | Edit content, manage sources |
| **Contributor** | Edit content |
| **Viewer** | Read-only |

### Item permissions

Beyond workspace roles, individual items (Lakehouse, Warehouse, Pipeline) can have explicit Read / ReadAll / Write / Reshare permissions.

### OneLake security (preview)

Folder/table-level access controls using **OneLake security predicates** for row/column filters.

### Sensitivity labels

Microsoft Purview Information Protection labels (Public, Confidential, Highly Confidential, etc.) propagate from sources into Fabric content for downstream policy enforcement.

### Microsoft Purview integration

- Data Catalog auto-discovers Fabric items
- Lineage tracks item-to-item flow
- Data quality and policy

---

## Deployment Pipelines (CI/CD)

- Promote items between **Dev → Test → Prod** workspaces
- Compare changes before deployment
- Rules to swap parameters per environment (data source, capacity)
- Git integration: backing your workspace with a repository (Azure DevOps or GitHub) for full version control

---

## Monitoring

### Monitoring Hub

- Centralized view of all activities (pipeline runs, Spark jobs, dataflows, refreshes)
- Filter by workspace, item, status, time range
- Drill into individual run logs

### Capacity Metrics App

- Free Power BI app showing per-capacity CU consumption
- Identifies which items / users / time windows consumed the most
- Throttling indicators

---

## Common exam triggers

- "Continuous CDC from Cosmos DB into Fabric without code" → **Mirroring**
- "Streaming events from IoT Hub" → **Eventstream**
- "Low-code Power Query transform" → **Dataflows Gen2**
- "PySpark notebook on Lakehouse data" → Notebooks
- "Strict T-SQL writes" → **Warehouse**, not Lakehouse SQL endpoint
- "Promote workspace from Dev to Prod" → **Deployment Pipelines**
- "Reference S3 data without copying" → **Shortcut** to S3
- "Multi-workspace shared semantic model" → Power BI semantic model + Direct Lake
- "Restrict columns in a Lakehouse table" → OneLake security predicates / row-column filters
- "Schedule a notebook nightly" → Pipeline with Notebook activity, scheduled trigger

---

## Highest-yield facts

1. **OneLake is the single Fabric storage layer.** Every Lakehouse, Warehouse, KQL DB lives in it as Delta files.
2. **Direct Lake** is Power BI's Fabric-native storage mode - no import, no DirectQuery, reads Delta directly from OneLake. Fastest-perf BI when everything is in Fabric.
3. **Capacity throttling**: Fabric has burstable + smoothing windows. Sustained over-consumption = throttle. Right-size capacity SKU.
4. **Lakehouse SQL endpoint is read-only**; for T-SQL writes use a Warehouse.
5. **Mirroring is zero-ETL** - no pipeline, no Spark, no copy activity. Just a config + landing in OneLake.
6. **Shortcuts** to external storage = no copy, queries fan out. Useful for federated queries.
7. **Deployment Pipelines** support Dev/Test/Prod, item-level diff, and rule-based parameter swaps.
8. **Git integration** = workspace ↔ repo sync; full version control for Fabric items (notebooks, pipelines, semantic models).
9. **Eventstream** has built-in transforms (filter, aggregate, manage fields) - you don't need a separate stream processor for simple transforms.
10. **OneLake security** is the row/column-filter mechanism (preview as of 2026).

---

## Comparison: DP-700 vs DP-203

| Aspect | DP-700 (Fabric) | DP-203 (Azure) |
|---|---|---|
| **Platform** | Microsoft Fabric (SaaS) | Synapse, ADLS Gen2, ADF (Azure-native) |
| **Storage** | OneLake (single lake) | ADLS Gen2 (per-account) |
| **Engine** | Spark + Warehouse + KQL | Synapse Spark + SQL Pool + Synapse Pipelines |
| **Power BI** | Native (Direct Lake) | Imported / DirectQuery |
| **Audience** | Data engineers using Fabric SaaS | Data engineers using Azure-native services |
| **Status** | Modern, growing | Still active; companion path |

Most candidates today take **DP-700 if their org is on Fabric**; DP-203 if on classic Azure data stack.

---

## Hands-on practice priorities

1. Build a Lakehouse: ingest CSVs to Files, convert to Delta tables via notebook
2. Create a Pipeline: schedule a notebook + Dataflow + email-on-failure
3. Build a Dataflow Gen2: Power Query-style transform writing to Warehouse
4. Set up Mirroring from a free Cosmos DB account
5. Configure Eventstream from sample event source → Lakehouse + KQL DB
6. Promote a workspace through a Deployment Pipeline (Dev → Test → Prod)
7. Connect the workspace to a Git repo and commit changes
8. Build a Power BI report on a Lakehouse with Direct Lake mode

These cover ~80% of likely exam scenarios.

---

## Comparable certs in this repo

- **[DP-203 Azure Data Engineer](../dp-203/)** - Azure-native data engineering
- **[DP-600 Fabric Analytics Engineer](../dp-600/)** - Fabric from analyst angle
- **[AWS DEA-C01](../../aws/associate/data-engineer-dea-c01/)** - AWS counterpart
- **[Databricks DE Associate](../../databricks/data-engineer-associate/)** - lakehouse counterpart
