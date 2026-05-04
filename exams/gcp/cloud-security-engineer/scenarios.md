---
last-updated: 2026-05-03
---

# GCP Professional Cloud Security Engineer (PCSE) - Exam Scenarios

> Six worked scenarios mirroring PCSE question style.

---

## Scenario 1 - Identity for federated workforce

A company uses Okta for SSO and wants Google Workspace + GCP access via Okta with provisioning automated.

**Options:** A. Okta as IdP + SAML federation to Google Workspace; SCIM for user provisioning; users access GCP via Cloud Identity. B. Manual user creation. C. Cloud Identity standalone. D. Sync via Google Cloud Directory Sync (GCDS).

**Analysis:** A is right - SAML for SSO + SCIM for provisioning is the modern standard. D (GCDS) is for AD-on-prem to Cloud Identity sync (legacy). B doesn't scale. C standalone doesn't include Okta SSO.

**Answer:** A

**Key takeaway:** Modern federation: SAML + SCIM with Okta / Azure AD. Legacy: GCDS for on-prem AD sync.

---

## Scenario 2 - VPC Service Controls

A company's BigQuery datasets contain PII and must not exfiltrate even via authorized identities; all access must come from approved service accounts in approved projects.

**Options:** A. VPC Service Controls perimeter around BigQuery + supporting services; ingress/egress rules for allowed identities and projects. B. IAM bindings only. C. Bucket policy on BigQuery (does not exist). D. Cloud Armor.

**Analysis:** A is right - VPCSC is data exfil prevention beyond IAM. Even an identity with bigquery.dataViewer can't pull data outside the perimeter unless an explicit egress rule allows it. B is bypassed by exfil scenarios. C doesn't exist. D is L7 web protection.

**Answer:** A

**Key takeaway:** VPC Service Controls = data exfil prevention. IAM = who can access. Both are needed; VPCSC is the perimeter beyond IAM.

---

## Scenario 3 - Secret management

A team uses API keys, DB passwords, and KMS keys across many services. They need rotation, audit, and least-privilege access.

**Options:** A. Secret Manager with rotation triggers via Cloud Functions; IAM for least privilege; Cloud KMS for keys with rotation enabled. B. Secrets in environment variables. C. Secrets in code, encrypted with KMS. D. Plain config files in Cloud Storage.

**Analysis:** A is right - Secret Manager handles secrets; KMS handles encryption keys (separate concerns). Both with rotation + IAM + audit logging. B - env vars are ephemeral but still readable to processes. C is anti-pattern. D is plaintext.

**Answer:** A

**Key takeaway:** Secret Manager for secrets (passwords, tokens, certs) with rotation. Cloud KMS for encryption keys with rotation. Don't conflate them.

---

## Scenario 4 - Workload Identity for GKE

A GKE app needs to call BigQuery without storing service account JSON keys.

**Options:** A. Workload Identity binding K8s service account to GCP service account. B. Mount JSON key as a K8s Secret. C. Use service account JSON key in pod env var. D. Use compute engine default service account.

**Analysis:** A is right - Workload Identity is the GCP-recommended pattern for GKE→GCP API access without storing keys. B / C store credentials (the anti-pattern). D works but uses a single service account for all pods (no isolation).

**Answer:** A

**Key takeaway:** GKE → GCP APIs = Workload Identity. Eliminates JSON key storage entirely.

---

## Scenario 5 - Logging and SIEM

A SOC needs centralized logging from all GCP projects with long retention, queryability, and SIEM integration.

**Options:** A. Aggregated log sink at the org level → BigQuery (or Cloud Logging bucket with longer retention) → Chronicle SIEM ingestion. B. Per-project logs with no aggregation. C. Cloud Storage only. D. Cloud Monitoring metrics only.

**Analysis:** A is right - org-level log sinks aggregate all projects; export to BigQuery for SQL queries, or Chronicle for Google's SIEM (now Google SecOps). B doesn't centralize. C loses queryability. D is metrics, not logs.

**Answer:** A

**Key takeaway:** GCP centralized logging = org-level aggregated sink → BigQuery (queryable archive) and/or Chronicle / Google SecOps (SIEM).

---

## Scenario 6 - Confidential Computing

A regulated workload requires data encrypted in-use (memory) in addition to at-rest and in-transit.

**Options:** A. Confidential VMs (AMD SEV / SEV-SNP) on Compute Engine; Confidential GKE Nodes for K8s. B. Standard VMs with full-disk encryption. C. Encrypt at the application layer only. D. Run on-prem.

**Analysis:** A is right - Confidential VMs encrypt RAM with AMD SEV / Intel TDX. Confidential GKE Nodes apply this to K8s. The only GCP answer for in-use encryption. B doesn't address in-use. C is partial. D abandons the cloud.

**Answer:** A

**Key takeaway:** GCP Confidential Computing = Confidential VMs (memory encryption via AMD SEV / Intel TDX) + Confidential GKE Nodes. The compliance ask for "data in use."
