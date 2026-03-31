# Compliance Guide - PCI DSS

## Overview

PCI DSS (Payment Card Industry Data Security Standard) is a set of security standards designed to ensure that all companies that accept, process, store, or transmit credit card information maintain a secure environment. Version 4.0 is the current standard, with full enforcement beginning March 2025.

---

## PCI DSS Requirements

### The 12 Requirements (v4.0)

| # | Requirement | Cloud Relevance |
|---|-------------|-----------------|
| 1 | Install and maintain network security controls | VPC, firewalls, network policies |
| 2 | Apply secure configurations to all system components | Hardened AMIs/images, CIS benchmarks |
| 3 | Protect stored account data | Encryption, tokenization, masking |
| 4 | Protect cardholder data with strong cryptography during transmission | TLS, VPN, private endpoints |
| 5 | Protect all systems and networks from malicious software | Endpoint protection, image scanning |
| 6 | Develop and maintain secure systems and software | Secure SDLC, vulnerability management |
| 7 | Restrict access to system components by business need | RBAC, least privilege |
| 8 | Identify users and authenticate access | MFA, strong passwords, SSO |
| 9 | Restrict physical access to cardholder data | Cloud provider responsibility (shared) |
| 10 | Log and monitor all access to system components | Audit logging, SIEM, alerting |
| 11 | Test security of systems and networks regularly | Penetration testing, vulnerability scanning |
| 12 | Support information security with organizational policies | Policies, training, incident response |

---

## Shared Responsibility for PCI DSS

### Responsibility Matrix

| Control | Cloud Provider | Customer |
|---------|---------------|----------|
| Physical security (data centers) | Provider | N/A |
| Hypervisor security | Provider | N/A |
| Network infrastructure | Provider | Customer (VPC, SGs, NACLs) |
| OS patching (managed services) | Provider | Customer (config, access) |
| OS patching (IaaS) | N/A | Customer |
| Application security | N/A | Customer |
| Data encryption | Provider (options) | Customer (implementation) |
| Access control | Provider (IAM service) | Customer (policies) |
| Logging | Provider (service) | Customer (configuration, review) |
| Vulnerability scanning | N/A | Customer |
| Penetration testing | N/A | Customer (with provider approval) |

---

## Cloud Implementation

### Cardholder Data Environment (CDE) Architecture

| Component | AWS | Azure | GCP |
|-----------|-----|-------|-----|
| Network Isolation | Dedicated VPC, private subnets | Dedicated VNet, private subnets | Dedicated VPC, private subnets |
| Firewall | Network Firewall, WAF | Azure Firewall, WAF | Cloud Firewall, Cloud Armor |
| Segmentation | Security groups, NACLs | NSGs, ASGs | Firewall rules, VPC Service Controls |
| Encryption at Rest | KMS (AES-256), S3 SSE | Key Vault, TDE, Azure Disk Encryption | Cloud KMS, CMEK |
| Encryption in Transit | TLS 1.2+, ACM certs | TLS 1.2+, App Gateway TLS | TLS 1.2+, managed certs |
| Tokenization | Custom (Lambda + DynamoDB) | Custom (Functions + Cosmos DB) | Sensitive Data Protection API |
| Access Control | IAM, Identity Center | RBAC, Entra ID, PIM | IAM, Cloud Identity |
| Logging | CloudTrail, CloudWatch Logs | Activity Log, Azure Monitor | Cloud Audit Logs, Cloud Logging |
| Monitoring | Security Hub, GuardDuty | Defender for Cloud, Sentinel | SCC, Chronicle |
| Vulnerability Scanning | Inspector | Defender for Cloud | Artifact Analysis, Web Security Scanner |

### Network Segmentation Best Practices

```
┌──────────────────────────────────────────────┐
│                   VPC/VNet                    │
│                                              │
│  ┌──────────────┐  ┌──────────────────────┐  │
│  │  Public       │  │  Private (CDE)       │  │
│  │  Subnet       │  │  Subnet              │  │
│  │              │  │                      │  │
│  │  ALB/LB      │  │  App Servers         │  │
│  │  WAF         │──│  (no public IP)      │  │
│  │  Bastion     │  │                      │  │
│  └──────────────┘  │  ┌────────────────┐  │  │
│                    │  │  Data Subnet    │  │  │
│                    │  │  (most strict)  │  │  │
│                    │  │  DB + vault     │  │  │
│                    │  └────────────────┘  │  │
│                    └──────────────────────┘  │
└──────────────────────────────────────────────┘
```

---

## PCI DSS v4.0 Key Changes

| Change | Impact | Cloud Implementation |
|--------|--------|---------------------|
| Customized approach | Alternative to defined approach for controls | Document custom cloud controls |
| MFA for all CDE access | MFA required for all users, not just admins | Enforce MFA via IAM/Entra/Cloud Identity |
| Authenticated vulnerability scanning | Internal scans must be authenticated | Authenticated scanning with Inspector/Defender |
| Targeted risk analysis | Risk-based approach for control frequency | Document risk assessments per control |
| Script management (Req 6.4.3) | Manage payment page scripts | CSP headers, subresource integrity |
| Enhanced logging (Req 10.4.1) | Automated log review mechanisms | SIEM with automated alerting |

---

## Compliance Validation Levels

| Level | Criteria | Validation |
|-------|----------|------------|
| Level 1 | > 6 million transactions/year | Annual on-site QSA audit + quarterly ASV scan |
| Level 2 | 1-6 million transactions/year | Annual SAQ + quarterly ASV scan |
| Level 3 | 20,000-1 million e-commerce transactions/year | Annual SAQ + quarterly ASV scan |
| Level 4 | < 20,000 e-commerce or < 1 million other transactions/year | Annual SAQ + quarterly ASV scan (recommended) |

---

## Scope Reduction Strategies

| Strategy | Description | Cloud Implementation |
|----------|-------------|---------------------|
| Tokenization | Replace card data with tokens | Payment processor tokenization, custom token vault |
| P2PE | Point-to-point encryption | Terminal-to-processor encryption |
| Network Segmentation | Isolate CDE from other environments | Separate VPCs, strict firewall rules |
| Outsource Payment Processing | Use hosted payment pages | Stripe, Braintree, Adyen hosted forms |
| Reduce Data Storage | Minimize stored cardholder data | Purge policies, tokenize at ingestion |

---

## Documentation Links

- PCI SSC: https://www.pcisecuritystandards.org/
- AWS PCI DSS: https://aws.amazon.com/compliance/pci-dss-level-1-faqs/
- Azure PCI DSS: https://learn.microsoft.com/en-us/azure/compliance/offerings/offering-pci-dss
- Google Cloud PCI DSS: https://cloud.google.com/security/compliance/pci-dss
