# 03 - Security, Compliance, Privacy, Trust

This is one of the heaviest-weighted domains (25-30%). Memorize the Defender / Purview / Compliance product names cold.

---

## Microsoft Defender (XDR)

Defender is Microsoft's umbrella security brand. Multiple products, unified in **Defender XDR** portal (security.microsoft.com).

### Defender for Office 365

- **Plan 1** - Safe Attachments, Safe Links, anti-phishing, anti-malware
- **Plan 2** - Plan 1 + Threat Explorer, Attack Simulator, automated investigation/response

Included in: M365 E5; add-on for E3.

### Defender for Endpoint

EDR (Endpoint Detection and Response) for Windows, macOS, Linux, iOS, Android.

- **Plan 1** - basic protection (EPP)
- **Plan 2** - full EDR + threat hunting + automated investigation

Included in: M365 E5; add-on for E3.

### Defender for Identity

(Formerly Azure ATP.) Detects threats in on-prem Active Directory by analyzing AD logs/traffic.

Use case: detect lateral movement, golden ticket attacks, reconnaissance.

### Defender for Cloud Apps

CASB (Cloud Access Security Broker). Discovers shadow IT, controls SaaS app usage, enforces policies on third-party SaaS (Salesforce, Box, Dropbox, etc.).

### Defender for Cloud

(Different product - Azure-side; covered more in AZ-104/AZ-500.) Posture management + threat protection for Azure resources.

### Defender XDR (the portal)

Unified portal correlating signals across Defender for Office / Endpoint / Identity / Cloud Apps. Single incident view, automated investigation/response across products.

---

## Microsoft Sentinel

Cloud-native SIEM + SOAR.

- Ingests logs from M365, Azure, AWS, GCP, third-party (1,200+ connectors)
- Hunting queries (KQL)
- Workbooks (dashboards)
- Playbooks (automation via Logic Apps)
- ML-based detections + analytics rules

Sentinel is **Azure-side** (in Azure portal, billed per GB ingested) but commonly bundled with M365 E5 conversations.

---

## Microsoft Purview (Compliance)

Microsoft's compliance umbrella. Don't confuse with Microsoft Purview (data governance) - these were unified branding-wise but cover different scopes.

### Information Protection

- **Sensitivity labels** - tag content as Public, Internal, Confidential, Highly Confidential, etc.
- **Auto-labeling** - automatically apply labels based on content patterns (regex, keywords, ML)
- **Encryption** - labels can enforce encryption (AIP encryption)
- **Watermarking + headers/footers**

### Data Loss Prevention (DLP)

Prevent sensitive data from leaving the org.

- Built-in classifiers for SSN, credit cards, GDPR data, etc.
- Custom classifiers for org-specific data
- Apply across Exchange, SharePoint, OneDrive, Teams, Endpoints, third-party SaaS (via Defender for Cloud Apps)
- Block actions, warn users, audit, generate alerts

### Records Management

