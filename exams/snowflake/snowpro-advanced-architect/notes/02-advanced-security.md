# Advanced Security

**[📖 Security Overview](https://docs.snowflake.com/en/user-guide/security)** - Complete security documentation

## Overview

This document covers advanced security features in Snowflake including network security, encryption architecture, data governance, and compliance. These topics are heavily weighted in the Advanced Architect exam and require understanding of edition-specific feature availability.

## Network Security

### Network Policies
- IP-based access control at the account or user level
- Allowlist and blocklist for IPv4 addresses and CIDR ranges
- Account-level policies apply to all users unless overridden
- User-level policies override account-level policies for specific users
- Multiple network policies can exist but only one is active per level

**[📖 Network Policies](https://docs.snowflake.com/en/user-guide/network-policies)** - IP-based access control

```sql
-- Create network policy
CREATE NETWORK POLICY corp_network
  ALLOWED_IP_LIST = ('10.0.0.0/8', '172.16.0.0/12')
  BLOCKED_IP_LIST = ('10.0.0.99');

-- Apply to account
ALTER ACCOUNT SET NETWORK_POLICY = corp_network;

-- Apply to specific user (overrides account policy)
ALTER USER analyst_user SET NETWORK_POLICY = analyst_policy;

-- View active policies
SELECT * FROM TABLE(INFORMATION_SCHEMA.POLICY_REFERENCES());
```

### Private Connectivity

#### AWS PrivateLink
- Creates a private endpoint in customer VPC to reach Snowflake
- Traffic stays on AWS backbone - never traverses public internet
- Requires Business Critical edition or higher
- Separate endpoints for Snowflake service and internal stages
- Customer configures VPC endpoint, Snowflake authorizes the connection

**[📖 AWS PrivateLink](https://docs.snowflake.com/en/user-guide/admin-security-privatelink)** - AWS private connectivity

#### Azure Private Link
- Private endpoint in customer VNet connecting to Snowflake
- Similar architecture to AWS PrivateLink
- Requires Business Critical edition or higher
- Managed through Azure portal and Snowflake configuration

**[📖 Azure Private Link](https://docs.snowflake.com/en/user-guide/privatelink-azure)** - Azure private connectivity

#### GCP Private Service Connect
- Google Cloud's private connectivity mechanism for Snowflake
- Service attachment model for private access
- Requires Business Critical edition or higher
- Configured through GCP console and Snowflake

**[📖 GCP Private Service Connect](https://docs.snowflake.com/en/user-guide/private-service-connect)** - GCP private connectivity

### Network Security Best Practices
- Combine network policies with Private Link for defense in depth
- Use account-level policies as baseline, user-level for exceptions
- Test policies thoroughly before applying to production accounts
- Monitor blocked connection attempts via LOGIN_HISTORY
- Document all allowed IP ranges and review periodically

## Encryption Architecture

### Encryption at Rest
- All data encrypted using AES-256 encryption
- Hierarchical key model: root key > account key > table key > file key
- Each micro-partition encrypted with its own file key
- Keys managed by Snowflake's internal key management service
- Automatic key rotation every 30 days (Snowflake-managed)

**[📖 End-to-End Encryption](https://docs.snowflake.com/en/user-guide/security-encryption)** - Encryption details

### Encryption in Transit
- All connections use TLS 1.2 minimum
- Certificate validation required for all client connections
- Internal Snowflake communication encrypted between layers
- Data transfer between storage and compute encrypted

### Key Hierarchy
```
Root Key (HSM-protected)
  └── Account Master Key
        └── Table Master Key
              └── File Encryption Key (per micro-partition)
```

### Automatic Key Rotation
- Snowflake rotates encryption keys every 30 days automatically
- New data encrypted with new keys immediately
- Existing data periodically rekeyed with new keys (rekeying)
- Rekeying is transparent and does not impact queries
- Enterprise edition and above support periodic rekeying

**[📖 Key Rotation](https://docs.snowflake.com/en/user-guide/security-encryption-manage)** - Key management

### Tri-Secret Secure
- Composite master key from Snowflake key + customer-managed key
- Customer maintains key in their cloud provider's KMS
- Both keys required to decrypt data - either party can revoke access
- Customer can disable their KMS key to immediately cut off access
- Requires Business Critical edition or higher

**[📖 Tri-Secret Secure](https://docs.snowflake.com/en/user-guide/security-encryption-manage)** - Customer-managed keys

#### Supported KMS Providers
| Cloud Provider | KMS Service | Configuration |
|---------------|------------|---------------|
| AWS | AWS KMS | Customer-managed CMK |
| Azure | Azure Key Vault | Customer-managed key |
| GCP | Cloud KMS | Customer-managed key |

#### Configuration Flow
1. Customer creates key in their cloud provider KMS
2. Customer grants Snowflake access to the key (IAM policy / access policy)
3. Snowflake uses customer key alongside its own key to create composite master key
4. All data encryption uses the composite key
5. Customer can revoke access by disabling or deleting their KMS key

## Data Governance

### Dynamic Data Masking
- Column-level security that transforms data at query time
- Policy applied to columns, evaluated per query based on context
- Uses CURRENT_ROLE(), CURRENT_USER(), or other context functions
- Multiple masking policies can exist but only one per column at a time
- Masking is transparent to applications - no query changes needed

**[📖 Dynamic Data Masking](https://docs.snowflake.com/en/user-guide/security-column-ddm-intro)** - Column masking

```sql
-- Create masking policy for email addresses
CREATE MASKING POLICY email_mask AS (val STRING) RETURNS STRING ->
  CASE
    WHEN CURRENT_ROLE() IN ('DATA_ENGINEER', 'ADMIN') THEN val
    WHEN CURRENT_ROLE() = 'ANALYST' THEN REGEXP_REPLACE(val, '.+@', '***@')
    ELSE '********'
  END;

-- Apply to column
ALTER TABLE customers MODIFY COLUMN email SET MASKING POLICY email_mask;

-- View applied policies
SELECT * FROM TABLE(INFORMATION_SCHEMA.POLICY_REFERENCES(
  REF_ENTITY_NAME => 'customers',
  REF_ENTITY_DOMAIN => 'TABLE'
));
```

### External Tokenization
- Integrates with external tokenization services (e.g., Protegrity, Voltage)
- External functions call tokenization service during masking
- Tokenized values stored in Snowflake, detokenized on query
- Useful for PCI DSS compliance where tokens must be reversible
- Requires external function and API integration setup

**[📖 External Tokenization](https://docs.snowflake.com/en/user-guide/security-column-ext-token)** - Tokenization integration

### Row Access Policies
- Row-level security that filters rows at query time
- Policy returns BOOLEAN - true means row is visible
- Applied per table, evaluated automatically for all queries
- Can use mapping tables for complex access rules
- Policies are enforced even for account admins (unless exempted)

**[📖 Row Access Policies](https://docs.snowflake.com/en/user-guide/security-row-intro)** - Row-level security

```sql
-- Simple role-based row access
CREATE ROW ACCESS POLICY region_access AS (region VARCHAR) RETURNS BOOLEAN ->
  CURRENT_ROLE() = 'ADMIN'
  OR region IN (SELECT allowed_region FROM access_mapping
                WHERE role_name = CURRENT_ROLE());

-- Apply to table
ALTER TABLE sales ADD ROW ACCESS POLICY region_access ON (region);

-- Mapping table approach for scalable access control
CREATE TABLE access_mapping (
  role_name VARCHAR,
  allowed_region VARCHAR
);
INSERT INTO access_mapping VALUES
  ('US_ANALYST', 'US'),
  ('EU_ANALYST', 'EU'),
  ('APAC_ANALYST', 'APAC');
```

### Object Tagging
- Metadata tags for classification and governance
- Tag objects at any level: account, database, schema, table, column
- Tags can have allowed values for consistency
- Tag lineage - column tags inherited from table tags
- Integrate with masking policies via tag-based masking

**[📖 Object Tagging](https://docs.snowflake.com/en/user-guide/object-tagging)** - Tag-based governance

```sql
-- Create tags
CREATE TAG data_classification ALLOWED_VALUES 'PUBLIC', 'INTERNAL', 'CONFIDENTIAL', 'RESTRICTED';
CREATE TAG pii_type ALLOWED_VALUES 'NAME', 'EMAIL', 'SSN', 'PHONE', 'ADDRESS';

-- Apply tags to objects
ALTER TABLE customers SET TAG data_classification = 'CONFIDENTIAL';
ALTER TABLE customers MODIFY COLUMN ssn SET TAG pii_type = 'SSN';
ALTER TABLE customers MODIFY COLUMN email SET TAG pii_type = 'EMAIL';

-- Tag-based masking: apply masking policy to all columns with a specific tag
ALTER TAG pii_type SET MASKING POLICY pii_mask;
```

### Tag-Based Masking
- Associate masking policies with tags instead of individual columns
- Any column with the tag automatically gets the masking policy
- Scales governance across thousands of columns
- Single point of management for masking rules
- Tag-level policy overridden by column-level policy if both exist

## Access Control

### Role Hierarchy Design
```
ACCOUNTADMIN
  ├── SECURITYADMIN
  │     └── USERADMIN
  ├── SYSADMIN
  │     ├── DATA_ENGINEER
  │     ├── ANALYST
  │     └── APP_SERVICE
  └── PUBLIC
```

- ACCOUNTADMIN: top-level role, manages account settings
- SECURITYADMIN: manages grants and roles (owns USERADMIN)
- SYSADMIN: manages databases, warehouses, and data objects
- Custom roles should be granted to SYSADMIN (not ACCOUNTADMIN)
- Principle of least privilege: grant minimum required permissions

**[📖 Access Control](https://docs.snowflake.com/en/user-guide/security-access-control)** - RBAC documentation

### SCIM Provisioning
- System for Cross-domain Identity Management
- Automated user and group provisioning from identity providers
- Supported: Okta, Azure AD, custom SCIM clients
- Users and roles synchronized automatically
- Deprovisioned users automatically disabled in Snowflake

**[📖 SCIM](https://docs.snowflake.com/en/user-guide/admin-security-fed-auth-use-scim)** - SCIM integration

## Compliance and Editions

### Edition Feature Matrix
| Feature | Standard | Enterprise | Business Critical | VPS |
|---------|----------|-----------|-------------------|-----|
| Network Policies | Yes | Yes | Yes | Yes |
| Dynamic Masking | No | Yes | Yes | Yes |
| Row Access Policies | No | Yes | Yes | Yes |
| Object Tagging | No | Yes | Yes | Yes |
| Private Link | No | No | Yes | Yes |
| Tri-Secret Secure | No | No | Yes | Yes |
| HIPAA/PCI Support | No | No | Yes | Yes |
| Dedicated Infrastructure | No | No | No | Yes |

### Compliance Certifications
- SOC 1 Type II, SOC 2 Type II
- HIPAA (Business Critical edition)
- PCI DSS (Business Critical edition)
- FedRAMP Moderate (specific regions)
- HITRUST CSF
- ISO 27001

**[📖 Compliance](https://docs.snowflake.com/en/user-guide/security-compliance)** - Compliance documentation
