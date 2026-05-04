---
last-updated: 2026-05-03
---

# Google Cloud Associate Cloud Engineer - Fact Sheet

## Quick Reference

**Exam Code:** Associate Cloud Engineer
**Duration:** 120 minutes
**Questions:** 50-60 questions
**Passing Score:** ~70% (not officially published)
**Cost:** $125 USD
**Validity:** 3 years
**Difficulty:** ⭐⭐⭐

## Exam Domains

| Domain | Weight | Key Focus |
|--------|--------|-----------|
| Setting up a cloud solution environment | 20% | Projects, billing, CLI, IAM setup |
| Planning and configuring a cloud solution | 17.5% | Compute, storage, networking planning |
| Deploying and implementing a cloud solution | 25% | GCE, GKE, App Engine, Cloud Run, data solutions |
| Ensuring successful operation | 20% | Management, monitoring, logging |
| Configuring access and security | 17.5% | IAM, service accounts, audit logs |

## Core Google Cloud Services

### Compute Services

**Compute Engine (GCE)**
- Virtual machine instances with customizable configurations
- Machine types: N1, N2, E2, C2, M1, A2
- Preemptible VMs: Up to 80% cost savings, 24-hour max lifetime
- Instance groups: Managed (auto-scaling) and unmanaged
- Persistent disks: Standard, SSD, balanced, extreme
- **[📖 Compute Engine Documentation](https://cloud.google.com/compute/docs)** - Complete GCE guide
- **[📖 Machine Types](https://cloud.google.com/compute/docs/machine-types)** - VM sizing and families
- **[📖 Preemptible VMs](https://cloud.google.com/compute/docs/instances/preemptible)** - Cost-effective instances
- **[📖 Instance Groups](https://cloud.google.com/compute/docs/instance-groups)** - Auto-scaling and load balancing
- **[📖 Persistent Disks](https://cloud.google.com/compute/docs/disks)** - Block storage options

**Google Kubernetes Engine (GKE)**
- Managed Kubernetes clusters
- Autopilot mode: Fully managed, optimized configurations
- Standard mode: Flexible node pool management
- Workload Identity: Secure pod-to-GCP service authentication
- Cluster autoscaler: Automatic node provisioning
- **[📖 GKE Documentation](https://cloud.google.com/kubernetes-engine/docs)** - Complete GKE guide
- **[📖 GKE Autopilot](https://cloud.google.com/kubernetes-engine/docs/concepts/autopilot-overview)** - Fully managed mode
- **[📖 GKE Standard](https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-architecture)** - Cluster architecture
- **[📖 Workload Identity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity)** - Pod authentication
- **[📖 Cluster Autoscaler](https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-autoscaler)** - Auto-scaling nodes

**App Engine**
- Platform as a Service (PaaS) for applications
- Standard environment: Auto-scaling, sandbox runtime
- Flexible environment: Docker containers, custom runtimes
- Traffic splitting: A/B testing and gradual rollouts
- Versions and services: Multi-version deployment
- **[📖 App Engine Documentation](https://cloud.google.com/appengine/docs)** - Complete App Engine guide
- **[📖 Standard vs Flexible](https://cloud.google.com/appengine/docs/the-appengine-environments)** - Environment comparison
- **[📖 Scaling Configuration](https://cloud.google.com/appengine/docs/standard/python3/how-instances-are-managed)** - Instance scaling
- **[📖 Traffic Splitting](https://cloud.google.com/appengine/docs/standard/python3/splitting-traffic)** - Version management
- **[📖 App Engine Deployment](https://cloud.google.com/appengine/docs/standard/python3/testing-and-deploying-your-app)** - Deployment workflows

**Cloud Run**
- Fully managed serverless containers
- Auto-scales from 0 to N instances
- Pay-per-use: Charged only when processing requests
- Cloud Run for Anthos: Hybrid and multi-cloud
- Concurrency: Handle multiple requests per container
- **[📖 Cloud Run Documentation](https://cloud.google.com/run/docs)** - Complete Cloud Run guide
- **[📖 Container Requirements](https://cloud.google.com/run/docs/container-contract)** - Container specs
- **[📖 Auto-scaling](https://cloud.google.com/run/docs/about-instance-autoscaling)** - Scaling behavior
- **[📖 Service Configuration](https://cloud.google.com/run/docs/configuring/services)** - Service settings
- **[📖 Cloud Run Pricing](https://cloud.google.com/run/pricing)** - Cost optimization

**Cloud Functions**
- Event-driven serverless functions
- Runtimes: Node.js, Python, Go, Java, Ruby, .NET
- 1st gen: HTTP and background functions
- 2nd gen: Built on Cloud Run, improved performance
- Event sources: Cloud Storage, Pub/Sub, Firestore, HTTP
- **[📖 Cloud Functions Documentation](https://cloud.google.com/functions/docs)** - Complete guide
- **[📖 Event Triggers](https://cloud.google.com/functions/docs/calling)** - Trigger types
- **[📖 Functions Framework](https://cloud.google.com/functions/docs/functions-framework)** - Local development
- **[📖 Best Practices](https://cloud.google.com/functions/docs/bestpractices/tips)** - Performance optimization
- **[📖 2nd Generation](https://cloud.google.com/functions/docs/2nd-gen/overview)** - Next-gen functions

### Storage Services

**Cloud Storage**
- Object storage with global availability
- Storage classes: Standard, Nearline, Coldline, Archive
- Lifecycle policies: Automatic tier transitions
- Versioning: Object version history
- Access control: IAM, ACLs, signed URLs
- **[📖 Cloud Storage Documentation](https://cloud.google.com/storage/docs)** - Complete guide
- **[📖 Storage Classes](https://cloud.google.com/storage/docs/storage-classes)** - Class comparison
- **[📖 Lifecycle Management](https://cloud.google.com/storage/docs/lifecycle)** - Automatic transitions
- **[📖 Access Control](https://cloud.google.com/storage/docs/access-control)** - IAM and ACLs
- **[📖 Object Versioning](https://cloud.google.com/storage/docs/object-versioning)** - Version control
- **[📖 Signed URLs](https://cloud.google.com/storage/docs/access-control/signed-urls)** - Temporary access

**Cloud SQL**
- Managed relational databases: MySQL, PostgreSQL, SQL Server
- High availability: Regional and cross-regional replication
- Read replicas: Scale read operations
- Automated backups: Point-in-time recovery
- Maintenance windows: Scheduled updates
- **[📖 Cloud SQL Documentation](https://cloud.google.com/sql/docs)** - Complete guide
- **[📖 High Availability](https://cloud.google.com/sql/docs/mysql/high-availability)** - HA configuration
- **[📖 Read Replicas](https://cloud.google.com/sql/docs/mysql/replication)** - Replica setup
- **[📖 Backup and Recovery](https://cloud.google.com/sql/docs/mysql/backup-recovery/backing-up)** - Backup strategies
- **[📖 Connection Options](https://cloud.google.com/sql/docs/mysql/connect-overview)** - Connectivity methods

**Cloud Firestore**
- NoSQL document database
- Native and Datastore modes
- Real-time updates: Live synchronization
- Offline support: Mobile and web
- ACID transactions: Strong consistency
- **[📖 Firestore Documentation](https://cloud.google.com/firestore/docs)** - Complete guide
- **[📖 Data Model](https://cloud.google.com/firestore/docs/data-model)** - Documents and collections
- **[📖 Queries](https://cloud.google.com/firestore/docs/query-data/queries)** - Query syntax
- **[📖 Security Rules](https://cloud.google.com/firestore/docs/security/get-started)** - Access control
- **[📖 Indexing](https://cloud.google.com/firestore/docs/query-data/indexing)** - Query optimization

**Cloud Bigtable**
- Wide-column NoSQL database
- Petabyte-scale, sub-10ms latency
- Time-series data, IoT, financial data
- HBase API compatible
- Replication: Multi-cluster, multi-region
- **[📖 Bigtable Documentation](https://cloud.google.com/bigtable/docs)** - Complete guide
- **[📖 Schema Design](https://cloud.google.com/bigtable/docs/schema-design)** - Best practices
- **[📖 Performance](https://cloud.google.com/bigtable/docs/performance)** - Optimization guide
- **[📖 Replication](https://cloud.google.com/bigtable/docs/replication-overview)** - Multi-cluster setup

**BigQuery**
- Serverless data warehouse
- SQL queries on petabyte-scale data
- Columnar storage, automatic optimization
- Streaming inserts: Real-time data ingestion
- Federated queries: Query external data sources
- **[📖 BigQuery Documentation](https://cloud.google.com/bigquery/docs)** - Complete guide
- **[📖 Query Syntax](https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax)** - SQL reference
- **[📖 Loading Data](https://cloud.google.com/bigquery/docs/loading-data)** - Data ingestion
- **[📖 Partitioning](https://cloud.google.com/bigquery/docs/partitioned-tables)** - Table optimization
- **[📖 Cost Optimization](https://cloud.google.com/bigquery/docs/best-practices-costs)** - Cost management

### Networking Services

**Virtual Private Cloud (VPC)**
- Isolated network environment
- Subnets: Regional IP ranges
- Firewall rules: Ingress and egress control
- VPC peering: Connect VPCs globally
- Shared VPC: Multi-project networking
- **[📖 VPC Documentation](https://cloud.google.com/vpc/docs)** - Complete guide
- **[📖 Subnet Creation](https://cloud.google.com/vpc/docs/subnets)** - Subnet design
- **[📖 Firewall Rules](https://cloud.google.com/vpc/docs/firewalls)** - Network security
- **[📖 VPC Peering](https://cloud.google.com/vpc/docs/vpc-peering)** - VPC connectivity
- **[📖 Shared VPC](https://cloud.google.com/vpc/docs/shared-vpc)** - Multi-project networks

**Cloud Load Balancing**
- Global load balancing with single anycast IP
- HTTP(S) Load Balancing: Layer 7, global
- TCP/UDP Load Balancing: Layer 4, regional/global
- Internal Load Balancing: Private load balancing
- SSL termination: Certificate management
- **[📖 Load Balancing Documentation](https://cloud.google.com/load-balancing/docs)** - Complete guide
- **[📖 HTTP(S) Load Balancing](https://cloud.google.com/load-balancing/docs/https)** - Layer 7 balancing
- **[📖 TCP/UDP Load Balancing](https://cloud.google.com/load-balancing/docs/network)** - Layer 4 balancing
- **[📖 Internal Load Balancing](https://cloud.google.com/load-balancing/docs/internal)** - Private balancing
- **[📖 SSL Certificates](https://cloud.google.com/load-balancing/docs/ssl-certificates)** - Certificate management

**Cloud CDN**
- Content delivery network
- Global edge locations
- Cache control: Custom TTL policies
- HTTPS support: SSL/TLS termination
- Origin: GCS buckets or HTTP(S) backends
- **[📖 Cloud CDN Documentation](https://cloud.google.com/cdn/docs)** - Complete guide
- **[📖 Cache Keys](https://cloud.google.com/cdn/docs/caching)** - Caching behavior
- **[📖 Signed URLs](https://cloud.google.com/cdn/docs/using-signed-urls)** - Secure content delivery

**Cloud VPN and Interconnect**
- Cloud VPN: IPsec tunnels to on-premises
- Cloud Interconnect: Dedicated physical connections
- Partner Interconnect: Carrier connections
- Cloud Router: Dynamic BGP routing
- **[📖 Cloud VPN Documentation](https://cloud.google.com/network-connectivity/docs/vpn)** - VPN setup
- **[📖 Cloud Interconnect](https://cloud.google.com/network-connectivity/docs/interconnect)** - Dedicated connectivity
- **[📖 Cloud Router](https://cloud.google.com/network-connectivity/docs/router)** - Dynamic routing

### Identity and Access Management

**IAM (Identity and Access Management)**
- Who: Members (users, groups, service accounts, domains)
- What: Resources (projects, GCS buckets, GCE instances)
- How: Roles (basic, predefined, custom)
- Policy binding: Member + Role + Resource
- Conditional access: Context-aware policies
- **[📖 IAM Documentation](https://cloud.google.com/iam/docs)** - Complete IAM guide
- **[📖 IAM Roles](https://cloud.google.com/iam/docs/understanding-roles)** - Role types
- **[📖 Custom Roles](https://cloud.google.com/iam/docs/creating-custom-roles)** - Role creation
- **[📖 Policy Management](https://cloud.google.com/iam/docs/policies)** - Policy structure
- **[📖 Conditional Access](https://cloud.google.com/iam/docs/conditions-overview)** - Context-based access
- **[📖 Best Practices](https://cloud.google.com/iam/docs/best-practices)** - Security guidelines

**Service Accounts**
- Machine-to-machine authentication
- Types: User-managed, Google-managed
- Key management: JSON keys, rotation
- Short-lived tokens: OAuth 2.0 access tokens
- Impersonation: Service account as another identity
- **[📖 Service Accounts](https://cloud.google.com/iam/docs/service-accounts)** - Complete guide
- **[📖 Key Management](https://cloud.google.com/iam/docs/creating-managing-service-account-keys)** - Key lifecycle
- **[📖 Best Practices](https://cloud.google.com/iam/docs/best-practices-service-accounts)** - Security guidelines
- **[📖 Impersonation](https://cloud.google.com/iam/docs/impersonating-service-accounts)** - Identity delegation

### Operations and Monitoring

**Cloud Monitoring (formerly Stackdriver)**
- Metrics collection: Infrastructure and application metrics
- Custom metrics: Application-specific monitoring
- Dashboards: Visualization and reporting
- Alerting policies: Notification channels
- Uptime checks: Availability monitoring
- **[📖 Cloud Monitoring Documentation](https://cloud.google.com/monitoring/docs)** - Complete guide
- **[📖 Metrics Explorer](https://cloud.google.com/monitoring/charts/metrics-explorer)** - Metric visualization
- **[📖 Alerting](https://cloud.google.com/monitoring/alerts)** - Alert configuration
- **[📖 Custom Metrics](https://cloud.google.com/monitoring/custom-metrics)** - Application metrics
- **[📖 Dashboards](https://cloud.google.com/monitoring/dashboards)** - Dashboard creation

**Cloud Logging (formerly Stackdriver Logging)**
- Centralized log management
- Log types: Admin, system, access, agent logs
- Log sinks: Export to GCS, BigQuery, Pub/Sub
- Log-based metrics: Metrics from log entries
- Retention: 30 days default, configurable
- **[📖 Cloud Logging Documentation](https://cloud.google.com/logging/docs)** - Complete guide
- **[📖 Log Router](https://cloud.google.com/logging/docs/routing/overview)** - Log routing
- **[📖 Log Sinks](https://cloud.google.com/logging/docs/export)** - Export configuration
- **[📖 Query Language](https://cloud.google.com/logging/docs/view/logging-query-language)** - Log filtering
- **[📖 Audit Logs](https://cloud.google.com/logging/docs/audit)** - Audit logging

**Cloud Trace and Debugger**
- Cloud Trace: Distributed tracing, latency analysis
- Cloud Debugger: Live application debugging
- Error Reporting: Error aggregation and alerts
- Cloud Profiler: CPU and memory profiling
- **[📖 Cloud Trace Documentation](https://cloud.google.com/trace/docs)** - Distributed tracing
- **[📖 Cloud Debugger](https://cloud.google.com/debugger/docs)** - Live debugging
- **[📖 Error Reporting](https://cloud.google.com/error-reporting/docs)** - Error tracking
- **[📖 Cloud Profiler](https://cloud.google.com/profiler/docs)** - Performance profiling

## Command Line Tools

**gcloud CLI**
- Project management: `gcloud projects list/create/delete`
- Compute: `gcloud compute instances create/start/stop`
- Storage: `gsutil cp/mb/rm`
- Configuration: `gcloud config set/get`
- Authentication: `gcloud auth login/application-default`
- **[📖 gcloud CLI Documentation](https://cloud.google.com/sdk/gcloud)** - Complete reference
- **[📖 gcloud Commands](https://cloud.google.com/sdk/gcloud/reference)** - Command reference
- **[📖 gcloud Configuration](https://cloud.google.com/sdk/gcloud/reference/config)** - Config management
- **[📖 gsutil Documentation](https://cloud.google.com/storage/docs/gsutil)** - Storage tool

**kubectl**
- Kubernetes cluster management
- Deployment: `kubectl apply/create/delete`
- Pods: `kubectl get pods/logs/exec`
- Services: `kubectl expose/port-forward`
- **[📖 kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)** - Command reference
- **[📖 GKE kubectl](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl)** - Cluster access

## Key Exam Concepts

### High Availability Patterns
- Multi-region deployments
- Regional managed instance groups
- Health checks and auto-healing
- Load balancer redundancy
- Database replication (Cloud SQL, Spanner)

### Cost Optimization
- Committed use discounts: 1-year or 3-year
- Sustained use discounts: Automatic monthly discounts
- Preemptible VMs: 80% cost reduction
- Custom machine types: Right-sizing
- Cloud Storage lifecycle policies: Auto-tiering

### Security Best Practices
- Least privilege IAM: Minimum necessary permissions
- Service account keys: Avoid long-lived keys
- VPC Service Controls: Perimeter security
- Encryption: At-rest (default), in-transit (SSL/TLS)
- Audit logging: Admin, data access, system event logs

### Deployment Strategies
- Blue/green deployment: Zero-downtime updates
- Rolling updates: Gradual instance replacement
- Canary deployments: Traffic splitting
- Infrastructure as Code: Deployment Manager, Terraform
- CI/CD: Cloud Build, Cloud Deploy

## Common Scenarios

**Scenario 1: Web Application with Auto-scaling**
- Solution: Managed instance group + HTTP(S) Load Balancer + Cloud CDN

**Scenario 2: Microservices Architecture**
- Solution: GKE cluster + Cloud Load Balancing + Cloud SQL/Firestore

**Scenario 3: Data Pipeline**
- Solution: Cloud Storage → Cloud Functions/Dataflow → BigQuery

**Scenario 4: Hybrid Connectivity**
- Solution: Cloud VPN or Interconnect + Cloud Router + Shared VPC

**Scenario 5: Serverless API**
- Solution: Cloud Functions or Cloud Run + API Gateway + Cloud Firestore

## Essential Documentation

- **[📖 Google Cloud Documentation](https://cloud.google.com/docs)** - Main documentation hub
- **[📖 Solutions Gallery](https://cloud.google.com/docs/tutorials)** - Architecture patterns
- **[📖 Best Practices](https://cloud.google.com/docs/enterprise/best-practices-for-enterprise-organizations)** - Enterprise guidelines
- **[📖 Pricing Calculator](https://cloud.google.com/products/calculator)** - Cost estimation
- **[📖 Free Tier](https://cloud.google.com/free)** - Always Free and trial credits

## Exam Tips

**Keywords:**
- "High availability" → Multi-region, managed instance groups, load balancing
- "Cost-effective" → Preemptible VMs, committed use, sustained use discounts
- "Secure" → IAM, service accounts, VPC firewall, encryption
- "Serverless" → Cloud Functions, Cloud Run, App Engine
- "Data warehouse" → BigQuery
- "Real-time" → Pub/Sub, Cloud Functions, Firestore

**Focus Areas:**
- IAM roles and service accounts (critical!)
- gcloud CLI commands for all services
- Compute options: When to use GCE vs GKE vs App Engine vs Cloud Run
- Networking: VPC, subnets, firewall rules, load balancing
- Monitoring and logging setup
- Cost optimization techniques

---

**Pro Tip:** This is a hands-on exam. Practice using the gcloud CLI extensively and deploy real applications on GCP. Understand the "why" behind service selection, not just the "how"!
