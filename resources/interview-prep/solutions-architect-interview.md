# Solutions Architect Interview Preparation Guide

## Overview

Solutions Architect interviews typically combine system design, cloud architecture, cost optimization, and behavioral questions. This guide covers common questions, frameworks for answering, and key concepts to prepare for.

---

## System Design Questions

### How to Approach System Design

1. **Clarify requirements** (2-3 minutes)
   - Functional requirements: what does the system do?
   - Non-functional requirements: scale, latency, availability, consistency
   - Ask about users, traffic volume, data size, and growth
2. **High-level design** (5-7 minutes)
   - Draw the major components and data flow
   - Identify APIs and interfaces
3. **Deep dive** (15-20 minutes)
   - Detail each component
   - Discuss database schema, caching, and messaging
   - Address scaling, fault tolerance, and monitoring
4. **Trade-offs and alternatives** (5 minutes)
   - Discuss what you would change at 10x or 100x scale
   - Mention alternatives you considered and why you chose this design

### Design a URL Shortener

**Requirements**: generate short URLs, redirect to original URL, analytics on clicks

- API: POST /shorten (long URL) returns short URL, GET /{shortCode} redirects
- Key decisions:
  - ID generation: counter-based, hash-based, or pre-generated IDs
  - Storage: key-value store (DynamoDB, Redis) for fast lookups
  - Base62 encoding for short codes (a-z, A-Z, 0-9)
- Scaling considerations:
  - Read-heavy workload (100:1 read-to-write ratio typical)
  - Cache popular URLs in Redis/Memcached
  - CDN for redirect responses (301 vs 302 trade-off)
- Analytics: async event stream (Kinesis/Kafka) for click tracking
- Availability: multi-region deployment for low latency redirects

### Design a Video Streaming Service (Netflix-like)

**Requirements**: upload videos, transcode, stream to millions of users

- Components:
  - Upload service: S3/GCS for raw video storage
  - Transcoding pipeline: AWS Elemental MediaConvert, FFmpeg on containers
  - CDN: CloudFront/Cloud CDN for global content delivery
  - Metadata service: database for video catalog, search index
  - Recommendation engine: ML-based, batch-processed
- Key decisions:
  - Adaptive bitrate streaming (HLS/DASH) for varying network conditions
  - Multiple resolution and codec transcoding
  - Pre-generate popular content at edge locations
- Scaling: CDN handles read scaling, transcoding scales with queues and workers
- Cost: CDN and storage are primary cost drivers

### Design a Real-Time Chat System

**Requirements**: 1-on-1 and group messaging, online presence, message history

- Components:
  - WebSocket gateway for persistent connections
  - Message routing service
  - Message storage (Cassandra/DynamoDB for write-heavy workload)
  - Presence service (Redis with TTL for online status)
  - Push notification service for offline users
- Key decisions:
  - WebSocket vs long polling vs Server-Sent Events
  - Message ordering: timestamp-based with vector clocks for conflicts
  - Fan-out on write vs fan-out on read for group messages
- Scaling: partition by user ID, horizontal WebSocket servers behind load balancer
- Reliability: message queue for durability, at-least-once delivery with deduplication

### Design a Rate Limiter

**Requirements**: limit API requests per user per time window

- Algorithms:
  - Token bucket: smooth rate limiting, allows bursts
  - Sliding window log: precise but memory-intensive
  - Sliding window counter: good balance of precision and memory
  - Fixed window counter: simplest but allows burst at window edges
- Implementation:
  - Redis for distributed counting (INCR with TTL)
  - Return HTTP 429 with Retry-After header
  - Headers: X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset
- Scaling: distributed Redis cluster, local cache for hot keys

---

## Architecture Trade-Offs

### SQL vs NoSQL

| Factor | SQL (RDS, Aurora, Cloud SQL) | NoSQL (DynamoDB, Cosmos DB, Firestore) |
|--------|-----|-------|
| Data model | Relational, structured | Flexible schema, document/key-value |
| Query patterns | Complex joins, ad hoc queries | Single-table design, known access patterns |
| Consistency | Strong (ACID) | Configurable (eventual or strong) |
| Scaling | Vertical (read replicas for reads) | Horizontal (partition-based) |
| Best for | Transactional systems, complex queries | High-throughput, predictable access patterns |

**When to choose SQL**: complex relationships, need for joins, ACID transactions, ad hoc reporting
**When to choose NoSQL**: massive scale, simple access patterns, flexible schema, low latency requirements

### Monolith vs Microservices

| Factor | Monolith | Microservices |
|--------|----------|---------------|
| Complexity | Simple to develop and deploy initially | Higher operational complexity |
| Scaling | Scale entire application | Scale individual services |
| Team structure | Small teams, shared codebase | Independent teams per service |
| Deployment | All-or-nothing releases | Independent deployments |
| Data management | Shared database | Database per service |

**Start with a monolith** when: small team, unclear domain boundaries, MVP stage
**Move to microservices** when: team is growing, need independent scaling, deployment bottlenecks

### Synchronous vs Asynchronous Communication

| Factor | Synchronous (HTTP/gRPC) | Asynchronous (Queues/Events) |
|--------|--------------------------|------------------------------|
| Latency | Immediate response | Eventual processing |
| Coupling | Tight (caller waits) | Loose (fire and forget) |
| Error handling | Caller handles errors directly | Dead letter queues, retries |
| Throughput | Limited by slowest service | Buffered by queue capacity |

