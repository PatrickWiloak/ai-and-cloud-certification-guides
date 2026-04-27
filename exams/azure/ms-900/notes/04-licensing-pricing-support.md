# 04 - Licensing, Pricing, Support

## Licensing models

### Per-user, per-month subscription

The standard M365 model. Each user assigned a license for the SKU(s) they need.

### Per-device

Some SKUs (e.g., Microsoft 365 F1 Frontline) can be licensed per shared device used by multiple shift workers. Useful for kiosks, retail floor terminals.

### Annual commitment

Most M365 plans are annual commitment with monthly billing. Cancellation mid-term may incur fees.

### Cloud Solution Provider (CSP)

Buy through a Microsoft Partner. Benefits:

- Monthly billing flexibility
- Partner-managed support
- Bundling with consultancy services
- Some discounts for volume

CSP partners are Microsoft's largest channel for SMB and mid-market.

### Enterprise Agreement (EA)

Large enterprise (250+ seats typically). 3-year commitment. Volume discounts. Negotiated pricing. Co-terminus expirations across products.

### Microsoft Customer Agreement (MCA)

Modern, flat agreement replacing legacy enrollments. No paperwork for subsequent purchases. Designed for cloud-first orgs.

### Direct online subscriptions

Purchase directly via Microsoft 365 admin center. Simple, no negotiation, monthly or annual billing.

---

## Microsoft 365 SKUs (memorize the high-level differences)

### Consumer

- **Microsoft 365 Personal** - 1 person, all apps, 1 TB OneDrive
- **Microsoft 365 Family** - 6 people, all apps, 1 TB OneDrive each

### SMB (max 300 users)

| SKU | Apps | Email | Teams | SharePoint | OneDrive | Intune | Defender |
|---|---|---|---|---|---|---|---|
| Microsoft 365 Business Basic | Web/mobile only | ✓ | ✓ | ✓ | 1TB | ✗ | ✗ |
| Microsoft 365 Business Standard | + desktop apps | ✓ | ✓ | ✓ | 1TB | ✗ | ✗ |
| Microsoft 365 Business Premium | + desktop apps | ✓ | ✓ | ✓ | 1TB | ✓ | Defender for Business |
| Microsoft 365 Apps for Business | Apps only (desktop) | ✗ | ✗ | ✗ | 1TB | ✗ | ✗ |

### Enterprise (no user limit)

| SKU | Highlight |
|---|---|
| **Microsoft 365 Apps for Enterprise** | Just the desktop apps (no Exchange/Teams/SharePoint) |
| **Office 365 E1** | Web/mobile apps + Exchange + Teams + SharePoint, no desktop apps |
| **Office 365 E3** | + desktop apps + advanced compliance |
| **Office 365 E5** | + Phone System, Audio Conferencing, advanced security/compliance |
| **Microsoft 365 E3** | Office 365 E3 + Windows + EMS E3 (Intune + Entra ID P1 + Defender for Endpoint P1) |
| **Microsoft 365 E5** | Office 365 E5 + Windows + EMS E5 (full Defender XDR, Entra ID P2, Power BI Pro) |

### Frontline

For shift workers, retail, manufacturing floor.

- **Microsoft 365 F1** - basic Teams + tools; no desktop apps; lower cost
- **Microsoft 365 F3** - F1 + more features (limited Outlook, etc.); cost between F1 and Business Basic
- Often per-shared-device licensed

### Education

- **A1** - free for accredited students/faculty
- **A3 / A5** - paid tiers analogous to E3 / E5

### Government

US-specific compliance tiers:

- **GCC (Government Community Cloud)** - FedRAMP Moderate
- **GCC High** - FedRAMP High, ITAR
- **DoD** - DoD IL5

These are separate clouds with separate pricing and feature parity lags slightly.

---

## Common add-ons

When base SKU isn't enough:

