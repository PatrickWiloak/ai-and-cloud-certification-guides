# Salesforce Administrator - 6-Week Practice Plan

This plan assumes 1-2 hours of theory + 1-2 hours of hands-on lab per day.

You **cannot** pass this cert without hands-on time. Most exam questions are scenario-based. Get into a Developer Edition org early and stay there.

---

## Lab setup (Week 1, Day 1)

- [ ] Sign up for [Salesforce Developer Edition](https://developer.salesforce.com/signup) - free, permanent dev org
- [ ] Sign up for [Trailhead](https://trailhead.salesforce.com/) - free training platform with hands-on Trailhead Playgrounds
- [ ] Bookmark the **["Prepare for Your Salesforce Administrator Credential"](https://trailhead.salesforce.com/users/strailhead/trailmixes/administrator-certification-prep)** Trailmix

---

## Week 1 - Org Setup, Users, Security

### Reading
- [ ] [README.md](./README.md) full read
- [ ] [fact-sheet.md](./fact-sheet.md) skim
- [ ] [notes/01-org-setup-and-security.md](./notes/01-org-setup-and-security.md)
- [ ] Trailhead: "Picking the Right Sharing Settings" + "User Authentication" modules

### Hands-on
- [ ] Tour Setup; learn search-based navigation (`?` shortcut for Setup search)
- [ ] Create 2 custom users with different profiles (Standard User, Marketing User)
- [ ] Create a custom profile based on Standard User
- [ ] Create a Permission Set granting "API Enabled" + "View Setup and Configuration"
- [ ] Configure Org-Wide Defaults for Account / Contact / Opportunity
- [ ] Build a 3-level Role Hierarchy
- [ ] Create a criteria-based Sharing Rule

### Self-check
- [ ] Can I describe the 5+ layers of access (OWD, Role, Sharing Rules, Manual)?
- [ ] Do I know Profile vs Permission Set?

---

## Week 2 - Objects, Fields, Page Layouts

### Reading
- [ ] [notes/02-objects-fields-page-layouts.md](./notes/02-objects-fields-page-layouts.md)
- [ ] Trailhead: "Customize the Salesforce Object Manager" + "Page Layouts and Record Types" modules

### Hands-on
- [ ] Create a Custom Object "Inspection" with fields (Date, Location, Inspector lookup to User, Result picklist, Notes long text)
- [ ] Add a Master-Detail relationship from "Inspection Item" to "Inspection"
- [ ] Add a Roll-Up Summary on Inspection: SUM of Inspection Items
- [ ] Create 2 Record Types on Inspection: "Annual" vs "Quarterly", each with different page layouts
- [ ] Build a Lightning Record Page with conditional component visibility per record type

### Self-check
- [ ] Can I list 5+ field types and when to use each?
- [ ] Do I know Lookup vs Master-Detail tradeoffs?
- [ ] Can I configure Record Types with different page layouts?

---

## Week 3 - Data Management

### Reading
- [ ] [notes/03-data-management.md](./notes/03-data-management.md)
- [ ] Trailhead: "Data Management" trail

### Hands-on
- [ ] Install Data Loader (free download)
- [ ] Bulk insert 1,000 Accounts via Data Loader
- [ ] Upsert (update + insert) 500 records using an External ID field
- [ ] Configure Duplicate Rule + Matching Rule for Accounts
- [ ] Run Mass Transfer of Accounts from one user to another
- [ ] Configure weekly Data Export schedule
- [ ] Tour Sandboxes (Setup → Sandboxes; you may need to imagine a Production org for cert prep)

### Self-check
- [ ] Can I pick the right import tool for a given record count?
- [ ] Do I know the upsert pattern with External ID?
- [ ] Can I describe Sandbox types and their use cases?

---

## Week 4 - Automation: Flow, Validation, Approvals

### Reading
- [ ] [notes/04-automation-flow-validation.md](./notes/04-automation-flow-validation.md)
- [ ] Trailhead: "Build Flows with Flow Builder" + "Approval Processes" trails

### Hands-on
- [ ] Validation Rule: block save if Opportunity Close Date is in the past
- [ ] Record-Triggered Flow (before save): set Account Type based on Industry
- [ ] Record-Triggered Flow (after save): when Opportunity stage = Closed Won, send email + create a follow-up Task
- [ ] Screen Flow: button on Account that creates a Contact via wizard
- [ ] Approval Process: 2-step approval (Manager + Director) for Opportunities > $100,000

### Self-check
- [ ] Can I write a Validation Rule formula from memory?
- [ ] Do I know when to use before-save vs after-save Flow?
- [ ] Can I configure a multi-step Approval Process?

---

## Week 5 - Reports, Dashboards, Sales/Service Cloud

### Reading
- [ ] [notes/05-reports-dashboards-apps.md](./notes/05-reports-dashboards-apps.md)
- [ ] Trailhead: "Reports & Dashboards for Lightning Experience" trail
- [ ] Trailhead: "Service Cloud Basics" + "Sales Cloud Basics"

### Hands-on
- [ ] Build a Custom Report Type joining Account + Opportunity
- [ ] Create Tabular, Summary, and Matrix reports from it
- [ ] Build a 6-component Dashboard
- [ ] Schedule report subscription
- [ ] Configure Web-to-Lead form
- [ ] Configure Email-to-Case
- [ ] Set up Case Assignment Rule + Auto-Response Rule
- [ ] Tour Service Console + Knowledge

### Self-check
- [ ] Can I build a Custom Report Type with related objects?
- [ ] Do I know report formats and when to use each?
- [ ] Can I describe Lead conversion (creates Account + Contact + Opportunity)?

---

## Week 6 - Practice Exams + Weak Areas

### Reading
- [ ] Re-read [fact-sheet.md](./fact-sheet.md) cover to cover
- [ ] Work through [scenarios.md](./scenarios.md)

### Practice exams
- [ ] [Trailhead Admin Trailmix practice questions](https://trailhead.salesforce.com/users/strailhead/trailmixes/administrator-certification-prep)
- [ ] FocusOnForce Admin practice exams (paid; widely used)
- [ ] Salesforce Ben practice questions
- [ ] [resources/practice-questions/](../../../resources/practice-questions/) - Salesforce Admin questions if added
- [ ] Score 80%+ on the same practice exam twice in a row

### Drill weak areas
- [ ] Identify 3-5 weakest topics
- [ ] Re-read those notes
- [ ] Build a Trailhead module-specific lab for each

### Schedule the exam
- [ ] Book through [Salesforce Trailhead](https://trailhead.salesforce.com/credentials/administrator)
- [ ] Choose online proctored or testing center
- [ ] Confirm 105-minute slot

---

## Stop signals (you're ready)

- [ ] You can configure a custom object with relationships, page layouts, record types from memory
- [ ] You can describe the 7-layer sharing model and pick the right tool for any access scenario
- [ ] You can build a Record-Triggered Flow with Decisions and related-record updates
- [ ] You score 80%+ on practice exams twice in a row
- [ ] You can solve scenarios in [scenarios.md](./scenarios.md) without notes

When all are true, schedule the exam.
