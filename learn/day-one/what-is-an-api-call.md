---
last-updated: 2026-05-03
---

# What is an API call?

> **5-minute read.** When apps talk to other apps, they make API calls. Almost every cloud feature, every web app, every mobile app does this constantly. Knowing the parts of a call lets you read documentation and debug failures.

## The mental model

An API call is just an HTTP request to a URL. There are four parts:

```
METHOD  URL                                       HEADERS                       BODY (optional)
GET     https://api.example.com/users/42          Authorization: Bearer xyz     (none)
POST    https://api.example.com/orders            Content-Type: application/json {"item": "shirt"}
```

That's it. Every API on the internet is a variant of this shape.

## The four parts

### Method

The verb. Common ones:

| Method | Meaning | Idempotent? |
|---|---|---|
| **GET** | Read | Yes |
| **POST** | Create | No |
| **PUT** | Replace | Yes |
| **PATCH** | Update partially | No (usually) |
| **DELETE** | Remove | Yes |

GET should never modify state. POST should. The rest you'll meet less often.

### URL

The endpoint. Often shaped like a noun hierarchy:

```
https://api.example.com/v1/users/42/orders
                       ^   ^     ^  ^
                       version  collection  id  sub-collection
```

The pattern `GET /users/42/orders` reads as "give me the orders for user 42." That's REST style; modern APIs lean this way but plenty don't.

### Headers

Metadata the server uses to interpret the request:

- `Authorization: Bearer <token>` - who are you (most APIs use this)
- `Content-Type: application/json` - the body format
- `Accept: application/json` - the response format you want
- `User-Agent: MyApp/1.0` - what client is calling
- `X-Request-Id: abc123` - your own correlation ID for debugging

### Body

For POST / PUT / PATCH, the data you're sending. Almost always JSON these days:

```json
{
  "item": "shirt",
  "quantity": 2,
  "shipping_address": "123 Main St"
}
```

GET requests don't have a body; their parameters go in the URL as a query string:

```
GET /search?q=shoes&limit=10
```

## The response

Same shape, different direction:

```
STATUS  HEADERS                                 BODY
200 OK  Content-Type: application/json          {"id": 42, "name": "Alice"}
```

### Status codes (memorize the families)

| Range | Meaning |
|---|---|
| **2xx** | Success |
| **3xx** | Redirect |
| **4xx** | Client error (you sent something wrong) |
| **5xx** | Server error (the server broke) |

The most common ones:
- **200 OK** - it worked
- **201 Created** - resource created (after POST)
- **204 No Content** - it worked, nothing to return
- **301 / 302** - redirect to another URL
- **400 Bad Request** - your input is malformed
- **401 Unauthorized** - you didn't authenticate
- **403 Forbidden** - you authenticated but aren't allowed
- **404 Not Found** - URL doesn't exist
- **409 Conflict** - state conflict (duplicate, race condition)
- **422 Unprocessable Entity** - syntactically valid, semantically invalid (e.g., missing required field)
- **429 Too Many Requests** - rate limited
- **500 Internal Server Error** - server bug
- **502 / 503 / 504** - server overloaded, dependency down, timeout

## Making API calls

### From the terminal: `curl`

```bash
# Simple GET
curl https://api.example.com/users/42

# Show headers + status (-i)
curl -i https://api.example.com/users/42

# Verbose (-v) shows request and response in detail
curl -v https://api.example.com/users/42

# Pass auth header
curl -H "Authorization: Bearer xyz" https://api.example.com/users/42

# POST with JSON body
curl -X POST https://api.example.com/orders \
  -H "Authorization: Bearer xyz" \
  -H "Content-Type: application/json" \
  -d '{"item": "shirt"}'
```

### From code

Every language has an HTTP client. They all do the same thing:

```python
import requests
r = requests.post(
    "https://api.example.com/orders",
    headers={"Authorization": f"Bearer {token}"},
    json={"item": "shirt"},
)
print(r.status_code, r.json())
```

```javascript
const r = await fetch("https://api.example.com/orders", {
  method: "POST",
  headers: { "Authorization": `Bearer ${token}`, "Content-Type": "application/json" },
  body: JSON.stringify({ item: "shirt" }),
});
console.log(r.status, await r.json());
```

## Debugging a failing API call

In order:

1. **Read the status code.** 4xx vs 5xx tells you whose problem it is.
2. **Read the response body.** Most APIs return a structured error: `{"error": "missing field 'email'"}`.
3. **Check headers.** Missing `Authorization`, wrong `Content-Type`, rate-limit hint in `Retry-After` are common culprits.
4. **Add a request ID.** If the API supports `X-Request-Id`, include one; the server may log it for you to grep their support team's traces.
5. **Try with curl.** Reproduce outside your code; if curl works, the bug is in your code's HTTP setup, not the API.

## Things that come next

- **OpenAPI / Swagger**: machine-readable API specs. Great APIs publish one.
- **gRPC**: an alternative to JSON-over-HTTP for service-to-service calls. Faster, typed, harder to debug with curl.
- **Webhooks**: the API calls you. Inverse direction. You expose an endpoint; the provider POSTs to it on events.
- **Rate limits and retries with exponential backoff**: production callers handle 429s and 5xx by waiting and retrying.

## What to look at next

- **[HTTP and APIs](./http-and-apis.md)** - HTTP basics in more depth
- **[TLS and HTTPS](../concepts/tls-and-https.md)** - the encryption layer under HTTPS
- **[Networking troubleshooting](./networking-troubleshooting.md)** - when API calls don't connect at all
- **[Tool use and function calling](../concepts/tool-use-and-function-calling.md)** - what an LLM tool call looks like (it's also just an API)
