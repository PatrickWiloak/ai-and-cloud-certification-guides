---
last-updated: 2026-05-03
---

# GCP Professional Cloud Database Engineer (PCDE) - Exam Scenarios

> Six worked scenarios mirroring PCDE question style. PCDE tests database design, migration, operations, and selection across GCP database products.

---

## Scenario 1 - Database selection for transactional global app

A retailer needs strongly consistent transactions across regions, horizontal scale, and SQL.

**Options:** A. Cloud Spanner. B. Cloud SQL with read replicas. C. Firestore. D. Bigtable.

**Analysis:** A is right - Spanner = global ACID + horizontal scale + SQL. Single-purpose answer for that requirement.

**Answer:** A

**Key takeaway:** Spanner = global SQL ACID. Cloud SQL = regional SQL. Firestore = document. Bigtable = wide-column NoSQL.

---

## Scenario 2 - Migration with minimal downtime

A 5 TB on-prem MySQL must move to Cloud SQL with <30 min cutover.

**Options:** A. Database Migration Service (DMS) full load + CDC; cut over after CDC catches up. B. mysqldump + restore. C. Snowball-equivalent for GCP. D. Re-architect on Spanner.

**Analysis:** A is right - DMS supports homogeneous (MySQL→Cloud SQL MySQL) migrations with full-load + CDC + cutover. B causes long downtime. C - Transfer Appliance is for offline bulk transfer, not DB. D is re-architecture.

**Answer:** A

**Key takeaway:** GCP DB migration = Database Migration Service. Supports MySQL, PostgreSQL, SQL Server, Oracle (target Spanner / AlloyDB / Cloud SQL).

---

## Scenario 3 - High availability for Cloud SQL

Production needs HA with automatic failover and minimal RTO.

**Options:** A. Cloud SQL HA enabled (regional, with sync standby); cross-region read replica for DR. B. Cloud SQL single zone. C. Manual snapshot/restore. D. Self-managed MySQL on GCE.

**Analysis:** A is right - Cloud SQL HA = synchronous standby in another zone, automatic failover, ~minutes RTO. Cross-region read replica is the second layer for region failure. B / C don't HA. D abandons managed service.

**Answer:** A

**Key takeaway:** Cloud SQL HA = regional, automatic failover. Cross-region read replicas for DR (manual promotion).

---

## Scenario 4 - PostgreSQL with high read scale

A team needs PostgreSQL with very high read throughput for analytics queries; some writes; minimal ops.

**Options:** A. AlloyDB for PostgreSQL with read pool nodes. B. Cloud SQL for PostgreSQL with read replicas. C. Self-hosted PostgreSQL on GCE. D. BigQuery.

**Analysis:** A is right - AlloyDB is GCP's PostgreSQL-compatible, vertically-and-horizontally scalable DB with separate columnar engine for analytics queries. Outperforms Cloud SQL for read-heavy + analytics workloads. B is fine but slower for analytics. C ops-heavy. D is OLAP, not transactional PostgreSQL.

**Answer:** A

**Key takeaway:** AlloyDB > Cloud SQL when you need PostgreSQL + analytics performance + read scale. AlloyDB Omni for on-prem.

---

## Scenario 5 - Time-series at scale

An IoT system writes 100K events/sec from sensors; queries are by sensor ID and time range; long retention.

**Options:** A. Bigtable with row key = sensor_id#reverse_timestamp. B. Cloud SQL. C. Firestore. D. Spanner.

**Analysis:** A is right - Bigtable's row-key design with reverse timestamp is the textbook IoT pattern; high write throughput; range scans for time queries. B doesn't scale to 100K writes/sec. C is per-document, slow at scale for time series. D is overkill and more expensive.

**Answer:** A

**Key takeaway:** Bigtable for time-series IoT, sensor data, large-scale wide-column. Row key design (entity#reverse_ts) is the high-leverage pattern.

---

## Scenario 6 - Backup and PITR

A team needs point-in-time recovery (any second in last 7 days) for Cloud SQL.

**Options:** A. Cloud SQL Backups + binary log replication enabled (PITR feature). B. Daily snapshots only. C. Manual exports to GCS. D. Cloud Storage backup.

**Analysis:** A is right - Cloud SQL native PITR uses backups + transaction log replay to restore to any second within the configured window (1-7 days). B / C / D are coarser-grained.

**Answer:** A

**Key takeaway:** Cloud SQL PITR = automated backups + binary log retention. Configure PITR window 1-7 days. Spanner has its own PITR (up to 7 days).
