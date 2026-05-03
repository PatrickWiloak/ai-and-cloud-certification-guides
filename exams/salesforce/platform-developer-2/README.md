# Salesforce Certified Platform Developer II (PDII)

## Overview

The Platform Developer II (PDII) credential validates advanced programmatic skills on the Salesforce platform. Candidates demonstrate mastery of **Apex** (advanced async patterns, Stub API, dynamic Apex, design patterns), **integrations** (REST/SOAP, Platform Events, Change Data Capture, Named Credentials, External Services), **Lightning Web Components** (events, reactivity, performance), **testing** (mocks, dependency injection), and **deployment** (SFDX, 2GP packaging, Metadata API).

PDII is the next step after Platform Developer I. Historically the credential included a coding assignment / superbadge component, but as of 2026 the credential is awarded after a single proctored multiple-choice exam (Salesforce retired the programming assignment requirement). Always verify the latest format on the official credential page before scheduling.

---

## Quick Reference

| Detail | Info |
|---|---|
| **Exam Name** | Salesforce Certified Platform Developer II |
| **Provider** | Salesforce |
| **Format** | 60 multiple-choice / multi-select questions (proctored) |
| **Duration** | 120 minutes |
| **Passing Score** | 70% |
| **Cost** | $200 USD ($100 retake) |
| **Prerequisite** | Platform Developer I (required to earn PDII) |
| **Validity** | Maintained via free annual release exams |

**[Credential page](https://trailhead.salesforce.com/credentials/platformdeveloperii)**
**[Exam Guide PDF](https://trailhead.salesforce.com/help?article=Salesforce-Certified-Platform-Developer-II-Exam-Guide)**

---

## Exam Domains

| # | Domain | Weight |
|---|---|---|
| 1 | Salesforce Fundamentals | 5% |
| 2 | Data Modeling and Management | 10% |
| 3 | Process Automation, Logic, and Integration | 35% |
| 4 | User Interface | 20% |
| 5 | Testing, Debugging, and Deployment | 20% |
| 6 | Performance | 10% |

The exam emphasizes **architectural decision-making** under governor-limit constraints. Expect long code samples, ambiguous-looking choices, and questions where multiple answers compile but only one scales.

---

## Study Materials in This Guide

| File | Description |
|---|---|
| [fact-sheet.md](fact-sheet.md) | High-yield reference: governor limits, async patterns, LWC lifecycle, test patterns |
| [practice-plan.md](practice-plan.md) | 10-week study plan with hands-on labs |
| [scenarios.md](scenarios.md) | 15 exam-style architecture/design scenarios with reasoning |
| [strategy.md](strategy.md) | Exam tactics, time budgeting, format notes |
| [notes/01-fundamentals.md](notes/01-fundamentals.md) | MVC, multi-tenant, declarative vs programmatic |
| [notes/02-data-modeling.md](notes/02-data-modeling.md) | Relationships, schema design, LDV, skinny tables, indexing |
| [notes/03-process-automation-logic-integration.md](notes/03-process-automation-logic-integration.md) | Apex async, SOQL/SOSL, REST/SOAP, Platform Events, CDC, Named Credentials |
| [notes/04-user-interface.md](notes/04-user-interface.md) | LWC deep dive, Aura, Visualforce, events, LMS, LDS |
| [notes/05-testing-debugging-deployment.md](notes/05-testing-debugging-deployment.md) | Test classes, Stub API, mocks, debug logs, SFDX, 2GP packaging |
| [notes/06-performance.md](notes/06-performance.md) | Governor limits, bulkification, query optimization, transaction control |

---

## Recommended Study Time

| Background | Estimated Prep Time |
|---|---|
| PDI + 2+ years Apex experience | 6-8 weeks |
| PDI + occasional Apex work | 10-12 weeks |
| PDI just earned, limited project work | 14-16 weeks |
| Targeting PDII without strong PDI fundamentals | Take PDI seriously first |

PDII is not a memorization exam. The questions reward people who have shipped Apex to production and dealt with governor limits, mixed DML, recursion, deserialization, and integration latency.

---

## Prerequisites

- **Platform Developer I credential** (required, not optional - PDII is awarded only after PDI is in good standing)
- 1-2+ years of hands-on Apex / LWC / SOQL development
- Comfort with REST APIs, JSON, async patterns, and design patterns
- Familiarity with SFDX, scratch orgs, and source-driven development

---

## Hands-on Setup

- **[Salesforce Developer Edition org](https://developer.salesforce.com/signup)** - free, permanent
- **[Salesforce CLI / `sf` binary](https://developer.salesforce.com/tools/sfdxcli)** - source-driven dev
- **[VS Code with Salesforce Extensions Pack](https://developer.salesforce.com/tools/vscode)** - the IDE
- **[Trailhead PDII Trailmix](https://trailhead.salesforce.com/users/strailhead/trailmixes/prepare-for-your-salesforce-platform-developer-ii-credential)** - official prep
- **[Apex Specialist Superbadge](https://trailhead.salesforce.com/content/learn/superbadges/superbadge_apex)** - prerequisite-level
- **[Advanced Apex Specialist Superbadge](https://trailhead.salesforce.com/content/learn/superbadges/superbadge_advanced_apex_specialist)** - core PDII material
- **[Apex Patterns and Best Practices](https://github.com/SalesforceFoundation/CumulusCI)** - real-world reference codebase

You **cannot** pass PDII without writing real Apex against a real org. Plan to ship at least 3-5 non-trivial integrations / async pipelines during prep.

---

## Companion Materials

- **[Platform Developer I](../platform-developer-1/)** - foundational developer cert; PDII assumes mastery
- **[Salesforce Administrator](../administrator/)** - configuration foundation referenced in declarative-vs-programmatic questions
- **[Integration Patterns Guide](https://architect.salesforce.com/decision-guides/integration-patterns)** - Salesforce architect reference for the integration domain (35% of PDII)

---

## Notes

- The 2026 PDII format is multiple-choice only. Salesforce previously required a "programming assignment" (Trailhead superbadge) component to earn the credential; this requirement was retired. Confirm the current format on the credential page before booking.
- PDI must be active (passed all maintenance modules) before PDII is awarded.
- Maintain PDII via free release exams ~3 times per year on Trailhead.
