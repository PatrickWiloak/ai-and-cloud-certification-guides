# Lakehouse Platform - Databricks Data Engineer Associate

## Overview

This section covers the Databricks Lakehouse Platform, which represents 24% of the exam. You need to understand Lakehouse architecture, workspace navigation, compute resources, and how Databricks relates to Apache Spark.

**[📖 Lakehouse Architecture](https://docs.databricks.com/en/lakehouse/index.html)** - Lakehouse concepts and design
**[📖 Databricks Architecture](https://docs.databricks.com/en/getting-started/overview.html)** - Platform architecture overview

## Key Topics

### 1. Lakehouse Architecture

The Lakehouse combines the reliability and governance of data warehouses with the flexibility and scale of data lakes. It is built on open formats and supports all data workloads.

**[📖 What is a Data Lakehouse?](https://docs.databricks.com/en/lakehouse/index.html)** - Core Lakehouse concepts

**Key Concepts:**
- Lakehouse sits on top of cloud object storage (S3, ADLS, GCS)
- Delta Lake provides the storage layer with ACID transactions
- Single platform for BI, data science, ML, and streaming
- Open data formats prevent vendor lock-in (Delta Lake uses Parquet)
- Schema enforcement prevents bad data from entering tables
- Schema evolution allows tables to adapt to new columns over time

**Lakehouse vs Data Warehouse vs Data Lake:**

| Feature | Data Lake | Data Warehouse | Lakehouse |
|---------|-----------|----------------|-----------|
| Data Types | All types | Structured only | All types |
| ACID Transactions | No | Yes | Yes |
| Schema Enforcement | Schema-on-read | Schema-on-write | Both |
| Storage Cost | Low | High | Low |
| BI Support | Limited | Strong | Strong |
| ML/AI Support | Strong | Limited | Strong |
| Governance | Weak | Strong | Strong |

### 2. Databricks Workspace

The workspace is the central interface for all Databricks operations. It organizes notebooks, repos, jobs, and data assets.

**[📖 Workspace Overview](https://docs.databricks.com/en/workspace/index.html)** - Workspace navigation and organization
**[📖 Notebooks](https://docs.databricks.com/en/notebooks/index.html)** - Notebook development environment

**Key Concepts:**
- Workspace organizes all development assets in a folder structure
- Notebooks support Python, SQL, Scala, and R in the same notebook
- Magic commands switch language contexts: `%sql`, `%python`, `%scala`, `%r`, `%md`
- `%run` executes another notebook in the current execution context
- `dbutils` provides utilities for file operations, secrets, and widgets
  - `dbutils.fs.ls()` - list files
  - `dbutils.secrets.get()` - retrieve secrets
  - `dbutils.widgets` - create parameterized notebooks
- Workspace supports folder-level permissions for access control

### 3. Databricks Repos (Git Integration)

**[📖 Databricks Repos](https://docs.databricks.com/en/repos/index.html)** - Git integration for version control

**Key Concepts:**
- Repos integrate with Git providers: GitHub, GitLab, Bitbucket, Azure DevOps
- Support standard Git operations: clone, commit, push, pull, branch, merge
- Enable collaborative development with version control
- CI/CD integration for automated testing and deployment
- Repos can be configured at workspace or user level

### 4. Compute Resources

Understanding compute types and when to use each is critical for this exam domain.

**[📖 Compute Overview](https://docs.databricks.com/en/compute/index.html)** - Compute configuration and management
**[📖 SQL Warehouses](https://docs.databricks.com/en/sql/admin/sql-endpoints.html)** - SQL-optimized compute
**[📖 Cluster Pools](https://docs.databricks.com/en/compute/pool-index.html)** - Instance pools for faster startup

**Cluster Types:**

| Type | Use Case | Lifecycle | Cost |
|------|----------|-----------|------|
| All-purpose | Interactive development | Long-running, shared | Higher |
| Job cluster | Automated jobs | Created per run, terminated after | Lower |
| SQL warehouse | SQL queries and BI | Managed, auto-stop | Varies |
| Serverless | Any workload | Fully managed | Pay-per-use |

**Key Concepts:**
- All-purpose clusters are for interactive notebook development
- Job clusters are created for each job run and terminated after - more cost-effective
- SQL warehouses are optimized for SQL queries and BI tool connectivity
- Serverless compute eliminates cluster management overhead
- Autoscaling adjusts worker count between min and max based on load
- Cluster pools keep idle instances ready for faster cluster startup
- Spot instances reduce cost but may be interrupted by the cloud provider

### 5. Databricks Runtime

**[📖 Runtime Versions](https://docs.databricks.com/en/release-notes/runtime/index.html)** - Runtime release notes

**Key Concepts:**
- Databricks Runtime includes Apache Spark, Delta Lake, and optimized libraries
- ML Runtime adds pre-installed ML libraries (scikit-learn, TensorFlow, PyTorch)
- GPU Runtime enables deep learning workloads
- Photon is a native vectorized query engine for faster SQL performance
- Runtime versions should match across development and production
- Long Term Support (LTS) versions receive extended maintenance

### 6. Spark and Databricks Relationship

**[📖 Apache Spark on Databricks](https://docs.databricks.com/en/getting-started/overview.html)** - How Databricks extends Spark

**Key Concepts:**
- Databricks is built on top of Apache Spark
- Adds managed infrastructure, governance, and collaboration features
- Delta Lake extends Spark with ACID transactions and time travel
- Photon replaces the Spark SQL engine with a faster native engine
- Spark DataFrames and SQL are the primary data manipulation interfaces
- Spark context (`spark`) is pre-configured in every Databricks notebook

## Exam Tips for This Domain

1. **Know the Lakehouse advantages** - Questions often ask why Lakehouse is better than a data lake or warehouse for specific scenarios
2. **Understand compute types** - Know when to recommend all-purpose vs job clusters vs SQL warehouses
3. **Magic commands** - Be familiar with `%run`, `%sql`, and `dbutils` utilities
4. **Cluster configuration** - Understand autoscaling, spot instances, and pools
5. **Serverless compute** - Know when serverless is the best option (minimal management needed)
6. **Open formats** - Lakehouse uses open formats like Parquet via Delta Lake to avoid lock-in

## Practice Questions to Consider

- When should you use a job cluster instead of an all-purpose cluster?
- What are the advantages of the Lakehouse architecture over a traditional data warehouse?
- How do you share code between notebooks using Databricks Repos?
- What is the difference between Photon and standard Spark SQL execution?
- How does autoscaling work and when would you configure a fixed-size cluster instead?

## Documentation Links Summary

| Topic | Link |
|-------|------|
| Lakehouse Architecture | [docs.databricks.com/en/lakehouse/index.html](https://docs.databricks.com/en/lakehouse/index.html) |
| Workspace | [docs.databricks.com/en/workspace/index.html](https://docs.databricks.com/en/workspace/index.html) |
| Notebooks | [docs.databricks.com/en/notebooks/index.html](https://docs.databricks.com/en/notebooks/index.html) |
| Repos | [docs.databricks.com/en/repos/index.html](https://docs.databricks.com/en/repos/index.html) |
| Compute | [docs.databricks.com/en/compute/index.html](https://docs.databricks.com/en/compute/index.html) |
| SQL Warehouses | [docs.databricks.com/en/sql/admin/sql-endpoints.html](https://docs.databricks.com/en/sql/admin/sql-endpoints.html) |
| Runtime Versions | [docs.databricks.com/en/release-notes/runtime/index.html](https://docs.databricks.com/en/release-notes/runtime/index.html) |
