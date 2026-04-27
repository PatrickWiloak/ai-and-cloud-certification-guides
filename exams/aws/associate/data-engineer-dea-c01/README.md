# AWS Certified Data Engineer - Associate (DEA-C01)

## Overview

The AWS Certified Data Engineer - Associate (DEA-C01) validates the skills needed to ingest, transform, store, operate, and secure data pipelines on AWS. It replaces both the retired **AWS Data Analytics Specialty (DAS-C01)** and the retired **AWS Database Specialty (DBS-C01)**, consolidating data-engineering expertise into a single Associate-tier credential.

This cert targets data engineers, analytics engineers, and ETL developers with 1-2 years of hands-on experience building data pipelines on AWS, plus 2-3 years of broader data engineering experience.

---

## Quick Reference

| Detail | Info |
|---|---|
| **Exam Code** | DEA-C01 |
| **Full Name** | AWS Certified Data Engineer - Associate |
| **Provider** | Amazon Web Services |
| **Duration** | 130 minutes |
| **Questions** | 65 (50 scored + 15 unscored) |
| **Format** | Multiple choice and multiple response |
| **Passing Score** | 720 / 1000 |
| **Cost** | $150 USD ($75 with 50% discount voucher for prior AWS cert holders) |
| **Validity** | 3 years |
| **Delivery** | Pearson VUE testing center or online proctoring |
| **Prerequisites** | Recommended: 2-3 years of data engineering experience plus 1-2 years building data pipelines on AWS |
| **Launched** | March 12, 2024 (general availability) |

