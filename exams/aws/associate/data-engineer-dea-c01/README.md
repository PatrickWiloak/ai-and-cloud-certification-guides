# AWS Certified Data Engineer - Associate (DEA-C01)

## Exam Overview

The AWS Certified Data Engineer - Associate (DEA-C01) exam validates technical expertise in designing, building, securing, and maintaining data pipelines on the AWS platform. This certification demonstrates proficiency in data ingestion, transformation, storage, governance, and analytics using AWS data services.

**Exam Details:**
- **Exam Code:** DEA-C01
- **Duration:** 170 minutes
- **Number of Questions:** 65 scored questions
- **Question Types:** Multiple choice and multiple response
- **Passing Score:** 720 out of 1000
- **Cost:** $150 USD
- **Language:** Available in multiple languages
- **Delivery:** Pearson VUE testing center or online proctoring
- **Validity:** 3 years
- **Prerequisites:** None (2+ years hands-on data engineering experience recommended)

## Exam Domains

### Domain 1: Data Ingestion and Transformation (34%)
- Ingest data from batch and streaming sources
- Transform and enrich data for analytics
- Orchestrate data pipelines and workflows
- Implement data quality and validation

**Key Services:**
- Amazon Kinesis (Data Streams, Data Firehose, Data Analytics)
- AWS Glue (ETL jobs, crawlers, Data Catalog)
- Amazon MSK (Managed Kafka)
- AWS DMS (Database Migration Service)
- AWS Step Functions (workflow orchestration)
- AWS Lambda (serverless transformation)
- Amazon EMR (Spark, Hive, Presto)
- AWS DataSync (data transfer)

### Domain 2: Data Store Management (26%)
- Choose appropriate data stores for analytics workloads
- Manage data catalogs and metadata
- Implement data lifecycle and retention policies
- Optimize data storage for cost and performance

**Key Services:**
- Amazon S3 (data lake storage)
- Amazon Redshift (data warehouse)
- Amazon Athena (serverless SQL on S3)
- Amazon DynamoDB (NoSQL database)
- Amazon RDS/Aurora (relational databases)
- Amazon OpenSearch Service (search and analytics)
- AWS Lake Formation (data lake management)
- AWS Glue Data Catalog (metadata repository)

### Domain 3: Data Operations and Support (22%)
- Automate and orchestrate data pipelines
- Monitor and troubleshoot data infrastructure
- Implement data quality frameworks
- Manage pipeline dependencies and scheduling

**Key Services:**
- Amazon MWAA (Managed Workflows for Apache Airflow)
- AWS Step Functions (state machine orchestration)
- Amazon CloudWatch (monitoring and alerting)
- Amazon EventBridge (event-driven automation)
- Amazon QuickSight (BI and visualization)
- AWS Glue DataBrew (visual data preparation)
- AWS CloudTrail (API auditing)

### Domain 4: Data Security and Governance (18%)
- Implement authentication and authorization for data services
- Configure data encryption at rest and in transit
- Manage data governance and compliance
- Implement fine-grained access control

**Key Services:**
- AWS IAM (identity and access management)
- AWS Lake Formation (fine-grained permissions, LF-Tags)
- AWS KMS (key management and encryption)
- Amazon Macie (sensitive data discovery)
- AWS CloudTrail (audit logging)
- AWS Secrets Manager (credential management)

## Core AWS Services for Data Engineers

### Data Ingestion

#### Amazon Kinesis
- **Kinesis Data Streams:** Real-time data streaming with custom consumers
- **Kinesis Data Firehose:** Fully managed delivery to S3, Redshift, OpenSearch
- **Kinesis Data Analytics:** SQL and Apache Flink for stream analytics
- Shard management, enhanced fan-out, consumer scaling

#### AWS Glue
- **ETL Jobs:** PySpark and Scala-based serverless ETL
- **Data Catalog:** Central metadata repository with crawlers
- **Job Bookmarks:** Incremental data processing
- **DataBrew:** Visual no-code data transformation
- **Schema Registry:** Schema management for streaming

#### Amazon MSK
- **Managed Apache Kafka:** Fully managed Kafka clusters
- **MSK Connect:** Managed Kafka Connect connectors
- **MSK Serverless:** Auto-scaling serverless Kafka

### Data Storage

#### Amazon S3
- **Data lake foundation:** Scalable, durable object storage
- **Storage classes:** Standard, IA, Glacier, Deep Archive
- **Lifecycle policies:** Automated data tiering
- **S3 Select:** Query data in place

#### Amazon Redshift
- **Cloud data warehouse:** Columnar storage for analytics
- **Redshift Spectrum:** Query S3 data from Redshift
- **Data sharing:** Cross-cluster and cross-account sharing
- **Materialized views:** Precomputed query results

