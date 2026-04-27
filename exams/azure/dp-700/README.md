# Microsoft Certified: Fabric Data Engineer Associate (DP-700)

## Overview

The Fabric Data Engineer Associate certification validates the ability to ingest, transform, secure, and serve analytical data using Microsoft Fabric. Fabric is Microsoft's unified analytics platform combining Power BI, Synapse, Data Factory, and Lakehouse (OneLake) into a SaaS experience.

DP-700 launched in late 2024 as Microsoft's modern data-engineering credential, positioned alongside / above the older DP-203 (Azure Data Engineer Associate, which remains active but more Synapse / Azure Data Lake-focused).

---

## Quick Reference

| Detail | Info |
|---|---|
| **Exam Code** | DP-700 |
| **Full Name** | Microsoft Certified: Fabric Data Engineer Associate |
| **Provider** | Microsoft |
| **Format** | Multiple choice, multiple response, case studies, Labs (some sittings) |
| **Duration** | 100 minutes |
| **Cost** | $165 USD |
| **Validity** | 1 year (renewable for free annually via Microsoft Learn assessment) |
| **Passing Score** | 700 / 1000 |
| **Languages** | English (more added over time) |

**[📖 Official DP-700 page](https://learn.microsoft.com/credentials/certifications/fabric-data-engineer-associate/)**
**[📖 Microsoft Learn DP-700 Study Guide](https://learn.microsoft.com/credentials/certifications/exams/dp-700/)**

---

## Exam Domains

Per the official Skills Measured outline:

| # | Domain | Weight |
|---|---|---|
| 1 | Implement and manage an analytics solution | 30-35% |
| 2 | Ingest and transform data | 30-35% |
| 3 | Monitor and optimize an analytics solution | 30-35% |

---

## Key Topics

### Domain 1 - Implement and manage an analytics solution

- Microsoft Fabric workspace administration, capacity management, lifecycle (Dev/Test/Prod via deployment pipelines)
- Version control with Git integration
- Security: workspace roles, item permissions, sensitivity labels, OneLake security
- CI/CD via Fabric Deployment Pipelines

### Domain 2 - Ingest and transform data

- **Lakehouse** (Files + Tables, Delta format) and **Warehouse** (T-SQL endpoints)
- **Dataflows Gen2** (Power Query) - low-code transforms
- **Data Pipelines** (Data Factory in Fabric) - orchestration
- **Notebooks** with Spark - PySpark / Spark SQL transforms
- **Eventstream** for streaming ingestion
- **Shortcuts** to other Fabric workspaces or external data (S3, ADLS, Dataverse)
- **Mirroring** - automatic CDC from operational DBs (Cosmos DB, Snowflake, Azure SQL DB)

### Domain 3 - Monitor and optimize an analytics solution

- Monitoring hub, capacity metrics
- Optimizing Lakehouse / Warehouse query performance
- Pipeline run monitoring
- Spark job tuning
- Cost optimization within capacity units (CU)

---

## Study Materials in This Guide

| File | Description |
|---|---|
| [fact-sheet.md](fact-sheet.md) | Reference with Microsoft Learn links and high-yield facts |
| [practice-plan.md](practice-plan.md) | 6-week study plan |
| [scenarios.md](scenarios.md) | 12 exam-style scenarios |
| [notes/01-fabric-architecture-and-workspaces.md](notes/01-fabric-architecture-and-workspaces.md) | Fabric concepts, OneLake, capacity |
| [notes/02-ingestion-pipelines-eventstream.md](notes/02-ingestion-pipelines-eventstream.md) | Pipelines, Dataflows, Eventstream, Mirroring |
| [notes/03-lakehouse-warehouse-notebooks.md](notes/03-lakehouse-warehouse-notebooks.md) | Lakehouse, Warehouse, Spark notebooks |
| [notes/04-security-governance-deployment.md](notes/04-security-governance-deployment.md) | RBAC, sensitivity labels, deployment pipelines, Git |
| [notes/05-monitoring-optimization.md](notes/05-monitoring-optimization.md) | Monitoring hub, capacity tuning, query optimization |

---

## Recommended Study Time

| Background | Estimated Prep Time |
|---|---|
| Existing Azure data engineer (DP-203 or similar) | 4-6 weeks |
| Power BI / Power Query background | 6-8 weeks |
| New to Microsoft data platform | 10-12 weeks |

---

## Hands-on Setup

- **[Microsoft Fabric Free Trial](https://learn.microsoft.com/fabric/get-started/fabric-trial)** - 60-day free trial of Fabric capacity
- Create a workspace, ingest a sample dataset, build a Lakehouse, run a Dataflow, write a Spark notebook
- Try all four ingestion patterns: Pipelines, Dataflows Gen2, Notebooks, Eventstream

---

## Companion Materials

- **[Azure Data Engineer DP-203](../dp-203/)** - covers Synapse / ADLS Gen2 (older but still active)
- **[Azure DP-600](../dp-600/)** - Fabric Analytics Engineer (overlaps with DP-700 on platform basics)
- **[Service Comparison: Databases](../../../resources/service-comparison-databases.md)**
- **[AWS DEA-C01](../../aws/associate/data-engineer-dea-c01/)** - AWS counterpart
- **[Databricks DE Associate](../../databricks/data-engineer-associate/)** - lakehouse counterpart

---

## After DP-700

- **Fabric Analytics Engineer (DP-600)** - covers Fabric from analyst angle
- **Azure Data Scientist (DP-100)** - ML / data science track
- **Azure Solutions Architect Expert (AZ-305)** - for architects designing Fabric solutions
