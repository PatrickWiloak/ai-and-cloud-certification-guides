# 05 - Testing, Debugging, Deployment

## Apex Testing

Test code is **mandatory** to deploy to production. **75% org-wide code coverage** minimum (some triggers must have at least 1% but practical minimum is 75%).

### Test class structure

```apex
@isTest
private class AccountServiceTest {

    @TestSetup
    static void setup() {
        // Test data created here is reset between methods
        List<Account> accs = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            accs.add(new Account(Name='Test ' + i));
        }
        insert accs;
    }

    @isTest
    static void testUpdateRevenue_positive() {
        // Arrange
        Account a = [SELECT Id FROM Account LIMIT 1];

        // Act
        Test.startTest();
        AccountService.updateRevenue(new List<Id>{a.Id});
        Test.stopTest();

        // Assert
        Account updated = [SELECT AnnualRevenue FROM Account WHERE Id = :a.Id];
        System.assertEquals(1000, updated.AnnualRevenue, 'Revenue should be 1000');
    }

    @isTest
    static void testUpdateRevenue_invalidId() {
        // Negative path
        try {
            AccountService.updateRevenue(new List<Id>{'001000000000000'});
            System.assert(false, 'Should have thrown');
        } catch (Exception e) {
            System.assertEquals('Account not found', e.getMessage());
        }
    }
}
```

### Best practices

1. **Annotate `@isTest`** on class and methods
2. **`@TestSetup`** for shared data (run once, reset between methods)
3. **Test.startTest() / Test.stopTest()** - resets governor limits, forces async to complete synchronously
4. **Don't use seeAllData=true** - create test data; depend on org data is fragile
5. **Cover positive and negative paths** - happy path AND edge cases / errors
6. **Cover bulk** - test with collections of 200+ records to verify bulkification
7. **Assert** - `System.assertEquals(expected, actual, message)` - asserts are required for "real" coverage

### Required test scenarios

- **Bulk insert** (with 200 records to verify bulkification)
- **Single record**
- **Failure / error case**
- **Negative case** (with `try/catch` and asserts)

### Seeing all data

```apex
@isTest(seeAllData=true)
public static void testWithOrgData() { }
```

Avoid except for legacy code that depends on org-specific data. Most modern test code creates its own data.

### Mocking HTTP callouts

```apex
public class MockHttpResponse implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{"status":"ok"}');
        return res;
    }
}

@isTest
static void testCallout() {
    Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
    // Now calls to Http.send() use the mock
    String response = MyService.callExternalApi();
    System.assertEquals('ok', response);
}
```

Real callouts in test methods throw exceptions; mocks are required.

---

## Code coverage rules

- **75%** org-wide for production deploy
- Each trigger must have **at least 1%** (so 25% rule for trigger applies elsewhere)
- Test methods themselves don't count toward coverage
- Comments don't count
- `System.assert()` calls validate behavior, drive "real" coverage

### Common coverage gaps

- Untested error paths (try/catch without `catch` test)
- Untested branches in `if/else`
- Helper methods called only from main path

---

## Debug logs

### Triggering a debug log

- Setup → Debug Logs → New Log
- Pick the user, log level, expiration time
- Subsequent activity by that user generates logs

### Log levels

NONE / ERROR / WARN / INFO / DEBUG / FINE / FINER / FINEST

Higher = more detail. Set per category:

- Apex Code (most relevant for dev)
- Database
- Workflow
- Validation
- Visualforce
- System
- Callouts

### `System.debug()`

```apex
System.debug(LoggingLevel.INFO, 'My value: ' + myVar);
```

Default level is DEBUG. Set per `System.debug(LoggingLevel.X, ...)` for finer control.

### Reading logs

- View logs in Setup → Debug Logs
- Or in Developer Console → Logs tab
- Search for specific events: USER_DEBUG, DML_BEGIN, SOQL_EXECUTE, LIMIT_USAGE

---

## Developer Console

