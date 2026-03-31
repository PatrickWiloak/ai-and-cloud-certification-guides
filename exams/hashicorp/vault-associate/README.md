# HashiCorp Vault Associate (003) Certification

## Exam Overview

The HashiCorp Vault Associate (003) certification validates your knowledge of basic concepts, skills, and use cases associated with HashiCorp Vault. This certification is designed for security engineers, DevOps professionals, and platform engineers who use Vault to manage secrets, protect sensitive data, and control access to infrastructure credentials. The exam covers authentication, authorization, secrets engines, tokens, leases, and Vault architecture.

**Exam Code:** Vault Associate (003)
**Exam Duration:** 60 minutes
**Number of Questions:** 57 questions
**Exam Format:** Multiple choice and fill-in-the-blank
**Passing Score:** 70%
**Cost:** $70.50 USD
**Proctoring:** PSI online proctoring
**Validity:** 2 years
**Prerequisites:** None (recommended 6+ months hands-on Vault experience)

## Exam Domains

### Domain 1: Compare authentication methods (15%)
- Describe authentication methods
- Choose an authentication method based on use case
- Differentiate human vs machine authentication
- Describe authentication methods: token, userpass, LDAP, AppRole, AWS, Kubernetes, GitHub
- Understand multi-factor authentication support

### Domain 2: Create Vault policies (15%)
- Illustrate the value of Vault policy
- Describe Vault policy syntax and structure
- Describe Vault policy capabilities: create, read, update, delete, list, sudo, deny
- Craft a Vault policy based on requirements
- Understand path-based access control

### Domain 3: Assess Vault tokens (10%)
- Describe Vault token types
- Differentiate between service and batch tokens
- Describe root token usage and lifecycle
- Describe token accessors
- Understand token time-to-live (TTL) and renewal
- Create tokens based on requirements

### Domain 4: Manage Vault leases (5%)
- Explain the purpose of a lease
- Renew leases
- Revoke leases
- Understand lease duration and TTL concepts

### Domain 5: Compare and configure Vault secrets engines (20%)
- Choose a secrets engine based on use case
- Contrast dynamic secrets vs static secrets
- Describe the KV secrets engine (v1 vs v2)
- Describe the Transit secrets engine
- Describe the PKI secrets engine
- Describe the Database secrets engine
- Enable and configure secrets engines

### Domain 6: Utilize Vault CLI (15%)
- Authenticate to Vault using CLI
- Read and write secrets using CLI
- Enable and configure auth methods and secrets engines
- Use environment variables for Vault configuration
- Manage tokens, leases, and policies via CLI

### Domain 7: Utilize Vault UI (5%)
- Authenticate to Vault UI
- Navigate and manage secrets in the UI
- Manage policies and auth methods in the UI

### Domain 8: Be aware of the Vault API (5%)
- Understand Vault API structure
- Authenticate via the API
- Read and write secrets via the API
- Describe the sys/ API endpoint

### Domain 9: Explain Vault architecture (10%)
- Describe the encryption as a service model
- Describe the purpose of storage backends
- Describe the Vault seal/unseal process
- Explain the purpose of the master key and unseal keys
- Describe Shamir's Secret Sharing
- Explain server-side vs client-side consistency
- Describe high availability architecture

## Key Study Areas

### Authentication and Authorization
- **Auth Methods:** Token, UserPass, LDAP, AppRole, AWS, Kubernetes, GitHub
- **Policies:** HCL-based path permissions with capabilities
- **Tokens:** Service tokens, batch tokens, root tokens, orphan tokens
- **Identity:** Entities, aliases, and groups

### Secrets Management
- **KV Secrets Engine:** Static key-value storage (v1 and v2)
- **Dynamic Secrets:** On-demand credential generation with automatic revocation
- **Transit Engine:** Encryption as a service without storing data
- **PKI Engine:** Certificate authority and certificate management
- **Database Engine:** Dynamic database credentials

### Vault Operations
- **Seal/Unseal:** Vault encryption lifecycle
- **Storage Backends:** Consul, Integrated Storage (Raft), S3
- **High Availability:** Active/standby cluster architecture
- **CLI Operations:** Common commands for daily operations
- **API Structure:** RESTful API for programmatic access

