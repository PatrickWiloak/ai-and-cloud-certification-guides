# Salesforce PD1 - 8-Week Practice Plan

This plan assumes 1.5-2 hours of theory + 1-2 hours of hands-on coding per day.

You **cannot** pass PD1 without writing Apex by hand. Build at least 5-10 small projects.

---

## Lab setup

- [ ] Salesforce Developer Edition org (free, permanent)
- [ ] Salesforce CLI (`sf`) + VS Code with Salesforce Extensions Pack
- [ ] [Trailhead PD1 Trailmix](https://trailhead.salesforce.com/users/strailhead/trailmixes/prepare-for-your-salesforce-platform-developer-i-credential)
- [ ] [Apex Specialist Superbadge](https://trailhead.salesforce.com/content/learn/superbadges/superbadge_apex)

---

## Week 1 - Apex syntax + Data model

- [ ] Read [notes/01-data-model-and-soql.md](./notes/01-data-model-and-soql.md)
- [ ] Trailhead: "Apex Basics & Database" + "Apex Triggers"
- [ ] Lab: Write 5 SOQL queries (filtered, joined parent-child, aggregate, with bind vars)
- [ ] Lab: Use Apex collections (List, Set, Map) to manipulate Account/Contact data

## Week 2 - Apex Triggers + Bulkification

- [ ] Read [notes/02-apex-triggers-and-classes.md](./notes/02-apex-triggers-and-classes.md)
- [ ] Trailhead: "Apex Triggers" trail
- [ ] Lab: Write a before-insert trigger to default a field
- [ ] Lab: Write an after-update trigger that updates related records (bulkified)
- [ ] Lab: Add recursion guard to a trigger
- [ ] Lab: Refactor trigger logic into a handler class

## Week 3 - Async Apex

- [ ] Read [notes/03-async-apex-and-platform-events.md](./notes/03-async-apex-and-platform-events.md)
- [ ] Trailhead: "Asynchronous Apex" trail
- [ ] Lab: Write a `@future(callout=true)` method
- [ ] Lab: Write a Queueable class that chains another Queueable
- [ ] Lab: Write a Batch class processing 5,000+ records
- [ ] Lab: Schedule a Batch job nightly via Schedulable

## Week 4 - Lightning Web Components

- [ ] Read [notes/04-lwc-and-visualforce.md](./notes/04-lwc-and-visualforce.md)
- [ ] Trailhead: "Lightning Web Components" + "Lightning Web Components Basics"
- [ ] Lab: Build a simple LWC that lists Accounts (wire to `@AuraEnabled` Apex method)
- [ ] Lab: Add filtering by an `@api` input
- [ ] Lab: Use Lightning Data Service to read/update a single record without Apex
- [ ] Lab: Parent + child LWC with custom event communication

## Week 5 - Visualforce + Aura (legacy)

- [ ] Read [notes/04-lwc-and-visualforce.md](./notes/04-lwc-and-visualforce.md) - legacy sections
- [ ] Trailhead: "Visualforce Basics" module
- [ ] Lab: Build a simple Visualforce page with custom controller
- [ ] Lab: Build an Aura component (briefly, for awareness)

## Week 6 - Testing

- [ ] Read [notes/05-testing-debugging-deployment.md](./notes/05-testing-debugging-deployment.md)
- [ ] Trailhead: "Apex Testing" trail
- [ ] Lab: Write tests for your Week-2 trigger achieving 90%+ coverage
- [ ] Lab: Test code with HTTP callout using HttpCalloutMock
- [ ] Lab: Test bulk scenario with 200 records

## Week 7 - Debugging + Deployment

- [ ] Read [notes/05-testing-debugging-deployment.md](./notes/05-testing-debugging-deployment.md)
- [ ] Lab: Set up debug logs in Developer Console
- [ ] Lab: Use `System.debug()` to trace a complex trigger
- [ ] Lab: Deploy code from sandbox via Change Set
- [ ] Lab: Use Salesforce CLI to deploy from VS Code

## Week 8 - Practice exams + Weak areas

- [ ] Re-read [fact-sheet.md](./fact-sheet.md)
- [ ] [scenarios.md](./scenarios.md) - work through all
- [ ] Practice exams: Focus On Force PD1, Salesforce Ben questions
- [ ] Score 80%+ on multiple practice exams

---

## Stop signals

- [ ] You can write a bulkified trigger from memory
- [ ] You can write a Queueable / Batch class
- [ ] You can build an LWC with @wire to Apex
- [ ] You can write Apex tests with mocks and 90%+ coverage
- [ ] You score 80%+ on practice exams twice in a row
