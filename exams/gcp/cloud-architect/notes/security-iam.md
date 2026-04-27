# GCP Security & IAM Fundamentals

## Google Cloud IAM Overview

### What is Cloud IAM?
Identity and Access Management service that lets you manage access control by defining who (identity) has what access (role) for which resource.

### IAM Model: Who, What, Where
- **Who**: Users, groups, service accounts, domains
- **What**: Roles (collections of permissions)
- **Where**: Resources (projects, folders, organization)

### IAM Hierarchy
```
Organization
├── Folder (Optional)
│   ├── Project A
│   │   ├── Resource 1
│   │   └── Resource 2
│   └── Project B
└── Project C
```

### Permission Inheritance
- **Inherited downward**: Permissions flow from parent to child
- **Additive**: Child permissions add to parent permissions
- **Cannot restrict**: Child cannot remove parent permissions
- **Least privilege**: Grant minimum required permissions

## IAM Identities

### Google Accounts
**Individual end users**

#### Account Types
- **Gmail accounts**: Personal Google accounts
- **Google Workspace accounts**: Business/education accounts
- **Cloud Identity accounts**: Google Cloud-only accounts

#### Use Cases
- **Developers**: Individual access to development resources
- **Administrators**: Administrative access to cloud resources
- **End users**: Access to applications and data

### Service Accounts
**Non-human identities for applications and services**

#### Service Account Types
| Type | Description | Use Case |
|------|-------------|----------|
| **Google-managed** | Created and managed by Google | Google services |
| **User-managed** | Created and managed by you | Applications, VMs |
| **Default** | Automatically created | Compute Engine, App Engine |

#### Service Account Best Practices
- **Principle of least privilege**: Grant minimal required permissions
- **Rotate keys regularly**: Update service account keys
- **Use short-lived tokens**: Prefer OAuth over long-lived keys
- **Monitor usage**: Track service account activities

#### Service Account Keys
```bash
# Create service account
gcloud iam service-accounts create my-service-account

# Generate key file
gcloud iam service-accounts keys create key.json \
  --iam-account=my-service-account@project-id.iam.gserviceaccount.com

# Use in application
export GOOGLE_APPLICATION_CREDENTIALS="key.json"
```

### Google Groups
**Collections of users for easier permission management**

#### Group Benefits
- **Simplified management**: Assign permissions to groups, not individuals
- **Consistency**: Ensure all team members have same access
- **Scalability**: Easily add/remove users from groups
- **Audit trail**: Track group membership changes

#### Group Types
- **Google Groups**: External email groups
- **Cloud Identity Groups**: Google Cloud-only groups
- **Google Workspace Groups**: Organization groups

### Google Workspace and Cloud Identity
**Enterprise identity management**

#### Features
- **Single sign-on (SSO)**: Unified authentication
- **Multi-factor authentication**: Enhanced security
- **User lifecycle management**: Automated provisioning
- **Mobile device management**: Control mobile access

## IAM Roles and Permissions

### Permission Structure
**Format**: `service.resource.verb`

#### Examples
- `storage.objects.create`: Create objects in Cloud Storage
- `compute.instances.start`: Start Compute Engine instances
- `iam.serviceAccounts.actAs`: Act as a service account

### Role Types

#### Primitive Roles (Legacy)
| Role | Description | Use Case |
|------|-------------|----------|
| **Owner** | Full access to all resources | Project administrators |
| **Editor** | Modify access to all resources | Developers |
| **Viewer** | Read-only access to all resources | Auditors, support |

**Note**: Primitive roles are very broad and not recommended for production.

#### Predefined Roles
**Curated sets of permissions for common use cases**

| Role | Description | Example Permissions |
|------|-------------|-------------------|
| **Compute Admin** | Full control of Compute Engine | compute.* |
| **Storage Object Admin** | Full control of Cloud Storage objects | storage.objects.* |
| **BigQuery Data Editor** | Read and modify BigQuery data | bigquery.datasets.*, bigquery.tables.* |
| **Security Admin** | Security-related permissions | iam.*, securitycenter.* |

#### Custom Roles
**User-defined roles with specific permissions**

