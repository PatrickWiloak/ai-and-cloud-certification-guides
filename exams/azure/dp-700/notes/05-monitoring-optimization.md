# 05 - Monitoring and Optimization

## Monitoring Hub

The central UI for observability. Shows all activities across the workspace: pipeline runs, Spark jobs, dataflow refreshes, semantic model refreshes, notebook executions.

### What you see

- Status: Succeeded / Failed / In Progress / Queued
- Item type, owner, duration
- Drill into individual run logs

### Filters

- By workspace
- By item type
- By status / time window
- By initiator (user vs service principal vs schedule)

---

## Capacity Metrics App

A free Power BI app provided by Microsoft. Connect it to your Fabric capacity for detailed CU consumption breakdown.

### Reports

- **CU consumption over time**: who consumed what, when
- **Throttling indicators**: any operations delayed because of capacity over-utilization
- **Top consumers**: which items / users / operations used the most CUs
- **Background vs interactive**: pipeline / Spark consumption (background, smoothed) vs Power BI reports (interactive, less smoothed)

### Patterns to watch

- **Sustained over-100% utilization** → consider sizing up (e.g., F32 → F64) or move heavy work to off-peak
- **Single user consuming disproportionate CUs** → coaching, query optimization
- **Refresh failures during peak** → reschedule to off-peak

---

## Diagnostic logs

Workspace activity logs can flow to:

- Log Analytics workspace (for Kusto queries)
- Azure Storage (long-term archival)
- Event Hubs (real-time processing)

Enable per workspace.

---

## Lakehouse / Warehouse query optimization

### Lakehouse

- **V-Order** the Delta tables: `OPTIMIZE table VORDER` - critical for Direct Lake performance
- **Partition by query-predicate columns** (e.g., date) - prune at read time
- **Compact small files** with `OPTIMIZE`
- **Vacuum** old versions (default 7-day retention)
- Use **statistics** updated regularly for SQL endpoint query plans

### Warehouse

- **Auto-distribution** - the Warehouse picks distribution; less manual tuning than Synapse Dedicated SQL Pool
- **Result-set caching** - identical queries served from cache
- **Statistics** - automatic, kept fresh
- **Distribution column hints** - for very large fact tables

---

## Spark performance

### Cluster sizing

- Larger nodes for memory-bound work (joins, aggregations on big tables)
- More workers for embarrassingly-parallel work (per-partition transforms)
- Minimum nodes vs auto-scale: pre-warm vs cost

### Code patterns

- **Cache** intermediate DataFrames used multiple times: `df.cache()`
- **Avoid `.toPandas()`** on large data (collects to driver - OOM)
- **Predicate pushdown** - filter early
- **Join hints**: broadcast small tables: `df.join(broadcast(small_df), "key")`
- **Repartition wisely** - don't repartition unnecessarily, target ~128MB per partition

### Spark UI

Open the Spark UI from a notebook execution to:

- Identify slow stages
- Spot data skew (one task taking 10x longer than others)
- Find expensive shuffles

---

## Pipeline tuning

- **Parallel For Each** - increase concurrency for embarrassingly-parallel iteration
- **Activity timeout** - set per activity to fail fast
- **Retry policies** - sane retry counts (3) and backoff
- **Logical partitioning** in Copy Data - parallel reads from a partitioned source

---

## Cost optimization

### Reduce CU consumption

- **Right-size capacity** - don't over-provision
- **Schedule heavy work off-peak** - smoothing window absorbs bursts
- **Use Direct Lake** instead of Import for Power BI - less compute on refresh
- **Cache** for repeated computations
- **OneLake shortcuts** instead of copies - reduce duplicate storage and processing

### Pause capacity

- Capacity can be **paused** when not in use (e.g., overnight, weekends for dev)
- Paused capacities don't accrue cost
- Resumed capacity comes online in seconds

---

## Alerts and notifications

### Built-in

- Pipeline failure → email or Teams notification (via webhook activity or built-in alert)
- Capacity throttling → email to capacity admin (configurable)
- Refresh failure on semantic model → email

### Reflex (preview)

A Fabric item that triggers actions on conditions:

- Watch a stream / KQL query
- Trigger a Power Automate flow, send email, post to Teams when condition met
- Use case: "Alert when daily sales drop 20% below average"

---

## Common exam triggers

- "See all pipeline runs in one place" → Monitoring Hub
- "Identify which user is consuming the most CUs" → Capacity Metrics App
- "Speed up Direct Lake queries" → V-Order + OPTIMIZE
- "Spark job is slow due to data skew" → Spark UI to diagnose; salt the join key or repartition
- "Reduce cost when dev workspace is idle" → Pause capacity (or use cheaper SKU)
- "Alert when daily revenue drops" → Reflex reactive item
- "Long-term archive of activity logs" → Diagnostic settings to Azure Storage

---

## High-yield checklist for production Fabric workloads

- [ ] V-Ordered, OPTIMIZED Delta tables in Lakehouse
- [ ] Partitioned by query-predicate columns where useful
- [ ] Right-sized Spark pool (custom pool for prod)
- [ ] Pinned Environment for reproducibility
- [ ] Pipeline retries + alerts configured
- [ ] Capacity Metrics App connected and reviewed weekly
- [ ] Sensitivity labels applied to sensitive items
- [ ] Item-level permissions tighter than workspace where needed
- [ ] Git integration in place for source control
- [ ] Deployment Pipeline for Dev → Test → Prod promotion
- [ ] Diagnostic settings to Log Analytics for audit
