---
last-updated: 2026-05-03
---

# OSCP - Practice Plan

A 12-week study plan for the OSCP. This is a **practical-only** exam: knowing concepts isn't enough. You need to compromise machines under time pressure with no hints. The plan assumes 10-15 hours per week. People who already do offensive work daily can compress to 8 weeks; total beginners may need 16-20.

Prerequisite comfort: Linux command line, basic Bash and Python, TCP/IP fundamentals, knowing what a port and service are. If any of those are shaky, spend 2-3 weeks on TryHackMe's "Pre-Security" + "Cyber Security 101" before this plan.

## Setup (week 0)

- [ ] Read [README.md](./README.md) and [fact-sheet.md](./fact-sheet.md) end to end
- [ ] Buy the **Learn One** bundle ($1,599) when you're committing to a 90-day window
- [ ] Set up a Kali VM (or Parrot) with at least 4 GB RAM and 80 GB disk
- [ ] Subscribe to **Proving Grounds Practice** ($19/mo) and **HackTheBox** ($14/mo or VIP)
- [ ] Bookmark the [TJ_NULL OSCP-like list](https://docs.google.com/spreadsheets/d/1dwSMIAPIam0PuRBkCiDI88pU3yzrqqHkDtBngUHNCw8/edit)
- [ ] Set up a notes system: Obsidian or CherryTree, with one page per box, template for: enumeration, foothold, lateral / privesc, screenshots, commands

## Weeks 1-2: PEN-200 course material + first easy boxes

**Goal:** finish reading the entire PEN-200 course PDF; complete every numbered exercise.

- [ ] Daily: 2-3 hours reading + practicing exercises
- [ ] Weekend: own 2-3 easy machines on TJ_NULL list (e.g., Lame, Beep, Knight)
- [ ] Build muscle memory for: nmap full TCP scan + service version detection, gobuster, basic SQLi, basic Linux privesc with linpeas

## Weeks 3-4: Web attacks + Linux PrivEsc

- [ ] Read PEN-200 web chapters; complete all exercises
- [ ] Own 6-8 Linux boxes from TJ_NULL list (e.g., Bashed, Mirai, Networked, Sense)
- [ ] Practice in writing for each box: the unique foothold technique, the unique privesc technique
- [ ] Ensure you can do a manual SQLi (no sqlmap) and a basic LFI to RCE chain by hand

## Weeks 5-6: Windows PrivEsc + Client-Side

- [ ] Read PEN-200 Windows chapters
- [ ] Own 6-8 Windows boxes from TJ_NULL list (e.g., Optimum, Devel, Granny, Jeeves, Bastard)
- [ ] Drill: SeImpersonatePrivilege exploitation (PrintSpoofer, GodPotato), unquoted service path, AlwaysInstallElevated
- [ ] Practice winpeas / PowerUp / Seatbelt output reading

## Weeks 7-8: Active Directory (the 40-point set)

This is the most exam-relevant block. Don't skip it.

- [ ] Read PEN-200 AD chapters
- [ ] Set up a small AD lab (2 Windows servers + 1 client) on Proxmox / Hyper-V or use HTB Starting Point AD
- [ ] Complete HTB Starting Point: Tier 2 (AD)
- [ ] Practice: Kerberoast, AS-REP roast, BloodHound enumeration, ACL abuse, DCSync, Pass-the-Hash, Pass-the-Ticket
- [ ] Drill from Forest, Active, Sauna, Cascade, Mantis on HTB
- [ ] Be able to do an AD chain from foothold to DC in under 4 hours by week 8

## Weeks 9-10: Pivoting + Tunneling + harder boxes

- [ ] Practice: chisel, ligolo-ng, sshuttle, SSH dynamic port forward, proxychains
- [ ] Buy a **Dante** (or Pro Lab equivalent) on HTB and complete all 28 hosts in 2 weeks (this is the closest experience to OSCP exam difficulty)
- [ ] Run a TJ_NULL list mock exam: pick 1 AD chain + 3 standalones from the list, time-box yourself to 24 hours, follow exam rules (no automated scanners, MSF on one box only)

## Week 11: Mock exam #2 + report rehearsal

- [ ] Schedule a full mock exam from PG Practice or HackTheBox: pick 4-5 unfamiliar machines you've never owned, give yourself 24 hours
- [ ] Stop after 23h45m, then write the full report in the next 24h - **this practices the exam day mechanics**
- [ ] Have a friend or community member review your report for completeness
- [ ] Identify your weakest spot from the mock; spend the rest of the week drilling it

## Week 12: Lock in + book the exam

- [ ] Light practice only (1-2 known boxes per day to stay sharp)
- [ ] Re-read your own notes from boxes you've owned - they're better than any cheat sheet
- [ ] Schedule the exam with **at least 7 days clear on either side** (you may need to retake)
- [ ] Final checklist:
  - [ ] Report template downloaded and customized with your name
  - [ ] Lab environment documented (Kali version, key tools, payloads ready)
  - [ ] Sleep schedule planned (4-6 hours mid-exam is realistic)
  - [ ] Snacks, water, room setup that passes the proctor's room scan

## Exam day (the actual day)

A common cadence that works:

| Hour | Phase |
|---|---|
| 0:00 - 0:30 | Connect, screenshots of starting state, full nmap on every host in parallel |
| 0:30 - 6:00 | Hit easy standalone first; bank 20 points fast |
| 6:00 - 12:00 | AD chain: foothold → lateral → DC. The 40-point set. |
| 12:00 - 14:00 | **SLEEP** (set 2 alarms) |
| 14:00 - 19:00 | Second standalone + push for at least one more 20-pointer |
| 19:00 - 22:00 | Cleanup, screenshots, retry anything within 50% completion |
| 22:00 - 23:45 | Final review of proof screenshots, take last screenshots, end exam |
| Then | 24-hour report window. Sleep, then write the report. |

**70 points to pass.** Don't try to perfect-sweep all 100. Lock in the AD chain (40), grab one full standalone (20) + 2 footholds (10 + 10) = 80. That's the realistic pass shape.

## Tracking

| Week | Boxes owned | Hours actual | Notes |
|---|---|---|---|
| 1 |  |  |  |
| 2 |  |  |  |
| 3 |  |  |  |
| 4 |  |  |  |
| 5 |  |  |  |
| 6 |  |  |  |
| 7 |  |  |  |
| 8 |  |  |  |
| 9 |  |  |  |
| 10 |  |  |  |
| 11 |  |  |  |
| 12 |  |  |  |
