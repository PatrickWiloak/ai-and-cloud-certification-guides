# CompTIA Security+ (SY0-701) - High-Yield Scenarios and Patterns

## Threat and Attack Scenarios

### Phishing Attack Response
**Scenario**: An employee reports receiving an email that appears to be from the CEO requesting an urgent wire transfer. The email address looks similar but uses a slightly different domain.

**Analysis**:
- **Attack type**: Business email compromise (BEC) / spear phishing / whaling
- **Indicators**: Urgency, unusual request, look-alike domain, bypasses normal process
- **Social engineering principle**: Authority (CEO impersonation) + urgency

**Response**:
- Do not execute the wire transfer
- Report to security team and IT helpdesk
- Verify request through out-of-band communication (phone call to CEO)
- Block the sender domain in email gateway
- Alert all employees about the attempted attack
- Review email filtering rules for look-alike domains

**Prevention**:
- Security awareness training on BEC attacks
- Email authentication (SPF, DKIM, DMARC)
- Verification policy for financial transactions
- Advanced email filtering for impersonation detection

### Ransomware Incident
**Scenario**: Multiple users report they cannot access their files. A ransom note appears demanding cryptocurrency payment. File extensions have changed to `.encrypted`.

**Analysis**:
- **Attack type**: Ransomware
- **Impact**: Data availability and potentially confidentiality
- **Urgency**: Contain immediately to prevent lateral spread

**Response (IR Lifecycle)**:
1. **Containment**: Isolate affected systems from the network immediately
2. **Assessment**: Determine scope - how many systems, which data affected
3. **Investigation**: Identify ransomware variant and initial infection vector
4. **Decision**: Restore from backups (preferred) or evaluate other options
5. **Eradication**: Remove malware, patch vulnerability used for entry
6. **Recovery**: Restore data from clean backups, rebuild affected systems
7. **Post-incident**: Update AV signatures, patch systems, improve training

**Key Decisions**:
- Do NOT pay the ransom (no guarantee of decryption, funds criminal activity)
- Restore from offline/immutable backups
- Report to law enforcement (FBI IC3, local authorities)
- Notify affected parties per regulatory requirements

### DDoS Attack Mitigation
**Scenario**: A company's website becomes unresponsive. Monitoring shows traffic has spiked to 100x normal levels from thousands of IP addresses worldwide.

**Analysis**:
- **Attack type**: Distributed Denial of Service (DDoS)
- **Impact**: Availability - legitimate users cannot access services
- **CIA affected**: Availability

**Response**:
- Activate DDoS mitigation service (cloud-based scrubbing)
- Enable rate limiting on edge devices
- Block traffic from known malicious IP ranges
- Enable CDN to absorb traffic
- Contact ISP for upstream filtering if needed
- Monitor for secondary attacks during the distraction

**Prevention**:
- DDoS protection service subscription
- CDN with DDoS mitigation capabilities
- Rate limiting and geo-blocking rules
- Auto-scaling to absorb traffic spikes
- Incident response plan specific to DDoS

### Insider Threat Detection
**Scenario**: Security monitoring detects an employee downloading large amounts of sensitive data to a USB drive after hours. The employee recently gave two weeks notice.

**Analysis**:
- **Threat type**: Insider threat - potential data exfiltration
- **Motivation**: Possibly taking proprietary data to new employer
- **Risk indicators**: Departing employee, after-hours access, bulk download, removable media

**Response**:
1. Preserve evidence - log files, SIEM alerts, USB access logs
2. Notify management and legal/HR
3. Review what data was accessed and copied
4. Consider immediately revoking access (with HR/legal approval)
5. Forensic imaging of the employee's workstation
6. Review employee's recent access patterns

**Prevention**:
- Data Loss Prevention (DLP) - block sensitive data to USB
- USB port restrictions via endpoint management
- User behavior analytics (UBA/UEBA) for anomaly detection
- Offboarding procedures - access revocation checklist
- Non-disclosure agreements and exit interviews

## Security Architecture Scenarios

### Network Segmentation Design
**Scenario**: A healthcare organization needs to design a network that separates patient records, medical devices, guest WiFi, and administrative systems.

