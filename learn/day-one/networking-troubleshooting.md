---
last-updated: 2026-05-03
---

# Networking troubleshooting

> **5-minute read.** "It's not working" is rarely "it's not working." Use the right diagnostic in the right order to narrow down where the request actually breaks.

## The diagnostic ladder

Always work from layer 3 outward. Don't start by inspecting HTTP headers if `ping` already tells you DNS or basic IP routing is broken.

### 1. DNS - does the name resolve?

```bash
dig example.com
dig example.com +short          # just the answer
dig example.com @1.1.1.1        # query a specific resolver
dig example.com +trace          # show the full resolution path
```

What you want: an IPv4 (`A`) or IPv6 (`AAAA`) record back. If `dig` returns no answer or `NXDOMAIN`, DNS is broken - either the record is missing, your resolver is wrong, or there's a typo.

`nslookup` does the same thing but the output is older and clunkier; modern guidance is to use `dig`.

### 2. ICMP - is the host reachable?

```bash
ping example.com
ping 93.184.216.34       # bypass DNS, test pure IP
```

If `ping` succeeds, basic IP routing works. If it fails:
- The target might block ICMP (many cloud security groups do by default - `ping` failing doesn't always mean "down")
- A firewall in between could be dropping ICMP
- The host might actually be down

### 3. Path - where is the packet getting lost?

```bash
traceroute example.com    # macOS / Linux
tracert example.com       # Windows
mtr example.com           # combined ping + traceroute, continuous
```

Shows each hop between you and the destination. The first hop that times out (`* * *`) is where to investigate. Common patterns:
- Hop 1 fails: your local router / VPN issue
- Hop 2-3 fails: your ISP or NAT
- Hops further out: ISP / backbone / target firewall

### 4. TCP / port - is the service listening?

```bash
nc -vz example.com 443         # netcat: open and close
telnet example.com 443         # older but works
curl -v telnet://example.com:443
```

If TCP connect succeeds, the port is open and something's listening. If not:
- The service isn't running
- Security group / firewall is blocking
- Wrong port

### 5. TLS - does the cert check out?

```bash
openssl s_client -connect example.com:443 -servername example.com < /dev/null
curl -vI https://example.com
```

Look for: cert valid, chain trusted, protocol version, SNI matching. Browser-level errors like "your connection is not private" usually map to one of these.

### 6. HTTP - what does the server actually say?

```bash
curl -vI https://example.com
curl https://example.com -o /dev/null -w "%{http_code} %{time_total}s\n"
curl https://api.example.com/users -H "Authorization: Bearer $TOKEN" -v
```

`-v` shows headers; `-vv` shows the request body. Now you're at the application layer.

## Other useful tools

```bash
# what's listening locally?
ss -tlnp                   # modern Linux
netstat -tlnp              # older systems

# what hostname am I, what's my IP?
hostname
hostname -I                # all IPs (Linux)
ip addr                    # detailed interface info

# routing table
ip route                   # Linux
route -n                   # older

# what's my public IP?
curl ifconfig.me
curl https://api.ipify.org

# is the firewall on?
sudo iptables -L           # Linux
sudo ufw status            # Ubuntu

# packet capture (advanced)
sudo tcpdump -i eth0 port 443
```

## A diagnostic playbook

When something doesn't connect, ask in order:

1. **Does the name resolve?** `dig`
2. **Can I reach the host?** `ping` (caveat: ICMP may be blocked)
3. **Is the port open?** `nc -vz host port`
4. **Does TLS work?** `openssl s_client` or `curl -vI`
5. **What does the server return?** `curl -v`
6. **What's listening locally?** `ss -tlnp`
7. **Where in the path is it failing?** `traceroute` / `mtr`

In cloud, also check: security groups / NSGs / firewall rules, route tables, NAT, public-IP assignment, IAM (some "network" failures are actually permission denied at the API layer).

## Things that look like network problems but aren't

- **DNS caching**: changes haven't propagated (browser, OS, resolver, ISP all cache). `dig +trace` bypasses caches.
- **TLS / cert mismatch**: name matches, host is up, port is open, but SNI / cert SAN doesn't match.
- **Authentication / authorization**: the network's fine, the API just refuses you. Read the actual response.
- **Rate limiting**: the API works for the first 100 calls, then 429s. Check headers.
- **CORS**: the request reaches the server fine, but the browser blocks the response. Check the JS console, not the network.

## What to look at next

- **[DNS explained](../concepts/dns-explained.md)** - the lookup layer
- **[TLS and HTTPS](../concepts/tls-and-https.md)** - what TLS actually does
- **[VPC explained](../concepts/vpc-explained.md)** - where most cloud network "issues" are actually security group rules
- **[What is a server?](./what-is-a-server.md)** - what's at the other end
