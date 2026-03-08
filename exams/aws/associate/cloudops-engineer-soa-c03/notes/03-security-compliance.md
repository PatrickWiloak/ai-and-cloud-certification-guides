# Domain 3: Security and Compliance (18%)

## 📋 Overview

This domain covers identity and access management, data protection, multi-account governance, and security monitoring. The SOA-C03 exam places increased emphasis on AWS Organizations, Control Tower, and centralized security services compared to its predecessor.

## 🎯 Key Services and Concepts

### AWS Identity and Access Management (IAM)

**📖 [AWS IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)** - Identity and Access Management

#### IAM Fundamentals

- **Users**: Individual identities with long-term credentials
- **Groups**: Collections of users for simplified permission management
- **Roles**: Temporary credentials for services, applications, or cross-account access
- **Policies**: JSON documents defining permissions (Allow/Deny, Actions, Resources, Conditions)

#### Policy Types

| Policy Type | Scope | Use Case |
|-------------|-------|----------|
| **Identity-Based** | Attached to user, group, or role | Standard permissions |
| **Resource-Based** | Attached to a resource (S3, SQS, KMS) | Cross-account access |
| **Permission Boundary** | Maximum permissions for an entity | Delegate admin safely |
| **Service Control Policy** | Organization OU or account | Guardrails across accounts |
| **Session Policy** | Passed during role assumption | Restrict session permissions |

#### Policy Evaluation Logic

1. All requests are denied by default
2. Evaluate all applicable policies
3. **Explicit Deny always wins** over any Allow
4. SCPs restrict what identity-based policies can grant
5. Permission boundaries limit maximum permissions

**📖 [IAM Policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html)** - Access control
**📖 [IAM Roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html)** - Temporary credentials
**📖 [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)** - Security recommendations

#### IAM Best Practices for Operations

- Enable MFA for all human users (especially root account)
- Use IAM roles for EC2 instances, Lambda functions, and ECS tasks
- Implement least privilege; start restrictive and add permissions as needed
- Rotate access keys regularly; prefer roles over long-term access keys
- Use IAM Access Analyzer to identify unused permissions and external access
- Enable credential reports for auditing

**📖 [IAM Access Analyzer](https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html)** - Access analysis

---

### AWS Organizations

**📖 [AWS Organizations](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html)** - Multi-account management

#### Core Concepts

- **Management Account**: Root account that creates the organization (formerly master account)
- **Member Accounts**: Accounts invited to or created within the organization
- **Organizational Units (OUs)**: Hierarchical grouping of accounts
- **Service Control Policies (SCPs)**: Permission guardrails applied to OUs or accounts

#### Service Control Policies (SCPs)

- SCPs define the **maximum available permissions** for member accounts
- SCPs do NOT grant permissions; they restrict what identity policies can allow
- SCPs do not affect the management account
- SCPs apply to all users and roles in affected accounts (including root)
- Commonly used to:
  - Restrict regions where resources can be created
  - Prevent disabling CloudTrail or GuardDuty
  - Enforce encryption requirements
  - Block specific services

**📖 [Service Control Policies](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html)** - Organization policies

#### Consolidated Billing

- Single payment method for all member accounts
- Volume discounts applied across the organization
- Reserved Instance sharing across accounts

> **Exam Tip:** SCPs affect ALL principals in a member account (users, roles, root) except service-linked roles. They do NOT affect the management account.

---

### AWS Control Tower

