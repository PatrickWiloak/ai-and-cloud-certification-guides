# MS-900 Microsoft 365 Fundamentals - Fact Sheet

## Quick Reference

**Exam:** MS-900 - Microsoft 365 Fundamentals
**Cost:** $99 USD
**Duration:** 65 minutes
**Questions:** ~45
**Passing:** 700/1000
**Validity:** Does not expire

**[📖 Official page](https://learn.microsoft.com/credentials/certifications/microsoft-365-fundamentals/)**
**[📖 Skills Measured](https://learn.microsoft.com/credentials/certifications/exams/ms-900/)**

---

## Microsoft 365 vs Office 365 vs M365 Apps

These names cause confusion - know them cold.

- **Office 365** - the legacy productivity suite (Word, Excel, PowerPoint, Outlook, Teams, SharePoint, OneDrive, Exchange Online)
- **Microsoft 365** = Office 365 + **Windows** + **Enterprise Mobility + Security (EMS)** = a broader enterprise bundle
- **Microsoft 365 Apps** = the standalone apps formerly known as "Office 365 ProPlus" - just Word/Excel/PowerPoint/etc., no email/SharePoint

For exam purposes:

- "Microsoft 365" generally means the full bundle (productivity + security + Windows)
- "Office 365" often refers to legacy SKUs that don't include Windows or EMS
- Microsoft is gradually phasing the "Office" branding out in favor of "Microsoft 365"

---

## Cloud concepts (Domain 1)

### Service models

- **IaaS** (Infrastructure as a Service) - VMs, networking, storage. Customer manages OS+. Example: Azure Virtual Machines.
- **PaaS** (Platform as a Service) - app platform; managed by Microsoft. Example: Azure App Service.
- **SaaS** (Software as a Service) - end-user apps. Most of M365 is SaaS. Example: Exchange Online, Microsoft 365 apps, Dynamics 365.

### Deployment models

- **Public cloud** - shared multi-tenant
- **Private cloud** - dedicated to one org
- **Hybrid** - mix of public + private + on-prem
- **Multi-cloud** - multiple public clouds

### Cloud benefits

Memorize: scalability, elasticity, agility, fault tolerance, disaster recovery, predictable costs, global reach, security/compliance posture (shared with Microsoft).

### Shared responsibility (in M365)

| Responsibility | Microsoft | Customer |
|---|---|---|
| Physical infra, hypervisor, OS patching of services | ✓ | |
| Service availability | ✓ | |
| Identity & user accounts | partial | partial (customer manages tenant identity) |
| Information & data | | ✓ (customer owns and classifies their data) |
| Devices | | ✓ |
| Account management | | ✓ |

Customer owns their **identity, data, devices**. Microsoft owns the platform.

---

## M365 apps and services (Domain 2)

### Productivity

- **Microsoft 365 Apps** - Word, Excel, PowerPoint, Outlook, OneNote, Access (Win), Publisher (Win), Teams (mobile/web). Subscription-based.
- **Office on the web** - browser versions
- **Outlook** - email client; talks to Exchange Online
- **OneDrive** - personal cloud storage (1TB+ in most plans)

### Collaboration

- **SharePoint Online** - team sites, intranet, document management
- **Teams** - chat, meetings, calls, collaboration; integrates with all of M365
- **Microsoft Loop** - real-time collaborative workspace components
- **Microsoft Forms** - surveys, quizzes
- **Microsoft Lists** - track items / inventory / issues
- **Yammer / Viva Engage** - enterprise social

### Email and calendaring

- **Exchange Online** - email + calendar
- **Microsoft Bookings** - appointment scheduling
- **Microsoft Planner** - lightweight project boards (Trello-style)

### Power Platform

- **Power BI** - BI dashboards
- **Power Apps** - low-code apps
- **Power Automate** - workflow automation (formerly Microsoft Flow)
- **Power Virtual Agents / Copilot Studio** - chatbots (now folded into Copilot Studio)
- **Dataverse** - underlying data platform for Power Platform

### Microsoft Copilot

- **Microsoft 365 Copilot** - AI assistant integrated across M365 apps (Word, Excel, PowerPoint, Outlook, Teams)
- **Copilot in Edge / Bing** - browser/search Copilot
- **GitHub Copilot** - code assistant (separate license)
- **Copilot Studio** - build custom copilots

### Endpoint management

- **Microsoft Intune** - MDM/MAM for Windows, iOS, Android, macOS, Linux
- **Microsoft Endpoint Manager** - umbrella that includes Intune + Configuration Manager (older on-prem)

### Identity (in M365 context)

- **Microsoft Entra ID** (formerly Azure AD) - cloud identity for M365
- Tenant = your organization's Entra ID instance
- Hybrid identity: connect on-prem AD to Entra ID via Entra Connect (sync) or pass-through auth

### Microsoft Viva

The employee-experience platform. Modules:

- **Viva Engage** (Yammer rebrand) - communities
- **Viva Connections** - intranet
- **Viva Insights** - personal/team analytics
- **Viva Learning** - LMS
- **Viva Topics** - knowledge graph
- **Viva Goals** - OKRs
- **Viva Pulse** - quick employee surveys
- **Viva Glint** - engagement surveys

---

## Security, Compliance, Privacy, Trust (Domain 3)

### Microsoft Defender (XDR / per-product)

- **Defender for Office 365** - email protection (anti-phishing, anti-malware, Safe Links, Safe Attachments)
- **Defender for Endpoint** - endpoint detection + response (EDR)
- **Defender for Identity** - on-prem AD threat detection (formerly Azure ATP)
- **Defender for Cloud Apps** - CASB (cloud app security broker)
- **Defender XDR** - the unified portal correlating signals across all Defender products

### Microsoft Sentinel

Cloud-native SIEM + SOAR. Ingests logs from M365, Azure, third-party. Built on Log Analytics.

### Microsoft Purview

Compliance and governance umbrella. Modules:

- **Information Protection** - sensitivity labels (Public / Confidential / etc.)
- **Data Loss Prevention (DLP)** - prevent leaks of sensitive content
- **Records Management** - retention policies, legal hold
- **Communication Compliance** - monitor for harassment / IP leakage in chat/email
- **Insider Risk Management** - detect risky user behavior
- **eDiscovery** - find and preserve content for legal cases
- **Audit** - compliance audit logs

### Compliance Manager

Score-based compliance posture tracker. Maps your tenant config against controls in regulations (GDPR, HIPAA, FedRAMP, etc.).

### Privacy and trust

Microsoft commitments:

- **Trust Center** - public docs on Microsoft's security/compliance/privacy posture
- **Service Trust Portal** - SOC, ISO, FedRAMP audit reports for download
- **Compliance offerings** - Microsoft maintains 100+ compliance certifications (SOC 1/2/3, ISO 27001, FedRAMP High, HIPAA BAA available, GDPR, etc.)

### Zero Trust principles

- **Verify explicitly** - always authenticate and authorize
- **Use least privilege access** - JIT, just-enough-access
- **Assume breach** - segment access, encrypt end-to-end, telemetry-driven detection

Microsoft positions Entra ID + Conditional Access + Defender + Intune as the Zero Trust stack.

### Conditional Access

Policy engine in Entra ID. Examples:

- "Require MFA for users in sales group accessing Salesforce from outside the corporate network"
- "Block sign-in if device isn't compliant with Intune policies"
- "Require trusted device for accessing Finance apps"

### Multi-factor authentication

Always-on MFA recommended for all users. Push notifications via Microsoft Authenticator app (preferred), SMS (legacy), hardware keys (FIDO2).

---

## Pricing, Licensing, Support (Domain 4)

### M365 SKUs (high level)

| Tier | Audience | Includes |
|---|---|---|
| **Microsoft 365 Personal/Family** | Consumer | Apps + 1TB OneDrive |
| **Microsoft 365 Business Basic** | SMB | Web/mobile apps + Teams + Exchange + SharePoint (no desktop apps) |
| **Microsoft 365 Business Standard** | SMB | + desktop apps |
| **Microsoft 365 Business Premium** | SMB | + Intune + Defender + advanced security |
| **Microsoft 365 Apps for Business** | SMB | Just the apps (no Exchange/Teams/SharePoint) |
| **Microsoft 365 E3** | Enterprise | Most enterprise features (apps, Exchange, SharePoint, Intune, Entra ID P1) |
| **Microsoft 365 E5** | Enterprise | E3 + advanced security (Defender XDR, Sentinel partial), Power BI Pro, Audio Conferencing, Phone System |
| **Microsoft 365 F1/F3** | Frontline workers | Lower-cost SKUs for shift workers; F3 has more features than F1 |

### Licensing models

- **Per user, per month** - normal subscription
- **Per device** - some SKUs (kiosk machines)
- **Annual commitment with monthly billing** - most common
- **Cloud Solution Provider (CSP)** - via Microsoft Partners; flexible, monthly
- **Enterprise Agreement (EA)** - large enterprise; 3-year commitment
- **Microsoft 365 Direct** - direct purchase via admin portal
- **Microsoft Customer Agreement (MCA)** - modern flat agreement

### Add-ons

Common: Audio Conferencing, Phone System, Defender for Endpoint Plan 2, Microsoft 365 Copilot, Power BI Pro/Premium, Project, Visio.

### Support

- **Standard support** included in subscriptions
- **Microsoft Unified Support** (formerly Premier) - paid, with TAM and faster response, for large enterprise
- **Service Health Dashboard** - real-time service incidents in admin center
- **Microsoft 365 Roadmap** - public roadmap of upcoming features

### FastTrack

Free Microsoft-led deployment support for eligible M365 customers (typically 150+ seats). Helps with onboarding and adoption.

### Adoption resources

- **Microsoft 365 Adoption** - free guidance + templates for change management
- **Productivity Score** - measure adoption metrics in your tenant

---

## High-yield exam facts

1. **M365 = Office 365 + Windows + EMS** at the enterprise tier
2. **Microsoft 365 Apps** = standalone apps (formerly "Office 365 ProPlus")
3. **E3 vs E5**: E5 adds Defender XDR, Sentinel features, Power BI Pro, Phone System, Audio Conferencing
4. **Defender XDR** = unified threat portal across Defender for Office 365 / Endpoint / Identity / Cloud Apps
5. **Purview** = compliance umbrella (IP, DLP, Records, eDiscovery, Insider Risk, Communication Compliance)
6. **Conditional Access** = policy engine in Entra ID for adaptive auth
7. **Zero Trust pillars** = Verify explicitly / Least privilege / Assume breach
8. **Compliance Manager** = score-based posture tracker
9. **Service Trust Portal** = where to download SOC/ISO/FedRAMP audit reports
10. **FastTrack** = free Microsoft-led deployment support for eligible customers (150+ seats)
11. **Frontline F-SKUs** = optimized for shift workers; F1 minimal, F3 more features
12. **CSP, EA, MCA** = procurement models (CSP via partner, EA for large enterprise, MCA modern)

---

## Common exam triggers

- "Cheapest M365 SKU with desktop apps for SMB" → Microsoft 365 Business Standard
- "Add advanced security + Intune to a small business" → upgrade to Business Premium
- "E3 vs E5 for advanced security and analytics" → E5
- "Centralize threat investigation across email + endpoints" → Defender XDR
- "Detect risky user behavior" → Insider Risk Management (Purview)
- "Tag a document as Confidential and prevent sharing externally" → Sensitivity Label + DLP policy
- "Force MFA when accessing email from outside corporate network" → Conditional Access policy
- "Public health/financial regulator audit reports" → Service Trust Portal
- "Free deployment help for new tenant" → FastTrack
- "Real-time service incidents" → Service Health Dashboard in admin center

---

## Companion services not always tested

- **Microsoft Copilot** - know it exists; specific Copilot exam (MS-4007) is separate
- **Microsoft Mesh** - immersive collaboration
- **GitHub** - integration with M365 (signed by Microsoft)
- **Microsoft Whiteboard** - collaborative whiteboarding
- **Microsoft Stream** - video sharing (now mostly replaced by Stream on SharePoint)
