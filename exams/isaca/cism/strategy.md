---
last-updated: 2026-05-03
---

# ISACA CISM - Exam Strategy

## Format reminder

- 150 questions, 240 minutes (4 hours)
- Pass mark: 450 / 800 (scaled, ~70%)
- Multiple choice
- Four domains: Governance (17%), Risk Management (20%), Program Development (33%), Incident Management (30%)

## The CISM mindset

Most CISM failures are not due to lack of knowledge - they're due to thinking like a technician instead of a manager. CISM tests **how a security manager thinks**:

- Strategy precedes tactics
- Risk-based decisions, not fear-based
- Business alignment is non-negotiable
- Management buy-in is the prerequisite to anything
- Cost-benefit drives treatment selection
- Containment first in incidents
- Compensating controls are valid responses to compliance gaps
- Programs and metrics, not events

When you see two technically-valid options, pick the one that emphasizes management responsibility, business alignment, or risk-based reasoning.

## Top traps

1. **First, FIRST, BEST**: ISACA loves these qualifiers. Read the question for which one is asked. "First" usually means "before all else"; "best" means "most appropriate given the context"; "MOST important" means "highest priority."

2. **Tempting tactical answers**: "Buy a SIEM," "run a pen test," "block external email." These are the wrong answer when the question is asking about strategy / governance / risk.

3. **Containment first in IR**: when an incident is confirmed, containment is the first hands-on action. Not investigation, not communication.

4. **Risk treatment options**: Accept, Mitigate, Transfer, Avoid. CISM tests scenarios where Accept is correct (cost > impact) and the candidate must resist mitigating "because it's critical."

5. **Compensating controls**: when an exact control isn't feasible, an alternate control achieving similar risk reduction is acceptable.

6. **RTO vs RPO vs MTBF / MTTR**: BC/DR metrics are tested. Know each.

7. **Defense in depth vs single point of failure**: layered controls > one strong control.

8. **Three lines of defense model**: 1st = operational management, 2nd = risk/compliance, 3rd = internal audit. Don't confuse who does what.

9. **CIA Triad** + extensions (Authenticity, Non-repudiation, Privacy): map controls to which property they protect.

10. **Senior management vs the board**: senior management approves operational decisions; the board owns strategic governance and ultimate accountability. ISACA tests this distinction.

## High-yield topics easy to miss

- BIA (Business Impact Analysis) - identifies critical processes and acceptable downtime; precedes RTO/RPO setting
- BCP / DRP relationship: BCP is broader, DRP is the IT subset
- Information classification (Public / Internal / Confidential / Restricted) drives control selection
- Data lifecycle: Create → Store → Use → Share → Archive → Destroy. Controls vary by phase.
- Change management vs configuration management vs problem management (ITIL roots)
- Vendor risk lifecycle: due diligence → contract → ongoing monitoring → exit
- Cyber insurance basics
- KGI / KPI / KRI distinctions

## Time management

240 / 150 = 1.6 min/question. CISM has time pressure. Pace: Q50 by 80 min, Q100 by 160 min, Q150 by 230 min. Leave 10 min for review. Don't agonize over single questions; flag and move.

## When stuck

1. **Pick the answer that emphasizes business alignment or management responsibility** when in doubt.
2. **Eliminate tactical answers** when the question is strategic.
3. **First / FIRST / BEST** - read the qualifier carefully.
4. **Contain first** in IR questions.
5. **Cost-benefit decides risk treatment** - Accept can be the right answer.

## Day-of logistics

- 4 hours, 150 questions
- ISACA exams: Pearson VUE testing center; bring two government IDs
- One break allowed at the testing center; check the policy
- Score reported on screen; official within 10 days

## After

**Pass:** 5-year cycle with 120 CPE credits required (20/year minimum). Maintenance fee.

**Fail:** Score broken down by domain. Most failures are on Domain 3 (Program Development - 33%) or Domain 4 (Incident Management - 30%). Re-read the CISM Review Manual focusing on the *manager mindset* sections.

## CISM patterns

- "First action of new CISO" = strategy aligned to business
- "Cost > impact" = Accept the risk with executive sign-off
- "Active incident, first action" = Contain
- "Compliance gap" = Compensating controls + risk-based treatment plan
- "30% phish click" = Awareness program with metrics
- "Vendor breach" = Contract + data-exposure assessment
- "Conflicting priorities" = Risk-based decision with management buy-in
- "Block all email" / "punish users" = Always wrong
- "Buy a tool" = Usually wrong unless preceded by strategy
- "Best metric for X" = pick the one that's quantitative, business-relevant, repeatable
