# LFCS Fact Sheet

## Quick Reference

**Exam:** Linux Foundation Certified System Administrator
**Duration:** 2 hours (120 minutes)
**Format:** Performance-based (hands-on terminal)
**Passing Score:** 66%
**Cost:** $395 USD (includes one free retake)
**Proctoring:** PSI online
**Distribution:** Ubuntu 22.04

## Exam Domain Breakdown

| Domain | Weight | Focus |
|--------|--------|-------|
| Essential Commands | 20% | Text processing, file ops, permissions, archiving |
| User and Group Management | 15% | Users, groups, sudo, PAM, profiles |
| Operation of Running Systems | 15% | systemd, processes, boot, scheduling, kernel |
| Networking | 15% | IP config, firewall, DNS, SSH, troubleshooting |
| Storage Management | 15% | Partitions, filesystems, LVM, RAID, swap |
| Service Configuration | 20% | Apache/Nginx, DNS, NFS, Samba, SSH, DB |

## Essential Commands Quick Reference

### Text Processing
```bash
# grep - search for patterns
grep "pattern" file
grep -r "pattern" /path      # recursive search
grep -i "pattern" file        # case-insensitive
grep -v "pattern" file        # invert match (exclude)
grep -c "pattern" file        # count matches
grep -n "pattern" file        # show line numbers
grep -E "regex" file          # extended regex (egrep)

# sed - stream editor
sed 's/old/new/' file         # replace first occurrence per line
sed 's/old/new/g' file        # replace all occurrences
sed -i 's/old/new/g' file     # in-place edit
sed -n '5,10p' file           # print lines 5-10
sed '/pattern/d' file         # delete matching lines

# awk - pattern processing
awk '{print $1}' file         # print first column
awk -F: '{print $1}' file    # custom delimiter
awk '$3 > 100' file           # conditional filter
awk 'NR==5' file              # print line 5
awk '{sum+=$1} END {print sum}' file  # sum column

# Other text tools
cut -d: -f1 /etc/passwd       # cut by delimiter
sort file                      # sort lines
sort -n file                   # numeric sort
sort -r file                   # reverse sort
uniq file                      # remove adjacent duplicates
sort file | uniq -c            # count duplicates
wc -l file                    # count lines
head -n 20 file               # first 20 lines
tail -n 20 file               # last 20 lines
tail -f /var/log/syslog       # follow log in real-time
tr 'a-z' 'A-Z' < file        # translate characters
```

