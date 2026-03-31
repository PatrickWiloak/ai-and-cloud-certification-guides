# GCP Troubleshooting Guide

Common issues and resolution steps for Google Cloud Platform services.

---

## Compute Engine SSH and Connectivity

### Cannot SSH into a VM Instance

**Check Firewall Rules**
```bash
# List firewall rules that apply to the instance
gcloud compute firewall-rules list --filter="network=default"

# Create a firewall rule to allow SSH
gcloud compute firewall-rules create allow-ssh \
  --network default \
  --allow tcp:22 \
  --source-ranges 0.0.0.0/0 \
  --target-tags ssh-enabled
```

**Verify VM Status**
```bash
gcloud compute instances describe my-instance --zone us-central1-a --format="get(status)"
```
- RUNNING - instance is running
- TERMINATED - instance is stopped
- STAGING - instance is starting
- SUSPENDED - instance is suspended

**OS Login vs Metadata SSH Keys**
- OS Login uses IAM to manage SSH access - requires `roles/compute.osLogin` or `roles/compute.osAdminLogin`
- Metadata SSH keys are stored in project or instance metadata
- If OS Login is enabled, metadata SSH keys are disabled
- Check: `gcloud compute project-info describe --format="get(commonInstanceMetadata.items.filter(key:enable-oslogin))"`

**Serial Console Access**
```bash
# Enable interactive serial console
gcloud compute instances add-metadata my-instance \
  --zone us-central1-a \
  --metadata serial-port-enable=TRUE

# Connect to serial console
gcloud compute connect-to-serial-port my-instance --zone us-central1-a
```

**Common Boot Issues**
- Review serial port output for boot errors
- Check if the boot disk is full
- Verify startup scripts are not blocking boot
- Ensure the guest agent is running for SSH key propagation

**Network Connectivity**
```bash
# Test connectivity from the instance
gcloud compute ssh my-instance --zone us-central1-a --command "curl -s ifconfig.me"

# Check routes
gcloud compute routes list --filter="network=default"
```

**Docs:** https://cloud.google.com/compute/docs/troubleshooting/troubleshooting-ssh

---

## IAM Permission Debugging

### Identifying Permission Issues

**Check Effective Permissions**
```bash
# Test IAM permissions on a resource
gcloud projects get-iam-policy my-project --flatten="bindings[].members" \
  --format="table(bindings.role, bindings.members)" \
  --filter="bindings.members:user@example.com"

# Test specific permissions
gcloud asset analyze-iam-policy \
  --organization=123456789 \
  --identity="user:user@example.com" \
  --full-resource-name="//storage.googleapis.com/my-bucket"
```

**Policy Troubleshooter**
- Console: IAM and Admin - Troubleshoot access
- Tests whether a principal has a specific permission on a resource
- Shows which policies grant or deny the permission
- Identifies which bindings are relevant

**Common Permission Issues**
- Roles granted at project level may not apply to resources in other projects
- Service account impersonation requires `roles/iam.serviceAccountTokenCreator`
- Some APIs must be enabled before permissions take effect
- Organization policies can restrict even if IAM allows

**Service Account Issues**
```bash
# List service account keys
gcloud iam service-accounts keys list --iam-account SA_EMAIL

# Check if a service account is disabled
gcloud iam service-accounts describe SA_EMAIL --format="get(disabled)"
```

**Audit Logs**
```bash
# View admin activity logs
gcloud logging read 'logName="projects/my-project/logs/cloudaudit.googleapis.com%2Factivity"' --limit 20

# Filter for denied access
gcloud logging read 'protoPayload.status.code=7' --limit 20
```

**Docs:** https://cloud.google.com/iam/docs/troubleshooting-access

---

## VPC Firewall Rule Issues

### Traffic Being Blocked

**List and Inspect Firewall Rules**
```bash
# List all firewall rules sorted by priority
gcloud compute firewall-rules list --sort-by=PRIORITY

# Describe a specific rule
gcloud compute firewall-rules describe my-rule
```

