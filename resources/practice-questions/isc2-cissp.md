# ISC2 CISSP - Practice Questions

15 scenario-based questions across the 8 CISSP domains. CISSP rewards "manager / risk-owner" thinking - read questions for that mindset.

> **Cert page:** [exams/isc2/cissp/](../../exams/isc2/cissp/)

---

### Question 1 - Domain 1: Security and Risk Management
**Scenario:** A Chief Risk Officer asks for a risk treatment for a vulnerability with low likelihood but catastrophic impact. The vulnerability cannot be remediated for 6 months. What's the BEST treatment?

A. Accept the risk
B. Avoid the risk by retiring the affected system
C. Transfer the risk via cyber insurance for the interim
D. Mitigate by adding a compensating control

<details>
<summary>Answer</summary>

**Correct: D**

**Why:** "Catastrophic impact" makes acceptance and transfer alone too weak; even with insurance, business continuity matters. A **compensating control** (firewall rule, additional monitoring, manual review) reduces likelihood while remediation is in progress. Avoidance via retirement is too costly without business approval. CISSP favors layered defense.
</details>

---

### Question 2 - Domain 1
**Scenario:** What's the order of priorities in a Business Impact Analysis (BIA)?

A. Cost > Safety > Reputation > Compliance
B. Safety of life > Critical assets > Reputation > Cost
C. Compliance > Cost > Reputation > Safety
D. They're equal

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** **Safety of human life is always the top priority** in any security or BCP question. Critical business assets next, then reputation, then cost. CISSP repeatedly tests this - never pick "save money" over "save lives."
</details>

---

### Question 3 - Domain 2: Asset Security
**Scenario:** Personal Health Information (PHI) under HIPAA must be classified at what level minimum?

A. Public
B. Internal
C. Confidential / Restricted (highest standard tier the organization uses for sensitive data)
D. It depends on the organization's classification scheme

<details>
<summary>Answer</summary>

**Correct: D**

**Why:** Classification schemes vary by organization. Most have 3-4 tiers (Public, Internal, Confidential, Restricted). PHI must be at the highest sensitivity tier the org defines. The right answer recognizes that classification labels are organization-specific while the underlying control requirements (encryption, access controls, audit) are mandated by HIPAA.
</details>

---

### Question 4 - Domain 3: Security Architecture
**Scenario:** What's the primary purpose of a Trusted Platform Module (TPM)?

A. Network packet filtering
B. Storing cryptographic keys in tamper-resistant hardware tied to a specific machine
C. Application sandboxing
D. Providing physical security

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** TPM is a hardware chip that stores keys securely, supports remote attestation, and enables full-disk encryption (BitLocker, dm-crypt). The key benefit is **bound to a specific physical machine** - keys can't be exfiltrated to another machine.
</details>

---

### Question 5 - Domain 3
**Scenario:** A defense-in-depth strategy adds firewall, IDS, EDR, and email filtering. What concept does this exemplify?

A. Single point of failure
B. Layered controls / defense in depth
C. Reactive security
D. Compliance theater

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Layering different control types (network, host, email) so a single failure doesn't compromise the system. CISSP tests this concept repeatedly under names like "defense in depth," "layered controls," "diverse controls."
</details>

---

### Question 6 - Domain 4: Communication and Network Security
**Scenario:** Which TLS handshake step proves the server's identity to the client?

A. ClientHello with cipher suites
B. The server's certificate signed by a trusted CA
C. The pre-master secret exchange
D. Application data encryption

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Server identity is proven by the X.509 certificate signed by a CA the client trusts. The client validates the chain, the certificate's CN/SAN matches the hostname, and the cert isn't revoked or expired.
</details>

---

### Question 7 - Domain 5: Identity and Access Management
**Scenario:** Type 1, Type 2, Type 3 authentication factors - which is which?

A. Something you know / something you have / something you are
B. Username / password / biometric
C. Hardware / software / cloud
D. Required / recommended / optional

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** Memorize: **Type 1 = something you KNOW** (password, PIN), **Type 2 = something you HAVE** (token, smart card, phone), **Type 3 = something you ARE** (biometric). Multi-factor auth requires factors from at least **two different types** - not two of the same type.
</details>

---

### Question 8 - Domain 5
**Scenario:** A federated identity model with SAML - what does the Identity Provider (IdP) provide?

