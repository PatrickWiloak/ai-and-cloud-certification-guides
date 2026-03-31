# Consul Associate (003) Study Plan

## 6-Week Intensive Study Schedule

### Phase 1: Foundation Building (Weeks 1-2)

#### Week 1: Consul Architecture

#### Day 1-2: Agent Architecture
- [ ] Study server and client agent roles
- [ ] Understand Raft consensus protocol and quorum
- [ ] Learn leader election and log replication
- [ ] Study recommended server counts (3 or 5)
- [ ] **Lab:** Start a single Consul agent in dev mode

#### Day 3-4: Gossip Protocol
- [ ] Study Serf-based gossip protocol
- [ ] Understand LAN gossip (all agents) vs WAN gossip (servers only)
- [ ] Learn membership detection and failure handling
- [ ] Study gossip encryption with symmetric keys
- [ ] **Lab:** Start a multi-node cluster and observe gossip

#### Day 5-7: Datacenter Design
- [ ] Study single datacenter deployment patterns
- [ ] Learn multi-datacenter federation via WAN gossip
- [ ] Understand cross-datacenter service discovery
- [ ] Practice cluster join operations
- [ ] **Lab:** Join agents to form a cluster, practice `consul members`

### Week 2: Service Discovery

#### Day 1-2: Service Registration
- [ ] Study registration via config file, API, and CLI
- [ ] Learn service definition format (JSON/HCL)
- [ ] Understand service tags and metadata
- [ ] Practice registering and deregistering services
- [ ] **Lab:** Register services via config files and CLI

#### Day 3-4: DNS and HTTP Discovery
- [ ] Master DNS query format: service.service.consul
- [ ] Learn tag-based DNS queries
- [ ] Study cross-datacenter DNS queries
- [ ] Practice HTTP API discovery endpoints
- [ ] **Lab:** Query services via DNS and HTTP API

#### Day 5-7: Health Checks
- [ ] Study all health check types (HTTP, TCP, script, TTL, gRPC)
- [ ] Understand check intervals and timeouts
- [ ] Learn how health status affects discovery results
- [ ] Practice configuring different check types
- [ ] **Lab:** Configure health checks and observe failure behavior

### Phase 2: Core Skills (Weeks 3-4)

#### Week 3: KV Store and Service Mesh

#### Day 1-2: Key/Value Store
- [ ] Practice KV read, write, delete operations
- [ ] Learn recursive operations and key prefixes
- [ ] Study watches for change detection
- [ ] Understand consul-template for dynamic config
- [ ] **Lab:** Use KV store for application configuration

#### Day 3-4: Service Mesh Fundamentals
- [ ] Study Connect architecture and sidecar proxies
- [ ] Understand Envoy proxy role in the mesh
- [ ] Learn mTLS and automatic certificate management
- [ ] Study the built-in CA and certificate rotation
- [ ] **Lab:** Enable Connect and deploy sidecar proxies

#### Day 5-7: Intentions and Gateways
- [ ] Study L4 and L7 intentions
- [ ] Practice creating allow and deny intentions
- [ ] Learn ingress, terminating, and mesh gateways
- [ ] Understand gateway use cases and configuration
- [ ] **Lab:** Create intentions and test service communication

### Week 4: Security and Operations

#### Day 1-2: ACL System
- [ ] Study ACL architecture: policies, tokens, roles
- [ ] Learn ACL bootstrap process
- [ ] Practice creating policies and tokens
- [ ] Understand default deny behavior with ACLs
- [ ] **Lab:** Bootstrap ACLs, create policies and tokens

#### Day 3-4: Encryption
- [ ] Study gossip encryption configuration
- [ ] Learn TLS setup for RPC communication
- [ ] Understand auto-encrypt for client certificates
- [ ] Practice certificate management
- [ ] **Lab:** Configure gossip encryption and TLS

#### Day 5-7: Backup and Kubernetes
- [ ] Study snapshot save, restore, and inspect commands
- [ ] Learn Consul-K8s integration via Helm chart
- [ ] Understand service mesh on Kubernetes
- [ ] Review connect-inject sidecar auto-injection
- [ ] **Lab:** Create and restore snapshots

### Phase 3: Exam Preparation (Weeks 5-6)

#### Week 5: Review and Practice

#### Day 1-3: Domain Review
- [ ] Review architecture: agents, gossip, Raft
- [ ] Review service discovery: DNS format, health checks
- [ ] Review Connect: intentions, proxies, mTLS
- [ ] Review security: ACLs, encryption
- [ ] **Practice:** Quiz yourself on each domain

#### Day 4-7: Practice Exam Round 1
- [ ] Take HashiCorp official practice exam
- [ ] Review all incorrect answers
- [ ] Identify knowledge gaps by domain
- [ ] Re-study weak areas
- [ ] **Review:** Create summary notes for weak areas

### Week 6: Final Review and Exam

#### Day 1-3: Practice Exam Round 2
- [ ] Take second practice exam
- [ ] Target 80%+ score
- [ ] Review common exam traps
- [ ] Focus on CLI command syntax

#### Day 4: Exam Day Preparation
- [ ] Light review of key concepts
- [ ] Review DNS query format
- [ ] Review ACL bootstrap process
- [ ] Verify system requirements
- [ ] **Prepare:** Set up workspace, check ID

#### Day 5-7: Exam and Post-Exam
- [ ] Take the exam
- [ ] Celebrate your achievement

## Daily Study Routine

### Recommended Schedule (1.5-2 hours per day)
1. **Review (15 min):** Review previous day's notes
2. **Study (45 min):** New topic with documentation
3. **Practice (30 min):** Hands-on lab work
4. **Quiz (15 min):** Self-assessment questions

## Key Milestones

- [ ] **Week 1:** Can explain architecture, gossip, and Raft
- [ ] **Week 2:** Can register services and query via DNS/HTTP
- [ ] **Week 3:** Can use KV store and configure service mesh
- [ ] **Week 4:** Can configure ACLs, encryption, and backups
- [ ] **Week 5:** Score 70%+ on first practice exam
- [ ] **Week 6:** Score 80%+ on practice exam, pass certification
