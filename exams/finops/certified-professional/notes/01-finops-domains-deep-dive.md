# 01. FinOps Domains Deep Dive

## The Framework at the Professional Level

At the Practitioner level the framework is something to know. At the Professional level it is something to use, critique, and extend. The 2024-2025 refresh reorganized the work into scopes and capabilities, and the Professional exam expects you to apply that structure to design decisions.

## The Four Scopes

The refreshed framework groups capabilities into four scopes plus intersecting disciplines:

### Scope 1: Understand Cloud Usage and Cost
- Data Ingestion
- Allocation
- Reporting and Analytics
- Anomaly Management

### Scope 2: Quantify Business Value
- Forecasting
- Budgeting
- Benchmarking
- Unit Economics

### Scope 3: Optimize Cloud Usage and Cost
- Architecting for Cloud
- Workload Optimization
- Rate Optimization
- Licensing and SaaS
- Cloud Sustainability

### Scope 4: Manage the FinOps Practice
- FinOps Education and Enablement
- Invoicing and Chargeback
- Policy and Governance
- FinOps Practice Operations

### Intersecting Disciplines
- ITAM (IT Asset Management)
- ITFM (IT Financial Management)
- Security
- Sustainability
- Product
- Procurement

## Capability Maturity Is Independent

A key Professional-level insight: capabilities mature independently. An org can be Run on Allocation and still Crawl on Sustainability. Scorecards must track per-capability maturity, not a single global level.

## Capability Ownership Matrix

Each capability has a primary owner and supporting stakeholders. A simplified view:

| Capability | Primary | Supporting |
|-----------|---------|------------|
| Data Ingestion | FinOps | Platform engineering |
| Allocation | FinOps | Engineering leaders |
| Reporting | FinOps | BI, Finance |
| Anomaly Management | FinOps | SRE, Engineering |
| Forecasting | FinOps + Finance | Engineering |
| Budgeting | Finance | FinOps, Leadership |
| Architecting for Cloud | Engineering | FinOps (coach) |
| Workload Optimization | Engineering | FinOps (coach) |
| Rate Optimization | FinOps | Procurement, Finance |
| Licensing and SaaS | ITAM | FinOps |
| Cloud Sustainability | Sustainability | FinOps, Engineering |
| Education | FinOps | All |
| Invoicing and Chargeback | Finance | FinOps |
| Policy and Governance | FinOps | Security, Engineering |
| Practice Operations | FinOps | Leadership |

## Capability-to-KPI Mapping

Every capability needs an output metric. Suggested mappings:

- Data Ingestion: data freshness, completeness percent
- Allocation: allocation coverage, unallocated trend
- Reporting: report adoption, report freshness, NPS from report consumers
- Anomaly Management: MTTD, MTTR, false positive rate
- Forecasting: forecast accuracy by BU
- Budgeting: plan variance, budget burn rate
- Benchmarking: peer comparison (internal or external)
- Unit Economics: cost per unit, trend vs revenue
- Architecting for Cloud: percent of workloads rearchitected, cost per architecture
- Workload Optimization: rightsizing implementation rate, idle percent
- Rate Optimization: ESR, commitment coverage, commitment utilization
- Licensing and SaaS: license utilization, shadow SaaS discovery rate
- Cloud Sustainability: tCO2e, SCI, region carbon mix
- Education: percent engineers trained, office hour attendance
- Invoicing and Chargeback: dispute rate, reconciliation cycle time
- Policy and Governance: policy compliance rate, policy violations
- Practice Operations: staffing ratio, delivery velocity

## The Lifecycle Revisited

Inform, Optimize, Operate are not sequential. They are concurrent activity types. A mature team has threads in all three every week.

A professional-level trap: mistaking the lifecycle for a project plan. It is not. It is a way to tag activity.

## Operating Model Choices

Four archetypes:

1. **Centralized**: central FinOps executes most work. Best for small orgs, crisis mode, or early maturity.
2. **Federated / Distributed**: central team sets standards, enables; BUs execute. Best for scale.
3. **Decentralized**: BUs fully own; central provides tooling only. Rare, works only at high maturity.
4. **Hybrid**: central for some capabilities (data, commits), federated for others (rightsizing, architecture).

Most mature large orgs land on Hybrid. The Professional exam will test your ability to recommend a model given constraints.

## Maturity Progression Design

When designing a maturity roadmap:

1. Baseline every capability
2. Identify which capabilities have highest leverage now
3. Invest in the 3-5 capabilities that move the needle, do not try to advance everything at once
4. Watch for capability dependencies (you cannot Run Chargeback without Run Allocation)
5. Review quarterly

## Capability Dependencies

Some capabilities depend on others. Key dependencies:

- Chargeback depends on Allocation at Walk or Run
- Unit Economics depends on Allocation + Product instrumentation
- Forecasting depends on stable Allocation
- Sustainability integration depends on Reporting maturity
- Rate Optimization at Run depends on Forecasting accuracy
- Workload Optimization at scale depends on Education

## Common Exam Traps

- Assuming one global maturity level instead of per-capability
- Picking "centralized" as the default for any FinOps question
- Ignoring intersecting disciplines (ITAM, Sustainability) in scenarios that signal them
- Treating the lifecycle as sequential
- Designing a capability without naming its KPI and owner
