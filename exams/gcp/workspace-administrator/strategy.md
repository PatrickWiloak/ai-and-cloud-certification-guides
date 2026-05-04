---
last-updated: 2026-05-03
---

# Google Workspace Administrator - Exam Strategy

## Format reminder

- ~50 questions, 90 minutes (varies)
- Pass mark ~70-75%
- Multiple choice
- Tests Workspace Admin Console operations, security, mobile management, compliance

## Top traps

1. **Workspace editions**: Business Starter / Standard / Plus / Enterprise Starter / Standard / Plus. Features differ significantly. DLP and Vault require Business Plus or Enterprise. Cloud Identity is the lighter option for identity-only.

2. **Cloud Identity vs Workspace**: Cloud Identity is identity management without the apps. Workspace adds Gmail, Drive, etc. Free Cloud Identity tier exists.

3. **GCDS vs SAML/SCIM**: GCDS = Google Cloud Directory Sync, syncs from on-prem AD/LDAP. SAML/SCIM = federation with cloud IdPs (Okta, Azure AD).

4. **OU vs Groups**:
   - Organizational Units: hierarchical, apply settings/policies (apps enabled, security settings)
   - Groups: collections for sharing, mailing, permissions
   Don't confuse - OUs control config, Groups control access.

5. **Context-Aware Access**: zero-trust framework restricting access to apps based on context (IP, device, etc.). Enterprise tier.

6. **2-Step Verification (2SV)**: enforce per-OU. Methods: Security Keys (FIDO2 - strongest), TOTP, SMS, Backup codes. SMS is being deprecated.

7. **Login challenges**: suspicious logins trigger additional verification.

8. **Mobile Management tiers**:
   - Basic: passcode, remote wipe (free)
   - Advanced: full MDM, work profile, app whitelisting (Business Standard+)

9. **Vault scope**: retention rules + holds for Gmail, Drive, Chat, Meet, Voice. eDiscovery search and export. Compliance feature.

10. **DLP scope**: Gmail outbound, Drive sharing, Chat, with predefined detectors and custom regex.

## High-yield topics easy to miss

- App management: APIs to manage admins / users / groups (Admin SDK)
- Security Center / Investigation Tool (for Enterprise)
- Bulk user upload via CSV
- Email routing rules (compliance footers, content compliance)
- Calendar resources (rooms, equipment)
- Drive trust rules (sharing restrictions)
- Chat spaces vs DMs vs groups
- Workspace Migration for Exchange, IMAP, etc.
- BeyondCorp Enterprise features integrated with Workspace (Context-Aware Access)

## Time management

90 / ~50 = ~1.8 min/question.

## When stuck

1. **Identify the edition** - DLP / Vault / Context-Aware Access are higher-tier features.
2. **OU vs group** - settings → OU, sharing → group.
3. **Default to Google-native** - Vault over third-party retention.

## Day-of logistics

90 min, ~50 questions.

## After

**Pass:** Cert valid 1 year (Workspace Admin specifics may differ from GCP Professional cycle).

**Fail:** Most failures cluster on Mail Flow / Security or DLP / Vault. Re-review the Admin Console hierarchy.

## Workspace Admin patterns

- "User provisioning at scale" = GCDS (AD) or SAML+SCIM
- "Group settings" = use OU
- "Permissions / sharing" = use Group
- "Email auth" = SPF + DKIM + DMARC
- "PII protection in Gmail/Drive" = DLP rules
- "Litigation hold" = Vault
- "BYOD with selective wipe" = Mobile Management Advanced + work profile
- "Phishing-resistant MFA" = Security Keys (FIDO2)
- "Zero-trust app access" = Context-Aware Access
- "M365 → Workspace migration" = Data Migration Service
