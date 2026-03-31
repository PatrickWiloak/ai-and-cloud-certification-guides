# Service Comparison - Identity and IAM

## Overview

This guide provides a deep comparison of identity and access management services across AWS, Azure, and Google Cloud - covering IAM models, user directories, single sign-on, RBAC, federation, and privileged access management. IAM is foundational to every cloud certification exam.

---

## IAM Architecture Models

### Fundamental Approach

| Aspect | AWS IAM | Azure RBAC + Entra ID | Google Cloud IAM |
|--------|---------|------------------------|-------------------|
| Philosophy | Identity-based + resource-based policies | Role-based access at scope levels | Resource-based policy bindings |
| Policy Language | JSON (IAM policy language) | Built-in/custom role definitions | YAML/JSON (IAM bindings) |
| Policy Attachment | Attach to users, groups, roles | Assign roles at scope (MG, sub, RG, resource) | Bind to resource hierarchy (org, folder, project, resource) |
| Evaluation Logic | Default deny, explicit allow, explicit deny overrides | Union of role assignments | Union of allow bindings, deny policies override |
| Inheritance | No inheritance (each principal independent) | Inherited down scope hierarchy | Inherited down resource hierarchy |
| Max Custom Policies | 5,000 customer-managed policies | 5,000 custom roles per tenant | 300 custom roles per organization |

### Identity Types

| Identity Type | AWS | Azure | GCP |
|--------------|-----|-------|-----|
| Human Users | IAM users (local) or federated | Entra ID users (cloud or synced) | Google Workspace / Cloud Identity users |
| Groups | IAM groups | Entra ID groups (security, M365) | Google Groups |
| Service Identity | IAM roles (for services) | Service principals / Managed Identities | Service accounts |
| Machine Identity | IAM roles (EC2, Lambda, ECS) | Managed Identity (System/User-assigned) | Service accounts (attached to resources) |
| External Identity | SAML/OIDC federation | B2B (guest), B2C (customer) | Workforce Identity Federation |
| Workload Identity | IRSA, EKS Pod Identity | Workload Identity (AKS + Entra) | Workload Identity Federation |

---

## Policy and Role Models

### AWS IAM Policy Structure

| Component | Description | Example |
|-----------|-------------|---------|
| Effect | Allow or Deny | `"Effect": "Allow"` |
| Action | API actions | `"Action": "s3:GetObject"` |
| Resource | ARN of target resource | `"Resource": "arn:aws:s3:::my-bucket/*"` |
| Condition | Context-based restrictions | `"Condition": {"IpAddress": {"aws:SourceIp": "10.0.0.0/8"}}` |
| Principal | Who the policy applies to (resource-based only) | `"Principal": {"AWS": "arn:aws:iam::123456789012:root"}` |

### Azure RBAC Model

| Component | Description | Example |
|-----------|-------------|---------|
| Security Principal | User, group, service principal, managed identity | User: john@contoso.com |
| Role Definition | Collection of permissions | Contributor, Reader, custom |
| Scope | Level where access applies | /subscriptions/{id}/resourceGroups/{name} |
| Role Assignment | Binding of principal + role + scope | John is Contributor on RG-Production |
| Deny Assignment | Explicit deny (limited to Blueprints) | Block delete on resource group |

### Google Cloud IAM Model

| Component | Description | Example |
|-----------|-------------|---------|
| Member | User, group, service account, domain | user:john@example.com |
| Role | Collection of permissions | roles/storage.objectViewer |
| Binding | Member + role on a resource | john@example.com has objectViewer on bucket |
| Condition | CEL expression for conditional access | `request.time < timestamp("2025-01-01")` |
| Deny Policy | Explicit deny rules | Deny storage.objects.delete for all except admins |

---

## Built-in Roles Comparison

### Common Administrative Roles

