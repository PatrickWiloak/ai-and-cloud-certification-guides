# Service Comparison - Messaging and Queues

## Overview

This guide compares messaging, queuing, streaming, and notification services across AWS, Azure, and Google Cloud. Messaging is a core component of distributed architectures and a frequent topic on cloud certification exams.

---

## Message Queue Services

### SQS vs Azure Service Bus vs Pub/Sub

| Feature | AWS SQS | Azure Service Bus | Google Cloud Pub/Sub |
|---------|---------|-------------------|----------------------|
| Type | Message queue | Enterprise message broker | Pub/Sub messaging |
| Model | Point-to-point (queue) | Queue + Topic/Subscription | Topic/Subscription |
| Message Size | 256 KB (up to 2 GB with S3 extended) | 256 KB (Standard), 100 MB (Premium) | 10 MB |
| Message Retention | 1 minute to 14 days (default 4 days) | Up to 14 days (configurable) | 7 days (default), up to 31 days |
| FIFO Support | Yes (FIFO queues) | Yes (sessions for ordering) | Yes (ordering keys) |
| Exactly-Once | Yes (FIFO queues, deduplication) | Duplicate detection (session) | Yes (exactly-once delivery) |
| Dead Letter Queue | Yes | Yes (DLQ per queue/subscription) | Yes (dead-letter topic) |
| Delay/Schedule | Up to 15 minutes (delay queues) | Scheduled messages (any future time) | N/A (use Cloud Scheduler) |
| Batching | Up to 10 messages (SendMessageBatch) | Batch operations | Batch publish |
| Throughput | Nearly unlimited (Standard), 300 TPS (FIFO, up to 30K with batching) | 1-16 messaging units (Premium) | Nearly unlimited |
| Transactions | N/A | Yes (send + complete in transaction) | N/A |
| Message Filtering | N/A (consumer-side) | Subscription filters (SQL, correlation) | Subscription filters (attribute-based) |
| Protocol | HTTP/HTTPS (AWS SDK) | AMQP 1.0, HTTP/REST | HTTP/REST, gRPC |
| Pricing | Per request (per million messages) | Per messaging unit (Premium) or operations (Standard) | Per data volume (per TB) |
| Free Tier | 1M requests/month | N/A | 10 GB/month |

### Queue Semantics Deep Dive

| Semantic | AWS SQS | Azure Service Bus | Google Pub/Sub |
|----------|---------|-------------------|----------------|
| Visibility Timeout | 0-12 hours (default 30s) | Lock duration (5s-5min, renewable) | Ack deadline (10s-600s, extendable) |
| Long Polling | Yes (up to 20 seconds) | ReceiveAndDelete or PeekLock | Streaming pull (gRPC) |
| Poison Message Handling | MaxReceiveCount -> DLQ | MaxDeliveryCount -> DLQ | Max delivery attempts -> dead-letter |
| Message Deduplication | FIFO (5-minute window, content/ID based) | Duplicate detection (session window) | Ordering key + message ID |
| Priority Queues | Multiple queues (manual priority) | N/A (use sessions or separate queues) | N/A (use separate subscriptions) |
| Message Groups | FIFO (MessageGroupId) | Sessions (SessionId) | Ordering keys |

---

## Pub/Sub and Topic-Based Messaging

### SNS vs Service Bus Topics vs Pub/Sub Topics

| Feature | AWS SNS | Azure Service Bus Topics | Google Cloud Pub/Sub |
|---------|---------|--------------------------|----------------------|
| Model | Fan-out (topic -> subscriptions) | Fan-out (topic -> subscriptions) | Fan-out (topic -> subscriptions) |
| Max Subscriptions | 12.5 million per topic | 2,000 per topic | 10,000 per topic |
| Message Filtering | Subscription filter policies (attribute-based) | SQL filters, correlation filters | Attribute-based filters |
| Push Delivery | HTTP/S, email, SMS, Lambda, SQS | N/A (pull-based) | Push (HTTP/S) and Pull |
| Protocol Support | HTTP/S, email, SMS, SQS, Lambda, Kinesis Firehose | AMQP 1.0, HTTP/REST | HTTP/REST, gRPC |
| Message Ordering | FIFO topics | Sessions | Ordering keys |
| Message Size | 256 KB | 256 KB (Standard), 100 MB (Premium) | 10 MB |
| Fan-out Pattern | SNS -> multiple SQS queues | Topic -> multiple subscriptions | Topic -> multiple subscriptions |
| Cross-Region | SNS -> SQS (cross-region) | Geo-DR (paired namespace) | Global (auto-replication) |
| Schema Validation | N/A | N/A | Schema validation (Avro, Protocol Buffers) |

