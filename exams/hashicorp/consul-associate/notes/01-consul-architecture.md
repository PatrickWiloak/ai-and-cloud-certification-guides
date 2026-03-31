# Consul Architecture

**[📖 Architecture Overview](https://developer.hashicorp.com/consul/docs/architecture)** - Consul architecture documentation

## Overview

This document covers Consul's architecture including server and client agents, the gossip protocol, Raft consensus, datacenter design, and cluster operations. Architecture represents 18% of the exam and provides the foundation for understanding all other Consul features.

## Agent Types

### Server Agents
- Participate in Raft consensus protocol
- Maintain the cluster state (catalog, KV, ACLs)
- Elect a leader to handle writes
- Replicate state to follower servers
- Participate in both LAN and WAN gossip
- Recommended: 3 or 5 servers per datacenter (always odd number)

**[📖 Server Agent](https://developer.hashicorp.com/consul/docs/agent#server-agents)** - Server configuration

### Client Agents
- Lightweight processes running on every node
- Forward requests to server agents
- Execute local health checks
- Participate in LAN gossip only (not WAN)
- Do NOT participate in Raft consensus
- One client per application node

**[📖 Client Agent](https://developer.hashicorp.com/consul/docs/agent#client-agents)** - Client configuration

### Agent Configuration
```hcl
# Server agent configuration
datacenter = "dc1"
data_dir   = "/opt/consul/data"
server     = true
bootstrap_expect = 3

bind_addr   = "10.0.1.10"
client_addr = "0.0.0.0"

ui_config {
  enabled = true
}

connect {
  enabled = true
}
```

```hcl
# Client agent configuration
datacenter = "dc1"
data_dir   = "/opt/consul/data"
server     = false

bind_addr = "10.0.1.20"
retry_join = ["10.0.1.10", "10.0.1.11", "10.0.1.12"]
```

### Starting and Joining
```bash
# Start server agent
consul agent -config-dir=/etc/consul.d/

# Start in dev mode (single node, no persistence)
consul agent -dev

# Join an existing cluster
consul join 10.0.1.10

# Auto-join on startup (retry_join in config)
# retry_join = ["10.0.1.10", "10.0.1.11"]

# Cloud auto-join (AWS example)
# retry_join = ["provider=aws tag_key=consul tag_value=server"]

# View cluster members
consul members
consul members -wan  # WAN members (servers only)

# Leave cluster gracefully
consul leave
```

**[📖 Agent Configuration](https://developer.hashicorp.com/consul/docs/agent/config)** - Config reference

## Gossip Protocol (Serf)

### LAN Gossip
- All agents in a datacenter participate
- UDP-based protocol for fast propagation
- Used for membership management
- Detects node failures (unreachable agents)
- Propagates events and configuration changes
- Default port: 8301 (TCP and UDP)

### WAN Gossip
- Only server agents participate
- Connects servers across datacenters
- Enables cross-datacenter service discovery
- Lower protocol overhead than LAN gossip
- Default port: 8302 (TCP and UDP)

**[📖 Gossip Protocol](https://developer.hashicorp.com/consul/docs/architecture/gossip)** - Gossip details

### Gossip Mechanics
- Based on SWIM (Scalable Weakly-consistent Infection-style Membership)
- Random node selection for protocol messages
- Three message types: ping, indirect-ping, suspect
- Failed nodes detected and removed from membership
- Configurable intervals for gossip frequency

### Failure Detection
1. Agent A sends periodic ping to Agent B
2. If Agent B does not respond, Agent A asks others to probe Agent B (indirect ping)
3. If indirect pings also fail, Agent B is marked as "suspect"
4. After configurable timeout, Agent B is declared "failed"
5. Failed agents are removed from the catalog

## Consensus Protocol (Raft)

### Raft Basics
- Used for leader election and state replication
- Only server agents participate in Raft
- Leader handles all write operations
- Followers replicate the leader's log
- Writes require acknowledgment from quorum (majority)

**[📖 Consensus Protocol](https://developer.hashicorp.com/consul/docs/architecture/consensus)** - Raft details

### Leader Election
1. All servers start as followers
2. If no heartbeat from leader within timeout, follower becomes candidate
3. Candidate requests votes from other servers
4. Server that receives majority of votes becomes leader
5. Leader sends heartbeats to maintain leadership

### Quorum Requirements
| Server Count | Quorum Required | Failure Tolerance |
|-------------|----------------|-------------------|
| 1 | 1 | 0 (no HA) |
| 3 | 2 | 1 |
| 5 | 3 | 2 |
| 7 | 4 | 3 |

- Always use odd numbers of servers
- Even numbers provide no additional fault tolerance
- 3 servers: minimum for production HA
- 5 servers: recommended for production with maintenance tolerance
- 7+ servers: diminishing returns, increased write latency

### Why Odd Numbers?
- 3 servers: quorum = 2, tolerates 1 failure
- 4 servers: quorum = 3, still tolerates only 1 failure
- 4 servers adds overhead without improving fault tolerance
- Always use 3 or 5 servers

## Datacenter Design

### Single Datacenter
```
┌──────────────── Datacenter: dc1 ──────────────────┐
│                                                     │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐           │
│  │Server 1 │  │Server 2 │  │Server 3 │  Raft     │
│  │(Leader) │  │(Follow) │  │(Follow) │  Cluster   │
│  └────┬────┘  └────┬────┘  └────┬────┘           │
│       │             │             │                 │
│  ┌────┴─────────────┴─────────────┴────┐           │
│  │         LAN Gossip Pool              │           │
│  └────┬─────────────┬─────────────┬────┘           │
│       │             │             │                 │
│  ┌────┴────┐  ┌────┴────┐  ┌────┴────┐           │
│  │Client A │  │Client B │  │Client C │           │
│  │+ App 1  │  │+ App 2  │  │+ App 3  │           │
│  └─────────┘  └─────────┘  └─────────┘           │
└─────────────────────────────────────────────────────┘
```

### Multi-Datacenter
```
DC1 (Primary)                    DC2 (Secondary)
┌─────────────┐                  ┌─────────────┐
│ Server 1 (L)│◄──── WAN ──────►│ Server 1 (L)│
│ Server 2    │    Gossip       │ Server 2    │
│ Server 3    │                  │ Server 3    │
│ Client A    │                  │ Client X    │
│ Client B    │                  │ Client Y    │
└─────────────┘                  └─────────────┘
```

- Each datacenter has independent Raft cluster
- WAN gossip connects servers between datacenters
- Cross-datacenter queries forwarded through WAN
- Each datacenter can operate independently if WAN link fails
- Primary datacenter handles global ACL replication (when ACLs enabled)

**[📖 Multi-Datacenter](https://developer.hashicorp.com/consul/tutorials/networking/federation-gossip-wan)** - Federation guide

## Ports Reference

| Port | Protocol | Purpose |
|------|----------|---------|
| 8300 | TCP | Server RPC (server-to-server) |
| 8301 | TCP/UDP | LAN Gossip (all agents) |
| 8302 | TCP/UDP | WAN Gossip (servers only) |
| 8500 | TCP | HTTP API |
| 8501 | TCP | HTTPS API (when TLS enabled) |
| 8502 | TCP | gRPC API |
| 8600 | TCP/UDP | DNS Interface |

**[📖 Required Ports](https://developer.hashicorp.com/consul/docs/install/ports)** - Port reference

## Cluster Operations

### Monitoring
```bash
# Cluster member list
consul members

# Detailed member info
consul members -detailed

# Raft peer list (servers only)
consul operator raft list-peers

# Leader information
consul info | grep leader

# Check agent health
consul info
```

### Maintenance
```bash
# Graceful leave (deregisters services and checks)
consul leave

# Force remove failed node
consul force-leave <node_name>

# Force remove with prune (removes from catalog)
consul force-leave -prune <node_name>

# Reload configuration without restart
consul reload
```

### Dev Mode
```bash
# Start dev agent (testing only)
consul agent -dev

# Properties:
# - Single node (server + client)
# - In-memory storage (no persistence)
# - Connect enabled
# - No ACLs
# - Listens on 127.0.0.1
# - NEVER use in production
```
