# 02 - Network Access (Domain 2, 20%)

## VLANs

A **VLAN** (Virtual LAN) is a Layer 2 broadcast domain. Multiple VLANs on the same physical switch are isolated.

### VLAN ranges

| Range | Notes |
|---|---|
| 1 | Default; cannot be deleted |
| 1-1005 | Normal range |
| 1006-4094 | Extended range (2950, 2960, etc. require VTP transparent mode) |

### Configure access port

```
interface fa0/1
 switchport mode access
 switchport access vlan 10
```

### Configure trunk port

```
interface gi0/1
 switchport trunk encapsulation dot1q       # only on multi-encap switches
 switchport mode trunk
 switchport trunk allowed vlan 10,20,30
 switchport trunk native vlan 99
```

`switchport mode dynamic auto/desirable` triggers DTP negotiation. Avoid in production - explicitly set `access` or `trunk`.

### Native VLAN

- Untagged frames on a trunk are mapped to the **native VLAN**.
- Default native VLAN is 1; common to change to 99 (or any unused VLAN) and avoid using VLAN 1 for user traffic.
- **Native VLAN must match on both ends of a trunk** or you get CDP mismatch warnings and traffic leak.

### 802.1Q tagging

A 4-byte tag inserted into the Ethernet frame on trunk links. Includes:

- Tag Protocol ID (0x8100)
- Priority (3 bits, 802.1p QoS)
- CFI (1 bit)
- VLAN ID (12 bits) - 1 to 4094

ISL (Cisco proprietary) is legacy; CCNA covers 802.1Q only.

### Voice VLAN

```
interface fa0/1
 switchport mode access
 switchport access vlan 10                 # data VLAN
 switchport voice vlan 20                  # voice VLAN
 mls qos trust cos
```

The phone tags voice traffic with VLAN 20; data behind the phone uses VLAN 10.

### Show commands

```
show vlan brief
show vlan id 10
show interfaces trunk
show interfaces switchport
show interfaces fa0/1 switchport
```

---

## Inter-VLAN routing

### Option 1: Router-on-a-stick

Single trunk link to a router; router has subinterfaces per VLAN.

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

### Option 2: Layer 3 switch with SVIs

```
ip routing                                  # enable L3 routing
vlan 10
 name SALES
vlan 20
 name ENG

interface vlan 10
 ip address 10.10.10.1 255.255.255.0
 no shutdown

interface vlan 20
 ip address 10.10.20.1 255.255.255.0
 no shutdown
```

L3 switch with SVIs is preferred at scale (line-rate routing).

### Option 3: Routed port on L3 switch

```
interface gi0/24
 no switchport                              # convert to L3 routed port
 ip address 192.168.1.1 255.255.255.252
```

---

## Spanning Tree Protocol (STP)

### Why STP?

Without it, redundant L2 paths cause **broadcast storms** and **MAC table instability**.

### Variants

| Name | Details |
|---|---|
| **STP (802.1D)** | Original; ~30s convergence |
| **RSTP (802.1w)** | Rapid; ~6s convergence; modern default |
| **PVST+** | Cisco; per-VLAN STP |
| **Rapid-PVST+** | Cisco; per-VLAN RSTP. Default on most Cisco switches. |
| **MSTP (802.1s)** | Groups VLANs into instances |

### Bridge ID and root election

- Bridge ID = priority + MAC address
- Default priority = 32768
- **Lowest BID wins** as root bridge
- Tiebreaker: lowest MAC

### Manipulate root election

```
spanning-tree vlan 10 priority 4096
# or:
spanning-tree vlan 10 root primary           # priority = 24576 (or 4096 below current root)
spanning-tree vlan 10 root secondary         # priority = 28672
```

### Port roles

- **Root port** - on a non-root switch, the port closest to the root (lowest cost path)
- **Designated port** - on each segment, the port that forwards toward leaves
- **Alternate / non-designated** - blocked port (loop prevention)

### Port states

| STP state | RSTP state |
|---|---|
| Disabled | Discarding |
| Blocking | Discarding |
| Listening | Discarding |
| Learning | Learning |
| Forwarding | Forwarding |

### PortFast and BPDUguard

```
spanning-tree portfast default
spanning-tree portfast bpduguard default

interface fa0/1
 spanning-tree portfast
 spanning-tree bpduguard enable
```

