# 02 - M365 Apps and Services

## Productivity apps (Microsoft 365 Apps)

The familiar Office suite, modernized as a subscription.

| App | Use |
|---|---|
| **Word** | Documents |
| **Excel** | Spreadsheets, data analysis |
| **PowerPoint** | Presentations |
| **Outlook** | Email + calendar (talks to Exchange Online) |
| **OneNote** | Note-taking |
| **Teams** | Chat, meetings, collaboration |
| **OneDrive** | Personal cloud storage (1+ TB in most plans) |
| **Access** | Desktop database (Windows) |
| **Publisher** | Desktop publishing (Windows) |

Plus mobile apps (iOS, Android), web apps (Office on the web), and Mac equivalents.

---

## Collaboration platform

### SharePoint Online

- Team sites, communication sites, hub sites
- Document libraries (with versioning, co-authoring)
- Lists (track items, requests, inventory)
- Built-in workflows via Power Automate
- Foundation for OneDrive (which is your personal SharePoint storage)

### OneDrive

Personal cloud drive, 1TB+ in most plans. Sync client for Windows / Mac / mobile. Used as the storage layer for many M365 apps.

### Teams

The hub for communication.

- **Chat** - 1:1, group, channel
- **Channels** - team-organized chat + files
- **Meetings** - video/voice, screen-share, recording (saved to OneDrive/SharePoint)
- **Calls** - PSTN calling with Phone System add-on
- **Apps** - extend Teams with custom or third-party apps
- **Live events** - broadcast to large audiences
- **Webinars** - registration + reporting

### Microsoft Loop

Real-time collaborative components (lists, tables, paragraphs) embeddable across Teams chat, Outlook, OneNote.

### Microsoft Lists

Lightweight tracking (issues, inventory, requests). Built on SharePoint.

### Microsoft Planner

Project task boards (Trello-style). Group-based.

### Yammer / Viva Engage

Enterprise social. Discussions, communities, broadcasting.

---

## Email and calendar

### Exchange Online

- Email, calendar, contacts, tasks
- Mailbox sizes typically 50-100 GB
- Anti-spam, anti-phishing, anti-malware (basic)
- Defender for Office 365 adds Safe Links / Safe Attachments / advanced threat protection

### Microsoft Bookings

Customer-facing appointment booking (used by hair salons, doctors, advisors, etc.).

---

## Power Platform

Low-code business apps platform. Each module has its own license but bundled with some M365 SKUs.

### Power BI

- BI dashboards and reports
- Power BI Service (cloud) and Power BI Desktop (Win authoring tool)
- **Power BI Pro** included in E5; available as add-on for E3
- **Power BI Premium** for capacity-based deployments

### Power Apps

- Low-code app builder
- Canvas apps (visual designer) and Model-driven apps (data-driven, on Dataverse)
- Many seeded scenarios in M365: approvals, expense reports, etc.

### Power Automate

- Workflow automation (formerly Microsoft Flow)
- Triggers + actions across 1000+ connectors
- **Power Automate Desktop** for RPA (Windows automation)

### Copilot Studio

(Formerly Power Virtual Agents.) Build chatbots and copilots without code. Now positioned as the platform for custom Copilots.

### Dataverse

The relational data platform underlying Power Platform. Tables, relationships, security model. Used by Dynamics 365 and Model-driven Power Apps.

---

## Microsoft Copilot (AI)

Microsoft's AI assistant, integrated across products.

### Variants

- **Microsoft 365 Copilot** - in Word, Excel, PowerPoint, Outlook, Teams, Loop. Per-user license. Grounded in your tenant data via the Microsoft Graph.
- **Copilot in Edge / Bing** - browser/search Copilot
- **Copilot for Sales / Service / Finance** - role-specific Copilots in Dynamics
- **Copilot Studio** - build custom Copilots
- **GitHub Copilot** - code assistant; separate license

### How M365 Copilot works (high level)

1. User prompts Copilot in Word/Excel/etc.
2. Copilot uses Microsoft Graph to retrieve your tenant context (emails, files, calendar, chats)
3. Sends a grounded prompt to a foundation model (Azure OpenAI / Microsoft hosted)
4. Returns response with citations to source documents

