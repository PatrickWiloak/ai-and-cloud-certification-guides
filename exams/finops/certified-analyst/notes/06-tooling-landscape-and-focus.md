# 06. Tooling Landscape and FOCUS

## The FOCUS Specification

FOCUS (FinOps Open Cost and Usage Specification) is an open standard that defines a single schema for cloud and SaaS billing data. It is the most important technical development in FinOps since the practice was named. The FinOps Foundation maintains the spec; AWS, Azure, GCP, OCI, and many SaaS vendors now emit FOCUS-compatible exports.

### Why FOCUS matters

Before FOCUS, every vendor had a different schema. Multi-cloud reporting required custom ETL and lost fidelity. FOCUS standardizes column names, definitions, and semantics so the same SQL works across providers.

### Key columns by family

**Identifier**
- ProviderName, PublisherName, InvoiceIssuerName
- BillingAccountId, BillingAccountName
- SubAccountId, SubAccountName
- InvoiceId, BillingPeriodStart, BillingPeriodEnd

**Time**
- ChargePeriodStart, ChargePeriodEnd

**Service and SKU**
- ServiceCategory, ServiceName
- SkuId, SkuPriceId
- RegionId, RegionName, AvailabilityZone

**Pricing**
- PricingCategory (Standard, Dynamic, Committed, Other)
- PricingUnit, PricingQuantity
- ListUnitPrice, ContractedUnitPrice

**Cost**
- BilledCost: what the invoice shows, before amortization
- EffectiveCost: amortized, post-discount, for unit economics
- ListCost: what it would cost at public rates
- ContractedCost: what it would cost at your negotiated rate

**Charge classification**
- ChargeCategory: Usage, Purchase, Tax, Credit, Adjustment
- ChargeClass: Correction, Refund, null
- ChargeDescription, ChargeFrequency

**Commitment**
- CommitmentDiscountId, CommitmentDiscountName
- CommitmentDiscountCategory (Spend, Usage)
- CommitmentDiscountType

**Resource and tags**
- ResourceId, ResourceName, ResourceType
- Tags (provider-normalized)

Memorize the ChargeCategory values and the Cost column distinctions; both show up in the exam.

## FOCUS 1.0 vs 1.1

- 1.0 (2024): initial GA, baseline columns, covered most common needs
- 1.1 (2024-2025): expanded commitment columns, tag standardization, clarified SKU modeling, added capacity reservation support

Check vendor export versions and map columns carefully.

## Native Cloud Cost Tools

### AWS
- Cost Explorer: interactive analysis
- Cost and Usage Report (CUR and CUR 2.0): definitive detail, S3 delivered, queryable in Athena or Redshift
- AWS Billing Conductor: internal pricing plans for end customers of AWS resellers
- Cost Anomaly Detection: ML-based alerts
- Compute Optimizer: rightsizing recommendations
- Cost Categories: virtual allocation dimensions
- Savings Plans and RI coverage reports

### Azure
- Cost Management: analysis and budgets
- EA / MCA export: detailed billing
- Azure Advisor: rightsizing and commitment recommendations
- Reservations recommendations
- Anomaly Detection (preview and GA features)

### GCP
- Billing reports in console
- BigQuery billing export: definitive detail
- Recommender (includes idle, rightsizing, CUD recommendations)
- Cost breakdown reports and budget alerts

## Third-Party Platforms

Not every tool is on the exam, but the exam expects you to know categories and can include representative names.

### All-in-one platforms
- Apptio Cloudability (IBM)
- Flexera One
- CloudHealth (Broadcom / VMware)
- Vantage
- Finout
- nOps

### Specialized
- ProsperOps: autonomous commitment management
- Spot.io (NetApp): spot/savings automation
- Kubecost and OpenCost: Kubernetes cost
- Cast AI: Kubernetes autoscaling and cost
- Harness Cloud Cost Management
- Zesty: autonomous commit and storage

### Data warehouse native
Increasingly, mature orgs build on a data warehouse (Snowflake, BigQuery, Databricks) using FOCUS, with BI layered on top (Looker, Tableau, Power BI, Sigma). This is the "roll your own" path and is valid for Run maturity.

## Selection Criteria

- FOCUS support (emit, ingest, both)
- Data freshness (hours lag)
- Multi-cloud coverage and depth
- Container and SaaS coverage
- Allocation engine flexibility
- Anomaly detection quality
- Commitment management automation level
- API and integration story
- Pricing model (percent of spend vs flat, per-user, per-resource)

Percent-of-spend pricing can become expensive at scale and can misalign incentives.

## Tool Implementation Patterns

- Start with native tools for the first 3-6 months
- Add a specialist (Kubecost for containers, ProsperOps for commits) before an all-in-one
- Adopt an all-in-one or warehouse-native approach when multi-cloud complexity justifies it
- Always maintain native-tool fluency; third-party views can lag or mask provider detail

## Data Pipeline Considerations

A FinOps data pipeline typically has:

1. Ingestion from each provider (CUR 2.0, Azure export, BigQuery billing)
2. Normalization to FOCUS
3. Enrichment (business taxonomy, owner lookup, unit metrics from Product)
4. Storage in warehouse
5. Serving layer (BI, alerts, API)

Data freshness targets: daily for operational, near-real-time for anomaly detection, monthly for reconciliation.

## Common Exam Traps

- Confusing BilledCost with EffectiveCost
- Believing FOCUS replaces all native tool usage (it does not)
- Believing tool choice is the hard part (process and culture are harder)
- Not knowing the ChargeCategory enumeration
- Expecting FOCUS to perfectly cover every vendor nuance (it does not; native fields remain)
