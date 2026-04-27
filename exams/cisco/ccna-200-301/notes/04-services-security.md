# 04 - IP Services (10%) and Security Fundamentals (15%)

## Network Address Translation (NAT)

### NAT terminology (often tested)

| Term | Meaning |
|---|---|
| **Inside Local** | Private IP on inside, as seen from inside |
| **Inside Global** | Public IP on inside, as seen from outside |
| **Outside Local** | Public IP on outside, as seen from inside |
| **Outside Global** | Public IP on outside, as seen from outside |

For typical home/office NAT:

- Inside Local: 192.168.1.10 (your laptop on LAN)
- Inside Global: 203.0.113.5 (your public IP, what the internet sees you as)

### NAT types

| Type | Behavior |
|---|---|
| **Static NAT** | 1-to-1 mapping inside-local → inside-global |
| **Dynamic NAT** | Pool of inside-globals; mappings allocated on demand |
| **PAT (overloading)** | Many inside-locals → one inside-global, distinguished by port |

### Static NAT

```
ip nat inside source static 192.168.1.10 203.0.113.5
interface gi0/0
 ip nat inside
interface gi0/1
 ip nat outside
```

### Dynamic NAT

```
ip nat pool MYPOOL 203.0.113.5 203.0.113.10 netmask 255.255.255.0
access-list 1 permit 192.168.1.0 0.0.0.255
ip nat inside source list 1 pool MYPOOL
```

### PAT (port overload)

```
access-list 1 permit 192.168.0.0 0.0.255.255
ip nat inside source list 1 interface gi0/1 overload
interface gi0/0
 ip nat inside
interface gi0/1
 ip nat outside
```

### Show

```
show ip nat translations
show ip nat statistics
clear ip nat translation *
```

---

## DHCP

### DHCP DORA

`Discover → Offer → Request → Acknowledge`

- Client broadcasts Discover (no IP yet)
- Server replies with Offer
- Client broadcasts Request
- Server confirms with Ack

### DHCP server on Cisco router

```
ip dhcp excluded-address 10.10.10.1 10.10.10.10
ip dhcp pool LAN
 network 10.10.10.0 /24
 default-router 10.10.10.1
 dns-server 8.8.8.8 8.8.4.4
 domain-name example.com
 lease 7
```

`excluded-address` reserves IPs for static use (router, servers).

### DHCP relay (helper-address)

If the DHCP server is on a different subnet, the router needs `ip helper-address` on the client-facing interface:

```
interface vlan 10
 ip address 10.10.10.1 255.255.255.0
 ip helper-address 192.168.50.10
```

The router converts the broadcast Discover into a unicast to the DHCP server.

### Show

```
show ip dhcp binding
show ip dhcp pool
show ip dhcp conflict
```

### DHCPv6

- **Stateful** - server hands out full address (like DHCPv4)
- **Stateless** - server hands out DNS / domain only; client uses SLAAC for the address

---

## DNS

- Hierarchical name system: `.com → example.com → www.example.com`
- Common record types: A, AAAA, CNAME, MX, TXT, NS, PTR (reverse)
- Cisco routers can act as DNS clients:

```
ip name-server 8.8.8.8 1.1.1.1
ip domain-lookup
ip domain-name example.com
```

`no ip domain-lookup` is conventional in CLI to prevent typos triggering DNS queries.

---

## NTP

```
ntp server 10.0.0.1
ntp server 10.0.0.2 prefer

clock timezone EST -5
clock summer-time EDT recurring
```

For the router to act as NTP server:

```
ntp master 5
```

Show:

```
show ntp status
show ntp associations
show clock detail
```

---

## SNMP / Syslog

### Syslog

```
logging host 10.0.0.50
logging trap informational              ! severity 6 and worse
service timestamps log datetime msec
service sequence-numbers
```

Severity levels (memorize):

| Level | Name |
|---|---|
| 0 | Emergencies |
| 1 | Alerts |
| 2 | Critical |
| 3 | Errors |
| 4 | Warnings |
| 5 | Notifications |
| 6 | Informational |
| 7 | Debugging |

`logging trap informational` means levels 0-6.

### SNMP

- v1 and v2c use community strings (cleartext); insecure
- v3 supports auth and encryption

```
snmp-server community SECRET ro
snmp-server host 10.0.0.50 SECRET

! v3
snmp-server group MYGROUP v3 priv
snmp-server user admin MYGROUP v3 auth sha SHASECRET priv aes 128 AESSECRET
```

---

## QoS basics (concept-level)

- **Classification** - identify traffic (ACL, NBAR, DSCP)
- **Marking** - tag with DSCP / IP precedence at the edge
- **Queuing** - order frames for transmission (FIFO, WFQ, LLQ)
- **Shaping** - smooth bursty traffic; buffers excess
- **Policing** - drop or remark traffic that exceeds rate
- **Trust boundary** - network edge where you start trusting QoS markings

CCNA tests recognition; deep QoS config is CCNP.

