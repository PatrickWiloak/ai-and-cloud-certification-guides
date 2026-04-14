# Boundary Associate - Real-World Scenarios

## Scenario 1: Replace a Bastion Host

**Question:** Your company has a single SSH bastion that engineers use to reach 200 production EC2 instances. It requires shared IAM keys, SSH key rotation is manual, and logging is spotty. Leadership wants identity-aware access with audit. How does Boundary solve this?

**Answer:** Deploy Boundary controllers (self-managed or HCP) and egress workers in the production VPC. Configure OIDC auth tied to your IdP. Create a dynamic host catalog pulling EC2 instances by tag. Create SSH targets with credential injection using Vault-signed SSH certificates. Engineers auth via OIDC, browse targets in Boundary Desktop, click connect. No shared keys. Every session is logged with the authenticated user identity. Optionally enable session recording on Enterprise tier.

## Scenario 2: Grant a Read-Only Role for Sessions

**Question:** A support engineer needs to view running sessions and cancel their own, but must not be able to cancel others' sessions or authorize new ones. Write the grant string.

**Answer:**

```
ids=*;type=session;actions=list,read,cancel:self
```

The `:self` qualifier restricts cancel to sessions owned by the authenticated user. `list` and `read` are not qualified, so they can view all. Do not include `authorize-session` at all (that's a target action, not a session action).

## Scenario 3: Dynamic Credentials from Vault for PostgreSQL

**Question:** Developers need temporary database credentials that expire after 1 hour of idle, are never seen by the developer, and are unique per session. How do you set this up?

**Answer:**

1. Configure Vault's database secrets engine with the PostgreSQL instance.
2. Create a Vault role that issues dynamic credentials with TTL 1h.
3. In Boundary, create a Vault credential store pointed at Vault with a token that has read permission on the DB role.
4. Create a credential library referencing the Vault role.
5. Create a TCP target for the PostgreSQL port, attach the credential library as... well, here's a nuance: TCP targets use brokering, not injection. For true injection you'd need an SSH target. For DB credentials typically you broker to the user's client (e.g., psql). If the requirement is the user never sees creds, you need to use a proxy pattern or SSH jump. In practice Boundary brokers DB creds to the user's client tool.

## Scenario 4: Multi-Region Worker Deployment

**Question:** You have workloads in `us-east-1` and `eu-west-1`. Users connecting to `eu-west-1` targets should route through workers in that region to reduce latency and comply with data residency. How do you configure this?

**Answer:** Deploy workers in each region with tags:

```hcl
# us-east-1 worker
worker {
  tags {
    region = ["us-east-1"]
  }
}

# eu-west-1 worker
worker {
  tags {
    region = ["eu-west-1"]
  }
}
```

On each target, set a worker filter: `"region" in "/tags/region"` with value matching the target's region. Boundary only routes that target's sessions to workers matching the filter.

## Scenario 5: Break-Glass Admin Access

**Question:** Your OIDC provider goes down. You still need admin access to Boundary. What mechanism does Boundary provide?

**Answer:** The `recovery` KMS key. Boundary supports a recovery authentication that uses the KMS key directly. Configure in the controller's HCL:

```hcl
kms "awskms" {
  purpose = "recovery"
  region = "us-east-1"
  kms_key_id = "alias/boundary-recovery"
}
```

Then: `boundary authenticate ... -recovery-config=recovery.hcl` or export `BOUNDARY_RECOVERY_CONFIG=...` plus `BOUNDARY_TOKEN=""`. Recovery access has global admin rights. Protect the KMS key access (IAM policy) carefully and audit its usage.

## Scenario 6: Managed Groups from OIDC Claims

**Question:** Your IdP sends group membership in a claim `groups`. You want members of `groups:platform-admins` to automatically have admin role in the `platform` project without manually creating accounts. How?

**Answer:** Configure your OIDC auth method. Create a managed group with a filter on the claim:

```
"/token/groups" contains "platform-admins"
```

Any account authenticating via this OIDC method gets membership in the managed group based on the current token's claims. Attach a role with admin grants in `p_platform` project to the managed group. Membership is recomputed at every auth; no manual account management.

## Scenario 7: Secure Access Without Exposed Workers

**Question:** Your security team says no worker can have a public IP or accept inbound connections from the internet. But you still need remote engineer access. How?

**Answer:** Use HCP Boundary (or self-managed with public controllers). Workers run in your private network and **dial out** to the controllers. Client connections terminate at the controllers, which route to a worker via the upstream connection the worker established. No inbound firewall rules on workers. This is the default pattern for HCP Boundary and is also supported in self-managed multi-hop setups.

## Scenario 8: Terraform the Boundary Config

**Question:** Your team wants all Boundary scopes, targets, credentials, and roles declared as code. How do you achieve this?

**Answer:** Use the `boundary` Terraform provider:

```hcl
terraform {
  required_providers {
    boundary = { source = "hashicorp/boundary" }
  }
}

provider "boundary" {
  addr  = "https://boundary.example.com"
  recovery_kms_hcl = file("recovery.hcl")
}

resource "boundary_scope" "org" {
  scope_id    = "global"
  name        = "platform"
  description = "Platform engineering"
}

resource "boundary_scope" "project" {
  scope_id = boundary_scope.org.id
  name     = "prod"
}

resource "boundary_target" "ssh" {
  type        = "ssh"
  name        = "webserver"
  scope_id    = boundary_scope.project.id
  default_port = 22
  host_source_ids = [boundary_host_set_static.web.id]
  injected_application_credential_source_ids = [boundary_credential_library_vault.ssh_signed.id]
}
```

Commit to version control; apply via CI. Benefits: review, rollback, drift detection.

## Scenario 9: OIDC Claim-to-Scope Mapping

**Question:** You want users to auto-land in the correct org scope based on their OIDC team claim without manual account attribution. Is this possible?

**Answer:** Partially. Boundary does not natively "auto-select scope" based on claims, but you can achieve the effective behavior by:

1. Creating an OIDC auth method at the global scope.
2. Creating managed groups per team (using claim filters).
3. Granting each managed group appropriate roles in target org/project scopes.

Users auth once globally; their accessible resources are determined by managed group memberships derived from claims on every login.

## Scenario 10: Session Recording Setup (Enterprise)

**Question:** Security requires all SSH sessions to be recorded and retained for 1 year. You have an Enterprise license. How do you implement?

**Answer:**

1. Create an S3 bucket with versioning and lifecycle policy deleting after 365 days.
2. Create a Boundary storage bucket resource: `boundary storage-buckets create -plugin-name=aws -bucket-name=sessions -region=us-east-1 -...`.
3. Configure a worker with session recording capability (requires storage bucket worker filter).
4. On each SSH target: `enable_session_recording = true` and reference the storage bucket.
5. Optionally set a retention policy.

Test by initiating an SSH session, then replay via Boundary Desktop or `boundary sessions record-session ...`.

## Scenario 11: Revoke All Access for a Departed Employee

**Question:** An employee is offboarded. Disable their access immediately. Active sessions must terminate.

**Answer:**

1. Disable the user in the OIDC IdP (Okta, Azure AD, etc.). This prevents new authentications.
2. In Boundary, disable or delete the corresponding account (and user): `boundary accounts delete -id=acctoidc_...`.
3. List active sessions for that user: `boundary sessions list -user-id=u_...`.
4. Cancel each: `boundary sessions cancel -id=s_...`.
5. Audit: check that any Vault-brokered credentials have been revoked (Vault should handle via lease expiration, but confirm).

Automate this in an offboarding runbook or SCIM integration.

## Scenario 12: Static vs Dynamic Host Catalog Choice

**Question:** You have 3 production databases and 400 ephemeral Kubernetes pods. Where do you use each host catalog type?

**Answer:**

- **Static host catalog** for the 3 databases. They rarely change. Declare in Terraform with stable addresses.
- **Dynamic / plugin host catalog** for the Kubernetes pods (or the backing nodes). Use the appropriate plugin (AWS, Azure, etc.) or custom. Static would thrash as pods come and go.

For pods specifically, pragmatically you'd target the Kubernetes API or the nodes, not individual pods. Boundary is more natural at the infra layer (VMs, nodes, services) than per-pod.
