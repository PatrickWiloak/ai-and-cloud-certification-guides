# Compliance Guide - FedRAMP

## Overview

FedRAMP (Federal Risk and Authorization Management Program) is a US government program that provides a standardized approach to security assessment, authorization, and continuous monitoring for cloud products and services used by federal agencies.

---

## FedRAMP Basics

### Impact Levels

| Level | Description | Controls | Examples |
|-------|-------------|----------|----------|
| Low | Minimal adverse effect on operations | ~125 controls | Public-facing websites |
| Moderate | Serious adverse effect on operations | ~325 controls | Most government data (CUI) |
| High | Severe/catastrophic effect | ~421 controls | Law enforcement, emergency services, financial, health |

### Authorization Paths

| Path | Description | Timeline | Best For |
|------|-------------|----------|----------|
| JAB (Joint Authorization Board) | Provisional ATO from JAB | 6-12 months | Broad federal use |
| Agency | ATO from a single federal agency | 3-6 months | Single agency relationship |
| FedRAMP Ready | Pre-assessment designation | 2-4 months | Market signal, pipeline preparation |

---

## Cloud Provider FedRAMP Status

### AWS GovCloud

| Aspect | Details |
|--------|---------|
| Authorization Level | FedRAMP High (GovCloud), FedRAMP Moderate (Standard regions) |
| Regions | us-gov-west-1, us-gov-east-1 |
| Services | 100+ FedRAMP-authorized services |
| Isolation | Physically isolated, US-person operated |
| Additional Compliance | DoD SRG IL2-IL5, ITAR, CJIS |

### Azure Government

| Aspect | Details |
|--------|---------|
| Authorization Level | FedRAMP High |
| Regions | US Gov Virginia, US Gov Arizona, US Gov Texas |
| Services | 100+ FedRAMP-authorized services |
| Isolation | Physically separated, screened US persons |
| Additional Compliance | DoD SRG IL2-IL5, ITAR, CJIS, IRS 1075 |

### Google Cloud

| Aspect | Details |
|--------|---------|
| Authorization Level | FedRAMP High (select services), FedRAMP Moderate (most services) |
| Regions | us-central1, us-east4 (Assured Workloads) |
| Services | 80+ FedRAMP-authorized services |
| Isolation | Assured Workloads for logical isolation |
| Additional Compliance | DoD SRG IL2-IL4, CJIS |

---

## NIST 800-53 Control Families

FedRAMP is based on NIST SP 800-53 controls:

| Family | ID | Cloud-Relevant Controls |
|--------|-----|------------------------|
| Access Control | AC | AC-2 (account management), AC-6 (least privilege), AC-17 (remote access) |
| Audit and Accountability | AU | AU-2 (auditable events), AU-6 (audit review), AU-12 (audit generation) |
| Configuration Management | CM | CM-2 (baseline config), CM-6 (config settings), CM-7 (least functionality) |
| Contingency Planning | CP | CP-9 (system backup), CP-10 (system recovery) |
| Identification and Authentication | IA | IA-2 (MFA), IA-5 (authenticator management) |
| Incident Response | IR | IR-4 (incident handling), IR-6 (incident reporting) |
| Risk Assessment | RA | RA-5 (vulnerability scanning) |
| System and Communications Protection | SC | SC-7 (boundary protection), SC-13 (cryptographic protection), SC-28 (encryption at rest) |
| System and Information Integrity | SI | SI-2 (flaw remediation), SI-4 (information system monitoring) |

---

## Continuous Monitoring Requirements

| Requirement | Frequency | Implementation |
|-------------|-----------|----------------|
| Vulnerability Scanning | Monthly (OS), weekly (web apps) | Inspector, Defender, Web Security Scanner |
| POA&M (Plan of Action and Milestones) | Monthly updates | Tracked in GRC tool |
| Significant Change Requests | As needed | Change management process |
| Annual Assessment | Yearly | 3PAO reassessment |
| Incident Reporting | Within 1 hour (US-CERT) | Automated detection and notification |
| Configuration Scanning | Monthly | Config Rules, Azure Policy, SCC |

---

## Key Architecture Requirements

### Boundary Protection

| Requirement | Implementation |
|-------------|----------------|
| Network segmentation | Dedicated VPC/VNet, strict firewall rules |
| Intrusion detection | IDS/IPS, threat detection services |
| DNS security | DNSSEC, DNS logging |
| TLS enforcement | TLS 1.2+ only, certificate management |
| Egress filtering | Outbound firewall rules, proxy |

### Data Protection

| Requirement | Implementation |
|-------------|----------------|
| Encryption at rest | FIPS 140-2 validated modules |
| Encryption in transit | TLS 1.2+, IPSec VPN |
| Key management | FIPS 140-2 Level 3 HSM |
| Data location | US-only regions |
| Media sanitization | Cloud provider (for hardware), customer (for data) |

### Identity and Access

| Requirement | Implementation |
|-------------|----------------|
| MFA | Required for all privileged access |
| PIV/CAC | Federal identity cards (where applicable) |
| Session management | Timeout, concurrent session limits |
| Separation of duties | Role-based access, approval workflows |
| Account management | Automated provisioning/deprovisioning |

---

## FedRAMP vs StateRAMP vs DoD SRG

| Framework | Scope | Based On | Levels |
|-----------|-------|----------|--------|
| FedRAMP | Federal agencies | NIST 800-53 | Low, Moderate, High |
| StateRAMP | State/local government | NIST 800-53 (subset) | 1, 2, 3 |
| DoD SRG | Department of Defense | NIST 800-53 + DoD controls | IL2, IL4, IL5, IL6 |
| CMMC | DoD contractors | NIST 800-171 | Level 1, 2, 3 |

---

## Documentation Links

- FedRAMP: https://www.fedramp.gov/
- FedRAMP Marketplace: https://marketplace.fedramp.gov/
- NIST SP 800-53: https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final
- AWS GovCloud: https://aws.amazon.com/govcloud-us/
- Azure Government: https://learn.microsoft.com/en-us/azure/azure-government/
- Google Assured Workloads: https://cloud.google.com/assured-workloads/docs