---

## Access Control Lists (ACLs)

### Numbering ranges

| Range | Type |
|---|---|
| 1-99, 1300-1999 | Standard |
| 100-199, 2000-2699 | Extended |
| Named (any name) | Both standard and extended |

### Standard ACL

Match by **source IP only**. Place close to the **destination**.

```
access-list 10 permit 10.0.0.0 0.255.255.255
access-list 10 deny any log

interface gi0/1
 ip access-group 10 in
```

Wildcard mask is the inverse of subnet mask.

### Extended ACL

Match by source, destination, protocol, ports. Place close to the **source**.

```
access-list 110 permit tcp 10.0.0.0 0.255.255.255 host 192.168.1.5 eq 80
access-list 110 permit tcp 10.0.0.0 0.255.255.255 host 192.168.1.5 eq 443
access-list 110 deny ip any any log
```

### Named ACL (preferred)

```
ip access-list extended WEB-ALLOW
 permit tcp 10.0.0.0 0.255.255.255 any eq 80
 permit tcp 10.0.0.0 0.255.255.255 any eq 443
 deny ip any any log

interface gi0/1
 ip access-group WEB-ALLOW in
```

Named ACLs allow inserting / deleting specific entries by sequence number.

### Implicit deny

Every ACL ends with an implicit `deny ip any any`. If no rule matches, traffic is dropped.

### Show

```
show access-lists
show access-lists 110
show ip interface gi0/1
```

---

## Port security

Limits which MACs can use a switchport. Common for endpoint-facing access ports.

```
interface fa0/1
 switchport mode access
 switchport port-security
 switchport port-security maximum 2
 switchport port-security mac-address sticky
 switchport port-security violation restrict
```

### Violation modes

| Mode | Behavior on violation |
|---|---|
| `protect` | Silently drop packets from unknown MACs |
| `restrict` | Drop packets, log, increment counter |
| `shutdown` | Disable port (err-disabled state) - default |

Recover an err-disabled port:

```
interface fa0/1
 shutdown
 no shutdown
! or globally:
errdisable recovery cause psecure-violation
errdisable recovery interval 60
```

### Show

```
show port-security
show port-security interface fa0/1
show port-security address
```

---

## AAA: Authentication, Authorization, Accounting

### Servers

- **TACACS+** (Cisco) - encrypts entire packet, separates AAA functions, port TCP 49
- **RADIUS** (open) - encrypts only the password, combines auth+authz, ports UDP 1812 (auth) and 1813 (acct)

### Configure (for SSH login)

```
aaa new-model
radius server MYRAD
 address ipv4 10.0.0.50 auth-port 1812 acct-port 1813
 key SECRET

aaa authentication login default group radius local
aaa authorization exec default group radius local
aaa accounting exec default start-stop group radius

line vty 0 4
 transport input ssh
 login authentication default
```

`local` as fallback ensures you can still log in if the RADIUS server is down.

---

## VPN concepts (high-level)

| Type | Use |
|---|---|
| **Site-to-site IPsec** | Office ↔ office; tunneled at routers / firewalls |
| **Remote access (SSL VPN, AnyConnect)** | Single user from anywhere |
| **GRE** | Encapsulation tunnel (no encryption by default) |
| **GRE over IPsec** | Encapsulate + encrypt |
| **DMVPN** | Dynamic multipoint VPN; mesh of site-to-site |

### IPsec phases

- **Phase 1 (IKE)** - establish secure channel; auth (PSK or cert)
- **Phase 2** - negotiate IPsec SAs for actual data

CCNA covers concepts only; full IPsec config is CCNP / CCIE.

---

## Wireless security recap

(See [01-network-fundamentals.md](01-network-fundamentals.md) for general wireless.)

| Standard | Notes |
|---|---|
| WEP | Broken; do not use |
| WPA | Old |
| WPA2-PSK | Pre-shared key |
| WPA2-Enterprise | 802.1X with RADIUS |
| WPA3 | Newest, SAE handshake |

**802.1X** for wireless or wired authentication:

- Supplicant (client)
- Authenticator (switch / AP) - relays
- Authentication Server (RADIUS) - decides

EAP methods: EAP-TLS (cert), PEAP, EAP-FAST.

---

## Common exam triggers

- "Many internal hosts share one public IP" → PAT (NAT overload)
- "DHCP server in a different subnet" → `ip helper-address`
- "Restrict access to web only" → Extended ACL with `permit tcp ... any eq 80/443`, deny ip any any
- "Block specific source from a destination" → Standard ACL near destination
- "Port admits only 2 MAC addresses, sticky learn, drop violations" → Port security with `maximum 2`, `mac-address sticky`, `violation restrict`
- "TACACS+ vs RADIUS" → TACACS+ encrypts everything and is Cisco; RADIUS encrypts only password and is open
- "Authentication via central server with local fallback" → `aaa authentication login default group radius local`
- "WPA2-Enterprise" → 802.1X + RADIUS
