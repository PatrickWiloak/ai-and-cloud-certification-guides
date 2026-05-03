# CDN Explained

> **5-minute read.**

## The one-line answer

A CDN (Content Delivery Network) is a global network of caching servers placed close to users. When a user requests something, they get it from the nearest cache instead of crossing the planet to your origin server.

## Why this exists

Speed of light is finite. From New York to Singapore is ~250ms round trip - just for the network. Add server processing, and a user in Singapore hitting a US-only server feels every page load.

CDNs solved this by:

1. Putting cache servers in 100s of cities ("points of presence" / PoPs)
2. Caching static content (images, JS, CSS, video) at the PoP closest to the user
3. Routing dynamic requests through the nearest PoP for TLS termination + smart routing back to your origin

End result: a user in Tokyo loads your site in ~30ms instead of ~250ms, even though your servers are in Virginia.

## How it works

```
User in Tokyo
    |
    v
[CDN PoP in Tokyo]  ← caches the JS bundle, images, etc.
    |
    | (only when cache miss)
    v
[Your origin in us-east-1]  ← actually serves the asset once
```

First user in Tokyo: cache miss, request goes to origin (~150ms).
Origin sends asset back to PoP.
PoP caches it.
Next 1,000 users in Tokyo: cache hit, ~10ms.

## What gets cached

CDNs are most valuable for:

- **Static assets** - images, CSS, JS, fonts, videos
- **API responses with proper cache headers** (e.g., `Cache-Control: max-age=300`)
- **HTML pages** that don't change per-user (marketing sites, blogs)
- **Edge-rendered HTML** (newer pattern: Vercel, Cloudflare Workers, etc.)

Hard to cache:
- Per-user dashboards
- Authenticated content
- Anything that changes constantly

## What CDNs do besides caching

Modern CDNs are doing more than caching:

### TLS termination
Browsers negotiate TLS with the nearest PoP, not your origin. Faster handshake (one fewer round trip across the world).

### DDoS protection
CDNs absorb traffic floods at the edge. Your origin never sees most of it.

### WAF (Web Application Firewall)
Block SQL injection, XSS, bot traffic at the edge.

### Edge compute
Run your code at the PoP closest to the user. Cloudflare Workers, AWS CloudFront Functions / Lambda@Edge, Fastly Compute@Edge.

### Image optimization
Resize, recompress, convert to modern formats (WebP, AVIF) on the fly.

### Smart routing
Route requests through the optimal path back to your origin (Cloudflare Argo, AWS Global Accelerator).

## A small concrete example

Without CDN:

```
User in São Paulo
    |  ~200ms RTT
    v
Origin in us-east-1 (Virginia)
- TLS handshake: ~600ms
- HTML response: ~250ms
- 30 separate requests for JS/CSS/images: ~30 * 200ms = 6000ms
Total: 7+ seconds, terrible.
```

With CDN:

```
User in São Paulo
    |  ~10ms RTT
    v
Cloudflare PoP in São Paulo
- TLS handshake: ~30ms
- HTML response: ~250ms (cache miss, fetched from origin once)
- JS/CSS/images: cached at PoP, ~5ms each
Total: ~500ms.
```

10x improvement. Same servers. Just a CDN in front.

## The big CDN providers

| Provider | Strengths |
|----------|-----------|
| **Cloudflare** | Largest network, generous free tier, built-in WAF, edge compute (Workers) |
| **AWS CloudFront** | Tight AWS integration, S3/ALB origins, Lambda@Edge |
| **Fastly** | Programmable cache (VCL → now Compute@Edge), high-performance, premium pricing |
| **Akamai** | Largest enterprise CDN, longest history, complex pricing |
| **Bunny.net** | Cheap, simple, good for video/static |
| **Vercel / Netlify** | CDN bundled with hosting; great for Next.js / static sites |

For most use cases: Cloudflare. Free tier is enormous, defaults are sane, and it adds DDoS / WAF on top.

## Cache invalidation

The hard part. When you deploy a new version of your site, the CDN still has the old version cached. Two patterns:

### Purge (manual or API)
Tell the CDN to evict specific URLs. Works, but slow at scale.

### Cache-busting URLs
Append a hash to filenames: `app.a3b9.js`. New version = new filename = no stale cache. The classic deployment pattern for SPAs.

For HTML, you typically use short TTLs (e.g., 60 seconds) + serve `Cache-Control: public, max-age=60`.

## When you need a CDN

Probably day one for:
- Anything user-facing globally
- Marketing sites (every kilobyte matters for conversion)
- Apps with images, video, or large JS bundles

Maybe not yet:
- Internal tools used by 10 people in one timezone
- Backend APIs with no static content (though edge TLS termination still helps)

If you're behind Cloudflare's free plan, you basically have a CDN with no work. Most modern static-site hosts include one.

## What to look at next

- **[VPC explained](./vpc-explained.md)** - the origin lives in a VPC; CDN sits in front
- **[TLS and HTTPS](./tls-and-https.md)** - CDNs typically terminate TLS at the edge
- **[Glossary: CDN, Edge location, TTL](../glossary.md#networking)**
