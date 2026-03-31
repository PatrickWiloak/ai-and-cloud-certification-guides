# Service Comparison - Security Tools

## Overview

This guide compares cloud security services across AWS, Azure, and Google Cloud - covering threat detection, web application firewalls, secrets management, identity and access management, and compliance tools. These are critical topics for security-focused certification exams.

---

## Threat Detection and Security Monitoring

### GuardDuty vs Microsoft Defender vs Security Command Center

| Feature | AWS GuardDuty | Microsoft Defender for Cloud | Google Security Command Center |
|---------|---------------|-------------------------------|--------------------------------|
| Type | Threat detection service | CSPM + CWPP | CSPM + threat detection |
| Data Sources | CloudTrail, VPC Flow Logs, DNS, S3, EKS, Lambda | Azure Activity Log, resource configs, network | Cloud Audit Logs, VPC Flow Logs, asset inventory |
| ML/AI Detection | Yes (anomaly detection) | Yes (behavioral analytics) | Yes (Event Threat Detection) |
| Pricing Model | Per GB analyzed + per event | Per resource/hour (by plan) | Standard/Premium tiers |
| Multi-Account | Organizations integration | Management groups | Organization-level |
| Threat Intel | AWS threat intelligence feeds | Microsoft threat intelligence | Google threat intelligence |
| Container Security | EKS Runtime Monitoring | Defender for Containers | Container Threat Detection |
| Malware Scanning | GuardDuty Malware Protection | Defender for Storage | On-demand scanning |
| Auto-Remediation | EventBridge + Lambda/SSM | Logic Apps / Azure Functions | Cloud Functions + Pub/Sub |
| Compliance Scoring | No (use Security Hub) | Secure Score | Security Health Analytics |

### Security Posture Management

| Feature | AWS Security Hub | Microsoft Defender CSPM | Google SCC Premium |
|---------|------------------|--------------------------|---------------------|
| Standards | CIS, PCI DSS, NIST, AWS FSBP | CIS, PCI DSS, NIST, ISO, SOC2 | CIS, PCI DSS, NIST, ISO |
| Findings Aggregation | Yes (multi-account) | Yes (multi-subscription) | Yes (organization) |
| Custom Standards | Yes | Yes | Yes |
| Attack Path Analysis | No | Yes (cloud security graph) | Yes (toxic combinations) |
| Risk Prioritization | Severity-based | Risk-based (attack paths) | Risk-based |
| Integration | 80+ partner integrations | 50+ partner integrations | Partner integrations |
| Automated Remediation | Custom actions + EventBridge | Governance rules | Custom modules |

---

## Web Application Firewall (WAF)

### AWS WAF vs Azure WAF vs Cloud Armor

| Feature | AWS WAF | Azure WAF | Google Cloud Armor |
|---------|---------|-----------|-------------------|
| Deployment | CloudFront, ALB, API Gateway, App Runner | Application Gateway, Front Door, CDN | Global/Regional LB, Cloud CDN |
| Managed Rules | AWS Managed Rules + Marketplace | OWASP CRS (DRS 2.1) | Preconfigured WAF rules |
| Custom Rules | Up to 10 rules per WebACL (adjustable) | Custom rules | Custom rules (CEL expressions) |
| Rate Limiting | Rate-based rules | Rate limiting | Rate limiting + throttling |
| Bot Control | AWS WAF Bot Control | Bot Manager (Front Door Premium) | reCAPTCHA Enterprise integration |
| DDoS Protection | Shield Standard (free) / Advanced | DDoS Protection Standard | Cloud Armor Standard + Managed Protection |
| Geo-blocking | Yes | Yes | Yes |
| IP Reputation | AWS Managed Rules (IP reputation) | Microsoft Threat Intelligence | Google Threat Intelligence |
| Logging | CloudWatch Logs, S3, Kinesis Firehose | Azure Monitor, Log Analytics | Cloud Logging |
| Pricing | Per WebACL + per rule + per request | Per gateway-hour + per rule | Per policy + per request |
| Adaptive Protection | No | No | Yes (ML-based) |
| Named IP Lists | Yes | Yes | Yes |

