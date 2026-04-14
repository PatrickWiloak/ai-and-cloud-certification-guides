# FinOps Certified Professional - Fact Sheet

## Exam Identity

| Attribute | Value |
|-----------|-------|
| Certification body | FinOps Foundation (Linux Foundation) |
| Exam code | FOCP-Pro |
| Level | Professional / Senior |
| Delivery | Online proctored via Linux Foundation portal |
| Duration | 120 minutes |
| Questions | 65 multiple choice, multi-response, and scenario-based |
| Passing score | 75 percent |
| Cost | 450 USD (may bundle with training) |
| Validity | 2 years |
| Languages | English (additional languages planned) |
| Prerequisites | FOCP required, FOCA recommended |

## Domain Blueprint

| Domain | Weight |
|--------|-------:|
| 1. Advanced Framework and Capabilities | 10% |
| 2. Rate Optimization (RIs, SPs, CUDs, EDPs) | 20% |
| 3. Workload Rightsizing and Architectural Efficiency | 20% |
| 4. Multi-Cloud FinOps with FOCUS | 15% |
| 5. Organizational Maturity, Operating Models, Governance | 15% |
| 6. Sustainability and GreenOps | 10% |
| 7. FinOps for AI/ML and Data | 10% |

## Key Concepts by Domain

### Domain 1: Advanced Framework

- Full Capabilities taxonomy (16+ capabilities grouped into scopes)
- Intersecting disciplines: ITAM, ITFM, Security, Sustainability, Product
- FinOps operating models: centralized, federated, decentralized, hybrid
- Crawl/Walk/Run by capability, not globally
- Evolution of FinOps Foundation output and working groups

### Domain 2: Rate Optimization

- AWS: Reserved Instances (Standard vs Convertible), Savings Plans (Compute, EC2 Instance, SageMaker), private pricing (EDP, PPA)
- Azure: Reservations, Savings Plan for Compute, Azure Consumption Commitment (MACC)
- GCP: Committed Use Discounts (resource-based and spend-based), Custom CUDs, negotiated discounts
- Commitment portfolio design: coverage targets, term mix, layering
- Convertible vs standard trade-offs
- Autonomous commitment platforms (ProsperOps, Zesty, Spot.io)
- Effective Savings Rate as the integrating KPI

### Domain 3: Workload Optimization

- Rightsizing loops: observe, recommend, implement, validate
- Idle detection and scheduling
- Storage tiering and lifecycle (S3 IA/Glacier, Azure Blob tiers, GCS Nearline/Coldline/Archive)
- Spot, preemptible, Azure Spot, GCP Spot
- Architectural moves: serverless, managed services, Graviton and ARM, container density
- Data transfer optimization (VPC endpoints, CloudFront, Cross-AZ reduction)

### Domain 4: Multi-Cloud and FOCUS

- FOCUS 1.0 and 1.1 mastery
- Cross-cloud allocation and reporting patterns
- Data pipeline architecture: ingest, normalize, enrich, serve
- Multi-cloud commitment strategy trade-offs
- Vendor lock-in and commitment flexibility

### Domain 5: Maturity, Operating Models, Governance

- Operating model selection (centralized, federated, hybrid)
- FinOps team structure and staffing ratios
- Policy and guardrails (preventive vs detective)
- Enablement and education programs
- Incentive and performance integration
- Executive sponsorship and stakeholder management
- Vendor and procurement governance

### Domain 6: Sustainability and GreenOps

- Cloud provider carbon reporting (AWS CCFT, Azure Emissions Impact, GCP Carbon Footprint)
- Scope 1/2/3 basics and which cloud emissions live where
- Software Carbon Intensity (SCI) specification
- Region and workload carbon awareness
- Efficiency as cost and carbon co-benefit
- GreenOps Capability and emerging standards

### Domain 7: FinOps for AI/ML and Data

- GPU economics (A100, H100, H200, B200, MI300, TPU, AWS Trainium/Inferentia)
- Inference vs training cost profiles
- Token-based pricing for LLM APIs
- Vector database and retrieval cost
- Data platform cost (Snowflake, Databricks, BigQuery, Redshift)
- Model governance tied to cost
- Provisioned capacity vs on-demand for AI

## Official Resources

- FinOps Foundation: https://www.finops.org/
- FOCUS spec: https://focus.finops.org/
- Framework Capabilities: https://www.finops.org/framework/capabilities/
- State of FinOps: https://data.finops.org/
- FinOps for AI: FinOps Foundation project page
- Sustainability: https://www.finops.org/topics/sustainability/
- Green Software Foundation SCI spec: https://sci.greensoftware.foundation/
- AWS Customer Carbon Footprint Tool
- Azure Emissions Impact Dashboard
- Google Cloud Carbon Footprint

## Recommended Materials

- Book: Cloud FinOps, 2nd edition (Storment, Fuller)
- Book: Designing Data-Intensive Applications (for data platform context)
- FinOps Foundation Professional bootcamp
- Provider economics courses (AWS Cloud Economics, Azure FinOps learning path, GCP FinOps hub)
- Real-world: lead or participate in at least one multi-cloud commitment renewal cycle
