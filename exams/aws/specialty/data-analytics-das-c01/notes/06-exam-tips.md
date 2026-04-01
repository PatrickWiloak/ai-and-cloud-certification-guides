# Exam Tips - AWS Data Analytics Specialty

## Overview

This guide covers common patterns, decision trees, and quick-reference tips for the DAS-C01 exam. Use this as a final review before the exam.

## Service Selection Decision Trees

### Streaming Ingestion

```
Need to stream data into AWS?
├── Need custom consumers or ordering? -> Kinesis Data Streams
├── Just load to S3/Redshift/OpenSearch? -> Kinesis Data Firehose
├── Real-time SQL on streams? -> Kinesis Data Analytics (SQL)
├── Complex stream processing (stateful)? -> Kinesis Data Analytics (Flink)
└── IoT device data? -> IoT Core -> Rules Engine -> Kinesis/S3/DynamoDB
```

### Batch Processing

```
Need to process batch data?
├── Simple transform on single file? -> Lambda (< 15 min, < 10 GB)
├── Serverless ETL pipeline? -> Glue ETL
├── Need Spark/Hive at PB scale? -> EMR
├── One-time schema conversion? -> Glue Crawler + Glue ETL
└── Orchestrate multi-step pipeline? -> Step Functions
```

### Query and Analysis

```
Need to query data?
├── Ad-hoc SQL on S3 data? -> Athena
├── Complex analytics with joins? -> Redshift
├── Extend Redshift to S3? -> Redshift Spectrum
├── Full-text search or log analytics? -> OpenSearch
├── Interactive queries across sources? -> Athena Federated Query
└── Business dashboards? -> QuickSight
```

### Database Selection for Analytics

```
What type of analytics data store?
├── Structured, complex queries? -> Redshift
├── Semi-structured, full-text search? -> OpenSearch
├── Key-value with real-time access? -> DynamoDB
├── Time-series data? -> Timestream
├── Graph relationships? -> Neptune
└── Data lake (all formats)? -> S3 + Lake Formation
```

## High-Frequency Exam Topics

### Kinesis Data Streams vs Firehose

| Question Keyword | Answer |
|-----------------|--------|
| Custom processing logic | Data Streams |
| Load directly to S3/Redshift | Firehose |
| Real-time (milliseconds) | Data Streams |
| Near real-time (60 sec minimum) | Firehose |
| Manage scaling manually | Data Streams (provisioned) |
| Fully managed, no scaling | Firehose |
| Multiple consumers needed | Data Streams |
| Transform before delivery | Firehose (Lambda) |

### S3 Format Selection

| Question Keyword | Answer |
|-----------------|--------|
| Athena query performance | Parquet |
| Hive on EMR | ORC |
| Schema evolution needed | Avro |
| Human-readable | CSV/JSON |
| Write-heavy streaming | Avro or JSON |
| Read-heavy analytics | Parquet or ORC |

### Glue vs EMR

| Question Keyword | Answer |
|-----------------|--------|
| Serverless ETL | Glue |
| Custom Spark libraries | EMR |
| PB-scale processing | EMR |
| Schema discovery | Glue Crawler |
| Incremental ETL | Glue (bookmarks) |
| Interactive notebooks | EMR (or Athena Spark) |
| Hive, Presto, HBase | EMR |
| Cost-sensitive small jobs | Glue |

## Key Numbers to Remember

| Metric | Value |
|--------|-------|
| Kinesis shard write capacity | 1 MB/sec or 1,000 records/sec |
| Kinesis shard read capacity | 2 MB/sec (shared), 2 MB/sec per consumer (enhanced) |
| Kinesis max record size | 1 MB |
| Kinesis retention | 24 hours - 365 days |
| Firehose buffer interval | 60 - 900 seconds |
| Firehose buffer size | 1 - 128 MB |
| Lambda timeout | 15 minutes |
| Lambda memory | Up to 10,240 MB |
| Athena query timeout | 30 minutes |
| Athena cost | $5 per TB scanned |
| Redshift Spectrum cost | $5 per TB scanned |
| S3 Standard-IA min duration | 30 days |
| Glacier Flexible retrieval | 1 - 12 hours |
| Glacier Deep Archive retrieval | 12 - 48 hours |
| DynamoDB export | Does not consume read capacity |
| QuickSight SPICE | 10 GB/user Standard, 500 GB/user Enterprise |

## Common Traps and Distractors

1. **"Real-time" does not always mean Kinesis Data Streams** - If loading to S3, Firehose is sufficient even though it has a 60-sec buffer
2. **Athena LIMIT does not reduce cost** - Full partition scan still occurs; use partitions and columnar formats to reduce cost
3. **Redshift COPY is always preferred over INSERT** - COPY is parallel, INSERT is single-row
4. **Glue Crawler does not transform data** - It only discovers schema and updates the catalog
5. **EMR core nodes should not use Spot** - HDFS data is on core nodes; losing them loses data
6. **Kinesis Analytics SQL is being replaced by Flink** - But SQL questions still appear on the exam
7. **Lake Formation does not replace IAM** - It works alongside IAM; users still need basic IAM permissions
8. **S3 Select is not a replacement for Athena** - S3 Select works on single objects; Athena queries across objects
9. **Redshift Enhanced VPC Routing** - Does not improve performance; it routes traffic through VPC for security
10. **DynamoDB Streams vs Kinesis adapter** - Streams has 24h retention; use Kinesis adapter for longer retention needs

## Last-Minute Review Checklist

- [ ] Kinesis family: Streams vs Firehose vs Analytics - when to use each
- [ ] S3 storage classes and lifecycle transitions
- [ ] Glue components: Crawler, Data Catalog, ETL, bookmarks
- [ ] EMR node types and Spot instance strategy
- [ ] Redshift: distribution styles, sort keys, COPY command, WLM
- [ ] Athena: cost optimization (Parquet, partitions, compression)
- [ ] Lake Formation: permission model, LF-Tags, cross-account
- [ ] Encryption: SSE-S3 vs SSE-KMS vs SSE-C - when to use each
- [ ] VPC endpoints: Gateway (S3, DynamoDB) vs Interface (everything else)
- [ ] QuickSight: SPICE, RLS, CLS, embedding
- [ ] OpenSearch: UltraWarm, log analytics pipeline
- [ ] Step Functions vs Glue Workflows for orchestration
