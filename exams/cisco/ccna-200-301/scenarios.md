# CCNA - 15 Lab/Simulation Scenarios

These mirror the format of CCNA simulation lab items. Complete each in Packet Tracer (or GNS3 / EVE-NG). Aim for 8-12 minutes per scenario.

---

## Scenario 1 - Basic switch security

Configure a switch named `SW1` with:

- Hostname `SW1`
- Enable secret `cisco123`
- Console password `cisco`
- SSH-only VTY access (no Telnet)
- Local user `admin` with privilege 15

<details>
<summary>Solution</summary>

```
hostname SW1
ip domain-name example.com
crypto key generate rsa modulus 2048
enable secret cisco123
service password-encryption
username admin privilege 15 secret cisco

line console 0
 password cisco
 login
 logging synchronous
 exit

line vty 0 4
 transport input ssh
 login local
 exit

ip ssh version 2
```
</details>

---

## Scenario 2 - VLANs and Trunking

On `SW1`: create VLANs 10 (SALES), 20 (ENG). Assign Fa0/1 to VLAN 10 and Fa0/2 to VLAN 20. Configure Gi0/1 as trunk with native VLAN 99 and allow only VLANs 10, 20.

<details>
<summary>Solution</summary>

```
vlan 10
 name SALES
vlan 20
 name ENG
vlan 99
 name NATIVE

interface fa0/1
 switchport mode access
 switchport access vlan 10

interface fa0/2
 switchport mode access
 switchport access vlan 20

interface gi0/1
 switchport mode trunk
 switchport trunk native vlan 99
 switchport trunk allowed vlan 10,20
```

Verify: `show vlan brief`, `show interfaces trunk`.
</details>

---

## Scenario 3 - Inter-VLAN routing on L3 switch

On a layer-3 switch, configure SVIs for VLANs 10 and 20. Enable IP routing.

<details>
<summary>Solution</summary>

```
ip routing

interface vlan 10
 ip address 10.10.10.1 255.255.255.0
 no shutdown

interface vlan 20
 ip address 10.10.20.1 255.255.255.0
 no shutdown
```

Verify: ping between hosts in different VLANs.
</details>

---

## Scenario 4 - Router-on-a-stick

A single router has Gi0/0 connected to a switch trunk. Configure subinterfaces for VLANs 10 and 20.

<details>
<summary>Solution</summary>

```
interface gi0/0
 no ip address
 no shutdown

interface gi0/0.10
 encapsulation dot1q 10
 ip address 10.10.10.1 255.255.255.0

interface gi0/0.20
 encapsulation dot1q 20
 ip address 10.10.20.1 255.255.255.0
```

Verify: ping from hosts in VLAN 10 to VLAN 20.
</details>

---

## Scenario 5 - PortFast and BPDUguard

Configure all access ports with PortFast and BPDUguard enabled by default.

<details>
<summary>Solution</summary>

```
spanning-tree portfast default
spanning-tree portfast bpduguard default

interface fa0/1
 switchport mode access
```

Verify: `show running-config | begin spanning-tree`. Plug a switch into Fa0/1 in Packet Tracer; observe Fa0/1 going err-disabled.
</details>

---

## Scenario 6 - Make this switch the root for VLAN 10

Configure `SW1` to be the root bridge for VLAN 10.

<details>
<summary>Solution</summary>

```
spanning-tree vlan 10 root primary
! or:
spanning-tree vlan 10 priority 4096
```

Verify: `show spanning-tree vlan 10` shows "This bridge is the root."
</details>

---

## Scenario 7 - LACP EtherChannel

Configure Gi0/1 and Gi0/2 between two switches as an LACP EtherChannel, both as trunks allowing VLANs 10 and 20.

<details>
<summary>Solution</summary>

On both switches:

```
interface range gi0/1 - 2
 channel-group 1 mode active
 exit

interface port-channel 1
 switchport mode trunk
 switchport trunk allowed vlan 10,20
```

Verify: `show etherchannel summary` shows `Po1(SU)` and member ports `(P)`.
</details>

---

## Scenario 8 - Static routing with default

Three routers (R1, R2, R3) in a line. Configure static routes for full reachability and a default route on R3 to the internet.

<details>
<summary>Solution</summary>

R1 (LAN: 10.0.0.0/24, link to R2: 10.10.10.0/30):

```
ip route 0.0.0.0 0.0.0.0 10.10.10.2
```

R2 (links to R1 10.10.10.0/30 and to R3 10.10.20.0/30):

```
ip route 10.0.0.0 255.255.255.0 10.10.10.1
ip route 0.0.0.0 0.0.0.0 10.10.20.2
```

R3 (link to R2 10.10.20.0/30, link to internet):

```
ip route 10.0.0.0 255.0.0.0 10.10.20.1
ip route 0.0.0.0 0.0.0.0 <ISP-next-hop>
```

Verify: `show ip route`, `traceroute` from R1 LAN to internet.
</details>

---

