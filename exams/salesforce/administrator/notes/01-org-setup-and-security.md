# 01 - Org Setup, Users, and Security Model

## Org-wide settings

### Company Information

Setup → Company Information. Edition, license usage, storage, currency, locale.

### Fiscal Year

- **Standard** - calendar-aligned (Jan/Apr/Jul/Oct quarter starts)
- **Custom** - non-standard fiscal periods (e.g., 4-4-5 retail calendar)

Setting custom fiscal year is one-way - careful.

### Multi-currency

- Disabled by default (single currency)
- Once enabled, **cannot be disabled**
- Adds Currency picklist on records, conversion rates table

### Locale and language

Per-user override via User record.

---

## User management

### Creating users

Setup → Users → New User. Required fields: First/Last Name, Email, Username (must be globally unique across all Salesforce orgs, in email format), Profile, Role (optional), License.

### License types

- **Salesforce** - full CRM access
- **Salesforce Platform** - custom app only, no Sales/Service objects
- **Customer Community / Partner Community** - external users
- **Chatter Free** - Chatter-only

### Deactivating vs deleting

- **Cannot delete** users (FK from many records)
- **Deactivate** = freeze the account; user disappears from picklists; license freed up
- **Freeze** = temporary lock (faster than full deactivation)

### User-related lifecycle

- New user → assign profile → assign permission sets → assign roles
- Role change requires sharing recalc (long for large orgs)

---

## Sharing model (the layered access)

### Layer 1: Object permissions (CRUD)

Set per **Profile** or **Permission Set**:

- **C**reate
- **R**ead
- **E**dit / **U**pdate
- **D**elete
- **V**iew All / **M**odify All (super-permissions, override sharing)

### Layer 2: Field-Level Security (FLS)

Per-profile / per-permission-set. Read / Edit per field.

A field hidden by FLS is invisible everywhere - reports, list views, page layouts, API.

### Layer 3: Org-Wide Defaults (OWD)

Baseline record access for each object. Most restrictive level.

Options:

- **Private** - only owner + above-in-role-hierarchy + sharing rules
- **Public Read Only** - everyone reads, only owner edits
- **Public Read/Write** - everyone reads + edits
- **Public Read/Write/Transfer** (cases/leads only) - + transfer
- **Controlled by Parent** (detail in Master-Detail relationship) - inherits from parent

External access can differ from internal access (External OWD typically more restrictive).

### Layer 4: Role Hierarchy

Hierarchical tree of roles. "Grant Access Using Hierarchies" checkbox (default on for standard objects):

- Users **above** in the hierarchy can see records owned by users below
- Doesn't grant edit by itself; combine with sharing for edit

### Layer 5: Sharing Rules

Programmatic grants based on owner or criteria:

- **Owner-Based Sharing Rule** - grant access to records owned by a specific group/role
- **Criteria-Based Sharing Rule** - grant access to records meeting field criteria

### Layer 6: Manual Sharing

Per-record share via the Share button. Limited to records the user owns/has access to.

### Layer 7: Apex Sharing

Code-based shares (rare in admin world; flagged for awareness).

### Layer 8: Implicit Sharing

Automatic shares Salesforce maintains:

- Account → Contact / Case / Opportunity (read-only when you have account access)
- Etc.

---

## Profile

A bundle of:

- Object CRUD
- Field-Level Security
- App access
- Tab access
- Login hours and IP ranges
- Page layout assignments (per record type)
- Apex class / Visualforce page access
- Custom permissions
- System permissions ("View All Data", "Modify All Data", "API Enabled", etc.)

### Profile types

- **Standard profiles** - System Administrator, Standard User, Read Only, Marketing User, etc. - cannot delete
- **Custom profiles** - admin-created, cloned from standard

### Profile best practice

Don't proliferate custom profiles. Use **Permission Sets** to grant additional access on top of a base profile. This scales better.

---

## Permission Sets

Additive bundles of permissions assigned per-user.

- Create one for each "feature" or "role within profile"
- Assign multiple to a single user
- Don't subtract permissions - only add

### Permission Set Groups

Bundle permission sets together. Mute specific permissions in a group with **Muting Permission Set** if needed.

---

## Roles vs Profiles

- **Profile** = what you can do (object/field permissions)
- **Role** = what you can see (record access via hierarchy)

A user has exactly **one Profile** and **zero or one Role**. Multiple Permission Sets allowed.

---

## MFA, IP restrictions, login hours

### MFA (mandatory since 2022)

- Microsoft / Google Authenticator, Salesforce Authenticator, FIDO2 keys, OTP, etc.
- Enforced per-profile (default on for all internal)
- Cannot opt out (Salesforce-mandated)

### IP restrictions

- **Login IP Ranges** (per profile) - users can only log in from these IPs (no MFA needed within range)
- **Trusted IP Ranges** (org-wide) - users from these IPs skip device activation MFA but may still need 2nd factor

### Login Hours

Per-profile - user can only log in during these hours.

---

## Authentication options

### Standard

Username + password + (mandatory) MFA.

### Single Sign-On (SSO)

- **SAML 2.0** with external IdP (Okta, ADFS, Microsoft Entra ID, Auth0, etc.)
- **OAuth 2.0** for app integration (delegated authorization)
- **OpenID Connect** for federated identity

### Connected Apps

OAuth-enabled apps that integrate with Salesforce. Configure scopes, IP ranges, OAuth policies.

### My Domain

Custom subdomain (e.g., `mycompany.my.salesforce.com`). **Required** for many features (Lightning, SAML, Communities). Must enable.

---

## Common exam triggers

- "Public Read default but managers see direct reports' records" → OWD Public Read + Role Hierarchy with Grant Access Using Hierarchies
- "Sales reps can see records owned by their team" → Sharing Rule (owner-based)
- "Specific fields hidden from sales but visible to finance" → Field-Level Security on field, different per profile
- "Add API access to specific user without changing profile" → Permission Set with API Enabled
- "User cannot log in after 6 PM" → Login Hours on profile
- "User can log in from corporate office without MFA but needs MFA from home" → Login IP Range on profile (within range = no MFA on every login)
- "Federate with Microsoft Entra ID" → SAML 2.0 SSO with Entra ID as IdP
- "Apply layered access: baseline private, manager sees records, sales sees by criteria" → OWD Private + Role Hierarchy + Criteria-Based Sharing Rule
- "Cannot delete a user but want to remove access" → Deactivate the user (frees the license)
- "Per-record-type page layout assignment" → Page Layout assignments per Record Type per Profile
