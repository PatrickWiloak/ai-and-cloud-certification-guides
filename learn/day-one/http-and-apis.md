---
last-updated: 2026-05-03
---

# HTTP and APIs

> **10-minute read. How computers talk to each other on the internet.**

## What HTTP actually is

HTTP (Hypertext Transfer Protocol) is the rules computers follow when one wants to ask another for something over the internet. Every time you load a web page, click a button, or use an app, HTTP is involved.

The pattern is always: one computer (a **client**) sends a **request**. Another computer (a **server**) sends a **response**.

That's it. That's HTTP. Everything else is detail.

## A request and response, in actual text

When you type `https://example.com` in a browser, your browser sends something like:

```http
GET / HTTP/1.1
Host: example.com
User-Agent: Mozilla/5.0 ...
Accept: text/html
```

The server responds:

```http
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 1256

<html>
<head><title>Example</title></head>
<body><h1>Hello</h1></body>
</html>
```

Both sides are just text over a network connection. The browser parses the HTML and shows you the page.

## The four (you really care about) parts of a request

### 1. Method
What you want to do.

| Method | Means | Example |
|--------|-------|---------|
| `GET` | Read something | Loading a page, fetching data |
| `POST` | Create something | Signing up, submitting a form |
| `PUT` | Update / replace | Editing your profile |
| `DELETE` | Delete | Removing your account |
| `PATCH` | Partial update | Changing one field |

`GET` and `POST` are 80% of what you'll see.

### 2. URL
Where you're sending it.

```
https://api.example.com/users/42?expand=posts
└─┬─┘   └──────┬──────┘└───┬───┘└─────┬─────┘
 scheme   host         path     query string
```

- **Scheme**: `http` (insecure) or `https` (encrypted - always use this)
- **Host**: the server you're talking to
- **Path**: which resource on that server
- **Query string**: extra parameters, after `?`

### 3. Headers
Metadata. Key-value pairs the request carries.

```
Authorization: Bearer eyJhbGciOiJIUzI1...
Content-Type: application/json
User-Agent: MyApp/1.0
```

Common ones:
- `Authorization` - who you are (API token, etc.)
- `Content-Type` - what format the body is in
- `Accept` - what format you want the response in

### 4. Body (for POST/PUT/PATCH)
The actual data you're sending. Usually JSON these days.

```json
{
  "email": "you@example.com",
  "password": "secret"
}
```

## The four (you really care about) parts of a response

### 1. Status code
A 3-digit number telling you what happened.

| Range | Meaning | Common codes |
|-------|---------|--------------|
| 2xx | Success | 200 OK, 201 Created, 204 No Content |
| 3xx | Redirect | 301 Moved, 302 Found |
| 4xx | Client error (you messed up) | 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 429 Too Many Requests |
| 5xx | Server error (they messed up) | 500 Internal Error, 502 Bad Gateway, 503 Unavailable |

Memorize at least: 200, 401, 403, 404, 429, 500. They cover most of what you'll see.

### 2. Headers
Same idea as the request. Server tells you about itself, the response, caching, etc.

### 3. Body
The actual data. Could be HTML, JSON, an image, anything.

## What an "API" is

An **API** (Application Programming Interface) is a way for one piece of software to talk to another. When the term is used loosely on the internet, "API" almost always means "an HTTP API" - a server that exposes endpoints that other programs can call to do things or fetch data.

A REST API is an HTTP API following certain conventions:

- URLs represent **resources** (`/users/42`).
- Methods represent **actions** (`GET /users/42` reads, `DELETE /users/42` deletes).
- Responses are usually JSON.

Examples of APIs you've heard of:
- The Stripe API for taking payments
- The OpenAI/Anthropic APIs for talking to LLMs
- The GitHub API for everything GitHub does
- The AWS APIs for managing your cloud infrastructure

When you "use the AWS CLI" or "use the Anthropic SDK," you're using a friendlier wrapper around HTTP API calls.

## JSON, briefly

JSON (JavaScript Object Notation) is the de facto data format for HTTP APIs. It's not specific to JavaScript despite the name.

```json
{
  "id": 42,
  "name": "Alice",
  "active": true,
  "tags": ["admin", "founder"],
  "address": {
    "city": "Brooklyn",
    "zip": "11211"
  }
}
```

Six things JSON has:
- Strings (`"hello"`)
- Numbers (`42`, `3.14`)
- Booleans (`true`, `false`)
- `null`
- Arrays (`[1, 2, 3]`)
- Objects (`{"key": "value"}`)

That's it. No comments. No trailing commas. No `undefined`.

## Trying it yourself with curl

`curl` is a command-line tool for making HTTP requests. It comes pre-installed on Mac and Linux.

```
$ curl https://api.github.com/users/torvalds
{
  "login": "torvalds",
  "id": 1024025,
  "name": "Linus Torvalds",
  ...
}
```

Send a POST with JSON:

```
$ curl -X POST https://httpbin.org/post \
    -H "Content-Type: application/json" \
    -d '{"hello": "world"}'
```

Send an Authorization header:

```
$ curl https://api.example.com/me \
    -H "Authorization: Bearer YOUR_TOKEN"
```

`-v` adds verbose output - shows the full request and response. Helpful when something's wrong.

## Authentication, briefly

How does the server know it's you?

- **API key**: a long random string. You include it in a header. Easy, common.
- **Bearer token**: a token you got after logging in. Same idea but expires.
- **OAuth**: more complex flow where users grant permission to apps without sharing passwords.
- **Basic auth**: username + password base64-encoded. Old. Rarely used directly anymore.
- **Cookies + sessions**: how websites keep you logged in.

For API consumption (the LLM APIs, GitHub API, etc.), you'll mostly use API keys or bearer tokens. Treat them like passwords - never commit them, never share them, rotate if leaked.

## REST vs GraphQL vs gRPC vs WebSockets

You'll see these terms. Briefly:

- **REST**: standard HTTP API style. What we described above. Most APIs are this.
- **GraphQL**: alternative where the client specifies exactly what fields it wants. Used by GitHub's modern API and many newer services.
- **gRPC**: binary protocol over HTTP/2. Internal microservice communication. You usually wouldn't call this directly.
- **WebSockets**: bi-directional persistent connection. For real-time things (chat, live updates).

Don't worry about anything but REST until you have a reason.

## Common gotchas

| Gotcha | What it looks like | Fix |
|--------|--------------------|-----|
| Wrong content type | API rejects your data | Set `Content-Type: application/json` and send JSON |
| Forgot auth header | 401 Unauthorized | Add `Authorization` header |
| Wrong URL path | 404 Not Found | Re-read the docs, watch for trailing slashes |
| CORS errors (in browser) | Browser blocks the request | Server-side issue; APIs need CORS headers to allow your origin |
| Rate limited | 429 Too Many Requests | Slow down, batch, or wait |
| HTTP not HTTPS | Connection refused or certificate errors | Always use `https://` |

## What to look at next

- **[What is a server?](./what-is-a-server.md)** - the next prerequisite
- **[curl tutorial (everything.curl.dev)](https://everything.curl.dev/)** - the canonical reference
- **[HTTP/1.1 in 60 seconds (MDN)](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview)** - the spec, accessibly written
- **[Cloud from Scratch](../cloud-from-scratch.md)** - now you can follow along