### Fan-Out Architecture Patterns

| Pattern | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Simple Fan-Out | SNS -> multiple SQS | Topic -> multiple subscriptions | Topic -> multiple subscriptions |
| Filter Fan-Out | SNS filter policies | Subscription SQL filters | Subscription attribute filters |
| Event-Driven Fan-Out | EventBridge -> multiple targets | Event Grid -> multiple handlers | Eventarc -> multiple targets |
| Ordered Fan-Out | SNS FIFO -> SQS FIFO | Topic sessions | Ordering keys |

---

## Streaming Services

### Kinesis vs Event Hubs vs Pub/Sub (Streaming)

| Feature | AWS Kinesis Data Streams | Azure Event Hubs | Google Pub/Sub |
|---------|--------------------------|-------------------|----------------|
| Type | Real-time data streaming | Event ingestion | Real-time messaging/streaming |
| Throughput | 1 MB/s per shard (in), 2 MB/s (out) | 1 MB/s per TU (in), 2 MB/s per TU (out) | Nearly unlimited (auto-scaled) |
| Partitioning | Shards (manual/auto scaling) | Partitions (fixed at creation) | N/A (automatic) |
| Retention | 24 hours (default), up to 365 days | 1-90 days (Standard), up to 90 days (Premium) | 7 days (default), up to 31 days |
| Consumer Groups | Enhanced fan-out (per-shard) | Up to 20 consumer groups | Multiple subscriptions |
| Replay/Rewind | Yes (by timestamp or sequence) | Yes (by offset or timestamp) | Yes (seek to timestamp) |
| Schema Registry | Glue Schema Registry | Schema Registry (built-in) | Pub/Sub schemas |
| Kafka Compatibility | MSK (Managed Kafka) | Event Hubs for Kafka | N/A (use Confluent on GKE) |
| Serverless Option | Kinesis Data Streams On-Demand | Event Hubs Premium (auto-inflate) | Default (serverless) |
| Capture/Export | Kinesis Data Firehose -> S3/Redshift | Capture -> Blob Storage/Data Lake | BigQuery subscription / Cloud Storage |
| Processing | Lambda, KDA (Flink), KCL | Azure Functions, Stream Analytics | Dataflow (Apache Beam) |
| Pricing | Per shard-hour + per PUT payload unit | Per throughput unit-hour + per event | Per data volume |
| Free Tier | N/A | N/A | 10 GB/month |

### Managed Kafka Comparison

| Feature | Amazon MSK | Azure Event Hubs (Kafka) | Confluent on GCP |
|---------|-----------|--------------------------|-------------------|
| Kafka Version | Apache Kafka (multiple versions) | Kafka protocol compatible | Confluent Platform |
| Management | Managed brokers and ZooKeeper | Fully managed (Kafka protocol) | Fully managed |
| Storage | EBS (unlimited retention) | Tiered storage | Tiered storage |
| Connectors | MSK Connect (Kafka Connect) | N/A | Managed connectors |
| Schema Registry | Glue Schema Registry | Built-in | Confluent Schema Registry |
| KSQL/Streams | Self-managed | N/A | ksqlDB |
| Cross-Region | MSK Replicator | Geo-replication | Cluster linking |
| Serverless | MSK Serverless | Event Hubs (auto-inflate) | Confluent Cloud |
| Pricing | Per broker-hour + storage | Per throughput unit + capture | Per CKU + data |

---

## Notification Services

