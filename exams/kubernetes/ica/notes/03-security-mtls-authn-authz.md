# 03. Security: mTLS, Authentication, Authorization

## The Security CRDs

Three primary security CRDs:

- **PeerAuthentication**: workload-to-workload authentication (mTLS modes)
- **RequestAuthentication**: end-user authentication (JWT validation)
- **AuthorizationPolicy**: who can do what

Plus the underlying certificate machinery managed by istiod (Citadel).

## PeerAuthentication

Configures mTLS for inbound traffic.

```yaml
apiVersion: security.istio.io/v1
kind: PeerAuthentication
metadata:
  name: default
  namespace: istio-system
spec:
  mtls:
    mode: STRICT
```

Modes:

- **STRICT**: only accept mTLS connections; reject plaintext
- **PERMISSIVE**: accept both mTLS and plaintext (default)
- **DISABLE**: do not use mTLS

Scope by placement:

- In `istio-system` with no selector: mesh-wide
- In an app namespace with no selector: namespace-wide
- With a `selector`: workload-specific

Most narrow scope wins on conflicts (workload > namespace > mesh).

### Migration pattern

1. Install Istio (default PERMISSIVE)
2. Roll out sidecars to all workloads
3. Switch to STRICT mesh-wide
4. Verify nothing breaks; rollback if needed

Switching to STRICT before all workloads have sidecars breaks unmeshed callers.

### Per-port mTLS overrides

```yaml
spec:
  mtls: { mode: STRICT }
  portLevelMtls:
    8080: { mode: PERMISSIVE }
```

## RequestAuthentication

Validates JWT tokens on requests.

```yaml
apiVersion: security.istio.io/v1
kind: RequestAuthentication
metadata: { name: jwt-auth, namespace: bookinfo }
spec:
  selector:
    matchLabels: { app: productpage }
  jwtRules:
    - issuer: "https://accounts.example.com"
      jwksUri: "https://accounts.example.com/.well-known/jwks.json"
      audiences: ["productpage"]
```

RequestAuthentication does NOT enforce a token must be present. It validates if present. To require, pair with an AuthorizationPolicy that denies requests without `request.auth.principal`.

## AuthorizationPolicy

The action engine. Three primary actions:

- **ALLOW**: if any rule matches, allow; otherwise deny (when an ALLOW exists for that workload)
- **DENY**: if any rule matches, deny
- **CUSTOM**: invoke external authz (envoy ext_authz)
- **AUDIT**: log without enforcing

```yaml
apiVersion: security.istio.io/v1
kind: AuthorizationPolicy
metadata: { name: reviews-policy, namespace: bookinfo }
spec:
  selector:
    matchLabels: { app: reviews }
  action: ALLOW
  rules:
    - from:
        - source:
            principals: ["cluster.local/ns/bookinfo/sa/bookinfo-productpage"]
      to:
        - operation:
            methods: ["GET"]
            paths: ["/reviews/*"]
```

### Rule structure

A rule has:
- `from`: source (principals, namespaces, IP ranges, identity)
- `to`: operation (hosts, ports, methods, paths)
- `when`: arbitrary conditions on attributes (request.auth.claims, headers)

A rule matches if ALL `from`, `to`, and `when` conditions are satisfied. Multiple rules in a policy are OR-ed (any rule matching is sufficient).

### Evaluation order

1. CUSTOM policies (external authz)
2. DENY policies
3. ALLOW policies (if any apply to the workload)
4. Default: allow if no ALLOW exists; deny if any ALLOW exists and none match

This is the rule that catches people: an ALLOW with no rules denies everything.

### Example: deny everything except specific calls

```yaml
spec:
  selector: { matchLabels: { app: reviews } }
  action: ALLOW
  rules:
    - from: [{ source: { principals: ["cluster.local/ns/bookinfo/sa/bookinfo-productpage"] }}]
```

### Example: deny a path globally

```yaml
spec:
  action: DENY
  rules:
    - to: [{ operation: { paths: ["/admin/*"] } }]
```

### JWT-based AuthZ

Combine RequestAuthentication with AuthorizationPolicy on `request.auth` attributes:

```yaml
spec:
  selector: { matchLabels: { app: api } }
  action: ALLOW
  rules:
    - from: [{ source: { requestPrincipals: ["*"] } }]
      when:
        - key: request.auth.claims[role]
          values: ["admin", "editor"]
```

## Identity (SPIFFE)

Each workload's SPIFFE identity:

```
spiffe://cluster.local/ns/<namespace>/sa/<serviceaccount>
```

This is the principal used in AuthorizationPolicy `from.source.principals`.

## Certificate Management

- istiod (Citadel) is the default CA
- Each workload gets a short-lived cert (24h default), rotated automatically
- Custom CA: provide `cacerts` Secret in `istio-system` to bring your own CA

Inspect a workload's cert:

```bash
istioctl proxy-config secret <pod> -n <ns>
```

## Common Patterns

### Mesh-wide default deny, allow-list per namespace

```yaml
# In istio-system
apiVersion: security.istio.io/v1
kind: AuthorizationPolicy
metadata: { name: deny-all, namespace: istio-system }
spec:
  {}    # no selector + no rules + ALLOW default = deny-all mesh-wide
  action: ALLOW
```

Then add namespace-scoped ALLOW policies that enumerate permitted callers.

### Block external traffic from reaching a workload

```yaml
spec:
  selector: { matchLabels: { app: backend } }
  action: DENY
  rules:
    - from: [{ source: { notNamespaces: ["bookinfo"] } }]
```

## Troubleshooting

Common AuthZ failure: 403 with `RBAC: access denied` in access logs.

Steps:
1. `istioctl x describe pod <pod>` shows policies that apply
2. Check `from.source.principals` value matches expected SPIFFE
3. Check `to.operation.paths` and `methods` match the actual request
4. Verify mTLS works (principals require mTLS auth; without it, principal is empty)

Common mTLS failure: connection reset or 503.

Steps:
1. `istioctl proxy-config secret <pod>` - is the cert present and valid?
2. Check PeerAuthentication mode and scope
3. Confirm both ends have sidecars

## Common Exam Traps

- ALLOW with no rules = deny-all
- PeerAuthentication STRICT placed wrong scope
- RequestAuthentication does not enforce; must combine with AuthorizationPolicy
- Forgetting `cluster.local/ns/<ns>/sa/<sa>` SPIFFE format
- Confusing requestPrincipals (JWT) with principals (mTLS identity)
- Missing sidecar on caller (no identity, no mTLS, AuthZ denies)
