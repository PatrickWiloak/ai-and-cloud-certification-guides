# LFCS Study Strategy

## Study Approach

### Phase 1: Command-Line Foundation (2-3 weeks)
1. **Essential Commands**
   - Master text processing (grep, sed, awk)
   - File operations and permissions
   - Finding files and archiving
   - I/O redirection and pipes

2. **User and Group Management**
   - Create and modify users and groups
   - Configure sudo access
   - Understand PAM basics

### Phase 2: System Administration (2-3 weeks)
1. **Running Systems**
   - systemd service management
   - Process management and scheduling
   - Boot process and targets
   - Kernel module management

2. **Networking**
   - IP configuration (static and dynamic)
   - Firewall configuration with firewalld
   - SSH setup and hardening
   - Network troubleshooting tools

### Phase 3: Storage and Services (2-3 weeks)
1. **Storage Management**
   - Disk partitioning and filesystems
   - LVM workflow (create, extend, resize)
   - RAID configuration
   - Swap management

2. **Service Configuration**
   - Apache/Nginx web server setup
   - NFS and Samba file sharing
   - Basic DNS configuration
   - SSH and database configuration

### Phase 4: Exam Preparation (1 week)
1. **Practice Under Exam Conditions**
   - Timed full practice sessions
   - Use killer.sh exam simulator if available
   - Focus on weak areas

2. **Final Review**
   - Command syntax review
   - Configuration file locations
   - Troubleshooting methodology

## Study Resources

