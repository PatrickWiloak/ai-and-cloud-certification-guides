# 01 - Cloud Concepts and Microsoft 365 Overview

## Cloud service models

### IaaS - Infrastructure as a Service

You manage: OS, runtime, applications, data.
Microsoft manages: physical hardware, virtualization, networking infrastructure.
M365 example: Azure Virtual Machines (mostly IaaS, used by some M365 customers for hybrid scenarios).

### PaaS - Platform as a Service

You manage: applications, data.
Microsoft manages: OS, runtime, middleware, infrastructure.
M365 example: Azure App Service.

### SaaS - Software as a Service

You manage: data, identity, settings within the app.
Microsoft manages: everything else.
**Most of M365 is SaaS:** Exchange Online, SharePoint Online, Teams, Microsoft 365 Apps (web).

### Comparison

```
On-prem:    [App][Data][Runtime][OS][VM][Network][HW]   <- you manage all
IaaS:       [App][Data][Runtime][OS]                    <- you manage above the line
PaaS:       [App][Data]
SaaS:       [Data]                                      <- you only manage data + users
```

---

## Cloud deployment models

### Public cloud

Multi-tenant. Microsoft hosts in shared infrastructure. M365 runs in Microsoft's public cloud (with logical isolation per tenant).

### Private cloud

Single-tenant. On-prem datacenter or dedicated cloud hardware. Older banking/government.

### Hybrid cloud

Mix of public + private/on-prem. Common for M365 + on-prem AD via Entra Connect.

### Multi-cloud

Multiple public clouds (Azure + AWS + GCP). Less common in M365 context but increasingly common in enterprise IT.

---

## Cloud benefits

- **Scalability** - scale up/down on demand
- **Elasticity** - automatic scaling based on load
- **Agility** - deploy in minutes, not months
- **Reliability** - cloud SLAs higher than typical on-prem
- **Disaster recovery** - geo-redundant by default in M365
- **Predictable costs** - subscription pricing
- **Global reach** - regional data residency available

---

## Microsoft Cloud

Microsoft's overall cloud portfolio:

- **Microsoft Azure** - the public cloud platform (IaaS/PaaS)
- **Microsoft 365** - productivity SaaS suite
- **Dynamics 365** - business apps SaaS (CRM, ERP)
- **Power Platform** - low-code (Power BI, Power Apps, Power Automate, Copilot Studio)
- **Microsoft Industry Clouds** - vertical SaaS (Healthcare, Financial Services, Retail, Manufacturing, Sustainability, Nonprofit)
- **GitHub** - Microsoft-owned, separately branded

M365 sits in this portfolio as the productivity SaaS pillar.

---

## What is Microsoft 365?

The bundle that includes:

1. **Microsoft 365 Apps** (Word, Excel, PowerPoint, Outlook, OneNote, Teams, OneDrive, etc.)
2. **Productivity services** (Exchange Online, SharePoint Online, Teams, OneDrive)
3. **Windows** (in some enterprise tiers)
4. **Enterprise Mobility + Security (EMS)** - Entra ID P1/P2, Intune, Defender XDR, Microsoft Purview

### M365 vs Office 365

- **Office 365** is the legacy productivity-only bundle (Apps + services, no Windows, no EMS)
- **Microsoft 365** = Office 365 + Windows + EMS = enterprise complete bundle
- Microsoft is gradually consolidating "Office" branding into "Microsoft 365"

### Common SKUs and what's in them

**SMB:**
- Microsoft 365 Business Basic - web/mobile apps + Exchange + Teams + SharePoint
- Microsoft 365 Business Standard - desktop apps too
- Microsoft 365 Business Premium - + Intune + Defender for Business + Entra ID P1

**Enterprise:**
- Microsoft 365 E3 - apps + services + Intune + Entra ID P1 + Defender for Endpoint P1
- Microsoft 365 E5 - E3 + Defender XDR + Sentinel features + Power BI Pro + Phone System + Audio Conferencing
- Microsoft 365 F1/F3 - frontline workers (shift staff, retail floor)

**Education:**
- A1, A3, A5 (analogous to enterprise tiers)
- Free for accredited students/faculty (limited features)

**Government:**
- GCC, GCC High, DoD - separate clouds for US government compliance (FedRAMP High, ITAR, IL5)

---

## Microsoft 365 Apps deployment

How apps get to user devices:

- **Click-to-Run** - streaming installer; default for M365 apps
- **MSI** - legacy installer; use for managed environments needing stricter version control
- **Configuration Manager** - SCCM/Intune-managed deployment
- **Direct download** - users install from portal

### Update channels

Updates come on different cadences:

- **Current Channel** - monthly; latest features ASAP
- **Monthly Enterprise Channel** - monthly; predictable second-Tuesday cadence
- **Semi-Annual Enterprise Channel** - twice a year; for orgs preferring stability
- **Insider channels** - beta / dev tracks

Plan deployment by user role: developers and power users on Current; broader workforce on Monthly Enterprise; regulated/managed environments on Semi-Annual.

---

## Tenants

A **tenant** = your organization's M365 environment.

- Identified by a domain `<name>.onmicrosoft.com` (you can also bind verified custom domains)
- Backed by an Entra ID directory
- Isolated from other tenants
- Can be in different regions (data residency)

### Multi-tenant

Some orgs (M&A scenarios, multinationals) operate multiple tenants. M365 supports limited cross-tenant scenarios via:

- **Cross-tenant access settings** for B2B
- **Cross-tenant synchronization** (Entra ID feature)
- **Microsoft 365 Multi-tenant Organizations** (newer feature for managing multi-tenant scenarios more cleanly)

---

## Common exam triggers

- "Office 365 vs Microsoft 365" → M365 includes Windows + EMS; O365 is productivity only
- "SaaS examples" → Exchange Online, Teams, SharePoint Online, Dynamics 365
- "Hybrid cloud" → Mix of on-prem + cloud, common with on-prem AD + Entra ID
- "Geo-redundancy" → Built into M365 by default; data replicated within geo
- "Update channel for stability" → Semi-Annual Enterprise Channel
- "Cloud benefit: scaling automatically with load" → Elasticity
- "Cloud benefit: speed to deploy" → Agility