### SNS vs Notification Hubs vs Firebase Cloud Messaging

| Feature | AWS SNS | Azure Notification Hubs | Google Firebase Cloud Messaging |
|---------|---------|--------------------------|----------------------------------|
| Mobile Push | APNs, FCM, ADM, WNS | APNs, FCM, WNS, MPNS, Baidu | Native FCM |
| SMS | Yes (200+ countries) | N/A (use Communication Services) | N/A |
| Email | Yes (basic) + SES for rich email | N/A (use Communication Services) | N/A |
| HTTP/S Webhooks | Yes | Yes (webhook) | Yes |
| Broadcast | Topic-based | Tags and tag expressions | Topic messaging |
| Personalization | Message attributes | Templates (platform-specific) | Data messages |
| Pricing | Per message type | Per namespace + per push | Free |
| Scale | Millions of subscribers | Millions of devices | Unlimited |

---

## Message Transformation and Routing

### Integration Services

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Message Transform | EventBridge input transformers | Logic Apps / Service Bus filters | Dataflow transforms |
| Content Routing | EventBridge rules | Service Bus topic filters | Pub/Sub filters |
| Protocol Bridge | API Gateway + Lambda | Logic Apps (200+ connectors) | Apigee / Cloud Functions |
| Enrichment | Lambda enrichment | Logic Apps / Functions | Cloud Functions |
| Schema Evolution | Glue Schema Registry | Event Hubs Schema Registry | Pub/Sub Schema |
| ETL Pipeline | EventBridge Pipes | Azure Data Factory | Dataflow |

### EventBridge Pipes vs Azure Data Factory vs Dataflow

| Feature | AWS EventBridge Pipes | Azure Data Factory | Google Dataflow |
|---------|----------------------|--------------------|--------------------|
| Purpose | Point-to-point integration | Data integration/ETL | Stream + batch processing |
| Sources | SQS, Kinesis, DynamoDB, MSK, self-managed Kafka | 100+ connectors | Pub/Sub, Kafka, files |
| Enrichment | Lambda, Step Functions, API Gateway, EventBridge | Mapping data flows | Apache Beam transforms |
| Targets | 15+ AWS services | 100+ connectors | BigQuery, GCS, Pub/Sub |
| Filtering | EventBridge patterns | Conditional activities | Beam filtering |
| Pricing | Per request | Per activity run + data flow hours | Per worker-hour |

---

## Reliability and Disaster Recovery

### Message Durability

| Aspect | AWS SQS/SNS | Azure Service Bus | Google Pub/Sub |
|--------|-------------|-------------------|----------------|
| Storage Replication | Multi-AZ (3 AZs) | Zone-redundant (Premium) | Multi-zone (regional) |
| Cross-Region DR | Cross-region SQS/SNS | Geo-DR (paired namespace) | Global topic (auto-replication) |
| Backup | N/A (consume and persist) | N/A | N/A |
| Message Durability | 99.999999999% (11 9s) | 99.9% SLA | 99.95% SLA |
| Failover Time | Automatic (multi-AZ) | Manual/automatic (Geo-DR) | Automatic (global) |

### Ordering Guarantees

| Guarantee | AWS | Azure | GCP |
|-----------|-----|-------|-----|
| No Ordering | SQS Standard, SNS Standard | Service Bus (no sessions) | Pub/Sub (no ordering key) |
| Per-Group Ordering | SQS FIFO (MessageGroupId) | Sessions (SessionId) | Ordering keys |
| Global Ordering | Single message group | Single session | Single ordering key |
| Exactly-Once | SQS FIFO (deduplication) | Duplicate detection | Exactly-once delivery |

---

## Cost Comparison

### Monthly Estimate (1 Million Messages/Day)

| Service | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Standard Queue | ~$12/month (SQS) | ~$10/month (Service Bus Standard) | ~$10/month (Pub/Sub) |
| FIFO/Ordered | ~$18/month (SQS FIFO) | ~$700/month (Service Bus Premium 1MU) | ~$10/month (Pub/Sub with ordering) |
| Streaming | ~$350/month (Kinesis, 2 shards) | ~$700/month (Event Hubs, 1 TU) | ~$10/month (Pub/Sub) |
| Fan-Out (5 targets) | ~$15/month (SNS + 5x SQS) | ~$10/month (Service Bus topic) | ~$50/month (Pub/Sub, 5 subs) |

