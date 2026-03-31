# Domain 2: User and Group Management (15%)

## Overview
This domain covers creating and managing local user accounts and groups, configuring sudo access, managing environment profiles, and understanding PAM (Pluggable Authentication Modules). These are fundamental sysadmin tasks that you must be able to perform quickly and correctly.

## User Management

**[📖 Ubuntu User Management](https://ubuntu.com/server/docs/security-users)** - Official Ubuntu user administration guide

### Important User Files

#### /etc/passwd
```
username:x:UID:GID:comment:home_directory:shell
```
- **username** - Login name (up to 32 characters)
- **x** - Password placeholder (actual password in /etc/shadow)
- **UID** - User ID (0=root, 1-999=system, 1000+=regular users)
- **GID** - Primary group ID
- **comment** - GECOS field (full name, room, phone)
- **home_directory** - User's home directory path
- **shell** - Login shell (/bin/bash, /bin/sh, /usr/sbin/nologin)

```bash
# View user information
cat /etc/passwd
getent passwd username     # query user info
id username                # show UID, GID, groups
whoami                     # current user
who                        # logged-in users
w                          # logged-in users with activity
```

#### /etc/shadow
```
username:$6$salt$hash:last_change:min:max:warn:inactive:expire:reserved
```
- **$6$** - SHA-512 hashing algorithm
- **$5$** - SHA-256
- **$y$** - yescrypt (newer Ubuntu default)
- **last_change** - Days since Jan 1, 1970 when password was last changed
- **min** - Minimum days between password changes
- **max** - Maximum days password is valid
- **warn** - Days before expiry to warn user
- **inactive** - Days after expiry before account is disabled
- **expire** - Date account expires (days since epoch)

```bash
# Only readable by root
sudo cat /etc/shadow
```

#### /etc/group
```
groupname:x:GID:member1,member2
```
- **groupname** - Group name
- **x** - Group password placeholder
- **GID** - Group ID
- **members** - Comma-separated list of supplementary group members

### Creating Users

```bash
# Basic user creation
useradd username                    # create user (minimal)
useradd -m username                 # create with home directory
useradd -m -s /bin/bash username   # with home and bash shell

# Full user creation
useradd -m \
  -s /bin/bash \                   # login shell
  -c "Full Name" \                 # comment/GECOS
  -d /home/username \              # home directory path
  -g primary_group \               # primary group
  -G sudo,docker \                 # supplementary groups
  -e 2026-12-31 \                  # account expiration date
  -u 1500 \                        # specific UID
  username

# Set password after creation
passwd username                     # interactive password set
echo "username:password" | chpasswd # non-interactive (scripting)
```

### Default User Settings

```bash
# View defaults
useradd -D                          # show useradd defaults

# Configuration files for defaults
/etc/default/useradd               # useradd default values
/etc/login.defs                    # login defaults (UID/GID ranges, password aging)
/etc/skel/                         # skeleton directory (copied to new home dirs)
```

**/etc/login.defs important settings:**
```
PASS_MAX_DAYS   99999    # max password age
PASS_MIN_DAYS   0        # min days between changes
PASS_WARN_AGE   7        # warning days before expiry
UID_MIN         1000     # minimum UID for regular users
UID_MAX         60000    # maximum UID for regular users
CREATE_HOME     yes      # create home directory by default
```

### Modifying Users

```bash
# Change user properties
usermod -s /bin/zsh username       # change shell
usermod -d /new/home username      # change home directory
usermod -d /new/home -m username   # change home and move contents
usermod -c "New Name" username     # change comment/GECOS
usermod -l newname oldname         # rename user
usermod -u 2000 username           # change UID
usermod -e 2026-12-31 username     # set account expiration

# CRITICAL: Group management
usermod -aG groupname username     # ADD to supplementary group (append!)
usermod -G group1,group2 username  # REPLACE all supplementary groups (DANGEROUS!)
# Always use -aG to add, never -G alone (it removes other groups)

# Lock/unlock accounts
usermod -L username                # lock account (adds ! to password hash)
usermod -U username                # unlock account
passwd -l username                 # lock (alternative method)
passwd -u username                 # unlock (alternative method)
```

### Deleting Users

```bash
userdel username                   # delete user (keep home directory)
userdel -r username                # delete user AND home directory
userdel -f username                # force delete (even if logged in)
```

### Password Management

```bash
# Set/change password
passwd                             # change own password
passwd username                    # change another user's password (root)

# Password aging with chage
chage -l username                  # list password aging info
chage -M 90 username               # max password age: 90 days
chage -m 7 username                # min days between changes: 7
chage -W 14 username               # warning: 14 days before expiry
chage -I 30 username               # inactive: 30 days after expiry
chage -E 2026-12-31 username       # account expiration date
chage -d 0 username                # force password change on next login

# View password status
passwd -S username                 # password status
```

## Group Management

### Creating and Managing Groups

```bash
# Create group
groupadd groupname                 # create group
groupadd -g 2000 groupname        # create with specific GID

# Modify group
groupmod -n newname oldname        # rename group
groupmod -g 2500 groupname        # change GID

# Delete group
groupdel groupname                 # delete group (must have no primary members)

# View group information
groups username                    # show user's groups
id username                        # show UID, GID, all groups
getent group groupname            # query group info
cat /etc/group                     # all groups
```

### Managing Group Membership

```bash
# Add user to group
usermod -aG groupname username     # preferred method (append)
gpasswd -a username groupname      # alternative method

# Remove user from group
gpasswd -d username groupname      # remove from group

# Set group administrators
gpasswd -A username groupname      # make user group admin

# Temporary group change
newgrp groupname                   # switch primary group for session
```

### Shared Group Directories

A common exam task - create a shared directory for a group:

```bash
# Create group and directory
groupadd project
mkdir /opt/project

# Set ownership and SGID
chown :project /opt/project
chmod 2770 /opt/project

# SGID ensures new files inherit the "project" group
# 2770 = rwxrws--- (owner and group full access, SGID set)

# Add users to the group
usermod -aG project user1
usermod -aG project user2
```

## Sudo Configuration

**[📖 Sudo Manual](https://www.sudo.ws/docs/man/)** - Complete sudo documentation

### /etc/sudoers File

```bash
# Always edit with visudo (validates syntax)
visudo                             # edit /etc/sudoers safely

# File format
# user    host=(runas_user:runas_group)    commands
root      ALL=(ALL:ALL)                     ALL
%sudo     ALL=(ALL:ALL)                     ALL

# Examples
john      ALL=(ALL:ALL) ALL                              # full sudo access
%admins   ALL=(ALL:ALL) ALL                              # group sudo access
sarah     ALL=(ALL) NOPASSWD: ALL                        # no password required
mike      ALL=(ALL) /usr/bin/systemctl restart *         # specific commands
deploy    ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart httpd, /usr/bin/systemctl status httpd
```

### Sudoers Drop-in Files

```bash
# Create drop-in file (preferred over editing /etc/sudoers directly)
visudo -f /etc/sudoers.d/deployers

# Example content:
# %deployers ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart *, /usr/bin/systemctl status *

# File permissions must be correct
chmod 440 /etc/sudoers.d/deployers
```

### Sudo Usage

```bash
sudo command                       # run as root
sudo -u username command           # run as specific user
sudo -i                            # root interactive shell
sudo -s                            # root shell (keep environment)
sudo -l                            # list allowed commands
sudo -l -U username                # list another user's sudo rights
sudo su -                          # switch to root (requires sudo access)
```

### Sudo Lecture and Logging
```bash
# In /etc/sudoers:
Defaults    lecture=always          # always show sudo warning
Defaults    logfile=/var/log/sudo  # log sudo commands
Defaults    timestamp_timeout=15   # sudo timeout in minutes
Defaults    passwd_tries=3         # password attempts before lockout
```

## PAM (Pluggable Authentication Modules)

**[📖 Linux PAM Documentation](http://www.linux-pam.org/Linux-PAM-html/)** - PAM configuration guide

### PAM Overview
- Modular authentication framework
- Separates authentication logic from applications
- Configuration files in /etc/pam.d/
- Each service has its own PAM configuration file

### PAM Configuration File Format

```
type    control    module    [options]
```

**Types:**
- **auth** - Authentication (verify identity)
- **account** - Account validation (expiration, access restrictions)
- **password** - Password management (change password)
- **session** - Session management (setup/teardown)

**Control flags:**
- **required** - Must succeed, but continue checking other modules
- **requisite** - Must succeed, fail immediately if not
- **sufficient** - If succeeds, no more modules checked (unless required fails)
- **optional** - Only matters if it is the only module for this type
- **include** - Include rules from another PAM file

### Common PAM Modules

| Module | Purpose |
|--------|---------|
| pam_unix.so | Standard Unix authentication |
| pam_env.so | Set/unset environment variables |
| pam_limits.so | Set resource limits |
| pam_nologin.so | Prevent non-root login (/etc/nologin) |
| pam_deny.so | Always deny access |
| pam_permit.so | Always permit access |
| pam_pwquality.so | Password quality checking |
| pam_faillock.so | Lock account after failed attempts |
| pam_motd.so | Display message of the day |

### Example: /etc/pam.d/common-auth
```
auth    [success=1 default=ignore]    pam_unix.so nullok
auth    requisite                      pam_deny.so
auth    required                       pam_permit.so
```

## Resource Limits

### /etc/security/limits.conf

```bash
# Format: domain  type  item  value
# domain: username, @groupname, or * (all users)
# type: hard (maximum), soft (default), - (both)

*         soft    nproc     4096      # default max processes
*         hard    nproc     8192      # absolute max processes
@devs     hard    maxlogins 3         # max concurrent logins for devs
john      soft    nofile    1024      # default open files for john
john      hard    nofile    65536     # max open files for john
```

**Common limit items:**
| Item | Description |
|------|-------------|
| nproc | Maximum number of processes |
| nofile | Maximum number of open files |
| maxlogins | Maximum number of logins |
| cpu | CPU time limit (minutes) |
| fsize | Maximum file size |
| memlock | Maximum locked memory |

```bash
# View current limits
ulimit -a                          # show all soft limits
ulimit -aH                        # show all hard limits
ulimit -n                          # show open file limit
ulimit -u                          # show process limit

# Set limits for current session
ulimit -n 4096                     # set open file limit
```

## Environment Profiles

### Profile Loading Order

**Login shell (interactive login):**
1. /etc/profile
2. /etc/profile.d/*.sh
3. ~/.bash_profile (or ~/.bash_login or ~/.profile)
4. ~/.bashrc (typically sourced by .bash_profile)

**Non-login shell (interactive non-login):**
1. ~/.bashrc
2. /etc/bash.bashrc

### Configuration Files

```bash
# System-wide
/etc/profile               # system-wide login profile
/etc/profile.d/            # drop-in scripts (executed by /etc/profile)
/etc/bash.bashrc           # system-wide bashrc
/etc/environment           # system-wide environment variables

# User-specific
~/.bash_profile            # user login profile
~/.bashrc                  # user interactive shell config
~/.bash_logout             # executed on logout
```

### Setting Environment Variables

```bash
# Temporary (current session)
export VAR_NAME="value"

# Persistent for user (add to ~/.bashrc or ~/.bash_profile)
echo 'export VAR_NAME="value"' >> ~/.bashrc

# Persistent system-wide
echo 'VAR_NAME="value"' >> /etc/environment
# or create a script in /etc/profile.d/
echo 'export VAR_NAME="value"' > /etc/profile.d/custom.sh
```

### Skeleton Directory

```bash
/etc/skel/                 # template for new user home directories
# Contents are copied to new user's home when created with useradd -m
# Common files: .bashrc, .profile, .bash_logout
```

---

## Key Takeaways for the Exam

1. Always use `useradd -m` to create home directory
2. Always use `usermod -aG` (with -a) to add to groups - never -G alone
3. Use `visudo` to edit sudoers - never edit directly
4. Sudoers drop-in files go in /etc/sudoers.d/
5. Know /etc/passwd format: username:x:UID:GID:comment:home:shell
6. SGID on directories makes new files inherit the directory's group
7. `chage -d 0 username` forces password change on next login
8. Know the difference between hard and soft resource limits
