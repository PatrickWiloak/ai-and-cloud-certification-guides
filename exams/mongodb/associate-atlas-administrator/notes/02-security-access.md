# Security and Access Control

**[📖 Atlas Security](https://www.mongodb.com/docs/atlas/security/)** - Security documentation
**[📖 Atlas Access Management](https://www.mongodb.com/docs/atlas/access/)** - Access control guide

## Network Security

### IP Access List

**[📖 IP Access List](https://www.mongodb.com/docs/atlas/security/ip-access-list/)** - IP allowlist configuration

- Required for all cluster connections (even with private endpoints)
- Specify individual IP addresses or CIDR ranges
- `0.0.0.0/0` allows access from anywhere (not recommended for production)
- Temporary access entries with expiration time
- Separate from API key access lists

**Configuration:**
```bash
# Add IP via Atlas CLI
atlas accessLists create --currentIp
atlas accessLists create 203.0.113.0/24 --comment "Office network"

# List access entries
atlas accessLists list
```

### VPC Peering

**[📖 VPC Peering](https://www.mongodb.com/docs/atlas/security-vpc-peering/)** - VPC peering setup

**How It Works:**
- Creates a private network connection between Atlas VPC and your VPC
- Traffic stays within the cloud provider's network
- No data traverses the public internet
- Requires route table configuration in both VPCs
- CIDR ranges must not overlap

**Provider-Specific:**

| Provider | Atlas Network | Your Network | Peering Type |
|----------|--------------|--------------|-------------|
| AWS | Atlas VPC | Your VPC | VPC Peering |
| Azure | Atlas VNet | Your VNet | VNet Peering |
| GCP | Atlas VPC | Your VPC | VPC Peering |

**Limitations:**
- Must be in same region (AWS) or can be cross-region (Azure, GCP)
- CIDR range conflicts prevent peering
- Limited number of peering connections per project
- Requires M10+ tier

### Private Endpoints

**[📖 Private Endpoints](https://www.mongodb.com/docs/atlas/security-private-endpoint/)** - Private endpoint configuration

**AWS PrivateLink:**
- Create an interface VPC endpoint in your VPC
- Atlas creates an endpoint service
- Traffic uses AWS private network
- No CIDR overlap concerns
- No route table changes needed

**Azure Private Link:**
- Create a private endpoint in your VNet
- Atlas creates a private link service
- Traffic stays within Azure backbone

**GCP Private Service Connect:**
- Create a forwarding rule in your VPC
- Atlas creates a service attachment
- Traffic stays within GCP network

**VPC Peering vs Private Endpoints:**

| Feature | VPC Peering | Private Endpoints |
|---------|-------------|-------------------|
| CIDR overlap | Must not overlap | No concern |
| Route tables | Manual configuration | Automatic |
| Direction | Bidirectional | Unidirectional (to Atlas) |
| Cross-region | Limited | Supported |
| Security | Network-level | Endpoint-level |
| Complexity | Moderate | Lower |
| Cost | No additional | Endpoint charges apply |

## Database Users

**[📖 Database Users](https://www.mongodb.com/docs/atlas/security-add-mongodb-users/)** - User management

### Authentication Methods

**SCRAM (Default):**
- Username and password authentication
- SCRAM-SHA-256 mechanism
- Simplest to set up
- Credentials stored in Atlas

**x.509 Certificates:**
- Certificate-based authentication
- More secure than password-based
- Requires certificate management
- Good for automated systems

**AWS IAM:**
- Authenticate using AWS IAM roles or users
- No MongoDB passwords to manage
- Tight integration with AWS services
- Requires AWS IAM configuration

**LDAP (M10+):**
- Integrate with enterprise directory (Active Directory)
- Centralized user management
- Map LDAP groups to MongoDB roles
- Requires LDAP server configuration

### Database Roles

**Built-in Roles:**

| Role | Description |
|------|-------------|
| `atlasAdmin` | Full Atlas admin access |
| `readWriteAnyDatabase` | Read/write on all databases |
| `readAnyDatabase` | Read on all databases |
| `read` on specific DB | Read on one database |
| `readWrite` on specific DB | Read/write on one database |
| `dbAdmin` on specific DB | Admin on one database |

**Custom Roles:**
```bash
# Create custom role via Atlas CLI
atlas customDbRoles create analyticsReader \
  --privilege '{"resource":{"db":"analytics","collection":""},"actions":["find","aggregate"]}'
```

### User Management

```bash
# Create database user
atlas dbusers create --username appUser --password secret123 \
  --role readWriteAnyDatabase

# List users
atlas dbusers list

# Update user
atlas dbusers update appUser --role readAnyDatabase

# Delete user
atlas dbusers delete appUser
```

## Atlas Organization Structure

**[📖 Atlas Organizations](https://www.mongodb.com/docs/atlas/access/manage-organizations/)** - Organization management

### Hierarchy
```
Organization (billing, global settings)
  ├── Project 1 (production)
  │   ├── Cluster A
  │   ├── Cluster B
  │   ├── Database Users
  │   ├── Network Access
  │   └── Backup Settings
  ├── Project 2 (staging)
  │   ├── Cluster C
  │   └── ...
  └── Project 3 (development)
      └── ...
```

### Organization Roles

| Role | Description |
|------|-------------|
| Organization Owner | Full organization access |
| Organization Member | View organization, access assigned projects |
| Organization Billing Admin | Manage billing |
| Organization Read Only | View-only organization access |

### Project Roles

| Role | Description |
|------|-------------|
| Project Owner | Full project access |
| Project Cluster Manager | Create/modify/delete clusters |
| Project Data Access Admin | Manage database users and access |
| Project Data Access Read/Write | Connect and read/write data |
| Project Data Access Read Only | Connect and read data |
| Project Read Only | View project settings |

### Teams
- Groups of organization members
- Assign project roles to teams
- Simplifies access management for large organizations
- Members inherit team's project roles

## API Keys

**[📖 API Keys](https://www.mongodb.com/docs/atlas/configure-api-access/)** - API key management

### Organization API Keys
- Access organization-level resources
- Broader permissions scope
- Used for cross-project automation

### Project API Keys
- Access project-level resources only
- Narrower, more secure scope
- Used for project-specific automation

### API Key Configuration
```bash
# Create API key via CLI
atlas organizations apiKeys create --desc "CI/CD Key" --role ORG_MEMBER

# Create project API key
atlas projects apiKeys create --desc "Deploy Key" --role GROUP_CLUSTER_MANAGER

# List API keys
atlas organizations apiKeys list
```

**Security Best Practices:**
- Use project-level keys when possible (least privilege)
- Configure IP access list for each API key
- Rotate keys regularly
- Store keys securely (secrets manager, CI/CD secrets)
- Never commit API keys to source control

## Encryption

### Encryption in Transit
- TLS 1.2+ required for all Atlas connections
- Enabled by default, cannot be disabled
- Covers client-to-cluster and inter-node communication

### Encryption at Rest
- Enabled by default using Atlas-managed keys
- Customer-Managed Keys (CMK) available for M10+
- Supports AWS KMS, Azure Key Vault, GCP Cloud KMS
- Encrypts data files, journals, and backups

### Client-Side Field Level Encryption (CSFLE)
- Encrypt specific fields before sending to Atlas
- Atlas never sees plaintext for encrypted fields
- Application-level encryption using MongoDB drivers
- Supports automatic and explicit encryption modes
