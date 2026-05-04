# FinOps Certified Practitioner - Practice Questions

25 scenario-based questions for FinOps Certified Practitioner prep.

> **Cert page:** [exams/finops/certified-practitioner/](../../exams/finops/certified-practitioner/)

---

### Question 1
**Scenario:** A company is in the **Crawl** phase of FinOps maturity. Which capability should they focus on first?

A. Optimize unit economics
B. Cost allocation, tagging, and basic visibility
C. Predictive cost modeling
D. Automated rightsizing

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Crawl = visibility and basic allocation. You can't optimize what you can't see. Tagging strategy + cost-and-usage data + per-team allocation are the Crawl foundations. Walk adds optimization recommendations; Run adds advanced unit economics and cultural maturity.
</details>

---

### Question 2
**Scenario:** What are the FinOps Foundation's three principal personas/roles?

A. Engineer / Manager / Executive
B. Engineering / Finance / Product/Business
C. CFO / CIO / CTO
D. DevOps / FinOps / SecOps

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** FinOps lives at the intersection of **Engineering, Finance, and Product/Business**. Engineers care about performance and reliability; Finance cares about budgets and forecasts; Product/Business cares about feature velocity and unit economics. The FinOps practitioner translates between them.
</details>

---

### Question 3
**Scenario:** A team's cloud bill spikes 40% month-over-month. What's the FIRST FinOps action?

A. Cancel all non-essential workloads
B. Investigate via Cost Explorer / per-tag drill-down to identify the source of the spike
C. Negotiate harder with the cloud provider
D. Ignore until next quarter

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** The first phase of any anomaly response is **inform** - identify what changed (which service, which team, which environment) before acting. Random cuts without diagnosis cause outages. Tagging hygiene makes this fast.
</details>

---

### Question 4
**Scenario:** Reserved Instances and Savings Plans share what core FinOps tradeoff?

A. They reduce on-demand cost in exchange for a commitment (1 or 3 years), trading flexibility for discount
B. They're free
C. They only apply to compute
D. They're identical

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Both are commitment-based discounts (up to ~72% off on-demand). Tradeoff: you pay even if you don't use them, so a wrong commitment = waste. Savings Plans are more flexible (compute or instance family); RIs are stricter (instance type+region).
</details>

---

### Question 5
**Scenario:** "Unit economics" in FinOps means what?

A. Total cost
B. Cost per unit of business value (e.g., $/customer, $/transaction, $/GB processed)
C. Per-team cost
D. Cost per VM

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Unit economics ties cloud spend to business outcomes - cost per active user, per order shipped, per GB processed. This lets product teams reason about whether to optimize (high cost per unit) or invest (low cost per unit, scaling well).
</details>

---

### Question 6
**Scenario:** What's the FOCUS specification?

A. A new cloud provider
B. The FinOps Foundation's open standard for cloud billing data so it's comparable across providers (FinOps Open Cost and Usage Specification)
C. A budgeting tool
D. A type of discount

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** FOCUS is an open spec from the FinOps Foundation defining a normalized format for cloud cost and usage data. Goal: make cross-cloud cost analysis tractable instead of every CSP having different schemas.
</details>

---

### Question 7
**Scenario:** A "showback" report tells engineering teams what they spent. A "chargeback" report does what differently?

A. Showback informs; chargeback bills the team's budget
B. They're identical
C. Chargeback is mandatory; showback is optional
D. Chargeback only applies to public cloud

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** **Showback** = visibility (here's what your team spent). **Chargeback** = financial accountability (the cost is debited to the team's actual budget). Chargeback creates stronger incentives for cost optimization but requires more org maturity.
</details>

---

### Question 8
**Scenario:** What's the appropriate metric for a FinOps team's success?

A. Total cloud spend (lower is always better)
B. Engineering NPS only
C. Unit cost trends + commitment utilization + budget variance + tag coverage
D. Number of cost optimization tickets closed

<details>
<summary>Answer</summary>

**Correct: C**

**Why:** Lower spend isn't always better - it might mean you're under-investing. Mature FinOps tracks: unit cost (improving over time as scale grows), commitment utilization (>80% target), budget variance (predictability), and tag coverage (visibility hygiene).
</details>

---

### Question 9
**Scenario:** An idle EBS volume costs $50/month. What FinOps phase does identifying it belong to?

A. Inform
B. Optimize
C. Operate
D. None - it's not FinOps

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** **Inform** is visibility (you know the volume exists and costs $50). **Optimize** is the action (delete it or right-size). **Operate** is the ongoing process (have a policy that auto-deletes idle volumes after N days).
</details>

---

### Question 10
**Scenario:** A team relies on Spot Instances for batch jobs. Spot can be interrupted with 2 minutes' notice. What's the right FinOps mindset?

