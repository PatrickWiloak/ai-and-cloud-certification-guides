# Consul Associate - High-Yield Scenarios and Patterns

## Architecture Scenarios

### Cluster Sizing for High Availability
**Scenario:** A company is deploying Consul in production and needs to ensure the cluster can tolerate server failures. They want the minimum number of servers that can survive losing one server during a maintenance window where another server is already down.

**Solution Pattern:**
- **5 server agents:** Tolerates 2 server failures (quorum = 3)
- **Quorum formula:** (N/2) + 1 servers must be available for writes
- **Client agents:** One per application node for health checks and forwarding
- **Deployment:** Spread servers across availability zones

**Common Distractors:**
- 3 servers (wrong - tolerates only 1 failure, not 2)
- 4 servers (wrong - even numbers create split-brain risk, 4 tolerates only 1 failure)
- 7 servers (wrong - more than needed, adds overhead, tolerates 3)
- Using client agents for consensus (wrong - only servers participate in Raft)

### Cross-Datacenter Service Discovery
**Scenario:** An organization has services deployed in US-East and EU-West datacenters. The US application needs to discover and communicate with a payment service running in the EU datacenter.

**Solution Pattern:**
- **WAN Federation:** Servers in both datacenters joined via WAN gossip
- **DNS Query:** `payment.service.eu-west.consul` for cross-DC discovery
- **Forwarding:** US server forwards query to EU server via WAN
- **Health Checks:** Only healthy EU instances returned

**Common Distractors:**
- Client agents joining WAN gossip (wrong - only servers participate in WAN)
- Direct DNS query to EU Consul server (wrong - use local agent, it forwards)
- Using KV store for service endpoints (wrong - service discovery is built-in)
- Creating a VPN between all agents (wrong - WAN gossip handles cross-DC)

## Service Discovery Scenarios

### Deploying a New Microservice
**Scenario:** A team is deploying a new REST API service. They need other services to discover it automatically, and unhealthy instances should be excluded from discovery results.

**Solution Pattern:**
```json
{
  "service": {
    "name": "order-api",
    "port": 8080,
    "tags": ["v2", "production"],
    "check": {
      "http": "http://localhost:8080/health",
      "interval": "10s",
      "timeout": "3s",
      "deregister_critical_service_after": "90s"
    }
  }
}
```

- **Registration:** Service definition file or API registration
- **Discovery:** `order-api.service.consul` DNS query
- **Health:** HTTP health check every 10 seconds
- **Auto-Cleanup:** Deregister after 90 seconds of critical status

**Common Distractors:**
- Using TTL check without updating (wrong - TTL requires service to actively report)
- No health check configured (wrong - unhealthy instances would still be returned)
- Registering via KV store (wrong - use service registration, not KV)
- Using script check in a container (wrong - consider Docker check type instead)

### Blue-Green Deployment Discovery
**Scenario:** A team wants to perform a blue-green deployment. The current "blue" version should continue serving traffic while the new "green" version is tested. Once verified, traffic should shift to green.

**Solution Pattern:**
- **Tags:** Register blue instances with tag "blue", green with "green"
- **DNS Query:** `blue.web.service.consul` for blue, `green.web.service.consul` for green
- **Testing:** Test green via tag-based query
- **Cutover:** Update prepared query or DNS alias to point to green

