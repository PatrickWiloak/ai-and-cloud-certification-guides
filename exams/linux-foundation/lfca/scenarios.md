# High-Yield Scenarios and Patterns

## Linux Fundamentals Scenarios

### Identifying the Right Distribution
**Scenario**: A company needs a Linux distribution for their production servers that offers long-term enterprise support, commercial backing, and certified hardware compatibility.

**Solution Pattern**: Red Hat Enterprise Linux (RHEL) or SUSE Linux Enterprise Server (SLES)

**Key Points**:
- RHEL offers 10-year lifecycle with commercial support
- CentOS Stream/Rocky Linux are free RHEL-compatible alternatives
- Ubuntu LTS also offers long-term support (5 years standard)
- Fedora is cutting-edge but not suited for production stability

**Common Distractors**:
- Arch Linux (wrong - rolling release, no enterprise support)
- Fedora (wrong - short lifecycle, not production-focused)
- Debian (partially correct - stable but no commercial support)

### Understanding Filesystem Layout
**Scenario**: An administrator needs to find where system configuration files, user home directories, and log files are stored.

**Solution Pattern**:
- Configuration: `/etc` (e.g., /etc/ssh/sshd_config, /etc/fstab)
- Home directories: `/home` (e.g., /home/alice, /home/bob)
- Log files: `/var/log` (e.g., /var/log/syslog, /var/log/auth.log)

**Common Distractors**:
- /usr/etc for configs (wrong - /etc is the standard location)
- /root for all user homes (wrong - /root is only for the root user)
- /log for logs (wrong - logs are in /var/log)

### Open Source License Selection
**Scenario**: A company wants to use open source code in their proprietary product. Which license allows this without requiring their product to also be open source?

**Solution Pattern**: MIT or Apache 2.0 (permissive licenses)

**Key Points**:
- GPL (copyleft) requires derivative works to also be GPL
- MIT and Apache 2.0 allow proprietary use
- Apache 2.0 includes patent protection
- BSD is also permissive

## System Administration Scenarios

### File Permission Configuration
**Scenario**: A web server needs to serve files from /var/www/html. The web server runs as user "www-data". Files should be readable by the web server but not writable. The admin needs full access.

**Solution Pattern**:
```
chown root:www-data /var/www/html -R
chmod 750 /var/www/html              # drwxr-x---
chmod 640 /var/www/html/*.html       # -rw-r-----
```

**Key Points**:
- Owner (root): read + write + execute on directory
- Group (www-data): read + execute on directory, read on files
- Others: no access
- 750 = rwx r-x --- (directory needs execute for listing)
- 640 = rw- r-- --- (files need read for serving)

### Service Management
**Scenario**: An application was installed that includes a systemd service file. The service needs to start automatically on boot and be running now.

**Solution Pattern**:
```bash
systemctl enable --now myapp.service
systemctl status myapp.service
```

**Key Points**:
- `enable` sets the service to start at boot
- `--now` also starts the service immediately
- `status` verifies the service is active and running
- Without `--now`, the service only starts on next boot

**Common Distractors**:
- Only using `start` (wrong - does not persist across reboots)
- Only using `enable` (wrong - does not start immediately)
- Using `restart` instead of `start` (wrong for a service not yet running)

### Package Management
**Scenario**: Install the nginx web server on an Ubuntu system and verify it is running.

**Solution Pattern**:
```bash
apt update                    # Update package lists
apt install nginx             # Install package
systemctl status nginx        # Verify running
```

**Common Distractors**:
- Using `dnf install` on Ubuntu (wrong - dnf is for RHEL/Fedora)
- Using `apt install` without `apt update` first (may fail with stale lists)
- Using `dpkg -i` without a .deb file (wrong - dpkg is for local packages)

## Cloud Computing Scenarios

### Choosing a Cloud Service Model
**Scenario**: A startup needs to deploy a web application. They want to focus on code, not on managing servers, operating systems, or runtime environments.

**Solution Pattern**: PaaS (Platform as a Service)

**Key Points**:
- IaaS: You manage the OS, middleware, and application (most control)
- PaaS: Provider manages OS and middleware, you deploy code (balanced)
- SaaS: Everything managed by provider, you just use it (least control)
- FaaS: Event-driven functions, no server management at all

