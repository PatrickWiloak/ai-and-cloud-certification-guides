---
last-updated: 2026-05-03
---

# ServiceNow CSA - Practice Plan

A 6-week study plan for the ServiceNow Certified System Administrator (CSA) exam. Pace assumes 5-7 hours per week. Adjust if you already work in a ServiceNow instance daily (4 weeks is enough) or are completely new to the platform (extend to 8 weeks).

Prerequisite: complete the **Now Learning "ServiceNow System Administration Fundamentals"** course required for voucher access. The exam blueprint maps directly to this course.

## Setup (week 0)

- [ ] Sign up for a [Personal Developer Instance (PDI)](https://developer.servicenow.com/dev.do)
- [ ] Confirm your PDI runs the same release the cert blueprint references (Zurich at time of writing)
- [ ] Bookmark the [CSA exam blueprint](https://nowlearning.servicenow.com/lxp/en/now-platform/certified-system-administrator)
- [ ] Read [README.md](./README.md) and [fact-sheet.md](./fact-sheet.md) end to end

## Week 1 - Platform Overview (Domain 1, 15%)

**Concepts:** instance architecture, application navigator, modules, Next Experience UI, roles, ACL evaluation order, update sets.

- [ ] Read fact-sheet sections on architecture and navigation
- [ ] Login to PDI, walk through application navigator, filter navigator, and the role of the impersonator
- [ ] Lab: create a user, assign roles (`itil`, `admin`, custom), test what each role can see
- [ ] Lab: capture a small change in an update set, export, import to a new sub-instance

## Week 2 - Lists, Forms, and Tasks (Domain 2, 20%)

**Concepts:** list views, list editing, personalize list, form sections, form layout, related lists, task table model, approval flows.

- [ ] Lab: customize a list view (columns, filters, group-by); save as personal vs everyone
- [ ] Lab: build a custom form layout for an Incident; add a related list for Tasks
- [ ] Lab: create an approval flow for a Catalog Item using Flow Designer
- [ ] Practice: 20 questions on form/list configuration

## Week 3 - Self-Service and Process Automation (Domain 3, 15%)

**Concepts:** Service Catalog (item, variable, variable set, record producer), Service Portal, Knowledge Base, Flow Designer (trigger, action, subflow).

- [ ] Lab: create a Catalog Item with 3+ variables, attach a record producer to populate Incident
- [ ] Lab: build a Knowledge Base with categories, articles, and an article template
- [ ] Lab: build a 3-step flow in Flow Designer that triggers on Incident created, updates Priority, and notifies a group
- [ ] Practice: 20 questions on catalog + flows

## Week 4 - Database Administration + Configuration (Domains 4 + 5, 25%)

**Concepts:** tables, dictionary entries, fields, references, dot-walking, table extension vs many-to-many, business rules vs client scripts vs UI policies, ACL types.

- [ ] Lab: extend the `task` table to a custom table; understand TPH (table-per-hierarchy)
- [ ] Lab: write a `before insert` business rule on Incident that sets a custom field
- [ ] Lab: write a UI policy that hides a field when state = Closed
- [ ] Lab: write an ACL that allows read of Incident but denies write to non-itil users
- [ ] Practice: 30 questions on data model + scripting

## Week 5 - Application, Reporting, Knowledge & Catalog (Domains 6 + 7, 25%)

**Concepts:** reports (list, bar, pie, time series, performance analytics), dashboards, scheduled reports, Knowledge Management workflow, Service Catalog publishing.

- [ ] Lab: build 3 reports (one bar by category, one time-series by month, one trend) and put them on a dashboard
- [ ] Lab: schedule a report to email weekly to a group
- [ ] Lab: configure Knowledge Management with article approvers and feedback
- [ ] Practice: 25 questions on reporting + KM

## Week 6 - Cumulative review + scheduling

- [ ] Read all `notes/*.md` end to end (once they exist - currently scaffolded)
- [ ] Take 2 full-length practice exams (Now Learning, MeasureUp, or third-party)
- [ ] Review every miss; map each to a domain and revisit fact-sheet
- [ ] Re-do any lab where the underlying concept still feels shaky
- [ ] Schedule the exam for late this week or early next - don't let prep go stale

## Pass-day reminders

- Read the question fully; ServiceNow loves "EXCEPT" / "NOT" wording
- Eliminate clearly wrong answers before deciding between the last two
- When in doubt, lean toward the answer that uses standard out-of-box behavior over heavy customization
- Mark and skip; come back. Don't burn 5 minutes on one question

## Tracking

| Week | Hours actual | Practice score | Confidence (1-5) |
|---|---|---|---|
| 1 |  |  |  |
| 2 |  |  |  |
| 3 |  |  |  |
| 4 |  |  |  |
| 5 |  |  |  |
| 6 |  |  |  |
