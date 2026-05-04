---
last-updated: 2026-05-03
---

# Microsoft Fabric Analytics Engineer (DP-600) - Fact Sheet

## Quick Reference

**Exam Code:** DP-600
**Duration:** 120 minutes
**Questions:** 40-60 questions
**Passing Score:** 700/1000
**Cost:** $165 USD
**Validity:** 3 years
**Difficulty:** ⭐⭐⭐⭐

## Exam Domains

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| Plan, implement, and manage a solution for data analytics | 10-15% | Fabric workspace, capacity, governance |
| Prepare and serve data | 40-45% | Lakehouses, data pipelines, semantic models |
| Implement and manage semantic models | 20-25% | Data modeling, DAX, optimization |
| Explore and analyze data | 20-25% | Power BI reports, KQL queries, notebooks |

## Microsoft Fabric Overview

**What is Microsoft Fabric?**
- Unified analytics platform (SaaS)
- Combines Data Engineering, Data Science, Data Warehousing, Real-time Analytics, Power BI
- Built on OneLake (unified data lake)
- Single capacity-based pricing model
- **[📖 Microsoft Fabric Documentation](https://learn.microsoft.com/en-us/fabric/)** - Complete Fabric guide
- **[📖 Fabric Get Started](https://learn.microsoft.com/en-us/fabric/get-started/microsoft-fabric-overview)** - Platform overview
- **[📖 Fabric Architecture](https://learn.microsoft.com/en-us/fabric/get-started/fabric-architecture)** - Technical architecture
- **[📖 Fabric Licensing](https://learn.microsoft.com/en-us/fabric/enterprise/licenses)** - Capacity and licensing

## OneLake

**OneLake: Unified Data Lake**
- Single, hierarchical namespace
- ADLS Gen2 compatible
- Automatic data organization
- Delta Lake format by default
- Shortcuts: Access data without copying
- **[📖 OneLake Overview](https://learn.microsoft.com/en-us/fabric/onelake/onelake-overview)** - OneLake concepts
- **[📖 OneLake Data Hub](https://learn.microsoft.com/en-us/fabric/get-started/onelake-data-hub)** - Data discovery
- **[📖 OneLake Shortcuts](https://learn.microsoft.com/en-us/fabric/onelake/onelake-shortcuts)** - Data federation
- **[📖 OneLake Security](https://learn.microsoft.com/en-us/fabric/onelake/onelake-security)** - Access control
- **[📖 OneLake Integration](https://learn.microsoft.com/en-us/fabric/onelake/onelake-azure-storage)** - Azure Storage integration

## Fabric Workspaces

**Workspaces**
- Containers for Fabric items
- Role-based access: Admin, Member, Contributor, Viewer
- Workspace capacity assignment
- Licensing modes: Trial, Premium, Fabric
- **[📖 Workspaces](https://learn.microsoft.com/en-us/fabric/get-started/workspaces)** - Workspace management
- **[📖 Workspace Roles](https://learn.microsoft.com/en-us/fabric/get-started/roles-workspaces)** - Permission levels
- **[📖 Workspace Identity](https://learn.microsoft.com/en-us/fabric/security/workspace-identity)** - Service principal access

## Lakehouses

**Lakehouse Architecture**
- Combines data lake (Parquet) and warehouse (SQL endpoint)
- Delta Lake format for ACID transactions
- Automatic metadata generation
- SQL analytics endpoint (read-only)
- Notebooks for data engineering
- **[📖 Lakehouse Overview](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-overview)** - Lakehouse concepts
- **[📖 Create Lakehouse](https://learn.microsoft.com/en-us/fabric/data-engineering/create-lakehouse)** - Setup guide
- **[📖 Lakehouse SQL Endpoint](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-sql-analytics-endpoint)** - SQL analytics
- **[📖 Tables in Lakehouse](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-tables)** - Table management
- **[📖 Lakehouse Files](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-files)** - File management
- **[📖 V-Order Optimization](https://learn.microsoft.com/en-us/fabric/data-engineering/delta-optimization-and-v-order)** - Performance optimization

## Data Factory in Fabric

**Data Pipelines**
- Copy data activity
- Dataflow Gen2 for transformations
- Pipeline orchestration
- Schedule and triggers
- Integration with Azure Data Factory
- **[📖 Data Factory Overview](https://learn.microsoft.com/en-us/fabric/data-factory/data-factory-overview)** - Pipeline concepts
- **[📖 Copy Activity](https://learn.microsoft.com/en-us/fabric/data-factory/copy-data-activity)** - Data ingestion
- **[📖 Dataflow Gen2](https://learn.microsoft.com/en-us/fabric/data-factory/dataflows-gen2-overview)** - Data transformation
- **[📖 Pipeline Activities](https://learn.microsoft.com/en-us/fabric/data-factory/activity-overview)** - Activity reference
- **[📖 Pipeline Monitoring](https://learn.microsoft.com/en-us/fabric/data-factory/monitor-pipeline-runs)** - Run monitoring
- **[📖 Pipeline Parameters](https://learn.microsoft.com/en-us/fabric/data-factory/parameters)** - Parameterization

## Notebooks and Spark

**Fabric Notebooks**
- Python, Scala, R, SQL languages
- Apache Spark engine
- Built-in data visualization
- Integration with lakehouses
- Notebook scheduling
- **[📖 Notebooks Overview](https://learn.microsoft.com/en-us/fabric/data-engineering/how-to-use-notebook)** - Notebook guide
- **[📖 Spark Compute](https://learn.microsoft.com/en-us/fabric/data-engineering/spark-compute)** - Spark configurations
- **[📖 Notebook Source Control](https://learn.microsoft.com/en-us/fabric/data-engineering/notebook-source-control-deployment)** - Git integration
- **[📖 PySpark Reference](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-pyspark-tutorial)** - PySpark tutorial
- **[📖 Delta Lake with Spark](https://learn.microsoft.com/en-us/fabric/data-engineering/delta-lake-overview)** - Delta operations

## Data Warehouse

**Fabric Warehouse**
- T-SQL analytics
- Columnar storage
- Separation of storage and compute
- Automatic query optimization
- Cross-database queries
- **[📖 Warehouse Overview](https://learn.microsoft.com/en-us/fabric/data-warehouse/data-warehousing)** - Warehouse concepts
- **[📖 Create Warehouse](https://learn.microsoft.com/en-us/fabric/data-warehouse/create-warehouse)** - Setup guide
- **[📖 Warehouse Tables](https://learn.microsoft.com/en-us/fabric/data-warehouse/tables)** - Table design
- **[📖 Warehouse Ingestion](https://learn.microsoft.com/en-us/fabric/data-warehouse/ingest-data)** - Data loading
- **[📖 Query Warehouse](https://learn.microsoft.com/en-us/fabric/data-warehouse/query-warehouse)** - T-SQL queries
- **[📖 Warehouse Security](https://learn.microsoft.com/en-us/fabric/data-warehouse/security)** - Row-level security

## Semantic Models (Power BI Datasets)

**Data Modeling**
- Import, DirectQuery, Composite modes
- Star schema design
- Relationships and cardinality
- Calculated columns and measures
- Hierarchies and display folders
- **[📖 Semantic Models Overview](https://learn.microsoft.com/en-us/fabric/data-warehouse/semantic-models)** - Modeling concepts
- **[📖 DirectLake](https://learn.microsoft.com/en-us/fabric/get-started/direct-lake-overview)** - Direct Lake mode
- **[📖 Data Modeling Best Practices](https://learn.microsoft.com/en-us/power-bi/guidance/star-schema)** - Star schema design
- **[📖 Relationships](https://learn.microsoft.com/en-us/power-bi/transform-model/desktop-relationships-understand)** - Relationship types
- **[📖 Calculated Columns vs Measures](https://learn.microsoft.com/en-us/power-bi/transform-model/desktop-calculated-columns)** - Calculations
- **[📖 Model Optimization](https://learn.microsoft.com/en-us/power-bi/guidance/import-modeling-data-reduction)** - Performance tuning

## DAX (Data Analysis Expressions)

**DAX Functions and Patterns**
- Aggregation: SUM, AVERAGE, COUNT, MIN, MAX
- Filter context: CALCULATE, FILTER, ALL, ALLEXCEPT
- Time intelligence: TOTALYTD, SAMEPERIODLASTYEAR, DATEADD
- Iterators: SUMX, AVERAGEX, COUNTX
- Relationship navigation: RELATED, RELATEDTABLE
- **[📖 DAX Reference](https://learn.microsoft.com/en-us/dax/)** - Complete DAX reference
- **[📖 CALCULATE Function](https://learn.microsoft.com/en-us/dax/calculate-function-dax)** - Context transition
- **[📖 Time Intelligence](https://learn.microsoft.com/en-us/power-bi/guidance/dax-time-intelligence-functions)** - Date functions
- **[📖 DAX Best Practices](https://learn.microsoft.com/en-us/power-bi/guidance/dax-best-practices)** - Performance patterns
- **[📖 Variables in DAX](https://learn.microsoft.com/en-us/dax/var-dax)** - VAR keyword

## Real-Time Analytics (KQL Database)

**Kusto Query Language (KQL)**
- Time-series analytics
- Streaming data ingestion
- Event-based data
- Fast queries on large datasets
- Integration with Event Hubs, IoT Hub
- **[📖 KQL Database Overview](https://learn.microsoft.com/en-us/fabric/real-time-analytics/create-database)** - KQL database
- **[📖 KQL Query Language](https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/)** - Query syntax
- **[📖 Data Ingestion](https://learn.microsoft.com/en-us/fabric/real-time-analytics/event-streams/overview)** - Eventstreams
- **[📖 KQL Queryset](https://learn.microsoft.com/en-us/fabric/real-time-analytics/kusto-query-set)** - Query management
- **[📖 Real-Time Dashboards](https://learn.microsoft.com/en-us/fabric/real-time-analytics/dashboard-real-time-create)** - Dashboard creation

## Power BI Integration

**Reports and Dashboards**
- Report design and visualization
- Paginated reports
- Real-time streaming
- Row-level security (RLS)
- Apps and content distribution
- **[📖 Power BI in Fabric](https://learn.microsoft.com/en-us/fabric/get-started/fabric-power-bi)** - Power BI integration
- **[📖 Create Reports](https://learn.microsoft.com/en-us/power-bi/create-reports/)** - Report design
- **[📖 Visualizations](https://learn.microsoft.com/en-us/power-bi/visuals/)** - Visual types
- **[📖 Row-Level Security](https://learn.microsoft.com/en-us/fabric/security/service-admin-row-level-security)** - RLS implementation
- **[📖 Paginated Reports](https://learn.microsoft.com/en-us/power-bi/paginated-reports/)** - Report Builder
- **[📖 Power BI Apps](https://learn.microsoft.com/en-us/power-bi/collaborate-share/service-create-distribute-apps)** - App deployment

## Data Science in Fabric

**Machine Learning**
- ML models with notebooks
- MLflow integration
- Model training and tracking
- Model deployment
- **[📖 Data Science Overview](https://learn.microsoft.com/en-us/fabric/data-science/data-science-overview)** - ML in Fabric
- **[📖 Train Models](https://learn.microsoft.com/en-us/fabric/data-science/train-models)** - Model training
- **[📖 MLflow](https://learn.microsoft.com/en-us/fabric/data-science/mlflow-overview)** - Experiment tracking
- **[📖 Model Registry](https://learn.microsoft.com/en-us/fabric/data-science/model-registry)** - Model management

## Security and Governance

**Access Control**
- Workspace roles and permissions
- Item permissions
- Row-level security (RLS)
- Object-level security (OLS)
- Dynamic data masking
- **[📖 Fabric Security](https://learn.microsoft.com/en-us/fabric/security/security-overview)** - Security overview
- **[📖 Workspace Permissions](https://learn.microsoft.com/en-us/fabric/get-started/roles-workspaces)** - Access control
- **[📖 Data Loss Prevention](https://learn.microsoft.com/en-us/fabric/governance/information-protection)** - Data protection
- **[📖 Endorsement](https://learn.microsoft.com/en-us/fabric/governance/endorsement-overview)** - Content certification
- **[📖 Sensitivity Labels](https://learn.microsoft.com/en-us/fabric/governance/sensitivity-labels)** - Data classification

## Monitoring and Optimization

**Performance Monitoring**
- Monitoring hub
- Capacity metrics app
- Query performance analysis
- Usage metrics
- Diagnostic logs
- **[📖 Monitoring Hub](https://learn.microsoft.com/en-us/fabric/admin/monitoring-hub)** - Centralized monitoring
- **[📖 Capacity Metrics](https://learn.microsoft.com/en-us/fabric/enterprise/metrics-app)** - Capacity analytics
- **[📖 Query Insights](https://learn.microsoft.com/en-us/fabric/data-warehouse/query-insights)** - Query performance
- **[📖 Performance Analyzer](https://learn.microsoft.com/en-us/power-bi/create-reports/desktop-performance-analyzer)** - Report optimization

## Data Integration Patterns

**Common Patterns**
- Medallion architecture (Bronze, Silver, Gold)
- Lambda architecture (batch + streaming)
- Hub-and-spoke data distribution
- Data mesh with domains
- ELT over ETL
- **[📖 Medallion Architecture](https://learn.microsoft.com/en-us/azure/databricks/lakehouse/medallion)** - Layered approach
- **[📖 Data Pipelines Best Practices](https://learn.microsoft.com/en-us/fabric/data-factory/data-factory-best-practices)** - Design patterns

## Migration to Fabric

**Migration Strategies**
- Power BI workspace migration
- Azure Synapse to Fabric
- Azure Data Factory to Fabric Data Factory
- On-premises data sources
- **[📖 Migrate to Fabric](https://learn.microsoft.com/en-us/fabric/get-started/migrate-to-fabric)** - Migration guide
- **[📖 Synapse Migration](https://learn.microsoft.com/en-us/fabric/data-warehouse/migration-synapse-dedicated-sql-pool)** - Synapse to Fabric

## Common Scenarios

**Scenario 1: Modern Data Warehouse**
- Solution: Lakehouse → Warehouse → Semantic Model → Power BI Reports

**Scenario 2: Real-Time Analytics Dashboard**
- Solution: Eventstream → KQL Database → Real-Time Dashboard

**Scenario 3: Self-Service BI**
- Solution: Lakehouse → DirectLake Semantic Model → Power BI Reports

**Scenario 4: Data Engineering Pipeline**
- Solution: Source → Data Pipeline → Dataflow Gen2 → Lakehouse (Bronze/Silver/Gold)

**Scenario 5: ML Model Deployment**
- Solution: Lakehouse → Notebook → MLflow → Model Registry → Batch Scoring

## Essential Commands

**Python (PySpark) in Notebooks:**
```python
# Read from lakehouse
df = spark.read.format("delta").load("Tables/tablename")

# Write to lakehouse
df.write.format("delta").mode("overwrite").save("Tables/tablename")

# Optimize Delta table
spark.sql("OPTIMIZE tablename")

# V-Order write
df.write.format("delta").option("optimizeWrite", "true").save("Tables/tablename")
```

**KQL Queries:**
```kql
// Time-series aggregation
TableName
| where Timestamp > ago(1h)
| summarize Count=count() by bin(Timestamp, 5m)
| render timechart

// Top N analysis
TableName
| summarize Total=sum(Amount) by Category
| top 10 by Total desc
```

**DAX Measures:**
```dax
// Time intelligence
Sales YTD = TOTALYTD(SUM(Sales[Amount]), Dates[Date])

// Context modification
Sales All Regions = CALCULATE(SUM(Sales[Amount]), ALL(Region))
```

## Exam Tips

**Keywords:**
- "Unified analytics" → Microsoft Fabric
- "Single data lake" → OneLake
- "ACID transactions on data lake" → Delta Lake format
- "No data movement" → Shortcuts
- "Fast semantic model" → DirectLake mode
- "Real-time analytics" → KQL Database, Eventstream
- "T-SQL analytics" → Warehouse
- "Python/Spark transformations" → Notebooks
- "Low-code ETL" → Dataflow Gen2

**Focus Areas:**
- Understand when to use Lakehouse vs Warehouse
- DirectLake mode and its benefits
- OneLake shortcuts for data federation
- Medallion architecture (Bronze, Silver, Gold layers)
- DAX context (filter context vs row context)
- KQL query syntax for time-series data
- Workspace roles and permissions
- Capacity management and optimization
- Data modeling best practices

**Study Strategy:**
- Hands-on: Create lakehouses, build data pipelines, design semantic models
- Practice DAX and KQL queries
- Understand DirectLake vs DirectQuery vs Import
- Know the Fabric item types and their use cases
- Memorize capacity SKUs and limits

---

**Pro Tip:** Microsoft Fabric is relatively new (GA November 2023). Focus on understanding the unified architecture, OneLake concepts, and how traditional Power BI/Synapse/Data Factory concepts map to Fabric!
