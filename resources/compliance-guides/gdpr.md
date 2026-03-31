# Compliance Guide - GDPR

## Overview

GDPR (General Data Protection Regulation) is the European Union's comprehensive data protection law that governs how personal data of EU residents is collected, processed, stored, and transferred. It applies to any organization that processes data of EU residents, regardless of where the organization is located.

---

## Key GDPR Principles

| Principle | Description | Cloud Implementation |
|-----------|-------------|---------------------|
| Lawfulness, fairness, transparency | Legal basis for processing, clear communication | Consent management, privacy policies |
| Purpose limitation | Collect data for specified purposes only | Data classification, access controls |
| Data minimization | Collect only what is necessary | Schema design, collection restrictions |
| Accuracy | Keep data accurate and up-to-date | Validation rules, update mechanisms |
| Storage limitation | Retain data only as long as needed | Lifecycle policies, automated deletion |
| Integrity and confidentiality | Protect data with appropriate security | Encryption, access controls, monitoring |
| Accountability | Demonstrate compliance | Audit logs, documentation, DPIAs |

---

## Data Subject Rights

| Right | Description | Technical Implementation |
|-------|-------------|--------------------------|
| Right of Access | Provide copy of personal data | API for data export, automated retrieval |
| Right to Rectification | Correct inaccurate data | Self-service update portals, API endpoints |
| Right to Erasure | Delete personal data ("right to be forgotten") | Automated deletion workflows, cascade deletes |
| Right to Restrict Processing | Limit how data is used | Processing flags, conditional logic |
| Right to Data Portability | Provide data in machine-readable format | JSON/CSV export, standard formats |
| Right to Object | Object to certain processing | Opt-out mechanisms, processing controls |
| Automated Decision-Making | Contest automated decisions | Human review workflows, explainability |

---

## Cloud Provider GDPR Support

### AWS

| Requirement | AWS Service | Implementation |
|-------------|-------------|----------------|
| Data Residency | Region selection | Deploy in eu-west-1, eu-central-1, etc. |
| Encryption | KMS, S3 SSE, EBS encryption | Encrypt all personal data at rest |
| Access Control | IAM, Organizations | Least privilege, separation of duties |
| Audit Logging | CloudTrail, CloudWatch | Log all access to personal data |
| Data Discovery | Macie | Discover and classify PII in S3 |
| Data Deletion | S3 lifecycle, Lambda automation | Automated retention and deletion |
| Transfer Mechanisms | Region restriction (SCPs) | Prevent data from leaving EU regions |
| DPA | AWS Data Processing Addendum | Available through AWS Artifact |

### Azure

| Requirement | Azure Service | Implementation |
|-------------|---------------|----------------|
| Data Residency | Region selection, data residency options | Deploy in West Europe, North Europe, etc. |
| Encryption | Key Vault, TDE, disk encryption | Customer-managed keys |
| Access Control | Entra ID, RBAC | Conditional Access, PIM |
| Audit Logging | Azure Monitor, Activity Log | Comprehensive audit trails |
| Data Discovery | Microsoft Purview | Data classification and governance |
| Data Deletion | Lifecycle management, Logic Apps | Automated retention policies |
| Transfer Mechanisms | Azure Policy (allowed locations) | Restrict to EU regions |
| DPA | Microsoft DPA | Auto-accepted in Online Services Terms |

### Google Cloud

| Requirement | GCP Service | Implementation |
|-------------|-------------|----------------|
| Data Residency | Region selection, org policies | Deploy in europe-west regions |
| Encryption | Cloud KMS, CMEK | Customer-managed encryption keys |
| Access Control | IAM, Cloud Identity | Workload Identity, context-aware access |
| Audit Logging | Cloud Audit Logs | Admin Activity, Data Access logs |
| Data Discovery | Sensitive Data Protection (DLP) | Discover and redact PII |
| Data Deletion | Object lifecycle, Cloud Functions | Automated retention and deletion |
| Transfer Mechanisms | Org policy (resource locations) | Restrict to EU regions |
| DPA | Google Cloud DPA | Available via Admin Console |

---

## Data Transfer Mechanisms

### Transferring Data Outside the EU/EEA

| Mechanism | Description | Status |
|-----------|-------------|--------|
| EU-US Data Privacy Framework | Adequacy decision for US companies | Active (July 2023) |
| Standard Contractual Clauses (SCCs) | EU-approved contract terms | Required for non-adequate countries |
| Binding Corporate Rules (BCRs) | Internal group transfer rules | For multinational organizations |
| Adequacy Decisions | EU-recognized countries | UK, Canada, Japan, South Korea, others |
| Derogations | Explicit consent, contract necessity | Limited use, case-by-case |

---

## Technical Implementation Patterns

### Data Residency Architecture

```
┌─────────────────────────────────────────┐
│           EU Region Only                │
│                                         │
│  ┌──────────┐  ┌──────────┐           │
│  │ App Layer │  │ API GW   │           │
│  │ (compute) │  │          │           │
│  └─────┬─────┘  └──────────┘           │
│        │                                │
│  ┌─────▼─────┐  ┌──────────┐           │
│  │ Database   │  │ Storage  │           │
│  │ (encrypted)│  │(encrypted│           │
│  └───────────┘  └──────────┘           │
│                                         │
│  ┌───────────┐  ┌──────────┐           │
│  │ Audit Logs │  │ Backups  │           │
│  │ (retained) │  │(EU only) │           │
│  └───────────┘  └──────────┘           │
└─────────────────────────────────────────┘
```

### Privacy by Design Checklist

- [ ] Data minimization - collect only required fields
- [ ] Pseudonymization - replace identifiers where possible
- [ ] Encryption at rest and in transit
- [ ] Access logging for all personal data access
- [ ] Automated data retention and deletion
- [ ] Consent management system
- [ ] Data subject request handling (automated where possible)
- [ ] Data Protection Impact Assessment (DPIA) for high-risk processing
- [ ] Breach notification workflow (72-hour requirement)
- [ ] Regular access reviews and least privilege enforcement

---

## Breach Notification

| Requirement | Timeline | Action |
|-------------|----------|--------|
| Supervisory Authority | Within 72 hours of awareness | Notify relevant DPA |
| Data Subjects | Without undue delay (if high risk) | Direct notification |
| Documentation | All breaches | Maintain breach register |

### Automated Breach Detection

| Cloud | Detection Service | Notification |
|-------|-------------------|-------------|
| AWS | GuardDuty, Macie, Security Hub | EventBridge -> SNS -> incident workflow |
| Azure | Defender for Cloud, Sentinel | Logic Apps -> incident workflow |
| GCP | SCC, Chronicle | Pub/Sub -> Cloud Functions -> incident workflow |

---

## Penalties

| Violation Type | Maximum Fine |
|---------------|-------------|
| Lower tier (Articles 8, 11, 25-39, 42, 43) | 10 million EUR or 2% of global annual revenue |
| Upper tier (Articles 5-7, 9, 12-22, 44-49) | 20 million EUR or 4% of global annual revenue |

---

## Documentation Links

- GDPR Official Text: https://gdpr-info.eu/
- AWS GDPR Center: https://aws.amazon.com/compliance/gdpr-center/
- Azure GDPR: https://learn.microsoft.com/en-us/compliance/regulatory/gdpr
- Google Cloud GDPR: https://cloud.google.com/privacy/gdpr
