# 02. Cost Allocation and Tagging

## Why Allocation Is the Foundation

Without allocation you cannot do showback, chargeback, unit economics, or variance analysis by owner. Allocation is the mechanism that answers "whose cost is this?" and it is the most common place FinOps programs stall. The exam treats allocation as the central operational challenge of Inform.

## The Allocation Hierarchy

Cloud spend can be allocated from multiple signals, often layered as a fallback chain:

1. Resource tags or labels (most granular)
2. Account, subscription, or project (coarse but reliable)
3. Organizational unit or management group (high-level)
4. Cost center policy table (fallback mapping)
5. Unallocated bucket (what remains)

A mature allocation engine walks this chain per line item until it finds a signal that maps to a business owner. "Unallocated" should be an explicit, visible, trended number, not a hidden gap.

## Tag Strategy Elements

### Mandatory tags
Start small. Four to six tags covers most needs:

- `cost-center` or `business-unit`
- `app` or `service`
- `env` (prod, staging, dev, sandbox)
- `owner` (email or team alias)
- `data-classification` (for security cross-over)
- `project` or `program` (for finite work)

### Tag governance
Enforce at create time via IaC linters, admission controllers, Cloud Custodian, AWS Service Control Policies, Azure Policy, GCP Organization Policy. Detection-based cleanup is always more expensive than prevention.

### Case sensitivity and normalization
AWS tags are case-sensitive, Azure tag names are case-insensitive, GCP labels are strictly lowercase. Always normalize in your FOCUS pipeline.

## Provider-Specific Allocation Constructs

| Provider | Primary allocation primitives |
|----------|-------------------------------|
| AWS | Tags, cost allocation tags (must activate), Cost Categories, linked accounts, Organizations OUs |
| Azure | Tags, Management Groups, Subscriptions, Resource Groups, cost allocation rules |
| GCP | Labels, Projects, Folders, Billing account hierarchy, custom cost allocation |

AWS Cost Categories are worth particular attention. They let you build rule-based groupings that behave like virtual dimensions. Azure Management Groups and GCP Folders provide hierarchy that often replaces tagging for org-level splits.

## Shared Cost Handling

Not every cost is directly attributable. Classic shared cost buckets:

- Data transfer and networking (often cross-AZ or cross-region)
- Support plans (often a percent of spend)
- Security tooling (often shared platforms)
- Shared observability, CI/CD, shared clusters
- Amortized commitment fees (RI upfronts, SP fees)

### Allocation methods for shared cost

- **Direct**: bill it to the service that generated it (when identifiable)
- **Proportional**: split by direct spend share
- **Even**: split equally across business units
- **Fixed**: pre-negotiated percentages
- **Usage-based**: by a driver metric (requests, GB, cores)

Pick the method that incentivizes the right behavior. Even splits often hide inefficiency; proportional splits penalize large teams even when they are efficient.

## Amortization

Upfront commitment fees must be amortized to avoid month-one spikes.

- AWS RI upfront: amortize across term monthly
- AWS Savings Plan commit: EffectiveCost already amortizes in FOCUS
- Azure Reservation upfront: amortize across term
- GCP CUDs: typically billed as usage, less amortization concern

Use EffectiveCost (FOCUS) or AmortizedCost (AWS CUR) for unit economics, not BilledCost.

## Cost Categories vs Tags

Tags describe a resource. Cost Categories (or equivalent) describe a business grouping. Use Categories to absorb legacy or untaggable spend, to group tags (for example, 12 tag values into 3 product lines), and to model matrix organizations.

## Kubernetes Allocation

Shared clusters are a black hole without extra tooling. Use OpenCost or Kubecost to:

- Emit per-namespace, per-workload, per-label costs
- Split idle capacity as a separate line
- Push data into your FOCUS warehouse

Namespace-to-team mapping must be maintained. Label governance for pods is analogous to tag governance for cloud resources.

## Untagged and Untaggable Spend

Not everything supports tags. Data transfer charges, some managed service subcomponents, and marketplace spend may be untaggable. Handle with:

- Cost Categories / allocation rules based on account + service
- A standing "untaggable shared services" pool allocated by policy
- A documented accepted-untagged list, trended over time

## Measuring Allocation Quality

Key metrics:

- **Allocation coverage**: percent of spend mapped to a business owner
- **Tag coverage**: percent of resources with all mandatory tags
- **Unallocated trend**: absolute and relative over time
- **Allocation dispute rate**: invoices disputed per month

Targets for Run maturity: allocation coverage above 95 percent, tag coverage above 90 percent, dispute rate below 2 percent.

## Common Exam Traps

- Believing perfect tagging is a prerequisite for allocation (it is not, use a fallback chain)
- Mixing up tag policies with cost categories
- Forgetting to activate cost allocation tags in AWS (they do not appear in CUR by default)
- Allocating marketplace spend like regular service spend (often requires special handling)
- Over-allocating shared costs and double-counting
