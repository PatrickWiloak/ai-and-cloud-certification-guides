---
last-updated: 2026-05-03
---

# Azure Developer Associate (AZ-204) Fact Sheet

## Quick Reference

**Exam Code:** AZ-204
**Duration:** 120 minutes
**Questions:** 40-60 questions
**Passing Score:** 700/1000
**Cost:** $165 USD
**Validity:** 1 year (requires annual renewal)
**Delivery:** Pearson VUE (Testing center or online proctored)

## Exam Domain Breakdown

| Domain | Weight | Focus |
|--------|--------|-------|
| Develop Azure compute solutions | 25-30% | App Service, Functions, Container Apps, AKS |
| Develop for Azure storage | 15-20% | Blob, Cosmos DB, Azure SQL |
| Implement Azure security | 20-25% | Managed Identity, Key Vault, App Config |
| Monitor, troubleshoot, and optimize | 15-20% | Application Insights, Cache, CDN |
| Connect to and consume Azure services | 15-20% | API Management, Event Grid, Service Bus, Queue Storage |

## Core Services to Master

### Azure Compute (25-30%)

#### Azure App Service
- **Web Apps** - PaaS for web applications, auto-scaling
  - **[📖 App Service Overview](https://learn.microsoft.com/en-us/azure/app-service/overview)** - Complete App Service documentation
  - **[📖 App Service Plans](https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans)** - Pricing tiers and scaling options
  - **[📖 App Service Deployment](https://learn.microsoft.com/en-us/azure/app-service/deploy-best-practices)** - Deployment best practices
  - **[📖 App Service Slots](https://learn.microsoft.com/en-us/azure/app-service/deploy-staging-slots)** - Deployment slots and swapping
  - **[📖 App Service Slot Settings](https://learn.microsoft.com/en-us/azure/app-service/deploy-staging-slots#which-settings-are-swapped)** - Slot-specific vs swapped settings
  - **[📖 App Service Configuration](https://learn.microsoft.com/en-us/azure/app-service/configure-common)** - App settings and connection strings
  - **[📖 App Service Networking](https://learn.microsoft.com/en-us/azure/app-service/networking-features)** - VNet integration and hybrid connections
  - **[📖 App Service Authentication](https://learn.microsoft.com/en-us/azure/app-service/overview-authentication-authorization)** - Built-in auth/authz (Easy Auth)
  - **[📖 App Service Scaling](https://learn.microsoft.com/en-us/azure/app-service/manage-scale-up)** - Manual and autoscale options
  - **[📖 App Service Logs](https://learn.microsoft.com/en-us/azure/app-service/troubleshoot-diagnostic-logs)** - Application and web server logging

#### Azure Functions
- **Serverless compute** - Event-driven functions, multiple triggers
  - **[📖 Azure Functions Overview](https://learn.microsoft.com/en-us/azure/azure-functions/functions-overview)** - Complete Functions documentation
  - **[📖 Functions Triggers and Bindings](https://learn.microsoft.com/en-us/azure/azure-functions/functions-triggers-bindings)** - Input/output bindings
  - **[📖 Functions Host.json](https://learn.microsoft.com/en-us/azure/azure-functions/functions-host-json)** - Function app configuration
  - **[📖 Functions Local.settings.json](https://learn.microsoft.com/en-us/azure/azure-functions/functions-develop-local)** - Local development settings
  - **[📖 Durable Functions](https://learn.microsoft.com/en-us/azure/azure-functions/durable/durable-functions-overview)** - Stateful functions and orchestrations
  - **[📖 Durable Functions Patterns](https://learn.microsoft.com/en-us/azure/azure-functions/durable/durable-functions-overview?tabs=csharp#application-patterns)** - Function chaining, fan-out/fan-in, async HTTP APIs
  - **[📖 Functions Performance](https://learn.microsoft.com/en-us/azure/azure-functions/performance-reliability)** - Best practices and optimization
  - **[📖 Functions Hosting Plans](https://learn.microsoft.com/en-us/azure/azure-functions/functions-scale)** - Consumption, Premium, Dedicated
  - **[📖 Functions Networking](https://learn.microsoft.com/en-us/azure/azure-functions/functions-networking-options)** - VNet integration and private endpoints
  - **[📖 Functions Monitoring](https://learn.microsoft.com/en-us/azure/azure-functions/functions-monitoring)** - Application Insights integration

#### Azure Container Instances (ACI)
- **Containerized apps** - Fast container deployment without orchestration
  - **[📖 ACI Overview](https://learn.microsoft.com/en-us/azure/container-instances/container-instances-overview)** - Container Instances basics
  - **[📖 ACI Container Groups](https://learn.microsoft.com/en-us/azure/container-instances/container-instances-container-groups)** - Multi-container pods
  - **[📖 ACI Environment Variables](https://learn.microsoft.com/en-us/azure/container-instances/container-instances-environment-variables)** - Configuration management
  - **[📖 ACI Volumes](https://learn.microsoft.com/en-us/azure/container-instances/container-instances-volume-azure-files)** - Mount Azure Files shares

#### Azure Kubernetes Service (AKS)
- **Container orchestration** - Managed Kubernetes clusters
  - **[📖 AKS Overview](https://learn.microsoft.com/en-us/azure/aks/intro-kubernetes)** - Complete AKS documentation
  - **[📖 AKS Deployment](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-cli)** - Deploy applications to AKS
  - **[📖 AKS Networking](https://learn.microsoft.com/en-us/azure/aks/concepts-network)** - Network concepts and CNI

#### Azure Container Registry (ACR)
- **Container registry** - Private Docker registry for container images
  - **[📖 ACR Overview](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-intro)** - Registry service overview
  - **[📖 ACR Tasks](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-tasks-overview)** - Automated image builds
  - **[📖 ACR Authentication](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-authentication)** - Authentication methods

### Azure Storage (15-20%)

#### Azure Blob Storage
- **Object storage** - Unstructured data, scalable, hot/cool/archive tiers
  - **[📖 Blob Storage Overview](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-overview)** - Complete Blob documentation
  - **[📖 Blob Storage Client Library](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-dotnet)** - SDK for .NET developers
  - **[📖 Blob Types](https://learn.microsoft.com/en-us/rest/api/storageservices/understanding-block-blobs--append-blobs--and-page-blobs)** - Block, append, and page blobs
  - **[📖 Blob Access Tiers](https://learn.microsoft.com/en-us/azure/storage/blobs/access-tiers-overview)** - Hot, cool, cold, archive tiers
  - **[📖 Blob Lifecycle Management](https://learn.microsoft.com/en-us/azure/storage/blobs/lifecycle-management-overview)** - Automated tier transitions
  - **[📖 Shared Access Signatures](https://learn.microsoft.com/en-us/azure/storage/common/storage-sas-overview)** - Delegated access with SAS
  - **[📖 Blob Metadata](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blob-properties-metadata)** - Properties and custom metadata
  - **[📖 Blob Versioning](https://learn.microsoft.com/en-us/azure/storage/blobs/versioning-overview)** - Automatically maintain previous versions
  - **[📖 Blob Change Feed](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blob-change-feed)** - Track all changes to blobs

#### Azure Cosmos DB
- **NoSQL database** - Globally distributed, multi-model, multiple APIs
  - **[📖 Cosmos DB Overview](https://learn.microsoft.com/en-us/azure/cosmos-db/introduction)** - Complete Cosmos DB documentation
  - **[📖 Cosmos DB APIs](https://learn.microsoft.com/en-us/azure/cosmos-db/choose-api)** - NoSQL, MongoDB, Cassandra, Gremlin, Table
  - **[📖 Cosmos DB Partitioning](https://learn.microsoft.com/en-us/azure/cosmos-db/partitioning-overview)** - Partition keys and distribution
  - **[📖 Cosmos DB Consistency Levels](https://learn.microsoft.com/en-us/azure/cosmos-db/consistency-levels)** - Five consistency options
  - **[📖 Cosmos DB Request Units](https://learn.microsoft.com/en-us/azure/cosmos-db/request-units)** - RU/s pricing and capacity
  - **[📖 Cosmos DB Change Feed](https://learn.microsoft.com/en-us/azure/cosmos-db/change-feed)** - Stream of changes for event processing
  - **[📖 Cosmos DB Best Practices](https://learn.microsoft.com/en-us/azure/cosmos-db/best-practice-dotnet)** - .NET SDK best practices
  - **[📖 Cosmos DB Indexing](https://learn.microsoft.com/en-us/azure/cosmos-db/index-policy)** - Index policies and performance
  - **[📖 Cosmos DB SQL Queries](https://learn.microsoft.com/en-us/azure/cosmos-db/nosql/query/getting-started)** - Query syntax and optimization
  - **[📖 Cosmos DB Server-Side Programming](https://learn.microsoft.com/en-us/azure/cosmos-db/stored-procedures-triggers-udfs)** - Stored procedures, triggers, UDFs

#### Azure SQL Database
- **Relational database** - Managed SQL Server, serverless option
  - **[📖 Azure SQL Database Overview](https://learn.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview)** - PaaS SQL service
  - **[📖 Azure SQL Connectivity](https://learn.microsoft.com/en-us/azure/azure-sql/database/connect-query-dotnet-core)** - Connection strings and SDKs
  - **[📖 Azure SQL Elastic Pools](https://learn.microsoft.com/en-us/azure/azure-sql/database/elastic-pool-overview)** - Shared resources for multiple databases

#### Azure Table Storage
- **NoSQL key-value store** - Simple structured data storage
  - **[📖 Table Storage Overview](https://learn.microsoft.com/en-us/azure/storage/tables/table-storage-overview)** - Key-value NoSQL storage
  - **[📖 Table Storage Design](https://learn.microsoft.com/en-us/azure/storage/tables/table-storage-design)** - Design patterns and best practices

### Azure Security (20-25%)

#### Azure Active Directory (Microsoft Entra ID)
- **Identity platform** - Authentication and authorization
  - **[📖 Microsoft Entra ID Overview](https://learn.microsoft.com/en-us/entra/fundamentals/whatis)** - Identity and access management
  - **[📖 Microsoft Identity Platform](https://learn.microsoft.com/en-us/entra/identity-platform/)** - Complete developer documentation
  - **[📖 MSAL Overview](https://learn.microsoft.com/en-us/entra/identity-platform/msal-overview)** - Microsoft Authentication Library
  - **[📖 MSAL for .NET](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-web-app-dotnet-core-sign-in)** - Implement authentication in .NET apps
  - **[📖 OAuth 2.0 Flows](https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-auth-code-flow)** - Authorization code flow
  - **[📖 OAuth Client Credentials Flow](https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-client-creds-grant-flow)** - Service-to-service authentication
  - **[📖 App Registration](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app)** - Register applications in Entra ID
  - **[📖 Access Tokens](https://learn.microsoft.com/en-us/entra/identity-platform/access-tokens)** - Token structure and validation
  - **[📖 ID Tokens](https://learn.microsoft.com/en-us/entra/identity-platform/id-tokens)** - User identity claims
  - **[📖 Microsoft Graph API](https://learn.microsoft.com/en-us/graph/use-the-api)** - Access Microsoft 365 data

#### Managed Identity
- **Automatic credentials** - Azure-managed service identities
  - **[📖 Managed Identity Overview](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview)** - System and user-assigned identities
  - **[📖 Managed Identity Services](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/managed-identities-status)** - Services that support managed identity
  - **[📖 Managed Identity Token](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-to-use-vm-token)** - Acquire tokens programmatically

#### Azure Key Vault
- **Secrets management** - Keys, secrets, certificates
  - **[📖 Key Vault Overview](https://learn.microsoft.com/en-us/azure/key-vault/general/overview)** - Complete Key Vault documentation
  - **[📖 Key Vault Secrets](https://learn.microsoft.com/en-us/azure/key-vault/secrets/about-secrets)** - Store and retrieve secrets
  - **[📖 Key Vault Keys](https://learn.microsoft.com/en-us/azure/key-vault/keys/about-keys)** - Cryptographic keys management
  - **[📖 Key Vault Certificates](https://learn.microsoft.com/en-us/azure/key-vault/certificates/about-certificates)** - SSL/TLS certificate management
  - **[📖 Key Vault Access Policies](https://learn.microsoft.com/en-us/azure/key-vault/general/assign-access-policy)** - Control access to vault resources
  - **[📖 Key Vault SDK](https://learn.microsoft.com/en-us/azure/key-vault/general/developers-guide)** - Developer guide and SDK usage

#### App Configuration
- **Configuration management** - Centralized app settings, feature flags
  - **[📖 App Configuration Overview](https://learn.microsoft.com/en-us/azure/azure-app-configuration/overview)** - Centralized configuration service
  - **[📖 App Configuration Key-Values](https://learn.microsoft.com/en-us/azure/azure-app-configuration/concept-key-value)** - Store configuration data
  - **[📖 Feature Management](https://learn.microsoft.com/en-us/azure/azure-app-configuration/concept-feature-management)** - Feature flags and toggles
  - **[📖 App Configuration SDK](https://learn.microsoft.com/en-us/azure/azure-app-configuration/quickstart-dotnet-core-app)** - .NET integration

### Monitoring and Optimization (15-20%)

#### Application Insights
- **APM solution** - Application performance monitoring and diagnostics
  - **[📖 Application Insights Overview](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)** - Complete Application Insights docs
  - **[📖 Application Insights SDK](https://learn.microsoft.com/en-us/azure/azure-monitor/app/asp-net-core)** - Instrument .NET applications
  - **[📖 Custom Telemetry](https://learn.microsoft.com/en-us/azure/azure-monitor/app/api-custom-events-metrics)** - Track custom events and metrics
  - **[📖 Application Map](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-map)** - Visualize application components
  - **[📖 Availability Tests](https://learn.microsoft.com/en-us/azure/azure-monitor/app/availability-overview)** - Monitor endpoint availability
  - **[📖 Log Queries](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/get-started-queries)** - KQL query language
  - **[📖 Smart Detection](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/proactive-diagnostics)** - AI-powered anomaly detection
  - **[📖 Application Insights for Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-monitoring)** - Monitor Azure Functions

#### Azure Monitor
- **Observability platform** - Metrics, logs, alerts
  - **[📖 Azure Monitor Overview](https://learn.microsoft.com/en-us/azure/azure-monitor/overview)** - Complete monitoring platform
  - **[📖 Azure Monitor Metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/data-platform-metrics)** - Platform and custom metrics
  - **[📖 Azure Monitor Logs](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/data-platform-logs)** - Log Analytics workspace

#### Azure Cache for Redis
- **In-memory cache** - Distributed cache, session state
  - **[📖 Azure Cache for Redis Overview](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-overview)** - Managed Redis service
  - **[📖 Redis Cache Patterns](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-best-practices-development)** - Development best practices
  - **[📖 Redis Client Libraries](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-dotnet-core-quickstart)** - .NET client integration

#### Azure CDN
- **Content delivery network** - Global content distribution, caching
  - **[📖 Azure CDN Overview](https://learn.microsoft.com/en-us/azure/cdn/cdn-overview)** - CDN capabilities and features
  - **[📖 CDN Caching Rules](https://learn.microsoft.com/en-us/azure/cdn/cdn-caching-rules)** - Control cache behavior
  - **[📖 CDN Optimization](https://learn.microsoft.com/en-us/azure/cdn/cdn-optimization-overview)** - Delivery optimization types

### Azure Integration Services (15-20%)

#### Azure API Management
- **API gateway** - API lifecycle, policies, throttling
  - **[📖 API Management Overview](https://learn.microsoft.com/en-us/azure/api-management/api-management-key-concepts)** - Complete APIM documentation
  - **[📖 APIM Policies](https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-policies)** - Transform and protect APIs
  - **[📖 APIM Policy Reference](https://learn.microsoft.com/en-us/azure/api-management/api-management-policies)** - All available policies
  - **[📖 APIM Authentication](https://learn.microsoft.com/en-us/azure/api-management/api-management-authentication-policies)** - Backend authentication policies
  - **[📖 APIM Products](https://learn.microsoft.com/en-us/azure/api-management/api-management-howto-add-products)** - API products and subscriptions

#### Azure Event Grid
- **Event routing** - Publish-subscribe messaging, event-driven architecture
  - **[📖 Event Grid Overview](https://learn.microsoft.com/en-us/azure/event-grid/overview)** - Complete Event Grid documentation
  - **[📖 Event Grid Concepts](https://learn.microsoft.com/en-us/azure/event-grid/concepts)** - Events, topics, subscriptions
  - **[📖 Event Grid Schema](https://learn.microsoft.com/en-us/azure/event-grid/event-schema)** - Event structure and format
  - **[📖 Event Grid Filtering](https://learn.microsoft.com/en-us/azure/event-grid/event-filtering)** - Subject and advanced filtering

#### Azure Event Hubs
- **Event streaming** - Big data streaming, event ingestion
  - **[📖 Event Hubs Overview](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about)** - Complete Event Hubs documentation
  - **[📖 Event Hubs Features](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-features)** - Partitions, consumer groups, capture
  - **[📖 Event Hubs SDK](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-dotnet-standard-getstarted-send)** - Send and receive events

#### Azure Service Bus
- **Enterprise messaging** - Queues, topics, advanced messaging patterns
  - **[📖 Service Bus Overview](https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview)** - Complete Service Bus documentation
  - **[📖 Service Bus Queues](https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-queues-topics-subscriptions)** - Queues, topics, subscriptions
  - **[📖 Service Bus Sessions](https://learn.microsoft.com/en-us/azure/service-bus-messaging/message-sessions)** - FIFO guarantee with sessions
  - **[📖 Service Bus Dead Letter](https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-dead-letter-queues)** - Handle message failures

#### Azure Queue Storage
- **Simple queues** - Asynchronous message queue
  - **[📖 Queue Storage Overview](https://learn.microsoft.com/en-us/azure/storage/queues/storage-queues-introduction)** - Simple message queuing
  - **[📖 Queue Storage Operations](https://learn.microsoft.com/en-us/azure/storage/queues/storage-dotnet-how-to-use-queues)** - Send and receive messages

## Service Limits to Know

### Azure Functions
- **Consumption Plan timeout:** 5 minutes (default), 10 minutes (max)
- **Premium/Dedicated timeout:** 30 minutes (default), unlimited (configurable)
- **HTTP trigger timeout:** 230 seconds (function apps)
- **Max function instances:** 200 (Consumption), 100 (Premium default)
- **Max payload size:** 100 MB (HTTP trigger)
- **Max connections:** 300 (Consumption per instance)

### Azure App Service
- **Always On:** Required for continuous apps (not available in Free/Shared tiers)
- **Deployment slots:** 5 (Standard), 20 (Premium/Isolated)
- **Custom domains:** Unlimited (Basic and above)
- **Request timeout:** 240 seconds (default)
- **Max instances:** Varies by tier (30 for P3v3)

### Cosmos DB
- **Item size:** 2 MB max
- **Partition key:** 2 KB max value length
- **Container throughput:** 1,000,000 RU/s max (provisioned)
- **Consistency levels:** 5 options (Strong, Bounded staleness, Session, Consistent prefix, Eventual)
- **Transaction:** 100 operations, 4 MB (transactional batch)

### Azure Blob Storage
- **Block blob size:** 190.7 TiB max (4.77 TiB per block)
- **Block size:** 4,000 MiB max
- **Blocks per blob:** 50,000 max
- **Page blob size:** 8 TiB max
- **SAS token lifetime:** 1 hour recommended max for user delegation SAS

### API Management
- **Request size:** 1 MB (gateway)
- **Response size:** 4 MB (gateway)
- **Cache entry TTL:** 3600 seconds (default)
- **Rate limits:** Configurable per product/API/operation
- **Policy size:** 256 KB max

### Event Grid
- **Event size:** 1 MB max (64 KB increments billed separately)
- **Batch size:** 1 MB max (array of events)
- **Retry attempts:** Up to 30 attempts
- **Max delivery latency:** 24 hours

### Service Bus
- **Message size:** 256 KB (Standard), 100 MB (Premium - in chunks)
- **Queue/topic size:** 1-80 GB
- **Message TTL:** 14 days (default max)
- **Lock duration:** 5 minutes (default)
- **Max delivery count:** 10 (default)

## Azure Functions Triggers and Bindings

### Common Triggers
| Trigger | Use Case | Key Points |
|---------|----------|------------|
| **HTTP** | REST APIs, webhooks | Synchronous, return response directly |
| **Timer** | Scheduled tasks | CRON expressions, single instance |
| **Blob** | File processing | Triggered on new/updated blobs |
| **Queue Storage** | Async message processing | Automatic poison queue after 5 failures |
| **Service Bus** | Enterprise messaging | Sessions for FIFO, peek lock |
| **Event Grid** | Event-driven reactions | Push-based, low latency |
| **Event Hubs** | Stream processing | Checkpointing, consumer groups |
| **Cosmos DB** | Change data capture | Change feed processor |

### Common Bindings
| Binding | Direction | Use Case |
|---------|-----------|----------|
| **Blob Storage** | In/Out | Read/write files |
| **Cosmos DB** | In/Out | Read/write documents |
| **Table Storage** | In/Out | Read/write entities |
| **Queue Storage** | Out | Send messages |
| **Service Bus** | Out | Send messages to queue/topic |
| **Event Grid** | Out | Publish events |
| **SignalR** | Out | Real-time web messaging |
| **SendGrid** | Out | Send emails |

**Documentation:**
- **[📖 All Triggers and Bindings](https://learn.microsoft.com/en-us/azure/azure-functions/functions-triggers-bindings)** - Complete reference
- **[📖 HTTP Trigger](https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-http-webhook-trigger)** - HTTP trigger configuration
- **[📖 Timer Trigger](https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-timer)** - CRON expressions and scheduling
- **[📖 Blob Trigger](https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-storage-blob-trigger)** - Blob storage trigger details
- **[📖 Queue Trigger](https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-storage-queue-trigger)** - Queue storage trigger configuration
- **[📖 Service Bus Trigger](https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-service-bus-trigger)** - Service Bus queue and topic triggers
- **[📖 Event Grid Trigger](https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-event-grid-trigger)** - Event Grid event handling
- **[📖 Cosmos DB Trigger](https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-cosmosdb-v2-trigger)** - Change feed processing

## Azure Storage Access Methods

### Authentication Options
1. **Shared Key (Storage Account Key)**
   - Full access to storage account
   - Not recommended for client apps
   - **[📖 Shared Key Authorization](https://learn.microsoft.com/en-us/rest/api/storageservices/authorize-with-shared-key)** - Storage account keys

2. **Shared Access Signature (SAS)**
   - **Account SAS:** Access to multiple storage services
   - **Service SAS:** Access to specific service (Blob, Queue, Table, File)
   - **User Delegation SAS:** Secured with Entra ID credentials (most secure)
   - **[📖 SAS Overview](https://learn.microsoft.com/en-us/azure/storage/common/storage-sas-overview)** - Delegated access with SAS tokens
   - **[📖 Create User Delegation SAS](https://learn.microsoft.com/en-us/rest/api/storageservices/create-user-delegation-sas)** - Entra ID-secured SAS

3. **Azure Active Directory (Microsoft Entra ID)**
   - Role-based access control (RBAC)
   - Managed identity support
   - Most secure option
   - **[📖 Authorize with Entra ID](https://learn.microsoft.com/en-us/azure/storage/blobs/authorize-access-azure-active-directory)** - RBAC for storage

## Cosmos DB Consistency Levels

| Level | Guarantee | Use Case | Read Latency | Throughput |
|-------|-----------|----------|--------------|------------|
| **Strong** | Linearizability | Mission-critical | Highest | Lowest (2x RU) |
| **Bounded Staleness** | Lag by K versions or T time | Consistent within bounds | High | Low |
| **Session** | Read your writes within session | Most applications (default) | Medium | Medium |
| **Consistent Prefix** | Reads never see out-of-order writes | Low consistency needs | Low | High |
| **Eventual** | No ordering guarantee | Highest availability | Lowest | Highest |

**Documentation:**
- **[📖 Consistency Levels Explained](https://learn.microsoft.com/en-us/azure/cosmos-db/consistency-levels)** - Detailed comparison and guarantees

## Managed Identity vs Service Principal

| Feature | Managed Identity | Service Principal |
|---------|------------------|-------------------|
| **Credential management** | Automatic (Azure-managed) | Manual (secrets/certs) |
| **Rotation** | Automatic | Manual |
| **Use case** | Azure resources only | Any application |
| **Types** | System-assigned, User-assigned | N/A |
| **Cost** | Free | Free |
| **Best for** | Azure compute resources | Non-Azure apps, DevOps |

**When to use Managed Identity:**
- App Service, Azure Functions, VM, AKS accessing Azure services
- No credential management needed

**When to use Service Principal:**
- GitHub Actions, Azure DevOps pipelines
- On-premises applications
- Multi-tenant scenarios

**Documentation:**
- **[📖 When to Use Managed Identity](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview)** - Best practices

## API Management Policy Execution Order

### Inbound Processing
1. **inbound** policies (from product, API, operation)
2. Backend service called

### Outbound Processing
3. **backend** policies
4. **outbound** policies (from operation, API, product)
5. Response returned to client

### Error Handling
- **on-error** policies execute on any error

### Common Policies
| Policy | Purpose | Section |
|--------|---------|---------|
| **set-header** | Add/modify request header | inbound/outbound |
| **set-backend-service** | Change backend URL | inbound |
| **rate-limit** | Throttle calls by key | inbound |
| **quota** | Call volume quota | inbound |
| **validate-jwt** | Verify JWT token | inbound |
| **cache-lookup** | Check response cache | inbound |
| **cache-store** | Store response in cache | outbound |
| **retry** | Retry failed requests | inbound/outbound/backend |
| **mock-response** | Return mock response | inbound |

**Documentation:**
- **[📖 Policy Expressions](https://learn.microsoft.com/en-us/azure/api-management/api-management-policy-expressions)** - C# expressions in policies

## Event Grid vs Event Hubs vs Service Bus

| Feature | Event Grid | Event Hubs | Service Bus |
|---------|-----------|------------|-------------|
| **Pattern** | Pub/sub (reactive) | Streaming (data pipeline) | Enterprise messaging (transactional) |
| **Message size** | 1 MB | 1 MB | 256 KB (Std), 100 MB (Premium) |
| **Ordering** | Not guaranteed | Per partition | With sessions (FIFO) |
| **Retention** | No retention (push) | 1-7 days (90 days Premium) | None (message delivered once) |
| **Throughput** | High (millions/sec) | Very high (millions/sec) | Medium |
| **Use case** | React to state changes | Big data streaming, telemetry | Reliable message delivery, transactions |
| **Filtering** | Advanced filters | Consumer-side | Subscriptions (topics) |
| **Protocol** | HTTP, Azure Functions | AMQP, Kafka | AMQP, HTTP |
| **Dead letter** | Built-in | Manual implementation | Built-in |

**Documentation:**
- **[📖 Choose Between Messaging Services](https://learn.microsoft.com/en-us/azure/service-bus-messaging/compare-messaging-services)** - Service comparison

## Azure SDK Best Practices

### Client Lifecycle
```csharp
// DO: Reuse clients (singleton or static)
private static readonly BlobServiceClient _blobClient = new BlobServiceClient(connectionString);

// DON'T: Create new client per request
// var client = new BlobServiceClient(connectionString); // ❌
```

### Retry Policies
- **Default:** Exponential backoff with jitter
- **Transient errors:** Automatically retried (429, 500, 503, 504)
- **[📖 Retry Guidance](https://learn.microsoft.com/en-us/azure/architecture/best-practices/retry-service-specific)** - Service-specific retry patterns

### Authentication
```csharp
// Preferred: Managed Identity with DefaultAzureCredential
var credential = new DefaultAzureCredential();
var client = new BlobServiceClient(serviceUri, credential);
```

**Documentation:**
- **[📖 Azure SDK for .NET](https://learn.microsoft.com/en-us/dotnet/azure/sdk/azure-sdk-for-dotnet)** - Complete .NET SDK guide
- **[📖 Azure SDK for JavaScript](https://learn.microsoft.com/en-us/javascript/api/overview/azure/)** - Node.js SDK overview
- **[📖 Azure SDK for Python](https://learn.microsoft.com/en-us/python/api/overview/azure/)** - Python SDK overview
- **[📖 Azure SDK for Java](https://learn.microsoft.com/en-us/java/api/overview/azure/)** - Java SDK overview
- **[📖 DefaultAzureCredential](https://learn.microsoft.com/en-us/dotnet/api/azure.identity.defaultazurecredential)** - Simplified authentication
- **[📖 Azure Identity Library](https://learn.microsoft.com/en-us/dotnet/api/overview/azure/identity-readme)** - Authentication library for .NET

## Deployment Strategies

### App Service Deployment Slots
- **Blue-Green deployment:** Deploy to slot, test, then swap
- **A/B testing:** Route percentage of traffic to slot
- **Staged rollout:** Gradual traffic shifting
- **Auto-swap:** Automatic swap after deployment (CI/CD)
- **Swap with preview:** Test in production environment before completing swap

**Key points:**
- Settings can be "slot-specific" or "swap with slot"
- Connection strings should be slot-specific
- Swap is near-instantaneous (warm-up instances)

**Documentation:**
- **[📖 Deployment Best Practices](https://learn.microsoft.com/en-us/azure/app-service/deploy-best-practices#use-deployment-slots)** - Slot strategies

### Container Deployment Options

| Service | Use Case | Complexity | Orchestration |
|---------|----------|------------|---------------|
| **Web App for Containers** | Single container web apps | Low | None |
| **Azure Container Instances** | Quick container deployment, burst workloads | Low | None (container groups) |
| **Azure Container Apps** | Microservices, event-driven apps | Medium | Managed (KEDA) |
| **Azure Kubernetes Service** | Full container orchestration | High | Kubernetes |

**Documentation:**
- **[📖 Web App for Containers](https://learn.microsoft.com/en-us/azure/app-service/quickstart-custom-container)** - Deploy custom containers to App Service
- **[📖 Azure Container Apps Overview](https://learn.microsoft.com/en-us/azure/container-apps/overview)** - Serverless containers with KEDA
- **[📖 Container Apps Revisions](https://learn.microsoft.com/en-us/azure/container-apps/revisions)** - Versioning and traffic splitting

## CI/CD with Azure DevOps and GitHub Actions

### Azure Pipelines YAML
```yaml
trigger:
  - main

pool:
  vmImage: 'ubuntu-latest'

steps:
- task: DotNetCoreCLI@2
  inputs:
    command: 'build'
    projects: '**/*.csproj'
```

**Documentation:**
- **[📖 Azure Pipelines Overview](https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines)** - CI/CD with Azure DevOps
- **[📖 Azure Pipelines YAML Schema](https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/)** - Complete YAML reference
- **[📖 Deploy to App Service](https://learn.microsoft.com/en-us/azure/devops/pipelines/targets/webapp)** - Azure Pipelines deployment
- **[📖 Azure Pipeline Tasks](https://learn.microsoft.com/en-us/azure/devops/pipelines/tasks/reference/)** - Built-in task reference
- **[📖 Service Connections](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints)** - Connect to Azure resources

### GitHub Actions
```yaml
name: Deploy to Azure

on:
  push:
    branches: [main]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: azure/webapps-deploy@v2
```

**Documentation:**
- **[📖 GitHub Actions for Azure](https://learn.microsoft.com/en-us/azure/developer/github/github-actions)** - Deploy from GitHub to Azure
- **[📖 Azure Login Action](https://github.com/marketplace/actions/azure-login)** - Authenticate with Azure
- **[📖 Deploy to App Service with GitHub Actions](https://learn.microsoft.com/en-us/azure/app-service/deploy-github-actions)** - CI/CD workflow
- **[📖 Deploy to Functions with GitHub Actions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-how-to-github-actions)** - Function app deployment
- **[📖 GitHub Actions Marketplace](https://github.com/marketplace?type=actions&query=azure)** - Azure-specific actions

## Infrastructure as Code

### Azure CLI
- **Command-line tool** - Manage Azure resources from terminal
  - **[📖 Azure CLI Overview](https://learn.microsoft.com/en-us/cli/azure/what-is-azure-cli)** - Install and get started
  - **[📖 Azure CLI Reference](https://learn.microsoft.com/en-us/cli/azure/reference-index)** - Complete command reference
  - **[📖 Azure CLI for App Service](https://learn.microsoft.com/en-us/cli/azure/webapp)** - Manage web apps
  - **[📖 Azure CLI for Functions](https://learn.microsoft.com/en-us/cli/azure/functionapp)** - Manage function apps
  - **[📖 Azure CLI Scripts](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-script-template)** - Automate deployments

### ARM Templates and Bicep
- **Declarative IaC** - Define infrastructure in JSON or Bicep
  - **[📖 ARM Templates Overview](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/overview)** - Azure Resource Manager templates
  - **[📖 ARM Template Structure](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax)** - Template file structure
  - **[📖 Bicep Overview](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview)** - Domain-specific language for ARM
  - **[📖 Bicep vs ARM Templates](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/compare-template-syntax)** - Syntax comparison
  - **[📖 Deploy Bicep Files](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-cli)** - Azure CLI deployment

## Common Development Patterns

### Circuit Breaker
- Protect against cascading failures
- Use with Azure Cache, databases
- **[📖 Circuit Breaker Pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/circuit-breaker)** - Implementation guidance

### Retry Pattern
- Handle transient failures
- Exponential backoff with jitter
- **[📖 Retry Pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/retry)** - Retry strategies

### Cache-Aside
- Check cache first, then database
- Update cache on cache miss
- **[📖 Cache-Aside Pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cache-aside)** - Caching pattern

### Strangler Fig
- Gradually migrate legacy apps
- Route traffic incrementally to new system
- **[📖 Strangler Fig Pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/strangler-fig)** - Migration pattern

### Queue-Based Load Leveling
- Decouple services with queues
- Handle traffic spikes
- **[📖 Queue-Based Load Leveling](https://learn.microsoft.com/en-us/azure/architecture/patterns/queue-based-load-leveling)** - Queue pattern

### Additional Patterns
- **[📖 Competing Consumers](https://learn.microsoft.com/en-us/azure/architecture/patterns/competing-consumers)** - Multiple consumers processing messages
- **[📖 Priority Queue](https://learn.microsoft.com/en-us/azure/architecture/patterns/priority-queue)** - Process high-priority requests first
- **[📖 Publisher-Subscriber](https://learn.microsoft.com/en-us/azure/architecture/patterns/publisher-subscriber)** - Async event-driven messaging
- **[📖 Throttling](https://learn.microsoft.com/en-us/azure/architecture/patterns/throttling)** - Control resource consumption
- **[📖 Valet Key](https://learn.microsoft.com/en-us/azure/architecture/patterns/valet-key)** - Delegated access with tokens (SAS)

## Exam Tips - Key Concepts

### Azure Functions Best Practices
- ✅ Use environment variables for configuration (App Settings)
- ✅ Use dependency injection for services
- ✅ Store secrets in Key Vault, reference via App Config or Key Vault references
- ✅ Use Durable Functions for stateful workflows
- ✅ Use Premium plan for VNet integration and no cold starts
- ❌ Don't store state in function code
- ❌ Don't make functions dependent on each other

### Cosmos DB Best Practices
- ✅ Choose partition key based on access patterns (high cardinality)
- ✅ Use Session consistency for most applications
- ✅ Query within partition when possible
- ✅ Use change feed for event-driven processing
- ✅ Monitor RU consumption
- ❌ Don't use small partition keys (creates hot partitions)
- ❌ Don't query across partitions frequently

### Security Best Practices
- ✅ Use Managed Identity for Azure resource authentication
- ✅ Store secrets in Key Vault
- ✅ Use User Delegation SAS for temporary blob access
- ✅ Enable HTTPS-only for App Service and API Management
- ✅ Use Azure AD for user authentication
- ❌ Never store connection strings in code
- ❌ Don't use Storage Account Keys in client apps

### API Management Best Practices
- ✅ Use policies to transform requests/responses
- ✅ Implement rate limiting and quotas
- ✅ Use caching for GET operations
- ✅ Use Products to bundle APIs
- ✅ Validate JWT tokens in policies
- ❌ Don't expose backend URLs directly
- ❌ Don't skip authentication/authorization

### Monitoring Best Practices
- ✅ Enable Application Insights for all applications
- ✅ Use custom events and metrics for business KPIs
- ✅ Set up availability tests for critical endpoints
- ✅ Use Log Analytics for querying across resources
- ✅ Create alerts for key metrics and failures
- ❌ Don't ignore telemetry correlation (operation IDs)
- ❌ Don't over-sample telemetry in production

## Common Exam Scenarios

1. **"Authenticate users in web app"** → Azure AD (Microsoft Entra ID) with MSAL
2. **"Securely access Azure SQL from App Service"** → Managed Identity
3. **"Store application secrets"** → Key Vault with Key Vault references
4. **"Process files uploaded to Blob"** → Blob trigger in Azure Functions
5. **"Implement FIFO message processing"** → Service Bus queue with sessions
6. **"React to resource changes in Azure"** → Event Grid subscription
7. **"Implement centralized API gateway"** → API Management
8. **"Zero-downtime deployment"** → App Service deployment slots (swap)
9. **"Stream telemetry from IoT devices"** → Event Hubs with capture
10. **"Cache frequently accessed data"** → Azure Cache for Redis with cache-aside pattern
11. **"Monitor application performance"** → Application Insights with custom telemetry
12. **"Globally distributed database"** → Cosmos DB with multi-region writes
13. **"Temporary access to blob without exposing keys"** → User Delegation SAS
14. **"Run periodic background jobs"** → Azure Functions with Timer trigger
15. **"Implement feature flags"** → App Configuration with feature management

## Study Priorities

### High Priority (Must Know)
- Azure Functions development (triggers, bindings, Durable Functions)
- App Service deployment and configuration (slots, scaling)
- Managed Identity for authentication
- Key Vault secrets management
- Blob Storage operations and SAS tokens
- Cosmos DB partition keys and consistency levels
- API Management policies (especially authentication and caching)
- Application Insights telemetry and monitoring
- Event Grid, Event Hubs, Service Bus differences
- Azure AD authentication with MSAL

### Medium Priority (Important)
- Container deployment (ACI, AKS, Container Apps)
- Azure Cache for Redis patterns
- App Configuration and feature flags
- Service Bus sessions and dead letter queues
- Cosmos DB change feed
- Azure SDK best practices
- CI/CD with Azure Pipelines and GitHub Actions
- Queue Storage vs Service Bus Queue
- CDN and caching strategies

### Lower Priority (Good to Know)
- Table Storage design patterns
- Azure SQL connectivity options
- ARM templates and Bicep
- Azure Monitor Log Analytics (KQL)
- Durable Functions patterns (fan-out/fan-in, chaining)
- API Management developer portal
- Azure SignalR Service
- Logic Apps integration
- Event Grid domain topics

## Last-Minute Review

**Remember these:**
- Azure Functions Consumption timeout: 5 min default, 10 min max
- Cosmos DB item max size: 2 MB
- API Management gateway timeout: No hard limit (backend dependent)
- Managed Identity: No credential management needed
- User Delegation SAS: Most secure (uses Azure AD)
- Cosmos DB: Session consistency is default
- App Service slots: Test in prod environment before swap
- Event Grid: Push-based, no retention
- Service Bus: Pull-based, FIFO with sessions
- Key Vault: Soft-delete enabled by default

**Common gotchas:**
- App Service Free/Shared tier doesn't support Always On
- Azure Functions HTTP trigger timeout is 230 seconds for function apps (not configurable)
- Cosmos DB: Cross-partition queries consume more RUs
- Managed Identity doesn't work outside Azure (use Service Principal)
- SAS tokens should have minimum permissions and short lifetime
- App Service slot settings: connection strings are slot-specific by default
- Blob triggers have latency (use Event Grid trigger for faster response)
- Consumption plan functions can have cold starts (use Premium to avoid)
- DefaultAzureCredential tries multiple credential types in order
- Event Grid requires endpoint validation for webhook subscriptions

**SDK patterns:**
- Reuse client instances (singleton pattern)
- Use DefaultAzureCredential for authentication
- Implement exponential backoff for retries
- Handle transient failures gracefully
- Use async/await for all Azure SDK operations

**Security checklist:**
- Use Managed Identity wherever possible
- Store secrets in Key Vault, never in code
- Use User Delegation SAS for temporary access
- Enable HTTPS-only for all web services
- Validate JWT tokens in API Management
- Use RBAC for fine-grained access control
- Enable Application Insights for security monitoring

---

**Good luck on your exam!** Focus on hands-on practice - deploy applications to Azure using the portal, CLI, and SDKs. Understand the "why" behind each service choice, not just the "what". The exam tests practical development scenarios, so build real applications with these services.
