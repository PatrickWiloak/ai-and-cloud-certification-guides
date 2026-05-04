---
last-updated: 2026-05-03
---

# Azure Security Engineer (AZ-500) - Exam Scenarios

> Eight worked scenarios mirroring AZ-500 question style. AZ-500 tests identity & access (~25-30%), platform protection (~20-25%), security operations (~25-30%), and data + apps security (~20-25%).

---

## Scenario 1 - Conditional Access for risky sign-ins (Domain: Identity)

A company wants to require MFA for sign-ins from outside trusted IPs and block sign-ins flagged as high-risk by Identity Protection.

Which fits?

A. Two Conditional Access policies: one requires MFA when sign-in is from outside a Named Location; another blocks access when user risk OR sign-in risk is High.
B. Disable accounts after 3 bad password attempts.
C. Force MFA always for everyone.
D. Use SMS-based MFA only.

**Analysis**

A is right: Conditional Access is the unified policy engine. Named Locations + risk signals from Identity Protection (Premium P2) is the canonical pattern. B doesn't address risk-based access. C is over-restrictive (treats trusted and untrusted equally; affects user experience). D is the worst MFA method (SMS is phishable, NIST has deprecated SMS as primary).

**Answer:** A

**Key takeaway:** Conditional Access combines signals (user, location, device, application, risk) into Allow/Block/Require-MFA decisions. Identity Protection (Premium P2) provides risk signals.

---

## Scenario 2 - Privileged access management (Domain: Identity)

Admins should not have permanent Global Administrator role; they should request just-in-time access with approval and time-bound activation.

Which fits?

A. Privileged Identity Management (PIM) with eligible assignments, approval workflow, MFA on activation, time-bound activation, and access reviews.
B. Make all admins permanent.
C. Custom Logic App that creates and removes role assignments.
D. Azure AD groups with dynamic membership.

**Analysis**

A is right: PIM is purpose-built for this - eligible vs active assignments, JIT activation with MFA + approval, time-bound, audit trail, periodic access reviews. B is the opposite of least privilege. C reinvents PIM. D doesn't add JIT.

**Answer:** A

**Key takeaway:** PIM = JIT + approval + MFA + time-bound + audit. The default for any privileged role in modern Azure.

---

## Scenario 3 - VM patch management with compliance (Domain: Platform Protection)

500 Azure VMs (mix of Windows and Linux) need monthly patches with compliance reporting.

Which fits?

A. Azure Update Manager (formerly Update Management center) with deployment schedules; Azure Policy to ensure VMs have the agent and are scoped to the right deployment.
B. Manual SSH/RDP and run updates.
C. Custom DSC scripts.
D. Defender for Cloud only.

**Analysis**

A is right: Update Manager is the modern Azure-native solution for VM patching across Azure, Arc-enabled servers, on-prem; supports deployment schedules and compliance reporting. B doesn't scale. C is partially obsolete. D - Defender for Cloud surfaces missing patches as recommendations but isn't the patching tool.

**Answer:** A

**Key takeaway:** Azure Update Manager (modern, native, replaces older Update Management). Defender for Cloud gives the recommendation; Update Manager applies the patch.

---

## Scenario 4 - Secrets in Storage Account access (Domain: Data Security)

App on Azure VM needs to read from Storage Account without storing connection strings or keys.

Which fits?

A. Managed Identity assigned to the VM with RBAC role on the storage account (Storage Blob Data Reader).
B. Connection string stored in app config file.
C. SAS token regenerated daily and pushed to the VM.
D. Storage account key encrypted with KMS.

**Analysis**

A is right: Managed Identities eliminate stored credentials entirely. The VM's identity authenticates to Azure AD, gets a token, calls Storage with the token. RBAC grants the right role on the data plane. B is plaintext credentials. C is rotation but not credential elimination. D - storage account keys are still credentials.

**Answer:** A

**Key takeaway:** Managed Identity > storage account key > SAS token > connection string. AZ-500 prefers credential elimination over rotation.

---

## Scenario 5 - Network segmentation in Azure (Domain: Platform Protection)

