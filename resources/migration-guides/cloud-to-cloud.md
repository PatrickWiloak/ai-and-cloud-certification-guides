# Cloud-to-Cloud Migration Guide

## Overview

Migrating between cloud providers - or operating across multiple clouds - introduces unique challenges around data transfer, application portability, identity federation, and cost management. This guide covers strategies for moving workloads between AWS, Azure, and GCP, as well as multi-cloud operational patterns.

---

## Multi-Cloud Migration Strategies

### Why Migrate Between Clouds?

- Cost optimization (leverage better pricing for specific workloads)
- Avoid vendor lock-in or reduce single-provider dependency
- Leverage best-of-breed services (e.g., BigQuery for analytics, Azure AD for identity)
- Regulatory or compliance requirements (data sovereignty)
- Mergers and acquisitions (consolidating cloud environments)

### Strategy Options

#### 1. Full Migration (All-In on Target Cloud)

- Move all workloads from source cloud to target cloud
- Highest effort but simplest long-term operational model
- Best when consolidating after M&A or making a strategic platform choice
- Requires complete networking, identity, and operations rebuild

#### 2. Hybrid Multi-Cloud (Best-of-Breed)

- Run different workloads on different clouds intentionally
- Example: compute on AWS, analytics on GCP, identity on Azure
- Requires cross-cloud networking and identity federation
- Higher operational complexity but maximizes service advantages

#### 3. Gradual Workload Shifting

- Move workloads incrementally based on contract renewals or optimization needs
- Reduces risk through phased approach
- Maintain operations in both clouds during transition period
- Use DNS-based traffic shifting for zero-downtime migration

---

## Data Transfer Between Clouds

### Object Storage Migration

#### AWS S3 to Google Cloud Storage

- Use Google Storage Transfer Service (supports S3 as source natively)
- Provide IAM credentials with S3 read access
- Schedule recurring transfers for ongoing sync
- Documentation: https://cloud.google.com/storage-transfer/docs/create-manage-transfer-console

#### AWS S3 to Azure Blob Storage

- Use AzCopy with S3 as source (supports S3-compatible sources)
- Or use Azure Data Factory with S3 connector
- Documentation: https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-s3

#### Google Cloud Storage to AWS S3

- Use AWS DataSync with GCS as source
- Or use rclone (open-source tool supporting both clouds)
- Documentation: https://docs.aws.amazon.com/datasync/latest/userguide/what-is-datasync.html

#### Azure Blob Storage to AWS S3 or GCS

- Use rclone for bidirectional sync
- AWS DataSync supports Azure Blob as a source location
- Google Storage Transfer Service supports Azure Blob as source

### Database Migration Between Clouds

- Export and import: simplest but requires downtime
- Continuous replication tools: Striim, Fivetran, or native DMS tools
- Homogeneous migrations (e.g., PostgreSQL to PostgreSQL) are simpler
- Heterogeneous migrations require schema conversion
- See the dedicated [Database Migration Guide](database-migration.md) for details

### Large Dataset Transfers

- For datasets over 10 TB, consider physical transfer appliances
- Alternatively, use dedicated network connections between clouds
- Compression and deduplication reduce transfer time and cost
- Estimate transfer time: 1 TB over 1 Gbps link takes approximately 2.5 hours

---

## Application Portability

### Containers and Kubernetes

- Containerized applications are the most portable between clouds
- Use Docker images stored in a cloud-agnostic registry (or replicate across registries)
- Kubernetes provides a consistent orchestration layer:
  - AWS EKS
  - Azure AKS
  - Google GKE
- Avoid cloud-specific Kubernetes extensions where portability matters
- Use Helm charts for application packaging
- Consider service mesh (Istio) for cross-cloud service communication

### Infrastructure as Code with Terraform

- Terraform supports all major cloud providers through providers
- Write cloud-agnostic modules where possible
- Use Terraform workspaces or separate state files per cloud
- Common portable patterns:
  - Compute instances (aws_instance, azurerm_virtual_machine, google_compute_instance)
  - Load balancers
  - DNS records
  - IAM roles and policies (structure varies significantly between clouds)
- Documentation: https://developer.hashicorp.com/terraform/tutorials/aws-get-started

### Application-Level Abstractions

- Use cloud-agnostic SDKs and libraries where possible
- Abstract storage access behind interfaces (S3 API is widely supported)
- Use standard protocols: HTTPS, gRPC, AMQP, MQTT
- Avoid deep integration with proprietary services unless strategically intended
- Configuration-driven cloud selection (environment variables for endpoints)

---

## DNS and Traffic Shifting Strategies

### Blue-Green Migration via DNS