In-browser IDE for quick exploration:

- Tabs: Open file, search, debug log
- File menu → New (Apex Class, Trigger, Visualforce, etc.)
- Execute Anonymous (Debug → Open Execute Anonymous Window) - run ad-hoc Apex
- Query Editor - run SOQL/SOSL
- Logs tab - real-time debug logs
- Test runs

For bigger projects, use **VS Code with Salesforce Extensions Pack**.

---

## VS Code with Salesforce Extensions

Modern dev experience.

- Source-driven (your code = source of truth, not org)
- Salesforce CLI (sfdx / sf) under the hood
- Project structure: `force-app/main/default/{classes,triggers,lwc,objects,...}`
- Authorize an org: `sf org login web --alias myorg`
- Deploy: `sf project deploy start` (incremental)
- Retrieve: `sf project retrieve start --metadata ApexClass:MyClass`
- Run tests: `sf apex run test`

### Scratch orgs

Ephemeral, source-driven dev orgs.

```bash
sf org create scratch --definition-file config/project-scratch-def.json --duration-days 7 --alias myscratch
sf project deploy start --target-org myscratch
sf data import tree --target-org myscratch --files data/sample-data.json
```

Useful for feature branch development - throwaway orgs that mirror production schema.

---

## Deployment options

### Change Sets

- Setup → Outbound Change Sets in source org
- Add components
- Upload to target org
- Inbound Change Set in target → Deploy

Limited to certain metadata; slow for large deployments. UI-driven; not source-controlled.

### Salesforce CLI / DevOps

```bash
# Validate without deploying
sf project deploy start --target-org production --check-only --tests-to-run AllLocal

# Deploy
sf project deploy start --target-org production --tests-to-run AllLocal
```

### Unmanaged / Managed packages

- **Unmanaged** - distribute customizations; recipient owns metadata; no version control
- **Managed (1GP / 2GP)** - AppExchange products; namespaced; versioned

### Git-based DevOps

Modern: `force-app/` directory in git, CI/CD via GitHub Actions / Azure DevOps / Salesforce DevOps Center / Copado / Gearset.

---

## Common exam triggers

- "Test with 200 records to verify bulkification" → loop create records in test, then assert
- "Test code requires HTTP callout" → `Test.setMock(HttpCalloutMock.class, new MockResp())`
- "Force async to complete in test" → `Test.startTest()` / `Test.stopTest()`
- "75% code coverage" → minimum for production deploy
- "Avoid test data dependency on org" → Don't use `seeAllData=true`; create data in `@TestSetup`
- "Run anonymous Apex" → Developer Console > Execute Anonymous
- "Debug a flow / trigger that isn't behaving" → Set up Debug Log + `System.debug()` statements
- "Migrate code from sandbox to prod" → Change Sets (UI) or Salesforce CLI (modern)
- "Ephemeral dev environment" → Scratch Org
- "Real-time CI/CD pipeline for Salesforce" → SFDX + git + GitHub Actions

---

## Best-practice testing pattern

```apex
@isTest
private class MyTriggerTest {
    @TestSetup
    static void setup() {
        List<Account> accs = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            accs.add(new Account(Name='Test ' + i));
        }
        insert accs;
    }

    @isTest
    static void testInsertBulk() {
        // Bulk test - 200 records
        List<Account> accs = [SELECT Id FROM Account];
        Test.startTest();
        // Trigger logic gets exercised here
        for (Account a : accs) {
            a.Industry = 'Technology';
        }
        update accs;
        Test.stopTest();

        List<Account> updated = [SELECT Industry FROM Account];
        for (Account a : updated) {
            System.assertEquals('Technology', a.Industry);
        }
    }

    @isTest
    static void testFailure() {
        try {
            Account bad = new Account();  // Name is required
            insert bad;
            System.assert(false, 'Should have failed');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('REQUIRED_FIELD_MISSING'));
        }
    }
}
```

This pattern: positive, negative, bulk - covers most scenarios.