**Common Distractors**:
- IaaS (wrong - still requires server management)
- SaaS (wrong - no custom application deployment)
- FaaS (partially correct - but limited to function-level execution)

### VMs vs Containers Decision
**Scenario**: A team needs to run a legacy application that requires a specific older Linux kernel version.

**Solution Pattern**: Virtual Machine (VM)

**Key Points**:
- VMs have their own kernel - can run any OS/kernel version
- Containers share the host kernel - cannot run a different kernel
- VMs provide stronger isolation between workloads
- Containers are better for microservices and rapid scaling

### Cloud Deployment Model Selection
**Scenario**: A bank needs cloud services but must keep customer financial data within their own data center due to regulations. They want to use cloud for non-sensitive workloads.

**Solution Pattern**: Hybrid cloud

**Key Points**:
- Hybrid: Combines private (on-premises) and public cloud
- Sensitive data stays on-premises (private cloud)
- Non-sensitive workloads run in public cloud
- Requires secure connectivity between environments

## DevOps Scenarios

### Git Branching Workflow
**Scenario**: A developer needs to fix a bug without disrupting the main branch.

**Solution Pattern**:
```bash
git checkout -b bugfix/login-error    # Create and switch to new branch
# ... make changes ...
git add .
git commit -m "Fix login error handling"
git push origin bugfix/login-error
# Create pull request for review
```

**Key Points**:
- Feature/bugfix branches isolate work from main
- Changes are reviewed via pull requests before merging
- Main branch stays stable and deployable
- Delete branches after merging

### CI/CD Pipeline Design
**Scenario**: A team wants to automate testing and deployment of their web application.

**Solution Pattern** (Pipeline Stages):
1. **Source** - Developer pushes code to Git
2. **Build** - Code is compiled, dependencies installed
3. **Test** - Automated unit and integration tests run
4. **Deploy to Staging** - Deploy to staging environment
5. **Deploy to Production** - Deploy to production (may require approval)

**Key Points**:
- CI (Continuous Integration): Build and test on every commit
- CD (Continuous Delivery): Automate to staging, manual production deploy
- CD (Continuous Deployment): Fully automated including production

## Security and Networking Scenarios

### SSH Key Authentication Setup
**Scenario**: Enable SSH key-based authentication and disable password authentication for a server.

**Solution Pattern**:
1. Generate key pair: `ssh-keygen -t ed25519`
2. Copy public key: `ssh-copy-id user@server`
3. Edit /etc/ssh/sshd_config:
   - `PasswordAuthentication no`
   - `PubkeyAuthentication yes`
4. Restart SSH: `systemctl restart sshd`

**Key Points**:
- Key-based authentication is more secure than passwords
- Private key stays on client, public key goes to server
- Disable password auth after verifying key access works
- Test before disconnecting to avoid lockout

### Identifying Network Issues
**Scenario**: A server cannot access the internet. How do you diagnose the issue?

**Troubleshooting Steps**:
1. `ip addr show` - Check if interface has an IP address
2. `ping gateway-ip` - Check local network connectivity
3. `ping 8.8.8.8` - Check internet connectivity (bypassing DNS)
4. `dig example.com` - Check DNS resolution
5. `ss -tunlp` - Check if services are listening
6. `firewall-cmd --list-all` - Check firewall rules

**Key Points**:
- Systematic approach: interface -> gateway -> internet -> DNS
- If ping to IP works but DNS fails, the problem is DNS configuration
- If nothing works, check the interface is up with an IP
- Check firewall rules if service is running but not accessible

### OSI Model Layer Identification
**Scenario**: Identify which OSI layer is involved in different network issues.

**Solution Pattern**:
| Issue | Layer |
|-------|-------|
| Cable unplugged | Layer 1 (Physical) |
| MAC address conflict | Layer 2 (Data Link) |
| IP address misconfigured | Layer 3 (Network) |
| TCP connection refused | Layer 4 (Transport) |
| DNS resolution failure | Layer 7 (Application) |
| HTTPS certificate error | Layer 6 (Presentation) |

**Key Points**:
- Layer 1-3: Infrastructure issues (cables, switches, routers)
- Layer 4: Transport issues (ports, connections)
- Layer 5-7: Application issues (protocols, services)
- TCP is Layer 4 (Transport), HTTP is Layer 7 (Application)