## Scenario 9 - OSPF single-area

3 routers in a triangle, all loopbacks 1.1.1.1, 2.2.2.2, 3.3.3.3. Configure OSPF area 0 on all WAN links plus loopbacks. Make one router prefer to be DR on the LAN segment.

<details>
<summary>Solution</summary>

R1:

```
interface loopback 0
 ip address 1.1.1.1 255.255.255.255

router ospf 1
 router-id 1.1.1.1
 network 1.1.1.1 0.0.0.0 area 0
 network 10.10.0.0 0.0.255.255 area 0
 passive-interface default
 no passive-interface gi0/1
 no passive-interface gi0/2

interface gi0/1
 ip ospf priority 100         ! prefer DR
```

Repeat with appropriate IDs on R2, R3.

Verify: `show ip ospf neighbor` shows neighbors in `FULL` state. `show ip ospf interface` shows DR/BDR roles.
</details>

---

## Scenario 10 - Configure PAT for internet access

R1 has Gi0/0 (inside, 192.168.1.0/24) and Gi0/1 (outside, 203.0.113.10/30). Configure PAT so hosts can browse the internet.

<details>
<summary>Solution</summary>

```
access-list 1 permit 192.168.1.0 0.0.0.255

ip nat inside source list 1 interface gi0/1 overload

interface gi0/0
 ip nat inside

interface gi0/1
 ip nat outside
```

Verify: from a host, ping an outside IP. `show ip nat translations` shows the mapping with port differentiator.
</details>

---

## Scenario 11 - DHCP server on router

Configure R1 as DHCP server for VLAN 10 (10.10.10.0/24). Reserve .1-.10 for static. Push gateway and DNS.

<details>
<summary>Solution</summary>

```
ip dhcp excluded-address 10.10.10.1 10.10.10.10

ip dhcp pool VLAN10
 network 10.10.10.0 /24
 default-router 10.10.10.1
 dns-server 8.8.8.8 8.8.4.4
 domain-name example.com
 lease 7
```

Verify: clients in VLAN 10 receive an IP via DHCP. `show ip dhcp binding` lists leases.
</details>

---

## Scenario 12 - Extended ACL

Allow only HTTP/HTTPS from internal network 10.10.10.0/24 to anywhere. Block everything else.

<details>
<summary>Solution</summary>

```
ip access-list extended OUTBOUND-WEB
 permit tcp 10.10.10.0 0.0.0.255 any eq 80
 permit tcp 10.10.10.0 0.0.0.255 any eq 443
 deny ip any any log

interface gi0/0
 ip access-group OUTBOUND-WEB in
```

Verify: HTTP/HTTPS from 10.10.10.x works. Other protocols blocked.
</details>

---

## Scenario 13 - Port security

Configure Fa0/5 to allow at most 2 MAC addresses, learn them sticky, and shut down on violation.

<details>
<summary>Solution</summary>

```
interface fa0/5
 switchport mode access
 switchport access vlan 10
 switchport port-security
 switchport port-security maximum 2
 switchport port-security mac-address sticky
 switchport port-security violation shutdown
```

Verify: connect 2 hosts (both work). Connect a 3rd → port shuts down.

Recover:

```
interface fa0/5
 shutdown
 no shutdown
```

Or globally:

```
errdisable recovery cause psecure-violation
errdisable recovery interval 60
```
</details>

---

## Scenario 14 - Configure SNMP and syslog

R1 should send syslog to 10.0.0.50 (info-level), and respond to SNMPv3 queries from the same NMS.

<details>
<summary>Solution</summary>

```
! Syslog
logging host 10.0.0.50
logging trap informational
service timestamps log datetime msec

! SNMPv3
snmp-server group MYGROUP v3 priv
snmp-server user admin MYGROUP v3 auth sha SHASECRET priv aes 128 AESSECRET
```

Verify: trigger an interface flap; the NMS should receive syslog. SNMP query from NMS should return data.
</details>

---

## Scenario 15 - SSH-only access with TACACS+ fallback

Configure R1 so SSH login uses TACACS+ first and local users as fallback.

<details>
<summary>Solution</summary>

```
aaa new-model

tacacs server MYTAC
 address ipv4 10.0.0.50
 key SECRET

aaa authentication login default group tacacs+ local
aaa authorization exec default group tacacs+ local

username localadmin privilege 15 secret cisco

line vty 0 4
 transport input ssh
 login authentication default
```

Verify: from a client, SSH using a TACACS+ user (works). Disable TACACS+ server; SSH using `localadmin/cisco` (works).
</details>

---

## Scoring guide

- **All 15 in <2 hours, no notes:** ready to schedule the exam.
- **12-14 in 2-3 hours:** another 1-2 weeks of practice.
- **<12, or you needed notes:** keep practicing in Packet Tracer.

The real exam has 4-6 lab simulations (each 8-15 minutes) plus ~100 multiple-choice / drag-and-drop. If you can do these 15 in 2 hours, the lab portion of the exam is comfortable.