- **Audio Conferencing** - dial-in numbers for Teams meetings
- **Phone System + Calling Plan** - PSTN calling via Teams
- **Defender for Endpoint Plan 2** - if base SKU only has Plan 1
- **Defender for Office 365 Plan 2** - if base SKU only has Plan 1
- **Microsoft 365 Copilot** - $30/user/month AI assistant add-on
- **Power BI Pro** - if base SKU doesn't include
- **Project / Visio** - separate license
- **Microsoft Viva Suite** - Viva modules bundle
- **Exchange Online Archiving / In-place hold** - extended mailbox storage and compliance hold

---

## Tenant management

### Microsoft 365 admin center

[admin.microsoft.com](https://admin.microsoft.com) - the main admin portal.

- User and license management
- Subscription / billing
- Service Health Dashboard
- Message Center (announcements about feature changes)
- Reports on usage

### Service-specific admin centers

- Exchange admin center
- Teams admin center
- SharePoint admin center
- Microsoft Defender portal
- Microsoft Purview portal
- Microsoft Entra admin center
- Microsoft Intune admin center

---

## Service health and lifecycle

### Service Health Dashboard

Real-time view of M365 service issues affecting your tenant. Microsoft posts incidents and resolution updates.

### Message Center

Notifications about upcoming feature changes (typically 30+ days advance notice).

### Microsoft 365 Roadmap

[microsoft365.com/roadmap](https://www.microsoft.com/microsoft-365/roadmap) - public roadmap of features:

- In Development
- Rolling Out
- Launched

Filter by product, platform, status.

### Modern Lifecycle Policy

Continuous servicing model: "evergreen" updates, no end-of-support dates for cloud services. Some products (Office on the desktop) have version lifecycle (e.g., Office 2019 Mainstream End of Support 2023, Extended Support 2025).

### Service Level Agreement (SLA)

- M365 SLA: **99.9% uptime** for most services
- Service credits if Microsoft fails to meet SLA
- Read the financially-backed SLA terms in your subscription

---

## Support plans

### Standard support (included)

- Self-service via documentation
- Microsoft 365 admin center support tickets
- Community forums

### Microsoft Unified Support

Paid premium support tier for enterprise customers.

- Technical Account Manager (TAM)
- Faster response times
- Critical situation 24/7 support
- Custom training and proactive services

Replaced the old Premier Support model.

### FastTrack

**Free** Microsoft-led deployment guidance for eligible customers (typically 150+ M365 seats). Includes:

- Onboarding planning
- Migration assistance
- Adoption guidance
- Best practices

Purpose: maximize successful M365 deployment and adoption.

---

## Adoption and change management

### Microsoft 365 Adoption resources

Microsoft publishes free adoption playbooks, templates, and training. Find at [adoption.microsoft.com](https://adoption.microsoft.com).

### Productivity Score

Tenant-level metric measuring M365 adoption across:

- People experience (collaboration, communication, content)
- Technology experience (network, endpoints)

Use to drive adoption initiatives.

### Microsoft Champions Program

Internal champions help drive adoption within an org. Microsoft provides materials and recognition.

---

## Pricing trends to know

- M365 Copilot launched at $30/user/month (subject to change)
- M365 Business Premium ~$22/user/month (small business)
- M365 E3 ~$36/user/month
- M365 E5 ~$57/user/month
- Frontline F1 ~$2.25/user/month, F3 ~$8/user/month

(Pricing varies by region, channel, commitment, currency.)

---

## Common exam triggers

- "SMB needs Defender + Intune at low cost" → Microsoft 365 Business Premium
- "Enterprise needs full security stack including XDR + Sentinel" → Microsoft 365 E5
- "Shift workers in retail need Teams without expensive licensing" → Microsoft 365 F1 / F3
- "Free deployment help for 500-seat tenant" → FastTrack
- "Real-time service incidents" → Service Health Dashboard
- "Upcoming feature changes notification" → Message Center
- "TAM and 24/7 critical support for large enterprise" → Microsoft Unified Support
- "M365 SLA" → 99.9% for most services
- "Buy via partner with monthly billing" → Cloud Solution Provider (CSP)
- "Large enterprise 3-year deal" → Enterprise Agreement (EA)
