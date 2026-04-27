# 01 - System Configuration, Boot, and Targets

## Boot process (RHEL 9)

1. **UEFI / BIOS firmware** loads the bootloader.
2. **GRUB2** presents the boot menu and loads the kernel and initramfs.
3. **Kernel** initializes hardware, mounts initramfs, then pivots to the real root filesystem.
4. **systemd** (PID 1) takes over and brings up the system to its **default target**.

The default target on a server is usually `multi-user.target` (no GUI) or `graphical.target` (with GUI).

### Important boot files

| File | Purpose |
|---|---|
| `/boot/grub2/grub.cfg` | Generated GRUB config; do not edit directly |
| `/etc/default/grub` | Persistent GRUB defaults |
| `/etc/grub.d/` | GRUB scriptlets |
| `/boot/loader/entries/*.conf` | BLS (boot loader spec) entries |
| `/etc/dracut.conf.d/` | initramfs config |

After editing `/etc/default/grub`, regenerate config:

```bash
grub2-mkconfig -o /boot/grub2/grub.cfg                       # BIOS
grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg              # UEFI
```

---

## systemd targets

Targets replace older System V "runlevels."

| Target | What it does | Equivalent runlevel |
|---|---|---|
| `poweroff.target` | Shutdown | 0 |
| `rescue.target` | Single-user, root shell | 1 |
| `multi-user.target` | Full multi-user, no GUI | 3 |
| `graphical.target` | Multi-user with GUI | 5 |
| `reboot.target` | Reboot | 6 |
| `emergency.target` | Minimal recovery (root fs RO) | n/a |

### Manage targets

```bash
systemctl get-default                 # show current default
systemctl set-default multi-user.target
systemctl isolate rescue.target       # switch now to rescue
```

### Boot to a different target (one-time)

At the GRUB menu, press `e`, find the `linux` line, append `systemd.unit=rescue.target`, then `Ctrl-X` to boot.

---

## Recovery patterns

### Boot to emergency mode (root filesystem read-only)

Use when even rescue mode fails. Append `emergency` (or `systemd.unit=emergency.target`) to the kernel line at GRUB.

You'll need to remount root read-write:

```bash
mount -o remount,rw /
```

### Reset root password

The canonical RHEL 9 procedure is in [fact-sheet.md](../fact-sheet.md#reset-root-password-rhel-9). Key steps:

1. At GRUB, append `rd.break enforcing=0` to the kernel line.
2. `Ctrl-X` to boot.
3. `mount -o remount,rw /sysroot`
4. `chroot /sysroot`
5. `passwd root`
6. `touch /.autorelabel` (forces SELinux relabel)
7. Exit twice and reboot.

`enforcing=0` is critical - without it, SELinux blocks `passwd` and you'll think you succeeded but reboot fails to log in.

---

## Default targets and graphical vs server

```bash
# Production server, no GUI
systemctl set-default multi-user.target

# Workstation
systemctl set-default graphical.target
```

If `graphical.target` is set but no GUI packages installed, the system stops at the multi-user level - this is fine.

---

## Kernel command-line parameters

View current:

```bash
cat /proc/cmdline
```

Common parameters you might see or use:

- `quiet` - hide most boot output
- `rhgb` - graphical boot
- `selinux=0` - disable SELinux at boot (don't, except for diagnosis)
- `enforcing=0` - boot in permissive SELinux
- `single` or `1` - single-user mode (older syntax; use `systemd.unit=rescue.target`)

To make a parameter persistent, edit `GRUB_CMDLINE_LINUX` in `/etc/default/grub` and regenerate config.

---

## Tuned (performance profiles)

`tuned` is a daemon that applies kernel and system tuning profiles.

```bash
systemctl enable --now tuned
tuned-adm list                        # list profiles
tuned-adm active                      # current profile
tuned-adm profile throughput-performance
tuned-adm recommend                   # suggest profile based on workload
```

Profiles to know:

- `balanced` - default, general-purpose
- `throughput-performance` - high throughput servers
- `latency-performance` - low-latency apps
- `virtual-guest` - VMs
- `virtual-host` - hypervisor hosts

---

## Time and date

```bash
timedatectl                              # current state
timedatectl set-timezone America/New_York
timedatectl set-time '2026-04-26 10:30:00'    # only if NTP off
timedatectl set-ntp true                 # enable NTP sync via chronyd
```

### chronyd configuration

Edit `/etc/chrony.conf`:

```
pool 2.rhel.pool.ntp.org iburst
server time.example.com iburst
```

Then:

```bash
systemctl enable --now chronyd
chronyc sources -v          # verify peering
chronyc tracking            # show offset and drift
```

---

## Common exam patterns

### "Configure this server to boot into multi-user mode by default"

```bash
systemctl set-default multi-user.target
```

### "Configure NTP using internal time server"

Edit `/etc/chrony.conf`, comment out `pool` lines, add `server time.example.com iburst`. Then:

```bash
systemctl restart chronyd
chronyc sources
```

### "Reset root password and keep SELinux enforcing"

Follow the recovery procedure above. The `touch /.autorelabel` step is non-negotiable.

### "Set timezone to UTC and enable NTP"

```bash
timedatectl set-timezone UTC
timedatectl set-ntp true
```

---

## Verification checklist

After making boot or system config changes, **always verify with a reboot**:

1. `reboot`
2. After boot: `systemctl get-default` shows your target
3. `timedatectl` shows correct time
4. `tuned-adm active` shows active profile (if changed)
5. `getenforce` shows correct SELinux mode
