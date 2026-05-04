---
last-updated: 2026-05-03
---

# GCP Professional Cloud Database Engineer (PCDE) - Exam Strategy

## Format reminder

- 50-60 questions, 120 minutes
- Pass mark ~70-75%

## Top traps

1. **Database product matrix** (memorize):
   - Cloud SQL: regional, MySQL/PostgreSQL/SQL Server, fully managed
   - AlloyDB: PostgreSQL-compatible, performance-tuned, vertical+horizontal scale
   - Spanner: global ACID, horizontal scale, SQL
   - Bigtable: wide-column NoSQL, petabyte scale, single-key access
   - Firestore: document, mobile/web sync
   - Memorystore: managed Redis / Memcached
   - Memorystore for Valkey: open-source Redis fork

2. **Migration via Database Migration Service**: supports MySQL→Cloud SQL, PostgreSQL→Cloud SQL/AlloyDB, SQL Server→Cloud SQL, Oracle→Cloud SQL/AlloyDB/Spanner. Heterogeneous migrations require schema work.

3. **HA modes**:
   - Cloud SQL: regional HA (sync standby in another zone)
   - AlloyDB: regional with read pools
   - Spanner: regional or multi-region; multi-region is global ACID
   - Bigtable: replication for HA + DR

4. **Cloud SQL Editions**: Enterprise (default) vs Enterprise Plus (newer, better performance, longer maintenance windows, near-zero downtime maintenance).

5. **Spanner config**: regional (single region) vs multi-region (us, eu, asia, nam-eur-asia1). Cost and consistency vary.

6. **Bigtable replication**: app profiles, multi-cluster routing, single-cluster routing. Failover behavior depends.

7. **Cloud SQL connection options**: public IP + Cloud SQL Auth Proxy, private IP via VPC, Private Service Connect endpoint. PSC is the modern recommendation.

8. **Encryption**: default Google-managed; CMEK via Cloud KMS; CSEK for Cloud SQL is limited.

9. **PITR and backups**: Cloud SQL PITR (1-7 days), Spanner PITR (up to 7 days), AlloyDB continuous backup. Each product has different mechanics.

10. **Consistency levels in Spanner**: strong reads (default) vs stale reads (timestamp bounded, lower latency, eventual). Can request via API.

## High-yield topics easy to miss

- AlloyDB Omni (run AlloyDB on-prem)
- Database Insights (per-database performance dashboards in Cloud SQL)
- Spanner change streams (CDC)
- Cloud SQL Studio (in-console SQL editor)
- Bigtable continuous backup
- Datastream (CDC service for replication into BigQuery / Cloud Storage / Cloud SQL)

## Time management

120 / ~55 = ~2.2 min/question.

## When stuck

1. **Match access pattern to product** - SQL transactional → Cloud SQL/AlloyDB/Spanner; wide-column → Bigtable; document → Firestore.
2. **Match scale to product** - regional small → Cloud SQL; regional large → AlloyDB; global → Spanner; PB → Bigtable.
3. **Default to managed** over self-hosted on GCE.
4. **Eliminate "use [random other product]"** when the access pattern doesn't fit.

## Day-of logistics

120 min, ~55 questions.

## After

**Pass:** Cert valid 2 years.

**Fail:** Most failures are on Database Selection (~25%) - re-review the product matrix above.

## PCDE patterns

- "Global ACID + SQL" = Spanner
- "PostgreSQL + analytics + scale" = AlloyDB
- "MySQL/PostgreSQL/SQL Server managed regional" = Cloud SQL
- "Wide-column at PB scale" = Bigtable
- "Document + mobile sync" = Firestore
- "Managed Redis" = Memorystore
- "MySQL→Cloud SQL migration" = Database Migration Service
- "PITR within 7 days" = Cloud SQL PITR or Spanner PITR
- "HA failover automatic" = Cloud SQL HA / AlloyDB regional / Spanner multi-region
- "CDC stream" = Datastream or Spanner change streams