A multi-tier app needs network isolation: web tier accessible from internet, app tier only from web tier, database tier only from app tier.

Which fits?

A. Three subnets in a VNet, NSGs at the subnet level enforcing tier-to-tier rules; Azure Firewall in a hub VNet for egress; Application Security Groups (ASGs) for app-level grouping.
B. Three separate VNets without peering.
C. Single subnet with security groups per VM.
D. Public IPs on every tier.

**Analysis**

A is right: subnet-level NSGs + ASGs is the standard Azure micro-segmentation. ASGs let you group VMs and reference them in NSG rules without IP lists. Azure Firewall handles north-south traffic centrally. B isolates but breaks intra-app traffic. C doesn't enforce tier separation cleanly. D is the opposite of secure.

**Answer:** A

**Key takeaway:** Azure micro-segmentation hierarchy: NSG (subnet or NIC level) + ASG (logical groups) + Azure Firewall (centralized). Combine for layered defense.

---

## Scenario 6 - Defender for Cloud workload coverage (Domain: Security Ops)

A company needs continuous threat detection on VMs, containers (AKS), App Service, SQL, Storage, and Key Vault.

Which fits?

A. Microsoft Defender for Cloud with the appropriate Defender plans enabled (Defender for Servers, Containers, App Service, SQL, Storage, Key Vault).
B. Custom monitoring scripts on each workload.
C. Third-party SIEM only.
D. Azure Monitor alone.

**Analysis**

A is right: Defender for Cloud's per-workload Defender plans are the AWS GuardDuty + Inspector + Macie equivalent for Azure. They feed findings into Defender for Cloud's central view and into Sentinel if integrated. B is custom and doesn't have the threat intelligence. C and D lack workload-specific detection (Sentinel is the SIEM, but Defender plans feed it).

**Answer:** A

**Key takeaway:** Defender for Cloud = posture management + workload threat protection (per-resource Defender plans). Sentinel = SIEM/SOAR layered on top.

---

## Scenario 7 - SIEM with Sentinel (Domain: Security Ops)

A SOC needs a central SIEM aggregating Azure logs, AWS CloudTrail, Office 365, Defender alerts; with custom detections, threat hunting, and automated playbooks.

Which fits?

A. Microsoft Sentinel with data connectors for Azure, AWS, M365, Defender; KQL analytics rules for detections; Logic Apps as playbooks for automated response.
B. Azure Monitor only.
C. Splunk on-prem.
D. Defender for Cloud only.

**Analysis**

A is right: Sentinel is Microsoft's cloud-native SIEM/SOAR with native data connectors for major sources (including AWS), KQL-based detections, hunting queries, and Logic Apps for SOAR automation. B doesn't have SIEM features. C works but isn't the Microsoft answer. D is workload protection, not SIEM.

**Answer:** A

**Key takeaway:** Sentinel = SIEM + SOAR for Microsoft ecosystem (and many third-party connectors). Logic Apps = playbook automation. KQL = detection language.

---

## Scenario 8 - Customer-managed keys for Storage (Domain: Data Security)

A regulated workload requires customer-managed encryption keys for Storage Account, with key rotation, audit, and HSM-backed keys.

Which fits?

A. Azure Key Vault Managed HSM with customer-managed keys; Storage Account configured to use the customer-managed key with rotation policy.
B. Azure Storage Service Encryption with platform-managed keys.
C. Encrypt files client-side before uploading.
D. Use a third-party HSM.

**Analysis**

A is right: Managed HSM is FIPS 140-3 Level 3, customer-managed, with rotation. Storage Account natively integrates with Key Vault / Managed HSM for the encryption key. B is the default but doesn't meet the customer-managed requirement. C works but adds operational burden and breaks Azure-native features. D - Azure has Managed HSM, no third-party needed.

**Answer:** A

**Key takeaway:** Customer-managed keys: Key Vault Standard/Premium (FIPS 140-2 L2) for most; Managed HSM (FIPS 140-3 L3) for highest compliance. Storage / Disk / SQL TDE all support CMK.
