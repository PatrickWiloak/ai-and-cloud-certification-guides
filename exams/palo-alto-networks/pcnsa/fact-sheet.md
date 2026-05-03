# PCNSA - Fact Sheet

## Quick Reference

**Exam Code:** PCNSA
**PAN-OS:** 11.x (currently 11.0/11.1)
**Duration:** 80 minutes
**Questions:** 60
**Passing Score:** ~70%
**Cost:** $155 USD
**Validity:** 2 years
**Recommended Course:** EDU-210 Firewall Essentials

**[PCNSA exam page](https://www.paloaltonetworks.com/services/education/certification/pcnsa)**
**[PAN-OS 11.x admin guide](https://docs.paloaltonetworks.com/pan-os/11-1/pan-os-admin)**
**[LIVEcommunity](https://live.paloaltonetworks.com/)**

---

## Domain Weights

| Domain | Weight |
|---|---|
| 1.0 Palo Alto Networks Portfolio and Architecture | 22% |
| 2.0 Manage and Configure NGFW | 30% |
| 3.0 Connect Network Components | 30% |
| 4.0 Manage and Configure Security Policies and Profiles | 18% |

---

## The Three IDs (core concept - high yield)

PAN-OS classifies every flow with three identification engines that run in the single-pass parallel processing (SP3) data plane.

| Engine | What it identifies | How |
|---|---|---|
| **App-ID** | The application (Facebook, SSH, Salesforce, BitTorrent, etc.) | Signatures, decoders, heuristics, decryption-aware. Port-independent. |
| **User-ID** | The user (`acme\jdoe`) tied to an IP | Server Monitoring (AD security logs), syslog parsing, GlobalProtect, Captive Portal, XML API, TS Agent (terminal servers), User-ID agent |
| **Content-ID** | Threats and content inside the flow | Inline AV, Anti-Spyware, Vulnerability Protection, URL filtering, file blocking, WildFire analysis, data filtering |

**Why this matters on the exam:** Security policy can match on application, source user, URL category, and HIP - not just IP/port. Allowing "web-browsing" to "facebook-base" is more precise than allowing tcp/443.

---

## Single-Pass Parallel Processing (SP3)

```
Packet in
  │
  ├─> Decryption (if SSL/TLS decrypt policy matches)
  │
  ├─> Single-pass: parse once
  │     - App-ID
  │     - User-ID
  │     - Content-ID (threats, URL, file, WildFire)
  │     - Policy match
  │
  └─> Parallel processing across multiple cores
       - Networking, signatures, decoders happen on dedicated chips
Packet out
```

The "single pass" means the firewall does not decode the packet multiple times for each feature (unlike legacy UTMs that chained AV, IPS, URL filtering as separate processes). The "parallel processing" means signature matching, networking, and policy can happen on different cores simultaneously.

---

## Portfolio (memorize the families)

| Family | Sub-products | Purpose |
|---|---|---|
| **Strata** | NGFW (PA-Series, VM-Series, CN-Series), Panorama, AIOps for NGFW, IoT Security | On-prem and cloud network security |
| **Prisma** | Prisma Cloud, Prisma Access, Prisma SD-WAN (CloudGenix), Prisma SASE | Cloud-delivered security, SASE |
| **Cortex** | Cortex XDR, Cortex XSOAR (Demisto), Cortex XSIAM, Cortex Data Lake (now Strata Logging Service) | SecOps, automation, SIEM/SOC |

NGFW form factors:

- **PA-Series** - hardware appliances (PA-410 SOHO up to PA-7080 datacenter)
- **VM-Series** - virtualized for ESXi, KVM, Hyper-V, AWS, Azure, GCP, OCI, NSX
- **CN-Series** - containerized firewall for Kubernetes (sidecar / cluster)

---

## Interface Types

| Type | Use case | L3? | Zone required? |
|---|---|---|---|
| **Tap** | Passive monitoring (SPAN port) | No | Yes (tap zone) |
| **Virtual Wire (vwire)** | Bump-in-the-wire, no MAC/IP changes | No | Yes (vwire zone, two interfaces) |
| **Layer 2** | Switching between zones, optional VLAN tagging | No | Yes |
| **Layer 3** | Most common, has IP, supports routing | Yes | Yes |
| **Aggregate Ethernet (AE)** | LACP bundle, can be L2 or L3 | Either | Yes |
| **HA** | Dedicated HA1 / HA2 / HA3 link | n/a | n/a |
| **Loopback** | Management, BGP peering, GlobalProtect portal | Yes | Yes |
| **Tunnel** | IPsec or GRE | Yes | Yes |
| **VLAN** | Logical interface on L2 zone | Yes | Yes (parent L2) |

Every dataplane interface must be in a security zone for traffic to be inspected.

---

## Zones

- **Intrazone** - traffic source and destination zone are the same
- **Interzone** - traffic crosses zones
- **Universal** - default rule type, matches both intrazone and interzone
- **Implicit defaults at the bottom of the security policy:**
  - `intrazone-default` = allow, no logging
  - `interzone-default` = deny, no logging
- You can override implicit defaults to enable logging or change behavior. They cannot be deleted.

---

## Security Policy Rule Fields

A security policy rule is matched on these fields (left-to-right in the GUI):

| Field | Notes |
|---|---|
| **Rule type** | universal (default), intrazone, interzone |
| **Source Zone** | One or more zones |
| **Source Address** | Address objects, groups, regions, or `any` |
| **Source User** | User-ID users/groups, `known-user`, `unknown`, or `any` |
| **Source HIP Profile** | GlobalProtect Host Information Profile |
| **Destination Zone** | One or more zones |
| **Destination Address** | Address objects, groups, regions, or `any` |
| **Application** | App-ID(s) - this is the heart of the rule |
| **Service / URL Category** | Service objects (port-based - default `application-default`), URL category |
| **Action** | Allow, Deny, Drop, Reset client/server/both |
| **Profile Setting** | Security profile group or individual profiles |
| **Log Setting** | Log at session start / end, log forwarding profile |

**`application-default` service** is preferred: PAN-OS uses the application's known port(s) instead of forcing you to specify `tcp/443`. If a SaaS app uses non-standard ports legitimately, App-ID handles it.

---

## Policy Evaluation Order

1. PAN-OS evaluates rules **top-down**.
2. **First matching rule wins.** No more rules are evaluated.
3. If no rule matches, traffic hits the **interzone-default (deny)** or **intrazone-default (allow)**.
4. NAT rules are evaluated **before** security policy lookup, but security policy uses **pre-NAT IP, post-NAT zone**.
5. App-ID may shift the matched rule mid-session if the application changes (App-ID dependency / app-shift). Configure with care.

---

## NAT Translation Types

PAN-OS NAT is configured in `Policies > NAT`. Each rule has an Original Packet (match) and Translated Packet (action) section.

### Source NAT (outbound)

| Subtype | What | Use case |
|---|---|---|
| **Dynamic IP and Port (DIPP)** | One public IP shared across many internal hosts using ports (PAT) | Default outbound for SMBs |
| **Dynamic IP** | Pool of public IPs, no port translation | When you need predictable port preservation (VoIP, gaming) |
| **Static IP** | One-to-one fixed mapping | Server with predictable outbound source IP |

### Destination NAT (inbound / port forwarding)

- Translate destination IP (and optionally port) so external clients can reach internal servers
- Match on pre-NAT destination IP and pre-NAT zone, but translate before routing decision
- Common: external `203.0.113.10:443` → internal `10.0.0.50:443`
- **Security policy must use post-NAT zone (the internal zone) but pre-NAT destination IP** when it is a destination NAT scenario - critical exam fact

### U-turn NAT (hairpin)

- Internal users access an internal server using its public IP (because of split-DNS issues or hard-coded URLs)
- Source NAT + destination NAT applied in the same rule so the server sees the firewall as the source (avoids asymmetric routing)
- Source translated to firewall's internal interface IP; destination translated to internal server IP

### NAT Rule Match Order

NAT rules are also top-down, first match wins.

---

## Common CLI Commands (memorize)

PAN-OS CLI has two modes: **operational** (`>`) and **configuration** (`#`). Type `configure` to enter config mode.

### Operational mode (show / debug / system)

```
show system info                          # serial, model, PAN-OS version, uptime
show system resources                     # CPU, memory like top
show jobs all                             # commit / install jobs
show config running                       # current running config (XML)
show interface all                        # all interfaces summary
show interface ethernet1/1                # specific interface
show session all                          # active sessions (very long; pipe filters)
show session all filter source 10.0.0.5   # filter sessions by attribute
show session info                         # session table stats
show session id <session-id>              # detail on a single session
show running security-policy              # rules as evaluated by dataplane
show running nat-policy                   # NAT rules as evaluated
show routing route                        # routing table
show routing fib                          # forwarding information base
show arp all                              # ARP table
show user ip-user-mapping all             # User-ID mappings
show user user-ids                        # users known to firewall
show high-availability state              # HA state (active/passive/etc)
show high-availability all                # full HA detail
show counter global filter packet-filter yes   # global counters with filter
show log traffic direction equal backward       # last 100 traffic logs
show log threat                           # threat log
debug dataplane packet-diag set filter ...  # capture filter setup
```

### Configuration mode

```
configure
# now in config mode, prompt is #
set deviceconfig system hostname FW-EDGE
set network interface ethernet ethernet1/1 layer3 ip 10.0.0.1/24
set zone trust network layer3 ethernet1/1
edit rulebase security rules Allow-Web
set from trust to untrust source any destination any application web-browsing service application-default action allow
top                                       # back to top of config tree
commit                                    # commit candidate config
commit force                              # force commit (skip validation warnings)
exit                                      # leave config mode
```

### Useful one-liners

```
> show system software status              # is anything installing?
> request system software check            # check for new PAN-OS versions
> request content upgrade check            # check for App+Threat updates
> request anti-virus upgrade check         # AV update check
> request wildfire upgrade check           # WildFire signature check
> tail follow yes mp-log ms.log            # tail management plane log
> less mp-log devsrv.log                   # paginated read of a log
> ping host 8.8.8.8 source 10.0.0.1        # ping from a specific source
> test routing fib-lookup virtual-router default ip 8.8.8.8     # which FIB entry?
> test security-policy-match ...           # simulate which rule a flow matches
> test nat-policy-match ...                # simulate NAT match
```

---

## `test security-policy-match` (high-yield)

Predicts which security rule will match without sending real traffic. Common form:

```
test security-policy-match \
  source 10.0.0.5 destination 8.8.8.8 \
  source-user "acme\jdoe" \
  destination-port 443 protocol 6 \
  application ssl from trust to untrust
```

`test nat-policy-match` is the same idea for NAT rules.

---

## Security Profiles (Content-ID)

Profiles attach to security rules with action `allow` to add inline inspection. Sets of profiles can be bundled in a **Profile Group**.

| Profile | Purpose | Common actions |
|---|---|---|
| **Antivirus** | Inline malware signatures over SMTP/POP3/IMAP/FTP/HTTP/SMB | allow, alert, drop, reset-client, reset-server, reset-both |
| **Anti-Spyware** | C2 / spyware traffic, DNS sinkhole | allow, alert, drop, reset, sinkhole (DNS) |
| **Vulnerability Protection** | IPS-style signatures for exploits | allow, alert, drop, reset, block-ip |
| **URL Filtering** | Web category enforcement, credential phishing prevention | allow, alert, continue (warn), override, block, none |
| **File Blocking** | Block by file type (.exe, .bat) per app/direction | alert, block, continue |
| **WildFire Analysis** | Forward unknown files to WildFire cloud sandbox | forward (public-cloud / private-cloud) |
| **Data Filtering** | Pattern matching for data egress (CC#, SSN) | alert, block, continue |
| **DoS Protection** | Per-rule SYN flood / UDP flood / ICMP flood | classified vs aggregate |

**Default profiles** ship out of the box: `default` and `strict`. New rules default to none until you assign a group.

---

## Zone Protection vs DoS Protection (commonly confused)

| Aspect | Zone Protection | DoS Protection |
|---|---|---|
| **Where applied** | Zone object (Network > Zones > Zone Protection) | Security rule via DoS Protection profile + DoS rule |
| **Granularity** | Per zone (all traffic entering the zone) | Per rule, per source/destination IP, classified or aggregate |
| **Use case** | Coarse perimeter defense (recon scans, packet-based attacks) | Targeted protection of specific servers (e.g., web farm) |
| **Profile types** | Flood (SYN, UDP, ICMP, ICMPv6, Other-IP), Reconnaissance, Packet-based attacks, Protocol Protection, Ethernet SGT | Classified, Aggregate |
| **Action examples** | Random Early Drop (RED), SYN cookies, drop, alert | Random Early Drop, drop, alert |
| **License needed** | None | None |

Rule of thumb: zone protection = "defend the front door from internet noise." DoS protection = "defend a specific server from a targeted flood."

---

## High Availability (HA)

### Active/Passive

- One firewall is active, one is passive.
- Failover triggers: link failure, path monitor failure, heartbeat loss, internal health check.
- Most common deployment.

### Active/Active

- Both firewalls process traffic simultaneously.
- Used for asymmetric routing tolerance, not throughput doubling.
- More complex; requires HA3 link.

### HA Links

| Link | Purpose | Traffic |
|---|---|---|
| **HA1** | Control / heartbeat | HA state, hello packets, configuration sync |
| **HA1 backup** | Optional redundant control | Same as HA1 |
| **HA2** | Session/state synchronization | Session table, ARP, IPsec SA |
| **HA2 backup** | Optional redundant state | Same as HA2 |
| **HA3** | Active/active packet forwarding | Forwards packets between peers when one peer owns the session |

### What syncs vs what doesn't

- Syncs: running config, sessions, IPsec SAs, ARP, NDP, ND, FIB.
- Does **not** sync: management interface IP, hostname, HA cfg itself, log database.

---

## Dynamic Updates (memorize the cadence)

Updates download from `updates.paloaltonetworks.com`. Configure under `Device > Dynamic Updates`.

| Update | Default cadence | Why |
|---|---|---|
| **Antivirus** | Every 24 hours | Inline malware signatures |
| **Applications and Threats** | Daily (Threat Prevention license) or Weekly (App-ID only) | App-ID + IPS signatures |
| **WildFire** | Every 1-5 minutes (with WildFire license) | Bleeding-edge malware verdicts |
| **URL Filtering (PAN-DB)** | Real-time cloud lookup + cached locally | Web category data |
| **GlobalProtect Data File** | As needed | HIP signatures |
| **Device Telemetry** | As needed | Telemetry uploads |

Best practice: stagger schedules and use **Threshold** (e.g., wait 48 hours before installing the latest content) to avoid bad signature releases.

---

## Licenses (commonly tested)

| License | What it unlocks |
|---|---|
| **Support** | TAC, RMA, software downloads |
| **Threat Prevention** | IPS (Vulnerability Protection), Antivirus, Anti-Spyware, file/data filtering |
| **WildFire** | Cloud sandbox, sub-5-minute signature updates |
| **Advanced URL Filtering** | Real-time URL category, credential phishing prevention, ML-based |
| **DNS Security** | ML-based DNS sinkhole, advanced DGA detection |
| **GlobalProtect** | VPN portal/gateway features beyond single gateway |
| **SD-WAN** | App-aware path selection across multiple ISPs |
| **IoT Security** | Device profiling and policy recommendations |
| **AutoFocus** | Threat intelligence (now bundled into other products) |

Subscriptions are PER-DEVICE and serialized to the firewall's serial number.

---

## Logs

| Log | What |
|---|---|
| **Traffic** | Session start/end, sources/dests, app, action |
| **Threat** | AV/AS/Vuln/URL/WildFire/file/data hits |
| **URL Filtering** | Specific URL events |
| **Data** | Data filtering profile events |
| **WildFire Submissions** | Verdicts on samples sent to sandbox |
| **HIP Match** | GlobalProtect HIP profile matches |
| **GlobalProtect** | VPN session events |
| **IP-Tag** | Dynamic address group tag changes |
| **User-ID** | User mapping events |
| **Tunnel** | IPsec phase 1/2 |
| **Configuration** | Config changes (who/when/what) |
| **System** | System events (HA, daemons, faults) |
| **Authentication** | Admin and Captive Portal auth |

Log forwarding profile can send logs to:

- **Panorama** / **Cortex Data Lake** (most common)
- **Syslog** (TCP/UDP/SSL)
- **SNMP traps**
- **Email**
- **HTTP(S)** webhooks (for SOAR integration)

---

## Panorama (centralized management)

- Manages many firewalls from one console.
- **Device Groups** = policy and object inheritance hierarchy.
- **Templates / Template Stacks** = network and device config (interfaces, zones, virtual routers, dynamic updates, log forwarding).
- **Log Collectors** = aggregated log database (M-Series Log Collector or VM dedicated to logging).
- **Plugins** = extend Panorama (Cisco ACI, AWS, Azure, GCP, Kubernetes, ServiceNow, etc.).
- **Modes**: Panorama mode, Log Collector mode, Management Only mode.

---

## High-Yield Acronyms

| Acronym | Meaning |
|---|---|
| **NGFW** | Next-Generation Firewall |
| **SP3** | Single-Pass Parallel Processing |
| **App-ID** | Application Identification |
| **User-ID** | User Identification |
| **Content-ID** | Content Identification |
| **HIP** | Host Information Profile (GlobalProtect endpoint posture) |
| **PAN-DB** | Palo Alto Networks URL filtering database |
| **DIPP** | Dynamic IP and Port (PAT) |
| **PBF** | Policy-Based Forwarding |
| **VR** | Virtual Router |
| **VSYS** | Virtual System (multi-tenant) |
| **AE** | Aggregate Ethernet |
| **HA1/HA2/HA3** | HA control / state / packet links |
| **WF** | WildFire |
| **TS Agent** | Terminal Services agent (User-ID for Citrix/RDS) |
| **CP** | Captive Portal |
| **GP** | GlobalProtect |
| **PA-DB** | PAN-DB (URL filtering database) |
| **DLP** | Data Loss Prevention (Enterprise DLP add-on) |

---

## Key URLs to Bookmark

- **[PAN-OS Admin Guide](https://docs.paloaltonetworks.com/pan-os/11-1/pan-os-admin)**
- **[PAN-OS CLI Quick Start](https://docs.paloaltonetworks.com/pan-os/11-1/pan-os-cli-quick-start)**
- **[Networking docs](https://docs.paloaltonetworks.com/pan-os/11-1/pan-os-networking-admin)**
- **[Panorama admin guide](https://docs.paloaltonetworks.com/panorama/11-1/panorama-admin)**
- **[Applipedia (App-ID database)](https://applipedia.paloaltonetworks.com)**
- **[URL Test (PAN-DB lookup)](https://urlfiltering.paloaltonetworks.com)**
- **[LIVEcommunity](https://live.paloaltonetworks.com)**
- **[Compatibility Matrix](https://docs.paloaltonetworks.com/compatibility-matrix)**
