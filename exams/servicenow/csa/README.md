# ServiceNow Certified System Administrator (CSA)

## Overview

The **Certified System Administrator (CSA)** is the foundational ServiceNow credential. It validates the ability to configure, manage, and administer a ServiceNow instance: tables and the dictionary, list/form configuration, ACL-based security, business rules, client scripts, UI policies, Service Catalog, Knowledge, Flow Designer, reporting, and update set deployment.

CSA is a **prerequisite** for almost every other ServiceNow certification (CAD, all CIS-* implementation specialist certs, and the architect track). If you work on a ServiceNow instance professionally, this is the first cert you earn.

---

## Quick Reference

| Detail | Info |
|---|---|
| **Exam Name** | ServiceNow Certified System Administrator |
| **Provider** | ServiceNow |
| **Format** | 60 multiple-choice / multiple-answer questions |
| **Duration** | 90 minutes |
| **Passing Score** | ~70% (ServiceNow does not publish exact cut score; widely reported as 70%) |
| **Cost** | $300 USD (retake $300) |
| **Validity** | Maintained per release; ServiceNow publishes a delta exam each release cycle |
| **Delivery** | Online proctored (Kryterion / Webassessor) or onsite |
| **Prerequisite Training** | **Now Learning "ServiceNow System Administration Fundamentals"** required for voucher access |

**[Now Learning - CSA learning path](https://nowlearning.servicenow.com/lxp/en/now-platform/getting-started-with-servicenow)**
**[CSA exam blueprint and registration](https://nowlearning.servicenow.com/lxp/en/now-platform/certified-system-administrator)**
**[Personal Developer Instance (PDI) signup](https://developer.servicenow.com/dev.do)**

---

## Exam Domains

| # | Domain | Weight |
|---|---|---|
| 1 | ServiceNow Platform Overview | 15% |
| 2 | Lists, Forms, and Tasks | 20% |
| 3 | Self-Service & Process Automation | 15% |
| 4 | Database Administration | 15% |
| 5 | Configuration & Customization | 10% |
| 6 | Application & Reporting | 15% |
| 7 | Knowledge Management & Service Catalog | 10% |

(Weights track the current published blueprint. Confirm on Now Learning before registering - ServiceNow updates the blueprint every couple of releases.)

---

## Releases You Should Be Aware Of

ServiceNow ships two named releases per year. The CSA exam tracks the current Now Platform - questions reference UI Builder, Flow Designer, and the modern Next Experience UI, not legacy Workflow Editor or the pre-Madrid UI.

Recent / current releases (newest first):

- **Zurich** - latest current major
- **Yokohama**
- **Xanadu**
- **Washington DC**
- **Vancouver**
- (older: Utah, Tokyo, San Diego, Rome, Quebec, Paris)

Always confirm the release on your PDI matches what the cert blueprint references.

---

## Study Materials in This Guide

| File | Description |
|---|---|
| [fact-sheet.md](fact-sheet.md) | High-yield reference: tables, GlideRecord syntax, ACL rules, update sets |
| [practice-plan.md](practice-plan.md) | 6-week study plan with PDI labs |
| [scenarios.md](scenarios.md) | 12-15 admin scenarios (forms, ACLs, catalog, flows) |
| [strategy.md](strategy.md) | Exam-day strategy, time management, common traps |
| [notes/01-platform-overview.md](notes/01-platform-overview.md) | Architecture, instances, releases, navigation, roles |
| [notes/02-lists-forms-tasks.md](notes/02-lists-forms-tasks.md) | List views, personalization, form layout, task lifecycle, approvals |
| [notes/03-self-service-process-automation.md](notes/03-self-service-process-automation.md) | Service Catalog, Service Portal, Knowledge, Flow Designer |
| [notes/04-database-administration.md](notes/04-database-administration.md) | Tables, dictionary, fields, references, dot-walking, relationships |
| [notes/05-configuration-customization.md](notes/05-configuration-customization.md) | UI policies, business rules, client scripts, script includes, update sets |
| [notes/06-application-reporting-knowledge.md](notes/06-application-reporting-knowledge.md) | ACLs, reports, dashboards, Performance Analytics, Knowledge Management |

---

## Recommended Study Time

| Background | Estimated Prep Time |
|---|---|
| Active ServiceNow admin (1+ year hands-on) | 3-4 weeks |
| ITSM / ITIL background, no ServiceNow | 6-8 weeks |
| New to ServiceNow and to ITSM | 10-14 weeks (start with the Now Learning Fundamentals path) |

---

## Hands-on Setup

You **cannot** pass this cert without a live instance to click through. Most exam questions test specific UI navigation paths and configuration choices.

1. **Sign up for a [Personal Developer Instance (PDI)](https://developer.servicenow.com/dev.do)** - free, dedicated, on the latest release. Hibernates after ~10 days of inactivity but wakes on login.
2. **Complete the [Now Learning Fundamentals path](https://nowlearning.servicenow.com/lxp/en/now-platform/getting-started-with-servicenow)** - required for the cert voucher.
3. **Bookmark the [Now Create](https://nowlearning.servicenow.com/nowcreate) accelerators** for reference architecture patterns.
4. **Open the [Developer Documentation](https://developer.servicenow.com/dev.do#!/reference)** - particularly the GlideRecord and GlideAjax API references.

---

## Companion Materials

- **[ITIL 4 Foundation](../../axelos/itil-4-foundation/)** - the IT service management framework ServiceNow's ITSM products implement. Conceptual companion to CSA. *(planned)*
- **[Salesforce Administrator](../../salesforce/administrator/)** - parallel "platform admin" cert on a different platform. Same shape: declarative config, role-based access, automation, reporting.
- **[AWS Service Catalog](https://aws.amazon.com/servicecatalog/)** - conceptual parallel for "self-service catalog" thinking. AWS Service Catalog provisions infrastructure; ServiceNow Service Catalog provisions any approved request type (HR, IT, facilities).

---

## After CSA

Common next steps:

- **Certified Application Developer (CAD)** - learn scoped applications, server-side scripting, UI components.
- **CIS-ITSM** - the most common follow-on; deepens Incident/Problem/Change/Request implementation.
- **CIS-Discovery** or **CIS-CMDB Health** - if you specialize in CMDB.
- **CIS-CSM** - Customer Service Management.
- **Now Assist / AI Agent Studio** - generative AI on the Now Platform (newer cert family).

The full CIS-* ladder requires CSA as a prerequisite. The architect track (CTA) is years out and gates on multi-instance, integration, and performance experience.
