# Hands-On Project: Set Up a Monitoring Stack

Deploy Prometheus and Grafana on Kubernetes for comprehensive monitoring and alerting.

**Estimated Time:** 3-4 hours
**Difficulty:** Intermediate
**Prerequisites:** Kubernetes cluster (local or cloud), Helm installed, kubectl configured

---

## Architecture Overview

```
Application Pods (instrumented with metrics)
       |
       v
Prometheus (scrapes metrics every 15-30s)
       |
       +---> Grafana (dashboards and visualization)
       |
       +---> Alertmanager (alerts via email, Slack, PagerDuty)
```

---

## Step 1: Install Prometheus and Grafana via Helm

### Add Helm Repository

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

### Install kube-prometheus-stack

This chart installs Prometheus, Grafana, Alertmanager, and pre-configured Kubernetes dashboards.

```bash
# Create namespace
kubectl create namespace monitoring

# Install the stack
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set grafana.adminPassword=admin \
  --set prometheus.prometheusSpec.retention=15d \
  --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage=50Gi \
  --set alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.resources.requests.storage=10Gi
```

### Verify Installation

```bash
kubectl get pods -n monitoring
kubectl get svc -n monitoring
```

Expected pods:
- `prometheus-monitoring-kube-prometheus-prometheus-0` - Prometheus server
- `monitoring-grafana-xxx` - Grafana dashboard
- `alertmanager-monitoring-kube-prometheus-alertmanager-0` - Alertmanager
- `monitoring-kube-prometheus-operator-xxx` - Prometheus Operator
- `monitoring-kube-state-metrics-xxx` - Kubernetes state metrics
- `monitoring-prometheus-node-exporter-xxx` - Node-level metrics (one per node)

---

## Step 2: Access the Dashboards

### Grafana

```bash
# Port forward to access Grafana
kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80
```
- Open http://localhost:3000
- Login: admin / admin (or the password you set)

### Prometheus

```bash
kubectl port-forward svc/monitoring-kube-prometheus-prometheus -n monitoring 9090:9090
```
- Open http://localhost:9090

### Alertmanager

```bash
kubectl port-forward svc/monitoring-kube-prometheus-alertmanager -n monitoring 9093:9093
```
- Open http://localhost:9093

---

## Step 3: Configure Scrape Targets

### Using ServiceMonitor (Prometheus Operator)

The Prometheus Operator watches for `ServiceMonitor` custom resources to configure scrape targets.

```yaml
# service-monitor.yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: my-app-monitor
  namespace: monitoring
  labels:
    release: monitoring  # Must match Prometheus operator selector
spec:
  selector:
    matchLabels:
      app: my-app
  namespaceSelector:
    matchNames:
      - default
  endpoints:
    - port: metrics
      interval: 15s
      path: /metrics
```

```bash
kubectl apply -f service-monitor.yaml
```

### Using PodMonitor

For pods that do not have a Service:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: my-job-monitor
  namespace: monitoring
spec:
  selector:
    matchLabels:
      app: my-batch-job
  podMetricsEndpoints:
    - port: metrics
      interval: 30s
```

---

## Step 4: Create Grafana Dashboards

### Import Pre-Built Dashboards

1. In Grafana, go to Dashboards - Import
2. Enter a dashboard ID from https://grafana.com/grafana/dashboards/
3. Useful dashboard IDs:
   - 315 - Kubernetes cluster monitoring
   - 6417 - Kubernetes pod resources
   - 1860 - Node Exporter Full
   - 13770 - Kubernetes cluster overview

### Create a Custom Dashboard

1. Click "+" then "New Dashboard"
2. Add a panel with a PromQL query

**Useful PromQL Queries**

```promql
# CPU usage per pod
sum(rate(container_cpu_usage_seconds_total{namespace="default"}[5m])) by (pod)

# Memory usage per pod
sum(container_memory_working_set_bytes{namespace="default"}) by (pod)

# HTTP request rate
sum(rate(http_requests_total[5m])) by (service)

# HTTP error rate (5xx)
sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m]))

# Pod restart count
sum(kube_pod_container_status_restarts_total) by (pod)

# Node disk usage
1 - (node_filesystem_avail_bytes / node_filesystem_size_bytes)
```

---

## Step 5: Set Up Alerting Rules

### PrometheusRule Custom Resource

```yaml
# alerting-rules.yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: app-alerts
  namespace: monitoring
  labels:
    release: monitoring
