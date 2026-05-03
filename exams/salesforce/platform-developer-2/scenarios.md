# Salesforce PDII - Exam-Style Scenarios

15 scenarios mirroring PDII question style: long context, code samples, multiple plausible answers. The "best" answer is usually the one that scales, respects governor limits, and follows Salesforce patterns.

---

### Scenario 1: Bulk trigger updating parent rollups

**A trigger on `Order_Line__c` (child of `Order__c` via master-detail) needs to recalculate `Order__c.Total_Amount__c` when lines are inserted, updated, or deleted. The org regularly imports 50,000 lines at a time via Data Loader.**

**Best answer:** Master-detail relationships natively support roll-up summary fields - prefer the declarative roll-up over Apex when possible. If business logic requires Apex (e.g., conditional summing, weighted totals):

1. Single trigger on `Order_Line__c` with after insert / after update / after delete / after undelete.
2. Collect parent `Order__c` Ids into a `Set<Id>` from `Trigger.new` and `Trigger.old`.
3. Single SOQL with subquery: `SELECT Id, (SELECT Amount__c FROM Order_Lines__r) FROM Order__c WHERE Id IN :orderIds`.
4. Recalculate in Apex; single `update` of parents.
5. Bulk-test with 200+ child records inserted / updated / deleted.

Data Loader chunks at 200 records per call by default, so the trigger runs many times. Bulk safety per invocation is what matters.

---

### Scenario 2: Async chain with complex objects

**An order-fulfillment process has 4 steps that must run sequentially: (1) validate inventory via external API, (2) charge customer via Stripe, (3) generate shipping label via FedEx API, (4) update Salesforce records. Each step needs the prior step's response to proceed.**

**Best answer:** Queueable chain. Each step is a `Queueable, Database.AllowsCallouts` class that accepts the prior step's result via constructor. The last line of `execute()` enqueues the next:

```apex
public class ChargeCustomer implements Queueable, Database.AllowsCallouts {
    private Order__c order;
    public ChargeCustomer(Order__c order) { this.order = order; }
    public void execute(QueueableContext ctx) {
        // ... charge via callout
        if (!Test.isRunningTest()) {
            System.enqueueJob(new GenerateLabel(order));
        }
    }
}
```

`@future` is wrong because (a) it can't accept sObjects, (b) it can't be chained from another `@future`. Batch is wrong because there's no record set to iterate. Schedulable is wrong because there's no schedule.

---

### Scenario 3: Process 80M records nightly

**A telecom org needs to recalculate `Customer__c.Lifetime_Value__c` for all 80M customer records every night. Each record's calculation depends on summing related `Usage_Event__c` records (avg 200 per customer).**

**Best answer:** Schedulable + Batchable.

- Schedulable runs at `'0 0 2 * * ?'` and calls `Database.executeBatch(new RecalcLTVBatch(), 200)`.
- Batchable's `start()` returns `Database.QueryLocator` over `Customer__c` (handles up to 50M; for 80M, chain another batch from `finish()` or use a flag-based filter to process in halves on alternating nights).
- `execute()` queries `Usage_Event__c WHERE Customer__c IN :scope` once per chunk - one SOQL per 200 customers, not per customer.
- `Database.Stateful` to accumulate processed/failed counts.
- Email summary in `finish()`.

Anti-pattern: querying usage events inside the loop over `scope` (one SOQL per customer = governor death).

---

### Scenario 4: HTTP callout from a synchronous trigger

**A trigger on `Lead` after insert needs to register the lead with a marketing automation platform via REST API.**

**Best answer:** Synchronous triggers cannot make HTTP callouts. Two valid options:

1. `@future(callout=true)` static method, called from the trigger with `Set<Id>` of new lead IDs (re-query inside the future method).
2. `Queueable, Database.AllowsCallouts` enqueued from the trigger.

Prefer Queueable when:
- You need to chain
- You need to pass complex types
- You need transaction control / monitoring (Queueable shows up in Apex Jobs)

