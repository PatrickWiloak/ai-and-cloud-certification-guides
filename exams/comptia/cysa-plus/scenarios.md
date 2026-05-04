---
last-updated: 2026-05-03
---

# CompTIA CySA+ - Exam Scenarios

> Six worked scenarios mirroring CySA+ question style. CySA+ is intermediate cybersecurity analyst - vendor-neutral, with focus on threat detection, vulnerability management, incident response, and security operations.

---

## Scenario 1 - Triage of suspicious traffic

A SIEM alert shows beaconing from an internal host to a known C2 IP every 10 minutes. Which is the analyst's FIRST action?

**Options:** A. Verify the alert is true positive (check threat intel feed for the IP, review related logs); if confirmed, contain by isolating the host. B. Block the IP at the firewall and close the ticket. C. Reimage the host immediately. D. Notify the user.

**Analysis:** A is right - verify before action; then contain. Containment > eradication > recovery is the IR sequence. B closes too early. C jumps past containment. D may tip off the threat actor.

**Answer:** A

**Key takeaway:** Triage = verify (true positive?) → contain → investigate → eradicate → recover. Don't skip verification.

---

## Scenario 2 - Vulnerability prioritization

A scanner reports 1,500 vulnerabilities. Which prioritization fits?

**Options:** A. Score by CVSS + exploitability (active in-the-wild exploits) + asset value; remediate critical+high on internet-facing assets first, then internal critical. B. Patch oldest CVE first. C. Patch alphabetical. D. Wait for the next quarterly cycle.

**Analysis:** A is right - risk-based prioritization combining severity (CVSS), exploitability (KEV catalog, EPSS), and asset criticality. CISA Known Exploited Vulnerabilities (KEV) and EPSS score are the modern signals. B / C aren't risk-based. D is too slow.

**Answer:** A

**Key takeaway:** Vuln prioritization = CVSS × exploitability × asset value. Use KEV catalog and EPSS in addition to CVSS.

---

## Scenario 3 - SIEM use case design

The SOC wants alerts on lateral movement attempts. Which detections fit?

**Options:** A. Correlation rules: multiple failed logons followed by success on a different host (account abuse), unusual SMB / WinRM / RDP from non-admin sources, new admin tool execution (psexec, wmic). B. Single rule on bad password attempts. C. Network scan alerts only. D. Daily reports.

**Analysis:** A is right - lateral movement = post-foothold; the indicators are credential reuse across hosts, admin tool spawn, atypical SMB / RDP / WinRM patterns. Combine signals via correlation. B is single signal. C is initial recon, not lateral. D is reactive.

**Answer:** A

**Key takeaway:** Detection engineering: chain signals via correlation. Lateral movement = post-foothold IOC patterns (suspicious admin protocols + credential reuse + uncommon binaries).

---

## Scenario 4 - Threat hunting

The team wants to proactively hunt for evidence of compromise without specific alerts.

**Options:** A. Hypothesis-driven hunting: form hypothesis ("attackers using SMB lateral movement"), query EDR + Sysmon + network logs for evidence, document findings, refine hypothesis. B. Wait for SIEM alerts. C. Run a vulnerability scan. D. Hire pentester.

**Analysis:** A is right - threat hunting is hypothesis-driven, not reactive. Use frameworks like MITRE ATT&CK to generate hypotheses. B is reactive (SIEM-only). C is vuln, not threat. D is offensive, not defensive hunting.

**Answer:** A

**Key takeaway:** Threat hunting = hypothesis (often from MITRE ATT&CK) → query telemetry → analyze → document. Distinct from detection (which is rule-driven).

---

## Scenario 5 - Threat intel integration

The team wants to enrich SIEM alerts with threat intel and block known bad indicators automatically.

**Options:** A. Subscribe to threat intel feeds (open + commercial); ingest into TIP (Threat Intelligence Platform); enrich SIEM alerts; auto-push high-confidence IOCs to firewall / DNS sinkhole. B. Just block manually as you see things. C. Buy more feeds. D. Trust antivirus.

**Analysis:** A is right - TIP normalizes feeds, deduplicates, scores confidence; integrates with SIEM for enrichment and with security controls for automated blocking. B doesn't scale. C is "buying more" without integration. D is one signal.

**Answer:** A

**Key takeaway:** Threat intel pipeline = feeds → TIP (normalize, dedupe, score) → enrich SIEM + push to controls. Confidence scoring matters.

---

## Scenario 6 - Incident communication

During a confirmed incident, the comms team wants public statement immediately. The technical team is still investigating. Which is the right approach?

**Options:** A. Hold the public statement until facts are confirmed; communicate internally; share confirmed-only facts with comms team for any required external statement. B. Issue immediate public statement with current best guess. C. No communication. D. Let comms decide.

**Analysis:** A is right - avoid speculation in public; share confirmed facts only; mind regulatory clocks (GDPR 72h notification etc.) but base the statement on confirmed scope. B leads to retractions and reputation damage. C may violate disclosure obligations. D abdicates.

**Answer:** A

**Key takeaway:** IR communication: confirmed facts only, internal first, regulatory clocks honored, public statements pre-vetted by legal + technical.