### DDoS Protection Comparison

| Feature | AWS Shield | Azure DDoS Protection | Google Cloud Armor |
|---------|-----------|------------------------|---------------------|
| Free Tier | Shield Standard (L3/L4) | Basic (always on) | Standard tier |
| Premium Tier | Shield Advanced ($3,000/mo) | DDoS Protection ($2,944/mo) | Managed Protection Plus |
| L7 Protection | Via WAF | Via WAF | Via Cloud Armor policies |
| Response Team | Shield Response Team (SRT) | Rapid Response team | N/A |
| Cost Protection | Yes (Shield Advanced) | Yes | N/A |
| Attack Visibility | Shield metrics + CloudWatch | DDoS attack analytics | Cloud Armor telemetry |

---

## Secrets Management

### AWS Secrets Manager vs Azure Key Vault vs Secret Manager

| Feature | AWS Secrets Manager | Azure Key Vault | Google Secret Manager |
|---------|--------------------|-----------------|-----------------------|
| Secret Types | Arbitrary secrets, DB credentials | Secrets, keys, certificates | Arbitrary secrets |
| Automatic Rotation | Built-in (RDS, Redshift, DocumentDB) | Custom (Event Grid + Functions) | Custom (Pub/Sub + Cloud Functions) |
| Rotation Frequency | Configurable (days) | Custom schedule | Custom schedule |
| Versioning | Automatic (staging labels) | Automatic | Automatic (versions) |
| Cross-Region | Replica secrets | N/A (deploy per region) | Automatic replication |
| Access Control | IAM policies + resource policies | Azure RBAC + access policies | IAM policies |
| Audit Logging | CloudTrail | Azure Monitor / Activity Log | Cloud Audit Logs |
| Encryption | AWS KMS (CMK or AWS-managed) | HSM-backed (FIPS 140-2 L2) | Cloud KMS (envelope encryption) |
| Pricing | $0.40/secret/month + $0.05/10K API calls | $0.03/10K operations | $0.06/secret version/month + $0.03/10K access |
| Max Secret Size | 64 KB | 25 KB | 64 KB |
| CSI Driver | Yes (EKS) | Yes (AKS) | Yes (GKE) |
| Terraform Support | Yes | Yes | Yes |

### Key Management Services

| Feature | AWS KMS | Azure Key Vault (Keys) | Google Cloud KMS |
|---------|---------|------------------------|-------------------|
| Key Types | Symmetric, Asymmetric, HMAC | RSA, EC, Symmetric (oct) | Symmetric, Asymmetric, MAC |
| HSM Options | Default (multi-tenant), Custom Key Store (CloudHSM) | Standard, Premium (HSM), Managed HSM | Software, HSM, External |
| FIPS 140-2 Level | Level 3 (CloudHSM) | Level 2 (Premium), Level 3 (Managed HSM) | Level 3 (HSM keys) |
| External Key Store | Yes (XKS) | N/A | Yes (EKM) |
| Auto-Rotation | Annual (configurable) | Configurable | Configurable |
| Multi-Region Keys | Yes | N/A | N/A (per region) |
| Pricing | $1/key/month + $0.03/10K requests | $1/key/month (HSM) + operations | $0.06/key version/month + operations |

### Certificate Management

| Feature | AWS Certificate Manager | Azure Key Vault (Certificates) | Google Certificate Manager |
|---------|------------------------|-------------------------------|---------------------------|
| Free Public Certs | Yes (ACM-issued) | No (partner CAs) | Yes (Google-managed) |
| Auto-Renewal | Yes (ACM-issued) | Yes (integrated CAs) | Yes (Google-managed) |
| Private CA | ACM Private CA | Integrated CAs | Certificate Authority Service |
| Wildcard Certs | Yes | Yes | Yes |
| Integration | CloudFront, ALB, API Gateway | App Gateway, Front Door, App Service | Load Balancers, GKE |

---

