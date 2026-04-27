# RHCSA (EX200) - 6-Week Practice Plan

This plan assumes 1-2 hours of theory + 1-2 hours of hands-on lab per day. Adjust if you need more time.

The most important thing about RHCSA prep is **lab time**. Reading is necessary but insufficient.

---

## Lab setup (do this in week 1, day 1)

- [ ] Activate a free Red Hat Developer subscription at [developers.redhat.com](https://developers.redhat.com)
- [ ] Download RHEL 9 ISO
- [ ] Create two RHEL 9 VMs in VirtualBox / VMware / KVM (4 GB RAM, 20 GB disk each)
- [ ] One is your "system under test", the other is your "remote server" for NFS / SSH / firewall tasks
- [ ] Take a clean snapshot you can roll back to before each major lab

---

## Week 1 - Essentials and Boot

### Reading
- [ ] [README.md](./README.md) full read
- [ ] [fact-sheet.md](./fact-sheet.md) skim
- [ ] [notes/01-system-config.md](./notes/01-system-config.md)

### Hands-on
- [ ] Reset root password using `rd.break enforcing=0` recovery
- [ ] Boot to rescue, emergency, and multi-user targets
- [ ] Change default target between graphical and multi-user
- [ ] Configure NTP via chronyd; verify with `chronyc sources`
- [ ] Set timezone to UTC then back

### Self-check
- [ ] Can I reset the root password without notes?
- [ ] Can I switch boot targets at GRUB?
- [ ] Do I know the order: firmware → GRUB → kernel → initramfs → systemd?

---

## Week 2 - Storage, LVM, Filesystems

### Reading
- [ ] [notes/02-storage-filesystems.md](./notes/02-storage-filesystems.md)
- [ ] RHEL 9 docs: [Managing Storage Devices](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/managing_storage_devices/index)

### Hands-on
- [ ] Add a new virtual disk to your VM
- [ ] Create partition with `fdisk`, format ext4 + xfs, mount, add to fstab with UUID
- [ ] Build an LVM stack: pvcreate → vgcreate → lvcreate → mkfs.xfs → mount
- [ ] Extend LV by 2 GB and grow XFS online
- [ ] Configure swap on a partition AND on a swap file
- [ ] Mount an NFS share from your second VM
- [ ] Set ACLs on a file (`setfacl -m u:bob:rw- file`)

### Self-check
- [ ] Can I build a full LVM stack in under 5 minutes?
- [ ] Do I know that XFS can extend but NOT shrink?
- [ ] Can I diagnose a fstab error without rebooting (use `mount -a`)?

---

## Week 3 - Users, Groups, Permissions

### Reading
- [ ] [notes/03-users-groups-permissions.md](./notes/03-users-groups-permissions.md)

### Hands-on
- [ ] Create users with specific UIDs, primary groups, secondary groups
- [ ] Configure password aging with `chage`
- [ ] Lock and unlock accounts
- [ ] Add users to wheel group and confirm sudo works
- [ ] Configure passwordless sudo for a specific group
- [ ] Allow user to run only specific commands as root
- [ ] Build a group-collaborative directory with SGID
- [ ] Set ACLs to give a non-group user read access

### Self-check
- [ ] Do I always use `usermod -aG` (with -a) to add to secondary groups?
- [ ] Can I read `/etc/sudoers` syntax fluently?
- [ ] Do I know SGID dirs make new files inherit the dir's group?

---

## Week 4 - systemd, Logs, Processes

### Reading
- [ ] [notes/04-services-systemd.md](./notes/04-services-systemd.md)

### Hands-on
- [ ] Create a custom systemd service unit (write the .service file)
- [ ] Override an existing unit with `systemctl edit`
- [ ] Create a systemd timer that runs daily
- [ ] Convert the same job to a cron entry
- [ ] Use `journalctl` to find errors from a specific service over the last hour
- [ ] Make journal logs persistent
- [ ] Manage processes: nice, renice, kill, killall, pgrep

### Self-check
- [ ] Can I write a basic .service file from memory?
- [ ] Do I always run `systemctl daemon-reload` after editing units?
- [ ] Can I read `journalctl -u nginx -b` and find what failed?

---

## Week 5 - Networking, Firewalld, SELinux, SSH

### Reading
- [ ] [notes/05-networking-security-selinux.md](./notes/05-networking-security-selinux.md)

### Hands-on
- [ ] Configure static IP, gateway, DNS with `nmcli`
- [ ] Set hostname with `hostnamectl`
- [ ] Configure firewalld: open HTTP, HTTPS, custom port, rich rule
- [ ] Configure SSH key auth between your two VMs
- [ ] Disable root SSH login and password auth
- [ ] Set SELinux to permissive, observe AVC denials, then back to enforcing
- [ ] Use `chcon` and `semanage fcontext` to fix a context for a non-default web root
- [ ] Use `setsebool -P httpd_can_network_connect on`

### Self-check
- [ ] Can I configure static networking with `nmcli` from memory?
- [ ] Do I know SELinux booleans need `-P` to persist?
- [ ] Can I diagnose an SELinux denial with `ausearch -m avc -ts recent`?

---

## Week 6 - Containers, Mock Exams, Weak Areas

### Reading
- [ ] [notes/06-containers-podman.md](./notes/06-containers-podman.md)
- [ ] Re-read [fact-sheet.md](./fact-sheet.md) end to end
- [ ] Work through [scenarios.md](./scenarios.md)

### Hands-on
- [ ] Pull image, run container, map port, mount volume with `:Z`
- [ ] Build a custom image from a Containerfile
- [ ] Generate a systemd unit with `podman generate systemd --new`
- [ ] Make a rootless container survive reboot via `loginctl enable-linger`
- [ ] Try Quadlet (drop a `.container` file in `~/.config/containers/systemd/`)

### Mock exams
- [ ] Sander van Vugt's RHCSA practice exam (free chapter excerpts available)
- [ ] Asghar Ghori's practice exams
- [ ] Build your own: pick 8 tasks from `scenarios.md` and time yourself for 90 minutes
- [ ] Score 80%+ on a clean lab before scheduling

### Final review
- [ ] All six notes files re-read
- [ ] Every command in fact-sheet.md typed at least once
- [ ] Reboot test at the end of every practice session

### Schedule the exam
- [ ] Book through [redhat.com](https://www.redhat.com/en/services/certification)
- [ ] Choose Individual Exam (online) or testing center
- [ ] Confirm 3-hour slot
- [ ] Plan exam-day logistics (ID, quiet space if online)

---

## Daily routine (suggested)

| Time | Activity |
|---|---|
| 30 min | Read notes / fact-sheet section |
| 60-90 min | Hands-on lab on the day's topic |
| 15 min | Verify with reboot, then write a one-line cheat sheet for what you learned |

---

## Stop signals (when you're ready)

- [ ] You can do all 15 scenarios in [scenarios.md](./scenarios.md) end-to-end without notes, with reboot test, in under 90 minutes total
- [ ] You can reset the root password without looking it up
- [ ] You can build a full LVM stack from disk addition to mounted XFS in < 5 minutes
- [ ] You can write a systemd .service file from memory
- [ ] You can troubleshoot an SELinux denial with `ausearch` / `sealert`
- [ ] You've rebooted and everything you set up still works

When all six are true, schedule the exam.
