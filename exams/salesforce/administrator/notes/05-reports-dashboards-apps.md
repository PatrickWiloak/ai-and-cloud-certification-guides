# 05 - Reports, Dashboards, Sales/Service Apps

## Reports

### Report types

A **Report Type** defines:

- The primary object (e.g., Opportunity)
- Related objects (joined via standard relationships)
- Available fields

Report Types are templates; Reports are instances.

#### Standard Report Types

Salesforce provides hundreds based on standard objects + relationships. E.g., "Opportunities with Products," "Cases with Contacts."

#### Custom Report Types

Create your own when you need:

- Custom relationships included in reporting
- A "with or without" relationship (left outer join)
- Specific available fields filtered

Setup → Report Types → New Custom Report Type. Specify primary object + related (mandatory, optional, exclude when no related). Define which fields are reportable.

### Report formats

| Format | Use |
|---|---|
| **Tabular** | Simple list, no totals - export-style |
| **Summary** | Grouped by 1-3 fields with subtotals |
| **Matrix** | Cross-tab (rows + columns), e.g., Account by Region by Quarter |
| **Joined** | Multiple report blocks on same canvas (different report types) |

### Report features

- **Filters** - field criteria, logic (AND/OR/NOT), date ranges
- **Cross filters** - "Accounts WITH/WITHOUT Opportunities matching..."
- **Bucket fields** - on-the-fly grouping (e.g., bucket Amount into Small/Medium/Large)
- **Formula fields** - row-level or summary-level calculations
- **Conditional highlighting** - color cells based on values
- **Charts** - bar, line, pie, donut, funnel, scatter
- **Subscriptions** - email a report on schedule
- **Folder permissions** - share / restrict reports

### Limits

- 2,000 rows displayed in browser (export shows more)
- 20,000 rows for export from Lightning
- Complex reports may hit governor limits

---

## Dashboards

### Components

- **Chart** - bar, column, line, pie, donut, funnel, scatter, gauge, metric, table
- **Visual Filters** - filter dashboard by clicking a component (Lightning)
- **Dynamic Dashboards** - run as the logged-in user (limited per edition)

### Source data

Each component sources from a single Report. Update the Report = update the dashboard component.

### Refresh

- Manual refresh
- Scheduled refresh (daily, weekly)
- Subscribe (email when refreshed)

### Limits

- 12 components per dashboard (most editions)
- 25 in Lightning Experience
- Up to 10 dynamic dashboards per org (Enterprise)

### Folders and access

- Public Dashboards folder - shared with everyone
- Custom folders - shared with users / roles / public groups
- "Run as" setting controls whose data the components query

---

## Sales Cloud highlights

### Lead lifecycle

```
Lead created (web-to-lead, manual, import)
    ↓
Lead worked / qualified
    ↓
Convert
    ├─ Account (existing or new)
    ├─ Contact (existing or new)
    └─ Opportunity (optional)
```

### Web-to-Lead

- Setup → Web-to-Lead - generate HTML form
- Auto-create Lead from form submission
- Daily limit: 500 leads/day standard, 5,000 with Premier

### Auto-Response Rules

When a Lead is created, send acknowledgment email based on criteria.

### Assignment Rules

Auto-assign Leads or Cases based on criteria. First matching rule entry wins.

### Sales Process

A specific set of Stage values for a Record Type's Opportunity. Allows different sales motions.

### Path

Visual progress indicator on the record page. Show the steps, key field guidance per stage, success guidance.

### Forecasting

Track sales pipeline aggregates. Two flavors:

- **Collaborative Forecasts** - managers commit / adjust forecasts
- **Customizable Forecasting** (legacy) - more rigid

### Products and Pricebooks

- Product = thing you sell
- Pricebook = price list (Standard Pricebook required + custom pricebooks per market/segment)
- Pricebook Entry = Product + Pricebook + Price

### Quotes and Orders

Generate quotes from Opportunities; convert to orders. Standard objects with built-in PDFs.

### Campaign Management

- **Campaign** - marketing initiative
- **Campaign Member** - link Lead/Contact to Campaign with Status (e.g., Sent, Responded)
- **Campaign Influence** - track multi-touch campaign attribution

---

## Service Cloud highlights

### Case lifecycle

```
Case created (Email-to-Case, Web-to-Case, Self-Service portal, agent manual, integration)
    ↓
Routed (Assignment Rules, Omni-Channel)
    ↓
Worked by agent (Service Console)
    ↓
Resolved or escalated
    ↓
Closed
```

### Email-to-Case

- Setup → Email-to-Case
- Forward emails from a custom address (`support@example.com`) into Salesforce
- **On-Demand Email-to-Case** - simpler, hosted by Salesforce
- **Email-to-Case (regular)** - requires email service installed on local mail server (legacy)

### Web-to-Case

- HTML form generator like Web-to-Lead
- Auto-create Case from form submission
- 500/day standard

### Auto-Response Rules

Send acknowledgment email when Case is created.

### Assignment Rules

Route Cases to queue or owner based on criteria.

### Escalation Rules

Auto-escalate Cases based on age, priority, or other criteria. Action: notify, reassign, change owner.

### Service Console

Multi-record agent UI:

- Tabbed workspace (one tab = one open record)
- Sub-tabs for related records
- Macros to automate repetitive actions
- Knowledge component (search and insert articles into responses)
- Omni-Channel widget for incoming work routing

### Omni-Channel

- Routes work (Cases, Chats, Phone Calls, custom objects) to agents
- Routing: Most Available, Least Active, External Routing
- Capacity model: each work item has a "weight"; agent has a "capacity"
- Service Channels define what's routed

### Knowledge

- Articles for self-service and agent reference
- Versioning, translations, data categories
- Article types (legacy Classic) → unified Knowledge in Lightning

### Entitlements and Milestones

- **Entitlement** - SLA (e.g., gold customer: 4-hour first response)
- **Milestone** - measurable step within entitlement (response time, resolution time)
- Entitlement Process - defined milestones with timer

---

## Apps

### Lightning Apps

Bundles of:

- Tabs (objects + custom tabs)
- Utility bar items
- App branding
- Profile assignments

Examples: Sales (default), Service Console, Marketing, custom apps.

### App Manager

Setup → App Manager. Create/edit/clone apps.

### AppExchange

Microsoft of Salesforce add-ons. Install managed packages from AppExchange. Free and paid.

---

## Common exam triggers

- "Show open Opportunities by Region by Quarter" → Matrix Report
- "Report on Accounts WITHOUT recent Activity" → Custom Report Type with optional Activity + cross filter
- "Group revenue into Small/Medium/Large bands" → Bucket Field
- "Email a weekly sales report to the team" → Subscription
- "Manager wants to see their team's data without creating per-rep dashboards" → Dynamic Dashboard with "Run as logged-in user"
- "Lead from website automatically creates Salesforce record" → Web-to-Lead
- "Auto-route high-priority cases to Tier 2 queue" → Assignment Rule
- "Escalate case if not resolved in 8 hours" → Escalation Rule (or Entitlement Process with Milestone)
- "Visual progress steps on Lead page" → Path
- "Multi-tab agent UI for case work" → Service Console (with Omni-Channel for routing)
- "SLA tracking on Cases" → Entitlement Process with Milestones
- "Track marketing campaign multi-touch attribution" → Campaign Influence
- "Different stages for B2B vs B2C Opportunity" → Two Sales Processes + two Record Types