**Solution Pattern**:
- **Patient records**: Isolated VLAN with strict access controls, encrypted data
- **Medical devices (IoT)**: Separate VLAN with micro-segmentation, limited internet access
- **Guest WiFi**: Isolated network with no access to internal resources
- **Administrative**: Corporate VLAN with standard security controls
- **DMZ**: Web servers and external-facing services

**Security Controls**:
- NGFW between all segments with deny-by-default policies
- NAC for device authentication before network access
- IDS/IPS monitoring between segments
- 802.1X for wired and wireless authentication
- Compliance: HIPAA-compliant segmentation of PHI systems

**Common Distractors**:
- Flat network (wrong - no segmentation violates HIPAA)
- Guest WiFi on same VLAN as medical devices (wrong - IoT security risk)
- Firewall only at perimeter (wrong - no internal segmentation)

### Zero Trust Implementation
**Scenario**: A company with remote workers needs to replace their VPN-based access model with a zero trust architecture.

**Solution Pattern**:
- **Identity verification**: MFA for all users, every access request
- **Device trust**: Device compliance check before granting access
- **Micro-segmentation**: Application-level access, not network-level
- **Least privilege**: Minimum required access, just-in-time elevation
- **Continuous monitoring**: Session behavior monitoring and re-authentication
- **ZTNA**: Zero Trust Network Access replacing VPN

**Implementation Steps**:
1. Identify all resources and access patterns
2. Implement strong identity verification (MFA, SSO)
3. Deploy ZTNA solution for application access
4. Implement device posture assessment
5. Apply micro-segmentation policies
6. Enable continuous monitoring and analytics
7. Gradually decommission VPN

**Common Distractors**:
- VPN with MFA only (wrong - still network-level trust, not zero trust)
- Firewall rules alone (wrong - perimeter-based, not identity-based)
- One-time authentication (wrong - zero trust requires continuous verification)

### Secure Web Application
**Scenario**: A company is deploying a web application that processes credit card payments. They need to ensure PCI-DSS compliance.

**Solution Pattern**:
- **WAF**: Protect against OWASP Top 10 (SQLi, XSS, CSRF)
- **TLS 1.2+**: Encrypt all traffic in transit
- **Network segmentation**: Isolate cardholder data environment (CDE)
- **Input validation**: Parameterized queries, output encoding
- **Access control**: MFA for admin access, RBAC for users
- **Logging**: Comprehensive audit logging (PCI requirement)
- **Vulnerability scanning**: Regular internal and external scans (ASV)

**PCI-DSS Requirements (Key Ones)**:
- Maintain a firewall configuration
- Do not use vendor-supplied defaults
- Protect stored cardholder data (encryption)
- Encrypt transmission of cardholder data
- Maintain vulnerability management program
- Implement strong access control measures

## Security Operations Scenarios

### SIEM Alert Investigation
**Scenario**: The SIEM generates an alert for multiple failed login attempts followed by a successful login from an unusual geographic location for a privileged account.

**Analysis**:
- **Pattern**: Brute force attack followed by potential compromise
- **Risk level**: High - privileged account, unusual location
- **Indicators**: Multiple failures + success + anomalous location = likely compromise

**Investigation Steps**:
1. Verify the alert - review raw logs for accuracy
2. Check if the user is traveling (could be legitimate)
3. Review what actions were taken after the successful login
4. Check for impossible travel (login from two distant locations in short time)
5. Determine if any lateral movement occurred
6. Check other accounts for similar patterns

**Response**:
- Force password reset for the account
- Disable the account if compromise is confirmed
- Review and revoke any changes made during the session
- Check for persistence mechanisms (new accounts, backdoors)
- Implement conditional access policies to prevent future occurrence

### Vulnerability Management Prioritization
**Scenario**: A vulnerability scan returns 500 findings. Resources are limited and not all can be remediated immediately. How do you prioritize?

**Prioritization Framework**:
1. **CVSS score** - Critical (9.0+) and High (7.0-8.9) first
2. **Exploitability** - Known exploits in the wild get highest priority
3. **Asset value** - Vulnerabilities on critical systems first
4. **Exposure** - Internet-facing systems before internal
5. **Regulatory impact** - Compliance violations before best-practice issues

**Response by Priority**:
| Priority | Criteria | Timeline |
|----------|----------|----------|
| P1 | Critical CVSS + known exploit + internet-facing | 24-48 hours |
| P2 | High CVSS + critical asset | 1 week |
| P3 | Medium CVSS + standard systems | 30 days |
| P4 | Low CVSS + internal systems | Next cycle |

