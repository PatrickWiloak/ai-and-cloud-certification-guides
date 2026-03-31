# Domain 2: Security (20%)

## Overview
This domain covers implementing security controls in cloud environments, including identity and access management, data protection, network security, and compliance. Security is the second-heaviest weighted domain and overlaps with concepts tested in troubleshooting scenarios.

## Identity and Access Management (IAM)

**[📖 NIST SP 800-63 - Digital Identity Guidelines](https://csrc.nist.gov/publications/detail/sp/800-63-3/final)** - Comprehensive identity and authentication guidance

### Authentication

**Multi-Factor Authentication (MFA):**
- Combines two or more of: something you know, something you have, something you are
- **Knowledge factor** - Passwords, PINs, security questions
- **Possession factor** - Hardware tokens, authenticator apps, SMS codes
- **Inherence factor** - Fingerprint, facial recognition, retina scan
- **Location factor** - Geofencing, IP restrictions
- Required for privileged accounts and sensitive operations

**Single Sign-On (SSO):**
- One set of credentials for multiple applications
- Reduces password fatigue and credential sprawl
- Central authentication point for policy enforcement
- Requires trust relationship between identity provider and service providers
- Protocols: SAML 2.0, OAuth 2.0, OpenID Connect (OIDC)

**Federation:**
- Trust relationships between identity providers (IdPs)
- Users authenticate with their home organization
- SAML 2.0 - XML-based, enterprise federation standard
- OIDC - Modern, JSON-based, built on OAuth 2.0
- Cross-organization access without duplicate accounts

**Certificate-Based Authentication:**
- PKI certificates for identity verification
- Mutual TLS (mTLS) for service-to-service authentication
- Smart cards and hardware tokens
- Certificate lifecycle management (issuance, renewal, revocation)

### Authorization Models

**[📖 NIST SP 800-162 - ABAC Guide](https://csrc.nist.gov/publications/detail/sp/800-162/final)** - Attribute-Based Access Control definition and considerations

**Role-Based Access Control (RBAC):**
- Access based on assigned roles within the organization
- Users assigned to roles, roles have permissions
- Simplifies management for standard organizational structures
- Example: "DBA" role has database admin permissions across all databases
- Best for: Stable organizations with well-defined job functions

**Attribute-Based Access Control (ABAC):**
- Access decisions based on attributes (user, resource, environment, action)
- Dynamic and context-aware (time of day, location, device type)
- More granular than RBAC but more complex to implement
- Example: "Allow access if user.department=finance AND resource.classification=internal AND time=business_hours"
- Best for: Complex environments requiring fine-grained, dynamic control

**Mandatory Access Control (MAC):**
- Access based on security labels and clearance levels
- System-enforced, not user-configurable
- Classification levels: Unclassified, Confidential, Secret, Top Secret
- Best for: Government and military environments

**Discretionary Access Control (DAC):**
- Resource owner controls access permissions
- Owner grants permissions to other users
- Common in file systems (read/write/execute permissions)
- Least restrictive model

### Privileged Access Management (PAM)
- Secure management of elevated/administrative accounts
- Just-in-time access - temporary elevation when needed
- Session recording and monitoring
- Password vaulting and rotation
- Break-glass procedures for emergency access

### Principle of Least Privilege
- Grant minimum permissions needed to perform job function
- Regularly review and revoke unnecessary permissions
- Use temporary credentials where possible
- Audit access patterns and remove unused permissions

## Access Controls

### Security Groups
- Virtual firewalls for cloud instances
- Stateful - return traffic automatically allowed
- Allow rules only (implicit deny)
- Applied at the instance level
- Common across AWS, Azure (NSGs), GCP (firewall rules)

### Network ACLs
- Subnet-level traffic filtering
- Stateless - must explicitly allow both inbound and outbound
- Both allow and deny rules
- Processed in order (rule number)
- Additional layer of defense beyond security groups

### API Access Controls
- API keys and tokens for programmatic access
- Rate limiting and throttling
- IP whitelisting for API endpoints
- OAuth 2.0 scopes for granular API permissions
- API gateway policies for centralized control

### Conditional Access
- Access decisions based on context (device, location, risk level)
- Device compliance checks before granting access
- Impossible travel detection
- Risk-based authentication (step-up when risk detected)
- Session management and token expiration

## Network Security

### Firewalls

**Cloud-Native Firewalls:**
- Security groups (instance-level, stateful)
- Network ACLs (subnet-level, stateless)
- Web Application Firewalls (WAF) - Layer 7 protection
- Cloud-based firewall services (AWS Network Firewall, Azure Firewall)

**Web Application Firewall (WAF):**
- Protects against OWASP Top 10 (SQL injection, XSS, CSRF)
- Custom rules for application-specific threats
- Rate limiting and bot detection
- Managed rule sets from security vendors

### Virtual Private Networks (VPN)

**Site-to-Site VPN:**
- Connects on-premises network to cloud VPC/VNet
- IPsec encrypted tunnel over public internet
- Redundant tunnels for high availability
- Cost-effective for moderate bandwidth needs

**Client-to-Site VPN (Remote Access):**
- Individual users connect to cloud network
- SSL/TLS or IPsec-based connections
- Split tunneling vs full tunneling
- Authentication integration with directory services

### Network Segmentation

**Virtual Private Cloud/Network:**
- Logically isolated network in the cloud
- Custom IP address ranges (CIDR blocks)
- Public and private subnets
- Route tables for traffic control
- Internet gateways for public access

**Micro-Segmentation:**
- Fine-grained security between workloads
- Zero trust network model - no implicit trust
- Policy enforcement at the workload level
- East-west traffic control (between services)
- Service mesh implementation (Istio, Linkerd)

### Intrusion Detection/Prevention (IDS/IPS)
- **IDS** - Detects and alerts on suspicious activity
- **IPS** - Detects and blocks suspicious activity
- Network-based and host-based variants
- Signature-based and anomaly-based detection
- Cloud provider managed services available

### DDoS Protection
- Distributed Denial of Service mitigation
- Cloud providers offer built-in basic protection
- Advanced protection tiers with SLA guarantees
- Web Application Firewall integration
- Auto-scaling can absorb some attack traffic

## Data Security

### Data Classification
- **Public** - No restrictions, freely available
- **Internal** - For organizational use only
- **Confidential** - Restricted access, business-sensitive
- **Restricted/Secret** - Highest protection level, regulatory requirements

### Encryption at Rest

**[📖 NIST SP 800-111 - Storage Encryption Guide](https://csrc.nist.gov/publications/detail/sp/800-111/final)** - Guide to storage encryption technologies

- Data encrypted when stored on disk, database, or backup
- **AES-256** - Standard symmetric encryption algorithm
- **Volume encryption** - Encrypt entire storage volumes
- **Database encryption** - Transparent Data Encryption (TDE)
- **Object storage encryption** - Server-side or client-side
- **Backup encryption** - Encrypt all backup copies

### Encryption in Transit
- Data encrypted while moving between systems
- **TLS 1.2/1.3** - Standard for HTTPS, API calls, web traffic
- **IPsec** - VPN tunnel encryption
- **SSH** - Secure remote administration
- **mTLS** - Mutual authentication between services

### Key Management

**Key Types:**
- **Provider-managed keys** - Cloud provider generates and manages keys
- **Customer-managed keys (CMK)** - Customer controls key lifecycle
- **Customer-supplied keys (CSEK)** - Customer provides the actual keys
- **Bring Your Own Key (BYOK)** - Customer generates, imports to provider

**Hardware Security Modules (HSM):**
- FIPS 140-2 Level 2 or 3 validated hardware
- Tamper-resistant key storage and cryptographic operations
- Required for some compliance standards (PCI-DSS, HIPAA)
- Cloud HSM services: AWS CloudHSM, Azure Dedicated HSM

**Key Rotation:**
- Regular replacement of encryption keys
- Automated rotation (annually or more frequently)
- Old data re-encrypted with new keys or keys maintained in rotation
- Audit trail of key usage and rotation events

### Data Loss Prevention (DLP)
- Identify and protect sensitive data (PII, PHI, financial data)
- Monitor data movement and block unauthorized transfers
- Classification-based policies and rules
- Content inspection for sensitive data patterns
- Endpoint, network, and cloud DLP

### Data Sovereignty and Residency
- Legal requirements for data physical location
- Data must stay within specific geographic boundaries
- Cloud region selection based on regulatory requirements
- Cross-border data transfer regulations (GDPR, data localization laws)

## Compliance Frameworks

**[📖 NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)** - Core cybersecurity framework

### SOC 2 (Service Organization Control)
- **Scope:** Service organizations providing technology services
- **Trust Principles:** Security, Availability, Processing Integrity, Confidentiality, Privacy
- **Type 1:** Design of controls at a point in time
- **Type 2:** Operating effectiveness over a period (typically 6-12 months)
- **Industry:** Technology, SaaS, cloud services

### ISO 27001
- **Scope:** Information security management system (ISMS)
- **Structure:** Plan-Do-Check-Act cycle
- **Controls:** Annex A - 114 controls across 14 domains
- **Certification:** Third-party audit and certification
- **Industry:** Global standard, widely recognized

### HIPAA
- **Scope:** Protected Health Information (PHI)
- **Rules:** Privacy Rule, Security Rule, Breach Notification Rule
- **Entities:** Covered entities and business associates
- **Requirements:** Administrative, physical, and technical safeguards
- **Penalties:** Fines from $100 to $1.5M per violation category
- **Industry:** Healthcare (US)

### PCI-DSS
- **Scope:** Cardholder data environment (CDE)
- **Levels:** Based on transaction volume (Level 1: 6M+, Level 4: <20K)
- **Requirements:** 12 requirements across 6 goals
- **Assessment:** Self-assessment questionnaire (SAQ) or QSA audit
- **Industry:** Payment card processing

### GDPR
- **Scope:** Personal data of EU/EEA data subjects
- **Rights:** Access, rectification, erasure, portability, restriction
- **Principles:** Lawfulness, purpose limitation, data minimization, accuracy
- **Requirements:** Data Protection Officer, Data Protection Impact Assessment
- **Penalties:** Up to 4% of global annual revenue or 20M EUR
- **Industry:** Any organization processing EU personal data

### FedRAMP
- **Scope:** Cloud services for US federal government
- **Levels:** Low, Moderate, High impact
- **Process:** Authorization through JAB or agency
- **Based on:** NIST SP 800-53 security controls
- **Industry:** US federal government cloud services

### NIST Cybersecurity Framework (CSF)
- **Functions:** Identify, Protect, Detect, Respond, Recover
- **Tiers:** Partial, Risk Informed, Repeatable, Adaptive
- **Profiles:** Current state and target state
- **Industry:** US organizations, voluntary but widely adopted

## Security Monitoring and Incident Response

### Security Information and Event Management (SIEM)
- Centralized collection of security logs and events
- Correlation rules and alerting
- Real-time monitoring and historical analysis
- Compliance reporting and audit trails
- Examples: Splunk, Azure Sentinel, AWS Security Hub

### Audit Logging
- API call logging (CloudTrail, Azure Activity Log, Cloud Audit Logs)
- User access and authentication logs
- Configuration change logs
- Data access logs
- Immutable log storage for compliance

### Vulnerability Management
- Regular vulnerability scanning
- Patch management and remediation
- Configuration compliance checking
- Penetration testing (with provider notification if required)
- Vulnerability disclosure and response procedures

### Incident Response
1. **Preparation** - Plans, procedures, tools, and training
2. **Detection** - Identify potential security incidents
3. **Analysis** - Determine scope, impact, and severity
4. **Containment** - Limit damage and prevent spread
5. **Eradication** - Remove threat and root cause
6. **Recovery** - Restore systems and verify integrity
7. **Post-Incident** - Lessons learned and process improvements

---

## Key Takeaways for the Exam

1. Know all authentication methods and when to use each (MFA, SSO, federation)
2. Understand the four access control models (RBAC, ABAC, MAC, DAC)
3. Know encryption types: at rest (AES-256), in transit (TLS), and key management options
4. Match compliance frameworks to industries (HIPAA=healthcare, PCI=payments, GDPR=EU data)
5. Understand network security layers: firewalls, security groups, NACLs, WAF
6. VPN types: site-to-site for network connectivity, client-to-site for remote users
7. Least privilege is a fundamental principle across all security domains
8. Know the incident response lifecycle stages