## Identity and Access Management

### Core IAM Comparison

| Feature | AWS IAM | Azure RBAC + Entra ID | Google Cloud IAM |
|---------|---------|------------------------|-------------------|
| Identity Model | Users, Groups, Roles | Users, Groups, Service Principals | Users, Groups, Service Accounts |
| Policy Model | JSON policies (identity + resource) | Role assignments (scope-based) | IAM policies (resource-based) |
| Max Policies per Entity | 10 managed policies per user/role | 4,000 role assignments per subscription | Multiple bindings per resource |
| Predefined Roles | AWS managed policies | 400+ built-in roles | 900+ predefined roles |
| Custom Roles | Custom policies | Custom roles | Custom roles |
| Condition-based Access | IAM conditions (15+ context keys) | ABAC (attribute conditions) | IAM conditions |
| Permission Boundaries | Yes | N/A (use management groups) | N/A (use deny policies) |
| Service Control Policies | AWS Organizations SCPs | Azure Policy | Organization Policies |
| Deny Policies | Implicit deny only (no explicit deny SCP) | Deny assignments | IAM Deny Policies |
| Cross-Account Access | IAM roles (AssumeRole) | Azure Lighthouse / B2B | Cross-project IAM bindings |
| Temporary Credentials | STS (AssumeRole) | Managed Identity tokens | Workload Identity tokens |

### User Directories

| Feature | AWS IAM Identity Center | Microsoft Entra ID | Google Cloud Identity |
|---------|------------------------|--------------------|-----------------------|
| Previously Named | AWS SSO | Azure Active Directory | G Suite Admin |
| MFA | Built-in or external IdP | Built-in (Authenticator, FIDO2, SMS) | Built-in (Google Authenticator, Titan) |
| SSO Protocols | SAML 2.0, OIDC | SAML 2.0, OIDC, WS-Fed | SAML 2.0, OIDC |
| Conditional Access | N/A (use external IdP) | Conditional Access policies | Context-Aware Access |
| External Identities | External IdP federation | B2B/B2C | External identities |
| Password Policies | Configurable | Configurable (ban lists, smart lockout) | Configurable |
| Licensing | Free (included) | Free / P1 / P2 tiers | Free / Premium |
| Self-Service Password | Via external IdP | Built-in (SSPR) | Built-in |

### Privileged Access Management

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Just-in-Time Access | IAM Access Analyzer + custom | Privileged Identity Management (PIM) | PAM (Privileged Access Manager) |
| Access Reviews | IAM Access Analyzer | Access Reviews (Entra ID P2) | IAM Recommender |
| Unused Permission Detection | Access Analyzer (unused access) | Access Reviews | IAM Recommender |
| Least Privilege Analysis | IAM Access Analyzer | Entra Permissions Management | IAM Recommender |
| Session Policies | STS session policies | Conditional Access (session) | N/A |

---

## Network Security

### Firewall Services

| Feature | AWS Network Firewall | Azure Firewall | Google Cloud Firewall |
|---------|---------------------|----------------|----------------------|
| Type | Managed stateful firewall | Managed stateful firewall | Distributed stateful firewall |
| Layer | L3-L7 | L3-L7 | L3-L4 (L7 with policies) |
| IDS/IPS | Suricata-compatible rules | IDPS (Premium SKU) | IDS (Cloud IDS) |
| Threat Intelligence | Managed threat intel rules | Microsoft threat intel feeds | Google threat intel |
| TLS Inspection | Yes | Yes (Premium) | N/A (use Cloud IDS) |
| FQDN Filtering | Yes | Yes | Yes (Secure Web Proxy) |
| Centralized Management | Firewall Manager | Azure Firewall Manager | Hierarchical policies |
| High Availability | Multi-AZ | Multi-AZ | Global (distributed) |
| Pricing | Per endpoint-hour + per GB | Per firewall-hour + per GB | Per policy + per endpoint |

---

## Data Security and Privacy

### Data Classification and Protection