**Firewall Rule Evaluation**
- Lower priority number = higher precedence
- Rules are evaluated per-VM, not per-subnet
- Target is specified by tags, service accounts, or all instances in the network
- An "allow" rule at priority 1000 is overridden by a "deny" rule at priority 900

**Firewall Insights and Logging**
```bash
# Enable logging on a firewall rule
gcloud compute firewall-rules update my-rule --enable-logging

# View firewall logs
gcloud logging read 'resource.type="gce_subnetwork" AND jsonPayload.rule_details.action="DENY"' --limit 20
```

**Hierarchical Firewall Policies**
- Organization and folder level policies are evaluated before VPC firewall rules
- A "deny" in a hierarchical policy cannot be overridden by a VPC rule
- Use `goto_next` in hierarchical policies to delegate to VPC rules

**Implied Rules**
- Implied allow egress (priority 65535) - allows all egress traffic
- Implied deny ingress (priority 65535) - denies all ingress traffic
- These cannot be deleted but can be overridden by higher priority rules

**Connectivity Tests**
```bash
# Run a connectivity test
gcloud network-management connectivity-tests create my-test \
  --source-instance=projects/my-project/zones/us-central1-a/instances/source-vm \
  --destination-instance=projects/my-project/zones/us-central1-a/instances/dest-vm \
  --protocol=TCP \
  --destination-port=80
```

**Docs:** https://cloud.google.com/vpc/docs/firewalls

---

## Cloud Functions and Cloud Run Errors

### Cloud Functions Failures

**View Logs**
```bash
gcloud functions logs read my-function --limit 50
```

**Common Errors**
- Timeout - default is 60 seconds (1st gen) or 10 minutes (2nd gen), max is 9 minutes (1st gen) or 60 minutes (2nd gen)
- Memory exceeded - increase memory allocation
- Permission denied - check the function's service account permissions
- Dependency errors - verify requirements.txt/package.json has all needed packages

**Cold Starts**
- Minimize global scope initialization
- Use minimum instances setting to keep warm instances
- 2nd gen functions (Cloud Run based) support minimum instances natively
- Reduce deployment package size

### Cloud Run Issues

**Deployment Failures**
```bash
# Check Cloud Run service status
gcloud run services describe my-service --region us-central1

# View revision logs
gcloud logging read 'resource.type="cloud_run_revision" AND resource.labels.service_name="my-service"' --limit 20
```

**Common Cloud Run Errors**
- Container failed to start - must listen on the PORT environment variable (default 8080)
- Container not found - verify the image path in Artifact Registry or Container Registry
- Memory limit exceeded - increase memory or optimize the application
- Request timeout - default 300 seconds, max 3600 seconds

**Health Check Failures**
- Cloud Run uses startup probes - the container must respond on the configured port
- Check if the application crashes during initialization
- Ensure health check endpoints return 200 status codes

**Docs:** https://cloud.google.com/functions/docs/troubleshooting

---

## GKE Cluster Troubleshooting

### Cluster Issues

**Check Cluster Status**
```bash
gcloud container clusters describe my-cluster --zone us-central1-a --format="get(status)"
```

**Node Pool Problems**
```bash
# List node pools
gcloud container node-pools list --cluster my-cluster --zone us-central1-a

# Check node conditions
kubectl get nodes -o wide
kubectl describe node NODE_NAME
```

**Common Issues**
- Insufficient quota - check Compute Engine quotas for CPUs, IP addresses, and disks
- IP address exhaustion - secondary ranges for pods and services may be full
- Node auto-repair keeps restarting nodes - check node health conditions
- Cluster autoscaler not scaling - check node pool limits and resource requests

**Workload Identity Issues**
```bash
# Verify Workload Identity is enabled
gcloud container clusters describe my-cluster --zone us-central1-a \
  --format="get(workloadIdentityConfig)"

# Check the KSA-to-GSA binding
gcloud iam service-accounts get-iam-policy GSA_EMAIL \
  --format="table(bindings.role, bindings.members)"
```

