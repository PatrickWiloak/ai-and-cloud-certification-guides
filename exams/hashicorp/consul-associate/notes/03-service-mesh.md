# Service Mesh (Connect)

**[📖 Connect Overview](https://developer.hashicorp.com/consul/docs/connect)** - Service mesh documentation

## Overview

This document covers Consul Connect (service mesh), including sidecar proxies, intentions, mTLS, and gateways. Service mesh is 17% of the exam and tests understanding of how Consul secures and controls service-to-service communication.

## Connect Architecture

### Components
- **Control Plane:** Consul servers manage configuration, intentions, and certificates
- **Data Plane:** Envoy sidecar proxies handle traffic between services
- **Certificate Authority:** Built-in CA issues mTLS certificates
- **Intentions:** Authorization rules for service-to-service communication

### How Connect Works
1. Service registers with Consul and requests a sidecar proxy
2. Consul's CA issues a TLS certificate with the service identity (SPIFFE ID)
3. Sidecar proxy configured automatically by Consul
4. Inbound traffic: proxy terminates mTLS, forwards to local service
5. Outbound traffic: proxy initiates mTLS connection to destination's proxy
6. Intentions checked before allowing connection

**[📖 Connect Internals](https://developer.hashicorp.com/consul/docs/connect/connect-internals)** - Internal mechanics

## Sidecar Proxies

### Envoy Proxy
- Default and recommended proxy for Consul Connect
- Deployed alongside each service (sidecar pattern)
- Configured dynamically by Consul via xDS API
- Handles mTLS termination and origination
- Supports L4 and L7 traffic management

### Registration with Sidecar
```json
{
  "service": {
    "name": "web",
    "port": 8080,
    "connect": {
      "sidecar_service": {
        "proxy": {
          "upstreams": [
            {
              "destination_name": "api",
              "local_bind_port": 9191
            }
          ]
        }
      }
    }
  }
}
```

- `connect.sidecar_service` registers the sidecar proxy automatically
- `upstreams` define which services this service connects to
- `local_bind_port` is the local port the application uses to reach the upstream
- Application connects to `localhost:9191` to reach the "api" service

### Starting the Proxy
```bash
# Start Envoy sidecar proxy
consul connect envoy -sidecar-for web

# The proxy:
# 1. Registers with Consul as "web-sidecar-proxy"
# 2. Fetches TLS certificates from Consul CA
# 3. Configures upstream connections
# 4. Listens for inbound connections on a dynamic port
# 5. Proxies outbound connections to upstream services
```

### Built-in Proxy
```bash
# Start built-in proxy (development only, not production)
consul connect proxy -sidecar-for web
```

- Built-in proxy is simple L4 proxy
- No L7 features (no path-based routing, no observability)
- Use Envoy in production

## mTLS (Mutual TLS)

### Certificate Management
- Consul has a built-in Certificate Authority (CA)
- CA issues leaf certificates to services (SPIFFE format)
- Certificates automatically rotated before expiration
- Both client and server verify each other's identity (mutual)
- SPIFFE ID format: `spiffe://<trust-domain>/ns/<namespace>/dc/<datacenter>/svc/<service>`

**[📖 Certificate Authority](https://developer.hashicorp.com/consul/docs/connect/ca)** - CA configuration

### CA Providers
| Provider | Description | Use Case |
|----------|-------------|----------|
| Built-in (Consul) | Consul manages root and leaf CAs | Default, simple setup |
| Vault | HashiCorp Vault as CA backend | Enterprise PKI integration |
| AWS Private CA | AWS Certificate Manager Private CA | AWS-native PKI |

### Certificate Rotation
- Leaf certificates have configurable TTL (default: 72 hours)
- Certificates rotated automatically before expiration
- Root CA rotation supported with cross-signing
- No service disruption during rotation

## Intentions

### Overview
- Authorization rules controlling service-to-service communication
- Evaluated by sidecar proxies before allowing connections
- Default behavior depends on ACL configuration
- L4 intentions: allow/deny based on service identity
- L7 intentions: path-based, header-based rules (Envoy only)

**[📖 Intentions](https://developer.hashicorp.com/consul/docs/connect/intentions)** - Authorization rules

### L4 Intentions (Allow/Deny)
```bash
# Allow web to communicate with api
consul intention create web api

# Deny web from communicating with database
consul intention create -deny web database

# Allow all services to communicate with monitoring
consul intention create '*' monitoring

# Deny all by default
consul intention create -deny '*' '*'

# List intentions
consul intention list

# Check specific intention
consul intention check web api
# Output: Allowed

# Delete intention
consul intention delete web api
```

### L7 Intentions (Path-Based)
```hcl
# L7 intention via config entry
Kind = "service-intentions"
Name = "api"
Sources = [
  {
    Name = "web"
    Permissions = [
      {
        Action = "allow"
        HTTP {
          PathPrefix = "/api/v1"
          Methods    = ["GET", "POST"]
        }
      },
      {
        Action = "deny"
        HTTP {
          PathPrefix = "/admin"
        }
      }
    ]
  }
]
```

- L7 intentions require Envoy proxy (not built-in)
- Support path prefix, exact path, and regex matching
- Support HTTP method filtering
- Support header-based matching

### Intention Precedence
1. Exact source and destination match (most specific)
2. Wildcard source, exact destination
3. Exact source, wildcard destination
4. Wildcard source, wildcard destination (least specific)
5. More specific intentions take precedence over less specific

### Default Behavior
| ACL Configuration | Default Intention |
|-------------------|-------------------|
| ACLs disabled | Allow all |
| ACLs enabled, default allow | Allow all |
| ACLs enabled, default deny | Deny all |

## Gateways

### Ingress Gateway
- Allows external (non-mesh) traffic to enter the service mesh
- Listens on public-facing ports
- Routes traffic to mesh services based on configuration
- Handles TLS termination for external clients

**[📖 Ingress Gateway](https://developer.hashicorp.com/consul/docs/connect/gateways/ingress-gateway)** - Ingress documentation

```hcl
# Ingress gateway config entry
Kind = "ingress-gateway"
Name = "public-ingress"
Listeners = [
  {
    Port     = 8443
    Protocol = "http"
    Services = [
      { Name = "web" },
      { Name = "api" }
    ]
  }
]
```

### Terminating Gateway
- Allows mesh services to communicate with external (non-mesh) services
- Registers external services in the Consul catalog
- Handles mTLS origination to external services (if supported)
- External services appear as regular services to mesh consumers

**[📖 Terminating Gateway](https://developer.hashicorp.com/consul/docs/connect/gateways/terminating-gateway)** - Terminating documentation

```hcl
# Terminating gateway config entry
Kind = "terminating-gateway"
Name = "external-gateway"
Services = [
  {
    Name     = "external-db"
    CAFile   = "/etc/ssl/certs/db-ca.pem"
    CertFile = "/etc/ssl/certs/db-client.pem"
    KeyFile  = "/etc/ssl/private/db-client-key.pem"
  }
]
```

### Mesh Gateway
- Connects service meshes across datacenters
- Routes cross-datacenter mesh traffic
- Handles TLS between datacenters
- Supports three modes: local, remote, none

**[📖 Mesh Gateway](https://developer.hashicorp.com/consul/docs/connect/gateways/mesh-gateway)** - Cross-DC mesh

### Gateway Comparison
| Gateway | Direction | Use Case |
|---------|-----------|----------|
| Ingress | External to mesh | Public APIs, web frontends |
| Terminating | Mesh to external | External databases, third-party APIs |
| Mesh | Mesh to mesh (cross-DC) | Multi-datacenter service communication |

## Configuration Entries

### Overview
- Centrally managed configuration for Connect features
- Applied via CLI, API, or config files
- Stored in Consul's state (replicated across servers)
- Control proxy behavior, routing, and service defaults

```bash
# Apply config entry
consul config write service-defaults.hcl

# Read config entry
consul config read -kind service-defaults -name web

# List config entries
consul config list -kind service-defaults

# Delete config entry
consul config delete -kind service-defaults -name web
```

### Common Config Entry Kinds
| Kind | Purpose |
|------|---------|
| service-defaults | Default settings per service (protocol, mesh gateway mode) |
| service-intentions | L7 intentions for a service |
| proxy-defaults | Default proxy configuration for all services |
| ingress-gateway | Ingress gateway listener configuration |
| terminating-gateway | External service registration |
| service-router | L7 traffic routing rules |
| service-splitter | Traffic splitting (canary, blue/green) |
| service-resolver | Service resolution (failover, redirect) |
