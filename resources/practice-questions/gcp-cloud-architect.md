# Google Cloud Professional Cloud Architect Practice Questions

40 scenario-based questions weighted by exam domain.

## Exam Domain Breakdown
| Domain | Weight | Questions |
|--------|--------|-----------|
| Design and plan a cloud solution architecture | 24% | 10 |
| Manage and provision cloud solution infrastructure | 15% | 6 |
| Design for security and compliance | 18% | 7 |
| Analyze and optimize technical and business processes | 18% | 7 |
| Manage implementation | 11% | 4 |
| Ensure solution and operations reliability | 14% | 6 |

---

## Domain 1: Design and Plan a Cloud Solution Architecture (Questions 1-10)

### Question 1
**Scenario:** A global e-commerce company needs to design a solution that provides consistent low latency for users worldwide. Their application requires a relational database that supports strong consistency across regions and automatic failover. Which database solution should they choose?

A. Cloud SQL with cross-region read replicas
B. Cloud Spanner with multi-region configuration
C. Cloud Firestore in multi-region mode
D. BigQuery with regional datasets

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Cloud Spanner provides a globally distributed, strongly consistent relational database with automatic failover. It supports horizontal scaling and maintains strong consistency across regions using TrueTime. Cloud SQL read replicas (A) are asynchronous and don't provide strong consistency across regions. Firestore (C) is NoSQL. BigQuery (D) is for analytics, not transactional workloads.

