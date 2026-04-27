# 04 - Lightning Web Components, Aura, Visualforce

## UI framework history

| Era | Framework |
|---|---|
| Pre-2014 | Visualforce only |
| 2014-2018 | Lightning Components (Aura) added; Visualforce still primary |
| 2019+ | **Lightning Web Components (LWC)** is the modern standard |
| Today | LWC is the default for new dev; Aura still supported; Visualforce in maintenance mode |

PD1 tests **all three** but emphasizes LWC.

---

## Lightning Web Components (LWC)

Standards-based (Web Components, ES Modules, modern JavaScript). Faster than Aura, easier learning curve for web devs.

### File structure

```
my_lwc/
├─ myLwc.html      # template
├─ myLwc.js        # logic
├─ myLwc.js-meta.xml  # metadata - where it can be used
└─ myLwc.css       # styles (optional)
```

### Sample LWC

#### myLwc.js

```javascript
import { LightningElement, api, wire, track } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';

export default class MyLwc extends LightningElement {
    @api recordId;          // input from parent / record context
    @track searchTerm = ''; // tracked (most properties auto-tracked in LWC)

    @wire(getAccounts, { searchTerm: '$searchTerm' })
    accounts;               // wired data: accounts.data, accounts.error

    handleSearch(event) {
        this.searchTerm = event.target.value;
    }
}
```

#### myLwc.html

```html
<template>
    <lightning-input label="Search" onchange={handleSearch}></lightning-input>
    <template lwc:if={accounts.data}>
        <template for:each={accounts.data} for:item="acc">
            <p key={acc.Id}>{acc.Name} - {acc.Industry}</p>
        </template>
    </template>
    <template lwc:if={accounts.error}>
        <p>Error: {accounts.error.body.message}</p>
    </template>
</template>
```

#### myLwc.js-meta.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>59.0</apiVersion>
    <isExposed>true</isExposed>
    <targets>
        <target>lightning__RecordPage</target>
        <target>lightning__AppPage</target>
        <target>lightning__HomePage</target>
    </targets>
</LightningComponentBundle>
```

### Decorators

- **`@api`** - public property; settable from parent or record context
- **`@track`** - reactive (most LWC properties are reactive by default; only need `@track` for objects/arrays where you want deep reactivity)
- **`@wire`** - declarative data via Apex method or Lightning Data Service

### Apex from LWC

#### `@AuraEnabled` Apex method

```apex
public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(String searchTerm) {
        return [SELECT Id, Name, Industry FROM Account WHERE Name LIKE :('%' + searchTerm + '%')];
    }

    @AuraEnabled
    public static void updateAccount(Account acc) {
        update acc;
    }
}
```

- `cacheable=true` - results cached client-side; for read-only, repeatable queries
- Without `cacheable` - direct method (DML allowed)

#### Calling from LWC

```javascript
// Wire (declarative, reactive)
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
@wire(getAccounts, { searchTerm: '$searchTerm' }) accounts;

// Imperative
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
async loadData() {
    try {
        const result = await getAccounts({ searchTerm: this.searchTerm });
        this.accounts = result;
    } catch (e) {
        this.error = e;
    }
}
```

### Lightning Data Service (LDS)

Component-level CRUD without Apex - cached, no governor cost.

```javascript
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Account.Name';

@wire(getRecord, { recordId: '$recordId', fields: [NAME_FIELD] })
account;

async update() {
    const fields = { Id: this.recordId, Name: 'New Name' };
    await updateRecord({ fields });
}
```

Use LDS for record-level CRUD. Use Apex for complex queries / batch DML / business logic.

### Component composition

#### Parent passes data to child

```html
<!-- parent.html -->
<c-child-comp record-id={recordId}></c-child-comp>
```

```javascript
// child.js
@api recordId;
```

#### Child fires event to parent

```javascript
// child.js - dispatch
this.dispatchEvent(new CustomEvent('myevent', { detail: { value: 42 } }));
```

```html
<!-- parent.html -->
<c-child-comp onmyevent={handleMyEvent}></c-child-comp>
```

```javascript
// parent.js
handleMyEvent(event) {
    console.log(event.detail.value);
}
```

#### Pub/Sub pattern (Lightning Message Service)

For component-to-component communication that doesn't share parent-child relationship.

```javascript
import { publish, subscribe, MessageContext } from 'lightning/messageService';
import myMessageChannel from '@salesforce/messageChannel/MyMessageChannel__c';
```

### Targets in js-meta.xml

Common:

- `lightning__RecordPage` - record detail pages
- `lightning__AppPage` - app pages
- `lightning__HomePage` - home page
- `lightning__Tab` - custom tab
- `lightning__FlowScreen` - usable in Flow Screen elements
- `lightning__UtilityBar` - utility bar item

---

## Aura (Lightning Components, predecessor to LWC)

Older framework. Still supported. New components should be LWC.

```html
<aura:component implements="flexipage:availableForRecordHome">
    <aura:attribute name="recordId" type="Id" />
    <aura:handler name="init" value="{!this}" action="{!c.doInit}" />

    <ui:button label="Click Me" press="{!c.handleClick}" />
</aura:component>
```

LWC components can be embedded in Aura components and vice versa, easing migration.

---

## Visualforce (legacy)

Server-rendered, controller-driven UI.

### Page

```html
<apex:page controller="AccountController" tabStyle="Account">
    <apex:form>
        <apex:pageBlock title="Account Search">
            <apex:inputText value="{!searchTerm}" />
            <apex:commandButton action="{!search}" value="Search" />

            <apex:pageBlockTable value="{!accounts}" var="acc">
                <apex:column value="{!acc.Name}" />
                <apex:column value="{!acc.Industry}" />
            </apex:pageBlockTable>
        </apex:pageBlock>
    </apex:form>
</apex:page>
```

### Controller

```apex
public class AccountController {
    public String searchTerm { get; set; }
    public List<Account> accounts { get; set; }

    public PageReference search() {
        accounts = [SELECT Name, Industry FROM Account WHERE Name LIKE :('%' + searchTerm + '%')];
        return null;
    }
}
```

### Standard controllers

```html
<apex:page standardController="Account">
    <apex:detail subject="{!Account}" />
</apex:page>
```

Use built-in controller for standard CRUD on a record. Add `extensions="MyExtension"` for custom logic.

### Visualforce remoting

Call Apex from Visualforce JavaScript (legacy AJAX pattern):

```javascript
Visualforce.remoting.Manager.invokeAction(
    '{!$RemoteAction.MyController.getAccounts}',
    function(result, event) { /* ... */ }
);
```

---

## Choosing UI framework

| Need | Framework |
|---|---|
| New component on a record / app / home page | LWC |
| Migrate old Aura component | LWC (or keep as Aura if working) |
| Visual force exists and works | Keep it, but new dev = LWC |
| Custom record actions, list view buttons | LWC (or Aura) |
| Email Template / Quote PDF | Visualforce (still required for some PDF generation) |

---

## Common exam triggers

- "Public input property in LWC" → `@api` decorator
- "Reactive data from Apex" → `@wire` to `@AuraEnabled(cacheable=true)` method
- "Component-to-component event" → `dispatchEvent` (parent-child) or Lightning Message Service (siblings)
- "CRUD on a record without Apex" → Lightning Data Service (uiRecordApi)
- "Make Apex method callable from LWC" → `@AuraEnabled` annotation
- "Cache Apex results client-side" → `@AuraEnabled(cacheable=true)` (read-only methods)
- "Custom logic on Visualforce page" → standardController + extensions
- "Custom button on record page invoking LWC" → Action with Lightning Component override (LWC must implement `lightning__RecordAction` target)
