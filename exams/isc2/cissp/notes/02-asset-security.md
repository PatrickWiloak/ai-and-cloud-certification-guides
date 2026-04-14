# 02 - Asset Security (Domain 2, 10%)

## Domain Overview

Domain 2 covers the lifecycle of information and physical assets: identifying what you have, classifying it, protecting it through its lifecycle, and disposing of it securely. It is the smallest CISSP domain by weight but creates the foundation for many controls in later domains.

## Asset Classification

Classification matches the level of protection to the sensitivity of the asset, enabling proportional control investment.

### Government Classification (US)
| Level | Description |
|-------|-------------|
| Top Secret | Exceptionally grave damage to national security |
| Secret | Serious damage |
| Confidential | Damage |
| Controlled Unclassified Information (CUI) | Sensitive but not classified |
| Unclassified | Public release allowed |

### Commercial Classification (typical)
| Level | Description |
|-------|-------------|
| Highly Confidential / Restricted | Severe damage if disclosed (trade secrets, M&A, executive comp) |
| Confidential | Significant harm if disclosed (PII, financials, customer data) |
| Internal Use Only | Minor harm if disclosed |
| Public | No restriction |

Classification levels must:
- Be based on impact of disclosure, modification, or destruction (CIA)
- Have associated handling rules
- Be reviewed periodically (data classification can change as data ages)

### Classification process
1. Identify the asset
2. Determine the value (qualitative or quantitative)
3. Assess impact of compromise across CIA
4. Assign classification level
5. Apply handling controls
6. Periodically review

## Information Lifecycle

The data lifecycle (sometimes called the data security lifecycle):

1. **Create** - Generation of data
2. **Store** - At rest in storage media
3. **Use** - In memory, processed by applications
4. **Share** - Transmitted to other parties
5. **Archive** - Long-term retention
6. **Destroy** - End of useful life

Each phase has different threats and controls. A common exam mistake: applying only "at rest" encryption when the question covers data in transit or in use.

## Data States

| State | Threats | Controls |
|-------|---------|----------|
| At rest | Unauthorized access to storage | Storage encryption, access controls, physical security |
| In transit | Interception, MITM | TLS, IPsec, signed transport, network segmentation |
| In use | Memory scraping, side-channel | Process isolation, secure enclaves (SGX, AMD SEV), runtime memory encryption, application controls |

## Data Roles

| Role | Responsibility |
|------|----------------|
| Data Owner | Senior business role; accountable for classification, access decisions, ultimate responsibility |
| Data Steward | Day-to-day quality, lineage, metadata |
| Data Custodian | IT/operations; implements technical controls (backups, encryption) |
| Data Processor | (GDPR term) Processes data on behalf of controller |
| Data Controller | (GDPR term) Determines purposes and means of processing |
| Data Subject | (GDPR term) The natural person the data refers to |
| Data User | Consumes data within authorized scope |

The data owner is the business; the custodian is IT. Common exam trap: confusing owner (decisions) with custodian (implementation).

## Provisioning Resources

### Asset inventory
- Hardware, software, virtual machines, cloud resources, data stores
- Maintained continuously (CMDB, ITAM tools)
- Includes ownership, classification, lifecycle status

### Configuration baselines
- Hardened baseline images for OS, middleware, application
- CIS Benchmarks, DISA STIGs, vendor security guides as starting points
- Tracked in CMDB; deviations require approval

### Provisioning vs decommissioning
- Provisioning: secure-by-default, baseline applied, identities and access scoped
- Decommissioning: data sanitization, asset disposition (destroy, sell, donate), license return, asset record retired

## Data Sanitization (NIST SP 800-88)

| Method | Description | Reuse Possible? |
|--------|-------------|-----------------|
| Clearing | Logical sanitization (overwrite, factory reset) | Yes, within organization |
| Purging | Stronger; secure erase commands, cryptographic erase, degauss for magnetic | Yes, may transfer outside |
| Destroying | Physical destruction (shred, pulverize, incinerate, melt) | No |

Choose method based on:
- Storage type (SSD, HDD, optical, tape, mobile)
- Sensitivity of data
- Reuse intent

For SSDs, overwriting is unreliable due to wear leveling; cryptographic erase or physical destruction preferred.

For magnetic tapes/disks, degaussing only works if the media is magnetic. SSDs are not magnetic and degaussing is ineffective.

## Asset Retention

- Driven by legal, regulatory, contractual, and business requirements
- Should NOT exceed retention requirements (privacy and storage cost)
- Retention schedules document specific retention periods per data type
- Legal holds suspend normal retention

End-of-life (EOL) and end-of-support (EOS):
- Software EOL: vendor stops adding features
- Software EOS: vendor stops issuing patches (security risk)
- Hardware EOL: replacement parts unavailable
- Plan refresh cycles to avoid running unsupported assets

