# Azure Cost Optimization

## Overview

This guide covers Azure cost management tools, strategies, and best practices for optimizing cloud spending. Cost management is tested across Azure Administrator, Solutions Architect, and FinOps certifications.

---

## Azure Cost Management Tools

| Tool | Purpose | Access |
|------|---------|--------|
| Cost Management + Billing | Analyze and manage costs | Azure Portal |
| Azure Advisor | Optimization recommendations | Azure Portal |
| Azure Pricing Calculator | Estimate costs before deployment | Web tool |
| TCO Calculator | Compare on-prem vs Azure costs | Web tool |
| Azure Budgets | Spending alerts and automation | Azure Portal |
| Cost Analysis | Visualize spending by dimension | Azure Portal |
| Azure Reservations | Commit for discounts | Azure Portal |
| Savings Plans | Flexible commitment pricing | Azure Portal |

---

## Compute Cost Optimization

### VM Pricing Models

| Model | Discount | Commitment | Best For |
|-------|----------|------------|----------|
| Pay-as-you-go | 0% | None | Unpredictable workloads |
| Azure Savings Plan | Up to 65% | 1 or 3 year | Flexible compute |
| Reserved Instances | Up to 72% | 1 or 3 year | Steady-state workloads |
| Spot VMs | Up to 90% | None (evictable) | Fault-tolerant workloads |
| Dev/Test Pricing | Up to 55% | Visual Studio subscription | Dev/test environments |
| Azure Hybrid Benefit | Up to 85% (with RI) | Existing Windows/SQL licenses | Windows/SQL Server workloads |

### Right-Sizing

| Strategy | Tool | Action |
|----------|------|--------|
| VM right-sizing | Azure Advisor | Resize underutilized VMs |
| Auto-shutdown | Azure Automation | Stop dev/test VMs after hours |
| Scale sets | VMSS | Auto-scale based on demand |
| Burstable VMs | B-series | Variable workloads with low baseline |
| ARM-based VMs | Dpsv5/Epsv5 (Ampere) | 20-40% savings for Linux workloads |

---

## Storage Cost Optimization

### Blob Storage Tiers

| Tier | Use Case | Cost (per GB/month, East US) |
|------|----------|------------------------------|
| Hot | Frequently accessed | ~$0.018 |
| Cool | Infrequent access (30+ days) | ~$0.01 |
| Cold | Rarely accessed (90+ days) | ~$0.0036 |
| Archive | Long-term archive (180+ days) | ~$0.00099 |

### Storage Strategies

| Strategy | Action | Savings |
|----------|--------|---------|
| Lifecycle management | Auto-tier blobs by age | 50-95% |
| Delete old snapshots | Clean up VM and disk snapshots | Variable |
| Premium to Standard | Downgrade disks where performance allows | 40-60% |
| Reserved capacity | 1 or 3 year storage reservations | Up to 38% |
| Soft delete retention | Reduce retention period | Reduce storage waste |

---

## Database Cost Optimization

| Strategy | Service | Action |
|----------|---------|--------|
| Reserved capacity | Azure SQL, Cosmos DB | 1 or 3 year commitments |
| Serverless tier | Azure SQL | Auto-pause for dev/test |
| Elastic pools | Azure SQL | Share resources across DBs |
| DTU to vCore | Azure SQL | Right-size compute model |
| Auto-scale RUs | Cosmos DB | Scale RUs based on demand |
| Azure Hybrid Benefit | Azure SQL | Use existing SQL Server licenses |
| Free tier | Cosmos DB | 1,000 RU/s + 25 GB free |

---

## Networking Cost Optimization

| Strategy | Description | Savings |
|----------|-------------|---------|
| Private endpoints | Avoid public internet egress | Reduced egress |
| Azure CDN | Cache content at edge | Reduced origin traffic |
| Proximity placement groups | Reduce inter-VM latency/traffic | Performance + potential cost |
| Hub-spoke topology | Centralize shared services | Reduce duplicate resources |
| Azure Front Door | Global load balancing + caching | Optimized routing |

---

## Azure Hybrid Benefit

| License | Benefit | Savings |
|---------|---------|---------|
| Windows Server | Use existing licenses on Azure VMs | Up to 40% |
| SQL Server | Use on Azure SQL/VMs | Up to 55% |
| Windows Server + RI | Combined savings | Up to 80% |
| SQL Server + RI | Combined savings | Up to 85% |
| Linux (RHEL/SUSE) | Use existing subscriptions | Up to 70% |

---

## Organization-Level Optimization

| Strategy | Description |
|----------|-------------|
| Management groups | Organize subscriptions for governance |
| Cost allocation | Tag resources for chargeback |
| Budget automation | Auto-shutdown on budget threshold |
| Azure Policy | Enforce allowed VM sizes, regions |
| Resource locks | Prevent accidental deletion |
| Advisor Score | Track optimization progress |

---

## Cost Optimization Checklist

- [ ] Review Azure Advisor cost recommendations weekly
- [ ] Enable budgets and alerts per subscription/resource group
- [ ] Analyze Savings Plans and Reservation recommendations
- [ ] Right-size VMs quarterly using Advisor
- [ ] Implement blob lifecycle management policies
- [ ] Enable auto-shutdown for dev/test VMs
- [ ] Apply Azure Hybrid Benefit where applicable
- [ ] Delete unused public IPs, disks, and snapshots
- [ ] Review and consolidate underutilized resources
- [ ] Implement tagging strategy for cost allocation
- [ ] Use Spot VMs for fault-tolerant workloads
- [ ] Schedule non-production environments to stop

---

## Documentation Links

- Azure Cost Management: https://learn.microsoft.com/en-us/azure/cost-management-billing/
- Azure Advisor: https://learn.microsoft.com/en-us/azure/advisor/
- Azure Pricing Calculator: https://azure.microsoft.com/en-us/pricing/calculator/
- Azure Reservations: https://learn.microsoft.com/en-us/azure/cost-management-billing/reservations/
- Azure Hybrid Benefit: https://azure.microsoft.com/en-us/pricing/hybrid-benefit/
