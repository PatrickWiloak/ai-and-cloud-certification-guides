# Domain 5: Storage Management (15%) and Domain 6: Service Configuration (20%)

## Overview
This combined notes file covers storage management (partitioning, filesystems, LVM, RAID, swap) and service configuration (Apache, Nginx, NFS, Samba, DNS, databases). These two domains together represent 35% of the exam.

## Disk Partitioning

### Viewing Storage Devices

```bash
lsblk                             # list block devices (tree view)
lsblk -f                          # include filesystem info
fdisk -l                          # list all disks and partitions
blkid                             # show UUID and filesystem type
df -h                             # mounted filesystem usage
```

### Partition Tables
- **MBR** - Legacy, max 2TB disk, 4 primary partitions
- **GPT** - Modern, no practical size limit, 128 partitions

### fdisk (MBR) and gdisk (GPT)

```bash
fdisk /dev/sdb                    # MBR partitioning
# p=print, n=new, d=delete, t=type, w=write, q=quit

gdisk /dev/sdb                    # GPT partitioning
# Same interactive commands as fdisk

parted /dev/sdb                   # Both MBR and GPT
parted /dev/sdb mklabel gpt
parted /dev/sdb mkpart primary ext4 0% 50%
```

## Filesystems

### Creating and Managing

```bash
# Create filesystem
mkfs.ext4 /dev/sdb1               # ext4
mkfs.xfs /dev/sdb1                # XFS

# Mount
mount /dev/sdb1 /mnt              # temporary mount
mkdir -p /data                    # create mount point
mount /dev/sdb1 /data

# Persistent mount (/etc/fstab)
# UUID=abc123  /data  ext4  defaults  0  2
blkid /dev/sdb1                   # get UUID
mount -a                          # mount all in fstab (test before reboot!)

# Filesystem operations
umount /mnt                       # unmount
fsck /dev/sdb1                    # check (unmounted only!)
resize2fs /dev/sdb1               # resize ext4
xfs_growfs /mountpoint            # grow XFS (mounted, can only grow)
tune2fs -l /dev/sdb1              # ext4 info
```

### /etc/fstab Format
```
# device         mountpoint  type  options    dump  pass
UUID=abc123      /data       ext4  defaults   0     2
/dev/md0         /mnt/raid   ext4  defaults   0     2
server:/share    /mnt/nfs    nfs   defaults   0     0
/swapfile        swap        swap  defaults   0     0
```

## Logical Volume Management (LVM)

