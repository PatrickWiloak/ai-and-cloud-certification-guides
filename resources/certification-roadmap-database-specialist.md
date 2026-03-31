# Certification Roadmap - Database Specialist

## Overview

This roadmap guides you through database-focused certifications across AWS, Azure, and Google Cloud. Database specialists design, implement, and optimize database solutions for performance, availability, and cost-efficiency.

---

## Recommended Certification Path

### Phase 1 - Foundation (Months 1-3)

| Certification | Provider | Level | Exam Code |
|--------------|----------|-------|-----------|
| AWS Cloud Practitioner | AWS | Foundational | CLF-C02 |
| Azure Fundamentals | Microsoft | Foundational | AZ-900 |
| Cloud Digital Leader | Google | Foundational | CDL |

**Focus Areas:**
- Relational vs NoSQL database concepts
- Database deployment models (managed vs self-managed)
- Cloud service models (IaaS, PaaS, SaaS) and how they apply to databases
- Basic SQL and data modeling concepts

### Phase 2 - Associate Level (Months 3-8)

| Certification | Provider | Level | Exam Code |
|--------------|----------|-------|-----------|
| AWS Solutions Architect Associate | AWS | Associate | SAA-C03 |
| Azure Database Administrator Associate | Microsoft | Associate | DP-300 |
| Google Cloud Database Engineer | Google | Professional | PDE (pending availability) |

**Focus Areas:**
- Managed database services (RDS, Aurora, Azure SQL, Cloud SQL, Spanner)
- Database migration strategies
- Backup, restore, and point-in-time recovery
- High availability and disaster recovery configurations
- Performance tuning and indexing basics

### Phase 3 - Specialty (Months 8-14)

| Certification | Provider | Level | Exam Code |
|--------------|----------|-------|-----------|
| AWS Database Specialty | AWS | Specialty | DBS-C01 |
| Azure Cosmos DB Developer Specialty | Microsoft | Specialty | DP-420 |
| Google Cloud Professional Data Engineer | Google | Professional | PDE |

**Focus Areas:**
- Advanced query optimization and execution plans
- Database sharding, partitioning, and replication
- Multi-region and global database deployments
- NoSQL data modeling (DynamoDB, Cosmos DB, Firestore, Bigtable)
- Database security (encryption, auditing, access control)

### Phase 4 - Expert and Cross-Platform (Months 14-20)

| Certification | Provider | Level | Exam Code |
|--------------|----------|-------|-----------|
| AWS Solutions Architect Professional | AWS | Professional | SAP-C02 |
| Azure Solutions Architect Expert | Microsoft | Expert | AZ-305 |
| Google Cloud Professional Cloud Architect | Google | Professional | PCA |

---

## Core Knowledge Areas

### Relational Databases

| Topic | AWS | Azure | GCP |
|-------|-----|-------|-----|
| Managed RDBMS | RDS (MySQL, PostgreSQL, MariaDB, Oracle, SQL Server) | Azure SQL Database, Azure Database for MySQL/PostgreSQL | Cloud SQL (MySQL, PostgreSQL, SQL Server) |
| Serverless RDBMS | Aurora Serverless v2 | Azure SQL Serverless | Cloud SQL (no serverless variant) |
| Enterprise-Grade | Aurora | Azure SQL Managed Instance | AlloyDB |
| Global Distribution | Aurora Global Database | Azure SQL Hyperscale (geo-replication) | Spanner |
| Data Warehouse | Redshift | Azure Synapse Analytics | BigQuery |

### NoSQL Databases

| Topic | AWS | Azure | GCP |
|-------|-----|-------|-----|
| Key-Value / Document | DynamoDB | Cosmos DB | Firestore |
| Wide-Column | Keyspaces (Cassandra) | Cosmos DB (Cassandra API) | Bigtable |
| Graph | Neptune | Cosmos DB (Gremlin API) | N/A (use JanusGraph on GKE) |
| In-Memory | ElastiCache (Redis, Memcached), MemoryDB | Azure Cache for Redis | Memorystore (Redis, Memcached) |
| Time Series | Timestream | Azure Data Explorer | Bigtable / BigQuery |
| Ledger | QLDB | Azure SQL Ledger | N/A |

