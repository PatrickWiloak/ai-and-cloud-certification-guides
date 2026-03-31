# LFCA - Fact Sheet

## Exam Overview

**Exam Name:** Linux Foundation Certified IT Associate (LFCA)
**Duration:** 90 minutes
**Questions:** 60 multiple-choice questions
**Passing Score:** 70%
**Cost:** $250 USD
**Valid For:** 3 years
**Delivery:** Online proctored

**[📖 LFCA Certification Page](https://training.linuxfoundation.org/certification/certified-it-associate/)** - Registration and details
**[📖 Linux Foundation Training](https://training.linuxfoundation.org/)** - Official courses
**[📖 Introduction to Linux (Free)](https://training.linuxfoundation.org/training/introduction-to-linux/)** - Free foundational course

## Target Audience

This certification is designed for:
- IT professionals beginning their Linux journey
- Students pursuing a career in system administration
- Help desk and support staff expanding their skills
- Professionals transitioning from Windows to Linux
- Anyone seeking foundational Linux/cloud/DevOps knowledge

## Exam Domains

### Domain 1: Linux Fundamentals (20%)

**Linux Distributions:**
| Distribution | Family | Package Manager | Use Case |
|-------------|--------|-----------------|----------|
| Ubuntu | Debian | apt/dpkg | Desktop, servers, cloud |
| Debian | Debian | apt/dpkg | Servers, stability-focused |
| RHEL | Red Hat | dnf/rpm | Enterprise servers |
| CentOS/Rocky | Red Hat | dnf/rpm | Free RHEL alternative |
| SUSE/openSUSE | SUSE | zypper/rpm | Enterprise, Europe |
| Fedora | Red Hat | dnf/rpm | Cutting-edge features |
| Arch | Arch | pacman | Advanced users, rolling release |

**Filesystem Hierarchy Standard (FHS):**
| Directory | Purpose |
|-----------|---------|
| `/` | Root filesystem |
| `/bin` | Essential binaries (ls, cp, mv) |
| `/boot` | Boot loader files, kernel |
| `/dev` | Device files |
| `/etc` | System configuration files |
| `/home` | User home directories |
| `/lib` | Shared libraries |
| `/opt` | Optional/third-party software |
| `/proc` | Virtual filesystem (process info) |
| `/root` | Root user's home directory |
| `/sbin` | System binaries (admin tools) |
| `/tmp` | Temporary files |
| `/usr` | User programs and data |
| `/var` | Variable data (logs, mail, spool) |

**Open Source Licenses:**
| License | Type | Key Feature |
|---------|------|-------------|
| GPL v2/v3 | Copyleft | Derivatives must be GPL |
| MIT | Permissive | Minimal restrictions |
| Apache 2.0 | Permissive | Patent protection included |
| BSD | Permissive | Very minimal restrictions |
| LGPL | Copyleft (weak) | Library linking allowed |

**[📖 Filesystem Hierarchy Standard](https://refspecs.linuxfoundation.org/fhs.shtml)** - FHS specification

### Domain 2: System Administration (20%)

**User Management Commands:**
| Command | Description |
|---------|-------------|
| `useradd user` | Create user |
| `usermod -aG group user` | Add user to group |
| `userdel -r user` | Delete user and home |
| `passwd user` | Set/change password |
| `groupadd group` | Create group |
| `id user` | Show user/group IDs |
| `whoami` | Current username |

**File Permissions:**
```
-rwxrwxrwx = owner/group/others
r=4, w=2, x=1
chmod 755 file  = rwxr-xr-x
chmod 644 file  = rw-r--r--
chown user:group file
```

**Key System Admin Commands:**
| Command | Description |
|---------|-------------|
| `systemctl start/stop/restart svc` | Service management |
| `systemctl enable/disable svc` | Boot behavior |
| `journalctl -u svc` | View service logs |
| `apt install pkg` | Install package (Debian) |
| `dnf install pkg` | Install package (RHEL) |
| `ps aux` | List processes |
| `top` / `htop` | Interactive process monitor |
| `kill PID` | Terminate process |

**[📖 System Administration Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9)** - RHEL documentation

### Domain 3: Cloud Computing (20%)

**Cloud Service Models:**
| Model | Description | Examples |
|-------|-------------|---------|
| IaaS | Infrastructure as a Service | EC2, Azure VMs, GCE |
| PaaS | Platform as a Service | Heroku, App Engine, Elastic Beanstalk |
| SaaS | Software as a Service | Gmail, Salesforce, Office 365 |
| FaaS | Function as a Service | Lambda, Cloud Functions, Azure Functions |

**Cloud Deployment Models:**
| Model | Description |
|-------|-------------|
| Public | Shared infrastructure (AWS, Azure, GCP) |
| Private | Dedicated infrastructure (on-premises or hosted) |
| Hybrid | Combination of public and private |
| Multi-cloud | Using multiple cloud providers |

**Virtualization vs Containers:**
| Feature | Virtual Machines | Containers |
|---------|-----------------|------------|
| Isolation | Full OS per VM | Shared kernel |
| Size | Gigabytes | Megabytes |
| Boot time | Minutes | Seconds |
| Overhead | High | Low |
| Portability | Limited | High |
| Hypervisor | Required | Not needed |

**[📖 Cloud Computing Fundamentals](https://training.linuxfoundation.org/)** - Linux Foundation cloud training

### Domain 4: DevOps and Site Reliability (16%)

**Git Basics:**
| Command | Description |
|---------|-------------|
| `git clone url` | Clone repository |
| `git add .` | Stage changes |
| `git commit -m "msg"` | Commit changes |
| `git push` | Push to remote |
| `git pull` | Pull from remote |
| `git branch name` | Create branch |
| `git checkout branch` | Switch branch |
| `git merge branch` | Merge branch |

**CI/CD Pipeline Stages:**
1. **Source** - Code commit triggers pipeline
2. **Build** - Compile code, create artifacts
3. **Test** - Run automated tests
4. **Deploy** - Deploy to staging/production

**Configuration Management Tools:**
| Tool | Language | Agent |
|------|----------|-------|
| Ansible | YAML/Python | Agentless (SSH) |
| Puppet | Ruby/DSL | Agent-based |
| Chef | Ruby | Agent-based |
| Salt | YAML/Python | Agent-based (or agentless) |

**[📖 DevOps Fundamentals](https://training.linuxfoundation.org/)** - DevOps training

### Domain 5: Security Fundamentals (12%)

**Key Security Concepts:**
| Concept | Description |
|---------|-------------|
| Least privilege | Grant minimum required access |
| Defense in depth | Multiple security layers |
| CIA triad | Confidentiality, Integrity, Availability |
| Authentication | Verifying identity (who you are) |
| Authorization | Granting access (what you can do) |

**Linux Security Tools:**
| Tool | Purpose |
|------|---------|
| `firewalld` / `iptables` | Firewall management |
| `ssh-keygen` | Generate SSH key pairs |
| `chmod` / `chown` | File permission management |
| `sudo` | Privileged command execution |
| SELinux / AppArmor | Mandatory access control |

### Domain 6: Networking Fundamentals (12%)

**OSI Model Layers:**
| Layer | Name | Protocols/Devices |
|-------|------|------------------|
| 7 | Application | HTTP, HTTPS, DNS, SSH, FTP |
| 6 | Presentation | SSL/TLS, encryption |
| 5 | Session | Session management |
| 4 | Transport | TCP, UDP |
| 3 | Network | IP, ICMP, routers |
| 2 | Data Link | Ethernet, MAC, switches |
| 1 | Physical | Cables, signals, hubs |

**Common Ports:**
| Port | Protocol | Service |
|------|----------|---------|
| 22 | TCP | SSH |
| 25 | TCP | SMTP |
| 53 | TCP/UDP | DNS |
| 80 | TCP | HTTP |
| 443 | TCP | HTTPS |
| 3306 | TCP | MySQL |
| 5432 | TCP | PostgreSQL |

**[📖 Networking Fundamentals](https://training.linuxfoundation.org/)** - Networking training

## Key Facts to Remember

| Topic | Key Fact |
|-------|---------|
| Linux kernel creator | Linus Torvalds (1991) |
| GNU Project founder | Richard Stallman (1983) |
| GPL | Copyleft - derivatives must use same license |
| RHEL package format | RPM (.rpm) |
| Debian package format | DEB (.deb) |
| Default shell | bash |
| Root UID | 0 |
| Config files location | /etc |
| Log files location | /var/log |
| Temp files location | /tmp |
