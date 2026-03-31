# LFCA - Study Strategy

## Study Approach

### Phase 1: Linux Fundamentals (1-2 weeks)
1. **Linux Basics**
   - Learn Linux history, distributions, and open source licensing
   - Understand the Filesystem Hierarchy Standard
   - Practice basic shell commands (ls, cd, cp, mv, rm, mkdir, cat)
   - Learn a text editor (vi/vim or nano)

2. **Hands-on Practice**
   - Install Linux in a virtual machine (Ubuntu recommended)
   - Navigate the filesystem and explore directory structure
   - Practice command-line operations daily
   - Learn to use man pages and --help

### Phase 2: System Administration and Security (2-3 weeks)
1. **System Administration**
   - Learn user and group management commands
   - Understand file permissions (read/write/execute, chmod, chown)
   - Practice service management with systemctl
   - Learn package management (apt for Debian, dnf for RHEL)
   - Understand process management (ps, top, kill)

2. **Security**
   - Learn basic firewall concepts (firewalld, iptables)
   - Understand SSH key-based authentication
   - Study encryption basics (symmetric, asymmetric, hashing)
   - Learn about TLS/SSL certificates
   - Understand the CIA triad and security best practices

### Phase 3: Cloud and Networking (2-3 weeks)
1. **Cloud Computing**
   - Study cloud service models (IaaS, PaaS, SaaS)
   - Understand virtualization vs containers
   - Learn Docker basics (images, containers, Dockerfiles)
   - Study Kubernetes overview (pods, services, deployments)
   - Explore major cloud providers (AWS, Azure, GCP)

2. **Networking**
   - Study the OSI and TCP/IP models
   - Learn IP addressing and subnetting basics
   - Understand DNS, DHCP, and HTTP/HTTPS
   - Practice network troubleshooting commands
   - Memorize common port numbers

### Phase 4: DevOps and Exam Prep (1-2 weeks)
1. **DevOps**
   - Learn Git basics (clone, add, commit, push, pull, branch)
   - Study CI/CD pipeline concepts
   - Understand configuration management (Ansible, Puppet, Chef)
   - Learn Infrastructure as Code concepts (Terraform)

2. **Exam Preparation**
   - Take practice exams
   - Review weak areas
   - Focus on high-weight domains (Linux, System Admin, Cloud - 60%)

## Study Resources

### Official Resources
- **[📖 Introduction to Linux (LFS101)](https://training.linuxfoundation.org/training/introduction-to-linux/)** - Free course
- **[📖 Linux Foundation Training](https://training.linuxfoundation.org/)** - All courses
- **[📖 LFCA Exam Curriculum](https://training.linuxfoundation.org/certification/certified-it-associate/)** - Exam details

### Free Learning Resources
- **[📖 Linux Journey](https://linuxjourney.com/)** - Interactive Linux tutorials
- **[📖 The Linux Documentation Project](https://tldp.org/)** - Community docs
- **[📖 OverTheWire Bandit](https://overthewire.org/wargames/bandit/)** - Linux command practice
- **[📖 Docker Getting Started](https://docs.docker.com/get-started/)** - Docker tutorial

### Practice
- **[📖 VirtualBox](https://www.virtualbox.org/)** - Free VM software for practice
- **[📖 Play with Docker](https://labs.play-with-docker.com/)** - Browser-based Docker lab
- **[📖 Katacoda/Killercoda](https://killercoda.com/)** - Interactive scenarios

## Exam Tactics

### Question Strategy
1. **Linux Fundamentals (20%)** - Know distributions, FHS, basic commands
2. **System Administration (20%)** - Know user management, permissions, systemctl
3. **Cloud Computing (20%)** - Know service models, VMs vs containers
4. **DevOps (16%)** - Know Git commands, CI/CD concepts
5. **Security (12%)** - Know firewalls, SSH, encryption basics
6. **Networking (12%)** - Know OSI model, common ports, IP addressing

### Time Management
- 1.5 minutes per question average
- Flag and move - do not spend more than 2 minutes on any question
- Reserve 10-15 minutes for reviewing flagged questions
- This is MCQ only - no hands-on terminal

### Key Areas to Master
- Linux distribution families and package managers
- Filesystem Hierarchy Standard directories
- File permission numeric notation (chmod 755, 644, etc.)
- Cloud service models (IaaS vs PaaS vs SaaS)
- VM vs container differences
- Git basic workflow
- OSI model layers and common ports
- CIA triad and basic security concepts

## Common Pitfalls

1. **Confusing apt and dnf** - apt is Debian/Ubuntu, dnf is RHEL/Fedora
2. **Permission math errors** - rwx=7, rw-=6, r-x=5, r--=4
3. **IaaS vs PaaS** - IaaS gives you the server, PaaS gives you the platform
4. **TCP vs UDP** - TCP is connection-oriented (reliable), UDP is connectionless (fast)
5. **Containers share the kernel** - VMs each have their own OS
6. **GPL is copyleft** - MIT and Apache are permissive
7. **/etc vs /var** - /etc is configuration, /var is variable data (logs)
8. **Ansible is agentless** - Uses SSH, unlike Puppet/Chef which use agents
