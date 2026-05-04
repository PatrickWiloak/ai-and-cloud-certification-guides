---
last-updated: 2026-05-03
---

# IBM Cloud Security Engineer (C1000-173) - Exam Scenarios

> Six worked scenarios mirroring IBM Cloud Security Engineer question style. Tests IAM, network security, compliance, key management, threat detection, and IBM-specific services on IBM Cloud (and IBM Z / Power for hybrid).

---

## Scenario 1 - IAM and resource access

A company has 30 admins across 5 environments (dev, staging, prod-us, prod-eu, prod-apac). Admins should only access their environment's resources.

**Options:** A. IBM Cloud IAM Access Groups per environment with appropriate access policies; resource group per environment; IAM service IDs for app-level access. B. Single global admin role for all. C. Manual user policies. D. Per-resource access controls only.

**Analysis:** A is right - Access Groups + Resource Groups is the IBM Cloud pattern for environment isolation. Service IDs replace user IDs for workloads. B violates least privilege. C doesn't scale. D ignores the IAM model.

**Answer:** A

**Key takeaway:** IBM Cloud IAM hierarchy: Account → Resource Groups → Resources. Access Groups bundle access policies for users / service IDs / trusted profiles.

---

## Scenario 2 - Key management

A regulated app needs customer-managed encryption keys for Cloud Object Storage and Databases for PostgreSQL.

**Options:** A. IBM Key Protect (FIPS 140-2 Level 3) or Hyper Protect Crypto Services (FIPS 140-2 Level 4); enable BYOK for COS and Databases for PostgreSQL via key management integration. B. Default platform keys. C. Encrypt at the app layer only. D. Disable encryption.

**Analysis:** A is right - Key Protect (HSM-backed, FIPS 140-2 L3) for most regulated workloads, Hyper Protect Crypto Services (HPCS, FIPS 140-2 L4) for the highest. Both integrate with COS and managed DBs for envelope encryption. B is platform-managed, fails CMK requirement. C / D are unacceptable.

**Answer:** A

**Key takeaway:** IBM Cloud key management: Key Protect (FIPS 140-2 L3) for typical regulated; Hyper Protect Crypto Services (FIPS 140-2 L4 with KYOK - "Keep Your Own Key") for highest assurance.

---

## Scenario 3 - Network isolation

A workload spans two regions and needs private network connectivity between VPCs and to on-prem, with no internet exposure.

**Options:** A. IBM Cloud VPC + Direct Link (Connect or Dedicated) for on-prem; Transit Gateway connecting VPCs; security groups + ACLs for micro-segmentation. B. Public IPs everywhere with security groups. C. VPN over public internet. D. Classic infrastructure only.

**Analysis:** A is right - VPC + Transit Gateway (multi-region transit) + Direct Link (private hybrid) is the canonical secure topology on IBM Cloud. B exposes resources unnecessarily. C is over public internet. D is legacy.

**Answer:** A

**Key takeaway:** IBM Cloud network: VPC for isolation, Transit Gateway for inter-VPC + multi-region, Direct Link for private hybrid (Connect = via SP, Dedicated = customer-owned line).

---

## Scenario 4 - Compliance posture

The team needs continuous compliance checks against a target framework (e.g., SOC 2, ISO 27001, HIPAA) with auto-remediation where possible.

**Options:** A. IBM Cloud Security and Compliance Center (SCC): rule-based scans against profiles (SOC 2, ISO, HIPAA, custom); evidence collection for audit; integrate with workflow for remediation. B. Manual checks quarterly. C. Custom Cloud Functions auditors. D. Third-party scanner without IBM integration.

**Analysis:** A is right - SCC is IBM's CSPM equivalent: continuous compliance scans, profile library (NIST, ISO, SOC 2, HIPAA, GDPR, IBM Cloud Framework), evidence collection, integration with notifications and remediation. B doesn't scale. C reinvents SCC. D loses native integration.

**Answer:** A

**Key takeaway:** IBM Security and Compliance Center (SCC) = posture management + continuous compliance + evidence. The IBM equivalent of AWS Security Hub / Azure Defender for Cloud / GCP SCC.

---

## Scenario 5 - Threat detection

A SOC needs threat detection across IBM Cloud workloads with SIEM integration.

**Options:** A. IBM Cloud Security and Compliance Center for posture + Cloud Activity Tracker for audit logs + IBM QRadar SIEM ingestion. B. Cloud Activity Tracker only. C. Custom log analysis. D. Trust default monitoring.

**Analysis:** A is right - Activity Tracker captures audit events; SCC provides security findings; QRadar (IBM's SIEM) ingests both for correlation + threat detection + investigation. B is logging without correlation. C reinvents the SIEM. D is reactive.

**Answer:** A

**Key takeaway:** IBM threat detection stack: Activity Tracker (audit logs) + SCC (findings) + QRadar SIEM. QRadar is IBM's flagship SIEM/SOAR product.

---

## Scenario 6 - Confidential computing

A regulated workload requires data confidentiality even from cloud-provider operators (in-use protection beyond at-rest and in-transit).

**Options:** A. IBM Cloud Hyper Protect Virtual Servers (running on IBM Z LinuxONE Secure Execution); Hyper Protect Crypto Services for keys held in tenant-controlled HSM. B. Standard VPC virtual servers with full-disk encryption. C. App-layer encryption only. D. Self-hosted.

**Analysis:** A is right - IBM's Hyper Protect family is built on IBM Z Secure Execution (technology equivalent to AMD SEV / Intel TDX but more mature for the highest assurance). KYOK in HPCS means the key is held by the tenant and the cloud operator cannot access it. The market-leader for "confidential computing for regulated industries."

**Answer:** A

**Key takeaway:** IBM Hyper Protect = confidential computing on IBM Z + KYOK key management. Used heavily by regulated finance / healthcare clients.
