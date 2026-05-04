---
last-updated: 2026-05-03
---

# OSCP - Exam Strategy

## Format reminder

- 23 hours 45 minutes practical + 24 hours report window
- 100 points total, 70 to pass
- 40 points: AD chain (3 hosts) - graded as a set with partial credit
- 60 points: 3 standalone hosts (20 each: 10 user + 10 root/SYSTEM)
- Metasploit / Meterpreter allowed on exactly ONE machine
- Automated scanners (Nessus, OpenVAS, Burp Pro active scan, etc.) FORBIDDEN
- Commercial exploit packs (Core Impact, Cobalt Strike, etc.) FORBIDDEN

## The "70 to pass" math

You need 70 points. The realistic shape is:
- AD chain full = 40
- One full standalone (user + root) = 20
- Two more standalone footholds (user only) = 10 + 10 = 20
- **Total: 90** (comfortably above 70)

Or:
- AD chain full = 40
- Two standalone footholds (user only) = 20
- Two standalone full (user + root) = 40 → but this is harder than completing AD
- **Skip optimizing for 100; aim for 80-90 with the AD chain.**

If AD doesn't fall: you need 70 from standalones, which means 3.5 of 3 - impossible without AD partial credit. **The AD chain is the exam.**

## Day-of cadence

| Time | Phase |
|---|---|
| 0:00 - 0:30 | Connect, screenshots of starting state, nmap on every host in parallel |
| 0:30 - 6:00 | Hit easy standalone first; bank 20 points fast |
| 6:00 - 12:00 | AD chain: foothold → lateral → DC. The 40-point set. |
| 12:00 - 14:00 | **SLEEP** (set 2 alarms). Yes, really. |
| 14:00 - 19:00 | Second standalone + push for at least one more 20-pointer |
| 19:00 - 22:00 | Cleanup, screenshots, retry anything within 50% completion |
| 22:00 - 23:45 | Final review of proof screenshots, take last screenshots, end exam |
| Post-exam | 24-hour report window. Sleep, then write the report. |

## Note-taking template

For each host, maintain a markdown / CherryTree note with these sections:
- **Recon**: nmap output, service versions, web enum
- **Foothold**: vulnerability, exploit, evidence (screenshot of initial shell)
- **Local Enum**: linpeas / winpeas output, interesting findings
- **Privilege Escalation**: technique, command, evidence (screenshot of root shell)
- **Loot**: proof.txt and local.txt contents (and screenshots showing them)
- **Cleanup**: what you left on the box

If you don't take notes during exploitation, you cannot write the report later.

## Reporting requirements

- Use the [OffSec exam report template](https://help.offsec.com/hc/en-us/articles/360046787731-OSCP-Exam-Report)
- Executive summary (2-3 paragraphs)
- Methodology
- Per-host: enumeration → exploitation → post-exploitation → loot, with **screenshots of proof.txt and local.txt** for credit
- All commands and output (text, not screenshots of terminals)
- Cleanup steps

**Lab points without proper screenshots = 0 points on the report.**

## Top failure modes

1. **No AD attempt**: candidates avoid AD due to its complexity, then can't reach 70. Practice it relentlessly in week 7-8 of prep.

2. **Tunnel vision**: 3 hours stuck on one machine. Set 30-minute checkpoints on dead ends. Rotate.

3. **Burned MSF early**: used MSF on the first easy box; needed it later for AD entry. Save it.

4. **Bad notes**: by hour 18 you're tired and can't reconstruct what happened in hour 4. Take notes throughout.

5. **Sleep avoidance**: 24 straight hours of caffeine doesn't work. Plan 4-6 hours sleep mid-exam.

6. **Report shortcomings**: 80 lab points + sloppy report can fail.

## Tooling reminders (allowed)

- Manual exploitation: nmap, ffuf, gobuster, nikto, wpscan, sqlmap (manual SQLi often required)
- Active Directory: BloodHound, SharpHound, impacket-* suite, crackmapexec, kerbrute, evil-winrm
- Pivoting: chisel, ligolo-ng, sshuttle, proxychains
- Linux privesc: linpeas, LinEnum, pspy
- Windows privesc: winpeas, PowerUp, Seatbelt, WES-NG
- Cracking: hashcat, john
- Payload generation: msfvenom (allowed everywhere; only the *exploit/auxiliary/post* modules count toward the one-MSF-machine rule)

## Tooling reminders (forbidden)

- Nessus, OpenVAS, Nexpose, Acunetix, Burp Pro active scanner
- Core Impact, Canvas, Cobalt Strike
- Any commercial / automated vulnerability scanner

## Mental management

OSCP is as much mental as technical. Plan:
- Pre-exam: 7-8 hours sleep the night before, full meal 1h before start
- During: hydrate, snacks, reasonable food (no heavy meals, they make you sleepy)
- The 14-hour mark slump is real; if you've made the AD progress + 1 standalone by hour 12, you're in good shape

## After

**Pass:** OSCP is lifetime. OSCP+ (introduced 2024) is renewable every 3 years via CE credits or re-exam.

**Fail:** Score breakdown received. Most failures are 60-65 points (just below pass). Common: AD partial only (20 of 40) + 2 standalone footholds (20 of 60) = 40-60. Regroup in 4-6 weeks - you can retake after 14 days. The OffSec Learn One bundle includes one retake.

## OSCP "patterns" (recognized attack chains)

- "Web app foothold" → SQLi / file upload / LFI / RCE in CMS
- "Linux privesc" → linpeas → sudo / SUID / kernel / PATH / cron
- "Windows privesc" → winpeas → service / token / DLL / GPP / SeImpersonatePrivilege
- "AD foothold" → AS-REP roast / kerberoast / null session / weak creds
- "AD lateral" → ACL abuse / Pass-the-Hash / Pass-the-Ticket
- "AD final" → DCSync / unconstrained delegation / Golden Ticket
- "Pivot" → chisel / ligolo-ng / SSH dynamic
- "When stuck" → re-enum, look at unusual ports, check default creds, check the easy stuff
