# Consul Associate (003) Study Strategy

## Study Approach

### Phase 1: Foundation (2 weeks)
1. **Consul Architecture**
   - Understand server vs client agents and their roles
   - Study the gossip protocol (LAN and WAN)
   - Learn Raft consensus and leader election
   - Master datacenter design and federation concepts

2. **Service Discovery**
   - Learn service registration methods (config file, API, CLI)
   - Study DNS discovery format and queries
   - Understand health check types and behavior
   - Practice HTTP API discovery endpoints

### Phase 2: Core Skills (2-3 weeks)
1. **Service Mesh and Security**
   - Study Connect architecture and sidecar proxies
   - Learn intentions for service authorization
   - Understand mTLS and certificate management
   - Configure gossip encryption and TLS
   - Master ACL system: bootstrap, policies, tokens

2. **Operations**
   - Practice KV store operations
   - Learn consul-template for dynamic configuration
   - Study snapshot backup and restore procedures
   - Practice Consul CLI commands

### Phase 3: Exam Preparation (1-2 weeks)
1. **Practice Exams**
   - Take HashiCorp official practice exam
   - Target 80%+ before scheduling the real exam
   - Review every incorrect answer thoroughly

2. **Final Review**
   - Review architecture diagrams and gossip protocol
   - Study DNS discovery format and health check types
   - Review ACL system and intention rules
   - Quick review of Kubernetes integration

## Comprehensive Study Resources

### Official Resources
- **[Consul Associate Study Guide](https://developer.hashicorp.com/consul/tutorials/certification/associate-review)** - Official guide
- **[Consul Documentation](https://developer.hashicorp.com/consul/docs)** - Complete reference
- **[Consul Tutorials](https://developer.hashicorp.com/consul/tutorials)** - Hands-on learning
- **[Consul API Docs](https://developer.hashicorp.com/consul/api-docs)** - REST API reference

### Recommended Courses
- Bryan Krausen - Consul Associate on Udemy
- HashiCorp Learn - Free official tutorials
- KodeKloud - Consul for Beginners

## Exam Tactics

### Question Strategy
1. **Architecture questions:** Know server vs client, gossip vs Raft
2. **Discovery questions:** DNS format is heavily tested
3. **Mesh questions:** Understand intentions vs ACLs
4. **Security questions:** Gossip encryption, TLS, ACL bootstrap order
5. **CLI questions:** Know exact command syntax

### Time Management
- ~1 minute per question (57 questions in 60 minutes)
- Flag and move on for complex scenario questions
- Answer direct knowledge questions quickly

## Common Pitfalls

### Exam Mistakes
- Mixing up LAN gossip (all agents, UDP) with WAN gossip (servers only)
- Forgetting DNS query format: tag.service.service.dc.consul
- Thinking client agents participate in consensus
- Confusing intentions (mesh authorization) with ACLs (API authorization)
- Not knowing quorum requirements for different cluster sizes

## Progress Tracking

### Weekly Milestones
- **Week 1-2:** Can explain architecture, gossip, Raft, datacenter design
- **Week 3:** Master service discovery, health checks, KV store
- **Week 4:** Understand Connect mesh, intentions, gateways
- **Week 5:** Security: ACLs, gossip encryption, TLS configuration
- **Week 6:** Score 80%+ on practice exam, pass certification
