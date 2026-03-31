# LFCS Study Plan

## 8-Week Hands-On Study Schedule

**CRITICAL: This is a performance-based exam. You MUST practice on a real Linux system daily. Reading alone will not prepare you.**

### Setup: Practice Environment (Day 0)
- [ ] Install VirtualBox or VMware on your computer
- [ ] Create Ubuntu 22.04 LTS VM (2 CPU, 4GB RAM, 40GB disk)
- [ ] Add 2-3 additional virtual disks for storage practice (5-10GB each)
- [ ] Take a snapshot as a clean baseline for easy reset
- [ ] Verify SSH access to your VM

### Week 1-2: Essential Commands

#### Day 1-3: File Operations and Permissions
- [ ] Practice navigating filesystem hierarchy (/, /etc, /var, /home, /tmp)
- [ ] Create, copy, move, rename, and delete files and directories
- [ ] Set permissions with chmod (numeric and symbolic)
- [ ] Change ownership with chown and chgrp
- [ ] Understand and set special permissions (SUID, SGID, sticky bit)
- [ ] Create hard links and symbolic links, understand the difference
- [ ] Practice: Create directory structure with specific permissions

#### Day 4-7: Text Processing
- [ ] grep - basic, extended regex, recursive, inverted, count
- [ ] sed - substitution, deletion, in-place editing
- [ ] awk - column extraction, conditionals, field separators
- [ ] cut, sort, uniq, wc, head, tail, tr
- [ ] I/O redirection: >, >>, 2>, 2>&1, &>, |, tee
- [ ] Practice: Process /etc/passwd to extract user information
- [ ] Practice: Parse log files to find specific patterns

#### Day 8-10: Finding Files and Archiving
- [ ] find - by name, type, size, time, permissions, user, exec
- [ ] locate and updatedb
- [ ] tar - create, extract, list, with gzip and bzip2 compression
- [ ] zip and unzip
- [ ] Practice: Find all files > 10MB modified in last 7 days
- [ ] Practice: Create compressed backup of a directory

#### Day 11-14: Week 1-2 Review
- [ ] Timed practice: Complete essential command tasks under pressure
- [ ] Create a cheat sheet of commands you keep forgetting
- [ ] Practice combining commands with pipes and redirection

### Week 3: User and Group Management

#### Day 15-17: User Administration
- [ ] Create users with specific properties (home, shell, groups, UID)
- [ ] Modify existing users (add to groups, change shell, lock/unlock)
- [ ] Delete users (with and without home directory)
- [ ] Set and manage passwords, password aging, account expiration
- [ ] Understand /etc/passwd, /etc/shadow, /etc/group file formats
- [ ] Practice: Create 5 users with different properties

#### Day 18-19: Sudo and PAM
- [ ] Configure sudo access using visudo
- [ ] Create sudoers drop-in files in /etc/sudoers.d/
- [ ] Understand PAM configuration files in /etc/pam.d/
- [ ] Configure user resource limits with /etc/security/limits.conf
- [ ] Practice: Set up sudo access for a group with specific command restrictions

#### Day 20-21: Week 3 Review
- [ ] Timed practice: User and group management tasks
- [ ] Create complex user scenarios (shared group directories, restricted sudo)
- [ ] Verify all configurations work correctly

### Week 4: Operation of Running Systems

#### Day 22-24: Systemd
- [ ] Start, stop, restart, reload, enable, disable services
- [ ] Check service status and troubleshoot failures
- [ ] View logs with journalctl (by service, time, priority, boot)
- [ ] Change system default target (multi-user, graphical)
- [ ] Boot into rescue and emergency mode
- [ ] Create a custom systemd service unit file
- [ ] Practice: Set up a custom service and configure it to start at boot

#### Day 25-26: Process Management
- [ ] View processes with ps, top, htop
- [ ] Send signals with kill, killall, pkill
- [ ] Manage process priority with nice and renice
- [ ] Background and foreground job control (bg, fg, jobs, &)
- [ ] nohup for persistent background processes
- [ ] Practice: Identify and kill resource-heavy processes

#### Day 27-28: Scheduling and Kernel
- [ ] Create and manage cron jobs (crontab -e, -l, -r)
- [ ] Understand cron timing fields (min, hour, dom, month, dow)
- [ ] Schedule one-time tasks with at command
- [ ] Manage kernel modules with lsmod, modprobe, modinfo
- [ ] Practice: Schedule backup scripts with cron

### Week 5: Networking

#### Day 29-31: IP Configuration
- [ ] View and configure IP addresses with ip command
- [ ] Configure static and dynamic IP with nmcli or netplan
- [ ] View and manage routing table
- [ ] Configure DNS resolution (/etc/hosts, /etc/resolv.conf)
- [ ] Understand systemd-resolved
- [ ] Practice: Configure static IP address on your VM