### Official
- **[📖 LFCS Certification Page](https://training.linuxfoundation.org/certification/linux-foundation-certified-sysadmin-lfcs/)** - Exam details
- **[📖 LFCS Exam Domains](https://training.linuxfoundation.org/certification/linux-foundation-certified-sysadmin-lfcs/#domains)** - Exam objectives
- **[📖 LFS201 Training Course](https://training.linuxfoundation.org/training/essentials-of-linux-system-administration/)** - Official training
- **[📖 LFCS Candidate Handbook](https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2)** - Exam rules

### Practice Environments
- **[📖 killer.sh](https://killer.sh/)** - Exam simulator (included with exam purchase)
- **[📖 KodeKloud LFCS](https://kodekloud.com/courses/linux-foundation-certified-system-administrator-lfcs/)** - Interactive labs
- **VirtualBox/VMware** - Local VM for unlimited practice
- **AWS Free Tier** - Cloud-based Ubuntu instance

### Reference Documentation
- **[📖 Ubuntu Server Guide](https://ubuntu.com/server/docs)** - Ubuntu server administration
- **[📖 GNU Coreutils Manual](https://www.gnu.org/software/coreutils/manual/)** - Essential command reference
- **[📖 systemd Documentation](https://www.freedesktop.org/software/systemd/man/)** - systemd reference
- **[📖 Linux man pages online](https://man7.org/linux/man-pages/)** - Online man pages

### Books
1. **LFCS Study Guide** by Sander van Vugt
2. **The Linux Command Line** by William Shotts (free at linuxcommand.org)
3. **How Linux Works** by Brian Ward

## Exam-Specific Strategy

### Understanding the Exam Format
- Terminal-based exam with live Linux environment
- Multiple tasks to complete within 2 hours
- Each task has specific requirements and is scored independently
- Partial credit may be available for some tasks
- You can access man pages and installed documentation
- You CANNOT access the internet during the exam
- One free retake included with exam purchase

### Time Management
- **2 hours for all tasks** - allocate time based on task complexity
- **Read all tasks first** - get an overview before starting
- **Start with confident tasks** - build momentum with tasks you know well
- **Skip difficult tasks** - come back to them later rather than getting stuck
- **Verify as you go** - check each task works before moving to the next
- **Save 15-20 minutes** - for review and verification at the end

### Using Man Pages Effectively
```bash
man command             # full manual page
man -k keyword          # search manual pages by keyword
command --help          # quick help (often enough)
apropos keyword         # find related commands
info command            # sometimes more detailed than man
/pattern                # search within man page
n / N                   # next/previous search match
```

**Practice tip:** Before the exam, practice finding information in man pages. Know the structure: NAME, SYNOPSIS, DESCRIPTION, OPTIONS, EXAMPLES.

### Key Configuration File Locations

| File | Purpose |
|------|---------|
| /etc/passwd | User account information |
| /etc/shadow | Encrypted passwords |
| /etc/group | Group definitions |
| /etc/sudoers | Sudo configuration |
| /etc/fstab | Persistent mount points |
| /etc/hosts | Local hostname resolution |
| /etc/resolv.conf | DNS configuration |
| /etc/ssh/sshd_config | SSH server configuration |
| /etc/exports | NFS share definitions |
| /etc/samba/smb.conf | Samba configuration |
| /etc/apache2/ | Apache configuration (Ubuntu) |
| /etc/nginx/ | Nginx configuration |
| /etc/crontab | System cron jobs |
| /etc/systemd/system/ | Custom systemd units |

### Common Exam Pitfalls

1. **Forgetting persistence** - Changes must survive a reboot
   - Add mounts to /etc/fstab
   - Enable services with systemctl enable
   - Use firewall-cmd --permanent
   - Save cron jobs properly

2. **Permission errors** - Run as root or use sudo when needed
   - Check file and directory permissions after creation
   - Verify ownership is correct

3. **Not verifying work** - Always test your solution
   - Mount and verify filesystems
   - Restart services and check they come back
   - Test firewall rules from another perspective
   - Verify user/group configurations with id command

4. **Typos in configuration files** - Use config test commands
   - apache2ctl configtest
   - nginx -t
   - visudo (validates syntax)
   - testparm (Samba)

5. **Forgetting to restart/reload services** - After configuration changes
   - systemctl restart service
   - systemctl reload service
   - firewall-cmd --reload
   - exportfs -a (NFS)

### Domain-Specific Tips

**Essential Commands (20%):**
- Know grep, sed, awk cold - these are foundational
- Practice find with -exec and -delete
- Know tar flags: -c (create), -x (extract), -z (gzip), -j (bzip2), -f (file)
- Understand SUID (4), SGID (2), and sticky bit (1)

**User and Group Management (15%):**
- Always use -m with useradd to create home directory
- Use -aG (append to group) with usermod, NOT -G alone (replaces groups)
- Use visudo or /etc/sudoers.d/ for sudo configuration
- Know /etc/login.defs for default user settings

**Running Systems (15%):**
- systemctl is your primary tool - master it
- journalctl -u service -f for following service logs
- Know cron field order: minute hour day-of-month month day-of-week
- Default target change: systemctl set-default target-name

**Networking (15%):**
- Know both nmcli and netplan (depending on Ubuntu version)
- firewall-cmd --permanent followed by --reload
- SSH key auth: ssh-keygen, ssh-copy-id, verify sshd_config
- Use ss -tunlp to check listening ports

**Storage Management (15%):**
- LVM workflow: pvcreate -> vgcreate -> lvcreate -> mkfs -> mount
- After lvextend, resize filesystem: resize2fs (ext4) or xfs_growfs (XFS)
- Use UUID in /etc/fstab (from blkid)
- mount -a to test fstab entries without rebooting

**Service Configuration (20%):**
- Apache: a2ensite/a2dissite, a2enmod/a2dismod
- Nginx: symlink from sites-available to sites-enabled
- NFS: /etc/exports syntax, exportfs -a
- Always test configs before restarting services

## Pre-Exam Checklist

### One Week Before
- [ ] Complete at least 2 full practice sessions under timed conditions
- [ ] All commands executable from memory (with man page for details)
- [ ] Comfortable with LVM and storage management
- [ ] Can configure services (Apache, NFS, SSH) without reference
- [ ] Used killer.sh exam simulator

### Day Before
- [ ] Light review of key file locations
- [ ] Verify PSI browser works
- [ ] Check internet connection stability
- [ ] Prepare exam workspace (clean desk, quiet room)
- [ ] Get a good night's rest

### Exam Day
- [ ] Start PSI session 15 minutes early
- [ ] Read ALL tasks before starting
- [ ] Tackle confident tasks first
- [ ] Verify each task works before moving on
- [ ] Use man pages when unsure of syntax
- [ ] Do not panic - 66% is passing, you do not need perfection
- [ ] Save time at end for review and verification
