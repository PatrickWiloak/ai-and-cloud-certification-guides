# 03 - Cloud Platform and Infrastructure Security (Domain 3, 17%)

## Domain Overview

Domain 3 covers the cloud infrastructure stack: physical facilities, virtualization, compute, storage, network, and the security controls that protect them. Customers in IaaS take the most responsibility for these layers; PaaS and SaaS customers benefit from provider controls but must understand the model.

## Cloud Infrastructure Components

### Physical Layer (Provider Responsibility)
- Data center facilities
  - Tier I to IV redundancy (Uptime Institute)
  - Tier IV: 99.995% availability, 2N+1 redundancy
- Power: utility, UPS, generators, multiple feeds
- Cooling: HVAC, hot/cold aisle, water cooling for high-density
- Fire suppression: gas (FM-200, Inergen, CO2) preferred over water
- Physical access controls: mantraps, biometrics, 24/7 security
- Environmental monitoring

While customer cannot directly inspect, attestations (SOC 2, ISO 27001, FedRAMP) provide assurance.

### Logical Layer
- Virtualization (hypervisors, containers)
- Networking (virtual networks, SDN)
- Compute (VMs, containers, serverless)
- Storage (object, block, file, database)
- Identity and access management
- Security services (firewalls, monitoring)

## Virtualization Security

### Hypervisor Types
- **Type 1 (Bare-Metal)** - Runs directly on hardware
  - Examples: VMware ESXi, Microsoft Hyper-V (server), Xen, KVM
  - Used by all major cloud providers
  - Smaller attack surface
- **Type 2 (Hosted)** - Runs on a host OS
  - Examples: VMware Workstation, VirtualBox, Hyper-V (Windows desktop)
  - Larger attack surface (host OS vulnerabilities)
  - Used for development, not production cloud

### Hypervisor Security Concerns
- **VM escape** - Guest VM breaks isolation to access hypervisor or other VMs
  - Examples: VENOM (CVE-2015-3456), Spectre/Meltdown side-channel variants
  - Mitigation: hypervisor patching, hardware features (Intel VT-x, AMD-V)
- **Side-channel attacks** - Co-resident VM extracts info via cache, timing, etc.
  - Mitigation: hardware isolation, dedicated tenancy options
- **Hypervisor compromise** - Catastrophic; affects all VMs
  - Mitigation: minimal hypervisor footprint, signed firmware, monitoring
- **Snapshot exposure** - Snapshots may include sensitive memory state
  - Mitigation: encrypt snapshots, restrict access, sanitize before share
- **Resource starvation** - Noisy neighbor consumes shared resources
  - Mitigation: quotas, dedicated tenancy

### VM Security Controls
- Patched guest OS and applications
- Endpoint protection (EDR/EPP)
- Encrypted boot volumes and data disks
- Network segmentation
- Logging to centralized system
- Periodic vulnerability scanning
- Hardened baseline images

## Container Security

### Container Concepts
- Containers share host kernel (lighter weight than VMs)
- Image: filesystem snapshot with metadata (Dockerfile, Containerfile)
- Registry: stores images (Docker Hub, ECR, ACR, GCR)
- Runtime: executes containers (containerd, runc, CRI-O)
- Orchestrator: manages containers at scale (Kubernetes, ECS)

### Container Security Lifecycle
1. **Image scanning** - Trivy, Snyk, Anchore, vendor tools (ECR, ACR, GCR built-in)
2. **Image signing** - Sigstore (Cosign), Notation, Notary v2; ensures provenance
3. **Trusted registries** - Private registries with access controls; mirror critical OSS
4. **Minimal base images** - Distroless, Alpine, scratch; reduces attack surface
5. **Non-root containers** - User namespace mapping, drop capabilities
6. **Read-only filesystems** - Mount as RO except specific writable paths
7. **Runtime threat detection** - Falco, Defender for Containers, Sysdig, Aqua, Prisma Cloud Compute

### Kubernetes Security
- **Pod Security Standards** - Restricted, Baseline, Privileged
- **Network policies** - Restrict pod-to-pod traffic (Calico, Cilium)
- **Admission controllers** - OPA Gatekeeper, Kyverno enforce policy at API server
- **RBAC** - Role-based access for cluster operations
- **Secrets management** - Kubernetes Secrets (base64-encoded, encrypt etcd at rest), or external secret operators (External Secrets Operator with Vault, AWS Secrets Manager, etc.)
- **etcd encryption** - Encrypt cluster state at rest
- **Audit logging** - Kubernetes audit logs centralized
- **Service mesh** - Istio, Linkerd, Consul; mTLS, identity, observability
- **Workload identity** - Federate K8s service accounts to cloud IAM (no static cloud creds in pods)
- **Image admission** - Require signed images from trusted registries
- **CIS Benchmarks** - For Kubernetes hardening; tools like kube-bench