**📖 [AWS Control Tower](https://docs.aws.amazon.com/controltower/latest/userguide/what-is-control-tower.html)** - Multi-account governance

#### Core Features

- **Landing Zone**: Pre-configured multi-account environment following best practices
- **Account Factory**: Automated provisioning of new accounts with standardized configurations
- **Guardrails (Controls)**:
  - **Preventive**: SCPs that prevent non-compliant actions
  - **Detective**: AWS Config rules that detect non-compliant resources
  - **Proactive**: CloudFormation hooks that check resources before deployment
- **Dashboard**: Centralized view of compliance status across all accounts

**📖 [Control Tower Guardrails](https://docs.aws.amazon.com/controltower/latest/userguide/controls.html)** - Governance controls

---

### Data Protection and Encryption

#### AWS KMS (Key Management Service)

**📖 [AWS KMS](https://docs.aws.amazon.com/kms/latest/developerguide/overview.html)** - Key management

- **Customer Managed Keys (CMK)**: Keys you create and manage (rotation, policies, aliases)
- **AWS Managed Keys**: Keys created by AWS services on your behalf
- **Key Policies**: Resource-based policies that control access to KMS keys
- **Key Rotation**: Automatic annual rotation for customer managed keys
- **Grants**: Temporary, granular access to KMS keys
- **Envelope Encryption**: Use data key to encrypt data, use KMS key to encrypt data key

#### Encryption at Rest

| Service | Encryption Method |
|---------|------------------|
| **S3** | SSE-S3, SSE-KMS, SSE-C, client-side |
| **EBS** | AES-256, KMS-managed keys |
| **RDS** | KMS encryption, TDE (Oracle, SQL Server) |
| **DynamoDB** | AWS owned keys or customer managed KMS keys |
| **EFS** | KMS encryption |

**📖 [EBS Encryption](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSEncryption.html)** - Volume encryption
**📖 [S3 Encryption](https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingEncryption.html)** - Object encryption

#### Encryption in Transit

- TLS/SSL for all AWS API calls
- AWS Certificate Manager (ACM) for managing SSL/TLS certificates
- ACM certificates for use with CloudFront, ELB, and API Gateway
- VPN encryption for Site-to-Site connections

**📖 [ACM](https://docs.aws.amazon.com/acm/latest/userguide/acm-overview.html)** - SSL/TLS certificates

---

### AWS Config for Compliance

**📖 [AWS Config](https://docs.aws.amazon.com/config/latest/developerguide/WhatIsConfig.html)** - Configuration compliance

#### Common Config Rules for Operations

| Rule | What It Checks |
|------|----------------|
| `ec2-instance-managed-by-ssm` | EC2 instances managed by Systems Manager |
| `encrypted-volumes` | EBS volumes are encrypted |
| `s3-bucket-server-side-encryption-enabled` | S3 buckets have encryption enabled |
| `cloudtrail-enabled` | CloudTrail is enabled |
| `restricted-ssh` | SSH access restricted from 0.0.0.0/0 |
| `rds-instance-public-access-check` | RDS instances not publicly accessible |
| `iam-root-access-key-check` | Root account has no access keys |
| `mfa-enabled-for-iam-console-access` | MFA enabled for console access |

#### Remediation

- **Automatic Remediation**: Trigger SSM Automation documents when non-compliant
- **Manual Remediation**: Notify operators via SNS for manual action
- **Remediation Retries**: Configure retry attempts for failed remediation

**📖 [Config Rules](https://docs.aws.amazon.com/config/latest/developerguide/evaluate-config.html)** - Compliance checks
**📖 [Remediation](https://docs.aws.amazon.com/config/latest/developerguide/remediation.html)** - Auto-remediation

---

### Security Monitoring Services

#### Amazon GuardDuty

**📖 [Amazon GuardDuty](https://docs.aws.amazon.com/guardduty/latest/ug/what-is-guardduty.html)** - Intelligent threat detection

- Analyzes CloudTrail events, VPC Flow Logs, and DNS logs
- Machine learning-based anomaly detection
- Finding types: reconnaissance, instance compromise, account compromise
- Integration with Security Hub and EventBridge for automated response
- Supports multi-account via AWS Organizations delegated administrator

#### AWS Security Hub

**📖 [AWS Security Hub](https://docs.aws.amazon.com/securityhub/latest/userguide/what-is-securityhub.html)** - Centralized security findings

- Aggregates findings from GuardDuty, Inspector, Config, Macie, and more
- Security standards: AWS Foundational Security Best Practices, CIS Benchmarks, PCI DSS
- Automated checks against security controls
- Cross-account aggregation via Organizations
- Integration with EventBridge for automated remediation

#### Amazon Inspector

**📖 [Amazon Inspector](https://docs.aws.amazon.com/inspector/latest/user/what-is-inspector.html)** - Vulnerability scanning

- Automated vulnerability scanning for EC2 instances, container images (ECR), and Lambda functions
- Uses CVE database for known vulnerability detection
- Network reachability analysis
- Integration with Security Hub for centralized findings

---

### Network Security

#### Security Groups vs Network ACLs

| Feature | Security Groups | Network ACLs |
|---------|----------------|--------------|
| Level | Instance (ENI) | Subnet |
| State | Stateful | Stateless |
| Rules | Allow only | Allow and Deny |
| Evaluation | All rules evaluated | Rules evaluated in order |
| Default | Deny all inbound, allow all outbound | Allow all inbound and outbound |

**📖 [Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html)** - Instance firewalls
**📖 [Network ACLs](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html)** - Subnet firewalls

#### AWS WAF (Web Application Firewall)

**📖 [AWS WAF](https://docs.aws.amazon.com/waf/latest/developerguide/waf-chapter.html)** - Web application firewall

- Protects CloudFront, ALB, API Gateway, and AppSync
- Rule types: IP match, geo match, string match, SQL injection, XSS
- AWS Managed Rule Groups for common threats (OWASP Top 10)
- Rate-based rules for DDoS and bot mitigation

#### AWS Shield

- **Shield Standard**: Free, automatic DDoS protection for all AWS resources
- **Shield Advanced**: Enhanced DDoS protection with 24/7 DDoS Response Team, cost protection

---

## 📚 Key Exam Scenarios

1. **Restrict resource creation to specific regions** - Apply SCP at OU level denying all actions in non-approved regions
2. **Ensure all EBS volumes are encrypted** - AWS Config rule `encrypted-volumes` with automatic remediation
3. **Detect compromised EC2 instance** - GuardDuty finding triggers EventBridge rule to isolate instance (modify security group)
4. **Centralize security findings across accounts** - Enable Security Hub with Organizations delegated administrator
5. **Delegate account provisioning with guardrails** - Use Control Tower Account Factory with preventive and detective guardrails
6. **Secure cross-account access** - Create IAM role in target account with trust policy; assume role from source account
