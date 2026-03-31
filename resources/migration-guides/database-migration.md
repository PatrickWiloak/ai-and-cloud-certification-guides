# Database Migration Guide

## Overview

Database migration is one of the most critical and risk-sensitive parts of any cloud migration. This guide covers homogeneous and heterogeneous migration strategies, schema conversion tools, continuous replication, downtime minimization techniques, and data validation approaches across AWS, Azure, and GCP.

---

## Migration Types

### Homogeneous Migration

- Same database engine on source and target (e.g., MySQL to MySQL, PostgreSQL to PostgreSQL)
- No schema conversion needed
- Lower risk and complexity
- Examples:
  - On-premises PostgreSQL to Amazon RDS for PostgreSQL
  - On-premises MySQL to Azure Database for MySQL
  - On-premises SQL Server to Google Cloud SQL for SQL Server

### Heterogeneous Migration

- Different database engine on source and target (e.g., Oracle to PostgreSQL)
- Requires schema conversion (data types, stored procedures, functions)
- Higher complexity - plan for manual remediation of conversion issues
- Examples:
  - Oracle to Amazon Aurora PostgreSQL
  - SQL Server to Azure Database for PostgreSQL
  - Oracle to Google AlloyDB for PostgreSQL

### Migration Strategy Decision Matrix

| Factor | Homogeneous | Heterogeneous |
|--------|------------|---------------|
| Complexity | Low-Medium | High |
| Schema conversion | None or minimal | Required |
| Stored procedure migration | Direct copy | Manual rewrite often needed |
| Testing effort | Moderate | Extensive |
| Timeline | Weeks | Months |
| Risk | Lower | Higher |
| Cost savings potential | Moderate | High (escape expensive licenses) |

---

## Schema Conversion Tools

### AWS Schema Conversion Tool (SCT)

- Converts database schemas from one engine to another
- Supports source engines: Oracle, SQL Server, MySQL, PostgreSQL, DB2, Sybase
- Target engines: Amazon Aurora, PostgreSQL, MySQL, MariaDB, Redshift
- Identifies conversion issues with severity ratings:
  - Green: automatically converted
  - Yellow: requires minor manual changes
  - Red: requires significant manual effort
- Generates migration assessment reports
- Converts stored procedures, functions, triggers, views, and sequences
- Documentation: https://docs.aws.amazon.com/SchemaConversionTool/latest/userguide/CHAP_Welcome.html

### Azure Database Migration Assessment (DMA)

- Assesses SQL Server databases for migration to Azure SQL
- Identifies compatibility issues and breaking changes
- Recommends target Azure SQL deployment option
- Provides feature parity analysis
- Documentation: https://learn.microsoft.com/en-us/sql/dma/dma-overview

### Azure Data Migration Assistant

- Migrates SQL Server schema and data to Azure SQL Database
- Handles schema migration, data migration, and login migration
- Supports SQL Server 2005 and later

### ora2pg

- Open-source tool for Oracle to PostgreSQL migration
- Converts schemas, data, stored procedures, packages, and triggers
- Generates migration cost estimates
- Active community and regular updates
- Documentation: https://ora2pg.darold.net/documentation.html

### pgloader

- Open-source tool for migrating to PostgreSQL from MySQL, SQLite, and others
- Handles schema conversion and data loading in a single step
- Supports continuous migration with Change Data Capture
- Documentation: https://pgloader.readthedocs.io/

### Additional Conversion Tools

- **SQL Server Migration Assistant (SSMA)**: Oracle, MySQL, DB2, SAP ASE to SQL Server/Azure SQL
- **AWS DMS Schema Conversion**: integrated schema conversion within DMS (newer approach)
- **Google Database Migration Service**: includes schema mapping for supported sources

---

## Cloud Database Migration Services

### AWS Database Migration Service (DMS)

- Fully managed continuous replication service
- Supports one-time migration and ongoing replication
- Source endpoints: Oracle, SQL Server, MySQL, PostgreSQL, MongoDB, SAP ASE, DB2, and more
- Target endpoints: RDS, Aurora, Redshift, DynamoDB, S3, Kinesis, OpenSearch
- Task types:
  - Full load: migrates existing data
  - CDC (Change Data Capture): replicates ongoing changes
  - Full load + CDC: migrates existing data then captures changes
- Serverless option available for automatic scaling
- Documentation: https://docs.aws.amazon.com/dms/latest/userguide/Welcome.html

### Azure Database Migration Service