### Managed vs Self-Managed Kubernetes
- **Managed (EKS, AKS, GKE)** - Provider manages control plane patching
- **Self-managed** - Customer responsible for control plane and worker nodes

## Serverless / FaaS Security

### Concepts
- Code runs in response to events
- No server management
- Per-invocation billing
- Examples: AWS Lambda, Azure Functions, GCP Cloud Functions

### Security Considerations
- IAM per function (least privilege; the function should access only what it needs)
- Secrets in vault, retrieved at invocation (not in environment variables for sensitive secrets)
- Dependency management (SCA on packaged libraries)
- Cold start telemetry visibility limits
- Event source authentication (validate triggers come from expected source)
- Concurrent execution limits (DoS protection, cost control)
- Function timeouts
- VPC connectivity (for accessing private resources, with NAT impact)
- API Gateway in front for control (auth, rate limiting, schema validation)

### Serverless-Specific Risks
- Function event injection
- Over-privileged functions
- Insecure deserialization in event payloads
- Long-lived secrets in env vars
- Dependency vulnerabilities

OWASP Serverless Top 10 covers these in detail.

## Cloud Network Security

### Virtual Networks (VPC / VNet)
- Isolated network in cloud
- Subnets within VPC; can be public or private
- IP addressing (CIDR blocks)
- Routing tables, internet gateways, NAT gateways
- Examples: AWS VPC, Azure VNet, GCP VPC

### Network Segmentation
- Multi-VPC for environments (dev, staging, prod) and tiers (web, app, data)
- Subnets within VPC for further isolation
- Security groups (instance-level firewalls; stateful)
- Network ACLs (subnet-level; stateless)
- Microsegmentation (per-workload, often via SDN or service mesh)

### Connecting Networks
- **VPC peering** - Direct private connection between VPCs
- **Transit Gateway / Hub-and-spoke** - Centralized routing
- **Private connectivity to on-prem** - Direct Connect (AWS), ExpressRoute (Azure), Cloud Interconnect (GCP)
- **Site-to-site VPN** - IPsec over internet, lower cost than direct
- **Client VPN / ZTNA** - Remote access; ZTNA preferred over traditional VPN

### Cloud Firewalls
- **Security groups** - Per-instance/resource, stateful
- **Network ACLs** - Per-subnet, stateless
- **Cloud-native firewall services** - AWS Network Firewall, Azure Firewall, GCP Cloud Firewall
- **WAF** - L7 protection (AWS WAF, Azure WAF, GCP Cloud Armor)
- **NGFW from third parties** - Palo Alto VM-Series, Fortinet, Check Point

### DDoS Protection
- Cloud provider built-in (AWS Shield Standard, Azure DDoS Protection Basic, GCP Cloud Armor)
- Premium tiers for advanced (AWS Shield Advanced, Azure DDoS Protection Standard)
- Application-layer protection via WAF and CDN
- Rate limiting at API Gateway

### Zero Trust Network Access (ZTNA)
- Replaces traditional VPN
- Identity-aware, device-aware, application-specific access
- Examples: Cloudflare Access, Zscaler Private Access, Microsoft Entra Private Access, Google BeyondCorp Enterprise
- No implicit trust based on network location

### Service Mesh (for microservices)
- Sidecars handle communication
- Features: mTLS between services, identity, traffic policies, observability
- Examples: Istio, Linkerd, Consul, AWS App Mesh, Azure Service Fabric mesh

## Cloud Storage Security

(Recap from Domain 2 with infrastructure focus)

### Object Storage Security
- Default bucket policy: private (default in modern providers)
- Bucket policies and ACLs (deprecated in favor of policies)
- Block Public Access at account level (AWS S3)
- Encryption with customer-managed keys
- Versioning and Object Lock for ransomware resilience
- Pre-signed URLs for time-limited access
- Logging access requests
- VPC endpoints / Private Link to avoid internet routing

### Block Storage Security
- Encryption at rest (default)
- Snapshot encryption
- Snapshot sharing controls
- Backup with separate identity scope
- Detach and re-attach for forensics

### Database Storage Security
- Private endpoints (no public IP)
- TLS required
- Encryption at rest with CMK
- Backups encrypted and versioned
- Point-in-time recovery

## Compute Security