**Network Policy Issues**
- Network policies require a network policy-enabled cluster (Calico or Dataplane V2)
- Default deny policies block all traffic unless explicitly allowed
- Check: `kubectl get networkpolicies -A`

**Upgrade Failures**
- Check node pool version compatibility with control plane version
- Review surge upgrade settings for disruption tolerance
- PodDisruptionBudgets may prevent node draining during upgrades

**Docs:** https://cloud.google.com/kubernetes-engine/docs/troubleshooting

---

## Cloud SQL Connectivity

### Cannot Connect to Cloud SQL Instance

**Check Instance Status**
```bash
gcloud sql instances describe my-instance --format="get(state)"
```

**Authorized Networks (Public IP)**
```bash
# Add an authorized network
gcloud sql instances patch my-instance \
  --authorized-networks=YOUR_IP/32
```

**Private IP Connectivity**
- Must be on the same VPC or a peered VPC
- Private services access must be configured
- Check the peering connection: `gcloud compute addresses list --global --filter="purpose=VPC_PEERING"`
- DNS name for private IP: `my-instance.project-id.internal`

**Cloud SQL Auth Proxy**
```bash
# Connect using the Cloud SQL Auth Proxy
cloud-sql-proxy --port 5432 my-project:us-central1:my-instance

# In another terminal
psql -h 127.0.0.1 -U postgres -d mydb
```
- Requires the calling identity to have `roles/cloudsql.client`
- Handles SSL and IAM authentication automatically
- Preferred method for Cloud Run and GKE connections

**IAM Database Authentication**
- Enable IAM authentication on the instance
- Grant `roles/cloudsql.instanceUser` to the IAM principal
- Use the Auth Proxy or generate an OAuth2 token for the password

**Connection Limits**
- Max connections depend on instance tier (machine type and memory)
- Use connection pooling (PgBouncer, ProxySQL) for high-connection workloads
- Cloud SQL does not support connection pooling natively - use Auth Proxy sidecar

**Docs:** https://cloud.google.com/sql/docs/mysql/diagnose-issues

---

## Deployment Manager Failures

### Debugging Failed Deployments

**View Deployment Status**
```bash
# List deployments
gcloud deployment-manager deployments list

# Describe a deployment with errors
gcloud deployment-manager deployments describe my-deployment

# View manifest for the full configuration
gcloud deployment-manager manifests describe --deployment my-deployment MANIFEST_ID
```

**Common Failures**
- API not enabled - enable the required API: `gcloud services enable compute.googleapis.com`
- Quota exceeded - check project quotas in the console
- Resource name conflicts - names must be unique within the project (or globally for some resources)
- Template syntax errors - validate Jinja2 or Python templates locally

**Dependency Issues**
- Use `metadata.dependsOn` to declare ordering
- References create implicit dependencies
- Circular dependencies cause deployment failures

**Stuck Deployments**
```bash
# Cancel a running operation
gcloud deployment-manager operations list --filter="status=RUNNING"

# Delete a failed deployment
gcloud deployment-manager deployments delete my-deployment
```

**Migration Note**
- Deployment Manager is still supported but Google recommends migrating to Terraform or Pulumi
- Consider using Config Connector for Kubernetes-native resource management

**Docs:** https://cloud.google.com/deployment-manager/docs/troubleshooting

---

## Quick Reference - gcloud Debugging

```bash
# Enable verbose logging
gcloud compute instances list --verbosity=debug

# Check current project and account
gcloud config list

# List enabled APIs
gcloud services list --enabled

# View recent errors in logs
gcloud logging read "severity>=ERROR" --limit 20 --format="table(timestamp, resource.type, textPayload)"
```

---

## Additional Resources

- [GCP Troubleshooting Documentation](https://cloud.google.com/docs/troubleshooting)
- [Google Cloud Status Dashboard](https://status.cloud.google.com/)
- [GCP Quotas and Limits](https://cloud.google.com/docs/quota)
- [GCP Error Reporting](https://cloud.google.com/error-reporting/docs)