Wrap the call in `if (!System.isFuture() && !System.isBatch())` if there's risk of the trigger firing inside an already-async context.

---

### Scenario 5: LWC reactive search with Apex

**An LWC must display `Account` records filtered by a search term that updates as the user types. Search should be debounced to avoid excessive Apex calls.**

**Best answer:**

```apex
public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> search(String term) {
        if (String.isBlank(term)) return new List<Account>();
        String like = '%' + term + '%';
        return [SELECT Id, Name, Industry FROM Account WHERE Name LIKE :like LIMIT 50];
    }
}
```

```javascript
import { LightningElement, wire } from 'lwc';
import searchAccounts from '@salesforce/apex/AccountController.search';

export default class AccountSearch extends LightningElement {
    term = '';
    timer;

    @wire(searchAccounts, { term: '$term' })
    accounts;

    handleInput(event) {
        clearTimeout(this.timer);
        const value = event.target.value;
        this.timer = setTimeout(() => { this.term = value; }, 300);
    }
}
```

`$term` makes the wire reactive to property changes. `cacheable=true` enables LDS caching but disallows DML.

---

### Scenario 6: Mixed DML exception

**Code attempts to insert a `User` and an `Account` in the same transaction. It fails with `MIXED_DML_OPERATION`.**

**Best answer:** Setup objects (User, Group, GroupMember, Permission Set assignments, Queue, etc.) cannot be inserted/updated in the same synchronous transaction as non-setup objects. Fix options:

1. Insert User first, then enqueue a Queueable to insert the Account asynchronously (separate transactions).
2. Wrap the User insert in `System.runAs(thisUser)` block (test code only).
3. Use `@future` for one of the two operations.

In production code, the Queueable approach is canonical. `runAs` is a test-only construct.

---

### Scenario 7: Stub API for service mocking

**A service class `OrderService` depends on `PaymentGateway` (concrete class with `charge(amount)` method that hits Stripe). Tests must not hit Stripe. The team prefers not to refactor `PaymentGateway` to extract an interface.**

**Best answer:** Use the Stub API to mock the concrete class:

```apex
public class PaymentStub implements System.StubProvider {
    public Object handleMethodCall(Object stubbed, String method, Type returnType,
                                   List<Type> paramTypes, List<String> paramNames,
                                   List<Object> args) {
        if (method == 'charge') return new ChargeResult(true, 'tx_123');
        return null;
    }
}

@isTest
static void testOrderCheckout() {
    PaymentGateway mockGw = (PaymentGateway) Test.createStub(PaymentGateway.class, new PaymentStub());
    OrderService svc = new OrderService(mockGw);
    // ... assertions
}
```

Stub API limitations: cannot stub static methods, system types, or sealed classes. For static methods, refactor to instance method or use a wrapper.

---

### Scenario 8: Platform Event vs CDC

**Different parts of the org need to react to (a) a custom "OrderShipped" notification published by the order pipeline, and (b) any field-level change to Account.**

**Best answer:**

- **(a) OrderShipped:** Platform Event. Define `Order_Shipped__e` with custom fields. Publish via `EventBus.publish(evt)`. Subscribe via Apex trigger on `Order_Shipped__e`, LWC `empApi`, Flow Platform-Event-Triggered Flow, or external system via Pub/Sub API.
- **(b) Account changes:** Change Data Capture. Enable CDC on Account in setup. Subscribe via Apex trigger on `AccountChangeEvent` or external Pub/Sub API consumer.

