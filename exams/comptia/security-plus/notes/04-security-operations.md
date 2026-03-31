# Domain 4: Security Operations (28%)

## Overview
This is the heaviest domain on the exam, covering security monitoring, incident response, digital forensics, log analysis, vulnerability management, penetration testing, and identity and access management. Allocate extra study time here.

## Security Monitoring and SIEM

**[📖 NIST SP 800-92 - Log Management Guide](https://csrc.nist.gov/publications/detail/sp/800-92/final)** - Guide to computer security log management

### SIEM (Security Information and Event Management)

**Core Functions:**
- Log collection from multiple sources (firewalls, servers, applications, endpoints)
- Event correlation - link related events across sources
- Real-time alerting on suspicious patterns
- Historical log analysis and searching
- Dashboard visualization and reporting
- Compliance reporting and audit support

**Log Sources:**
- Firewalls and network devices
- IDS/IPS alerts
- Endpoint protection platforms
- Authentication systems (Active Directory, LDAP)
- Cloud provider audit logs (CloudTrail, Activity Log)
- Web servers and application logs
- DNS and DHCP logs
- Email gateway logs

**Alert Types:**
- **True positive** - Correctly identified real threat
- **False positive** - Alert triggered but no actual threat
- **True negative** - Correctly identified no threat
- **False negative** - Missed actual threat (most dangerous)

**Alert Triage Process:**
1. Receive and acknowledge alert
2. Validate - is it a true positive?
3. Assess severity and scope
4. Escalate or investigate based on severity
5. Document findings and actions

### SOAR (Security Orchestration, Automation, and Response)
- Automates repetitive security tasks
- Playbooks define automated response procedures
- Integrates with SIEM, ticketing, threat intel platforms
- Reduces mean time to detect (MTTD) and respond (MTTR)

**Example Playbook:**
1. SIEM detects multiple failed logins
2. SOAR automatically blocks source IP
3. Creates ticket for analyst review
4. Enriches alert with threat intelligence
5. Notifies security team

### Threat Intelligence
- **Tactical** - IoCs, malware signatures, IP addresses (immediate use)
- **Operational** - TTPs, campaign details, threat actor profiles (days/weeks)
- **Strategic** - Trends, motivations, geopolitical context (long-term planning)

**Sources:**
- OSINT (Open Source Intelligence) - public data, social media
- Commercial feeds - vendor threat intelligence
- ISACs (Information Sharing and Analysis Centers) - industry-specific
- Government sources - CISA, FBI, NSA advisories
- Dark web monitoring

### Threat Hunting
- Proactive search for threats not detected by automated tools
- Hypothesis-driven investigation
- Uses threat intelligence to guide searches
- Examines logs, network traffic, and endpoint data
- Identifies advanced persistent threats (APTs)

## Incident Response

**[📖 NIST SP 800-61 - Incident Handling Guide](https://csrc.nist.gov/publications/detail/sp/800-61/rev-2/final)** - Computer security incident handling guide

### IR Lifecycle (NIST)

**Phase 1: Preparation**
- Develop incident response plan (IRP)
- Define roles and responsibilities (IR team, CSIRT)
- Establish communication channels and escalation procedures
- Prepare tools and resources (forensic kits, sandboxes)
- Train personnel through exercises and simulations
- Establish relationships (legal, law enforcement, PR)

**Phase 2: Detection and Analysis**
- Monitor alerts from SIEM, IDS/IPS, endpoints
- Identify indicators of compromise (IoCs)
- Determine incident scope, severity, and impact
- Classify the incident (malware, unauthorized access, DoS, etc.)
- Document all findings with timestamps
- Prioritize based on business impact

**Phase 3: Containment, Eradication, and Recovery**

*Containment:*
- Short-term: Isolate affected systems (disconnect network)
- Long-term: Apply temporary fixes while maintaining evidence
- Decision: Shut down vs keep running (depends on evidence needs)

*Eradication:*
- Remove malware and artifacts
- Patch exploited vulnerability
- Reset compromised credentials
- Remove persistence mechanisms (backdoors, new accounts)

*Recovery:*
- Restore systems from clean backups
- Rebuild compromised systems
- Verify system integrity before returning to production
- Monitor closely for signs of re-compromise
- Gradually restore service in controlled manner

**Phase 4: Post-Incident Activity**
- Lessons learned meeting (within 1-2 weeks)
- Document timeline and root cause analysis
- Update IR plan based on findings
- Improve detection and prevention controls
- Provide management report
- Retain evidence per retention policy

### Incident Classification

| Severity | Description | Response Time | Example |
|----------|-------------|---------------|---------|
| **Critical (P1)** | Active data breach, ransomware | Immediate | Active attacker in network |
| **High (P2)** | Compromised account, malware | 1-4 hours | Successful phishing |
| **Medium (P3)** | Vulnerability exploitation attempt | 4-24 hours | Blocked attack |
| **Low (P4)** | Policy violation, recon activity | Next business day | Port scan |

### Communication During Incidents
- Internal: IR team, management, legal, HR, communications
- External: Law enforcement, regulators, customers, media (if required)
- Regulatory: Breach notification requirements (GDPR: 72 hours, HIPAA: 60 days)
- Maintain communication log with timestamps

## Digital Forensics

**[📖 NIST SP 800-86 - Forensic Techniques Guide](https://csrc.nist.gov/publications/detail/sp/800-86/final)** - Guide to integrating forensic techniques

### Forensic Process
1. **Identification** - Determine what evidence exists and where
2. **Preservation** - Protect evidence from modification or destruction
3. **Collection** - Gather evidence using forensic methods
4. **Examination** - Process and analyze collected data
5. **Analysis** - Interpret findings in context of the incident
6. **Reporting** - Document findings and present conclusions

### Order of Volatility (Most to Least Volatile)
1. **CPU registers and cache** - Lost immediately on power off
2. **Memory (RAM)** - Active processes, network connections, encryption keys
3. **Swap space / page file** - Virtual memory on disk
4. **Hard drive data** - File system, logs, user data
5. **Remote logging data** - SIEM, syslog server
6. **Physical configuration** - Network topology
7. **Archival media** - Backups, tape storage

**Key Principle**: Collect most volatile evidence first

### Evidence Handling

**Chain of Custody:**
- Document who collected evidence, when, where, and how
- Track every transfer of evidence between people
- Record storage conditions and access
- Maintain integrity from collection through legal proceedings
- Break in chain can invalidate evidence in court

**Forensic Imaging:**
- Create bit-for-bit copy of storage media
- Use write blockers to prevent modification of original
- Verify image integrity with hash comparison (SHA-256)
- Work only on forensic copy, never the original
- Tools: FTK Imager, dd, EnCase

**Evidence Types:**
- **Direct evidence** - Proves fact directly (log showing access)
- **Circumstantial** - Implies but doesn't prove (location near incident)
- **Corroborating** - Supports other evidence
- **Documentary** - Written records, logs, policies

### Legal Considerations
- **Legal hold** - Preserve all potentially relevant data
- **e-Discovery** - Electronic discovery for legal proceedings
- **Jurisdiction** - Where incident occurred vs where data is stored
- **Privacy** - Employee privacy vs investigation needs
- **Admissibility** - Evidence must be properly collected and documented

## Log Analysis

### Important Log Types
| Log Type | Contains | Used For |
|----------|----------|----------|
| **Authentication** | Login success/failure, MFA events | Unauthorized access detection |
| **Firewall** | Allow/deny decisions, source/dest | Network attack detection |
| **DNS** | Query and response records | Tunneling, C2 detection |
| **Web server** | HTTP requests, status codes, user agents | Web attack detection |
| **Proxy** | URL requests, categories, blocks | Shadow IT, data exfiltration |
| **Email** | Sender, recipient, subject, attachments | Phishing detection |
| **Endpoint** | Process execution, file changes, registry | Malware detection |
| **Cloud audit** | API calls, configuration changes | Unauthorized changes |

### Log Analysis Techniques
- **Pattern matching** - Search for known attack signatures
- **Anomaly detection** - Identify deviations from baseline
- **Correlation** - Link events across multiple log sources
- **Timeline analysis** - Reconstruct sequence of events
- **Statistical analysis** - Identify unusual volumes or frequencies
- **User behavior analytics** - Detect anomalous user activity

### Common Indicators in Logs
- Multiple failed logins followed by success = brute force
- DNS queries to unusual domains = potential C2 communication
- Large outbound data transfers = potential exfiltration
- Login from unusual location/time = potential compromise
- Privilege escalation events = potential attack progression
- New scheduled tasks or services = potential persistence

## Vulnerability Management

### Vulnerability Management Lifecycle
1. **Asset discovery** - Identify all systems in scope
2. **Vulnerability scanning** - Automated scanning for known vulnerabilities
3. **Analysis and prioritization** - Rank by risk (CVSS + business context)
4. **Remediation** - Patch, reconfigure, or mitigate
5. **Verification** - Rescan to confirm fix
6. **Reporting** - Document findings and remediation status
7. **Repeat** - Continuous cycle

### Scanning Types
- **Credentialed** - Authenticated scan with system access (more thorough)
- **Non-credentialed** - External scan without authentication (attacker's view)
- **Internal** - Scan from inside the network
- **External** - Scan from outside the network (public-facing)
- **Active** - Send probes to targets (may cause disruption)
- **Passive** - Monitor traffic without sending probes (non-disruptive)

### CVSS (Common Vulnerability Scoring System)
- Industry standard for rating vulnerability severity
- Score range: 0.0 (none) to 10.0 (critical)
- **Base metrics** - Inherent characteristics (attack vector, complexity, impact)
- **Temporal metrics** - Change over time (exploit availability, patch status)
- **Environmental metrics** - Organization-specific context

### CVE (Common Vulnerabilities and Exposures)
- Unique identifier for known vulnerabilities (CVE-YYYY-NNNNN)
- Public database maintained by MITRE
- Referenced in vendor advisories and scanning tools

## Penetration Testing

### Penetration Testing Types
| Type | Description | Knowledge |
|------|-------------|-----------|
| **Black box** | No prior knowledge of target | External attacker perspective |
| **White box** | Full knowledge of target | Complete transparency |
| **Gray box** | Partial knowledge of target | Insider or partial access |

### Testing Phases
1. **Planning/Scoping** - Define scope, rules of engagement, authorization
2. **Reconnaissance** - Gather information (passive and active)
3. **Scanning/Enumeration** - Identify live systems, ports, services
4. **Exploitation** - Attempt to exploit vulnerabilities
5. **Post-exploitation** - Lateral movement, privilege escalation, persistence
6. **Reporting** - Document findings, evidence, recommendations

### Rules of Engagement
- Written authorization from asset owner (GET THIS IN WRITING)
- Define scope (in-scope and out-of-scope systems)
- Define timeframe and testing windows
- Emergency contact information
- Data handling and confidentiality requirements
- Restrictions (no DoS, no social engineering, etc.)

### Types of Testing
- **Network penetration test** - Infrastructure and network devices
- **Web application test** - OWASP testing guide
- **Social engineering test** - Phishing campaigns, physical access
- **Wireless test** - Wi-Fi security assessment
- **Physical test** - Physical security controls
- **Red team** - Full-scope, adversary simulation
- **Blue team** - Defensive security testing
- **Purple team** - Collaborative red + blue team

## Identity and Access Management

### Authentication Methods

**Password-Based:**
- Password complexity requirements (length, special characters)
- Password history and reuse prevention
- Account lockout after failed attempts
- Password managers for unique passwords
- Passwordless alternatives gaining adoption

**Multi-Factor Authentication (MFA):**
- Combines multiple authentication factor types
- TOTP (Time-based One-Time Password) - authenticator apps
- FIDO2/WebAuthn - hardware security keys
- Push notifications - approve/deny on trusted device
- SMS/email codes (weaker, susceptible to SIM swap)

**Biometrics:**
- Fingerprint, facial recognition, iris scan
- False Acceptance Rate (FAR) - unauthorized person accepted
- False Rejection Rate (FRR) - authorized person rejected
- Crossover Error Rate (CER) - optimal balance point

**Certificate-Based:**
- PKI certificates for user/device authentication
- Smart cards with embedded certificates
- Mutual TLS (mTLS) for service authentication

### Single Sign-On (SSO) and Federation

**SAML (Security Assertion Markup Language):**
- XML-based protocol for enterprise SSO
- Identity Provider (IdP) authenticates user
- Service Provider (SP) receives SAML assertion
- Common in enterprise web applications

**OAuth 2.0:**
- Authorization framework (NOT authentication)
- Grants limited access to resources
- Access tokens and refresh tokens
- Scopes define permission boundaries

**OpenID Connect (OIDC):**
- Authentication layer built on OAuth 2.0
- ID token contains user identity claims
- Standard for modern web and mobile authentication
- JWT (JSON Web Token) format

**Kerberos:**
- Ticket-based authentication protocol
- Key Distribution Center (KDC) issues tickets
- Ticket Granting Ticket (TGT) for session authentication
- Used in Active Directory environments
- Port 88

### Account Management
- **Provisioning** - Create accounts with appropriate access
- **Review** - Regular access reviews and recertification
- **De-provisioning** - Disable/remove accounts when no longer needed
- **Service accounts** - Manage and rotate credentials
- **Shared accounts** - Avoid or implement strict controls
- **Guest accounts** - Limited access, time-restricted

### Privileged Access Management (PAM)
- Secure management of administrative accounts
- Password vaulting and rotation
- Session recording and monitoring
- Just-in-time (JIT) access - temporary elevation
- Approval workflows for elevated access
- Break-glass accounts for emergencies

---

## Key Takeaways for the Exam

1. Know SIEM functions: log collection, correlation, alerting, reporting
2. IR lifecycle: Preparation -> Detection -> Containment/Eradication/Recovery -> Post-Incident
3. Order of volatility: registers -> RAM -> swap -> disk -> logs -> archives
4. Chain of custody must be maintained for evidence admissibility
5. Vulnerability management is a continuous cycle, not a one-time activity
6. Pen test types: black box (no knowledge), white box (full knowledge), gray box (partial)
7. Know authentication protocols: SAML (federation), OAuth (authorization), OIDC (authentication)
8. MFA requires different factor TYPES - two passwords is NOT MFA