**Key Concept:** [Cloud Spanner](https://cloud.google.com/spanner/docs/overview)
</details>

### Question 2
**Scenario:** A media company needs to process video uploads. Videos should be transcoded to multiple formats, thumbnails should be generated, and metadata should be stored. The workload is unpredictable with peaks during events. What architecture should they design?

A. VM instances with manual scaling
B. Event-driven architecture with Cloud Storage triggers, Cloud Functions/Cloud Run for processing, and Firestore for metadata
C. Single large Compute Engine instance
D. App Engine standard environment

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Event-driven architecture handles variable workloads efficiently. Cloud Storage triggers invoke Cloud Functions or Cloud Run when videos are uploaded. Transcoding can use Cloud Run Jobs or Batch for long-running tasks. Firestore stores metadata. Scales to zero when idle and handles peaks automatically. Manual scaling (A) doesn't handle spikes well. Single instance (C) is a bottleneck. App Engine (D) isn't ideal for video processing.

**Key Concept:** [Event-Driven Architecture](https://cloud.google.com/architecture/event-driven-architecture)
</details>

### Question 3
**Scenario:** A company wants to migrate their monolithic application to GCP. They want to minimize changes initially but position for future modernization. What migration strategy should they use?

A. Rewrite the application from scratch
B. Lift and shift to Compute Engine, then incrementally modernize using Strangler Fig pattern
C. Immediately containerize everything
D. Use Cloud Functions for the entire application

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Lift and shift to Compute Engine minimizes initial changes while establishing GCP presence. The Strangler Fig pattern allows incremental modernization - extracting microservices over time while the monolith remains functional. Rewriting (A) is risky and time-consuming. Immediate containerization (C) requires significant changes. Functions (D) aren't suitable for monoliths.

**Key Concept:** [Application Modernization](https://cloud.google.com/architecture/application-modernization)
</details>

### Question 4
**Scenario:** A healthcare company needs to store and analyze patient data. Data must be encrypted, access must be audited, and the solution must comply with HIPAA. They need to run complex analytics queries. What storage and analytics solution should they use?

A. Cloud Storage with default encryption
B. BigQuery with customer-managed encryption keys (CMEK), IAM, and Cloud Audit Logs
C. Compute Engine with local storage
D. Cloud Bigtable for analytics

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** BigQuery provides enterprise data warehouse capabilities for complex analytics. CMEK enables customer-controlled encryption. IAM provides granular access control. Cloud Audit Logs track all data access for compliance. BigQuery can be configured for HIPAA compliance. Default encryption (A) doesn't provide customer control. Bigtable (D) is for operational workloads, not complex analytics.

**Key Concept:** [BigQuery Security](https://cloud.google.com/bigquery/docs/best-practices-security)
</details>

### Question 5
**Scenario:** A company has a high-traffic website with static content (images, CSS, JS) and dynamic API calls. They want to optimize performance and reduce origin server load. What architecture should they implement?

A. Single Compute Engine instance for all traffic
B. Cloud CDN for static content, Cloud Load Balancing with Cloud Run backend for dynamic APIs
C. Cloud Storage for static content without CDN
D. All content served from Cloud Functions

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Cloud CDN caches static content at edge locations worldwide, reducing latency and origin load. Cloud Load Balancing distributes API traffic. Cloud Run provides auto-scaling container-based backend for APIs. This separation optimizes each content type. Single instance (A) doesn't scale. Storage without CDN (C) lacks edge caching. Functions for everything (D) is expensive for static content.

**Key Concept:** [Cloud CDN](https://cloud.google.com/cdn/docs/overview)
</details>

### Question 6
**Scenario:** A startup is building a real-time multiplayer game. They need sub-100ms latency for game state updates, persistence for player data, and the ability to handle millions of concurrent connections. What architecture should they design?

A. Cloud SQL for all data
B. Cloud Memorystore (Redis) for game state, Cloud Firestore for player data, and Cloud Run with WebSockets or Agones on GKE
C. BigQuery for real-time updates
D. Single VM with in-memory data

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Memorystore (Redis) provides sub-millisecond latency for game state. Firestore offers real-time sync and automatic scaling for player data. Cloud Run or Agones (game server management on GKE) handles WebSocket connections with auto-scaling. Cloud SQL (A) has higher latency. BigQuery (C) is for analytics. Single VM (D) doesn't scale.

**Key Concept:** [Game Architecture](https://cloud.google.com/architecture/gaming)
</details>

### Question 7
**Scenario:** A financial services company needs to process streaming transaction data, detect fraud in real-time, and store data for batch analytics. What architecture should they implement?

A. Batch processing only
B. Pub/Sub for ingestion, Dataflow for stream processing and fraud detection, BigQuery for storage and analytics
C. Cloud SQL for all processing
D. Direct writes to BigQuery

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Pub/Sub provides durable, scalable message ingestion. Dataflow processes streams in real-time with exactly-once semantics - ideal for fraud detection logic. BigQuery stores processed data for batch analytics and reporting. This is the standard streaming architecture on GCP. Batch only (A) has latency. Cloud SQL (C) doesn't handle streaming. Direct BigQuery writes (D) add latency and don't allow real-time processing.

**Key Concept:** [Stream Analytics Architecture](https://cloud.google.com/architecture/stream-analytics)
</details>

### Question 8
**Scenario:** A company has development, staging, and production environments. They want environment isolation, consistent deployments, and the ability to share common resources (like container images). How should they structure their GCP organization?

A. Single project for all environments
B. Separate projects per environment (dev, staging, prod) with shared services project, managed through folders
C. Separate GCP accounts
D. Different regions for each environment

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Separate projects provide resource isolation, IAM boundaries, and billing separation. A shared services project hosts common resources like Container Registry/Artifact Registry. Folders organize projects under the organization with inherited policies. Single project (A) lacks isolation. Separate accounts (C) complicate management. Regions (D) are for geographic distribution.

**Key Concept:** [Resource Hierarchy](https://cloud.google.com/resource-manager/docs/cloud-platform-resource-hierarchy)
</details>

### Question 9
**Scenario:** A machine learning team needs to train models on large datasets. Training jobs run for hours and require GPUs. They want to minimize cost while maintaining performance. What compute solution should they use?

A. Persistent GPU VMs running continuously
B. Vertex AI Training with preemptible/spot VMs, or GKE with spot node pools
C. Cloud Functions for ML training
D. Standard VMs without GPUs

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Vertex AI Training manages ML jobs with automatic infrastructure provisioning. Preemptible/spot VMs cost up to 91% less than regular VMs. Training jobs can checkpoint and resume if preempted. GKE with spot node pools provides similar benefits for custom training. Persistent VMs (A) waste money when not training. Functions (C) have time limits and no GPUs. Non-GPU VMs (D) are slower.

**Key Concept:** [Vertex AI Training](https://cloud.google.com/vertex-ai/docs/training/overview)
</details>

### Question 10
**Scenario:** A company wants to implement a data lake on GCP. They have structured data from databases, semi-structured logs, and unstructured documents. All data should be queryable and governed. What architecture should they implement?

A. Cloud SQL for all data types
B. Cloud Storage as data lake with BigQuery for analytics, Data Catalog for governance, and Dataproc for processing
C. Separate systems for each data type
D. BigQuery only

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Cloud Storage provides cost-effective storage for all data types (data lake). BigQuery queries data in Cloud Storage directly (external tables) and stores processed data. Data Catalog provides metadata management and data governance. Dataproc runs Spark/Hadoop for complex processing. Cloud SQL (A) isn't a data lake. Separate systems (C) create silos. BigQuery only (D) is expensive for raw storage.

**Key Concept:** [Data Lake Architecture](https://cloud.google.com/architecture/build-a-data-lake-on-gcp)
</details>

---

## Domain 2: Manage and Provision Cloud Solution Infrastructure (Questions 11-16)

### Question 11
**Scenario:** A company needs to deploy consistent infrastructure across development, staging, and production environments. Changes should be reviewed before applying, and infrastructure state should be tracked. What approach should they use?

A. Manual console deployment
B. Terraform with remote state in Cloud Storage, infrastructure as code in Git with Cloud Build
C. Deployment Manager only
D. Scripts without version control

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Terraform provides infrastructure as code with state management. Remote state in Cloud Storage enables team collaboration. Git provides version control and code review. Cloud Build automates deployment with PR-based workflows. Manual deployment (A) causes drift. Deployment Manager (C) is GCP-only and less feature-rich. Scripts without VCS (D) lack reproducibility.

**Key Concept:** [Terraform on GCP](https://cloud.google.com/docs/terraform)
</details>

### Question 12
**Scenario:** A team needs to deploy containers to GCP without managing Kubernetes clusters. They need auto-scaling, HTTPS endpoints, and integration with Cloud SQL. What service should they use?

A. Compute Engine with Docker
B. Cloud Run with Cloud SQL connector
C. App Engine Flex
D. Cloud Functions

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Cloud Run is serverless containers - no cluster management. It auto-scales to zero, provides HTTPS endpoints automatically, and has native Cloud SQL connector support for secure database connections. CE with Docker (A) requires VM management. App Engine Flex (C) is similar but less flexible. Functions (D) aren't containers.

**Key Concept:** [Cloud Run](https://cloud.google.com/run/docs/overview/what-is-cloud-run)
</details>

### Question 13
**Scenario:** A company's application requires instances in multiple zones for high availability. If one zone fails, traffic should automatically route to healthy instances. What configuration is needed?

A. Single zone deployment
B. Managed instance group (MIG) with regional configuration and Cloud Load Balancing
C. Multiple unmanaged instances
D. Zone-specific DNS records

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Regional MIGs distribute instances across multiple zones with automatic healing. Cloud Load Balancing detects unhealthy instances and routes traffic to healthy ones. Automatic failover between zones. Single zone (A) isn't HA. Unmanaged instances (C) don't auto-heal. DNS records (D) require manual failover.

**Key Concept:** [Regional MIGs](https://cloud.google.com/compute/docs/instance-groups/distributing-instances-with-regional-instance-groups)
</details>

### Question 14
**Scenario:** A GKE cluster needs to be updated to a new Kubernetes version. The update should cause no downtime, and the team wants to test the new version before full rollout. What strategy should they use?

A. In-place upgrade of all nodes immediately
B. Blue-green node pool upgrade with surge upgrades
C. Delete and recreate the cluster
D. Never upgrade

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Blue-green upgrades create a new node pool with the new version. Workloads gradually migrate. Surge upgrades add extra capacity during the upgrade. If issues occur, traffic can shift back to the old node pool. In-place (A) risks downtime. Delete/recreate (C) causes major downtime. Never upgrading (D) creates security risks.

**Key Concept:** [GKE Upgrades](https://cloud.google.com/kubernetes-engine/docs/concepts/node-pool-upgrade-strategies)
</details>

### Question 15
**Scenario:** A company needs to provide developers self-service access to create GCP resources within budget limits and approved configurations. What should they implement?

A. Give developers project owner access
B. Service Catalog with approved Terraform modules and Budget alerts
C. Manual approval for each request
D. No restrictions

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Service Catalog provides a curated list of approved solutions (Terraform modules) developers can deploy. Budget alerts notify on spending. This balances self-service with governance. Project owner (A) is too permissive. Manual approval (C) slows development. No restrictions (D) risks cost overruns and non-compliance.

**Key Concept:** [Service Catalog](https://cloud.google.com/service-catalog/docs/overview)
</details>

### Question 16
**Scenario:** A company needs to manage multiple GKE clusters across different environments and regions. They want centralized policy management and consistent security configurations. What should they use?

A. Manage each cluster independently
B. GKE Fleet with Config Sync for policy management
C. Single cluster for everything
D. Different GCP accounts per cluster

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** GKE Fleet provides centralized multi-cluster management. Config Sync (Anthos Config Management) applies consistent Kubernetes configurations and policies across all clusters from a Git repository. GitOps approach. Independent management (A) causes drift. Single cluster (C) lacks isolation. Different accounts (D) complicate management.

**Key Concept:** [GKE Fleet](https://cloud.google.com/anthos/fleet-management/docs/fleet-overview)
</details>

---

## Domain 3: Design for Security and Compliance (Questions 17-23)

### Question 17
**Scenario:** A company needs to ensure that all data in Cloud Storage is encrypted with keys they control. They need to rotate keys annually and audit all key usage. What should they configure?

A. Default Google-managed encryption
B. Customer-managed encryption keys (CMEK) with Cloud KMS and key rotation policy
C. Client-side encryption only
D. No encryption

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** CMEK in Cloud KMS provides customer-controlled keys for Cloud Storage encryption. Automatic key rotation can be configured (annual or custom). Cloud Audit Logs track all key usage. Default encryption (A) uses Google-managed keys. Client-side (C) is additional, not replacement. No encryption (D) violates requirements.

**Key Concept:** [Cloud KMS](https://cloud.google.com/kms/docs/overview)
</details>

### Question 18
**Scenario:** A company's applications running on GCP need to access Cloud APIs without storing service account keys. Applications run on Compute Engine, GKE, and Cloud Run. What should they use?

A. Store service account keys in the application
B. Workload Identity (GKE), attached service accounts (Compute Engine), and default service account (Cloud Run)
C. API keys
D. User credentials

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Workload Identity maps Kubernetes service accounts to GCP service accounts - no keys in pods. Compute Engine can attach service accounts to instances. Cloud Run automatically uses the configured service account. No key management required. Stored keys (A) can be leaked. API keys (C) lack fine-grained permissions. User credentials (D) aren't for applications.

**Key Concept:** [Workload Identity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity)
</details>

### Question 19
**Scenario:** A company needs to restrict which services can be used in their GCP organization. They want to prevent anyone from creating Compute Engine instances in certain projects while allowing Cloud Run. What should they configure?

A. Remove all IAM permissions
B. Organization Policy with resource location constraint and service restriction policies
C. Delete unwanted services
D. Firewall rules

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Organization Policies provide guardrails. The services constraint (constraints/gcp.restrictServiceUsage) can allow/deny specific services at organization, folder, or project level. This prevents Compute Engine creation while allowing Cloud Run. IAM removal (A) is too broad. Deleting services (C) isn't possible. Firewalls (D) are network, not service restrictions.

**Key Concept:** [Organization Policies](https://cloud.google.com/resource-manager/docs/organization-policy/overview)
</details>

### Question 20
**Scenario:** A company needs to implement zero-trust security for their GKE workloads. Services should only communicate with explicitly allowed services, and all traffic should be encrypted. What should they implement?

A. Network policies only
B. Istio service mesh with mutual TLS (mTLS) and authorization policies
C. No security controls
D. VPC firewall only

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Istio service mesh provides mTLS for encrypted service-to-service communication. Authorization policies define which services can communicate (allow-list). Provides zero-trust within the cluster. Network policies (A) are L3/L4 only, not encrypted. VPC firewall (D) is cluster-external. No controls (C) violates requirements.

**Key Concept:** [Anthos Service Mesh](https://cloud.google.com/service-mesh/docs/overview)
</details>

### Question 21
**Scenario:** A company needs to detect threats and vulnerabilities across their GCP environment, including compromised credentials, cryptomining, and data exfiltration. What should they enable?

A. Cloud Monitoring only
B. Security Command Center Premium with Event Threat Detection and Container Threat Detection
C. Manual log review
D. Third-party SIEM only

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Security Command Center Premium provides comprehensive threat detection. Event Threat Detection identifies compromised credentials, cryptomining, and suspicious activity. Container Threat Detection finds runtime threats in GKE. Built-in vulnerability scanning. Monitoring (A) is for metrics/logs, not threat detection. Manual review (C) doesn't scale.

**Key Concept:** [Security Command Center](https://cloud.google.com/security-command-center/docs/concepts-security-command-center-overview)
</details>

### Question 22
**Scenario:** A development team needs access to production data for debugging but shouldn't see actual customer PII (names, emails, phone numbers). What should be implemented?

A. Full production access
B. Cloud DLP to de-identify PII in a sanitized dataset or use DLP for on-the-fly redaction
C. No debugging access
D. Honor system

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Cloud DLP (Data Loss Prevention) identifies and de-identifies PII using techniques like masking, tokenization, or generalization. A sanitized dataset can be created for debugging with PII removed. Or use DLP API for on-the-fly redaction. Full access (A) violates privacy requirements. No access (C) blocks debugging. Honor system (D) isn't enforceable.

**Key Concept:** [Cloud DLP](https://cloud.google.com/dlp/docs/overview)
</details>

### Question 23
**Scenario:** A company needs to establish a secure connection between their on-premises network and GCP. The connection should use private IP addresses and not traverse the public internet. They have high bandwidth requirements.

A. Cloud VPN
B. Dedicated Interconnect with Cloud Router
C. Public IP addresses
D. SSH tunnels

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Dedicated Interconnect provides private, high-bandwidth (10-200 Gbps) connectivity between on-premises and GCP. Traffic doesn't traverse the public internet. Cloud Router enables dynamic routing with BGP. Cloud VPN (A) uses internet (encrypted). Public IPs (C) traverse internet. SSH tunnels (D) are for specific connections.

**Key Concept:** [Cloud Interconnect](https://cloud.google.com/interconnect/docs/concepts/overview)
</details>

---

## Domain 4: Analyze and Optimize Technical and Business Processes (Questions 24-30)

### Question 24
**Scenario:** A company's monthly GCP bill is higher than expected. They need to identify which services, projects, and teams are driving costs and find optimization opportunities. What tools should they use?

A. Ignore costs
B. Cloud Billing reports with cost breakdown, Recommender for optimization suggestions, and budget alerts
C. Manual calculation
D. Third-party cost tool only

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Cloud Billing reports show cost breakdown by service, project, and labels (teams). Export to BigQuery enables custom analysis. Recommender provides actionable suggestions like rightsizing VMs or deleting unused resources. Budget alerts notify on spending thresholds. Manual calculation (C) is error-prone. Third-party (D) may miss GCP-specific recommendations.

**Key Concept:** [Cloud Billing](https://cloud.google.com/billing/docs/how-to/reports)
</details>

### Question 25
**Scenario:** A Compute Engine workload runs batch jobs that can tolerate interruption. Jobs take 4 hours to complete and can checkpoint progress. How can they reduce compute costs by up to 91%?

A. Use larger instances to finish faster
B. Use Spot VMs (preemptible) with checkpointing and automatic restart
C. Run fewer jobs
D. Use free tier only

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Spot VMs (formerly preemptible) cost up to 91% less than regular VMs. They can be preempted with 30-second warning. Checkpointing saves progress before preemption. Instance groups can automatically restart preempted instances. Ideal for fault-tolerant batch workloads. Larger instances (A) don't reduce unit cost. Free tier (D) has minimal capacity.

**Key Concept:** [Spot VMs](https://cloud.google.com/compute/docs/instances/spot)
</details>

### Question 26
**Scenario:** A company has identified that their Cloud SQL instance is oversized. The instance has 32 vCPUs but CPU utilization averages 10%. What should they do?

A. Keep the same size for future growth
B. Use Active Assist Recommender suggestions to rightsize to appropriate instance size
C. Delete the instance
D. Add more connections

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Active Assist/Recommender analyzes usage patterns and suggests appropriate instance sizes. Rightsizing reduces cost while maintaining performance. Cloud SQL supports live resizing. Keeping oversized (A) wastes money. Deleting (C) loses the database. More connections (D) doesn't address the sizing issue.

**Key Concept:** [VM Rightsizing](https://cloud.google.com/compute/docs/instances/apply-machine-type-recommendations-for-instances)
</details>

### Question 27
**Scenario:** A company's application has variable traffic - high during business hours, low at night. They want to scale down at night to save costs. What should they configure?

A. Manual scaling daily
B. Scheduled scaling or autoscaling based on metrics with scale-down policies
C. Fixed capacity 24/7
D. Turn off the application at night

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Autoscaling with scheduled actions can set minimum instances higher during business hours and lower at night. Metric-based autoscaling adjusts to actual traffic. Scale-down policies control how quickly to reduce capacity. Manual scaling (A) requires daily intervention. Fixed capacity (C) wastes money. Turning off (D) causes downtime.

**Key Concept:** [MIG Autoscaling](https://cloud.google.com/compute/docs/autoscaler/scaling-schedules)
</details>

### Question 28
**Scenario:** A company needs to choose between Cloud Run and GKE for a new microservices application. The team has limited Kubernetes experience, services are HTTP-based, and they want minimal operational overhead. Which should they choose?

A. GKE Autopilot for all workloads
B. Cloud Run for this use case
C. Compute Engine
D. Cloud Functions

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Cloud Run is serverless containers with zero infrastructure management - ideal for teams without Kubernetes experience. It handles HTTP-based services, auto-scales including to zero, and has per-request pricing. Minimal operational overhead. GKE Autopilot (A) is simpler than standard GKE but still more complex than Cloud Run. CE (C) requires more management.

**Key Concept:** [Cloud Run vs GKE](https://cloud.google.com/blog/topics/developers-practitioners/cloud-run-vs-gke-when-use-which)
</details>

### Question 29
**Scenario:** A BigQuery data warehouse is experiencing slow query performance. Queries scan entire tables even when filtering on specific dates. What optimization should they implement?

A. Add more slots
B. Implement table partitioning by date and clustering on frequently filtered columns
C. Export to CSV and re-import
D. Use smaller tables

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Partitioning by date limits scans to relevant partitions (date-filtered queries only scan those dates). Clustering organizes data within partitions by specified columns, improving filter performance. Combined, they dramatically reduce data scanned and improve query speed. More slots (A) add capacity but don't reduce data scanned.

**Key Concept:** [BigQuery Partitioning](https://cloud.google.com/bigquery/docs/partitioned-tables)
</details>

### Question 30
**Scenario:** A company wants to establish SLIs, SLOs, and error budgets for their application. They need to track availability and latency, alert when SLOs are at risk, and make informed decisions about feature velocity vs. reliability.

A. Manual tracking in spreadsheets
B. Cloud Monitoring SLOs with alerting on burn rate and error budget dashboards
C. No SLOs
D. Alert on every error

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Cloud Monitoring supports defining SLOs with SLIs (availability, latency). Burn rate alerts notify when error budget is being consumed too quickly. Dashboards show remaining error budget for decision-making. This is Google's SRE approach. Spreadsheets (A) aren't automated. No SLOs (C) lacks reliability targets. Every-error alerts (D) cause alert fatigue.

**Key Concept:** [Cloud Monitoring SLOs](https://cloud.google.com/monitoring/slo)
</details>

---

## Domain 5: Manage Implementation (Questions 31-34)

### Question 31
**Scenario:** A team needs to plan the migration of 200 VMs from on-premises to GCP. They need to discover VM configurations, dependencies, and estimate GCP costs. What should they use?

A. Manual inventory
B. Migration Center (formerly Migrate for Compute Engine assessment) for discovery, dependency mapping, and TCO analysis
C. Guess the requirements
D. Migrate everything at once

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Migration Center (formerly part of Migrate for Compute Engine) provides agentless discovery of VM configurations, automatic dependency mapping to identify migration groups, and TCO analysis to estimate GCP costs. Creates a migration plan. Manual inventory (A) is time-consuming and error-prone. Big-bang migration (D) is risky.

**Key Concept:** [Migration Center](https://cloud.google.com/migration-center/docs/overview)
</details>

### Question 32
**Scenario:** A company is migrating their database from on-premises MySQL to Cloud SQL. They need minimal downtime during cutover. What migration approach should they use?

A. Export, transfer, import (extended downtime)
B. Database Migration Service with continuous replication and minimal-downtime cutover
C. Recreate schema and start fresh
D. Keep on-premises

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Database Migration Service (DMS) provides continuous replication from source to Cloud SQL. Data stays synchronized until cutover. The cutover window is minimal (minutes). Supports MySQL, PostgreSQL, and SQL Server. Export/import (A) requires extended downtime. Starting fresh (C) loses data.

**Key Concept:** [Database Migration Service](https://cloud.google.com/database-migration/docs/overview)
</details>

### Question 33
**Scenario:** A development team wants to adopt CI/CD for their GCP deployments. They use GitHub for source control and want to deploy to Cloud Run on every push to main. What should they configure?

A. Manual deployments
B. Cloud Build triggered by GitHub, with cloudbuild.yaml defining build and deploy steps
C. GitHub Actions only
D. FTP uploads

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Cloud Build integrates with GitHub via triggers. Push to main triggers a build defined in cloudbuild.yaml. Steps can build container, push to Artifact Registry, and deploy to Cloud Run. Native GCP integration with IAM. GitHub Actions (C) works but requires managing GCP credentials. Manual (A) isn't CI/CD.

**Key Concept:** [Cloud Build](https://cloud.google.com/build/docs/overview)
</details>

### Question 34
**Scenario:** A company has a tight deadline for GCP migration. They need to accelerate the project without sacrificing quality. What should they do?

A. Skip testing
B. Engage Google Cloud consulting or a certified partner with migration experience
C. Work overtime indefinitely
D. Delay the deadline

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Google Cloud consulting and certified partners have migration expertise and can accelerate projects with proven methodologies. They bring experience from similar projects. Professional services can supplement internal teams. Skipping testing (A) causes quality issues. Extended overtime (C) isn't sustainable.

**Key Concept:** [Google Cloud Partners](https://cloud.google.com/partners)
</details>

---

## Domain 6: Ensure Solution and Operations Reliability (Questions 35-40)

### Question 35
**Scenario:** A company needs to ensure their application can survive the failure of an entire GCP region. RTO is 30 minutes and RPO is 5 minutes. What architecture should they implement?

A. Single region with multiple zones
B. Multi-region architecture with Cloud Spanner (or Cloud SQL cross-region replicas), regional load balancing, and Cloud DNS failover
C. Backup and restore only
D. On-premises DR site

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Multi-region architecture distributes across regions. Cloud Spanner provides multi-region with automatic failover. For Cloud SQL, cross-region replicas with promotion meet RPO. Global/multi-region load balancing with health checks and Cloud DNS failover routing traffic to healthy region. Meets 30-min RTO and 5-min RPO. Single region (A) doesn't survive regional failure.

**Key Concept:** [Disaster Recovery Planning](https://cloud.google.com/architecture/disaster-recovery)
</details>

### Question 36
**Scenario:** A production system experienced an outage. The team needs to conduct a blameless post-incident review (postmortem) and prevent recurrence. What should they focus on?

A. Find who to blame
B. Document timeline, root cause analysis, action items for prevention, and update runbooks
C. Ignore and move on
D. Punish the responsible team

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Blameless postmortems focus on systemic improvements, not individual blame. Document what happened (timeline), why it happened (root cause analysis), and how to prevent it (action items). Update runbooks for future incidents. Blame (A, D) discourages reporting. Ignoring (C) leads to repeat incidents.

**Key Concept:** [Postmortem Culture](https://sre.google/sre-book/postmortem-culture/)
</details>

### Question 37
**Scenario:** A team needs to automate responses to common production issues, such as restarting unhealthy services or clearing full disks. What should they implement?

A. Manual intervention for all issues
B. Cloud Monitoring alerting policies with notification channels that trigger Cloud Functions for automated remediation
C. Ignore alerts
D. Reboot servers daily

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Alerting policies detect issues (unhealthy service, disk full). Notification channels can trigger Cloud Functions or Pub/Sub. Functions execute remediation (restart service, clean disk, scale up). Automation reduces MTTR. Manual intervention (A) is slow. Ignoring (C) causes outages. Daily reboots (D) are disruptive.

**Key Concept:** [Alerting Policies](https://cloud.google.com/monitoring/alerts)
</details>

### Question 38
**Scenario:** A company wants to implement chaos engineering to test the resilience of their GKE-based application. They want to randomly terminate pods and observe system behavior. What should they use?

A. Production experiments without safeguards
B. Chaos engineering tools like Chaos Mesh or LitmusChaos with controlled experiments
C. Delete production pods manually
D. Never test failure scenarios

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Chaos Mesh and LitmusChaos provide controlled chaos experiments with safeguards. They can terminate pods, inject network latency, and more. Experiments are time-bounded with abort conditions. Results improve resilience. Production without safeguards (A, C) risks uncontrolled outages. Never testing (D) means unknown failure modes.

**Key Concept:** [Chaos Engineering](https://cloud.google.com/architecture/framework/reliability/testing-resilience)
</details>

### Question 39
**Scenario:** A Cloud Run service is experiencing intermittent 503 errors during traffic spikes. Logs show "instance scaling" messages. What should they investigate and configure?

A. Ignore the errors
B. Configure minimum instances to reduce cold starts, review concurrency settings, and optimize container startup time
C. Switch to a VM
D. Reduce traffic

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** 503 errors during scaling suggest cold start latency or insufficient capacity. Minimum instances keep containers warm. Concurrency settings control requests per instance (too low = more instances needed). Optimizing startup time (smaller images, faster init) reduces cold start impact. Ignoring (A) provides poor UX.

**Key Concept:** [Cloud Run Performance](https://cloud.google.com/run/docs/tips/general)
</details>

### Question 40
**Scenario:** A company needs to create comprehensive documentation for their GCP architecture, including disaster recovery procedures, runbooks, and architectural diagrams. What format and tools should they use?

A. Undocumented knowledge in engineers' heads
B. Version-controlled documentation (Markdown in Git), architecture diagrams (draw.io or Lucidchart), and automated runbooks (Cloud Workflows or Terraform)
C. Paper documents
D. Email chains

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Version-controlled documentation enables collaboration and history. Markdown in Git works with CI/CD. Architecture diagrams visualize systems. Automated runbooks (Cloud Workflows, Terraform) ensure procedures are tested and repeatable. Undocumented (A), paper (C), and email (D) aren't accessible, searchable, or maintainable.

**Key Concept:** [Architecture Documentation](https://cloud.google.com/architecture/framework/system-design/documentation)
</details>

---

## Answer Key

| Question | Answer | Domain |
|----------|--------|--------|
| 1 | B | Design/Plan Architecture |
| 2 | B | Design/Plan Architecture |
| 3 | B | Design/Plan Architecture |
| 4 | B | Design/Plan Architecture |
| 5 | B | Design/Plan Architecture |
| 6 | B | Design/Plan Architecture |
| 7 | B | Design/Plan Architecture |
| 8 | B | Design/Plan Architecture |
| 9 | B | Design/Plan Architecture |
| 10 | B | Design/Plan Architecture |
| 11 | B | Manage/Provision Infrastructure |
| 12 | B | Manage/Provision Infrastructure |
| 13 | B | Manage/Provision Infrastructure |
| 14 | B | Manage/Provision Infrastructure |
| 15 | B | Manage/Provision Infrastructure |
| 16 | B | Manage/Provision Infrastructure |
| 17 | B | Security/Compliance |
| 18 | B | Security/Compliance |
| 19 | B | Security/Compliance |
| 20 | B | Security/Compliance |
| 21 | B | Security/Compliance |
| 22 | B | Security/Compliance |
| 23 | B | Security/Compliance |
| 24 | B | Analyze/Optimize |
| 25 | B | Analyze/Optimize |
| 26 | B | Analyze/Optimize |
| 27 | B | Analyze/Optimize |
| 28 | B | Analyze/Optimize |
| 29 | B | Analyze/Optimize |
| 30 | B | Analyze/Optimize |
| 31 | B | Manage Implementation |
| 32 | B | Manage Implementation |
| 33 | B | Manage Implementation |
| 34 | B | Manage Implementation |
| 35 | B | Reliability |
| 36 | B | Reliability |
| 37 | B | Reliability |
| 38 | B | Reliability |
| 39 | B | Reliability |
| 40 | B | Reliability |
