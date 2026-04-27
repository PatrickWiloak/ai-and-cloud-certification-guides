# 03 - IP Connectivity / Routing (Domain 3, 25%)

The largest exam domain. Master routing concepts, static routes, OSPF single-area, and FHRP concepts.

## Routing fundamentals

### How routers decide

1. Look up destination IP in **routing table**.
2. Pick the **longest prefix match** that covers the destination.
3. Forward out the matching interface (or to the next-hop IP).

If multiple routes are equal-prefix-length, **administrative distance (AD)** is the tiebreaker:

| Source | AD |
|---|---|
| Connected | 0 |
| Static | 1 |
| EIGRP summary | 5 |
| External BGP | 20 |
| Internal EIGRP | 90 |
| OSPF | 110 |
| RIPv2 | 120 |
| External EIGRP | 170 |
| Internal BGP | 200 |
| Unknown / Untrusted | 255 |

If still tied (same AD), the routing protocol's **metric** is the tiebreaker.

### show commands

```
show ip route                    # full routing table
show ip route 192.168.1.0       # specific
show ip route ospf
show ip route static
show ip route connected
show ip protocols                # active routing protocols
show ip cef                      # FIB (forwarding info base)
show ip arp
```

Symbols in `show ip route`:

- `C` - connected
- `L` - local (router's own IP)
- `S` - static
- `S*` - candidate default
- `O` - OSPF intra-area
- `O IA` - OSPF inter-area
- `O E1`, `O E2` - OSPF external
- `R` - RIP
- `D` - EIGRP
- `B` - BGP

---

## Static routing

### Syntax

```
ip route <destination> <mask> <next-hop-ip-or-interface>

ip route 0.0.0.0 0.0.0.0 192.168.1.1                # default route
ip route 10.0.0.0 255.0.0.0 192.168.1.1
ip route 10.0.0.0 255.0.0.0 GigabitEthernet0/1
ip route 10.0.0.0 255.0.0.0 192.168.1.1 5            # AD 5 (floating static)
```

### Floating static routes

A static route with higher AD than the dynamic route. It's installed only if the dynamic route fails.

```
router ospf 1
 network 10.0.0.0 0.255.255.255 area 0
 ! AD 110

ip route 10.0.0.0 255.0.0.0 192.168.99.1 200      ! AD 200; only used if OSPF dies
```

### Default route

```
ip route 0.0.0.0 0.0.0.0 192.168.1.1
ip default-network 192.168.1.0          ! older syntax
```

For OSPF advertising default:

```
router ospf 1
 default-information originate
```

### IPv6 static

```
ipv6 unicast-routing                     ! enable IPv6 routing
ipv6 route 2001:db8:abcd::/48 2001:db8::1
ipv6 route ::/0 2001:db8::1              ! default
```

---

## OSPF single-area

### Concepts

- **Type:** Link-state
- **Algorithm:** Dijkstra (SPF)
- **Metric:** Cost = reference_bandwidth / interface_bandwidth (default ref = 100 Mbps; bump to 100 Gbps with `auto-cost reference-bandwidth 100000`)
- **Hello / Dead intervals:** 10/40s on broadcast LANs; 30/120s on NBMA
- **Multicast:** 224.0.0.5 (all OSPF), 224.0.0.6 (DR/BDR)
- **Areas:** All areas connect to area 0 (backbone). CCNA covers single-area.
- **Router ID:** Highest configured loopback IP, else highest active interface IP, or `router-id` command.

### Configure

```
router ospf 1
 router-id 1.1.1.1
 network 10.10.10.0 0.0.0.255 area 0
 network 192.168.1.0 0.0.0.255 area 0
 passive-interface default
 no passive-interface gi0/1
 no passive-interface gi0/2
```

`network` uses **wildcard mask** (inverted subnet mask).

`passive-interface default` then `no passive-interface <intf>` is the modern best practice (passive everything by default, enable on uplinks).

### Neighbor states

`Down → Init → 2-Way → Exstart → Exchange → Loading → Full`

- `2-Way` is normal on multi-access (LAN) for non-DR/BDR neighbors.
- `Full` means full LSDB sync.
- Stuck in `Init` or `Exstart` usually means MTU mismatch, hello/dead mismatch, or area mismatch.

### DR / BDR

On a multi-access (broadcast / Ethernet) network, OSPF elects a Designated Router (DR) and Backup DR (BDR) to avoid full mesh adjacencies.

- DR has the highest **OSPF priority** (default 1; tiebreaker is highest router-id).
- Priority 0 = will never become DR.
- DR election is non-preemptive - changing priorities doesn't trigger a re-election.

```
interface gi0/1
 ip ospf priority 100                ! make this router preferred DR
```

To force re-election: `clear ip ospf process` on the affected router.

### Common adjacency requirements

For two OSPF routers to become `Full`:

- Same area
- Same hello / dead intervals
- Same subnet (same OSPF interface)
- Same MTU (huge gotcha)
- Matching authentication (if configured)
- Compatible network type
- Matching stub area flags

### show commands

```
show ip ospf
show ip ospf neighbor
show ip ospf interface
show ip ospf interface gi0/1
show ip ospf database
show ip protocols
debug ip ospf events                ! use sparingly
debug ip ospf adj
```

### OSPFv3 (IPv6)

```
ipv6 unicast-routing
interface gi0/1
 ipv6 ospf 1 area 0
router ospfv3 1
 router-id 1.1.1.1
 address-family ipv6 unicast
  passive-interface default
  no passive-interface gi0/1
 exit-address-family
```

---

## First-Hop Redundancy (FHRP) - concept-level

CCNA tests recognition; full config is CCNP territory.

### HSRP (Hot Standby Router Protocol)

- Cisco proprietary
- One active, one standby
- Virtual IP and virtual MAC (`0000.0c07.acXX` where XX is group number)
- Config snippet:

```
interface vlan 10
 ip address 10.10.10.2 255.255.255.0
 standby 1 ip 10.10.10.1
 standby 1 priority 110
 standby 1 preempt
```

### VRRP (Virtual Router Redundancy Protocol)

- Open standard (RFC 5798)
- Master / backup
- Multicast 224.0.0.18
- Similar concept to HSRP

### GLBP (Gateway Load Balancing Protocol)

- Cisco proprietary
- Active / active load balancing
- Single virtual IP, multiple virtual MACs

### What you need to know on CCNA

- HSRP and VRRP are active/standby
- GLBP is active/active load-balanced
- HSRP and GLBP are Cisco-only; VRRP is open standard
- HSRP virtual MAC pattern (0000.0c07.acXX) is high-yield trivia

---

## Common exam triggers

- "Add a default route via 192.168.1.1" → `ip route 0.0.0.0 0.0.0.0 192.168.1.1`
- "Backup route used only if OSPF fails" → floating static with AD > 110
- "OSPF neighbors stuck in EXSTART" → MTU mismatch, check `show ip ospf interface`
- "Make this router the OSPF DR" → `ip ospf priority 255` (and then clear ip ospf process on the segment)
- "Don't form OSPF adjacency on user-facing port" → `passive-interface gi0/1`
- "OSPF default route announcement" → `default-information originate`
- "Two OSPF neighbors won't form" → check area, hello/dead, MTU, subnet, auth
- "Active/active gateway redundancy" → GLBP

---

## Troubleshooting workflow

When a route is missing or traffic doesn't flow:

1. `show ip interface brief` - interface up/up?
2. `ping <directly-connected>` - L2/L1 working?
3. `show ip route <destination>` - is the route there?
4. If not, `show ip route` - look for the parent supernet
5. `show ip protocols` - is the routing process running?
6. `show ip ospf neighbor` - did neighbor form?
7. `show ip ospf interface` - did the interface get included? Right area? Hello/dead matching?
8. `traceroute <destination>` - where does the packet die?
9. `debug ip ospf events` (use carefully)