- Supports online and offline migration modes
- Online mode: continuous sync with minimal downtime cutover
- Source databases: SQL Server, MySQL, PostgreSQL, MongoDB, Oracle
- Target databases: Azure SQL Database, SQL Managed Instance, Azure Database for MySQL/PostgreSQL, Cosmos DB
- Integrated with Azure Migrate hub for tracking
- Documentation: https://learn.microsoft.com/en-us/azure/dms/dms-overview

### Google Cloud Database Migration Service

- Serverless, fully managed migration service
- Supports MySQL, PostgreSQL, SQL Server, Oracle, and AlloyDB migrations
- Continuous replication for minimal downtime
- Automatic promotion of target when ready for cutover
- Documentation: https://cloud.google.com/database-migration/docs/overview

---

## Continuous Replication and CDC

### How Change Data Capture Works

1. Initial full load copies all existing data to the target
2. CDC process reads changes from the source database transaction log
3. Changes are applied to the target database in near real-time
4. Source and target remain in sync until cutover

### CDC Requirements by Database

| Database | CDC Source | Requirements |
|----------|-----------|--------------|
| Oracle | LogMiner or Binary Reader | ARCHIVELOG mode enabled, supplemental logging |
| SQL Server | Transaction log | SQL Server Agent running, msdb access |
| MySQL | Binary log | binlog_format = ROW, binlog_row_image = FULL |
| PostgreSQL | Logical replication | wal_level = logical, max_replication_slots configured |
| MongoDB | Change streams | Replica set or sharded cluster |

### CDC Best Practices

- Monitor replication lag and set alerts for acceptable thresholds
- Size the replication instance appropriately for the data change rate
- Use table mappings to filter unnecessary tables or schemas
- Test CDC thoroughly before relying on it for cutover
- Plan for LOB (large object) handling - these are slower to replicate
- Consider partitioning large tables for parallel replication

---

## Downtime Minimization Strategies

### Strategy 1 - Online Migration with CDC (Recommended)

- Minimal downtime (minutes to hours depending on cutover process)
- Workflow:
  1. Set up continuous replication from source to target
  2. Wait for initial full load to complete
  3. Monitor replication lag until it reaches near-zero
  4. Stop writes to source database
  5. Wait for final CDC changes to apply
  6. Switch application connection strings to target
  7. Validate and resume operations
- Typical downtime: 5-30 minutes

### Strategy 2 - Blue-Green Database Cutover

- Run source and target databases simultaneously
- Application reads from source, writes are replicated to target
- At cutover:
  1. Stop application writes
  2. Verify replication is caught up (lag = 0)
  3. Redirect application to target database
  4. Verify reads and writes succeed on target
  5. Keep source available for rollback
- Provides instant rollback capability

### Strategy 3 - Dual Write (High Complexity)

- Application writes to both source and target simultaneously
- Requires application code changes
- Highest complexity but allows gradual traffic shifting
- Risk of data inconsistency if writes fail to one target
- Use only when other approaches are not feasible

### Strategy 4 - Read Replica Promotion

- For homogeneous migrations within the same engine
- Create a read replica in the target cloud
- Promote the replica to primary at cutover time
- Available for:
  - MySQL/Aurora read replicas cross-region
  - PostgreSQL logical replication
  - SQL Server Always On availability groups

### Downtime Budget Planning

| Approach | Expected Downtime | Complexity | Rollback Speed |
|----------|-------------------|------------|----------------|
| Online CDC cutover | 5-30 minutes | Medium | Minutes (redirect back) |
| Blue-green cutover | 2-10 minutes | Medium-High | Instant |
| Dual write | Near-zero | Very High | Instant |
| Offline export/import | Hours to days | Low | Hours (re-import) |

---

## Data Validation and Integrity Checks

### Pre-Migration Validation

- [ ] Document source database size (tables, rows, storage)
- [ ] Record row counts for all tables
- [ ] Calculate checksums for critical tables
- [ ] Document stored procedures, functions, triggers, and views count
- [ ] Verify target database engine version compatibility
- [ ] Test application against target engine in a dev environment

### During Migration Validation

- Monitor replication task status and error logs
- Track row counts: source vs target for each table
- Monitor replication lag (latency between source and target)
- Check for replication errors (data type mismatches, constraint violations)
- Validate LOB column migration (BLOBs, CLOBs, TEXT fields)

### Post-Migration Validation

#### Row Count Validation

```sql
-- Run on both source and target, compare results
SELECT table_name, 
       (xpath('/row/cnt/text()', xml_count))[1]::text::bigint AS row_count
FROM (
    SELECT table_name, 
           query_to_xml('SELECT count(*) AS cnt FROM ' || table_schema || '.' || table_name, false, true, '') AS xml_count
    FROM information_schema.tables
    WHERE table_schema = 'public'
) t;
```

