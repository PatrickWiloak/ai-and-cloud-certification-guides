# Architecture Pattern - API Gateway

## Overview

The API Gateway pattern provides a single entry point for client requests to backend microservices. It handles cross-cutting concerns like authentication, rate limiting, request routing, protocol translation, and response aggregation - simplifying client interactions with distributed systems.

---

## Pattern Description

### Problem
- Clients need to interact with multiple microservices
- Each service may use different protocols, authentication mechanisms, and data formats
- Direct client-to-service communication creates tight coupling
- Cross-cutting concerns (auth, logging, rate limiting) are duplicated across services

### Solution
Place an API Gateway between clients and backend services that:
- Routes requests to appropriate backend services
- Aggregates responses from multiple services
- Handles authentication and authorization centrally
- Applies rate limiting and throttling
- Transforms protocols and data formats
- Provides a stable API contract regardless of backend changes

### When to Use
- Microservices architectures with multiple backend services
- Mobile/web applications needing optimized API responses
- Multi-tenant SaaS platforms requiring per-tenant controls
- Public APIs requiring monetization and developer portals
- Systems needing protocol translation (REST to gRPC, SOAP to REST)

### When to Avoid
- Simple monolithic applications with a single backend
- Internal service-to-service communication (use service mesh instead)
- Real-time streaming workloads (use direct connections)
- When latency sensitivity prohibits an additional network hop

---

## Architecture Components

### Core Components

```
                    ┌─────────────────┐
   Clients ──────>  │   API Gateway    │
   (Web, Mobile,    │                  │
    IoT, Partners)  │  - Auth          │
                    │  - Rate Limit    │
                    │  - Routing       │
                    │  - Transform     │
                    │  - Cache         │
                    └────────┬─────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
         ┌────▼────┐   ┌────▼────┐   ┌────▼────┐
         │Service A │   │Service B │   │Service C │
         │(Orders)  │   │(Users)   │   │(Products)│
         └──────────┘   └──────────┘   └──────────┘
```

### Gateway Responsibilities

| Responsibility | Description | Implementation |
|----------------|-------------|----------------|
| Request Routing | Route requests to backend services | Path-based, header-based, query-based |
| Authentication | Validate identity tokens | JWT validation, OAuth 2.0, API keys |
| Authorization | Enforce access policies | Scopes, RBAC, custom authorizers |
| Rate Limiting | Throttle requests per client | Token bucket, sliding window |
| Caching | Cache frequent responses | In-memory, Redis, CDN |
| Load Balancing | Distribute across service instances | Round-robin, weighted, least connections |
| Circuit Breaking | Prevent cascading failures | Timeout, retry, fallback |
| Request/Response Transform | Modify payloads | Header injection, body transformation |
| Aggregation | Combine multiple service responses | Backend-for-frontend pattern |
| Logging/Monitoring | Centralized observability | Access logs, metrics, tracing |

---

## Cloud Implementation

### AWS Implementation

| Component | AWS Service | Notes |
|-----------|-------------|-------|
| API Gateway | Amazon API Gateway (REST, HTTP, WebSocket) | Managed, serverless |
| Custom Authorizer | Lambda Authorizer | JWT, custom auth logic |
| Rate Limiting | API Gateway Usage Plans | Per API key throttling |
| Caching | API Gateway Cache | 0.5 - 237 GB |
| WAF | AWS WAF | Attached to API Gateway |
| Backend Integration | Lambda, ALB, HTTP endpoints, AWS services | Direct integration |
| Developer Portal | Third-party (SwaggerHub, Readme) | No native portal |
| Monitoring | CloudWatch, X-Ray | Metrics, tracing |
| CDN | CloudFront (in front of API Gateway) | Edge caching, global distribution |

**AWS Architecture:**
```
CloudFront -> WAF -> API Gateway -> Lambda Authorizer
                                 -> Lambda (backend)
                                 -> ALB -> ECS/EKS
                                 -> Step Functions
                                 -> DynamoDB (direct integration)
```

### Azure Implementation

