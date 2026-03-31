# CQRS and Event Sourcing

A comprehensive guide to Command Query Responsibility Segregation and Event Sourcing patterns with implementation across AWS, Azure, and Google Cloud Platform.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Architecture Diagram Description](#architecture-diagram-description)
3. [Component Breakdown](#component-breakdown)
4. [AWS Implementation](#aws-implementation)
5. [Azure Implementation](#azure-implementation)
6. [GCP Implementation](#gcp-implementation)
7. [Event Sourcing Fundamentals](#event-sourcing-fundamentals)
8. [Design Considerations](#design-considerations)
9. [Cost Estimation](#cost-estimation)
10. [Production Checklist](#production-checklist)

---

## Architecture Overview

### What is CQRS?

Command Query Responsibility Segregation separates read and write operations into distinct models:
- **Commands**: Operations that change state (create, update, delete)
- **Queries**: Operations that read state (get, list, search)
- **Separate Models**: Write model optimized for consistency, read model optimized for queries
- **Independent Scaling**: Read and write sides scale independently
- **Different Storage**: Write and read sides can use different databases

### What is Event Sourcing?

Event sourcing stores state as a sequence of immutable events rather than current state:
- **Events as Source of Truth**: All state changes recorded as events
- **Append-Only**: Events are never modified or deleted
- **State Reconstruction**: Current state derived by replaying events
- **Complete History**: Full audit trail of every change
- **Temporal Queries**: Query state at any point in time

### CQRS + Event Sourcing Combined

| Aspect | Traditional CRUD | CQRS | CQRS + Event Sourcing |
|--------|-----------------|------|----------------------|
| **Data Model** | Single model | Separate read/write models | Events + projections |
| **Storage** | One database | Separate read/write stores | Event store + read stores |
| **Consistency** | Immediate | Eventual (read side) | Eventual (projections) |
| **Audit Trail** | Requires separate logging | Partial | Complete by design |
| **Complexity** | Low | Medium | High |

### Benefits

- **Performance**: Read and write models independently optimized
- **Scalability**: Scale reads and writes separately
- **Audit Trail**: Complete history of all changes (event sourcing)
- **Flexibility**: Multiple read projections from same events
- **Debugging**: Replay events to understand what happened
- **Temporal Queries**: Query state at any historical point

### Trade-offs

- **Complexity**: Significantly more complex than CRUD
- **Eventual Consistency**: Read models lag behind write model
- **Event Schema Evolution**: Changing event schemas is difficult
- **Storage Growth**: Event store grows indefinitely
- **Learning Curve**: Teams need to learn new patterns
- **Tooling**: Fewer off-the-shelf tools compared to CRUD

### When to Use CQRS

**Good Fit:**
- Read and write workloads have very different scaling needs
- Complex domain logic on the write side
- Multiple read representations of the same data
- High-performance read requirements (search, reporting)
- Collaborative domains with concurrent modifications

**Poor Fit:**
- Simple CRUD applications
- Small teams without distributed systems experience
- Applications where strong consistency is required everywhere
- Low-traffic applications where scaling is not a concern

### When to Add Event Sourcing

**Good Fit:**
- Regulatory audit requirements (financial, healthcare)
- Complex business processes with long-running workflows
- Need to rebuild state or replay history
- Event-driven integrations with other systems
- Temporal queries ("what was the state last Tuesday?")

**Poor Fit:**
- Simple state management
- High-frequency updates to same entity
- When event schema evolution is impractical
- Applications with simple, predictable state transitions

---

## Architecture Diagram Description

### CQRS Architecture

```
[Client] --commands--> [Command Handler] --> [Write Model/DB]
                                                   |
                                            [Event/Change Feed]
                                                   |
                                            [Projection Builder]
                                                   |
[Client] <--queries--- [Query Handler]  <-- [Read Model/DB]
```

### CQRS + Event Sourcing Architecture

```
[Client] --commands--> [Command Handler] --> [Aggregate]
                                                |
                                         [Event Store]
                                         (append-only)
                                                |
                                    +-----------+-----------+
                                    |           |           |
                             [Projection A] [Projection B] [Projection C]
                             [SQL Database] [Search Index] [Cache]
                                    |           |           |
[Client] <--queries--------[Query Handler]------+-----------+
```

---

## Component Breakdown

### Write Side

| Component | Purpose | Key Features |
|-----------|---------|--------------|
| **Command Handler** | Validate and process commands | Input validation, authorization |
| **Aggregate** | Business logic and invariants | Domain rules, state transitions |
| **Event Store** | Persist events | Append-only, ordered, immutable |
| **Command Bus** | Route commands to handlers | Async processing, retry logic |

### Read Side

| Component | Purpose | Key Features |
|-----------|---------|--------------|
| **Projection Builder** | Transform events into read models | Event handlers, idempotent |
| **Read Store** | Optimized query storage | Denormalized, indexed for queries |
| **Query Handler** | Execute queries against read models | Caching, pagination |
| **Event Subscriber** | Receive events from event store | Ordered processing, checkpointing |

### Infrastructure

| Component | Purpose | Key Features |
|-----------|---------|--------------|
| **Event Bus** | Distribute events to projections | Fan-out, ordering, replay |
| **Snapshot Store** | Cache aggregate state | Reduce replay time |
| **Schema Registry** | Manage event schemas | Versioning, compatibility |

---

## AWS Implementation

### Core Services

| Component | AWS Service | Purpose |
|-----------|------------|---------|
| **Event Store** | DynamoDB (append-only) | Event persistence |
| **Event Distribution** | DynamoDB Streams + EventBridge | Event fan-out |
| **Command Processing** | Lambda / ECS | Command handlers |
| **Read Store (SQL)** | Aurora / RDS | Relational projections |
| **Read Store (Search)** | OpenSearch | Full-text search projections |
| **Read Store (Cache)** | ElastiCache Redis | Low-latency projections |
| **Projection Processing** | Lambda (event-driven) | Build read models |
| **API** | API Gateway | Command and query endpoints |

### Architecture Pattern

- API Gateway exposes separate command and query endpoints
- Lambda functions handle commands, validate, and write events to DynamoDB
- DynamoDB Streams trigger Lambda functions to build projections
- EventBridge distributes events to multiple subscribers
- Aurora stores denormalized read models for complex queries
- ElastiCache provides sub-millisecond reads for hot data
- OpenSearch powers full-text search projections

**Documentation:**
- [DynamoDB Streams](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Streams.html)
- [Amazon EventBridge](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html)
- [AWS Lambda](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)
- [Amazon OpenSearch](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/what-is.html)

---

## Azure Implementation

### Core Services

| Component | Azure Service | Purpose |
|-----------|--------------|---------|
| **Event Store** | Cosmos DB (append-only) | Event persistence |
| **Event Distribution** | Cosmos DB Change Feed + Event Grid | Event fan-out |
| **Command Processing** | Azure Functions / Container Apps | Command handlers |
| **Read Store (SQL)** | Azure SQL | Relational projections |
| **Read Store (Search)** | Azure AI Search | Search projections |
| **Read Store (Cache)** | Azure Cache for Redis | Low-latency projections |
| **Projection Processing** | Azure Functions (trigger on change feed) | Build read models |
| **API** | Azure API Management | Command and query endpoints |

### Architecture Pattern

- API Management routes commands and queries to separate backends
- Azure Functions process commands and append events to Cosmos DB
- Cosmos DB Change Feed triggers projection builders
- Event Grid distributes events to external subscribers
- Azure SQL stores relational read models
- Azure AI Search provides full-text search capabilities
- Redis cache serves frequently accessed projections

**Documentation:**
- [Cosmos DB Change Feed](https://learn.microsoft.com/en-us/azure/cosmos-db/change-feed)
- [Azure Event Grid](https://learn.microsoft.com/en-us/azure/event-grid/overview)
- [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview)
- [Azure AI Search](https://learn.microsoft.com/en-us/azure/search/search-what-is-azure-search)

---

## GCP Implementation

### Core Services

| Component | GCP Service | Purpose |
|-----------|------------|---------|
| **Event Store** | Firestore / Bigtable | Event persistence |
| **Event Distribution** | Pub/Sub + Eventarc | Event fan-out |
| **Command Processing** | Cloud Run / Cloud Functions | Command handlers |
| **Read Store (SQL)** | Cloud SQL / AlloyDB | Relational projections |
| **Read Store (Search)** | Vertex AI Search | Search projections |
| **Read Store (Cache)** | Memorystore for Redis | Low-latency projections |
| **Projection Processing** | Cloud Functions (Pub/Sub trigger) | Build read models |
| **API** | Cloud Endpoints / Apigee | Command and query endpoints |

### Architecture Pattern

- Cloud Endpoints or Apigee routes commands and queries
- Cloud Run handles commands and writes events to Firestore
- Firestore triggers or Pub/Sub distribute events
- Cloud Functions build projections into Cloud SQL and Memorystore
- Pub/Sub provides durable, ordered event delivery
- BigQuery stores events for analytics and historical queries

**Documentation:**
- [Pub/Sub](https://cloud.google.com/pubsub/docs/overview)
- [Eventarc](https://cloud.google.com/eventarc/docs/overview)
- [Cloud Firestore](https://cloud.google.com/firestore/docs/overview)
- [Cloud Run](https://cloud.google.com/run/docs/overview/what-is-cloud-run)

---

## Event Sourcing Fundamentals

### Event Store Design

An event store contains ordered, immutable events per aggregate:

| Field | Type | Description |
|-------|------|-------------|
| **aggregate_id** | String (UUID) | Identifies the entity |
| **version** | Integer | Sequence number for ordering |
| **event_type** | String | Type of event (OrderCreated, ItemAdded) |
| **event_data** | JSON | Event payload |
| **metadata** | JSON | Correlation ID, user, timestamp |
| **timestamp** | DateTime | When the event occurred |

### Projections

Projections (also called read models or materializations) are derived views built from events:

- **Synchronous projections**: Updated in the same transaction as event storage
- **Asynchronous projections**: Updated via event stream subscription (eventual consistency)
- **Rebuild**: Projections can be rebuilt from scratch by replaying all events
- **Multiple projections**: Same events can feed many different read models

### Snapshots

For aggregates with many events, snapshots optimize state reconstruction:

- Store periodic snapshots of aggregate state
- Replay only events after the latest snapshot
- Typical snapshot frequency: every 50-100 events
- Snapshots are an optimization, not a requirement

### Event Schema Evolution

| Strategy | Description | When to Use |
|----------|-------------|------------|
| **Versioned Events** | Add version number to event type | Breaking changes |
| **Upcasting** | Transform old events to new format on read | Backward compatible changes |
| **Weak Schema** | Use flexible schemas (JSON) | Evolving domains |
| **Copy-Transform** | Migrate event store to new schema | Major refactoring |

---

## Design Considerations

### Consistency

- **Write side**: Strong consistency within an aggregate
- **Read side**: Eventual consistency (typically milliseconds to seconds lag)
- **Handling stale reads**: Show "processing" indicators in the UI
- **Read-your-writes**: Route the writing user to the write model briefly

### Idempotency

- **Command idempotency**: Use command IDs to detect duplicates
- **Projection idempotency**: Track processed event versions per projection
- **Deduplication**: Store processed event IDs to prevent reprocessing

### Error Handling

- **Command validation failures**: Return errors synchronously
- **Projection failures**: Use dead letter queues and retry with backoff
- **Event store failures**: Retry with idempotency guarantees
- **Compensating events**: Issue corrective events for business errors

### Performance Optimization

- **Snapshots**: Reduce event replay time for hot aggregates
- **Projection caching**: Cache frequently accessed read models
- **Parallel projections**: Build multiple projections concurrently
- **Event batching**: Process events in batches for throughput

---

## Cost Estimation

### AWS (Monthly Estimate - Moderate Workload)

| Component | Service | Estimated Cost |
|-----------|---------|---------------|
| Event Store | DynamoDB (10 GB, 1000 WCU) | ~$500/month |
| Event Distribution | DynamoDB Streams + EventBridge | ~$50/month |
| Command Processing | Lambda (1M invocations) | ~$20/month |
| Projection Processing | Lambda (5M invocations) | ~$100/month |
| Read Store | Aurora Serverless | ~$200/month |
| Cache | ElastiCache (r6g.large) | ~$200/month |
| API | API Gateway (10M requests) | ~$35/month |
| **Total** | | **~$1,105/month** |

### Azure (Monthly Estimate - Moderate Workload)

| Component | Service | Estimated Cost |
|-----------|---------|---------------|
| Event Store | Cosmos DB (10 GB, 1000 RU/s) | ~$600/month |
| Command Processing | Azure Functions (1M) | ~$20/month |
| Projection Processing | Azure Functions (5M) | ~$100/month |
| Read Store | Azure SQL (Standard S2) | ~$150/month |
| Cache | Redis Cache (C1) | ~$160/month |
| API | API Management (Developer) | ~$50/month |
| **Total** | | **~$1,080/month** |

### GCP (Monthly Estimate - Moderate Workload)

| Component | Service | Estimated Cost |
|-----------|---------|---------------|
| Event Store | Firestore (10 GB, moderate ops) | ~$200/month |
| Event Distribution | Pub/Sub (10M messages) | ~$40/month |
| Command Processing | Cloud Run (moderate) | ~$50/month |
| Projection Processing | Cloud Functions (5M) | ~$50/month |
| Read Store | Cloud SQL (db-standard-2) | ~$150/month |
| Cache | Memorystore (M1, 5 GB) | ~$150/month |
| **Total** | | **~$640/month** |

---

## Production Checklist

### Event Store

- [ ] Event store deployed with append-only semantics
- [ ] Event ordering guaranteed per aggregate
- [ ] Event schema versioning strategy defined
- [ ] Snapshot strategy implemented for large aggregates
- [ ] Event retention policy configured
- [ ] Backup and recovery procedures tested

### Command Side

- [ ] Command validation implemented
- [ ] Idempotency handling in place (command deduplication)
- [ ] Aggregate concurrency control (optimistic locking)
- [ ] Error handling and dead letter queues configured
- [ ] Command authorization and authentication

### Query Side

- [ ] Projections deployed for all required read models
- [ ] Projection rebuild capability tested
- [ ] Eventual consistency lag monitored
- [ ] Read model indexing optimized for query patterns
- [ ] Caching layer configured for hot queries

### Operations

- [ ] Monitoring dashboards for command and query throughput
- [ ] Alerting on projection lag and errors
- [ ] Event replay procedures documented and tested
- [ ] Schema evolution procedures documented
- [ ] Load testing completed for peak scenarios
- [ ] Runbooks for common failure scenarios

---

**Related Guides:**
- [Event-Driven Architecture](./event-driven-architecture.md)
- [Microservices Architecture](./microservices-architecture.md)
- [API Gateway Pattern](./api-gateway-pattern.md)