A. The application itself
B. Authentication assertions about a user (the IdP says "yes, this is alice@example.com")
C. Network access
D. Audit logs

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** In SAML federation, the IdP authenticates the user and sends a signed assertion to the Service Provider (SP / app). The SP trusts the assertion based on the IdP's signing certificate. OIDC works similarly with JWT tokens.
</details>

---

### Question 9 - Domain 6: Security Assessment and Testing
**Scenario:** A penetration test should be conducted with what authorization?

A. Implicit consent of management
B. Explicit, written authorization (rules of engagement document) from senior management
C. Verbal approval from the CISO
D. No authorization needed if internal

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Written authorization (often called "Rules of Engagement" or "Get Out of Jail Free Letter") is essential. Without it, pen testing is criminal trespass under CFAA (US) or equivalent. Specifies scope, timing, escalation contacts, and what's off-limits.
</details>

---

### Question 10 - Domain 7: Security Operations
**Scenario:** During incident response, what's the first phase per the standard 6-step process?

A. Identification
B. Preparation
C. Containment
D. Recovery

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Order: **Preparation → Identification → Containment → Eradication → Recovery → Lessons Learned**. Preparation (policies, runbooks, training) happens before any incident.
</details>

---

### Question 11 - Domain 7
**Scenario:** RAID 5 vs RAID 6 - the key difference?

A. RAID 5 has one parity disk; RAID 6 has two (tolerates two simultaneous disk failures)
B. RAID 5 is faster
C. RAID 6 uses encryption
D. They're the same

<details>
<summary>Answer</summary>

**Correct: A**

**Why:** RAID 5: striping with single parity (tolerates 1 failure). RAID 6: striping with double parity (tolerates 2 simultaneous failures, slower writes due to dual parity calculation). RAID 10 is mirrored stripes (fast, expensive).
</details>

---

### Question 12 - Domain 7
**Scenario:** RTO vs RPO?

A. RTO is recovery time objective; RPO is recovery point objective
B. RTO = how much data loss is acceptable; RPO = how long the outage can last
C. RTO = how long the outage can last; RPO = how much data loss is acceptable
D. Both A and C

<details>
<summary>Answer</summary>

**Correct: D**

**Why:** **RTO** = Recovery Time Objective = max acceptable outage duration. **RPO** = Recovery Point Objective = max acceptable data loss (measured backwards from incident). RTO of 4 hours + RPO of 1 hour means: bring the system back within 4 hours, lose at most 1 hour of data.
</details>

---

### Question 13 - Domain 8: Software Development Security
**Scenario:** SQL injection is mitigated primarily by:

A. Input validation alone
B. Parameterized queries (prepared statements) with bound parameters
C. Output encoding
D. Web Application Firewall

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** Parameterized queries are the **primary** defense. They separate SQL code from data so user input can't be interpreted as code. Input validation is defense-in-depth but not sufficient alone (encoding bypasses, edge cases). WAF helps but is reactive.
</details>

---

### Question 14 - Domain 8
**Scenario:** A code review finds a hardcoded API key in source. What's the BEST remediation?

A. Comment it out and ship
B. Rotate the key, store in a secret manager, fix the code, audit version control history for prior leaks, and rotate any other credentials that may have been compromised
C. Use environment variables instead
D. Encrypt the key in code

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** A hardcoded credential in version control is **already leaked** if the repo has multiple eyes. Rotate first, then move to secret manager, then sweep history (`git log -p` or BFG Repo-Cleaner), then audit related credentials. CISSP favors comprehensive remediation over narrow fixes.
</details>

---

### Question 15 - Cross-domain
**Scenario:** A company hires a third-party SaaS for HR data. From a security perspective, what document is MOST important?

A. NDA
B. SLA + SOC 2 Type II report + Data Processing Agreement (DPA)
C. Master Service Agreement
D. Insurance certificate

<details>
<summary>Answer</summary>

**Correct: B**

**Why:** SOC 2 Type II shows operational security controls work over time. SLA covers availability and breach notification timing. DPA (especially under GDPR/CCPA) defines data handling. NDA and MSA are baseline contractual but don't cover security operations.
</details>

---

## Scoring guide

- **13-15 correct:** Strong; schedule the exam.
- **10-12:** Re-read weak domains; CISSP is broad - know all 8 domains.
- **<10:** More foundational study needed.

CISSP exam: 100-150 adaptive questions, 3 hours. Pass rate ~70%. The mindset is **manager-level / risk-based**, not technical-implementation. When in doubt, pick the answer that prioritizes safety, business continuity, and the formal process.