#### Day 32-34: Firewall and SSH
- [ ] Configure firewalld - zones, services, ports, rich rules
- [ ] Make firewall changes persistent (--permanent flag)
- [ ] Generate SSH keys (ed25519) and configure key-based auth
- [ ] Configure sshd_config (disable root login, change port)
- [ ] Practice: Allow HTTP/HTTPS through firewall, set up SSH key auth

#### Day 35: Network Troubleshooting
- [ ] ss and netstat for listening ports and connections
- [ ] ping, traceroute, mtr for connectivity testing
- [ ] dig and nslookup for DNS queries
- [ ] tcpdump for packet capture
- [ ] curl for HTTP testing
- [ ] Practice: Diagnose and fix connectivity issues

### Week 6: Storage Management

#### Day 36-38: Partitioning and Filesystems
- [ ] List block devices with lsblk and fdisk -l
- [ ] Create partitions with fdisk (MBR) and gdisk (GPT)
- [ ] Create ext4 and XFS filesystems
- [ ] Mount filesystems manually and persistently (/etc/fstab)
- [ ] Use blkid to find UUIDs
- [ ] Create and manage swap space
- [ ] Practice: Partition new disk, create filesystem, add to fstab

#### Day 39-41: LVM and RAID
- [ ] Create PV, VG, LV sequence
- [ ] Extend volume groups and logical volumes
- [ ] Resize filesystems (ext4 and XFS)
- [ ] Create RAID 1 and RAID 5 arrays with mdadm
- [ ] Monitor RAID status
- [ ] Practice: Full LVM workflow from disk to mounted filesystem

#### Day 42: Week 6 Review
- [ ] Timed practice: Complete storage tasks from scratch
- [ ] Practice extending LVM without downtime

### Week 7: Service Configuration

#### Day 43-45: Web Server (Apache/Nginx)
- [ ] Install and configure Apache
- [ ] Create virtual hosts
- [ ] Enable/disable sites and modules
- [ ] Configure basic Nginx server blocks
- [ ] Set up HTTPS with self-signed certificate
- [ ] Practice: Host multiple websites on one server

#### Day 46-48: File Sharing and DNS
- [ ] Configure NFS server and client
- [ ] Set up persistent NFS mounts
- [ ] Install and configure Samba for Windows file sharing
- [ ] Configure basic DNS with BIND (zones, records)
- [ ] Practice: Set up NFS share accessible from another VM

#### Day 49: SSH and Database
- [ ] Advanced SSH configuration
- [ ] SSH tunneling and port forwarding
- [ ] Install and configure MariaDB/MySQL
- [ ] Basic database operations (create db, user, grant)
- [ ] Practice: Set up MariaDB with a new database and user

### Week 8: Review and Exam Practice

#### Day 50-52: Full Practice Exams
- [ ] Simulate exam conditions: 2-hour timer, terminal only
- [ ] Complete practice tasks covering all domains
- [ ] Identify weak areas for focused review
- [ ] Practice using man pages for reference

#### Day 53-55: Weak Area Remediation
- [ ] Additional practice on identified weak areas
- [ ] Review commands and configurations you struggled with
- [ ] Practice multi-step tasks that combine domains

#### Day 56: Final Review
- [ ] Quick review of all command syntax
- [ ] Review fact sheet
- [ ] Light practice - avoid learning new material
- [ ] Prepare exam environment and get rest

## Daily Practice Routine (2-3 hours/day)

1. **15 minutes**: Review previous day's commands
2. **90 minutes**: Hands-on practice in VM
3. **30 minutes**: Work through practice scenarios
4. **15 minutes**: Update personal cheat sheet with new commands

## Practice Resources

### Official
- **[📖 LFCS Training Course (LFS201)](https://training.linuxfoundation.org/training/essentials-of-linux-system-administration/)** - Official course
- **[📖 Linux Foundation Exam Simulator](https://killer.sh/)** - killer.sh practice environment

### Community
- **[📖 KodeKloud LFCS Labs](https://kodekloud.com/courses/linux-foundation-certified-system-administrator-lfcs/)** - Interactive labs
- **[📖 Linux Journey](https://linuxjourney.com/)** - Free Linux learning
- **[📖 OverTheWire Bandit](https://overthewire.org/wargames/bandit/)** - Command-line practice game

## Final Exam Checklist

### Technical Preparation
- [ ] Can perform all essential commands from memory
- [ ] Can manage users and groups with specific requirements
- [ ] Can troubleshoot systemd services
- [ ] Can configure networking and firewall rules
- [ ] Can create LVM volumes and manage storage
- [ ] Can set up Apache, NFS, and Samba
- [ ] Comfortable using man pages for reference

### Exam Day
- [ ] PSI browser installed and tested
- [ ] Stable internet connection verified
- [ ] Webcam and microphone working
- [ ] Clean desk and room prepared
- [ ] Valid ID ready
- [ ] Know the exam interface (practice with killer.sh if available)
