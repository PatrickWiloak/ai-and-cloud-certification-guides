---
last-updated: 2026-05-03
---

# CompTIA CySA+ (CS0-003) Fact Sheet

## Quick Reference

**Exam Code:** CS0-003
**Duration:** 165 minutes
**Questions:** Up to 85 (MCQ + performance-based)
**Passing Score:** 750/900
**Cost:** $404 USD
**Validity:** 3 years
**Delivery:** Pearson VUE (testing center or online proctored)

## Exam Domain Breakdown

| Domain | Weight | Focus |
|--------|--------|-------|
| Security Operations | 33% | Logs, IoCs, network analysis, threat intel, threat hunting, MITRE ATT&CK |
| Vulnerability Management | 30% | Scanning, CVSS, prioritization, validation, controls, response |
| Incident Response and Management | 20% | NIST 800-61 lifecycle, evidence handling, forensics, RCA |
| Reporting and Communication | 17% | Vuln/incident reports, metrics, stakeholder comms, ticketing |

**Documentation:**
- **[CompTIA CySA+ Objectives](https://www.comptia.org/certifications/cybersecurity-analyst#examdetails)** - Official exam objectives
- **[NIST SP 800-61r2](https://csrc.nist.gov/publications/detail/sp/800-61/rev-2/final)** - Computer security incident handling
- **[NIST SP 800-150](https://csrc.nist.gov/publications/detail/sp/800-150/final)** - Cyber threat information sharing

## Attack Methodology Frameworks

### MITRE ATT&CK Tactics (Enterprise Matrix)

| ID | Tactic | Goal |
|----|--------|------|
| TA0043 | Reconnaissance | Gather info to plan ops |
| TA0042 | Resource Development | Acquire infrastructure (domains, accounts) |
| TA0001 | Initial Access | Get foothold (phishing, exploit) |
| TA0002 | Execution | Run code on victim |
| TA0003 | Persistence | Maintain access across reboots |
| TA0004 | Privilege Escalation | Gain higher permissions |
| TA0005 | Defense Evasion | Avoid detection (obfuscation, log clearing) |
| TA0006 | Credential Access | Steal credentials |
| TA0007 | Discovery | Internal recon |
| TA0008 | Lateral Movement | Pivot to other systems |
| TA0009 | Collection | Gather data of interest |
| TA0011 | Command and Control | Communicate with compromised systems |
| TA0010 | Exfiltration | Steal data |
| TA0040 | Impact | Disrupt, destroy, encrypt |

### High-Yield ATT&CK Techniques to Memorize

| ID | Technique | Domain Indicator |
|----|-----------|------------------|
| T1566 | Phishing | Email gateway logs, attachment detonation |
| T1059 | Command and Scripting Interpreter | PowerShell, cmd.exe, bash, wscript |
| T1059.001 | PowerShell | EncodedCommand, Invoke-Expression, IEX |
| T1078 | Valid Accounts | Auth logs, impossible travel |
| T1003 | OS Credential Dumping | LSASS access, Mimikatz signatures |
| T1003.001 | LSASS Memory | Process accessing lsass.exe with READ |
| T1486 | Data Encrypted for Impact | Mass file rename + extension change |
| T1055 | Process Injection | Cross-process VirtualAllocEx, WriteProcessMemory |
| T1021 | Remote Services | RDP, SMB, WinRM lateral movement |
| T1021.001 | RDP | TCP 3389, EventID 4624 type 10 |
| T1071 | Application Layer Protocol (C2) | Beaconing patterns over HTTPS/DNS |
| T1071.004 | DNS | High-entropy subdomain queries, TXT records |
| T1547.001 | Registry Run Keys / Startup Folder | HKCU\Software\Microsoft\Windows\CurrentVersion\Run |
| T1053.005 | Scheduled Task | schtasks.exe creation events |
| T1190 | Exploit Public-Facing Application | WAF logs, web server 500/error spikes |
| T1110 | Brute Force | Failed auth log spikes |
| T1110.003 | Password Spraying | Many users, few attempts each |
| T1041 | Exfiltration Over C2 | Outbound data volume spikes |
| T1567 | Exfiltration to Cloud Storage | Uploads to Dropbox, Mega, AnonFiles |
| T1219 | Remote Access Software | TeamViewer, AnyDesk, ScreenConnect installs |

### Cyber Kill Chain (Lockheed Martin)
1. **Reconnaissance** - target research, OSINT
2. **Weaponization** - couple exploit + payload
3. **Delivery** - email, web, USB
4. **Exploitation** - trigger code on victim
5. **Installation** - persistence (backdoor, rootkit)
6. **Command and Control (C2)** - remote channel
7. **Actions on Objectives** - exfiltration, encryption, destruction

### Diamond Model
Four interconnected vertices on every intrusion event:
- **Adversary** - threat actor, group, individual
- **Capability** - malware, tools, exploits used
- **Infrastructure** - C2 servers, domains, IPs
- **Victim** - targeted person, system, organization
Plus meta-features: timestamp, phase, result, direction, methodology, resources.

### Other Frameworks
- **OWASP Top 10** - web app risks (Broken Access Control #1, Crypto Failures #2, Injection #3)
- **MITRE D3FEND** - defensive countermeasures matched to ATT&CK
- **MITRE CAPEC** - attack pattern enumeration
- **STRIDE** - Spoofing, Tampering, Repudiation, Info disclosure, DoS, Elevation
- **PASTA** - Process for Attack Simulation and Threat Analysis (7 stages)

## Indicators of Compromise (IoCs)

### Network IoCs
| Indicator | What to Hunt For |
|-----------|------------------|
| Suspicious IPs | Connections to known C2, sinkholes, Tor exit nodes |
| Suspicious domains | DGA-generated, newly registered, typosquats |
| Beaconing | Periodic connections at fixed intervals (jitter pattern) |
| Unusual ports | C2 on non-standard ports (RDP outbound, DNS to non-DNS) |
| Geo-anomalies | Connections from countries org never operates in |
| TLS fingerprints | JA3/JA3S hashes matching known malware |
| Long-lived sessions | Hours-long connections from workstations |

### Host IoCs
| Indicator | What to Hunt For |
|-----------|------------------|
| File hashes | MD5/SHA1/SHA256 matching known bad in VT or threat feeds |
| File paths | Unusual locations - %TEMP%, %APPDATA%, C:\Windows\Temp\ executables |
| Registry keys | Run keys, Image File Execution Options, services |
| Process anomalies | unsigned binary, parent-child mismatch (Word -> PowerShell) |
| Service creation | New services with random names |
| Scheduled tasks | New tasks running scripts or LOLBins |
| Account creation | New local admins, hidden accounts ($) |
| Log clearing | EventID 1102 (Windows), wevtutil cl |

### Behavioral IoCs / IoAs
- Login from impossible travel locations
- Privilege escalation attempts
- Mass file access by single user
- Data staged to compressed archive before exfil
- Lateral movement (SMB, WinRM, RDP across many hosts)
- Disabled security tools (AV, EDR, audit logging)

## Log Analysis Cheatsheet

### Windows Security Event IDs

| EventID | Description | Hunt Use |
|---------|-------------|----------|
| 4624 | Successful logon | Type 3 (network), 10 (RDP), 4 (batch), 5 (service) |
| 4625 | Failed logon | Brute force, password spray |
| 4634 | Logoff | Session correlation |
| 4648 | Logon with explicit credentials | RunAs, lateral movement |
| 4672 | Special privileges assigned | Admin logon |
| 4688 | Process creation | Track command lines, LOLBins |
| 4689 | Process termination | |
| 4697 | Service installed | Persistence |
| 4698 | Scheduled task created | Persistence |
| 4720 | User account created | New accounts |
| 4724 | Password reset attempt | Account takeover |
| 4728/4732 | User added to group | Privilege escalation |
| 4768 | Kerberos TGT requested | Auth tracking |
| 4769 | Kerberos service ticket | Kerberoasting indicator if RC4 |
| 4776 | NTLM auth | Domain controller auth |
| 5140 | Network share accessed | SMB hunt |
| 5145 | Detailed file share access | |
| 1102 | Audit log cleared | Log tampering |
| 7045 | Service installation (System log) | Malicious service |

### Linux Log Locations

| Log | Path | Content |
|-----|------|---------|
| auth.log / secure | /var/log/auth.log, /var/log/secure | sudo, sshd, auth |
| syslog / messages | /var/log/syslog, /var/log/messages | system events |
| kern.log | /var/log/kern.log | kernel |
| audit.log | /var/log/audit/audit.log | auditd events |
| bash history | ~/.bash_history | command history |
| utmp/wtmp/btmp | /var/log/wtmp, btmp | login records |
| journald | journalctl | systemd unified |

**Useful Linux commands:**
```
last -F                           # successful logins
lastb                             # failed logins
ausearch -k recon                 # search auditd by key
journalctl -u sshd --since today  # systemd journal
grep "Failed password" /var/log/auth.log | awk '{print $11}' | sort -u
```

## SIEM Queries

### Splunk SPL Examples

```spl
# Failed logon spike (brute force)
index=wineventlog EventCode=4625
| stats count by src_ip, user
| where count > 20

# Password spraying (many users, few attempts)
index=wineventlog EventCode=4625
| stats dc(user) as users, count by src_ip
| where users > 10

# Impossible travel
index=auth user=*
| iplocation src_ip
| stats values(Country) as countries, count by user
| where mvcount(countries) > 1

# PowerShell encoded command
index=sysmon EventCode=1 (CommandLine="*-enc*" OR CommandLine="*-EncodedCommand*")
| table _time, host, user, ParentImage, CommandLine

# Lateral movement via RDP
index=wineventlog EventCode=4624 LogonType=10
| stats values(host) as hosts, count by user
| where mvcount(hosts) > 3

# Suspicious LSASS access
index=sysmon EventCode=10 TargetImage="*lsass.exe"
| stats count by host, SourceImage, GrantedAccess

# DNS data exfiltration (high entropy)
index=dns | eval len=len(query) | where len > 50
| stats count, avg(len) by src_ip
```

### Microsoft Sentinel KQL Examples

```kql
// Failed sign-ins
SigninLogs
| where ResultType != 0
| summarize FailedAttempts=count() by UserPrincipalName, IPAddress
| where FailedAttempts > 20

// New service installation
SecurityEvent
| where EventID == 7045
| project TimeGenerated, Computer, ServiceName, ServiceFileName, AccountName

// PowerShell with encoded command
SecurityEvent
| where EventID == 4688
| where CommandLine has_any ("-enc", "-EncodedCommand", "FromBase64String")

// Defender alerts by severity
SecurityAlert
| summarize count() by AlertName, AlertSeverity
| order by AlertSeverity desc
```

## Sigma Rule Skeleton

```yaml
title: Suspicious PowerShell Encoded Command
id: 4d7a1b8e-1234-5678-9abc-def012345678
status: stable
description: Detects use of base64-encoded PowerShell commands often used to evade detection
references:
    - https://attack.mitre.org/techniques/T1059/001/
author: SOC Team
date: 2025/01/15
tags:
    - attack.execution
    - attack.t1059.001
logsource:
    product: windows
    category: process_creation
detection:
    selection:
        Image|endswith: '\powershell.exe'
        CommandLine|contains:
            - '-enc '
            - '-EncodedCommand'
            - 'FromBase64String'
    condition: selection
falsepositives:
    - Legitimate admin scripts
level: high
```

## Network Detection

### Snort/Suricata Rule Format

```
alert tcp $EXTERNAL_NET any -> $HOME_NET 445 (
    msg:"ET EXPLOIT Possible EternalBlue MS17-010";
    flow:established,to_server;
    content:"|FF|SMB"; offset:4; depth:4;
    content:"|00 00 00 00|"; distance:1; within:4;
    classtype:attempted-admin;
    sid:2024218; rev:3;
)
```

| Component | Purpose |
|-----------|---------|
| action | alert, log, drop, reject, pass |
| protocol | tcp, udp, icmp, ip, http, dns, tls |
| direction | -> (one way), <> (bidirectional) |
| msg | Human-readable description |
| content | Pattern to match in payload |
| sid | Unique signature ID |
| rev | Revision number |
| classtype | Category (trojan-activity, attempted-admin) |

### Wireshark Display Filters

| Filter | Purpose |
|--------|---------|
| `ip.addr == 10.0.0.5` | All traffic to/from host |
| `tcp.port == 443` | TLS traffic |
| `http.request.method == "POST"` | HTTP POSTs |
| `http.host contains "evil"` | Suspicious Host header |
| `dns.qry.name contains "xyz"` | DNS queries matching string |
| `tls.handshake.type == 1` | TLS Client Hello (JA3 fingerprinting) |
| `tcp.flags.syn == 1 && tcp.flags.ack == 0` | SYN scans |
| `icmp.type == 8` | ICMP echo request (ping sweep) |
| `smb2` | SMB2 traffic (lateral movement) |
| `ftp.request.command == "RETR"` | FTP downloads |
| `frame contains "password"` | Plaintext password leak |

### tcpdump Capture

```
sudo tcpdump -i eth0 -w capture.pcap port 80 or port 443
sudo tcpdump -i any -nn 'tcp port 22 and host 10.0.0.5'
sudo tcpdump -r capture.pcap -A 'tcp port 80'   # readable ASCII
```

### Zeek Logs (Bro)

| Log | Content |
|-----|---------|
| conn.log | All connections (5-tuple, duration, bytes) |
| http.log | HTTP requests, hosts, URIs, user agents |
| dns.log | DNS queries and responses |
| ssl.log | TLS handshakes, JA3, SNI |
| files.log | Files transferred over any protocol |
| weird.log | Protocol anomalies |
| notice.log | Zeek-generated alerts |
| x509.log | TLS certificates |

## Vulnerability Scoring and Tools

### CVSS v3.1 Severity

| Score | Severity | Response Window |
|-------|----------|-----------------|
| 9.0 - 10.0 | Critical | 24 - 48 hours |
| 7.0 - 8.9 | High | 7 days |
| 4.0 - 6.9 | Medium | 30 days |
| 0.1 - 3.9 | Low | 90 days / next cycle |
| 0.0 | None / Informational | Tracked, no action |

### CVSS Base Metrics
- **AV** - Attack Vector (Network, Adjacent, Local, Physical)
- **AC** - Attack Complexity (Low, High)
- **PR** - Privileges Required (None, Low, High)
- **UI** - User Interaction (None, Required)
- **S** - Scope (Unchanged, Changed)
- **C/I/A** - Confidentiality, Integrity, Availability impact (None, Low, High)

Example string: `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H` = 9.8 Critical

### CVSS v4.0 (Released Nov 2023)
- New supplemental metrics: Safety, Automatable, Recovery, Value Density
- Threat metric replaces "Temporal" group
- Environmental adjustments more granular

### Other Scoring Systems
- **EPSS** - Exploit Prediction Scoring System (probability of exploitation in 30 days, 0-1)
- **CISA KEV** - Known Exploited Vulnerabilities catalog (must-patch list for federal)
- **CWE** - Common Weakness Enumeration (vulnerability category)
- **CVE** - Common Vulnerabilities and Exposures (specific instance)
- **SSVC** - Stakeholder-Specific Vulnerability Categorization (CISA decision tree)

### Vulnerability Scanning Tools

| Tool | Purpose | Type |
|------|---------|------|
| Nessus / Tenable.io | Network and host vuln scanning | Authenticated, agent, network |
| Qualys VMDR | Cloud-based vuln management | SaaS, agent, network |
| Rapid7 InsightVM | Vuln management | Network, agent |
| OpenVAS / Greenbone | Open source vuln scanner | Network |
| Nikto | Web server scanner | Web app |
| Burp Suite Pro | Web application testing | Proxy, scanner |
| OWASP ZAP | Open source web app scanner | Proxy, scanner |
| Nmap / NSE scripts | Port and service discovery | Network |
| Nuclei | Template-based vuln scanner | Network and web |
| Trivy / Grype | Container image scanning | SBOM, container |
| Checkov / tfsec | IaC scanning | Static, Terraform |
| sqlmap | SQL injection testing | Web app |

### Scan Types
- **Unauthenticated** - external attacker view, fewer findings
- **Authenticated** - logged-in scan, fuller picture, more accurate
- **Agent-based** - persistent agent reports findings
- **Passive** - sniff network traffic, no probes (Zeek, Suricata)
- **Active** - send probes (Nessus, Nmap)
- **Web application** - DAST (Burp, ZAP)
- **Static (SAST)** - source code analysis (Semgrep, SonarQube)
- **Dynamic (DAST)** - running app testing
- **Interactive (IAST)** - hybrid SAST + DAST inside running app
- **Container** - image scanning (Trivy, Grype, Clair)
- **IaC** - Terraform/CloudFormation static analysis (Checkov, tfsec)

## Incident Response Quick Reference

### NIST SP 800-61 Lifecycle
1. **Preparation** - policies, runbooks, tools, training, communication trees
2. **Detection and Analysis** - monitor, classify, scope, prioritize
3. **Containment, Eradication, Recovery** - isolate, remove, restore
4. **Post-Incident Activity** - lessons learned, report, improvements

### SANS PICERL Lifecycle
**P**reparation -> **I**dentification -> **C**ontainment -> **E**radication -> **R**ecovery -> **L**essons Learned

### Order of Volatility (RFC 3227)
1. CPU registers, cache (nanoseconds)
2. Routing table, ARP cache, process table, kernel statistics, RAM (microseconds-milliseconds)
3. Temporary file systems / swap (seconds-minutes)
4. Disk (minutes-hours)
5. Remote logging and monitoring data
6. Physical configuration, network topology
7. Archival media (offline backups)

### Forensic Tools

| Tool | Purpose |
|------|---------|
| FTK Imager | Disk and memory imaging (free) |
| EnCase | Commercial forensic suite |
| Autopsy / Sleuth Kit | Open source disk forensics |
| Volatility | Memory analysis |
| LiME | Linux memory acquisition |
| Magnet AXIOM | Mobile and computer forensics |
| Velociraptor | Endpoint visibility and DFIR |
| KAPE | Triage collection |
| Plaso / log2timeline | Timeline analysis |
| dd / dcfldd | Bit-for-bit imaging (Linux) |

## Common Exam Scenarios

1. **"Suspicious beacon traffic to external IP"** - C2 detection, block at firewall, IR
2. **"Multiple failed logins followed by success from new geo"** - account compromise, force reset
3. **"Vulnerability scan returned 500 findings"** - prioritize by CVSS + KEV + asset value
4. **"PowerShell -enc command observed"** - T1059.001, hunt for parent process, decode payload
5. **"Mass file rename to .locked"** - ransomware T1486, isolate immediately
6. **"LSASS process accessed by unsigned binary"** - credential dumping T1003.001
7. **"Outbound DNS queries with high entropy"** - DNS tunneling T1071.004
8. **"User in group X downloaded 50GB"** - insider threat, data exfil T1041
9. **"Public-facing web app exploited"** - T1190, WAF logs, patch, scan
10. **"Privilege escalation evidence found"** - check ATT&CK TA0004 techniques
11. **"Patch fails in test environment"** - compensating control, document risk acceptance
12. **"Auditor asks for evidence"** - chain of custody, timestamps, hash verification

## Key Acronyms

### Operations
- **SOC** - Security Operations Center
- **SIEM** - Security Information and Event Management
- **SOAR** - Security Orchestration Automation and Response
- **EDR/XDR** - Endpoint / Extended Detection and Response
- **MDR** - Managed Detection and Response
- **NDR** - Network Detection and Response
- **UEBA** - User and Entity Behavior Analytics

### Frameworks and Standards
- **ATT&CK** - Adversarial Tactics, Techniques, and Common Knowledge
- **TTP** - Tactics, Techniques, Procedures
- **IoC / IoA** - Indicator of Compromise / Attack
- **STIX / TAXII** - Structured Threat Info eXpression / Trusted Automated eXchange of Indicator Information
- **OSINT** - Open Source Intelligence
- **ISAC / ISAO** - Information Sharing and Analysis Center / Organization

### Vulnerability
- **CVE** - Common Vulnerabilities and Exposures
- **CWE** - Common Weakness Enumeration
- **CVSS** - Common Vulnerability Scoring System
- **EPSS** - Exploit Prediction Scoring System
- **KEV** - Known Exploited Vulnerabilities
- **SSVC** - Stakeholder-Specific Vulnerability Categorization
- **SBOM** - Software Bill of Materials

### Metrics
- **MTTD** - Mean Time to Detect
- **MTTR** - Mean Time to Respond / Resolve
- **MTTA** - Mean Time to Acknowledge
- **MTBF** - Mean Time Between Failures
- **SLA / SLO / SLI** - Service Level Agreement / Objective / Indicator

---

**Use this fact sheet for last-week revision.** Memorize ATT&CK technique IDs, Windows EventIDs, CVSS thresholds, and the NIST IR phases.
