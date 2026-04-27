# 04 - Automation: Flow, Validation, Approvals

## Salesforce automation history

Multiple tools have existed; consolidation toward Flow is the modern story:

| Tool | Status |
|---|---|
| **Workflow Rules** | Deprecated for new dev; existing rules still work |
| **Process Builder** | Deprecated for new dev; existing processes still work |
| **Flow Builder** | The current standard - covers all use cases |
| **Approval Processes** | Active; functionality moving into Flow Approvals |
| **Apex Triggers** | Code-based; for what Flow can't do |
| **Validation Rules** | Active; use for save-time field validation |

For new automation, **always use Flow** unless you need an approval process not yet supported in Flow.

---

## Flow Builder

Modern automation. Multiple flow types for different triggers.

### Flow types

| Type | Trigger | Use |
|---|---|---|
| **Screen Flow** | User-initiated (button, action, lightning component) | Wizards, guided UI |
| **Record-Triggered Flow** | Record save (before/after) | Replaces Workflow Rules + Process Builder |
| **Scheduled-Triggered Flow** | Schedule (daily, weekly, etc.) | Periodic batch operations |
| **Auto-Launched Flow** | Called from Apex, Process, button | Reusable subflows |
| **Platform Event Flow** | Platform Event published | Reactive, integration |

### Record-Triggered Flow timing

- **Before save** - ultra-fast; modify the record before insert/update
- **After save** - run after commit; can do related-record updates, callouts, etc.
- **Asynchronous** - run after-save in a delayed transaction (good for callouts, heavy logic)

### Common Flow elements

- **Get Records** - query
- **Create Records** - insert
- **Update Records** - update
- **Delete Records** - delete
- **Decision** - branching
- **Loop** - iterate over collection
- **Assignment** - set variables
- **Subflow** - call another flow
- **Action** - call out: Apex action, send email, post to Chatter, etc.
- **Screen** - UI elements (Screen Flow only)
- **Wait** - pause until time / event (Scheduled-Triggered or pause element)

### Variables and resources

- **Variables** - mutable values within flow
- **Constants** - fixed values
- **Formulas** - computed values
- **Choices** - picklist source for screens
- **Stages** - flow progress milestones (UI in Screen Flow)

### Best practices

- One record-triggered flow per object per timing (before vs after) - consolidate into one Flow with Decision elements
- Bulkify by working with collections, not single records
- Test in sandbox before deploying

---

## Validation Rules

Formula-based field-level validation. Returns TRUE → block save with error message.

### Examples

#### Date in future

```
AND(
    ISCHANGED(CloseDate__c),
    CloseDate__c < TODAY()
)
```

Error: "Close Date cannot be in the past."

#### Required field conditional on another

```
AND(
    ISPICKVAL(Status__c, "Closed Won"),
    ISBLANK(Final_Amount__c)
)
```

Error: "Final Amount is required when status is Closed Won."

#### Format validation

```
NOT(REGEX(Phone__c, "^\\+?[0-9]{10,15}$"))
```

Error: "Phone must be 10-15 digits."

### Where validation runs

- Triggered on every save
- Skipped during certain bulk operations (Data Loader option to skip)
- Can be bypassed with profile permission "Modify All Data" if rule has IF($Permission.Modify_All) clause

### Validation Rule vs Required Field

- Required field via field definition - applied universally
- Required via page layout - applied only via that layout's UI
- Validation rule - flexible (can require conditionally, format-check, cross-field check)

---

## Approval Processes

Multi-step approvals with submit, approve/reject, escalation.

### Components

- **Process definition** - what triggers it (criteria), entry actions, who approves
- **Steps** - sequential approval steps (with manager hierarchy or specific users)
- **Initial / Final / Recall actions** - field updates / email alerts when transitioning
- **Approver options** - automatically assigned (manager / role) or specifically named

### Common patterns

- Discount > 20% → Manager approval → Director approval
- Capital expense > $10,000 → Finance approval
- Contract approval workflow

### Limitations

- One approval at a time per record (no parallel processes per object)
- Hard to handle complex conditional approvals → migrate to Flow with approval components

### Flow-based approvals (modern)

Newer Salesforce releases bring approvals into Flow with the **Approval action**. More flexible (parallel approvals, dynamic approvers).

---

## Email automation

### Email Templates

- **Lightning Email Templates** - modern, with merge fields
- **Classic Email Templates** - older format (HTML, Text, Visualforce)

Used in:

- Email actions (in Flow)
- Approval Process notifications
- Manual sending from record pages
- Mass email via Reports

### Email Alerts

A predefined email + recipients. Used as an action in Flow / Process / Approval.

### Mass Email

Send to up to 5,000 recipients per day from a Report. Subject to Salesforce email deliverability.

### Email Deliverability

Setup → Email Deliverability. Three modes:

- **No access** - blocks all outbound email (sandbox default)
- **System email only** - allows system-generated email
- **All email** - normal production setting

Watch this in **Sandboxes** - default is "No access" so test emails won't send.

---

## Common exam triggers

- "Run logic when Opportunity stage changes to Closed Won" → Record-Triggered Flow with Decision element on Stage
- "Block save unless Phone is in valid format" → Validation Rule
- "Two-step approval: manager then VP, conditional on amount" → Approval Process or Flow Approval
- "Send email when case is escalated" → Email Alert from a Flow or Approval
- "Auto-close cases older than 30 days" → Scheduled-Triggered Flow daily
- "User clicks button → wizard collects info → creates records" → Screen Flow
- "Batch update 10,000 records based on Lead Source change" → Record-Triggered Flow on Lead with bulkified Update Records element (or async Flow for callouts)
- "Run a flow from Apex code" → Auto-Launched Flow

---

## Decision matrix: which automation tool?

| Need | Tool |
|---|---|
| Block save based on field values | Validation Rule |
| Multi-step manual approval workflow | Approval Process (or Flow Approval) |
| Modify record on save | Before-save Record-Triggered Flow |
| Update related records on save | After-save Record-Triggered Flow |
| Periodic batch job | Scheduled-Triggered Flow |
| User-driven multi-screen wizard | Screen Flow |
| Call from button on record page | Screen Flow or Action button → Auto-Launched Flow |
| Heavy compute, complex logic Flow can't handle | Apex Trigger (developer territory) |
| Conditional UI changes | Lightning Record Page component visibility (declarative) |

For most admin-tier needs, **Flow + Validation Rules + Approval Processes** cover 90%+ of use cases.
