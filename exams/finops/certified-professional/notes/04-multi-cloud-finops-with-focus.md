# 04. Multi-Cloud FinOps with FOCUS

## Why Multi-Cloud Is Hard

Each cloud has its own billing schema, terminology, commit mechanics, and cadence. Before FOCUS, any multi-cloud program built custom ETL for each vendor and still lost fidelity on translation. Multi-cloud FinOps at Professional level is about building a unified data and operating layer that respects each cloud's native constructs while enabling comparable reporting.

## FOCUS as the Unifying Layer

FOCUS (FinOps Open Cost and Usage Specification) defines a common schema across providers. FOCUS 1.0 (2024) established the baseline; 1.1 (2024-2025) expanded commitment modeling, tag handling, and capacity reservations. AWS, Azure, GCP, OCI, and major SaaS vendors now emit FOCUS-compatible exports.

### Columns you must know cold

Identifier: ProviderName, PublisherName, BillingAccountId, SubAccountId

Time: ChargePeriodStart, ChargePeriodEnd, BillingPeriodStart

Service: ServiceCategory, ServiceName

Cost: BilledCost, EffectiveCost, ListCost, ContractedCost

Charge: ChargeCategory (Usage/Purchase/Tax/Credit/Adjustment), ChargeClass (Correction/Refund/null), ChargeDescription

Pricing: PricingCategory (Standard/Dynamic/Committed/Other), ListUnitPrice, ContractedUnitPrice, PricingQuantity, PricingUnit

Commitment: CommitmentDiscountId, CommitmentDiscountCategory (Spend/Usage), CommitmentDiscountType

Resource: ResourceId, ResourceName, ResourceType, RegionId, RegionName

Tags: Tags (normalized map)

## Cost Column Semantics (critical)

- **BilledCost**: what the invoice will show. Use for finance reconciliation.
- **EffectiveCost**: amortized, post-discount. Use for unit economics and business reporting.
- **ListCost**: what it would cost at public rates. Use for savings math (ESR).
- **ContractedCost**: what it would cost at your negotiated rate before commitment discounts.

Mismatching these is the #1 reason multi-cloud reports are wrong.

## Provider-to-FOCUS Mapping

### AWS CUR 2.0
- Native AWS data export with FOCUS output option
- Includes FOCUS columns plus AWS-specific columns
- Delivered to S3, queryable via Athena or Redshift

### Azure Cost Management FOCUS export
- EA/MCA customers can emit FOCUS via Cost Management exports
- Daily or monthly cadence

### GCP BigQuery FOCUS export
- Billing export to BigQuery with FOCUS schema
- Native BigQuery SQL surface

### Third-party SaaS
- Snowflake, Databricks, and others are starting to emit FOCUS
- Many still require custom translation

## Multi-Cloud Pipeline Architecture

Typical pattern:

1. **Ingest**: each provider's FOCUS export lands in blob/bucket storage
2. **Normalize**: enforce FOCUS 1.1, normalize tag case, fill missing columns
3. **Enrich**: add business taxonomy (cost center, app, product) from a source-of-truth system
4. **Store**: warehouse (Snowflake, BigQuery, Databricks, Redshift)
5. **Model**: dbt or equivalent for derived marts (by BU, by product, by environment)
6. **Serve**: BI (Looker, Tableau, Sigma, Power BI), anomaly detection, alerting, API
7. **Feed back**: dashboards for engineers, BUs, finance, leadership

## Allocation Across Clouds

A common taxonomy layered over per-cloud signals:

- Shared tags (cost-center, app, env) mandatory across clouds
- Fallback hierarchy: AWS account > Azure subscription > GCP project
- Cross-cloud Cost Categories or allocation rules
- Unallocated bucket visible per cloud and in aggregate

## Cross-Cloud Commitment Strategy

Commitments are cloud-specific. Cross-cloud strategy is about portfolio balance, not shared commits.

Portfolio design:

- AWS: Compute SP for EC2/Fargate/Lambda, RIs for RDS/ElastiCache
- Azure: Savings Plan for Compute, Reservations for DBs, MACC for Azure-wide discount
- GCP: Spend-based or flexible CUDs, resource-based for high-steady SKUs

Avoid: over-committing in any one cloud when a migration is planned. Cross-cloud visibility reveals these risks early.

## Comparing Across Clouds

Questions you should be able to answer from FOCUS:

- What is our total EffectiveCost by cloud? By service category?
- What is our coverage and utilization by cloud?
- What is ESR by cloud?
- Where is our carbon footprint by cloud (when carbon data is joined)?
- Which workloads cost more in their current cloud vs a target cloud?

## Lock-In and Portability

Multi-cloud often aims to reduce lock-in. FinOps perspective:

- Commitments are the primary financial lock-in mechanism
- Managed services (DynamoDB, BigQuery, Cosmos DB) lock architectures
- Data gravity is real; egress cost is a migration tax
- Weigh portability against the ESR loss of not committing

There is no free multi-cloud. Either pay with extra engineering (abstraction) or pay with lower ESR (less commitment).

## FOCUS Governance

FOCUS is versioned. Treat it like API versioning:

- Test upgrades in staging
- Maintain column mapping for backward compatibility
- Follow FinOps Foundation working group for upcoming changes
- Contribute issues and feedback; the spec is community-driven

## Common Exam Traps

- Using BilledCost for unit economics (wrong; use EffectiveCost)
- Using EffectiveCost for invoice reconciliation (wrong; use BilledCost)
- Assuming cross-cloud commits are a real thing (they are not)
- Ignoring tag case sensitivity differences
- Treating FOCUS as a replacement for provider-specific detail (it complements)
- Underestimating the engineering investment to migrate to FOCUS cleanly
