# ServiceNow CSA - Fact Sheet

High-yield reference. Skim weekly. Memorize the table hierarchy, ACL evaluation order, and GlideRecord patterns.

## Quick Reference

**Exam:** ServiceNow Certified System Administrator
**Cost:** $300 USD
**Format:** 60 multi-choice / multi-answer
**Duration:** 90 minutes
**Passing:** ~70% (not officially published)
**Prereq:** Now Learning "ServiceNow System Administration Fundamentals" path
**Maintenance:** Per-release delta exam

**[Now Learning - CSA path](https://nowlearning.servicenow.com/lxp/en/now-platform/certified-system-administrator)**
**[Personal Developer Instance](https://developer.servicenow.com/dev.do)**
**[Product Docs](https://www.servicenow.com/docs/)**
**[Developer API Reference](https://developer.servicenow.com/dev.do#!/reference)**

---

## Now Platform basics

### What ServiceNow is

A multi-instance SaaS platform. Each customer gets one or more dedicated **instances** (`<name>.service-now.com`). All instance code runs on shared infrastructure, but each instance has its own database schema, configuration, and update set chain.

### Instance types (typical customer landscape)

- **Sub-prod** instances: Dev, Test, UAT, Sandbox.
- **Prod** instance: the live system.
- Update sets flow Dev → Test → Prod (or via release pipelines).
- Each instance is independently licensed, sized, and patched.

### Releases (current and recent)

ServiceNow names releases after cities, alphabetically (semi-strict). Two majors per year.

| Release | Note |
|---|---|
| **Zurich** | current latest |
| Yokohama | |
| Xanadu | |
| Washington DC | |
| Vancouver | |
| Utah, Tokyo, San Diego, Rome, Quebec, Paris | older |

The CSA exam tracks the current platform UI (Next Experience).

### UI surfaces

- **Next Experience UI** - modern UI, default since San Diego. Polaris design.
- **Service Portal** - end-user self-service portal (cards, knowledge, catalog).
- **Now Mobile** / Mobile Agent - mobile apps.
- **UI Builder** - declarative builder for custom workspaces (replacing legacy UI16 customizations).
- **Classic UI / UI16** - legacy, still supported but not the focus of the exam.

### Application Navigator

- Left-side filter at top: **Filter Navigator** (or `Ctrl+Shift+F`).
- Three tabs: All, Favorites, History.
- Modules grouped under applications. Module = link to a list/form/UI page.
- "All" search supports fuzzy module names ("incidnt").

### Lists, forms, and dot-walking exist on every table

Almost everything is a row in a table. Tables show as **lists**, individual records show as **forms**. References between tables enable **dot-walking** through relationships in conditions, scripts, and reports.

---

## Roles, users, groups

### Built-in roles

| Role | What it grants |
|---|---|
| **admin** | Full access; can elevate to **security_admin** for high-security operations. |
| **itil** | Standard fulfiller (read/write tasks: Incident, Problem, Change, Request). |
| **itil_admin** | Manage ITIL configuration. |
| **approver_user** | Can approve/reject approval records. |
| **knowledge** / **knowledge_admin** | Read/write Knowledge articles. |
| **catalog** / **catalog_admin** | Use / administer Service Catalog. |
| **report_user** / **report_admin** | Use / build reports. |

### Elevated privileges (security_admin)

Many high-impact actions (editing ACLs on the `sys_security_acl` table, system properties affecting security) require **elevating to security_admin** even if you have admin. User menu → Elevate Privileges → security_admin. Lasts for the session.

### Groups

Records in `sys_user_group`. Used for assignment, approvals, notifications, ACL conditions. Users inherit roles via group membership.

### Role inheritance

Roles can contain other roles. Users get the union of all roles from direct assignment + group membership + role-contains-role chains. View effective roles on the user form.

---

## Table hierarchy (memorize this)

ServiceNow uses **table inheritance**. Child tables extend parents and inherit fields. Records in child tables are also visible (with parent fields) when querying the parent.

### Core hierarchy

```
sys_metadata                       (everything that is "configuration")
sys_user                           (users)
sys_user_group                     (groups)
sys_attachment                     (attachments)

task                               (parent of all work items)
├── incident                       (something broken)
├── problem                        (root cause investigation)
├── change_request                 (planned change)
│   ├── std_change_proposal
│   └── change_task
├── sc_request                     (request from catalog - the "header")
│   └── sc_req_item                (requested item, the "RITM")
│       └── sc_task                (catalog task - work for fulfiller)
├── kb_submission
└── (custom task tables you create)

cmdb                               (root of CMDB)
└── cmdb_ci                        (Configuration Item base)
    ├── cmdb_ci_computer
    │   ├── cmdb_ci_server
    │   └── cmdb_ci_pc
    ├── cmdb_ci_network_gear
    ├── cmdb_ci_appl               (application)
    └── cmdb_ci_service            (business / technical service)
```

### What this means in practice

- A query on `task` returns Incidents, Problems, Changes, Requests, RITMs, Catalog Tasks together.
- `cmdb_ci` is the parent of all configuration items - querying it returns all CI types.
- Custom tables can extend `task` to inherit assignment, state, work notes, SLAs.

### Key system tables

| Table | Stores |
|---|---|
| `sys_user` | Users |
| `sys_user_group` | Groups |
| `sys_user_role` | Roles |
| `sys_user_has_role` | User-role assignments |
| `sys_user_grmember` | User-group membership |
| `sys_dictionary` | Field definitions for every table |
| `sys_db_object` | Tables themselves |
| `sys_security_acl` | ACL rules |
| `sys_choice` | Choice list values |
| `sys_properties` | System properties |
| `sys_script` | Business rules |
| `sys_script_client` | Client scripts |
| `sys_ui_policy` | UI policies |
| `sys_app` / `sys_scope` | Applications and scopes |
| `sys_update_set` | Update sets |
| `sys_update_xml` | Update set entries |

---

## Fields, dictionary, dot-walking

### Field naming

- Every field has a `name` (column) and a `label` (display).
- Custom fields auto-prefix with `u_` (e.g., `u_business_owner`). Setting it differently requires changing the system property; convention is to keep `u_`.

### Common field types

| Type | Notes |
|---|---|
| String | Text. Define max length in dictionary. |
| Integer / Decimal / Float | Numeric. |
| Boolean | True/false checkbox. |
| Choice | Dropdown of `sys_choice` values. |
| Date / Date/Time | Temporal. Stored UTC. |
| Reference | FK to another table. Renders as autocomplete. |
| Glide List | Multi-reference (comma-separated sys_ids). |
| List | Multi-value choice. |
| Document ID | Reference where the table is also chosen at runtime. |
| Journal / Journal Input | Append-only log (work notes, comments). |
| HTML / URL / Email | Validated string subtypes. |
| Currency / Price | Currency-aware numeric. |
| Script | Multi-line script field. |

### Dot-walking

In any condition, list filter, report, or script, you can traverse a reference field with `.`:

```
incident.caller_id.manager.email
```

That walks: Incident → Caller (sys_user) → Manager (sys_user) → email field. Dot-walking is the single most ServiceNow-y thing on the exam.

### Reference qualifiers

Filter what shows up in a reference field's autocomplete. Two types:

- **Simple** - condition builder.
- **Dynamic** - script that returns an encoded query.
- **Advanced** - script that returns a sys_id list.

Example: a Change form's `assigned_to` field could use a reference qualifier `active=true^roles=itil` to only show active fulfillers.

---

## Relationships

### One-to-many

A reference field on the child table pointing to a row on the parent. Default. Example: `incident.assigned_to` references `sys_user`.

### Many-to-many

Implemented with a join table (a third table with two reference fields). ServiceNow lets you define this declaratively via **Many-to-Many Definition** (System Definition → Relationships → Many to Many).

Common existing many-to-many: `sys_user_grmember` (user ↔ group), `cmdb_rel_ci` (CI ↔ CI relationships).

### Extension vs reference

- **Extends**: child table inherits all parent fields, can add its own. Records in child are records in parent (via inheritance).
- **References**: child holds a sys_id pointer to parent. Independent records.

Pick **extends** when "X is a kind of Y" (Incident IS-A Task). Pick **reference** when "X has a Y" (Incident has an Assignee).

---

## GlideRecord (server-side query API)

The cornerstone of server scripting. Query, iterate, update tables. Runs in business rules, script includes, scheduled jobs, fix scripts.

### Basic query and iterate

```javascript
var gr = new GlideRecord('incident');
gr.addQuery('active', true);
gr.addQuery('priority', '<=', 2);
gr.orderBy('number');
gr.query();
while (gr.next()) {
    gs.info('Incident: ' + gr.number + ' / ' + gr.short_description);
}
```

### Common methods

| Method | What it does |
|---|---|
| `addQuery(field, op, value)` | Add a condition. Op defaults to `=`. |
| `addEncodedQuery('a=b^c=d')` | Add a Condition Builder-style encoded query string. |
| `orderBy('field')` / `orderByDesc('field')` | Sort. |
| `query()` | Execute the query. |
| `next()` | Advance to next row; returns false when done. |
| `setLimit(n)` | Cap result count. |
| `getRowCount()` | How many rows matched (avoid on large tables). |
| `get('sys_id')` or `get('field', 'value')` | Fetch a single record by sys_id or unique field. |
| `setValue(field, value)` | Set a field. |
| `update()` | Persist changes for the current row. |
| `insert()` | Insert a new record. |
| `deleteRecord()` | Delete the current record. |
| `initialize()` | Prepare a new empty record before `insert()`. |

### Insert example

```javascript
var task = new GlideRecord('sc_task');
task.initialize();
task.short_description = 'Provision laptop';
task.assignment_group.setDisplayValue('Hardware');
task.priority = 3;
var sysId = task.insert();
gs.info('Created task ' + sysId);
```

### Update example

```javascript
var inc = new GlideRecord('incident');
if (inc.get('number', 'INC0010001')) {
    inc.state = 6; // Resolved
    inc.close_code = 'Solved (Permanently)';
    inc.close_notes = 'Cleared cache.';
    inc.update();
}
```

### Encoded queries

Built in the list view via the condition builder, copied with right-click "Copy query". Useful in scripts:

```javascript
gr.addEncodedQuery('active=true^priority<=2^assignment_groupISNOTEMPTY');
```

### GlideRecord vs GlideRecordSecure

- `GlideRecord` ignores ACLs (system-level).
- `GlideRecordSecure` honors the running user's ACLs.
- Server-side scripts run as system by default, so use `GlideRecordSecure` when you need to respect the caller's permissions.

---

## GlideAjax (client → server bridge)

Client scripts run in the browser and have no `GlideRecord`. To query the server, call a Script Include via **GlideAjax**.

### Script Include (server-side)

```javascript
var GetManagerEmail = Class.create();
GetManagerEmail.prototype = Object.extendsObject(AbstractAjaxProcessor, {
    getEmail: function() {
        var userSysId = this.getParameter('sysparm_user');
        var user = new GlideRecord('sys_user');
        if (user.get(userSysId) && user.manager) {
            return user.manager.email + '';
        }
        return '';
    },
    type: 'GetManagerEmail'
});
```

Mark the Script Include **Client callable = true**.

### Client script (calls it)

```javascript
function onChange(control, oldValue, newValue, isLoading) {
    if (isLoading || newValue === '') return;
    var ga = new GlideAjax('GetManagerEmail');
    ga.addParam('sysparm_name', 'getEmail');
    ga.addParam('sysparm_user', newValue);
    ga.getXMLAnswer(function(answer) {
        g_form.setValue('u_manager_email', answer);
    });
}
```

### Common client APIs

- `g_form` - read/write the current form. `getValue`, `setValue`, `setMandatory`, `setReadOnly`, `setVisible`, `addInfoMessage`, `addErrorMessage`.
- `g_user` - current user info: `userID`, `userName`, `hasRole('itil')`.
- `GlideAjax` - call server-side Script Include.

---

## Business rules vs client scripts vs UI policies

Pick the right tool. The exam tests this distinction repeatedly.

### Business Rules (server-side)

Run in the database transaction when records are inserted, updated, deleted, queried.

| When | Use case |
|---|---|
| **before** insert/update | Mutate the record before it's saved. Example: derive a field. Use `current.field = ...`. |
| **after** insert/update | React to a save. Example: create a related record. |
| **async** | Run after-save in a separate thread. Use for non-blocking integration calls. |
| **display** | Run on form load, populate `g_scratchpad` for client scripts. |

Available variables: `current` (the record), `previous` (pre-update values), `g_scratchpad` (display-rule bridge to client).

### Client Scripts (browser)

Run in the user's browser when forms load or fields change.

| Type | Fires |
|---|---|
| **onLoad** | Form first renders. |
| **onChange** | A specific field changes. |
| **onSubmit** | User clicks Save/Submit; can `return false` to block. |
| **onCellEdit** | Inline list cell edit. |

Use for: real-time validation, conditional UI based on data not just field values, calling server via GlideAjax.

### UI Policies (declarative client-side)

Declarative way to say "when condition X is true on this form, set fields Y mandatory/visible/read-only".

Prefer UI Policies over onChange client scripts when the rule is simple field-state changes - they are faster, easier to maintain, and visible to admins without reading code.

### Choosing

| Need | Use |
|---|---|
| Compute / derive a field on save | **before-update** Business Rule |
| Block save unless server-side condition passes | **before-update** Business Rule with `current.setAbortAction(true)` |
| Validate on submit, blocking save in browser | **onSubmit** Client Script returning false |
| Make field mandatory when another field has a value | **UI Policy** |
| Hide a field for users without a role | **UI Policy** with role condition (or ACL for security-critical) |
| Auto-populate field from a reference's manager | **onChange** Client Script + GlideAjax |
| Trigger downstream record creation on insert | **after-insert** Business Rule |
| Slow integration call on save | **async** Business Rule |

---

## ACL evaluation (memorize)

ACLs (`sys_security_acl`) gate read/write/create/delete on tables and fields.

### ACL types

- **Table-level**: `incident.None` (the whole record on `incident`).
- **Field-level**: `incident.short_description` (a specific field).
- **Wildcard field**: `incident.*` (default for fields not otherwise covered).

### Operations

`read`, `write`, `create`, `delete`. Plus `execute` (UI Action), `add_to_list`, etc.

### Evaluation order (the rule)

For a given operation on a given record/field, ServiceNow evaluates:

1. **Match the most specific ACL first**, in this priority:
   - `table.field` (specific field on this table)
   - `table.*` (wildcard field on this table)
   - `parent_table.field` (specific field on a parent table, walking up the inheritance chain)
   - `parent_table.*` (wildcard on a parent table)
2. For a matching ACL, the user is granted access **only if all three pass**:
   - **Roles** - user has at least one listed role (or no roles required).
   - **Condition** - the condition builder passes.
   - **Script** - the script returns `true` (or no script).
3. If multiple ACLs exist at the same specificity, the user needs to pass **at least one** of them (OR among same level).
4. If no ACL exists at any level for that operation, access is **denied** by default (after the High Security Plugin / since Geneva).

### Practical implications

- A field-level ACL can deny access even if the table-level ACL grants it (most specific wins).
- ACLs run for **every record and every field** - keep scripts cheap.
- Test ACLs by impersonating the user (User menu → Impersonate User).

### High Security Settings

Plugin enabled by default since Geneva. Adds default-deny, requires elevation to security_admin to edit security ACLs, blocks several risky default behaviors.

---

## Update Sets vs Source Control

### Update sets (the standard)

Track configuration changes (records on tables flagged as configuration in their dictionary) so you can move them between instances.

- An update set is a record on `sys_update_set`. Each captured change is a row on `sys_update_xml` (the metadata as XML).
- **Current update set** is per-user, set in the user menu. Every config change you make goes there until you switch.
- Workflow: develop in Dev → mark update set Complete → export XML or use Retrieved Update Sets → import in Test/Prod → preview → commit.

### What's tracked vs not

- Tracked: business rules, client scripts, UI policies, ACLs, table changes, dictionary, reports, flows, form layouts.
- Not tracked (data, not config): records on data tables (incidents, users, CIs). Move data via XML export, import sets, or Transform Maps.

### Update set best practices

- One feature per update set; descriptive names.
- Don't reopen a Completed set.
- Preview before commit; resolve **collisions** (same record changed differently on the target).
- Be mindful of **batches** - parent batches commit child sets in order.

### Source control (newer alternative)

Scoped applications can connect to **Git** (Studio → Source Control). Pushes app metadata as XML files to a Git repo. Pull/merge in Studio.

- Used for **scoped applications**, not the global scope.
- Branches per environment or per feature.
- Replaces the manual update set chain for app development.
- Studio integrates with GitHub, GitLab, Bitbucket, generic Git.

### Update sets vs source control - exam choice

- "Customer wants to deploy a customization from Dev to Prod" → **update set**.
- "Team developing a custom scoped app wants version control" → **source control**.
- "Deploy global-scope changes" → **update set** (source control is scoped-app only).

---

## Service Catalog

Catalog items show up in the Service Portal as request cards. End-users fill out a form and submit; ServiceNow creates a Request (REQ) → Requested Item (RITM) → Catalog Tasks (SCTASK) chain.

### Catalog item types

- **Catalog Item** - standard request (e.g., "New laptop").
- **Record Producer** - creates a record on any table (commonly used for "Submit an Incident" forms).
- **Order Guide** - bundles multiple catalog items.
- **Content Item** - static info card.

### Variables

Variables on a catalog item define the form fields. Stored in `item_option_new`. Types include: single-line text, multi-line, choice, reference, lookup select box, checkbox, attachments.

### Variable Sets

Reusable groups of variables. Apply to multiple catalog items.

### Workflow on a catalog item

Originally **Workflow Editor** (legacy graphical workflow). **Flow Designer is the modern replacement** - all new automation should use Flow Designer. Legacy workflows still run; new development should be in Flow Designer.

### Process flow

```
User submits → sc_request (REQ) created
            → sc_req_item (RITM) per catalog item
            → flow / workflow generates sc_task records
            → fulfillers complete tasks
            → RITM closes when all tasks complete
            → REQ closes when all RITMs close
```

---

## Flow Designer (replaces Workflow Editor)

Modern declarative automation tool. Replaces legacy Workflow Editor for new development.

### Core concepts

- **Flow** - a sequence of triggers, actions, decisions, loops.
- **Trigger** - what starts the flow: record change, schedule, inbound REST, catalog item submission.
- **Action** - a step (Create Record, Update Record, Send Email, Approval, Ask for Approval, REST step, Script step).
- **Subflow** - reusable flow callable from another flow.
- **Action Designer** - build custom actions.

### Flow vs Subflow vs Action

| Type | Use |
|---|---|
| **Flow** | Top-level automation with a trigger. |
| **Subflow** | Reusable logic called from flows; has inputs/outputs. |
| **Action** | Lowest-level reusable step (often wrapping a script or REST call). |

### Workflow Editor (legacy)

Drag-drop graphical workflow editor. Uses activities like "Approval", "Run Script", "Notification". Still ships with the platform; existing catalog items often still use it. **Don't build new ones here**.

---

## Knowledge Management

### Knowledge Base (KB) and articles

- Articles live in `kb_knowledge`.
- Organized into **Knowledge Bases** (top-level) → **Categories** → **Articles**.
- States: Draft → Review → Published → Retired.
- Versioning, feedback, ratings, view counts.

### User criteria

Controls who can read or contribute. Per-KB and per-article. Based on roles, groups, departments, etc.

### Knowledge in incident form

Fulfillers can search KB inline on the Incident form. "Attach knowledge" links the article on the work notes.

---

## Reports and Dashboards

### Report types

- **List** - simple list of records.
- **Bar / Pie / Donut / Column** - categorical visualizations.
- **Line / Time series** - trends over time.
- **Pivot Table** - row x column aggregates.
- **Single Score** - one metric (count, sum, avg).
- **Multi-level Pivot** - more than two grouping dimensions.
- **Map** - geographic.
- **Calendar** - records on a calendar.
- **Heatmap**.

### Sources

- **Table** - any table.
- **Report Source** - reusable saved query.

### Sharing

- **Visibility**: Me, Everyone, Specific groups/roles/users.
- **Schedule**: email PDF/CSV on cron schedule.

### Dashboards

- Dashboards display reports and other widgets in a layout.
- **Tabs** for grouping. **Filters** apply across the dashboard.
- **Performance Analytics widgets** layer trend/breakdown analytics if PA is licensed.

### Performance Analytics (intro)

Premium product. Snapshots data over time into **indicators** (KPIs) and **breakdowns**. Provides trend lines, forecasts, score thresholds. Beyond CSA scope but tested at a "what is it" level.

---

## System Properties

Configuration settings stored on `sys_properties`. Affect platform behavior.

- Set via Setup → System Properties (or `sys_properties.list` directly).
- Examples: `glide.ui.session_timeout`, `glide.email.smtp.active`, `instance_name`.
- Use `gs.getProperty('name', 'default')` in scripts.

System properties in **System Properties → System Security** include the High Security Settings flags.

---

## Common exam triggers

| Question pattern | Answer |
|---|---|
| "Which tool to declaratively make a field mandatory based on another field?" | **UI Policy** |
| "Run logic in browser before save, blocking submit on invalid data" | **onSubmit Client Script** |
| "Run logic on the server before insert to mutate the record" | **before-insert Business Rule** |
| "Move customizations from Dev to Prod" | **Update Set** |
| "Version control a custom scoped app across team" | **Source Control (Studio)** |
| "Build a new automated workflow today" | **Flow Designer** |
| "Replaces Workflow Editor for new automation" | **Flow Designer** |
| "Allow client script to query a record on the server" | **GlideAjax + client-callable Script Include** |
| "Iterate over many records, updating each" | **GlideRecord while(gr.next()) { gr.update(); }** |
| "Pull manager.email from caller_id field on Incident" | **Dot-walking: caller_id.manager.email** |
| "Restrict who sees a field on a form per role" | **Field-level ACL** (or UI Policy if non-security) |
| "Order to evaluate ACLs" | **Most specific (table.field) wins, then table.*, then parent inheritance** |
| "Many users → many groups" | **Many-to-many via sys_user_grmember (existing join table)** |
| "Customize what shows up in a reference field" | **Reference qualifier** |
| "Reusable group of variables on multiple catalog items" | **Variable Set** |
| "Top-level work item every other task table extends" | **task** table |
| "Top-level CMDB CI table" | **cmdb_ci** |

---

## Highest-yield facts

1. **`task`** is the parent of Incident, Problem, Change, sc_request, sc_req_item, sc_task. Inheritance, not reference.
2. **`cmdb_ci`** is the parent of all CIs (server, network gear, application, service).
3. **`sys_user`**, **`sys_user_group`**, **`sys_user_grmember`** are the user/group/membership tables. The membership table is the canonical many-to-many example.
4. **GlideRecord** = server query API. **GlideAjax** = client → Script Include bridge. **g_form** = client form API.
5. **Business Rule when**: before / after / async / display. Pick before for mutation, after for downstream side effects, async for slow.
6. **UI Policy** is declarative, **Client Script** is scripted. Prefer UI Policy when you can.
7. **ACL evaluation**: most specific (table.field) wins; user must pass roles AND condition AND script; multiple ACLs at same level are OR.
8. **`security_admin` elevation** is required to edit security-critical ACLs and properties even if you're admin.
9. **Dot-walking** through reference fields with `.` works in conditions, lists, reports, and scripts.
10. **Update sets** move config between instances; **source control** (Git) is for scoped apps.
11. **Flow Designer replaces Workflow Editor** - build new automation in Flow Designer.
12. **REQ → RITM → SCTASK** is the catalog request hierarchy.
13. **`u_` prefix** identifies custom fields by convention.
14. **Reference qualifier** filters reference field autocomplete via static condition, dynamic script, or advanced sys_id list.
15. **Personal Developer Instance (PDI)** is the free, dedicated practice instance. Use it daily.