PortFast skips Listening/Learning for endpoint-facing ports. BPDUguard shuts the port if a BPDU arrives (protecting against rogue switches).

### Common show commands

```
show spanning-tree
show spanning-tree vlan 10
show spanning-tree summary
show spanning-tree interface gi0/1
show spanning-tree blockedports
```

---

## EtherChannel (link aggregation)

Combines multiple physical links into one logical link for bandwidth + redundancy.

### Modes

| Mode | Protocol | Notes |
|---|---|---|
| `on` | none (static) | Both sides must be `on` |
| `active` | LACP | Negotiates with `active` or `passive` |
| `passive` | LACP | Negotiates only with `active` |
| `desirable` | PAgP (Cisco) | Negotiates with `desirable` or `auto` |
| `auto` | PAgP | Negotiates only with `desirable` |

### Compatible combinations

- on - on
- active - active OR active - passive
- desirable - desirable OR desirable - auto

### Config example (LACP)

```
interface range gi0/1 - 2
 channel-group 1 mode active

interface port-channel 1
 switchport mode trunk
 switchport trunk allowed vlan 10,20
```

### Verify

```
show etherchannel summary
show etherchannel port-channel
show interfaces port-channel 1
show etherchannel load-balance
```

In `show etherchannel summary`:

- `(P)` - bundled in port-channel (good)
- `(I)` - individual (not bundled)
- `(D)` - down

Both sides must agree on:

- Speed and duplex
- VLAN configuration (access VLAN on access ports, trunk allowed VLANs on trunks)
- Port-security settings
- Spanning-tree settings

---

## Discovery protocols

### CDP (Cisco Discovery Protocol)

Cisco-proprietary L2 protocol. Discovers directly-connected Cisco neighbors.

```
cdp run                                     # global enable (default)
cdp enable                                  # per-interface enable (default)

show cdp neighbors
show cdp neighbors detail
show cdp interface
```

### LLDP (Link Layer Discovery Protocol)

Open standard (802.1AB). Multi-vendor.

```
lldp run                                    # global enable
interface gi0/1
 lldp transmit
 lldp receive

show lldp neighbors
show lldp neighbors detail
```

CDP is on by default on Cisco; LLDP is off and must be enabled.

---

## Wireless architecture (concept-level)

### WLC (Wireless LAN Controller)

Centralized management for lightweight APs. Handles:

- AP configuration and firmware
- Client authentication (RADIUS integration)
- Roaming between APs
- RF management (channel selection, power)
- Centralized data forwarding (split-MAC) or local forwarding (FlexConnect)

### CAPWAP

The protocol APs use to talk to the WLC.

- Control: UDP 5246 (DTLS-encrypted)
- Data: UDP 5247

### Wireless security

| Type | Notes |
|---|---|
| **Open** | No security; avoid |
| **WEP** | Broken; do not use |
| **WPA** | Old; deprecated |
| **WPA2-PSK** | Pre-shared key, AES-CCMP |
| **WPA2-Enterprise** | 802.1X with RADIUS, individual user creds |
| **WPA3** | Newest; SAE handshake (replaces PSK), 192-bit Enterprise option |

### 802.1X

- Supplicant (client), Authenticator (switch / AP), Authentication Server (RADIUS).
- EAP methods: EAP-TLS (cert-based), PEAP, EAP-FAST.

---

## Common exam triggers

- "Allow only specific VLANs on a trunk" → `switchport trunk allowed vlan add 10,20`
- "Native VLAN mismatch warnings" → Check both sides have the same `native vlan`
- "Switchport security: max 2 MACs, sticky learning, drop violations" → `switchport port-security`, `maximum 2`, `mac-address sticky`, `violation restrict`
- "Make this switch the root for VLAN 10" → `spanning-tree vlan 10 root primary` or `priority 4096`
- "End-host port skips listening/learning" → PortFast
- "Block a port that receives a BPDU" → BPDUguard
- "Router-on-a-stick for two VLANs" → Router subinterfaces with `encapsulation dot1q`
- "Aggregate two switch links for bandwidth" → EtherChannel (LACP active/active)
- "Discover non-Cisco neighbor" → LLDP (CDP is Cisco-only)
