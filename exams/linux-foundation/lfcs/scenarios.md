# LFCS - Hands-On Practice Scenarios

## How to Use These Scenarios

Each scenario simulates the type of task you will face on the LFCS exam. Set a timer and try to complete each one. After finishing, verify your work using the provided verification steps.

**Important:** Practice these on your Ubuntu 22.04 VM. Take a snapshot before starting so you can reset and retry.

---

## Essential Commands Scenarios

### Scenario 1: Text Processing Pipeline
**Task**: Extract all unique usernames from /etc/passwd that use /bin/bash as their shell, sort them alphabetically, and save to /root/bash-users.txt.

**Time limit:** 5 minutes

**Verification:**
```bash
cat /root/bash-users.txt
# Should contain sorted list of bash users
grep "/bin/bash" /etc/passwd | cut -d: -f1 | sort > /root/bash-users.txt
```

### Scenario 2: Find and Archive
**Task**: Find all files under /var/log that are larger than 1MB and were modified in the last 30 days. Create a compressed tar archive of these files at /root/recent-large-logs.tar.gz.

**Time limit:** 5 minutes

**Verification:**
```bash
tar -tzf /root/recent-large-logs.tar.gz
# Should list the matching log files
```

### Scenario 3: Permissions and Links
**Task**: 
1. Create directory /opt/shared with group ownership of "developers"
2. Set SGID on the directory so new files inherit the group
3. Set permissions so owner and group can read/write/execute, others have no access
4. Create a symbolic link from /home/dev-share pointing to /opt/shared

**Time limit:** 5 minutes

**Verification:**
```bash
ls -ld /opt/shared
# Should show drwxrws--- with group "developers" and SGID set
ls -l /home/dev-share
# Should show symlink to /opt/shared
touch /opt/shared/testfile
ls -l /opt/shared/testfile
# testfile should have "developers" as group
```

### Scenario 4: Complex Text Processing
**Task**: From /etc/passwd, create a report at /root/user-report.txt showing:
- Only users with UID >= 1000
- Format: "username - home_directory"
- Sorted by username

**Time limit:** 5 minutes

**Verification:**
```bash
cat /root/user-report.txt
# Should show format: "username - /home/username" for regular users
awk -F: '$3 >= 1000 {print $1" - "$6}' /etc/passwd | sort > /root/user-report.txt
```

---

## User and Group Management Scenarios

### Scenario 5: User and Group Setup
**Task**:
1. Create a group called "webadmins"
2. Create user "sarah" with home directory, bash shell, member of webadmins
3. Create user "mike" with home directory, bash shell, member of webadmins
4. Set password for both users to "TempPass123!"
5. Force both users to change password on next login
6. Set sarah's account to expire on December 31, 2026

**Time limit:** 10 minutes

**Verification:**
```bash
id sarah
# Should show webadmins group
id mike
# Should show webadmins group
chage -l sarah
# Should show expiration date and forced password change
chage -l mike
# Should show forced password change
```

### Scenario 6: Sudo Configuration
**Task**:
1. Create a group called "deployers"
2. Add user "deploy" to the deployers group
3. Configure sudo so that members of "deployers" can run systemctl restart and systemctl status commands without a password

**Time limit:** 10 minutes

**Verification:**
```bash
sudo -l -U deploy
# Should show NOPASSWD for systemctl restart and systemctl status
# In /etc/sudoers.d/deployers:
# %deployers ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart *, /usr/bin/systemctl status *
```

---

## Running Systems Scenarios

### Scenario 7: Custom Systemd Service
**Task**:
1. Create a script at /opt/healthcheck.sh that writes the current date and "System OK" to /var/log/healthcheck.log
2. Make the script executable
3. Create a systemd service unit that runs this script
4. Create a systemd timer that runs the service every 5 minutes
5. Enable and start the timer

**Time limit:** 15 minutes

**Verification:**
```bash
systemctl status healthcheck.timer
# Should show active
systemctl list-timers | grep healthcheck
# Should show next trigger time
cat /var/log/healthcheck.log
# Should contain timestamped entries
```

### Scenario 8: Process Management
**Task**:
1. Start a background process: `sleep 3600 &`
2. Find its PID using ps
3. Change its nice value to 10
4. Verify the priority change
5. Send SIGTERM to terminate it
6. Verify it is no longer running

**Time limit:** 5 minutes

**Verification:**
```bash
ps aux | grep sleep
# Should show no matching process after kill
```

### Scenario 9: Cron Job Setup
**Task**:
1. Create a cron job for the root user that runs every day at 2:30 AM
2. The job should create a backup of /etc to /backup/etc-backup-$(date +%Y%m%d).tar.gz
3. Create a cron job that runs every Monday at 6 PM to clean up backups older than 30 days

**Time limit:** 10 minutes

**Verification:**
```bash
crontab -l
# Should show two cron entries
# 30 2 * * * tar -czf /backup/etc-backup-$(date +\%Y\%m\%d).tar.gz /etc
# 0 18 * * 1 find /backup -name "etc-backup-*.tar.gz" -mtime +30 -delete
```

---

## Networking Scenarios

### Scenario 10: Static IP Configuration
**Task**:
1. Configure a network interface with a static IP address 192.168.1.100/24
2. Set the default gateway to 192.168.1.1
3. Configure DNS servers to 8.8.8.8 and 8.8.4.4
4. Ensure the configuration persists across reboots

