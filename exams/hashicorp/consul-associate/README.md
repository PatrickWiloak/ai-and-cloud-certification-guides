# HashiCorp Consul Associate (003) Certification

## Exam Overview

The HashiCorp Consul Associate (003) certification validates your knowledge of Consul's core concepts, service networking capabilities, and operational skills. This certification is designed for network engineers, DevOps professionals, and platform engineers who use Consul for service discovery, service mesh, and configuration management in distributed environments.

**Exam Code:** Consul Associate (003)
**Exam Duration:** 60 minutes
**Number of Questions:** 57 questions
**Exam Format:** Multiple choice and fill-in-the-blank
**Passing Score:** 70%
**Cost:** $70.50 USD
**Proctoring:** PSI online proctoring
**Validity:** 2 years
**Prerequisites:** None (recommended 6+ months hands-on Consul experience)

## Exam Domains

### Domain 1: Consul Architecture (18%)
- Describe the Consul architecture
- Explain the role of agents (server and client)
- Understand datacenter design and federation
- Describe the gossip protocol and consensus mechanism
- Explain the role of the leader and followers

### Domain 2: Deploy a Single Datacenter (16%)
- Configure and start a Consul agent
- Understand agent configuration options
- Join agents to a cluster
- Configure and manage ACLs
- Use the Consul CLI for cluster management

### Domain 3: Register Services and Use Service Discovery (17%)
- Register a service with Consul
- Perform service discovery using DNS and HTTP API
- Configure and use health checks
- Understand service tags and metadata
- Use prepared queries for advanced discovery

### Domain 4: Access the Consul Key/Value Store (10%)
- Read, write, and delete KV data
- Use the KV store for application configuration
- Understand watches for KV changes
- Use transactions for atomic KV operations
- Configure consul-template for dynamic configuration

### Domain 5: Back Up and Restore Consul (5%)
- Create and restore snapshots
- Understand data persistence and recovery
- Configure snapshot agents (Enterprise)

### Domain 6: Use Consul Service Mesh (17%)
- Describe the Consul Connect service mesh
- Configure sidecar proxies
- Define and enforce intentions
- Understand mTLS and certificate management
- Configure ingress and terminating gateways

### Domain 7: Secure Agent Communication (12%)
- Configure gossip encryption
- Configure TLS for RPC communication
- Manage ACL tokens and policies
- Understand the ACL system architecture

### Domain 8: Use Consul on Kubernetes (5%)
- Install Consul on Kubernetes via Helm
- Configure service mesh on Kubernetes
- Understand the Consul-K8s integration

## Key Study Areas

### Architecture and Networking
- **Server Agents:** Maintain cluster state, participate in consensus
- **Client Agents:** Forward requests to servers, run health checks
- **Gossip Protocol:** Serf-based membership and failure detection
- **Consensus:** Raft protocol for leader election and log replication
- **Datacenters:** WAN federation for multi-datacenter deployments

### Service Discovery
- **Service Registration:** Agent-based or API-based registration
- **DNS Interface:** service.consul DNS queries for discovery
- **HTTP API:** /v1/catalog and /v1/health endpoints
- **Health Checks:** Script, HTTP, TCP, TTL, gRPC check types

### Service Mesh (Connect)
- **Sidecar Proxies:** Envoy-based data plane
- **Intentions:** Service-to-service authorization rules
- **mTLS:** Automatic mutual TLS between services
- **Gateways:** Ingress, terminating, and mesh gateways

### Security
- **ACLs:** Token-based access control system
- **Gossip Encryption:** Symmetric key for gossip protocol
- **TLS:** Certificate-based encryption for RPC
- **Intentions:** Layer 4 and Layer 7 authorization

## Study Tips

1. **Architecture First:** Understand server/client, gossip, and consensus thoroughly
2. **Hands-On Practice:** Set up a multi-node Consul cluster
3. **Service Discovery:** Practice DNS and HTTP API discovery
4. **Connect/Mesh:** Understand sidecar proxies and intentions
5. **Security:** Master ACLs, gossip encryption, and TLS
6. **CLI Commands:** Know exact command syntax for common operations
7. **KV Store:** Practice read, write, watch operations

## Comprehensive Study Resources

### Quick Links
- **[Consul Associate Exam Page](https://www.hashicorp.com/certifications/consul-associate)** - Registration
- **[Consul Documentation](https://developer.hashicorp.com/consul/docs)** - Complete documentation
- **[Consul Tutorials](https://developer.hashicorp.com/consul/tutorials)** - Official tutorials
- **[Consul API Documentation](https://developer.hashicorp.com/consul/api-docs)** - REST API reference

### Recommended Courses
- HashiCorp Learn Consul tutorials (free)
- Bryan Krausen - Consul Associate on Udemy
- KodeKloud - Consul for Beginners
- A Cloud Guru - HashiCorp Consul

## Exam Registration

Register through:
- **PSI Online:** Online proctored exam via PSI
- **HashiCorp Certification Portal:** [hashicorp.com/certifications](https://www.hashicorp.com/certifications)

## Career Benefits

### Job Opportunities
- Network Engineer
- Platform Engineer
- DevOps Engineer
- Site Reliability Engineer
- Cloud Infrastructure Engineer

### Professional Development
- Foundation for advanced service mesh expertise
- Complements Terraform and Vault certifications
- Demonstrates service networking knowledge
- Industry recognition for distributed systems skills