### Database Migration

| Topic | AWS | Azure | GCP |
|-------|-----|-------|-----|
| Migration Service | DMS (Database Migration Service) | Azure Database Migration Service | Database Migration Service |
| Schema Conversion | SCT (Schema Conversion Tool) | Data Migration Assistant | Database Migration Service |
| Continuous Replication | DMS CDC | DMS (online migration) | Datastream |
| Heterogeneous Migration | DMS + SCT | Azure Migrate + DMA | DMS + conversion tools |

---

## Study Resources

### AWS Database Specialty (DBS-C01)

| Resource | Type | Link |
|----------|------|------|
| AWS Database Services Overview | Documentation | https://aws.amazon.com/products/databases/ |
| DynamoDB Developer Guide | Documentation | https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/ |
| Aurora User Guide | Documentation | https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/ |
| AWS Database Blog | Blog | https://aws.amazon.com/blogs/database/ |
| AWS Skill Builder | Training | https://skillbuilder.aws/ |

### Azure Database Administrator (DP-300)

| Resource | Type | Link |
|----------|------|------|
| Azure SQL Documentation | Documentation | https://learn.microsoft.com/en-us/azure/azure-sql/ |
| DP-300 Learning Path | Training | https://learn.microsoft.com/en-us/credentials/certifications/azure-database-administrator-associate/ |
| Azure Cosmos DB Documentation | Documentation | https://learn.microsoft.com/en-us/azure/cosmos-db/ |

### Google Cloud Data Engineer

| Resource | Type | Link |
|----------|------|------|
| Cloud SQL Documentation | Documentation | https://cloud.google.com/sql/docs |
| Spanner Documentation | Documentation | https://cloud.google.com/spanner/docs |
| BigQuery Documentation | Documentation | https://cloud.google.com/bigquery/docs |
| Google Cloud Skills Boost | Training | https://www.cloudskillsboost.google/ |

---

## Hands-On Practice

### Essential Lab Exercises

| Lab | Skills Tested |
|-----|---------------|
| Deploy Aurora Global Database with failover | Multi-region, DR |
| DynamoDB single-table design pattern | NoSQL modeling |
| Azure SQL Managed Instance migration | Database migration |
| Cosmos DB multi-region writes | Global distribution |
| Cloud Spanner schema design | Globally consistent RDBMS |
| BigQuery partitioned and clustered tables | Data warehouse optimization |
| RDS Performance Insights analysis | Query optimization |
| ElastiCache cluster setup with replication | In-memory caching |
| Database encryption (TDE, column-level, KMS) | Security |
| Cross-region read replicas with failover testing | High availability |

---

## Study Schedule (20 Weeks)

| Weeks | Focus | Certification Target |
|-------|-------|---------------------|
| 1-4 | SQL fundamentals, relational modeling, cloud database services | Foundation review |
| 5-8 | Managed RDBMS (RDS, Aurora, Azure SQL, Cloud SQL) | DP-300 prep |
| 9-12 | NoSQL (DynamoDB, Cosmos DB, Firestore, Bigtable) | DBS-C01 prep |
| 13-16 | Migration, replication, DR patterns | DBS-C01 / PDE prep |
| 17-20 | Performance tuning, security, cost optimization, practice exams | Exam readiness |

---

## Key Exam Tips

1. Know the decision criteria for choosing between database types (relational vs NoSQL vs in-memory)
2. Understand consistency models - strong vs eventual, and how each service handles them
3. Master backup and recovery options - RPO and RTO for each database service
4. Practice capacity planning and cost estimation for database workloads
5. Be familiar with encryption options (at-rest, in-transit, client-side)
6. Understand multi-region replication trade-offs for each database service
7. Study migration patterns - homogeneous vs heterogeneous, online vs offline