| Feature | AWS Macie | Microsoft Purview | Google DLP |
|---------|-----------|-------------------|------------|
| Data Discovery | S3 buckets | Multi-cloud + on-prem | Cloud Storage, BigQuery, Datastore |
| PII Detection | ML-based | ML-based (100+ info types) | ML-based (150+ detectors) |
| Custom Classifiers | Yes | Yes (trainable classifiers) | Yes (custom info types) |
| Auto-Remediation | EventBridge + Lambda | Auto-labeling | Cloud Functions |
| Data Catalog | No (use Glue Catalog) | Data Catalog (unified governance) | Data Catalog |
| Pricing | Per S3 bucket + per GB scanned | Per asset + per scan | Per GB inspected |

---

## Compliance and Audit

### Audit Trail Comparison

| Feature | AWS CloudTrail | Azure Activity Log + Monitor | Google Cloud Audit Logs |
|---------|---------------|-------------------------------|--------------------------|
| Management Events | Free (90 days) | Free (90 days) | Free (400 days admin activity) |
| Data Events | Paid | Diagnostic settings (paid) | Paid (data access logs) |
| Multi-Account | Organization trail | Diagnostic settings per sub | Organization-level sinks |
| Immutable Storage | CloudTrail Lake / S3 Object Lock | Immutable blob storage | Locked retention policies |
| Query/Search | CloudTrail Lake (SQL) | Log Analytics (KQL) | Cloud Logging (filter syntax) |
| Real-time Alerts | EventBridge | Azure Monitor Alerts | Cloud Alerting |
| Integrity Validation | Log file validation | N/A | N/A |

---

## Certification Exam Focus Areas

### AWS Security Specialty
- GuardDuty finding types and remediation workflows
- KMS key policies, grants, and encryption context
- IAM permission boundaries and SCPs
- Security Hub standards and custom actions
- Network Firewall rule groups and stateful inspection

### Azure Security Engineer (AZ-500)
- Defender for Cloud secure score and recommendations
- Key Vault access policies vs Azure RBAC
- Entra ID Conditional Access and PIM
- Azure Firewall Premium features
- Microsoft Sentinel SIEM integration

### Google Cloud Security Engineer
- SCC findings and notification workflows
- Cloud KMS key hierarchy and rotation
- VPC Service Controls and access levels
- Organization Policy constraints
- BeyondCorp Enterprise zero trust

---

## Documentation Links

- AWS GuardDuty: https://docs.aws.amazon.com/guardduty/latest/ug/
- AWS Security Hub: https://docs.aws.amazon.com/securityhub/latest/userguide/
- AWS WAF: https://docs.aws.amazon.com/waf/latest/developerguide/
- AWS KMS: https://docs.aws.amazon.com/kms/latest/developerguide/
- AWS Secrets Manager: https://docs.aws.amazon.com/secretsmanager/latest/userguide/
- Microsoft Defender for Cloud: https://learn.microsoft.com/en-us/azure/defender-for-cloud/
- Azure Key Vault: https://learn.microsoft.com/en-us/azure/key-vault/
- Azure WAF: https://learn.microsoft.com/en-us/azure/web-application-firewall/
- Google SCC: https://cloud.google.com/security-command-center/docs
- Google Cloud Armor: https://cloud.google.com/armor/docs
- Google Secret Manager: https://cloud.google.com/secret-manager/docs
- Google Cloud KMS: https://cloud.google.com/kms/docs

---

## Key Takeaways

1. All three providers offer comprehensive threat detection - the key differentiator is integration depth with the native ecosystem
2. Azure Entra ID provides the most mature identity management with Conditional Access and PIM
3. AWS KMS and Google Cloud KMS both support external key stores for compliance requirements
4. Cloud Armor's adaptive protection (ML-based) is unique among the three WAF offerings
5. Secrets management is converging in features - focus on rotation automation and CSI driver integration for exams
6. For multi-cloud security posture management, consider third-party tools like Prisma Cloud, Wiz, or Orca
7. Understanding the audit trail capabilities and retention periods is critical for compliance-focused exam questions
