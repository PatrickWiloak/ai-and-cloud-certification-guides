# Security and Networking Fundamentals

**[📖 Linux Security Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/security_hardening)** - Security hardening reference
**[📖 TCP/IP Guide](http://www.tcpipguide.com/)** - Networking reference

## Security Fundamentals

### CIA Triad

| Principle | Description | Example |
|-----------|-------------|---------|
| **Confidentiality** | Data accessible only to authorized users | Encryption, access control |
| **Integrity** | Data is accurate and unmodified | Checksums, digital signatures |
| **Availability** | Systems and data are accessible when needed | Redundancy, backups |

### Authentication vs Authorization

| Concept | Description | Example |
|---------|-------------|---------|
| **Authentication** | Verify identity (who are you?) | Username/password, SSH keys, MFA |
| **Authorization** | Grant access (what can you do?) | File permissions, RBAC, IAM policies |
| **Accounting** | Track actions (what did you do?) | Audit logs, access logs |

### Multi-Factor Authentication (MFA)

| Factor | Type | Example |
|--------|------|---------|
| Something you know | Knowledge | Password, PIN |
| Something you have | Possession | Phone, hardware token |
| Something you are | Biometric | Fingerprint, face scan |

MFA requires two or more different factors (not just two passwords).

## Encryption

### Encryption Types

**Symmetric Encryption:**
- Same key for encryption and decryption
- Fast, suitable for large data
- Challenge: secure key distribution
- Algorithms: AES, DES, 3DES, Blowfish
- Use case: encrypting data at rest, TLS session data

**Asymmetric Encryption (Public Key):**
- Key pair: public key (encrypt) and private key (decrypt)
- Slower than symmetric
- Public key can be shared openly
- Algorithms: RSA, ECC, DSA
- Use case: SSH keys, TLS handshake, digital signatures

**Hashing:**
- One-way function (cannot reverse)
- Fixed-length output regardless of input size
- Used for integrity verification, not encryption
- Algorithms: SHA-256, SHA-512, MD5 (insecure), bcrypt
- Use case: password storage, file integrity, checksums

### TLS/SSL

**[📖 TLS Overview](https://en.wikipedia.org/wiki/Transport_Layer_Security)** - TLS reference

- **TLS (Transport Layer Security)** - Encrypts data in transit
- **SSL (Secure Sockets Layer)** - Deprecated predecessor to TLS
- **HTTPS** = HTTP + TLS (port 443)
- **Certificate** - Proves server identity, issued by Certificate Authority (CA)

**TLS Handshake (simplified):**
1. Client connects and sends supported cipher suites
2. Server responds with certificate and chosen cipher
3. Client verifies certificate with CA
4. Both sides establish symmetric session key
5. Encrypted communication begins

### Certificates

| Component | Description |
|-----------|-------------|
| **Certificate Authority (CA)** | Trusted organization that issues certificates |
| **Public Certificate** | Contains public key, domain, expiration |
| **Private Key** | Kept secret on the server |
| **CSR** | Certificate Signing Request (sent to CA) |
| **Self-Signed** | Not trusted by browsers (testing only) |
| **Let's Encrypt** | Free, automated CA |

## Linux Security

### Firewall Management

**firewalld (modern):**
```bash
systemctl enable --now firewalld
firewall-cmd --state                        # check status

# Allow services
firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=https --permanent
firewall-cmd --add-service=ssh --permanent

# Allow ports
firewall-cmd --add-port=8080/tcp --permanent

# Remove rules
firewall-cmd --remove-service=http --permanent

# Apply changes
firewall-cmd --reload

# List current rules
firewall-cmd --list-all
```

**iptables (legacy):**
```bash
iptables -L                             # list rules
iptables -A INPUT -p tcp --dport 80 -j ACCEPT    # allow HTTP
iptables -A INPUT -p tcp --dport 443 -j ACCEPT   # allow HTTPS
iptables -A INPUT -j DROP                         # drop all other
```

### SSH Security

```bash
# Generate key pair
ssh-keygen -t ed25519                   # modern, recommended
ssh-keygen -t rsa -b 4096              # RSA alternative

# Copy public key to server
ssh-copy-id user@server

# SSH connection
ssh user@server
ssh -p 2222 user@server                 # custom port
```

**SSH Hardening (/etc/ssh/sshd_config):**
```
PermitRootLogin no                      # disable root SSH login
PasswordAuthentication no               # require keys only
PubkeyAuthentication yes                # enable key authentication
MaxAuthTries 3                          # limit login attempts
```

### File Permissions for Security

```bash
chmod 600 ~/.ssh/id_ed25519            # private key - owner only
chmod 644 ~/.ssh/id_ed25519.pub        # public key - readable
chmod 700 ~/.ssh                        # .ssh directory - owner only
chmod 600 ~/.ssh/authorized_keys       # authorized keys - owner only
```

### SELinux and AppArmor

| System | Description | Distribution |
|--------|-------------|-------------|
| **SELinux** | Mandatory Access Control (MAC) | RHEL, CentOS, Fedora |
| **AppArmor** | Path-based access control | Ubuntu, SUSE |

```bash
# SELinux
getenforce                              # check status
setenforce 0                            # set permissive (temporary)
setenforce 1                            # set enforcing

# AppArmor
aa-status                               # check status
```

### Common Security Threats

| Threat | Description | Mitigation |
|--------|-------------|------------|
| **Phishing** | Fake emails/sites to steal credentials | User training, email filtering |
| **Malware** | Malicious software (virus, trojan, ransomware) | Antivirus, patching |
| **DDoS** | Overwhelm service with traffic | Rate limiting, CDN, WAF |
| **SQL Injection** | Inject malicious SQL via input | Input validation, parameterized queries |
| **Man-in-the-Middle** | Intercept communications | TLS/HTTPS, certificate pinning |
| **Brute Force** | Try many passwords | Account lockout, MFA, key auth |
| **Social Engineering** | Manipulate people for access | Security awareness training |

### Security Best Practices

1. **Principle of least privilege** - Grant minimum required access
2. **Defense in depth** - Multiple layers of security
3. **Patch regularly** - Keep systems and software updated
4. **Use MFA** - Multi-factor authentication wherever possible
5. **Encrypt data** - At rest and in transit
6. **Monitor and audit** - Log and review security events
7. **Backup regularly** - Protect against data loss and ransomware

## Networking Fundamentals

### OSI Model

| Layer | Name | Function | Protocols/Devices |
|-------|------|----------|------------------|
| 7 | Application | User interface | HTTP, HTTPS, DNS, SSH, FTP, SMTP |
| 6 | Presentation | Data format, encryption | SSL/TLS, JPEG, ASCII |
| 5 | Session | Session management | RPC, NetBIOS |
| 4 | Transport | End-to-end delivery | TCP, UDP |
| 3 | Network | Routing, IP addressing | IP, ICMP, routers |
| 2 | Data Link | MAC addressing, framing | Ethernet, switches |
| 1 | Physical | Bits on wire | Cables, hubs, signals |

**Memory Aid:** Please Do Not Throw Sausage Pizza Away (bottom-up)

### TCP/IP Model

| TCP/IP Layer | OSI Layers | Protocols |
|-------------|------------|-----------|
| Application | 5-7 | HTTP, DNS, SSH, FTP |
| Transport | 4 | TCP, UDP |
| Internet | 3 | IP, ICMP |
| Network Access | 1-2 | Ethernet, Wi-Fi |

### TCP vs UDP

| Feature | TCP | UDP |
|---------|-----|-----|
| Connection | Connection-oriented | Connectionless |
| Reliability | Guaranteed delivery | Best effort |
| Ordering | Ordered | No ordering |
| Speed | Slower (overhead) | Faster (no overhead) |
| Use cases | HTTP, SSH, email, file transfer | DNS, streaming, gaming, VoIP |
| Handshake | 3-way (SYN, SYN-ACK, ACK) | None |

### IP Addressing

**IPv4:**
- 32-bit address (4 octets): 192.168.1.100
- Total: ~4.3 billion addresses
- Private ranges: 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16
- Loopback: 127.0.0.1

**CIDR Notation:**
| CIDR | Subnet Mask | Hosts |
|------|-------------|-------|
| /8 | 255.0.0.0 | 16 million |
| /16 | 255.255.0.0 | 65,534 |
| /24 | 255.255.255.0 | 254 |
| /32 | 255.255.255.255 | 1 (single host) |

**IPv6:**
- 128-bit address: 2001:0db8:85a3::8a2e:0370:7334
- Virtually unlimited addresses
- No NAT needed
- Loopback: ::1

### Common Ports

| Port | Protocol | Service |
|------|----------|---------|
| 20/21 | TCP | FTP (data/control) |
| 22 | TCP | SSH |
| 23 | TCP | Telnet (insecure) |
| 25 | TCP | SMTP (email sending) |
| 53 | TCP/UDP | DNS |
| 67/68 | UDP | DHCP |
| 80 | TCP | HTTP |
| 110 | TCP | POP3 (email retrieval) |
| 143 | TCP | IMAP (email retrieval) |
| 443 | TCP | HTTPS |
| 3306 | TCP | MySQL |
| 5432 | TCP | PostgreSQL |
| 3389 | TCP | RDP (Remote Desktop) |

### DNS (Domain Name System)

**How DNS Works:**
1. User types www.example.com in browser
2. Browser checks local cache
3. Query goes to recursive DNS resolver
4. Resolver queries root nameserver
5. Root directs to .com TLD nameserver
6. TLD directs to authoritative nameserver
7. Authoritative returns IP address
8. Browser connects to IP

**DNS Record Types:**
| Record | Purpose | Example |
|--------|---------|---------|
| A | IPv4 address | example.com -> 93.184.216.34 |
| AAAA | IPv6 address | example.com -> 2606:2800:220:1:... |
| CNAME | Alias to another domain | www -> example.com |
| MX | Mail server | example.com -> mail.example.com |
| NS | Nameserver | example.com -> ns1.example.com |
| TXT | Text record | SPF, DKIM verification |

### Network Troubleshooting Commands

```bash
ping host                   # test connectivity (ICMP)
traceroute host             # trace route to destination
dig domain                  # DNS lookup (detailed)
nslookup domain             # DNS lookup (simple)
ss -tunlp                   # listening ports with processes
netstat -tunlp              # legacy alternative to ss
curl -v http://host         # HTTP request with details
ip addr show                # network interface configuration
ip route show               # routing table
```

## Key Facts for the Exam

1. CIA triad: Confidentiality, Integrity, Availability
2. Symmetric encryption uses one key; asymmetric uses a key pair
3. TLS encrypts data in transit; HTTPS = HTTP + TLS on port 443
4. SSH uses port 22; always disable root login and use key authentication
5. OSI has 7 layers; TCP/IP has 4 layers
6. TCP is reliable (connection-oriented); UDP is fast (connectionless)
7. /24 subnet = 254 usable hosts; /16 = 65,534 hosts
8. DNS translates domain names to IP addresses using port 53
