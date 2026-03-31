# FinOps Certified Engineer - Study Strategy

## 3-Phase Study Approach

### Phase 1: Foundation and Review (Weeks 1-2)

**Goal:** Refresh FinOps Practitioner knowledge and build engineering context

1. **FinOps Framework Review**
   - Review the FinOps lifecycle from an engineering perspective
   - Understand how each capability translates to engineering work
   - Study the FinOps Foundation's engineering-specific resources
   - Map engineering tasks to FinOps phases

2. **Cloud Cost APIs and Data**
   - Study AWS Cost and Usage Report (CUR) schema and delivery
   - Learn Azure Cost Management API endpoints
   - Understand GCP BigQuery billing export format
   - Review cloud pricing APIs for each provider

3. **Infrastructure as Code Fundamentals**
   - Review Terraform provider resources for cost-relevant services
   - Study CloudFormation templates with tagging
   - Understand Pulumi and CDK cost management patterns
   - Learn about Infracost and similar pre-deployment tools

**Resources:**
- **[📖 FinOps Framework](https://www.finops.org/framework/)** - Framework review
- **[📖 AWS CUR Documentation](https://docs.aws.amazon.com/cur/latest/userguide/what-is-cur.html)** - CUR schema
- **[📖 Azure Cost Management API](https://learn.microsoft.com/en-us/rest/api/cost-management/)** - Azure API
- **[📖 GCP Billing Export](https://cloud.google.com/billing/docs/how-to/export-data-bigquery)** - GCP export

### Phase 2: Technical Deep Dive (Weeks 3-5)

**Goal:** Master the technical implementation of FinOps practices

1. **Cost Data Engineering (Week 3)**
   - Build a cost data pipeline conceptually
   - Study ETL patterns for billing data
   - Learn anomaly detection approaches
   - Practice writing cost analysis queries (Athena, BigQuery)

2. **Optimization Engineering (Week 4)**
   - Study automated right-sizing workflows
   - Learn spot instance orchestration patterns
   - Understand resource scheduling implementation
   - Practice waste detection automation

3. **Automation and Governance (Week 5)**
   - Study policy as code (OPA, Sentinel, SCPs)
   - Learn CI/CD integration for cost validation
   - Understand event-driven cost management
   - Review compliance monitoring automation

**Resources:**
- **[📖 AWS Compute Optimizer API](https://docs.aws.amazon.com/compute-optimizer/latest/APIReference/Welcome.html)** - Right-sizing API
- **[📖 Spot Best Practices](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-best-practices.html)** - Spot engineering
- **[📖 OPA Documentation](https://www.openpolicyagent.org/docs/latest/)** - Policy as code
- **[📖 Infracost Documentation](https://www.infracost.io/docs/)** - Cost estimation in CI/CD

### Phase 3: Exam Preparation (Weeks 6-7)

**Goal:** Practice, review, and fill knowledge gaps

1. **Practice Exams**
   - Take the official FinOps practice exam
   - Review all incorrect answers
   - Focus on automation-specific questions
   - Score 85%+ before scheduling the exam

2. **Scenario-Based Review**
   - Work through engineering scenarios
   - Practice designing cost data architectures
   - Review optimization automation patterns
   - Study multi-cloud engineering challenges

3. **Final Review**
   - Review all notes and fact sheets
   - Focus on high-weight domain (Rate and Usage Optimization at 30%)
   - Ensure comfort with all major APIs and tools
   - Review common exam patterns

**Resources:**
- **[📖 FinOps Stories](https://www.finops.org/stories/)** - Real-world implementations
- **[📖 FinOps Landscape](https://www.finops.org/landscape/)** - Tool ecosystem
- **[📖 FinOps Community](https://www.finops.org/community/)** - Community support

## Study Resources

### Official Resources
- **[📖 FinOps Certified Engineer Course](https://learn.finops.org/path/finops-certified-engineer)** - Official training
- **[📖 FinOps Framework](https://www.finops.org/framework/)** - Complete framework
- **[📖 FinOps Foundation YouTube](https://www.youtube.com/@FinOpsFoundation)** - Technical talks

### Technical Documentation
- **[📖 AWS Cost Management](https://docs.aws.amazon.com/cost-management/)** - AWS cost docs
- **[📖 Azure Cost Management](https://learn.microsoft.com/en-us/azure/cost-management-billing/)** - Azure cost docs
- **[📖 GCP Cloud Billing](https://cloud.google.com/billing/docs)** - GCP billing docs
- **[📖 Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)** - IaC reference

### Books and Courses
- "Cloud FinOps" by J.R. Storment and Mike Fuller (O'Reilly)
- FinOps Foundation self-paced engineer course
- A Cloud Guru FinOps courses
- Linux Foundation FinOps training

### Hands-on Practice
- Build a cost data pipeline using CUR and Athena
- Create tagging automation with Lambda and Config
- Implement resource scheduling
- Write Terraform modules with cost controls
- Set up Infracost in a CI/CD pipeline

## Exam Day Tactics

### Time Management
- 50 questions in 60 minutes = ~72 seconds per question
- Technical questions may take more time - budget accordingly
- Flag complex scenario questions and return to them
- Do not overthink - first instinct is often correct

### Question Strategy
1. **Identify the domain** - Is this data, optimization, automation, or governance?
2. **Look for the technical answer** - This is an engineering exam, not practitioner
3. **Consider automation first** - Automated solutions are preferred over manual
4. **Think multi-cloud** - Solutions should work across providers when possible
5. **Choose scalable solutions** - Prefer solutions that scale over one-off scripts

### Common Pitfalls

1. **Thinking like a practitioner** - This exam tests engineering implementation, not strategy
2. **Ignoring multi-cloud** - Know equivalent services across AWS, Azure, and GCP
3. **Choosing manual over automated** - Always prefer automation
4. **Not knowing API details** - CUR columns, API endpoints, and data formats matter
5. **Overlooking policy as code** - OPA and Sentinel are heavily tested
6. **Forgetting about data pipelines** - Know how billing data flows and is processed
7. **Ignoring Kubernetes costs** - Container cost allocation is an important topic
8. **Skipping spot engineering** - Know interruption handling and fleet management
9. **Not studying tagging automation** - Tag enforcement through automation is key
10. **Underestimating the governance domain** - 10% is still 5 questions that could determine pass/fail