## Privacy Concepts

### PII (Personally Identifiable Information)
Information that identifies a specific person directly or in combination with other data. Categories:
- Direct identifiers: name, SSN, driver's license, passport, email
- Indirect identifiers: ZIP, DOB, gender (often re-identifiable in combination)
- Sensitive PII: health, financial, biometric, genetic, sexual orientation, religion, immigration

### PHI (Protected Health Information)
HIPAA term for health information identifiable to an individual. 18 HIPAA identifiers must be removed for de-identification (or expert determination).

### NPI (Non-Public Information)
GLBA term for personally identifiable financial information.

### Data subject rights (GDPR-style)
- Access (DSAR)
- Rectification
- Erasure ("right to be forgotten")
- Restriction of processing
- Data portability
- Object
- Not be subject to automated decision-making

### Data minimization
Collect only what you need; retain only as long as needed; restrict to authorized purpose. Required by GDPR and many other regimes.

### Privacy impact assessment (PIA)
Process to evaluate privacy risks before launching new systems or data processing. GDPR's DPIA is similar but mandatory for high-risk processing.

## Cross-Border Data Transfer

GDPR restricts transfer of EU personal data outside the EEA to:
- Adequacy decision countries (e.g., UK post-Brexit, Japan, Switzerland)
- Standard Contractual Clauses (SCCs) with appropriate safeguards
- Binding Corporate Rules (BCRs) for intra-group transfers
- Specific derogations (consent, contract necessity)

Schrems II invalidated Privacy Shield (US transfers); EU-US Data Privacy Framework restored a similar mechanism.

## Data Security Controls

### Technical
- Encryption at rest (TDE, FDE, file-level)
- Encryption in transit (TLS, IPsec)
- Access controls (RBAC, ABAC)
- Data Loss Prevention (DLP) at endpoint, network, cloud
- Tokenization (replace sensitive value with non-sensitive token)
- Anonymization (irreversible)
- Pseudonymization (reversible with key, GDPR-recognized)
- Data masking (visual obfuscation)
- Digital Rights Management (DRM)

### Administrative
- Classification policy
- Handling standards
- Acceptable use policy
- Data sharing agreements
- Privacy notices

### Physical
- Locked storage
- Secure disposal bins
- Visitor policies
- Environmental controls

## Data Loss Prevention (DLP)

DLP types:
- **Network DLP** - Inspects traffic at egress
- **Endpoint DLP** - Inspects activity on devices (clipboard, USB, print, screenshot)
- **Cloud DLP** - Inspects content in SaaS/IaaS (M365 Purview, Google Cloud DLP)
- **Storage/discovery DLP** - Scans repositories at rest

DLP requires:
- Sensitive data definitions (regex, dictionaries, fingerprinting, ML classifiers)
- Policies (block, alert, encrypt, redact)
- User education (false positives drive workarounds)

## Information Rights Management (IRM) / Digital Rights Management (DRM)

Persistent encryption with policy enforcement that travels with the file:
- Read-only, no copy, no print, expiration
- Examples: Microsoft Purview Information Protection (sensitivity labels), Adobe LiveCycle, Vera

## Tokenization vs Encryption vs Hashing

| Technique | Reversible? | Use Case |
|-----------|-------------|----------|
| Encryption | Yes (with key) | Confidentiality, must access original |
| Tokenization | Yes (via token vault) | Replace sensitive value while preserving format (PCI DSS scope reduction) |
| Hashing | No | Verify integrity, store passwords (with salt) |
| Anonymization | No | Allow analytics without privacy risk |
| Pseudonymization | Yes (with key) | Privacy-preserving while retaining linkability |

## Common Exam Pitfalls

- Confusing data owner (business) with custodian (IT)
- Choosing degaussing for SSDs (does not work)
- Assuming retention longer is better (over-retention is a violation)
- Forgetting in-use data state
- Over-relying on encryption when access control is the root issue
- Confusing tokenization with encryption
- Mixing GDPR controller and processor responsibilities

## Quick Reference Tables

### Sanitization choice
| Asset | Reuse internal | Transfer external | Discard |
|-------|---------------|-------------------|---------|
| HDD | Clear | Purge | Destroy |
| SSD | Crypto erase | Crypto erase + verify | Destroy |
| Optical | N/A | N/A | Destroy (shred) |
| Tape | Clear | Degauss/Purge | Degauss + destroy |
| Mobile device | Factory reset (BLE/data clear) | Crypto erase + factory | Destroy |
| Paper | N/A | N/A | Cross-cut shred or burn |

### Classification triggers
- Aggregation (combining low-sens to derive high-sens)
- Inference (deducing sensitive value from non-sensitive)
- Repurposing (using data for new purposes may require reclassification)
