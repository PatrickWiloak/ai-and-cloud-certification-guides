# Security and Compliance

**[AWS Security Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)** - IAM security recommendations

## AWS IAM

**[AWS IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)** - Identity and Access Management

### IAM Fundamentals

**Users** - individual identities with credentials:
- Console password for AWS Management Console
- Access keys for CLI and API access
- MFA for additional security layer
- Best practice: use IAM Identity Center (SSO) instead of IAM users

**Groups** - collections of users:
- Attach policies to groups, not individual users
- Users inherit group permissions
- No nesting - groups cannot contain other groups

**Roles** - temporary credentials for trusted entities:
- EC2 instances, Lambda functions, other AWS services
- Cross-account access
- Identity federation (SAML, OIDC, web identity)
- Trust policy defines who can assume the role

**[IAM Roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html)** - Temporary security credentials

### IAM Policies

**Policy Types**:
- **Identity-based** - attached to users, groups, or roles
- **Resource-based** - attached to resources (S3 buckets, SQS queues)
- **Permission boundaries** - maximum permissions for IAM entities
- **Service Control Policies (SCPs)** - maximum permissions for accounts in Organizations
- **Session policies** - limit permissions for role session

**Policy Structure**:
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow|Deny",
    "Action": "service:action",
    "Resource": "arn:aws:...",
    "Condition": {}
  }]
}
```

**[IAM Policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html)** - Policy types and structure

### Policy Evaluation Logic
1. All requests are denied by default
2. Explicit allow overrides the default deny
3. Explicit deny always overrides any allow
4. SCPs, permission boundaries, and session policies restrict effective permissions
5. Resource-based policies can grant cross-account access

### IAM Best Practices
- Enable MFA for all users (especially root account)
- Use roles instead of long-term access keys
- Apply least privilege - grant minimum necessary permissions
- Use IAM Access Analyzer to identify unused permissions
- Rotate credentials regularly
- Use policy conditions for additional security (IP, MFA, time)

**[IAM Access Analyzer](https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html)** - Identify unintended access

## AWS Organizations

**[AWS Organizations](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html)** - Multi-account management

### Structure
- **Management account** - root account that creates the organization
- **Organizational Units (OUs)** - logical groupings of accounts
- **Member accounts** - accounts within the organization
- **Root** - top-level container for all accounts and OUs

### Service Control Policies (SCPs)
- Set maximum permissions for accounts in an OU or individual accounts
- Do NOT grant permissions - only restrict them
- Do NOT affect the management account
- Applied hierarchically from root to OUs to accounts
- Must have an explicit allow for actions to be permitted

**Common SCP Patterns**:
- Deny access to specific regions
- Prevent disabling CloudTrail or GuardDuty
- Require encryption on S3 buckets
- Restrict instance types that can be launched

**[SCPs](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html)** - Service Control Policies

### AWS Control Tower

**[AWS Control Tower](https://docs.aws.amazon.com/controltower/latest/userguide/what-is-control-tower.html)** - Multi-account governance

- Automates multi-account setup with landing zone
- Pre-configured guardrails (preventive and detective)
- Account factory for provisioning new accounts
- Dashboard for compliance visibility
- Integrates with Organizations, Config, and CloudTrail

## AWS Config

**[AWS Config](https://docs.aws.amazon.com/config/latest/developerguide/WhatIsConfig.html)** - Configuration compliance

### Core Features
- **Resource inventory** - discover and track all AWS resources
- **Configuration history** - view changes over time
- **Configuration recorder** - records resource configurations
- **Delivery channel** - sends configuration data to S3 and SNS

### Config Rules

**Managed Rules** - pre-built rules by AWS:
- `s3-bucket-server-side-encryption-enabled`
- `ec2-instance-no-public-ip`
- `iam-password-policy`
- `restricted-ssh`
- `rds-instance-public-access-check`

**Custom Rules** - Lambda-backed custom evaluations:
- Trigger: configuration change or periodic
- Lambda function evaluates compliance
- Returns COMPLIANT or NON_COMPLIANT

**[Config Rules](https://docs.aws.amazon.com/config/latest/developerguide/evaluate-config.html)** - Evaluate resource compliance

### Conformance Packs
- Collection of Config rules and remediation actions
- Deploy as a single entity across accounts
- Pre-built packs for frameworks (CIS, NIST, PCI DSS)
- Custom packs for organization-specific requirements

**[Conformance Packs](https://docs.aws.amazon.com/config/latest/developerguide/conformance-packs.html)** - Compliance frameworks

### Auto-Remediation
- Automatically fix non-compliant resources
- Uses SSM Automation documents for remediation
- Configurable retry attempts and rate limiting
- Example: auto-enable S3 encryption when detected as non-compliant

**[Remediation](https://docs.aws.amazon.com/config/latest/developerguide/remediation.html)** - Automatic remediation actions

### Config Aggregator
- Aggregate Config data across accounts and regions
- Organization-wide compliance view
- Requires authorization from source accounts (or use Organizations)

## Security Services

### Amazon GuardDuty

**[Amazon GuardDuty](https://docs.aws.amazon.com/guardduty/latest/ug/what-is-guardduty.html)** - Intelligent threat detection

- Analyzes CloudTrail, VPC Flow Logs, DNS logs, EKS audit logs
- ML-based anomaly detection for threats
- Finding types: reconnaissance, instance compromise, account compromise
- Delegated administrator for multi-account management
- Integration with Security Hub and EventBridge

### Amazon Inspector

**[Amazon Inspector](https://docs.aws.amazon.com/inspector/latest/user/what-is-inspector.html)** - Vulnerability scanning

- Automated vulnerability scanning for EC2, ECR, and Lambda
- Scans for software vulnerabilities (CVEs) and network exposure
- Risk score based on CVSS with environmental adjustments
- Continuous scanning when new CVEs are published
- Integration with Security Hub and EventBridge

### Amazon Macie

**[Amazon Macie](https://docs.aws.amazon.com/macie/latest/user/what-is-macie.html)** - Sensitive data discovery

- ML-powered discovery of sensitive data in S3
- Identifies PII, financial data, credentials
- S3 bucket inventory and security posture assessment
- Custom data identifiers for organization-specific patterns
- Automated findings to Security Hub

### AWS Security Hub

**[AWS Security Hub](https://docs.aws.amazon.com/securityhub/latest/userguide/what-is-securityhub.html)** - Centralized security

- Aggregates findings from GuardDuty, Inspector, Macie, Config, and more
- Security standards compliance checks (CIS, PCI DSS, AWS Foundational)
- Automated response with EventBridge integration
- Cross-account security visibility
- Custom actions for manual and automated workflows

## Data Protection

### AWS KMS

**[AWS KMS](https://docs.aws.amazon.com/kms/latest/developerguide/overview.html)** - Key Management Service

**Key Types**:
- **Customer managed keys** - you create and manage
- **AWS managed keys** - AWS creates for service integration
- **AWS owned keys** - AWS uses internally, not visible

**Key Features**:
- Automatic annual key rotation (for customer managed keys)
- Key policies and IAM policies for access control
- Grants for temporary, fine-grained permissions
- Envelope encryption for large data

**Encryption Integration**:
- EBS volumes - encrypted at rest
- S3 objects - SSE-KMS, SSE-S3, SSE-C
- RDS instances - encrypted at rest
- Lambda environment variables - encrypted with KMS
- Parameter Store SecureString - encrypted with KMS

### AWS Certificate Manager (ACM)

**[AWS ACM](https://docs.aws.amazon.com/acm/latest/userguide/acm-overview.html)** - SSL/TLS certificates

- Provision and manage public and private certificates
- Automatic renewal for ACM-issued certificates
- Integration with ALB, CloudFront, API Gateway
- DNS or email validation for certificate issuance

### AWS Secrets Manager

**[Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html)** - Secret rotation

- Store and rotate database credentials, API keys
- Automatic rotation with Lambda functions
- Built-in rotation for RDS, Redshift, DocumentDB
- Cross-region replication for DR
- Fine-grained access with IAM policies

## Network Security

### VPC Security

**Security Groups** (stateful):
- Allow rules only (no deny rules)
- Return traffic automatically allowed
- Applied at instance/ENI level
- Reference other security groups

**Network ACLs** (stateless):
- Allow and deny rules
- Return traffic must be explicitly allowed
- Applied at subnet level
- Rules evaluated in order (lowest number first)

**[VPC Security](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-best-practices.html)** - Network security best practices

### AWS WAF

**[AWS WAF](https://docs.aws.amazon.com/waf/latest/developerguide/waf-chapter.html)** - Web Application Firewall

- Protect against common web exploits (SQL injection, XSS)
- Custom rules and managed rule groups
- Rate-based rules for DDoS mitigation
- Integration with CloudFront, ALB, API Gateway, AppSync

### AWS Shield

- **Shield Standard** - free, automatic DDoS protection
- **Shield Advanced** - enhanced DDoS protection with 24/7 support
- Cost protection for DDoS-related scaling

### VPC Flow Logs

**[VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html)** - Network traffic logging

- Capture IP traffic information at VPC, subnet, or ENI level
- Publish to CloudWatch Logs, S3, or Kinesis Data Firehose
- Use for troubleshooting, security analysis, and compliance
- Flow log record includes source/destination IP, ports, protocol, action

## Key Takeaways

1. **IAM** - understand policy evaluation logic, especially deny overrides allow
2. **SCPs** - restrict maximum permissions for accounts, do not grant permissions
3. **Config** - continuous compliance monitoring with auto-remediation
4. **GuardDuty** - threat detection using ML on CloudTrail, VPC Flow Logs, DNS logs
5. **Security Hub** - aggregates findings from all security services
6. **KMS** - know key types and encryption integration with AWS services
7. **WAF** - web application protection at CloudFront, ALB, and API Gateway
8. **Organizations** - multi-account management with SCPs and Control Tower