**[📖 Official AWS Data Engineer - Associate page](https://aws.amazon.com/certification/certified-data-engineer-associate/)**

---

## Exam Domains

| # | Domain | Weight |
|---|---|---|
| 1 | Data Ingestion and Transformation | 34% |
| 2 | Data Store Management | 26% |
| 3 | Data Operations and Support | 22% |
| 4 | Data Security and Governance | 18% |

### Domain 1 - Data Ingestion and Transformation (34%)

The largest and most weighted domain. You must understand how to:

- Ingest data from streaming, batch, and database sources (Kinesis Data Streams, Kinesis Data Firehose, MSK, DMS, AppFlow, Glue, Lambda)
- Transform data with AWS Glue ETL, Amazon EMR (Spark, Hive, Presto), Lambda, Step Functions
- Handle late-arriving data, schema evolution, idempotency, and replays
- Choose between micro-batch, batch, and streaming patterns
- Orchestrate workflows with Step Functions, MWAA (Managed Apache Airflow), and EventBridge

### Domain 2 - Data Store Management (26%)

Choosing and operating the right data store for the workload:

- Object storage (S3 storage classes, partitioning strategies, file formats - Parquet, ORC, Avro, JSON)
- Data warehouses (Amazon Redshift, Redshift Serverless, RA3 nodes, materialized views, distribution and sort keys)
- Operational databases (RDS, Aurora, DynamoDB, ElastiCache)
- Data catalogs and lakes (AWS Glue Data Catalog, Lake Formation, Iceberg / Hudi / Delta on S3)
- Search and analytics stores (OpenSearch, OpenSearch Serverless)

### Domain 3 - Data Operations and Support (22%)

Running data pipelines reliably in production:

- Athena for ad-hoc and pipeline querying (Athena workgroups, partition projection, CTAS / INSERT INTO)
- QuickSight for analytics and visualization
- CloudWatch metrics, alarms, Logs Insights, and EventBridge for pipeline monitoring
- Cost monitoring and FinOps (S3 Storage Lens, Cost Explorer, billing alarms)
- Quality and observability (Glue Data Quality, Deequ, custom validation steps)
- Recovery from failures (DLQs, SQS retries, EMR step retries, Step Functions error handling)

### Domain 4 - Data Security and Governance (18%)

Securing data end to end:

- IAM (least privilege, identity-based vs resource-based policies, Lake Formation permissions, Glue resource policies)
- Encryption (KMS keys, S3 encryption (SSE-S3, SSE-KMS, DSSE-KMS), RDS / Redshift / DynamoDB encryption, in-transit TLS)
- Network controls (VPC endpoints / PrivateLink for Glue, S3, Redshift, OpenSearch; subnets and security groups)
- Data governance (Lake Formation tag-based access control, row / column / cell-level security, data sharing across accounts)
- Compliance and discovery (Macie for sensitive-data discovery, AWS Config for posture, CloudTrail for audit)

---

## Study Materials in This Guide

| File | Description |
|---|---|
| [fact-sheet.md](fact-sheet.md) | Deep reference with documentation links and high-yield facts |
| [notes/01-data-ingestion.md](notes/01-data-ingestion.md) | Streaming and batch ingestion (Kinesis, MSK, DMS, AppFlow, Glue) |
| [notes/02-data-transformation.md](notes/02-data-transformation.md) | Glue ETL, EMR, Lambda transforms, Step Functions, MWAA |
| [notes/03-data-stores.md](notes/03-data-stores.md) | S3, Redshift, RDS, DynamoDB, Lake Formation, OpenSearch |
| [notes/04-data-operations.md](notes/04-data-operations.md) | Athena, QuickSight, CloudWatch, EventBridge, observability |
| [notes/05-security-governance.md](notes/05-security-governance.md) | IAM, KMS, Lake Formation, network controls, compliance |
| [notes/06-architecture-patterns.md](notes/06-architecture-patterns.md) | Lakehouse, lambda, streaming, cost optimization, recovery patterns |
| [practice-plan.md](practice-plan.md) | 8-week study plan with weekly milestones |
| [scenarios.md](scenarios.md) | 20 exam-style scenarios mapped to domains |
| [strategy.md](strategy.md) | Exam-day approach, time allocation, common traps |

---

## Recommended Study Time

| Background | Estimated Prep Time |
|---|---|
| Senior data engineer with hands-on AWS data pipeline experience | 4-6 weeks |
| Data engineer with general AWS experience but limited Glue/Redshift exposure | 8-10 weeks |
| Career-changer from non-AWS data tooling (Snowflake, GCP, Databricks) | 10-12 weeks |
| New to data engineering | Take Cloud Practitioner first; budget 12-16 weeks for DEA-C01 after |

Plan on 2-3 hours per day of focused study.

---

## Prerequisites and Recommended Prior Certs

DEA-C01 has no formal prerequisites. AWS recommends:

- **AWS Cloud Practitioner (CLF-C02)** if you are new to AWS
- **AWS Solutions Architect Associate (SAA-C03)** strongly complementary for architectural context
- General data engineering experience: SQL, Python or Java/Scala, Spark, ETL fundamentals

If you held the retired DAS-C01 or DBS-C01, your DEA-C01 prep will compress significantly. Most DAS-C01 material maps directly. DBS-C01's database operations content is partially covered.

---

## Key Differences vs. Retired DAS-C01 and DBS-C01

- **Level**: Associate (vs. Specialty for both retired exams)
- **Scope**: Broader than DAS-C01 (adds operational databases, more Glue / DMS coverage) and broader than DBS-C01 (adds streaming, lakehouse, analytics)
- **Modern services**: Includes current Glue (3.0/4.0/5.0 capabilities), Redshift Serverless, Athena V3 engine, Lake Formation tag-based access, Iceberg/Hudi/Delta lakehouse formats
- **Career alignment**: Maps to today's "data engineer" job titles, not the older "DBA" or "data analytics specialist" framing

---

## Companion Materials in This Repo

- **[Practice Questions](../../../../resources/practice-questions/aws-data-engineer-associate.md)** - sample questions
- **[AWS CLI Cheat Sheet](../../../../resources/cli-cheat-sheet-aws.md)** - common Glue, S3, Redshift commands
- **[Data Engineer Roadmap](../../../../resources/certification-roadmap-data-engineer.md)** - career path that includes DEA-C01
- **[Data Pipeline Architecture Pattern](../../../../resources/architecture-patterns/data-pipeline-etl.md)** - cross-cloud pipeline reference
- **[Lakehouse Architecture Pattern](../../../../resources/architecture-patterns/lakehouse-architecture.md)** - lakehouse design

---

## Exam Day Tips

1. **Watch domain weights.** Domain 1 (Ingestion/Transformation) is 34%; weak coverage there can sink you. Domain 4 (Security/Governance) is only 18% but the questions are precise.
2. **Read every word.** Scenario questions hide constraints (cost target, latency SLA, compliance requirement) in the body. Skim at your peril.
3. **Eliminate first.** Most questions have 1-2 obviously wrong options. Knock those out, then reason through the remaining options.
4. **Pick the AWS-native solution.** When in doubt, the answer that uses managed AWS services (Glue, Lake Formation, Athena) over self-managed Spark on EC2 is usually correct.
5. **Cost matters.** Many questions have a "most cost-effective" qualifier. S3 lifecycle policies, Athena partition projection, and Spot pricing on EMR are common cost levers.
6. **Time: ~2 minutes per question.** Flag hard ones and come back. 130 minutes for 65 questions.

Good luck.
