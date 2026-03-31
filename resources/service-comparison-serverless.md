# Service Comparison - Serverless

## Overview

This guide compares serverless compute, event routing, workflow orchestration, and API management services across AWS, Azure, and Google Cloud. Serverless architecture is a key topic across all cloud certification exams.

---

## Serverless Compute

### Lambda vs Azure Functions vs Cloud Functions

| Feature | AWS Lambda | Azure Functions | Google Cloud Functions |
|---------|-----------|-----------------|------------------------|
| Runtimes | Node.js, Python, Java, .NET, Go, Ruby, custom | Node.js, Python, Java, .NET, PowerShell, custom | Node.js, Python, Java, .NET, Go, Ruby, PHP |
| Max Execution Time | 15 minutes | 10 minutes (Consumption), unlimited (Premium/Dedicated) | 9 minutes (1st gen), 60 minutes (2nd gen) |
| Max Memory | 10,240 MB | 1,536 MB (Consumption), 14 GB (Premium) | 32 GB (2nd gen) |
| Max Package Size | 250 MB (unzipped), 50 MB (zipped) | No hard limit (Consumption: plan limits) | 500 MB (source), 32 GB (container) |
| Container Support | Container images (up to 10 GB) | Custom containers (Premium/Dedicated) | Container images (2nd gen) |
| Ephemeral Storage | 512 MB - 10 GB (/tmp) | 500 MB - 1 TB (local storage) | In-memory tmpfs |
| Concurrency Model | 1 invocation per instance (default) | Multiple invocations per instance | 1 invocation per instance (1st gen), concurrent (2nd gen) |
| Max Concurrency | 1,000 (default, adjustable) | 200 per instance (Consumption) | 1,000 (per function, 2nd gen) |
| Reserved Concurrency | Yes (provisioned concurrency) | Pre-warmed instances (Premium) | Min instances (2nd gen) |
| Cold Start | ~100ms-1s (varies by runtime) | ~1-3s (Consumption), reduced (Premium) | ~100ms-2s (1st gen), reduced (2nd gen) |
| VPC Access | VPC configuration (ENI-based) | VNet integration | VPC connector / Direct VPC |
| GPU Support | No | No | No |
| Pricing | Per request + per GB-second | Per execution + per GB-second | Per invocation + per GB-second + per GHz-second |
| Free Tier | 1M requests + 400,000 GB-seconds/month | 1M executions + 400,000 GB-seconds/month | 2M invocations + 400,000 GB-seconds/month |
| SnapStart | Yes (Java) | N/A | N/A |

### Cold Start Optimization Strategies

| Strategy | AWS Lambda | Azure Functions | Google Cloud Functions |
|----------|-----------|-----------------|------------------------|
| Provisioned/Pre-warmed | Provisioned Concurrency | Premium Plan (pre-warmed) | Min instances (2nd gen) |
| Snapshots | SnapStart (Java) | N/A | N/A |
| Keep-Warm | Scheduled ping | Durable Functions timer | Cloud Scheduler trigger |
| Container Reuse | Execution context reuse | Instance reuse | Instance reuse |
| Smaller Packages | Layer optimization | Deployment optimization | Dependency optimization |
| Runtime Choice | Python/Node.js (fastest) | Node.js/.NET (fastest) | Node.js/Python (fastest) |

---

## Serverless Compute - Extended Options

### Lambda vs Azure Container Apps vs Cloud Run

| Feature | AWS Lambda | Azure Container Apps | Google Cloud Run |
|---------|-----------|----------------------|-------------------|
| Unit of Deployment | Function (code/container) | Container | Container |
| Scale to Zero | Yes | Yes | Yes |
| Max Request Duration | 15 minutes | Unlimited (HTTP), 24h (jobs) | 60 minutes |
| Max vCPU | 6 vCPU | 4 vCPU | 8 vCPU |
| Max Memory | 10 GB | 8 GB | 32 GB |
| Concurrency per Instance | 1 (default) | Multiple | Up to 1,000 |
| GPU Support | No | No | Yes (L4) |
| Built-in Auth | IAM + Cognito (via API Gateway) | Easy Auth | IAM |
| Traffic Splitting | Aliases + weighted | Revision-based | Revision-based |
| Sidecar Support | Lambda Extensions | Yes | Yes |
| gRPC | No | Yes | Yes |
| WebSocket | Via API Gateway | Yes | No (use Firebase) |

---

## Event Routing and Integration

### EventBridge vs Event Grid vs Eventarc

