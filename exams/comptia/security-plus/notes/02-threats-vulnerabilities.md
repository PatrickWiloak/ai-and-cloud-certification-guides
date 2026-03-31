# Domain 2: Threats, Vulnerabilities, and Mitigations (22%)

## Overview
This domain covers understanding threat actors, common attack techniques, vulnerability types, indicators of malicious activity, and mitigation strategies. It is the second-heaviest domain and requires knowledge of specific attack types, how to recognize them, and how to defend against them.

## Malware Types

**[📖 MITRE ATT&CK - Malware](https://attack.mitre.org/software/)** - Comprehensive malware reference database

### Ransomware
- Encrypts victim's files, demands payment for decryption key
- Often delivered via phishing emails or exploit kits
- Variants: Crypto-ransomware (encrypts files), locker ransomware (locks system)
- Double extortion: Encrypt data AND threaten to leak it
- Triple extortion: Add DDoS threat or contact victims' customers
- **Defense**: Offline backups, email filtering, endpoint protection, user training

### Trojans
- Malware disguised as legitimate software
- Requires user action to execute (download, install, open)
- Types: Remote Access Trojan (RAT), banking trojan, dropper
- Often opens backdoor for persistent access
- **Defense**: Application whitelisting, download scanning, user education

### Worms
- Self-replicating malware that spreads across networks
- Does NOT require user interaction to spread
- Exploits network vulnerabilities for propagation
- Can consume bandwidth and system resources even without payload
- **Defense**: Patch management, network segmentation, IDS/IPS

### Rootkits
- Hides deep in the operating system (kernel, bootloader, firmware)
- Modifies OS to conceal malware presence
- Extremely difficult to detect and remove
- Types: Kernel-level, bootloader, firmware/UEFI
- **Defense**: Secure boot, firmware integrity checking, reinstallation may be required

### Spyware
- Collects information without user knowledge
- Monitors browsing habits, captures credentials, records activity
- Often bundled with free software
- **Defense**: Anti-spyware tools, browser security, careful software installation

### Keyloggers
- Records keystrokes to capture passwords, credit cards, messages
- Hardware (physical device) or software-based
- May send captured data to attacker periodically
- **Defense**: Virtual keyboards, MFA (reduces impact), endpoint protection

### Remote Access Trojan (RAT)
- Provides attacker with remote control of victim's system
- Full access: files, camera, microphone, screen capture
- Often uses encrypted communication to avoid detection
- **Defense**: Network monitoring, endpoint detection, outbound filtering

### Logic Bomb
- Malicious code that triggers on a specific condition
- Conditions: Date/time, user action, file deletion, system event
- Often planted by insiders
- Dormant until trigger condition is met
- **Defense**: Code review, insider threat monitoring, separation of duties

### Fileless Malware
- Operates entirely in memory - no files written to disk
- Uses legitimate system tools (PowerShell, WMI, macros)
- Evades traditional signature-based antivirus
- Techniques: Living off the land (LOLBins), script injection, process injection
- **Defense**: Behavioral analysis, EDR, PowerShell logging, memory scanning

### Cryptominers
- Uses victim's computing resources to mine cryptocurrency
- May be delivered via malware or browser-based (cryptojacking)
- Symptoms: High CPU usage, slow performance, increased power consumption
- **Defense**: Ad blockers, endpoint protection, resource monitoring

### Botnets
- Network of compromised devices controlled by attacker (bot herder)
- Used for DDoS, spam, credential stuffing, cryptomining
- Command and Control (C2) server coordinates botnet activities
- IoT devices are common botnet targets
- **Defense**: Network monitoring, DNS sinkholing, IoT security, patching

## Attack Vectors

### Phishing Variants

**Email Phishing:**
- Mass emails impersonating trusted entities
- Goal: Steal credentials, deliver malware, initiate fraud
- Indicators: Generic greeting, urgency, suspicious links, spoofed sender

**Spear Phishing:**
- Targeted phishing at specific individuals or groups
- Uses personal information to increase credibility
- More effective than generic phishing

**Whaling:**
- Phishing targeting executives and senior leadership
- Often involves wire transfer requests or sensitive data access
- Higher potential impact due to executive privileges

**Business Email Compromise (BEC):**
- Attacker compromises or spoofs executive email account
- Requests wire transfers or sensitive information
- Often targets finance department
- May involve extensive reconnaissance before attack

**Vishing (Voice Phishing):**
- Social engineering via phone calls
- Caller impersonates IT support, bank, government agency
- May use caller ID spoofing

**Smishing (SMS Phishing):**
- Social engineering via text messages
- Often includes malicious links
- Exploits trust in SMS communications

### Network-Based Attacks

**Man-in-the-Middle (MITM/On-Path):**
- Attacker intercepts communication between two parties
- Can read, modify, and inject data into the conversation
- Types: ARP spoofing, DNS spoofing, SSL stripping
- **Defense**: TLS/SSL, certificate pinning, HSTS, encrypted protocols

**Distributed Denial of Service (DDoS):**
- Overwhelm target with traffic from multiple sources
- Types: Volumetric (bandwidth), protocol (SYN flood), application (HTTP flood)
- Amplification: DNS amplification, NTP amplification
- **Defense**: DDoS mitigation services, rate limiting, CDN, scrubbing centers

**DNS Attacks:**
- **DNS poisoning/spoofing** - Corrupt DNS cache with false entries
- **DNS tunneling** - Encode data in DNS queries to exfiltrate data
- **Domain hijacking** - Take over legitimate domain registration
- **Defense**: DNSSEC, DNS monitoring, registry locks

**ARP Poisoning:**
- Send false ARP messages to associate attacker's MAC with target's IP
- Enables MITM attack on local network
- **Defense**: Static ARP entries, Dynamic ARP Inspection (DAI), encryption

**Replay Attack:**
- Capture and re-send valid authentication data
- Intercepted token or credential used again
- **Defense**: Timestamps, nonces, session tokens with expiration

**Session Hijacking:**
- Take over authenticated session using stolen session token
- Types: Cookie theft, session fixation, cross-site scripting
- **Defense**: Secure cookies (HttpOnly, Secure, SameSite), session rotation, re-auth

**Wireless Attacks:**
- **Evil twin** - Fake access point mimicking legitimate network
- **Deauthentication** - Force clients to disconnect and reconnect
- **WPS attacks** - Exploit Wi-Fi Protected Setup weaknesses
- **Bluetooth attacks** - Bluejacking, bluesnarfing, bluebugging
- **Defense**: WPA3, 802.1X, wireless IDS, disable WPS

### Application Attacks

**SQL Injection:**
- Insert malicious SQL commands through user input
- Can read, modify, or delete database data
- Types: Classic, blind, time-based
- **Defense**: Parameterized queries/prepared statements, input validation, WAF

**Cross-Site Scripting (XSS):**
- Inject malicious scripts into web pages viewed by other users
- **Stored XSS** - Script stored in database, served to all visitors
- **Reflected XSS** - Script in URL, reflected back from server
- **DOM-based XSS** - Script manipulates page DOM in browser
- **Defense**: Input validation, output encoding, Content Security Policy (CSP)

**Cross-Site Request Forgery (CSRF):**
- Force authenticated user to perform unwanted actions
- Exploits the trust a site has in the user's browser
- **Defense**: Anti-CSRF tokens, SameSite cookies, re-authentication for sensitive actions

**Buffer Overflow:**
- Write data beyond allocated memory buffer
- Can crash application or execute arbitrary code
- **Defense**: Input validation, bounds checking, ASLR, DEP/NX bit, stack canaries

**Directory/Path Traversal:**
- Access files outside intended directory using `../` sequences
- Can read sensitive system files
- **Defense**: Input sanitization, chroot jails, proper file permissions

**XML External Entity (XXE):**
- Exploit XML parser to read files, SSRF, or DoS
- **Defense**: Disable external entity processing, input validation

**Server-Side Request Forgery (SSRF):**
- Trick server into making requests to internal resources
- Access internal services not directly accessible
- **Defense**: Input validation, network segmentation, URL whitelisting

### Supply Chain Attacks
- Compromise software vendor or supplier to reach downstream targets
- Methods: Compromised updates, infected development tools, backdoored libraries
- Affects many organizations through trusted software channels
- Examples: SolarWinds, Codecov, Event-Stream
- **Defense**: Software composition analysis, vendor assessment, code signing verification

### Password Attacks
| Attack | Method | Defense |
|--------|--------|---------|
| **Brute force** | Try all possible combinations | Account lockout, complexity, MFA |
| **Dictionary** | Try common words/passwords | Complex passwords, MFA |
| **Credential stuffing** | Use leaked username/password pairs | Unique passwords, MFA |
| **Password spraying** | Try one password across many accounts | Lockout policies, MFA |
| **Rainbow table** | Pre-computed hash lookup | Salted hashes (bcrypt, Argon2) |
| **Pass-the-hash** | Use captured hash directly | Kerberos, credential guard |

## Vulnerability Types

### Software Vulnerabilities
- **Zero-day** - Unknown to vendor, no patch available
- **Unpatched** - Known vulnerability, patch not applied
- **Memory-related** - Buffer overflow, memory leak, use-after-free
- **Race condition** - Timing-dependent vulnerability
- **Improper error handling** - Error messages reveal system info
- **Insecure API** - Missing authentication, injection flaws

### Configuration Vulnerabilities
- **Default credentials** - Factory passwords not changed
- **Open ports and services** - Unnecessary services running
- **Permissive permissions** - Overly broad access rights
- **Missing encryption** - Data transmitted or stored in cleartext
- **Misconfigured cloud storage** - Public S3 buckets, blob access
- **Missing security headers** - HSTS, CSP, X-Frame-Options

### Hardware Vulnerabilities
- **Firmware** - Outdated firmware with known exploits
- **Side-channel attacks** - Spectre, Meltdown (CPU cache timing)
- **End-of-life hardware** - No longer receiving security updates
- **Physical access** - Unprotected hardware ports, missing encryption

### Human Vulnerabilities
- **Social engineering susceptibility** - Lack of security awareness
- **Poor password practices** - Reuse, simple passwords, sharing
- **Phishing susceptibility** - Clicking malicious links
- **Shadow IT** - Using unauthorized tools and services
- **Insider negligence** - Accidental data exposure

## Indicators of Malicious Activity

### Indicators of Compromise (IoCs)
- Unusual outbound network traffic
- DNS requests to suspicious domains
- Anomalous privileged user activity
- Geographic irregularities in login locations
- Unexpected registry or file system changes
- Unknown processes or services running
- Web traffic with unusual encoded data
- Signs of DDoS (traffic spikes from many sources)

### Indicators of Attack (IoAs)
- Focus on attacker's intent and behavior, not just artifacts
- Internal reconnaissance activity (port scanning, enumeration)
- Lateral movement between systems
- Command and control communication patterns
- Privilege escalation attempts
- Data staging and exfiltration preparation

## MITRE ATT&CK Framework

**[📖 MITRE ATT&CK](https://attack.mitre.org/)** - Full framework documentation

### Tactics (What attackers want to achieve)
1. **Reconnaissance** - Gather information about target
2. **Resource Development** - Prepare attack infrastructure
3. **Initial Access** - Gain entry to the target
4. **Execution** - Run malicious code
5. **Persistence** - Maintain access across restarts
6. **Privilege Escalation** - Gain higher-level permissions
7. **Defense Evasion** - Avoid detection
8. **Credential Access** - Steal credentials
9. **Discovery** - Learn about the environment
10. **Lateral Movement** - Move through the network
11. **Collection** - Gather target data
12. **Command and Control (C2)** - Communicate with compromised systems
13. **Exfiltration** - Steal data from the target
14. **Impact** - Disrupt, destroy, or manipulate systems

### Cyber Kill Chain (Lockheed Martin)
1. **Reconnaissance** - Research target
2. **Weaponization** - Create exploit/payload
3. **Delivery** - Transmit to target (email, web, USB)
4. **Exploitation** - Trigger the vulnerability
5. **Installation** - Install malware/backdoor
6. **Command and Control** - Establish remote control
7. **Actions on Objectives** - Achieve goal (exfiltrate, destroy)

## Mitigation Techniques

### Network Mitigations
- Firewall rules and segmentation
- IDS/IPS deployment
- Network access control (802.1X)
- DNS filtering and sinkholing
- Traffic encryption (TLS, VPN)

### Endpoint Mitigations
- Endpoint Detection and Response (EDR)
- Application whitelisting
- Host-based firewall
- Patch management
- Full disk encryption
- Disable unused ports and services

### Application Mitigations
- Secure coding practices
- Input validation and output encoding
- Web application firewall (WAF)
- Regular penetration testing
- Code review and static/dynamic analysis

### Identity Mitigations
- Multi-factor authentication
- Privileged access management
- Password policies and complexity
- Account lockout after failed attempts
- Regular access reviews

### Data Mitigations
- Encryption at rest and in transit
- Data Loss Prevention (DLP)
- Data classification and labeling
- Backup and recovery procedures
- Secure data disposal

### Hardening
- Remove unnecessary software and services
- Disable unused accounts and ports
- Apply security baselines (CIS Benchmarks, DISA STIGs)
- Keep systems patched and up to date
- Change default passwords and settings
- Enable logging and monitoring

---

## Key Takeaways for the Exam

1. Know all malware types and how they differ (especially worm vs trojan - worm self-replicates)
2. Understand social engineering principles (authority, urgency, scarcity)
3. Know application attacks and their specific defenses (SQLi = parameterized queries)
4. Differentiate between IoCs (what happened) and IoAs (what's happening)
5. Know MITRE ATT&CK tactics at a high level
6. Understand the cyber kill chain stages
7. Match attacks to appropriate mitigation techniques
8. Know vulnerability types: software, configuration, hardware, human