| Function | AWS | Azure | GCP |
|----------|-----|-------|-----|
| Full Admin | AdministratorAccess | Owner | roles/owner |
| Billing Admin | Billing (policy-based) | Billing Reader / Cost Management | roles/billing.admin |
| Read-Only | ReadOnlyAccess | Reader | roles/viewer |
| Network Admin | Custom (VPC policies) | Network Contributor | roles/compute.networkAdmin |
| Security Admin | SecurityAudit | Security Admin | roles/iam.securityAdmin |
| Database Admin | Custom (RDS/DynamoDB policies) | SQL DB Contributor | roles/cloudsql.admin |
| Kubernetes Admin | Custom (EKS policies) | Azure Kubernetes Service Cluster Admin | roles/container.clusterAdmin |

### Permission Granularity

| Aspect | AWS | Azure | GCP |
|--------|-----|-------|-----|
| Total Permissions | 17,000+ actions | 10,000+ operations | 12,000+ permissions |
| Wildcard Support | Yes (Action: "s3:*") | Implicit in role | No wildcards in role |
| Custom Roles | Custom policies (JSON) | Custom roles (JSON) | Custom roles (YAML) |
| Permission Boundary | Yes (IAM permission boundaries) | N/A | N/A |
| Deny Policies | Only in resource-based + SCP | Deny assignments (limited) | IAM Deny Policies |

---

## User Directories and Identity Providers

### AWS IAM Identity Center vs Entra ID vs Cloud Identity

| Feature | AWS IAM Identity Center | Microsoft Entra ID | Google Cloud Identity |
|---------|------------------------|--------------------|-----------------------|
| Previously Known As | AWS SSO | Azure Active Directory (Azure AD) | G Suite Admin / Google Admin |
| User Store | Built-in or external IdP | Cloud-native + on-prem sync | Cloud-native + LDAP sync |
| Max Users | 100,000 (built-in directory) | Unlimited | Unlimited |
| On-Prem Sync | AD Connector | Entra Connect (hash sync, pass-through, federation) | Google Cloud Directory Sync (GCDS) |
| MFA | Built-in (TOTP, FIDO2) or external | Built-in (Authenticator, FIDO2, SMS, voice) | Built-in (Titan key, TOTP, push) |
| Conditional Access | N/A (use external IdP) | Conditional Access policies (P1/P2) | Context-Aware Access (BeyondCorp) |
| Password Policies | External IdP dependent | Custom (banned lists, smart lockout, SSPR) | Custom policies |
| License Tiers | Free (included) | Free, P1, P2 | Free, Premium |
| B2B/B2C | N/A | B2B (guest), B2C (customer identity) | N/A |
| Lifecycle Management | SCIM provisioning | Lifecycle workflows (P2 Governance) | Automated provisioning |

### Multi-Factor Authentication Comparison

| MFA Method | AWS | Azure | GCP |
|------------|-----|-------|-----|
| TOTP Apps | Yes | Yes (Authenticator) | Yes |
| Push Notification | N/A (external IdP) | Yes (Authenticator) | Yes (Google prompt) |
| FIDO2/WebAuthn | Yes (IAM Identity Center) | Yes | Yes (Titan Security Key) |
| SMS | N/A | Yes (not recommended) | N/A |
| Hardware Token | Yes (Gemalto) | Yes (OATH tokens) | Yes (Titan key) |
| Phishing-Resistant | FIDO2 support | FIDO2 + certificate-based | Titan key + passkeys |

---

## Single Sign-On (SSO)

### SSO Federation

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| SSO Service | IAM Identity Center | Entra ID (Enterprise Apps) | Cloud Identity (SAML apps) |
| Supported Protocols | SAML 2.0, OIDC | SAML 2.0, OIDC, WS-Fed | SAML 2.0, OIDC |
| Pre-integrated Apps | AWS accounts + SAML apps | 5,000+ gallery apps | 700+ pre-integrated apps |
| Custom SAML | Yes | Yes | Yes |
| SCIM Provisioning | Yes | Yes (auto-provisioning) | Yes |
| SSO Portal | AWS access portal | My Apps portal (myapps.microsoft.com) | Google Workspace app launcher |
| Cross-Cloud SSO | SAML/OIDC to Azure/GCP | SAML/OIDC to AWS/GCP | SAML/OIDC to AWS/Azure |