Don't use a Platform Event for record-level diffs (CDC does it for free). Don't use CDC for custom business events (they're not record changes).

---

### Scenario 9: SOQL non-selectivity

**A nightly batch query takes 60+ seconds and sometimes hits the SELECTIVITY error: `SOQL_OFFSET_NOT_AVAILABLE_FOR_OBJECT_ON_THIS_API_VERSION`. Query: `SELECT Id FROM Account WHERE Custom_Status__c = 'Active'` against 5M Account rows where 80% are 'Active'.**

**Best answer:** The filter is not selective: 80% of records match, way above the 10% threshold. Options:

1. Add a more selective filter: `WHERE Custom_Status__c = 'Active' AND LastModifiedDate = LAST_N_DAYS:1` (audit fields are indexed).
2. Mark `Custom_Status__c` as External Id or Unique to add a custom index. (Custom indexes still need <30% selectivity to be picked up.)
3. Request a custom index from Salesforce support if the field is high-cardinality.
4. Use **Batch Apex with QueryLocator** - the QueryLocator bypasses the 50K row limit and is the only way to safely process millions of rows.

Use Developer Console -> Query Plan tool to verify Leading Operation = "Index" after changes.

---

### Scenario 10: LWC sibling communication

**Three LWCs on the same Lightning App Page need to share state: a filter component, a list component, and a detail panel. They are siblings, not parent-child.**

**Best answer:** Lightning Message Service (LMS) with a custom message channel.

1. Create `OrderChannel__c` message channel metadata.
2. Each component imports the channel and `MessageContext`:

```javascript
import { LightningElement, wire } from 'lwc';
import { publish, subscribe, MessageContext } from 'lightning/messageService';
import ORDER_CHANNEL from '@salesforce/messageChannel/OrderChannel__c';

@wire(MessageContext) messageContext;

connectedCallback() {
    this.subscription = subscribe(this.messageContext, ORDER_CHANNEL,
        (msg) => this.handleMessage(msg));
}

publishFilter(filter) {
    publish(this.messageContext, ORDER_CHANNEL, { type: 'filter', value: filter });
}
```

LMS works across LWC, Aura, and Visualforce. Custom events with `bubbles: true, composed: true` only work within the same component tree, so they fail for siblings.

---

### Scenario 11: Recursion guard

**An after-update trigger on `Account` updates child `Contact` records. Each `Contact` update fires a `Contact` trigger that updates `Account.Total_Contacts__c`, which fires the original `Account` trigger again. Result: stack overflow.**

**Best answer:** Static class flag pattern, scoped per-trigger:

```apex
public class TriggerControl {
    public static Boolean accountAfterUpdate = false;
    public static Boolean contactAfterUpdate = false;
}

trigger AccountTrigger on Account (after update) {
    if (TriggerControl.accountAfterUpdate) return;
    TriggerControl.accountAfterUpdate = true;
    try {
        new AccountTriggerHandler().run();
    } finally {
        TriggerControl.accountAfterUpdate = false;
    }
}
```

Static class fields persist for the duration of the transaction; the flag prevents re-entry from chained DML. Reset in `finally` so subsequent independent transactions still execute.

Alternative: store processed Ids in a `Set<Id>` on the helper class and skip records already processed.

---

### Scenario 12: Test class with HTTP callout and DML

**A class makes an HTTP callout, parses the JSON response, and inserts records based on the response. Test class must achieve 90% coverage and not hit the real endpoint.**

**Best answer:**

```apex
public class JsonMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        HttpResponse r = new HttpResponse();
        r.setStatusCode(200);
        r.setHeader('Content-Type', 'application/json');
        r.setBody('{"orders":[{"name":"Order 1","total":100}]}');
        return r;
    }
}

@isTest
private class OrderImporterTest {
    @TestSetup
    static void setup() {
        Account a = new Account(Name='Test');
        insert a;
    }

    @isTest
    static void importOrders_success() {
        Test.setMock(HttpCalloutMock.class, new JsonMock());
        Test.startTest();
        OrderImporter.run();
        Test.stopTest();
        List<Order__c> orders = [SELECT Id FROM Order__c];
        System.assertEquals(1, orders.size());
    }

    @isTest
    static void importOrders_apiFailure() {
        Test.setMock(HttpCalloutMock.class, new FailMock());
        try {
            OrderImporter.run();
            System.assert(false, 'Expected exception');
        } catch (OrderImporter.ApiException e) {
            System.assert(e.getMessage().contains('500'));
        }
    }

    private class FailMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse r = new HttpResponse();
            r.setStatusCode(500);
            return r;
        }
    }
}
```

Cover happy path, error path, and (where relevant) bulk path with 200 records.

---

### Scenario 13: External Services vs Apex callout

**Business analysts need to invoke an external HR system from Flow when a Contact's `Status__c` changes. The external system has an OpenAPI 3.0 spec. Developers don't want to write a custom Apex callout class for every Flow.**

**Best answer:** External Services. Import the OpenAPI schema in Setup -> External Services. Salesforce auto-generates invocable actions for each operation, callable from Flow without code. Configure a Named Credential for the endpoint + auth.

Apex callout is right when:
- The integration logic is complex (transformation, retries, multi-step orchestration)
- You need response parsing into custom objects beyond what External Services supports
- There's no schema (no OpenAPI / JSON Schema)

---

### Scenario 14: Continuation pattern for long callout

**An LWC calls an external pricing engine that takes 8-15 seconds to respond. The standard 5-second `@AuraEnabled` callout times out.**

**Best answer:** Continuation pattern.

```apex
public with sharing class PricingController {
    @AuraEnabled(continuation=true)
    public static Object getPricing(String sku) {
        Continuation con = new Continuation(40); // 40 sec timeout
        con.continuationMethod = 'processResponse';
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Pricing_API/v1/' + sku);
        req.setMethod('GET');
        con.addHttpRequest(req);
        return con;
    }

    @AuraEnabled
    public static Object processResponse(List<String> labels, Object state) {
        HttpResponse res = Continuation.getResponse(labels[0]);
        return res.getBody();
    }
}
```

Continuations allow up to 120 seconds for an async callout from Visualforce / Aura / LWC without holding a server thread. Limited to up to 3 callouts per Continuation, max 1MB request/response.

Alternative: Queueable + Platform Event to push the result back to the LWC via `empApi` subscription.

---

### Scenario 15: 2GP packaging and source-driven deployment

**A team has a custom app that they want to install in multiple customer orgs. They use VS Code + SFDX + GitHub. They want versioned, source-controlled releases.**

**Best answer:** 2nd Generation Managed Packages (2GP) or Unlocked Packages, depending on the distribution model.

- **2GP managed:** for AppExchange products, namespaced, version-controlled in source.
- **Unlocked:** for internal modular development, no namespace required.

Workflow:

```bash
# One-time setup
sf package create --name "MyApp" --package-type Unlocked --path force-app
# Track in sfdx-project.json (auto-edited)

# Each release
sf package version create --package "MyApp" --installation-key-bypass --wait 10
# Returns SubscriberPackageVersionId

# Install in target org
sf package install --package 04t... --target-org customer1
```

Change Sets are wrong: not source-controlled, UI-driven, slow, limited metadata. 1GP managed packages are wrong: legacy, no source-control story.

CI/CD: GitHub Actions runs `sf package version create` on tag, `sf package install` on each customer org.

---

## Scoring guide

- **13-15:** Schedule the exam.
- **10-12:** Re-read fact-sheet, weak-domain notes, and Trailhead Advanced Apex Specialist.
- **<10:** More hands-on coding before retesting. PDII rewards muscle memory.

PDII questions almost always have **two or three "code-correct" answers**. The right answer is the one that:

1. Respects governor limits at scale (200, 50K, 50M)
2. Uses the modern recommended pattern (Queueable over @future, LWC over Aura, Named Credentials over hardcoded URLs)
3. Avoids the well-known anti-patterns (SOQL/DML in loops, mixed DML, recursion without guard)
4. Is testable (interface dependencies, Stub API mockable, no `seeAllData=true`)
