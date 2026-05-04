---
last-updated: 2026-05-03
---

# Google Workspace Administrator - Exam Scenarios

> Six worked scenarios mirroring Workspace Admin question style. Tests user/group lifecycle, mail flow, security, mobile management, and compliance for Google Workspace.

---

## Scenario 1 - User onboarding at scale

A company hires 50 people per month. New hires need a Workspace account, group memberships per role, and a default mobile policy.

**Options:** A. Google Cloud Directory Sync (GCDS) from on-prem AD + dynamic group rules + mobile management default policy. B. Manual creation in Admin Console. C. CSV upload weekly. D. SAML SSO only.

**Analysis:** A is right - GCDS for AD-driven provisioning, dynamic groups (e.g., "all employees in Engineering") for automatic membership, mobile management default policy applies on enrollment. B doesn't scale. C is partial automation. D is auth, not provisioning.

**Answer:** A

**Key takeaway:** Workspace provisioning at scale: GCDS (on-prem AD) or Google APIs + SAML/SCIM (Okta, Azure AD). Dynamic groups for membership.

---

## Scenario 2 - Email security

A company is concerned about phishing and spoofing. They want SPF, DKIM, DMARC enforcement and inbound advanced threat protection.

**Options:** A. Configure SPF, DKIM, DMARC DNS records; enable enhanced pre-delivery scanning (Security Sandbox); apply attachment + link checks. B. Just SPF. C. Disable email entirely. D. Trust all senders.

**Analysis:** A is right - the modern email auth trio (SPF, DKIM, DMARC) plus Workspace's pre-delivery scanning (sandbox detonation of attachments, link rewrite). B is partial. C / D are not serious.

**Answer:** A

**Key takeaway:** Email auth: SPF (whitelist senders) + DKIM (signed messages) + DMARC (policy + reporting). Workspace adds Security Sandbox.

---

## Scenario 3 - Mobile device management

A company allows BYOD; they need to enforce screen lock, remote wipe of work data, and app whitelisting on managed mobile devices.

**Options:** A. Google Mobile Management with Advanced settings; Android Enterprise (work profile) or iOS managed apps; remote wipe of work data only. B. Block all mobile access. C. MDM third-party. D. Nothing.

**Analysis:** A is right - Workspace Mobile Management Advanced supports work profile (BYOD) with selective wipe of work data. B is over-restrictive. C is valid but Workspace native is the exam answer. D is no MDM.

**Answer:** A

**Key takeaway:** Workspace Mobile Management tiers: Basic (passcode, remote wipe), Advanced (full MDM with work profile, compliance, app whitelisting).

---

## Scenario 4 - Data Loss Prevention (DLP)

A company wants to prevent sharing of credit card numbers and SSNs in Gmail and Drive externally.

**Options:** A. Workspace DLP rules with predefined detectors (CCN, SSN); actions: block share / warn / require justification; covers Gmail outbound + Drive sharing. B. Train users to be careful. C. Disable external sharing entirely. D. Manual review.

**Analysis:** A is right - DLP in Workspace covers Gmail, Drive, Chat, Meet (ongoing). Predefined detectors for common PII. Configurable actions per rule. B is human-error-prone. C is over-restrictive. D doesn't scale.

**Answer:** A

**Key takeaway:** Workspace DLP = predefined detectors + custom regex + actions (block / warn / report) across Gmail, Drive, Chat. Requires Enterprise Standard / Plus tier.

---

## Scenario 5 - Vault for compliance

Legal needs to preserve emails and Drive files for a litigation hold, with search and export.

**Options:** A. Google Vault with retention rules and a Hold matter; eDiscovery search and export. B. Manual download. C. Backup to Cloud Storage. D. Don't do it.

**Analysis:** A is right - Vault is the eDiscovery + retention + hold tool for Workspace. B / C aren't legally defensible. D isn't compliant.

**Answer:** A

**Key takeaway:** Google Vault = retention + legal hold + eDiscovery for Gmail, Drive, Chat, Meet, Voice. Available in Business Plus and Enterprise editions.

---

## Scenario 6 - Migration from another suite

A company is migrating from Microsoft 365 to Workspace: 5,000 mailboxes, 10 TB of OneDrive data, 500 SharePoint sites.

**Options:** A. Workspace Migration for Microsoft Exchange / OneDrive (data migration tools), parallel cutover with mail forwarding during transition. B. Manual export/import. C. Third-party migration tool only. D. Email forwarding only without data migration.

**Analysis:** A is right - Google's data migration service handles M365 → Workspace migrations including Exchange / OneDrive / SharePoint. B doesn't scale. C is fine for some scenarios but native is the exam answer. D loses historical data.

**Answer:** A

**Key takeaway:** Google's Data Migration Service handles M365, IMAP, Exchange Server migrations. Plan a phased cutover with dual delivery during transition.
