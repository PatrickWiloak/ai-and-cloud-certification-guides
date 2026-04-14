# Authentication and RBAC

Boundary's access model combines auth methods (identity verification), accounts (per-method identities), users/groups/managed groups (abstractions), and roles with grants (authorization). Understanding each layer is critical.

## Auth Methods

An auth method validates user credentials and maps them to an account.

### Password Auth Method (`amp_`)

Built-in. Username and password stored (hashed) in Boundary's DB.

```
boundary auth-methods create password \
  -scope-id=global \
  -name=local-password

boundary accounts create password \
  -auth-method-id=amp_... \
  -login-name=alice \
  -password=s3cret
```

Use for:

- Initial bootstrap before IdP is configured
- Break-glass admin accounts
- Small deployments without an IdP

Not recommended for production user auth at scale.

### OIDC Auth Method (`amoidc_`)

Integrates with any OIDC-compliant IdP (Okta, Auth0, Azure AD, Google Workspace, Keycloak).

```
boundary auth-methods create oidc \
  -scope-id=o_... \
  -name=corporate-oidc \
  -issuer=https://tenant.oktapreview.com \
  -client-id=abc \
  -client-secret=xyz \
  -signing-algorithm=RS256 \
  -api-url-prefix=https://boundary.example.com \
  -claims-scopes=email,profile,groups
```

After create, activate it:

```
boundary auth-methods change-state oidc -id=amoidc_... -state=active-public
```

OIDC flow:

1. User clicks "sign in with OIDC" in Boundary Desktop
2. Boundary redirects to IdP
3. User authenticates at IdP, consents, redirected back with code
4. Boundary exchanges code for ID token and access token
5. Boundary creates or finds an account matching the token's `sub` claim
6. User gets a Boundary session token

### LDAP Auth Method (`amldap_`)

For corporate AD or LDAP:

```
boundary auth-methods create ldap \
  -scope-id=o_... \
  -name=corporate-ad \
  -urls=ldaps://dc1.example.com:636 \
  -user-dn="OU=Users,DC=example,DC=com" \
  -user-attr=sAMAccountName \
  -group-dn="OU=Groups,DC=example,DC=com" \
  -group-filter="(&(objectClass=group)(member=*))"
```

Supports group mapping for automatic managed group membership.

### Primary Auth Method

Each scope can designate one primary auth method per type. When set:

- Users can login without specifying `-auth-method-id`
- New user creation is simpler

```
boundary scopes update -id=o_... -primary-auth-method-id=amoidc_...
```

## Accounts

An account is a per-auth-method identity. Resource IDs:

- `acctpw_`: password account
- `acctoidc_`: OIDC account
- `acctldap_`: LDAP account

A user can have multiple accounts across different auth methods (e.g., OIDC account for daily use, password account for break-glass).

## Users and Groups

### Users (`u_`)

An identity that unifies one or more accounts.

```
boundary users create -scope-id=global -name=alice -description="Alice Smith"
boundary users add-accounts -id=u_... -account=acctoidc_...
```

### Groups (`g_`)

Static collections of users.

```
boundary groups create -scope-id=o_... -name=sre-team
boundary groups add-members -id=g_... -member=u_...
```

### Managed Groups (`mg_`)

Dynamic membership based on auth method claims (OIDC) or attributes (LDAP).

OIDC filter example:

```
boundary managed-groups create oidc \
  -auth-method-id=amoidc_... \
  -name=platform-admins \
  -filter='"/token/groups" contains "platform-admins"'
```

The filter evaluates on every authentication; membership is computed live.

Managed groups are the preferred pattern for tying IdP groups to Boundary roles. No manual account linking needed.

## Roles and Grants

A role is a named bundle of permissions attached to users/groups/managed groups, evaluated within a specific scope with a specific grant_scope.

### Create a Role

```
boundary roles create \
  -scope-id=p_... \
  -name=target-users \
  -description="Can authorize sessions on this project's targets"
```

### Grant Scope

```
boundary roles update -id=r_... -grant-scope-id=this
# or
boundary roles update -id=r_... -grant-scope-id=children
# or
boundary roles update -id=r_... -grant-scope-id=descendants
```

- `this` (default): grants apply in the role's own scope
- `children`: grants apply in direct child scopes (org role granting into all projects)
- `descendants`: grants apply in all nested scopes recursively (global role granting everywhere)

### Add Grants

Grants are strings following the format:

```
ids=<ids>;type=<type>;actions=<actions>;output_fields=<fields>
```

Examples:

