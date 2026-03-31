# Azure Troubleshooting Guide

Common issues and resolution steps for Azure services.

---

## VM Connectivity and Boot Diagnostics

### Cannot RDP/SSH into Azure VM

**Check Network Security Group (NSG) Rules**
```bash
# List effective NSG rules for a NIC
az network nic list-effective-nsg --name myNic --resource-group myRG

# Add an inbound rule for SSH
az network nsg rule create \
  --resource-group myRG \
  --nsg-name myNSG \
  --name AllowSSH \
  --priority 100 \
  --access Allow \
  --direction Inbound \
  --protocol Tcp \
  --destination-port-ranges 22
```

**Check VM Status**
```bash
az vm get-instance-view --resource-group myRG --name myVM --query instanceView.statuses
```
- PowerState/running - VM is running
- PowerState/deallocated - VM is stopped (no billing)
- PowerState/stopped - VM is stopped but still allocated (still billing)

**Boot Diagnostics**
- Enable boot diagnostics to capture serial console output and screenshots
- Serial console provides direct console access even when networking is broken
- Review boot log for kernel panics, filesystem errors, or stuck services

```bash
az vm boot-diagnostics enable --resource-group myRG --name myVM
az vm boot-diagnostics get-boot-log --resource-group myRG --name myVM
```

**Common VM Boot Failures**
- Disk full - extend OS disk or clean up from serial console
- FSTAB errors - bad mount entries prevent boot, fix via serial console
- Firewall rules inside the OS blocking traffic
- Windows: RDP service not running, check via Run Command

```bash
# Run a command inside the VM without network access
az vm run-command invoke \
  --resource-group myRG \
  --name myVM \
  --command-id RunShellScript \
  --scripts "systemctl status sshd"
```

**Docs:** https://learn.microsoft.com/en-us/troubleshoot/azure/virtual-machines/welcome-virtual-machines

---

## Storage Account Access Issues

### Cannot Access Blob Storage

**Check Access Tier and Account Kind**
- StorageV2 (general purpose v2) supports all features
- BlobStorage accounts only support block and append blobs
- Archive tier blobs must be rehydrated before reading

**Authentication and Authorization**
```bash
# Check storage account access keys
az storage account keys list --resource-group myRG --account-name mystorageacct

# List role assignments on the storage account
az role assignment list --scope /subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.Storage/storageAccounts/{name}
```

**Common RBAC Roles**
- Storage Blob Data Reader - read access to blob data
- Storage Blob Data Contributor - read, write, delete blob data
- Storage Blob Data Owner - full access including POSIX ACLs
- Note: Owner/Contributor roles on the resource do NOT grant data plane access

**Firewall and Network Rules**
```bash
az storage account show --name mystorageacct --query networkRuleSet
```
- If firewall is enabled, your client IP must be in the allowed list
- VNet service endpoints or private endpoints must be configured for VNet access
- "Allow trusted Microsoft services" must be enabled for Azure service access

**Shared Access Signatures (SAS) Issues**
- Check expiry time - SAS tokens have a start and end time
- Verify permissions match the operation (read, write, delete, list)
- IP restrictions on the SAS may block your client
- Protocol restriction (HTTPS only) may block HTTP requests

**Docs:** https://learn.microsoft.com/en-us/troubleshoot/azure/azure-storage/welcome-azure-storage

---

## Entra ID Authentication Problems

### Sign-In Failures

**Check Sign-In Logs**
```bash
# Requires Azure AD Premium
az rest --method GET \
  --url "https://graph.microsoft.com/v1.0/auditLogs/signIns?\$filter=userPrincipalName eq 'user@domain.com'&\$top=5"
```

**Common Error Codes**
- AADSTS50055 - Password expired
- AADSTS50126 - Invalid username or password
- AADSTS50076 - MFA required but not completed
- AADSTS700016 - Application not found in tenant
- AADSTS65001 - User or admin has not consented to the application
- AADSTS7000218 - Request body must contain client_secret or client_assertion

**Conditional Access Policy Blocks**
- Check which CA policies applied in the sign-in log
- Common blocks: location-based, device compliance, risk level
- Use the "What If" tool to simulate CA policy evaluation

**App Registration Issues**
- Verify redirect URIs match exactly (including trailing slashes)
- Check that the required API permissions have admin consent
- Ensure the correct token type is configured (access token vs ID token)
- For client credentials flow, verify the client secret has not expired

**Service Principal Problems**
```bash
# Check service principal details
az ad sp show --id <app-id>

# Reset credentials
az ad sp credential reset --id <app-id>
```

**Docs:** https://learn.microsoft.com/en-us/entra/identity/monitoring-health/concept-sign-in-log-activity-details

---

## NSG and Networking Troubleshooting

### Traffic Being Blocked Unexpectedly

**Effective Security Rules**
```bash
# View effective rules combining NSG on subnet and NIC
az network nic list-effective-nsg \
  --resource-group myRG \
  --name myNIC
```

**NSG Rule Evaluation Order**
- Rules are evaluated by priority (lowest number = highest priority)
- First matching rule wins
- Default rules (65000+) allow VNet-to-VNet, allow LB, deny all inbound from internet
- You cannot delete default rules but can override them with higher priority rules

**NSG Flow Logs**
```bash
# Enable NSG flow logs for debugging
az network watcher flow-log create \
  --resource-group myRG \
  --name myFlowLog \
  --nsg myNSG \
  --storage-account mystorageacct \
  --enabled true
```

**Network Watcher Tools**
- IP Flow Verify - tests if traffic is allowed or denied between two points
- Connection Troubleshoot - tests end-to-end connectivity
- Next Hop - shows where traffic is routed
- Packet Capture - captures packets on a VM NIC