Data stays inside your tenant boundary; not used to train Microsoft's models (per Copilot data protection commitments).

### Pricing

Microsoft 365 Copilot is a $30/user/month add-on for E3/E5 customers (price subject to change).

---

## Endpoint management

### Microsoft Intune

MDM (Mobile Device Management) and MAM (Mobile App Management) for:

- Windows
- macOS
- iOS / iPadOS
- Android
- Linux

Capabilities:

- Device enrollment + compliance
- App deployment (Win32, iOS, Android, web apps)
- App protection policies (MAM without enrollment for BYOD)
- Conditional access integration with Entra ID
- Patch management for Windows (Windows Update for Business)

### Microsoft Endpoint Manager / Configuration Manager

Configuration Manager (SCCM) is the on-prem management tool, often co-managed with Intune. "Endpoint Manager" was the umbrella branding (Intune + ConfigMgr); branding has shifted to just "Intune" again recently.

### Autopilot

Zero-touch Windows device provisioning. Ship a new laptop directly to a user; first boot enrolls into Intune and configures itself.

---

## Identity (in M365 context)

### Microsoft Entra ID

The identity service powering M365 (formerly Azure AD).

- Tenant = your org's directory
- Users, groups, devices, roles
- SSO to thousands of SaaS apps via Entra ID Gallery
- B2B (guest users from other tenants) and B2C (consumer-facing apps)

### Hybrid identity

- **Microsoft Entra Connect** - syncs on-prem AD users/groups to Entra ID
- **Pass-through Authentication** - sign-in validated against on-prem AD (no password sync)
- **Federation** (legacy) - ADFS-based sign-in
- **Cloud Sync** - lightweight alternative to Entra Connect

### Conditional Access

(Detail in [03-security-compliance-trust.md](./03-security-compliance-trust.md).)

---

## Microsoft Viva

Employee experience platform. Modules:

- **Viva Engage** (formerly Yammer) - communities, discussions
- **Viva Connections** - personalized intranet in Teams
- **Viva Insights** - personal/team productivity analytics (anonymized aggregates)
- **Viva Learning** - LMS aggregating LinkedIn Learning + custom content
- **Viva Topics** - knowledge graph automatically extracts topics from your tenant's content
- **Viva Goals** - OKRs and goal tracking
- **Viva Pulse** - quick employee surveys (manager-led)
- **Viva Glint** - engagement / sentiment surveys (org-wide, with HR)

Some modules are included in M365 plans; others are paid add-ons (Viva Suite license).

---

## Industry Clouds (high level)

Vertical M365 + Dynamics + Azure bundles:

- **Microsoft Cloud for Healthcare** - patient engagement, EHR integration (FHIR), Teams for clinicians
- **Microsoft Cloud for Financial Services** - banking + insurance + capital markets workflows
- **Microsoft Cloud for Retail** - in-store ops, supply chain, marketing
- **Microsoft Cloud for Manufacturing** - factory operations, supply chain
- **Microsoft Cloud for Sustainability** - carbon accounting, sustainability reporting
- **Microsoft Cloud for Nonprofit** - donor / volunteer / program management

These bundle existing services with industry-specific accelerators.

---

## Common exam triggers

- "Email server in M365" → Exchange Online
- "File collaboration with versioning" → SharePoint Online + OneDrive
- "Chat + meetings + calls in one app" → Teams
- "Custom chatbot with no code" → Copilot Studio (Power Virtual Agents successor)
- "Workflow automation across SaaS apps" → Power Automate
- "Manage iOS / Android / Windows fleet from one console" → Intune
- "Zero-touch laptop provisioning" → Windows Autopilot
- "AI assistant in Word/Excel/PowerPoint" → Microsoft 365 Copilot
- "Personal productivity insights" → Viva Insights
- "Knowledge graph from tenant content" → Viva Topics
- "Sync on-prem AD to Entra ID" → Microsoft Entra Connect (or Cloud Sync)