```
boundary roles add-grants -id=r_... \
  -grant='ids=*;type=target;actions=list,read,authorize-session'

boundary roles add-grants -id=r_... \
  -grant='ids=*;type=session;actions=list,read,cancel:self'

boundary roles add-grants -id=r_... \
  -grant='ids=hst_*;type=host;actions=read'
```

### Add Principals

Attach users, groups, or managed groups:

```
boundary roles add-principals -id=r_... -principal=u_...
boundary roles add-principals -id=r_... -principal=g_...
boundary roles add-principals -id=r_... -principal=mg_...
```

## Grant String Breakdown

### ids

Resource IDs this grant applies to.

- `ids=*`: all resources of the given type
- `ids=ttcp_1234,ttcp_5678`: specific targets
- `ids=ttcp_*`: all TCP targets (wildcard)

### type

Resource type. Common values:

- `target`
- `host`, `host-set`, `host-catalog`
- `session`
- `user`, `group`, `managed-group`
- `role`
- `scope`
- `auth-method`, `auth-token`, `account`
- `credential`, `credential-library`, `credential-store`
- `worker`
- `*` (wildcard)

### actions

Permissions to grant. Common actions:

- `list`, `read`, `create`, `update`, `delete`: CRUD
- `authorize-session`: allow starting a session on a target
- `cancel`: cancel a session
- `add-grants`, `set-grants`, `remove-grants`: modify a role
- `*`: wildcard

Qualifiers:

- `:self`: only applies to resources owned by the authenticated user (sessions only, typically)

### output_fields

Restricts which fields are returned. Advanced use; rarely needed for Associate exam.

## Default Roles

Every scope has default roles:

- **authenticated** (`admin`): full control within scope for authenticated users (auto-attached to admin-like users)
- **anonymous** (`default`): actions available to unauthenticated requests (extremely limited by default)

Customize these carefully; they affect the baseline behavior.

## Grant Examples

### Target user (can connect but not manage)

```
ids=*;type=target;actions=list,read,authorize-session
ids=*;type=session;actions=list,read,cancel:self
```

### Target admin

```
ids=*;type=target;actions=*
ids=*;type=host-set;actions=*
ids=*;type=host;actions=*
ids=*;type=credential-library;actions=list,read
```

### Scope admin

```
ids=*;type=*;actions=*
```

Powerful; grant sparingly.

### Allow reading auth methods in scope

```
ids=*;type=auth-method;actions=list,read,authenticate
```

`authenticate` action on an auth method is what allows users to use it for login.

## Principals in Multiple Scopes

A user can have roles in many scopes simultaneously. Grants are additive across roles. At any decision point, Boundary checks all relevant roles scoped to the target resource.

## Auth Token Lifecycle

After authenticating, the user gets an auth token stored in Boundary's DB. The client stores a corresponding opaque token. By default tokens last 7 days but refresh on each request.

Revoke a token:

```
boundary auth-tokens delete -id=at_...
```

Or delete the user; tokens cascade.

## SCIM Integration

Enterprise Boundary supports SCIM for automated user/group provisioning from the IdP. Configure the SCIM endpoint in the IdP; Boundary receives create/update/delete events. Reduces manual account management.

## Terraform Example

```hcl
resource "boundary_auth_method_oidc" "corp" {
  name     = "corporate"
  scope_id = boundary_scope.org.id
  issuer   = "https://example.okta.com"
  client_id     = var.oidc_client_id
  client_secret = var.oidc_client_secret
  signing_algorithms = ["RS256"]
  api_url_prefix     = "https://boundary.example.com"
  is_primary_for_scope = true
  state = "active-public"
}

resource "boundary_managed_group" "platform" {
  name           = "platform-admins"
  auth_method_id = boundary_auth_method_oidc.corp.id
  filter         = "\"/token/groups\" contains \"platform\""
}

resource "boundary_role" "admin" {
  name         = "platform-admin"
  scope_id     = boundary_scope.project.id
  grant_strings = [
    "ids=*;type=*;actions=*",
  ]
  grant_scope_id      = "this"
  principal_ids = [boundary_managed_group.platform.id]
}
```

## Common Mistakes

- Forgetting `grant_scope_id`; default `this` may not cover what you want
- Using `ids=*` when you meant specific resources
- Missing `:self` qualifier on session actions
- Confusing `authenticate` action (on auth method) with user authentication
- Setting primary auth method on multiple methods of the same type (only one can be primary)

## Exam-Ready Checklist

- [ ] Can explain auth methods, accounts, users, groups, managed groups
- [ ] Know primary auth method semantics
- [ ] Can parse and author grant strings
- [ ] Understand `:self` qualifier
- [ ] Know grant_scope options (this, children, descendants)
- [ ] Can describe OIDC login flow end to end
- [ ] Know when to use managed groups vs static groups
