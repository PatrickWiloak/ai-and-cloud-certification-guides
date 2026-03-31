# HashiCorp Vault Associate (003) Study Plan

## 6-Week Intensive Study Schedule

### Phase 1: Foundation Building (Weeks 1-2)

#### Week 1: Vault Architecture and Core Concepts
**Focus:** Architecture, seal/unseal, storage backends, and basic operations

#### Day 1-2: Vault Architecture Fundamentals
- [ ] Study Vault architecture: barrier, storage, audit devices
- [ ] Understand the seal/unseal process and Shamir's Secret Sharing
- [ ] Learn about storage backends: Raft, Consul, S3
- [ ] Study high availability architecture (active/standby)
- [ ] **Lab:** Install Vault CLI and start a dev server (`vault server -dev`)

#### Day 3-4: Vault Initialization and Setup
- [ ] Practice `vault operator init` and `vault operator unseal`
- [ ] Understand root token generation and revocation
- [ ] Study auto-unseal with cloud KMS providers
- [ ] Learn Vault server configuration file structure
- [ ] **Practice:** Initialize Vault and practice the unseal process

#### Day 5-7: Authentication Methods Overview
- [ ] Study all authentication methods: token, userpass, LDAP, AppRole
- [ ] Understand human vs machine authentication patterns
- [ ] Learn AWS and Kubernetes auth methods
- [ ] Practice enabling and configuring auth methods
- [ ] **Lab:** Enable userpass and AppRole auth methods, authenticate with each

### Week 2: Secrets Engines and Policies

#### Day 1-2: KV Secrets Engine
- [ ] Study KV v1 vs v2 differences (versioning, soft delete, paths)
- [ ] Practice `vault kv put`, `get`, `delete`, `undelete`, `destroy`
- [ ] Understand metadata and version management in KV v2
- [ ] Learn check-and-set (cas) operations
- [ ] **Practice:** Create, read, update, and manage versioned secrets

#### Day 3-4: Dynamic Secrets Engines
- [ ] Study Database secrets engine: configuration, roles, dynamic creds
- [ ] Learn Transit secrets engine: encryption, decryption, key rotation
- [ ] Understand PKI secrets engine: CA setup, certificate generation
- [ ] Study AWS secrets engine: dynamic IAM credentials
- [ ] **Lab:** Configure database engine and generate dynamic credentials

#### Day 5-7: Vault Policies
- [ ] Study policy syntax: path, capabilities, deny
- [ ] Learn policy capabilities: create, read, update, delete, list, sudo, deny
- [ ] Practice writing policies for various access patterns
- [ ] Understand default and root built-in policies
- [ ] **Practice:** Write and test policies for different user roles

### Phase 2: Core Skills (Weeks 3-4)

#### Week 3: Tokens, Leases, and CLI Operations

#### Day 1-2: Vault Tokens Deep Dive
- [ ] Study service tokens vs batch tokens
- [ ] Understand root tokens: generation, usage, revocation
- [ ] Learn orphan tokens and token hierarchy
- [ ] Practice token creation with policies, TTLs, and use limits
- [ ] **Lab:** Create tokens with different types and properties

#### Day 3-4: Lease Management
- [ ] Study lease concepts: duration, TTL, renewal, revocation
- [ ] Practice lease renewal and revocation commands
- [ ] Understand lease lifecycle with dynamic secrets
- [ ] Learn prefix-based revocation
- [ ] **Practice:** Generate dynamic secrets and manage their leases

#### Day 5-7: CLI Mastery
- [ ] Practice all essential CLI commands for secrets operations
- [ ] Master auth method and secrets engine management commands
- [ ] Practice policy management via CLI
- [ ] Learn environment variables: VAULT_ADDR, VAULT_TOKEN, VAULT_FORMAT
- [ ] **Lab:** Complete a full workflow using only CLI commands

### Week 4: API, UI, and Advanced Topics

