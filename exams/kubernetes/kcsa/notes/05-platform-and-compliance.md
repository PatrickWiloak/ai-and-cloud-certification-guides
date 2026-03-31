# Platform Security and Compliance Frameworks

**[📖 Trivy](https://aquasecurity.github.io/trivy/)** - Vulnerability scanner
**[📖 Falco](https://falco.org/docs/)** - Runtime security
**[📖 CIS Benchmarks](https://www.cisecurity.org/benchmark/kubernetes)** - CIS Kubernetes Benchmark

## Image Security

### Base Image Best Practices
- **Minimal images**: Use distroless, scratch, or Alpine to reduce attack surface
- **Multi-stage builds**: Build in one stage, copy artifacts to a minimal runtime image
- **Pin versions**: Never use `latest` tag - use specific version tags or digests
- **Non-root user**: Set USER directive in Dockerfile
- **No unnecessary tools**: Remove shells, package managers, and debug tools from production images

### Vulnerability Scanning
- Scan images during CI/CD build (shift-left)
- Block deployments with critical/high CVEs
- Re-scan running images for newly discovered vulnerabilities
- Tools: Trivy, Grype, Clair, Snyk Container

**Common Scanner Output:**
| Severity | Action |
|----------|--------|
| CRITICAL | Block deployment, fix immediately |
| HIGH | Block deployment, fix in current sprint |
| MEDIUM | Track and fix in next release |
| LOW | Track, fix when convenient |

### Image Signing and Verification

**cosign (Sigstore):**
- Signs container images with cryptographic signatures
- Supports keyless signing with OIDC identity
- Verification can be enforced via admission controllers
- Part of the Sigstore project (CNCF)

**Supply Chain Attestation:**
- SBOM (Software Bill of Materials) - list of all components in an image
- SLSA (Supply chain Levels for Software Artifacts) - framework for supply chain integrity
- in-toto - framework for securing software supply chains
- Provenance records documenting how an artifact was built

### Registry Security
- Use private registries with access control
- Enable vulnerability scanning on the registry
- Implement image retention and cleanup policies
- Restrict which registries pods can pull from (admission controllers)

## Runtime Security

### Falco
- Open source runtime threat detection engine
- Monitors system calls at the kernel level
- Detects abnormal behavior in containers and hosts
- Uses rules to define what constitutes a threat
- Alerts via multiple channels (syslog, HTTP, gRPC)

**What Falco Detects:**
- Shell spawning inside containers
- Sensitive file access (/etc/shadow, /etc/passwd)
- Unexpected network connections
- Privilege escalation attempts
- Cryptocurrency mining activity
- Container escape attempts

### Container Runtime Sandboxes

| Technology | Approach | Isolation Level |
|-----------|----------|----------------|
| **gVisor (runsc)** | Application-level kernel in user space | Strong - intercepts syscalls |
| **Kata Containers** | Lightweight VM per container | Strongest - hardware isolation |
| **Default (runc)** | Standard container (shared kernel) | Standard - namespace/cgroup isolation |

**RuntimeClass:**
- Kubernetes resource for selecting container runtimes
- Allows different pods to use different runtimes
- Use sandboxed runtimes for untrusted workloads or multi-tenant environments

### Kernel Hardening

**seccomp (Secure Computing Mode):**
- Filters system calls available to containers
- Profiles: RuntimeDefault (recommended minimum), Localhost (custom), Unconfined (no filtering)
- RuntimeDefault blocks dangerous syscalls while allowing normal operation
- Custom profiles can restrict to only the syscalls an application needs

**AppArmor:**
- Linux Security Module for mandatory access control
- Profiles restrict file access, network operations, and capabilities
- Modes: enforce (block violations), complain (log violations), unconfined (no restrictions)
- Profiles must be loaded on the node before pods can use them

**SELinux:**
- Alternative to AppArmor (typically on RHEL-based systems)
- Uses labels to define access control policies
- More granular than AppArmor but more complex to configure

## Admission Controllers for Policy Enforcement

### Built-in Controllers

| Controller | Purpose |
|-----------|---------|
| **PodSecurity** | Enforces Pod Security Standards via namespace labels |
| **ImagePolicyWebhook** | Controls which images can be deployed |
| **NodeRestriction** | Limits kubelet modifications to its own node |
| **LimitRanger** | Sets default and max resource requests/limits |
| **ResourceQuota** | Enforces resource consumption limits per namespace |

### OPA Gatekeeper

**[📖 OPA Gatekeeper](https://open-policy-agent.github.io/gatekeeper/website/docs/)** - Policy engine documentation

- Admission controller for custom policy enforcement
- Uses Rego policy language (from Open Policy Agent)
- ConstraintTemplates define the policy logic
- Constraints apply templates to specific resources

**Common Gatekeeper Policies:**
- Required labels on all resources
- Allowed container registries (whitelist)
- Required resource limits
- Blocked privileged containers
- Required security context settings
- Disallowed latest image tag

## Compliance Frameworks

### CIS Kubernetes Benchmark

**Categories:**
1. **Control Plane Components** - API server, scheduler, controller manager flags
2. **etcd** - etcd security configuration
3. **Control Plane Configuration** - Auth, logging, general config
4. **Worker Nodes** - kubelet and kube-proxy settings
5. **Policies** - RBAC, Network Policies, Pod Security, Secrets

**Assessment with kube-bench:**
- Automated tool that checks CIS Benchmark compliance
- Can run as a Job in the cluster or directly on nodes
- Outputs PASS, FAIL, WARN, INFO for each check
- Provides remediation steps for failed checks
- Should be run regularly, not just once

### NIST Cybersecurity Framework

**[📖 NIST Framework](https://www.nist.gov/cyberframework)** - NIST Cybersecurity Framework

| Function | Description | Kubernetes Mapping |
|----------|-------------|-------------------|
| **Identify** | Know your assets and risks | Asset inventory, threat modeling, risk assessment |
| **Protect** | Implement safeguards | RBAC, Network Policies, PSA, encryption, admission control |
| **Detect** | Identify security events | Audit logging, Falco, monitoring, image scanning |
| **Respond** | Take action on incidents | Incident response, pod isolation, forensics |
| **Recover** | Restore to normal | etcd backups, GitOps recovery, node replacement |

### SOC 2
- Service Organization Control 2 - trust services criteria
- Trust Service Categories: Security, Availability, Processing Integrity, Confidentiality, Privacy
- Kubernetes controls map to multiple categories
- Audit logging and access control are key evidence items

### PCI DSS
- Payment Card Industry Data Security Standard
- Relevant when processing payment data in containers
- Key requirements: network segmentation, access control, encryption, monitoring
- Network Policies and namespace isolation help meet segmentation requirements

### GDPR
- General Data Protection Regulation (EU)
- Data protection and privacy for personal data
- Relevant: data encryption, access control, audit logging, data deletion capabilities
- Kubernetes Secrets management and RBAC support GDPR requirements

## Audit Logging

**[📖 Auditing](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/)** - Kubernetes audit logging

### Audit Levels
| Level | What is Recorded |
|-------|-----------------|
| **None** | Nothing logged |
| **Metadata** | Request metadata (who, what, when) but no body |
| **Request** | Metadata plus request body |
| **RequestResponse** | Metadata, request body, and response body |

### Audit Policy
- Rules define what to log at what level
- First matching rule applies (order matters)
- Best practice: RequestResponse for Secrets, Request for writes, Metadata for everything else
- Exclude high-volume, low-risk endpoints (health checks)

### Compliance Value
- Provides evidence of who did what and when
- Critical for incident investigation and forensic analysis
- Required by most compliance frameworks (SOC 2, PCI DSS, NIST)
- Should be forwarded to centralized, tamper-proof storage
- Retention policies must align with compliance requirements

## Policy as Code

### Concept
- Define security policies as version-controlled code
- Automate policy enforcement via admission controllers
- Review policies through standard code review processes
- Track policy changes in Git history

### Benefits
- Consistent enforcement across all environments
- Auditable history of policy changes
- Testable policies before deployment
- Scalable across multiple clusters
- Reduced human error in policy application

### Tools
- **OPA/Gatekeeper**: Rego-based policies for Kubernetes admission
- **Kyverno**: Kubernetes-native policy engine (YAML-based policies)
- **Kubewarden**: WebAssembly-based policy engine
- **Datree**: Policy enforcement in CI/CD pipelines
