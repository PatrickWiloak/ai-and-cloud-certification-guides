# Architecture Pattern - Strangler Fig Migration

## Overview

The Strangler Fig pattern incrementally migrates a legacy monolithic application to a modern architecture by gradually replacing specific functionality with new services. Named after the strangler fig tree that grows around a host tree and eventually replaces it, this pattern minimizes risk by avoiding "big bang" rewrites.

---

## Pattern Description

### Problem
- Legacy monolithic application is difficult to maintain, scale, and evolve
- A complete rewrite is too risky, expensive, and time-consuming
- Business cannot afford extended downtime during migration
- The legacy system must continue operating while migration proceeds
- Team needs to deliver new features during the migration period

### Solution
Incrementally replace parts of the legacy system with new services:
1. Place a facade (proxy/gateway) in front of the legacy application
2. Identify bounded contexts or modules to extract
3. Build new services for extracted functionality
4. Route traffic to new services via the facade
5. Decommission legacy components as they are replaced
6. Continue until the legacy system is fully replaced or sufficiently modernized

### When to Use
- Migrating monoliths to microservices
- Moving from on-premises to cloud
- Replacing legacy platforms with modern technology
- When business continuity is required during migration
- When the legacy system has clear functional boundaries

### When to Avoid
- The legacy system is too small to justify the migration overhead
- The legacy system cannot be intercepted by a proxy/facade
- Complete data model changes are required simultaneously
- When the legacy codebase is well-maintained and meeting requirements

---

## Migration Phases

### Phase 1 - Assess and Plan

| Activity | Description | Output |
|----------|-------------|--------|
| Dependency Mapping | Map all service dependencies and data flows | Dependency graph |
| Domain Analysis | Identify bounded contexts using DDD | Domain model |
| Prioritization | Rank modules by migration value and complexity | Migration backlog |
| Risk Assessment | Identify data coupling, shared databases, side effects | Risk register |
| Success Metrics | Define KPIs for migration progress | Metrics dashboard |

### Phase 2 - Set Up the Facade

| Component | Purpose | Implementation |
|-----------|---------|----------------|
| API Gateway/Proxy | Route traffic between legacy and new services | NGINX, Envoy, cloud API gateway |
| Traffic Router | Direct requests based on path, header, or content | Path-based routing rules |
| Monitoring | Track traffic split and performance | Metrics, logging, tracing |
| Feature Flags | Control traffic routing dynamically | LaunchDarkly, CloudWatch Evidently, custom |

### Phase 3 - Extract and Replace

```
Phase 3a: Extract one module
┌──────────┐     ┌──────────────┐     ┌──────────────┐
│  Client   │────>│   Facade     │────>│   Legacy     │
│           │     │  (Gateway)   │     │   Monolith   │
└──────────┘     │              │     │              │
                 │  /orders ────│────>│  Orders      │
                 │  /users  ────│────>│  Users       │
                 │  /products ──│────>│  Products    │
                 └──────────────┘     └──────────────┘

Phase 3b: Replace orders module
┌──────────┐     ┌──────────────┐     ┌──────────────┐
│  Client   │────>│   Facade     │     │   Legacy     │
│           │     │  (Gateway)   │     │   Monolith   │
└──────────┘     │              │     │              │
                 │  /orders ────│──┐  │  [Orders]    │
                 │  /users  ────│──│─>│  Users       │
                 │  /products ──│──│─>│  Products    │
                 └──────────────┘  │  └──────────────┘
                                   │
                              ┌────▼─────┐
                              │  Orders   │
                              │  Service  │
                              │  (new)    │
                              └──────────┘
```

### Phase 4 - Decommission

| Step | Action | Verification |
|------|--------|-------------|
| 1 | Redirect all traffic to new service | Monitor error rates |
| 2 | Disable legacy module | Verify no traffic to legacy |
| 3 | Remove legacy code | Code review and cleanup |
| 4 | Migrate/clean data | Data validation |
| 5 | Update documentation | Architecture diagrams |

---

## Cloud Implementation

### AWS Implementation

| Component | AWS Service | Purpose |
|-----------|-------------|---------|
| Facade/Proxy | ALB / API Gateway / CloudFront | Traffic routing |
| New Services | Lambda, ECS, EKS | Modern microservices |
| Legacy Hosting | EC2, Elastic Beanstalk | Existing monolith |
| Data Sync | DMS, EventBridge, SQS | Data migration and sync |
| Feature Flags | CloudWatch Evidently / AppConfig | Traffic control |
| Monitoring | CloudWatch, X-Ray | Performance tracking |
| DNS Routing | Route 53 (weighted routing) | Gradual traffic shift |

