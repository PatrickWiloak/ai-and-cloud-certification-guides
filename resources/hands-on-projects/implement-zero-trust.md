# Hands-On Project: Implement Zero Trust Security

Implement identity-based access with no implicit network trust.

**Estimated Time:** 4-5 hours
**Difficulty:** Advanced
**Prerequisites:** Cloud account, identity provider access, basic networking knowledge

---

## Architecture Overview

```
                      Identity Provider (IdP)
                     /          |           \
                    /           |            \
        MFA + Conditional   Workload       Service
        Access Policies     Identity       Mesh (mTLS)
                |               |               |
        User Access         App-to-Cloud    App-to-App
        (Browser/CLI)       (API calls)     (Internal)
                \               |               /
                 \              |              /
              Private Endpoints / Microsegmentation
              (No public exposure of internal services)
```

**Core Principles**
- Never trust, always verify
- Assume breach
- Verify explicitly (every request, every time)
- Use least-privilege access
- Inspect and log everything

---

## Step 1: Configure Identity Provider

### AWS - IAM Identity Center (SSO)

```bash
# Enable IAM Identity Center
aws sso-admin create-instance

# Create a permission set
aws sso-admin create-permission-set \
  --instance-arn arn:aws:sso:::instance/ssoins-xxx \
  --name "DeveloperAccess" \
  --session-duration "PT4H"

# Attach a managed policy
aws sso-admin attach-managed-policy-to-permission-set \
  --instance-arn arn:aws:sso:::instance/ssoins-xxx \
  --permission-set-arn arn:aws:sso:::permissionSet/ssoins-xxx/ps-xxx \
  --managed-policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess
```

**Key Configuration**
- Connect to an external IdP (Okta, Entra ID, Google Workspace) via SAML or SCIM
- Define permission sets that map to IAM roles in target accounts
- Assign users and groups to AWS accounts with specific permission sets

**Docs:** https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html

### Azure - Entra ID

```bash
# Create a Conditional Access policy (requires Entra ID P1 or P2)
az rest --method POST \
  --url "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies" \
  --body '{
    "displayName": "Require MFA for all users",
    "state": "enabled",
    "conditions": {
      "users": { "includeUsers": ["All"] },
      "applications": { "includeApplications": ["All"] }
    },
    "grantControls": {
      "operator": "OR",
      "builtInControls": ["mfa"]
    }
  }'
```

**Docs:** https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview

### GCP - Cloud Identity

```bash
# Set up organization-wide policies
gcloud organizations list

# Enforce 2-Step Verification (via Admin Console)
# Admin Console > Security > Authentication > 2-Step Verification > Enforce
```

**Docs:** https://cloud.google.com/identity/docs/overview

---

## Step 2: Implement Multi-Factor Authentication (MFA)

### AWS MFA

```bash
# Require MFA via IAM policy
cat <<'POLICY'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "NotAction": [
        "iam:CreateVirtualMFADevice",
        "iam:EnableMFADevice",
        "iam:ListMFADevices",
        "iam:ListUsers",
        "sts:GetSessionToken"
      ],
      "Resource": "*",
      "Condition": {
        "BoolIfExists": {
          "aws:MultiFactorAuthPresent": "false"
        }
      }
    }
  ]
}
POLICY
```

### Azure MFA

- Enable per-user MFA or use Conditional Access (recommended)
- Configure authentication methods: Microsoft Authenticator, FIDO2 keys, SMS (not recommended)
- Set up number matching for phishing resistance

### GCP MFA

- Enforce via Cloud Identity admin console
- Support for hardware keys (Titan Security Key)
- Context-aware access policies based on device posture

### Phishing-Resistant MFA

- FIDO2 / WebAuthn security keys (YubiKey, Titan Key)
- Platform authenticators (Windows Hello, Touch ID)
- Passkeys as the modern replacement for passwords
- Avoid SMS-based MFA when possible (SIM swap attacks)

---

## Step 3: Set Up Conditional Access

### Azure Conditional Access Policies

**Policy 1: Require MFA from untrusted locations**
```
Conditions:
  Users: All users
  Cloud apps: All cloud apps
  Locations: Any location NOT in the trusted list
Grant:
  Require multi-factor authentication
```

**Policy 2: Block legacy authentication**
```
Conditions:
  Users: All users
  Client apps: Exchange ActiveSync, Other clients
Grant:
  Block access
```

**Policy 3: Require compliant device**
```
Conditions:
  Users: All users
  Cloud apps: Sensitive applications
  Device platforms: Any
Grant:
  Require device to be marked as compliant
```

### AWS Equivalent - IAM Conditions

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "NotIpAddress": {
          "aws:SourceIp": ["203.0.113.0/24", "198.51.100.0/24"]
        },
        "BoolIfExists": {
          "aws:ViaAWSService": "false"
        }
      }
    }
  ]
}
```

### GCP Equivalent - BeyondCorp Enterprise

```bash
# Create an access level
gcloud access-context-manager levels create trusted-corp \
  --title "Trusted Corporate Access" \
  --basic-level-spec access-level.yaml \
  --policy POLICY_ID
```

```yaml
# access-level.yaml
- ipSubnetworks:
    - 203.0.113.0/24
- devicePolicy:
    requireScreenlock: true
    osConstraints:
      - osType: DESKTOP_CHROME_OS
        minimumVersion: "100.0"
