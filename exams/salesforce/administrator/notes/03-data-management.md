# 03 - Data Management

## Importing data

### Decision flowchart

```
Volume?
├─ < 50,000 records → Data Import Wizard (browser, simple)
├─ < 5 million records → Data Loader (desktop or CLI)
└─ > 5 million → Bulk API directly (programmatic)

Object?
├─ Account, Contact, Lead, Solution, Custom → Both wizards work
└─ Other standard objects (Opportunity, Case, Campaign, etc.) → Data Loader only
```

### Data Import Wizard

- Setup → Data Import Wizard
- 50,000-record limit per file
- Insert / Update / Upsert
- Match by Salesforce ID, Name, External ID, or Email
- No relationships across multi-step imports

### Data Loader

- Desktop app (Windows / Mac) or CLI (`apex_data_loader_cli`)
- All standard and custom objects
- Insert / Update / Upsert / Delete / Hard Delete / Export / Export All
- 5 million records or 10 GB (theoretical)
- CSV files
- Field mapping UI
- Saves successful and error files

### Bulk API

- REST or SOAP API
- For >5M records or programmatic integrations
- Asynchronous; submit job, poll status, retrieve results
- 50,000 batches/day limit (configurable)

---

## Upsert

Match existing records by an **External ID** field; update if matched, insert if not. Critical for data integrations.

Requires:

- A field marked as **External ID**
- Field marked as **Unique** (recommended)
- The CSV column containing the matching value

Saves you from "do I update or create?" logic in your ETL.

---

## Mass operations

### Mass Transfer

- Setup → Data Management → Mass Transfer Records
- Available for Lead, Account, custom objects (not all standard)
- Transfer ownership in bulk based on criteria

### Mass Update

- Through list views with inline editing (limited)
- For real bulk updates, use Data Loader Update

### Mass Delete

- Setup → Data Management → Mass Delete Records
- For Lead, Contact, Account, Activity, Product, Report
- Soft delete (goes to Recycle Bin); Hard Delete option in Data Loader

### Recycle Bin

- Soft-deleted records go here for 15 days
- Recover via Recycle Bin or `UNDELETE` in Data Loader (Hard Delete bypasses Recycle Bin)

---

## Duplicate management

### Matching Rules

Define how to compare records:

- Match on Email, Phone, Name (fuzzy or exact)
- Built-in for Account, Contact, Lead
- Custom matching rules for custom objects (with limitations)

### Duplicate Rules

Use a matching rule + define action:

- **Allow** with alert (let user save, show warning)
- **Block** save (reject creating a duplicate)
- **Audit** (log but allow)

### Duplicate Jobs (paid feature)

Periodic duplicate scans on existing data. Available with **Data.com** or **Duplicate Check** package. Built-in dupe management is for prevention, not bulk dedup of existing data.

---

## Data quality tools

### Validation Rules

Block save if a formula returns true. Display custom error message.

Examples:

- "Close Date must be in the future when Stage is Open"
- "Phone must be valid US format"
- "Discount cannot exceed 30% without manager approval"

### Required fields

- **Universally Required** - required regardless of profile (set on field definition)
- **Page Layout Required** - required when editing through the layout (per profile via layout)
- **Validation Rule** - "field must not be blank" formula

---

## Backup and export

### Weekly Export (Free)

Setup → Data Management → Data Export.

- Schedule weekly or monthly
- Generates ZIP of CSVs (1 per object) emailed to admin
- Free, slow, manual restore if needed
- Not a true backup product (no point-in-time restore)

### Salesforce Backup & Restore (Paid)

Salesforce-native backup product. Daily snapshots, point-in-time restore, retention controls.

### Third-party backup tools

OwnBackup (now Own), Spanning, Druva, etc. Common for enterprises.

---

## Sandboxes

Identical-schema replicas of production for development / testing.

| Type | Refresh | Storage | Data |
|---|---|---|---|
| **Developer** | 1 day | 200 MB | Metadata only |
| **Developer Pro** | 1 day | 1 GB | Metadata only |
| **Partial Copy** | 5 days | 5 GB | Metadata + sample data (configurable) |
| **Full** | 29 days | Production size | Metadata + all data |

### When to use

- **Developer / Developer Pro** - unit / integration testing for individual devs
- **Partial Copy** - QA / UAT with representative data, faster refresh than Full
- **Full** - final UAT before prod deploy, training, performance testing

### Sandbox naming

`<sandbox-name>.sandbox.my.salesforce.com` - separate URL from prod.

---

## Deployment options

### Change Sets

- Inbound + outbound between connected sandboxes / prod
- Drag-drop UI for selecting metadata to deploy
- Limited to specific component types
- Slow for large deployments

### Salesforce CLI / SFDX

Modern dev workflow:

- Source format (decomposed XML for git-friendliness)
- Scratch orgs (ephemeral dev orgs)
- Deploy via `sf project deploy start`
- CI/CD via GitHub Actions / Azure DevOps / etc.

### Unmanaged / Managed Packages

- **Unmanaged** - distributable but recipient owns the metadata
- **Managed** - AppExchange products with versioning, namespace, IP protection

---

## Storage

Two types:

- **Data Storage** - records (Account, Contact, etc.)
- **File Storage** - attachments, documents, content versions

### Per-edition allowances

- Enterprise: 10 GB Data + 10 GB File for org + per-user additions
- Unlimited: more

### Monitoring

Setup → Storage Usage. Per-object storage breakdown.

### Storage cleanup

- Delete old / archived records
- Move attachments to external storage (S3, OneDrive) via Files Connect
- Hard Delete to bypass Recycle Bin (frees storage immediately)
- Big Objects for archival data (millions of records, async query only)

---

## Common exam triggers

- "Mass insert 250,000 Opportunities with parent Account lookup" → Data Loader (Wizard caps at 50K and doesn't support Opportunity)
- "Match incoming records by SAP ID" → External ID + Upsert via Data Loader
- "Detect duplicate Leads at creation time" → Matching Rule + Duplicate Rule (Block or Alert)
- "Restore data deleted 5 days ago" → Recycle Bin (15-day retention)
- "Permanently delete with no Recycle Bin retention" → Data Loader Hard Delete
- "Block save unless region field is filled" → Validation Rule (or Universally Required if always required)
- "Sandbox for UAT with representative data" → Partial Copy Sandbox
- "Final UAT before prod deploy" → Full Sandbox
- "Move large data archive out of normal storage" → Big Object
- "Schedule weekly backup of all data to CSV" → Data Export (Weekly Export)
