# KCSA High-Yield Scenarios and Practice Problems

## Scenario 1: The 4C's Security Assessment

**Scenario**: A company is deploying a new application to Kubernetes on AWS. The security team asks you to identify which security controls should be implemented at each layer of the 4C's model. The application processes payment data and must meet compliance requirements.

**Solution Pattern**:
- **Cloud**: AWS IAM roles with least privilege, VPC with private subnets, security groups restricting traffic, KMS encryption for EBS volumes, CloudTrail for audit logging
- **Cluster**: RBAC with namespace isolation, Network Policies for pod-to-pod restrictions, Pod Security Admission at Restricted level, audit logging enabled, CIS Benchmark compliance
- **Container**: Minimal base images (distroless), vulnerability scanning in CI/CD, read-only root filesystem, non-root user, dropped capabilities, resource limits
- **Code**: Input validation, TLS for all external communication, dependency scanning, no hardcoded secrets, encrypted sensitive data

**Common Distractors**:
- Placing Network Policies at the Cloud layer (they are Cluster-level controls)
- Thinking image scanning is a Code-level control (it is Container-level)
- Confusing cloud IAM with Kubernetes RBAC (different layers)

**Key Takeaway**: Each 4C layer addresses different threats. A weakness at any layer can compromise layers above it. Security must be implemented at every layer.

---

## Scenario 2: RBAC Misconfiguration Analysis

**Scenario**: During a security audit, you discover that a developer's service account in the `dev` namespace has a ClusterRoleBinding to the `cluster-admin` ClusterRole. The developer only needs to create and manage Deployments and Services in the `dev` namespace. What is wrong and how should it be fixed?

**Solution Pattern**:
- **Problem**: ClusterRoleBinding to cluster-admin grants full access to everything in every namespace - massive violation of least privilege
- **Fix**: Delete the ClusterRoleBinding, create a namespace-scoped Role with only the needed permissions (create, get, list, update Deployments and Services), create a RoleBinding in the `dev` namespace binding the Role to the service account
- **Verification**: Use `kubectl auth can-i` to verify the service account can only perform allowed actions

**Common Distractors**:
- Keeping the ClusterRoleBinding but changing it to a less privileged ClusterRole (still too broad if only one namespace is needed)
- Creating a ClusterRole instead of a Role (ClusterRole is cluster-scoped, not needed here)
- Not deleting the original ClusterRoleBinding (the old binding still grants full access)

**Key Takeaway**: Always use the narrowest scope possible. Namespace-scoped Roles are preferred over ClusterRoles when access is limited to a single namespace.

---

## Scenario 3: Threat Modeling with STRIDE

**Scenario**: A Kubernetes cluster hosts a web application with a frontend (public-facing), backend API, and PostgreSQL database. Apply the STRIDE threat model to identify threats and recommend mitigations for each category.

**Solution Pattern**:

| Threat | Example | Mitigation |
|--------|---------|------------|
| **Spoofing** | Attacker uses stolen service account token to access API server | Short-lived tokens, OIDC authentication, disable automount |
| **Tampering** | Malicious image pushed to container registry | Image signing with cosign, admission controller for verification |
| **Repudiation** | Admin deletes pods with no audit trail | Enable Kubernetes audit logging, forward logs to central system |
| **Information Disclosure** | Secrets readable via API or etcd | Encryption at rest, RBAC to limit Secret access, external vault |
| **Denial of Service** | Pod without resource limits consumes all node resources | Resource limits, LimitRange, ResourceQuota per namespace |
| **Elevation of Privilege** | Container escape via privileged mode | Pod Security Admission (Restricted), drop all capabilities, non-root |

**Common Distractors**:
- Confusing Spoofing with Elevation of Privilege (Spoofing is about identity, EoP is about gaining higher access)
- Not identifying Repudiation threats (audit logging is often overlooked)
- Thinking Network Policies alone prevent all Information Disclosure (they control network access, not API-level access to Secrets)

**Key Takeaway**: STRIDE provides a structured approach to identifying threats. Each category maps to specific Kubernetes security controls.

---

## Scenario 4: Pod Security Standards Selection

**Scenario**: An organization has three types of workloads in their cluster:
1. A monitoring agent that needs host network and PID access (runs as DaemonSet)
2. A standard web application with no special requirements
3. A financial processing service that must have maximum security hardening

Which Pod Security Standards level should each workload use?

**Solution Pattern**:
- **Monitoring agent**: Privileged level - requires host-level access that Baseline and Restricted would block. Isolate in a dedicated namespace with strict RBAC
- **Web application**: Baseline level - prevents known privilege escalations while allowing most standard workloads to run without modification
- **Financial service**: Restricted level - enforces all hardening best practices: non-root, no privilege escalation, seccomp profile, dropped capabilities, read-only filesystem

**Common Distractors**:
- Using Restricted for the monitoring agent (would block required host access - the agent cannot function)
- Using Privileged for all workloads (violates least privilege - only use Privileged when necessary)
- Thinking Baseline and Restricted are the same (Baseline allows some capabilities that Restricted blocks)

