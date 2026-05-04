---
last-updated: 2026-05-03
---

# GCP Professional Cloud DevOps Engineer (PDOE) - Exam Scenarios

> Six worked scenarios mirroring PDOE question style. PDOE tests SRE practices on GCP: CI/CD, observability, incident response, and reliability engineering.

---

## Scenario 1 - SLO definition and burn rate alerting

A team needs to define an SLO for an API at 99.9% availability and alert on fast and slow burn rates so they catch incidents early.

**Options:** A. Service Monitoring (in Cloud Operations) with SLO of 99.9%; multi-burn-rate alerts (1h fast burn, 6h slow burn). B. Static threshold alert on 5xx > 1%. C. Daily report on availability. D. Manual review.

**Analysis:** A is right - Service Monitoring is the GCP-native SLO tool. Multi-burn-rate alerting (Google's recommended pattern from the SRE workbook) catches both sudden outages and slow degradation. B alerts on a metric, not a budget. C is reactive. D doesn't scale.

**Answer:** A

**Key takeaway:** SRE on GCP = Service Monitoring SLOs + multi-burn-rate alerts. Memorize the Google SRE Workbook framework.

---

## Scenario 2 - Canary deployment with auto-rollback

A team deploys to GKE; needs canary at 10% for 10 min with auto-rollback on error rate.

**Options:** A. Cloud Deploy with progressive delivery + verify pipeline running rollout health checks. B. Manual kubectl apply. C. Cloud Build only. D. Helm without progressive delivery.

**Analysis:** A is right - Cloud Deploy is the GCP managed CD service with progressive delivery, canary, and verification stages. B is manual. C is build, not deploy. D - Helm doesn't natively progressive-deploy.

**Answer:** A

**Key takeaway:** GCP CD: Cloud Deploy (managed, progressive). Cloud Build (build artifacts, can do simple deploys). Argo CD / Flux for GitOps.

---

## Scenario 3 - Observability stack

A platform team wants metrics, logs, traces, and profiles in one place with alerting.

**Options:** A. Cloud Operations Suite: Cloud Monitoring (metrics + alerts), Cloud Logging (logs), Cloud Trace (traces), Cloud Profiler (continuous profiling), Error Reporting (exception aggregation). B. Three separate tools. C. Custom Prometheus + Grafana on GKE. D. Cloud Logging only.

**Analysis:** A is right - Cloud Operations Suite is the GCP-native unified stack. B fragments. C works (and is sometimes preferred for portability) but isn't the GCP-managed answer. D is one-pillar only.

**Answer:** A

**Key takeaway:** GCP observability = Cloud Operations Suite. Self-managed Prometheus + Grafana is fine for portability/multi-cloud but PDOE expects the managed answer.

---

## Scenario 4 - Postmortem and incident management

After a P1 outage, the team needs a structured postmortem process: timeline, root cause, action items, blameless culture.

**Options:** A. Document postmortem in shared docs using Google's blameless template; track action items in tickets; review at weekly engineering meeting. B. Email summary. C. Skip postmortem since it's too time-consuming. D. Punish the responsible engineer.

**Analysis:** A is right - Google SRE blameless postmortems are the cultural standard. B is partial. C / D are anti-patterns.

**Answer:** A

**Key takeaway:** PDOE tests SRE culture, including blameless postmortems, error budgets, and toil reduction. Read Google's SRE book.

---

## Scenario 5 - Toil reduction

A team spends 60% of their week on repetitive operational tasks. SRE practice says to limit toil to 50%.

**Options:** A. Identify the top 3 toil sources; automate the highest-frequency one first; track toil hours weekly. B. Hire more engineers. C. Accept it. D. Move to a different team.

**Analysis:** A is right - the SRE answer to toil is automation, prioritized by frequency × time. Track it as a metric.

**Answer:** A

**Key takeaway:** SRE toil definition: manual, repetitive, automatable, tactical, no enduring value. Cap toil at 50% of an SRE's time; automate the rest.

---

## Scenario 6 - Reliability budgets

The team's API has a 99.9% SLO, meaning ~43 minutes of downtime per month. This month they've already used 30 min. The product wants to push a risky deploy.

**Options:** A. Use the error-budget framework: with 13 min of budget left, freeze risky deploys until next month or until budget recovers. B. Push the deploy anyway. C. Lower the SLO. D. Block all deploys forever.

**Analysis:** A is right - error budget governs risk-taking. When budget is high, deploy aggressively. When low, freeze risky changes. This is the core SRE/product agreement. B violates the SLO. C is moving the goalposts. D is over-restrictive.

**Answer:** A

**Key takeaway:** Error budget = (1 - SLO) × time. Use it to govern release velocity. Drives the SRE↔product partnership.
