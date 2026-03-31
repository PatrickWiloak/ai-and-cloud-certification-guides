# Data Mesh Architecture

A comprehensive guide to implementing domain-oriented, decentralized data architectures across AWS, Azure, and Google Cloud Platform.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Architecture Diagram Description](#architecture-diagram-description)
3. [Component Breakdown](#component-breakdown)
4. [AWS Implementation](#aws-implementation)
5. [Azure Implementation](#azure-implementation)
6. [GCP Implementation](#gcp-implementation)
7. [Design Considerations](#design-considerations)
8. [Data as a Product](#data-as-a-product)
9. [Federated Governance](#federated-governance)
10. [Cost Estimation](#cost-estimation)
11. [Production Checklist](#production-checklist)

---

## Architecture Overview

### What is Data Mesh?

Data mesh is a decentralized data architecture that organizes data by business domain:
- **Domain Ownership**: Each business domain owns and manages its own data
- **Data as a Product**: Data is treated as a product with defined quality, SLAs, and discoverability
- **Self-Serve Data Platform**: Infrastructure provides a platform for domains to publish and consume data
- **Federated Computational Governance**: Governance is automated and embedded, not centralized
- **Decentralized Architecture**: No central data team owns all data pipelines

### Four Pillars of Data Mesh

1. **Domain-Oriented Ownership**: Data is owned by the teams that understand the business domain
2. **Data as a Product**: Each data product has an owner, SLAs, documentation, and quality guarantees
3. **Self-Serve Data Infrastructure**: A platform that makes it easy for domains to create and manage data products
4. **Federated Computational Governance**: Global policies enforced through automation, not manual review

### Benefits

- **Scalability**: Data ownership scales with organizational growth
- **Domain Expertise**: Teams closest to the data manage it
- **Reduced Bottlenecks**: No central data team as a bottleneck
- **Faster Time to Value**: Domains can independently create data products
- **Quality**: Domain experts ensure data accuracy and relevance
- **Innovation**: Teams can experiment without cross-team dependencies

### Trade-offs

- **Organizational Change**: Requires significant cultural and organizational shift
- **Duplication**: Some data may be duplicated across domains
- **Standardization**: Balancing domain autonomy with interoperability
- **Skill Requirements**: Each domain needs data engineering capabilities
- **Cost**: Decentralized infrastructure can be more expensive than centralized
- **Governance Complexity**: Federated governance is harder to implement than centralized

### Use Cases

- Large enterprises with multiple business units and data domains
- Organizations where a central data team has become a bottleneck
- Companies adopting microservices and domain-driven design
- Industries with complex data regulations requiring domain accountability
- Organizations needing to scale their data analytics capabilities

### When to Avoid Data Mesh

- Small organizations with a single data team
- Simple data landscapes with few domains
- Organizations without mature engineering practices
- Teams not ready for cultural shift to domain ownership

---

## Architecture Diagram Description

### High-Level Architecture

```
+------------------+    +------------------+    +------------------+
|   Sales Domain   |    |  Product Domain  |    | Customer Domain  |
|                  |    |                  |    |                  |
| [Source Systems]  |    | [Source Systems]  |    | [Source Systems]  |
|       |          |    |       |          |    |       |          |
| [Ingestion]      |    | [Ingestion]      |    | [Ingestion]      |
|       |          |    |       |          |    |       |          |
| [Data Product]   |    | [Data Product]   |    | [Data Product]   |
|  - Sales Orders  |    |  - Product Cat.  |    |  - Customer 360  |
|  - Revenue       |    |  - Inventory     |    |  - Segments      |
+--------+---------+    +--------+---------+    +--------+---------+
         |                       |                       |
         +----------+------------+-----------+-----------+
                    |                        |
          [Data Product Catalog]    [Self-Serve Platform]
                    |                        |
          [Federated Governance]    [Monitoring / Quality]
```

### Data Product Structure

Each data product consists of:
1. **Input Ports**: Data ingestion from source systems
2. **Transformation**: Domain-specific business logic
3. **Output Ports**: APIs, datasets, events for consumers
4. **Metadata**: Schema, documentation, lineage, quality metrics
5. **Observability**: Monitoring, alerting, SLA tracking

---

## Component Breakdown

### Platform Components

| Component | Purpose | Key Features |
|-----------|---------|--------------|
| **Data Catalog** | Discover and understand data products | Search, metadata, lineage |
| **Data Storage** | Persist domain data | Lakehouse, warehouse, object storage |
| **Data Processing** | Transform and prepare data | ETL/ELT, streaming, batch |
| **Data Quality** | Ensure data meets standards | Validation, profiling, monitoring |
| **Access Control** | Manage who can access data | RBAC, column-level security |
| **Data Sharing** | Share data across domains | APIs, subscriptions, marketplace |

### Data Product Components

| Component | Purpose | Key Features |
|-----------|---------|--------------|
| **Owner** | Accountable person/team | Domain expert, product manager |
| **SLA** | Quality and availability guarantees | Freshness, completeness, uptime |
| **Schema** | Data structure definition | Versioned, backward compatible |
| **Documentation** | Usage instructions and context | Examples, business definitions |
| **Access Policies** | Who can consume the data | Request-based, self-service |

---

## AWS Implementation

### Core Services

| Component | AWS Service | Purpose |
|-----------|------------|---------|
| **Data Catalog** | AWS Glue Data Catalog | Centralized metadata repository |
| **Data Governance** | AWS Lake Formation | Fine-grained access control, data sharing |
| **Object Storage** | Amazon S3 | Data lake storage for data products |
| **Data Processing** | AWS Glue, EMR, Step Functions | ETL/ELT pipelines |
| **Data Warehouse** | Amazon Redshift | Analytical queries across data products |
| **Streaming** | Amazon Kinesis, MSK | Real-time data product ingestion |
| **Data Sharing** | Lake Formation, Redshift Data Sharing | Cross-account data sharing |
| **Data Quality** | AWS Glue Data Quality | Automated data quality rules |

### Multi-Account Strategy

```
+---------------------------+
|   Management Account      |
|   - AWS Organizations     |
|   - Central Governance    |
+---------------------------+
         |
    +----+----+----+
    |         |         |
+---------+ +---------+ +---------+
| Sales   | | Product | | Customer|
| Account | | Account | | Account |
| - S3    | | - S3    | | - S3    |
| - Glue  | | - Glue  | | - Glue  |
| - Lake  | | - Lake  | | - Lake  |
| Format. | | Format. | | Format. |
+---------+ +---------+ +---------+
```

### Implementation Pattern

- Each domain gets its own AWS account via AWS Organizations
- Lake Formation manages cross-account data sharing
- Glue Data Catalog provides federated metadata
- S3 buckets store domain data products
- IAM policies enforce access control per data product
- EventBridge enables cross-domain event notifications

**Documentation:**
- [AWS Lake Formation](https://docs.aws.amazon.com/lake-formation/latest/dg/what-is-lake-formation.html)
- [AWS Glue](https://docs.aws.amazon.com/glue/latest/dg/what-is-glue.html)
- [Amazon S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html)
- [AWS Glue Data Quality](https://docs.aws.amazon.com/glue/latest/dg/glue-data-quality.html)

---

## Azure Implementation

### Core Services

| Component | Azure Service | Purpose |
|-----------|--------------|---------|
| **Data Catalog** | Microsoft Purview | Unified data governance and cataloging |
| **Data Governance** | Purview Data Map | Data lineage, classification, policies |
| **Object Storage** | Azure Data Lake Storage Gen2 | Scalable data lake storage |
| **Data Processing** | Azure Synapse Analytics, Data Factory | ETL/ELT pipelines |
| **Data Warehouse** | Synapse Dedicated SQL Pools | Analytical queries |
| **Streaming** | Azure Event Hubs, Stream Analytics | Real-time data ingestion |
| **Data Sharing** | Azure Data Share | Cross-domain data sharing |
| **Data Quality** | Purview Data Quality | Data profiling and quality rules |

### Subscription Strategy

- Each domain gets its own Azure subscription or resource group
- Purview provides cross-subscription data catalog and governance
- ADLS Gen2 containers organized by data product
- Synapse workspaces per domain for independent processing
- Azure Policy enforces tagging and compliance standards
- Managed identities for cross-domain access

### Key Integration Points

- Purview scans data sources across domains automatically
- Data Share enables snapshot and in-place sharing
- Synapse Link provides near-real-time analytics from operational stores
- Event Hubs captures domain events for streaming data products

**Documentation:**
- [Microsoft Purview](https://learn.microsoft.com/en-us/purview/purview)
- [Azure Synapse Analytics](https://learn.microsoft.com/en-us/azure/synapse-analytics/overview-what-is)
- [Azure Data Lake Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction)
- [Azure Data Share](https://learn.microsoft.com/en-us/azure/data-share/overview)

---

## GCP Implementation

### Core Services

| Component | GCP Service | Purpose |
|-----------|------------|---------|
| **Data Catalog** | Dataplex | Unified data management and governance |
| **Data Governance** | Dataplex Data Quality, Catalog | Automated governance |
| **Object Storage** | Cloud Storage (GCS) | Data lake storage |
| **Data Processing** | Dataflow, Dataproc, Cloud Composer | ETL/ELT pipelines |
| **Data Warehouse** | BigQuery | Serverless analytics |
| **Streaming** | Pub/Sub, Dataflow | Real-time data ingestion |
| **Data Sharing** | BigQuery Analytics Hub | Data exchange marketplace |
| **Data Quality** | Dataplex Data Quality Tasks | Automated quality checks |

### Project-Based Strategy

- Each domain gets its own GCP project
- Dataplex organizes data into lakes, zones, and assets across projects
- BigQuery datasets serve as data product output ports
- Analytics Hub enables cross-project data sharing without data movement
- Cloud IAM with organization-level policies for federated governance
- Pub/Sub topics for domain event publishing

### Key Integration Points

- Dataplex auto-discovers and catalogs data across projects
- BigQuery authorized views and datasets for controlled sharing
- Analytics Hub listings for marketplace-style data product discovery
- Data Catalog tags for classification and business metadata

**Documentation:**
- [Google Cloud Dataplex](https://cloud.google.com/dataplex/docs/introduction)
- [BigQuery](https://cloud.google.com/bigquery/docs/introduction)
- [BigQuery Analytics Hub](https://cloud.google.com/bigquery/docs/analytics-hub-introduction)
- [Cloud Storage](https://cloud.google.com/storage/docs/introduction)

---

## Design Considerations

### Domain Identification

- **Align with business capabilities**: Domains should map to business units or capabilities (sales, marketing, product, customer)
- **Bounded contexts**: Use domain-driven design (DDD) to identify natural boundaries
- **Source-aligned domains**: Own operational data (orders, transactions)
- **Consumer-aligned domains**: Create aggregated data products (analytics, reporting)
- **Avoid too many domains**: Start with 3-5 domains and expand as the organization matures

### Data Product Design

- **Define clear interfaces**: Standardize how data products are consumed (SQL, API, files)
- **Version schemas**: Use semantic versioning for breaking changes
- **Self-describing**: Include metadata, documentation, and sample data
- **Immutable**: Append-only data with full history when possible
- **SLA-driven**: Define freshness, completeness, and availability guarantees

### Platform Design

- **Golden paths**: Provide templates and tooling for common data product patterns
- **Self-service provisioning**: Domains should be able to create infrastructure without tickets
- **Observability built-in**: Monitoring, alerting, and quality checks as platform features
- **Security by default**: Encryption, access control, and audit logging as defaults

---

## Data as a Product

### Product Thinking for Data

| Aspect | Traditional Data | Data as a Product |
|--------|-----------------|-------------------|
| **Ownership** | Central data team | Domain team |
| **Quality** | Best effort | SLA-backed guarantees |
| **Discovery** | Ask someone | Self-serve catalog |
| **Documentation** | Wiki pages (maybe) | Co-located with data |
| **Consumers** | Known, limited | Self-service, scalable |
| **Evolution** | Breaking changes | Versioned, backward compatible |

### Data Product Quality Dimensions

- **Freshness**: How recently was the data updated?
- **Completeness**: Are there missing values or records?
- **Accuracy**: Does the data reflect reality?
- **Consistency**: Is the data consistent across sources?
- **Uniqueness**: Are there duplicate records?
- **Timeliness**: Is data available when needed?

### Data Product Metadata

Every data product should include:
- **Name and description**: Clear, business-friendly naming
- **Owner and contact**: Who to reach for questions
- **Schema**: Field definitions, types, and constraints
- **SLA**: Freshness, availability, and quality guarantees
- **Lineage**: Where the data comes from and how it is transformed
- **Sample data**: Examples for quick understanding
- **Usage examples**: SQL queries, API calls, code snippets
- **Access request process**: How to get access

---

## Federated Governance

### Governance Model

```
                    [Global Policies]
                    - Naming standards
                    - Security baseline
                    - Quality thresholds
                    - Interoperability
                          |
         +----------------+----------------+
         |                |                |
   [Domain: Sales]  [Domain: Product] [Domain: Customer]
   - Domain rules   - Domain rules    - Domain rules
   - Local quality  - Local quality   - Local quality
   - Access mgmt    - Access mgmt    - Access mgmt
```

### Global vs Domain Policies

| Policy Type | Global (Federated) | Domain (Local) |
|-------------|-------------------|----------------|
| **Naming** | Standard prefixes and conventions | Domain-specific terminology |
| **Security** | Encryption requirements, PII handling | Access control for specific products |
| **Quality** | Minimum freshness and completeness | Domain-specific validation rules |
| **Interoperability** | Standard formats (Parquet, Avro) | Internal transformation logic |
| **Compliance** | Regulatory requirements (GDPR, HIPAA) | Domain-specific retention policies |

### Automation

- **Policy as Code**: Define governance rules in version-controlled code
- **Automated Quality Checks**: Run data quality validations on every update
- **Schema Validation**: Enforce schema standards at ingestion time
- **Access Auditing**: Automatically log and review data access patterns
- **Compliance Scanning**: Detect PII and sensitive data automatically

---

## Cost Estimation

### AWS (Monthly Estimate per Domain)

| Component | Service | Estimated Cost |
|-----------|---------|---------------|
| Storage | S3 (1 TB) | ~$23/month |
| Catalog | Glue Data Catalog | ~$1/month |
| Processing | Glue Jobs (10 DPU-hours/day) | ~$130/month |
| Governance | Lake Formation | Free (included) |
| Warehouse | Redshift Serverless (moderate) | ~$200-500/month |
| Quality | Glue Data Quality | ~$50-100/month |
| **Per Domain Total** | | **~$400-750/month** |
| **Platform Total (5 domains)** | | **~$2,000-3,750/month** |

### Azure (Monthly Estimate per Domain)

| Component | Service | Estimated Cost |
|-----------|---------|---------------|
| Storage | ADLS Gen2 (1 TB) | ~$21/month |
| Catalog | Purview | ~$250-500/month (shared) |
| Processing | Data Factory + Synapse | ~$200-500/month |
| Sharing | Data Share | ~$50-100/month |
| **Per Domain Total** | | **~$500-1,100/month** |
| **Platform Total (5 domains)** | | **~$2,500-5,500/month** |

### GCP (Monthly Estimate per Domain)

| Component | Service | Estimated Cost |
|-----------|---------|---------------|
| Storage | GCS (1 TB) | ~$20/month |
| Catalog | Dataplex | ~$50-100/month |
| Processing | Dataflow | ~$100-300/month |
| Warehouse | BigQuery (on-demand, moderate) | ~$100-400/month |
| Sharing | Analytics Hub | Free (query costs only) |
| **Per Domain Total** | | **~$270-820/month** |
| **Platform Total (5 domains)** | | **~$1,350-4,100/month** |

---

## Production Checklist

### Organization Readiness

- [ ] Domain boundaries identified and agreed upon
- [ ] Domain data product owners assigned
- [ ] Data mesh principles communicated to stakeholders
- [ ] Organizational support and executive sponsorship secured
- [ ] Training plan for domain teams created

### Platform Infrastructure

- [ ] Multi-account/project/subscription strategy implemented
- [ ] Self-serve provisioning templates available
- [ ] Data catalog deployed and accessible
- [ ] Data quality framework operational
- [ ] Monitoring and alerting configured
- [ ] CI/CD pipelines for data product deployment

### Data Products

- [ ] Data product template and standards defined
- [ ] Schema registry or catalog configured
- [ ] At least one data product per domain published
- [ ] Documentation standards enforced
- [ ] SLAs defined and monitored
- [ ] Data product versioning strategy implemented

### Governance

- [ ] Global governance policies documented
- [ ] Policy-as-code implemented and enforced
- [ ] Data classification and PII detection automated
- [ ] Access control model implemented (RBAC/ABAC)
- [ ] Compliance requirements mapped to controls
- [ ] Data lineage tracking operational

### Operations

- [ ] Data quality dashboards available
- [ ] Incident response process for data issues defined
- [ ] Cross-domain data sharing tested and validated
- [ ] Performance benchmarks established
- [ ] Cost allocation per domain configured
- [ ] Regular data mesh maturity assessments scheduled

---

**Related Guides:**
- [Data Pipeline ETL Architecture](./data-pipeline-etl.md)
- [Lakehouse Architecture](./lakehouse-architecture.md)
- [Event-Driven Architecture](./event-driven-architecture.md)