**[📖 LVM Documentation](https://sourceware.org/lvm2/)** - LVM reference

### LVM Architecture
```
Physical Volumes (PV) -> Volume Groups (VG) -> Logical Volumes (LV)
```

### Complete LVM Workflow

```bash
# Step 1: Create Physical Volumes
pvcreate /dev/sdb1
pvcreate /dev/sdc1
pvdisplay                         # view details
pvs                               # brief list

# Step 2: Create Volume Group
vgcreate datavg /dev/sdb1 /dev/sdc1
vgdisplay
vgs

# Step 3: Create Logical Volume
lvcreate -L 10G -n datalv datavg          # fixed size
lvcreate -l 100%FREE -n datalv datavg     # all free space
lvdisplay
lvs

# Step 4: Create filesystem
mkfs.ext4 /dev/datavg/datalv

# Step 5: Mount
mkdir /data
mount /dev/datavg/datalv /data

# Step 6: Persist in fstab
echo "/dev/datavg/datalv /data ext4 defaults 0 2" >> /etc/fstab
```

### Extending LVM

```bash
# Add new PV to VG
pvcreate /dev/sdd1
vgextend datavg /dev/sdd1

# Extend LV
lvextend -L +5G /dev/datavg/datalv          # add 5GB
lvextend -l +100%FREE /dev/datavg/datalv    # use all free space

# Resize filesystem AFTER extending LV
resize2fs /dev/datavg/datalv               # ext4
xfs_growfs /data                           # XFS (specify mount point)

# Combined extend + resize
lvextend -r -L +5G /dev/datavg/datalv      # -r resizes filesystem too
```

### LVM Display Commands
```bash
pvs / pvdisplay                   # physical volumes
vgs / vgdisplay                   # volume groups
lvs / lvdisplay                   # logical volumes
```

## RAID Configuration

### RAID Levels
| Level | Min Disks | Fault Tolerance | Capacity |
|-------|-----------|-----------------|----------|
| RAID 0 | 2 | None (striping) | All disks |
| RAID 1 | 2 | 1 disk (mirroring) | 50% |
| RAID 5 | 3 | 1 disk (parity) | N-1 disks |
| RAID 6 | 4 | 2 disks | N-2 disks |
| RAID 10 | 4 | 1 per mirror | 50% |

### mdadm

```bash
# Create RAID 1
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1

# Create RAID 5
mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1

# Check status
mdadm --detail /dev/md0
cat /proc/mdstat

# Save config
mdadm --detail --scan >> /etc/mdadm/mdadm.conf
update-initramfs -u

# Use RAID device like a regular disk
mkfs.ext4 /dev/md0
mount /dev/md0 /mnt/raid

# Manage
mdadm --add /dev/md0 /dev/sde1           # add spare
mdadm --remove /dev/md0 /dev/sdc1        # remove failed disk
```

## Swap Management

```bash
# Swap partition
mkswap /dev/sdb2
swapon /dev/sdb2

# Swap file
fallocate -l 1G /swapfile         # or: dd if=/dev/zero of=/swapfile bs=1M count=1024
chmod 600 /swapfile               # required!
mkswap /swapfile
swapon /swapfile

# Verify
swapon --show
free -h

# Persistent in fstab
# /swapfile swap swap defaults 0 0
```

---

## Service Configuration

## Apache Web Server

```bash
# Install and start
apt install apache2
systemctl enable --now apache2

# Key locations
/etc/apache2/apache2.conf         # main config
/etc/apache2/sites-available/     # virtual host configs
/etc/apache2/sites-enabled/       # enabled sites (symlinks)
/var/www/html/                     # default document root
```

### Virtual Host

```apache
# /etc/apache2/sites-available/mysite.conf
<VirtualHost *:80>
    ServerName mysite.local
    DocumentRoot /var/www/mysite
    ErrorLog ${APACHE_LOG_DIR}/mysite-error.log
    CustomLog ${APACHE_LOG_DIR}/mysite-access.log combined
    <Directory /var/www/mysite>
        Require all granted
    </Directory>
</VirtualHost>
```

```bash
a2ensite mysite.conf              # enable site
a2dissite 000-default.conf        # disable default
a2enmod ssl                       # enable module
apache2ctl configtest             # test config
systemctl reload apache2          # apply changes
```

### HTTPS with Self-Signed Certificate

```bash
a2enmod ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/mysite.key \
  -out /etc/ssl/certs/mysite.crt
# Create SSL virtual host referencing cert and key
a2ensite mysite-ssl.conf
systemctl reload apache2
```

## Nginx Web Server

```bash
apt install nginx
systemctl enable --now nginx

# Key locations
/etc/nginx/nginx.conf
/etc/nginx/sites-available/
/etc/nginx/sites-enabled/
```

### Server Block

```nginx
# /etc/nginx/sites-available/mysite
server {
    listen 80;
    server_name mysite.local;
    root /var/www/mysite;
    index index.html;
    location / {
        try_files $uri $uri/ =404;
    }
}
```

```bash
ln -s /etc/nginx/sites-available/mysite /etc/nginx/sites-enabled/
nginx -t                          # test config
systemctl reload nginx
```

## NFS (Network File System)

```bash
# Server
apt install nfs-kernel-server

# /etc/exports
/exports/shared    192.168.1.0/24(rw,sync,no_subtree_check)
/exports/readonly  *(ro,sync)

exportfs -a                       # apply exports
exportfs -v                       # show exports
systemctl enable --now nfs-kernel-server

# Client
apt install nfs-common
mount server:/exports/shared /mnt/nfs
showmount -e server               # show available exports

# Persistent in fstab
# server:/exports/shared  /mnt/nfs  nfs  defaults  0  0
```

### NFS Export Options
| Option | Description |
|--------|-------------|
| rw | Read-write access |
| ro | Read-only access |
| sync | Synchronous writes (safer) |
| async | Asynchronous writes (faster) |
| no_subtree_check | Disable subtree checking (recommended) |
| no_root_squash | Allow remote root access |
| root_squash | Map remote root to nobody (default) |

## Samba (Windows File Sharing)

```bash
apt install samba

# /etc/samba/smb.conf
[global]
    workgroup = WORKGROUP
    security = user

[shared]
    path = /srv/samba/shared
    browsable = yes
    writable = yes
    valid users = @smbusers
    create mask = 0660
    directory mask = 0770

# Create Samba user
useradd -m smbuser
smbpasswd -a smbuser

# Test and restart
testparm                          # validate config
systemctl enable --now smbd

# Client access
smbclient //server/shared -U smbuser
```

## DNS Configuration (BIND)

```bash
apt install bind9

# Key files
/etc/bind/named.conf              # main config
/etc/bind/named.conf.local        # local zones
/etc/bind/named.conf.options      # options, forwarders
```

### Basic Caching DNS

```
# /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";
    forwarders {
        8.8.8.8;
        8.8.4.4;
    };
    listen-on { any; };
    allow-query { any; };
};
```

## Database (MariaDB/MySQL)

```bash
apt install mariadb-server
mysql_secure_installation
mysql -u root -p
```

```sql
CREATE DATABASE mydb;
CREATE USER 'myuser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON mydb.* TO 'myuser'@'localhost';
FLUSH PRIVILEGES;
```

---

## Key Takeaways for the Exam

1. LVM workflow: pvcreate -> vgcreate -> lvcreate -> mkfs -> mount -> fstab
2. After lvextend, resize filesystem: resize2fs (ext4) or xfs_growfs (XFS)
3. XFS can only grow, never shrink
4. Always use UUID in /etc/fstab (from blkid)
5. Use `mount -a` to test fstab entries before rebooting
6. Apache: a2ensite/a2dissite, apache2ctl configtest
7. Nginx: symlinks to sites-enabled, `nginx -t`
8. NFS: /etc/exports, exportfs -a
9. RAID: mdadm --create, check with cat /proc/mdstat
10. Swap file: create, chmod 600, mkswap, swapon, fstab
