# Snowflake Architecture

**[📖 Key Concepts and Architecture](https://docs.snowflake.com/en/user-guide/intro-key-concepts)** - Complete architecture overview

## Three-Layer Architecture

Snowflake's architecture separates storage, compute, and cloud services into three independent layers that scale independently.

**[📖 Architecture Overview](https://docs.snowflake.com/en/user-guide/intro-key-concepts#snowflake-architecture)** - Detailed layer descriptions

### Storage Layer

- All data stored as micro-partitions in cloud provider's object storage
- Micro-partitions: 50-500 MB compressed, contiguous units of storage
- Columnar format - each column stored separately within partitions
- Immutable - updates create new micro-partitions
- Automatic compression (no manual tuning needed)
- Data stored in a proprietary optimized format (not raw files)
- Storage is billed monthly based on average compressed data

**[📖 Micro-Partitions](https://docs.snowflake.com/en/user-guide/tables-clustering-micropartitions)** - Partition internals
**[📖 Data Storage](https://docs.snowflake.com/en/user-guide/data-storage-considerations)** - Storage pricing model

#### Micro-Partition Details
- Each partition stores 50-500 MB of uncompressed data
- Organized by natural ingestion order initially
- Metadata tracked: min/max values, distinct count, null count per column
- Pruning uses metadata to skip irrelevant partitions
- Cannot be manually created or managed
- All data types including semi-structured stored in columnar format

### Compute Layer (Virtual Warehouses)

Virtual warehouses are MPP (Massively Parallel Processing) compute clusters.

**[📖 Virtual Warehouses](https://docs.snowflake.com/en/user-guide/warehouses)** - Warehouse management guide

#### Warehouse Sizing
| Size | Credits/Hour | Relative Performance |
|------|-------------|---------------------|
| X-Small | 1 | 1x |
| Small | 2 | 2x |
| Medium | 4 | 4x |
| Large | 8 | 8x |
| X-Large | 16 | 16x |
| 2X-Large | 32 | 32x |
| 3X-Large | 64 | 64x |
| 4X-Large | 128 | 128x |
| 5X-Large | 256 | 256x |
| 6X-Large | 512 | 512x |

**[📖 Warehouse Sizing](https://docs.snowflake.com/en/user-guide/warehouses-considerations)** - Choosing warehouse size

#### Key Behaviors
- **Auto-Suspend:** Warehouse pauses after a period of inactivity (default 10 min)
- **Auto-Resume:** Warehouse starts when a query is submitted
- **Scaling Up:** Change warehouse size for more complex queries
- **Scaling Out:** Add clusters for more concurrent queries (multi-cluster)
- **Credit billing:** Per-second billing with 60-second minimum
- **No data stored:** Warehouses do not store data persistently

#### Multi-Cluster Warehouses (Enterprise+)

**[📖 Multi-Cluster Warehouses](https://docs.snowflake.com/en/user-guide/warehouses-multicluster)** - Concurrency scaling

- Add additional clusters to handle concurrent queries
- MIN and MAX cluster count configuration
- **Standard Scaling Policy:** Starts new cluster immediately when queries queue
- **Economy Scaling Policy:** Starts new cluster only when estimated to run for 6+ minutes
- Standard is better for consistent performance; Economy reduces costs

### Cloud Services Layer

The brain of Snowflake - handles management functions.

**[📖 Cloud Services](https://docs.snowflake.com/en/user-guide/intro-key-concepts#cloud-services)** - Services layer details

#### Responsibilities
- **Authentication:** User login, MFA, SSO
- **Access Control:** RBAC enforcement, privilege checks
- **Infrastructure Management:** Warehouse provisioning, scaling
- **Metadata Management:** Object definitions, statistics, query history
- **Query Parsing/Optimization:** SQL compilation, execution planning
- **Transaction Management:** ACID compliance

#### Billing
- Cloud services usage is free up to 10% of daily warehouse consumption
- Only charged for usage exceeding that 10% threshold
- Includes: query parsing, authentication, metadata operations

## Caching Architecture

Snowflake has three distinct caching layers:

### Result Cache
- Stored in cloud services layer
- Returns exact results for identical queries
- 24-hour validity window
- Shared across users with same role context
- Does NOT require a running warehouse
- Invalidated when underlying data changes
- Can be disabled: `ALTER SESSION SET USE_CACHED_RESULT = FALSE`

### Warehouse Cache (Local Disk Cache)
- SSD storage on warehouse compute nodes
- Caches raw micro-partition data read from remote storage
- Persists as long as warehouse is running
- Cleared when warehouse is suspended
- Benefits subsequent queries on same/overlapping data
- Not shared across warehouses

### Metadata Cache
- Maintained by cloud services layer
- Stores column statistics (min, max, count, null count)
- Enables query pruning before data scan
- Answers simple aggregate queries instantly (COUNT, MIN, MAX)
- Always available, no cost

**[📖 Query Caching](https://docs.snowflake.com/en/user-guide/querying-persisted-results)** - Result cache behavior

## Snowflake Objects Hierarchy

```
Organization
  └── Account
       ├── User
       ├── Role
       ├── Warehouse
       ├── Resource Monitor
       ├── Database
       │    └── Schema
       │         ├── Table
       │         ├── View
       │         ├── Stage
       │         ├── File Format
       │         ├── Pipe
       │         ├── Stream
       │         ├── Task
       │         ├── Sequence
       │         ├── Stored Procedure
       │         ├── UDF
       │         └── Masking Policy
       └── Share
```

**[📖 Object Identifiers](https://docs.snowflake.com/en/sql-reference/identifiers)** - Naming conventions

## Snowflake Editions

**[📖 Snowflake Editions](https://docs.snowflake.com/en/user-guide/intro-editions)** - Feature comparison

### Standard
- Full SQL support, encryption, Time Travel (1 day)
- Basic security features, single-cluster warehouses

### Enterprise (adds)
- Multi-cluster warehouses
- Up to 90-day Time Travel
- Materialized views
- Column-level security (masking policies)
- Search optimization
- Dynamic data masking
- Row access policies

### Business Critical (adds)
- Tri-Secret Secure and customer-managed keys
- AWS PrivateLink / Azure Private Link / GCP Private Service Connect
- Failover and failback between accounts
- Database failover groups
- HIPAA and PCI DSS compliance support
- Enhanced security for regulated industries

### Virtual Private Snowflake (VPS)
- Completely isolated Snowflake environment
- Dedicated infrastructure and metadata store
- Highest level of security
- Required for FedRAMP and specific government workloads

## Cloud Provider Support

- AWS (most regions)
- Microsoft Azure
- Google Cloud Platform
- Cross-cloud data sharing and replication supported
- Choose cloud provider and region at account creation
- Some features may vary by cloud provider

**[📖 Supported Regions](https://docs.snowflake.com/en/user-guide/intro-regions)** - Available regions by cloud