Note: Pricing varies significantly based on message size, retention, and data transfer. Always use the cloud provider's pricing calculator for accurate estimates.

---

## Decision Matrix

### When to Use What

| Scenario | Recommended Service |
|----------|---------------------|
| Simple async decoupling | SQS, Pub/Sub, Service Bus Queue |
| Fan-out to multiple consumers | SNS + SQS, Pub/Sub, Service Bus Topics |
| Strict FIFO ordering | SQS FIFO, Service Bus Sessions, Pub/Sub ordering keys |
| Real-time analytics | Kinesis, Event Hubs, Pub/Sub + Dataflow |
| Log aggregation | Kinesis Firehose, Event Hubs Capture, Pub/Sub -> BigQuery |
| IoT telemetry | IoT Core + Kinesis, IoT Hub + Event Hubs, IoT Core + Pub/Sub |
| Enterprise integration | EventBridge + SQS, Service Bus (AMQP), Pub/Sub + Workflows |
| Cross-cloud messaging | Apache Kafka (MSK/Confluent), or Pub/Sub with push endpoints |

---

## Certification Exam Focus Areas

### AWS Solutions Architect / Developer
- SQS Standard vs FIFO: throughput, ordering, deduplication
- SNS fan-out patterns with SQS subscriptions
- Kinesis Data Streams shard calculations and scaling
- EventBridge Pipes vs Lambda for stream processing
- Dead letter queue configuration and monitoring
- Message visibility timeout and long polling

### Azure Developer / Solutions Architect
- Service Bus Queues vs Topics vs Event Hubs decision criteria
- Session-based message ordering and processing
- Event Hubs partitions, consumer groups, and checkpointing
- Geo-DR for Service Bus (active/passive)
- AMQP vs HTTP protocol selection
- Service Bus Premium vs Standard tier differences

### Google Cloud Architect / Developer
- Pub/Sub push vs pull subscription models
- Ordering keys and exactly-once delivery
- Dead-letter topics and retry policies
- Pub/Sub to BigQuery subscriptions (direct write)
- Dataflow (Apache Beam) for stream processing
- Pub/Sub Lite for cost-sensitive high-volume scenarios

---

## Documentation Links

- AWS SQS: https://docs.aws.amazon.com/sqs/latest/dg/
- AWS SNS: https://docs.aws.amazon.com/sns/latest/dg/
- AWS Kinesis: https://docs.aws.amazon.com/streams/latest/dev/
- AWS EventBridge: https://docs.aws.amazon.com/eventbridge/latest/userguide/
- Azure Service Bus: https://learn.microsoft.com/en-us/azure/service-bus-messaging/
- Azure Event Hubs: https://learn.microsoft.com/en-us/azure/event-hubs/
- Azure Notification Hubs: https://learn.microsoft.com/en-us/azure/notification-hubs/
- Google Pub/Sub: https://cloud.google.com/pubsub/docs
- Google Dataflow: https://cloud.google.com/dataflow/docs

---

## Key Takeaways

1. **Google Pub/Sub** is the simplest to operate - no shard/partition management, global by default
2. **Azure Service Bus** offers the richest enterprise features (transactions, sessions, AMQP)
3. **AWS SQS** is the most cost-effective for simple queuing workloads
4. **Kinesis** and **Event Hubs** are purpose-built for streaming - Pub/Sub handles both messaging and streaming
5. For strict ordering, understand the partition/shard/ordering-key model for each platform
6. Dead letter queues are essential for production workloads - know how to configure and monitor them on all platforms
7. Cross-cloud messaging is best achieved with Apache Kafka or HTTP-based Pub/Sub push
8. Understanding the pricing model differences (per-request vs per-unit vs per-volume) is critical for cost optimization questions
