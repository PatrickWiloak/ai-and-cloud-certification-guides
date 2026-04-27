# 02 - Objects, Fields, Page Layouts, Record Types

## Standard objects

The big ones the exam tests:

- **Account** - companies (B2B) or households
- **Person Account** (combines Account + Contact for B2C) - opt-in feature
- **Contact** - individuals
- **Lead** - unqualified prospects; convert to Account + Contact + Opportunity
- **Opportunity** - sales deals in progress
- **Case** - support tickets
- **Campaign** - marketing campaigns; track members
- **Product / Pricebook / Pricebook Entry** - what you sell
- **Quote / Quote Line Item** - quotes generated from Opportunities
- **Order / Order Product** - orders
- **Asset** - sold products tracked over their lifecycle
- **Contract** - customer contracts
- **Activity / Task / Event** - activities related to records
- **Knowledge** - support articles

### Account-Contact relationship

- One account, many contacts
- A contact can have **multiple accounts** via Contacts to Multiple Accounts feature

### Opportunity-Lead relationship

Lead is **converted** to:

- Account (existing or new)
- Contact (existing or new)
- Opportunity (optional - check the box during conversion)

After conversion, the Lead is read-only / converted state.

---

## Custom objects

### Creating a custom object

Setup → Object Manager → Create. Specifies:

- Singular and Plural label
- Object name (auto-suffixed `__c`)
- Record name (Auto Number or Text)
- Allow Reports / Activities / Search
- Object features

### Custom object limits (Enterprise edition)

- 800 custom objects per org
- 800 custom fields per object
- 1,000 custom relationships per object

### When to create a custom object

If your data has its own lifecycle, fields, security model, automation. Examples: Project, Asset Inventory, Training Record, Inspection.

Don't create one when fields on a standard object would suffice.

---

## Field types in detail

### Text variants

| Field | Max length | Notes |
|---|---|---|
| Text | 255 chars | Single line |
| Text Area | 255 chars | Multi-line plain |
| Text Area (Long) | 131,072 chars | Long plain text |
| Text Area (Rich) | 131,072 chars | HTML formatting |
| Text Encrypted (Classic) | varies | Hidden from non-privileged users |

### Numeric

- **Number** - integer or decimal, configurable digits + decimals
- **Currency** - locale-aware
- **Percent** - stored as percentage value

### Lookup vs Master-Detail (THE most-tested distinction)

| Aspect | Lookup | Master-Detail |
|---|---|---|
| Cascade delete | No (or null/error/clear) | Yes - delete parent, children deleted |
| Owner of child | Independent | Inherits from parent |
| Sharing | Independent | Inherits from parent |
| Roll-Up Summary support | No | Yes |
| Required at creation | Configurable | Always required |
| Reparenting | Always | Only if "Allow reparenting" checked |
| Standard objects as children | Some | No (custom can be MD child of standard, but Account/Contact/etc. can't be the child) |

### Master-Detail rules

- Child has up to 2 master-detail relationships
- Once 1 MD is on the child, can't be deleted standalone (orphan); convert to Lookup first
- Can convert Lookup → MD only if all existing records have a value in the lookup field

### Roll-Up Summary

Aggregates child records into the parent (Master-Detail only):

- COUNT - count children
- SUM, MIN, MAX - on a numeric / date / currency field
- Filter criteria optional

### Formula fields

Read-only calculated fields. Can reference:

- Other fields on same record
- Parent fields (one level via lookup)
- Owner fields, system fields ($Profile, $User, etc.)
- Metadata via $CustomMetadata

Limit: max compiled size 4000 chars; max formula characters 3,900.

### Cross-object formulas

Reference parent record's fields via lookup (10 levels deep). E.g., on Contact, reference `Account.Name`.

### Hierarchical relationship

Lookup specifically for **User** to **User** (e.g., Manager field on User).

### External ID

Field marked as External ID is indexed and searchable; can be used in upsert operations to match incoming data without Salesforce IDs.

### Global picklists

Define a value set once, reuse across fields/objects. Easier to maintain.

---

## Page layouts

Define which fields, sections, related lists are visible on a record page (in **Salesforce Classic**) or which fields/sections are visible in a Lightning Record Page's Details section.

Per-record-type, per-profile assignment.

### Lightning Record Pages

Modern equivalent built in **Lightning App Builder**. Drag-drop components on a canvas. Page layout still drives the Details section.

---

## Record Types

Different "flavors" of the same object with:

- Different page layouts
- Different picklist values
- Different default values
- Different processes (Sales Process for Opportunity, Lead Process for Lead)

### Common scenarios

- B2B Opportunity vs B2C Opportunity (different stages, fields)
- Prospect Lead vs Existing Customer Lead
- Different regional flavors

### Assigning record types

- **Default record type** per profile
- User can pick from available record types when creating new record
- Profile can be limited to specific record types

---

## Lightning App Builder

Drag-drop component-based page authoring.

### Components

- Standard: Highlights Panel, Activity Timeline, Path, Related Lists, Details, Chatter, etc.
- Custom Lightning Components (built by developers)
- AppExchange components

### Page assignment

- App default
- Per-app
- Per-record-type
- Per-profile

### Component visibility

Filter components to show only when:

- Record field equals some value
- User has specific permissions
- App is a specific app

Powerful for tailoring UI to roles.

---

## Page layout vs Lightning Record Page (LRP)

In Lightning Experience:

- The **Lightning Record Page** is the canvas (what most users see)
- The **Page Layout** is one component on the LRP (specifically, the "Record Detail" section)

You configure:

- Field placement and section structure → Page Layout
- Component layout (Highlights Panel, Path, Related Lists, etc.) → Lightning Record Page

For maximum customization, use Lightning Record Page; minor field tweaks can be done in the Page Layout alone.

---

## Common exam triggers

- "Sum of all child Order Products on Order" → Roll-Up Summary on Master-Detail relationship
- "Two flavors of Opportunity, different stages" → Sales Process + Record Types
- "Mass change picklist value across multiple objects" → Use Global Picklist Value Set
- "Field that's calculated and read-only" → Formula Field
- "Reference parent Account name from Contact record" → Cross-object formula via Account.Name
- "Match incoming data to existing records by an external system's ID" → External ID field + Upsert via Data Loader
- "Hide a section from sales but show to finance" → Field-Level Security or different page layouts per profile
- "Different page when record type = New" → Lightning Record Page with component visibility filter on Record Type
- "User-to-User reference (manager)" → Hierarchical relationship field
- "Prevent orphan records when a parent is deleted" → Use Master-Detail (auto cascade)
- "Allow orphan records (parent can be deleted independently)" → Use Lookup
