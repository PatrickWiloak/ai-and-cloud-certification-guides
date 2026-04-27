# FinOps Certified Engineer

## Exam Overview

The FinOps Certified Engineer (FOCE) exam validates your technical ability to implement FinOps practices at the engineering level. This certification demonstrates proficiency in building and managing cloud cost data pipelines, implementing automation for cost optimization, and engineering solutions that support FinOps practices across cloud environments.

**Exam Details:**
- **Certification Body:** FinOps Foundation (part of The Linux Foundation)
- **Duration:** 60 minutes
- **Number of Questions:** 50 multiple choice questions
- **Passing Score:** 70%
- **Cost:** $300 USD
- **Delivery:** Online proctored
- **Prerequisites:** FinOps Certified Practitioner (FOCP)
- **Validity:** 2 years
- **Recertification:** Retake the exam or earn continuing education credits

## Exam Domains

### Domain 1: FinOps Engineering Fundamentals (15%)
- Understand the FinOps framework from an engineering perspective
- Apply FinOps principles to engineering decisions
- Implement infrastructure as code with cost awareness
- Integrate cost considerations into CI/CD pipelines
- Understand multi-cloud engineering challenges

**Key Concepts:**
- Engineering role in FinOps lifecycle
- Cost-aware architecture design
- DevOps and FinOps integration
- Infrastructure as code (IaC) for cost management
- Cloud provider APIs and SDKs

### Domain 2: Cloud Cost Data and Analytics (25%)
- Build and manage cost data pipelines
- Implement cost allocation through tagging automation
- Create cost dashboards and reporting
- Analyze cloud billing data programmatically
- Implement anomaly detection systems

**Key Concepts:**
- Cloud billing APIs (AWS CUR, Azure Cost Management API, GCP BigQuery export)
- Data pipeline architecture for cost data
- ETL processes for billing data
- Custom reporting and visualization
- Tagging automation and enforcement
- Anomaly detection algorithms and thresholds

### Domain 3: Rate and Usage Optimization (30%)
- Implement automated right-sizing workflows
- Build commitment management automation
- Engineer spot/preemptible instance strategies
- Create resource scheduling systems
- Implement waste detection and remediation

**Key Concepts:**
- Automated right-sizing pipelines
- Commitment purchase and management automation
- Spot instance orchestration and interruption handling
- Resource scheduling automation
- Waste detection scripts and workflows
- Auto-scaling configuration for cost optimization

### Domain 4: Automation and Tooling (20%)
- Build FinOps automation with Terraform, CloudFormation, and Pulumi
- Implement policy as code for cost governance
- Create custom FinOps tools and integrations
- Use cloud-native and third-party FinOps tools
- Implement event-driven cost management

**Key Concepts:**
- Infrastructure as code for cost controls
- Policy as code (OPA, Sentinel, AWS Config)
- Custom Lambda/Functions for cost automation
- FinOps tool integration (APIs, webhooks)
- Event-driven architecture for cost management
- CI/CD integration for cost validation

### Domain 5: Governance and Compliance (10%)
- Implement cost governance through automation
- Build compliance monitoring for cost policies
- Create audit trails for cost-related changes
- Implement budget controls programmatically
- Engineer guardrails using cloud-native services

**Key Concepts:**
- Service Control Policies and Organization Policies
- Budget APIs and automated alerts
- Compliance as code
- Cost policy enforcement automation
- Audit logging for cost-related actions

## Study Approach

### Phase 1: Foundation (Week 1-2)
1. **Review FinOps Practitioner Knowledge**
   - Refresh FinOps framework and principles
   - Review lifecycle phases from an engineering lens
   - Understand how engineering implements each phase

2. **Cloud APIs and Data Structures**
   - Study AWS Cost and Usage Report (CUR) schema
   - Learn Azure Cost Management REST API
   - Understand GCP BigQuery billing export schema
   - Review cloud pricing APIs

### Phase 2: Technical Deep Dive (Week 3-5)
1. **Data Engineering for FinOps**
   - Build cost data pipelines
   - Create ETL processes for billing data
   - Implement tagging automation
   - Build custom cost dashboards

2. **Optimization Engineering**
   - Automate right-sizing workflows
   - Build commitment management tools
   - Implement spot instance orchestration
   - Create resource scheduling systems

3. **Infrastructure as Code**
   - Terraform modules for cost-optimized infrastructure
   - CloudFormation templates with cost controls
   - Policy as code for cost governance

### Phase 3: Exam Preparation (Week 6-7)
1. **Practice and Review**
   - Take practice exams
   - Review real-world engineering scenarios
   - Focus on automation and tooling questions

2. **Integration Patterns**
   - CI/CD cost validation
   - Event-driven cost management
   - Cross-cloud normalization

## Key Tools and Technologies

| Category | Tools |
|----------|-------|
| **IaC** | Terraform, CloudFormation, Pulumi, CDK |
| **Policy as Code** | OPA/Rego, HashiCorp Sentinel, AWS Config |
| **Cost APIs** | AWS CUR, Azure Cost Management API, GCP Billing API |
| **Automation** | Lambda, Azure Functions, Cloud Functions, Step Functions |
| **Monitoring** | CloudWatch, Azure Monitor, Cloud Monitoring |
| **FinOps Platforms** | CloudHealth, Apptio Cloudability, Spot.io, Kubecost |
| **Data Analysis** | Athena, BigQuery, Synapse, pandas |
| **CI/CD** | Jenkins, GitHub Actions, GitLab CI, CodePipeline |

## File Index

| File | Description |
|------|-------------|
| [fact-sheet.md](fact-sheet.md) | Comprehensive reference with documentation links |
| [notes/01-finops-engineering-fundamentals.md](notes/01-finops-engineering-fundamentals.md) | FinOps engineering principles and operating model |
| [notes/02-cloud-cost-data-analytics.md](notes/02-cloud-cost-data-analytics.md) | Cloud billing APIs, cost data, and analytics |
| [notes/03-rate-and-usage-optimization.md](notes/03-rate-and-usage-optimization.md) | Rate optimization (RIs, SPs) and usage optimization |
| [notes/04-automation-and-tooling.md](notes/04-automation-and-tooling.md) | Automation, IaC, and FinOps tooling |
| [notes/05-governance-and-compliance.md](notes/05-governance-and-compliance.md) | Governance, policy, and compliance |
| [practice-plan.md](practice-plan.md) | Week-by-week study schedule |
| [scenarios.md](scenarios.md) | Exam-style practice scenarios |
| [strategy.md](strategy.md) | Study strategy and exam tactics |