A. Avoid Spot - it's risky
B. Use Spot for interruption-tolerant workloads; mix On-Demand for steady-state; the savings (up to 90%) outweigh the engineering cost when properly architected
C. Use only Spot to maximize savings
D. Spot is always cheaper than RIs

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Spot suits stateless, batch, fault-tolerant workloads. Mix matters: Spot for task nodes / batch, On-Demand or Reserved for core/control. The architecture work to handle interruptions is the cost; for the right workload it pays back many times over.
</details>

---

### Question 11
**Scenario:** Tag governance recommendations include:

A. Mandatory tags (cost-center, environment, owner, project) enforced at resource creation via policy
B. Optional tags only
C. One mandatory tag (cost-center)
D. No tagging policy needed

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Effective FinOps requires comprehensive tag coverage. Common mandatory tag set: `cost-center`, `environment` (prod/staging/dev), `owner` (team or person), `project` or `application`. Enforce via cloud-native policy (AWS Service Control Policies, Azure Policy, GCP Org Policy) or IaC linting.
</details>

---

### Question 12
**Scenario:** A new cloud workload is being designed. When in the lifecycle should FinOps engage?

A. After deployment, when costs become an issue
B. At the design phase - architecture choices (RI/SP commitments, instance family, region, storage class) lock in 70%+ of future costs
C. Quarterly
D. Only during budget season

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** FinOps best practice is "shift left" on cost - influence architecture decisions before deployment. Choices like serverless vs always-on, region selection, storage class, and instance family are hard to change later. Late-stage cost cleanup is expensive.
</details>

---

### Question 13
**Scenario:** A team chooses to use Reserved Instances (or Savings Plans) for 80% of their steady-state compute. What FinOps principle does this best illustrate?

A. Cost cutting
B. Rate optimization - lowering the unit price of resources you'd use anyway, distinct from usage optimization (using less)
C. Tagging
D. Showback

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** FinOps splits cost optimization into two levers: rate (unit price - RIs, SPs, volume discounts) and usage (consumption - rightsizing, autoscaling, decommissioning). Both must work in concert; over-committing on rate when usage is uncertain creates waste.
</details>

---

### Question 14
**Scenario:** A FinOps team is asked: "Should we go multi-cloud?" What's the FinOps-aligned response?

A. Always yes
B. Multi-cloud creates complexity (per-cloud commitment math, data egress costs, tooling proliferation) that often outweighs theoretical pricing benefits; evaluate it on business need (DR, regulatory, capability gaps), not on price arbitrage
C. Always no
D. Move all to AWS

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** "Multi-cloud for cost" rarely pencils out: data egress fees, divided commitment leverage, doubled engineering and FinOps tooling. Multi-cloud is justified by business reasons; FinOps' job is to surface true cost including the operational tax.
</details>

---

### Question 15
**Scenario:** A monthly business review shows engineering spent 15% over budget. What's the constructive FinOps response?

A. Penalize the team
B. Investigate the variance: was usage higher than forecast (legitimate growth), was rate optimization missed (commit gap), or was there waste (drift)? Each cause has different remediation
C. Cut the team's budget
D. Block all spending

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Variance analysis is a core FinOps capability. Drives "act decisively" with specific actions. Punishment culture kills the cooperation between engineering and finance that FinOps requires. The output: targeted action, not blanket restriction.
</details>

---

### Question 16
**Scenario:** Unit economics: a SaaS company tracks "cost per active user". Why is this more useful than total cloud spend?

A. Easier to calculate
B. It normalizes for growth - rising spend on a flat or declining cost-per-user is healthy growth; spend rising in lockstep with cost-per-user is a margin problem; this metric tells the business story
C. Smaller numbers
D. Required for compliance

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Unit economics tie cloud spend to value delivered. They reveal whether you're scaling efficiently (good) or just scaling (concerning). FinOps maturity peaks at unit-economics reporting integrated into business reviews.
</details>

---

### Question 17
**Scenario:** Which best describes "showback" vs "chargeback"?

A. They're identical
B. Showback reports per-team or per-product cost without invoicing; chargeback bills the cost back to the consuming team's budget. Both drive accountability; chargeback is a stronger forcing function but requires tagging maturity and political will
C. Chargeback is for vendors
D. Showback is post-billing

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Both surface accountability; chargeback enforces it. Most orgs start with showback (visibility) and graduate to chargeback once tagging coverage is high. Premature chargeback with poor tagging creates a fight, not a culture.
</details>

---

### Question 18
**Scenario:** A team's tagging coverage is 60%. What's the FinOps team's first move?

A. Mandate 100% retroactively
B. Identify the untagged spend by service and team, prioritize the high-cost untagged resources for tagging, automate tagging on resource creation (IaC defaults, AWS Tag Policies, Azure Policy), and gradually raise the floor with reporting
C. Ignore it
D. Block resource creation

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Tagging is iterative. Top-down mandates fail; the working approach is "make the easy path tagged" via defaults, then surface gaps via reports. 80%+ coverage is realistic in a quarter; 100% is rarely worth the cost.
</details>

