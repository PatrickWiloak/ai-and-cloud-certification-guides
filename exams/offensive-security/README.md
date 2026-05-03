# Offensive Security (OffSec)

[Offensive Security](https://www.offensive-security.com/) is the cybersecurity training and certification organization behind Kali Linux and Exploit Database (Exploit-DB). Their certifications are widely regarded as among the most challenging and respected hands-on credentials in the offensive security industry. Unlike most multiple-choice certifications, every OffSec certification is a fully practical, lab-based exam where the candidate must compromise live systems and submit a professional penetration test report.

The OffSec philosophy centers on the phrase **"Try Harder"**, which captures the expectation that students develop persistence, problem-solving ability, and the methodology to attack unfamiliar systems without hand-holding. Walkthroughs and step-by-step guides are deliberately avoided.

## OffSec Certification Ladder

OffSec organizes its credentials into specialized tracks. The PEN (Penetration) track is the flagship.

### Penetration Testing Track

| Certification | Course | Focus | Difficulty |
|--------------|--------|-------|------------|
| **OSCP** | PEN-200 | General penetration testing, Linux/Windows privesc, basic AD | Foundational pentest cert |
| **OSEP** | PEN-300 | Evasion techniques, advanced AD, AV bypass, lateral movement | Advanced pentest |
| **OSWE** | WEB-300 | Advanced web application attacks, source code review, custom exploits | Specialist (web) |
| **OSED** | EXP-301 | Windows user-mode exploit development, custom shellcode, ROP | Specialist (exploit dev) |
| **OSEE** | EXP-401 | Advanced Windows exploitation, kernel exploits, sandbox escape | Expert tier |

### Three-Year Bundles and Higher Recognition

- **OSCE3** - Awarded after passing OSEP, OSWE, and OSED. Recognizes broad expert-level offensive ability.
- **OSCP+** - Renewable variant of OSCP introduced 2024 with a 3-year validity period. Existing OSCP remains lifetime.

### Other OffSec Tracks

- **OSDA** (SOC-200) - Defensive security analyst, blue team focused.
- **OSWP** (PEN-210) - Wireless penetration testing.
- **OSCC** (PEN-100 family bundle) - Foundational courses for those new to security.

## OSCP as the Entry Point

The OSCP is the most common starting credential and is the prerequisite-in-spirit for all advanced OffSec exams. Most candidates approach OffSec in this order:

1. **OSCP** (PEN-200) - prove you can compromise standalone hosts and a small AD environment.
2. **OSEP** (PEN-300) - prove you can do it under EDR/AV, with advanced AD attacks.
3. **OSWE** or **OSED** - specialize.
4. **OSEE** - expert-tier capstone.

## Industry Standing

OSCP is frequently listed in penetration tester job descriptions and red team roles. It is often compared to:

- **CompTIA PenTest+** - more theoretical, multiple-choice oriented, foundational.
- **EC-Council CEH** - heavy on terminology, lighter on hands-on.
- **GIAC GPEN / GXPN** - SANS-backed, also rigorous, more expensive.
- **eLearnSecurity eCPPT / eCPTX** - hands-on equivalents, growing in recognition.

OSCP's reputation comes from the 24-hour proctored practical exam plus the 24-hour report deliverable, which mirrors a real penetration test engagement more closely than any other entry-level certification.

## Ethics Note

All OffSec material is for **authorized penetration testing only**. The skills taught are dual-use: they are illegal to apply against systems you do not own or have written permission to test. Practice exclusively in lab environments such as the OffSec proving grounds, HackTheBox, TryHackMe, your own lab, or sanctioned client engagements with a signed scope and rules of engagement.

## Available Study Guides in This Repo

- [OSCP / PEN-200](oscp-pen-200/) - foundational penetration testing cert
