# Offensive Security Certified Professional (OSCP / PEN-200)

## Exam Overview

The Offensive Security Certified Professional (OSCP) is the practical penetration testing certification awarded by [Offensive Security](https://www.offensive-security.com/) upon completion of the **PEN-200: Penetration Testing with Kali Linux** course. It is widely considered the most respected entry-to-mid-level offensive security credential, primarily because its exam is a full 24-hour hands-on hacking lab followed by a 24-hour professional report write-up.

There are no multiple-choice questions. There is no theory section. You either compromise the machines and document your work, or you do not pass.

The course was significantly updated in 2023. Buffer overflow exploitation was **removed** from both the syllabus and the exam. In its place, Active Directory attacks were given heavier weight. As of the current syllabus, AD is a 40-point graded set on the exam.

## The "Try Harder" Ethos

OffSec deliberately does not provide step-by-step walkthroughs. Students are expected to:

- Read documentation, source code, and error messages carefully.
- Try multiple angles before asking for help.
- Build their own methodology rather than memorize one.
- Take detailed notes during practice so they can recreate attacks under exam pressure.

This is a feature, not a bug. The exam is designed to test whether you can attack an unfamiliar environment with no hints, which is exactly what real penetration testers do.

## Exam Details

- **Exam Code:** OSCP (course PEN-200)
- **Format:** Practical / hands-on lab exam, fully proctored
- **Duration:** 23 hours 45 minutes for the practical, then 24 hours to submit the report
- **Total Points:** 100
- **Passing Score:** 70 / 100
- **Cost:** $1,599 USD for the Learn One bundle (course, labs, exam, one retake)
- **Delivery:** Remote, proctored via OffSec proctoring software (webcam, screen share, room scan)
- **Validity:** OSCP is lifetime. **OSCP+** (introduced 2024) is the renewable 3-year variant.
- **Prerequisites:** None enforced. Realistically: Linux comfort, Bash, basic Python, networking fundamentals.

## Exam Scoring Breakdown

| Set | Machines | Points | Notes |
|-----|----------|--------|-------|
| **Active Directory chain** | 3 hosts (typically client + member server + DC) | **40 (as a set)** | Partial credit possible; full chain compromise = 40 |
| **Standalone #1** | 1 host | 20 (10 user + 10 root/SYSTEM) | Partial credit per foothold |
| **Standalone #2** | 1 host | 20 (10 user + 10 root/SYSTEM) | Partial credit per foothold |
| **Standalone #3** | 1 host | 20 (10 user + 10 root/SYSTEM) | Partial credit per foothold |
| **Total** | 6 machines | 100 | 70 to pass |

The AD chain is graded as a unit. Compromising only the first host without pivoting to the DC yields partial credit. Compromising all three hosts in the AD set yields the full 40 points.

You also get **+10 bonus points** if you complete 80% of the course exercises and 30 of the lab machines, but as of the 2023 update OffSec phased out the bonus point structure and replaced it with the OffSec Learning Library style assessments. Confirm the current bonus rules on the OffSec student portal at the time you book.

## Metasploit and Tooling Restrictions

- **Metasploit / Meterpreter is allowed on exactly ONE machine** during the exam.
- The full module suite counts: `exploit`, `auxiliary`, and `post`. Once you use any of these on a machine, that machine is your "Metasploit machine" for the exam.
- `msfvenom` is **not** restricted. You may generate payloads with it freely.
- Manual exploitation is required for every other host.
- Automated vulnerability scanners (Nessus, OpenVAS, Nexpose, Burp Pro active scan, Acunetix, etc.) are **forbidden**.
- Commercial exploit packs (Core Impact, Canvas, Cobalt Strike) are **forbidden**.

## Domains / Topics Covered

PEN-200's current syllabus removes buffer overflow and emphasizes practical penetration testing with a heavy AD focus.

### 1. Information Gathering and Enumeration
- Passive recon (OSINT, DNS, WHOIS, certificate transparency)
- Active recon (`nmap`, service enumeration, banner grabbing)
- Web enumeration (`gobuster`, `feroxbuster`, `ffuf`, `whatweb`)

### 2. Vulnerability Scanning and Web Attacks
- `nmap` NSE scripts, `nikto`, `nuclei`
- SQL injection (manual + `sqlmap`)
- Cross-site scripting (XSS), Local/Remote File Inclusion (LFI/RFI)
- File upload bypass, command injection, SSRF
- Modifying public exploits (`searchsploit`, Exploit-DB)

### 3. Client-Side Attacks
- Malicious HTA files
- Office macros (VBA payloads)
- Phishing payload delivery in lab scenarios

### 4. Linux Privilege Escalation
- Kernel exploits (`linux-exploit-suggester`, Dirty Pipe / CVE-2022-0847 variants)
- SUID/SGID, sudo misconfigurations, capabilities, NFS no_root_squash
- Cron jobs, PATH hijacks, writable services, shared library injection
- Enumeration with `linpeas.sh`, `LinEnum.sh`, `pspy`

### 5. Windows Privilege Escalation
- Service abuse (unquoted paths, weak permissions, registry)
- AlwaysInstallElevated, token impersonation
- PrintSpoofer, GodPotato, JuicyPotato family (`SeImpersonatePrivilege`)
- Stored credentials, AutoLogon registry, Group Policy Preferences
- Enumeration with `winpeas.exe`, `PowerUp.ps1`, `Seatbelt.exe`

### 6. Password Attacks
- `hashcat` and `john` modes for NTLM, NetNTLMv2, Kerberos, Linux shadow
- Wordlist crafting (`cewl`, `hashcat` rules)
- Online password spraying (`crackmapexec`, `kerbrute`)

### 7. Active Directory Attacks
- Enumeration: `BloodHound` / `SharpHound`, `ldapsearch`, `rpcclient`
- Kerberoasting, AS-REP roasting
- ACL abuse, DCSync, unconstrained / constrained delegation
- Lateral movement: Pass-the-Hash, Pass-the-Ticket, `psexec.py`, `wmiexec.py`, `evil-winrm`

### 8. Pivoting and Tunneling
- SSH local/remote/dynamic port forwarding
- `chisel`, `ligolo-ng`, `sshuttle`
- `proxychains` with SOCKS4/5

### 9. Antivirus Evasion (basic)
- Compiling tools manually, simple obfuscation
- Note: deep AV/EDR evasion is OSEP territory.

### 10. Metasploit (limited)
- `msfconsole` workflow, payload generation, post modules.

## Study Materials

### Notes
- [01 - Information Gathering and Enumeration](notes/01-information-gathering-enumeration.md)
- [02 - Vulnerability Scanning and Web Attacks](notes/02-vulnerability-scanning-web-attacks.md)
- [03 - Exploitation and Client-Side Attacks](notes/03-exploitation-client-side.md)
- [04 - Privilege Escalation (Linux + Windows)](notes/04-privilege-escalation.md)
- [05 - Active Directory Attacks](notes/05-active-directory-attacks.md)
- [06 - Pivoting, Tunneling, and Post-Exploitation](notes/06-pivoting-tunneling-post-exploitation.md)

### Study Resources
- [Fact Sheet](fact-sheet.md) - Command cheat sheet, payloads, syntax reference
- [Practice Plan](practice-plan.md) - 4-6 month structured study schedule
- [Scenarios](scenarios.md) - 12-15 practice box scenarios mapping to exam types
- [Strategy](strategy.md) - 24-hour exam-day strategy and report-writing tips

## Official Resources

- **[OffSec OSCP Page](https://www.offensive-security.com/pwk-oscp/)** - Official certification details and pricing
- **[PEN-200 Syllabus](https://www.offensive-security.com/documentation/penetration-testing-with-kali.pdf)** - Current course outline
- **[OffSec Proving Grounds](https://www.offensive-security.com/labs/)** - Official practice labs (PG Practice and PG Play)
- **[Exploit-DB](https://www.exploit-db.com/)** - OffSec's exploit database, mirrored locally as `searchsploit`
- **[Kali Linux](https://www.kali.org/)** - The official OSCP attacker distro

## Recommended Training and Companion Material

OffSec PEN-200 is the primary resource. Most successful candidates supplement it.

### Companion Certifications (foundational)
- **CompTIA PenTest+** - foundational pentest theory, multiple-choice. Good warm-up.
- **CEH (Certified Ethical Hacker)** - heavy on terminology and breadth, light on hands-on. Useful vocabulary.
- **CompTIA Security+ (SY0-701)** - baseline cybersecurity knowledge expected before OSCP.

### Hands-On Practice Platforms
- **[HackTheBox](https://www.hackthebox.com/)** - Closest practice environment to OSCP. Use the **TJ Null OSCP-like list** and the **Lainkusanagi list**.
- **[TryHackMe](https://tryhackme.com/)** - Beginner-friendlier; the **Offensive Pentesting** path and **OSCP Pathway** room are excellent.
- **[OffSec Proving Grounds Practice (PG Practice)](https://www.offensive-security.com/labs/individual/)** - Closest possible match to actual exam machines. Strongly recommended.
- **[VulnHub](https://www.vulnhub.com/)** - Free downloadable VM boxes.

### Books and Video Courses
- **TCM Security - Practical Ethical Hacking (PEH)** by Heath Adams - excellent OSCP primer.
- **TCM Security - Windows Privilege Escalation** and **Linux Privilege Escalation for Beginners** - tightly aligned with OSCP privesc topics.
- **The Hacker Playbook 3** by Peter Kim - methodology reference.
- **Red Team Field Manual (RTFM)** - quick command lookup.
- **OSCP for $0** community guides on GitHub - free curated paths through TryHackMe / HackTheBox boxes.

### Cheat Sheets and References
- **[HackTricks](https://book.hacktricks.xyz/)** - The community penetration testing wiki. Indispensable.
- **[PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings)** - Curated payload reference.
- **[GTFOBins](https://gtfobins.github.io/)** - Linux binaries for privesc, file transfer, shell escape.
- **[LOLBAS](https://lolbas-project.github.io/)** - Windows equivalent.
- **[The PayloadAllTheThings AD methodology](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Active%20Directory%20Attack.md)** - AD attack reference.

## Next Steps After OSCP

### Immediate Career Paths
- Junior Penetration Tester
- Red Team Operator (junior)
- Security Consultant (offensive)
- Vulnerability Researcher (entry)
- Bug Bounty Hunter

### Advanced OffSec Certifications
- **OSEP** (PEN-300) - advanced AD, EDR/AV evasion, lateral movement.
- **OSWE** (WEB-300) - advanced web app attacks and source code review.
- **OSED** (EXP-301) - Windows user-mode exploit development.
- **OSCE3** - earned by passing OSEP + OSWE + OSED.
- **OSEE** (EXP-401) - expert-tier Windows exploitation, ~5% pass rate.

### Adjacent Tracks
- **GIAC GPEN / GXPN** - SANS penetration testing certs.
- **CRTO / CRTL** (Zero-Point Security) - red team operator focus.
- **AWS Security - Specialty** - cloud-specific offensive/defensive overlap.

## Ethics Reminder

OSCP teaches offensive techniques. These skills are illegal to apply against systems you do not own or have explicit written authorization to test. All practice should occur in OffSec labs, HackTheBox / TryHackMe / VulnHub VMs, your own home lab, or sanctioned engagements with a signed scope. Map your activity to the [MITRE ATT&CK](https://attack.mitre.org/) framework so you can communicate with defenders. Penetration testing is a profession built on trust.

---

**Try harder. Take notes. Document everything. Good luck on your OSCP.**