**AWS Migration Architecture:**
```
Route 53 (weighted) -> CloudFront -> ALB
                                      |
                        ┌─────────────┼─────────────┐
                        │             │             │
                   ┌────▼────┐  ┌────▼────┐  ┌────▼────┐
                   │ New Svc  │  │ New Svc  │  │ Legacy  │
                   │ (ECS)    │  │ (Lambda) │  │ (EC2)   │
                   └────┬─────┘  └────┬─────┘  └────┬────┘
                        │             │             │
                   ┌────▼─────┐ ┌────▼─────┐ ┌────▼────┐
                   │ DynamoDB  │ │ Aurora   │ │ Legacy  │
                   └───────────┘ │ (new)    │ │ DB      │
                                 └──────────┘ └─────────┘
                                       ↑           │
                                       └───DMS─────┘
```

### Azure Implementation

| Component | Azure Service | Purpose |
|-----------|---------------|---------|
| Facade/Proxy | Application Gateway / Azure Front Door / APIM | Traffic routing |
| New Services | Azure Functions, Container Apps, AKS | Modern microservices |
| Legacy Hosting | App Service, VMs | Existing monolith |
| Data Sync | Azure Data Factory, Service Bus, Event Grid | Data migration and sync |
| Feature Flags | App Configuration (Feature Management) | Traffic control |
| Monitoring | Azure Monitor, Application Insights | Performance tracking |
| DNS Routing | Azure Traffic Manager | Gradual traffic shift |

### Google Cloud Implementation

| Component | GCP Service | Purpose |
|-----------|-------------|---------|
| Facade/Proxy | Cloud Load Balancing / Apigee | Traffic routing |
| New Services | Cloud Run, Cloud Functions, GKE | Modern microservices |
| Legacy Hosting | Compute Engine, App Engine | Existing monolith |
| Data Sync | Dataflow, Pub/Sub, Database Migration Service | Data migration and sync |
| Feature Flags | Firebase Remote Config / custom | Traffic control |
| Monitoring | Cloud Monitoring, Cloud Trace | Performance tracking |
| DNS Routing | Cloud DNS (weighted routing) | Gradual traffic shift |

---

## Data Migration Strategies

### Shared Database (Transitional)

During migration, both legacy and new services may need to access the same data.

| Approach | Description | Risk Level |
|----------|-------------|------------|
| Shared Database | Both systems read/write same DB | High (schema coupling) |
| Database View | New service reads via view, legacy owns writes | Medium |
| Change Data Capture | Stream changes from legacy DB to new service DB | Low |
| Event Sourcing | Publish events on data changes, both systems subscribe | Low |
| API-based Sync | New service calls legacy API for data | Medium |

### Database Decomposition Patterns

| Pattern | Description | Use When |
|---------|-------------|----------|
| Database per Service | Each new service gets its own database | Clean domain boundaries |
| Shared Database (temporary) | Shared during transition | Tight data coupling |
| Database Wrapping | API layer over legacy database | Cannot modify legacy schema |
| CQRS | Separate read/write models | Different read/write patterns |
| Event-Driven Sync | Events propagate data changes | Eventual consistency is acceptable |

### Data Synchronization

| Method | AWS | Azure | GCP |
|--------|-----|-------|-----|
| CDC (Change Data Capture) | DMS, Debezium on MSK | Azure Data Factory CDC | Datastream |
| ETL Pipeline | Glue, Step Functions | Data Factory | Dataflow |
| Event Streaming | Kinesis, EventBridge | Event Hubs, Event Grid | Pub/Sub |
| Dual Write | Application-level (Lambda) | Application-level (Functions) | Application-level (Cloud Functions) |

---

## Traffic Routing Strategies

### Gradual Migration

| Strategy | Description | Risk |
|----------|-------------|------|
| Canary (1% -> 5% -> 25% -> 100%) | Gradually shift traffic percentage | Low |
| Feature Flag | Route specific users/tenants | Low |
| Path-Based | Route specific URL paths | Low |
| Header-Based | Route based on request headers | Low |
| Shadow/Mirror | Send copy of traffic to new service | Very low |
| Blue/Green | Switch all traffic at once | Medium |

