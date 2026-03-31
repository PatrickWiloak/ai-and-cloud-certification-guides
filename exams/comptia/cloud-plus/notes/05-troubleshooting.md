# Domain 5: Troubleshooting (22%)

## Overview
This domain covers systematic approaches to diagnosing and resolving issues in cloud environments. Topics include connectivity problems, performance degradation, security incidents, and automation failures. Troubleshooting questions often combine concepts from other domains, making this a comprehensive test of overall cloud knowledge.

## Troubleshooting Methodology

**[📖 CompTIA Cloud+ Exam Objectives](https://www.comptia.org/certifications/cloud#examdetails)** - Official exam objectives for troubleshooting domain

### Systematic Approach

1. **Identify the problem**
   - Gather information from users, alerts, and logs
   - Define symptoms and scope of the issue
   - Determine when the issue started
   - Identify what changed recently

2. **Establish a theory of probable cause**
   - Consider the most common causes first
   - Review recent changes and deployments
   - Check for known issues and service health dashboards
   - Consider both infrastructure and application causes

3. **Test the theory**
   - Validate or eliminate each probable cause
   - Use diagnostic tools and log analysis
   - Test in isolation where possible
   - If theory is not confirmed, go back to step 2

4. **Establish a plan of action**
   - Define resolution steps
   - Assess risk and impact of the fix
   - Prepare a rollback plan
   - Get approval if changes affect production

5. **Implement the solution**
   - Execute the plan during an appropriate window
   - Follow change management procedures
   - Monitor during and after implementation

6. **Verify full system functionality**
   - Confirm the issue is resolved
   - Verify no new issues were introduced
   - Check related systems for side effects
   - Get user confirmation if applicable

7. **Document findings**
   - Record root cause and resolution
   - Update runbooks and knowledge base
   - Share findings with the team
   - Identify preventive measures

## Connectivity Issues

### DNS Resolution Problems

**Symptoms:**
- Applications cannot connect to services by hostname
- Intermittent connectivity issues
- Connection timeouts to specific services
- "Name not resolved" errors

**Common Causes:**
- Incorrect DNS records (A, CNAME, MX, TXT)
- DNS propagation delays after changes (TTL-dependent)
- DNS server configuration issues
- Split-horizon DNS misconfiguration
- Private hosted zone not associated with VPC

**Diagnostic Steps:**
```bash
# Check DNS resolution
nslookup hostname
dig hostname
dig +trace hostname

# Check specific DNS server
nslookup hostname dns-server-ip
dig @dns-server-ip hostname

# Check DNS configuration
cat /etc/resolv.conf

# Verify DNS record types
dig hostname A         # IPv4 address
dig hostname AAAA      # IPv6 address
dig hostname CNAME     # Alias
dig hostname MX        # Mail exchange
```

**Resolution:**
- Verify DNS records are correct and pointing to right targets
- Wait for TTL expiration if records were recently changed
- Check DNS server health and configuration
- Verify VPC DNS settings (enableDnsSupport, enableDnsHostnames)
- Check DNS firewall rules (port 53 UDP/TCP)

### Firewall and Security Group Issues

**Symptoms:**
- Connection refused or timeout errors
- Partial connectivity (some ports work, others do not)
- One-directional traffic issues
- Intermittent connection drops

**Common Causes:**
- Missing or incorrect security group rules
- Network ACL blocking traffic
- Firewall rule changes
- Stateless vs stateful rule confusion
- Port range restrictions

**Diagnostic Steps:**
- Review security group inbound/outbound rules
- Review Network ACL rules (check rule order - lower number = higher priority)
- Check cloud firewall logs for denied traffic
- Verify the source IP/CIDR is allowed
- Check both source and destination security groups

**Security Group vs NACL Troubleshooting:**
| Issue | Security Group | NACL |
|-------|---------------|------|
| **Scope** | Instance level | Subnet level |
| **State** | Stateful (return traffic auto-allowed) | Stateless (must allow both directions) |
| **Rules** | Allow only | Allow and deny |
| **Processing** | All rules evaluated | Rules processed in order |
| **Common fix** | Add missing allow rule | Add both inbound and outbound rules |

### Routing Issues

**Symptoms:**
- Cannot reach resources in different subnets or VPCs
- VPN tunnel up but traffic not flowing
- Internet access not working from private subnets
- Cross-region connectivity failures

**Common Causes:**
- Missing or incorrect route table entries
- NAT Gateway/Instance not configured for private subnet internet access
- VPC peering routes not added
- Transit Gateway route table misconfiguration
- Overlapping CIDR blocks between networks

**Diagnostic Steps:**
```bash
# Check routing table
ip route show
route -n
traceroute destination

# Check connectivity
ping destination-ip
telnet destination-ip port
curl -v https://destination
```

**Resolution:**
- Verify route table associations (correct subnet to correct route table)
- Add missing routes for VPC peering, VPN, or Transit Gateway
- Ensure NAT Gateway is in public subnet with internet gateway route
- Check for CIDR overlap conflicts
- Verify VPC peering acceptance and route configuration on both sides

### VPN Tunnel Issues

**Symptoms:**
- VPN tunnel shows down status
- Intermittent connectivity through VPN
- Slow performance over VPN
- Specific traffic types not passing through VPN

**Common Causes:**
- Pre-shared key mismatch
- IKE version or parameter mismatch (encryption, hashing, DH group)
- NAT traversal issues
- Firewall blocking IPsec ports (UDP 500, UDP 4500, IP protocol 50)
- Dead Peer Detection timeout

**Diagnostic Steps:**
- Check VPN tunnel status in cloud console
- Verify Phase 1 and Phase 2 parameters match on both sides
- Check firewall rules for IPsec traffic
- Review VPN logs for negotiation errors
- Test with simplified configuration to isolate issue

### Load Balancer Issues

**Symptoms:**
- Uneven traffic distribution
- Health check failures
- 502/503/504 gateway errors
- SSL/TLS certificate errors

**Common Causes:**
- Health check misconfiguration (wrong port, path, or threshold)
- Backend instances not healthy
- Security group blocking health check traffic
- SSL certificate expired or misconfigured
- Target group configuration issues

**Diagnostic Steps:**
- Check health check configuration and status
- Verify backend instances are running and healthy
- Check security groups allow health check traffic
- Review access logs for error patterns
- Verify SSL certificate validity and chain

## Performance Issues

### CPU Performance

**Symptoms:**
- High CPU utilization (> 80% sustained)
- Slow application response times
- Process queuing and scheduling delays

**Common Causes:**
- Insufficient compute capacity
- Runaway processes or infinite loops
- CPU-intensive operations without optimization
- Incorrect instance type for workload
- Noisy neighbor (shared tenancy)

**Diagnostic Tools:**
```bash
# CPU utilization
top
htop
vmstat 1
mpstat -P ALL 1

# Process CPU usage
ps aux --sort=-%cpu | head -20

# CPU steal time (virtualization overhead)
vmstat 1  # check 'st' column
```

**Resolution:**
- Scale up (larger instance) or scale out (more instances)
- Identify and optimize CPU-intensive processes
- Use CPU-optimized instance types for compute workloads
- Consider dedicated instances to avoid noisy neighbor
- Implement caching to reduce CPU-bound operations

### Memory Performance

**Symptoms:**
- High memory utilization (> 90%)
- Out of memory (OOM) errors
- Excessive swapping/paging
- Application crashes

**Common Causes:**
- Memory leaks in application code
- Insufficient memory allocation
- Too many concurrent processes/connections
- Large dataset processing without streaming
- JVM heap size misconfiguration

**Diagnostic Tools:**
```bash
# Memory usage
free -h
vmstat 1
cat /proc/meminfo

# Process memory usage
ps aux --sort=-%mem | head -20

# Check for OOM killer
dmesg | grep -i "out of memory"
journalctl -k | grep -i oom
```

**Resolution:**
- Scale up to instance with more memory
- Fix memory leaks in application code
- Implement connection pooling and limits
- Use memory-optimized instance types
- Tune application memory settings (JVM heap, cache sizes)

### Storage Performance

**Symptoms:**
- High disk I/O latency
- Slow read/write operations
- I/O wait causing CPU bottleneck
- Application timeouts during disk operations

**Common Causes:**
- Insufficient IOPS for workload
- Wrong storage type (HDD vs SSD)
- Storage throughput limits reached
- Database lock contention
- Large file operations without optimization

**Diagnostic Tools:**
```bash
# Disk I/O
iostat -x 1
iotop
df -h
du -sh /path

# Check I/O wait
vmstat 1  # check 'wa' column
```

**Resolution:**
- Upgrade to higher-performance storage tier (gp3, io2, provisioned IOPS)
- Implement caching layer (Redis, application cache)
- Optimize database queries and indexing
- Use appropriate storage type for workload pattern
- Distribute I/O across multiple volumes

### Network Performance

**Symptoms:**
- High latency between components
- Packet loss or retransmissions
- Low throughput for data transfers
- Connection timeouts

**Common Causes:**
- Bandwidth limitations
- Network congestion
- Suboptimal routing
- MTU mismatch (jumbo frames)
- Geographic distance between components

**Diagnostic Tools:**
```bash
# Network connectivity
ping -c 10 destination
traceroute destination
mtr destination

# Network throughput
iperf3 -c destination

# Network connections
ss -tunap
netstat -tulnp

# Packet capture
tcpdump -i eth0 -n host destination-ip
```

**Resolution:**
- Use enhanced networking or placement groups for low latency
- Upgrade to higher-bandwidth instance types
- Place resources in same AZ for lowest latency
- Use CDN for geographically distributed users
- Check MTU settings (VPN tunnels may need lower MTU)

## Security Incidents

### Unauthorized Access

**Indicators:**
- Login attempts from unusual locations or times
- API calls from unexpected IP addresses
- Privilege escalation events
- Access to resources outside normal scope
- Newly created users or access keys

**Investigation Steps:**
1. Review authentication logs for anomalous activity
2. Check audit logs for unauthorized API calls
3. Identify compromised credentials or access keys
4. Determine scope of unauthorized access
5. Check for data exfiltration or modification
6. Review resource creation logs for persistence mechanisms

**Immediate Actions:**
- Disable compromised credentials immediately
- Revoke active sessions
- Block source IP addresses
- Preserve evidence (log snapshots, forensic images)

### Security Misconfigurations

**Common Misconfigurations:**
- Overly permissive security groups (0.0.0.0/0 on sensitive ports)
- Public S3 buckets or storage accounts
- Unencrypted data at rest
- Missing MFA on administrative accounts
- Excessive IAM permissions
- Default credentials not changed
- Logging not enabled

**Detection:**
- Cloud security posture management (CSPM) tools
- Automated configuration compliance scanning
- Regular security audits
- Penetration testing results
- Cloud provider security advisories

**Remediation:**
- Apply least privilege to all access rules
- Enable encryption by default
- Enforce MFA for all administrative access
- Regular access reviews and permission audits
- Implement automated compliance enforcement

### Data Exposure

**Indicators:**
- Public access to private storage
- Unintended data in public APIs
- Credentials or keys in code repositories
- Data in unencrypted backups or snapshots

**Response:**
- Remove public access immediately
- Rotate any exposed credentials
- Assess what data was exposed and for how long
- Notify affected parties per compliance requirements
- Implement controls to prevent recurrence

## Automation Failures

### IaC Template Errors

**Common Issues:**
- Syntax errors in templates (HCL, YAML, JSON)
- Resource dependency ordering issues
- Missing or incorrect variable values
- Provider API rate limiting
- Insufficient permissions for resource creation
- State file corruption or conflicts

**Diagnostic Steps:**
- Check template syntax validation output
- Review execution plan/change set for unexpected changes
- Check provider API error messages
- Verify IAM permissions for automation service account
- Review state file for inconsistencies

**Resolution:**
- Fix syntax errors using linter/validator tools
- Add explicit dependencies (depends_on)
- Use data sources to reference existing resources
- Implement retry logic for transient API errors
- Use remote state with locking to prevent conflicts

### State Drift

**Description:** Actual infrastructure differs from IaC-defined state

**Causes:**
- Manual console changes outside IaC
- Failed apply that partially completed
- External automation modifying resources
- Provider API side effects

**Detection:**
- terraform plan shows unexpected changes
- CloudFormation drift detection
- Configuration compliance scanning
- Regular state refresh and comparison

**Resolution:**
- Import manually created resources into state
- Use terraform refresh to update state
- Enforce policy: no manual changes to IaC-managed resources
- Implement automated drift detection and alerting

### CI/CD Pipeline Failures

**Common Issues:**
- Build failures (dependency resolution, compilation errors)
- Test failures (flaky tests, environment differences)
- Deployment failures (permissions, resource limits, configuration)
- Approval gate timeouts
- Artifact storage issues

**Diagnostic Steps:**
- Review pipeline logs for the failing stage
- Check build/test environment configuration
- Verify artifact availability and integrity
- Check deployment target health and permissions
- Review recent code changes that triggered the pipeline

**Resolution:**
- Fix code or dependency issues causing build failures
- Stabilize flaky tests or quarantine them
- Verify deployment permissions and target configuration
- Implement better error handling and notifications
- Add retry logic for transient failures

### Container Deployment Failures

**Common Issues:**
- Image pull failures (registry authentication, image not found)
- Resource limit exceeded (CPU, memory)
- Health check failures (application not starting)
- Volume mount issues
- Network connectivity from container

**Diagnostic Steps:**
```bash
# Check pod status (Kubernetes)
kubectl get pods
kubectl describe pod pod-name
kubectl logs pod-name

# Check events
kubectl get events --sort-by=.metadata.creationTimestamp

# Check container details
docker logs container-id
docker inspect container-id
```

**Resolution:**
- Fix registry credentials and image references
- Adjust resource limits and requests
- Fix application startup issues causing health check failures
- Verify volume configuration and permissions
- Check network policies and DNS configuration

---

## Troubleshooting Quick Reference

### Network Connectivity Checklist
- [ ] DNS resolving correctly?
- [ ] Security groups allow traffic?
- [ ] Network ACLs allow traffic (both directions)?
- [ ] Route tables have correct entries?
- [ ] NAT Gateway configured for private subnet internet access?
- [ ] VPN tunnel status up?
- [ ] Load balancer health checks passing?
- [ ] SSL certificates valid?

### Performance Checklist
- [ ] CPU utilization within normal range?
- [ ] Memory usage not at capacity?
- [ ] Disk I/O latency acceptable?
- [ ] Network throughput sufficient?
- [ ] Database query performance acceptable?
- [ ] Auto-scaling responding to demand?
- [ ] Caching effective?

### Security Incident Checklist
- [ ] Compromised credentials disabled?
- [ ] Scope of unauthorized access determined?
- [ ] Evidence preserved?
- [ ] Affected systems isolated?
- [ ] Root cause identified?
- [ ] Preventive measures implemented?
- [ ] Incident documented?

## Key Takeaways for the Exam

1. Follow the systematic 7-step troubleshooting methodology
2. Check recent changes first - most issues follow changes
3. Know the difference between stateful (security groups) and stateless (NACLs) rules
4. Understand DNS troubleshooting tools and common issues
5. Know performance diagnostic tools and what metrics they reveal
6. Security incidents: contain first, then investigate
7. IaC state drift is a common source of deployment issues
8. Container troubleshooting: check events, logs, and resource limits
