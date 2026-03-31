# Domain 4: Networking (15%)

## Overview
This domain covers IP configuration, DNS resolution, firewall management, SSH configuration, and network troubleshooting. You must be able to configure networking from the command line and diagnose connectivity issues.

## IP Configuration

**[📖 Ubuntu Networking Guide](https://ubuntu.com/server/docs/network-configuration)** - Official network configuration guide

### Viewing Network Configuration

```bash
ip addr show                       # all interfaces and IPs
ip addr show eth0                  # specific interface
ip link show                       # interface status (up/down)
ip route show                      # routing table
ip route get 8.8.8.8              # show route to destination
```

### Temporary Configuration (ip command)

```bash
ip addr add 192.168.1.100/24 dev eth0
ip addr del 192.168.1.100/24 dev eth0
ip link set eth0 up
ip link set eth0 down
ip route add default via 192.168.1.1
ip route add 10.0.0.0/8 via 192.168.1.254
```

### Persistent Configuration with Netplan (Ubuntu 22.04)

```yaml
# /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: false
      addresses:
        - 192.168.1.100/24
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
        search:
          - example.com
```

```bash
sudo netplan apply                 # apply changes
sudo netplan try                   # apply with auto-revert (120s)
```

### NetworkManager (nmcli)

```bash
nmcli con show                     # list connections
nmcli dev status                   # device status

# Create static connection
nmcli con add type ethernet \
  con-name "static-eth0" ifname eth0 \
  ipv4.addresses 192.168.1.100/24 \
  ipv4.gateway 192.168.1.1 \
  ipv4.dns "8.8.8.8,8.8.4.4" \
  ipv4.method manual

# Modify existing
nmcli con mod "conn" ipv4.addresses 192.168.1.100/24
nmcli con mod "conn" ipv4.method manual
nmcli con up "conn"

# Hostname
hostnamectl set-hostname myserver
```

## DNS Resolution

```bash
# Configuration files
/etc/hosts                        # local resolution (checked first)
/etc/resolv.conf                  # DNS server configuration
/etc/nsswitch.conf                # resolution order (hosts: files dns)

# systemd-resolved
resolvectl status                  # DNS status

# DNS queries
dig example.com                    # detailed query
dig @8.8.8.8 example.com         # query specific server
dig +short example.com            # brief output
nslookup example.com              # simple lookup
host example.com                   # simple lookup
```

## Firewall Configuration

**[📖 firewalld Documentation](https://firewalld.org/documentation/)** - Firewall reference

### firewalld

```bash
systemctl enable --now firewalld
firewall-cmd --state

# Zones
firewall-cmd --get-zones
firewall-cmd --get-default-zone
firewall-cmd --get-active-zones
firewall-cmd --set-default-zone=public
firewall-cmd --zone=public --list-all

# Services
firewall-cmd --zone=public --add-service=http --permanent
firewall-cmd --zone=public --add-service=https --permanent
firewall-cmd --zone=public --remove-service=http --permanent

# Ports
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --zone=public --add-port=3000-3100/tcp --permanent

# Rich rules
firewall-cmd --zone=public \
  --add-rich-rule='rule family="ipv4" source address="10.0.0.0/8" port port="3306" protocol="tcp" accept' \
  --permanent

# CRITICAL: Reload after permanent changes
firewall-cmd --reload
```

**Zones:**
| Zone | Default Behavior |
|------|-----------------|
| drop | Drop all incoming |
| block | Reject all incoming |
| public | Default, reject except selected |
| trusted | Accept all traffic |

### iptables (Reference)

```bash
iptables -L -n -v                  # list rules
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -j DROP
iptables-save > /etc/iptables.rules
```

## SSH Configuration

**[📖 OpenSSH Documentation](https://www.openssh.com/manual.html)** - SSH reference

### SSH Client

```bash
ssh user@hostname
ssh -p 2222 user@hostname
ssh-keygen -t ed25519              # generate key pair
ssh-copy-id user@hostname          # copy public key

# SSH config (~/.ssh/config)
Host webserver
    HostName 192.168.1.10
    User admin
    Port 2222
    IdentityFile ~/.ssh/webserver_key

# Port forwarding
ssh -L 8080:localhost:80 user@server    # local forward
ssh -R 8080:localhost:80 user@server    # remote forward
```

### SSH Server (/etc/ssh/sshd_config)

```bash
Port 22
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
MaxAuthTries 3
AllowUsers user1 user2

# After changes
sshd -t                            # test config
systemctl restart sshd
```

### SSH Key Permissions

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519       # private key
chmod 644 ~/.ssh/id_ed25519.pub   # public key
chmod 600 ~/.ssh/authorized_keys
```

## Network Troubleshooting

### Connectivity Testing

```bash
ping -c 5 hostname                 # ICMP test
traceroute hostname                # trace route
mtr hostname                       # combined ping + traceroute
curl -v http://hostname            # HTTP test
wget http://hostname/file          # download
```

### Port and Connection Analysis

```bash
ss -tunlp                          # listening ports with process
ss -t                              # TCP connections
ss state established               # established connections
netstat -tunlp                     # legacy alternative
lsof -i :80                        # processes on port 80
```

### Packet Capture

```bash
tcpdump -i eth0 -n                 # capture on interface
tcpdump -i eth0 port 80            # filter by port
tcpdump -i eth0 host 192.168.1.10 # filter by host
tcpdump -w capture.pcap            # save to file
```

### Troubleshooting Workflow

1. **Check interface**: `ip addr show` - Is interface up with IP?
2. **Check gateway**: `ip route show` - Is there a default route?
3. **Ping gateway**: `ping gateway-ip` - Can we reach gateway?
4. **Ping external**: `ping 8.8.8.8` - Can we reach internet?
5. **Check DNS**: `dig example.com` - Is DNS resolving?
6. **Check firewall**: `firewall-cmd --list-all` - Are ports open?
7. **Check service**: `ss -tunlp | grep port` - Is service listening?
8. **Check logs**: `journalctl -u service` - Any errors?

---

## Key Takeaways for the Exam

1. Know both netplan and nmcli for network configuration
2. Always use `firewall-cmd --permanent` AND `--reload` for persistent rules
3. SSH key permissions must be correct: 700 for .ssh, 600 for private key
4. `ss -tunlp` is the go-to for checking listening ports
5. Troubleshoot systematically: interface -> gateway -> DNS -> service -> firewall
6. Know /etc/hosts, /etc/resolv.conf, and their purposes
7. sshd_config: PermitRootLogin no, PasswordAuthentication no for hardening
8. `ip addr` and `ip route` replace deprecated ifconfig and route