### Workforce Identity Federation

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Service | IAM Identity Center + SAML/OIDC | Entra ID federation | Workforce Identity Federation |
| External IdPs | Okta, Ping, OneLogin, Entra ID | AD FS, PingFederate, Okta | Okta, Azure AD, AD FS |
| Token Exchange | STS AssumeRoleWithSAML/WebIdentity | Entra ID token | STS token exchange |
| Session Duration | 1-12 hours | Configurable (token lifetime) | 1-12 hours |
| Attribute Mapping | SAML attribute to IAM session tags | Claims mapping | Attribute mapping |

---

## Workload Identity

### Service-to-Service Authentication

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Service Identity | IAM roles | Managed Identity | Service accounts |
| Auto-Credential | Instance profile / IRSA / Pod Identity | System-assigned managed identity | Metadata server / Workload Identity |
| Cross-Service Auth | IAM role assumption | Managed identity token | Service account impersonation |
| Cross-Cloud | OIDC federation | Workload identity federation | Workload Identity Federation |
| Kubernetes | IRSA / EKS Pod Identity | AKS Workload Identity (Entra) | GKE Workload Identity |
| Serverless | Execution role (Lambda) | System identity (Functions) | Service account (Cloud Functions) |

### Cross-Cloud Workload Identity

| Scenario | Implementation |
|----------|---------------|
| AWS to GCP | AWS IAM OIDC provider -> GCP Workload Identity Pool -> GCP service account |
| GCP to AWS | GCP service account -> AWS OIDC federation -> AWS IAM role |
| Azure to AWS | Managed Identity -> AWS OIDC federation -> AWS IAM role |
| AWS to Azure | IAM role -> Azure Workload Identity Federation -> Service principal |
| GitHub to any cloud | GitHub OIDC -> cloud provider federation -> cloud role/identity |

---

## Organization-Level Controls

### Service Control Policies / Organization Policies

| Feature | AWS SCPs | Azure Policy | GCP Organization Policies |
|---------|---------|--------------|---------------------------|
| Scope | Organization, OU, Account | Management group, subscription, resource group | Organization, folder, project |
| Effect | Restrict permissions (deny list or allow list) | Audit, deny, deploy, modify | Allow, deny constraints |
| Inheritance | Inherited down OU tree | Inherited down scope hierarchy | Inherited down resource hierarchy |
| Exemptions | N/A (move to different OU) | Exemptions per scope | N/A (override at lower level) |
| Custom Policies | JSON (IAM policy syntax) | JSON (policy rule) | Custom constraints (CEL) |
| Built-in | N/A (create custom) | 1,000+ built-in definitions | 80+ built-in constraints |
| Compliance | SCPs + Config Rules | Policy compliance dashboard | Organization Policy compliance |

### Guardrails Comparison

| Guardrail Type | AWS | Azure | GCP |
|----------------|-----|-------|-----|
| Preventive | SCPs, IAM permission boundaries | Azure Policy (deny effect) | Organization policies (deny) |
| Detective | Config Rules, Security Hub | Azure Policy (audit), Defender | SCC, Policy Analyzer |
| Proactive | CloudFormation Guard | Azure Policy (deployIfNotExists) | Assured Workloads |
| Tag Enforcement | SCP + Config Rules | Azure Policy (tag rules) | Organization policies + labels |
| Region Restriction | SCP (deny regions) | Azure Policy (allowed locations) | Organization policy (resource locations) |

---

## Privileged Access and Governance

### Just-in-Time Access

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Service | Custom (STS + Lambda) | Privileged Identity Management (PIM) | Privileged Access Manager (PAM) |
| Activation | N/A (custom workflow) | Time-limited role activation | Time-limited role grant |
| Approval Workflow | Custom (Step Functions) | Built-in approval (PIM) | Built-in approval |
| Max Duration | STS session (1-12 hours) | Configurable (hours) | Configurable (hours) |
| Audit Trail | CloudTrail | Entra ID audit logs | Cloud Audit Logs |
| License Required | N/A | Entra ID P2 | Included |

