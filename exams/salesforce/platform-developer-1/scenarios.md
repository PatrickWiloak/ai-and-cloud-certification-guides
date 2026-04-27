# Salesforce PD1 - Exam-Style Scenarios

12 scenarios across PD1 domains.

---

### Scenario 1
**A trigger on Contact updates the parent Account's Total_Contacts__c field. With 200 contacts being inserted in bulk, what's the right pattern?**

**Best answer:** After-insert trigger. Collect AccountIds into a Set. Single SOQL to fetch all Accounts. Single update of Accounts. Don't query/update inside the loop.

---

### Scenario 2
**A trigger needs to make an HTTP callout to an external API when an Opportunity is closed.**

**Best answer:** Synchronous triggers can't make HTTP callouts. Use `@future(callout=true)` method or Queueable with `Database.AllowsCallouts`.

---

### Scenario 3
**You need to chain three async jobs in sequence, passing complex objects between them.**

**Best answer:** Queueable. Each job's `execute()` enqueues the next via `System.enqueueJob()`. Constructor accepts complex types (sObjects, custom classes). `@future` doesn't accept sObjects.

---

### Scenario 4
**Process 10 million Account records nightly with Apex.**

**Best answer:** Schedulable + Batch. Schedulable triggers Batch on cron schedule. Batch QueryLocator handles up to 50M records.

---

### Scenario 5
**An LWC needs to display Accounts filtered by a search term that updates as the user types.**

**Best answer:**

```javascript
@track searchTerm = '';
@wire(getAccounts, { searchTerm: '$searchTerm' }) accounts;

handleInput(event) {
    this.searchTerm = event.target.value;  // re-fires the wire
}
```

The `$searchTerm` syntax makes the wire reactive to property changes.

---

### Scenario 6
**A test class fails because the code does an HTTP callout. The org doesn't allow real callouts in test context.**

**Best answer:** Implement `HttpCalloutMock` and register with `Test.setMock(HttpCalloutMock.class, new MyMock())`. The mock intercepts callouts during the test.

---

### Scenario 7
**An after-update trigger fires, makes a DML update, which fires the same trigger again, causing infinite recursion.**

**Best answer:** Use a static class flag as a recursion guard:

```apex
public class TriggerHelper {
    public static Boolean isRunning = false;
}

trigger AccountTrigger on Account (after update) {
    if (TriggerHelper.isRunning) return;
    TriggerHelper.isRunning = true;
    try { /* logic */ } finally { TriggerHelper.isRunning = false; }
}
```

---

### Scenario 8
**A custom LWC must read and update a single record without writing Apex.**

**Best answer:** Lightning Data Service via `lightning/uiRecordApi`:

```javascript
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
@wire(getRecord, { recordId: '$recordId', fields: [NAME_FIELD] }) account;
```

---

### Scenario 9
**A test must verify both successful insert (200 records) AND the failure case (missing required field).**

**Best answer:** Two test methods - `testInsert_bulk` creates 200 records, asserts side effects. `testInsert_failure` tries an invalid record inside try/catch, asserts the DmlException message.

---

### Scenario 10
**An LWC needs to call an Apex method that does DML.**

**Best answer:** `@AuraEnabled` (without `cacheable=true`). `cacheable=true` is read-only and doesn't allow DML. Plain `@AuraEnabled` permits DML; LWC calls imperatively.

---

### Scenario 11
**Apex class should be callable from LWC and be cached client-side for performance.**

**Best answer:**

```apex
@AuraEnabled(cacheable=true)
public static List<Account> getAccountsByIndustry(String industry) {
    return [SELECT Id, Name FROM Account WHERE Industry = :industry];
}
```

`cacheable=true` enables client-side caching but disallows DML.

---

### Scenario 12
**Code coverage is 60% on a class. You can't deploy to production. Which type of code should you focus on adding tests for?**

**Best answer:** Find untested branches (uncovered lines in the test report). Add tests for: error handling paths (catch blocks), edge cases (null inputs, empty lists), and bulk scenarios (200+ records). Aim for 75%+ org-wide.

---

## Scoring guide

- **10-12:** Schedule the exam.
- **7-9:** Re-read fact-sheet and weak-area notes.
- **<7:** More hands-on Apex coding before retesting.

PD1 is **scenario-based code-reading**. You'll see Apex code snippets and pick the right answer (or fix). Practice writing real Apex in your dev org.
