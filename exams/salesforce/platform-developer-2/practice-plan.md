# Salesforce PDII - 10-Week Practice Plan

This plan assumes 1.5-2 hours of theory + 2 hours of hands-on coding per day. PDII is hands-on heavy. You will not pass by reading.

You **must** ship at least 3-5 non-trivial Apex / LWC / integration projects during prep.

---

## Lab setup

- [ ] Salesforce Developer Edition org (free, permanent)
- [ ] Salesforce CLI (`sf`) + VS Code with Salesforce Extensions Pack
- [ ] Postman or `curl` for testing REST endpoints
- [ ] [Trailhead PDII Trailmix](https://trailhead.salesforce.com/users/strailhead/trailmixes/prepare-for-your-salesforce-platform-developer-ii-credential)
- [ ] [Apex Specialist Superbadge](https://trailhead.salesforce.com/content/learn/superbadges/superbadge_apex)
- [ ] [Advanced Apex Specialist Superbadge](https://trailhead.salesforce.com/content/learn/superbadges/superbadge_advanced_apex_specialist)
- [ ] Active PDI credential (PDII is awarded only after PDI is in good standing)

---

## Week 1 - Foundations + Data Modeling

- [ ] Read [notes/01-fundamentals.md](./notes/01-fundamentals.md)
- [ ] Read [notes/02-data-modeling.md](./notes/02-data-modeling.md)
- [ ] Trailhead: "Data Modeling" + "Build a Data Model on Salesforce"
- [ ] Lab: Build a 3-object schema (master-detail, lookup, junction). Add roll-up summary, formula, validation rule.
- [ ] Lab: Create a junction object for a many-to-many relationship between two custom objects.
- [ ] Lab: Mark a field as External Id and import via SFDX `sf data import`.

## Week 2 - Apex Triggers and Handler Patterns

- [ ] Read [notes/03-process-automation-logic-integration.md](./notes/03-process-automation-logic-integration.md) (sections 1-3)
- [ ] Trailhead: "Apex Triggers" + "Apex Trigger Patterns"
- [ ] Lab: One-trigger-per-object dispatcher with handler class.
- [ ] Lab: Recursion guard using static class flag, tested with a self-referencing update.
- [ ] Lab: Bulkified handler that processes 200 inserts in a single trigger run.
- [ ] Lab: `addError()` validation in before-trigger; catch in test class.

## Week 3 - Async Apex deep dive

- [ ] Read [notes/03-process-automation-logic-integration.md](./notes/03-process-automation-logic-integration.md) (async sections)
- [ ] Trailhead: "Asynchronous Apex" + "Apex Integration Services"
- [ ] Lab: Write a `@future(callout=true)` and verify governor limits in debug log.
- [ ] Lab: Queueable that chains itself for paginated processing (with `!Test.isRunningTest()` guard).
- [ ] Lab: Batchable + `Database.Stateful` accumulating success/failure counts; email summary in `finish()`.
- [ ] Lab: Schedulable that launches Batch via cron `'0 0 2 * * ?'`.
- [ ] Lab: Mixed DML scenario (User + Account) - reproduce the error, fix with `System.runAs` or async.

## Week 4 - Integrations: REST/SOAP, Named Credentials, Platform Events

- [ ] Read [notes/03-process-automation-logic-integration.md](./notes/03-process-automation-logic-integration.md) (integration sections)
- [ ] Trailhead: "Apex Integration Services" + "Platform Events Basics"
- [ ] Lab: Build an Apex REST endpoint (`@RestResource`) supporting GET / POST / PATCH.
- [ ] Lab: Configure a Named Credential (use `httpbin.org` or similar test endpoint) and call from a Queueable with `Database.AllowsCallouts`.
- [ ] Lab: Define a Platform Event `Order_Placed__e`. Publish from Apex, subscribe via trigger.
- [ ] Lab: Subscribe to a Platform Event from LWC using `lightning/empApi`.
- [ ] Lab: Enable Change Data Capture on Account; subscribe via trigger on `AccountChangeEvent`.
- [ ] Lab: Generate Apex stubs from a sample WSDL with `sf force apex generate webservice`.

## Week 5 - Lightning Web Components advanced

- [ ] Read [notes/04-user-interface.md](./notes/04-user-interface.md)
- [ ] Trailhead: "Lightning Web Components Specialist" + "Build a Conference Management App"
- [ ] Lab: Parent + child LWC; child fires custom event with `bubbles: true, composed: true`.
- [ ] Lab: LWC with `@wire` to `@AuraEnabled(cacheable=true)`; verify reactivity with `$propName` syntax.
- [ ] Lab: LWC using LDS (`getRecord`, `updateRecord`) for record CRUD without Apex.
- [ ] Lab: Three sibling LWCs communicating via Lightning Message Service custom channel.
- [ ] Lab: LWC Toast notification on success / error.
- [ ] Lab: Imperative Apex call with try/catch and error display in template.

## Week 6 - Visualforce and Aura (legacy coverage)

- [ ] Read [notes/04-user-interface.md](./notes/04-user-interface.md) (legacy sections)
- [ ] Trailhead: "Visualforce Mobile" + "Aura Components Basics"
- [ ] Lab: Visualforce page with custom controller and `actionFunction`.
- [ ] Lab: Aura component embedding an LWC child.
- [ ] Lab: LWC embedded inside an Aura wrapper to expose to a Visualforce-only context.

## Week 7 - Testing: Stub API, mocks, dependency injection

- [ ] Read [notes/05-testing-debugging-deployment.md](./notes/05-testing-debugging-deployment.md) (testing sections)
- [ ] Trailhead: "Apex Testing" + "Apex Mocks Framework" reference
- [ ] Lab: Refactor a service to take an interface dependency; mock the dependency in a test.
- [ ] Lab: Use `Test.createStub` + `StubProvider` to mock a concrete class without an interface.
- [ ] Lab: `HttpCalloutMock` test for an integration class.
- [ ] Lab: `MultiStaticResourceCalloutMock` for a multi-step integration.
- [ ] Lab: Test data factory class. Refactor 3+ test classes to use it.
- [ ] Lab: Bulk test (200 records) verifying no governor limit hits.
- [ ] Lab: Negative-path test asserting exception message.

## Week 8 - Debugging, performance, governor limits

- [ ] Read [notes/06-performance.md](./notes/06-performance.md)
- [ ] Read [notes/05-testing-debugging-deployment.md](./notes/05-testing-debugging-deployment.md) (debug + deploy sections)
- [ ] Trailhead: "Performance Profiling for Apex" + "Apex Performance Best Practices"
- [ ] Lab: Use Developer Console -> Query Plan to optimize a non-selective SOQL.
- [ ] Lab: Add `Limits.getQueries()` / `Limits.getCpuTime()` checkpoints in a long-running flow.
- [ ] Lab: Reproduce a CPU timeout; refactor to bulk pattern.
- [ ] Lab: Reproduce a heap-size error; stream via Iterable instead of loading all rows.
- [ ] Lab: Identify a non-selective filter; add a custom index (note: in real org needs Salesforce support).

## Week 9 - Deployment, packaging, SFDX

- [ ] Read [notes/05-testing-debugging-deployment.md](./notes/05-testing-debugging-deployment.md) (deployment sections)
- [ ] Trailhead: "Application Lifecycle Management" + "Unlocked Packages for Customers"
- [ ] Lab: Convert your codebase into a 2GP unlocked package (`sf package create`, `sf package version create`).
- [ ] Lab: Install the package in a fresh scratch org; verify metadata deployed.
- [ ] Lab: Set up CI: GitHub Actions workflow running `sf project deploy validate` on PR.
- [ ] Lab: Validate-only deploy with `--check-only --tests-to-run RunLocalTests`.
- [ ] Lab: Change Set (UI) - upload from one sandbox, deploy to another. Compare to SFDX experience.

## Week 10 - Practice exams + Weak areas

- [ ] Re-read [fact-sheet.md](./fact-sheet.md) twice
- [ ] [scenarios.md](./scenarios.md) - work through all 15
- [ ] Practice exams: Focus On Force PDII (~3 attempts), Salesforce Ben PDII set, Trailhead practice
- [ ] Score 80%+ on practice exams two days in a row
- [ ] Re-read weak-domain notes
- [ ] Review [strategy.md](./strategy.md) the day before the exam

---

## Stop signals (you are ready when)

- [ ] You can write a bulkified, recursion-guarded trigger handler from memory
- [ ] You can write a Queueable with chaining and callouts from memory
- [ ] You can write a Batchable with `Database.Stateful` from memory
- [ ] You can write a `@RestResource` endpoint and a Named Credential callout from memory
- [ ] You can build an LWC with `@wire`, `@api`, custom events, and LDS from memory
- [ ] You can write Apex tests using Stub API, `HttpCalloutMock`, and a test data factory
- [ ] You can identify a non-selective SOQL query and explain how to fix it
- [ ] You can name the limit and units for: SOQL queries, DML rows, CPU time, heap, callout count
- [ ] You score 80%+ on Focus On Force PDII practice exams two attempts in a row

---

## Anti-patterns to internalize before exam day

- SOQL inside a `for` loop -> always wrong answer
- DML inside a `for` loop -> always wrong answer
- `@future` chained from another `@future` -> not allowed
- Passing sObjects to `@future` -> not allowed; use Queueable
- `seeAllData=true` for new code -> avoid
- Hardcoded endpoint URL or token -> use Named Credential
- Mixing setup + non-setup DML in one transaction -> use `runAs` or async
- `Trigger.new` accessed in `before delete` -> it's `Trigger.old` for delete operations
- `cacheable=true` on a method that does DML -> compile/runtime error
- Visualforce / Aura for new builds -> use LWC

---

## Daily routine while studying

1. Morning (45 min): Re-read prior day's notes, work through 2 fact-sheet sections
2. Mid-day (90 min): Hands-on lab from current week
3. Evening (30 min): 10 practice questions, log weak areas

The PDII exam rewards muscle memory. Keep your dev org open. Type, don't read.