| Feature | AWS EventBridge | Azure Event Grid | Google Eventarc |
|---------|----------------|-------------------|-----------------|
| Type | Serverless event bus | Event routing service | Event routing service |
| Event Sources | 200+ AWS services, SaaS, custom | Azure services, custom topics, partner | 130+ Google Cloud sources, custom |
| Event Format | CloudEvents + custom | CloudEvents (v1.0) | CloudEvents (v1.0) |
| Targets | 20+ (Lambda, SQS, SNS, Step Functions, API destinations) | Azure Functions, Logic Apps, webhooks, Event Hubs, Storage | Cloud Run, Cloud Functions, Workflows, GKE |
| Filtering | Content-based (prefix, suffix, numeric, IP, exists) | Subject, event type, advanced (AND/OR) | Attribute matching |
| Schema Registry | Yes (discovered + custom) | Yes (Event Grid schema) | N/A |
| Event Replay | Archive and replay | N/A | N/A |
| Dead Letter Queue | Yes (SQS) | Yes (Blob Storage) | Yes (Pub/Sub) |
| Cross-Account | Cross-account event buses | Cross-subscription topics | Cross-project |
| Global | Regional (multi-region with global endpoints) | Regional | Regional |
| Pricing | Per event published | Per operation | Per event delivered |
| Free Tier | All AWS service events free | First 100K operations/month | First 2M events/month |
| Guaranteed Delivery | At-least-once | At-least-once | At-least-once |
| Latency | ~500ms (typical) | ~seconds | ~seconds |

### Event Bus vs Message Queue Decision

| Use Case | Event Routing (EventBridge/Event Grid/Eventarc) | Message Queue (SQS/Service Bus/Pub/Sub) |
|----------|--------------------------------------------------|------------------------------------------|
| Fan-out | Yes (multiple targets per rule) | Pub/Sub pattern |
| Point-to-point | Not ideal | Yes |
| Ordering | Best-effort | FIFO available |
| Retention | Limited (archive for replay) | Days to weeks |
| Replay | EventBridge archive/replay | Dead letter reprocessing |
| Throughput | High (millions of events) | Very high (millions of messages) |
| Transformation | Input transformers | Consumer-side |

---

## Workflow Orchestration

### Step Functions vs Logic Apps/Durable Functions vs Workflows

| Feature | AWS Step Functions | Azure Logic Apps | Google Cloud Workflows |
|---------|-------------------|------------------|------------------------|
| Type | State machine workflow | Visual workflow designer | YAML/JSON workflow |
| Definition | Amazon States Language (JSON) | Logic Apps Designer / Bicep | Workflows YAML syntax |
| Max Execution | 1 year (Standard), 5 min (Express) | 90 days (Consumption) | 1 year |
| Execution Model | Standard (exactly-once), Express (at-least-once) | Stateful, Stateless | Exactly-once |
| Visual Designer | Workflow Studio | Logic Apps Designer (visual) | N/A (YAML only) |
| Connectors | AWS service integrations (200+) | 1,000+ connectors (SaaS) | HTTP, gRPC, Cloud APIs |
| Human Approval | Callback pattern (task tokens) | Approval connector | Callback endpoints |
| Parallel Execution | Parallel state, Map state | Parallel branches, ForEach | Parallel steps |
| Error Handling | Retry, Catch | Retry policies, scopes | Retry, try/except |
| Nested Workflows | Yes | Yes | Yes (subworkflows) |
| Express/Sync | Express Workflows | Stateless | N/A |
| Pricing | Per state transition (Standard), per execution + duration (Express) | Per action execution, per trigger | Per step executed |
| Free Tier | 4,000 transitions/month | 4,000 actions/month (Consumption) | 5,000 steps/month |

### Durable Functions vs Step Functions