### Security Architecture
- **Encryption:** All data encrypted at rest and in transit
- **Audit Logging:** Request and response audit trails
- **Shamir's Secret Sharing:** Key splitting for unseal process
- **Barrier:** Cryptographic barrier protecting all stored data

## Hands-On Skills Required

### CLI Proficiency
- **vault login:** Authentication with various methods
- **vault kv:** KV secrets engine operations
- **vault secrets:** Enable and manage secrets engines
- **vault auth:** Enable and manage auth methods
- **vault policy:** Create and manage policies
- **vault token:** Token creation and management
- **vault lease:** Lease renewal and revocation

### Configuration
- **Policy writing in HCL**
- **Auth method configuration**
- **Secrets engine enablement and tuning**
- **Token creation with specific parameters**
- **Environment variable configuration (VAULT_ADDR, VAULT_TOKEN)**

## Study Tips

1. **Hands-On Practice:** Set up a Vault dev server and practice all operations
2. **CLI Focus:** The exam heavily tests CLI commands and flags
3. **Policy Writing:** Practice writing policies from scratch
4. **Dynamic Secrets:** Understand the lifecycle of dynamic credentials
5. **Seal/Unseal:** Thoroughly understand the unseal process and Shamir's Secret Sharing
6. **Token Types:** Know the differences between service, batch, root, and orphan tokens
7. **Auth Methods:** Understand when to use each authentication method
8. **Practice Exams:** Take official HashiCorp practice exams

## Comprehensive Study Resources

### Quick Links (Vault Associate Specific)
- **[Vault Associate Exam Page](https://www.hashicorp.com/certifications/vault-associate)** - Registration and exam details
- **[Vault Documentation](https://developer.hashicorp.com/vault/docs)** - Complete Vault documentation
- **[Vault Tutorials](https://developer.hashicorp.com/vault/tutorials)** - Official hands-on tutorials
- **[Vault Associate Study Guide](https://developer.hashicorp.com/vault/tutorials/associate-cert)** - Official study guide
- **[Vault API Documentation](https://developer.hashicorp.com/vault/api-docs)** - REST API reference

### Recommended Courses
- HashiCorp Learn Vault tutorials (free)
- Bryan Krausen - Vault Associate on Udemy
- KodeKloud - Vault for Beginners
- A Cloud Guru - HashiCorp Vault

### Practice Resources
- HashiCorp official practice exam
- Bryan Krausen practice tests on Udemy
- Vault dev server (free, no configuration required)
- Docker-based Vault lab environments

## Exam Registration

Register through:
- **PSI Online:** Online proctored exam via PSI
- **HashiCorp Certification Portal:** [hashicorp.com/certifications](https://www.hashicorp.com/certifications)

## Exam Day Preparation

### Technical Setup (Online Exam)
- Stable internet connection
- Webcam and microphone
- Clean, quiet workspace
- Valid government-issued ID
- PSI Secure Browser installed

### Exam Strategy
1. **Read questions carefully:** Pay attention to exact wording about methods, engines, and capabilities
2. **Eliminate wrong answers:** Use process of elimination
3. **Flag uncertain questions:** Review flagged questions at the end
4. **Time management:** ~1 minute per question with review time
5. **CLI knowledge:** Many questions test exact command syntax

### Common Question Types
- **Architecture questions:** Seal/unseal, storage backends, HA setup
- **Auth method questions:** Choosing the right method for a scenario
- **Policy questions:** Writing or interpreting policy HCL
- **CLI questions:** Exact command syntax and flags
- **Secrets engine questions:** Choosing the right engine for a use case

## Career Benefits

### Job Opportunities
- Security Engineer
- DevOps Engineer
- Platform Engineer
- Cloud Security Architect
- Site Reliability Engineer

### Professional Development
- Foundation for Vault Operations Professional certification
- Industry recognition for secrets management skills
- Demonstrates security-focused infrastructure knowledge
- Complements Terraform and Consul certifications

## Next Steps After Certification

### Advanced Certifications
- **Vault Operations Professional:** Advanced Vault administration
- **Terraform Associate:** Infrastructure as code
- **Consul Associate:** Service networking

### Continuous Learning
- Stay updated with new Vault features and secrets engines
- Practice with production-like Vault clusters
- Explore Vault Enterprise features (namespaces, Sentinel, replication)
- Integrate Vault with CI/CD pipelines and Kubernetes
