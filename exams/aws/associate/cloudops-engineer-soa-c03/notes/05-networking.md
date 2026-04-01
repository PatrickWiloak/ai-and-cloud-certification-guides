# Networking and Content Delivery

**[Amazon VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)** - Virtual Private Cloud documentation

## VPC Architecture

### VPC Fundamentals

**VPC Components**:
- **CIDR Block** - IP address range (e.g., 10.0.0.0/16) - /16 to /28
- **Subnets** - subdivisions within AZs
- **Route Tables** - control traffic routing
- **Internet Gateway** - connects VPC to the internet
- **NAT Gateway** - enables outbound internet for private subnets

**[VPC Components](https://docs.aws.amazon.com/vpc/latest/userguide/how-it-works.html)** - How VPC works

### Subnets

**Public Subnets**:
- Route table has route to Internet Gateway (0.0.0.0/0 -> IGW)
- Instances have public or Elastic IP addresses
- Used for: load balancers, bastion hosts, NAT Gateways

**Private Subnets**:
- No direct route to Internet Gateway
- Outbound internet via NAT Gateway in public subnet
- Used for: application servers, databases, backend services

**[Subnets](https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html)** - Subnet configuration

### Route Tables

- Each subnet associated with exactly one route table
- Local route for VPC CIDR is automatic and cannot be removed
- Most specific route wins (longest prefix match)
- Separate route tables for public and private subnets

**Common Routes**:
- `10.0.0.0/16 -> local` (VPC internal traffic)
- `0.0.0.0/0 -> igw-xxx` (public subnet internet access)
- `0.0.0.0/0 -> nat-xxx` (private subnet outbound internet)
- `172.16.0.0/16 -> pcx-xxx` (VPC peering)
- `0.0.0.0/0 -> tgw-xxx` (Transit Gateway)

**[Route Tables](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html)** - Routing configuration

### Internet Gateway
- Horizontally scaled, redundant, highly available
- One IGW per VPC
- Performs NAT for instances with public IP addresses
- Must be attached to VPC and referenced in route table

### NAT Gateway

**[NAT Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html)** - Network Address Translation

- Managed NAT service in a public subnet
- Allows private subnet instances to reach the internet
- Does not allow inbound connections from internet
- AZ-specific - deploy one per AZ for high availability
- Scales automatically up to 100 Gbps
- Elastic IP address required

**NAT Gateway vs NAT Instance**:
- NAT Gateway: managed, scales automatically, HA within AZ
- NAT Instance: self-managed EC2, manual scaling, single point of failure
- NAT Gateway recommended for production workloads

## Security Groups and NACLs

### Security Groups (Stateful)

**[Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html)** - Instance-level firewall

**Key Properties**:
- Applied at instance (ENI) level
- Allow rules only - no deny rules
- Stateful - return traffic automatically allowed
- Default: deny all inbound, allow all outbound
- Can reference other security groups as sources

**Best Practices**:
- Principle of least privilege - only open required ports
- Use security group references instead of IP ranges when possible
- Separate security groups by function (web, app, database)
- Document the purpose of each rule

### Network ACLs (Stateless)

**[Network ACLs](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html)** - Subnet-level firewall

**Key Properties**:
- Applied at subnet level
- Allow AND deny rules
- Stateless - return traffic must be explicitly allowed
- Rules evaluated in number order (lowest first)
- Default NACL allows all inbound and outbound
- Custom NACLs deny all by default

**Ephemeral Ports**:
- Outbound NACL rules must allow ephemeral ports (1024-65535)
- Needed for return traffic from internet requests
- Common mistake: blocking return traffic with NACL rules

### Security Groups vs NACLs

| Feature | Security Groups | NACLs |
|---------|----------------|-------|
| Level | Instance/ENI | Subnet |
| State | Stateful | Stateless |
| Rules | Allow only | Allow and Deny |
| Default | Deny inbound, allow outbound | Allow all (default NACL) |
| Evaluation | All rules evaluated | Rules evaluated in order |
| Return traffic | Automatic | Must be explicitly allowed |

## VPC Connectivity

### VPC Peering

**[VPC Peering](https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html)** - Connect two VPCs

- Direct network connection between two VPCs
- Can be same account or cross-account, same region or cross-region
- No transitive peering - each VPC pair needs its own connection
- CIDR ranges cannot overlap
- Route table entries required in both VPCs

### Transit Gateway

**[Transit Gateway](https://docs.aws.amazon.com/vpc/latest/tgw/what-is-transit-gateway.html)** - Network hub

- Hub-and-spoke model for connecting VPCs and on-premises networks
- Supports transitive routing (unlike VPC peering)
- Route tables for controlling traffic flow between attachments
- Supports VPC, VPN, Direct Connect Gateway, and peering attachments
- Multi-region with Transit Gateway peering

### VPC Endpoints

**[VPC Endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints.html)** - Private access to AWS services

**Gateway Endpoints** (free):
- S3 and DynamoDB only
- Route table entry pointing to endpoint
- No ENI required

**Interface Endpoints** (PrivateLink):
- ENI with private IP in your subnet
- Supports most AWS services
- DNS resolution to private IP
- Security group attached to endpoint ENI
- Costs per hour and per GB processed

**Best Practice**: Use VPC endpoints to avoid internet traffic for AWS service access - improves security and can reduce NAT Gateway costs.

## VPN and Direct Connect

### Site-to-Site VPN

**[Site-to-Site VPN](https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html)** - Encrypted connections over internet

**Components**:
- **Virtual Private Gateway (VGW)** - AWS side of VPN connection
- **Customer Gateway** - on-premises side of VPN connection
- **VPN Connection** - two IPSec tunnels for redundancy

**Key Points**:
- Encrypted over public internet
- Bandwidth limited by internet connection
- Quick to set up (minutes to hours)
- Supports BGP and static routing
- Use as backup for Direct Connect

### AWS Direct Connect

**[AWS Direct Connect](https://docs.aws.amazon.com/directconnect/latest/UserGuide/Welcome.html)** - Dedicated network connection

**Key Features**:
- Dedicated 1 Gbps or 10 Gbps connections
- Hosted connections: 50 Mbps to 10 Gbps
- Consistent network performance (not over internet)
- Lower data transfer costs than internet
- Setup time: weeks to months

**Virtual Interfaces**:
- **Private VIF** - connect to VPC resources
- **Public VIF** - connect to AWS public services
- **Transit VIF** - connect to Transit Gateway

**Direct Connect + VPN** - encryption over Direct Connect:
- Direct Connect does not encrypt traffic by default
- Run site-to-site VPN over Direct Connect for encryption
- Provides both consistent performance and encryption

### AWS VPN CloudHub
- Hub-and-spoke model for multiple VPN connections
- Multiple customer gateways connect through single VGW
- Enables site-to-site communication through AWS

## Amazon Route 53

**[Route 53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html)** - DNS management

### Record Types
- **A** - maps domain to IPv4 address
- **AAAA** - maps domain to IPv6 address
- **CNAME** - maps domain to another domain (cannot be zone apex)
- **Alias** - maps domain to AWS resource (can be zone apex, free for AWS resources)
- **MX** - mail exchange records
- **TXT** - text records (verification, SPF)
- **NS** - name server records

### Hosted Zones
- **Public hosted zone** - routes internet traffic
- **Private hosted zone** - routes traffic within VPCs
- Associate private hosted zones with VPCs

### Routing Policies
- **Simple** - single resource, no health checks
- **Weighted** - distribute by percentage (useful for A/B testing)
- **Latency** - route to lowest latency region
- **Failover** - active-passive with health checks
- **Geolocation** - route by user geographic location
- **Geoproximity** - route by resource location with bias
- **Multivalue Answer** - return multiple healthy records (up to 8)

**[Routing Policies](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html)** - Traffic management

## Amazon CloudFront

**[Amazon CloudFront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html)** - Content Delivery Network

### Distribution Components
- **Origins** - source of content (S3, ALB, API Gateway, custom HTTP)
- **Behaviors** - rules for how CloudFront handles requests
- **Edge Locations** - points of presence for content caching
- **Regional Edge Caches** - intermediate cache layer

### Cache Configuration
- **TTL** - minimum, default, and maximum time-to-live
- **Cache Key** - determines what constitutes a unique object
- **Cache Policies** - define what's included in cache key
- **Origin Request Policies** - control what's forwarded to origin
- **Invalidation** - remove objects from edge caches before TTL

### Origin Failover
- **Origin Groups** - primary and secondary origins
- Automatic failover when primary returns specific error codes
- Improves availability of content delivery

### Edge Computing

**CloudFront Functions**:
- Lightweight JavaScript for simple transformations
- Sub-millisecond execution at edge locations
- Use for: URL rewrites, header manipulation, redirects
- Millions of requests per second

**Lambda@Edge**:
- Node.js or Python at regional edge caches
- More compute power than CloudFront Functions
- Access to request body and network calls
- Use for: A/B testing, authentication, dynamic content

**[Lambda@Edge](https://docs.aws.amazon.com/lambda/latest/dg/lambda-edge.html)** - Edge computing

### CloudFront Security
- **Origin Access Control (OAC)** - restrict S3 access to CloudFront only
- **HTTPS enforcement** - redirect HTTP to HTTPS
- **Custom SSL certificates** - via ACM (us-east-1 for CloudFront)
- **Geo-restriction** - allow or block by country
- **AWS WAF integration** - web application protection
- **Field-level encryption** - encrypt sensitive form fields

## Troubleshooting Common Issues

### Cannot Connect to Instance
1. Check security group inbound rules
2. Verify NACL allows traffic in both directions
3. Confirm route table has correct routes
4. Verify instance has public IP (if connecting from internet)
5. Check IGW is attached and routed

### Private Subnet Cannot Reach Internet
1. Verify NAT Gateway exists in public subnet
2. Check private subnet route table: 0.0.0.0/0 -> NAT Gateway
3. Verify NAT Gateway's subnet routes to IGW
4. Check security groups and NACLs
5. Verify NAT Gateway has Elastic IP

### VPC Peering Not Working
1. Peering connection accepted by both sides
2. Route tables updated in both VPCs
3. CIDR ranges do not overlap
4. Security groups allow traffic from peer VPC CIDR
5. NACLs allow traffic in both directions

## Key Takeaways

1. **Security groups are stateful, NACLs are stateless** - most common exam topic
2. **NAT Gateway** - deploy per AZ for high availability, requires Elastic IP
3. **VPC endpoints** - Gateway (S3/DynamoDB, free) vs Interface (most services, cost)
4. **Transit Gateway** - enables transitive routing, unlike VPC peering
5. **Direct Connect** - consistent performance but not encrypted by default
6. **Route 53** - know all routing policies and when to use each
7. **CloudFront** - OAC for S3, origin failover for availability
8. **Troubleshooting** - systematic approach: routes, security groups, NACLs, gateways