| Component | Azure Service | Notes |
|-----------|---------------|-------|
| API Gateway | Azure API Management | Full lifecycle management |
| Authentication | OAuth 2.0, JWT validation (policy) | Built-in policies |
| Rate Limiting | Rate-limit / quota policies | Per subscription/product |
| Caching | Built-in cache, Azure Cache for Redis | Policy-based |
| WAF | Azure Application Gateway + WAF | Front-end protection |
| Backend Integration | Azure Functions, App Service, AKS, Logic Apps | Direct integration |
| Developer Portal | Built-in developer portal | Customizable |
| Monitoring | Azure Monitor, Application Insights | Integrated analytics |
| CDN | Azure Front Door | Global load balancing + CDN |

**Azure Architecture:**
```
Azure Front Door -> WAF -> API Management -> Azure Functions
                                          -> App Service
                                          -> AKS
                                          -> Logic Apps
```

### Google Cloud Implementation

| Component | GCP Service | Notes |
|-----------|-------------|-------|
| API Gateway | Apigee, API Gateway | Apigee for full lifecycle |
| Authentication | Firebase Auth, IAM, JWT | Policy-based |
| Rate Limiting | Apigee policies (spike arrest, quota) | Flexible policies |
| Caching | Apigee response cache | Policy-based |
| WAF | Cloud Armor | Attached to load balancer |
| Backend Integration | Cloud Functions, Cloud Run, GKE | Via load balancer |
| Developer Portal | Apigee integrated portal | Built-in |
| Monitoring | Cloud Monitoring, Cloud Trace | Integrated |
| CDN | Cloud CDN | Global caching |

**GCP Architecture:**
```
Cloud CDN -> Cloud Armor -> Global LB -> API Gateway/Apigee -> Cloud Run
                                                             -> Cloud Functions
                                                             -> GKE
```

---

## Design Patterns

### Backend for Frontend (BFF)

Deploy separate API gateways optimized for each client type.

| Client | Gateway | Optimization |
|--------|---------|-------------|
| Web Browser | Web BFF | Full payloads, pagination |
| Mobile App | Mobile BFF | Compact payloads, offline-first |
| IoT Devices | IoT BFF | Minimal payloads, batch operations |
| Third-Party | Public API | Stable versioning, documentation |

### API Composition / Aggregation

The gateway aggregates responses from multiple services into a single response.

```
Client Request: GET /order-summary/123

Gateway calls in parallel:
  - Order Service: GET /orders/123
  - User Service: GET /users/456
  - Product Service: GET /products/789

Gateway response: Combined order + user + product data
```

### Gateway Offloading

Move cross-cutting concerns from services to the gateway.

| Concern | Service-Level | Gateway-Level |
|---------|--------------|---------------|
| TLS Termination | Each service manages certs | Gateway terminates TLS |
| Authentication | Each service validates tokens | Gateway validates tokens |
| CORS | Each service configures CORS | Gateway handles CORS |
| Compression | Each service compresses | Gateway compresses responses |
| IP Allowlisting | Each service checks IPs | Gateway enforces IP rules |

---

## API Versioning Strategies

| Strategy | Example | Pros | Cons |
|----------|---------|------|------|
| URL Path | /v1/users, /v2/users | Simple, explicit | URL pollution |
| Query Parameter | /users?version=2 | Easy to default | Easy to miss |
| Header | Accept: application/vnd.api.v2+json | Clean URLs | Less discoverable |
| Content Negotiation | Accept: application/json; version=2 | HTTP standard | Complex |

### Implementation per Cloud

| Strategy | AWS API Gateway | Azure APIM | Apigee |
|----------|----------------|------------|--------|
| URL Path | Stage variables + path routing | API revisions + versioning | Proxy basepath versioning |
| Header-based | Lambda authorizer routing | Policies (set-backend) | Conditional routing |
| Canary | Canary deployments | Revisions (traffic split) | Traffic management |

---

## Security Best Practices

### Defense in Depth