```bash
# Test if a specific flow is allowed
az network watcher test-ip-flow \
  --resource-group myRG \
  --vm myVM \
  --direction Inbound \
  --protocol TCP \
  --local 10.0.0.4:22 \
  --remote 203.0.113.5:*
```

**UDR (User Defined Routes) Issues**
- More specific routes take precedence
- If using a network virtual appliance (NVA), ensure IP forwarding is enabled on the NIC
- System routes can be overridden by UDRs

**Docs:** https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-overview

---

## Azure Functions Errors and Cold Starts

### Function Execution Failures

**Check Application Insights**
```bash
az monitor app-insights query \
  --app myAppInsights \
  --analytics-query "requests | where success == false | top 10 by timestamp desc"
```

**Common Errors**
- Timeout - Consumption plan has a 5-minute (default) or 10-minute (max) timeout
- Out of memory - monitor memory usage in Application Insights
- Missing bindings - check function.json or binding attributes in code
- Connection string errors - verify app settings reference the correct Key Vault or connection string

**Cold Start Mitigation**
- Consumption plan: cold starts of 1-10 seconds
- Premium plan: pre-warmed instances eliminate cold starts
- Use the "Always Ready" instances setting on Premium plan
- Keep the function app package small
- Minimize dependencies and initialization logic

**Deployment Issues**
```bash
# Check deployment status
az functionapp deployment list-publishing-profiles --name myFuncApp --resource-group myRG

# Stream logs
az functionapp log tail --name myFuncApp --resource-group myRG
```

**Scaling Issues**
- Consumption plan scales automatically but has a limit on concurrent executions
- Check `WEBSITE_MAX_DYNAMIC_APPLICATION_SCALE_OUT` setting
- Event-driven triggers (Service Bus, Event Hub) may have partition limits

**Docs:** https://learn.microsoft.com/en-us/azure/azure-functions/functions-diagnostics

---

## ARM Template Deployment Failures

### Debugging Failed Deployments

**View Deployment Operations**
```bash
# List deployments with status
az deployment group list --resource-group myRG --query "[].{name:name, state:properties.provisioningState}"

# View operations of a specific deployment
az deployment group show \
  --resource-group myRG \
  --name myDeployment \
  --query properties.error
```

**Common Failures**
- Resource name conflicts - names must be globally unique for some resources (storage accounts, web apps)
- SKU not available in the target region
- Quota exceeded - check subscription limits
- API version mismatch - use the latest stable API version
- Circular dependencies between resources

**Template Validation**
```bash
# Validate template before deploying
az deployment group validate \
  --resource-group myRG \
  --template-file template.json \
  --parameters @parameters.json

# Run what-if to preview changes
az deployment group what-if \
  --resource-group myRG \
  --template-file template.json \
  --parameters @parameters.json
```

**Dependency Issues**
- Use `dependsOn` to define explicit ordering
- Use `reference()` and `resourceId()` which create implicit dependencies
- Nested/linked templates may need explicit dependency declarations

**Stuck Deployments**
- Deployments timeout after approximately 2 hours by default
- Cancel stuck deployments: `az deployment group cancel --resource-group myRG --name myDeployment`
- If resources are partially created, clean up manually or redeploy

**Docs:** https://learn.microsoft.com/en-us/azure/azure-resource-manager/troubleshooting/overview

---

## Azure SQL Connectivity

### Cannot Connect to Azure SQL Database

**Firewall Rules**
```bash
# Add client IP to firewall
az sql server firewall-rule create \
  --resource-group myRG \
  --server myserver \
  --name AllowMyIP \
  --start-ip-address YOUR_IP \
  --end-ip-address YOUR_IP

# Allow Azure services
az sql server firewall-rule create \
  --resource-group myRG \
  --server myserver \
  --name AllowAzureServices \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 0.0.0.0
```

**Private Endpoint / VNet Rules**
- If private endpoint is configured, connections must come through the private endpoint
- Public access can be disabled entirely when using private endpoints
- VNet service endpoints require a VNet rule on the SQL server

**Authentication Issues**
- SQL authentication: verify username and password
- Entra ID authentication: ensure the user is added as an AD admin or has a contained database user
- Connection strings must specify the correct authentication method

**Connection String Format**
```
Server=tcp:myserver.database.windows.net,1433;Database=mydb;User ID=myuser;Password=mypass;Encrypt=True;TrustServerCertificate=False;
```

**Performance and Connection Limits**
- DTU-based tiers have fixed connection limits
- vCore-based tiers scale connections with compute
- Use connection pooling in your application
- Implement retry logic with exponential backoff for transient errors

**Troubleshooting Tools**
```bash
# Test connectivity from an Azure VM
az network watcher test-connectivity \
  --source-resource myVM \
  --dest-address myserver.database.windows.net \
  --dest-port 1433
```

**Docs:** https://learn.microsoft.com/en-us/azure/azure-sql/database/troubleshoot-common-errors-issues

---

## Quick Reference - Azure CLI Debugging

```bash
# Enable debug output
az vm list --debug

# Check current subscription context
az account show

# List all resource groups
az group list --output table

# View activity log for failures
az monitor activity-log list \
  --resource-group myRG \
  --status Failed \
  --offset 1h
```

---

## Additional Resources

- [Azure Troubleshooting Documentation](https://learn.microsoft.com/en-us/troubleshoot/azure/)
- [Azure Service Health](https://status.azure.com/)
- [Azure Resource Manager Troubleshooting](https://learn.microsoft.com/en-us/azure/azure-resource-manager/troubleshooting/overview)
- [Azure Subscription Limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits)