```

**Docs:** https://cloud.google.com/beyondcorp-enterprise/docs/overview

---

## Step 4: Microsegmentation

### Kubernetes Network Policies

```yaml
# Default deny all ingress and egress
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: production
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress

---
# Allow specific service-to-service communication
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: frontend
      ports:
        - protocol: TCP
          port: 8080

---
# Allow backend to database only
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-backend-to-db
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
    - Egress
  egress:
    - to:
        - podSelector:
            matchLabels:
              app: database
      ports:
        - protocol: TCP
          port: 5432
    - to:  # Allow DNS
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: kube-system
      ports:
        - protocol: UDP
          port: 53
```

### Cloud Security Groups / Firewall Rules

**AWS - Security Group Chaining**
```bash
# Frontend SG: allow inbound from ALB only
# Backend SG: allow inbound from Frontend SG only
# Database SG: allow inbound from Backend SG only
aws ec2 authorize-security-group-ingress --group-id sg-db \
  --protocol tcp --port 5432 --source-group sg-backend
```

**Azure - Application Security Groups**
```bash
az network asg create --resource-group myRG --name backend-asg
az network asg create --resource-group myRG --name database-asg

az network nsg rule create --resource-group myRG --nsg-name my-nsg \
  --name allow-backend-to-db \
  --source-asgs backend-asg --destination-asgs database-asg \
  --destination-port-ranges 5432 --protocol Tcp --access Allow --priority 100
```

**GCP - Firewall Rules with Tags**
```bash
gcloud compute firewall-rules create allow-backend-to-db \
  --network my-vpc \
  --allow tcp:5432 \
  --source-tags backend \
  --target-tags database
```

---

## Step 5: Private Endpoints

Remove public exposure of internal services.

### AWS PrivateLink

```bash
# Create a VPC endpoint for S3
aws ec2 create-vpc-endpoint --vpc-id vpc-xxx \
  --service-name com.amazonaws.us-east-1.s3 \
  --route-table-ids rtb-xxx

# Create an interface endpoint for RDS
aws ec2 create-vpc-endpoint --vpc-id vpc-xxx \
  --vpc-endpoint-type Interface \
  --service-name com.amazonaws.us-east-1.rds \
  --subnet-ids subnet-xxx \
  --security-group-ids sg-xxx
```

### Azure Private Endpoints

```bash
az network private-endpoint create --resource-group myRG \
  --name my-sql-pe --vnet-name myVNet --subnet private-endpoints \
  --connection-name my-sql-connection \
  --private-connection-resource-id /subscriptions/.../Microsoft.Sql/servers/myserver \
  --group-ids sqlServer
```

### GCP Private Service Connect

```bash
gcloud compute addresses create psc-address \
  --region us-central1 --subnet private-subnet

gcloud compute forwarding-rules create psc-endpoint \
  --region us-central1 --network my-vpc \
  --address psc-address --target-service-attachment SERVICE_ATTACHMENT
```

---

## Step 6: Workload Identity

Eliminate long-lived credentials for service-to-service communication.

### AWS - IAM Roles for Service Accounts (IRSA)

```bash
# Associate an IAM role with a Kubernetes service account
eksctl create iamserviceaccount \
  --cluster my-cluster \
  --namespace default \
  --name my-app-sa \
  --attach-policy-arn arn:aws:iam::123456789012:policy/MyAppPolicy \
  --approve
```

### Azure - Workload Identity Federation

```bash
az identity create --resource-group myRG --name my-app-identity

az identity federated-credential create \
  --identity-name my-app-identity --resource-group myRG \
  --name my-fed-cred \
  --issuer "https://oidc.eks.us-east-1.amazonaws.com/id/xxx" \
  --subject "system:serviceaccount:default:my-app-sa"
```

### GCP - Workload Identity

```bash
gcloud iam service-accounts add-iam-policy-binding GSA_EMAIL \
  --role roles/iam.workloadIdentityUser \
  --member "serviceAccount:PROJECT_ID.svc.id.goog[NAMESPACE/KSA_NAME]"

kubectl annotate serviceaccount KSA_NAME \
  --namespace NAMESPACE \
  iam.gke.io/gcp-service-account=GSA_EMAIL
```

---

## Verification Checklist

- [ ] All users authenticate through the central identity provider
- [ ] MFA is enforced for all interactive logins
- [ ] Conditional access blocks risky sign-ins
- [ ] Network policies enforce service-to-service restrictions
- [ ] Internal services are accessible only via private endpoints
- [ ] No long-lived credentials - workload identity is used for service auth
- [ ] All access is logged and auditable
- [ ] Public endpoints are protected with WAF and DDoS protection

---

## Cleanup

1. Remove network policies
2. Delete private endpoints
3. Remove conditional access policies
4. Delete IAM roles and service accounts
5. Disable the identity provider integration (if test-only)

---

## Additional Resources

- [NIST Zero Trust Architecture (SP 800-207)](https://csrc.nist.gov/publications/detail/sp/800-207/final)
- [AWS Zero Trust on AWS](https://aws.amazon.com/security/zero-trust/)
- [Azure Zero Trust Deployment](https://learn.microsoft.com/en-us/security/zero-trust/)
- [GCP BeyondCorp Enterprise](https://cloud.google.com/beyondcorp-enterprise/docs)
