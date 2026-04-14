# FinOps Certified Analyst - 6 Week Practice Plan

This plan assumes 8-10 hours per week of focused study and lab work. Adjust if you already hold FOCP (compress to 4 weeks) or if FinOps is new to you (extend to 8 weeks).

## Week 1: Framework and Capabilities Refresh

Goals: ground yourself in the refreshed FinOps Framework and Capabilities model.

- Read FinOps Framework docs end to end
- Review the 2024-2025 Capabilities list and map each to a real task you have done or observed
- Read the latest State of FinOps report, note top-three pain areas
- Lab: draw an org chart for your team and annotate each person with their FinOps persona

Deliverable: a one-page map of all 16+ Capabilities to tools or processes in your org.

## Week 2: Billing Data and FOCUS

Goals: read billing data fluently.

- Export one month of AWS CUR 2.0, Azure cost details, or GCP billing export
- Convert to FOCUS 1.1 using a community converter or native export where available
- Load into DuckDB, BigQuery, or Snowflake
- Practice queries: total BilledCost by ServiceName, EffectiveCost by ResourceId, ChargeCategory breakdown
- Memorize FOCUS column families: Identifier, Time, Service, Pricing, Cost, Commitment, Resource, Tag, SKU

Deliverable: 10 SQL queries on FOCUS data answering business questions.

## Week 3: Allocation, Tagging, Shared Costs

Goals: build an allocation model.

- Design a tag policy with mandatory tags (cost center, environment, application, owner)
- Implement cost categories (AWS) or a tag-based allocation in Azure/GCP
- Build a shared-cost allocation rule (for example, split support cost proportionally to direct spend)
- Handle amortization: RI upfront fee, Savings Plan commit, Azure reservation
- Address untagged and untaggable spend

Deliverable: an allocation model spreadsheet or SQL view that assigns 100 percent of spend to a business unit.

## Week 4: Anomaly Detection and Reporting

Goals: make the data tell a story.

- Compute daily and weekly z-scores for top 20 services
- Build a simple threshold-plus-seasonality anomaly alert
- Construct plan-vs-actual variance by business unit
- Build three reports: executive dashboard, engineering dashboard, finance dashboard
- Practice writing an anomaly investigation narrative (what, when, who, impact, action)

Deliverable: three dashboards (or mockups) with distinct audiences.

## Week 5: Chargeback, Unit Economics, KPIs

Goals: translate cost into business language.

- Design a showback report; then evolve it into a chargeback
- Compute unit economics: cost per tenant, cost per transaction, cost per active user
- Calculate commitment coverage, commitment utilization, effective savings rate (ESR)
- Build a forecast: run-rate, seasonal, and driver-based
- Compute forecast accuracy on historical data

Deliverable: unit economics scorecard covering five KPIs with trend.

## Week 6: Tooling, Review, Mock Exams

Goals: finalize and test.

- Compare three third-party FinOps platforms against your requirements
- Review all six notes
- Take two full mock exams, time-boxed at 90 minutes
- Review incorrect answers in depth, re-read related notes
- Day before: light review, early sleep

Deliverable: pass a mock at 80 percent or above.

## Daily Cadence Suggestion

- 30 minutes reading or video
- 45 minutes hands-on lab or SQL
- 15 minutes flashcards (FOCUS columns, KPIs, personas)

## Lab Environment

- Free tier or sandbox account on at least one cloud
- DuckDB (free, local) for FOCUS querying
- A spreadsheet tool for allocation modeling
- Optional: Kubecost or OpenCost for container cost labs

## Red Flags That You Are Not Ready

- Cannot recite the FOCUS ChargeCategory values from memory
- Struggle to compute amortized cost from an RI purchase
- Cannot explain the difference between commitment coverage and commitment utilization
- Cannot name the six FinOps principles in your own words
- Have not done at least one end-to-end allocation exercise
