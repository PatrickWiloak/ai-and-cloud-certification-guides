# SnowPro Core Certification Fact Sheet

## Exam Overview

**Exam Code:** COF-C02
**Exam Name:** SnowPro Core Certification
**Duration:** 115 minutes
**Questions:** 100 multiple choice
**Passing Score:** 750/1000
**Cost:** $175 USD
**Valid For:** 2 years
**Delivery:** Online proctored
**Prerequisites:** None

**[📖 Official Exam Page](https://learn.snowflake.com/en/certifications/snowpro-core/)** - Registration and official details
**[📖 Exam Study Guide](https://learn.snowflake.com/en/certifications/snowpro-core/)** - Domain breakdown and objectives
**[📖 Snowflake Documentation](https://docs.snowflake.com/)** - Primary reference material

## Target Audience

This certification is designed for:
- Data engineers working with Snowflake daily
- Database administrators transitioning to cloud data platforms
- Data analysts needing to validate Snowflake knowledge
- Solutions architects designing Snowflake-based solutions
- Anyone pursuing SnowPro Advanced certifications (this is a prerequisite)

**[📖 Certification Overview](https://learn.snowflake.com/en/certifications/)** - All Snowflake certifications
**[📖 Snowflake University](https://learn.snowflake.com/)** - Free training courses

## Domain 1: Snowflake Cloud Data Platform Features and Architecture (25%)

This is the most heavily weighted domain covering Snowflake's unique architecture.

### Three-Layer Architecture

**Storage Layer:**
- Data stored in micro-partitions (50-500 MB compressed)
- Columnar format for efficient compression and scanning
- Automatic organization - no manual indexing needed
- Stored in cloud provider's blob storage (S3, Azure Blob, GCS)
- Immutable micro-partitions - updates create new partitions

**[📖 Micro-Partitions and Data Clustering](https://docs.snowflake.com/en/user-guide/tables-clustering-micropartitions)** - Storage internals
**[📖 Data Storage Considerations](https://docs.snowflake.com/en/user-guide/data-storage-considerations)** - Storage costs and management

**Compute Layer (Virtual Warehouses):**
- Independent compute clusters that process queries
- T-shirt sizing: X-Small through 6X-Large
- Each size doubles compute from previous (X-Small = 1 credit/hour)
- Can be started, stopped, and resized without data loss
- Auto-suspend and auto-resume capabilities
- Multi-cluster warehouses for concurrent workloads

**[📖 Virtual Warehouses](https://docs.snowflake.com/en/user-guide/warehouses)** - Warehouse management
**[📖 Warehouse Sizing](https://docs.snowflake.com/en/user-guide/warehouses-considerations)** - Performance and sizing guide
**[📖 Multi-Cluster Warehouses](https://docs.snowflake.com/en/user-guide/warehouses-multicluster)** - Scaling for concurrency

**Cloud Services Layer:**
- Authentication and access control
- Infrastructure management
- Metadata management
- Query parsing and optimization
- Transaction management
- Charged only when exceeding 10% of daily warehouse usage

**[📖 Cloud Services Layer](https://docs.snowflake.com/en/user-guide/intro-key-concepts)** - Architecture overview

### Snowflake Editions

| Feature | Standard | Enterprise | Business Critical | VPS |
|---------|----------|------------|-------------------|-----|
| Time Travel | 1 day | 90 days | 90 days | 90 days |
| Multi-cluster warehouses | No | Yes | Yes | Yes |
| Materialized views | No | Yes | Yes | Yes |
| Column-level security | No | Yes | Yes | Yes |
| Search optimization | No | Yes | Yes | Yes |
| Failover/failback | No | No | Yes | Yes |
| Tri-Secret Secure | No | No | Yes | Yes |
| HIPAA/PCI DSS support | No | No | Yes | Yes |
| Dedicated infrastructure | No | No | No | Yes |

**[📖 Snowflake Editions](https://docs.snowflake.com/en/user-guide/intro-editions)** - Edition comparison
**[📖 Pricing Guide](https://www.snowflake.com/pricing/)** - Credit costs by edition and cloud

### Connectivity

- Snowflake Web UI (Snowsight)
- SnowSQL CLI client
- ODBC/JDBC drivers
- Python connector (snowflake-connector-python)
- Spark connector
- Node.js driver
- Go driver
- .NET driver

**[📖 Connecting to Snowflake](https://docs.snowflake.com/en/user-guide/connecting)** - All connection methods
**[📖 Snowsight](https://docs.snowflake.com/en/user-guide/ui-snowsight)** - Web interface guide

## Domain 2: Account Access and Security (20%)

### Role-Based Access Control (RBAC)

**System-Defined Roles:**
- **ACCOUNTADMIN:** Top-level role, combines SYSADMIN and SECURITYADMIN. Use sparingly.
- **SECURITYADMIN:** Manages grants, can manage any object grant. Owns USERADMIN role.
- **SYSADMIN:** Creates and manages databases and warehouses. Recommended for object creation.
- **USERADMIN:** Creates and manages users and roles.
- **PUBLIC:** Automatically granted to every user. Lowest privilege.
- **ORGADMIN:** Organization-level management (cross-account).

**[📖 Access Control Overview](https://docs.snowflake.com/en/user-guide/security-access-control-overview)** - RBAC fundamentals
**[📖 System-Defined Roles](https://docs.snowflake.com/en/user-guide/security-access-control-overview#system-defined-roles)** - Role descriptions
**[📖 Access Control Privileges](https://docs.snowflake.com/en/user-guide/security-access-control-privileges)** - All available privileges

**Best Practices:**
- Always use SYSADMIN or lower for object creation
- Create custom roles and grant to SYSADMIN
- Limit ACCOUNTADMIN usage to administrative tasks
- Enable MFA for ACCOUNTADMIN users
- Use role hierarchy for privilege inheritance

### Authentication

- Username/password authentication
- Multi-Factor Authentication (MFA) - Duo Security
- Key pair authentication (RSA 2048-bit minimum)
- Federated authentication (SAML 2.0)
- External OAuth
- Snowflake OAuth

**[📖 Authentication](https://docs.snowflake.com/en/user-guide/admin-security-fed-auth-overview)** - Federation and SSO
**[📖 Key Pair Authentication](https://docs.snowflake.com/en/user-guide/key-pair-auth)** - Service account auth
**[📖 MFA](https://docs.snowflake.com/en/user-guide/security-mfa)** - Multi-factor setup

### Network Security

- Network policies for IP allow/block lists
- Private connectivity (AWS PrivateLink, Azure Private Link, GCP Private Service Connect)
- Minimum TLS 1.2 for all connections

**[📖 Network Policies](https://docs.snowflake.com/en/user-guide/network-policies)** - IP allowlisting
**[📖 Private Connectivity](https://docs.snowflake.com/en/user-guide/admin-security-privatelink)** - AWS PrivateLink setup

### Data Encryption

- All data encrypted at rest (AES-256)
- All data encrypted in transit (TLS 1.2+)
- Automatic encryption key management
- Periodic key rotation (annual for Snowflake-managed keys)
- Tri-Secret Secure (customer-managed key + Snowflake key) - Business Critical+

**[📖 Encryption](https://docs.snowflake.com/en/user-guide/security-encryption)** - Encryption overview
**[📖 Tri-Secret Secure](https://docs.snowflake.com/en/user-guide/security-encryption-manage)** - Customer-managed keys

## Domain 3: Performance Concepts (15%)

### Caching

**Result Cache:**
- Stores query results for 24 hours
- Shared across users if same query and same role context
- No warehouse needed - served from cloud services layer
- Invalidated when underlying data changes
- Can be disabled with USE_CACHED_RESULT = FALSE

**Warehouse Cache (Local Disk Cache):**
- SSD storage on warehouse compute nodes
- Caches raw data from remote storage
- Cleared when warehouse is suspended
- Improves subsequent queries on same data

**Metadata Cache:**
- Maintained in cloud services layer
- Stores min/max values, distinct count, null count per micro-partition
- Enables query pruning without scanning data
- Used for COUNT(*), MIN(), MAX() on clustered data

**[📖 Query Caching](https://docs.snowflake.com/en/user-guide/querying-persisted-results)** - Result cache details
**[📖 Warehouse Caching](https://docs.snowflake.com/en/user-guide/warehouses-considerations)** - Cache behavior

### Clustering

- Micro-partitions are automatically clustered by ingestion order
- Clustering keys can be defined for large tables (multi-TB)
- Automatic Clustering maintains clustering over time (Enterprise+)
- Clustering depth metric measures clustering quality
- Use SYSTEM$CLUSTERING_INFORMATION() to assess clustering

**When to Use Clustering Keys:**
- Tables larger than 1 TB
- Queries frequently filter on specific columns
- Query performance has degraded over time
- High clustering depth values

**[📖 Clustering Keys](https://docs.snowflake.com/en/user-guide/tables-clustering-keys)** - Clustering fundamentals
**[📖 Automatic Clustering](https://docs.snowflake.com/en/user-guide/tables-auto-reclustering)** - Managed clustering

### Query Optimization

- Use Query Profile to identify bottlenecks
- Look for: spillage to disk, exploding joins, inefficient pruning
- Warehouse sizing: scale up for complex queries, scale out for concurrency
- Avoid SELECT * - specify needed columns
- Use appropriate data types
- Leverage semi-structured data optimizations

**[📖 Query Profile](https://docs.snowflake.com/en/user-guide/ui-query-profile)** - Analyzing query performance
**[📖 Query Optimization](https://docs.snowflake.com/en/user-guide/performance-query)** - Performance tuning

### Resource Monitors

- Track credit usage at account or warehouse level
- Set credit quotas with notification thresholds
- Actions: notify, notify and suspend, notify and suspend immediately
- Can be set for monthly, daily, or custom intervals

**[📖 Resource Monitors](https://docs.snowflake.com/en/user-guide/resource-monitors)** - Credit monitoring

## Domain 4: Data Loading and Unloading (10%)

### Stages

**Internal Stages:**
- User stage (@~) - each user has one, cannot be altered or dropped
- Table stage (@%table_name) - each table has one
- Named internal stage (CREATE STAGE) - most flexible

**External Stages:**
- Amazon S3
- Microsoft Azure Blob Storage
- Google Cloud Storage
- Requires storage integration or credentials

**[📖 Stages](https://docs.snowflake.com/en/user-guide/data-load-overview#stages)** - Stage types overview
**[📖 Internal Stages](https://docs.snowflake.com/en/user-guide/data-load-local-file-system-create-stage)** - Creating internal stages
**[📖 External Stages](https://docs.snowflake.com/en/user-guide/data-load-s3-create-stage)** - S3 stage setup

### COPY INTO (Loading)

```sql
COPY INTO my_table
FROM @my_stage/path/
FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1)
ON_ERROR = 'CONTINUE'
PATTERN = '.*[.]csv';
```

**ON_ERROR Options:**
- CONTINUE - skip errors, load valid rows
- SKIP_FILE - skip entire file on error
- SKIP_FILE_n - skip file after n errors
- ABORT_STATEMENT - abort entire load on first error (default)

**VALIDATION_MODE:**
- RETURN_n_ROWS - validate first n rows without loading
- RETURN_ERRORS - validate all rows and return errors
- RETURN_ALL_ERRORS - validate and return all errors

**[📖 COPY INTO Table](https://docs.snowflake.com/en/sql-reference/sql/copy-into-table)** - Loading syntax
**[📖 Data Loading Best Practices](https://docs.snowflake.com/en/user-guide/data-load-considerations-prepare)** - File preparation

### Snowpipe

- Serverless, continuous data ingestion
- Event-driven (cloud storage notifications) or REST API
- Uses a dedicated compute (not virtual warehouses)
- Near real-time loading (within minutes)
- Charged per-second compute usage

**[📖 Snowpipe](https://docs.snowflake.com/en/user-guide/data-load-snowpipe-intro)** - Continuous loading
**[📖 Snowpipe REST API](https://docs.snowflake.com/en/user-guide/data-load-snowpipe-rest-apis)** - REST endpoints

### Data Unloading

```sql
COPY INTO @my_stage/output/
FROM my_table
FILE_FORMAT = (TYPE = 'PARQUET')
HEADER = TRUE;
```

**[📖 COPY INTO Location](https://docs.snowflake.com/en/sql-reference/sql/copy-into-location)** - Unloading syntax

## Domain 5: Data Transformations (20%)

### Semi-Structured Data

**VARIANT Data Type:**
- Stores JSON, Avro, ORC, Parquet, XML natively
- Maximum size 16 MB per value
- Queried using dot notation or bracket notation

```sql
SELECT raw_data:customer.name::STRING AS customer_name
FROM my_table;

SELECT raw_data['customer']['name']::STRING AS customer_name
FROM my_table;
```

**FLATTEN Function:**
```sql
SELECT f.value:name::STRING AS name
FROM my_table,
LATERAL FLATTEN(input => raw_data:items) f;
```

**[📖 Semi-Structured Data](https://docs.snowflake.com/en/user-guide/semistructured-concepts)** - VARIANT overview
**[📖 FLATTEN](https://docs.snowflake.com/en/sql-reference/functions/flatten)** - Unnesting arrays
**[📖 Querying Semi-Structured Data](https://docs.snowflake.com/en/user-guide/querying-semistructured)** - Query patterns

### Streams and Tasks

**Streams (Change Data Capture):**
- Track DML changes (INSERT, UPDATE, DELETE) on a table
- Standard streams - track all changes
- Append-only streams - track inserts only
- Insert-only streams - for external tables
- METADATA$ACTION, METADATA$ISUPDATE, METADATA$ROW_ID columns

**Tasks:**
- Schedule SQL statements or stored procedures
- Cron or interval-based scheduling
- Task trees (DAGs) with dependencies
- Serverless tasks or warehouse-based tasks
- Must be explicitly resumed after creation (ALTER TASK RESUME)

**[📖 Streams](https://docs.snowflake.com/en/user-guide/streams-intro)** - CDC fundamentals
**[📖 Tasks](https://docs.snowflake.com/en/user-guide/tasks-intro)** - Task scheduling

### Stored Procedures and UDFs

**Stored Procedures:**
- JavaScript, SQL, Python, Java, Scala
- Can execute DDL and DML
- Owner's rights or caller's rights
- EXECUTE AS OWNER (default) or EXECUTE AS CALLER

**User-Defined Functions (UDFs):**
- SQL, JavaScript, Python, Java
- Scalar or tabular (UDTF)
- Must return a value
- Cannot perform DML operations

**[📖 Stored Procedures](https://docs.snowflake.com/en/sql-reference/stored-procedures)** - Procedure creation
**[📖 UDFs](https://docs.snowflake.com/en/sql-reference/user-defined-functions)** - Function creation

### Views

- **Regular Views:** Store query definition, not data. No performance benefit.
- **Secure Views:** Hide view definition from non-owners. Use for data sharing.
- **Materialized Views:** Pre-compute and store results. Enterprise+ only. Auto-maintained.

**[📖 Views](https://docs.snowflake.com/en/user-guide/views-introduction)** - View types and usage

## Domain 6: Data Protection and Data Sharing (10%)

### Time Travel

- Query historical data using AT or BEFORE clauses
- Standard edition: 0-1 day retention
- Enterprise+: 0-90 days retention
- Uses DATA_RETENTION_TIME_IN_DAYS parameter

```sql
SELECT * FROM my_table AT(TIMESTAMP => '2024-01-01 12:00:00'::TIMESTAMP);
SELECT * FROM my_table BEFORE(STATEMENT => 'query_id');
```

**[📖 Time Travel](https://docs.snowflake.com/en/user-guide/data-time-travel)** - Historical data access

### Fail-Safe

- 7-day period after Time Travel expires
- Non-configurable, Snowflake-managed
- Data recovery requires contacting Snowflake Support
- Storage costs apply during Fail-safe period
- Cannot be disabled

**[📖 Fail-Safe](https://docs.snowflake.com/en/user-guide/data-failsafe)** - Disaster recovery protection

### Zero-Copy Cloning

- Creates metadata copy, not physical copy
- No additional storage until clone is modified
- Works on databases, schemas, tables, stages, file formats, sequences, streams, tasks
- Clones inherit granted privileges if COPY GRANTS is specified
- Time Travel is independent between source and clone

```sql
CREATE TABLE my_clone CLONE my_table;
CREATE DATABASE dev_db CLONE prod_db;
```

**[📖 Cloning](https://docs.snowflake.com/en/user-guide/object-clone)** - Zero-copy clone details

### Data Sharing

- Share data without copying or moving it
- Provider creates a share, consumer creates a database from it
- Read-only access for consumers
- Real-time access to provider's data
- Reader accounts for non-Snowflake customers (provider pays compute)

**[📖 Data Sharing](https://docs.snowflake.com/en/user-guide/data-sharing-intro)** - Sharing fundamentals
**[📖 Snowflake Marketplace](https://docs.snowflake.com/en/user-guide/data-marketplace)** - Public data exchange

### Replication

- Database replication across regions and clouds
- Account replication for DR
- Failover groups for business continuity
- Primary and secondary database model

**[📖 Replication](https://docs.snowflake.com/en/user-guide/account-replication-intro)** - Cross-region replication

## Exam Tips

### High-Priority Topics
1. Architecture (three layers, caching, micro-partitions)
2. RBAC model and role hierarchy
3. Virtual warehouse sizing and multi-cluster behavior
4. Data loading methods (COPY INTO vs Snowpipe)
5. Semi-structured data handling (VARIANT, FLATTEN)
6. Time Travel vs Fail-safe differences
7. Edition-specific features
8. Streams and tasks for CDC

### Common Trick Questions
- Result cache does not require a running warehouse
- Fail-safe cannot be accessed by users directly
- Clustering keys are not recommended for small tables
- ACCOUNTADMIN should not own objects directly
- Snowpipe uses its own compute, not virtual warehouses
- Multi-cluster warehouses require Enterprise edition
- Zero-copy cloning is a metadata operation initially
- Streams must be consumed regularly to avoid staleness

### Time Management
- 100 questions in 115 minutes = ~69 seconds per question
- Flag difficult questions and return to them
- Read all answer choices before selecting
- Look for absolute language in wrong answers
