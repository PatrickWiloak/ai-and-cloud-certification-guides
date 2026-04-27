# FinOps Certified Practitioner - Practice Questions

12 scenario-based questions for FinOps Certified Practitioner prep.

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

## Scoring guide

- **10-12:** Strong; schedule the exam.
- **7-9:** Re-read FinOps Foundation framework + capability domains.
- **<7:** Read the FinOps for Engineers book and re-attempt.

FinOps Practitioner: ~50 multiple-choice questions, 60 minutes, 75% to pass. Concepts > implementation. Common pitfall: thinking FinOps = cost cutting (it's actually cost-aware decision-making and unit economics).