### Forensic Investigation
**Scenario**: A server suspected of being compromised needs forensic analysis. What is the correct evidence collection order?

**Order of Volatility (Most Volatile First)**:
1. **CPU registers and cache** - Lost immediately when powered off
2. **RAM/memory** - Active processes, network connections, encryption keys
3. **Swap space/temp files** - Virtual memory on disk
4. **Disk data** - File system, logs, user data
5. **Remote logging data** - SIEM, syslog servers
6. **Physical configuration** - Network topology, device layout
7. **Archival media** - Backups, tape archives

**Key Procedures**:
- Use write blockers when imaging drives
- Create forensic images (bit-for-bit copies)
- Hash original and copy to verify integrity (SHA-256)
- Document chain of custody for every piece of evidence
- Work on forensic copies, never the original
- Take photos and notes throughout the process

## Governance and Risk Scenarios

### Risk Assessment
**Scenario**: A company needs to assess the risk of their customer database being breached.

**Quantitative Analysis**:
- **Asset Value (AV)**: $2,000,000 (customer database)
- **Exposure Factor (EF)**: 50% (estimated damage from breach)
- **Single Loss Expectancy (SLE)**: AV x EF = $1,000,000
- **Annual Rate of Occurrence (ARO)**: 0.1 (once every 10 years)
- **Annualized Loss Expectancy (ALE)**: SLE x ARO = $100,000/year

**Risk Response**: Invest up to $100,000/year in controls to mitigate the risk

**Qualitative Analysis**:
- **Likelihood**: Medium (based on industry data and current controls)
- **Impact**: High (regulatory fines, reputation damage, customer loss)
- **Risk Level**: High (requires mitigation)

### Third-Party Risk Assessment
**Scenario**: A company is evaluating a cloud provider to host customer data. What should they assess?

**Assessment Areas**:
1. **Security certifications** - SOC 2 Type II, ISO 27001
2. **Data handling** - Encryption, access controls, data residency
3. **Incident response** - Breach notification procedures and timeline
4. **Business continuity** - DR capabilities, SLA guarantees
5. **Compliance** - Meets relevant regulatory requirements (GDPR, HIPAA)
6. **Right to audit** - Can you audit their security controls?
7. **Exit strategy** - Data portability and contract termination process
8. **Supply chain** - Their third-party dependencies

**Documents to Request**:
- SOC 2 Type II report
- Penetration test results (executive summary)
- Business continuity/DR plan
- Data processing agreement
- Security policy documentation
- Incident response plan

### Security Awareness Program
**Scenario**: After multiple successful phishing attacks, management asks for a security awareness program.

**Program Components**:
1. **Baseline assessment** - Phishing simulation to measure current awareness
2. **Training** - Interactive modules on common threats
3. **Phishing simulations** - Regular, ongoing simulated phishing campaigns
4. **Metrics tracking** - Click rates, report rates, completion rates
5. **Role-specific training** - Targeted training for high-risk roles
6. **Continuous reinforcement** - Posters, newsletters, security tips
7. **Gamification** - Rewards for reporting, competitions between teams

**Success Metrics**:
- Phishing simulation click rate decreasing over time
- Increase in reported suspicious emails
- Reduction in actual security incidents
- Training completion rates > 95%

---

## Scenario Analysis Framework

When approaching Security+ scenarios:

1. **Identify the threat/risk** - What is happening or could happen?
2. **Determine the impact** - Which CIA principle is affected?
3. **Select appropriate controls** - Technical, administrative, or physical
4. **Consider compliance** - Are there regulatory requirements?
5. **Choose the best answer** - Most effective control that addresses the specific scenario

### Common Exam Keywords and Their Meaning
| Keyword | Points To |
|---------|-----------|
| "Prevent unauthorized access" | Authentication, access controls, encryption |
| "Detect intrusion" | IDS, SIEM, log monitoring, threat hunting |
| "Protect data" | Encryption, DLP, access controls, classification |
| "Compliance requirement" | Match to specific regulation |
| "Least privilege" | RBAC, just-in-time access, regular reviews |
| "Incident occurred" | Follow IR lifecycle, contain first |
| "Evidence collection" | Order of volatility, chain of custody |
| "Risk assessment" | Identify threats, vulnerabilities, impact |
