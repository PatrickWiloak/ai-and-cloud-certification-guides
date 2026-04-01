# Data Collection - AWS Data Analytics Specialty

## Overview

Data collection covers 18% of the DAS-C01 exam. This domain focuses on ingesting data from various sources into AWS analytics services using streaming and batch mechanisms.

**[📖 Analytics on AWS](https://aws.amazon.com/big-data/datalakes-and-analytics/)** - Overview of AWS analytics services

## Amazon Kinesis

### Kinesis Data Streams

Real-time data streaming service with shard-based architecture.

**[📖 Kinesis Data Streams Developer Guide](https://docs.aws.amazon.com/streams/latest/dev/introduction.html)** - Core concepts and usage

**Key Concepts:**
- **Shard**: Base throughput unit - 1 MB/sec input, 2 MB/sec output, 1,000 records/sec write
- **Partition Key**: Determines which shard receives the record via MD5 hash
- **Sequence Number**: Unique identifier assigned per record within a shard
- **Retention**: 24 hours default, extendable to 365 days (extra cost after 24h)
- **Data Record**: Partition key + sequence number + data blob (up to 1 MB)

**Producers:**
- **AWS SDK** - PutRecord (single), PutRecords (batch up to 500)
- **Kinesis Producer Library (KPL)** - High-throughput batching, aggregation, retries
- **Kinesis Agent** - Java-based agent for log file monitoring and streaming
- KPL uses micro-batching (RecordMaxBufferedTime default 100ms)
- KPL aggregation packs multiple user records into a single Kinesis record

**[📖 Using the KPL](https://docs.aws.amazon.com/streams/latest/dev/developing-producers-with-kpl.html)** - Producer Library configuration

**Consumers:**
- **Kinesis Client Library (KCL)** - Manages shard leases, checkpointing, load balancing
- **Lambda** - Event-driven processing with automatic scaling
- **Enhanced Fan-Out** - Dedicated 2 MB/sec per consumer per shard (push model via HTTP/2)
- Standard consumers share the 2 MB/sec read per shard (pull model via GetRecords)
- KCL uses DynamoDB for lease coordination and checkpointing

**[📖 KCL Consumer](https://docs.aws.amazon.com/streams/latest/dev/shared-throughput-kcl-consumers.html)** - Consumer development
**[📖 Enhanced Fan-Out](https://docs.aws.amazon.com/streams/latest/dev/enhanced-consumers.html)** - Dedicated throughput consumers

**Scaling:**
- Shard splitting: Divide a hot shard into two child shards
- Shard merging: Combine two cold shards into one
- UpdateShardCount API for automatic resharding
- On-demand capacity mode: Auto-scales up to 200 MB/sec write, 400 MB/sec read

**[📖 Resharding](https://docs.aws.amazon.com/streams/latest/dev/kinesis-using-sdk-java-resharding.html)** - Shard management

### Kinesis Data Firehose

Fully managed service for loading streaming data into destinations.

**[📖 Firehose Developer Guide](https://docs.aws.amazon.com/firehose/latest/dev/what-is-this-service.html)** - Delivery streams and buffering

**Key Facts:**
- Near real-time delivery (minimum 60-second buffer interval)
- Buffer size: 1-128 MB depending on destination
- No shard management - fully managed scaling
- Automatic retry with exponential backoff
- Source record backup to S3 (optional)

**Destinations:**
- Amazon S3
- Amazon Redshift (via S3 intermediate COPY)
- Amazon OpenSearch Service
- HTTP endpoints (Datadog, New Relic, Splunk, custom)
- Third-party: MongoDB, Snowflake

**Data Transformation:**
- Lambda functions for record transformation
- Transformation timeout: up to 5 minutes
- Source record backup preserves original data in S3
- Format conversion: JSON to Parquet or ORC (uses Glue Data Catalog schema)

**[📖 Data Transformation](https://docs.aws.amazon.com/firehose/latest/dev/data-transformation.html)** - Lambda-based transformation
**[📖 Format Conversion](https://docs.aws.amazon.com/firehose/latest/dev/record-format-conversion.html)** - Parquet and ORC conversion

**Compression:**
- S3 destination: GZIP, ZIP, Snappy, Hadoop Snappy
- Redshift destination: GZIP only (for COPY command)
- Format conversion destinations: Snappy (default for Parquet), GZIP, ZIP

### Kinesis Data Analytics

Real-time analytics using SQL or Apache Flink on streaming data.

**[📖 Kinesis Data Analytics for SQL](https://docs.aws.amazon.com/kinesisanalytics/latest/dev/what-is.html)** - SQL-based stream processing
**[📖 Kinesis Data Analytics for Flink](https://docs.aws.amazon.com/kinesisanalytics/latest/java/what-is.html)** - Apache Flink applications

**SQL Applications:**
- In-application streams and pumps
- Reference tables for data enrichment (from S3)
- Windowed queries: tumbling, sliding, stagger windows
- Anomaly detection with RANDOM_CUT_FOREST function

**Apache Flink Applications:**
- Java, Scala, Python, or SQL
- Exactly-once processing semantics with checkpointing
- Parallel processing with configurable parallelism
- State management for complex event processing
- Snapshots for application state recovery

## AWS IoT Core

**[📖 IoT Core Developer Guide](https://docs.aws.amazon.com/iot/latest/developerguide/what-is-aws-iot.html)** - IoT data ingestion

**Key Concepts:**
- **Device Gateway** - MQTT, HTTPS, WebSocket connections
- **Message Broker** - Pub/sub with topic-based routing
- **Rules Engine** - SQL-like rules to route data to AWS services
- **Device Shadow** - Virtual device state representation
- Rules can route to: Kinesis, S3, DynamoDB, Lambda, SNS, SQS, OpenSearch, Firehose

**Exam Tips:**
- IoT rules can transform and filter data before forwarding
- Use IoT Analytics for time-series analysis of IoT data
- Device shadows enable offline device state management

## AWS Database Migration Service (DMS)

**[📖 DMS User Guide](https://docs.aws.amazon.com/dms/latest/userguide/Welcome.html)** - Database migration

**Key Facts:**
- Replication instance runs migration tasks
- Source and target endpoints define connections
- Full load, CDC (change data capture), or full load + CDC
- Homogeneous (same engine) and heterogeneous migrations
- Schema Conversion Tool (SCT) for heterogeneous schema conversion
- Supports streaming replication to Kinesis Data Streams and Kafka

**For Analytics Use Cases:**
- Use DMS to stream database changes to Kinesis for real-time analytics
- CDC from operational databases to S3 for data lake ingestion
- S3 as a target - outputs CSV or Parquet files
- Redshift as a target - uses S3 intermediate stage

**[📖 DMS Best Practices](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_BestPractices.html)** - Migration best practices
**[📖 Using S3 as a Target](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Target.S3.html)** - S3 target configuration

## AWS Direct Connect and Snowball

### Direct Connect

**[📖 Direct Connect User Guide](https://docs.aws.amazon.com/directconnect/latest/UserGuide/Welcome.html)** - Dedicated network connections

- Dedicated network connection from on-premises to AWS
- 1 Gbps, 10 Gbps, or 100 Gbps connections
- Consistent network performance vs internet
- Use for large, ongoing data transfers to data lakes
- Can combine with VPN for encrypted transit

### AWS Snow Family

**[📖 Snowball Edge Guide](https://docs.aws.amazon.com/snowball/latest/developer-guide/whatisedge.html)** - Offline data transfer

- **Snowball Edge Storage Optimized**: 80 TB usable storage
- **Snowball Edge Compute Optimized**: 42 TB usable, GPU option
- **Snowcone**: 8 TB or 14 TB, smallest form factor
- **Snowmobile**: Up to 100 PB per truck
- Rule of thumb: Use Snow for transfers that would take more than 1 week over network
- OpsHub for managing Snow devices via GUI
- Can run EC2 and Lambda locally on Snowball Edge

## Data Collection Decision Tree

| Scenario | Service |
|----------|---------|
| Real-time streaming, custom consumers needed | Kinesis Data Streams |
| Streaming data load to S3/Redshift/OpenSearch | Kinesis Data Firehose |
| Real-time SQL analytics on streams | Kinesis Data Analytics |
| IoT device telemetry ingestion | IoT Core + Rules Engine |
| Database change capture for analytics | DMS with CDC |
| Petabyte-scale offline transfer | Snowball / Snowmobile |
| Consistent high-bandwidth transfer | Direct Connect |
| Log file collection from servers | Kinesis Agent or CloudWatch Agent |

## Common Exam Patterns

1. **"Real-time" + "load to S3"** - Kinesis Data Firehose (near real-time)
2. **"Real-time" + "custom processing"** - Kinesis Data Streams + Lambda/KCL
3. **"Real-time" + "SQL analytics"** - Kinesis Data Analytics
4. **"IoT" + "route to multiple services"** - IoT Core Rules Engine
5. **"Database changes" + "streaming"** - DMS CDC to Kinesis
6. **"Large offline transfer"** - Snow Family
7. **"Ordered data processing"** - Kinesis Data Streams with partition keys
8. **"Multiple consumers, dedicated throughput"** - Enhanced Fan-Out
