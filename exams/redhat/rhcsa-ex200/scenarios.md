# RHCSA - 15 Hands-On Scenarios

These 15 scenarios mirror the format of the real exam. Each is a task to perform on a live RHEL 9 VM. Time yourself - aim to complete each in 8-15 minutes.

After each scenario, **reboot** to verify your changes survive.

---

## Scenario 1 - Reset the root password

Boot into a RHEL 9 VM. You don't know the root password. Reset it without losing SELinux enforcement.

<details>
<summary>Solution</summary>

1. Reboot. At GRUB menu, press `e`.
2. On the `linux` line, append `rd.break enforcing=0`.
3. `Ctrl-X` to boot.
4. `mount -o remount,rw /sysroot`
5. `chroot /sysroot`
6. `passwd root` - set new password
7. `touch /.autorelabel`
8. `exit; exit` to reboot.
9. Wait through SELinux relabel on first boot.
10. Verify: log in as root with new password; `getenforce` returns `Enforcing`.

**Trap:** without `enforcing=0`, the `passwd` command fails silently and you'll think you reset successfully but be locked out.
</details>

---

## Scenario 2 - Configure static networking

Configure your VM with IP `192.168.50.10/24`, gateway `192.168.50.1`, DNS `8.8.8.8`. Hostname is `server1.example.com`. Add `192.168.50.20` as `db1.example.com` to /etc/hosts.

<details>
<summary>Solution</summary>

```bash
nmcli connection modify "System eth0" \
    ipv4.method manual \
    ipv4.addresses 192.168.50.10/24 \
    ipv4.gateway 192.168.50.1 \
    ipv4.dns 8.8.8.8

nmcli connection up "System eth0"

hostnamectl set-hostname server1.example.com

echo '192.168.50.20  db1.example.com  db1' >> /etc/hosts
```

**Verify:** `ip a` shows correct IP. `hostnamectl` shows correct hostname. `getent hosts db1.example.com` resolves.
</details>

---

## Scenario 3 - Add and configure a swap file

Create a 1 GB swap file at `/swapfile1` and make it survive reboot.

<details>
<summary>Solution</summary>

```bash
dd if=/dev/zero of=/swapfile1 bs=1M count=1024
chmod 600 /swapfile1
mkswap /swapfile1
swapon /swapfile1

echo '/swapfile1  none  swap  defaults  0  0' >> /etc/fstab
swapon --show
```

**Verify:** `swapon --show` lists `/swapfile1`. After reboot, `swapon --show` still lists it.
</details>

---

## Scenario 4 - Build an LVM stack

Add a new 5 GB disk to your VM (`/dev/sdb`). Create a partition, then build an LVM stack: PV → VG (`vg_data`) → LV (`lv_data`, 3 GB) → XFS filesystem → mount at `/mnt/data` persistently.

<details>
<summary>Solution</summary>

```bash
# Create partition (type 8e Linux LVM)
fdisk /dev/sdb       # n, default size, t, 8e, w
partprobe

pvcreate /dev/sdb1
vgcreate vg_data /dev/sdb1
lvcreate -L 3G -n lv_data vg_data
mkfs.xfs /dev/vg_data/lv_data

mkdir -p /mnt/data
echo '/dev/vg_data/lv_data  /mnt/data  xfs  defaults  0  2' >> /etc/fstab
mount -a
df -h | grep lv_data
```

**Verify:** `lsblk`, `df -h`, reboot, then re-verify.
</details>

---

## Scenario 5 - Extend a logical volume

Extend `vg_data/lv_data` by 1 GB and grow the XFS filesystem online.

<details>
<summary>Solution</summary>

```bash
lvextend -L +1G /dev/vg_data/lv_data
xfs_growfs /mnt/data
df -h | grep lv_data
```

**Verify:** `df -h` shows the new size.
</details>

---

## Scenario 6 - Create user with specific UID, password aging

Create user `alice` with UID 1500, home dir `/home/alice`, bash shell, password expiring every 60 days, password must change on first login.

<details>
<summary>Solution</summary>

```bash
useradd -u 1500 -m -s /bin/bash alice
passwd alice                       # set initial password
chage -M 60 -d 0 alice             # 60 days max, force change at next login
chage -l alice                     # verify
```

**Verify:** `id alice` shows uid=1500. `chage -l alice` shows max=60 and password change required.
</details>

---

## Scenario 7 - Sudo for a group

Create group `ops`. Add user `alice` to `ops`. Configure `ops` for passwordless sudo, restricted to `systemctl restart httpd`.

<details>
<summary>Solution</summary>

```bash
groupadd ops
usermod -aG ops alice

cat > /etc/sudoers.d/ops <<'EOF'
%ops  ALL=(ALL)  NOPASSWD: /usr/bin/systemctl restart httpd
EOF
chmod 0440 /etc/sudoers.d/ops
visudo -cf /etc/sudoers.d/ops
```

**Verify:** as alice, `sudo systemctl restart httpd` succeeds without password. `sudo systemctl restart sshd` is denied.
</details>

---

## Scenario 8 - Group-collaborative directory

Create directory `/srv/shared/team` owned by group `team`, where files created inside are automatically owned by group `team`, and other users can't see anything.

<details>
<summary>Solution</summary>

```bash
groupadd team
mkdir -p /srv/shared/team
chgrp team /srv/shared/team
chmod 2770 /srv/shared/team             # SGID + group rwx, no other
```

