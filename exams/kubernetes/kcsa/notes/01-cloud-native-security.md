# Overview of Cloud Native Security

**[📖 Cloud Native Security](https://kubernetes.io/docs/concepts/security/overview/)** - The 4C's of cloud native security
**[📖 Securing a Cluster](https://kubernetes.io/docs/tasks/administer-cluster/securing-a-cluster/)** - Cluster security best practices

## The 4C's of Cloud Native Security

The 4C's model provides a layered approach to security where each layer builds on the security of the layer beneath it. A weakness at any layer can compromise the layers above.

### Cloud Layer (Outermost)

The infrastructure layer - cloud provider or data center security.

**Key Controls:**
- **IAM**: Identity and access management for cloud resources
- **Network**: VPCs, subnets, security groups, firewall rules
- **Encryption**: Data at rest (KMS, encrypted volumes) and in transit (TLS)
- **Logging**: Cloud provider audit logs (CloudTrail, Cloud Audit Logs)
- **Compliance**: Cloud provider compliance certifications (SOC 2, ISO 27001)

**Shared Responsibility Model:**
- Cloud provider is responsible for security "of" the cloud (physical, network, hypervisor)
- Customer is responsible for security "in" the cloud (data, applications, configuration)
- In managed Kubernetes (EKS, GKE, AKS), the provider manages control plane security
- Customer is always responsible for workload security, RBAC, and network policies

### Cluster Layer

Kubernetes cluster security - the platform running your workloads.

**Key Controls:**
- API server authentication and authorization
- RBAC configuration with least privilege
- Network Policies for pod-to-pod traffic control
- Pod Security Admission for workload restrictions
- Audit logging for API activity monitoring
- etcd encryption at rest
- Certificate management for component communication
- CIS Benchmark compliance

### Container Layer

Container image and runtime security.

**Key Controls:**
- Minimal base images (distroless, scratch, Alpine)
- Vulnerability scanning (Trivy, Grype)
- Image signing and verification (cosign, Sigstore)
- Read-only root filesystem
- Non-root user execution
- Dropped capabilities
- Resource limits (CPU, memory)
- Container runtime sandboxes (gVisor, Kata Containers)

### Code Layer (Innermost)

Application code security.

**Key Controls:**
- Input validation and sanitization
- Dependency scanning (Dependabot, Snyk)
- Secret handling (never hardcode, use Kubernetes Secrets or external vaults)
- Secure communication (TLS for external, mTLS for internal)
- Authentication and authorization in application logic
- Logging sensitive operations
- OWASP Top 10 awareness

## Security Principles

### Least Privilege
- Grant only the minimum permissions needed for a task
- Applies at every level: cloud IAM, RBAC, container capabilities, service accounts
- Regularly audit and remove unused permissions
- Use time-limited credentials when possible

### Defense in Depth
- Multiple layers of security controls
- If one layer is compromised, other layers still protect
- No single point of failure in security posture
- Each 4C layer provides independent security controls

### Zero Trust
- Never trust, always verify
- Authenticate and authorize every request, regardless of source
- Do not trust traffic based on network location alone
- Assume breach and limit blast radius
- Implement mTLS for service-to-service communication

### Shift Left
- Integrate security early in the development lifecycle
- Scan code and dependencies during development
- Scan container images during CI/CD build
- Enforce policies before deployment, not after
- Security as code - version-controlled, reviewed, automated

### Immutability
- Do not modify running infrastructure
- Replace containers and nodes instead of patching in place
- Container images are immutable after build
- Read-only root filesystems enforce runtime immutability
- Changes require new builds and deployments

## Security Across the Lifecycle

### Build Phase
- Secure coding practices
- Dependency scanning and update
- Container image building with minimal base
- Static analysis of code and configurations
- Image vulnerability scanning

### Deploy Phase
- Admission controllers validate workloads
- Image signature verification
- RBAC and Network Policy enforcement
- Pod Security Standards enforcement
- Registry restrictions (only trusted sources)

### Runtime Phase
- Runtime threat detection (Falco)
- Container immutability enforcement
- Audit logging and monitoring
- Anomaly detection
- Incident response procedures

## Attack Surface Reduction

**Minimize Exposure:**
- Reduce the number of externally accessible services
- Use Ingress controllers instead of exposing every service
- Restrict API server access to trusted networks
- Disable unused Kubernetes features and APIs

**Minimize Components:**
- Use minimal base images
- Remove unnecessary tools from containers
- Disable unused admission controllers
- Remove default credentials and service accounts
