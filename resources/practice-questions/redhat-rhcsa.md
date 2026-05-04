# Red Hat Certified System Administrator (RHCSA - EX200) - Practice Questions

25 conceptual reinforcement questions for RHCSA prep. RHCSA is **performance-based** (live RHEL 9 system) - these test concepts; you also need command-line muscle memory from hands-on labs.

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

### Question 13
**Scenario:** You need to grow `/data` (an XFS filesystem on an LVM logical volume) without unmounting. Sequence?

A. Reformat
B. Extend the underlying VG with `vgextend` if needed → extend the LV with `lvextend -L +5G /dev/mapper/vg-data` → grow the XFS filesystem online with `xfs_growfs /data`
C. mkfs again
D. resize2fs

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** XFS supports online growth (never shrink). Sequence: physical / VG / LV / FS. `resize2fs` is for ext4. Memorize this exact LVM growth pattern - it's a guaranteed exam task.
</details>

---

### Question 14
**Scenario:** A user can't write to `/srv/web` despite Linux permissions allowing it. SELinux is enforcing. What's the diagnostic step?

A. Disable SELinux permanently
B. Check `audit2allow -a` or `journalctl _AUDIT_TYPE_NAME=AVC` for AVC denials, identify the expected context with `matchpathcon`, and apply the right context with `chcon` (test) or `semanage fcontext` + `restorecon` (persist)
C. chmod 777
D. Reboot

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** SELinux denies enforce file context, not Unix perms. The fix is to set the right context, not disable enforcement. `semanage fcontext -a -t httpd_sys_rw_content_t` makes the context persistent across `restorecon`.
</details>

---

### Question 15
**Scenario:** A non-privileged user needs to run only `systemctl restart nginx` as root. Best approach?

A. Add to wheel
B. `sudo` rule in `/etc/sudoers.d/nginx-restart` granting just that command, no password prompt if needed: `user ALL=(root) NOPASSWD: /usr/bin/systemctl restart nginx`
C. Share root password
D. setuid the binary

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Sudo with command-scoped grants is the standard for least-privilege. Always use `/etc/sudoers.d/` (not direct edits to `/etc/sudoers`) and `visudo -c` to validate syntax. setuid root binaries are a security anti-pattern.
</details>

---

### Question 16
**Scenario:** Setting a cron job to run a script every weekday at 9 AM?

A. `0 9 * * 1-5 /path/to/script` in user's crontab (`crontab -e`) or in `/etc/cron.d/myjob` for system jobs
B. `* * * * * script`
C. systemd reload
D. /etc/anacrontab

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Cron format: minute hour day-of-month month day-of-week. 1-5 = Mon-Fri. User crontabs run as the user; system cron files in `/etc/cron.d/` specify the user explicitly. systemd timers are the modern alternative for new RHEL deployments.
</details>

---

### Question 17
**Scenario:** Mounting a remote NFS share at `/mnt/nfs` persistently?

A. mount command at boot
B. Add to `/etc/fstab`: `server:/path /mnt/nfs nfs defaults,_netdev 0 0` and run `systemctl daemon-reload && mount -a`
C. autofs only
D. SMB mount

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** `_netdev` ensures the mount waits for network. fstab is the persistent mount mechanism. Test with `mount -a` before reboot to catch typos. autofs is an alternative for on-demand mounts.
</details>

---

### Question 18
**Scenario:** A service must start after another (e.g., `myapp.service` after `network-online.target`). Where does that go?

A. Cron
B. In the unit file's `[Unit]` section: `After=network-online.target` and `Wants=network-online.target` (and enable network-online if needed)
C. /etc/rc.local
D. Comment in script

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** systemd ordering uses `After=` (ordering) and `Wants=` or `Requires=` (dependency strength). `network-online.target` is the standard "network is fully up" sync point. After editing, `systemctl daemon-reload`.
</details>

---

### Question 19
**Scenario:** Resetting the root password on a system you can reboot?

A. Reinstall
B. Boot to single-user / emergency shell, edit kernel command line in GRUB to add `rd.break`, mount /sysroot rw, chroot, `passwd`, `touch /.autorelabel`, exit, reboot
C. Use systemd-cat
D. dnf install

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Classic RHEL recovery. `rd.break` interrupts the initramfs early. After password change, `/.autorelabel` triggers SELinux relabeling on next boot (otherwise SELinux denies access to the changed shadow file).
</details>