### Implementation Examples

| Strategy | AWS | Azure | GCP |
|----------|-----|-------|-----|
| Weighted Routing | Route 53 weighted, ALB weighted target groups | Traffic Manager weighted, Front Door | Cloud DNS weighted, LB traffic splitting |
| Path-Based | ALB path-based routing, API Gateway | Application Gateway path rules, APIM | URL map path rules |
| Header-Based | ALB header conditions, API Gateway | APIM policies | Custom header routing |
| Shadow Traffic | ALB mirroring (via Lambda@Edge) | APIM mock backend + forward | Traffic Director mirroring |

---

## Common Challenges and Solutions

| Challenge | Solution |
|-----------|----------|
| Shared sessions | Externalize sessions (Redis, DynamoDB, Cosmos DB) |
| Authentication across old/new | Shared auth service or token exchange |
| Distributed transactions | Saga pattern, eventual consistency |
| Data consistency during migration | CDC, event-driven sync, reconciliation jobs |
| Legacy database schema coupling | Database wrapping API, anti-corruption layer |
| Monitoring across old/new | Unified observability platform, correlation IDs |
| Team coordination | Clear ownership boundaries, migration backlog |
| Rollback capability | Feature flags, weighted routing, blue/green |

### Anti-Corruption Layer

An anti-corruption layer translates between the legacy and new system models, preventing legacy concepts from leaking into the new architecture.

```
┌─────────────┐     ┌────────────────────┐     ┌─────────────┐
│  New Service │────>│ Anti-Corruption     │────>│   Legacy    │
│  (clean      │     │ Layer               │     │   System    │
│   model)     │     │  - Model translation│     │  (legacy    │
│              │     │  - Protocol adapting │     │   model)    │
│              │     │  - Data mapping      │     │             │
└─────────────┘     └────────────────────┘     └─────────────┘
```

---

## Migration Metrics and KPIs

| Metric | Description | Target |
|--------|-------------|--------|
| Migration Progress | Percentage of traffic on new services | Track weekly |
| Error Rate Delta | Error rate comparison (new vs legacy) | New <= legacy |
| Latency Delta | Latency comparison (new vs legacy) | New <= legacy + 10% |
| Feature Velocity | New feature delivery rate | Increasing post-migration |
| Legacy Footprint | Resources still on legacy | Decreasing monthly |
| Data Consistency | Reconciliation discrepancies | < 0.01% |
| Rollback Count | Number of rollbacks to legacy | Decreasing |
| Deployment Frequency | How often new services deploy | Increasing |

---

## Certification Exam Focus Areas

### AWS
- ALB routing rules for traffic splitting
- DMS for database migration during strangler fig
- Route 53 weighted routing for gradual migration
- EventBridge for event-driven data sync
- CloudFormation/CDK for infrastructure automation

### Azure
- Application Gateway and Front Door for traffic routing
- Azure Migrate for assessment and migration planning
- Data Factory for ETL during data decomposition
- APIM for facade/proxy layer
- App Configuration for feature flags

### Google Cloud
- Cloud Load Balancing URL maps for path-based routing
- Database Migration Service for data migration
- Pub/Sub for event-driven architecture during migration
- Anthos for hybrid legacy-to-cloud scenarios
- Cloud Run for deploying extracted microservices

---

## Documentation Links

- Strangler Fig Pattern (Microsoft): https://learn.microsoft.com/en-us/azure/architecture/patterns/strangler-fig
- AWS Migration Strategies: https://docs.aws.amazon.com/prescriptive-guidance/latest/migration-retiring-applications/
- AWS Database Migration Service: https://docs.aws.amazon.com/dms/latest/userguide/
- Azure Migrate: https://learn.microsoft.com/en-us/azure/migrate/
- Google Cloud Migration Center: https://cloud.google.com/migration-center/docs

---

## Key Takeaways

1. Start with the facade/proxy layer - it is the foundation of the entire migration
2. Extract modules with the highest business value or the most pain points first
3. Data migration is the hardest part - plan for it early and use CDC where possible
4. Always maintain rollback capability throughout the migration
5. The anti-corruption layer prevents legacy patterns from infecting the new system
6. Feature flags are essential for controlling traffic routing without deployments
7. Migration is a marathon, not a sprint - expect 12-24 months for a significant monolith
8. Measure and compare performance between legacy and new services continuously
