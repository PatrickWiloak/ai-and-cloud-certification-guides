# Linux Foundation Certified System Administrator (LFCS)

## Exam Overview

The LFCS certification validates the skills needed to perform system administration tasks on Linux systems. This is a **performance-based exam** conducted entirely in a live terminal environment - you must demonstrate actual command-line skills, not just answer multiple choice questions.

**Exam Details:**
- **Exam Code:** LFCS
- **Duration:** 2 hours (120 minutes)
- **Format:** Performance-based (hands-on terminal tasks)
- **Passing Score:** 66%
- **Cost:** $395 USD (includes one free retake)
- **Proctoring:** PSI online proctoring
- **Validity:** 3 years
- **Prerequisites:** None required (basic Linux experience recommended)
- **Distributions:** Ubuntu 22.04 (default exam environment)

## CRITICAL: This is a Hands-On Exam

Unlike multiple-choice exams, LFCS requires you to perform actual tasks in a live Linux terminal. You will NOT be selecting answers from a list. You must:

- Execute commands correctly from memory
- Configure services and verify they work
- Troubleshoot real system issues
- Navigate the filesystem efficiently
- Use man pages and built-in help effectively

**The #1 study strategy is practice, practice, practice on real Linux systems.**

## Exam Domains

### Domain 1: Essential Commands (20%)
- Use streams, pipes, and redirects
- Search and process text
- Manage files and directories
- Create, manage, and use hard and soft links
- Archive, compress, and extract files
- Find files and directories

**Key Skills:**
- grep, sed, awk for text processing
- find, locate for file searching
- tar, gzip, bzip2 for archiving
- chmod, chown for permissions
- ln for links
- Redirection (>, >>, 2>, |)

### Domain 2: User and Group Management (15%)
- Create, delete, and modify local user accounts
- Create, delete, and modify local groups
- Manage system-wide and user-specific environment profiles
- Configure user resource limits
- Manage user privileges

**Key Skills:**
- useradd, usermod, userdel
- groupadd, groupmod, groupdel
- /etc/passwd, /etc/shadow, /etc/group
- sudo configuration (/etc/sudoers, visudo)
- PAM configuration
- ulimit and /etc/security/limits.conf

### Domain 3: Operation of Running Systems (15%)
- Boot, reboot, and shut down a system safely
- Boot or change system into different operating modes
- Install, configure, and troubleshoot bootloaders
- Manage and diagnose processes
- Manage and use system logging

**Key Skills:**
- systemd - systemctl, journalctl
- Boot targets (multi-user, graphical, rescue, emergency)
- Process management - ps, top, kill, nice, renice
- Scheduling - cron, at, systemd timers
- Kernel modules - lsmod, modprobe, modinfo

### Domain 4: Networking (15%)
- Configure networking and hostname resolution statically or dynamically
- Configure network services to start automatically at boot
- Implement packet filtering
- Configure firewall settings
- Troubleshoot network issues

**Key Skills:**
- IP configuration - ip, nmcli, netplan
- DNS - /etc/hosts, /etc/resolv.conf, systemd-resolved
- firewalld, iptables/nftables
- SSH configuration and key management
- Network troubleshooting - ss, ping, traceroute, dig, tcpdump

### Domain 5: Storage Management (15%)
- Manage and configure storage devices
- Create and configure file systems
- Configure and manage swap
- Configure and manage Logical Volume Management (LVM)
- Create and configure RAID devices

**Key Skills:**
- Partitioning - fdisk, gdisk, parted
- Filesystems - mkfs, mount, /etc/fstab
- LVM - pvcreate, vgcreate, lvcreate, lvextend
- RAID - mdadm
- Swap - mkswap, swapon

### Domain 6: Service Configuration (20%)
- Configure a caching DNS server
- Maintain a DNS zone
- Configure an HTTP server
- Configure HTTPS
- Configure SSH
- Configure a database server
- Configure NFS and Samba

