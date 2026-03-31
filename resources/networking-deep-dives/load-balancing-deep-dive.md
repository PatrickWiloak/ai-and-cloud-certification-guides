# Load Balancing Deep Dive

Comprehensive guide to load balancing concepts and cloud services.

---

## Layer 4 vs Layer 7 Load Balancing

### Layer 4 (Transport Layer)

Operates at the TCP/UDP level. Routes traffic based on IP address and port number without inspecting the application payload.

**Characteristics**
- Faster - minimal processing overhead
- Protocol-agnostic (works with any TCP/UDP protocol)
- Cannot make routing decisions based on HTTP headers, cookies, or URL paths
- Connection is forwarded directly to the backend
- Supports non-HTTP protocols (database connections, MQTT, custom TCP)

**Use Cases**
- Non-HTTP workloads (databases, message queues, gaming servers)
- Extreme performance requirements (millions of connections per second)
- Simple TCP/UDP pass-through with minimal latency
- Network load balancing for Kubernetes services (type: LoadBalancer)

### Layer 7 (Application Layer)

Operates at the HTTP/HTTPS level. Inspects the application payload to make intelligent routing decisions.

**Characteristics**
- Content-based routing (URL path, host header, HTTP headers, cookies)
- SSL/TLS termination at the load balancer
- HTTP/2 and WebSocket support
- Request/response manipulation (header injection, URL rewriting)
- Advanced health checks (HTTP status codes, response body matching)
- Web Application Firewall (WAF) integration

**Use Cases**
- Web applications and APIs
- Microservices with path-based routing (`/api/*` to backend, `/static/*` to CDN)
- Host-based routing (multiple domains on one load balancer)
- A/B testing and canary deployments with weighted routing

---

## Cloud Load Balancing Services

### AWS Load Balancers

**Application Load Balancer (ALB) - Layer 7**
- HTTP/HTTPS traffic routing
- Path-based and host-based routing rules
- Target groups: instances, IPs, Lambda functions, containers
- Native integration with ECS, EKS, and WAF
- Fixed response and redirect actions
- Authentication with Cognito or OIDC
- Pricing: hourly charge + LCU (Load Balancer Capacity Units)
- Docs: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html

**Network Load Balancer (NLB) - Layer 4**
- Ultra-high performance (millions of requests per second)
- Static IP addresses (one per AZ) and Elastic IP support
- Preserves source IP address
- TCP, UDP, and TLS traffic
- Target groups: instances, IPs, ALB (for combining L4 and L7)
- Cross-zone load balancing (disabled by default)
- Pricing: hourly charge + NLCU
- Docs: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html

**Gateway Load Balancer (GWLB) - Layer 3**
- Transparent network gateway for third-party virtual appliances
- Used for firewalls, IDS/IPS, deep packet inspection
- GENEVE encapsulation protocol
- Integrates with Transit Gateway
- Docs: https://docs.aws.amazon.com/elasticloadbalancing/latest/gateway/introduction.html

### Azure Load Balancers

**Azure Load Balancer - Layer 4**
- Internal and public (internet-facing) options
- Supports TCP and UDP
- Standard SKU: zone-redundant, supports availability zones
- Outbound rules for SNAT configuration
- Health probes: TCP, HTTP, HTTPS
- Docs: https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-overview

**Azure Application Gateway - Layer 7**
- HTTP/HTTPS routing with URL path-based rules
- SSL termination and end-to-end SSL
- Web Application Firewall (WAF v2) integration
- Autoscaling (v2 SKU)
- Cookie-based session affinity
- WebSocket and HTTP/2 support
- Docs: https://learn.microsoft.com/en-us/azure/application-gateway/overview

**Azure Front Door - Global Layer 7**
- Global load balancing with anycast
- CDN capabilities built in
- WAF integration
- SSL offloading with managed certificates
- URL rewriting and redirect rules
- Session affinity
- Docs: https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview

### GCP Load Balancers

**External HTTP(S) Load Balancer - Global Layer 7**
- Global load balancing with single anycast IP
- URL maps for path-based routing
- Backend services: instance groups, NEGs, Cloud Storage buckets
- Cloud CDN integration
- Cloud Armor (WAF/DDoS) integration
- Docs: https://cloud.google.com/load-balancing/docs/https