#### Day 1-2: Vault API
- [ ] Study API structure and authentication
- [ ] Practice reading and writing secrets via curl/API
- [ ] Understand sys/ endpoints for system management
- [ ] Learn health check and status endpoints
- [ ] **Practice:** Perform CRUD operations using the Vault API

#### Day 3-4: Vault UI and Integration
- [ ] Navigate Vault UI for secrets, auth, and policy management
- [ ] Study Vault integration with Kubernetes
- [ ] Understand Vault Agent for automatic authentication
- [ ] Learn response wrapping for secure secret delivery
- [ ] **Lab:** Use Vault UI to manage secrets and policies

#### Day 5-7: Advanced Authentication Patterns
- [ ] Deep dive into AppRole: Role ID, Secret ID, CIDR restrictions
- [ ] Study Kubernetes auth: service accounts, pod identity
- [ ] Practice multi-factor authentication configuration
- [ ] Understand identity system: entities, aliases, groups
- [ ] **Practice:** Configure AppRole with production-like settings

### Phase 3: Exam Preparation (Weeks 5-6)

#### Week 5: Deep Dive and Practice

#### Day 1-2: Review High-Weight Domains
- [ ] Review secrets engines (20%) - focus on engine selection scenarios
- [ ] Review auth methods (15%) - know when to use each
- [ ] Review policies (15%) - practice writing from memory
- [ ] Review CLI (15%) - test yourself on command syntax
- [ ] **Practice:** Quiz yourself on each domain

#### Day 3-4: Hands-On Review
- [ ] Complete end-to-end Vault setup from scratch
- [ ] Configure multiple auth methods and secrets engines
- [ ] Write policies and test access control
- [ ] Practice token lifecycle management
- [ ] **Lab:** Build a production-like Vault configuration

#### Day 5-7: Practice Exam Round 1
- [ ] Take HashiCorp official practice exam
- [ ] Review all incorrect answers thoroughly
- [ ] Identify knowledge gaps by domain
- [ ] Re-study weak areas with focused attention
- [ ] **Review:** Create summary notes for weak areas

### Week 6: Final Review and Exam

#### Day 1-2: Gap Analysis and Review
- [ ] Review seal/unseal process and architecture (10%)
- [ ] Review token types and lifecycle (10%)
- [ ] Practice CLI commands for edge cases
- [ ] Review dynamic vs static secrets comparison
- [ ] **Practice:** Write policies from memory, test CLI commands

#### Day 3-4: Practice Exam Round 2
- [ ] Take second practice exam
- [ ] Target 80%+ score before scheduling real exam
- [ ] Review flagged questions and common traps
- [ ] Focus on exact command syntax and flag names
- [ ] **Review:** Final review of fact sheet and key concepts

#### Day 5: Exam Day Preparation
- [ ] Light review of key concepts only
- [ ] Review auth method selection criteria
- [ ] Review KV v1 vs v2 differences
- [ ] Review policy capabilities table
- [ ] Verify PSI system requirements and test connection
- [ ] **Prepare:** Set up quiet workspace, check ID, ensure stable internet

#### Day 6-7: Exam and Post-Exam
- [ ] Take the exam
- [ ] Document questions you were unsure about
- [ ] If needed, plan retake strategy based on score report
- [ ] Celebrate your achievement

## Daily Study Routine

### Recommended Schedule (1.5-2 hours per day)
1. **Review (15 min):** Review previous day's notes
2. **Study (45 min):** New topic reading and documentation
3. **Practice (30 min):** Hands-on lab work with Vault dev server
4. **Quiz (15 min):** Self-assessment questions

## Key Milestones

- [ ] **Week 1:** Can explain architecture, unseal process, enable auth methods
- [ ] **Week 2:** Can manage KV secrets, understand dynamic secrets, write policies
- [ ] **Week 3:** Can manage tokens and leases, proficient with CLI
- [ ] **Week 4:** Can use API, understand advanced auth patterns
- [ ] **Week 5:** Score 70%+ on first practice exam
- [ ] **Week 6:** Score 80%+ on practice exam, pass certification
