# FinOps Certified Professional - Strategic Scenarios

Ten design and leadership scenarios. Work through each one fully; these mirror the open-ended style of FOCP-Pro.

## Scenario 1: The Multi-Cloud Commitment Rebalance

A SaaS company spends 180M across AWS (60 percent), Azure (25 percent), GCP (15 percent). Current ESR is 18 percent. Engineering is planning a 12-month migration of 20 percent AWS workloads to GCP.

Question: What commitment strategy do you propose for the next 12 months?

Answer: Do not renew full AWS coverage at 3-year terms. Shift AWS commits to 1-year Compute SPs to preserve flexibility. Grow GCP flexible CUDs as usage migrates, confirmed with monthly checkpoints. Keep Azure steady. Target ESR 22-24 percent at lower risk. Document assumptions and revisit quarterly.

## Scenario 2: The Federated Operating Model Push

A 2000-engineer org has a 10-person central FinOps team. Cost is growing 40 percent year over year while revenue grows 25 percent. Leadership wants to accelerate optimization.

Question: Do you grow the central team, or federate?

Answer: Federate, with the central team shifting from execution to enablement. Embed cost champions in each BU (1 per 50-100 engineers, part-time). Central team owns data platform, standards, commit portfolio, executive reporting. BUs own rightsizing, architecture, anomaly response. Track the cost-to-revenue ratio as the leading KPI.

## Scenario 3: The GPU Cost Blowout

A 30M GenAI product launched last quarter. Inference GPU cost is running at 2.1M per month. Model is a 70B-parameter LLM on on-demand H100s.

Question: Name four levers in priority order.

Answer:
1. Enable prompt/prefix caching and response caching (often 30-60 percent reduction)
2. Quantize and/or distill to a smaller model where quality permits
3. Move eligible traffic to batch APIs or off-peak capacity
4. Negotiate capacity-reserved pricing or consider Trainium/Inferentia alternatives for eligible workloads

Only after these, consider commitments.

## Scenario 4: Chargeback Readiness Assessment

A CFO wants full chargeback by next fiscal year. Current allocation coverage is 82 percent, tag coverage 74 percent, no dispute process, one-month reporting lag.

Question: Go or no-go?

Answer: No-go for next fiscal year as full chargeback. Counter-propose: showback with named accountability now, hybrid chargeback (production only, central absorbs shared services) next fiscal year, full chargeback the year after. Deliver a readiness plan with milestones: allocation to 95 percent, tag to 90 percent, dispute process live, reporting lag to 5 days.

## Scenario 5: Sustainability Pressure

A sustainability team asks FinOps to track emissions alongside cost for monthly leadership reporting. Your current scorecard is cost-only.

Question: How do you integrate?

Answer: Ingest provider carbon reports (AWS CCFT monthly, Azure Emissions monthly, GCP Carbon Footprint monthly). Add three KPIs: total tCO2e, carbon intensity (tCO2e per unit of business value), and regional mix. Frame efficiency wins as cost and carbon co-benefits. Do not conflate offsets with reductions.

## Scenario 6: The Snowflake Surprise

Snowflake spend doubled in six months with no revenue change. You suspect inefficiency but do not own the platform.

Question: What is your investigation plan?

Answer: Partner with the Snowflake admin. Pull query history. Rank by credits burned. Check warehouse sizing vs concurrency, auto-suspend latency, materialized views, dbt job scheduling, and storage lifecycle. Likely culprits: oversized warehouses, missed auto-suspend tuning, redundant transformations, runaway queries. Propose guardrails (resource monitors, query timeouts) and a design review cadence.

## Scenario 7: The Spot Risk Debate

Engineering proposes moving 60 percent of a stateless web tier to spot. Reliability is worried about interruption.

Question: What is the defensible position?

Answer: Yes to spot for stateless, horizontally scalable tiers, with guardrails: diversified instance pool, capacity rebalancing, on-demand fallback, graceful drain hooks. Start at 40 percent spot with SLO monitoring. Expand to 60 percent after two months of clean data. Document the on-demand base as the availability contract.

## Scenario 8: Commitment Pool Ownership

Engineering BUs want to own their own commitments. Finance wants a central pool.

Question: Which wins and why?

Answer: Central pool wins for most orgs. Rationale: commit risk is diversified across workloads (unused in one BU offsets under-covered in another), volume discounts are better, and rebalancing is easier. Charge BUs at EffectiveCost. BUs still have incentive to be efficient; central absorbs commit risk.

## Scenario 9: FOCUS Adoption Decision

Your current reporting is built on per-cloud schemas. A new third-party tool emits FOCUS. Migration cost is 3 months of engineering.

Question: Do you migrate?

Answer: Yes, but incrementally. Start with new dashboards on FOCUS while keeping legacy views. Phase deprecation over 6 months. FOCUS pays off in multi-cloud reporting, vendor portability, and future-proofing. Sunk cost in legacy schemas is not an argument against strategic alignment.

## Scenario 10: AI Governance Gap

Five teams are building GenAI prototypes. None have cost caps. One team accidentally ran up 140K in three days.

Question: What policy do you put in place this week?

Answer: Three guardrails: (1) budget alerts per API key at daily and monthly thresholds; (2) per-key rate limits and per-call token caps; (3) mandatory cost review before production promotion. Require tagging of GenAI workloads. Educate via office hours within two weeks. Do not try to block experimentation; govern it.
