---
last-updated: 2026-05-03
---

# Salesforce Platform Developer II (PDII) - Fact Sheet

## Quick Reference

**Cost:** $200 USD ($100 retake)
**Format:** 60 multiple-choice / multi-select (proctored, single exam as of 2026)
**Duration:** 120 minutes
**Passing:** 70%
**Prereq:** Active PDI credential

**[Credential page](https://trailhead.salesforce.com/credentials/platformdeveloperii)**
**[Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/)**
**[Apex Reference Guide](https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/)**
**[LWC Developer Guide](https://developer.salesforce.com/docs/component-library/documentation/en/lwc)**
**[Integration Patterns Guide](https://architect.salesforce.com/decision-guides/integration-patterns)**
**[REST API Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/)**

---

## Governor limits (must memorize cold)

| Limit | Sync | Async |
|---|---|---|
| SOQL queries | 100 | 200 |
| SOQL rows returned | 50,000 | 50,000 |
| SOSL queries | 20 | 20 |
| DML statements | 150 | 150 |
| DML rows | 10,000 | 10,000 |
| CPU time | 10,000 ms | 60,000 ms |
| Heap size | 6 MB | 12 MB |
| HTTP callouts | 100 | 100 |
| Callout total time | 120 sec | 120 sec |
| Future calls per txn | 50 | n/a |
| Queueable jobs per txn | 50 | 1 (chained from queueable: 1 in test, otherwise 50) |
| Queueable depth | unlimited prod / 5 chained in test | n/a |
| Batch concurrent jobs | 5 | n/a |
| Async daily executions | 250,000 (or 200x user licenses, whichever is greater) | n/a |
| `EventBus.publish` events | per-txn limit applies; subscribers run async | n/a |
| Email invocations | 10 (sendEmail) | n/a |

Bulkification = staying within these limits despite mass operations. **Every PDII trigger/handler answer must respect bulk patterns.**

---

## Apex class structure (advanced)

```apex
public with sharing class OpportunityService {
    @TestVisible private static Boolean bypassRecursion = false;

    public interface IOpportunityRepo {
        List<Opportunity> findByStage(String stage);
    }

    public class StageChangeException extends Exception {}

    private final IOpportunityRepo repo;

    public OpportunityService(IOpportunityRepo repo) {
        this.repo = repo;
    }

    public void closeWon(Set<Id> oppIds) {
        List<Opportunity> opps = repo.findByStage('Negotiation');
        // ... business logic
    }
}
```

### Sharing keywords

| Keyword | Behavior |
|---|---|
| `with sharing` | Enforces running user's record-level sharing |
| `without sharing` | Bypasses sharing (system context) |
| `inherited sharing` | Inherits caller's mode; safer default for utility classes |

Triggers default to `without sharing` unless declared in a class with explicit sharing. Apex REST endpoints execute as the calling user.

### `WITH SECURITY_ENFORCED` and `Security.stripInaccessible`

```apex
List<Account> accs = [SELECT Id, Name, AnnualRevenue FROM Account WITH SECURITY_ENFORCED];

SObjectAccessDecision decision = Security.stripInaccessible(
    AccessType.READABLE, [SELECT Id, Name, AnnualRevenue FROM Account]);
List<Account> safeList = (List<Account>) decision.getRecords();
```

`WITH SECURITY_ENFORCED` throws if any field is not accessible. `stripInaccessible` removes inaccessible fields silently and returns a sanitized list.

---

## SOQL (advanced)

### Selective filters and indexed fields

A query is "selective" when filtering reduces the candidate set below the org-specific threshold. Indexed fields:

- `Id`, `Name` (auto-indexed)
- `OwnerId`, `LookupFields`, `MasterDetail`
- `External Id` (custom flag - this creates a custom index)
- `Unique` fields
- Audit fields (`CreatedDate`, `LastModifiedDate`, `SystemModstamp`)
- Custom indexes via Salesforce support

**Selectivity threshold:** 10% (under 333K records) or 5% (over 333K). Standard indexes ~30%. Custom indexes ~10%.

### Skinny tables

Salesforce-managed denormalized table for an object with up to 100 fields. Improves report and list view performance for tables with millions of records. Created via Salesforce support; visible to admins as a tuning option, not directly queryable.

### Bind variables and dynamic SOQL

```apex
String name = 'Acme%';
List<Account> accs = [SELECT Id FROM Account WHERE Name LIKE :name];

// Dynamic
String soql = 'SELECT Id FROM Account WHERE Name LIKE :name';
List<Account> dyn = Database.query(soql);

// Sanitize when concatenating
String safe = String.escapeSingleQuotes(userInput);
```

### Query plan

Use Developer Console -> Query Plan tool to see leading operation type (Index, TableScan, Other). Optimize until LeadingOperationType = "Index".

### Cursors and chunking

For >50K rows in a single transaction, use **Batch Apex with `Database.QueryLocator`** (50M record cap) or **Database.getQueryLocator** in a Queueable that re-queues itself.

---

## SOSL

```apex
List<List<sObject>> results = [
    FIND :searchTerm IN ALL FIELDS
    RETURNING Account(Id, Name WHERE Industry='Technology'),
              Contact(Id, LastName)
    LIMIT 100
];
```

- 20 SOSL queries per transaction
- 2,000 records returned
- Use SOSL when searching across multiple objects with full-text terms; SOQL for filtered single-object queries

---

## Async Apex - decision matrix

| Tool | When to use | Args | Chaining | Callouts |
|---|---|---|---|---|
| `@future` | Fire-and-forget, sync triggers needing callouts | Primitives only | No | `@future(callout=true)` |
| Queueable | Pass complex types, chain jobs | Any type via constructor | Yes (50/txn, depth limited in test only) | `Database.AllowsCallouts` |
| Batchable | Process millions of records | sObject scope, custom Iterable | Via `finish()` | `Database.AllowsCallouts` |
| Schedulable | Run on cron schedule | none | Yes (often launches Batch) | n/a |
| Platform Events | Pub/sub event-driven | event sObject | Via subscriber triggers | n/a |
| Change Data Capture | React to record CRUD | CDC event | Via triggers | n/a |

### Future

```apex
public class CalloutHelper {
    @future(callout=true)
    public static void postToService(Set<Id> ids, String url) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        HttpResponse res = h.send(req);
        if (res.getStatusCode() != 200) {
            System.debug(LoggingLevel.ERROR, 'Callout failed: ' + res.getStatusCode());
        }
    }
}
```

Constraints: static, void, primitive args (no sObjects), can't be called from another `@future` or from Batch.

### Queueable with chaining + callouts

```apex
public class SyncOpportunitiesQueueable implements Queueable, Database.AllowsCallouts {
    private List<Id> oppIds;
    private Integer offset;

    public SyncOpportunitiesQueueable(List<Id> oppIds, Integer offset) {
        this.oppIds = oppIds;
        this.offset = offset;
    }

    public void execute(QueueableContext ctx) {
        List<Id> chunk = new List<Id>();
        Integer end = Math.min(offset + 50, oppIds.size());
        for (Integer i = offset; i < end; i++) chunk.add(oppIds[i]);

        // ... do callout for chunk
        if (end < oppIds.size() && !Test.isRunningTest()) {
            System.enqueueJob(new SyncOpportunitiesQueueable(oppIds, end));
        }
    }
}
```

Test mode chains max 5 deep. Production has no documented chain limit (use stack control to avoid runaway).

### Batch Apex (stateful)

```apex
public class RevenueRecalcBatch implements Database.Batchable<sObject>, Database.Stateful {
    public Integer processed = 0;
    public List<Id> failedIds = new List<Id>();

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, AnnualRevenue FROM Account WHERE Active__c = true');
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {
        for (Account a : scope) {
            try {
                a.AnnualRevenue = (a.AnnualRevenue == null ? 0 : a.AnnualRevenue) * 1.05;
            } catch (Exception e) {
                failedIds.add(a.Id);
            }
        }
        Database.SaveResult[] results = Database.update(scope, false);
        for (Database.SaveResult r : results) {
            if (r.isSuccess()) processed++;
            else failedIds.add(r.getId());
        }
    }

    public void finish(Database.BatchableContext bc) {
        // Optional: chain another batch, send email, log
    }
}

// Run:
Id jobId = Database.executeBatch(new RevenueRecalcBatch(), 200);
```

`Database.Stateful` preserves instance variables across batch executions; otherwise instance state resets per chunk.

### Schedulable

```apex
public class NightlyRecalcScheduler implements Schedulable {
    public void execute(SchedulableContext ctx) {
        Database.executeBatch(new RevenueRecalcBatch(), 200);
    }
}
// CRON: 'seconds minutes hours dayOfMonth month dayOfWeek [year]'
String cron = '0 0 2 * * ?'; // every day 02:00
System.schedule('Nightly Recalc', cron, new NightlyRecalcScheduler());
```

---

## Integration patterns (35% domain)

### REST API endpoint in Apex

```apex
@RestResource(urlMapping='/orders/*')
global with sharing class OrderResource {
    @HttpGet
    global static Order__c doGet() {
        RestRequest req = RestContext.request;
        Id orderId = req.requestURI.substringAfterLast('/');
        return [SELECT Id, Status__c FROM Order__c WHERE Id = :orderId];
    }

    @HttpPost
    global static Id doPost(String name, Decimal total) {
        Order__c o = new Order__c(Name=name, Total__c=total);
        insert o;
        return o.Id;
    }
}
```

URL: `/services/apexrest/orders/<id>`. Methods supported: `@HttpGet`, `@HttpPost`, `@HttpPut`, `@HttpPatch`, `@HttpDelete`.

### SOAP / WSDL2Apex

```bash
sf force apex generate webservice --wsdl path/to/service.wsdl
```

Generates Apex stub classes. Less common in modern integrations; REST + Named Credentials preferred.

### Named Credentials

Endpoint + auth (OAuth, named principal, per-user OAuth) configured in setup. Reference in code:

```apex
HttpRequest req = new HttpRequest();
req.setEndpoint('callout:My_Named_Cred/path');
req.setMethod('GET');
HttpResponse res = new Http().send(req);
```

Auth headers are auto-injected. Avoid hardcoding tokens.

### External Services

Declarative integration. Import OpenAPI / JSON schema, Salesforce generates invocable actions usable in Flow without code.

### Platform Events

```apex
// Define: Order_Placed__e (custom event with fields)
Order_Placed__e evt = new Order_Placed__e(Order_Id__c = ord.Id, Total__c = ord.Total__c);
Database.SaveResult sr = EventBus.publish(evt);
if (!sr.isSuccess()) {
    for (Database.Error err : sr.getErrors()) System.debug(err.getMessage());
}
```

### Change Data Capture (CDC)

System publishes events when records are created/updated/deleted/undeleted on subscribed objects. Subscribe via:

- Apex trigger on `__ChangeEvent` (e.g., `AccountChangeEvent`)
- Pub/Sub API (gRPC) for external subscribers
- Streaming API
- LWC via empApi
- Flow

### Outbound Messaging

Workflow-based SOAP message sent on record change. Largely replaced by Platform Events / external API callouts.

### Pub/Sub API

Modern gRPC-based API for high-throughput streaming of Platform Events and CDC. External clients subscribe with replay support. Replaces older CometD-based Streaming API.

### Integration pattern decision matrix

| Need | Pattern |
|---|---|
| External system pushes data into Salesforce | REST API / Apex REST / Bulk API |
| Salesforce pushes data to external system | Outbound Messaging / Apex Callout (Queueable + Named Cred) |
| Real-time bi-directional event stream | Platform Events / CDC / Pub/Sub API |
| Process millions of records nightly | Bulk API 2.0 |
| Trigger external workflow from record change | Platform Event published from trigger |
| Mash up external data inline on a record | External Objects (OData) / Salesforce Connect |

---

## Lightning Web Components

### Lifecycle hooks

| Hook | When |
|---|---|
| `constructor()` | Component instantiation; no DOM yet, no `@api` props |
| `connectedCallback()` | Element inserted into DOM; `@api` props available |
| `renderedCallback()` | After every render (use a flag to run only once) |
| `disconnectedCallback()` | Element removed from DOM; cleanup subscriptions |
| `errorCallback(error, stack)` | Captures errors from descendant components |

### Reactivity

```javascript
import { LightningElement, api, wire, track } from 'lwc';
import getOpps from '@salesforce/apex/OppController.getByStage';

export default class OppList extends LightningElement {
    @api recordId;
    stage = 'Negotiation';

    @wire(getOpps, { stage: '$stage' })
    wiredOpps;  // wiredOpps.data, wiredOpps.error

    handleStageChange(e) { this.stage = e.detail.value; } // re-fires wire
}
```

`$propName` syntax in `@wire` config makes the wire reactive to property changes. Primitive properties are reactive automatically. Objects/arrays only deep-react if reassigned (or use `@track`).

### Imperative Apex

```javascript
import getOpps from '@salesforce/apex/OppController.getByStage';
async load() {
    try {
        this.opps = await getOpps({ stage: this.stage });
    } catch (e) { this.error = e.body.message; }
}
```

Use imperative when: action-triggered (button click), needs DML, needs to await before render.

### Events

```javascript
// Child fires
this.dispatchEvent(new CustomEvent('selected', {
    detail: { id: this.recordId },
    bubbles: true,    // bubble up DOM
    composed: true    // cross shadow boundary
}));

// Parent listens
<c-child onselected={handleSelected}></c-child>
```

For sibling/distant components, use **Lightning Message Service**:

```javascript
import { publish, subscribe, MessageContext } from 'lightning/messageService';
import ORDER_CHANNEL from '@salesforce/messageChannel/OrderChannel__c';

@wire(MessageContext) messageContext;

connectedCallback() {
    this.sub = subscribe(this.messageContext, ORDER_CHANNEL, (msg) => this.handle(msg));
}
```

### Lightning Data Service (LDS)

Component-level CRUD without Apex; cached, no governor cost:

```javascript
import { getRecord, updateRecord, createRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Account.Name';

@wire(getRecord, { recordId: '$recordId', fields: [NAME_FIELD] }) account;

async save() {
    await updateRecord({ fields: { Id: this.recordId, Name: 'New' }});
}
```

### `@AuraEnabled` flavors

| Annotation | Use |
|---|---|
| `@AuraEnabled` | Imperative call from LWC; DML allowed |
| `@AuraEnabled(cacheable=true)` | Wire-compatible; client-side cache; **no DML** |
| `@AuraEnabled(continuation=true)` | Long-running callout (>5s) returning a Continuation |

---

## Apex Test patterns

### Test class with Stub API mock

```apex
@isTest
private class OpportunityServiceTest {

    private class MockRepo implements OpportunityService.IOpportunityRepo {
        public List<Opportunity> findByStage(String stage) {
            return new List<Opportunity>{
                new Opportunity(Id='006000000000001AAA', StageName=stage)
            };
        }
    }

    @TestSetup
    static void setup() {
        Account a = new Account(Name='Acme');
        insert a;
    }

    @isTest
    static void closeWon_marksOpps() {
        OpportunityService svc = new OpportunityService(new MockRepo());

        Test.startTest();
        svc.closeWon(new Set<Id>{ '006000000000001AAA' });
        Test.stopTest();

        // assertions...
    }
}
```

### Stub API for mocking concrete classes

```apex
public class StubExample implements System.StubProvider {
    public Object handleMethodCall(Object stubbed, String method, Type returnType,
                                   List<Type> paramTypes, List<String> paramNames,
                                   List<Object> args) {
        if (method == 'getName') return 'mocked';
        return null;
    }
}

@isTest
static void testWithStub() {
    AccountService svc = (AccountService) Test.createStub(AccountService.class, new StubExample());
    System.assertEquals('mocked', svc.getName());
}
```

Stub API allows mocking concrete classes without an interface (cannot stub static methods).

### HttpCalloutMock

```apex
public class MockResponse implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        HttpResponse r = new HttpResponse();
        r.setStatusCode(200);
        r.setBody('{"status":"ok"}');
        return r;
    }
}

@isTest
static void testCallout() {
    Test.setMock(HttpCalloutMock.class, new MockResponse());
    Test.startTest();
    String result = MyService.callExternal();
    Test.stopTest();
    System.assertEquals('ok', result);
}
```

For multi-callout flows, use `MultiStaticResourceCalloutMock` or a custom mock that switches by URL.

### Test data factory

```apex
@isTest
public class TestDataFactory {
    public static List<Account> createAccounts(Integer n) {
        List<Account> accs = new List<Account>();
        for (Integer i = 0; i < n; i++) accs.add(new Account(Name='Test ' + i));
        insert accs;
        return accs;
    }
}
```

Centralize test data creation; avoid `seeAllData=true`.

---

## Deployment

| Tool | Use |
|---|---|
| Change Sets | UI sandbox-to-sandbox / sandbox-to-prod; slow, limited metadata |
| Salesforce CLI (`sf project deploy start`) | Source-driven; works with git |
| Metadata API | Programmatic deployment (CI/CD) |
| 1GP packages | Legacy managed packages (single namespace) |
| 2GP packages | Modern; track package versions in source control; supported by SFDX |
| Unlocked packages | 2GP without namespace; for internal modular dev |
| DevOps Center | Salesforce-native pipeline UI on top of source control |

### Test execution levels

- `RunSpecifiedTests` - explicit list, fastest
- `RunLocalTests` - all tests in org except managed packages (default for prod)
- `RunAllTestsInOrg` - everything

---

## Highest-yield PDII facts

1. **Bulkify everything** - never SOQL/DML in a loop; always handle 200 records.
2. **Queueable > @future** - pass complex objects, chain, callouts via `Database.AllowsCallouts`.
3. **Batch for >50K rows** - QueryLocator handles 50M; `Database.Stateful` preserves state.
4. **Recursion guards** - static class flag pattern is the canonical answer.
5. **Trigger handlers** - one trigger per object, dispatcher to handler class.
6. **Mixed DML error** - setup objects (User, Group, etc.) can't be inserted with non-setup objects in the same txn; use `System.runAs` or async.
7. **Stub API + dependency injection** - pass interfaces into services for testability.
8. **`Test.startTest()` / `Test.stopTest()`** - resets governor limits; forces async to run.
9. **Selective queries** - filter on indexed fields; check Query Plan tool.
10. **Named Credentials** - never hardcode endpoints/tokens; reference `callout:My_Cred/path`.
11. **LWC `@wire` reactivity** - `$propName` config syntax re-fires on property change.
12. **Platform Events vs CDC** - Platform Events for custom messages; CDC for record-level diffs.
13. **`@AuraEnabled(cacheable=true)`** - cacheable, read-only, wire-compatible; no DML.
14. **Lightning Message Service** - cross-component / cross-DOM comms (Aura/Visualforce/LWC).
15. **`Limits.getQueries()` / `Limits.getDmlStatements()`** - check limits at runtime.
16. **Dynamic Apex** - `Schema.getGlobalDescribe()` / `getDescribe()` for schema-aware code.
17. **`Database.insert(records, false)`** - allows partial success; returns `Database.SaveResult[]`.
18. **`addError()`** in before-trigger context for graceful validation.
19. **75% test coverage** required for prod deploy; assertions required for "real" coverage.
20. **2GP packaging** - modern packaging tied to source control via SFDX.
