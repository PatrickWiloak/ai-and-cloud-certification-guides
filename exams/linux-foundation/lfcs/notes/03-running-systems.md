# Domain 3: Operation of Running Systems (15%)

## Overview
This domain covers systemd service management, process management, boot process, kernel modules, and task scheduling. Understanding how to manage running Linux systems is essential for the hands-on exam tasks.

## Systemd

**[📖 systemd Documentation](https://www.freedesktop.org/software/systemd/man/)** - Complete systemd reference

### Core Concepts
- **systemd** - Init system and service manager (PID 1)
- **Unit** - Basic object managed by systemd
- **Service** - A process or group of processes
- **Target** - Group of units (similar to runlevels)
- **Timer** - Schedule-based activation
- **Socket** - IPC/network socket-based activation

### Unit File Locations
| Location | Priority | Purpose |
|----------|----------|---------|
| /etc/systemd/system/ | Highest | Admin-created and overrides |
| /run/systemd/system/ | Medium | Runtime-generated units |
| /usr/lib/systemd/system/ | Lowest | Package-installed units |

### systemctl - Service Management

```bash
# Basic service control
systemctl start service.service      # start service
systemctl stop service.service       # stop service
systemctl restart service.service    # stop then start
systemctl reload service.service     # reload config (no restart)
systemctl reload-or-restart service  # reload if supported, else restart

# Boot behavior
systemctl enable service.service     # start at boot
systemctl disable service.service    # don't start at boot
systemctl enable --now service       # enable AND start immediately
systemctl disable --now service      # disable AND stop immediately

# Status and information
systemctl status service.service     # show status (active, logs)
systemctl is-active service          # check if running
systemctl is-enabled service         # check if enabled at boot
systemctl is-failed service          # check if failed
systemctl show service               # show all properties

# Listing units
systemctl list-units                 # all active units
systemctl list-units --type=service  # all active services
systemctl list-units --failed        # failed units
systemctl list-unit-files            # all installed unit files

# Masking (prevent starting entirely)
systemctl mask service               # prevent starting
systemctl unmask service             # allow starting again

# Reload unit files after changes
systemctl daemon-reload              # reload all unit file changes
```

### Creating Custom Service Units

```ini
# /etc/systemd/system/myapp.service
[Unit]
Description=My Custom Application
After=network.target
Wants=network-online.target

[Service]
Type=simple
User=appuser
Group=appgroup
WorkingDirectory=/opt/myapp
ExecStart=/opt/myapp/start.sh
ExecStop=/opt/myapp/stop.sh
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

**Service Types:**
| Type | Description |
|------|-------------|
| simple | Default. Process started is the main process |
| forking | Process forks, parent exits. Use PIDFile= |
| oneshot | Process runs and exits. Used with RemainAfterExit=yes |
| notify | Process sends notification when ready |
| idle | Delayed until all active jobs finish |

**After creating or modifying a unit file:**
```bash
systemctl daemon-reload              # reload unit files
systemctl enable --now myapp.service # enable and start
systemctl status myapp.service       # verify
```

### Boot Targets

| Target | Description | Old Runlevel |
|--------|-------------|-------------|
| poweroff.target | System shutdown | 0 |
| rescue.target | Single user mode, basic system | 1 |
| multi-user.target | Multi-user, no GUI, full network | 3 |
| graphical.target | Multi-user with GUI | 5 |
| reboot.target | System reboot | 6 |
| emergency.target | Emergency shell, minimal | - |

```bash
# Default target
systemctl get-default              # show current default
systemctl set-default multi-user.target  # set text-mode default
systemctl set-default graphical.target   # set GUI default

# Switch target at runtime
systemctl isolate multi-user.target     # switch to text mode
systemctl isolate rescue.target         # switch to rescue mode

# Boot operations
systemctl reboot                   # reboot system
systemctl poweroff                 # power off
shutdown -h now                    # power off immediately
shutdown -r +5 "Rebooting in 5 min"  # reboot in 5 minutes
shutdown -c                        # cancel scheduled shutdown
```

### journalctl - System Logging

```bash
# View logs
journalctl                         # all logs (oldest first)
journalctl -e                      # jump to end of logs
journalctl -f                      # follow (like tail -f)
journalctl -n 50                   # last 50 entries

# Filter by service
journalctl -u sshd.service        # logs for SSH
journalctl -u nginx.service -f    # follow nginx logs

# Filter by time
journalctl --since "2024-01-01"
journalctl --since "1 hour ago"
journalctl --since today

# Filter by priority
journalctl -p err                  # errors and above
journalctl -p warning              # warnings and above
# Priorities: emerg, alert, crit, err, warning, notice, info, debug

# Filter by boot
journalctl -b                      # current boot
journalctl -b -1                   # previous boot
journalctl --list-boots            # list all boots

# Disk usage
journalctl --disk-usage            # show log size
journalctl --vacuum-size=100M      # limit to 100MB
```

## Process Management

### Viewing Processes

```bash
# ps - process snapshot
ps aux                             # all processes (BSD format)
ps -ef                             # all processes (System V format)
ps aux --sort=-%cpu                # sort by CPU usage
ps aux --sort=-%mem                # sort by memory usage
ps -eo pid,user,cmd               # custom output format
pgrep -la processname             # find process by name

# top/htop - interactive monitor
top                                # interactive (P=CPU, M=memory, k=kill, q=quit)
htop                               # enhanced interactive monitor

# Process tree
pstree                             # tree view of processes
pstree -p                          # show PIDs
```

### Signals

```bash
kill PID                           # send SIGTERM (15) - graceful
kill -9 PID                        # send SIGKILL (9) - force kill
kill -HUP PID                      # send SIGHUP (1) - reload config
kill -STOP PID                     # pause process
kill -CONT PID                     # resume process
killall processname                # kill all with name
pkill processname                  # kill by pattern
pkill -u username                  # kill all user processes

# List signals
kill -l                            # list all signals
```

| Signal | Number | Description |
|--------|--------|-------------|
| SIGHUP | 1 | Hangup - often reload configuration |
| SIGINT | 2 | Interrupt (Ctrl+C) |
| SIGKILL | 9 | Force kill (cannot be caught) |
| SIGTERM | 15 | Graceful termination (default) |
| SIGSTOP | 19 | Pause process (cannot be caught) |
| SIGCONT | 18 | Continue paused process |

### Process Priority

```bash
# Nice values: -20 (highest priority) to 19 (lowest priority)
nice -n 10 command                 # start with nice value 10
nice -n -5 command                 # start with nice value -5 (root only)
renice -n 5 -p PID                # change running process priority
renice -n -10 -p PID              # higher priority (root only)
```

### Job Control

```bash
command &                          # run in background
Ctrl+Z                             # suspend foreground process
bg                                 # resume suspended in background
fg                                 # bring to foreground
fg %1                              # bring job 1 to foreground
jobs                               # list background jobs
nohup command &                    # run immune to hangup
```

## Boot Process

### Linux Boot Sequence
1. **BIOS/UEFI** - Hardware initialization, POST
2. **Boot loader (GRUB2)** - Load kernel and initramfs
3. **Kernel** - Hardware detection, driver loading
4. **initramfs** - Initial RAM filesystem, load essential drivers
5. **systemd (PID 1)** - Initialize system, start services
6. **Default target** - multi-user.target or graphical.target

### GRUB2 Configuration

```bash
/etc/default/grub                  # GRUB defaults
/boot/grub/grub.cfg               # generated config (do not edit directly)

# Regenerate GRUB config after changes
update-grub                        # Ubuntu

# Common settings in /etc/default/grub
GRUB_TIMEOUT=5
GRUB_DEFAULT=0
GRUB_CMDLINE_LINUX=""
```

## Kernel Module Management

```bash
lsmod                              # list loaded modules
modinfo module_name                # module information
modprobe module_name               # load module (with dependencies)
modprobe -r module_name           # unload module
insmod /path/to/module.ko         # load (no dependency resolution)
rmmod module_name                  # unload (no dependency resolution)

# Persistent module loading
echo "module_name" >> /etc/modules-load.d/custom.conf

# Blacklist a module
echo "blacklist module_name" >> /etc/modprobe.d/blacklist-custom.conf
```

## Task Scheduling

### cron - Recurring Tasks

```bash
crontab -e                         # edit user crontab
crontab -l                         # list crontab
crontab -r                         # remove crontab

# Format: MIN HOUR DOM MONTH DOW command
# 0-59  0-23 1-31  1-12  0-7

# Examples
0 2 * * *     /path/backup.sh        # daily at 2:00 AM
*/5 * * * *   /path/check.sh         # every 5 minutes
0 0 * * 0     /path/weekly.sh        # Sunday midnight
30 6 1 * *    /path/monthly.sh       # 1st of month 6:30 AM
0 9-17 * * 1-5 /path/hourly.sh      # hourly 9-5 weekdays

# Special strings
@reboot       /path/startup.sh       # run at boot
@daily        /path/daily.sh         # once per day
@weekly       /path/weekly.sh        # once per week
```

### at - One-Time Tasks

```bash
at now + 5 minutes                 # schedule (type commands, Ctrl+D)
at 14:30 tomorrow
atq                                # list pending jobs
atrm job_number                   # remove job
```

### systemd Timers

```ini
# /etc/systemd/system/backup.timer
[Unit]
Description=Daily backup timer

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

```bash
systemctl enable --now backup.timer
systemctl list-timers
```

---

## Key Takeaways for the Exam

1. `systemctl enable --now` is the fastest way to enable and start a service
2. `systemctl daemon-reload` is required after creating/modifying unit files
3. `journalctl -u service -f` is essential for troubleshooting
4. Know boot targets and how to switch between them
5. Cron fields: MIN HOUR DOM MONTH DOW
6. `kill -9` is SIGKILL (force), default `kill` is SIGTERM (graceful)
7. Nice values: -20 (highest priority) to 19 (lowest priority)
8. Use `update-grub` after changing GRUB configuration
