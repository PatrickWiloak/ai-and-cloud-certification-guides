# Domain 1: Essential Commands (20%)

## Overview
This domain covers core Linux command-line skills including file operations, text processing, permissions, links, archiving, and file finding. These are foundational skills tested on the exam and used in every other domain. Master these commands through daily practice.

## File Operations

**[📖 GNU Coreutils Manual](https://www.gnu.org/software/coreutils/manual/)** - Complete reference for core utilities

### Filesystem Hierarchy

| Directory | Purpose |
|-----------|---------|
| `/` | Root filesystem |
| `/bin` | Essential user commands (symlink to /usr/bin on Ubuntu) |
| `/sbin` | System administration commands |
| `/etc` | System configuration files |
| `/home` | User home directories |
| `/root` | Root user's home directory |
| `/var` | Variable data (logs, mail, spool) |
| `/var/log` | System and application logs |
| `/tmp` | Temporary files (cleared on reboot) |
| `/usr` | User programs and libraries |
| `/opt` | Optional/third-party software |
| `/dev` | Device files |
| `/proc` | Virtual filesystem for process information |
| `/sys` | Virtual filesystem for kernel/hardware information |
| `/mnt` | Temporary mount points |
| `/media` | Removable media mount points |
| `/boot` | Boot loader files and kernel |

### Basic File Commands

```bash
# Navigation
pwd                      # print working directory
cd /path                 # change directory
cd ~                     # go to home directory
cd -                     # go to previous directory
cd ..                    # go up one level

# Listing
ls                       # list files
ls -l                    # long format (permissions, owner, size, date)
ls -la                   # include hidden files
ls -lh                   # human-readable file sizes
ls -ltr                  # sort by time, reversed (newest last)
ls -R                    # recursive listing

# File operations
cp source dest           # copy file
cp -r source/ dest/      # copy directory recursively
cp -a source/ dest/      # copy preserving all attributes
mv source dest           # move or rename
rm file                  # remove file
rm -r directory/         # remove directory recursively
rm -rf directory/        # force remove (be careful!)
mkdir directory          # create directory
mkdir -p path/to/dir     # create parent directories as needed
rmdir directory          # remove empty directory
touch file               # create empty file or update timestamp

# File information
file filename            # determine file type
stat filename            # detailed file information
du -sh /path             # disk usage of directory
df -h                    # disk space of filesystems
```

### Viewing File Contents

```bash
cat file                 # display entire file
less file                # page through file (/ to search, q to quit)
more file                # page through file (older, less features)
head -n 20 file          # first 20 lines
tail -n 20 file          # last 20 lines
tail -f file             # follow file updates in real-time
```

## Text Processing

**[📖 GNU Grep Manual](https://www.gnu.org/software/grep/manual/)** - Complete grep reference

### grep - Pattern Searching

```bash
# Basic grep
grep "pattern" file              # search for pattern
grep -i "pattern" file           # case-insensitive
grep -v "pattern" file           # invert match (exclude)
grep -r "pattern" /path          # recursive search
grep -n "pattern" file           # show line numbers
grep -c "pattern" file           # count matches
grep -l "pattern" /path/*.log    # show only filenames with matches
grep -w "word" file              # match whole word only
grep -A 3 "pattern" file         # show 3 lines after match
grep -B 3 "pattern" file         # show 3 lines before match
grep -C 3 "pattern" file         # show 3 lines around match

# Extended regex (egrep)
grep -E "pattern1|pattern2" file # match either pattern
grep -E "^start" file           # lines starting with "start"
grep -E "end$" file             # lines ending with "end"
grep -E "[0-9]{3}" file         # three consecutive digits
grep -E "^$" file               # empty lines

# Common patterns
grep "^root" /etc/passwd         # lines starting with root
grep "bash$" /etc/passwd         # lines ending with bash
grep -v "^#" config.conf         # exclude comments
grep -v "^$" file                # exclude empty lines
```

### sed - Stream Editor

**[📖 GNU Sed Manual](https://www.gnu.org/software/sed/manual/)** - Complete sed reference

```bash
# Substitution
sed 's/old/new/' file            # replace first occurrence per line
sed 's/old/new/g' file           # replace all occurrences
sed 's/old/new/gi' file          # replace all, case-insensitive
sed -i 's/old/new/g' file        # in-place edit (modifies file)
sed -i.bak 's/old/new/g' file   # in-place with backup

# Line operations
sed -n '5p' file                 # print only line 5
sed -n '5,10p' file              # print lines 5-10
sed '5d' file                    # delete line 5
sed '/pattern/d' file            # delete lines matching pattern
sed '3i\inserted text' file      # insert text before line 3
sed '3a\appended text' file      # append text after line 3

# Multiple operations
sed -e 's/old1/new1/g' -e 's/old2/new2/g' file
sed '/pattern/s/old/new/g' file  # substitute only on matching lines

# Common tasks
sed 's/^/  /' file               # indent all lines (add 2 spaces)
sed 's/[[:space:]]*$//' file     # remove trailing whitespace
sed '/^$/d' file                 # remove empty lines
```

### awk - Pattern Processing

**[📖 GNU Awk Manual](https://www.gnu.org/software/gawk/manual/)** - Complete awk reference

```bash
# Field extraction (default delimiter: whitespace)
awk '{print $1}' file            # print first field
awk '{print $1, $3}' file       # print first and third fields
awk '{print $NF}' file          # print last field
awk '{print NR, $0}' file       # print line number and entire line

# Custom delimiter
awk -F: '{print $1}' /etc/passwd       # colon-delimited
awk -F, '{print $2}' data.csv         # comma-delimited

# Conditionals
awk '$3 > 1000' /etc/passwd            # UID > 1000 (field 3)
awk -F: '$3 >= 1000 {print $1}' /etc/passwd  # users with UID >= 1000
awk 'NR >= 5 && NR <= 10' file         # lines 5 through 10
awk '/pattern/ {print $0}' file        # lines matching pattern

# Calculations
awk '{sum += $1} END {print sum}' file           # sum of first column
awk '{sum += $1; count++} END {print sum/count}' file  # average
awk 'BEGIN {count=0} /pattern/ {count++} END {print count}' file

# Formatting
awk -F: '{printf "%-20s %s\n", $1, $6}' /etc/passwd  # formatted output
```

### Other Text Tools

```bash
# cut - extract fields
cut -d: -f1 /etc/passwd          # first field, colon-delimited
cut -d: -f1,6 /etc/passwd        # fields 1 and 6
cut -c1-10 file                  # first 10 characters per line

# sort
sort file                         # alphabetical sort
sort -n file                      # numeric sort
sort -r file                      # reverse sort
sort -k2 file                    # sort by second column
sort -t: -k3 -n /etc/passwd     # sort by UID numerically
sort -u file                      # sort and remove duplicates

# uniq (requires sorted input)
sort file | uniq                  # remove adjacent duplicates
sort file | uniq -c               # count occurrences
sort file | uniq -d               # show only duplicates

# wc - word count
wc file                           # lines, words, characters
wc -l file                       # count lines only
wc -w file                       # count words only
wc -c file                       # count bytes

# tr - translate characters
tr 'a-z' 'A-Z' < file           # uppercase
tr -d '\r' < file                # remove carriage returns
tr -s ' '                        # squeeze repeated spaces

# paste and join
paste file1 file2                # merge files side by side
paste -d, file1 file2           # merge with comma delimiter

# diff
diff file1 file2                 # compare files
diff -u file1 file2              # unified format (like git diff)
```

## I/O Redirection and Pipes

```bash
# Standard streams
# 0 = stdin (input)
# 1 = stdout (output)
# 2 = stderr (error)

# Output redirection
command > file           # stdout to file (overwrite)
command >> file          # stdout to file (append)
command 2> file          # stderr to file
command 2>> file         # stderr to file (append)
command &> file          # both stdout and stderr to file
command > file 2>&1      # both stdout and stderr to file (POSIX)
command > /dev/null 2>&1 # discard all output

# Input redirection
command < file           # stdin from file
command << EOF           # here document
line1
line2
EOF

# Pipes
command1 | command2      # stdout of cmd1 to stdin of cmd2
command1 | command2 | command3  # chain multiple commands

# tee - write to file AND stdout
command | tee file       # output to screen and file
command | tee -a file    # append to file
command | tee file1 file2  # write to multiple files

# xargs - build commands from stdin
find . -name "*.log" | xargs rm        # delete found files
find . -name "*.txt" | xargs grep "pattern"  # search in found files
echo "file1 file2" | xargs -n 1 rm    # one argument per command
```

## File Permissions

### Understanding Permission Notation

```
-rwxr-xr-x  1  user  group  4096  Mar 15 10:00  filename
│├──┤├──┤├──┤
│ │   │   │
│ │   │   └── Others permissions (r-x = 5)
│ │   └────── Group permissions (r-x = 5)
│ └────────── Owner permissions (rwx = 7)
└──────────── File type (- = file, d = directory, l = link)
```

### Numeric (Octal) Permissions
| Value | Permission |
|-------|-----------|
| 0 | No permission (---) |
| 1 | Execute (--x) |
| 2 | Write (-w-) |
| 3 | Write + Execute (-wx) |
| 4 | Read (r--) |
| 5 | Read + Execute (r-x) |
| 6 | Read + Write (rw-) |
| 7 | Read + Write + Execute (rwx) |

### chmod - Change Permissions

```bash
# Numeric mode
chmod 755 file           # rwxr-xr-x
chmod 644 file           # rw-r--r--
chmod 700 file           # rwx------
chmod 600 file           # rw-------
chmod -R 755 /path       # recursive

# Symbolic mode
chmod u+x file           # add execute for user (owner)
chmod g-w file           # remove write for group
chmod o=r file           # set others to read only
chmod a+r file           # add read for all
chmod u+x,g+r file      # multiple changes
```

### Special Permissions

```bash
# SUID (Set User ID) - 4xxx
chmod u+s file           # or chmod 4755 file
# When executed, runs as file owner (not executing user)
# Example: /usr/bin/passwd runs as root

# SGID (Set Group ID) - 2xxx
chmod g+s directory      # or chmod 2755 directory
# Files created in directory inherit directory's group
# Useful for shared directories

# Sticky Bit - 1xxx
chmod +t directory       # or chmod 1755 directory
# Only file owner can delete files in directory
# Example: /tmp has sticky bit set

# Identify special permissions in ls output
# SUID: -rwsr-xr-x (s in user execute position)
# SGID: -rwxr-sr-x (s in group execute position)
# Sticky: drwxrwxrwt (t in others execute position)
```

### chown and chgrp

```bash
chown user file          # change owner
chown user:group file    # change owner and group
chown :group file        # change group only
chown -R user:group /path  # recursive
chgrp group file         # change group only
```

### Default Permissions - umask

```bash
umask                    # show current umask
umask 022                # set umask (files: 644, dirs: 755)
umask 077                # restrictive (files: 600, dirs: 700)
# Default file permission = 666 - umask
# Default directory permission = 777 - umask
```

## Hard and Soft Links

### Hard Links
```bash
ln source hardlink       # create hard link
```
- Points to the same inode (same data on disk)
- Cannot cross filesystem boundaries
- Cannot link to directories
- Deleting original does not affect hard link
- Hard link count shown in ls -l (second column)

### Symbolic (Soft) Links
```bash
ln -s source symlink     # create symbolic link
```
- Points to the filename (path reference)
- Can cross filesystem boundaries
- Can link to directories
- Deleting original breaks the symlink (dangling link)
- Shown with -> in ls -l output
- Has its own inode

### Comparing Links
| Feature | Hard Link | Soft Link |
|---------|-----------|-----------|
| Points to | Inode | Filename/path |
| Cross filesystem | No | Yes |
| Link to directory | No | Yes |
| Original deleted | Link still works | Link breaks |
| Inode | Same as original | Different |

## Archiving and Compression

```bash
# tar (tape archive)
tar -cf archive.tar /path          # create tar
tar -czf archive.tar.gz /path     # create + gzip compress
tar -cjf archive.tar.bz2 /path   # create + bzip2 compress
tar -cJf archive.tar.xz /path    # create + xz compress
tar -xf archive.tar               # extract tar
tar -xzf archive.tar.gz           # extract gzipped tar
tar -xzf archive.tar.gz -C /dest  # extract to specific directory
tar -tf archive.tar                # list contents
tar -tzf archive.tar.gz           # list contents of gzipped tar

# tar flags summary
# -c  create archive
# -x  extract archive
# -t  list contents
# -f  specify filename
# -z  gzip compression
# -j  bzip2 compression
# -J  xz compression
# -v  verbose output
# -C  change to directory before extracting

# Standalone compression
gzip file                # compress (removes original, creates file.gz)
gunzip file.gz           # decompress
gzip -k file             # compress and keep original
bzip2 file               # bzip2 compress
bunzip2 file.bz2         # decompress
xz file                  # xz compress
unxz file.xz             # decompress

# zip (cross-platform)
zip archive.zip file1 file2        # create zip
zip -r archive.zip /path           # recursive zip
unzip archive.zip                  # extract
unzip -l archive.zip               # list contents
```

## Finding Files

### find Command

```bash
# By name
find /path -name "*.log"           # exact name (case-sensitive)
find /path -iname "*.LOG"          # case-insensitive
find /path -name "file*"           # wildcard

# By type
find /path -type f                 # regular files
find /path -type d                 # directories
find /path -type l                 # symbolic links

# By size
find /path -size +10M              # larger than 10MB
find /path -size -1k               # smaller than 1KB
find /path -size 100c              # exactly 100 bytes

# By time
find /path -mtime -7               # modified in last 7 days
find /path -mtime +30              # modified more than 30 days ago
find /path -mmin -60               # modified in last 60 minutes
find /path -atime -1               # accessed in last 1 day
find /path -newer reference_file   # newer than reference file

# By ownership
find /path -user username          # owned by user
find /path -group groupname        # owned by group
find /path -nouser                 # no owner (orphaned)

# By permissions
find /path -perm 644               # exact permissions
find /path -perm -644              # at least these permissions
find /path -perm /u+x              # any file with user execute

# Actions
find /path -name "*.tmp" -delete            # delete matching files
find /path -name "*.log" -exec rm {} \;     # execute command for each
find /path -name "*.sh" -exec chmod +x {} \;  # make executable
find /path -name "*.conf" -exec grep "pattern" {} +  # efficient exec

# Combining conditions
find /path -name "*.log" -size +1M          # AND (default)
find /path -name "*.log" -o -name "*.txt"   # OR
find /path ! -name "*.log"                  # NOT
find /path -maxdepth 2 -name "*.conf"       # limit depth
```

### locate Command
```bash
locate filename          # fast file finding (uses database)
sudo updatedb            # update locate database
locate -i filename       # case-insensitive
locate -c filename       # count matches
```

### which, whereis, type
```bash
which command            # find command in PATH
whereis command          # find command, source, man page
type command             # determine command type (builtin, alias, file)
```

---

## Key Takeaways for the Exam

1. Know grep, sed, and awk thoroughly - they appear in many tasks
2. Understand numeric permissions (755, 644) and can convert to/from symbolic
3. Know the difference between hard links and soft links
4. tar flags: -c (create), -x (extract), -z (gzip), -f (file) - in that order
5. find is powerful - know -name, -type, -size, -mtime, -exec, -delete
6. Understand I/O redirection: >, >>, 2>, 2>&1, |, tee
7. Special permissions: SUID (4), SGID (2), sticky (1) and their effects
8. Practice combining commands with pipes for complex text processing