```yaml
title: "Custom Storage Role"
description: "Limited Cloud Storage access"
stage: "GA"
includedPermissions:
- storage.objects.get
- storage.objects.list
- storage.buckets.get
```

#### Role Creation
```bash
# Create custom role from YAML file
gcloud iam roles create customStorageRole \
  --project=my-project \
  --file=custom-role.yaml

# Create custom role from flags
gcloud iam roles create limitedCompute \
  --project=my-project \
  --title="Limited Compute Access" \
  --permissions=compute.instances.get,compute.instances.list
```

## IAM Policies

### Policy Binding
**Assigns roles to identities for specific resources**

#### Policy Structure
```json
{
  "bindings": [
    {
      "role": "roles/storage.objectViewer",
      "members": [
        "user:alice@example.com",
        "group:developers@example.com",
        "serviceAccount:my-app@project.iam.gserviceaccount.com"
      ]
    }
  ]
}
```

#### Member Types
- **user:email**: Individual Google account
- **group:email**: Google group
- **serviceAccount:email**: Service account
- **domain:domain**: All users in domain
- **allUsers**: Everyone on the internet
- **allAuthenticatedUsers**: All authenticated users

### Conditional IAM
**Add conditions to role bindings**

#### Common Conditions
- **Time-based**: Access during business hours
- **IP-based**: Access from specific networks
- **Resource-based**: Access to specific resources
- **Request attributes**: Based on request properties

#### Example Conditional Policy
```json
{
  "bindings": [
    {
      "role": "roles/compute.instanceAdmin",
      "members": ["user:alice@example.com"],
      "condition": {
        "title": "Business hours only",
        "description": "Access only during 9-5 UTC",
        "expression": "request.time.getHours() >= 9 && request.time.getHours() < 17"
      }
    }
  ]
}
```

### Policy Management
```bash
# Get current policy
gcloud projects get-iam-policy PROJECT_ID

# Set policy from file
gcloud projects set-iam-policy PROJECT_ID policy.json

# Add binding
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="user:alice@example.com" \
  --role="roles/storage.admin"

# Remove binding
gcloud projects remove-iam-policy-binding PROJECT_ID \
  --member="user:alice@example.com" \
  --role="roles/storage.admin"
```

## Google Cloud Security Services

### Cloud Security Command Center
**Centralized security and risk management platform**

#### Key Features
- **Asset discovery**: Inventory of cloud resources
- **Vulnerability assessment**: Security findings and recommendations
- **Security insights**: Analytics and reporting
- **Compliance monitoring**: Regulatory compliance tracking

#### Finding Types
- **Security vulnerabilities**: Software vulnerabilities
- **Misconfigurations**: Insecure configurations
- **Compliance violations**: Policy violations
- **Anomalous activity**: Unusual behavior patterns

### Cloud Asset Inventory
**Real-time inventory of cloud resources**

#### Capabilities
- **Resource discovery**: Find all resources across projects
- **Configuration export**: Export resource configurations
- **Change tracking**: Monitor resource changes
- **Policy analysis**: Analyze IAM policies

#### Use Cases
- **Security audits**: Complete resource inventory
- **Compliance reporting**: Demonstrate compliance posture
- **Cost optimization**: Identify unused resources
- **Configuration management**: Track configuration drift

### Binary Authorization
**Deploy-time security control for container images**

#### How It Works
1. **Attestors**: Trusted authorities that verify images
2. **Policies**: Rules about which images can be deployed
3. **Attestations**: Cryptographic signatures on images
4. **Enforcement**: Block deployment of non-compliant images

#### Policy Example
```yaml
defaultAdmissionRule:
  evaluationMode: REQUIRE_ATTESTATION
  enforcementMode: ENFORCED_BLOCK_AND_AUDIT_LOG
  requireAttestationsBy:
  - projects/PROJECT_ID/attestors/prod-attestor
```

### Cloud KMS (Key Management Service)
**Managed cryptographic key service**

#### Key Types
| Type | Description | Use Case |
|------|-------------|----------|
| **Symmetric** | Same key for encrypt/decrypt | Data encryption |
| **Asymmetric** | Public/private key pairs | Digital signatures, PKI |
| **MAC** | Message authentication codes | Data integrity |

