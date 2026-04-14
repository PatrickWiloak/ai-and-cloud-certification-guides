# 04. Observability: Metrics, Traces, and Logs

## What Istio Gives You for Free

Every sidecar emits:

- **Metrics**: standard request metrics (count, latency, bytes) tagged with rich labels
- **Distributed tracing**: spans for each hop, with propagation headers
- **Access logs**: per-request log lines in Envoy format

You do not need to instrument application code for any of this. You do need the propagation headers to flow through your application code for tracing.

## Metrics

### Standard metrics

Prometheus-format metrics emitted by every sidecar:

- `istio_requests_total`
- `istio_request_duration_milliseconds`
- `istio_request_bytes`
- `istio_response_bytes`
- `istio_tcp_sent_bytes_total`
- `istio_tcp_received_bytes_total`
- `istio_tcp_connections_opened_total`
- `istio_tcp_connections_closed_total`

Common labels: `source_workload`, `destination_workload`, `source_namespace`, `destination_namespace`, `request_protocol`, `response_code`, `connection_security_policy`.

### Telemetry API

The newer way to customize metric output, replacing legacy annotations.

```yaml
apiVersion: telemetry.istio.io/v1
kind: Telemetry
metadata: { name: custom-metrics, namespace: istio-system }
spec:
  metrics:
    - providers:
        - name: prometheus
      overrides:
        - match: { metric: REQUEST_COUNT }
          tagOverrides:
            user_id:
              value: "request.headers['x-user-id']"
```

### Common queries

Request rate by destination:
```
sum by (destination_workload) (rate(istio_requests_total[5m]))
```

p99 latency:
```
histogram_quantile(0.99,
  sum(rate(istio_request_duration_milliseconds_bucket[5m])) by (le, destination_workload)
)
```

Error rate:
```
sum(rate(istio_requests_total{response_code=~"5.."}[5m]))
/ sum(rate(istio_requests_total[5m]))
```

## Distributed Tracing

Istio creates spans automatically. Your code must propagate the trace headers, since the sidecar cannot connect inbound to outbound for the same request without help.

### Required headers (B3 set, common default)
- `x-request-id`
- `x-b3-traceid`
- `x-b3-spanid`
- `x-b3-parentspanid`
- `x-b3-sampled`
- `x-b3-flags`

W3C Trace Context (`traceparent`, `tracestate`) is also supported and increasingly the default.

### Backend choices

- Jaeger
- Zipkin
- Tempo (Grafana)
- OpenTelemetry Collector (OTLP)
- Vendor backends (Datadog, New Relic, Honeycomb)

### Sampling

Default sample rate is low (1 percent in production profiles). Override via Telemetry API:

```yaml
spec:
  tracing:
    - providers:
        - name: jaeger
      randomSamplingPercentage: 100.0
```

## Access Logs

Per-request log lines from each sidecar.

### Default Envoy access log format

```
[%START_TIME%] "%REQ(:METHOD)% %REQ(X-ENVOY-ORIGINAL-PATH?:PATH)% %PROTOCOL%"
%RESPONSE_CODE% %RESPONSE_FLAGS% ...
```

### Enable access logs

In demo profile, enabled by default. In production profiles, enable via Telemetry API:

```yaml
spec:
  accessLogging:
    - providers:
        - name: otel
```

Or globally during install:

```bash
istioctl install --set meshConfig.accessLogFile=/dev/stdout
```

### Reading access logs

```bash
kubectl logs <pod> -c istio-proxy
```

Look for:
- Response code
- Response flags (NR, UH, UF, RH, UC, etc.)
- Upstream cluster
- Duration

### Envoy response flags (high value)

| Flag | Meaning |
|------|---------|
| NR | No Route configured |
| UH | No healthy Upstream Hosts |
| UF | Upstream connection Failure |
| RH | Rejected by external Health check |
| UC | Upstream Connection terminated |
| DC | Downstream Connection terminated |
| LH | Local Health check failed |
| FI | Fault Injection |
| RL | Rate Limit |
| UT | Upstream request Timeout |

These tell you the failure type at a glance.

## Kiali

Topology and configuration visualizer for Istio. Shows:

- Service graph with traffic flows
- Versions and routing rules
- Health and error rates
- Configuration validation (similar to `istioctl analyze`)

Install via `kubectl apply -f samples/addons/kiali.yaml` from the Istio release.

## Grafana Dashboards

Istio ships standard dashboards:
- Mesh dashboard (overall mesh view)
- Service dashboard (per-service)
- Workload dashboard (per-workload)
- Performance dashboard (control plane)
- Control plane dashboard

## Telemetry API Highlights

The Telemetry API consolidates configuration for metrics, tracing, and access logs:

```yaml
apiVersion: telemetry.istio.io/v1
kind: Telemetry
metadata: { name: mesh-default, namespace: istio-system }
spec:
  tracing:
    - randomSamplingPercentage: 100
  metrics:
    - providers: [{ name: prometheus }]
  accessLogging:
    - providers: [{ name: otel }]
```

Scope by placement: `istio-system` for mesh, app namespace for namespace, with selector for workload.

## Common Exam Traps

- Expecting traces without propagating headers in app code
- Confusing standard metrics with custom (Telemetry API needed)
- Looking for access logs in default profile (off; enable explicitly)
- Misreading response flags
- Using deprecated annotation-based config instead of Telemetry API
- Forgetting addons need separate installation (samples/addons/)