### Access Reviews and Recommendations

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Unused Access Detection | IAM Access Analyzer | Entra Access Reviews | IAM Recommender |
| Permission Right-Sizing | Access Analyzer (unused access findings) | Entra Permissions Management | IAM Recommender (role recommendations) |
| Access Certification | Custom workflow | Access Reviews (quarterly/annual) | Custom workflow |
| External Access Analysis | Access Analyzer (external access) | Entra Permissions Management | Policy Analyzer |
| Cross-Cloud Visibility | N/A | Entra Permissions Management (AWS, GCP) | N/A |

---

## Emergency Access and Break-Glass

| Aspect | AWS | Azure | GCP |
|--------|-----|-------|-----|
| Break-Glass Account | Root account (secured with MFA) | Emergency access accounts (Entra) | Super admin (Cloud Identity) |
| Best Practice | Secure root with hardware MFA, do not use daily | 2+ emergency accounts, monitor sign-ins | Secure super admin, delegate to roles |
| Monitoring | CloudTrail root login alerts | Sign-in log alerts | Admin audit log alerts |
| Recovery | Root email + MFA | Emergency accounts + Conditional Access exclusion | Recovery email/phone |

---

## Certification Exam Focus Areas

### AWS Security Specialty / Solutions Architect
- IAM policy evaluation logic (explicit deny > allow > implicit deny)
- Cross-account access patterns (AssumeRole, resource-based policies)
- SCP inheritance and evaluation with IAM policies
- Permission boundaries vs SCPs vs resource-based policies
- IRSA vs EKS Pod Identity for Kubernetes workloads
- IAM Access Analyzer findings and remediation

### Azure Security Engineer (AZ-500) / Identity (SC-300)
- Entra ID Conditional Access policy design
- PIM activation workflows and role settings
- RBAC scope hierarchy and role assignment inheritance
- Managed Identity types and use cases
- B2B/B2C identity scenarios
- Entra Permissions Management cross-cloud

### Google Cloud Security Engineer
- IAM policy binding inheritance across resource hierarchy
- Workload Identity Federation configuration
- Organization Policy constraints and custom constraints
- Service account best practices and impersonation
- VPC Service Controls and access levels
- IAM Deny Policies evaluation order

---

## Documentation Links

- AWS IAM: https://docs.aws.amazon.com/IAM/latest/UserGuide/
- AWS IAM Identity Center: https://docs.aws.amazon.com/singlesignon/latest/userguide/
- AWS IAM Access Analyzer: https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html
- Microsoft Entra ID: https://learn.microsoft.com/en-us/entra/identity/
- Azure RBAC: https://learn.microsoft.com/en-us/azure/role-based-access-control/
- Azure PIM: https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/
- Google Cloud IAM: https://cloud.google.com/iam/docs
- Google Workforce Identity Federation: https://cloud.google.com/iam/docs/workforce-identity-federation
- Google Workload Identity Federation: https://cloud.google.com/iam/docs/workload-identity-federation

---

## Key Takeaways

1. **Azure Entra ID** provides the most comprehensive identity platform with Conditional Access, PIM, and B2B/B2C
2. **AWS IAM** has the most granular policy language but requires combining multiple mechanisms (SCPs, permission boundaries, resource policies)
3. **Google Cloud IAM** has the cleanest resource hierarchy inheritance model
4. **Workload Identity Federation** is converging across all providers - eliminating long-lived credentials
5. All three providers support **FIDO2/passkeys** for phishing-resistant MFA
6. **Cross-cloud identity** is best handled through OIDC federation rather than syncing credentials
7. Understanding policy evaluation logic is critical for security certification exams on all platforms
8. **Entra Permissions Management** (formerly CloudKnox) is unique in providing cross-cloud permission visibility