#### Key Hierarchy
```
Project
├── Location (region/global)
│   ├── Key Ring
│   │   ├── Key
│   │   │   ├── Key Version 1
│   │   │   └── Key Version 2
│   │   └── Another Key
│   └── Another Key Ring
```

#### Key Rotation
- **Automatic rotation**: Configure automatic key rotation
- **Manual rotation**: Create new key versions manually
- **Gradual migration**: Old versions remain for decryption
- **Compliance**: Meet regulatory requirements

### Cloud HSM
**Hardware security modules for cryptographic operations**

#### When to Use Cloud HSM
- **FIPS 140-2 Level 3**: High security requirements
- **Compliance**: Regulatory requirements for HSM
- **Custom cryptography**: Need specialized crypto operations
- **Key sovereignty**: Complete control over keys

### Secret Manager
**Secure storage and management of secrets**

#### Secret Types
- **API keys**: Third-party service credentials
- **Database passwords**: Database connection strings
- **TLS certificates**: SSL/TLS certificates
- **OAuth tokens**: Authentication tokens

#### Features
- **Versioning**: Multiple versions of secrets
- **Access logging**: Audit secret access
- **Automatic rotation**: Rotate secrets automatically
- **Regional replication**: High availability

#### Secret Access
```bash
# Store secret
echo "my-secret-value" | gcloud secrets create my-secret --data-file=-

# Access secret
gcloud secrets versions access latest --secret="my-secret"

# Use in application
from google.cloud import secretmanager

client = secretmanager.SecretManagerServiceClient()
response = client.access_secret_version(
    request={"name": "projects/PROJECT_ID/secrets/SECRET_ID/versions/latest"}
)
secret_value = response.payload.data.decode("UTF-8")
```

## Network Security

### VPC Security Features
- **Firewall rules**: Control traffic flow
- **Private Google Access**: Access Google services privately
- **VPC peering**: Secure inter-VPC communication
- **Shared VPC**: Centralized network management

### Cloud Firewall
**Stateful firewall for VPC networks**

#### Rule Components
- **Direction**: Ingress or egress
- **Priority**: Rule precedence (0-65534)
- **Action**: Allow or deny
- **Targets**: What instances the rule applies to
- **Source/Destination**: Traffic origin/destination
- **Protocols and ports**: Traffic type

#### Default Rules
```
default-allow-internal: Allow traffic between VPC instances
default-allow-ssh: Allow SSH from anywhere (0.0.0.0/0)
default-allow-rdp: Allow RDP from anywhere
default-allow-icmp: Allow ICMP from anywhere
```

#### Firewall Rule Example
```bash
gcloud compute firewall-rules create allow-web-traffic \
  --allow tcp:80,tcp:443 \
  --source-ranges 0.0.0.0/0 \
  --target-tags web-server \
  --description "Allow HTTP and HTTPS traffic to web servers"
```

### Cloud Armor
**DDoS protection and Web Application Firewall**

#### Protection Levels
- **Standard DDoS protection**: Automatic, no cost
- **Adaptive Protection**: ML-based attack detection
- **Rate limiting**: Control request rates
- **Geo-blocking**: Block traffic by country

#### Security Policies
```yaml
name: "my-security-policy"
rules:
- priority: 1000
  match:
    versionedExpr: SRC_IPS_V1
    config:
      srcIpRanges: ["192.168.1.0/24"]
  action: "allow"
- priority: 2000
  match:
    versionedExpr: SRC_IPS_V1
    config:
      srcIpRanges: ["*"]
  action: "deny-403"
```

### Private Google Access
**Access Google services without internet**

#### How It Works
- **Private IP only**: VMs without external IPs
- **Google services**: Access Cloud Storage, BigQuery, etc.
- **Private routes**: Traffic stays on Google network
- **Firewall rules**: Control access to services

#### Configuration
```bash
# Enable Private Google Access on subnet
gcloud compute networks subnets update SUBNET_NAME \
  --region=REGION \
  --enable-private-ip-google-access
```

## Identity and Federation

### Workforce Identity Federation
**Use external identity providers with Google Cloud**

#### Supported Providers
- **SAML 2.0**: Enterprise identity providers
- **OIDC**: OpenID Connect providers
- **Azure Active Directory**: Microsoft's identity platform
- **ADFS**: Active Directory Federation Services

