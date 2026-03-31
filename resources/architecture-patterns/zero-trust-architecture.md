# Zero Trust Architecture

A comprehensive guide to implementing zero trust security models across AWS, Azure, and Google Cloud Platform.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Architecture Diagram Description](#architecture-diagram-description)
3. [Component Breakdown](#component-breakdown)
4. [AWS Implementation](#aws-implementation)
5. [Azure Implementation](#azure-implementation)
6. [GCP Implementation](#gcp-implementation)
7. [Design Considerations](#design-considerations)
8. [Network Security vs Identity Security](#network-security-vs-identity-security)
9. [Continuous Verification Patterns](#continuous-verification-patterns)
10. [Cost Estimation](#cost-estimation)
11. [Production Checklist](#production-checklist)

---

## Architecture Overview

### What is Zero Trust Architecture?

Zero trust is a security model based on the principle of "never trust, always verify":
- **No Implicit Trust**: Every request is authenticated and authorized regardless of origin
- **Least Privilege Access**: Users and services get the minimum permissions required
- **Microsegmentation**: Network is divided into small zones to limit lateral movement
- **Continuous Verification**: Trust is continuously re-evaluated, not granted once
- **Assume Breach**: Design systems assuming the network is already compromised
- **Identity-Centric**: Identity replaces network perimeter as the primary security boundary

### Core Principles

1. **Verify Explicitly**: Always authenticate and authorize based on all available data points (identity, location, device health, service, workload, data classification)
2. **Use Least Privilege Access**: Limit user access with just-in-time and just-enough-access (JIT/JEA), risk-based adaptive policies, and data protection
3. **Assume Breach**: Minimize blast radius and segment access, verify end-to-end encryption, use analytics for visibility and threat detection

### Benefits

- **Reduced Attack Surface**: Microsegmentation limits lateral movement
- **Improved Visibility**: All access attempts are logged and monitored
- **Data Protection**: Classification-aware access controls
- **Compliance**: Granular audit trails for regulatory requirements
- **Remote Work Support**: Secure access regardless of user location
- **Cloud-Native Security**: Designed for distributed, multi-cloud environments

### Trade-offs

- **Complexity**: Significant architectural and operational overhead
- **User Experience**: Additional authentication steps can impact productivity
- **Legacy Systems**: Older applications may not support modern identity protocols
- **Cost**: Identity providers, policy engines, and monitoring add cost
- **Migration Effort**: Transitioning from perimeter-based security is gradual

### Use Cases

- Enterprise environments with remote and hybrid workforces
- Multi-cloud and hybrid cloud deployments
- Regulated industries (finance, healthcare, government)
- Organizations with contractor and third-party access
- Applications handling sensitive data (PII, financial, health records)

---

## Architecture Diagram Description

### High-Level Architecture

```
[User/Device] --> [Identity Provider] --> [Policy Engine]
                                              |
                                     [Policy Decision Point]
                                              |
                           +------------------+------------------+
                           |                  |                  |
                    [API Gateway]     [Application Proxy]  [VPN/ZTNA]
                           |                  |                  |
                    [Microservice A]  [Internal App]     [Legacy App]
                           |                  |                  |
                    [Data Store]      [Data Store]       [Data Store]
```

### Request Flow

1. User or device initiates a request
2. Identity provider authenticates the user (MFA, device posture check)
3. Policy engine evaluates context (identity, device, location, risk score)
4. Policy decision point grants or denies access
5. Traffic is routed through an enforcement point (proxy, gateway, service mesh)
6. All access is logged for monitoring and analytics
7. Continuous monitoring re-evaluates trust throughout the session

---

## Component Breakdown

### Identity and Access Management

| Component | Purpose | Key Features |
|-----------|---------|--------------|
| **Identity Provider** | Authenticate users and devices | SSO, MFA, federation |
| **Policy Engine** | Evaluate access policies | Context-aware, risk-based |
| **Directory Service** | Store identity information | User attributes, group membership |
| **Certificate Authority** | Issue and manage certificates | mTLS, device certificates |

### Network Security

| Component | Purpose | Key Features |
|-----------|---------|--------------|
| **Microsegmentation** | Isolate workloads | Per-workload firewall rules |
| **Service Mesh** | Secure service-to-service traffic | mTLS, authorization policies |
| **Private Connectivity** | Eliminate public internet exposure | Private endpoints, private links |
| **DNS Security** | Prevent DNS-based attacks | DNS filtering, DNSSEC |

### Monitoring and Analytics

| Component | Purpose | Key Features |
|-----------|---------|--------------|
| **SIEM** | Security event correlation | Real-time alerting, threat detection |
| **UEBA** | User behavior analytics | Anomaly detection, risk scoring |
| **Audit Logging** | Record all access events | Immutable logs, compliance reporting |
| **Threat Intelligence** | Enrich security context | IP reputation, known threats |

---

## AWS Implementation

### Identity Layer

| Component | AWS Service | Purpose |
|-----------|------------|---------|
| **Identity Provider** | AWS IAM Identity Center | Centralized SSO and access management |
| **User Authentication** | Amazon Cognito | User pools, federation, MFA |
| **Service Identity** | IAM Roles | Temporary credentials for services |
| **Policy Evaluation** | IAM Policies + SCPs | Fine-grained access control |
| **Device Trust** | AWS Verified Access | Device posture evaluation |

### Network Layer

| Component | AWS Service | Purpose |
|-----------|------------|---------|
| **Microsegmentation** | Security Groups + NACLs | Per-instance firewall rules |
| **Private Connectivity** | AWS PrivateLink | Private access to services |
| **Application Proxy** | AWS Verified Access | Identity-aware application proxy |
| **Service Mesh** | AWS App Mesh | mTLS between services |
| **DNS Security** | Route 53 Resolver DNS Firewall | DNS-level filtering |
| **WAF** | AWS WAF | Application layer protection |

### Monitoring Layer

| Component | AWS Service | Purpose |
|-----------|------------|---------|
| **Threat Detection** | Amazon GuardDuty | Intelligent threat detection |
| **Security Hub** | AWS Security Hub | Centralized security findings |
| **Audit Logging** | AWS CloudTrail | API call logging |
| **Network Monitoring** | VPC Flow Logs | Network traffic analysis |
| **Config Compliance** | AWS Config | Resource configuration auditing |

**Documentation:**
- [AWS IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html)
- [AWS Verified Access](https://docs.aws.amazon.com/verified-access/latest/ug/what-is-verified-access.html)
- [AWS PrivateLink](https://docs.aws.amazon.com/vpc/latest/privatelink/what-is-privatelink.html)
- [Amazon GuardDuty](https://docs.aws.amazon.com/guardduty/latest/ug/what-is-guardduty.html)

---

## Azure Implementation

### Identity Layer

| Component | Azure Service | Purpose |
|-----------|--------------|---------|
| **Identity Provider** | Microsoft Entra ID | Enterprise identity and access |
| **Conditional Access** | Entra Conditional Access | Context-aware access policies |
| **MFA** | Entra MFA | Multi-factor authentication |
| **PIM** | Privileged Identity Management | Just-in-time privileged access |
| **App Proxy** | Entra Application Proxy | Secure access to on-premises apps |

### Network Layer

| Component | Azure Service | Purpose |
|-----------|--------------|---------|
| **Microsegmentation** | NSGs + ASGs | Network-level segmentation |
| **Private Connectivity** | Azure Private Link | Private access to PaaS services |
| **ZTNA** | Entra Global Secure Access | Zero trust network access |
| **Firewall** | Azure Firewall Premium | Network and application filtering |
| **WAF** | Azure WAF on Application Gateway | Web application protection |

### Monitoring Layer

| Component | Azure Service | Purpose |
|-----------|--------------|---------|
| **SIEM** | Microsoft Sentinel | Cloud-native SIEM/SOAR |
| **Threat Detection** | Microsoft Defender for Cloud | Threat protection |
| **Audit Logging** | Azure Activity Log + Entra Audit | Comprehensive audit trail |
| **Identity Analytics** | Identity Protection | Risk-based user sign-in policies |

**Documentation:**
- [Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/fundamentals/whatis)
- [Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview)
- [Azure Private Link](https://learn.microsoft.com/en-us/azure/private-link/private-link-overview)
- [Microsoft Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/overview)

---

## GCP Implementation

### Identity Layer

| Component | GCP Service | Purpose |
|-----------|------------|---------|
| **Identity Provider** | Cloud Identity / Google Workspace | User and group management |
| **Application Access** | Identity-Aware Proxy (IAP) | Context-aware application access |
| **Service Identity** | Service Accounts + Workload Identity | Workload authentication |
| **Access Management** | Cloud IAM | Fine-grained resource access |
| **BeyondCorp** | BeyondCorp Enterprise | Full zero trust platform |

### Network Layer

| Component | GCP Service | Purpose |
|-----------|------------|---------|
| **Microsegmentation** | VPC Firewall Rules + Firewall Policies | Hierarchical firewall rules |
| **Private Connectivity** | VPC Service Controls | API-level security perimeter |
| **Service Mesh** | Cloud Service Mesh (Istio) | mTLS and authorization |
| **Private Access** | Private Google Access + Private Service Connect | Private service connectivity |
| **WAF** | Cloud Armor | DDoS and application protection |

### Monitoring Layer

| Component | GCP Service | Purpose |
|-----------|------------|---------|
| **Threat Detection** | Security Command Center | Security findings and analytics |
| **Audit Logging** | Cloud Audit Logs | API and data access logging |
| **Network Intelligence** | Network Intelligence Center | Network monitoring and diagnostics |
| **Policy Analytics** | Policy Analyzer | IAM policy insights |

**Documentation:**
- [BeyondCorp Enterprise](https://cloud.google.com/beyondcorp-enterprise/docs/overview)
- [Identity-Aware Proxy](https://cloud.google.com/iap/docs/concepts-overview)
- [VPC Service Controls](https://cloud.google.com/vpc-service-controls/docs/overview)
- [Security Command Center](https://cloud.google.com/security-command-center/docs/concepts-security-command-center-overview)

---

## Design Considerations

### Identity-Centric Design

- **Use strong authentication**: Enforce MFA for all users, preferably phishing-resistant methods (FIDO2, passkeys)
- **Implement SSO**: Centralize authentication through a single identity provider
- **Short-lived credentials**: Use temporary tokens and certificates instead of long-lived credentials
- **Service-to-service identity**: Use managed identities (Azure), IAM roles (AWS), or workload identity (GCP) instead of API keys

### Microsegmentation Strategy

- **Start coarse, refine over time**: Begin with broad segments and narrow based on traffic analysis
- **Workload-based segmentation**: Group by application, environment, and data sensitivity
- **Default deny**: Block all traffic not explicitly allowed
- **East-west traffic inspection**: Monitor and control traffic between workloads, not just north-south

### Data Protection

- **Classify data**: Tag resources by sensitivity level
- **Encrypt everywhere**: Enforce encryption in transit (TLS 1.2+) and at rest
- **DLP policies**: Prevent sensitive data exfiltration
- **Access based on classification**: More sensitive data requires stronger authentication

---

## Network Security vs Identity Security

### Traditional Perimeter Model

| Aspect | Perimeter Security | Zero Trust |
|--------|-------------------|------------|
| **Trust Boundary** | Network perimeter (firewall) | Every access request |
| **Default Posture** | Trust internal, block external | Trust nothing |
| **Lateral Movement** | Unrestricted once inside | Blocked by microsegmentation |
| **Remote Access** | VPN to join trusted network | Direct access via identity proxy |
| **Scalability** | VPN bottlenecks | Cloud-native, scales horizontally |

### Migration Path

1. **Phase 1 - Inventory**: Catalog all users, devices, applications, and data flows
2. **Phase 2 - Identity**: Deploy centralized identity provider with MFA
3. **Phase 3 - Device Trust**: Implement device posture checks
4. **Phase 4 - Microsegmentation**: Segment networks and apply least-privilege rules
5. **Phase 5 - Continuous Monitoring**: Deploy analytics and automated response
6. **Phase 6 - Automation**: Automate policy enforcement and incident response

---

## Continuous Verification Patterns

### Session-Based Verification

- Re-evaluate trust at regular intervals during active sessions
- Step-up authentication for sensitive operations
- Session timeout policies based on risk level
- Device posture re-checks during long sessions

### Risk-Based Adaptive Access

- **Low Risk**: Standard authentication, full access to non-sensitive resources
- **Medium Risk**: MFA required, limited session duration
- **High Risk**: Phishing-resistant MFA, restricted access, additional logging
- **Critical Risk**: Block access, alert security team

### Context Signals

| Signal | Source | Use |
|--------|--------|-----|
| **User Identity** | IdP, directory | Authentication level |
| **Device Health** | MDM, endpoint agent | Compliance status |
| **Location** | IP geolocation, GPS | Geographic risk |
| **Time** | System clock | Unusual access hours |
| **Behavior** | UEBA, analytics | Anomaly detection |
| **Network** | IP reputation, VPN status | Network trust level |

---

## Cost Estimation

### AWS (Monthly Estimate for Mid-Size Deployment)

| Component | Service | Estimated Cost |
|-----------|---------|---------------|
| Identity | IAM Identity Center | Free (included) |
| Application Access | Verified Access | ~$200-500/month |
| Private Connectivity | PrivateLink endpoints | ~$100-300/month |
| Threat Detection | GuardDuty | ~$100-500/month |
| Security Hub | Security Hub | ~$50-200/month |
| Logging | CloudTrail + CloudWatch | ~$100-400/month |
| **Total** | | **~$550-1,900/month** |

### Azure (Monthly Estimate for Mid-Size Deployment)

| Component | Service | Estimated Cost |
|-----------|---------|---------------|
| Identity | Entra ID P2 (per user) | ~$9/user/month |
| Conditional Access | Included in Entra P1/P2 | Included |
| Private Connectivity | Private Link | ~$100-300/month |
| SIEM | Microsoft Sentinel | ~$200-1,000/month |
| Firewall | Azure Firewall Premium | ~$900/month |
| **Total** | | **~$1,200-2,200/month** (50 users) |

### GCP (Monthly Estimate for Mid-Size Deployment)

| Component | Service | Estimated Cost |
|-----------|---------|---------------|
| Identity | Cloud Identity Free / Premium | Free - $7.20/user/month |
| Application Access | IAP | Free (included with load balancer) |
| Private Connectivity | VPC Service Controls | Free (included) |
| Threat Detection | Security Command Center Premium | Usage-based pricing |
| WAF | Cloud Armor | ~$100-400/month |
| **Total** | | **~$500-1,500/month** |

---

## Production Checklist

### Identity and Access

- [ ] Centralized identity provider deployed and configured
- [ ] MFA enforced for all users (phishing-resistant for admins)
- [ ] SSO configured for all applications
- [ ] Least privilege access policies implemented
- [ ] Service-to-service authentication uses managed identities
- [ ] Privileged access management (PAM) in place
- [ ] Regular access reviews scheduled

### Network Security

- [ ] Microsegmentation implemented with default-deny rules
- [ ] Private connectivity configured for all PaaS services
- [ ] mTLS enabled for service-to-service communication
- [ ] DNS security filtering active
- [ ] WAF deployed for public-facing applications
- [ ] VPN replaced with ZTNA where possible

### Data Protection

- [ ] Data classification scheme defined and applied
- [ ] Encryption in transit enforced (TLS 1.2+)
- [ ] Encryption at rest enabled for all data stores
- [ ] DLP policies configured for sensitive data
- [ ] Key management using HSM-backed services

### Monitoring and Response

- [ ] SIEM deployed with correlation rules
- [ ] All access events logged and retained
- [ ] Anomaly detection and UEBA configured
- [ ] Automated alerting for high-risk events
- [ ] Incident response playbooks documented
- [ ] Regular security assessments and penetration testing

### Governance

- [ ] Zero trust policy documented and approved
- [ ] Compliance requirements mapped to controls
- [ ] Regular policy reviews scheduled
- [ ] Security awareness training for all staff
- [ ] Third-party access policies defined

---

**Related Guides:**
- [Microservices Architecture](./microservices-architecture.md)
- [Web App 3-Tier Architecture](./web-app-3-tier.md)
- [Service Comparison - Networking](../service-comparison-networking.md)
