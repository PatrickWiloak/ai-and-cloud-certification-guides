---
last-updated: 2026-05-03
---

# Cisco CCNP Enterprise ENCOR (350-401) - Exam Strategy

## Format reminder

- 90-110 questions, 120 minutes
- Pass mark: typically 825 / 1000 (~82.5%) - higher than most certs
- Multiple choice, multiple response, drag-and-drop, simulations (lab-style), testlets
- ENCOR is the core exam for CCNP Enterprise; passing it earns Cisco Certified Specialist - Enterprise Core. CCNP Enterprise also requires one concentration exam (ENARSI, ENSDWI, ENSLD, ENWLSI, ENAUTO, ENAUI).

## Top traps

1. **OSPF area types**: Standard, Stub, Totally Stubby, NSSA, Totally NSSA. Each filters specific LSA types. Memorize what each blocks (e.g., Totally Stubby blocks Type 3, 4, 5).

2. **BGP best-path order**: Weight > Local-Pref > Locally originated > Shortest AS_PATH > Origin > MED > eBGP over iBGP > IGP metric to next hop > Older route > Lowest router ID > Lowest neighbor IP. Higher = better for Weight / Local-Pref; lower = better for AS_PATH / MED.

3. **EIGRP metric**: composite of bandwidth + delay (default), with optional load + reliability + MTU. Memorize the formula and what changes K-values affect.

4. **Wireless 802.11**: 2.4 GHz (3 non-overlap channels: 1/6/11), 5 GHz (many), 6 GHz (Wi-Fi 6E). 802.11a/b/g/n/ac/ax (Wi-Fi 6) data rates. WPA2 vs WPA3.

5. **WLC + AP modes**: Local mode (centralized), FlexConnect (branch with WAN survival), monitor, sniffer, mesh, bridge.

6. **Network automation**: NETCONF (XML over SSH) vs RESTCONF (HTTP + JSON or XML). YANG models describe data. Ansible / Python via libraries (ncclient, netmiko).

7. **QoS DSCP values**: EF = 46 (voice), AF41 = 34 (video), CS6 = 48 (network control), default = 0. Memorize the high-yield ones.

8. **STP variants**: STP (802.1D) → RSTP (802.1w) → MSTP (802.1s) → PVST+ → Rapid PVST+. Cisco proprietary vs standards-based. Default Cisco = PVST+.

9. **HSRP / VRRP / GLBP**: HSRP (Cisco), VRRP (standards), GLBP (Cisco, load-balances). Memorize default priorities, hello timers.

10. **IPv6 addresses**: link-local (fe80::/10), unique local (fc00::/7), global unicast (2000::/3). SLAAC vs DHCPv6. ND replaces ARP.

## High-yield topics easy to miss

- VXLAN (overlay for SD-Access fabric)
- LISP (Locator/ID Separation Protocol, used in SD-Access)
- SD-Access vs SD-WAN: SD-Access is campus fabric (DNAC + ISE + Catalyst), SD-WAN is branch (vManage + cEdge / vEdge)
- DNA Center capabilities: Assurance, SWIM (image management), Path Trace, NSP, App Hosting
- IBNS 2.0 (identity-based networking, dot1x with policies)
- IGMP / PIM (multicast)
- Multicast routing: PIM-SM (rendezvous point), PIM-DM (dense, deprecated), PIM-SSM (source-specific)
- VRF-Lite (lightweight VRFs without MPLS)
- Layer 2 security: DHCP snooping, DAI, IP Source Guard, port security

## Time management

120 / ~100 = 1.2 min/question. Tight. Simulations take longer (5-10 min each). Pace: half done by minute 60. Leave 15 min for sim review.

## When stuck

1. **Read the entire question + all options** - Cisco exams reward careful reading.
2. **Eliminate clearly wrong** answers (deprecated tech, non-Cisco terminology).
3. **For sims**: read the question fully, do *exactly* what's asked, save and verify.
4. **For BGP / OSPF questions**: visualize the topology before picking. Sketch on the whiteboard.

## Day-of logistics

120 min, 90-110 questions. Pearson VUE testing center. Bring two IDs. No physical whiteboard at all centers; mental math.

## After

**Pass:** Earns Cisco Certified Specialist - Enterprise Core. Combined with a concentration = CCNP Enterprise. Valid 3 years; recert via Continuing Education or passing a higher cert.

**Fail:** Most failures are on Architecture (15%) or Network Assurance (10%). Re-review SD-Access, automation YANG/NETCONF/RESTCONF, and wireless RRM.

## ENCOR patterns

- "Scale OSPF" = Hierarchical areas + stub variants + summarization
- "BGP path selection" = Local-Pref > AS_PATH > MED hierarchy
- "Wireless interference 2.4 GHz" = 1/6/11 + reduce density + RRM
- "Network automation at scale" = NETCONF/RESTCONF + YANG + Ansible/Python
- "Voice QoS" = DSCP EF + LLQ
- "STP root bridge protection" = BPDU Guard + Root Guard + explicit priority
- "First-hop redundancy" = HSRP / VRRP / GLBP
- "Campus fabric overlay" = VXLAN + LISP + SD-Access
- "Branch SD-WAN" = vManage + cEdge
- "Multicast" = PIM-SM with rendezvous point