`2` is SGID. Test: as a user in `team`, `touch /srv/shared/team/x`, then `ls -l` shows the file's group is `team`.
</details>

---

## Scenario 9 - Configure SSH key-only authentication

Generate an SSH key pair on a client, copy the public key to the server's `alice` account, then disable password auth for SSH.

<details>
<summary>Solution</summary>

On client:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ''
ssh-copy-id -i ~/.ssh/id_ed25519.pub alice@server
```

On server, edit `/etc/ssh/sshd_config`:

```
PasswordAuthentication no
PubkeyAuthentication yes
PermitRootLogin no
```

```bash
systemctl restart sshd
```

**Verify:** `ssh alice@server` works without password. `ssh root@server` is denied.
</details>

---

## Scenario 10 - Configure firewalld

Allow HTTP, HTTPS. Allow SSH only from `10.0.0.0/8`. Block all other SSH.

<details>
<summary>Solution</summary>

```bash
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https

firewall-cmd --permanent --remove-service=ssh

firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="10.0.0.0/8" service name="ssh" accept'

firewall-cmd --reload
firewall-cmd --list-all
```

**Verify:** `firewall-cmd --list-all` shows http, https, the rich rule, and no plain ssh service.
</details>

---

## Scenario 11 - Schedule a daily script with systemd timer

Run `/usr/local/bin/backup.sh` every day at 2:30 AM.

<details>
<summary>Solution</summary>

```bash
cat > /usr/local/bin/backup.sh <<'EOF'
#!/bin/bash
echo "$(date) backup ran" >> /var/log/backup.log
EOF
chmod +x /usr/local/bin/backup.sh

cat > /etc/systemd/system/backup.service <<'EOF'
[Unit]
Description=Daily backup

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
EOF

cat > /etc/systemd/system/backup.timer <<'EOF'
[Unit]
Description=Run backup daily at 2:30

[Timer]
OnCalendar=*-*-* 02:30:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable --now backup.timer
systemctl list-timers backup
```

**Verify:** `systemctl list-timers` shows the next 02:30 run. Trigger it manually with `systemctl start backup.service` to confirm the script runs.
</details>

---

## Scenario 12 - SELinux file context for non-default web root

Make Apache (`httpd`) serve content from `/srv/myweb` (not the default `/var/www/html`).

<details>
<summary>Solution</summary>

```bash
dnf install -y httpd
mkdir -p /srv/myweb
echo '<h1>hello</h1>' > /srv/myweb/index.html

# Apache config
cat > /etc/httpd/conf.d/myweb.conf <<'EOF'
<Directory "/srv/myweb">
    Require all granted
</Directory>
DocumentRoot "/srv/myweb"
EOF

# SELinux context (the critical step)
semanage fcontext -a -t httpd_sys_content_t '/srv/myweb(/.*)?'
restorecon -Rv /srv/myweb

# Firewall
firewall-cmd --permanent --add-service=http
firewall-cmd --reload

systemctl enable --now httpd

curl http://localhost/
```

**Verify:** `curl localhost` returns the page. `ls -lZ /srv/myweb` shows `httpd_sys_content_t`.
</details>

---

## Scenario 13 - Configure NFS client mount

Mount `server2:/srv/share` at `/mnt/nfsshare` persistently.

<details>
<summary>Solution</summary>

```bash
dnf install -y nfs-utils

mkdir -p /mnt/nfsshare
echo 'server2:/srv/share  /mnt/nfsshare  nfs  defaults,_netdev  0  0' >> /etc/fstab

mount -a
df -h | grep nfsshare
```

`_netdev` is critical - it tells systemd to wait for the network before mounting at boot.

**Verify:** mount works. After reboot, mount still works.
</details>

---

## Scenario 14 - Configure tuned for high throughput

Set the `tuned` performance profile to `throughput-performance`.

<details>
<summary>Solution</summary>

```bash
systemctl enable --now tuned
tuned-adm profile throughput-performance
tuned-adm active
```

**Verify:** `tuned-adm active` shows `Current active profile: throughput-performance`. After reboot, still set.
</details>

---

## Scenario 15 - Run a container as a service

Run an `nginx` container persistently on port 8080, surviving reboot, with content from `/srv/web`.

<details>
<summary>Solution</summary>

```bash
mkdir -p /srv/web
echo '<h1>persistent container</h1>' > /srv/web/index.html

# SELinux for bind-mount
semanage fcontext -a -t container_file_t '/srv/web(/.*)?'
restorecon -Rv /srv/web

# Run the container manually first to verify
podman run -d --name web \
    -p 8080:80 \
    -v /srv/web:/usr/share/nginx/html:Z \
    docker.io/nginx

curl http://localhost:8080
podman stop web
podman rm web

# Generate systemd unit
podman create --name web -p 8080:80 -v /srv/web:/usr/share/nginx/html:Z docker.io/nginx
podman generate systemd --new --name web --files
mv container-web.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable --now container-web.service
systemctl status container-web.service

# Test
curl http://localhost:8080

# Firewall
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --reload
```

**Verify:** `curl http://localhost:8080` returns the page. After reboot, the container still runs.
</details>

---

## Scoring guide

- **All 15 in <2 hours, reboot-tested, no notes:** ready to schedule the exam.
- **12-14 in 2-3 hours:** one more week of practice on weak areas, then schedule.
- **<12, or you needed notes:** keep practicing. The exam is performance-based - reading isn't enough.

The real exam is roughly 20 tasks in 3 hours. If you can do these 15 in 2 hours, the exam pace is comfortable.