**External TCP/UDP Network Load Balancer - Regional Layer 4**
- Pass-through (preserves source IP)
- Regional scope
- Backend services or target pools
- Docs: https://cloud.google.com/load-balancing/docs/network

**External TCP Proxy Load Balancer - Global Layer 4**
- Global load balancing for non-HTTP TCP traffic
- SSL termination support
- Single global IP address

**Internal HTTP(S) Load Balancer - Regional Layer 7**
- Layer 7 load balancing for internal services
- Envoy-based proxy
- Path-based routing within a VPC

**Internal TCP/UDP Load Balancer - Regional Layer 4**
- Internal passthrough load balancer
- Preserves source IP
- Used for internal non-HTTP services

**Docs (all GCP LBs):** https://cloud.google.com/load-balancing/docs/load-balancing-overview

---

## Health Check Strategies

### Health Check Types

**TCP Health Check**
- Verifies the port is open and accepting connections
- Simplest check - does not validate application health
- Use when: the application does not have an HTTP endpoint

**HTTP/HTTPS Health Check**
- Sends an HTTP request and checks the response code
- Can validate response body content
- More reliable indicator of application health
- Recommended path: `/health` or `/healthz`

**Custom Health Checks**
- Check database connectivity
- Validate cache availability
- Verify downstream service dependencies
- Return degraded status for partial failures

### Health Check Configuration

```
Key Parameters:
  - Interval: how often to check (e.g., 30 seconds)
  - Timeout: how long to wait for a response (e.g., 5 seconds)
  - Healthy threshold: consecutive successes to mark healthy (e.g., 3)
  - Unhealthy threshold: consecutive failures to mark unhealthy (e.g., 2)
```

**Best Practices**
- Health check interval should be shorter than the expected failure detection time
- Unhealthy threshold of 2-3 prevents false positives from transient issues
- Health check endpoint should be lightweight (minimal processing)
- Include dependency checks but with timeouts (do not let a slow database make the health check time out)
- Separate liveness (is the process alive?) from readiness (can it serve traffic?)

### Graceful Shutdown

```
1. Load balancer marks target as draining
2. New connections are sent to other targets
3. Existing connections are allowed to complete
4. After deregistration delay, target is removed
```
- AWS: deregistration delay (default 300 seconds)
- Azure: connection draining (up to 30 minutes)
- GCP: connection draining timeout (configurable)

---

## SSL/TLS Termination

### Termination at the Load Balancer

```
Client --HTTPS--> Load Balancer --HTTP--> Backend Servers
```

**Benefits**
- Offloads CPU-intensive encryption from backend servers
- Centralized certificate management
- Simplifies backend server configuration
- Enables Layer 7 inspection and routing

**Managed Certificates**
- AWS: ACM (AWS Certificate Manager) - free public certificates
- Azure: App Service Managed Certificates, Key Vault integration
- GCP: Google-managed SSL certificates

### End-to-End Encryption

```
Client --HTTPS--> Load Balancer --HTTPS--> Backend Servers
```

- Required for compliance in some industries
- Load balancer re-encrypts traffic to backends
- Backend servers need their own certificates
- Higher CPU usage but ensures encryption in transit throughout

### TLS Best Practices

- Use TLS 1.2 or 1.3 (disable TLS 1.0 and 1.1)
- Strong cipher suites only
- Enable HSTS (HTTP Strict Transport Security) headers
- Implement certificate rotation before expiry
- Use SNI (Server Name Indication) for multiple domains on one IP

---

## Global Server Load Balancing (GSLB)

### What is GSLB?

Distributes traffic across multiple geographic regions, typically using DNS-based routing.

### Architecture

```
User DNS Query
  |
  v
GSLB (DNS-based)
  |
  +-- Region A (us-east-1) -> Regional Load Balancer -> Servers
  |
  +-- Region B (eu-west-1) -> Regional Load Balancer -> Servers
  |
  +-- Region C (ap-southeast-1) -> Regional Load Balancer -> Servers
```

