# Domain 1: Linux Fundamentals (20%)

## Overview
This domain covers the Linux command line, filesystem hierarchy, text editors, package management, and shell scripting basics. As one of the three highest-weighted domains, focus on understanding core concepts and common commands.

## Linux Basics

**[📖 Introduction to Linux (LFS101)](https://training.linuxfoundation.org/training/introduction-to-linux/)** - Free Linux Foundation course

### What is Linux?
- Open-source operating system kernel created by Linus Torvalds in 1991
- Built on the GNU project tools (Richard Stallman, 1983)
- Officially called GNU/Linux - kernel + GNU utilities
- Used in servers, cloud, mobile (Android), IoT, supercomputers
- Over 90% of cloud infrastructure runs Linux

### Linux Distributions
| Distribution | Family | Package Manager | Best For |
|-------------|--------|-----------------|----------|
| **Ubuntu** | Debian | apt/dpkg | Beginners, servers, cloud |
| **Debian** | Debian | apt/dpkg | Stability, servers |
| **RHEL** | Red Hat | dnf/rpm | Enterprise production |
| **CentOS/Rocky/Alma** | Red Hat | dnf/rpm | Free RHEL alternative |
| **Fedora** | Red Hat | dnf/rpm | Latest features, development |
| **SUSE** | SUSE | zypper/rpm | Enterprise (Europe) |
| **Arch** | Arch | pacman | Advanced users, customization |

### Open Source Licensing
| License | Type | Key Feature |
|---------|------|-------------|
| **GPL v2/v3** | Copyleft | Derivatives must use same license |
| **MIT** | Permissive | Minimal restrictions, commercial use OK |
| **Apache 2.0** | Permissive | Commercial use OK, patent protection |
| **BSD** | Permissive | Very few restrictions |
| **LGPL** | Weak copyleft | Library linking allowed without GPL |

**Key concept:** Copyleft (GPL) requires derivative works to also be open source. Permissive (MIT, Apache) allows proprietary use.

## Command Line Basics

### Navigation and File Operations

```bash
# Navigation
pwd                    # print working directory
ls                     # list directory contents
ls -la                 # detailed list including hidden files
cd /path               # change directory
cd ~                   # go to home directory
cd ..                  # go up one level
cd -                   # go to previous directory

# File operations
cp source dest         # copy file
cp -r src/ dest/       # copy directory recursively
mv source dest         # move or rename
rm file                # remove file
rm -r directory/       # remove directory recursively
mkdir directory        # create directory
mkdir -p path/to/dir   # create nested directories
touch file             # create empty file or update timestamp

# Viewing files
cat file               # display entire file
less file              # page through file (q to quit)
head -n 10 file        # first 10 lines
tail -n 10 file        # last 10 lines
tail -f file           # follow file in real-time (logs)
```

### Text Searching and Processing

```bash
# grep - search for patterns
grep "pattern" file            # search in file
grep -i "pattern" file         # case-insensitive
grep -r "pattern" /path        # recursive search
grep -v "pattern" file         # exclude matching lines
grep -c "pattern" file         # count matches

# Other text tools
wc -l file                     # count lines
sort file                      # sort lines
uniq file                      # remove duplicates (sorted input)
cut -d: -f1 /etc/passwd        # extract field 1 with : delimiter

# I/O redirection
command > file                  # output to file (overwrite)
command >> file                 # output to file (append)
command 2> file                 # error output to file
command1 | command2             # pipe output to next command

# Examples
cat /etc/passwd | grep "bash"   # find bash users
ls -l | wc -l                   # count files
```

### File Information

```bash
file filename          # determine file type
stat filename          # detailed file information
du -sh /path           # directory disk usage
df -h                  # filesystem disk space
which command          # find command location
man command            # manual page for command
command --help         # quick help text
```

## Filesystem Hierarchy

**[📖 Filesystem Hierarchy Standard](https://refspecs.linuxfoundation.org/fhs.shtml)** - Official FHS specification

| Directory | Purpose | Examples |
|-----------|---------|---------|
| `/` | Root of entire filesystem | - |
| `/bin` | Essential user commands | ls, cp, mv, cat |
| `/sbin` | System admin commands | fdisk, iptables |
| `/etc` | Configuration files | /etc/hosts, /etc/ssh/ |
| `/home` | User home directories | /home/alice |
| `/root` | Root user's home | - |
| `/var` | Variable data | Logs, mail, databases |
| `/var/log` | System log files | syslog, auth.log |
| `/tmp` | Temporary files | Cleared on reboot |
| `/usr` | User programs/libraries | /usr/bin, /usr/lib |
| `/opt` | Optional software | Third-party applications |
| `/dev` | Device files | /dev/sda, /dev/null |
| `/proc` | Process information | /proc/cpuinfo, /proc/meminfo |
| `/sys` | Kernel/hardware info | Hardware parameters |
| `/boot` | Boot loader and kernel | vmlinuz, initramfs |
| `/media` | Removable media | USB drives, CDs |
| `/mnt` | Temporary mount points | Manual mounts |

## Text Editors

### nano (Beginner-Friendly)
```bash
nano filename          # open file
# Ctrl+O  - Save (Write Out)
# Ctrl+X  - Exit
# Ctrl+K  - Cut line
# Ctrl+U  - Paste (Uncut)
# Ctrl+W  - Search
# Ctrl+G  - Help
```

### vi/vim (Essential to Know)
```bash
vim filename           # open file

# Modes:
# Normal mode (default) - navigation and commands
# Insert mode (i) - editing text
# Command mode (:) - file operations

# Key commands:
# i         - enter insert mode
# Esc       - return to normal mode
# :w        - save
# :q        - quit
# :wq       - save and quit
# :q!       - quit without saving
# dd        - delete line
# yy        - copy (yank) line
# p         - paste
# /pattern  - search forward
# u         - undo
```

## Package Management

### Debian/Ubuntu (apt)
```bash
apt update                     # update package lists
apt upgrade                    # upgrade installed packages
apt install package            # install package
apt remove package             # remove package
apt search keyword             # search for packages
apt list --installed           # list installed packages
dpkg -l                        # list installed (lower-level)
dpkg -i package.deb            # install local .deb file
```

### Red Hat/CentOS/Fedora (dnf/yum)
```bash
dnf update                     # update all packages
dnf install package            # install package
dnf remove package             # remove package
dnf search keyword             # search for packages
dnf list installed             # list installed packages
rpm -qa                        # list installed (lower-level)
rpm -ivh package.rpm           # install local .rpm file
```

### Key Concepts
- **Repository** - Server hosting packages (configured in /etc/apt/sources.list or /etc/yum.repos.d/)
- **Dependencies** - Required packages installed automatically
- **apt/dnf** - High-level tools that handle dependencies
- **dpkg/rpm** - Low-level tools for individual packages

## Shell Scripting Basics

### Script Structure
```bash
#!/bin/bash
# This is a comment

# Variables
NAME="World"
echo "Hello, $NAME"

# Command substitution
TODAY=$(date +%Y-%m-%d)
echo "Today is $TODAY"

# Conditionals
if [ -f /etc/hosts ]; then
    echo "File exists"
else
    echo "File not found"
fi

# Loops
for i in 1 2 3 4 5; do
    echo "Number: $i"
done

# While loop
COUNT=0
while [ $COUNT -lt 5 ]; do
    echo "Count: $COUNT"
    COUNT=$((COUNT + 1))
done
```

### Making Scripts Executable
```bash
chmod +x script.sh             # make executable
./script.sh                    # run script
bash script.sh                 # run with bash (no execute needed)
```

### Common Script Elements
- **Shebang (#!/bin/bash)** - Specifies the interpreter
- **Variables** - No spaces around = sign
- **Exit codes** - 0 = success, non-zero = failure
- **$?** - Exit code of last command
- **$1, $2, ...** - Command-line arguments

---

## Key Takeaways for the Exam

1. Know the major distribution families: Debian (apt), Red Hat (dnf), SUSE (zypper)
2. GPL is copyleft (derivatives must be open source), MIT/Apache are permissive
3. Know the filesystem hierarchy - especially /etc, /var/log, /home, /tmp
4. Know basic commands: ls, cd, cp, mv, rm, mkdir, grep, cat, chmod
5. Understand I/O redirection: >, >>, |, 2>
6. Know basic vi/vim modes: Normal, Insert (i), Command (:wq, :q!)
7. apt is for Debian/Ubuntu, dnf is for RHEL/Fedora
8. Scripts start with #!/bin/bash and need execute permission