### VM Security
- Hardened images (CIS, vendor benchmarks, Defender for Cloud baselines)
- Patch management (cloud-native or third-party)
- Endpoint protection
- Vulnerability assessment
- Just-in-time SSH/RDP access (provider features)
- No long-lived SSH keys (use cloud-native session tools)

### Container Compute Security
(See container section)

### Serverless Compute Security
(See serverless section)

### Cloud Workload Protection Platform (CWPP)
- Continuous protection across VMs, containers, serverless
- Examples: Defender for Cloud, Wiz, Prisma Cloud, Lacework, Orca
- Capabilities: vuln management, runtime protection, compliance, threat detection

## Cloud Security Posture Management (CSPM)

- Continuous assessment of cloud configurations
- Detect misconfigurations against best practices and compliance frameworks
- Examples: Defender for Cloud, AWS Security Hub + Config, GCP Security Command Center, Wiz, Prisma Cloud, Orca
- Cloud-Native CSPM features: attack path analysis, sensitive data discovery, IaC scanning

## Cloud-Native Application Protection Platform (CNAPP)

Convergence of CSPM + CWPP + CIEM (Cloud Infrastructure Entitlement Management):
- Single platform for posture and runtime
- Examples: Wiz, Prisma Cloud, Defender for Cloud, Lacework, Orca

## Disaster Recovery in Cloud

### DR Patterns
| Pattern | Cost | RTO | RPO |
|---------|------|-----|-----|
| Backup-restore | Lowest | Hours-days | Hours-days |
| Pilot light | Low | 10-30 min | Minutes |
| Warm standby | Medium | Minutes | Seconds-minutes |
| Hot multi-region (active-passive) | High | Seconds-minutes | Near-zero |
| Hot multi-region (active-active) | Highest | Near-zero | Near-zero |

### Cloud DR Considerations
- Cross-region replication (S3 CRR, Azure GRS, GCP multi-region buckets)
- Database replication (read replicas, Aurora Global Database, Cosmos DB multi-region writes)
- DNS failover (Route 53, Traffic Manager, Cloud DNS)
- IaC for rebuilding (Terraform, CloudFormation, ARM, Bicep)
- Backup of cloud configuration itself (KMS keys, IAM policies)
- DR runbooks documented and tested
- Provider-side outages: multi-cloud DR for critical systems

### DR Testing in Cloud
- Easier than on-prem (spin up DR environment, test, tear down)
- Game day exercises
- Chaos engineering (Chaos Monkey, AWS Fault Injection Simulator, Azure Chaos Studio)

## Risk Management for Cloud Infrastructure

### Specific cloud infrastructure risks
- **Shared infrastructure** - Multi-tenancy, side-channel
- **Provider lock-in** - Proprietary services, data formats
- **Provider failure** - Service outage, business failure, geopolitical
- **API security** - Misconfiguration, credential theft
- **Data location** - Residency, sovereignty
- **Insider threats** - Provider personnel access
- **Supply chain** - Provider's vendors and partners
- **Compliance** - Provider's framework alignment vs customer requirements

### Risk Mitigations
- Multi-region for availability
- Multi-cloud for redundancy and reduced lock-in
- Data portability planning (open formats, regular exports)
- Continuous compliance monitoring
- Provider attestations (SOC 2, ISO 27001, FedRAMP)
- Defense-in-depth across all layers
- Identity-centric security (zero trust)

## Common Exam Pitfalls

- Confusing Type 1 and Type 2 hypervisors (cloud uses Type 1)
- Assuming containers are as isolated as VMs (they share kernel)
- Forgetting that managed Kubernetes still requires customer-side hardening
- Choosing site-to-site VPN when Direct Connect / ExpressRoute is required for SLA
- Picking a DR pattern that doesn't meet RTO/RPO
- Forgetting to back up cloud configuration (IaC, identities)
- Selecting CSPM when CWPP is needed (or vice versa)
- Not recognizing CNAPP as the convergent category

## Quick Reference: Network Decision

| Need | Choice |
|------|--------|
| Restrict instance traffic | Security group |
| Restrict subnet traffic | Network ACL |
| Per-pod traffic control | Network policy + service mesh |
| Restrict egress to internet | NAT gateway + egress firewall |
| Private connection to on-prem | Direct Connect / ExpressRoute / Cloud Interconnect |
| Private connection to other VPC | VPC peering or Transit Gateway |
| Private SaaS access | Private Link / Private Endpoint |
| Replace VPN for app access | ZTNA |
| L7 web protection | WAF |
| DDoS protection | Provider-managed (Shield, DDoS Protection, Cloud Armor) |
