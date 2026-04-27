# Salesforce Platform Developer I (PD1) - Fact Sheet

## Quick Reference

**Cost:** $200 USD ($100 retake)
**Format:** 60 questions (multi-choice + multi-select)
**Duration:** 105 minutes
**Passing:** 68%

**[📖 Credential page](https://trailhead.salesforce.com/credentials/platformdeveloperi)**
**[📖 Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/)**
**[📖 Lightning Web Components Dev Guide](https://developer.salesforce.com/docs/component-library/documentation/en/lwc)**

---

## Apex fundamentals

Apex is Salesforce's server-side language. Java-like syntax, runs in a multi-tenant environment with strict governor limits.

### Class structure

```apex
public class AccountService {
    // Member variable
    private List<Account> accountList;

    // Constructor
    public AccountService(List<Account> accs) {
        this.accountList = accs;
    }

    // Method
    public void updateRevenue() {
        for (Account a : accountList) {
            a.AnnualRevenue *= 1.10;
        }
        update accountList;
    }
}
```

### Variable types

- Primitive: `String`, `Integer`, `Long`, `Decimal`, `Double`, `Boolean`, `Date`, `Datetime`, `Time`, `Id`, `Blob`
- sObject: `Account`, `Contact`, `MyCustomObject__c`, generic `sObject`
- Collection: `List<T>`, `Set<T>`, `Map<K,V>`
- Custom: classes, interfaces, enums

### Apex access modifiers

- `public` - accessible throughout the namespace
- `private` - same class only
- `global` - accessible across namespaces (managed packages)
- `protected` - inheriting classes
- `with sharing` - enforces user's record sharing rules
- `without sharing` - bypasses sharing (system context)
- `inherited sharing` - inherits caller's setting

### `with sharing` vs `without sharing`

- **with sharing** - respects the running user's access (use for user-context code)
- **without sharing** - bypasses sharing (use for system jobs that need to update records the user couldn't normally see)
- Default in triggers is **without sharing** unless you specify

---

## SOQL (Salesforce Object Query Language)

SQL-like, but Salesforce-specific.

### Basic syntax

```sql
SELECT Id, Name, Industry FROM Account WHERE Industry = 'Technology' LIMIT 10
```

### Relationships

#### Parent-to-child (subquery)

```sql
SELECT Id, Name, (SELECT Id, FirstName FROM Contacts) FROM Account
```

#### Child-to-parent (dot notation)

```sql
SELECT Id, FirstName, Account.Name, Account.Industry FROM Contact
```

### Bind variables in Apex

```apex
String industry = 'Technology';
List<Account> accs = [SELECT Id, Name FROM Account WHERE Industry = :industry];
```

### Aggregate queries

```sql
SELECT COUNT(Id), Industry FROM Account GROUP BY Industry
```

### LIMIT and OFFSET

- `LIMIT 100`
- `OFFSET 100` (max 2,000)

### SOQL governor limits

- 100 SOQL queries per synchronous transaction (200 async)
- 50,000 records returned by SOQL per transaction

---

## SOSL (Salesforce Object Search Language)

Multi-object full-text search.

```apex
List<List<sObject>> results = [FIND 'Acme*' IN ALL FIELDS RETURNING Account(Name), Contact(LastName)];
```

Use for keyword searches across multiple objects. SOQL is for filtered queries.

---

## DML (Data Manipulation Language)

```apex
insert account;
update account;
delete account;
upsert account External_Id__c;
undelete account;
merge masterAccount [duplicate1, duplicate2];
```

### Database class equivalents

```apex
Database.SaveResult[] results = Database.insert(accounts, false); // false = allow partial success
Database.UpsertResult[] r = Database.upsert(accounts, External_Id__c, false);
```

Use `Database.X(records, allOrNone)` to allow partial success.

### DML governor limits

- 150 DML statements per transaction
- 10,000 records modified per transaction

---

## Triggers

Apex code that runs in response to record events.

### Trigger syntax

```apex
trigger AccountTrigger on Account (before insert, before update, after insert, after update,
                                    before delete, after delete, after undelete) {
    if (Trigger.isBefore && Trigger.isInsert) {
        // logic
    }
}
```

### Trigger.context variables

- `Trigger.new` - new versions of records (List)
- `Trigger.old` - old versions (List)
- `Trigger.newMap` - new records by Id (Map<Id, sObject>)
- `Trigger.oldMap` - old records by Id
- `Trigger.isBefore`, `isAfter`, `isInsert`, `isUpdate`, `isDelete`, `isUndelete`, `isExecuting`
- `Trigger.size` - number of records

### Best practices

- **One trigger per object** - dispatcher pattern
- **Bulkified** - work with `Trigger.new` as a List, not single records
- **No SOQL/DML in loops** - aggregate queries / collect IDs first
- **Logic in handler classes** - keep trigger thin
- **Recursion handling** - use a static flag class

### Trigger context use cases

- **Before insert/update** - modify the record's own fields (no DML needed - just set the field)
- **After insert/update** - need the record ID (insert) or update related records
- **Before delete** - prevent deletion via `addError()`
- **After delete/undelete** - cleanup or re-creation logic

---

## Async Apex

Operations that can take longer than a synchronous transaction or need to run later.

### Future Methods

```apex
@future
public static void sendEmail(Set<Id> userIds) {
    // ...
}
@future(callout=true)  // for HTTP callouts
public static void doCallout() { }
```

- Static, void, only primitive args
- 50 future calls per transaction
- 250,000 future / async invocations per 24 hours (or 200 × user license count, whichever is greater)

### Queueable Apex

```apex
public class MyQueueable implements Queueable {
    public void execute(QueueableContext ctx) { }
}
// Enqueue:
System.enqueueJob(new MyQueueable());
```

- Pass complex objects (sObjects, custom types)
- Chain jobs (call `enqueueJob` from `execute`)
- 50 jobs per transaction
- 250,000 / day

### Batch Apex

```apex
public class MyBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id FROM Account');
    }
    public void execute(Database.BatchableContext bc, List<Account> scope) { }
    public void finish(Database.BatchableContext bc) { }
}
// Run:
Database.executeBatch(new MyBatch(), 200); // 200 = batch size
```

- Process millions of records in batches
- Up to 50,000,000 records via QueryLocator
- 5 concurrent batches per org
- 250,000 batch executions / day

### Schedulable Apex

```apex
public class MyScheduler implements Schedulable {
    public void execute(SchedulableContext ctx) {
        Database.executeBatch(new MyBatch());
    }
}
// Schedule:
System.schedule('Job 1', '0 0 1 * * ?', new MyScheduler()); // CRON
```

### Choose async type by use case

| Need | Use |
|---|---|
| Quick fire-and-forget callout | `@future(callout=true)` |
| Pass complex types or chain | Queueable |
| Process millions of records | Batch |
| Run on a schedule | Schedulable (often kicks off Batch) |

---

## Lightning Web Components (LWC)

Modern UI framework for Salesforce. Standards-based (Web Components, ES Modules).

### File structure

```
myComponent/
├─ myComponent.html      # Template
├─ myComponent.js        # JS logic
├─ myComponent.js-meta.xml  # Metadata (where it appears, properties)
└─ myComponent.css       # Styles (optional)
```

### Sample component

```javascript
// myComponent.js
import { LightningElement, api, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';

export default class MyComponent extends LightningElement {
    @api recordId;
    @wire(getAccounts) accounts;
}
```

```html
<!-- myComponent.html -->
<template>
    <template lwc:if={accounts.data}>
        <template for:each={accounts.data} for:item="acc">
            <p key={acc.Id}>{acc.Name}</p>
        </template>
    </template>
</template>
```

### LWC decorators

- `@api` - public property (input from parent)
- `@track` - reactive property (legacy; most properties are reactive by default in LWC)
- `@wire` - declarative data via Apex method or Lightning Data Service

### Lightning Data Service (LDS)

Component-level data layer for record CRUD without writing Apex:

- `lightning/uiRecordApi` - getRecord, createRecord, updateRecord, deleteRecord
- Caches records, no DML/SOQL governor cost (recommended over Apex when possible)

### LWC vs Aura

- **LWC** - modern, faster, standards-based
- **Aura** - older Lightning framework; still supported but new dev should use LWC
- Both can coexist on the same page

---

## Visualforce (legacy)

Older UI framework. Server-rendered.

```html
<apex:page controller="MyController">
    <apex:form>
        <apex:pageBlock>
            <apex:inputText value="{!searchTerm}" />
            <apex:commandButton action="{!search}" value="Search" />
        </apex:pageBlock>
    </apex:form>
</apex:page>
```

Backed by an Apex controller class. Salesforce is migrating away from Visualforce; new dev should use LWC. PD1 still tests it.

---

## Testing

Apex test classes are required for production deployment - **75% code coverage minimum**.

### Test class

```apex
@isTest
private class AccountServiceTest {
    @TestSetup
    static void setupData() {
        Account a = new Account(Name='Test');
        insert a;
    }

    @isTest
    static void testUpdateRevenue() {
        // Arrange
        Account a = [SELECT Id, AnnualRevenue FROM Account LIMIT 1];
        a.AnnualRevenue = 1000;
        update a;

        // Act
        Test.startTest();
        AccountService svc = new AccountService(new List<Account>{a});
        svc.updateRevenue();
        Test.stopTest();

        // Assert
        Account result = [SELECT AnnualRevenue FROM Account WHERE Id = :a.Id];
        System.assertEquals(1100, result.AnnualRevenue);
    }
}
```

### Test best practices

- `@isTest` annotations on class and methods
- `Test.startTest()` / `Test.stopTest()` resets governor limits and forces async to run synchronously
- Don't use `seeAllData=true` (avoid dependency on org data; create test data)
- `@TestSetup` for shared setup
- Use **Test.Mocking** for HTTP callouts (`HttpCalloutMock` interface)
- 75% coverage org-wide; individual triggers must have 1%+ coverage but practical minimum is 75%

---

## Governor Limits (must memorize)

| Limit | Sync | Async |
|---|---|---|
| Total SOQL queries | 100 | 200 |
| Total SOQL rows returned | 50,000 | 50,000 |
| Total DML statements | 150 | 150 |
| Total DML rows | 10,000 | 10,000 |
| CPU time | 10,000 ms | 60,000 ms |
| Heap size | 6 MB | 12 MB |
| Total callouts | 100 | 100 |
| Callout timeout | 120 sec | 120 sec |
| Future calls | 50 | n/a |
| Batch jobs concurrent | 5 | n/a |

Bulkifying = staying within these limits despite mass operations.

---

## Common exam triggers

- "Avoid SOQL in for loop" → bulkify; query before the loop, store in collection
- "Update related records after parent insert" → after-insert trigger with related-record DML
- "Run heavy logic that takes >10s" → Batch Apex or Queueable
- "Chain async jobs" → Queueable with `enqueueJob` in `execute`
- "Test code requires data" → Create test data in `@TestSetup` (avoid `seeAllData=true`)
- "HTTP callout in trigger" → Not allowed synchronously; use `@future(callout=true)` or Queueable
- "Custom UI on record page" → Lightning Web Component
- "Display Account list with reactive updates" → LWC with `@wire` to Apex / LDS
- "Force test code to run async synchronously" → `Test.startTest()` / `Test.stopTest()`
- "Trigger fires multiple times for one record" → Recursion guard with static class flag
- "Bypass sharing for system job" → `without sharing`
- "Pass an object as @future arg" → Not allowed; serialize to JSON or use Queueable

---

## Highest-yield facts

1. **Triggers should be bulkified** - work with `Trigger.new` as List
2. **No SOQL/DML in loops** - the #1 anti-pattern
3. **75% test coverage required** for production deployment
4. **Future = primitives only**, Queueable = any types + chaining
5. **Batch for millions of records**, returns QueryLocator from `start()`
6. **LWC is the modern UI framework** (LDS for record CRUD without Apex)
7. **Static methods are stateless**; non-static maintain state per instance
8. **`with sharing` respects user access**; `without sharing` bypasses
9. **`@future(callout=true)`** for HTTP callouts from sync context
10. **Test.startTest/stopTest** resets governor limits and runs async sync