| Feature | Azure Durable Functions | AWS Step Functions |
|---------|------------------------|--------------------|
| Language | Code-based (C#, JavaScript, Python, Java, PowerShell) | JSON (Amazon States Language) |
| Patterns | Orchestrator, Entity, Client | State machine |
| Fan-out/Fan-in | Native pattern | Map state |
| Human Interaction | WaitForExternalEvent | Task tokens (callback) |
| Eternal Orchestrations | ContinueAsNew | Loop with choice state |
| Entity Pattern | Durable Entities | N/A (use DynamoDB) |
| Sub-Orchestrations | Yes | Nested execution |
| Testing | Unit testable | Limited (local testing tool) |

---

## API Management

### API Gateway vs Azure API Management vs Apigee

| Feature | AWS API Gateway | Azure API Management | Google Apigee |
|---------|----------------|---------------------|----------------|
| Type | Managed API gateway | Full API lifecycle management | Full API lifecycle management |
| Protocols | REST, WebSocket, HTTP | REST, SOAP, WebSocket, GraphQL, gRPC | REST, SOAP, gRPC, GraphQL |
| Developer Portal | N/A (use third-party) | Built-in | Built-in |
| API Products | N/A | Products (bundled APIs) | API Products |
| Rate Limiting | Usage plans + API keys | Policies (rate-limit, quota) | Spike arrest, quota |
| Caching | Built-in (0.5-237 GB) | Built-in, External (Redis) | Built-in, External |
| Request Transform | Mapping templates (VTL) | Policies (XML-based) | Policies (JavaScript, Python) |
| Response Transform | Mapping templates | Policies | Policies |
| Authentication | IAM, Cognito, Lambda authorizer | OAuth 2.0, API keys, certificates, JWT | OAuth 2.0, API keys, JWT, SAML |
| mTLS | Yes | Yes | Yes |
| WAF Integration | AWS WAF | N/A (use Azure WAF separately) | Built-in threat protection |
| Monetization | N/A | N/A (third-party) | Built-in monetization |
| Analytics | CloudWatch | Built-in analytics | Built-in analytics (Apigee Analytics) |
| Pricing Model | Per request + data transfer | Tier-based (Developer to Premium) | Per API call (Pay-as-you-go) or subscription |

---

## Serverless Storage

### Serverless Database Options

| Feature | DynamoDB | Cosmos DB (Serverless) | Firestore |
|---------|----------|------------------------|-----------|
| Type | Key-value + document | Multi-model | Document |
| Consistency | Eventually / Strong (per-item) | 5 consistency levels | Strong |
| Auto-Scaling | On-demand / provisioned | Serverless (RU-based) | Automatic |
| Global Distribution | Global Tables | Multi-region writes | Multi-region (active-passive) |
| Transactions | ACID (up to 100 items) | ACID (within partition) | ACID (up to 500 docs) |
| Max Item Size | 400 KB | 2 MB | 1 MB |
| Secondary Indexes | GSI, LSI | Automatic indexing | Composite indexes |
| Change Stream | DynamoDB Streams | Change Feed | Real-time listeners |
| Pricing | Per RCU/WCU or per request | Per RU consumed + storage | Per read/write/delete + storage |
| Free Tier | 25 GB + 25 RCU/WCU | 1,000 RU/s + 25 GB | 1 GB + 50K reads + 20K writes/day |

---

## Serverless Integration Patterns

### Event-Driven Architecture Components

| Pattern | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Event Bus | EventBridge | Event Grid | Eventarc |
| Message Queue | SQS | Service Bus Queue | Pub/Sub |
| Stream Processing | Kinesis / MSK Serverless | Event Hubs | Pub/Sub + Dataflow |
| Pub/Sub | SNS | Service Bus Topic | Pub/Sub |
| Scheduling | EventBridge Scheduler | Timer trigger (Functions) | Cloud Scheduler |
| API Gateway | API Gateway | API Management | Apigee / API Gateway |
| Workflow | Step Functions | Logic Apps / Durable Functions | Workflows |
| File Processing | S3 + Lambda | Blob Storage + Functions | Cloud Storage + Cloud Functions |
| WebSocket | API Gateway WebSocket | SignalR Service | Firebase Realtime DB |
| GraphQL | AppSync | N/A (use Hot Chocolate / Strawberry Shake) | N/A (use Apollo on Cloud Run) |

---

## Certification Exam Focus Areas

### AWS Solutions Architect / Developer
- Lambda execution model, concurrency, and cold starts
- EventBridge event patterns and rule matching
- Step Functions Standard vs Express workflows
- API Gateway stage variables, deployment, and caching
- DynamoDB capacity modes and partition key design
- Lambda layers, extensions, and SnapStart

### Azure Developer / Solutions Architect
- Azure Functions hosting plans (Consumption, Premium, Dedicated)
- Durable Functions orchestration patterns
- Event Grid event subscriptions and filtering
- Logic Apps connectors and workflow design
- Cosmos DB serverless vs provisioned throughput
- API Management policies and products

### Google Cloud Architect / Developer
- Cloud Functions 1st gen vs 2nd gen differences
- Cloud Run concurrency and autoscaling configuration
- Eventarc triggers and event routing
- Workflows syntax and error handling
- Firestore data model and security rules
- Apigee API proxy design

---

## Documentation Links

- AWS Lambda: https://docs.aws.amazon.com/lambda/latest/dg/
- AWS Step Functions: https://docs.aws.amazon.com/step-functions/latest/dg/
- AWS EventBridge: https://docs.aws.amazon.com/eventbridge/latest/userguide/
- AWS API Gateway: https://docs.aws.amazon.com/apigateway/latest/developerguide/
- Azure Functions: https://learn.microsoft.com/en-us/azure/azure-functions/
- Azure Logic Apps: https://learn.microsoft.com/en-us/azure/logic-apps/
- Azure Event Grid: https://learn.microsoft.com/en-us/azure/event-grid/
- Google Cloud Functions: https://cloud.google.com/functions/docs
- Google Cloud Run: https://cloud.google.com/run/docs
- Google Eventarc: https://cloud.google.com/eventarc/docs
- Google Cloud Workflows: https://cloud.google.com/workflows/docs

---

## Key Takeaways

1. **Cloud Run** and **Azure Container Apps** blur the line between serverless and containers - offering scale-to-zero with container flexibility
2. **Lambda** has the most mature ecosystem but is constrained to 15-minute execution time
3. **Azure Functions Premium Plan** eliminates cold starts - unique among the big three
4. **EventBridge** leads in event routing with schema registry and archive/replay capabilities
5. **Logic Apps** offers the most pre-built connectors (1,000+) for enterprise integration
6. **Step Functions** provides the cleanest workflow-as-state-machine model
7. For exam prep, understand the trade-offs between event-driven and request-driven architectures
8. All three providers are converging on **CloudEvents** as the standard event format
