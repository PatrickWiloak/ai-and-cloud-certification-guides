# Vault Associate (003) Study Strategy

## Study Approach

### Phase 1: Foundation (2 weeks)
1. **Vault Architecture**
   - Understand the seal/unseal process and Shamir's Secret Sharing
   - Learn storage backend options and HA architecture
   - Study the barrier concept and encryption at rest
   - Set up a Vault dev server for hands-on practice

2. **Core Concepts**
   - Master authentication methods and when to use each
   - Learn policy syntax and capabilities (create, read, update, delete, list, sudo, deny)
   - Understand the token hierarchy and types (service, batch, root, orphan)
   - Study the difference between static and dynamic secrets

### Phase 2: Core Skills (2-3 weeks)
1. **Secrets Engines Deep Dive**
   - Practice KV v1 and v2 operations (most heavily tested engine)
   - Configure Database engine for dynamic credentials
   - Use Transit engine for encryption as a service
   - Understand PKI engine for certificate management

2. **CLI and Operations Mastery**
   - Practice all essential vault commands repeatedly
   - Learn environment variables (VAULT_ADDR, VAULT_TOKEN, etc.)
   - Practice writing and applying policies
   - Master token and lease management commands

### Phase 3: Exam Preparation (1-2 weeks)
1. **Practice Exams**
   - Take HashiCorp official practice exam
   - Use Bryan Krausen or Tutorials Dojo practice tests
   - Target 80%+ before scheduling the real exam
   - Review every incorrect answer thoroughly

2. **Final Review**
   - Review CLI command syntax and flags
   - Study auth method selection criteria
   - Review KV v1 vs v2 differences
   - Quick review of API structure and sys/ endpoints

## Comprehensive Study Resources

### Official Resources
- **[Vault Associate Study Guide](https://developer.hashicorp.com/vault/tutorials/associate-cert)** - Official study guide
- **[Vault Documentation](https://developer.hashicorp.com/vault/docs)** - Complete reference documentation
- **[Vault Tutorials](https://developer.hashicorp.com/vault/tutorials)** - Hands-on learning paths
- **[Vault API Documentation](https://developer.hashicorp.com/vault/api-docs)** - REST API reference
- **[Vault Getting Started](https://developer.hashicorp.com/vault/tutorials/getting-started)** - Beginner tutorials

### Recommended Courses
- **Bryan Krausen - Vault Associate on Udemy** - Highly rated exam-focused course
- **KodeKloud - Vault for Beginners** - Interactive hands-on course
- **A Cloud Guru - HashiCorp Vault** - Comprehensive course with labs
- **HashiCorp Learn** - Free official tutorials

### Practice Test Platforms
- **HashiCorp Official Practice Exam** - Included with registration
- **Bryan Krausen Practice Tests (Udemy)** - Multiple scenario-based exams
- **Tutorials Dojo Practice Exams** - Vault question banks

### Hands-On Practice
- **Vault Dev Server** - `vault server -dev` (free, no setup required)
- **Docker Vault** - Containerized Vault for local testing
- **HashiCorp Cloud Platform (HCP) Vault** - Managed Vault service with free tier
- **Katacoda/KillerCoda** - Browser-based Vault labs

## Exam Tactics

### Question Strategy
1. **Read carefully:** Identify what is being tested - auth method, policy, engine, or CLI
2. **Eliminate first:** Remove obviously incorrect answers
3. **Scenario keywords:** "machine auth" = AppRole/K8s, "human auth" = LDAP/OIDC/userpass
4. **CLI precision:** Know exact command syntax and flag names
5. **Security mindset:** Prefer least privilege, dynamic secrets, short TTLs

### Time Management
- **~1 minute per question** average (57 questions in 60 minutes)
- **Flag and move:** Do not spend more than 90 seconds on any question
- **Quick wins first:** Answer confident questions immediately
- **Policy questions:** May require careful reading - budget extra time
- **Fill-in-blank:** These test exact syntax, ensure precision

### Common Patterns on the Exam
- **Auth method selection:** Know which auth method fits each scenario
- **Policy writing:** Understand capabilities and path patterns
- **KV v1 vs v2:** Path differences, versioning, soft delete
- **Token types:** When to use service vs batch vs orphan
- **Dynamic secrets:** Lifecycle, lease management, auto-revocation
- **CLI commands:** Exact syntax for common operations
- **Architecture:** Seal/unseal, storage backends, HA

## Common Pitfalls

### Study Mistakes
- Only reading documentation without hands-on practice
- Ignoring the API section (5% but easy points)
- Not practicing policy writing from scratch
- Skipping the seal/unseal process understanding
- Not learning KV v2 path differences from v1

### Exam Mistakes
- Confusing KV v2 API paths (`/data/` prefix) with CLI paths (no prefix in `vault kv`)
- Thinking Transit engine stores data (it only encrypts/decrypts)
- Not knowing that deny capability overrides all other capabilities
- Confusing batch tokens with service tokens (batch cannot be renewed)
- Thinking `vault operator init` can be run more than once (it cannot on an already initialized Vault)
- Forgetting that the default policy is attached to ALL tokens
- Confusing Role ID (non-sensitive) with Secret ID (sensitive) in AppRole
- Not knowing that storage backends only see encrypted data

### Conceptual Misunderstandings
- Vault tokens are the universal authentication mechanism - all auth methods produce tokens
- Root tokens should be revoked after initial setup, not stored
- Dynamic secrets are generated on-demand, not pre-created and stored
- Transit engine is encryption as a service - data stays with the application
- Integrated Storage (Raft) is the recommended storage backend for new deployments

## Progress Tracking

### Weekly Milestones
- **Week 1-2:** Can explain architecture, configure auth methods, write policies
- **Week 3:** Master secrets engines, token management, CLI operations
- **Week 4:** Understand API, advanced auth patterns, integration scenarios
- **Week 5:** Score 70%+ on practice exam, identify and fill gaps
- **Week 6:** Score 80%+ on practice exam, pass certification

### Self-Assessment Questions
- Can I explain the Vault seal/unseal process?
- Do I know when to use AppRole vs Kubernetes vs LDAP auth?
- Can I write a policy with correct capabilities from memory?
- Do I understand KV v1 vs v2 differences?
- Can I explain the lifecycle of a dynamic secret?
- Do I know the difference between service and batch tokens?
- Can I configure a secrets engine via CLI?
