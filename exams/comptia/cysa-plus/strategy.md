---
last-updated: 2026-05-03
---

# CompTIA CySA+ - Exam Strategy

## Format reminder

- Up to 85 questions, 165 minutes
- Pass mark: 750 / 900 (~83%)
- Multiple choice + Performance-Based Questions (PBQs - drag-and-drop, lab simulations)
- 4 domains: Security Operations (33%), Vulnerability Management (30%), Incident Response & Management (20%), Reporting & Communication (17%)

## Top traps

1. **CompTIA-style "BEST" answers**: when multiple options are technically valid, CompTIA wants the answer matching the *intended methodology* (NIST IR lifecycle, hypothesis-driven hunting, risk-based prioritization).

2. **CVSS + KEV + EPSS**: vulnerability scoring isn't just CVSS anymore. KEV (CISA Known Exploited Vulnerabilities) tells you what's actively exploited. EPSS (Exploit Prediction Scoring System) gives probability. Modern prioritization combines all three with asset value.

3. **MITRE ATT&CK framework**: tactics (TA), techniques (T), sub-techniques. Memorize key tactics: Reconnaissance, Resource Development, Initial Access, Execution, Persistence, Privilege Escalation, Defense Evasion, Credential Access, Discovery, Lateral Movement, Collection, C2, Exfiltration, Impact.

4. **NIST IR lifecycle**: Preparation → Detection & Analysis → Containment → Eradication → Recovery → Post-Incident Activity (Lessons Learned). Don't skip steps.

5. **TIP (Threat Intelligence Platform)** vs SIEM vs SOAR vs EDR vs XDR:
   - SIEM: log aggregation + correlation (Splunk, Sentinel, QRadar)
   - SOAR: automation + playbooks (Phantom, XSOAR)
   - EDR: endpoint detection + response
   - XDR: SIEM + EDR + NDR + identity, vendor-integrated
   - TIP: threat intel aggregation, normalization, sharing

6. **STIX / TAXII**: STIX is the standard data format for threat intel; TAXII is the protocol for exchange.

7. **Vulnerability scanning types**: authenticated (with creds) vs unauthenticated; agent-based vs network-based. Authenticated finds more.

8. **Network analysis tools**: tcpdump, Wireshark, Zeek (Bro), Suricata. Know what each is for.

9. **Endpoint analysis**: Sysmon, OSQuery, EDR agent telemetry. Common indicators.

10. **Compliance frameworks**: GDPR, HIPAA, PCI DSS, SOX, NIST CSF, ISO 27001 - know the basic scope of each.

## High-yield topics easy to miss

- Pyramid of Pain (Bianco): hash → IP → domain → network/host artifact → tool → TTP. Higher = more painful for the attacker if you detect/block.
- Diamond Model of Intrusion Analysis: adversary, capability, infrastructure, victim
- Cyber Kill Chain: Recon → Weaponization → Delivery → Exploitation → Installation → C2 → Actions on Objectives
- Incident severity classification (P1-P4)
- Forensic chain of custody
- Memory forensics tools (Volatility, Rekall)
- Disk forensics (Autopsy, FTK Imager)
- SBOM (Software Bill of Materials) for supply chain
- DevSecOps shift-left (SAST, DAST, IAST, SCA)

## Time management

165 / 85 = 1.9 min/question. PBQs take 5-10 min each (typically 4-6 PBQs). Pace: half done by 80 min.

## When stuck

1. **Choose the methodology answer** (NIST IR, MITRE ATT&CK, hypothesis-driven hunting).
2. **Default to verify-then-act** in IR scenarios.
3. **Risk-based** wins over "most severe" for prioritization.

## Day-of logistics

165 min, ~85 questions. Pearson VUE. Bring two IDs. Online proctored available with PearsonVUE OnVUE.

## After

**Pass:** Cert valid 3 years. Renew via CEUs, higher cert, or other CompTIA renewal options.

**Fail:** Most failures are on Domain 1 (Security Operations - 33%). Re-review SIEM use cases, threat hunting methodology, MITRE ATT&CK.

## CySA+ patterns

- "Triage SIEM alert" = Verify true positive → contain
- "Vuln prioritization" = CVSS + KEV + EPSS + asset value
- "Lateral movement detection" = Correlation across credential reuse + admin tool exec + atypical SMB/RDP
- "Threat hunting" = Hypothesis-driven via MITRE ATT&CK
- "Threat intel" = Feeds → TIP → SIEM enrichment + auto-block
- "IR communication" = Confirmed facts only, internal first
- "Memory forensics" = Volatility
- "Network analysis" = Wireshark / Zeek / Suricata
- "Endpoint forensics" = Sysmon / EDR
- "Threat actor profile" = MITRE ATT&CK group + Diamond Model