**Time limit:** 10 minutes

**Verification:**
```bash
ip addr show
# Should show 192.168.1.100/24
ip route show
# Should show default via 192.168.1.1
resolvectl status
# Should show DNS servers
```

### Scenario 11: Firewall Configuration
**Task**:
1. Ensure firewalld is running and enabled
2. Set the default zone to "public"
3. Allow SSH (22/tcp), HTTP (80/tcp), and HTTPS (443/tcp) permanently
4. Block all other incoming traffic
5. Add a rich rule to allow traffic from 10.0.0.0/8 network to port 3306/tcp

**Time limit:** 10 minutes

**Verification:**
```bash
firewall-cmd --list-all
# Should show ssh, http, https services and rich rule for 3306
```

### Scenario 12: SSH Hardening
**Task**:
1. Generate an ED25519 SSH key pair for user "admin"
2. Copy the public key to the server
3. Configure sshd to disable root login
4. Configure sshd to disable password authentication
5. Change SSH port to 2222
6. Restart SSH service and verify it is listening on the new port

**Time limit:** 15 minutes

**Verification:**
```bash
ss -tunlp | grep 2222
# Should show sshd listening on port 2222
grep "PermitRootLogin no" /etc/ssh/sshd_config
grep "PasswordAuthentication no" /etc/ssh/sshd_config
grep "Port 2222" /etc/ssh/sshd_config
```

---

## Storage Scenarios

### Scenario 13: LVM Full Workflow
**Task**:
1. Create a physical volume on /dev/sdb
2. Create a volume group called "datavg" using /dev/sdb
3. Create a logical volume called "datalv" of size 5GB
4. Format datalv with ext4 filesystem
5. Mount it at /data with persistent mount in /etc/fstab
6. Extend datalv by 2GB and resize the filesystem

**Time limit:** 15 minutes

**Verification:**
```bash
lvdisplay /dev/datavg/datalv
# Should show 7GB size
df -h /data
# Should show mounted ext4 filesystem with ~7GB
grep datavg /etc/fstab
# Should show persistent mount entry
```

### Scenario 14: RAID 1 Setup
**Task**:
1. Create a RAID 1 array (/dev/md0) using /dev/sdc1 and /dev/sdd1
2. Create an ext4 filesystem on /dev/md0
3. Mount at /mnt/raid1
4. Add to /etc/fstab for persistence
5. Verify RAID status

**Time limit:** 15 minutes

**Verification:**
```bash
cat /proc/mdstat
# Should show md0 : active raid1
mdadm --detail /dev/md0
# Should show 2 active devices
df -h /mnt/raid1
# Should show mounted filesystem
```

### Scenario 15: Swap Management
**Task**:
1. Create a 1GB swap file at /swapfile
2. Set appropriate permissions (600)
3. Format as swap
4. Enable the swap file
5. Add to /etc/fstab for persistence
6. Verify swap is active

**Time limit:** 10 minutes

**Verification:**
```bash
free -h
# Should show swap increased by 1GB
swapon --show
# Should show /swapfile
```

---

## Service Configuration Scenarios

### Scenario 16: Apache Virtual Host
**Task**:
1. Install Apache web server
2. Create document root at /var/www/mysite
3. Create an index.html with any content
4. Configure a virtual host for mysite.local
5. Enable the site and restart Apache
6. Allow HTTP through the firewall
7. Test with curl

**Time limit:** 15 minutes

**Verification:**
```bash
curl -H "Host: mysite.local" http://localhost
# Should return the index.html content
systemctl is-active apache2
# Should show active
```

### Scenario 17: NFS Share
**Task**:
1. Install NFS server
2. Create directory /exports/shared
3. Create some test files in the shared directory
4. Export /exports/shared to the 192.168.1.0/24 network with rw access
5. Start and enable the NFS service
6. Mount the NFS share locally at /mnt/nfs for testing

**Time limit:** 15 minutes

**Verification:**
```bash
exportfs -v
# Should show /exports/shared with rw for 192.168.1.0/24
mount | grep nfs
# Should show mounted NFS share
ls /mnt/nfs
# Should show the test files
```

### Scenario 18: Comprehensive Multi-Domain Task
**Task**:
1. Create user "webdev" in group "www-data" with bash shell
2. Create /var/www/project owned by webdev:www-data with SGID
3. Install and configure Nginx to serve /var/www/project
4. Open port 80 in firewall
5. Create an LVM volume for web data, mount at /var/www/project
6. Set up a cron job to back up /var/www/project daily at midnight

**Time limit:** 25 minutes

**Verification:**
```bash
id webdev
curl http://localhost
ls -ld /var/www/project
lvdisplay
crontab -l
systemctl is-active nginx
firewall-cmd --list-services
```

---

## Tips for Practice

1. **Time yourself** - The exam is time-pressured, practice under time constraints
2. **Use man pages** - Get comfortable using `man command` for reference
3. **Verify everything** - After each task, verify it works correctly
4. **Reset and repeat** - Restore your VM snapshot and do the same tasks again
5. **Combine domains** - Real tasks often span multiple domains
6. **Build muscle memory** - Repeat commands until they become automatic
7. **Learn to troubleshoot** - When something goes wrong, diagnose rather than starting over
