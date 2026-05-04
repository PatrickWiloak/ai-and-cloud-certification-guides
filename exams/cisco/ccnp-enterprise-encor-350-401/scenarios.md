---
last-updated: 2026-05-03
---

# Cisco CCNP Enterprise ENCOR (350-401) - Exam Scenarios

> Six worked scenarios mirroring CCNP ENCOR question style. ENCOR tests enterprise networking depth: routing protocols (OSPF, BGP, EIGRP), wireless, automation, security, virtualization.

---

## Scenario 1 - OSPF area design

A campus has 200 routers in a flat OSPF area 0. SPF runs are slow, LSDB is huge. Which approach scales OSPF?

**Options:** A. Hierarchical OSPF: backbone area 0 + non-backbone areas (regular, stub, totally stubby, NSSA) connected via ABRs; LSA filtering at area boundaries. B. Single area with route summarization. C. Static routes everywhere. D. Switch to RIP.

**Analysis:** A is right - hierarchical OSPF with multiple areas reduces LSDB size in non-backbone areas. Stub / totally stubby filter out external LSAs. B doesn't help; route summarization helps but doesn't reduce LSDB. C is unmanageable. D is regression.

**Answer:** A

**Key takeaway:** OSPF scales via hierarchical area design. Stub variants control which LSA types propagate. Memorize stub / totally stubby / NSSA / totally NSSA distinctions.

---

## Scenario 2 - BGP route selection

You receive the same prefix from two ISPs. Local-Pref differs (ISP1: 200, ISP2: 100). AS_PATH length is same.

Which path is selected?

**Options:** A. ISP1 (higher Local-Pref). B. ISP2. C. Equal-cost multi-path. D. Random.

**Analysis:** A is right - BGP best-path selection order: Weight (Cisco-only) > Local-Pref > Locally originated > Shortest AS_PATH > Origin > MED > eBGP over iBGP > IGP metric to next hop > Older route > Lowest router ID > Lowest neighbor IP. Higher Local-Pref wins.

**Answer:** A

**Key takeaway:** Memorize BGP best-path order. Higher = better for Weight, Local-Pref. Lower = better for AS_PATH length, MED.

---

## Scenario 3 - Wireless RF interference

A WLC monitor shows excessive co-channel interference on 2.4 GHz; 5 GHz is fine. Which fix?

**Options:** A. Reduce 2.4 GHz AP density; use only channels 1, 6, 11; consider disabling 2.4 GHz where 5 GHz coverage is adequate. B. Add more APs on 2.4 GHz. C. Use channel 7 instead. D. Disable RRM.

**Analysis:** A is right - 2.4 GHz only has 3 non-overlapping channels (1, 6, 11). High density causes co-channel interference. The fix is reducing AP count, sticking to 1/6/11, or disabling 2.4 GHz where 5 GHz suffices. B makes it worse. C - channel 7 overlaps. D - RRM (Radio Resource Management) is the *fix*, not the problem.

**Answer:** A

**Key takeaway:** 2.4 GHz: 3 non-overlapping channels (1, 6, 11). 5 GHz: many channels, less density issues. RRM auto-tunes channel + power.

---

## Scenario 4 - Network automation

A team manages 200 routers manually. They want to push config changes consistently and version-controlled.

**Options:** A. Cisco DNA Center for SD-Access lifecycle, or Ansible playbooks via NETCONF/RESTCONF; configs in Git. B. SSH and copy/paste. C. TFTP server with config files. D. Each engineer manually updates.

**Analysis:** A is right - DNA Center for prescriptive Cisco SDN. Ansible / Python with NETCONF is the open-standards path. Configs in Git for version control. B doesn't scale. C is one-way push without state management. D is manual.

**Answer:** A

**Key takeaway:** Modern Cisco automation: NETCONF/RESTCONF + YANG models + Ansible / Python. DNA Center for SD-Access turnkey. Memorize NETCONF (XML) vs RESTCONF (HTTP+JSON).

---

## Scenario 5 - QoS for unified communications

A network carries voice + video + data. Voice has strict <150ms one-way latency, < 30ms jitter. Which QoS approach fits?

**Options:** A. DiffServ: classify voice as EF (Expedited Forwarding, DSCP 46), video as AF41, data as default; LLQ (priority queue) for EF; bandwidth-guaranteed CBWFQ for AF; FIFO for default. B. FIFO for everything. C. Bandwidth booking only. D. Disable QoS.

**Analysis:** A is right - DiffServ + LLQ + CBWFQ is the canonical Cisco QoS pattern for converged networks. EF for voice, AF for video, default for data. B causes jitter. C is bandwidth without prioritization. D guarantees voice quality issues.

**Answer:** A

**Key takeaway:** Cisco QoS: classify (DSCP) → mark → queue (LLQ for EF, CBWFQ for AF) → schedule → drop policy. Voice = EF (DSCP 46). Video = AF41.

---

## Scenario 6 - Spanning Tree security

An enterprise wants to prevent rogue switches from becoming root bridge.

**Options:** A. Enable BPDU Guard on access ports; Root Guard on uplinks to prevent root role from being claimed; configure root bridge priority on the intended root. B. Disable STP. C. VLAN ACLs. D. 802.1X.

**Analysis:** A is right - BPDU Guard error-disables ports receiving unexpected BPDUs (rogue switches plugged into access ports). Root Guard rejects superior BPDUs on uplinks. Setting priority hardens the legitimate root. B causes loops. C is L3, not STP. D is for endpoint auth.

**Answer:** A

**Key takeaway:** STP security: BPDU Guard (access ports), Root Guard (uplinks), Loop Guard (point-to-point trunks), set explicit root bridge priority.