**Common Distractors:**
- Deregistering blue before registering green (wrong - causes downtime)
- Using KV store for traffic routing (wrong - use tags and prepared queries)
- Changing service names for versions (wrong - complicates discovery for consumers)
- Manual DNS updates (wrong - use Consul's tag-based discovery)

## Service Mesh Scenarios

### Securing Service-to-Service Communication
**Scenario:** A company's security team requires all internal service communication to be encrypted. Services should only be able to communicate with explicitly authorized services.

**Solution Pattern:**
- **Connect:** Enable Consul Connect for automatic mTLS
- **Sidecar Proxies:** Deploy Envoy sidecar alongside each service
- **Intentions:** Define explicit allow rules for authorized communication
- **Default Deny:** Configure intentions to deny all by default
- **mTLS:** Automatic certificate management and rotation

```bash
# Allow web to communicate with api
consul intention create web api

# Allow api to communicate with database
consul intention create api database

# Deny all other communication (when ACLs enabled, default is deny)
consul intention create -deny '*' '*'
```

**Common Distractors:**
- Using ACLs instead of intentions (wrong - ACLs control API access, intentions control service communication)
- Manual TLS certificate management (wrong - Connect automates this)
- Network-level firewall rules only (wrong - does not provide identity-based auth)
- Deploying a dedicated API gateway for all service communication (wrong - sidecar model is more scalable)

### External Service Integration
**Scenario:** A service in the Consul mesh needs to communicate with an external database that is not part of the mesh. The external database runs on a fixed IP address with TLS.

**Solution Pattern:**
- **Terminating Gateway:** Registers the external service in Consul
- **Configuration:** Gateway proxies traffic from mesh to external service
- **Intentions:** Mesh services use intentions to authorize access to external service
- **TLS:** Gateway handles TLS connection to external database

**Common Distractors:**
- Ingress gateway (wrong - ingress handles inbound external traffic, not outbound)
- Direct connection bypassing the mesh (wrong - loses observability and authorization)
- Mesh gateway (wrong - mesh gateways are for cross-datacenter mesh traffic)
- Running a sidecar on the external database (wrong - external service is not in the mesh)

## Security Scenarios

### ACL Bootstrap and Policy Design
**Scenario:** A team is deploying Consul in production with security enabled. They need to set up ACLs for three teams: platform (full access), developers (service registration and KV read), and monitoring (read-only).

**Solution Pattern:**
```bash
# Bootstrap ACLs (creates initial management token)
consul acl bootstrap

# Platform team policy
consul acl policy create -name="platform" -rules='
  node_prefix "" { policy = "write" }
  service_prefix "" { policy = "write" }
  key_prefix "" { policy = "write" }
  agent_prefix "" { policy = "write" }
'

# Developer policy
consul acl policy create -name="developer" -rules='
  service_prefix "" { policy = "write" }
  key_prefix "" { policy = "read" }
  node_prefix "" { policy = "read" }
'

# Monitoring policy
consul acl policy create -name="monitoring" -rules='
  service_prefix "" { policy = "read" }
  key_prefix "" { policy = "read" }
  node_prefix "" { policy = "read" }
'

# Create tokens
consul acl token create -policy-name="platform" -description="Platform team"
consul acl token create -policy-name="developer" -description="Developer team"
consul acl token create -policy-name="monitoring" -description="Monitoring"
```

**Common Distractors:**
- Sharing the bootstrap token with all teams (wrong - bootstrap token is management-level)
- Not enabling ACLs (wrong - production requires access control)
- Using intentions instead of ACLs for API access (wrong - intentions are for mesh, ACLs for API)
- Creating a single shared token for all teams (wrong - no accountability or least privilege)

### Encrypting All Communication
**Scenario:** A security audit requires that all Consul communication is encrypted - both gossip traffic between agents and RPC traffic to servers.

**Solution Pattern:**
1. **Gossip Encryption:** Generate key with `consul keygen`, set in agent config
2. **TLS for RPC:** Configure TLS certificates for server and client agents
3. **Verify:** Enable `verify_incoming` and `verify_outgoing`
4. **Auto-Encrypt:** Enable auto_encrypt for client certificate distribution

```hcl
# Server agent configuration
encrypt = "pUqJrVyVRj5jsiYEkM/tFQYfWyJIv4s3XkvDwy7Cu5s="

tls {
  defaults {
    ca_file   = "/etc/consul.d/consul-agent-ca.pem"
    cert_file = "/etc/consul.d/dc1-server-consul.pem"
    key_file  = "/etc/consul.d/dc1-server-consul-key.pem"
    verify_incoming = true
    verify_outgoing = true
  }
  internal_rpc {
    verify_server_hostname = true
  }
}

auto_encrypt {
  allow_tls = true
}
```

**Common Distractors:**
- Only enabling gossip encryption (wrong - RPC also needs TLS)
- Only enabling TLS (wrong - gossip uses separate symmetric encryption)
- Using the same key for gossip and TLS (wrong - gossip uses symmetric key, TLS uses certificates)
- Disabling verify_incoming for convenience (wrong - compromises security)

## KV Store Scenarios

### Dynamic Application Configuration
**Scenario:** An application needs to read database connection configuration from Consul KV at startup and automatically reconfigure when the configuration changes.

**Solution Pattern:**
- **KV Store:** Store configuration at `config/myapp/db_host`, `config/myapp/db_port`
- **consul-template:** Render configuration file from KV values
- **Watch:** consul-template watches for changes and re-renders
- **Reload:** Application reloaded when configuration changes

```bash
# Store configuration
consul kv put config/myapp/db_host "db.example.com"
consul kv put config/myapp/db_port "5432"

# consul-template template file
# {{ key "config/myapp/db_host" }}:{{ key "config/myapp/db_port" }}
```

**Common Distractors:**
- Polling the KV store manually (wrong - watches and consul-template are more efficient)
- Using service discovery for configuration (wrong - KV store is designed for config)
- Storing large files in KV (wrong - KV is for small config values, max 512KB per entry)
- Hard-coding configuration in service definition (wrong - not dynamic)

## Key Decision Factors

### Architecture Selection Guide
1. **Service identity verification:** Connect with mTLS (not network-based trust)
2. **Service authorization:** Intentions (not ACLs - ACLs are for API access)
3. **API access control:** ACL policies and tokens
4. **Application configuration:** KV store with watches or consul-template
5. **External traffic into mesh:** Ingress gateway
6. **Mesh traffic to external services:** Terminating gateway
7. **Cross-datacenter mesh traffic:** Mesh gateway
8. **Failure tolerance of 2:** 5 server agents
9. **Change notifications:** Watches (blocking queries)
10. **Disaster recovery:** Snapshot save/restore