- **Retention labels and policies** - keep content for X years; or delete after Y years
- **Records management** - declarative records (immutable, can't be modified/deleted)
- **Disposition review** - human review before deletion

### Communication Compliance

Monitor email/chat/Teams for:

- Harassment / bullying
- Sensitive IP (e.g., source code in chat)
- Insider trading patterns
- HIPAA violations

Alerts go to designated reviewers for action.

### Insider Risk Management

Detect risky user behavior:

- Departing employees exfiltrating data
- Risky browsing (printing many sensitive files, mass downloads)
- Privacy-respecting (anonymized initial signals; reviewer escalation requires approval)

### eDiscovery

Two tiers:

- **eDiscovery (Standard)** - search content across M365, hold mailboxes/sites
- **eDiscovery (Premium)** - advanced workflow, custodian management, in-place review, predictive coding

Used for legal cases, internal investigations.

### Audit

All M365 user/admin actions logged. Search across audit log via Microsoft Purview portal.

- **Audit (Standard)** - 90-180 days retention
- **Audit (Premium)** - 1-year+ retention, more event types, longer retention with add-on

### Compliance Manager

Score-based compliance posture tracker.

- Pre-built **assessments** for regulations (GDPR, HIPAA, ISO 27001, FedRAMP, NIST, CMMC, etc.)
- Maps your tenant config against required controls
- Generates a compliance score with improvement actions

---

## Privacy and Trust

### Microsoft Trust Center

[microsoft.com/trust-center](https://www.microsoft.com/trust-center) - public portal with Microsoft's commitments on:

- Security
- Privacy
- Compliance
- Transparency

### Service Trust Portal

[servicetrust.microsoft.com](https://servicetrust.microsoft.com) - **download audit reports** (SOC 1/2/3, ISO 27001, FedRAMP, HIPAA BAA, etc.) for your customers and auditors.

### Microsoft compliance offerings

100+ compliance certifications:

- **SOC 1, 2, 3** - audit reports for service organizations
- **ISO 27001/27017/27018** - international security standards
- **FedRAMP High / Moderate** - US federal government
- **HIPAA BAA** - healthcare; Microsoft signs BAAs with covered entities
- **GDPR** - EU privacy regulation
- **CCPA** - California consumer privacy
- **C5** - German cloud security
- **IRAP** - Australian government
- **CJIS** - US criminal justice
- Industry-specific: PCI DSS, HITRUST, FISC, etc.

### Privacy commitments

- **Customer data is yours** - Microsoft doesn't use M365 customer data to train AI or for advertising
- **Data residency** - choose where data is stored
- **Regulator audit access** - subject to legal restrictions, customers can audit

---

## Zero Trust

Microsoft's three principles:

1. **Verify explicitly** - always authenticate and authorize based on all available signals (identity, location, device, app, real-time risk)
2. **Use least privilege access** - JIT access, JEA (just-enough-access), risk-based adaptive policies
3. **Assume breach** - segment access, encrypt end-to-end, telemetry-driven detection, automated response

### Zero Trust pillars

| Pillar | M365/Azure tools |
|---|---|
| **Identity** | Entra ID, Conditional Access, Privileged Identity Management |
| **Endpoints** | Intune, Defender for Endpoint |
| **Apps** | Defender for Cloud Apps, Conditional Access |
| **Data** | Purview Information Protection, DLP |
| **Infrastructure** | Defender for Cloud, Sentinel |
| **Network** | Microsoft Entra Internet Access, Entra Private Access |

---

## Conditional Access (CA)

Policy engine in Entra ID. Enforces adaptive sign-in requirements.

### Building blocks

- **Assignments** - who/what (users, groups, apps, conditions like location, device state, risk)
- **Access controls** - block, require MFA, require compliant device, require app protection policy, require terms of use

### Common policies

- "Require MFA for all users"
- "Block sign-in from non-corporate locations"
- "Require compliant device for accessing financial apps"
- "Block legacy authentication protocols"
- "Require a registered device for risky users"

### Microsoft-managed CA policies

Microsoft introduced **Microsoft-managed Conditional Access policies** that auto-deploy baseline protection (e.g., MFA for admins) - opt-out rather than opt-in.

---

## Multi-Factor Authentication (MFA)

Always-on MFA strongly recommended for all users.

### Methods

- **Microsoft Authenticator app** - push notifications + number matching (preferred)
- **FIDO2 security keys** - hardware tokens (YubiKey, etc.)
- **Windows Hello for Business** - biometric / PIN on Windows
- **SMS / phone call** - legacy, weaker (vulnerable to SIM swap)
- **OATH tokens** - third-party authenticator apps

### Microsoft Authenticator features

- Passwordless sign-in (just app approval, no password)
- Number matching (prevents accidental approval)
- Phishing-resistant FIDO2 keys integration

---

## Privileged Identity Management (PIM)

Just-in-time access for privileged roles (Global Admin, Exchange Admin, etc.).

- Eligible vs Active assignment
- Approval workflow
- Time-bound (e.g., 4-hour activation)
- Audit logs
- Access reviews

Critical for limiting blast radius of admin accounts.

---

## Common exam triggers

- "Email anti-phishing + Safe Links + Safe Attachments" → Defender for Office 365
- "Endpoint EDR" → Defender for Endpoint
- "On-prem AD threat detection" → Defender for Identity
- "Shadow IT discovery" → Defender for Cloud Apps
- "Unified threat portal" → Defender XDR
- "Cloud SIEM" → Microsoft Sentinel
- "Detect departing employee exfiltrating data" → Insider Risk Management (Purview)
- "Tag documents Confidential and prevent external sharing" → Sensitivity labels + DLP
- "Enforce MFA only when sign-in is risky" → Conditional Access with sign-in risk condition
- "Just-in-time admin role activation with approval" → Privileged Identity Management
- "Compliance score against GDPR" → Compliance Manager
- "Download SOC 2 audit report for our auditor" → Service Trust Portal
- "Score-based posture for HIPAA / ISO compliance" → Compliance Manager
- "Phishing-resistant MFA" → FIDO2 security keys (or Microsoft Authenticator with number matching)
