# Google Cloud Cost Optimization

## Overview

This guide covers Google Cloud cost management tools, strategies, and best practices. Cost optimization is relevant to Professional Cloud Architect and FinOps certification exams.

---

## GCP Cost Management Tools

| Tool | Purpose | Access |
|------|---------|--------|
| Billing Reports | Visualize spending by project/service | Cloud Console |
| Billing Export to BigQuery | Detailed billing analysis | BigQuery |
| Budgets and Alerts | Spending thresholds and notifications | Cloud Console |
| Recommender | Right-sizing and optimization suggestions | Cloud Console / API |
| Pricing Calculator | Estimate costs before deployment | Web tool |
| Cost Table | Detailed cost breakdown | Cloud Console |
| Active Assist | Unified recommendations hub | Cloud Console |
| FinOps Hub | Cost governance and optimization | Cloud Console |

---

## Compute Cost Optimization

### Compute Engine Pricing Models

| Model | Discount | Commitment | Best For |
|-------|----------|------------|----------|
| On-Demand | 0% | None | Short-term, unpredictable |
| Sustained Use Discounts | Up to 30% | Automatic (usage-based) | Consistent monthly usage |
| Committed Use Discounts (CUDs) | Up to 57% (compute), 70% (memory) | 1 or 3 year | Predictable workloads |
| Spot VMs | Up to 91% | None (preemptible) | Fault-tolerant, batch |
| Flex CUDs | Up to 46% | 1 year (flexible) | Variable instance types |

### Right-Sizing

| Strategy | Tool | Action |
|----------|------|--------|
| VM right-sizing | Recommender | Resize based on utilization |
| Idle VM detection | Recommender | Delete or stop idle VMs |
| Schedule VMs | Instance Scheduler | Stop dev/test after hours |
| Custom machine types | Compute Engine | Match exact CPU/memory needs |
| Tau VMs (T2D/T2A) | Compute Engine | Best price-performance for scale-out |
| Sole-tenant nodes | Compute Engine | Licensing compliance at scale |

---

## Storage Cost Optimization

### Cloud Storage Classes

| Class | Use Case | Cost (per GB/month, US multi-region) |
|-------|----------|--------------------------------------|
| Standard | Frequently accessed | ~$0.026 |
| Nearline | Infrequent (30+ days) | ~$0.01 |
| Coldline | Rare access (90+ days) | ~$0.004 |
| Archive | Long-term (365+ days) | ~$0.0012 |

### Storage Strategies

| Strategy | Action | Savings |
|----------|--------|---------|
| Object lifecycle rules | Auto-transition by age | 50-95% |
| Autoclass | Automatic class management | Optimized per-object |
| Regional vs multi-regional | Choose based on access pattern | 50% (regional vs multi) |
| Delete unused snapshots | Clean up Persistent Disk snapshots | Variable |
| Persistent Disk type | pd-standard vs pd-balanced vs pd-ssd | 70% (standard vs ssd) |

---

## Database Cost Optimization

| Strategy | Service | Action |
|----------|---------|--------|
| CUDs | Cloud SQL, Spanner, Bigtable | 1 or 3 year commitments |
| Right-size instances | Cloud SQL | Match CPU/memory to workload |
| Read replicas | Cloud SQL | Offload reads |
| Spanner auto-scaling | Spanner | Scale processing units based on load |
| BigQuery flat-rate | BigQuery | Editions (Standard, Enterprise, Enterprise Plus) |
| BigQuery storage optimization | BigQuery | Partitioning, clustering, long-term storage |
| Firestore usage | Firestore | Optimize read/write patterns |

### BigQuery Cost Optimization

| Strategy | Description | Impact |
|----------|-------------|--------|
| Partition tables | Partition by date/integer | Reduce data scanned |
| Cluster tables | Cluster by frequently filtered columns | Reduce data scanned |
| Use LIMIT with preview | Avoid scanning full tables | Reduce query cost |
| Materialized views | Cache expensive query results | Reduce repeated query cost |
| BI Engine | In-memory analysis acceleration | Fixed cost, fast queries |
| Editions pricing | Autoscale or baseline slots | Predictable cost |
| Long-term storage | Auto-discount after 90 days | 50% storage discount |

---

## Networking Cost Optimization

| Strategy | Description | Savings |
|----------|-------------|---------|
| Standard Network Tier | Lower cost egress (regional) | 25-50% vs Premium |
| Cloud CDN | Cache at edge, reduce origin | Reduced egress |
| Private Google Access | Access GCP APIs without external IP | Avoid NAT costs |
| Cloud Interconnect | Lower egress vs internet | 70-80% egress savings |
| Same-zone traffic | Co-locate resources | Free intra-zone traffic |
| Cloud NAT optimization | Right-size NAT bandwidth | Reduced NAT charges |

---

## GCP-Specific Savings

### Sustained Use Discounts (Automatic)

| Usage (% of month) | Discount |
|---------------------|----------|
| 0-25% | 0% |
| 25-50% | 20% |
| 50-75% | 40% |
| 75-100% | 60% |
| Full month effective | ~30% average |

Note: SUDs apply automatically to Compute Engine and Cloud SQL. No commitment required.

### Committed Use Discounts

| Type | Duration | Discount |
|------|----------|----------|
| Compute CUD | 1 year | Up to 37% |
| Compute CUD | 3 year | Up to 57% |
| Memory CUD | 1 year | Up to 50% |
| Memory CUD | 3 year | Up to 70% |
| Flex CUD | 1 year | Up to 46% |

---

## Organization-Level Optimization

| Strategy | Description |
|----------|-------------|
| Billing accounts | Organize by department/team |
| Labels | Tag resources for cost allocation |
| Billing export | Export to BigQuery for analysis |
| Budgets | Set per-project budgets with alerts |
| Quotas | Prevent cost overruns |
| Recommender | Organization-wide recommendations |
| Custom dashboards | Looker Studio with billing data |

---

## Cost Optimization Checklist

- [ ] Enable billing export to BigQuery
- [ ] Set up budgets and alerts per project
- [ ] Review Recommender suggestions weekly
- [ ] Implement Cloud Storage lifecycle rules
- [ ] Analyze CUD and Flex CUD recommendations
- [ ] Right-size Compute Engine instances quarterly
- [ ] Use custom machine types where applicable
- [ ] Schedule non-production VMs to stop after hours
- [ ] Optimize BigQuery with partitioning and clustering
- [ ] Delete unused persistent disks and snapshots
- [ ] Evaluate Standard vs Premium Network Tier
- [ ] Use Spot VMs for fault-tolerant workloads

---

## Documentation Links

- GCP Billing: https://cloud.google.com/billing/docs
- GCP Pricing Calculator: https://cloud.google.com/products/calculator
- Committed Use Discounts: https://cloud.google.com/compute/docs/instances/signing-up-committed-use-discounts
- GCP Recommender: https://cloud.google.com/recommender/docs
- GCP Cost Optimization: https://cloud.google.com/architecture/framework/cost-optimization
