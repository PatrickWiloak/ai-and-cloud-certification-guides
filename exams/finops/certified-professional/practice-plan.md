# FinOps Certified Professional - 8 Week Practice Plan

This plan assumes 10-12 hours per week. Compress to 6 weeks if you have 3+ years FinOps leadership experience.

## Week 1: Framework Mastery

Goals: move from knowing the framework to being able to teach it.

- Re-read the FinOps Framework with attention to the Capabilities refresh
- Map every capability to a maturity level in an org you know well
- Read three case studies from the FinOps Foundation library
- Build a one-page "here is our FinOps program" deck for your real or imagined org

## Week 2: Rate Optimization Deep Dive

Goals: build commitment strategy confidence across clouds.

- AWS: understand SP vs RI decision tree, Convertible RIs, Compute SP flexibility
- Azure: Reservations, Savings Plan for Compute, MACC
- GCP: resource-based CUDs, spend-based CUDs, custom CUDs, flexible CUDs
- Build a commitment portfolio exercise: given one month of usage, propose a portfolio and justify trade-offs
- Calculate ESR before and after your proposed portfolio
- Read on autonomous commit platforms and when they win

Deliverable: a multi-cloud commitment strategy doc with coverage targets and rationale.

## Week 3: Workload and Architecture Optimization

Goals: know the moves that change the shape of the cost curve.

- Rightsizing: read provider docs (Compute Optimizer, Azure Advisor, Recommender)
- Storage: tiering policies for S3, Blob, GCS; intelligent tiering vs manual
- Compute: spot economics, ARM migration (Graviton), container density
- Data transfer: NAT vs endpoints, cross-AZ traps
- Case study: pick a workload and write a before/after architecture with cost math

Deliverable: a workload optimization playbook covering compute, storage, data transfer.

## Week 4: Multi-Cloud and FOCUS

Goals: be able to design a multi-cloud FinOps data pipeline.

- Master FOCUS 1.1 columns end to end
- Build (or describe) a pipeline: AWS CUR 2.0 + Azure export + GCP BigQuery export into FOCUS
- Design allocation that works across clouds with a common taxonomy
- Explore FOCUS use in Snowflake, BigQuery, and Databricks
- Read FOCUS working group meeting notes to understand open issues

Deliverable: pipeline architecture diagram + a working SQL example across two clouds.

## Week 5: Operating Models and Governance

Goals: be able to pick and defend an operating model.

- Centralized vs federated vs hybrid: when each wins
- Staffing ratios: how many FinOps per 100M cloud spend
- Policy as code: OPA, Cloud Custodian, native policy engines
- Enablement design: curriculum, badging, office hours
- Stakeholder management: executive, engineering leaders, finance

Deliverable: an operating model proposal for a hypothetical 500M cloud org.

## Week 6: Sustainability and GreenOps

Goals: add carbon to your cost vocabulary.

- Scope 1/2/3 fundamentals
- Cloud provider carbon reports: AWS CCFT, Azure Emissions Impact, GCP Carbon Footprint
- Software Carbon Intensity (SCI) spec
- Region selection trade-offs
- Efficiency as a cost-carbon co-benefit
- The FinOps Sustainability Capability

Deliverable: a GreenOps integration plan for your FinOps scorecard.

## Week 7: FinOps for AI/ML and Data

Goals: apply FinOps to the cost frontier.

- GPU economics: training vs inference, batch vs real-time
- LLM API pricing: per-token, context window, caching strategies
- Vector DBs and retrieval cost
- Snowflake and Databricks cost levers (warehouse sizing, auto-suspend, storage lifecycle)
- Model lifecycle governance and cost gating

Deliverable: an AI cost governance playbook including guardrails and reporting.

## Week 8: Review and Mocks

- Full re-read of notes
- Two timed mock exams at 120 minutes
- Deep review of incorrect answers
- Practice verbalizing trade-offs: pick five scenarios and talk through them out loud
- Light review day before exam

Deliverable: consistent mock scores above 80 percent.

## Daily Cadence Suggestion

- 40 minutes reading or deep material
- 40 minutes design or hands-on exercise
- 20 minutes scenario or flashcard practice

## Study Environment

- Subscriptions or sandbox accounts on AWS, Azure, GCP
- A warehouse (BigQuery, Snowflake trial, or DuckDB locally)
- A calendar to track mock exam scores

## Red Flags That You Are Not Ready

- Cannot design a commitment portfolio for a two-region AWS org from memory
- Cannot explain when federated beats centralized
- Do not know the SCI formula at a conceptual level
- Cannot name three distinct cost levers for an LLM production workload
- Mock exam scores below 70 percent
