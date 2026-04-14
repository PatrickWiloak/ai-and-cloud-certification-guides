# 06 - Error Handling, Rate Limits, Retries

Production Claude apps live or die by their handling of errors and rate limits. The exam will test whether you can categorize errors correctly and design retry logic that does not make things worse.

---

## Error Codes

| HTTP | Type | Cause | Retryable? |
|---|---|---|---|
| 400 | invalid_request_error | Malformed body, schema violation | No - fix request |
| 401 | authentication_error | Bad / missing API key | No - fix auth |
| 403 | permission_error | Account permission denied | No |
| 404 | not_found_error | Bad endpoint or ID | No |
| 413 | request_too_large | Body too big | No - shrink |
| 429 | rate_limit_error | Hit RPM or TPM ceiling | Yes - backoff |
| 500 | api_error | Server error | Yes - backoff |
| 529 | overloaded_error | API overloaded | Yes - backoff |

Other error types include `billing_error` (usually 4xx) and `timeout_error`.

---

## Error Response Shape

```json
{
  "type": "error",
  "error": {
    "type": "rate_limit_error",
    "message": "Rate limit exceeded"
  }
}
```

Pin your retry logic on the `error.type` and HTTP status, not on the message string.

---

## Rate Limit Headers

On every successful response and on 429s:

- `anthropic-ratelimit-requests-limit`
- `anthropic-ratelimit-requests-remaining`
- `anthropic-ratelimit-requests-reset` (RFC 3339 timestamp)
- `anthropic-ratelimit-tokens-limit`
- `anthropic-ratelimit-tokens-remaining`
- `anthropic-ratelimit-tokens-reset`
- `anthropic-ratelimit-input-tokens-*`
- `anthropic-ratelimit-output-tokens-*`

On 429 and 529: `retry-after` (seconds or HTTP date).

Use these to implement proactive throttling: if remaining < threshold, slow down before getting blocked.

---

## Retry Patterns

### Exponential Backoff With Jitter

```python
def with_retry(func, max_attempts=5, base=1.0):
    for attempt in range(max_attempts):
        try:
            return func()
        except RetryableError as e:
            if attempt == max_attempts - 1:
                raise
            delay = e.retry_after or (base * (2 ** attempt))
            delay += random.uniform(0, delay * 0.25)  # jitter
            time.sleep(delay)
```

### Categorization

```python
def is_retryable(status, error_type):
    if status in (429, 500, 529):
        return True
    if status >= 500:
        return True
    return False
```

Do not retry 400-class errors (other than 429). Doing so wastes calls and may trigger account-level abuse signals.

### Honor Retry-After

If the server provides `retry-after`, honor it. Your backoff calculation is a fallback when the header is absent.

### Cap Retries

Cap attempts (typically 3-5). Unbounded retries hide outages and inflate latency.

### Idempotency

The Claude API does not provide native idempotency keys for Messages. Manage idempotency client-side: hash the request, store the response, return the stored response on retry.

For tool execution, design tools to be idempotent so retries within the agent loop are safe.

---

## Circuit Breakers

After N consecutive failures, open the circuit:

- Stop sending new requests for a cooldown
- Surface a clear failure to upstream callers
- Periodically test with a single request to detect recovery

Prevents cascading failure when Claude or your network is degraded.

---

## Timeouts

Set request timeouts. The SDKs default to long timeouts; configure per workload:

```python
client = Anthropic(timeout=30.0)  # or per-request: client.with_options(timeout=...)
```

Typical timeouts:

- Interactive UX: 30-60s
- Batch / async: longer
- Tool calls: bounded by tool, not by SDK

---

## Streaming Errors

Streams can fail mid-flight. The SDK exposes errors as exceptions during iteration. Handle:

```python
try:
    with client.messages.stream(...) as stream:
        for text in stream.text_stream:
            ...
except APIError as e:
    log.error("stream failed", error=e)
```

Decide whether to retry from the start or resume (most workloads restart).

---

## SDK Exception Hierarchy

Python SDK exposes typed exceptions:

- `APIError` - base
- `APIConnectionError` - network problems
- `APITimeoutError` - timeouts
- `APIStatusError` - non-2xx response (subclassed)
- `BadRequestError`, `AuthenticationError`, `PermissionDeniedError`, `NotFoundError`, `RateLimitError`, `InternalServerError`, `APIResponseValidationError`

Catch the specific class you care about; let others propagate.

TypeScript SDK has parallel error classes (`APIError`, `RateLimitError`, etc.).

---

## Observability

Log per request:

- Request ID (returned in response headers)
- Model
- Input tokens, output tokens, cache reads/writes
- Latency
- Stop reason
- Tool calls
- Final status (success / retry / fail)

Aggregate to dashboards. Alert on:

- 429 rate above threshold
- 5xx rate above threshold
- Tail latency increases
- Cost per request increases

---

## Pre-emptive Throttling

Watch `anthropic-ratelimit-tokens-remaining`. If it dips below your safety margin, queue or shed lower-priority traffic. Prevents 429 floods.

---

## Worked Example

```python
import anthropic, time, random

client = anthropic.Anthropic()

def call_with_retry(messages, max_attempts=5):
    for attempt in range(max_attempts):
        try:
            return client.messages.create(
                model="claude-sonnet-4-6",
                max_tokens=1024,
                messages=messages,
            )
        except anthropic.RateLimitError as e:
            retry_after = e.response.headers.get("retry-after")
            delay = float(retry_after) if retry_after else (2 ** attempt)
            delay += random.uniform(0, delay * 0.25)
            time.sleep(delay)
        except anthropic.InternalServerError:
            time.sleep((2 ** attempt) + random.uniform(0, 1))
        except anthropic.BadRequestError:
            raise  # do not retry
    raise RuntimeError("max attempts exceeded")
```

---

## Common Pitfalls

- Retrying 400 errors
- Ignoring `retry-after`
- Unbounded retries
- No jitter (synchronized retries cause thundering herd)
- Catching `Exception` broadly and treating all as retryable
- Hiding errors instead of logging request IDs
- No circuit breaker, so a partial outage burns budget

---

## Exam Focus

- Which error codes are retryable
- The role of `retry-after`
- Exponential backoff with jitter
- Rate limit headers
- Circuit breaker basics
- Idempotency strategy