### Implementation Options

**DNS-Based GSLB**
- Route 53 latency/geolocation routing
- Azure Traffic Manager
- GCP Cloud DNS routing policies
- Third-party: Cloudflare, NS1, Akamai

**Anycast-Based GSLB**
- Single IP address advertised from multiple locations
- Network routing directs clients to the nearest point of presence
- GCP External HTTP(S) LB uses anycast natively
- Azure Front Door uses anycast
- AWS Global Accelerator uses anycast

**Comparison**
| Feature | DNS-based | Anycast-based |
|---|---|---|
| Failover speed | Depends on TTL | Near-instant |
| Client caching | Can delay failover | Not affected |
| Granularity | Per DNS resolver | Per client connection |
| Protocol support | Any | TCP/UDP |

---

## Session Persistence and Sticky Sessions

### What is Session Persistence?

Ensures that requests from the same client are always routed to the same backend server.

### Types

**Cookie-Based (Layer 7)**
- Load balancer generates a cookie (e.g., `AWSALB`, `ApplicationGatewayAffinity`)
- Subsequent requests with the cookie go to the same target
- Duration-based: cookie expires after a set time
- Application-based: application generates the cookie

**Source IP-Based (Layer 4)**
- Routes based on client IP address
- Less reliable due to NAT, proxies, and mobile networks changing IPs
- Used when cookies are not available (non-HTTP protocols)

### When to Use Sticky Sessions

**Use When**
- Application stores session state in-memory (not recommended for new designs)
- WebSocket connections that must stay on the same server
- Long-running uploads or processing tied to a specific server

**Avoid When Possible**
- Sticky sessions reduce the effectiveness of load balancing
- A failed server loses all its sessions
- Better alternatives: external session store (Redis, DynamoDB), JWT tokens, stateless architecture

---

## WebSocket and gRPC Support

### WebSocket Load Balancing

**How It Works**
- Client sends HTTP Upgrade request
- Load balancer establishes WebSocket connection
- Connection is persistent (long-lived)
- All messages on the connection go to the same backend

**Cloud Support**
- AWS ALB: full WebSocket support (automatic upgrade detection)
- Azure Application Gateway: WebSocket support enabled by default
- GCP HTTP(S) LB: WebSocket support via backend service timeout configuration

**Considerations**
- Set appropriate idle timeouts (WebSocket connections are long-lived)
- Health checks must account for WebSocket backends
- Connection draining must wait for WebSocket connections to close
- Scale considerations: each server has a limit on concurrent connections

### gRPC Load Balancing

**How It Works**
- gRPC uses HTTP/2 with persistent connections and multiplexed streams
- Layer 7 load balancing can route individual gRPC calls
- Layer 4 load balancing routes entire connections (less granular)

**Cloud Support**
- AWS ALB: gRPC support with target group protocol version set to gRPC
- Azure Application Gateway v2: gRPC support
- GCP HTTP(S) LB: native gRPC support with health checks

**Best Practices**
- Use Layer 7 load balancing for per-request distribution
- Layer 4 load balancing may cause uneven distribution due to connection reuse
- Client-side load balancing (via service mesh or gRPC built-in) is an alternative
- Configure HTTP/2 on both the load balancer and backends

---

## Load Balancing Algorithms

| Algorithm | Description | Best For |
|---|---|---|
| Round Robin | Requests distributed sequentially | Equal-capacity servers |
| Weighted Round Robin | Requests distributed by assigned weights | Mixed-capacity servers |
| Least Connections | Sent to server with fewest active connections | Variable request duration |
| Least Response Time | Sent to server with fastest response | Heterogeneous backends |
| IP Hash | Consistent mapping of client IP to server | Session persistence without cookies |
| Random | Randomly selected backend | Simple and effective at scale |

---

## Additional Resources

- [AWS ELB Documentation](https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/what-is-load-balancing.html)
- [Azure Load Balancing Decision Tree](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/load-balancing-overview)
- [GCP Load Balancing Overview](https://cloud.google.com/load-balancing/docs/load-balancing-overview)
- [NGINX Load Balancing Guide](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/)