**Key Skills:**
- Apache/Nginx configuration
- DNS (BIND) configuration
- NFS exports and mounts
- Samba shares for Windows interop
- SSH server configuration and hardening
- MariaDB/MySQL basic configuration

## Study Materials

### Notes
- [01 - Essential Commands](notes/01-essential-commands.md) - File operations, text processing, permissions
- [02 - User and Group Management](notes/02-user-group-management.md) - Users, groups, sudo, PAM
- [03 - Running Systems](notes/03-running-systems.md) - systemd, processes, boot, scheduling
- [04 - Networking](notes/04-networking.md) - IP config, firewall, DNS, SSH, troubleshooting
- [05 - Storage and Services](notes/05-storage-services.md) - Partitions, LVM, RAID, NFS, Apache, Samba

### Study Resources
- [Fact Sheet](fact-sheet.md) - Quick reference with key commands and doc links
- [Practice Plan](practice-plan.md) - Structured study schedule
- [Scenarios](scenarios.md) - Hands-on practice scenarios
- [Strategy](strategy.md) - Exam day strategy and tips

## Official Resources

- **[📖 LFCS Certification Page](https://training.linuxfoundation.org/certification/linux-foundation-certified-sysadmin-lfcs/)** - Official certification details
- **[📖 LFCS Exam Domains](https://training.linuxfoundation.org/certification/linux-foundation-certified-sysadmin-lfcs/#domains)** - Detailed exam objectives
- **[📖 LFCS Candidate Handbook](https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2)** - Exam rules and procedures
- **[📖 LFCS Exam FAQ](https://docs.linuxfoundation.org/tc-docs/certification/frequently-asked-questions-lfcs)** - Common questions
- **[📖 Linux Foundation Training](https://training.linuxfoundation.org/)** - Official training courses

## Practice Environment

### Setting Up a Practice Lab

**Option 1: Virtual Machine (Recommended)**
- Install VirtualBox or VMware
- Create Ubuntu 22.04 VM
- Practice all commands and configurations
- Take snapshots for easy reset

**Option 2: Cloud Instance**
- Launch EC2 (AWS Free Tier) or GCE instance
- Ubuntu 22.04 LTS
- Practice SSH, networking, services

**Option 3: WSL2 (Windows)**
- Ubuntu on Windows Subsystem for Linux
- Limited for some system administration tasks
- Good for command-line practice

### Essential Practice
1. Install and configure Ubuntu 22.04 from scratch
2. Set up users, groups, and permissions
3. Configure networking manually
4. Set up and manage services (Apache, SSH, NFS)
5. Create LVM volumes and manage storage
6. Write cron jobs and systemd timers
7. Configure firewalld rules
8. Troubleshoot simulated failures

## Recommended Training

### Courses
1. **Linux Foundation LFS201** - Essentials of System Administration (official)
2. **KodeKloud LFCS Course** - Hands-on labs with practice environment
3. **Sander van Vugt LFCS Course** (Pearson/O'Reilly) - Video course
4. **Linux Academy / A Cloud Guru** - Linux system administration path

### Books
1. **LFCS Study Guide** by Sander van Vugt
2. **The Linux Command Line** by William Shotts (free PDF available)
3. **UNIX and Linux System Administration Handbook**

## Next Steps After Certification

### Career Paths
- Linux System Administrator
- DevOps Engineer
- Site Reliability Engineer (SRE)
- Cloud Engineer
- Infrastructure Engineer

### Advanced Certifications
- **LFCE** - Linux Foundation Certified Engineer
- **CKA** - Certified Kubernetes Administrator
- **RHCSA/RHCE** - Red Hat certifications
- **AWS SysOps Administrator** - Cloud administration

---

**Good luck with your LFCS certification!** Remember: This is a hands-on exam. The only way to prepare is by practicing on a real Linux system. Build a lab and practice every day.