spec:
  groups:
    - name: application
      rules:
        - alert: HighErrorRate
          expr: sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) > 0.05
          for: 5m
          labels:
            severity: critical
          annotations:
            summary: "High error rate detected"
            description: "Error rate is above 5% for more than 5 minutes."

        - alert: PodCrashLooping
          expr: increase(kube_pod_container_status_restarts_total[1h]) > 3
          for: 10m
          labels:
            severity: warning
          annotations:
            summary: "Pod {{ $labels.pod }} is crash looping"

        - alert: HighMemoryUsage
          expr: container_memory_working_set_bytes / container_spec_memory_limit_bytes > 0.9
          for: 5m
          labels:
            severity: warning
          annotations:
            summary: "Pod {{ $labels.pod }} memory usage above 90%"

        - alert: NodeDiskPressure
          expr: (1 - node_filesystem_avail_bytes / node_filesystem_size_bytes) > 0.85
          for: 10m
          labels:
            severity: warning
          annotations:
            summary: "Node {{ $labels.instance }} disk usage above 85%"
```

```bash
kubectl apply -f alerting-rules.yaml
```

---

## Step 6: Configure Alertmanager

### Alertmanager Configuration

```yaml
# alertmanager-config.yaml
apiVersion: v1
kind: Secret
metadata:
  name: alertmanager-monitoring-kube-prometheus-alertmanager
  namespace: monitoring
type: Opaque
stringData:
  alertmanager.yaml: |
    global:
      resolve_timeout: 5m

    route:
      group_by: ['alertname', 'namespace']
      group_wait: 30s
      group_interval: 5m
      repeat_interval: 4h
      receiver: 'slack-notifications'
      routes:
        - receiver: 'pagerduty-critical'
          match:
            severity: critical
        - receiver: 'slack-notifications'
          match:
            severity: warning

    receivers:
      - name: 'slack-notifications'
        slack_configs:
          - api_url: 'https://hooks.slack.com/services/YOUR/WEBHOOK/URL'
            channel: '#alerts'
            title: '[{{ .Status | toUpper }}] {{ .CommonLabels.alertname }}'
            text: '{{ .CommonAnnotations.summary }}'

      - name: 'pagerduty-critical'
        pagerduty_configs:
          - service_key: 'YOUR_PAGERDUTY_KEY'
```

---

## Alternative: Cloud-Native Monitoring

### AWS CloudWatch

```bash
# Install CloudWatch agent on EKS
aws eks create-addon --cluster-name my-cluster \
  --addon-name amazon-cloudwatch-observability

# Key metrics to monitor
# - CPUUtilization, MemoryUtilization (EC2/ECS)
# - 4XXError, 5XXError (ALB)
# - DatabaseConnections, FreeStorageSpace (RDS)
```

### Azure Monitor

```bash
# Enable Container Insights on AKS
az aks enable-addons --resource-group myRG --name myAKS --addons monitoring

# Key features
# - Container Insights for AKS
# - Application Insights for APM
# - Log Analytics for centralized logging
```

### GCP Cloud Monitoring

```bash
# GKE has Cloud Monitoring enabled by default
# Install the Managed Prometheus collector
gcloud container clusters update my-cluster \
  --enable-managed-prometheus --zone us-central1-a

# Key features
# - Managed Prometheus (PromQL compatible)
# - Cloud Trace for distributed tracing
# - Error Reporting for application errors
```

---

## Step 7: Application Instrumentation

### Node.js with prom-client

```javascript
const client = require('prom-client');
const express = require('express');

// Create a default registry
const register = new client.Registry();
client.collectDefaultMetrics({ register });

// Custom metrics
const httpRequestDuration = new client.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status'],
  buckets: [0.01, 0.05, 0.1, 0.5, 1, 5],
  registers: [register],
});

// Expose /metrics endpoint
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});
```

### Python with prometheus_client

```python
from prometheus_client import Counter, Histogram, generate_latest
from flask import Flask, Response

REQUEST_COUNT = Counter('http_requests_total', 'Total requests', ['method', 'endpoint', 'status'])
REQUEST_LATENCY = Histogram('http_request_duration_seconds', 'Request latency', ['endpoint'])

@app.route('/metrics')
def metrics():
    return Response(generate_latest(), mimetype='text/plain')
```

---

## Verification Checklist

- [ ] Prometheus is scraping Kubernetes metrics (node, pod, container)
- [ ] Grafana displays pre-built Kubernetes dashboards
- [ ] Custom application metrics appear in Prometheus
- [ ] Alert rules are loaded (check Prometheus - Alerts)
- [ ] Alertmanager sends test notifications
- [ ] Dashboards show meaningful data for your application

---

## Cleanup

```bash
helm uninstall monitoring -n monitoring
kubectl delete namespace monitoring
```

---

## Additional Resources

- [Prometheus Documentation](https://prometheus.io/docs/introduction/overview/)
- [Grafana Documentation](https://grafana.com/docs/grafana/latest/)
- [kube-prometheus-stack Chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- [PromQL Cheat Sheet](https://promlabs.com/promql-cheat-sheet/)
