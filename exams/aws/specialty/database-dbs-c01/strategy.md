# AWS Database Specialty (DBS-C01) Study Strategy

## Study Approach

### Phase 1: Database Fundamentals (Weeks 1-2)
1. **Relational Databases** - RDS engines, Aurora architecture, storage, replication
2. **NoSQL Databases** - DynamoDB data modeling, GSI/LSI, capacity modes
3. **Purpose-Built** - DocumentDB, Neptune, Keyspaces, QLDB, Timestream
4. **Caching** - ElastiCache Redis vs Memcached, DAX
- **[📖 RDS User Guide](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html)**
- **[📖 Aurora User Guide](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/CHAP_AuroraOverview.html)**
- **[📖 DynamoDB Developer Guide](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html)**

### Phase 2: Operations and Migration (Weeks 3-4)
1. **DMS and SCT** - Migration types, CDC, heterogeneous conversions
2. **High Availability** - Multi-AZ, read replicas, Aurora Global Database
3. **Backups** - Automated backups, PITR, snapshots, Aurora Backtrack
4. **Management** - Parameter groups, maintenance, Performance Insights
- **[📖 DMS User Guide](https://docs.aws.amazon.com/dms/latest/userguide/Welcome.html)**
- **[📖 SCT User Guide](https://docs.aws.amazon.com/SchemaConversionTool/latest/userguide/CHAP_Welcome.html)**

### Phase 3: Security and Monitoring (Week 5)
1. **Encryption** - KMS, TDE, in-transit SSL, encrypting existing databases
2. **Authentication** - IAM DB auth, Secrets Manager rotation, RDS Proxy
3. **Network** - VPC, security groups, private subnets, VPC endpoints
4. **Monitoring** - CloudWatch metrics, Enhanced Monitoring, Performance Insights
5. **Audit** - Database Activity Streams, CloudTrail, pgAudit
- **[📖 RDS Security](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.html)**
- **[📖 Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html)**

### Phase 4: Exam Prep (Week 6)
1. Practice scenario-based questions
2. Review database selection decision tree
3. Focus on migration workflows and troubleshooting
4. Take practice exams and review weak areas

## Recommended Resources

### Primary Resources
- **[AWS Skill Builder](https://skillbuilder.aws/)** - Official exam prep course
- **[DBS-C01 Exam Guide](https://d1.awsstatic.com/training-and-certification/docs-database-specialty/AWS-Certified-Database-Specialty_Exam-Guide.pdf)** - Official exam guide
- **[AWS Database Blog](https://aws.amazon.com/blogs/database/)** - Architecture patterns and best practices
- **[AWS Well-Architected Database Pillar](https://docs.aws.amazon.com/wellarchitected/latest/database-pillar/welcome.html)** - Design principles

### Hands-On Practice
- Deploy RDS Multi-AZ and test failover
- Set up Aurora Global Database with cross-region replication
- Build a DynamoDB table with GSI and test hot partition behavior
- Run a DMS migration from RDS MySQL to Aurora MySQL
- Configure RDS Proxy with Lambda
- Enable and analyze Performance Insights on a loaded database
- Set up Secrets Manager rotation for RDS credentials

## Exam Tactics

### Keywords to Watch For
- "Active-active multi-region" - DynamoDB Global Tables
- "Cross-region DR with < 1 sec RPO" - Aurora Global Database
- "MongoDB compatible" - DocumentDB
- "Cassandra compatible" - Keyspaces
- "Immutable ledger" or "audit trail" - QLDB
- "Time-series" or "IoT metrics" - Timestream
- "Connection pooling for Lambda" - RDS Proxy
- "Encrypt existing database" - Snapshot, copy encrypted, restore
- "Rotate credentials" - Secrets Manager
- "Tamper-proof audit" - Database Activity Streams
- "Zero-downtime upgrade" - Blue-green deployment
- "Different database engine migration" - SCT + DMS

### Common Pitfalls
- DynamoDB GSIs are always eventually consistent (no strong consistency option)
- LSIs can only be created at table creation time
- RDS encryption must be set at creation - cannot be added later
- IAM database authentication is only for MySQL and PostgreSQL
- PITR and snapshot restore always create a new DB instance (new endpoint)
- Aurora Multi-Master was discontinued - do not select it as an answer
- RDS Proxy only supports MySQL and PostgreSQL engines
- Memcached has no persistence, replication, or failover

### Time Management
- 180 minutes for 65 questions - approximately 2.5 minutes per question
- Database selection questions are usually straightforward - answer quickly
- Migration scenario questions require more analysis - allocate extra time
- Eliminate wrong answers by checking engine support and feature limitations

### Readiness Indicators
- [ ] You can select the correct database for any workload description
- [ ] You understand Aurora vs RDS architecture differences
- [ ] You know DynamoDB data modeling best practices
- [ ] You can plan a heterogeneous migration with SCT and DMS
- [ ] You understand all HA options (Multi-AZ, replicas, Global Database)
- [ ] You know encryption workflows including encrypting existing databases
- [ ] You can troubleshoot performance using Performance Insights
- [ ] You understand Secrets Manager rotation strategies
- [ ] You score 75%+ consistently on practice exams
