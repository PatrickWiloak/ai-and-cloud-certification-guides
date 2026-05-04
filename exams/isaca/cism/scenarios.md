---
last-updated: 2026-05-03
---

# ISACA CISM - Exam Scenarios

> Six worked scenarios mirroring CISM question style. CISM is governance-heavy: it tests how a security manager thinks, not how a technician implements. Right answers usually emphasize *business alignment*, *risk-based decisions*, and *management responsibility*.

---

## Scenario 1 - Information security governance

A new CISO is told by the CEO to "make us secure." Which is the FIRST action?

**Options:** A. Define an information security strategy aligned to business objectives, ratified by senior leadership. B. Buy a SIEM. C. Run a penetration test. D. Hire more analysts.

**Analysis:** A is right - CISM emphasizes that strategy precedes tactics. Security must be aligned to business objectives. B / C / D are tactical actions before the strategy is set.

**Answer:** A

**Key takeaway:** CISM Domain 1: Information Security Governance. The first move is *always* strategy and alignment, not tools.

---

## Scenario 2 - Risk treatment

A risk assessment finds a critical vulnerability. The cost to fix is $500K; the expected loss is $50K. Which treatment fits?

**Options:** A. Accept the risk (with documented executive approval). B. Mitigate immediately because it's "critical." C. Transfer via insurance. D. Avoid by removing the system.

**Analysis:** A is right - cost of treatment exceeds expected loss; the rational risk treatment is *acceptance* with documented executive sign-off. CISM expects you to think in cost-benefit, not "fix everything labeled critical." B is the tempting wrong answer. C / D are options but more expensive than acceptance here.

**Answer:** A

**Key takeaway:** Risk treatment options: Accept, Mitigate, Transfer, Avoid. The right one is the cost-benefit analysis with senior management approval, not "always mitigate."

---

## Scenario 3 - Incident response priority

During an active ransomware incident, three actions are competing: notify regulators, restore systems, contain spread. Which is FIRST?

**Options:** A. Contain the spread to prevent further damage. B. Notify regulators per the breach notification clock. C. Restore systems from backup. D. Investigate root cause.

**Analysis:** A is right - in incident response, **containment precedes everything else**. NIST IR lifecycle: Prepare → Detect → Analyze → Contain → Eradicate → Recover → Lessons Learned. Containment is the first hands-on action after analysis. B has clock requirements but isn't first hands-on. C is later (Recover phase). D is later (Eradicate / Lessons Learned).

**Answer:** A

**Key takeaway:** IR sequence: Detect → Analyze → **Contain** → Eradicate → Recover → Lessons Learned. Containment is the first action after confirmed incident.

---

## Scenario 4 - Third-party risk

A SaaS vendor handling sensitive data has a breach. Which is the security manager's PRIMARY concern?

**Options:** A. Whether the vendor's controls met contractual obligations and what data of yours was exposed. B. Switching vendors immediately. C. Public statement. D. Reviewing your firewall rules.

**Analysis:** A is right - the security manager's role is to assess vendor accountability against contract and the impact on your data. B is reactive without analysis. C is communications, not the *security* manager's primary action. D is internal but the breach was external.

**Answer:** A

**Key takeaway:** Third-party risk = contract + data exposure assessment. Security manager owns the vendor risk program; not the firewall in this case.

---

## Scenario 5 - Security awareness

A phishing simulation shows 30% of staff click. Which response fits CISM mindset?

**Options:** A. Targeted training for repeat clickers + organization-wide awareness improvements + measure quarterly. B. Block all external email. C. Discipline clickers. D. Replace IT.

**Analysis:** A is right - measured, sustained awareness program with metrics. B is over-restrictive. C is anti-pattern (kills reporting culture). D is unrelated.

**Answer:** A

**Key takeaway:** Security awareness is a program, not an event. Measure, target, repeat. Punitive responses suppress incident reporting.

---

## Scenario 6 - Compliance vs security

Auditors find compliance gaps but the security team thinks the controls in place are adequate. Which is the security manager's response?

**Options:** A. Engage with auditors to understand the gap, document compensating controls if applicable, propose treatment plan to leadership. B. Argue with auditors. C. Fix all gaps regardless of business impact. D. Ignore audit findings.

**Analysis:** A is right - the manager bridges audit, business, and technical. Compensating controls + risk-based treatment plan is the sophisticated response. B is unprofessional. C is "fix everything" which CISM rejects. D is non-compliant.

**Answer:** A

**Key takeaway:** CISM expects mature engagement with audit/compliance; risk-based treatment, not check-the-box compliance.