**Use synchronous**: user-facing requests needing immediate response, simple request-reply
**Use asynchronous**: background processing, cross-service communication, spike handling

### Event-Driven vs Request-Driven

- Event-driven: services publish events, interested services subscribe
- Benefits: loose coupling, easy to add new consumers, natural audit log
- Challenges: eventual consistency, debugging complexity, event ordering
- Tools: SNS/SQS, EventBridge, Kafka, Pub/Sub, Event Grid

---

## Cloud-Specific Design Questions

### Design a Multi-Region Active-Active Architecture

- Global load balancing (Route 53, Traffic Manager, Cloud DNS)
- Data replication strategy (DynamoDB Global Tables, Cosmos DB multi-region, Spanner)
- Conflict resolution for concurrent writes
- Session management (stateless preferred, or distributed session store)
- Failover and health checking between regions

### Design a Serverless E-Commerce Backend

- API Gateway + Lambda/Cloud Functions for API layer
- DynamoDB/Firestore for product catalog and shopping cart
- SQS/Pub/Sub for order processing pipeline
- Step Functions for order fulfillment workflow
- S3/Cloud Storage for product images, CDN for delivery
- Cognito/Firebase Auth for user authentication

### Design for Disaster Recovery

- RPO (Recovery Point Objective): how much data can you afford to lose?
- RTO (Recovery Time Objective): how quickly must you recover?
- DR strategies (from cheapest to most expensive):
  1. Backup and restore (RPO: hours, RTO: hours)
  2. Pilot light (RPO: minutes, RTO: minutes-hours)
  3. Warm standby (RPO: seconds-minutes, RTO: minutes)
  4. Multi-site active-active (RPO: near-zero, RTO: near-zero)

---

## Cost Optimization Scenarios

### How Would You Reduce AWS Costs by 40%?

- Analyze with Cost Explorer and identify top spending categories
- Right-size instances using Compute Optimizer recommendations
- Purchase Savings Plans or Reserved Instances for steady-state workloads
- Move infrequently accessed data to cheaper storage tiers (S3 IA, Glacier)
- Use Spot Instances for fault-tolerant workloads (batch processing, CI/CD)
- Implement auto-scaling to match capacity with demand
- Review and delete unused resources (unattached EBS volumes, idle load balancers)
- Consolidate underutilized databases
- Use caching to reduce compute and database costs

### Cost-Optimize a Data Pipeline

- Use Spot Instances or preemptible VMs for batch processing
- Schedule processing during off-peak hours for lower pricing
- Compress data before storage and transfer
- Use columnar formats (Parquet, ORC) for analytics
- Implement data lifecycle policies (archive old data, delete expired data)
- Use serverless (Lambda, Cloud Functions) for intermittent processing
- Choose the right database tier (provisioned vs serverless)

---

## Behavioral Questions

### STAR Method Framework

- **Situation**: set the context (project, team, challenge)
- **Task**: describe your responsibility
- **Action**: explain what you specifically did
- **Result**: quantify the outcome

### Common Behavioral Questions

**Tell me about a time you had to make a design decision under uncertainty.**
- Focus on how you gathered information, evaluated trade-offs, and mitigated risk
- Show you are comfortable making decisions with incomplete information
- Mention how you created reversibility (feature flags, abstraction layers)

**Describe a situation where you disagreed with a technical decision.**
- Show respect for the other perspective
- Explain how you presented data and evidence
- Discuss the outcome and what you learned
- Demonstrate willingness to commit even if you disagreed (disagree and commit)

**How do you handle a situation where the business wants a feature delivered faster than you think is safe?**
- Discuss risk communication and trade-off presentation
- Explain how you would propose phased delivery
- Show ability to balance business needs with technical quality
- Mention specific techniques: MVP approach, feature flags, tech debt tracking

**Tell me about a project that failed and what you learned.**
- Be honest and take appropriate ownership
- Focus on lessons learned and changes you made afterward
- Show growth mindset and ability to adapt
- Avoid blaming others or external factors

---

## How to Structure Your Answers

### System Design Answer Framework

1. Requirements and constraints (always start here)
2. API design and data model
3. High-level architecture diagram
4. Component deep dive
5. Scaling and performance optimization
6. Monitoring and operational considerations
7. Trade-offs and alternatives considered

### Cloud Architecture Answer Framework

1. Identify the workload characteristics (compute, storage, network patterns)
2. Choose appropriate services (explain why, not just what)
3. Design for the non-functional requirements (availability, durability, security)
4. Address cost optimization from the start
5. Explain the operational model (monitoring, deployment, incident response)

### Tips for Success

- Think out loud - interviewers want to see your reasoning process
- Ask clarifying questions before diving into design
- Start with the simplest solution and add complexity as needed
- Always discuss trade-offs - there is no perfect design
- Mention monitoring, logging, and alerting proactively
- Consider security at every layer (defense in depth)
- Quantify when possible (latency targets, throughput requirements, cost estimates)
- Draw diagrams - visual communication is highly valued
- Practice explaining complex concepts simply
- Be honest about what you do not know - then reason through it

---

## Recommended Preparation Resources

- System Design Interview by Alex Xu (Volume 1 and Volume 2)
- Designing Data-Intensive Applications by Martin Kleppmann
- AWS Well-Architected Framework: https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html
- Azure Architecture Center: https://learn.microsoft.com/en-us/azure/architecture/
- Google Cloud Architecture Framework: https://cloud.google.com/architecture/framework