---

### Question 19
**Scenario:** Which FinOps capability is most directly responsible for forecasting future cloud spend?

A. Rate optimization
B. Forecasting capability (in the FinOps Framework) - includes seasonality, growth modeling, commitment alignment, and variance analysis. Outputs: budgets, cash-flow projections, business-unit forecasts
C. Tagging
D. Anomaly detection

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Forecasting is its own FinOps capability. Modern tools blend historical usage trends with planned changes (deployments, retirements, new products) and confidence intervals. Anomaly detection looks backward; forecasting looks forward.
</details>

---

### Question 20
**Scenario:** A startup hits a sudden cost spike on day 12 of the month. What's the right FinOps response sequence?

A. Wait until end of month
B. Anomaly detection alerts → drill into the resource and account → identify root cause (deploy bug, leaked test workload, intentional growth) → remediate or notify the responsible team → document for future detection rule tuning
C. Cancel all instances
D. Block the AWS account

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Anomaly detection is mid-month's "fire alarm". The full loop is detect → investigate → act → learn. AWS Cost Anomaly Detection, Azure Cost Management alerts, GCP Recommender all support this pattern.
</details>

---

### Question 21
**Scenario:** A team uses spot/preemptible instances for batch ML training. Which best practice maximizes savings while managing reliability?

A. Spot for everything
B. Spot with checkpointing every N steps so a preemption resumes from the last checkpoint rather than restarting; combine with diversification across instance types and AZs to reduce simultaneous interruption risk
C. On-demand only
D. Reserved capacity

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Spot saves 60-90% but requires architectural readiness. Checkpointing makes interruption tolerable. Diversification (e.g., AWS Spot Instance Pools or Karpenter consolidation) reduces correlated reclaims. Critical workloads should not be spot-only.
</details>

---

### Question 22
**Scenario:** Which is the most common FinOps maturity progression?

A. Run → Walk → Crawl
B. Crawl → Walk → Run: visibility (tagging, reporting, allocation) → optimization (rightsizing, commitments) → operate (forecasting, unit economics, automation)
C. Random
D. Run skips Walk

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** FinOps Foundation framing: maturity advances along each capability. You can be Walk in Anomaly Management while Crawl in Forecasting. The framework lets teams identify which capability to mature next based on impact and readiness.
</details>

---

### Question 23
**Scenario:** Cloud egress costs - which strategy reduces them most reliably?

A. Compress everything once
B. Architectural: keep data and compute in the same region/AZ, leverage CloudFront/CDN for repeat egress, use private connectivity (Direct Connect, ExpressRoute, Interconnect) for steady high-volume egress to lower per-GB rates
C. Disable internet access
D. Move to a different cloud

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Egress is one of the hardest costs to optimize after the fact. The real lever is architecture - co-locate, cache, and use private connectivity. CloudFront/CDN egress to viewer is cheaper than direct cross-region. Direct Connect data transfer is significantly lower than internet egress at high volume.
</details>

---

### Question 24
**Scenario:** Which stakeholder group is most often missing from a stalled FinOps program?

A. Finance
B. Engineering - FinOps without engineers is reporting; with engineers it's optimization. Engagement requires aligned incentives, embedded metrics in team scorecards, and executive air cover, not just dashboards
C. Procurement
D. Vendors

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Most FinOps practices launch from finance. The hard work is bringing engineering to the table - and that requires showing them metrics they care about (per-feature cost, cost per request) and removing toil (automated rightsizing recommendations, IaC modules with sane defaults).
</details>

---

### Question 25
**Scenario:** A FinOps team is asked: "What's our cost of carbon?". Which capability does sustainability fall under?

A. It doesn't apply
B. Sustainability is an emerging FinOps capability - tracks emissions per cloud spend, factors in regional carbon intensity for workload placement, and ties into corporate ESG reporting; major cloud providers all publish carbon dashboards now
C. Same as anomaly detection
D. Manual estimates only

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** AWS Customer Carbon Footprint Tool, Microsoft Cloud for Sustainability, Google Cloud Carbon Footprint all expose Scope 2/3 emissions tied to cloud spend. FinOps Foundation has formally added sustainability as a capability. Workload placement (lower-carbon regions) is a real optimization lever.
</details>

---

## Scoring guide

- **22-25:** Strong; schedule the exam.
- **15-21:** Re-read FinOps Foundation framework + capability domains.
- **<15:** Read the FinOps for Engineers book and re-attempt.

FinOps Practitioner: ~50 multiple-choice questions, 60 minutes, 75% to pass. Concepts > implementation. Common pitfall: thinking FinOps = cost cutting (it's actually cost-aware decision-making and unit economics).