1. Deploy application in target cloud alongside source
2. Lower DNS TTL to 60 seconds (do this days before cutover)
3. Run parallel traffic to validate target environment
4. Switch DNS to target cloud
5. Monitor for errors and performance issues
6. Keep source environment for rollback (48-72 hours)
7. Restore original DNS TTL after validation

### Weighted DNS Routing

- Gradually shift traffic from source to target cloud
- Start with 10% to target cloud, increase incrementally
- Available through:
  - AWS Route 53 weighted routing
  - Azure Traffic Manager weighted profiles
  - Google Cloud DNS weighted round robin
  - Cloudflare load balancing (cloud-neutral)

### Global Load Balancing

- Use a cloud-neutral CDN or load balancer for traffic distribution
- Cloudflare, Fastly, or Akamai can route between cloud backends
- Health checks ensure traffic only goes to healthy endpoints
- Enables gradual migration with real-time rollback capability

---

## Identity and Access Management

### Cross-Cloud Identity Federation

- Use SAML 2.0 or OIDC for federation between clouds
- Azure AD (Entra ID) can serve as the central identity provider for all clouds:
  - AWS: SAML federation with AWS IAM Identity Center
  - GCP: Workforce Identity Federation with Azure AD
- Use workload identity federation for service-to-service authentication
  - Eliminates static credentials between clouds
  - AWS: IAM roles with OIDC provider
  - GCP: Workload Identity Federation
  - Azure: Federated credentials for managed identities

### Secrets Management Across Clouds

- Centralized options: HashiCorp Vault (cloud-agnostic)
- Cloud-native options (use per-cloud):
  - AWS Secrets Manager
  - Azure Key Vault
  - Google Secret Manager
- Sync secrets across clouds using automation (Terraform, CI/CD pipelines)
- Never store secrets in code or configuration files

---

## Cost Comparison During Migration

### Running Costs in Both Clouds

- Expect 2-6 months of overlapping costs during migration
- Budget for data transfer (egress) charges between clouds
- Track costs separately per cloud during migration

### Egress Cost Considerations

| Provider | Egress to Internet | Egress to Other Cloud |
|----------|-------------------|-----------------------|
| AWS | $0.09/GB (first 10 TB) | Same as internet egress |
| Azure | $0.087/GB (first 10 TB) | Same as internet egress |
| GCP | $0.12/GB (first 1 TB) | Same as internet egress |

- Note: prices vary by region and volume - check current pricing pages
- Consider dedicated interconnects between clouds for high-volume transfers

### Cost Optimization Tips

- Use spot/preemptible instances for migration processing workloads
- Compress data before transfer to reduce egress costs
- Use free tier services in the target cloud during testing
- Cancel reservations and committed use discounts as workloads move
- Negotiate with the target cloud provider (migration credits are common)

### Cost Tracking Tools

- AWS Cost Explorer: https://docs.aws.amazon.com/cost-management/latest/userguide/ce-what-is.html
- Azure Cost Management: https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/overview-cost-management
- Google Cloud Billing Reports: https://cloud.google.com/billing/docs/reports

---

## Migration Execution Checklist

### Pre-Migration

- [ ] Inventory all workloads and data in source cloud
- [ ] Design target architecture in destination cloud
- [ ] Set up networking between clouds (VPN or interconnect)
- [ ] Establish identity federation between clouds
- [ ] Set up monitoring in both clouds
- [ ] Create rollback plan for each workload
- [ ] Budget for dual-cloud costs during transition

### During Migration

- [ ] Migrate data first (databases, object storage, file systems)
- [ ] Deploy application infrastructure in target cloud
- [ ] Configure DNS for traffic shifting
- [ ] Test application functionality in target cloud
- [ ] Gradually shift traffic using weighted DNS or load balancing
- [ ] Monitor error rates and latency during traffic shift
- [ ] Validate data consistency between clouds

### Post-Migration

- [ ] Decommission resources in source cloud
- [ ] Cancel unused reservations and committed use agreements
- [ ] Update documentation and runbooks
- [ ] Train teams on target cloud operations
- [ ] Optimize costs in target cloud (right-sizing, discounts)
- [ ] Conduct lessons learned review

---

## Multi-Cloud Anti-Patterns to Avoid

- Running identical workloads across multiple clouds for redundancy (extremely expensive)
- Using cloud-specific services without abstraction when portability is required
- Not accounting for egress costs in the migration budget
- Maintaining separate identity systems per cloud (federate instead)
- Underestimating the operational complexity of multi-cloud
- Not having a clear reason for multi-cloud (complexity without benefit)
- Ignoring data gravity - large datasets are expensive to move repeatedly
