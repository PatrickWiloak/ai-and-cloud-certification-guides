# CCSP Fact Sheet

## Exam Logistics

| Item | Detail |
|------|--------|
| Exam Code | CCSP |
| Format | Linear, fixed-form |
| Duration | 3 hours |
| Question Count | 150 |
| Passing Score | 700 / 1000 (scaled) |
| Cost (USD) | $599 |
| Languages | English, Japanese, Chinese (Simplified), Korean, German |
| Delivery | Pearson VUE only |
| Retake Wait | 30/60/90 days; max 4 attempts in 12 months |
| Validity | 3 years |
| Maintenance | 90 CPE / 3 years (30 CPE/yr min, 60 Group A) + $135/yr AMF |

## Domain Weights

| Domain | Weight |
|--------|--------|
| 1. Cloud Concepts, Architecture, and Design | 17% |
| 2. Cloud Data Security | 20% |
| 3. Cloud Platform and Infrastructure Security | 17% |
| 4. Cloud Application Security | 17% |
| 5. Cloud Security Operations | 16% |
| 6. Legal, Risk, and Compliance | 13% |

## Eligibility

| Path | Requirement |
|------|-------------|
| Standard | 5 years IT experience including 3 years infosec and 1 year in any of the 6 CCSP CBK domains |
| CISSP holder | CISSP substitutes for entire CCSP experience requirement |
| CCSK holder | CCSK substitutes for the 1 year in CCSP CBK domain experience |
| Associate of ISC2 | Pass without experience; 6 years to fulfill |

## NIST SP 800-145 Cloud Definition

### Five essential characteristics
1. On-demand self-service
2. Broad network access
3. Resource pooling (multi-tenant)
4. Rapid elasticity
5. Measured service

### Three service models
| Model | Customer Manages | Provider Manages |
|-------|------------------|------------------|
| IaaS | OS, runtime, middleware, apps, data | Virtualization, hardware, network, facility |
| PaaS | Apps, data, configuration | OS, runtime, middleware, hardware, virt, network, facility |
| SaaS | Data, identity, configuration | Everything except customer data and identity |

### Four deployment models
- **Public** - shared multi-tenant, owned by provider
- **Private** - single org (on-prem or hosted)
- **Community** - shared by orgs with common requirements
- **Hybrid** - combination with portability between

### Add-ons (NIST and beyond)
- Multi-cloud
- Edge computing
- FaaS / serverless
- DBaaS, MBaaS, FaaS, NaaS, IDaaS

## Cloud Security Frameworks

| Framework | Source | Purpose |
|-----------|--------|---------|
| Cloud Controls Matrix (CCM) v4 | CSA | 197 controls across 17 domains |
| CAIQ (Consensus Assessments Initiative Questionnaire) | CSA | Standardized vendor questionnaire |
| Security Guidance v5 | CSA | Foundational cloud security guidance |
| STAR Registry | CSA | CSP self-assessment / third-party attestation registry |
| ISO/IEC 27017 | ISO | Cloud-specific 27002 controls |
| ISO/IEC 27018 | ISO | PII protection in public clouds |
| ISO/IEC 27701 | ISO | Privacy management on top of 27001/27002 |
| ISO/IEC 17788 | ISO | Cloud vocabulary |
| ISO/IEC 17789 | ISO | Cloud reference architecture |
| ISO/IEC 19944 | ISO | Cross-cutting cloud information flow |
| FedRAMP | US Gov | US federal cloud authorization |
| BSI C5 | German Federal Office for Info Sec | German cloud assurance |
| StateRAMP | US States | State government version of FedRAMP |
| MTCS (Singapore) | IMDA | Multi-tier cloud security |
| ENS (Spain) | Spanish gov | Esquema Nacional de Seguridad |

## Cloud Reference Architecture (ISO/IEC 17789)

Roles:
- Cloud Service Customer (CSC)
- Cloud Service Provider (CSP)
- Cloud Service Partner (CSN) - broker, auditor, integrator
- Cloud Service Broker (CSB)
- Cloud Auditor

Cross-cutting aspects:
- Auditability
- Availability
- Governance
- Interoperability
- Maintenance and versioning
- Performance
- Portability
- Protection of PII
- Regulatory
- Resiliency
- Reversibility (the ability to terminate and recover data)
- Security
- Service levels and SLA
- Service-oriented architecture

## Cloud Data Lifecycle

1. **Create** - Generated or modified
2. **Store** - Saved to storage
3. **Use** - Processed
4. **Share** - Made accessible to others
5. **Archive** - Long-term retention
6. **Destroy** - Permanent removal

Each phase has different threats, controls, and compliance considerations.

