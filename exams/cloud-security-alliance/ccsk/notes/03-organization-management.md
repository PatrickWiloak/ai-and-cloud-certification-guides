# 03 - Organization Management (Guidance Domain 4)

## Domain Overview

Guidance Domain 4 addresses how organizations structure their cloud accounts, projects, or tenants to enable governance, security, and operations at scale. Organization management is foundational: a poor foundation cannot be easily retrofitted with security controls later.

## Organization Hierarchies

Major cloud providers provide hierarchical structures:

### AWS
- **Organization** (root)
- **Organizational Units (OUs)** - Hierarchical groupings
- **Accounts** - Isolated billing and security boundary
- **Resources** within accounts

### Azure
- **Entra ID tenant** (root)
- **Management Groups** - Hierarchical
- **Subscriptions** - Billing boundary
- **Resource Groups** - Logical grouping
- **Resources**

### GCP
- **Organization** (root)
- **Folders** - Hierarchical
- **Projects** - Resource/billing boundary
- **Resources**

### Common Principles
- Hierarchy enables policy inheritance (policies applied at higher levels cascade down)
- Accounts/subscriptions/projects are the primary security boundary
- Separate accounts for isolation, not just organization
- Each level has identity and access management implications

## Landing Zone Concept

A landing zone is a pre-configured, secure, scalable multi-account environment that serves as the foundation for cloud workloads.

### Components of a Landing Zone
- **Account structure** - Hierarchy aligned to business (BU, environment, compliance)
- **Network architecture** - Hub-and-spoke, transit, shared services
- **Identity foundation** - Central IdP, federation, break-glass
- **Centralized logging** - Cross-account log aggregation to security account
- **Security services** - CSPM, CWPP, IR tooling, detections
- **Guardrails** - Policy-as-code, SCPs, deny-by-default
- **Cost management** - Budgets, alerts, allocation
- **Baseline templates** - Standard account provisioning automation

### Provider Landing Zone Solutions
- AWS: Control Tower, Landing Zone Accelerator
- Azure: Azure Landing Zones (Cloud Adoption Framework)
- GCP: Cloud Foundation Toolkit, Landing Zones

### Benefits
- Consistency across teams
- Security built in, not bolted on
- Faster onboarding for new projects
- Clear cost allocation
- Auditable guardrails

## Account Structure Patterns

### By Environment
- Dev
- Staging / UAT
- Production

Each environment in a separate account/project/subscription. Prevents dev changes from affecting production.

### By Business Unit or Team
- Engineering
- Marketing
- Finance
- HR

Each BU has its own accounts. Enables delegated ownership and cost tracking.

### By Application
- App A (dev/staging/prod)
- App B (dev/staging/prod)

Application-aligned accounts for independent deployment and blast radius reduction.

### By Compliance Scope
- PCI DSS in-scope account
- HIPAA BAA-covered account
- Non-regulated accounts

Isolation minimizes compliance scope and audit cost.

### Hybrid Approach
Most organizations combine: environments x BUs x compliance zones. Landing zones automate creation of the right account for each need.

## Security Accounts

Dedicated accounts for security functions:

- **Log archive account** - Centralized immutable log storage
- **Audit account** - Read-only access for auditors and security team
- **Security tooling account** - SIEM, CSPM, vulnerability scanners
- **Network/transit account** - Shared network infrastructure

Separation prevents compromise of a workload account from affecting security controls.

## Shared Services

Common across all accounts:
- Identity (IdP)
- DNS
- Network egress (centralized via Transit Gateway / hub)
- Logging
- Monitoring
- Directory services

Hub-and-spoke network architecture centralizes egress and inspection.

## Policy Inheritance

Policies defined at higher levels apply to all child resources:
- AWS Service Control Policies (SCPs) at OU level
- Azure Policy at Management Group
- GCP Organization Policy at Organization or Folder

Use cases:
- Deny specific services/regions across all accounts
- Require encryption at rest
- Prohibit public resources
- Require specific tags

## Guardrails

Automated controls enforcing policy without requiring human review:

### Preventive Guardrails
- SCPs / Organization Policies prevent actions
- IAM policies prevent unauthorized access
- Admission controllers for Kubernetes

### Detective Guardrails
- Config/Policy compliance rules detect drift
- CSPM alerts on misconfigurations
- Logging captures actions for audit

### Corrective Guardrails
- Auto-remediation (e.g., Lambda triggered to revert public S3 bucket)
- Quarantine resources violating policy

