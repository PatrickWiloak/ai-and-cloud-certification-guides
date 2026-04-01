# Data and Cluster Management - Databricks Lakehouse Platform Administrator

## Overview

This domain combines cluster/warehouse management (15%) and data management (20%), covering cluster policies, SQL warehouses, auto-scaling, spot instances, and Unity Catalog data objects.

## Cluster Management

### Cluster Types

**[📖 Compute Configuration](https://docs.databricks.com/en/compute/index.html)** - Cluster documentation

| Type | Purpose | Lifecycle |
|------|---------|-----------|
| All-purpose cluster | Interactive workloads, notebooks, development | Long-running, manual start/stop |
| Job cluster | Automated job execution | Created per job run, auto-terminated |
| SQL warehouse | SQL queries and BI tools | Managed, auto-start/stop |

### Cluster Configuration

**[📖 Cluster Configuration](https://docs.databricks.com/en/compute/configure.html)** - Configuration options

Key parameters:
- **Node type**: Instance type for driver and worker nodes
- **Autoscaling**: Min and max workers
- **Auto-termination**: Idle timeout (default 120 minutes)
- **Spark version**: Databricks Runtime version
- **Spark configuration**: Custom Spark properties
- **Environment variables**: Set on driver and workers
- **Init scripts**: Startup scripts for customization
- **Instance pools**: Pre-provisioned instances for faster startup
- **Spot instances**: Cost optimization for worker nodes

### Auto-Scaling

**[📖 Auto-Scaling](https://docs.databricks.com/en/compute/configure.html#autoscaling)** - Dynamic scaling

- Set min and max worker count
- Databricks scales based on pending task queue
- Scale-up: Adds workers when tasks are queued
- Scale-down: Removes workers after idle period
- Optimized autoscaling (default): Faster scale-down, cost-efficient
- Standard autoscaling: More conservative scaling

**Best practices:**
- Set min workers to handle baseline load
- Set max workers for peak workloads
- Use auto-termination to stop idle clusters
- Consider fixed-size clusters for predictable workloads

### Spot/Preemptible Instances

**[📖 Spot Instances](https://docs.databricks.com/en/compute/configure.html#spot-instances)** - Cost optimization

- **Driver node**: Always use on-demand (driver loss kills the cluster)
- **Worker nodes**: Can use spot/preemptible for cost savings (60-90% savings)
- **First on-demand**: Specify minimum on-demand workers for stability
- **Fallback to on-demand**: When spot capacity unavailable
- Spot workers may be reclaimed - Spark handles task re-execution

### Instance Pools

**[📖 Instance Pools](https://docs.databricks.com/en/compute/pool-index.html)** - Pre-provisioned instances

- Pre-allocate cloud instances for faster cluster startup
- Reduce cluster start time from minutes to seconds
- Set min and max idle instances
- Auto-terminate idle instances after timeout
- Cost: Pay for idle instances in the pool
- Share pools across multiple clusters

## Cluster Policies

**[📖 Cluster Policies](https://docs.databricks.com/en/admin/clusters/policy-definition.html)** - Governance

### Purpose

- Restrict cluster configurations to enforce standards
- Control costs by limiting instance types, sizes, and features
- Simplify cluster creation for end users
- Enforce security settings (network, encryption, init scripts)

### Policy Definition

Policies use JSON with three attribute types:
- **fixed**: Value cannot be changed by user
- **range**: Numeric range (min/max)
- **allowlist**: Set of allowed values
- **forbidden**: Attribute cannot be set
- **unlimited**: No restriction (explicitly allow)

**Example policy:**
```json
{
  "node_type_id": {
    "type": "allowlist",
    "values": ["i3.xlarge", "i3.2xlarge"],
    "defaultValue": "i3.xlarge"
  },
  "autoscale.max_workers": {
    "type": "range",
    "maxValue": 10,
    "defaultValue": 4
  },
  "spark_version": {
    "type": "fixed",
    "value": "13.3.x-scala2.12"
  },
  "custom_tags.team": {
    "type": "fixed",
    "value": "data-engineering"
  }
}
```

### Policy Permissions

- **Can use**: User can create clusters with this policy
- **Can manage**: User can edit the policy
- Assign policies to groups for team-based governance
- Users without "Allow cluster creation" entitlement can only use policies

## SQL Warehouses

**[📖 SQL Warehouses](https://docs.databricks.com/en/sql/admin/sql-endpoints.html)** - SQL compute

### Types

| Type | Description | Use Case |
|------|-------------|----------|
| Serverless | Databricks-managed, fastest startup | Default recommendation |
| Pro | Customer-managed, advanced features | Custom networking needs |
| Classic | Legacy, basic features | Backward compatibility |

### Configuration

- **Size**: 2X-Small to 4X-Large (T-shirt sizing, maps to cluster resources)
- **Auto-stop**: Idle timeout before shutdown (default 10-45 min)
- **Scaling**: Min and max clusters for concurrency
- **Spot policy**: Cost-optimized or reliability-optimized
- **Channel**: Current or Preview (for testing new features)
- **Tags**: Custom tags for cost allocation

### SQL Warehouse Scaling

- Each "cluster" handles a number of concurrent queries
- Min/max clusters control concurrency scaling
- Queries queue when all clusters are busy
- Scale-out for concurrent users, scale-up (size) for complex queries
- Serverless warehouses have faster auto-scale response

## Unity Catalog Data Management

### Data Object Hierarchy

**[📖 Unity Catalog](https://docs.databricks.com/en/data-governance/unity-catalog/index.html)** - Data governance

```
Metastore
└── Catalog
    └── Schema (Database)
        ├── Table (Managed or External)
        ├── View
        ├── Volume (Managed or External)
        ├── Function
        └── Model
```

### Managed vs External Tables

**[📖 Tables](https://docs.databricks.com/en/data-governance/unity-catalog/create-tables.html)** - Table types

| Feature | Managed Table | External Table |
|---------|--------------|----------------|
| Data location | Metastore/catalog managed storage | User-specified location |
| DROP behavior | Deletes data and metadata | Deletes metadata only |
| Format | Delta (required) | Delta, Parquet, CSV, JSON, etc. |
| Governance | Full Unity Catalog governance | Full Unity Catalog governance |

### Volumes

**[📖 Volumes](https://docs.databricks.com/en/connect/unity-catalog/volumes.html)** - File management

- Governed access to non-tabular files (images, logs, CSVs, JARs)
- **Managed volumes**: Storage managed by Unity Catalog
- **External volumes**: Point to existing cloud storage
- Path syntax: `/Volumes/<catalog>/<schema>/<volume>/<path>`
- Permissions: READ VOLUME, WRITE VOLUME, CREATE VOLUME

### External Locations and Storage Credentials

**[📖 External Locations](https://docs.databricks.com/en/sql/language-manual/sql-ref-external-locations.html)** - Cloud storage access

**Storage Credentials:**
- Define how Databricks authenticates to cloud storage
- AWS: IAM role
- Azure: Managed identity or service principal
- GCP: Service account
- Created by metastore admin

**External Locations:**
- Map a cloud storage path to a storage credential
- Grant access to specific paths (not entire buckets)
- Enables external tables and volumes
- Controls who can create external objects at that path

### Data Lineage

**[📖 Data Lineage](https://docs.databricks.com/en/data-governance/unity-catalog/data-lineage.html)** - Tracking data flow

- Automatic lineage tracking for Unity Catalog objects
- Table-level and column-level lineage
- Tracks across notebooks, jobs, and SQL queries
- Visual lineage graph in Catalog Explorer
- Helps with impact analysis and compliance

### Delta Sharing

**[📖 Delta Sharing](https://docs.databricks.com/en/delta-sharing/index.html)** - Cross-organization data sharing

- Open protocol for sharing data across organizations
- Share with Databricks or non-Databricks consumers
- No data copying - consumers query shared data in place
- Providers create shares, recipients access shares
- Fine-grained access: Share specific tables or partitions

## Common Exam Patterns

1. **"Control cluster costs"** - Cluster policies with max worker limits and instance allowlists
2. **"Fastest cluster startup"** - Instance pools
3. **"Spot instance for driver"** - Never use spot for driver node
4. **"SQL query concurrency"** - SQL warehouse scaling (min/max clusters)
5. **"Drop table keeps data"** - External table (DROP removes metadata only)
6. **"Access cloud storage through Unity Catalog"** - External location + storage credential
7. **"Share data outside organization"** - Delta Sharing
8. **"Track data dependencies"** - Unity Catalog data lineage