**Documentation:**
- **[📖 GNU Grep Manual](https://www.gnu.org/software/grep/manual/)** - Complete grep reference
- **[📖 GNU Sed Manual](https://www.gnu.org/software/sed/manual/)** - Complete sed reference
- **[📖 GNU Awk Manual](https://www.gnu.org/software/gawk/manual/)** - Complete awk reference

### File Operations
```bash
# Permissions
chmod 755 file                # rwxr-xr-x
chmod u+x file                # add execute for owner
chmod -R 644 /path            # recursive
chown user:group file         # change ownership
chown -R user:group /path     # recursive ownership

# Special permissions
chmod u+s file                # SUID (4xxx) - run as owner
chmod g+s dir                 # SGID (2xxx) - inherit group
chmod +t dir                  # Sticky bit (1xxx) - only owner can delete

# Links
ln source hardlink            # hard link (same inode)
ln -s source symlink          # symbolic/soft link

# Find
find /path -name "*.log"      # find by name
find /path -type f -size +10M # files > 10MB
find /path -mtime -7          # modified in last 7 days
find /path -user root         # owned by root
find /path -perm 644          # exact permissions
find /path -name "*.tmp" -exec rm {} \;  # find and execute
find /path -name "*.log" -delete         # find and delete

# Archive and compress
tar -czf archive.tar.gz /path   # create gzipped tar
tar -cjf archive.tar.bz2 /path  # create bzip2 tar
tar -xzf archive.tar.gz         # extract gzipped tar
tar -xzf archive.tar.gz -C /dest  # extract to directory
tar -tzf archive.tar.gz         # list contents
gzip file                       # compress (replaces original)
gunzip file.gz                  # decompress
bzip2 file                      # bzip2 compress
zip archive.zip file1 file2     # create zip
unzip archive.zip               # extract zip
```

### I/O Redirection
```bash
command > file        # stdout to file (overwrite)
command >> file       # stdout to file (append)
command 2> file       # stderr to file
command 2>&1          # stderr to stdout
command &> file       # both stdout and stderr to file
command < file        # stdin from file
command1 | command2   # pipe stdout to next command
command | tee file    # stdout to both screen and file
```

## User and Group Management

```bash
# User management
useradd -m -s /bin/bash username    # create user with home and shell
useradd -m -G sudo,docker username  # create with supplementary groups
usermod -aG groupname username      # add to group (append!)
usermod -L username                 # lock account
usermod -U username                 # unlock account
userdel -r username                 # delete user and home directory
passwd username                     # set password
chage -l username                   # view password aging
chage -M 90 username               # max password age 90 days
chage -E 2026-12-31 username       # account expiration date

# Group management
groupadd groupname                  # create group
groupmod -n newname oldname        # rename group
groupdel groupname                 # delete group
id username                        # show user info
groups username                    # show user's groups

# Important files
/etc/passwd    # user accounts (username:x:UID:GID:comment:home:shell)
/etc/shadow    # encrypted passwords and aging
/etc/group     # group definitions
/etc/gshadow   # group passwords
/etc/skel/     # skeleton directory for new users
/etc/login.defs  # default login settings

# sudo configuration
visudo                             # safely edit /etc/sudoers
# Format: user ALL=(ALL:ALL) ALL
# %group ALL=(ALL:ALL) ALL        # group sudo access
# user ALL=(ALL) NOPASSWD: ALL    # no password required
/etc/sudoers.d/                    # drop-in files
```

**Documentation:**
- **[📖 Ubuntu User Management](https://ubuntu.com/server/docs/security-users)** - User administration guide
- **[📖 Linux PAM Documentation](http://www.linux-pam.org/Linux-PAM-html/)** - PAM configuration guide

## Systemd and Process Management

```bash
# systemctl
systemctl start service           # start service
systemctl stop service            # stop service
systemctl restart service         # restart service
systemctl reload service          # reload configuration
systemctl enable service          # start at boot
systemctl disable service         # don't start at boot
systemctl enable --now service    # enable and start
systemctl status service          # check status
systemctl is-active service       # check if running
systemctl is-enabled service      # check if enabled
systemctl list-units --type=service  # list services
systemctl list-unit-files         # list all unit files
systemctl daemon-reload           # reload unit files after changes

# Boot targets
systemctl get-default             # current default target
systemctl set-default multi-user.target   # text mode default
systemctl set-default graphical.target    # GUI default
systemctl isolate rescue.target   # switch to rescue mode

# journalctl
journalctl -u service             # logs for specific service
journalctl -f                     # follow log (like tail -f)
journalctl --since "1 hour ago"   # time-based filter
journalctl -p err                 # priority filter (err, warning, etc.)
journalctl -b                     # current boot logs
journalctl -b -1                  # previous boot logs

# Process management
ps aux                            # all processes
ps -ef                            # all processes (System V style)
top / htop                        # interactive process monitor
kill PID                          # send SIGTERM
kill -9 PID                       # send SIGKILL (force)
killall processname               # kill by name
pkill -u username                 # kill all user processes
nice -n 10 command                # start with priority
renice -n 5 -p PID               # change priority
nohup command &                   # run immune to hangup
bg / fg / jobs                    # job control

# Scheduling
crontab -e                        # edit user crontab
crontab -l                        # list user crontab
# Format: min hour dom month dow command
# */5 * * * * /path/script.sh     # every 5 minutes
# 0 2 * * 0 /path/backup.sh      # Sunday 2 AM
at now + 5 minutes                # one-time scheduled task
```

**Documentation:**
- **[📖 systemd Documentation](https://www.freedesktop.org/software/systemd/man/)** - Complete systemd reference
- **[📖 Crontab Guru](https://crontab.guru/)** - Cron expression helper

## Networking

```bash
# IP configuration
ip addr show                      # show IP addresses
ip link show                      # show interfaces
ip route show                     # show routing table
ip addr add 192.168.1.10/24 dev eth0  # add IP
ip link set eth0 up/down          # enable/disable interface
nmcli con show                    # NetworkManager connections
nmcli con mod "conn" ipv4.addresses 192.168.1.10/24
nmcli con mod "conn" ipv4.method manual
nmcli con up "conn"               # apply changes

# DNS
/etc/hosts                        # local hostname resolution
/etc/resolv.conf                  # DNS server configuration
systemd-resolve --status          # DNS status
resolvectl status                 # modern DNS status

# Firewall (firewalld)
firewall-cmd --state              # check if running
firewall-cmd --get-zones          # list zones
firewall-cmd --get-default-zone   # current default zone
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-service=http --permanent
firewall-cmd --reload             # apply changes
firewall-cmd --list-all           # show all rules

# SSH
ssh user@host                     # connect
ssh-keygen -t ed25519             # generate key pair
ssh-copy-id user@host             # copy public key
/etc/ssh/sshd_config              # server configuration
  PermitRootLogin no
  PasswordAuthentication no
  Port 22

# Troubleshooting
ss -tunlp                         # show listening ports
ping host                         # test connectivity
traceroute host                   # trace route
dig domain                        # DNS query
nslookup domain                   # DNS lookup
curl -v url                       # HTTP request
wget url                          # download file
tcpdump -i eth0 -n port 80       # packet capture
netstat -tunlp                    # listening ports (legacy)
```

**Documentation:**
- **[📖 Ubuntu Networking](https://ubuntu.com/server/docs/network-configuration)** - Network configuration guide
- **[📖 firewalld Documentation](https://firewalld.org/documentation/)** - Firewall configuration

## Storage Management

```bash
# Disk partitioning
lsblk                             # list block devices
fdisk -l                          # list partitions
fdisk /dev/sdb                    # partition MBR disk
gdisk /dev/sdb                    # partition GPT disk
parted /dev/sdb                   # advanced partitioning

# Filesystems
mkfs.ext4 /dev/sdb1               # create ext4 filesystem
mkfs.xfs /dev/sdb1                # create XFS filesystem
mount /dev/sdb1 /mnt              # mount filesystem
umount /mnt                       # unmount
blkid                             # show UUID and type
# /etc/fstab entry:
# UUID=xxx /mount ext4 defaults 0 2
mount -a                          # mount all in fstab

# LVM (Logical Volume Management)
pvcreate /dev/sdb1                # create physical volume
pvdisplay                         # show PVs
vgcreate myvg /dev/sdb1          # create volume group
vgdisplay                         # show VGs
vgextend myvg /dev/sdc1          # add PV to VG
lvcreate -L 10G -n mylv myvg     # create logical volume
lvcreate -l 100%FREE -n mylv myvg  # use all free space
lvextend -L +5G /dev/myvg/mylv   # extend LV by 5G
resize2fs /dev/myvg/mylv         # resize ext4 filesystem
xfs_growfs /mountpoint            # resize XFS (mounted)
lvdisplay                         # show LVs

# RAID
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
mdadm --detail /dev/md0           # show RAID details
cat /proc/mdstat                  # RAID status

# Swap
mkswap /dev/sdb2                  # create swap
swapon /dev/sdb2                  # enable swap
swapoff /dev/sdb2                 # disable swap
free -h                           # show memory and swap
# /etc/fstab: UUID=xxx swap swap defaults 0 0
```

**Documentation:**
- **[📖 Ubuntu Storage Guide](https://ubuntu.com/server/docs/device-mapper-multipath-introduction)** - Storage administration
- **[📖 LVM Documentation](https://sourceware.org/lvm2/)** - Logical Volume Manager reference

## Service Configuration

### Apache / Nginx
```bash
# Apache
apt install apache2
systemctl enable --now apache2
/etc/apache2/apache2.conf         # main config
/etc/apache2/sites-available/     # virtual host configs
a2ensite site.conf                # enable site
a2dissite site.conf               # disable site
a2enmod ssl                       # enable module
apache2ctl configtest             # test configuration

# Nginx
apt install nginx
systemctl enable --now nginx
/etc/nginx/nginx.conf             # main config
/etc/nginx/sites-available/       # server block configs
ln -s /etc/nginx/sites-available/site /etc/nginx/sites-enabled/
nginx -t                          # test configuration
```

### NFS and Samba
```bash
# NFS Server
apt install nfs-kernel-server
/etc/exports                      # NFS share definitions
# /share 192.168.1.0/24(rw,sync,no_subtree_check)
exportfs -a                       # apply exports
exportfs -v                       # show current exports

# NFS Client
apt install nfs-common
mount server:/share /mnt
# /etc/fstab: server:/share /mnt nfs defaults 0 0

# Samba
apt install samba
/etc/samba/smb.conf               # Samba configuration
smbpasswd -a username             # add Samba user
testparm                          # test configuration
systemctl restart smbd
```

## Common Exam Scenarios

1. **"Create user with specific properties"** - useradd with -m, -s, -G flags
2. **"Set up LVM"** - pvcreate -> vgcreate -> lvcreate -> mkfs -> mount
3. **"Configure firewall"** - firewall-cmd with --add-port or --add-service --permanent
4. **"Set up cron job"** - crontab -e with correct time fields
5. **"Mount persistent filesystem"** - mkfs, create mount point, add to /etc/fstab
6. **"Find files matching criteria"** - find with -name, -type, -size, -mtime
7. **"Configure NFS share"** - Edit /etc/exports, exportfs -a, mount on client
8. **"Troubleshoot service"** - systemctl status, journalctl -u, check config files
9. **"Extend LVM volume"** - lvextend + resize2fs/xfs_growfs
10. **"Configure SSH key auth"** - ssh-keygen, ssh-copy-id, sshd_config

---

**Remember:** You can use `man command` during the exam. Knowing where to find information is just as important as memorizing commands.
