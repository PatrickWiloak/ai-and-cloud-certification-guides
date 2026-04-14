# FinOps Certified Analyst - Fact Sheet

## Exam Identity

| Attribute | Value |
|-----------|-------|
| Certification body | FinOps Foundation (Linux Foundation) |
| Exam code | FOCA |
| Level | Associate / Analyst |
| Delivery | Online proctored via Linux Foundation portal |
| Duration | 90 minutes |
| Questions | 60 multiple choice and multi-response |
| Passing score | 75 percent |
| Cost | 325 USD (bundles with training discount) |
| Validity | 2 years |
| Languages | English; additional languages rolling out |
| Retake policy | 14 day wait, up to 2 retakes with a single voucher |

## Domain Blueprint

| Domain | Weight |
|--------|-------:|
| 1. FinOps Framework, Personas, and Capabilities | 15% |
| 2. Cost Allocation, Tagging, and Hierarchy | 20% |
| 3. Anomaly Detection, Variance, and Reporting | 20% |
| 4. Chargeback and Showback Models | 15% |
| 5. Unit Economics and KPIs | 15% |
| 6. Tooling Landscape and FOCUS | 15% |

## Key Concepts by Domain

### Domain 1: Framework, Personas, Capabilities

- Six FinOps Principles (teams collaborate, everyone takes ownership, centralized team drives FinOps, reports are accessible and timely, decisions are driven by business value of cloud, variable cost model embraced)
- FinOps lifecycle phases: Inform, Optimize, Operate
- Maturity: Crawl, Walk, Run
- Personas: FinOps Practitioner, Engineer, Finance, Product, Leadership, Procurement, ITAM, Sustainability
- 2024-2025 Capabilities refresh: Data Ingestion, Allocation, Reporting and Analytics, Anomaly Management, Forecasting, Budgeting, Architecting for Cloud, Workload Optimization, Rate Optimization, Licensing and SaaS, Cloud Sustainability, FinOps Education, Invoicing and Chargeback, Policy and Governance, FinOps Practice Operations, Intersecting Disciplines

### Domain 2: Allocation and Tagging

- Tag hygiene, mandatory tags, inheritance, tag policies
- Cost categories (AWS), Management Groups and tags (Azure), Labels and folder hierarchy (GCP)
- Allocation methods: direct, proportional, even-split, custom
- Shared cost handling (data transfer, support, RI/SP amortization)
- Untagged and untaggable spend strategies

### Domain 3: Anomaly and Reporting

- Definitions: anomaly vs variance vs drift
- Detection techniques: threshold, statistical (z-score, MAD), seasonal, ML-based
- Signal-to-noise tuning, alert routing
- Variance analysis: plan vs actual, month over month, commit burn-down
- Reporting cadences and audiences

### Domain 4: Chargeback and Showback

- Showback: visibility without financial transfer
- Chargeback: actual financial transfer to business units
- Hybrid models and internal billing transfer pricing
- Shared services allocation approaches
- Dispute and true-up processes

### Domain 5: Unit Economics and KPIs

- Cost per unit of business value (per customer, per transaction, per tenant)
- COGS vs OpEx treatment of cloud
- Rate of cloud cost growth vs revenue growth
- Effective savings rate (ESR), commitment coverage, commitment utilization
- Forecast accuracy metrics

### Domain 6: Tooling and FOCUS

- FOCUS 1.0 and 1.1 columns: BilledCost, EffectiveCost, ListCost, ContractedCost, ChargeCategory, ChargeClass, CommitmentDiscountId, etc.
- Native cost tools: AWS Cost Explorer and CUR 2.0, Azure Cost Management, GCP Billing export
- Third-party platforms: Apptio Cloudability, Flexera One, CloudHealth, Vantage, Finout, ProsperOps, Spot.io, Kubecost/OpenCost
- Data warehouse patterns: Snowflake, BigQuery, Databricks for FinOps

## Official Resources

- FinOps Foundation: https://www.finops.org/
- FOCUS spec: https://focus.finops.org/
- State of FinOps: https://data.finops.org/
- Framework capabilities: https://www.finops.org/framework/capabilities/
- Linux Foundation training portal: https://training.linuxfoundation.org/

## Recommended Supplementary Materials

- Book: Cloud FinOps, 2nd edition by J.R. Storment and Mike Fuller
- FinOps Foundation on-demand courses (Analyst bootcamp)
- Hands-on dataset: any one-month CUR 2.0 export converted to FOCUS
- Slack channels: #focus, #anomaly-detection, #analyst-exam-prep
