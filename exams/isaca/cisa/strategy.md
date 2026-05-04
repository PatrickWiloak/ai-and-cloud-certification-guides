---
last-updated: 2026-05-03
---

# ISACA CISA - Exam Strategy

## Format reminder

- 150 questions, 240 minutes (4 hours)
- Pass mark: 450 / 800 (~70%)
- Multiple choice
- Five domains: Information System Auditing Process (21%), Governance & Management of IT (17%), Information Systems Acquisition / Development / Implementation (12%), Information Systems Operations & Business Resilience (23%), Protection of Information Assets (27%)

## The CISA mindset

CISA tests **how an auditor thinks**:

- Independence is non-negotiable
- Evidence-based conclusions, not opinions
- Risk-based audit planning
- ISACA ITAF (IT Assurance Framework) standards
- Documentation of findings + classification + recommendation
- Auditor reports - doesn't fix

When you see options where one says "the auditor performs X" (i.e., does management's job), it's almost always wrong.

## Top traps

1. **Independence threats**: self-review (auditing your own work), self-interest, advocacy, familiarity, intimidation. The fix is structural separation.

2. **Evidence reliability hierarchy**: independent corroborated system-generated > internal corroborated > internal uncorroborated > management assertion. System logs > observation > interview.

3. **Statistical vs judgmental sampling**: CISA prefers statistical (attribute or variable) for objectivity. Judgmental is acceptable for non-statistical purposes.

4. **Inherent vs Residual vs Control vs Detection risk**: 
   - Inherent: risk before controls
   - Control: risk controls fail
   - Detection: risk audit misses
   - Residual: risk after controls (= inherent × control × detection)

5. **First / FIRST / BEST**: read carefully. ISACA loves these.

6. **SoD: 4 functions** (Authorize, Record, Custody, Reconcile) - separate or use compensating controls.

7. **Audit lifecycle**: Plan → Risk Assessment → Audit Program → Fieldwork (testing) → Findings → Reporting → Follow-up.

8. **Materiality**: aggregate impact + likelihood determines whether a finding is material. Auditors must articulate why.

9. **Compensating controls**: when an exact control isn't feasible, an alternate achieving similar risk reduction is acceptable.

10. **Reporting findings**: classify by risk (high / medium / low), document with evidence, recommend (don't dictate), follow up.

## High-yield topics easy to miss

- COBIT 2019 framework (governance + management practices)
- ITAF (ISACA's IT Assurance Framework)
- Continuous Auditing concepts (CAATs - Computer-Assisted Audit Techniques)
- BCP/DRP audit concerns (BIA, RTO, RPO, alternate site, test frequency)
- Application controls (input, processing, output) vs general IT controls (access, change management, ops)
- Database access controls (DBA SoD, audit logging)
- Encryption auditor concerns: key management, certificate lifecycle, algorithm strength

## Time management

240 / 150 = 1.6 min/question. Pace: half done by 120 min, 100 questions by 160 min.

## When stuck

1. **Pick the answer emphasizing independence + evidence**.
2. **Eliminate "auditor does management's job"** options.
3. **First / FIRST / BEST** - read carefully.
4. **Risk-based** wins over "everything-equal."

## Day-of logistics

4 hours, 150 questions. Pearson VUE.

## After

**Pass:** 5-year cycle, 120 CPE, maintenance fee.

**Fail:** Most failures are on Domain 4 (Operations - 23%) or Domain 5 (Protection - 27%).

## CISA patterns

- "Auditor designs and audits same control" = Decline (independence)
- "Best evidence" = Independent + system-generated + corroborated
- "Sample size" = Risk-based statistical
- "SoD violation" = Implement SoD or compensating controls
- "Emergency change" = Documented fast path with retroactive review
- "DR test fails" = Document, classify, recommend, follow up
- "Auditor's first action" = Plan + risk assessment
- "Material finding" = Risk-classified + evidenced + recommended
- "Continuous monitoring" = CAATs
- "Tester / preparer / approver" = SoD principles
