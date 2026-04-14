# 02. Rate Optimization: RIs, Savings Plans, CUDs, and Private Pricing

## The Rate Optimization Stack

Rate optimization is the collective set of mechanisms that reduce unit price without changing usage. The stack has layers:

1. Public on-demand pricing (the default)
2. Volume or tier discounts (automatic at scale)
3. Commitment-based discounts (RIs, SPs, CUDs)
4. Spot and preemptible pricing (for interruptible workloads)
5. Private pricing agreements (EDP, MACC, custom)
6. Marketplace and resale pricing

Rate Optimization as a FinOps capability deals primarily with layers 3, 4, 5. Usage and architectural moves live in other capabilities.

## AWS Rate Optimization Instruments

### Reserved Instances (RIs)

- Standard RI: largest discount (up to ~72 percent), tied to instance family/region, shareable across accounts
- Convertible RI: smaller discount (up to ~54 percent), allows family changes
- RI term: 1 or 3 years; payment: All Upfront, Partial Upfront, No Upfront
- Scope: regional (flexible AZ) vs zonal (capacity reservation)
- Mostly superseded by Savings Plans for EC2 compute, still relevant for RDS, ElastiCache, OpenSearch, Redshift

### Savings Plans (SPs)

- Compute SP: most flexible; applies to EC2, Fargate, Lambda; instance family-agnostic
- EC2 Instance SP: instance family specific, higher discount
- SageMaker SP: SageMaker training and inference
- Commit: dollars per hour, not units
- Auto-applied against highest-discount-eligible usage

### Private Pricing

- **EDP (Enterprise Discount Program)**: multi-year spend commit for an AWS-wide discount, typically 5-15 percent
- **PPA (Private Pricing Agreement)**: service-specific negotiated rates
- **Support tier discounts**: Business/Enterprise/Enterprise On-Ramp

## Azure Rate Optimization Instruments

- **Reservations**: 1 or 3 year; compute, SQL DB, Cosmos DB, Storage, and more
- **Azure Savings Plan for Compute**: similar to AWS Compute SP; commits hourly spend for compute flexibility
- **Azure Hybrid Benefit**: BYOL for Windows/SQL with Software Assurance
- **Spot VMs**: interruptible capacity discount
- **Azure Consumption Commitment (MACC)**: multi-year spend commit for Azure-wide discount
- **Enterprise Agreement (EA)** and **Microsoft Customer Agreement (MCA)**: contract frameworks

## GCP Rate Optimization Instruments

- **Resource-based CUDs**: commit to specific instance types in a region; up to ~57 percent discount; 1 or 3 year
- **Spend-based CUDs**: commit to a dollar amount across compute SKUs; more flexibility, lower discount
- **Flexible CUDs**: even broader flexibility across machine types
- **Sustained Use Discounts**: automatic monthly discount for running instances; automatic, no commitment
- **Custom CUDs**: negotiated for large customers
- **Spot VMs / Preemptible**: interruptible capacity discount

## The Commitment Decision Tree

Given a workload, ask:

1. Is the usage stable enough to commit? (look at 90-day floor, not average)
2. How likely is architectural change in the next 1-3 years?
3. Is the workload interruptible? (spot first for these)
4. Does the provider offer a flexible commit (Compute SP, flexible CUD)?
5. Is the commit term aligned with business planning horizons?
6. Is there a central pool that can absorb unused commit risk?

## Coverage Targets

Aim for coverage below the stable usage floor, not at the mean.

- Stable mature workloads with low migration risk: 70-85 percent coverage, 1-3 year mix
- High-change environments: 50-65 percent coverage, 1 year terms
- New workloads (less than 6 months of history): do not commit yet

## The Effective Savings Rate (ESR)

ESR = (ListCost - EffectiveCost) / ListCost

It integrates all rate sources: volume, commitments, private pricing, spot. A healthy ESR varies by industry and workload mix:

- Steady-state enterprise AWS: 25-35 percent typical
- Aggressive spot-heavy: 40 percent+
- New cloud adopters: 10-15 percent
- Greenfield with mostly managed services: lower (less commit-eligible)

Track ESR monthly. Target a specific ESR, not just a coverage number; coverage without utilization is a loss.

## Convertible vs Standard: When It Matters

Convertible RIs and Compute SPs are superior when:

- Architectural change is expected
- Instance family evolution is likely (Graviton migration)
- Business unit usage will shift across products

Standard RIs and EC2 Instance SPs win when:

- Usage pattern is fixed for 3 years
- Maximum discount is the priority
- There is a central pool to absorb mismatch

## Autonomous Commitment Platforms

ProsperOps, Zesty, Spot.io Commitments manage the commitment portfolio continuously: laddered short-term commits, exchanges where allowed, and a target ESR. They typically earn their fee for orgs over 10M AWS spend.

Trade-offs:

- Pro: measurable ESR improvement, removes renewal anxiety, continuous optimization
- Con: ongoing fee (often percent of savings), less visibility into individual commits, provider-specific

## Private Pricing Negotiation

EDPs, MACCs, and equivalent are negotiated contracts. Key levers:

- Multi-year term (2-5 years typical)
- Spend commitment (with true-down provisions if possible)
- Specific service discounts (custom SKUs)
- Professional services credits
- Marketing or case study value
- Co-terminus end dates

Never negotiate in the last quarter of a contract; vendors know. Start 6-9 months ahead.

## Common Exam Traps

- Confusing coverage and utilization
- Assuming higher coverage is always better
- Picking Standard RI in a migration scenario
- Ignoring Compute SP flexibility advantage
- Mixing up EDP (spend commit for discount) with MACC (Azure equivalent)
- Forgetting sustained use discounts are automatic in GCP (not a commit)
- Recommending commits for new workloads without 90+ day history
