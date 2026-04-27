# Red Hat Certified System Administrator (RHCSA - EX200) - Practice Questions

12 conceptual reinforcement questions for RHCSA prep. RHCSA is **performance-based** (live RHEL 9 system) - these test concepts; you also need command-line muscle memory from hands-on labs.

> **Cert page:** [exams/redhat/rhcsa-ex200/](../../exams/redhat/rhcsa-ex200/)

---

### Question 1
**Scenario:** You need to reset the root password on a RHEL 9 system you can't log into. What's the canonical procedure (with SELinux preserved)?

A. Boot single-user mode and run `passwd`
B. Boot with `rd.break enforcing=0` → `mount -o remount,rw /sysroot` → `chroot /sysroot` → `passwd root` → `touch /.autorelabel` → reboot
C. Reinstall the OS
D. Edit /etc/shadow from rescue ISO

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** The standard recovery. `enforcing=0` is critical or `passwd` fails silently. `touch /.autorelabel` triggers SELinux relabeling on boot - skip this and the system may fail to log in afterward.
</details>

---

### Question 2
**Scenario:** A new mount must persist across reboots. Where do you configure it?

A. /etc/mtab
B. /etc/fstab (UUID or LABEL preferred over device names)
C. /etc/init.d/mount
D. ~/.bashrc

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** /etc/fstab is the canonical persistent-mount file. Use UUID (from `blkid`) instead of /dev/sdX1 because device names can change between reboots. Test with `mount -a` before rebooting.
</details>

---

### Question 3
**Scenario:** XFS supports growing online but not shrinking. Which filesystem supports both?

A. ext4
B. XFS
C. swap
D. NFS

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** ext4 supports both online grow and offline shrink (`resize2fs`). XFS only grows (`xfs_growfs`). If you need to shrink an LV, use ext4. Most RHEL 9 default-installs use XFS for root and home.
</details>

---

### Question 4
**Scenario:** Add user `alice` to the `wheel` group so she has sudo access?

A. `usermod -G wheel alice`
B. `usermod -aG wheel alice` (the -a is critical)
C. `gpasswd -a alice wheel`
D. Both B and C work; A removes alice from other groups

<details>
<summary>Answer</summary>

**Correct: D**

**Why:** `usermod -G` without `-a` REPLACES alice's secondary groups - dangerous. Always use `-aG` to APPEND. `gpasswd -a` also works and only adds. Both `-aG` and `gpasswd` are safe.
</details>

---

### Question 5
**Scenario:** SELinux is enforcing. A web app's files at `/srv/web/index.html` won't serve - HTTP 403. What's the fix?

A. Disable SELinux
B. `semanage fcontext -a -t httpd_sys_content_t '/srv/web(/.*)?'` then `restorecon -Rv /srv/web`
C. chmod 777
D. Reboot

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Files in non-default locations have wrong SELinux context. Add a permanent rule with `semanage fcontext -a` and apply with `restorecon`. Disabling SELinux is wrong on the exam.
</details>

---

### Question 6
**Scenario:** Open ports 80 and 443 in firewalld permanently?

A. `firewall-cmd --add-service=http --add-service=https`
B. `firewall-cmd --permanent --add-service=http --add-service=https && firewall-cmd --reload`
C. Edit /etc/firewalld/firewalld.conf
D. `iptables -A INPUT ...`

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Without `--permanent`, the change is runtime-only and lost on restart. After permanent changes, run `--reload` to apply. Don't mix iptables and firewalld.
</details>

---

### Question 7
**Scenario:** A systemd service must start on boot AND start now?

A. `systemctl enable servicename` (only sets up boot, doesn't start now)
B. `systemctl enable --now servicename`
C. `systemctl start servicename` (only starts now, won't run on boot)
D. Edit /etc/rc.local

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** `--now` does both enable + start in one command. The exam tests this exact form.
</details>

---

### Question 8
**Scenario:** Schedule a script to run daily at 2:30 AM?

A. cron entry: `30 2 * * * /path/script.sh`
B. systemd timer with `OnCalendar=*-*-* 02:30:00`
C. Both work
D. Neither - use Anacron only

<details>
<summary>Answer</summary>

**Correct: C**

**Why:** Both work on RHEL 9. systemd timers are the modern preference (better logging, easier dependencies); cron is still supported via crond. The exam may accept either.
</details>

---

### Question 9
**Scenario:** Permanently set SELinux to permissive mode?

A. `setenforce 0` only
B. Edit /etc/selinux/config and set `SELINUX=permissive`, then reboot (or `setenforce 0` for immediate effect)
C. Reboot only
D. `setenforce permissive`

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** `setenforce 0` is runtime-only. Persistent change requires editing /etc/selinux/config. Both is the safe pattern.
</details>

---

### Question 10
**Scenario:** Configure NTP/Chrony to sync from `time.example.com`?

A. Edit /etc/chrony.conf, replace `pool ...` lines with `server time.example.com iburst`, then `systemctl restart chronyd`
B. `ntpdate time.example.com`
C. Edit /etc/ntp.conf
D. timesyncd

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** RHEL 9 uses chrony by default (not ntpd, not timesyncd). Edit /etc/chrony.conf, restart, verify with `chronyc sources`.
</details>

---

### Question 11
**Scenario:** Default policy on systemd boot target after install (server, no GUI)?

A. graphical.target
B. multi-user.target
C. rescue.target
D. emergency.target

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Server installs default to multi-user.target (no GUI). Workstation installs default to graphical.target. Change with `systemctl set-default <target>`.
</details>

---

### Question 12
**Scenario:** Container best-practice on RHEL 9?

A. Install Docker
B. Use Podman (RHEL's daemonless, rootless-capable container runtime); persist via `podman generate systemd --new` or Quadlet
C. Run as root only
D. LXC

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** RHEL 9 ships Podman (not Docker). Podman runs rootless by default. To persist a container across reboots, generate a systemd unit with `podman generate systemd --new` or use Quadlet (`.container` files in `~/.config/containers/systemd/`).
</details>

---

## Scoring guide

- **10-12:** Strong; combine with hands-on lab time and schedule the exam.
- **7-9:** Re-read fact-sheet; do more hands-on practice.
- **<7:** Significant lab time + concept review needed.

RHCSA is **performance-based** (3 hours, ~20 hands-on tasks on a live RHEL 9 system). These multi-choice questions test concepts; you must also be fluent at the command line, fstab, systemd, SELinux, and Podman from memory.
