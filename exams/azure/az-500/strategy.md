---
last-updated: 2026-05-03
---

# Azure Security Engineer (AZ-500) - Exam Strategy

## Format reminder

- 40-60 questions, 100-120 minutes
- Pass mark: 700 / 1000 (70%)
- Multiple choice + multiple response + drag-and-drop
- No formal prerequisite, but practical Azure operational experience expected

## Top traps

1. **Defender for Cloud vs Sentinel**: Defender for Cloud = posture (CSPM) + per-workload threat protection (CWPP). Sentinel = SIEM + SOAR. Different products, often confused.

2. **Conditional Access vs Identity Protection**: Identity Protection generates risk signals (P2 license required); Conditional Access consumes them in policy decisions. CA is the policy engine; IP is the brain.

3. **PIM eligibility vs assignment**: Eligible = can activate JIT; Active = currently has the role. AZ-500 tests this distinction.

4. **Key Vault vs Managed HSM**:
   - Vault Standard: FIPS 140-2 L1 software keys
   - Vault Premium: FIPS 140-2 L2 with HSM-backed keys
   - Managed HSM: FIPS 140-3 L3, dedicated HSM
   Pick by compliance requirement.

5. **Customer-managed keys (CMK) vs platform-managed (PMK)**: PMK is the default; CMK gives you control of the key + rotation + audit. CMK is required for many compliance regimes.

6. **NSG vs Azure Firewall vs WAF vs Front Door**:
   - NSG: subnet/NIC L4 stateful
   - Azure Firewall: managed L4-L7 firewall (FQDN filtering, threat intel)
   - WAF: L7 HTTP/S rules, attached to App Gateway / Front Door / CDN
   - Front Door: global L7 with WAF capabilities
   Don't confuse layers.

7. **Service endpoints vs Private endpoints**:
   - Service endpoints: extend VNet identity to PaaS (still uses public IP)
   - Private endpoints: PaaS service via private IP in your VNet (truly private)
   Private endpoints are the modern recommendation.

8. **Just-in-time VM access**: Defender for Servers feature; opens NSG ports for a limited time on request; used for SSH/RDP access without leaving ports open.

9. **Compliance frameworks in Defender for Cloud**: Microsoft Cloud Security Benchmark (default), CIS, NIST, PCI, HIPAA, ISO. Multiple can be enabled simultaneously.

10. **Encryption at rest layers**:
    - Storage: Storage Service Encryption (SSE), Azure Disk Encryption for VM disks
    - SQL: Transparent Data Encryption (TDE)
    - Cosmos / Service Bus / Event Hubs: encryption by default with optional CMK

## High-yield topics easy to miss

- Azure AD App Registrations vs Enterprise Apps: registration = your app's identity, enterprise app = a service principal (instance) of an app in your tenant
- Workload identity federation (federated credentials for GitHub Actions, etc., to call Azure without secrets)
- Azure Bastion (browser-based RDP/SSH without public IPs)
- Azure DDoS Protection: Network tier (per-VNet, paid) vs IP Protection (per-IP, paid) vs platform default (free, basic)
- Azure Policy regulatory compliance initiatives
- Microsoft Defender XDR (formerly 365 Defender) - extends to Azure via Defender for Cloud integration
- Defender for IoT
- Defender External Attack Surface Management (EASM)

## Time management

100-120 / ~50 = ~2 min/question. Half done by halfway through the time. Leave 10 min for review.

## When stuck

1. **Identify the product family** - identity (AAD), platform (NSG/Firewall/Defender for X), data (encryption / DLP), ops (Sentinel).
2. **Default to Microsoft-recommended** - PIM, Conditional Access, Managed Identities, Private Endpoints.
3. **Eliminate "manual" answers** - SOC playbooks should be automated where possible.
4. **Mind the layer**: identity layer vs network layer vs data layer attacks have different mitigations.

## Day-of logistics

100-120 min, ~50 questions. Bring two IDs.

## After

**Pass:** Cert valid 1 year (annual renewal via free online assessment).

**Fail:** Most failures are on Identity (~25-30%) or Security Ops (~25-30%). Re-review Conditional Access design, Sentinel KQL rules, Defender for Cloud workload plans.

## AZ-500 patterns

- "Risk-based access" = Conditional Access + Identity Protection (P2)
- "JIT admin elevation" = PIM
- "VM patching at scale" = Azure Update Manager
- "App reads Storage without secrets" = Managed Identity + RBAC
- "Multi-tier network isolation" = NSG + ASG + Azure Firewall
- "SIEM + SOAR" = Microsoft Sentinel
- "Threat detection per workload" = Microsoft Defender for X plans
- "Customer-managed keys, FIPS 140-3 L3" = Managed HSM
- "Private PaaS access" = Private Endpoints
- "Browser-based RDP without public IP" = Azure Bastion
