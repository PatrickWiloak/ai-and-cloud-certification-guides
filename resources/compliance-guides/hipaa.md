# Compliance Guide - HIPAA

## Overview

HIPAA (Health Insurance Portability and Accountability Act) establishes national standards for protecting sensitive patient health information (PHI). Cloud providers offer HIPAA-eligible services, but the responsibility for compliance is shared between the provider and the customer.

---

## HIPAA Rules

### Key Regulations

| Rule | Purpose | Applies To |
|------|---------|-----------|
| Privacy Rule | Governs use and disclosure of PHI | Covered entities, business associates |
| Security Rule | Technical, physical, administrative safeguards for ePHI | Covered entities, business associates |
| Breach Notification Rule | Requirements for breach reporting | Covered entities, business associates |
| Enforcement Rule | Penalties for non-compliance | Covered entities, business associates |
| Omnibus Rule | Extends requirements to business associates | Business associates, subcontractors |

### Business Associate Agreement (BAA)

| Cloud Provider | BAA Available | How to Obtain |
|---------------|---------------|---------------|
| AWS | Yes | AWS Artifact (self-service) |
| Azure | Yes | Microsoft Trust Center (auto-accepted in terms) |
| Google Cloud | Yes | Admin Console or contract amendment |

---

## Security Rule Safeguards

### Administrative Safeguards

| Safeguard | Requirement | Cloud Implementation |
|-----------|-------------|---------------------|
| Security Management | Risk analysis and risk management | CSPM tools, vulnerability scanning |
| Assigned Security Responsibility | Designated security officer | Documented roles, IAM admin policies |
| Workforce Security | Authorization, supervision, termination | IAM lifecycle, access reviews |
| Information Access Management | Access authorization, modification | RBAC, least privilege, access logs |
| Security Awareness Training | Security reminders, login monitoring | Training platforms, CloudTrail/audit logs |
| Security Incident Procedures | Incident response and reporting | GuardDuty/Defender/SCC, automated response |
| Contingency Plan | Data backup, DR, emergency operations | Cloud backup services, multi-region DR |
| Evaluation | Periodic assessment | Compliance scanning, penetration testing |

### Technical Safeguards

| Safeguard | Requirement | Cloud Implementation |
|-----------|-------------|---------------------|
| Access Control | Unique user ID, emergency access, auto-logoff, encryption | IAM users, break-glass accounts, session policies, KMS |
| Audit Controls | Record and examine system activity | CloudTrail, audit logs, SIEM |
| Integrity | ePHI integrity mechanisms | Checksums, version control, backup validation |
| Authentication | Person or entity authentication | MFA, certificate-based auth, SSO |
| Transmission Security | Encryption of ePHI in transit | TLS 1.2+, VPN, private endpoints |

### Physical Safeguards

| Safeguard | Requirement | Cloud Provider Responsibility |
|-----------|-------------|-------------------------------|
| Facility Access Controls | Limit physical access to data centers | Cloud provider manages data center security |
| Workstation Use | Policies for workstation use and access | Customer responsibility |
| Device and Media Controls | Hardware disposal, media reuse | Cloud provider handles disk destruction, customer manages snapshots/backups |

---

## HIPAA-Eligible Services

### AWS HIPAA-Eligible Services (Partial List)

| Category | Services |
|----------|----------|
| Compute | EC2, Lambda, ECS, EKS, Fargate |
| Storage | S3, EBS, EFS, Glacier |
| Database | RDS, Aurora, DynamoDB, Redshift |
| Networking | VPC, CloudFront, Route 53, Direct Connect |
| Security | KMS, CloudTrail, GuardDuty, Security Hub |
| Analytics | Athena, EMR, Glue, Kinesis |
| AI/ML | SageMaker, Comprehend Medical, Transcribe Medical |

### Azure HIPAA-Eligible Services

| Category | Services |
|----------|----------|
| Compute | Virtual Machines, App Service, Functions, AKS |
| Storage | Blob Storage, Managed Disks, Azure Files |
| Database | Azure SQL, Cosmos DB, Azure Database for PostgreSQL/MySQL |
| Networking | VNet, Application Gateway, Front Door, ExpressRoute |
| Security | Key Vault, Defender, Sentinel, Azure AD |
| Analytics | Synapse Analytics, Data Factory, Stream Analytics |
| AI/ML | Azure AI Services, Azure Machine Learning |

### Google Cloud HIPAA-Covered Services

| Category | Services |
|----------|----------|
| Compute | Compute Engine, Cloud Functions, Cloud Run, GKE |
| Storage | Cloud Storage, Persistent Disk, Filestore |
| Database | Cloud SQL, Spanner, Firestore, Bigtable, BigQuery |
| Networking | VPC, Cloud Load Balancing, Cloud CDN, Cloud Interconnect |
| Security | Cloud KMS, Cloud Audit Logs, SCC |
| Analytics | Dataflow, Dataproc, Pub/Sub |
| AI/ML | Vertex AI, Healthcare API |

---

## Architecture Patterns for HIPAA

### Network Isolation

| Pattern | Implementation |
|---------|----------------|
| VPC Isolation | Dedicated VPC for HIPAA workloads |
| Private Subnets | No direct internet access for ePHI |
| Private Endpoints | PrivateLink / Private Link / Private Service Connect |
| Network Segmentation | Separate subnets for app, data, management |
| Encryption in Transit | TLS everywhere, VPN for hybrid |

### Data Protection

| Pattern | Implementation |
|---------|----------------|
| Encryption at Rest | KMS-managed keys for all storage |
| Encryption in Transit | TLS 1.2+, enforce HTTPS |
| Data Classification | Tag/label ePHI resources |
| Access Logging | Full audit trail for all ePHI access |
| Backup Encryption | Encrypted backups with tested restores |
| Data Retention | Automated lifecycle policies (6-year minimum for HIPAA) |

---

## Breach Notification Requirements

| Requirement | Timeline | Action |
|-------------|----------|--------|
| Individual Notice | Within 60 days of discovery | Written notice to affected individuals |
| HHS Notice | Within 60 days (500+ individuals), annually (under 500) | Report via HHS breach portal |
| Media Notice | Without unreasonable delay (500+ in a state) | Prominent media outlet notification |

---

## Documentation Links

- HHS HIPAA: https://www.hhs.gov/hipaa/
- AWS HIPAA: https://aws.amazon.com/compliance/hipaa-compliance/
- Azure HIPAA: https://learn.microsoft.com/en-us/azure/compliance/offerings/offering-hipaa-us
- Google Cloud HIPAA: https://cloud.google.com/security/compliance/hipaa