#### Checksum Validation

- Use DMS data validation feature (AWS) for automated comparison
- Compare checksums of critical columns using MD5 or SHA-256
- Sample-based validation for very large tables
- Full validation for tables with financial or sensitive data

#### Application-Level Validation

- [ ] Run application test suite against target database
- [ ] Verify all CRUD operations work correctly
- [ ] Test stored procedures and functions
- [ ] Validate report outputs match between source and target
- [ ] Test edge cases: NULL values, special characters, large text fields
- [ ] Verify auto-increment sequences are correct
- [ ] Test application performance under load

### Data Validation Tools

- **AWS DMS Data Validation**: built-in row-by-row comparison
  - Documentation: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Validating.html
- **pt-table-checksum** (Percona Toolkit): checksum validation for MySQL
- **pg_comparator**: table comparison for PostgreSQL
- **dbForge Data Compare**: commercial tool for SQL Server and MySQL

---

## Common Migration Scenarios

### Oracle to PostgreSQL

1. Run AWS SCT or ora2pg to assess conversion complexity
2. Convert schema (tables, indexes, constraints, sequences)
3. Manually convert PL/SQL to PL/pgSQL (most labor-intensive step)
4. Set up DMS or logical replication for data migration
5. Test thoroughly - pay special attention to:
   - Date handling differences
   - NULL vs empty string behavior
   - Numeric precision differences
   - Sequence behavior (Oracle vs PostgreSQL)

### SQL Server to PostgreSQL

1. Use SSMA or AWS SCT for schema assessment
2. Convert T-SQL stored procedures to PL/pgSQL
3. Handle SQL Server-specific features:
   - IDENTITY columns to SERIAL/GENERATED
   - NVARCHAR to VARCHAR (UTF-8)
   - Computed columns to generated columns
4. Migrate data using DMS or pgloader
5. Convert application queries (TOP to LIMIT, ISNULL to COALESCE)

### MongoDB to DynamoDB

1. Map MongoDB collections to DynamoDB tables
2. Design partition keys and sort keys (critical for performance)
3. Handle schema differences (document model to key-value)
4. Use AWS DMS for data migration
5. Refactor queries (MongoDB queries to DynamoDB API/PartiQL)

### MySQL to Cloud-Managed MySQL

1. Verify version compatibility (source vs target)
2. Set up native MySQL replication or use DMS
3. Handle storage engine differences (if any)
4. Migrate users and permissions
5. Switch connection strings at cutover

---

## Migration Checklist

### Planning Phase

- [ ] Identify all databases in scope
- [ ] Choose migration strategy for each database (homogeneous vs heterogeneous)
- [ ] Assess schema conversion complexity
- [ ] Estimate data volumes and transfer time
- [ ] Define acceptable downtime window
- [ ] Plan rollback procedures
- [ ] Set up target database environments

### Execution Phase

- [ ] Convert and deploy schema to target
- [ ] Configure and start replication
- [ ] Validate initial full load
- [ ] Monitor CDC replication lag
- [ ] Run application testing against target
- [ ] Schedule and execute cutover
- [ ] Validate data integrity post-cutover

### Post-Migration Phase

- [ ] Monitor application performance
- [ ] Verify backup schedules are running
- [ ] Optimize query performance on new engine
- [ ] Update connection strings across all applications
- [ ] Decommission source database after validation period
- [ ] Document lessons learned

---

## Key Documentation Links

| Resource | URL |
|----------|-----|
| AWS DMS | https://docs.aws.amazon.com/dms/latest/userguide/Welcome.html |
| AWS SCT | https://docs.aws.amazon.com/SchemaConversionTool/latest/userguide/CHAP_Welcome.html |
| Azure DMS | https://learn.microsoft.com/en-us/azure/dms/dms-overview |
| Azure DMA | https://learn.microsoft.com/en-us/sql/dma/dma-overview |
| Google Cloud DMS | https://cloud.google.com/database-migration/docs/overview |
| ora2pg | https://ora2pg.darold.net/documentation.html |
| pgloader | https://pgloader.readthedocs.io/ |

---

## Database Migration Anti-Patterns to Avoid

- Starting data migration without completing schema conversion first
- Not testing stored procedure conversion until the end of the project
- Underestimating the effort for heterogeneous migration (especially Oracle to PostgreSQL)
- Skipping performance testing on the target database engine
- Not monitoring replication lag before cutover
- Cutting over without a validated rollback plan
- Ignoring application query changes needed for the new database engine
- Assuming homogeneous migration means zero effort (version differences matter)