---

### Question 20
**Scenario:** Container management on RHEL 9 - which is native?

A. Docker
B. Podman - daemonless, rootless, drop-in compatible with `docker` CLI; preferred on RHEL 9. Also: `podman generate systemd` or Quadlets to run containers as systemd services
C. LXC
D. Vagrant

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** RHEL 9 ships Podman, not Docker. Rootless containers are first-class. Quadlets (RHEL 9.3+) declaratively define container services; older flow used `podman generate systemd`. Both put container lifecycle under systemd.
</details>

---

### Question 21
**Scenario:** Locking down SSH: which combination hardens the service most reliably?

A. Change port only
B. Disable root login (`PermitRootLogin no`), disable password auth (`PasswordAuthentication no`) and use key auth, restrict via firewalld + fail2ban for brute-force, log via journald
C. Disable SSH entirely
D. Open port 22 to all

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Layered: identity (keys, no root), auth method (no passwords), exposure (firewalld limits source), and observability (logs + brute-force detection). Port-changing is security theater - real attackers scan all ports.
</details>

---

### Question 22
**Scenario:** Configuring a static IP on RHEL 9 (NetworkManager-managed)?

A. Edit `/etc/network/interfaces`
B. Use `nmcli con mod <conn> ipv4.method manual ipv4.addresses 10.0.0.5/24 ipv4.gateway 10.0.0.1 ipv4.dns 8.8.8.8` then `nmcli con up <conn>`; or edit the keyfile in `/etc/NetworkManager/system-connections/`
C. ifconfig
D. dhclient

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** RHEL 9 deprecated `/etc/sysconfig/network-scripts/ifcfg-*` in favor of NetworkManager keyfiles. `nmcli` is the supported CLI. `ifconfig` is deprecated; use `ip` if you need raw config.
</details>

---

### Question 23
**Scenario:** Auditing user activity - "who ran what when"?

A. tail /var/log/messages
B. Combine: `last` for login history, `journalctl _UID=N` per user, `aureport -au` from auditd, plus `~/.bash_history` (untrusted - users can modify); for compliance, configure auditd rules on syscalls of interest
C. dmesg
D. ps only

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Multiple sources. `last`/`lastb` for logins, journald for service activity, auditd for kernel-level audit records (file access, syscalls). Bash history is user-modifiable so it's a hint, not evidence. Centralize logs to a remote syslog/SIEM for tamper resistance.
</details>

---

### Question 24
**Scenario:** Setting an ACL so a specific user has read+write on a file beyond standard Unix perms?

A. chmod 777
B. `setfacl -m u:alice:rw filename`; verify with `getfacl filename`. Default ACLs on directories propagate to new files: `setfacl -m d:u:alice:rw /path`
C. chown alice
D. SELinux booleans

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** POSIX ACLs let you grant specific users/groups beyond the owner/group/other model. `getfacl/setfacl` is the standard CLI. Filesystem must be mounted with ACLs enabled (default on XFS / ext4).
</details>

---

### Question 25
**Scenario:** Disk space on `/var` is critical. What's the diagnostic ladder?

A. Reboot first
B. `df -h` to confirm full filesystem → `du -sh /var/* | sort -h` to find culprit dirs → for journald, `journalctl --disk-usage` and `journalctl --vacuum-size=200M` to trim → for log files, rotate or compress; check `/var/lib/docker` or `/var/lib/containers` for image bloat
C. Format /var
D. delete /var

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Standard space-investigation workflow. Common culprits on `/var`: journald accumulation, /var/log/, container images, /var/lib/mysql /pgsql data. `journalctl --vacuum-*` is the safe trim command for journald specifically.
</details>

---

## Scoring guide

- **22-25:** Strong; combine with hands-on lab time and schedule the exam.
- **15-21:** Re-read fact-sheet; do more hands-on practice.
- **<15:** Significant lab time + concept review needed.

RHCSA is **performance-based** (3 hours, ~20 hands-on tasks on a live RHEL 9 system). These multi-choice questions test concepts; you must also be fluent at the command line, fstab, systemd, SELinux, and Podman from memory.
