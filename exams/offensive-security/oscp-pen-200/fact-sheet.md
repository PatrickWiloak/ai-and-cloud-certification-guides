---
last-updated: 2026-05-03
---

# OSCP - Fact Sheet

## Quick Reference

**Exam Code:** OSCP (course PEN-200)
**Format:** Practical hands-on lab; full report submission
**Practical Duration:** 23 hours 45 minutes
**Report Window:** 24 hours after the practical ends
**Total Points:** 100 (70 to pass)
**Cost:** $1,599 USD (Learn One bundle: course, labs, exam, one retake)
**Validity:** OSCP is lifetime. **OSCP+** (introduced 2024) is renewable every 3 years.
**Delivery:** Remote, OffSec proctoring (webcam, screen share, room scan)
**Prerequisites:** None enforced; Linux comfort, Bash, basic Python, networking expected

**[OSCP exam page](https://www.offsec.com/courses/pen-200/)**
**[Exam guide](https://help.offsec.com/hc/en-us/articles/360040165632-OSCP-Exam-Guide-OffSec-Penetration-Testing-Certification)**
**[Discord](https://offs.ec/discord)** | **[Reddit r/oscp](https://reddit.com/r/oscp)**

---

## Scoring Breakdown

| Set | Machines | Points | Notes |
|-----|----------|--------|-------|
| **Active Directory chain** | 3 hosts | **40 (as a set)** | Partial credit; full chain compromise = 40 |
| **Standalone #1** | 1 host | 20 (10 user + 10 root/SYSTEM) | Partial credit per foothold |
| **Standalone #2** | 1 host | 20 (10 user + 10 root/SYSTEM) | Partial credit per foothold |
| **Standalone #3** | 1 host | 20 (10 user + 10 root/SYSTEM) | Partial credit per foothold |
| **Total** | 6 machines | 100 | 70 to pass |

---

## Tooling Restrictions (high-yield)

- **Metasploit / Meterpreter**: allowed on **exactly one** machine. Once you use any `exploit`, `auxiliary`, or `post` module against a host, that host is your "Metasploit machine" for the exam.
- `msfvenom`: **not** restricted. Use it freely for payload generation.
- **Forbidden everywhere:** automated scanners (Nessus, OpenVAS, Nexpose, Burp Pro active scan, Acunetix), commercial exploit packs (Core Impact, Canvas, Cobalt Strike).
- Manual exploitation required for every other host. SOCKS proxies + manual scripts are fine.

---

## Domains / Topics (current syllabus, post-2023)

| Domain | Topics | Why it matters |
|---|---|---|
| 1. Information Gathering | OSINT, DNS, WHOIS, cert transparency; nmap, banner grabbing, web enum (gobuster/feroxbuster/ffuf) | Foundation for every box |
| 2. Vulnerability Scanning + Web Attacks | nmap NSE, nikto, nuclei; SQLi (manual + sqlmap), XSS, LFI/RFI, file upload bypass, command injection, SSRF; modifying public exploits | Standalone #1-3 footholds |
| 3. Client-Side | HTA, VBA macros, phishing payloads | Occasional foothold path |
| 4. Linux PrivEsc | Kernel exploits, SUID/SGID, sudo misconfig, capabilities, NFS no_root_squash, cron, PATH hijack, writable services, shared lib injection. linpeas / LinEnum / pspy | Standalone Linux boxes |
| 5. Windows PrivEsc | Service abuse (unquoted paths, weak perms, registry), AlwaysInstallElevated, token impersonation, SeImpersonatePrivilege (PrintSpoofer, GodPotato, JuicyPotato family), stored creds, AutoLogon, GPP. winpeas / PowerUp / Seatbelt | Standalone Windows + AD |
| 6. Password Attacks | hashcat / john modes for NTLM, NetNTLMv2, Kerberos, Linux shadow; cewl + rules; online spraying (crackmapexec, kerbrute) | Hash cracking is mandatory |
| 7. Active Directory | BloodHound/SharpHound, ldapsearch, rpcclient. Kerberoast, AS-REP roast, ACL abuse, DCSync, unconstrained/constrained delegation. Lateral: Pass-the-Hash, Pass-the-Ticket, psexec.py / wmiexec.py / evil-winrm | **40 of 100 exam points** |
| 8. Pivoting and Tunneling | SSH local/remote/dynamic forwarding, chisel, ligolo-ng, sshuttle, proxychains | AD chain requires it |
| 9. Antivirus Evasion (basic) | Manual compilation, simple obfuscation. Deep AV/EDR evasion is OSEP territory. | Light coverage |
| 10. Metasploit (limited) | msfconsole, payloads, post modules - but only on one box | Tool of last resort |

**Buffer overflow is REMOVED from the current syllabus and exam (post-2023).**

---

## Lab Environment

- **OffSec PG Practice** - the official practice ground; subscription-based, machines added regularly
- **OffSec PWK Lab** - included with Learn One; ~50 machines, AD network with multiple chains
- **HackTheBox** - the gold-standard supplementary platform. The community-maintained "TJ_NULL OSCP-like" list is the canonical training set
- **TryHackMe** - friendlier on-ramp; "Offensive Pentesting" path is OSCP-aligned
- **VulnHub** - free downloadable VMs; older but still teaches enumeration
- **Proving Grounds Play** - free OffSec-hosted practice (small subset)

---

## Reporting

The 24-hour report window is **mandatory** and graded. A perfect lab run with a poor report can fail.

**Report must include:**
- Executive summary
- Methodology
- Per-machine: enumeration steps, vulnerability identification, exploitation, post-exploitation, proof.txt and local.txt screenshots
- All commands and tool output (copy/paste, not screenshots of terminals)
- Cleanup steps

**Use the [OffSec exam report template](https://www.offsec.com/pwk-online/PWKv1-REPORT.docx)** unless you have a strong reason not to.

---

## High-Leverage Practice

Track the [TJ_NULL OSCP-like list](https://docs.google.com/spreadsheets/d/1dwSMIAPIam0PuRBkCiDI88pU3yzrqqHkDtBngUHNCw8/edit). It's grouped by difficulty and updated by the community to mirror exam style.

Recommended weekly cadence in the final 4-8 weeks:
- 1-2 standalone Linux boxes per week
- 1-2 standalone Windows boxes per week
- 1 AD chain per week (TJ_NULL "AD-style" or HTB Pro Labs / Dante)
- Time each box; aim for 3 hours from connect to root once you're in flow

---

## Common Exam Failure Modes

- **Tunnel vision** - 2 hours stuck on one foothold while the AD chain sits untouched. Set a 30-min cap; rotate.
- **Skipping enumeration** - "I'll come back to that port" → never came back → missed the box.
- **No notes** - getting lost in 6 machines × multiple footholds without a notebook is a known failure mode. Use Obsidian, CherryTree, KeepNote, or just per-host markdown.
- **Bad reporting** - 70 lab points but the report is missing screenshots of proof.txt → fail.
- **Burning the Metasploit token early** - using MSF on the first easy box and then needing it later for the AD entry. Save it.
- **Sleep deprivation** - 24 hours of red-bull is the wrong strategy. Plan a 4-6 hour sleep break in the middle.

---

## Renewal (OSCP+)

- OSCP (legacy): lifetime, no renewal.
- **OSCP+** (introduced 2024): valid 3 years; renewable via:
  - Continuing Education credits (e.g., other OffSec courses), or
  - Re-passing the OSCP exam.

---

## Cost

| Item | Cost |
|---|---|
| Learn One (course + labs + exam + 1 retake) | $1,599 |
| Learn Fundamentals (year-long subscription incl. PEN-200) | $2,599 |
| Standalone retake | $249 |
| Proving Grounds Practice (recommended add-on) | $19/month |

Plan total budget: **$1,800 - $2,500** including practice subscriptions and a likely retake.