#### Benefits
- **No user duplication**: Use existing identities
- **Single sign-on**: Unified authentication experience
- **Centralized management**: Manage users in existing systems
- **Enhanced security**: Leverage existing security controls

### Workload Identity Federation
**Allow external workloads to access Google Cloud**

#### Use Cases
- **GitHub Actions**: CI/CD pipelines
- **Azure DevOps**: Microsoft build pipelines
- **AWS**: Cross-cloud workloads
- **On-premises**: Existing automation systems

#### Configuration Example
```bash
# Create workload identity pool
gcloud iam workload-identity-pools create github-pool \
  --location="global" \
  --display-name="GitHub Actions Pool"

# Create provider
gcloud iam workload-identity-pools providers create-oidc github-provider \
  --location="global" \
  --workload-identity-pool="github-pool" \
  --issuer-uri="https://token.actions.githubusercontent.com" \
  --attribute-mapping="google.subject=assertion.sub"
```

## Security Best Practices

### Identity Management
1. **Use groups**: Manage permissions through groups, not individuals
2. **Principle of least privilege**: Grant minimum required permissions
3. **Regular access reviews**: Audit and remove unnecessary access
4. **Service account hygiene**: Monitor and rotate service account keys
5. **Multi-factor authentication**: Enable 2FA for all users

### Resource Security
1. **Network segmentation**: Use firewalls and private networks
2. **Encryption**: Encrypt data at rest and in transit
3. **Secrets management**: Use Secret Manager for sensitive data
4. **Container security**: Use Binary Authorization and security scanning
5. **Regular updates**: Keep systems and dependencies updated

### Monitoring and Compliance
1. **Audit logging**: Enable Cloud Audit Logs for all services
2. **Security monitoring**: Use Security Command Center
3. **Compliance frameworks**: Implement relevant compliance controls
4. **Incident response**: Have security incident response procedures
5. **Regular assessments**: Conduct security assessments and penetration testing

## Compliance and Governance

### Compliance Offerings
- **SOC 1/2/3**: Service Organization Control reports
- **ISO 27001**: Information security management
- **PCI DSS**: Payment card industry compliance
- **HIPAA**: Healthcare data protection (Google Cloud HIPAA BAA)
- **FedRAMP**: US government cloud security

### Resource Hierarchy for Governance
```
Organization (company.com)
├── Folder: Production
│   ├── Project: prod-web-app
│   └── Project: prod-database
├── Folder: Development
│   ├── Project: dev-environment
│   └── Project: test-environment
└── Folder: Shared Services
    ├── Project: logging
    └── Project: monitoring
```

### Organization Policies
**Centralized constraints on resource configuration**

#### Common Policies
- **Restrict VM external IPs**: Prevent public IP assignment
- **Allowed instance types**: Limit to approved machine types
- **Required labels**: Ensure resources are properly tagged
- **Location restrictions**: Control where resources are created

#### Policy Example
```yaml
constraint: constraints/compute.restrictSharedVpcSubnetworks
listPolicy:
  allowedValues:
  - "projects/host-project/regions/us-central1/subnetworks/allowed-subnet"
```

## Common Security Pitfalls

### IAM Misconfigurations
- **Overly broad primitive roles**: Using Owner/Editor instead of specific roles
- **Service account key proliferation**: Too many long-lived keys
- **Missing principle of least privilege**: Granting excessive permissions
- **Inconsistent group management**: Not using groups effectively

### Network Security Issues
- **Default firewall rules**: Not customizing firewall rules
- **Public IP usage**: Unnecessary external IP addresses
- **Missing network segmentation**: All resources in same network
- **Inadequate monitoring**: Not tracking network access

### Data Protection Gaps
- **Unencrypted data**: Not using encryption at rest
- **Weak access controls**: Insufficient data access restrictions
- **Missing audit trails**: Not logging data access
- **Poor secret management**: Hardcoded credentials or keys

### Operational Security
- **Insufficient monitoring**: Not using Security Command Center
- **Missing compliance controls**: Not implementing required frameworks
- **Weak incident response**: No security incident procedures
- **Outdated systems**: Not keeping systems updated