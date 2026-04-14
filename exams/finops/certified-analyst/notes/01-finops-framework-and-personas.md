# 01. FinOps Framework and Personas

## The Framework in One Paragraph

FinOps is the operating model for managing the variable, usage-based cost of the cloud. It is built on three lifecycle phases (Inform, Optimize, Operate), six principles, a maturity ladder (Crawl, Walk, Run), personas who play defined roles, and a Capabilities model that names the actual work. The FinOps Foundation refreshed the Capabilities model in 2024-2025, reorganizing work into scopes (Understand Cloud Usage and Cost, Quantify Business Value, Optimize Cloud Usage and Cost, Manage the FinOps Practice) plus intersecting disciplines.

## Lifecycle Phases

### Inform
Make cost and usage visible, allocate to business owners, build trustworthy reports and dashboards, forecast accurately.

### Optimize
Take action: rate optimization (RIs, Savings Plans, CUDs, EDPs), usage optimization (rightsizing, scheduling, idle cleanup), architectural optimization (serverless, spot, storage tiering).

### Operate
Institutionalize the practice: governance, policy, automation, continuous improvement, cultural change, KPI tracking.

A common exam trap is thinking you finish Inform before starting Optimize. You do not. All three run continuously, and any mature team has threads in all three phases at all times.

## The Six Principles (memorize the exact wording)

1. Teams need to collaborate
2. Everyone takes ownership for their cloud usage
3. A centralized team drives FinOps
4. FinOps reports should be accessible and timely
5. Decisions are driven by business value of cloud
6. Take advantage of the variable cost model of the cloud

On the exam, paraphrases that shift meaning are wrong. For example, "a centralized team does FinOps for the company" changes "drives" into "does", which contradicts principle 2 (everyone takes ownership).

## Maturity: Crawl, Walk, Run

| Stage | Posture | Typical signal |
|-------|---------|----------------|
| Crawl | Basic allocation, manual reports, reactive optimization | < 50 percent allocation, < 40 percent commit coverage |
| Walk | Automated reports, showback, formal Optimize cadence | 75-90 percent allocation, 50-70 percent coverage |
| Run | Chargeback, real-time anomaly response, architecture-level optimization, unit economics mature | > 95 percent allocation, targeted coverage by workload class |

Different capabilities can be at different maturities. An org can be Run on Allocation and Crawl on Sustainability simultaneously.

## Personas

The FinOps Foundation names at least the following:

- **FinOps Practitioner / Analyst**: day-to-day operator of the practice. Builds reports, runs allocation, drives optimization recommendations. Primary audience for FOCA.
- **Engineering / DevOps / SRE**: owns architecture, rightsizing, and implementation of optimization.
- **Finance**: owns budgeting, invoicing, accounting treatment of cloud (OpEx, COGS, capex for commitments).
- **Procurement**: owns contracts, EDPs, MACC, private pricing.
- **Leadership**: sponsors the practice, sets KPIs, removes blockers.
- **Product**: defines the business metrics that anchor unit economics.
- **ITAM / Software Asset Management**: licensing, BYOL, SaaS spend governance.
- **Sustainability**: emissions and GreenOps alignment.

Each persona owns certain capabilities. Expect questions of the form "which persona is primarily responsible for X." The primary owner of a chargeback policy is typically Finance with FinOps as a partner. The primary owner of workload rightsizing is Engineering with FinOps as a coach.

## The 2024-2025 Capabilities Refresh

The Capabilities model is the most likely place the exam will feel current. Key capabilities to know:

- Data Ingestion
- Allocation
- Reporting and Analytics
- Anomaly Management
- Forecasting
- Budgeting
- Architecting for Cloud
- Workload Optimization
- Rate Optimization
- Licensing and SaaS
- Cloud Sustainability
- FinOps Education and Enablement
- Invoicing and Chargeback
- Policy and Governance
- FinOps Practice Operations
- Intersecting Disciplines (ITAM, ITFM, Sustainability, Security, Product)

For each capability you should be able to answer: who owns it, what are inputs and outputs, what does Crawl vs Run look like, and what KPI measures its health.

## How the Framework Shows Up on the Exam

- Principle paraphrase traps (exact wording matters)
- Persona-to-capability matching
- Maturity identification from a description
- Lifecycle-phase tagging of activities
- Capability-to-KPI mapping

## Study Exercises

1. Recite the six principles from memory. Write them down. Compare to the canonical wording.
2. For each capability, name the persona most likely to own it and the KPI you would use.
3. Map ten activities from your own job to phases (Inform, Optimize, Operate).
4. Identify three capabilities in your org and rate each as Crawl, Walk, or Run with evidence.