## Policy as Code

Define governance policies in code for version control, review, and automated enforcement:
- **Open Policy Agent (OPA)** - General-purpose policy engine
- **HashiCorp Sentinel** - Policy for Terraform Enterprise/Cloud
- **AWS Config Rules** - Compliance rules (custom and managed)
- **Azure Policy** - Declarative policy language
- **GCP Organization Policy** - Constraint-based
- **Kubernetes admission controllers** - Kyverno, OPA Gatekeeper

## Identity Foundation in Organization

- Central IdP (Entra ID, Okta, Ping, etc.)
- SAML/OIDC federation to each cloud account
- Role-based access with permission sets
- Just-in-time elevation via PAM
- Break-glass accounts per cloud (vaulted, MFA, monitored, periodically tested)

## Network Foundation

### Hub-and-Spoke
- Central "hub" account/VPC with shared services (egress, firewall, DNS)
- Spoke accounts/VPCs peer into hub
- Centralized inspection and logging

### Transit Gateway / Transit Architecture
- AWS Transit Gateway, Azure Virtual WAN, GCP Cloud Interconnect
- Scales better than mesh VPC peering
- Central routing with policy enforcement

### Segmentation Principles
- Separate accounts/subscriptions/projects for blast radius isolation
- Within account: VPCs/VNets per environment or workload
- Within VPC: subnets by tier (web, app, data)
- Host-level: security groups, NSGs, firewall rules

## Centralized Logging

All accounts ship logs to a dedicated log archive account:
- AWS: CloudTrail + S3 in log archive account (cross-account delivery)
- Azure: Azure Monitor + Log Analytics in security subscription
- GCP: Cloud Logging aggregated in security project

Benefits:
- Logs preserved even if workload account compromised
- SIEM ingestion from one location
- Centralized retention policy
- Separate access control (read-only for security team)

## Tagging Strategy

Consistent tagging across resources enables:
- Cost allocation (cost-center tag)
- Environment identification (env tag: prod, staging, dev)
- Ownership (owner, team tags)
- Data classification (classification tag)
- Compliance scope (pci-in-scope tag)
- Automation (auto-shutdown, auto-backup)

Tag enforcement via policy (require certain tags on resource creation).

## Cost Management (FinOps Overlap)

- Budgets per account/project
- Alerts on spend anomalies
- Reserved capacity / committed use discounts
- Auto-scaling policies with cost controls
- Unused resource detection
- Tagging for showback/chargeback

Security overlap: cost anomalies can indicate compromise (cryptomining, data exfil DoS via egress costs).

## Sandbox Accounts

Separate accounts for experimentation:
- Restricted service catalog
- Limited budget
- Time-limited auto-decommission
- Reduced controls (still basic guardrails)
- Prevents sandbox work from leaking into production

## Account Lifecycle

### Provisioning
- Automated via landing zone templates
- Baseline controls applied
- Identity federation configured
- Logging enabled
- Network connected to shared services

### Ongoing
- Continuous monitoring (CSPM, config)
- Periodic access review
- Cost review
- Compliance attestation

### Decommissioning
- Data export / retention per policy
- Resources terminated
- Identity revoked
- Account closed (providers hold accounts for a period before permanent deletion)
- Documentation preserved

## Multi-Cloud Organization Management

### Challenges
- Different hierarchies per provider
- Different identity models
- Different policy languages
- Different logging formats
- Different compliance frameworks

### Strategies
- Central IdP federated to all clouds
- Abstraction layer (Terraform for IaC, CSPM for cross-cloud visibility)
- Standardized tagging across clouds
- Unified SIEM and SOC
- Per-cloud landing zone aligned to common principles

## Common Exam Pitfalls

- Designing single-account architecture for multi-BU organization
- Putting production and development in same account
- Storing logs in same account as the workload (attacker can delete)
- Using manual account creation instead of automated landing zone
- Missing hierarchical policy application (SCPs, etc.)
- Overlooking break-glass accounts for identity outage
- Skipping tagging standards

## Quick Reference: Account Pattern Decision

| Need | Pattern |
|------|---------|
| Environment isolation | Account per dev/staging/prod |
| BU delegation | Account per BU (with hierarchy) |
| Compliance scope reduction | Dedicated compliance account (e.g., PCI) |
| Security tooling | Dedicated security account |
| Logging | Dedicated log archive account |
| Shared services | Hub account with Transit Gateway/Virtual WAN |
| Experimentation | Sandbox account with limited budget |
