# 03 - Lakehouse, Warehouse, and Notebooks

## Lakehouse

### Structure

A Lakehouse has two areas:

- **Files** - any format (CSV, JSON, Parquet, semi-structured); accessed by path
- **Tables** - Delta-formatted tables; queryable via Spark and the SQL endpoint

```
Lakehouse: bronze
├─ Files/
│  ├─ raw/2026/04/01/sales.csv
│  ├─ raw/2026/04/02/sales.csv
│  └─ ...
└─ Tables/
   ├─ customers (Delta)
   ├─ products (Delta)
   └─ orders (Delta)
```

### SQL endpoint

Every Lakehouse exposes a **read-only T-SQL endpoint**. Power BI Direct Lake reads from this. You can run T-SQL SELECT but **not INSERT / UPDATE / DELETE**.

### Spark engine

- Native Spark for read/write
- Apache Spark 3.x with Microsoft optimizations
- Reads/writes Delta natively
- Photon-style accelerator (V-Order optimization)

### V-Order

Fabric-specific Delta optimization that pre-sorts data to maximize Direct Lake / SQL endpoint performance. Enable per-table or globally.

```sql
OPTIMIZE my_table VORDER;
```

### Schema enforcement

Delta tables enforce schema by default. Schema evolution is opt-in:

```python
df.write.format("delta") \
    .option("mergeSchema", "true") \
    .mode("append") \
    .saveAsTable("LakehouseName.tablename")
```

### Common operations

```python
# Write a Delta table
df.write.format("delta").mode("overwrite").saveAsTable("LakehouseName.products")

# Read
df = spark.read.format("delta").table("LakehouseName.products")

# MERGE (upsert)
spark.sql("""
    MERGE INTO LakehouseName.customers tgt
    USING staging_customers src ON tgt.id = src.id
    WHEN MATCHED THEN UPDATE SET *
    WHEN NOT MATCHED THEN INSERT *
""")

# Time travel
spark.sql("SELECT * FROM LakehouseName.products VERSION AS OF 5")
spark.sql("SELECT * FROM LakehouseName.products TIMESTAMP AS OF '2026-04-15'")

# Optimize
spark.sql("OPTIMIZE LakehouseName.products")
spark.sql("OPTIMIZE LakehouseName.products ZORDER BY (region)")

# Vacuum (cleanup old versions)
spark.sql("VACUUM LakehouseName.products RETAIN 168 HOURS")
```

---

## Warehouse

A Fabric Warehouse is a **T-SQL native warehouse** with full DDL/DML, distributed compute, and OneLake-backed Delta storage.

### Properties

- T-SQL endpoint - same dialect as Synapse Dedicated SQL Pool, more or less
- Full INSERT / UPDATE / DELETE / MERGE support
- Cross-warehouse / cross-Lakehouse queries via 3-part naming: `WarehouseA.dbo.tbl`
- Stored procedures, views, functions
- Auto-optimizing distribution (no manual hash/round-robin choice like Synapse)

### When to use Warehouse over Lakehouse

| Use case | Warehouse | Lakehouse |
|---|---|---|
| Strict T-SQL writes (UPDATE/DELETE) | ✅ | ❌ |
| BI-style aggregations | ✅ | ✅ (via SQL endpoint) |
| Spark / Python development | ❌ | ✅ |
| Mixed structured + semi-structured | ❌ | ✅ |
| Stored procedures | ✅ | ❌ |

Both store data in OneLake (Delta), so Power BI can read either via Direct Lake.

### Cross-database queries

```sql
-- Query a Lakehouse table from a Warehouse
SELECT * FROM MyLakehouse.dbo.products;

-- Query another Warehouse
SELECT * FROM AnotherWarehouse.dbo.customers;
```

This works because they all share OneLake.

### Loading data

```sql
COPY INTO dbo.sales
FROM 'https://onelake.dfs.fabric.microsoft.com/...'
WITH (FILE_TYPE = 'PARQUET');
```

Or via Pipeline Copy activity (visual).

---

## Notebooks

Interactive Spark for engineering, ML, and any code-first work.

### Languages

Each cell can be a different language:

- `%%pyspark` - PySpark (default)
- `%%sql` - Spark SQL
- `%%scala`
- `%%sparkr`
- `%%python` (no Spark, just Python)

### Magic commands

- `%lsmagic` - list magics
- `%pip install <package>` - install for current session
- `%%configure` - Spark config for the session

### Saving from a notebook to a Lakehouse

```python
# Attach the Lakehouse to the notebook (UI)
df = spark.read.csv("Files/raw/sales.csv", header=True)
df.write.format("delta").mode("overwrite").saveAsTable("sales_clean")
```

The path `Files/...` resolves to the attached Lakehouse's Files area.

### Running on a schedule

- Pipeline with Notebook activity (parameterizable)
- Spark Job Definition (productionized notebook execution)

### Resource pools

- **Starter Pool** - shared, ~30s startup
- **Custom Pool** - configured nodes, libraries, version; ~1-3min startup but reproducible

### Pickling environments

For prod, lock to a specific environment:

- Set up a custom pool with pinned Python / Spark / Delta versions
- Add required libraries via the **Environment** item (Fabric-managed conda envs)

---

## Direct Lake mode (Power BI on Fabric)

The unique value proposition of Fabric for BI.

### How it differs from Import / DirectQuery

- **Import**: data is loaded into the model; refresh required; bound by model size
- **DirectQuery**: data stays at source; every query goes to source; latency varies
- **Direct Lake**: data is read on-demand from Delta files in OneLake into Power BI's analysis services engine; no import, no DirectQuery latency, no refresh schedule

Direct Lake gives import-like speed without the refresh / size constraints, when source is in OneLake (Lakehouse, Warehouse).

### Fallback

If a query is incompatible with Direct Lake (e.g., Power Query transformation in the model), it falls back to DirectQuery automatically.

---

## Common operations cheat sheet

| Task | How |
|---|---|
| Read CSV from Lakehouse Files | `spark.read.csv("Files/path/to/file.csv", header=True)` |
| Save as Delta table | `df.write.format("delta").saveAsTable("tablename")` |
| Read Delta table | `spark.read.table("tablename")` or `spark.sql("SELECT ...")` |
| Optimize for Direct Lake | `OPTIMIZE table VORDER` |
| Cross-Lakehouse query in Warehouse | `SELECT * FROM Lakehouse.dbo.table` |
| Time travel | `... VERSION AS OF N` or `TIMESTAMP AS OF '...'` |
| Schedule notebook | Pipeline with Notebook activity |

---

## Common exam triggers

- "Read-only T-SQL access to Lakehouse" → SQL endpoint
- "Full T-SQL DDL/DML" → Warehouse, not Lakehouse
- "Cross-Lakehouse SQL query" → Warehouse with 3-part naming
- "Speed up Direct Lake queries" → V-Order + OPTIMIZE
- "Schedule a parameterized Spark job" → Pipeline + Spark Job Definition
- "Reproducible notebook environment" → Custom Spark Pool + Environment
- "Power BI without import or DirectQuery" → Direct Lake mode (requires source in OneLake)
