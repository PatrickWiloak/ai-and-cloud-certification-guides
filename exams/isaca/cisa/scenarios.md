---
last-updated: 2026-05-03
---

# ISACA CISA - Exam Scenarios

> Six worked scenarios mirroring CISA question style. CISA is for IS auditors. Right answers emphasize *independence*, *evidence-based conclusions*, *audit standards (ISACA ITAF)*, and *risk-based audit planning*.

---

## Scenario 1 - Audit independence

An IS auditor is asked to design controls and then audit them. Which is the appropriate response?

**Options:** A. Decline; designing and auditing the same controls violates independence. Recommend a separate auditor for the design review. B. Do both; nobody else has the expertise. C. Do design only; skip audit. D. Outsource.

**Analysis:** A is right - independence is foundational. An auditor cannot audit work they performed (self-review threat). B / C / D either compromise independence or shirk the role.

**Answer:** A

**Key takeaway:** CISA threats to independence: self-review, self-interest, advocacy, familiarity, intimidation. Separating "do" from "audit" is non-negotiable.

---

## Scenario 2 - Audit evidence

An auditor is reviewing access controls. They observe the badge reader works. Which is the BEST evidence?

**Options:** A. System-generated logs of badge access events for the audit period, validated against HR records. B. Auditor's eyewitness observation. C. IT manager's verbal assurance. D. Vendor documentation of how the system works.

**Analysis:** A is right - reliability hierarchy: independent third-party + system-generated > auditor observation > management assertion > vendor documentation. System logs validated against HR are the most reliable.

**Answer:** A

**Key takeaway:** Audit evidence reliability: independent + corroborated + system-generated wins. Verbal assurance is the weakest.

---

## Scenario 3 - Sample size for testing

An auditor is testing 10,000 transactions for a control. What's the RIGHT approach?

**Options:** A. Risk-based statistical sample using attribute sampling; sample size determined by risk + tolerable deviation rate. B. Test all 10,000. C. Test the first 50. D. Test 10% (1,000).

**Analysis:** A is right - statistical sampling gives mathematical confidence; sample size is a function of confidence level, expected deviation rate, and tolerable deviation rate. B is impractical at scale. C is convenience sample (not statistical). D is judgmental, not risk-based.

**Answer:** A

**Key takeaway:** CISA prefers statistical sampling (attribute or variable) over judgmental. Sample size determined by parameters, not "10%."

---

## Scenario 4 - SoD violations

An auditor finds the same person can authorize purchases AND approve invoices for payment. Which is the FIRST recommendation?

**Options:** A. Implement SoD: separate the authorize and approve functions. If small org limits this, implement compensating controls (review by independent person). B. Trust the person. C. Implement only after a fraud occurs. D. Reduce purchase limits.

**Analysis:** A is right - SoD is the textbook control for this conflict. Compensating controls when full SoD isn't feasible. B is no control. C is reactive. D is partial.

**Answer:** A

**Key takeaway:** Segregation of Duties (SoD): authorize / record / custody / reconcile must be separated. Compensating controls (independent review) when full SoD impossible.

---

## Scenario 5 - Change management audit

The auditor reviewing change management finds emergency changes are made directly to production without normal approval. Which is the BEST control?

**Options:** A. Documented emergency change procedure with retroactive approval requirement (within 24-72 hours), full review at next CAB. B. Block all emergency changes. C. Allow without review. D. Punish anyone making emergency changes.

**Analysis:** A is right - emergency changes need a defined fast path with retroactive review. B is operationally impossible (real emergencies happen). C / D are anti-patterns.

**Answer:** A

**Key takeaway:** Emergency changes need a documented fast path with mandatory retroactive review.

---

## Scenario 6 - DR test results

A DR test fails to meet RTO. Which is the auditor's response?

**Options:** A. Document the gap, classify by risk severity, recommend remediation, follow up at next audit. B. Pass the audit because they tried. C. Fail the company. D. Help fix the issues during the audit.

**Analysis:** A is right - the auditor's job is to document, classify, recommend, follow up. B ignores findings. C is sensational. D violates independence (auditor doing the work creates self-review threat).

**Answer:** A

**Key takeaway:** Auditor reports findings with severity + recommendation, then follows up - doesn't fix.
