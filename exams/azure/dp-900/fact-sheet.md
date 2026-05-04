---
last-updated: 2026-05-03
---

# Azure DP-900: Data Fundamentals - Comprehensive Fact Sheet

## Exam Overview

**[📖 DP-900 Exam Page](https://learn.microsoft.com/en-us/certifications/exams/dp-900/)** - Official Microsoft certification exam page with registration details

**[📖 DP-900 Study Guide](https://learn.microsoft.com/en-us/certifications/resources/study-guides/dp-900)** - Complete study guide outlining all exam objectives and skills measured

**[📖 Azure Data Fundamentals Learning Path](https://learn.microsoft.com/en-us/training/paths/azure-data-fundamentals-explore-core-data-concepts/)** - Free Microsoft Learn training path for exam preparation

The DP-900 exam validates foundational knowledge of core data concepts and Azure data services. It covers data workloads, relational and non-relational data, and analytics.

**Exam Details:**
- Questions: 40-60
- Duration: 60 minutes
- Passing Score: 700/1000
- Cost: $99 USD
- Delivery: Pearson VUE (online or test center)
- Languages: English, Japanese, Chinese (Simplified), Korean, German, French, Spanish, Portuguese (Brazil), Russian, Arabic (Saudi Arabia), Chinese (Traditional), Italian, Indonesian

---

## Domain 1: Core Data Concepts (25-30%)

### Data Types and Structures

**[📖 Structured vs Unstructured Data](https://learn.microsoft.com/en-us/azure/architecture/data-guide/big-data/)** - Understanding different data types and their characteristics in Azure

**[📖 Data Classification Overview](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/govern/policy-compliance/data-classification)** - Framework for classifying data in cloud environments

**[📖 Relational Data Concepts](https://learn.microsoft.com/en-us/training/modules/explore-relational-data-offerings/)** - Core concepts of relational databases and normalization

**[📖 Non-Relational Data Concepts](https://learn.microsoft.com/en-us/training/modules/explore-non-relational-data-offerings-azure/)** - Key-value, document, column-family, and graph databases

**Key Concepts:**
- **Structured Data**: Organized in tables with defined schema (SQL databases)
- **Semi-Structured Data**: Has some organizational properties (JSON, XML, CSV)
- **Unstructured Data**: No predefined structure (images, videos, binary files)

### Data Workload Types

**[📖 Transactional Workloads (OLTP)](https://learn.microsoft.com/en-us/azure/architecture/data-guide/relational-data/online-transaction-processing)** - Online Transaction Processing characteristics and use cases

**[📖 Analytical Workloads (OLAP)](https://learn.microsoft.com/en-us/azure/architecture/data-guide/relational-data/online-analytical-processing)** - Online Analytical Processing for business intelligence

**[📖 Batch vs Stream Processing](https://learn.microsoft.com/en-us/azure/architecture/data-guide/big-data/batch-processing)** - Understanding different data processing patterns

**[📖 ETL and ELT Processes](https://learn.microsoft.com/en-us/azure/architecture/data-guide/relational-data/etl)** - Extract, Transform, Load data integration patterns

**Workload Characteristics:**
- **OLTP**: High volume, low latency, CRUD operations, normalized schemas
- **OLAP**: Complex queries, aggregations, read-heavy, denormalized schemas
- **Batch Processing**: Large volumes processed at scheduled intervals
- **Stream Processing**: Real-time data processing as it arrives

### Data Roles and Responsibilities

**[📖 Database Administrator Role](https://learn.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/data-storage)** - Managing database availability, performance, and security

**[📖 Data Engineer Role](https://learn.microsoft.com/en-us/training/modules/understand-data-engineering-azure/)** - Building and maintaining data pipelines and infrastructure

**[📖 Data Analyst Role](https://learn.microsoft.com/en-us/training/modules/data-analytics-microsoft/)** - Analyzing data and creating visualizations for business insights

**Key Responsibilities:**
- **Database Administrator**: Backup/recovery, security, performance tuning, user access
- **Data Engineer**: ETL pipelines, data integration, data quality, infrastructure
- **Data Analyst**: Business intelligence, reporting, dashboards, data visualization

---

## Domain 2: Relational Data on Azure (25-30%)

### Azure SQL Database

**[📖 Azure SQL Database Overview](https://learn.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview)** - Fully managed PaaS database engine with built-in intelligence

**[📖 SQL Database Deployment Options](https://learn.microsoft.com/en-us/azure/azure-sql/database/database-deployment-options)** - Single database, elastic pools, and managed instances

**[📖 SQL Database DTU-Based Model](https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tiers-dtu)** - Database Transaction Units purchasing model

**[📖 SQL Database vCore-Based Model](https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tiers-vcore)** - Virtual core-based purchasing with granular resource control

**[📖 SQL Database Service Tiers](https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tiers-general-purpose-business-critical)** - General Purpose, Business Critical, and Hyperscale tiers

**[📖 SQL Database Backup and Restore](https://learn.microsoft.com/en-us/azure/azure-sql/database/automated-backups-overview)** - Automated backups with point-in-time restore capabilities

**Key Features:**
- Fully managed PaaS with 99.99% SLA
- Automatic patching, backups, and high availability
- Built-in intelligence and threat detection
- Scaling options: vertical (compute/storage) and horizontal (sharding)
- Geo-replication and failover groups

### Azure SQL Managed Instance

**[📖 SQL Managed Instance Overview](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview)** - Near 100% SQL Server compatibility with PaaS benefits

**[📖 SQL Managed Instance Use Cases](https://learn.microsoft.com/en-us/azure/azure-sql/migration-guides/managed-instance/sql-server-to-managed-instance-overview)** - Migration scenarios from on-premises SQL Server

**Key Features:**
- Native VNET integration
- SQL Server Agent support
- Cross-database queries
- Linked servers and CLR support
- Ideal for lift-and-shift migrations

### Azure SQL on Virtual Machines

**[📖 SQL Server on Azure VMs](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview)** - IaaS option with full SQL Server control

**[📖 SQL VM Best Practices](https://learn.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/performance-guidelines-best-practices-checklist)** - Performance optimization guidelines for SQL VMs

**Use Cases:**
- Need OS-level access
- Custom SQL Server configurations
- Legacy application compatibility
- Third-party software requiring server access

### Azure Database for Open Source

**[📖 Azure Database for MySQL](https://learn.microsoft.com/en-us/azure/mysql/single-server/overview)** - Fully managed MySQL database service

**[📖 Azure Database for PostgreSQL](https://learn.microsoft.com/en-us/azure/postgresql/single-server/overview)** - Managed PostgreSQL with high availability

**[📖 Azure Database for MariaDB](https://learn.microsoft.com/en-us/azure/mariadb/overview)** - Managed MariaDB service for cloud-native apps

**[📖 PostgreSQL Flexible Server](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/overview)** - Enhanced control over database management and configuration

### Relational Data Concepts

**[📖 Database Normalization](https://learn.microsoft.com/en-us/office/troubleshoot/access/database-normalization-description)** - Organizing data to reduce redundancy and improve integrity

**[📖 SQL Query Fundamentals](https://learn.microsoft.com/en-us/training/modules/explore-relational-data-azure/)** - SELECT, INSERT, UPDATE, DELETE operations

**[📖 Indexes and Performance](https://learn.microsoft.com/en-us/sql/relational-databases/indexes/indexes)** - Optimizing query performance with proper indexing

**SQL Fundamentals:**
- **DDL**: CREATE, ALTER, DROP (Data Definition Language)
- **DML**: SELECT, INSERT, UPDATE, DELETE (Data Manipulation Language)
- **DCL**: GRANT, REVOKE (Data Control Language)
- **Primary Keys**: Unique identifier for each row
- **Foreign Keys**: Establish relationships between tables
- **Normalization Forms**: 1NF, 2NF, 3NF to reduce redundancy

---

## Domain 3: Non-Relational Data on Azure (25-30%)

### Azure Cosmos DB

**[📖 Azure Cosmos DB Overview](https://learn.microsoft.com/en-us/azure/cosmos-db/introduction)** - Globally distributed, multi-model NoSQL database service

**[📖 Cosmos DB APIs](https://learn.microsoft.com/en-us/azure/cosmos-db/choose-api)** - NoSQL, MongoDB, Cassandra, Gremlin, and Table APIs

**[📖 Cosmos DB Consistency Levels](https://learn.microsoft.com/en-us/azure/cosmos-db/consistency-levels)** - Strong, bounded staleness, session, consistent prefix, and eventual consistency

**[📖 Cosmos DB Partitioning](https://learn.microsoft.com/en-us/azure/cosmos-db/partitioning-overview)** - Horizontal partitioning for unlimited scale

**[📖 Cosmos DB Request Units (RU)](https://learn.microsoft.com/en-us/azure/cosmos-db/request-units)** - Understanding throughput and cost model

**[📖 Cosmos DB Global Distribution](https://learn.microsoft.com/en-us/azure/cosmos-db/distribute-data-globally)** - Multi-region writes and automatic failover

**Key Features:**
- Turnkey global distribution across Azure regions
- Single-digit millisecond latency at 99th percentile
- Five well-defined consistency models
- Multi-model support (document, key-value, graph, column-family)
- Automatic indexing of all data
- SLA-backed availability, throughput, latency, and consistency

**Cosmos DB APIs:**
- **NoSQL API**: Native API with JSON document support
- **MongoDB API**: MongoDB wire protocol compatibility
- **Cassandra API**: Column-family data model
- **Gremlin API**: Graph database with nodes and edges
- **Table API**: Key-value pairs, Azure Table Storage upgrade path

### Azure Blob Storage

**[📖 Azure Blob Storage Overview](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction)** - Massively scalable object storage for unstructured data

**[📖 Blob Storage Access Tiers](https://learn.microsoft.com/en-us/azure/storage/blobs/access-tiers-overview)** - Hot, Cool, Cold, and Archive tiers for cost optimization

**[📖 Blob Types](https://learn.microsoft.com/en-us/rest/api/storageservices/understanding-block-blobs--append-blobs--and-page-blobs)** - Block blobs, append blobs, and page blobs

**[📖 Blob Storage Lifecycle Management](https://learn.microsoft.com/en-us/azure/storage/blobs/lifecycle-management-overview)** - Automate tier transitions and deletion

**Key Features:**
- Store massive amounts of unstructured data
- Support for files, images, videos, logs, backups
- Hierarchical namespace with Azure Data Lake Storage Gen2
- Integration with analytics services
- Multiple redundancy options (LRS, ZRS, GRS, GZRS)

**Access Tiers:**
- **Hot**: Frequent access, highest storage cost, lowest access cost
- **Cool**: Infrequent access (30+ days), lower storage cost
- **Cold**: Rarely accessed (90+ days), optimized for storage
- **Archive**: Long-term storage (180+ days), offline tier

### Azure Files and Table Storage

**[📖 Azure Files Overview](https://learn.microsoft.com/en-us/azure/storage/files/storage-files-introduction)** - Fully managed file shares using SMB and NFS protocols

**[📖 Azure Table Storage Overview](https://learn.microsoft.com/en-us/azure/storage/tables/table-storage-overview)** - NoSQL key-value store for structured data

**[📖 Azure Queue Storage](https://learn.microsoft.com/en-us/azure/storage/queues/storage-queues-introduction)** - Message queue service for asynchronous communication

**Azure Files Use Cases:**
- Replace or supplement on-premises file servers
- Lift-and-shift applications requiring file shares
- Store configuration files accessible from multiple VMs
- Share development tools and utilities

**Table Storage Characteristics:**
- Schema-less design with flexible data models
- Partition and row keys for data organization
- Cost-effective for large volumes of structured data
- No foreign keys, stored procedures, or joins

### Azure Data Lake Storage Gen2

**[📖 Data Lake Storage Gen2 Overview](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction)** - Blob storage with hierarchical namespace for big data analytics

**[📖 Data Lake Gen2 Best Practices](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-best-practices)** - Optimization guidelines for analytics workloads

**Key Features:**
- Hierarchical namespace for efficient directory operations
- Hadoop-compatible access (HDFS)
- Fine-grained access control with POSIX ACLs
- Optimized for analytics workloads
- All Blob storage features plus big data capabilities

---

## Domain 4: Analytics Workloads on Azure (25-30%)

### Azure Synapse Analytics

**[📖 Azure Synapse Analytics Overview](https://learn.microsoft.com/en-us/azure/synapse-analytics/overview-what-is)** - Unified analytics platform combining data warehouse and big data

**[📖 Synapse SQL Pools](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is)** - Dedicated and serverless SQL compute options

**[📖 Synapse Spark Pools](https://learn.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-overview)** - Apache Spark integration for big data processing

**[📖 Synapse Pipelines](https://learn.microsoft.com/en-us/azure/synapse-analytics/get-started-pipelines)** - Data integration and ETL orchestration

**[📖 Synapse Studio](https://learn.microsoft.com/en-us/azure/synapse-analytics/overview-what-is#synapse-studio)** - Unified workspace for data professionals

**Key Components:**
- **Dedicated SQL Pool**: Enterprise data warehouse with MPP architecture
- **Serverless SQL Pool**: On-demand query service, pay per query
- **Spark Pools**: Distributed data processing with Python, Scala, .NET
- **Pipelines**: Code-free ETL/ELT orchestration
- **Power BI Integration**: Seamless connection to analytical datasets

**Synapse Use Cases:**
- Enterprise data warehousing
- Big data and machine learning
- Real-time analytics
- Data lake exploration
- Unified analytics workspace

### Azure Data Factory

**[📖 Azure Data Factory Overview](https://learn.microsoft.com/en-us/azure/data-factory/introduction)** - Cloud-based ETL and data integration service

**[📖 Data Factory Pipelines](https://learn.microsoft.com/en-us/azure/data-factory/concepts-pipelines-activities)** - Workflow orchestration and activity execution

**[📖 Data Factory Linked Services](https://learn.microsoft.com/en-us/azure/data-factory/concepts-linked-services)** - Connection definitions to data stores and compute

**[📖 Data Factory Datasets](https://learn.microsoft.com/en-us/azure/data-factory/concepts-datasets-linked-services)** - Data structure representations in pipelines

**[📖 Data Factory Integration Runtime](https://learn.microsoft.com/en-us/azure/data-factory/concepts-integration-runtime)** - Compute infrastructure for data integration

**[📖 Data Factory Mapping Data Flows](https://learn.microsoft.com/en-us/azure/data-factory/concepts-data-flow-overview)** - Visual data transformation designer

**Key Features:**
- 90+ native connectors for data sources
- Code-free visual interface
- Scalable, serverless data integration
- Trigger-based and schedule-based execution
- Monitoring and alerting capabilities
- Integration with Azure DevOps and GitHub

**Pipeline Components:**
- **Activities**: Units of work (copy, transform, control)
- **Linked Services**: Connection strings to data sources
- **Datasets**: Named views of data
- **Triggers**: Determine pipeline execution (schedule, tumbling window, event)
- **Integration Runtime**: Execution environment

### Azure Databricks

**[📖 Azure Databricks Overview](https://learn.microsoft.com/en-us/azure/databricks/introduction/)** - Apache Spark-based analytics platform optimized for Azure

**[📖 Databricks Workspace](https://learn.microsoft.com/en-us/azure/databricks/workspace/)** - Collaborative environment for data engineering and science

**[📖 Databricks Notebooks](https://learn.microsoft.com/en-us/azure/databricks/notebooks/)** - Interactive development with multiple language support

**[📖 Databricks Clusters](https://learn.microsoft.com/en-us/azure/databricks/clusters/)** - Compute resources for running Spark workloads

**Key Features:**
- Optimized Apache Spark runtime
- Collaborative notebooks (Python, Scala, SQL, R)
- Native integration with Azure services
- MLflow for machine learning lifecycle
- Delta Lake for reliable data lakes
- Auto-scaling and auto-termination

**Use Cases:**
- Big data processing and ETL
- Machine learning and data science
- Real-time analytics and streaming
- Data lake analytics
- Advanced analytics and AI

### Azure HDInsight

**[📖 Azure HDInsight Overview](https://learn.microsoft.com/en-us/azure/hdinsight/hdinsight-overview)** - Managed Hadoop, Spark, and Kafka clusters

**[📖 HDInsight Cluster Types](https://learn.microsoft.com/en-us/azure/hdinsight/hdinsight-overview#cluster-types-in-hdinsight)** - Apache Hadoop, Spark, HBase, Kafka, Storm, and Interactive Query

**Key Features:**
- Open-source analytics frameworks
- Enterprise-grade security with Azure AD
- Cost-effective for large-scale data processing
- VNET integration and encryption

### Azure Stream Analytics

**[📖 Azure Stream Analytics Overview](https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction)** - Real-time analytics on fast-moving data streams

**[📖 Stream Analytics Query Language](https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-stream-analytics-query-patterns)** - SQL-like syntax for stream processing

**[📖 Stream Analytics Inputs](https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-add-inputs)** - Event Hubs, IoT Hub, and Blob storage sources

**[📖 Stream Analytics Outputs](https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-define-outputs)** - Send processed data to various Azure services

**Key Features:**
- Real-time processing with low latency
- Serverless, fully managed service
- SQL-based query language
- Integration with Event Hubs and IoT Hub
- Built-in temporal functions (windowing)
- Scalable streaming units

**Common Patterns:**
- IoT telemetry analysis
- Real-time dashboards
- Anomaly detection
- Log analytics and monitoring
- Clickstream analysis

### Power BI

**[📖 Power BI Overview](https://learn.microsoft.com/en-us/power-bi/fundamentals/power-bi-overview)** - Business analytics service for interactive visualizations

**[📖 Power BI Components](https://learn.microsoft.com/en-us/power-bi/fundamentals/service-service-vs-desktop)** - Desktop, Service, Mobile, and Embedded

**[📖 Power BI Data Sources](https://learn.microsoft.com/en-us/power-bi/connect-data/power-bi-data-sources)** - Connect to hundreds of data sources

**[📖 Power BI Datasets](https://learn.microsoft.com/en-us/power-bi/connect-data/service-datasets-understand)** - Data models for reports and dashboards

**[📖 Power BI Reports and Dashboards](https://learn.microsoft.com/en-us/power-bi/create-reports/service-dashboards)** - Interactive visualizations and KPI monitoring

**Key Components:**
- **Power BI Desktop**: Report authoring tool
- **Power BI Service**: Cloud-based sharing and collaboration
- **Power BI Mobile**: iOS and Android apps
- **Power BI Embedded**: Integrate reports into applications
- **Power BI Report Server**: On-premises reporting

**Data Connectivity:**
- Import mode: Data cached in Power BI
- DirectQuery: Real-time queries to source
- Live connection: Direct connection to Azure Analysis Services
- Composite models: Mix import and DirectQuery

### Azure Analysis Services

**[📖 Azure Analysis Services Overview](https://learn.microsoft.com/en-us/azure/analysis-services/analysis-services-overview)** - Enterprise-grade semantic data models

**[📖 Analysis Services Tabular Models](https://learn.microsoft.com/en-us/analysis-services/tabular-models/tabular-models-ssas)** - In-memory and DirectQuery modes

**Key Features:**
- High-performance semantic layer
- Integration with Power BI and Excel
- Row-level security
- Scale-out for read-heavy workloads
- Support for complex calculations (DAX)

---

## Data Governance and Security

### Azure Purview (Microsoft Purview)

**[📖 Microsoft Purview Overview](https://learn.microsoft.com/en-us/azure/purview/overview)** - Unified data governance service

**[📖 Purview Data Catalog](https://learn.microsoft.com/en-us/azure/purview/overview#data-catalog)** - Discover and understand data assets

**[📖 Purview Data Lineage](https://learn.microsoft.com/en-us/azure/purview/concept-data-lineage)** - Track data movement and transformations

**Key Features:**
- Automated data discovery and classification
- Business glossary and data dictionary
- Data lineage visualization
- Sensitivity labeling
- Data estate insights

### Security Best Practices

**[📖 Azure SQL Security](https://learn.microsoft.com/en-us/azure/azure-sql/database/security-overview)** - Comprehensive security features for SQL databases

**[📖 Transparent Data Encryption (TDE)](https://learn.microsoft.com/en-us/azure/azure-sql/database/transparent-data-encryption-tde-overview)** - Encryption at rest for databases

**[📖 Always Encrypted](https://learn.microsoft.com/en-us/azure/azure-sql/database/always-encrypted-azure-key-vault-configure)** - Protect sensitive data with client-side encryption

**[📖 Dynamic Data Masking](https://learn.microsoft.com/en-us/azure/azure-sql/database/dynamic-data-masking-overview)** - Limit sensitive data exposure

**[📖 Row-Level Security](https://learn.microsoft.com/en-us/sql/relational-databases/security/row-level-security)** - Control row access based on user characteristics

**Security Layers:**
- **Network Security**: Firewalls, private endpoints, VNET integration
- **Access Management**: Azure AD authentication, RBAC
- **Threat Protection**: Advanced Threat Protection, vulnerability assessments
- **Information Protection**: Encryption, masking, classification
- **Auditing**: SQL auditing, diagnostic logs

---

## Additional Resources

**[📖 Azure Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator/)** - Estimate costs for Azure services

**[📖 Azure Free Account](https://azure.microsoft.com/en-us/free/)** - 12 months of free services and $200 credit

**[📖 Azure Documentation](https://learn.microsoft.com/en-us/azure/)** - Comprehensive Azure service documentation

**[📖 Microsoft Learn](https://learn.microsoft.com/en-us/training/)** - Free, interactive learning paths and modules

**[📖 DP-900 Practice Assessment](https://learn.microsoft.com/en-us/certifications/exams/dp-900/practice/assessment)** - Official practice questions

---

## Study Tips and Exam Strategy

### Preparation Approach

1. **Complete Microsoft Learn Paths**: Free, structured content aligned with exam objectives
2. **Hands-On Practice**: Create free Azure account and experiment with services
3. **Understand Concepts**: Focus on "what" and "when" rather than deep technical "how"
4. **Review Documentation**: Familiarize yourself with official Microsoft docs
5. **Take Practice Tests**: Identify knowledge gaps and build exam confidence

### Key Focus Areas

**Core Concepts to Master:**
- Difference between OLTP and OLAP workloads
- Data types: structured, semi-structured, unstructured
- Batch vs. stream processing
- ETL vs. ELT patterns
- CAP theorem and consistency models

**Azure Services to Know:**
- **Relational**: Azure SQL Database, SQL Managed Instance, SQL on VMs, MySQL, PostgreSQL
- **Non-Relational**: Cosmos DB (all APIs), Blob Storage, Table Storage, Data Lake Gen2
- **Analytics**: Synapse Analytics, Data Factory, Databricks, Stream Analytics, Power BI

**Important Distinctions:**
- When to use SQL Database vs. Managed Instance vs. SQL on VMs
- Cosmos DB API selection based on use case
- Blob storage access tiers and when to use each
- Synapse dedicated vs. serverless SQL pools
- Data Factory vs. Synapse Pipelines

### Exam Day Tips

- Read questions carefully, paying attention to keywords like "minimize cost," "real-time," "lowest latency"
- Eliminate obviously incorrect answers first
- For scenario-based questions, identify requirements and constraints
- Don't overthink - this is a fundamentals exam, not advanced certification
- Manage time: ~1.5 minutes per question
- Review flagged questions if time permits

### Common Question Types

1. **Service Selection**: Choose appropriate Azure service for given scenario
2. **Feature Identification**: Match features to services
3. **Best Practices**: Select optimal approach for requirements
4. **Troubleshooting**: Identify issues and solutions
5. **Terminology**: Define concepts and understand relationships

---

## Quick Reference Tables

### Azure SQL Deployment Options

| Option | Use Case | Management | Compatibility |
|--------|----------|------------|---------------|
| SQL Database | Modern cloud apps | Fully managed PaaS | Most SQL Server features |
| SQL Managed Instance | Lift-and-shift migrations | Managed with more control | Near 100% SQL Server |
| SQL on VMs | Custom configurations | Full control (IaaS) | 100% SQL Server |

### Cosmos DB API Selection

| API | Best For | Data Model | Use Case |
|-----|----------|------------|----------|
| NoSQL | New applications | Document | JSON documents, flexible schema |
| MongoDB | MongoDB migrations | Document | Existing MongoDB apps |
| Cassandra | Cassandra migrations | Column-family | Wide-column data |
| Gremlin | Graph scenarios | Graph | Social networks, recommendations |
| Table | Table Storage upgrade | Key-value | Simple key-value pairs |

### Blob Storage Access Tiers

| Tier | Access Frequency | Storage Cost | Access Cost | Min Duration |
|------|-----------------|--------------|-------------|--------------|
| Hot | Frequent | Highest | Lowest | None |
| Cool | Infrequent | Lower | Higher | 30 days |
| Cold | Rare | Even Lower | Even Higher | 90 days |
| Archive | Very rare (offline) | Lowest | Highest | 180 days |

### Analytics Services Comparison

| Service | Primary Use | Processing Model | Best For |
|---------|-------------|------------------|----------|
| Synapse Analytics | Data warehouse + big data | Batch + interactive | Unified analytics |
| Data Factory | Data integration | Batch orchestration | ETL/ELT pipelines |
| Databricks | Big data + ML | Batch + streaming | Advanced analytics |
| Stream Analytics | Real-time analytics | Streaming | IoT and event processing |
| HDInsight | Open-source frameworks | Batch + streaming | Hadoop ecosystem |

---

## Exam Skills Measured (Current Version)

### Describe core data concepts (25-30%)
- Data representation formats
- Data storage types
- Data workload types (OLTP vs OLAP)
- Batch and streaming data
- Data roles and services

### Describe relational data workloads (25-30%)
- Relational data characteristics
- Relational database concepts (normalization, keys)
- SQL statement types (DDL, DML, DCL)
- Azure SQL Database, Managed Instance, SQL on VMs
- Azure Database for PostgreSQL, MySQL, MariaDB

### Describe non-relational data workloads (25-30%)
- Non-relational data types (key-value, document, graph, column-family)
- Azure Cosmos DB capabilities and APIs
- Azure Blob Storage features and tiers
- Azure Files and Table Storage
- Azure Data Lake Storage Gen2

### Describe analytics workloads (25-30%)
- Data warehouse concepts
- Data ingestion and processing
- Azure Synapse Analytics components
- Azure Data Factory pipelines
- Azure Databricks and HDInsight
- Azure Stream Analytics
- Power BI components and workflow

---

## Glossary of Key Terms

**ACID**: Atomicity, Consistency, Isolation, Durability - properties of reliable database transactions

**BASE**: Basically Available, Soft state, Eventual consistency - alternative to ACID for NoSQL

**CAP Theorem**: Trade-off between Consistency, Availability, and Partition tolerance

**Data Lake**: Repository storing massive amounts of raw data in native format

**Data Warehouse**: Centralized repository optimized for analytics and reporting

**ETL**: Extract, Transform, Load - traditional data integration pattern

**ELT**: Extract, Load, Transform - modern pattern leveraging cloud compute

**MPP**: Massively Parallel Processing - distribute queries across compute nodes

**Partition Key**: Determines data distribution for horizontal scaling

**RU**: Request Unit - Cosmos DB throughput measure combining CPU, memory, IOPS

**Schema-on-Read**: Define structure when reading data (data lakes)

**Schema-on-Write**: Define structure when writing data (databases)

**SLA**: Service Level Agreement - guaranteed uptime and performance

**Throughput**: Amount of data processed in given time period

---

*This fact sheet covers foundational concepts for the Azure DP-900 exam. Always verify information with official Microsoft documentation as Azure services evolve frequently.*

**Last Updated**: October 2025
