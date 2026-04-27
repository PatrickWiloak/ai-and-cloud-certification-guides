# Salesforce Administrator - Exam-Style Scenarios

12 scenarios mapped to exam domains.

---

### Scenario 1
**The Opportunity object's OWD is Public Read Only. Sales managers should be able to edit Opportunities owned by their team. What's the right setup?**

**Best answer:** Role Hierarchy with sales managers above sales reps + ensure "Grant Access Using Hierarchies" is enabled on Opportunity (default for standard objects). Hierarchy grants edit access to managers for subordinate-owned records.

---

### Scenario 2
**A custom field "Bonus_Approved__c" should be visible to managers but hidden from sales reps. How?**

**Best answer:** Field-Level Security: Read = unchecked on the Sales Rep profile (and any Permission Sets they have); Read = checked on the Manager profile.

---

### Scenario 3
**You need to import 250,000 Opportunities with parent Account lookups, matching by an external ID.**

**Best answer:** Data Loader (CLI or desktop app). Wizard caps at 50K and doesn't support Opportunity. Use Upsert with External ID field (mark as External ID + Unique on the Opportunity). Map the parent Account External ID into the Account lookup field; Salesforce resolves the relationship.

---

### Scenario 4
**Block save on Account if Industry is "Healthcare" and Compliance_Reviewed__c is unchecked.**

**Best answer:** Validation Rule with formula `AND(ISPICKVAL(Industry, "Healthcare"), NOT(Compliance_Reviewed__c))`. Error message: "Compliance review required for Healthcare accounts."

---

### Scenario 5
**When an Opportunity is set to Closed Won, automatically create a follow-up Task assigned to the AccountManager and send an email to the Sales Manager.**

**Best answer:** Record-Triggered Flow on Opportunity, after-save trigger, condition Stage equals Closed Won. Elements: Create Records (Task), Action (Send Email Alert).

---

### Scenario 6
**A custom object "Project" has child "Tasks" via Master-Detail. The parent should show total estimated hours from all tasks.**

**Best answer:** Roll-Up Summary field on Project: SUM of Tasks.Estimated_Hours__c. Roll-Up Summary requires Master-Detail relationship.

---

### Scenario 7
**You need to give a marketing user access to update Lead records they don't own, without changing their profile.**

**Best answer:** Create a Permission Set granting Edit on Lead (and required FLS), assign to the user. Profiles stay simple; Permission Sets layer additional access.

---

### Scenario 8
**The web-to-lead form is being abused by spam bots; you want to add CAPTCHA and route only legit Leads to the right rep based on Country.**

**Best answer:** Configure CAPTCHA in the Web-to-Lead form (Salesforce-provided option). Set up Lead Assignment Rule with criteria on Country, routing to specific reps or queues.

---

### Scenario 9
**Discount on an Opportunity over 25% requires manager approval, then director approval if over 50%.**

**Best answer:** Approval Process with two steps:
- Step 1: Trigger if Discount > 25%, approver = Manager (auto from hierarchy)
- Step 2: Trigger if Discount > 50%, approver = Director

Or implement in Flow with Approval action for newer dynamic logic.

---

### Scenario 10
**You want a dashboard that shows each sales manager their own team's pipeline (each manager sees their own data).**

**Best answer:** Dynamic Dashboard with "Run as logged-in user" setting. Each manager logs in and sees data scoped to records they have access to.

---

### Scenario 11
**An admin needs to find all "Closed Lost" Opportunities from last quarter that don't have any related Activities.**

**Best answer:** Custom Report Type with Opportunities (primary) + Activities (related, "without related" option). Build report with filter Stage = Closed Lost + Close Date = Last Quarter + Cross filter "Opportunities without Activities."

---

### Scenario 12
**The CFO wants the audit trail of every change to a specific custom field "Approval_Status__c" on Opportunity.**

**Best answer:** Enable Field History Tracking on Opportunity (up to 20 fields tracked). Audit shows in the Field History related list. For longer-term archival, use Field Audit Trail (paid add-on, 10-year retention).

---

## Scoring guide

- **10-12:** Schedule the exam.
- **7-9:** Re-read fact-sheet and weak-area notes.
- **<7:** More Trailhead modules + hands-on time before retesting.

The Salesforce Administrator exam is **scenario-based**. Pattern recognition + hands-on muscle memory matter most. Build everything yourself in a Developer Edition org.