| Layer | Control | Implementation |
|-------|---------|----------------|
| Edge | DDoS protection | Shield/DDoS Protection/Cloud Armor |
| Edge | WAF rules | OWASP rules, bot protection |
| Gateway | Authentication | OAuth 2.0, JWT, API keys |
| Gateway | Authorization | Scopes, custom policies |
| Gateway | Rate limiting | Per-client, per-endpoint |
| Gateway | Input validation | Schema validation, size limits |
| Backend | Service auth | mTLS, service mesh |
| Data | Encryption | TLS in transit, KMS at rest |

### Common Security Patterns

1. **Token Relay** - Gateway validates JWT, passes claims to backend via headers
2. **Token Exchange** - Gateway exchanges external token for internal service token
3. **API Key + OAuth** - API key for identification, OAuth for authorization
4. **mTLS Backend** - TLS between gateway and services with client certificates
5. **Request Signing** - Gateway signs requests for backend verification

---

## Performance Optimization

| Technique | Description | Impact |
|-----------|-------------|--------|
| Response Caching | Cache GET responses at gateway | Reduces backend load 60-90% |
| Connection Pooling | Reuse backend connections | Reduces latency 20-40% |
| Compression | gzip/brotli responses | Reduces bandwidth 60-80% |
| Request Collapsing | Batch duplicate concurrent requests | Reduces backend calls |
| Async Processing | Accept request, process async | Improves perceived latency |
| Edge Deployment | CDN + gateway at edge | Reduces round-trip latency |

---

## Monitoring and Observability

| Metric | Description | Alert Threshold |
|--------|-------------|-----------------|
| Request Rate | Requests per second | Anomaly detection |
| Error Rate | 4xx and 5xx percentage | > 1% (4xx), > 0.1% (5xx) |
| Latency (p50/p95/p99) | Response time distribution | p99 > SLA target |
| Cache Hit Ratio | Percentage of cached responses | < 50% (investigate) |
| Backend Health | Service availability | Any backend unhealthy |
| Throttled Requests | Rate-limited request count | Sustained throttling |
| Authentication Failures | Failed auth attempts | Spike detection |

---

## Certification Exam Focus Areas

### AWS
- API Gateway REST vs HTTP API vs WebSocket API differences
- Lambda authorizer types (token vs request)
- Usage plans, API keys, and throttling configuration
- Stage variables and canary deployments
- VPC link for private integrations

### Azure
- APIM tiers (Consumption, Developer, Basic, Standard, Premium)
- Policy expressions and policy scopes (inbound, backend, outbound, on-error)
- Products, subscriptions, and developer portal
- Self-hosted gateway for hybrid/multi-cloud
- Backend circuit breaker and retry policies

### Google Cloud
- Apigee vs API Gateway decision criteria
- Apigee proxy flow (PreFlow, Conditional Flows, PostFlow)
- API products, developer apps, and monetization
- Cloud Endpoints for gRPC and OpenAPI
- ESP (Extensible Service Proxy) for authentication

---

## Documentation Links

- AWS API Gateway: https://docs.aws.amazon.com/apigateway/latest/developerguide/
- Azure API Management: https://learn.microsoft.com/en-us/azure/api-management/
- Google Apigee: https://cloud.google.com/apigee/docs
- Google API Gateway: https://cloud.google.com/api-gateway/docs
- API Gateway Pattern (Microsoft): https://learn.microsoft.com/en-us/azure/architecture/microservices/design/gateway

---

## Key Takeaways

1. The API Gateway pattern is essential for microservices - it simplifies client communication and centralizes cross-cutting concerns
2. Choose between managed (API Gateway, APIM, Apigee) vs self-hosted (Kong, NGINX, Envoy) based on operational maturity
3. BFF pattern prevents a single gateway from becoming a bottleneck by optimizing per client type
4. Always implement rate limiting, authentication, and WAF at the gateway level
5. Cache aggressively at the gateway - most read-heavy APIs benefit significantly
6. Monitor gateway latency carefully - it adds an extra hop to every request
7. API versioning strategy should be decided early and applied consistently