**Key Takeaway**: Match the PSA level to the workload requirements. Use the most restrictive level possible for each workload. Isolate Privileged workloads in dedicated namespaces.

---

## Scenario 5: Supply Chain Attack Detection

**Scenario**: A security scan reveals that a container image deployed in production contains a known critical vulnerability (CVE with remote code execution). The image was pulled from a public registry. What went wrong and what controls should be implemented to prevent this?

**Solution Pattern**:
- **Root Cause**: No image scanning in the CI/CD pipeline, no admission control blocking vulnerable images, images pulled from untrusted public registries
- **Prevention Controls**:
  1. Image scanning in CI/CD pipeline (Trivy, Grype) - block builds with critical CVEs
  2. Admission controller to restrict images to approved private registries only
  3. Image signing with cosign and verification via admission webhook
  4. Regular scanning of running images for newly discovered CVEs
  5. Base image update policy with automated rebuilds
  6. SBOM (Software Bill of Materials) generation and tracking

**Common Distractors**:
- Only scanning at build time (new CVEs are discovered after deployment)
- Allowing any public registry as long as scanning passes (supply chain risk remains)
- Thinking Network Policies prevent supply chain attacks (they control network traffic, not image integrity)

**Key Takeaway**: Supply chain security requires controls at multiple stages - build (scanning, signing), deploy (admission control, registry restrictions), and runtime (continuous scanning).

---

## Scenario 6: Compliance Assessment

**Scenario**: An auditor asks how your Kubernetes environment maps to the NIST Cybersecurity Framework. They want evidence for each of the five functions. What Kubernetes security controls and tools provide evidence for each?

**Solution Pattern**:

| NIST Function | Kubernetes Controls | Evidence |
|---------------|-------------------|----------|
| **Identify** | Asset inventory, namespace organization, labels | kubectl get all, RBAC audit, resource inventory |
| **Protect** | RBAC, Network Policies, PSA, encryption, image signing | RBAC configs, NetworkPolicy manifests, PSA labels |
| **Detect** | Audit logging, Falco runtime detection, image scanning | Audit log entries, Falco alerts, scan reports |
| **Respond** | Incident response procedures, pod isolation, RBAC changes | Network Policy to isolate compromised pods, runbooks |
| **Recover** | etcd backups, GitOps state recovery, node replacement | Backup schedules, GitOps repo history, DR procedures |

**Common Distractors**:
- Thinking Kubernetes only covers "Protect" (it has controls across all five functions)
- Not knowing that audit logs serve the "Detect" function (they are often associated only with compliance)
- Confusing CIS Benchmark with NIST Framework (CIS is Kubernetes-specific configuration, NIST is an organizational security framework)

**Key Takeaway**: Kubernetes security controls map across all five NIST functions. Compliance requires evidence of controls at every stage, not just protection.

---

## Scenario 7: Network Policy Design

**Scenario**: A microservices application has three tiers: frontend (receives external traffic), API (handles business logic), and database (stores data). Security policy requires that the frontend can only talk to the API, the API can only talk to the database, and the database should not initiate any outbound connections. How should Network Policies be designed?

**Solution Pattern**:
- **Default deny all** in the namespace (both ingress and egress)
- **Frontend**: Allow ingress from outside (Ingress controller), allow egress to API pods only, allow DNS egress
- **API**: Allow ingress from frontend pods only, allow egress to database pods only, allow DNS egress
- **Database**: Allow ingress from API pods only, deny all egress (or allow only DNS)
- Use label selectors to target specific pod groups

**Common Distractors**:
- Forgetting default-deny (without it, all traffic is allowed by default)
- Not allowing DNS egress (pods cannot resolve service names without DNS access)
- Using IP-based rules instead of label selectors (less maintainable and error-prone)
- Only applying ingress policies (egress restrictions are equally important for defense in depth)

**Key Takeaway**: Network Policies should follow the principle of least privilege - default deny everything, then explicitly allow only required communication paths.

## Key Decision Factors

### Domain Priority for Study
1. **Kubernetes Cluster Component Security (22%)** - API server, etcd, kubelet, CIS benchmarks
2. **Kubernetes Security Fundamentals (22%)** - RBAC, PSA, Network Policies, Secrets
3. **Kubernetes Threat Model (16%)** - STRIDE, attack vectors, lateral movement
4. **Platform Security (16%)** - Image security, runtime security, admission control
5. **Cloud Native Security Overview (14%)** - 4C's model, security principles
6. **Compliance and Security Frameworks (10%)** - CIS, NIST, audit logging

### Common Anti-Patterns
- Studying only Kubernetes security without understanding the broader 4C model
- Ignoring threat modeling (16% of the exam)
- Not understanding compliance frameworks (easy points if studied)
- Memorizing controls without understanding what threats they mitigate
- Confusing RBAC scope (namespace vs cluster) and PSA levels
