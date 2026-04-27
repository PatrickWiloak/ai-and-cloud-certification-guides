# 01 - Fabric Architecture and Workspaces

## Microsoft Fabric overview

Microsoft Fabric is a **SaaS analytics platform** combining Power BI, Synapse Analytics, Data Factory, Data Science, and real-time streams under one roof. It is sold as **capacity** (compute) with **OneLake** (storage) as the unified substrate.

Three big mental shifts from classic Azure:

1. **Storage is shared.** OneLake is a single tenant-wide data lake. No more per-service storage accounts.
2. **Compute is shared.** Capacity Units (CU) cover all workloads: Spark, Warehouse, Pipelines, Power BI rendering, etc.
3. **Items live in workspaces.** A workspace is the container for Lakehouses, Warehouses, Pipelines, Notebooks, Reports, and more.

---

## Workspaces

A **workspace** is the unit of Fabric:

- All items (Lakehouses, Warehouses, Pipelines, Notebooks, Reports, KQL DBs) live in a workspace
- Workspace is assigned to a **capacity** (which provides compute)
- Workspace has **roles** (Admin / Member / Contributor / Viewer) for access control
- Workspaces can be **Git-connected** to back items in a repo

### Special workspaces

- **My Workspace** - personal, no capacity assigned by default
- **Standard workspace** - the normal multi-user workspace (must be assigned to Fabric capacity for Fabric workloads)

### Lifecycle pattern

Typical Dev / Test / Prod model:

```
Workspace: MyApp (Dev)  ──┐
                          │ Deployment Pipeline
Workspace: MyApp (Test) ──┤
                          │
Workspace: MyApp (Prod) ──┘
```

Each stage is its own workspace; Deployment Pipelines promote items + apply per-env rules (e.g., point to a different Lakehouse per environment).

---

## OneLake

OneLake is **the** Fabric storage. Every Lakehouse, Warehouse, KQL DB stores data here as **Delta Parquet** by default.

### Properties

- One per tenant (you don't choose a region per item)
- Backed by Azure Data Lake Storage Gen2 (ADLS Gen2)
- Free / no charge for storage in trial; metered in capacity units after
- Hierarchical namespace
- Open format (Delta) - any Delta-compatible client can read

### Shortcuts

A **shortcut** is a Fabric pointer to data living elsewhere. No copy. Queries fan out.

| Shortcut target | Use |
|---|---|
| Another OneLake item (Lakehouse, Warehouse) in the same or different workspace | Federated views without duplication |
| ADLS Gen2 (external) | Query existing Azure storage |
| Amazon S3 | Query AWS data |
| Google Cloud Storage | Query GCS |
| Dataverse | Query Power Platform business data |

Shortcuts honor source security (the requester needs access at the source).

### Mirrored databases

A special form of "shortcut" that does **continuous replication** from operational databases:

- Azure Cosmos DB
- Snowflake
- Azure SQL DB

Mirroring lands as Delta tables in OneLake; queryable immediately, no pipeline required.

---

## Capacity

Fabric is sold as **capacity SKUs** measured in **Capacity Units (CU)**:

| SKU | CU | Approx. monthly (USD) |
|---|---|---|
| F2 | 2 | $263 |
| F4 | 4 | $526 |
| F8 | 8 | $1,053 |
| F16 | 16 | $2,105 |
| F32 | 32 | $4,210 |
| F64 | 64 | $8,420 |
| F128 | 128 | $16,841 |
| F256+ | ... | ... |

Pricing is approximate. **F64 corresponds to a Power BI Premium P1** in the older world.

### CU consumption

Different workloads consume CUs at different rates. A Spark notebook execution might consume X CUs/second; a Direct Lake query might consume Y CUs/second; a pipeline activity Z. The **Capacity Metrics App** (free Power BI app) shows per-item, per-user, per-time CU consumption.

### Smoothing and bursting

Fabric capacity allows:

- **Bursting** - workloads can temporarily exceed capacity ceiling
- **Smoothing** - 24-hour smoothing window evens out short bursts
- **Throttling** - if sustained over-consumption breaches the smoothing budget, jobs get delayed/throttled

Right-size capacity by reviewing CU consumption over peak windows. Trial = F64 free for 60 days.

### Free Trial

Sign up for a 60-day Fabric trial via Microsoft Learn. Includes a workspace assigned to free F64-equivalent trial capacity.

---

## Items in a workspace

| Item | Purpose |
|---|---|
| **Lakehouse** | OneLake storage + Spark + read-only SQL endpoint; supports Files (semi-structured) and Tables (Delta) |
| **Warehouse** | OneLake-backed warehouse with full T-SQL DDL/DML |
| **Notebook** | Interactive Spark (Python, SQL, R, Scala) |
| **Spark Job Definition** | Scheduled / parameterized Spark job (no notebook UI) |
| **Pipeline** | Orchestration (Data Factory) |
| **Dataflow Gen2** | Power Query-based low-code transformation |
| **Eventstream** | Streaming ingestion |
| **KQL Database / Eventhouse** | Real-time analytics (Kusto) |
| **Semantic Model** (formerly Dataset) | Power BI tabular model |
| **Report** / **Dashboard** | Power BI visuals |
| **Data Pipelines** | Sequence of activities orchestrating multiple items |

Items have lineage relationships - one item's output feeds another. The lineage is visualized in the workspace.

---

## Identity and access

- **Microsoft Entra ID** (formerly Azure AD) for user identity
- **Service Principals** for unattended jobs
- **Managed Identities** when calling external resources
- **OneLake security predicates** for row/column-level data filtering (preview)

---

## Git integration

A workspace can be linked to:

- Azure DevOps repos
- GitHub repos

Items synced as JSON / source representations. Pull requests work as expected. Promote between workspaces via Deployment Pipelines or via Git (commit to dev branch → PR to main → trigger CI).

---

## Architecture mental model

```
Tenant
├─ OneLake (single lake, hierarchical, Delta default)
│
├─ Capacity F64
│  ├─ Workspace: data-prod
│  │  ├─ Lakehouse: bronze (raw)
│  │  ├─ Lakehouse: silver (curated)
│  │  ├─ Warehouse: gold (BI-ready)
│  │  ├─ Pipeline: nightly-elt
│  │  └─ Semantic Model: sales
│  │
│  └─ Workspace: data-dev (mirrors prod, also on F64)
│
└─ Power BI (across capacities)
   └─ Reports consume gold semantic model via Direct Lake
```

---

## Key exam triggers

- "Reference S3 data in Fabric without copying" → Shortcut to S3
- "Continuous CDC from Cosmos DB" → Mirroring (zero-ETL)
- "Promote items from Dev to Prod" → Deployment Pipelines
- "Version control for Fabric items" → Git integration
- "Single tenant-wide lake" → OneLake
- "Power BI reads Lakehouse without import or DirectQuery" → Direct Lake mode