## Cloud Storage Types (per service model)

### IaaS storage
- Volume / block (e.g., AWS EBS, Azure Managed Disks, GCP Persistent Disk)
- Object (e.g., AWS S3, Azure Blob, GCP Cloud Storage)
- File / NAS (e.g., AWS EFS, Azure Files, GCP Filestore)

### PaaS storage
- Database storage (managed RDBMS, NoSQL)
- Caching (Redis, Memcached)
- Message queues / streams

### SaaS storage
- Application-defined (CRM records, file shares within SaaS)

## Encryption Approaches

| Approach | Key Holder | Use Case |
|----------|-----------|----------|
| Provider-managed (SSE-S3, default) | Provider | Default; simplest |
| Customer-managed key in provider KMS (SSE-KMS, BYOK) | Customer (with provider KMS) | Most common; control with provider integration |
| Customer-supplied key (SSE-C) | Customer | Provider does not store key; customer provides per request |
| External / hold-your-own-key (HYOK) | Customer's external KMS | Highest control; cloud cannot decrypt without external system |
| Confidential computing | Customer (in TEE) | Sensitive computation in trusted execution environment |

## Privacy Regulations Recap

- **GDPR** - EU; data subject rights; 72-hour breach notification
- **CCPA / CPRA** - California; consumer rights, opt-out of sale
- **HIPAA** - US health; PHI; BAA required
- **GLBA** - US financial
- **SOX** - US public companies
- **PCI DSS** - Payment cards (contractual)
- **PIPEDA** - Canada
- **LGPD** - Brazil
- **POPIA** - South Africa
- **APPI** - Japan
- **PIPL** - China; data localization for some categories

## Cloud-Specific Threats (CSA Top Threats)

The CSA "Top Threats to Cloud Computing" report (latest: "Pandemic 11" / refreshed annually):

1. Insufficient identity, credential, access, and key management
2. Insecure interfaces and APIs
3. Misconfiguration and inadequate change control
4. Lack of cloud security architecture and strategy
5. Insecure software development
6. Unsecured third-party resources
7. System vulnerabilities
8. Accidental cloud data disclosure
9. Misconfiguration of serverless and container workloads
10. Organized crime / hackers / APT
11. Cloud storage data exfiltration

## Recovery Site Mapping in Cloud

| Pattern | Cloud Equivalent |
|---------|------------------|
| Cold | Backup-only restore (RTO hours-days) |
| Pilot light | Minimal services running, scale up on disaster (RTO 10-30 min) |
| Warm standby | Reduced-capacity always-on, scale up (RTO mins) |
| Hot / multi-site active-active | Geo-redundant active-active (RTO seconds, near-zero RPO) |

## Audit Considerations in Cloud

- Limited customer access to provider's underlying infrastructure
- Reliance on provider attestations (SOC 2, ISO 27001, FedRAMP)
- Right to audit clauses often replaced with right to receive audit reports
- Independent audit reports validate provider controls
- Customer audit scope: customer-controlled configuration, data, access

## SOC Reports for Cloud

- **SOC 1 Type 2** - financial reporting controls (rarely needed for cloud security)
- **SOC 2 Type 2** - Trust Services Criteria (Security mandatory; Availability, Processing Integrity, Confidentiality, Privacy optional); the gold standard
- **SOC 3** - public summary

## CSA STAR Levels

- **Level 1: Self-Assessment** - Free; CAIQ submitted to STAR Registry
- **Level 2: Third-Party Audit** - STAR Attestation (SOC 2 + CCM) or STAR Certification (ISO 27001 + CCM)
- **Level 3: Continuous Auditing** - In development

## Common Cloud Service Provider Certifications

Major providers maintain attestations for: SOC 2, ISO 27001/27017/27018/27701, PCI DSS, FedRAMP (multiple impact levels), HIPAA-eligibility, FIPS 140-2/3 modules, EU regional certifications.

## Documentation Links

- **CSA Guidance v5:** https://cloudsecurityalliance.org/research/guidance
- **CCM v4:** https://cloudsecurityalliance.org/research/cloud-controls-matrix
- **NIST SP 800-145:** https://csrc.nist.gov/publications/detail/sp/800-145/final
- **ISO 27017/27018:** https://www.iso.org/standard/43757.html
- **CCSP exam outline:** https://www.isc2.org/certifications/ccsp/ccsp-exam-outline

## CPE Categories (CCSP)

- **Group A** (security-related): minimum 60 CPEs over 3 years
- **Group B** (professional development): up to 30 CPEs

Earned via training, conferences, podcasts, books, articles, teaching, volunteering. Webinars from CSA, ISC2 events, vendor security trainings all qualify.
