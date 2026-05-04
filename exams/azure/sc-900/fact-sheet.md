---
last-updated: 2026-05-03
---

# Azure SC-900: Microsoft Security, Compliance, and Identity Fundamentals - Fact Sheet

## Exam Overview

The SC-900 certification validates foundational knowledge of security, compliance, and identity concepts across Microsoft cloud services. This exam is designed for business users, IT professionals, students, and those beginning their journey in Microsoft security solutions.

**Exam Details:**
- **[📖 Official SC-900 Exam Page](https://learn.microsoft.com/en-us/certifications/exams/sc-900)** - Complete exam information, registration, and requirements
- **[📖 SC-900 Study Guide](https://learn.microsoft.com/en-us/certifications/resources/study-guides/sc-900)** - Official Microsoft study guide with exam objectives
- **[📖 SC-900 Skills Measured](https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RE4Myp7)** - Detailed breakdown of exam domains and weightings
- **[📖 Microsoft Learn SC-900 Learning Path](https://learn.microsoft.com/en-us/training/paths/describe-concepts-of-security-compliance-identity/)** - Free comprehensive training modules

---

## Domain 1: Security, Compliance, and Identity Concepts (10-15%)

### Shared Responsibility Model

Understanding how security responsibilities are distributed between cloud providers and customers is fundamental to cloud security.

- **[📖 Shared Responsibility Model Overview](https://learn.microsoft.com/en-us/azure/security/fundamentals/shared-responsibility)** - Core concepts of shared security responsibilities in cloud computing
- **[📖 Shared Responsibility in the Cloud](https://learn.microsoft.com/en-us/azure/security/fundamentals/shared-responsibility-ai)** - How responsibilities shift across IaaS, PaaS, and SaaS models
- **[📖 Cloud Security Posture Management](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-cloud-security-posture-management)** - Tools and practices for maintaining security responsibilities

### Zero Trust Security Model

Zero Trust is a security framework that assumes breach and verifies each request as though it originates from an untrusted network.

- **[📖 Zero Trust Security Model](https://learn.microsoft.com/en-us/security/zero-trust/zero-trust-overview)** - Comprehensive overview of Zero Trust principles and implementation
- **[📖 Zero Trust Deployment Guide](https://learn.microsoft.com/en-us/security/zero-trust/deploy/overview)** - Step-by-step guidance for implementing Zero Trust architecture
- **[📖 Zero Trust Identity and Access](https://learn.microsoft.com/en-us/security/zero-trust/deploy/identity)** - Identity-centric Zero Trust implementation strategies
- **[📖 Zero Trust Rapid Modernization Plan](https://learn.microsoft.com/en-us/security/zero-trust/zero-trust-ramp-overview)** - Accelerated Zero Trust adoption framework
- **[📖 Guiding Principles of Zero Trust](https://www.microsoft.com/en-us/security/business/zero-trust)** - Core tenets: verify explicitly, use least privilege access, assume breach

### Defense in Depth

A layered security approach that provides multiple levels of protection to prevent and detect security breaches.

- **[📖 Defense in Depth Strategy](https://learn.microsoft.com/en-us/training/modules/describe-security-concepts-methodologies/4-describe-defense-depth)** - Multi-layered security approach from physical to application layers
- **[📖 Azure Defense in Depth](https://learn.microsoft.com/en-us/azure/architecture/framework/security/design-defense-in-depth)** - Implementing layered security in Azure environments
- **[📖 Security Layers Explained](https://learn.microsoft.com/en-us/azure/security/fundamentals/overview)** - Physical, identity, perimeter, network, compute, application, and data layers

### Encryption and Hashing

Cryptographic methods for protecting data at rest, in transit, and in use.

- **[📖 Azure Encryption Overview](https://learn.microsoft.com/en-us/azure/security/fundamentals/encryption-overview)** - Comprehensive guide to encryption services in Azure
- **[📖 Data Encryption at Rest](https://learn.microsoft.com/en-us/azure/security/fundamentals/encryption-atrest)** - Protecting stored data using Azure encryption services
- **[📖 Data Encryption in Transit](https://learn.microsoft.com/en-us/azure/security/fundamentals/encryption-overview#encryption-of-data-in-transit)** - TLS/SSL and network-level encryption mechanisms
- **[📖 Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/overview)** - Centralized secrets, keys, and certificate management service

### Compliance Concepts

Understanding regulatory requirements, standards, and governance frameworks relevant to cloud services.

- **[📖 Microsoft Compliance Offerings](https://learn.microsoft.com/en-us/compliance/regulatory/offering-home)** - Comprehensive list of compliance certifications and attestations
- **[📖 Azure Compliance Documentation](https://learn.microsoft.com/en-us/azure/compliance/)** - Industry-specific and regional compliance resources
- **[📖 Data Residency in Azure](https://learn.microsoft.com/en-us/azure/compliance/offerings/offering-data-residency)** - Understanding where data is stored and processed

---

## Domain 2: Identity and Access Management (25-30%)

### Microsoft Entra ID (Azure Active Directory)

Microsoft's cloud-based identity and access management service, the foundation of Microsoft 365 and Azure security.

- **[📖 Microsoft Entra ID Overview](https://learn.microsoft.com/en-us/entra/fundamentals/whatis)** - Core identity service for authentication and authorization
- **[📖 Azure AD vs Active Directory](https://learn.microsoft.com/en-us/entra/fundamentals/compare)** - Key differences between cloud and on-premises identity services
- **[📖 Entra ID Licensing](https://learn.microsoft.com/en-us/entra/fundamentals/licensing)** - Free, Premium P1, and Premium P2 feature comparisons
- **[📖 Entra ID Architecture](https://learn.microsoft.com/en-us/entra/architecture/architecture)** - Understanding tenants, directories, and organizational structure
- **[📖 Hybrid Identity with Azure AD Connect](https://learn.microsoft.com/en-us/entra/identity/hybrid/whatis-hybrid-identity)** - Synchronizing on-premises and cloud identities

### Authentication Methods

Various methods for verifying user identities in Microsoft cloud services.

- **[📖 Authentication Methods in Entra ID](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-methods)** - Passwords, passwordless, biometrics, and token-based authentication
- **[📖 Passwordless Authentication](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-passwordless)** - Windows Hello, FIDO2 keys, and Microsoft Authenticator
- **[📖 Self-Service Password Reset](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-sspr-howitworks)** - Enabling users to reset passwords without helpdesk intervention
- **[📖 Password Protection](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-password-ban-bad)** - Detecting and blocking weak passwords across the organization

### Multi-Factor Authentication (MFA)

Requiring multiple forms of verification to significantly enhance security beyond passwords alone.

- **[📖 Multi-Factor Authentication Overview](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-mfa-howitworks)** - How MFA provides additional security layers
- **[📖 Enabling Azure MFA](https://learn.microsoft.com/en-us/entra/identity/authentication/tutorial-enable-azure-mfa)** - Step-by-step MFA deployment guide
- **[📖 MFA Registration Policies](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-registration-mfa-sspr-combined)** - Combined security information registration experience
- **[📖 Microsoft Authenticator App](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-authenticator-app)** - Mobile app for push notifications and OTP codes

### Conditional Access

Policy-based access control that evaluates signals to make intelligent access decisions.

- **[📖 Conditional Access Overview](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview)** - If-then policy engine for automated access control decisions
- **[📖 Conditional Access Policies](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-conditional-access-policies)** - Building blocks: assignments, cloud apps, conditions, and access controls
- **[📖 Common Conditional Access Policies](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-conditional-access-policy-common)** - Best practice policy templates for typical scenarios
- **[📖 Conditional Access Signals](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-conditional-access-conditions)** - User location, device state, application, and risk-based signals
- **[📖 What-If Tool](https://learn.microsoft.com/en-us/entra/identity/conditional-access/what-if-tool)** - Testing and validating Conditional Access policies before enforcement

### Identity Protection

Automated detection and remediation of identity-based risks using machine learning.

- **[📖 Identity Protection Overview](https://learn.microsoft.com/en-us/entra/id-protection/overview-identity-protection)** - Risk-based Conditional Access using AI and machine learning
- **[📖 Risk Detections](https://learn.microsoft.com/en-us/entra/id-protection/concept-identity-protection-risks)** - Anonymous IP, atypical travel, malware-linked IP, and leaked credentials
- **[📖 Risk Policies](https://learn.microsoft.com/en-us/entra/id-protection/concept-identity-protection-policies)** - User risk and sign-in risk remediation policies
- **[📖 Investigating Risk Events](https://learn.microsoft.com/en-us/entra/id-protection/howto-identity-protection-investigate-risk)** - Analyzing and responding to detected identity risks

### Access Management

Controlling who can access what resources across Microsoft cloud services.

- **[📖 Azure Role-Based Access Control (RBAC)](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview)** - Fine-grained access management for Azure resources
- **[📖 Built-in Azure Roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles)** - Owner, Contributor, Reader, and specialized role definitions
- **[📖 Entra ID Roles](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/permissions-reference)** - Administrative roles for managing identity and access
- **[📖 Privileged Identity Management (PIM)](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure)** - Just-in-time privileged access with approval workflows
- **[📖 Access Reviews](https://learn.microsoft.com/en-us/entra/id-governance/access-reviews-overview)** - Periodic certification of user access rights and group memberships

### External Identities

Enabling secure collaboration with partners, suppliers, and customers outside your organization.

- **[📖 External Identities Overview](https://learn.microsoft.com/en-us/entra/external-id/external-identities-overview)** - B2B and B2C identity scenarios
- **[📖 B2B Collaboration](https://learn.microsoft.com/en-us/entra/external-id/what-is-b2b)** - Inviting external users to access your applications and resources
- **[📖 Azure AD B2C](https://learn.microsoft.com/en-us/azure/active-directory-b2c/overview)** - Customer identity and access management for consumer-facing applications

---

## Domain 3: Microsoft Security Solutions (35-40%)

### Microsoft Defender for Cloud

Unified security management and advanced threat protection for hybrid and multi-cloud workloads.

- **[📖 Defender for Cloud Overview](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction)** - Cloud Security Posture Management (CSPM) and Cloud Workload Protection Platform (CWPP)
- **[📖 Security Posture Management](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-cloud-security-posture-management)** - Continuous assessment and security recommendations
- **[📖 Secure Score](https://learn.microsoft.com/en-us/azure/defender-for-cloud/secure-score-security-controls)** - Quantifying security posture with actionable improvement metrics
- **[📖 Defender for Cloud Plans](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction#protect-cloud-workloads)** - Workload-specific protection for servers, storage, databases, and containers
- **[📖 Security Recommendations](https://learn.microsoft.com/en-us/azure/defender-for-cloud/review-security-recommendations)** - Prioritized guidance for improving security posture
- **[📖 Defender for Servers](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-servers-introduction)** - Advanced threat protection for virtual machines and servers
- **[📖 Defender for Storage](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-storage-introduction)** - Protection against malicious file uploads and sensitive data exposure

### Microsoft Defender for Endpoint

Enterprise endpoint security platform for preventing, detecting, investigating, and responding to advanced threats.

- **[📖 Defender for Endpoint Overview](https://learn.microsoft.com/en-us/defender-endpoint/microsoft-defender-endpoint)** - Next-generation endpoint protection, detection, and response
- **[📖 Threat and Vulnerability Management](https://learn.microsoft.com/en-us/defender-endpoint/next-gen-threat-and-vuln-mgt)** - Continuous vulnerability discovery, prioritization, and remediation
- **[📖 Attack Surface Reduction](https://learn.microsoft.com/en-us/defender-endpoint/overview-attack-surface-reduction)** - Rules and policies to reduce organizational exposure
- **[📖 Next-Generation Protection](https://learn.microsoft.com/en-us/defender-endpoint/next-generation-protection)** - Real-time antivirus and anti-malware protection
- **[📖 Endpoint Detection and Response](https://learn.microsoft.com/en-us/defender-endpoint/overview-endpoint-detection-response)** - Advanced threat detection and automated investigation
- **[📖 Automated Investigation and Remediation](https://learn.microsoft.com/en-us/defender-endpoint/automated-investigations)** - AI-driven threat analysis and response automation

### Microsoft Defender for Office 365

Protection against threats in email, links, collaboration tools, and Office applications.

- **[📖 Defender for Office 365 Overview](https://learn.microsoft.com/en-us/defender-office-365/mdo-about)** - Safeguarding against phishing, malware, and business email compromise
- **[📖 Safe Attachments](https://learn.microsoft.com/en-us/defender-office-365/safe-attachments-about)** - Sandboxing and detonating email attachments in virtual environments
- **[📖 Safe Links](https://learn.microsoft.com/en-us/defender-office-365/safe-links-about)** - Time-of-click URL scanning and rewriting
- **[📖 Anti-Phishing Protection](https://learn.microsoft.com/en-us/defender-office-365/anti-phishing-protection-about)** - Machine learning models to detect impersonation and spoofing
- **[📖 Threat Explorer](https://learn.microsoft.com/en-us/defender-office-365/threat-explorer-real-time-detections-about)** - Real-time reporting and analysis of email threats

### Microsoft Defender for Identity

Identity-based threat detection using on-premises Active Directory signals.

- **[📖 Defender for Identity Overview](https://learn.microsoft.com/en-us/defender-for-identity/what-is)** - Detecting advanced threats, compromised identities, and malicious insider actions
- **[📖 Identity Security Posture](https://learn.microsoft.com/en-us/defender-for-identity/security-assessment)** - Assessments for Active Directory misconfigurations and vulnerabilities
- **[📖 Lateral Movement Detection](https://learn.microsoft.com/en-us/defender-for-identity/understand-lateral-movement-paths)** - Identifying potential attack paths through the network
- **[📖 Identity Threat Investigation](https://learn.microsoft.com/en-us/defender-for-identity/investigate-assets)** - Analyzing suspicious activities and entity behaviors

### Microsoft Defender for Cloud Apps

Cloud Access Security Broker (CASB) providing visibility, data control, and threat protection for cloud applications.

- **[📖 Defender for Cloud Apps Overview](https://learn.microsoft.com/en-us/defender-cloud-apps/what-is-defender-for-cloud-apps)** - Comprehensive CASB for SaaS security and compliance
- **[📖 Cloud Discovery](https://learn.microsoft.com/en-us/defender-cloud-apps/set-up-cloud-discovery)** - Identifying shadow IT and unsanctioned cloud application usage
- **[📖 App Connectors](https://learn.microsoft.com/en-us/defender-cloud-apps/enable-instant-visibility-protection-and-governance-actions-for-your-apps)** - API-based connections for deep visibility and control
- **[📖 Conditional Access App Control](https://learn.microsoft.com/en-us/defender-cloud-apps/proxy-intro-aad)** - Real-time session monitoring and control for cloud applications
- **[📖 Information Protection Policies](https://learn.microsoft.com/en-us/defender-cloud-apps/data-protection-policies)** - DLP and classification for cloud-stored sensitive data

### Microsoft Sentinel

Cloud-native Security Information and Event Management (SIEM) and Security Orchestration, Automation, and Response (SOAR) solution.

- **[📖 Microsoft Sentinel Overview](https://learn.microsoft.com/en-us/azure/sentinel/overview)** - Intelligent security analytics and threat intelligence across the enterprise
- **[📖 Sentinel Architecture](https://learn.microsoft.com/en-us/azure/sentinel/design-your-workspace-architecture)** - Workspace design and data collection strategies
- **[📖 Data Connectors](https://learn.microsoft.com/en-us/azure/sentinel/connect-data-sources)** - Ingesting security data from Microsoft and third-party sources
- **[📖 Analytics Rules](https://learn.microsoft.com/en-us/azure/sentinel/detect-threats-built-in)** - Built-in and custom detection rules for security threats
- **[📖 Incident Management](https://learn.microsoft.com/en-us/azure/sentinel/investigate-cases)** - Investigating and triaging security incidents
- **[📖 Workbooks and Visualization](https://learn.microsoft.com/en-us/azure/sentinel/monitor-your-data)** - Creating dashboards for security monitoring and reporting
- **[📖 Threat Hunting](https://learn.microsoft.com/en-us/azure/sentinel/hunting)** - Proactive searching for security threats using KQL queries
- **[📖 Automation and Playbooks](https://learn.microsoft.com/en-us/azure/sentinel/automate-responses-with-playbooks)** - Logic Apps-based automated response workflows
- **[📖 User and Entity Behavior Analytics (UEBA)](https://learn.microsoft.com/en-us/azure/sentinel/identify-threats-with-entity-behavior-analytics)** - Machine learning to detect anomalous user and entity behavior

### Microsoft 365 Defender

Unified pre- and post-breach enterprise defense suite coordinating protection across endpoints, identities, email, and applications.

- **[📖 Microsoft 365 Defender Overview](https://learn.microsoft.com/en-us/defender-xdr/microsoft-365-defender)** - Extended detection and response (XDR) platform
- **[📖 Incidents and Alerts](https://learn.microsoft.com/en-us/defender-xdr/incidents-overview)** - Unified incident queue across all Defender products
- **[📖 Advanced Hunting](https://learn.microsoft.com/en-us/defender-xdr/advanced-hunting-overview)** - Query-based threat hunting across 30 days of raw data
- **[📖 Threat Analytics](https://learn.microsoft.com/en-us/defender-xdr/threat-analytics)** - Intelligence reports on emerging threats and attack campaigns
- **[📖 Secure Score](https://learn.microsoft.com/en-us/defender-xdr/microsoft-secure-score)** - Measurement and improvement of security posture across Microsoft 365

### Azure DDoS Protection

Safeguarding Azure resources against distributed denial-of-service attacks.

- **[📖 DDoS Protection Overview](https://learn.microsoft.com/en-us/azure/ddos-protection/ddos-protection-overview)** - Always-on traffic monitoring and automatic attack mitigation
- **[📖 DDoS Protection Tiers](https://learn.microsoft.com/en-us/azure/ddos-protection/ddos-protection-sku-comparison)** - Network Protection and IP Protection service levels

### Azure Firewall

Cloud-native, intelligent network firewall security service providing best-in-class threat protection.

- **[📖 Azure Firewall Overview](https://learn.microsoft.com/en-us/azure/firewall/overview)** - Managed, stateful firewall with built-in high availability
- **[📖 Azure Firewall Manager](https://learn.microsoft.com/en-us/azure/firewall-manager/overview)** - Centralized security policy and route management

---

## Domain 4: Microsoft Compliance Solutions (25-30%)

### Microsoft Purview

Comprehensive data governance and compliance management platform.

- **[📖 Microsoft Purview Overview](https://learn.microsoft.com/en-us/purview/purview)** - Unified data governance and risk management solutions
- **[📖 Purview Compliance Portal](https://learn.microsoft.com/en-us/purview/microsoft-365-compliance-center)** - Centralized hub for managing compliance across Microsoft 365

### Data Classification and Labeling

Discovering, classifying, and protecting sensitive information throughout its lifecycle.

- **[📖 Know Your Data](https://learn.microsoft.com/en-us/purview/data-classification-overview)** - Understanding data classification and sensitive information types
- **[📖 Sensitive Information Types](https://learn.microsoft.com/en-us/purview/sensitive-information-type-learn-about)** - Pre-built patterns for identifying sensitive data like credit cards, SSNs, and passport numbers
- **[📖 Trainable Classifiers](https://learn.microsoft.com/en-us/purview/classifier-learn-about)** - Machine learning models for identifying content types
- **[📖 Sensitivity Labels](https://learn.microsoft.com/en-us/purview/sensitivity-labels)** - Classifying and protecting documents and emails with persistent labels
- **[📖 Auto-Labeling Policies](https://learn.microsoft.com/en-us/purview/apply-sensitivity-label-automatically)** - Automatically applying labels based on content inspection
- **[📖 Label Analytics](https://learn.microsoft.com/en-us/purview/data-classification-activity-explorer)** - Monitoring and reporting on label usage and data access

### Data Loss Prevention (DLP)

Preventing accidental or intentional sharing of sensitive information outside the organization.

- **[📖 Data Loss Prevention Overview](https://learn.microsoft.com/en-us/purview/dlp-learn-about-dlp)** - Protecting sensitive data across devices, services, and on-premises locations
- **[📖 DLP Policies](https://learn.microsoft.com/en-us/purview/dlp-policy-reference)** - Creating rules to detect and protect sensitive information
- **[📖 Endpoint DLP](https://learn.microsoft.com/en-us/purview/endpoint-dlp-learn-about)** - Monitoring and protecting sensitive data on Windows and macOS devices
- **[📖 DLP Alerts and Reports](https://learn.microsoft.com/en-us/purview/dlp-alerts-dashboard-learn-about)** - Investigating and responding to data loss prevention incidents

### Retention and Records Management

Ensuring data is retained according to business and regulatory requirements while disposing of unnecessary data.

- **[📖 Retention Policies](https://learn.microsoft.com/en-us/purview/retention)** - Proactively retaining or deleting content based on organizational policies
- **[📖 Retention Labels](https://learn.microsoft.com/en-us/purview/retention#retention-labels)** - Item-level retention settings with manual or automatic application
- **[📖 Records Management](https://learn.microsoft.com/en-us/purview/records-management)** - Declaring items as regulatory or business records with deletion restrictions
- **[📖 Disposition Review](https://learn.microsoft.com/en-us/purview/disposition)** - Reviewing content before permanent deletion at retention period end

### eDiscovery and Audit

Identifying, preserving, and collecting electronic information for legal and investigative purposes.

- **[📖 eDiscovery Solutions](https://learn.microsoft.com/en-us/purview/ediscovery)** - Content search, eDiscovery Standard, and eDiscovery Premium capabilities
- **[📖 Content Search](https://learn.microsoft.com/en-us/purview/search-for-content)** - Searching mailboxes, SharePoint sites, and Teams locations
- **[📖 eDiscovery Cases](https://learn.microsoft.com/en-us/purview/ediscovery-standard-get-started)** - Managing legal holds, searches, and exports for investigations
- **[📖 Audit Logging](https://learn.microsoft.com/en-us/purview/audit-solutions-overview)** - Recording user and administrator activities across Microsoft 365
- **[📖 Advanced Audit](https://learn.microsoft.com/en-us/purview/audit-premium)** - Extended retention, forensically relevant events, and higher bandwidth access

### Insider Risk Management

Detecting and acting on risky activities by employees and partners.

- **[📖 Insider Risk Management](https://learn.microsoft.com/en-us/purview/insider-risk-management)** - Identifying potential malicious or inadvertent insider threats
- **[📖 Insider Risk Policies](https://learn.microsoft.com/en-us/purview/insider-risk-management-policies)** - Templates for data theft, leaks, and security violations
- **[📖 Insider Risk Alerts](https://learn.microsoft.com/en-us/purview/insider-risk-management-activities)** - Investigating and escalating risky user activities

### Communication Compliance

Monitoring organizational communications for policy violations and regulatory compliance.

- **[📖 Communication Compliance](https://learn.microsoft.com/en-us/purview/communication-compliance)** - Detecting inappropriate messages, harassment, and sensitive information sharing
- **[📖 Communication Policies](https://learn.microsoft.com/en-us/purview/communication-compliance-policies)** - Creating rules to monitor email, Teams, and third-party communications

### Compliance Manager

Simplified compliance management with actionable insights and improvement actions.

- **[📖 Compliance Manager Overview](https://learn.microsoft.com/en-us/purview/compliance-manager)** - Centralized tool for managing compliance across regulations and standards
- **[📖 Compliance Score](https://learn.microsoft.com/en-us/purview/compliance-score)** - Risk-based score measuring progress in completing recommended actions
- **[📖 Compliance Assessments](https://learn.microsoft.com/en-us/purview/compliance-manager-assessments)** - Pre-built and custom templates for regulatory frameworks
- **[📖 Improvement Actions](https://learn.microsoft.com/en-us/purview/compliance-manager-improvement-actions)** - Technical and non-technical recommendations for compliance improvement
- **[📖 Compliance Manager Templates](https://learn.microsoft.com/en-us/purview/compliance-manager-templates-list)** - GDPR, ISO 27001, NIST, HIPAA, and other regulatory templates

### Information Barriers

Preventing conflicts of interest by restricting communication and collaboration between specific groups.

- **[📖 Information Barriers](https://learn.microsoft.com/en-us/purview/information-barriers)** - Policies to segment users and control collaboration in regulated industries

### Privacy Management

Managing personal data and meeting privacy regulations like GDPR.

- **[📖 Privacy Management](https://learn.microsoft.com/en-us/purview/privacy-management)** - Subject rights requests, data minimization, and consent management
- **[📖 Subject Rights Requests](https://learn.microsoft.com/en-us/purview/privacy-management-subject-rights-requests)** - Automating responses to data subject access requests

---

## Additional Microsoft Security Technologies

### Microsoft Intune

Cloud-based endpoint management for mobile devices, desktops, and applications.

- **[📖 Microsoft Intune Overview](https://learn.microsoft.com/en-us/mem/intune/fundamentals/what-is-intune)** - Mobile Device Management (MDM) and Mobile Application Management (MAM)
- **[📖 Device Enrollment](https://learn.microsoft.com/en-us/mem/intune/enrollment/enrollment-overview)** - Bringing devices under Intune management
- **[📖 Compliance Policies](https://learn.microsoft.com/en-us/mem/intune/protect/device-compliance-get-started)** - Defining security requirements for managed devices
- **[📖 Configuration Profiles](https://learn.microsoft.com/en-us/mem/intune/configuration/device-profiles)** - Deploying settings and features to devices
- **[📖 App Protection Policies](https://learn.microsoft.com/en-us/mem/intune/apps/app-protection-policy)** - Protecting corporate data in mobile applications without device enrollment
- **[📖 Conditional Access Integration](https://learn.microsoft.com/en-us/mem/intune/protect/conditional-access)** - Device compliance as a Conditional Access signal

### Microsoft Defender Vulnerability Management

Continuous visibility and risk-based prioritization of endpoint vulnerabilities.

- **[📖 Defender Vulnerability Management](https://learn.microsoft.com/en-us/defender-vulnerability-management/defender-vulnerability-management)** - Asset discovery, vulnerability assessment, and remediation tracking
- **[📖 Exposure Score](https://learn.microsoft.com/en-us/defender-vulnerability-management/tvm-exposure-score)** - Quantifying organizational exposure to cybersecurity threats

### Azure Information Protection (AIP)

Classifying and protecting documents and emails by applying labels (now integrated into Microsoft Purview Information Protection).

- **[📖 Azure Information Protection](https://learn.microsoft.com/en-us/azure/information-protection/what-is-information-protection)** - Label-based classification and protection for documents and emails
- **[📖 AIP Unified Labeling Client](https://learn.microsoft.com/en-us/azure/information-protection/rms-client/aip-clientv2)** - Client software for applying sensitivity labels in Office apps

---

## Exam Preparation Resources

### Official Learning Paths and Documentation

- **[📖 SC-900 Certification Page](https://learn.microsoft.com/en-us/certifications/security-compliance-and-identity-fundamentals/)** - Official certification landing page with all resources
- **[📖 Microsoft Learn Training](https://learn.microsoft.com/en-us/training/browse/?products=azure%2Cm365&roles=security-engineer&resource_type=learning%20path)** - Free hands-on learning modules
- **[📖 Microsoft Security Documentation](https://learn.microsoft.com/en-us/security/)** - Comprehensive technical documentation
- **[📖 Microsoft 365 Security Center](https://security.microsoft.com)** - Production portal for managing security across Microsoft 365

### Practice and Assessment

- **[📖 SC-900 Practice Assessment](https://learn.microsoft.com/en-us/certifications/exams/sc-900/practice/assessment?assessment-type=practice&assessmentId=11)** - Official Microsoft practice questions
- **[📖 Microsoft Learn Sandbox](https://learn.microsoft.com/en-us/training/support/faq?pivots=sandbox)** - Free Azure subscription for hands-on practice within learning modules
- **[📖 Microsoft Security YouTube Channel](https://www.youtube.com/c/MicrosoftSecurityCommunity)** - Video content on security features and best practices

### Community Resources

- **[📖 Microsoft Security Community](https://techcommunity.microsoft.com/t5/security-compliance-and-identity/ct-p/MicrosoftSecurityandCompliance)** - Forums, blogs, and discussions with Microsoft engineers and community experts
- **[📖 Microsoft Security Blog](https://www.microsoft.com/en-us/security/blog/)** - Latest security news, threat intelligence, and product announcements

---

## Key Concepts Summary

### Zero Trust Principles
1. **Verify explicitly** - Always authenticate and authorize based on all available data points
2. **Use least privilege access** - Limit user access with Just-In-Time and Just-Enough-Access
3. **Assume breach** - Minimize blast radius and segment access, verify end-to-end encryption

### Defense in Depth Layers
1. **Physical security** - Datacenter access controls
2. **Identity & access** - Authentication, SSO, MFA
3. **Perimeter** - DDoS protection, firewalls
4. **Network** - Segmentation, access controls, deny by default
5. **Compute** - Secure VM access, endpoint protection, patching
6. **Application** - Secure development, no credentials in code
7. **Data** - Encryption at rest and in transit, classification

### Identity Types in Entra ID
- **User identities** - Employees and internal users
- **Workload identities** - Applications and services (service principals, managed identities)
- **Device identities** - Registered, joined, and hybrid-joined devices
- **External identities** - Guest users and B2B collaboration partners

### Microsoft Defender Suite
- **Defender for Endpoint** - Device/endpoint protection
- **Defender for Office 365** - Email and collaboration security
- **Defender for Identity** - On-premises AD threat detection
- **Defender for Cloud Apps** - CASB for SaaS applications
- **Defender for Cloud** - CSPM and CWPP for Azure and multi-cloud
- **Microsoft 365 Defender** - XDR coordinating all Defender products
- **Microsoft Sentinel** - SIEM and SOAR platform

### Compliance Solution Categories
- **Information Protection** - Classification, labeling, encryption
- **Data Lifecycle Management** - Retention, deletion, records management
- **Insider Risk Management** - Detecting malicious or negligent insider actions
- **eDiscovery and Audit** - Legal holds, content search, activity logging
- **Compliance Management** - Assessments, scores, improvement actions

---

## Exam Tips

1. **Understand concepts over memorization** - Focus on when and why to use each service rather than memorizing every feature
2. **Know the differences** - Be clear on distinctions between similar services (e.g., Defender for Cloud vs. Defender for Endpoint)
3. **Licensing awareness** - Understand which features require Premium licenses (especially for Entra ID P1/P2)
4. **Scenario-based thinking** - Practice identifying appropriate solutions for given business requirements
5. **Hands-on experience** - Use Microsoft Learn sandboxes and free trials to explore the services
6. **Service relationships** - Understand how services integrate (e.g., Intune + Conditional Access, Sentinel + Defender)
7. **Compliance frameworks** - Familiarize yourself with common regulations (GDPR, HIPAA, ISO 27001)
8. **Zero Trust mindset** - Many questions relate to implementing Zero Trust principles

---

## Glossary of Key Terms

- **CASB** - Cloud Access Security Broker
- **CWPP** - Cloud Workload Protection Platform
- **CSPM** - Cloud Security Posture Management
- **DLP** - Data Loss Prevention
- **EDR** - Endpoint Detection and Response
- **IAM** - Identity and Access Management
- **IaaS** - Infrastructure as a Service
- **MDM** - Mobile Device Management
- **MFA** - Multi-Factor Authentication
- **PaaS** - Platform as a Service
- **PIM** - Privileged Identity Management
- **RBAC** - Role-Based Access Control
- **SaaS** - Software as a Service
- **SIEM** - Security Information and Event Management
- **SOAR** - Security Orchestration, Automation, and Response
- **SSO** - Single Sign-On
- **UEBA** - User and Entity Behavior Analytics
- **XDR** - Extended Detection and Response

---

*Last Updated: 2025-10-13*
*Exam Version: This fact sheet covers the current SC-900 exam objectives*
*Total Documentation Links: 80+*

---

## Next Steps

1. Complete the official Microsoft Learn learning paths for SC-900
2. Take the practice assessment to identify knowledge gaps
3. Explore each service in the Azure and Microsoft 365 portals
4. Review security and compliance documentation for your areas of weakness
5. Schedule and pass the SC-900 exam
6. Consider advanced certifications: SC-200, SC-300, AZ-500, or SC-400

Good luck with your SC-900 certification journey!