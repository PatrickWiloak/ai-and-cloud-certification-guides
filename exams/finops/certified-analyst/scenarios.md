# FinOps Certified Analyst - Practice Scenarios

Ten applied scenarios with answers and rationale. Work through each one, write your own answer before reading the discussion.

## Scenario 1: The Tag Drift Crisis

A 600-engineer org mandated three tags (cost-center, app, env) a year ago. Today 34 percent of spend is untagged. A new CFO wants chargeback live in 90 days.

Question: What is the most effective first move?

Answer: Do not try to retag everything. Establish an allocation engine that uses the best available signal (account, subscription, project) to map to a cost center using a policy table, then progressively push tags upstream via IaC and service control policies. Show the CFO a trend of tag coverage and unallocated percent.

Why: Perfect tagging is a process, not a sprint. Allocation engines with fallback hierarchies are the standard pattern.

## Scenario 2: Surprise on the 3rd

On the 3rd of the month, a team sees a 40 percent cost spike vs a typical 3rd. Cost Explorer shows the spike concentrated in one account.

Question: What is the correct first analysis step?

Answer: Decompose the spike by ChargeCategory and ServiceName in FOCUS. Check whether it is Tax (often posts on month boundaries), Adjustment, RI/SP upfront amortization, or actual Usage. Spikes on the 1st-3rd are disproportionately billing events, not usage events.

## Scenario 3: The VP Who Wants a Number

A VP of Engineering asks "what is our cost per active user?" Your billing data is complete but there is no product analytics feed.

Question: What do you do?

Answer: Confirm the unit of business value with Product and Finance, then instrument the pipeline. Short term, use a monthly active users number from Product and divide allocated cloud cost by MAU. Document the caveats (shared cost allocation method, lag in product data). Start a roadmap to automate.

## Scenario 4: Commit Expiry Wave

60 percent of your AWS Savings Plans expire in 45 days. Current coverage is 78 percent and utilization is 96 percent.

Question: What is the most prudent action?

Answer: Run a commitment analysis against the last 90 days of stable usage, net of planned reductions. Renew at a coverage target slightly below the current stable floor (for example 70-72 percent) using a mix of 1-year SPs to preserve flexibility. Do not renew at full 78 percent if there are known migrations or reductions.

## Scenario 5: Data Egress Blow-up

Egress costs jumped 3x for one product team. Engineering says they did not change anything.

Question: How do you investigate?

Answer: Pivot FOCUS data on ServiceName and ChargeDescription filtered to DataTransfer. Compare source and destination regions. Common causes: new cross-region replication enabled, customer traffic moved to a new region, or a NAT gateway sitting in a different AZ from the traffic source. The "we did not change anything" often really means "we did not change anything we thought mattered."

## Scenario 6: Showback vs Chargeback

Leadership wants to hold teams accountable for cloud cost but Finance is not ready to actually move budget.

Question: What model do you propose?

Answer: Showback with named accountability. Publish clear, timely reports by team with trendlines and anomalies. Pair with goals (for example, cost per transaction reduction) tracked in performance reviews. Evolve to chargeback once allocation quality is above a threshold (for example 95 percent allocated) and Finance has a true-up process.

## Scenario 7: Forecast Drift

Your driver-based forecast has been 12 percent off for three months, always high.

Question: What is likely wrong?

Answer: Model is probably not reflecting new rate optimizations (a recent SP purchase, new negotiated EDP tier) or efficiency wins (rightsizing, graviton migration). Rebuild the unit rate inputs with the most recent 30 days of EffectiveCost, validate against invoice.

## Scenario 8: FOCUS Conversion Gap

Your third-party tool ingests FOCUS 1.0, but your vendor emits 1.1.

Question: How do you handle this without losing fidelity?

Answer: Map 1.1 columns back to 1.0 compatible where possible; for new columns (such as expanded CommitmentDiscount fields) preserve them in a separate staging table and reintroduce via a custom attribute in the tool. Do not silently drop columns. Document the mapping.

## Scenario 9: Anomaly Alert Storm

The anomaly detector sends 40 alerts a day. Engineers have started muting the channel.

Question: What do you change?

Answer: Tune by raising the minimum absolute dollar threshold (small percent swings on small services are noise), switch from mean-based to MAD-based statistics, and add suppression for known periodic events (monthly billing adjustments, scheduled batch jobs). Route by owner, not a firehose channel. Aim for less than five high-quality alerts per day.

## Scenario 10: The Kubernetes Black Hole

A single EKS cluster costs 80k per month and serves 12 teams. No per-team visibility exists.

Question: How do you allocate?

Answer: Deploy OpenCost or Kubecost to produce per-namespace cost based on resource requests and usage. Map namespaces to teams via labels. Allocate shared cluster overhead (control plane, logging, system namespaces) proportionally or by even split. Emit per-team data into your FOCUS warehouse as synthetic rows tagged appropriately.
