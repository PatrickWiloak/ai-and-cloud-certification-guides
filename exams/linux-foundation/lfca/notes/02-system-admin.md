# System Administration

**[📖 Ubuntu Server Guide](https://ubuntu.com/server/docs)** - Server administration documentation
**[📖 RHEL System Admin Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9)** - RHEL documentation

## User and Group Management

### User Management Commands

```bash
# Create user
useradd username                    # create user (minimal)
useradd -m -s /bin/bash username    # create with home dir and shell
useradd -m -G sudo,developers user # create with groups

# Modify user
usermod -aG groupname username      # add user to group (-a = append)
usermod -s /bin/zsh username        # change shell
usermod -L username                 # lock account
usermod -U username                 # unlock account

# Delete user
userdel username                    # delete user only
userdel -r username                 # delete user + home directory

# Password
passwd username                     # set/change password
passwd -l username                  # lock password
passwd -u username                  # unlock password

# User information
id username                         # show UID, GID, groups
whoami                              # current username
who                                 # logged-in users
last                                # login history
```

### Group Management

```bash
groupadd groupname                  # create group
groupmod -n newname oldname         # rename group
groupdel groupname                  # delete group
groups username                     # show user's groups
```

### Important User Files

| File | Purpose | Format |
|------|---------|--------|
| `/etc/passwd` | User accounts | username:x:UID:GID:comment:home:shell |
| `/etc/shadow` | Encrypted passwords | username:hash:... |
| `/etc/group` | Group definitions | groupname:x:GID:members |
| `/etc/sudoers` | Sudo configuration | Edit with `visudo` only |

```bash
# /etc/passwd example:
alice:x:1001:1001:Alice Smith:/home/alice:/bin/bash

# Fields: username:password(x=in shadow):UID:GID:comment:home:shell
# UID 0 = root, 1-999 = system, 1000+ = regular users
```

### sudo

```bash
sudo command                        # run as root
sudo -u user command                # run as specific user
sudo -i                             # start root shell
visudo                              # safely edit /etc/sudoers
```

**sudoers entry:**
```
# User privilege specification
alice ALL=(ALL:ALL) ALL             # full sudo access
bob ALL=(ALL) /usr/bin/systemctl    # only systemctl
%admin ALL=(ALL) ALL                # admin group gets full access
```

## File Permissions and Ownership

### Understanding Permissions

```
-rwxr-xr-x  1  alice  staff  4096  Jan 15 10:30  myfile.txt
|type|owner|group|other| links|owner|group|size|  date     | name

Type: - (file), d (directory), l (symlink)
r = read (4)
w = write (2)
x = execute (1)
```

### chmod - Change Permissions

**Numeric (Octal):**
```bash
chmod 755 file     # rwxr-xr-x (owner: rwx, group: r-x, others: r-x)
chmod 644 file     # rw-r--r-- (owner: rw-, group: r--, others: r--)
chmod 600 file     # rw------- (owner: rw-, group: ---, others: ---)
chmod 700 dir      # rwx------ (owner: rwx)
chmod 777 file     # rwxrwxrwx (everyone: rwx) - avoid in production
```

**Common Permission Patterns:**
| Octal | Symbolic | Use Case |
|-------|----------|----------|
| 755 | rwxr-xr-x | Executables, directories |
| 644 | rw-r--r-- | Regular files |
| 600 | rw------- | Private files (SSH keys) |
| 700 | rwx------ | Private directories (.ssh) |
| 664 | rw-rw-r-- | Shared group files |
| 775 | rwxrwxr-x | Shared group directories |

**Symbolic:**
```bash
chmod u+x file     # add execute for owner
chmod g-w file     # remove write for group
chmod o=r file     # set others to read only
chmod a+r file     # add read for all (a = all)
chmod -R 755 dir/  # recursive
```

### chown - Change Ownership

```bash
chown user file              # change owner
chown user:group file        # change owner and group
chown :group file            # change group only
chown -R user:group dir/     # recursive
```

### Special Permissions

| Permission | Octal | Effect on Files | Effect on Directories |
|-----------|-------|-----------------|----------------------|
| SUID | 4000 | Run as file owner | - |
| SGID | 2000 | Run as file group | New files inherit group |
| Sticky | 1000 | - | Only owner can delete files |

```bash
chmod 4755 file    # SUID + rwxr-xr-x
chmod 2775 dir     # SGID + rwxrwxr-x
chmod 1777 /tmp    # Sticky + rwxrwxrwx (like /tmp)
```

## Process Management

### Viewing Processes

```bash
ps aux                      # all processes (BSD format)
ps -ef                      # all processes (System V format)
top                         # interactive process viewer
htop                        # enhanced interactive viewer (if installed)
pgrep processname           # find PID by name
```

**ps aux output columns:**
| Column | Description |
|--------|-------------|
| USER | Process owner |
| PID | Process ID |
| %CPU | CPU usage |
| %MEM | Memory usage |
| STAT | Process state (R=running, S=sleeping, Z=zombie) |
| COMMAND | Command that started the process |

### Managing Processes

```bash
kill PID                    # send SIGTERM (graceful stop)
kill -9 PID                 # send SIGKILL (force stop)
kill -HUP PID               # send SIGHUP (reload config)
killall processname         # kill all processes by name
```

**Key Signals:**
| Signal | Number | Action |
|--------|--------|--------|
| SIGHUP | 1 | Reload configuration |
| SIGINT | 2 | Interrupt (Ctrl+C) |
| SIGKILL | 9 | Force kill (cannot be caught) |
| SIGTERM | 15 | Graceful termination (default) |

### Background and Foreground

```bash
command &                   # run in background
Ctrl+Z                      # suspend foreground process
bg                          # resume in background
fg                          # bring to foreground
jobs                        # list background jobs
```

## Service Management (systemd)

### systemctl Commands

```bash
systemctl start service     # start service
systemctl stop service      # stop service
systemctl restart service   # restart service
systemctl reload service    # reload config (no restart)
systemctl enable service    # start at boot
systemctl disable service   # do not start at boot
systemctl enable --now svc  # enable AND start
systemctl status service    # show status
systemctl is-active service # check if running
systemctl is-enabled svc    # check if enabled at boot
systemctl list-units --type=service  # list services
```

### Targets (Runlevels)

| Target | Description | Old Runlevel |
|--------|-------------|-------------|
| poweroff.target | Shutdown | 0 |
| rescue.target | Single user | 1 |
| multi-user.target | Text mode, network | 3 |
| graphical.target | GUI | 5 |
| reboot.target | Reboot | 6 |

```bash
systemctl get-default               # show boot target
systemctl set-default multi-user.target  # set default
```

## Log Management

### System Logs

```bash
journalctl                  # all system logs
journalctl -u service       # logs for specific service
journalctl -f               # follow (live tail)
journalctl -p err           # errors and above
journalctl --since today    # today's logs
```

**Key Log Files:**
| File | Content |
|------|---------|
| `/var/log/syslog` | General system log (Debian) |
| `/var/log/messages` | General system log (RHEL) |
| `/var/log/auth.log` | Authentication events |
| `/var/log/kern.log` | Kernel messages |
| `/var/log/dmesg` | Boot and hardware messages |

## System Monitoring

```bash
df -h                       # disk space usage
du -sh /path                # directory size
free -h                     # memory usage
uptime                      # system uptime and load
uname -a                    # system information
hostname                    # system hostname
lscpu                       # CPU information
lsblk                       # block devices (disks)
```

## Key Facts for the Exam

1. `useradd -m` creates the home directory, without `-m` it may not
2. `usermod -aG group user` - the `-a` flag is critical (append, not replace)
3. Permission 755 = rwxr-xr-x, 644 = rw-r--r--, 600 = rw-------
4. Root user UID = 0, regular users start at 1000
5. `systemctl enable --now` enables and starts in one command
6. SIGTERM (15) is graceful, SIGKILL (9) is forced
7. `/var/log` contains system logs
8. `visudo` is the safe way to edit sudoers (syntax checking)
