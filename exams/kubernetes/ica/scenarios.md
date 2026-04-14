# Istio Certified Associate - Practice Scenarios

Ten realistic configuration and troubleshooting scenarios. Try writing the YAML or commands before reading the answer.

## Scenario 1: Canary 90/10

Bookinfo has reviews v1 and v2 deployed. Route 90 percent of traffic to v1, 10 percent to v2.

Answer:
```yaml
apiVersion: networking.istio.io/v1
kind: DestinationRule
metadata: { name: reviews, namespace: bookinfo }
spec:
  host: reviews
  subsets:
    - name: v1
      labels: { version: v1 }
    - name: v2
      labels: { version: v2 }
---
apiVersion: networking.istio.io/v1
kind: VirtualService
metadata: { name: reviews, namespace: bookinfo }
spec:
  hosts: [reviews]
  http:
    - route:
        - destination: { host: reviews, subset: v1 }
          weight: 90
        - destination: { host: reviews, subset: v2 }
          weight: 10
```

Tip: Apply DR first; if VS routes to a missing subset, requests 503.

## Scenario 2: Header-Based Routing

Send `end-user: jason` to reviews v2; everyone else to v1.

Answer:
```yaml
http:
  - match:
      - headers:
          end-user:
            exact: jason
    route:
      - destination: { host: reviews, subset: v2 }
  - route:
      - destination: { host: reviews, subset: v1 }
```

Order matters; the first match wins.

## Scenario 3: Mesh-Wide STRICT mTLS

Enforce STRICT mTLS for the entire mesh.

Answer:
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

Place in `istio-system` for mesh-wide. Verify with `istioctl proxy-config secret <pod>`.

## Scenario 4: Allow Only `productpage` SA to Call `reviews`

Answer:
```yaml
apiVersion: security.istio.io/v1
kind: AuthorizationPolicy
metadata: { name: reviews-allow, namespace: bookinfo }
spec:
  selector:
    matchLabels: { app: reviews }
  action: ALLOW
  rules:
    - from:
        - source:
            principals: ["cluster.local/ns/bookinfo/sa/bookinfo-productpage"]
```

Anything not matching is denied (since an ALLOW exists).

## Scenario 5: Diagnose "503 NR"

Calls to `reviews` return 503 with `NR` (No Route) flag in access logs.

Answer: NR means no matching route configured at the proxy. Check:
1. `istioctl proxy-config routes <productpage-pod>` - does a route to reviews exist?
2. `kubectl get vs,dr -n bookinfo` - are CRDs applied?
3. `istioctl analyze` - any reported errors?

Common cause: VS routes to a subset that DR does not define.

## Scenario 6: Configure 5s Timeout and 3 Retries

Answer:
```yaml
http:
  - route:
      - destination: { host: reviews }
    timeout: 5s
    retries:
      attempts: 3
      perTryTimeout: 1s
      retryOn: 5xx,reset,connect-failure
```

## Scenario 7: Inject 50% 7s Delay

Answer:
```yaml
http:
  - fault:
      delay:
        percentage: { value: 50 }
        fixedDelay: 7s
    route:
      - destination: { host: reviews }
```

## Scenario 8: Expose `productpage` via Gateway

Answer:
```yaml
apiVersion: networking.istio.io/v1
kind: Gateway
metadata: { name: bookinfo-gw, namespace: bookinfo }
spec:
  selector: { istio: ingressgateway }
  servers:
    - port: { number: 80, name: http, protocol: HTTP }
      hosts: ["bookinfo.example.com"]
---
apiVersion: networking.istio.io/v1
kind: VirtualService
metadata: { name: bookinfo-vs, namespace: bookinfo }
spec:
  hosts: ["bookinfo.example.com"]
  gateways: [bookinfo-gw]
  http:
    - match: [{ uri: { prefix: "/productpage" } }]
      route: [{ destination: { host: productpage, port: { number: 9080 } } }]
```

## Scenario 9: External Service via ServiceEntry

Allow workloads in `app` namespace to call `httpbin.org`.

Answer:
```yaml
apiVersion: networking.istio.io/v1
kind: ServiceEntry
metadata: { name: httpbin-ext, namespace: app }
spec:
  hosts: [httpbin.org]
  ports:
    - number: 443
      name: https
      protocol: HTTPS
  resolution: DNS
  location: MESH_EXTERNAL
```

## Scenario 10: Sidecars Not Injected

A new namespace `payments` was labeled `istio-injection=enabled`, but pods still have only one container.

Answer: Existing pods are not re-injected automatically. Restart deployments:

```bash
kubectl rollout restart deploy -n payments
```

If still not injected, check:
- Webhook config: `kubectl get mutatingwebhookconfiguration`
- Revision mismatch: if Istio installed with `--revision 1-22`, label must be `istio.io/rev=1-22`, not `istio-injection=enabled`
- Pod-level annotation overriding: `sidecar.istio.io/inject: "false"`
