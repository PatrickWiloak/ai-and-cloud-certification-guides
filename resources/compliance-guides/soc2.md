# Compliance Guide - SOC 2

## Overview

SOC 2 (System and Organization Controls 2) is a compliance framework developed by the AICPA that evaluates an organization's information systems based on five Trust Services Criteria. It is the most commonly requested compliance report for SaaS and cloud service providers.

---

## Trust Services Criteria

### The Five Categories

| Criteria | Description | Required? |
|----------|-------------|-----------|
| Security (CC) | Protection against unauthorized access | Always required |
| Availability (A) | System is available for operation as committed | Optional |
| Processing Integrity (PI) | System processing is complete, valid, accurate, timely | Optional |
| Confidentiality (C) | Information designated as confidential is protected | Optional |
| Privacy (P) | Personal information is collected, used, retained, and disclosed properly | Optional |

### SOC 2 Type I vs Type II

| Aspect | Type I | Type II |
|--------|--------|---------|
| Scope | Design of controls at a point in time | Design and operating effectiveness over a period |
| Duration | Single date | 3-12 month observation period |
| Value | Controls are properly designed | Controls work consistently |
| Common Use | First-time audit or new system | Ongoing compliance |
| Customer Preference | Acceptable for initial engagement | Preferred for enterprise contracts |

---

## Cloud Provider SOC 2 Support

### AWS

| Control Area | AWS Service | Implementation |
|-------------|-------------|----------------|
| Access Control | IAM, Organizations, SCPs | Least privilege, MFA, role-based access |
| Logging | CloudTrail, CloudWatch, Config | Centralized logging, tamper-proof storage |
| Encryption | KMS, ACM, S3 encryption | Encryption at rest and in transit |
| Network Security | VPC, Security Groups, WAF | Network segmentation, firewall rules |
| Change Management | CloudFormation, CodePipeline | IaC, automated deployments, approval gates |
| Incident Response | GuardDuty, Security Hub, EventBridge | Automated detection and response |
| Backup/DR | AWS Backup, S3 versioning | Automated backups, cross-region replication |
| Monitoring | CloudWatch, X-Ray, Config Rules | Continuous monitoring, alerting |

### Azure

| Control Area | Azure Service | Implementation |
|-------------|---------------|----------------|
| Access Control | Entra ID, RBAC, PIM | Conditional Access, JIT, MFA |
| Logging | Azure Monitor, Activity Log, Defender | Centralized logging, SIEM |
| Encryption | Key Vault, TDE, Azure Disk Encryption | Encryption at rest and in transit |
| Network Security | NSGs, Azure Firewall, Private Link | Network segmentation, micro-segmentation |
| Change Management | Azure DevOps, ARM/Bicep | IaC, pipeline approvals |
| Incident Response | Sentinel, Defender for Cloud | Automated detection and response |
| Backup/DR | Azure Backup, Site Recovery | Automated backups, cross-region DR |
| Monitoring | Azure Monitor, Application Insights | Continuous monitoring, alerting |

### Google Cloud

| Control Area | GCP Service | Implementation |
|-------------|-------------|----------------|
| Access Control | IAM, Cloud Identity, BeyondCorp | Workload Identity, context-aware access |
| Logging | Cloud Audit Logs, Cloud Logging | Centralized logging, locked retention |
| Encryption | Cloud KMS, CMEK, default encryption | Encryption at rest and in transit |
| Network Security | VPC, Firewall Rules, Cloud Armor | VPC Service Controls, private access |
| Change Management | Cloud Build, Cloud Deploy, Terraform | IaC, automated deployments |
| Incident Response | SCC, Chronicle | Automated detection and response |
| Backup/DR | Cloud SQL backups, GKE backup | Automated backups, multi-region |
| Monitoring | Cloud Monitoring, Cloud Trace | Continuous monitoring, SLO-based alerting |

---

## Common Controls Mapping

### Security (Common Criteria)

| CC Number | Control | Cloud Implementation |
|-----------|---------|---------------------|
| CC1.1 | COSO Principle 1 - Integrity and ethics | Code of conduct, security training |
| CC2.1 | Communication of objectives | Security policies, documented procedures |
| CC3.1 | Risk assessment | Cloud security posture management (CSPM) |
| CC5.1 | Control activities | Automated controls via IaC |
| CC6.1 | Logical access security | IAM, MFA, SSO |
| CC6.2 | System access management | User provisioning/deprovisioning |
| CC6.3 | Role-based access | RBAC, least privilege |
| CC6.6 | External threats | WAF, DDoS protection, threat detection |
| CC6.7 | Data transmission security | TLS, VPN, private endpoints |
| CC6.8 | Malicious software prevention | Endpoint protection, image scanning |
| CC7.1 | Monitoring | SIEM, log aggregation, alerting |
| CC7.2 | Anomaly detection | Threat detection services |
| CC7.3 | Incident evaluation | Incident response runbooks |
| CC7.4 | Incident response | Automated remediation workflows |
| CC8.1 | Change management | CI/CD pipelines, approval workflows |
| CC9.1 | Risk mitigation | Insurance, SLAs, backup strategies |

---

## Audit Preparation Checklist

### Documentation Required

- [ ] Information security policy
- [ ] Access control policy and procedures
- [ ] Change management procedures
- [ ] Incident response plan
- [ ] Business continuity and disaster recovery plan
- [ ] Risk assessment documentation
- [ ] Vendor management policy
- [ ] Data classification policy
- [ ] Employee onboarding/offboarding procedures
- [ ] Network architecture diagrams

### Evidence Collection

| Evidence Type | Source | Automation |
|--------------|--------|------------|
| Access reviews | IAM policies, user lists | AWS Access Analyzer, Azure Access Reviews |
| Audit logs | CloudTrail, Activity Log, Audit Logs | Centralized log export |
| Configuration compliance | Config Rules, Azure Policy, SCC | Continuous compliance scanning |
| Encryption status | KMS key inventory, encryption settings | Config Rules, Policy |
| Network configuration | VPC configs, security groups, firewall rules | IaC source of truth |
| Change records | CI/CD pipeline history, deployment logs | Pipeline audit trails |
| Incident records | Incident tickets, post-mortems | Ticketing system export |
| Backup verification | Backup logs, restore test records | Automated backup verification |

---

## Certification Exam Relevance

SOC 2 knowledge is relevant for:
- AWS Solutions Architect Professional
- Azure Security Engineer (AZ-500)
- Google Cloud Security Engineer
- AWS Security Specialty

---

## Documentation Links

- AICPA SOC 2: https://www.aicpa-cima.com/topic/audit-assurance/audit-and-assurance-greater-than-soc-2
- AWS SOC Compliance: https://aws.amazon.com/compliance/soc-faqs/
- Azure SOC Reports: https://learn.microsoft.com/en-us/azure/compliance/offerings/offering-soc-2
- Google Cloud SOC Reports: https://cloud.google.com/security/compliance/soc-2
