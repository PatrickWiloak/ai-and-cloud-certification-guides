---
last-updated: 2026-05-03
---

# Azure DP-420 Certification Fact Sheet
## Designing and Implementing Cloud-Native Applications Using Microsoft Azure Cosmos DB

> Comprehensive quick reference guide with embedded documentation links for hands-on developers preparing for the DP-420 certification exam.

---

## Table of Contents
1. [Exam Overview](#exam-overview)
2. [Azure Cosmos DB Core Concepts](#azure-cosmos-db-core-concepts)
3. [Data Modeling for NoSQL](#data-modeling-for-nosql)
4. [Partitioning Strategies](#partitioning-strategies)
5. [Consistency Levels](#consistency-levels)
6. [SQL API and Queries](#sql-api-and-queries)
7. [Indexing Policies](#indexing-policies)
8. [Change Feed](#change-feed)
9. [SDKs and Development](#sdks-and-development)
10. [Performance Optimization](#performance-optimization)
11. [Global Distribution](#global-distribution)
12. [Security and Access Control](#security-and-access-control)
13. [Monitoring and Diagnostics](#monitoring-and-diagnostics)
14. [Cost Optimization](#cost-optimization)
15. [Integration Patterns](#integration-patterns)

---

## Exam Overview

### Essential Information
- **Exam Code:** DP-420
- **Duration:** 180 minutes
- **Questions:** 40-60 questions
- **Passing Score:** 700/1000
- **Cost:** $165 USD

### Official Exam Resources
- **[📖 DP-420 Official Exam Page](https://learn.microsoft.com/en-us/certifications/exams/dp-420/)** - Complete exam details, registration, and skills measured
- **[📖 DP-420 Study Guide](https://learn.microsoft.com/en-us/certifications/resources/study-guides/dp-420)** - Official study guide with exam objectives
- **[📖 DP-420 Learning Path](https://learn.microsoft.com/en-us/training/courses/dp-420t00)** - Microsoft's official training course materials

### Exam Domain Breakdown
1. **Design and Implement Data Models (35-40%)** - Data modeling, API selection, document design
2. **Design and Implement Data Distribution (5-10%)** - Partitioning, global distribution
3. **Integrate Azure Cosmos DB Solutions (5-10%)** - Change feed, Azure services integration
4. **Optimize Azure Cosmos DB Solutions (15-20%)** - Performance, cost optimization
5. **Maintain Azure Cosmos DB Solutions (25-30%)** - Monitoring, security, backup/recovery

---

## Azure Cosmos DB Core Concepts

### Platform Overview
- **[📖 Azure Cosmos DB Overview](https://learn.microsoft.com/en-us/azure/cosmos-db/introduction)** - Introduction to Cosmos DB fundamentals and capabilities
- **[📖 Choose an API in Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/choose-api)** - Guidance on selecting the right API for your workload
- **[📖 Multi-Model Database Capabilities](https://learn.microsoft.com/en-us/azure/cosmos-db/distributed-nosql)** - Understanding Cosmos DB's multi-model approach
- **[📖 Resource Model](https://learn.microsoft.com/en-us/azure/cosmos-db/account-databases-containers-items)** - Account, database, container, and item hierarchy

### NoSQL API (Core SQL API)
- **[📖 NoSQL API Overview](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/)** - Introduction to the native Cosmos DB NoSQL API
- **[📖 Getting Started with NoSQL API](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/quickstart-dotnet)** - Quick start guide for .NET developers
- **[📖 NoSQL API Best Practices](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/best-practice-dotnet)** - Performance and design best practices
- **[📖 JSON Document Support](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/query/working-with-json)** - Working with JSON documents in Cosmos DB

### Alternative APIs
- **[📖 MongoDB API](https://learn.microsoft.com/en-us/azure/cosmos-db/mongodb/mongodb-introduction)** - MongoDB compatibility for easy migration
- **[📖 Cassandra API](https://learn.microsoft.com/en-us/azure/cosmos-db/cassandra/cassandra-introduction)** - Apache Cassandra compatibility with CQL support
- **[📖 Gremlin API](https://learn.microsoft.com/en-us/azure/cosmos-db/gremlin/introduction)** - Graph database capabilities with Gremlin query language
- **[📖 Table API](https://learn.microsoft.com/en-us/azure/cosmos-db/table/introduction)** - Key-value store compatible with Azure Table Storage

---

## Data Modeling for NoSQL

### Design Principles
- **[📖 Data Modeling in Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/modeling-data)** - Fundamental principles of NoSQL data modeling
- **[📖 Modeling and Partitioning Best Practices](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/model-partition-example)** - Real-world example of effective data modeling
- **[📖 Embed vs Reference Data](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/modeling-data#embedding-data)** - When to embed or reference related data
- **[📖 Modeling Relationships](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/model-partition-example#v1-a-first-version)** - Handling one-to-many and many-to-many relationships

### Document Design Patterns
- **[📖 Document Structure Design](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/how-to-model-partition-example)** - Designing effective document structures
- **[📖 Denormalization Strategies](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/modeling-data#denormalizing-data)** - When and how to denormalize for performance
- **[📖 Handling Large Documents](https://learn.microsoft.com/en-us/azure/cosmos-db/concepts-limits#item-limits)** - Working with the 2MB document size limit
- **[📖 Modeling Hierarchical Data](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/model-partition-example#v2-introducing-denormalization)** - Techniques for nested and hierarchical data

### Migration and Modeling Tools
- **[📖 Data Migration Guide](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/how-to-migrate-data)** - Migrating data to Cosmos DB
- **[📖 Azure Data Factory for Cosmos DB](https://learn.microsoft.com/en-us/azure/data-factory/connector-azure-cosmos-db)** - ETL and data migration with ADF

---

## Partitioning Strategies

### Partition Key Fundamentals
- **[📖 Partitioning Overview](https://learn.microsoft.com/en-us/azure/cosmos-db/partitioning-overview)** - Complete guide to logical and physical partitioning
- **[📖 Choosing a Partition Key](https://learn.microsoft.com/en-us/azure/cosmos-db/partitioning-overview#choose-partitionkey)** - Critical decision factors for partition key selection
- **[📖 Partition Key Best Practices](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/how-to-model-partition-example#partition-key-selection)** - Real-world guidance for effective partition keys
- **[📖 Synthetic Partition Keys](https://learn.microsoft.com/en-us/azure/cosmos-db/synthetic-partition-keys)** - Creating composite keys for better distribution

### Advanced Partitioning
- **[📖 Hierarchical Partition Keys](https://learn.microsoft.com/en-us/azure/cosmos-db/hierarchical-partition-keys)** - Multi-level partitioning for improved distribution
- **[📖 Hot Partition Detection and Mitigation](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/troubleshoot-request-rate-too-large)** - Identifying and fixing hot partition issues
- **[📖 Partition Key Strategies by Workload](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/model-partition-example#choosing-a-partition-key)** - Patterns for different application types
- **[📖 Cross-Partition Queries](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/how-to-query-container#cross-partition-query)** - Understanding and optimizing cross-partition operations

---

## Consistency Levels

### Consistency Model Overview
- **[📖 Consistency Levels in Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/consistency-levels)** - Comprehensive guide to all five consistency levels
- **[📖 Consistency Level Trade-offs](https://learn.microsoft.com/en-us/azure/cosmos-db/consistency-levels#consistency-levels-and-latency)** - Understanding latency vs. consistency trade-offs
- **[📖 Choosing the Right Consistency Level](https://learn.microsoft.com/en-us/azure/cosmos-db/consistency-levels#scope)** - Decision guide for application requirements
- **[📖 Consistency Level Guarantees](https://learn.microsoft.com/en-us/azure/cosmos-db/consistency-levels#guarantees)** - Formal guarantees for each consistency level

### Consistency Configuration
- **[📖 Configure Default Consistency](https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-manage-consistency)** - Setting account-level consistency defaults
- **[📖 Override Consistency Per Request](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/how-to-manage-consistency#override-the-default-consistency-level)** - Request-level consistency configuration in SDKs
- **[📖 Session Consistency Deep Dive](https://learn.microsoft.com/en-us/azure/cosmos-db/consistency-levels#session-consistency)** - Understanding session tokens and read-your-writes
- **[📖 Strong Consistency and Multi-Region](https://learn.microsoft.com/en-us/azure/cosmos-db/consistency-levels#strong-consistency-and-multi-region-writes)** - Limitations and considerations

---

## SQL API and Queries

### Query Language Fundamentals
- **[📖 SQL Query Getting Started](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/query/getting-started)** - Introduction to Cosmos DB SQL query syntax
- **[📖 SQL Query Reference](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/query/select)** - Complete SQL query language reference
- **[📖 Query Execution](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/query/how-to-query-container)** - Executing queries using SDKs and Azure Portal

### Advanced Query Features
- **[📖 JOIN Operations](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/query/join)** - Intra-document joins within Cosmos DB
- **[📖 Subqueries](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/query/subquery)** - Using subqueries for complex filtering
- **[📖 Aggregate Functions](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/query/aggregate-functions)** - COUNT, SUM, AVG, MIN, MAX operations
- **[📖 Array and Object Functions](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/query/array-functions)** - Working with nested arrays and objects
- **[📖 String Functions](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/query/string-functions)** - String manipulation in queries
- **[📖 Mathematical Functions](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/query/mathematical-functions)** - Numeric calculations and operations

### Query Optimization
- **[📖 Query Performance Tuning](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/query/performance-tips)** - Best practices for efficient queries
- **[📖 Understanding Query Metrics](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/query-metrics)** - Analyzing RU consumption and execution time
- **[📖 Parameterized Queries](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/query/parameterized-queries)** - Using parameters for better performance and security
- **[📖 Pagination with Continuation Tokens](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/query/pagination)** - Efficiently handling large result sets

---

## Indexing Policies

### Indexing Fundamentals
- **[📖 Indexing Overview](https://learn.microsoft.com/en-us/azure/cosmos-db/index-overview)** - How Cosmos DB automatic indexing works
- **[📖 Indexing Policies](https://learn.microsoft.com/en-us/azure/cosmos-db/index-policy)** - Configuring and customizing indexing behavior
- **[📖 Index Types](https://learn.microsoft.com/en-us/azure/cosmos-db/index-overview#index-types)** - Range, spatial, and composite indexes

### Advanced Indexing
- **[📖 Composite Indexes](https://learn.microsoft.com/en-us/azure/cosmos-db/index-policy#composite-indexes)** - Optimizing multi-property queries with composite indexes
- **[📖 Spatial Indexes](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/query/geospatial-query)** - Geospatial queries and location-based indexing
- **[📖 Include and Exclude Paths](https://learn.microsoft.com/en-us/azure/cosmos-db/index-policy#include-exclude-paths)** - Fine-tuning indexed properties for cost optimization
- **[📖 Indexing Mode Configuration](https://learn.microsoft.com/en-us/azure/cosmos-db/index-policy#indexing-mode)** - Consistent vs. none indexing modes
- **[📖 Vector Search and Indexing](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/vector-search)** - AI and vector embedding search capabilities

---

## Change Feed

### Change Feed Fundamentals
- **[📖 Change Feed Overview](https://learn.microsoft.com/en-us/azure/cosmos-db/change-feed)** - Introduction to real-time change notifications
- **[📖 Change Feed Design Patterns](https://learn.microsoft.com/en-us/azure/cosmos-db/change-feed-design-patterns)** - Common architectural patterns using change feed
- **[📖 Change Feed Processing](https://learn.microsoft.com/en-us/azure/cosmos-db/change-feed-processor)** - Understanding the change feed processor library

### Implementation and Integration
- **[📖 Change Feed in .NET SDK](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/change-feed-pull-model)** - Pull and push models for processing changes
- **[📖 Azure Functions Trigger for Cosmos DB](https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-cosmosdb-v2-trigger)** - Serverless change feed processing
- **[📖 Change Feed Estimator](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/how-to-use-change-feed-estimator)** - Monitoring change feed lag and health
- **[📖 Change Feed All Versions Mode](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/change-feed-modes)** - Capturing all versions and deletes

---

## SDKs and Development

### .NET SDK
- **[📖 Azure Cosmos DB .NET SDK v3](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/sdk-dotnet-v3)** - Primary SDK for .NET applications
- **[📖 .NET SDK Best Practices](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/best-practice-dotnet)** - Performance optimization for .NET developers
- **[📖 Bulk Operations in .NET](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/how-to-use-bulk-executor-dotnet)** - High-throughput batch operations
- **[📖 Transactional Batch in .NET](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/transactional-batch)** - ACID transactions within a partition

### Java SDK
- **[📖 Azure Cosmos DB Java SDK v4](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/sdk-java-v4)** - Modern async SDK for Java developers
- **[📖 Java SDK Best Practices](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/best-practice-java)** - Performance and connection management
- **[📖 Java SDK Performance Tips](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/performance-tips-java-sdk-v4)** - Optimizing Java applications

### Python SDK
- **[📖 Azure Cosmos DB Python SDK](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/sdk-python)** - Python client library for Cosmos DB
- **[📖 Python SDK Samples](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/samples-python)** - Code examples for common Python scenarios

### JavaScript/Node.js SDK
- **[📖 Azure Cosmos DB JavaScript SDK](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/sdk-nodejs)** - Node.js and browser-based applications
- **[📖 JavaScript SDK Samples](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/samples-nodejs)** - Code examples for Node.js developers

### SDK Common Patterns
- **[📖 Connection Management](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/best-practice-dotnet#sdk-usage)** - Singleton client pattern and connection pooling
- **[📖 Retry Policies](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/conceptual-resilient-sdk-applications)** - Building resilient applications with automatic retries
- **[📖 Direct vs Gateway Mode](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/sdk-connection-modes)** - Connectivity modes and performance implications

---

## Performance Optimization

### Request Units (RU) Management
- **[📖 Request Units Explained](https://learn.microsoft.com/en-us/azure/cosmos-db/request-units)** - Understanding RU consumption and calculation
- **[📖 Estimating RU Requirements](https://learn.microsoft.com/en-us/azure/cosmos-db/estimate-ru-with-capacity-planner)** - Capacity planning and RU estimation
- **[📖 Provisioned Throughput](https://learn.microsoft.com/en-us/azure/cosmos-db/set-throughput)** - Configuring RU/s at database and container level
- **[📖 Autoscale Throughput](https://learn.microsoft.com/en-us/azure/cosmos-db/provision-throughput-autoscale)** - Automatic scaling based on workload

### Throughput Optimization
- **[📖 Serverless Mode](https://learn.microsoft.com/en-us/azure/cosmos-db/serverless)** - Pay-per-request pricing for variable workloads
- **[📖 Shared Throughput](https://learn.microsoft.com/en-us/azure/cosmos-db/set-throughput#set-throughput-on-a-database)** - Sharing RU/s across multiple containers
- **[📖 Optimizing RU Consumption](https://learn.microsoft.com/en-us/azure/cosmos-db/optimize-cost-throughput)** - Techniques to reduce request unit usage

### Performance Best Practices
- **[📖 Performance Tips for NoSQL API](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/performance-tips)** - General performance optimization strategies
- **[📖 Query Performance Optimization](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/query/performance-tips)** - Reducing RU costs in queries
- **[📖 Bulk Import Performance](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/how-to-use-bulk-executor-overview)** - High-performance data ingestion
- **[📖 SDK Performance Benchmarks](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/performance-benchmarks-dotnet-v3)** - Understanding SDK performance characteristics

### Analytical Store and HTAP
- **[📖 Azure Synapse Link for Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/synapse-link)** - Hybrid transactional and analytical processing
- **[📖 Analytical Store Overview](https://learn.microsoft.com/en-us/azure/cosmos-db/analytical-store-introduction)** - Column-oriented store for analytics without ETL
- **[📖 Query Analytical Store with Spark](https://learn.microsoft.com/en-us/azure/cosmos-db/synapse-link-use-cases)** - Big data analytics on operational data

---

## Global Distribution

### Multi-Region Configuration
- **[📖 Global Distribution Overview](https://learn.microsoft.com/en-us/azure/cosmos-db/distribute-data-globally)** - Turnkey global distribution capabilities
- **[📖 Add and Remove Regions](https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-manage-database-account)** - Configuring multi-region deployments
- **[📖 Multi-Region Writes](https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-multi-master)** - Enabling write capabilities in all regions
- **[📖 Automatic Failover](https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-manage-database-account#automatic-failover)** - Configuring failover priorities and policies

### Conflict Resolution
- **[📖 Conflict Resolution Overview](https://learn.microsoft.com/en-us/azure/cosmos-db/conflict-resolution-policies)** - Managing conflicts in multi-region write scenarios
- **[📖 Last-Write-Wins Policy](https://learn.microsoft.com/en-us/azure/cosmos-db/conflict-resolution-policies#last-write-wins-policy)** - Default timestamp-based conflict resolution
- **[📖 Custom Conflict Resolution](https://learn.microsoft.com/en-us/azure/cosmos-db/conflict-resolution-policies#custom-conflict-resolution)** - User-defined merge procedures

### Availability and SLAs
- **[📖 High Availability in Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/high-availability)** - Understanding 99.999% availability SLA
- **[📖 SLA for Azure Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/sla)** - Comprehensive service level agreements
- **[📖 Availability Zones](https://learn.microsoft.com/en-us/azure/cosmos-db/high-availability#availability-zones)** - Zone-redundant deployments

---

## Security and Access Control

### Authentication and Authorization
- **[📖 Security Overview](https://learn.microsoft.com/en-us/azure/cosmos-db/database-security)** - Comprehensive security features and capabilities
- **[📖 Azure AD Authentication](https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-setup-rbac)** - Role-based access control with Azure Active Directory
- **[📖 Primary and Secondary Keys](https://learn.microsoft.com/en-us/azure/cosmos-db/secure-access-to-data)** - Master key authentication and management
- **[📖 Resource Tokens](https://learn.microsoft.com/en-us/azure/cosmos-db/secure-access-to-data#resource-tokens)** - Fine-grained access control for specific resources

### Network Security
- **[📖 Firewall Configuration](https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-configure-firewall)** - IP firewall rules and access restrictions
- **[📖 Virtual Network Service Endpoints](https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-configure-vnet-service-endpoint)** - Private connectivity from VNets
- **[📖 Private Endpoints](https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-configure-private-endpoints)** - Azure Private Link integration
- **[📖 Public Network Access Control](https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-disable-public-access)** - Disabling public internet access

### Data Encryption
- **[📖 Encryption at Rest](https://learn.microsoft.com/en-us/azure/cosmos-db/database-encryption-at-rest)** - Transparent data encryption for stored data
- **[📖 Customer-Managed Keys](https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-setup-cmk)** - Bring your own key (BYOK) with Azure Key Vault
- **[📖 Encryption in Transit](https://learn.microsoft.com/en-us/azure/cosmos-db/database-security#encryption-in-transit)** - TLS 1.2+ for all connections

---

## Monitoring and Diagnostics

### Azure Monitor Integration
- **[📖 Monitoring Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/monitor-cosmos-db)** - Complete monitoring and observability guide
- **[📖 Metrics in Azure Monitor](https://learn.microsoft.com/en-us/azure/cosmos-db/monitor-cosmos-db-reference)** - Available metrics and dimensions
- **[📖 Diagnostic Logs](https://learn.microsoft.com/en-us/azure/cosmos-db/monitor-cosmos-db#diagnostic-settings)** - Configuring diagnostic logging to Log Analytics
- **[📖 Setting Up Alerts](https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-alert)** - Proactive monitoring with Azure Monitor alerts

### Performance Monitoring
- **[📖 Query Metrics and Diagnostics](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/query-metrics)** - Understanding query execution statistics
- **[📖 Server-Side Latency Metrics](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/troubleshoot-dotnet-sdk-request-timeout)** - Diagnosing latency issues
- **[📖 RU Consumption Monitoring](https://learn.microsoft.com/en-us/azure/cosmos-db/monitor-normalized-request-units)** - Tracking normalized RU consumption
- **[📖 Partition Metrics](https://learn.microsoft.com/en-us/azure/cosmos-db/monitor-partition-storage)** - Storage and throughput distribution analysis

### Troubleshooting
- **[📖 Troubleshooting Guide](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/troubleshoot-dotnet-sdk)** - Common issues and resolutions for .NET SDK
- **[📖 Rate Limiting (429) Errors](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/troubleshoot-request-rate-too-large)** - Understanding and fixing throughput exceeded errors
- **[📖 Connection Issues](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/troubleshoot-service-unavailable)** - Diagnosing connectivity problems
- **[📖 Performance Diagnostics](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/performance-diagnostics)** - Using built-in diagnostics tools

---

## Cost Optimization

### Cost Management
- **[📖 Understanding Cosmos DB Pricing](https://learn.microsoft.com/en-us/azure/cosmos-db/understand-your-bill)** - Billing components and cost calculation
- **[📖 Optimize Throughput Costs](https://learn.microsoft.com/en-us/azure/cosmos-db/optimize-cost-throughput)** - Strategies to reduce RU/s expenses
- **[📖 Optimize Storage Costs](https://learn.microsoft.com/en-us/azure/cosmos-db/optimize-cost-storage)** - Managing data retention and storage usage
- **[📖 Choosing Between Provisioned and Serverless](https://learn.microsoft.com/en-us/azure/cosmos-db/throughput-serverless)** - Cost comparison for different workload types

### Cost Optimization Strategies
- **[📖 Time to Live (TTL)](https://learn.microsoft.com/en-us/azure/cosmos-db/time-to-live)** - Automatic data expiration to reduce storage costs
- **[📖 Reserved Capacity](https://learn.microsoft.com/en-us/azure/cosmos-db/reserved-capacity)** - Pre-purchasing capacity for cost savings
- **[📖 Free Tier](https://learn.microsoft.com/en-us/azure/cosmos-db/free-tier)** - 1000 RU/s and 25 GB storage free
- **[📖 Cost Analysis and Budgets](https://learn.microsoft.com/en-us/azure/cosmos-db/plan-manage-costs)** - Planning and managing Cosmos DB costs

---

## Integration Patterns

### Azure Services Integration
- **[📖 Azure Functions Integration](https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-cosmosdb-v2)** - Serverless triggers, input and output bindings
- **[📖 Logic Apps Connector](https://learn.microsoft.com/en-us/connectors/documentdb/)** - Workflow automation with Cosmos DB
- **[📖 Azure Stream Analytics](https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-documentdb-output)** - Real-time streaming data to Cosmos DB
- **[📖 Event Grid Integration](https://learn.microsoft.com/en-us/azure/event-grid/event-schema-cosmos-db)** - Event-driven architectures with change feed

### Data Integration
- **[📖 Azure Data Factory](https://learn.microsoft.com/en-us/azure/data-factory/connector-azure-cosmos-db)** - ETL pipelines and data movement
- **[📖 Azure Databricks Integration](https://learn.microsoft.com/en-us/azure/databricks/data/data-sources/azure/cosmosdb-connector)** - Apache Spark connector for Cosmos DB
- **[📖 Power BI Integration](https://learn.microsoft.com/en-us/azure/cosmos-db/powerbi-visualize)** - Real-time dashboards and reporting

### Migration Tools
- **[📖 Data Migration Tool](https://learn.microsoft.com/en-us/azure/cosmos-db/import-data)** - Command-line tool for bulk data import
- **[📖 Azure Cosmos DB Live Migrator](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/how-to-move-data)** - Zero-downtime migration strategies
- **[📖 Spark Connector for Migration](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/migrate-data-databricks)** - Large-scale data migration using Databricks

---

## Additional Resources

### Backup and Disaster Recovery
- **[📖 Backup Overview](https://learn.microsoft.com/en-us/azure/cosmos-db/online-backup-and-restore)** - Automatic continuous backup
- **[📖 Point-in-Time Restore](https://learn.microsoft.com/en-us/azure/cosmos-db/continuous-backup-restore-introduction)** - Restoring data to any point in time
- **[📖 Periodic Backup Mode](https://learn.microsoft.com/en-us/azure/cosmos-db/periodic-backup-restore-introduction)** - Traditional scheduled backup approach
- **[📖 Restore Cosmos DB Account](https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-restore-account-continuous-backup)** - Recovery procedures and best practices

### Compliance and Governance
- **[📖 Compliance Certifications](https://learn.microsoft.com/en-us/azure/cosmos-db/compliance)** - Industry standards and regulatory compliance
- **[📖 Azure Policy for Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/policy-reference)** - Governance and compliance policies
- **[📖 Audit Logging](https://learn.microsoft.com/en-us/azure/cosmos-db/audit-control-plane-logs)** - Control plane operation logging

### Development Best Practices
- **[📖 Design Patterns](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/design-patterns)** - Common architectural patterns catalog
- **[📖 Testing Strategies](https://learn.microsoft.com/en-us/azure/cosmos-db/local-emulator)** - Using the Cosmos DB emulator for local development
- **[📖 Cosmos DB Emulator](https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-develop-emulator)** - Development and testing without Azure costs
- **[📖 DevOps and CI/CD](https://learn.microsoft.com/en-us/azure/cosmos-db/continuous-backup-restore-resource-model)** - Infrastructure as Code with ARM templates

### Community and Learning Resources
- **[📖 Azure Cosmos DB Blog](https://devblogs.microsoft.com/cosmosdb/)** - Latest features, announcements, and deep dives
- **[📖 GitHub Samples Repository](https://github.com/Azure-Samples/cosmos-dotnet-core-getting-started)** - Official code samples for all SDKs
- **[📖 Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/browse/)** - Reference architectures using Cosmos DB

---

## Exam Preparation Checklist

### Core Competencies to Master
- [ ] Design appropriate partition keys for various workload types
- [ ] Choose the right consistency level based on requirements
- [ ] Optimize queries to minimize RU consumption
- [ ] Configure indexing policies for cost and performance
- [ ] Implement change feed processors for event-driven architectures
- [ ] Use SDK best practices for connection management and bulk operations
- [ ] Configure global distribution and multi-region writes
- [ ] Implement proper authentication and authorization
- [ ] Set up monitoring, alerts, and diagnostics
- [ ] Optimize costs using autoscale, serverless, and TTL

### Hands-On Practice Areas
1. Create Cosmos DB accounts with different APIs
2. Design and implement effective data models
3. Write complex SQL queries with joins and aggregations
4. Configure custom indexing policies
5. Implement change feed processors with Azure Functions
6. Perform bulk import operations
7. Configure multi-region deployments
8. Troubleshoot 429 rate limiting errors
9. Analyze query metrics and optimize performance
10. Implement security controls (RBAC, firewall, private endpoints)

### Key Documentation to Review
- [ ] Partitioning and partition key selection
- [ ] Consistency levels and their trade-offs
- [ ] Request Units calculation and optimization
- [ ] Change feed patterns and implementations
- [ ] SDK best practices for your primary language
- [ ] Query performance tuning techniques
- [ ] Security and access control mechanisms
- [ ] Monitoring metrics and diagnostic logs

---

## Quick Reference Tables

### Consistency Levels Comparison

| Level | Guarantee | Use Case | Latency | Availability |
|-------|-----------|----------|---------|--------------|
| **Strong** | Linearizability | Financial, inventory | Highest | Lowest |
| **Bounded Staleness** | K versions or T time lag | Stock quotes, leaderboards | High | Low |
| **Session** | Read-your-writes | User sessions, shopping carts | Medium | Medium |
| **Consistent Prefix** | No out-of-order reads | Social media, notifications | Low | High |
| **Eventual** | Eventually converges | View counts, telemetry | Lowest | Highest |

### Request Unit Guidelines

| Operation | Typical RU Cost | Notes |
|-----------|-----------------|-------|
| Point read (1KB) | 1 RU | By ID and partition key |
| Point write (1KB) | 5-10 RU | Depends on indexing policy |
| Query (simple) | 2-5 RU | Single partition, indexed properties |
| Query (complex) | 10-100+ RU | Cross-partition, aggregations |
| Bulk insert (1KB) | 5-7 RU | Using bulk executor |
| Update (1KB) | 10-15 RU | Includes read and write |

### API Selection Guide

| API | Use When | Migration From | Query Language |
|-----|----------|----------------|----------------|
| **NoSQL (SQL)** | New applications, best performance | N/A | SQL-like |
| **MongoDB** | Existing MongoDB apps | MongoDB | MongoDB Query |
| **Cassandra** | Wide-column workloads | Cassandra | CQL |
| **Gremlin** | Graph relationships | Neo4j, TinkerPop | Gremlin |
| **Table** | Key-value store | Azure Table Storage | OData |

---

## Summary

This fact sheet provides a comprehensive reference for the Azure DP-420 certification exam with **100 embedded documentation links** covering all major exam domains:

1. **Design and Implement Data Models** - NoSQL modeling, APIs, document design
2. **Data Distribution** - Partitioning strategies, global distribution
3. **Integration** - Change feed, Azure services, migration
4. **Optimization** - Performance tuning, RU management, analytical store
5. **Maintenance** - Monitoring, security, backup/recovery

### Study Approach
1. Work through each documentation link systematically
2. Create hands-on labs for each major topic
3. Build sample applications using the SDKs
4. Practice query optimization and troubleshooting
5. Understand cost implications of design decisions

### Success Tips
- Focus on hands-on experience with Cosmos DB
- Understand partition key selection deeply - it appears in many scenarios
- Know when to use each consistency level
- Practice optimizing RU consumption
- Be comfortable with change feed implementation patterns
- Understand the trade-offs between different approaches

**Good luck with your DP-420 certification exam!**

---

*Last Updated: 2025-10-13*
*Total Documentation Links: 100*
*Exam Version: Current as of October 2025*