#### Amazon Athena
- **Serverless SQL:** Query S3 data without infrastructure
- **Partition projection:** Automatic partition management
- **Federated queries:** Query across data sources
- **Pay per query:** Charges based on data scanned

### Data Operations

#### Amazon MWAA
- **Managed Apache Airflow:** DAG-based pipeline orchestration
- **Python DAGs:** Programmatic workflow definitions
- **Scheduling:** Cron-based and event-driven triggers

#### AWS Step Functions
- **Visual workflows:** Drag-and-drop pipeline design
- **Error handling:** Built-in retry and catch logic
- **Native integrations:** 200+ AWS service integrations

### Data Security

#### AWS Lake Formation
- **Centralized permissions:** Table, column, and row-level security
- **LF-Tags:** Tag-based access control policies
- **Data filters:** Fine-grained row and column filtering
- **Cross-account sharing:** Governed data sharing

## Study Strategy

### Recommended Timeline: 6-8 Weeks

**Week 1-2: Data Ingestion and Streaming**
- Kinesis Data Streams and Firehose
- AWS Glue ETL and Data Catalog
- Amazon MSK basics
- AWS DMS and CDC patterns

**Week 3-4: Data Storage and Analytics**
- Amazon S3 data lake patterns
- Amazon Redshift and Spectrum
- Amazon Athena optimization
- Data formats (Parquet, ORC, Avro)

**Week 5-6: Data Operations and Pipelines**
- MWAA (Airflow) and Step Functions
- CloudWatch monitoring
- Data quality and validation
- Pipeline orchestration patterns

**Week 7-8: Security, Governance, and Review**
- Lake Formation permissions
- KMS encryption patterns
- IAM for data services
- Practice exams and weak areas

### Hands-on Practice Requirements

**CRITICAL:** This exam requires extensive hands-on experience with data engineering on AWS. You must build actual data pipelines, not just read about them.

**Essential Labs:**
1. Build streaming pipeline (Kinesis -> Lambda -> S3)
2. Create Glue ETL jobs with Data Catalog
3. Set up data lake with Lake Formation permissions
4. Load and query data in Redshift
5. Run Athena queries with partitioning
6. Orchestrate pipeline with Step Functions
7. Configure MWAA environment with DAGs
8. Implement encryption with KMS

## 📚 Comprehensive Study Resources

**👉 [Complete AWS Study Resources Guide](../../../../.templates/resources-aws.md)**

For detailed information on courses, practice tests, hands-on labs, communities, and more, see our comprehensive AWS study resources guide.

### Quick Links (DEA-C01 Specific)
- **[DEA-C01 Official Exam Page](https://aws.amazon.com/certification/certified-data-engineer-associate/)** - Registration and official exam guide
- **[AWS Skill Builder](https://skillbuilder.aws/)** - FREE official exam prep and labs
- **[AWS Documentation](https://docs.aws.amazon.com/)** - Complete service documentation
- **[AWS Free Tier](https://aws.amazon.com/free/)** - 12 months free + always-free services
- **[AWS Samples GitHub](https://github.com/aws-samples)** - Sample code and projects

### Recommended Courses
1. **AWS Skill Builder - DEA-C01 Exam Prep** (FREE)
2. **Stephane Maarek's AWS Certified Data Engineer Associate** (Udemy)
3. **A Cloud Guru AWS Data Engineer Associate**
4. **Tutorials Dojo DEA-C01 Study Path**

### Practice Exams
1. **Tutorials Dojo** - Highly recommended, detailed explanations
2. **Whizlabs** - Good question bank
3. **AWS Skill Builder Official Practice Exam** - $40, closest to real exam

## Next Steps After Certification

### Career Paths
- Data Engineer
- Data Platform Engineer
- Analytics Engineer
- Data Architect
- Machine Learning Engineer

### Advanced Certifications
- **AWS Certified Solutions Architect - Professional** - Architecture focus
- **AWS Certified Machine Learning - Specialty** - ML pipelines and models
- **AWS Certified Data Analytics - Specialty** - Advanced analytics (retired, replaced by DEA-C01)
- **AWS Certified Database - Specialty** - Database design and management

### Continuous Learning
- Stay updated with AWS re:Invent announcements
- Explore new data services (AWS Clean Rooms, Amazon DataZone)
- Build end-to-end data platforms
- Contribute to open-source data tools
- Attend AWS data and analytics meetups

---

**Good luck with your AWS Certified Data Engineer - Associate certification!**

Remember: This is a hands-on data engineering exam. Building real data pipelines and data lake architectures with AWS services is essential for success!
