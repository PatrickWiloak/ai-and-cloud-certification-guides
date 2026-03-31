# AWS Troubleshooting Guide

Common issues and resolution steps for AWS services.

---

## EC2 Connectivity Issues

### Cannot SSH into EC2 Instance

**Check Security Groups**
```bash
# List security group rules for an instance
aws ec2 describe-security-groups --group-ids sg-xxxxxxxx

# Verify inbound rule allows SSH (port 22) from your IP
aws ec2 authorize-security-group-ingress \
  --group-id sg-xxxxxxxx \
  --protocol tcp \
  --port 22 \
  --cidr YOUR_IP/32
```

**Check Network ACLs**
- NACLs are stateless - you need both inbound AND outbound rules
- Verify the subnet's NACL allows inbound on port 22 and outbound on ephemeral ports (1024-65535)
- Rules are evaluated in order - a DENY rule with a lower number overrides a later ALLOW

**Check Route Tables**
- Ensure the subnet has a route to an Internet Gateway (0.0.0.0/0 -> igw-xxxxxxxx)
- For private subnets, verify the NAT Gateway route is present
- Confirm the route table is associated with the correct subnet

**Key Pair Issues**
- Verify you are using the correct .pem file for the key pair assigned at launch
- Check file permissions: `chmod 400 my-key.pem`
- Default usernames: `ec2-user` (Amazon Linux), `ubuntu` (Ubuntu), `admin` (Debian)

**Instance Status Checks**
```bash
aws ec2 describe-instance-status --instance-ids i-xxxxxxxx
```
- System status check failure - hardware issue, stop/start the instance to migrate
- Instance status check failure - OS-level issue, review system logs

**Docs:** https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/TroubleshootingInstancesConnecting.html

---

## S3 Access Denied Errors

### Bucket Policy Conflicts

**Check Bucket Policy**
```bash
aws s3api get-bucket-policy --bucket my-bucket
```
- Explicit DENY in a bucket policy overrides any ALLOW
- Ensure the Principal matches the requesting identity (IAM user ARN, role ARN, or `*`)

**Check IAM Policies**
```bash
# View effective policies for a user
aws iam list-attached-user-policies --user-name myuser
aws iam list-user-policies --user-name myuser
```
- The requesting identity must have `s3:GetObject`, `s3:PutObject`, etc.
- Check for permission boundaries that restrict access

**Block Public Access Settings**
```bash
aws s3api get-public-access-block --bucket my-bucket
```
- Account-level BPA settings override bucket-level settings
- All four BPA settings (BlockPublicAcls, IgnorePublicAcls, BlockPublicPolicy, RestrictPublicBuckets) default to enabled on new buckets

**ACL Issues**
- ACLs are legacy - prefer bucket policies and IAM policies
- If using ACLs, verify the bucket ownership setting allows them
- Object ownership setting "BucketOwnerEnforced" disables ACLs entirely

**Cross-Account Access**
- Both the source account (IAM policy) and destination account (bucket policy) must allow access
- Use `s3:PutObjectAcl` with `bucket-owner-full-control` for cross-account uploads

**Docs:** https://docs.aws.amazon.com/AmazonS3/latest/userguide/troubleshoot-403-errors.html

---

## IAM Permission Debugging

### Systematic Approach to Permission Issues

**Step 1 - Use IAM Policy Simulator**
```bash
aws iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::123456789012:user/myuser \
  --action-names s3:GetObject \
  --resource-arns arn:aws:s3:::my-bucket/*
```
- Test specific actions against specific resources
- Console: https://policysim.aws.amazon.com/

**Step 2 - Check CloudTrail for Denied Requests**
```bash
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=GetObject \
  --max-results 10
```
- Look for `errorCode: AccessDenied` or `Client.UnauthorizedAccess`
- The `errorMessage` field often tells you which policy denied access

**Step 3 - IAM Access Analyzer**
- Validates policies against best practices
- Identifies resources shared with external entities
- Generates policies based on CloudTrail activity

**Common Gotchas**
- Service Control Policies (SCPs) in AWS Organizations can restrict permissions even if IAM allows them
- Permission boundaries limit the maximum permissions an IAM entity can have
- Session policies (when assuming roles) further restrict effective permissions
- Resource-based policies and identity-based policies are evaluated together

**Docs:** https://docs.aws.amazon.com/IAM/latest/UserGuide/troubleshoot.html

---

## VPC and Networking

### NAT Gateway Issues

**Instance in Private Subnet Cannot Reach Internet**
1. Check the private subnet route table has `0.0.0.0/0 -> nat-xxxxxxxx`
2. Verify the NAT Gateway is in a public subnet with an Elastic IP
3. Confirm the NAT Gateway's subnet route table has `0.0.0.0/0 -> igw-xxxxxxxx`
4. Check NAT Gateway status - must be "Available"

```bash
aws ec2 describe-nat-gateways --nat-gateway-ids nat-xxxxxxxx
```

### VPC Peering Problems

- Routes must be added in BOTH VPCs pointing to the peering connection
- Security groups must reference the peered VPC's CIDR or security group ID
- CIDR blocks must not overlap between peered VPCs
- DNS resolution across peering requires enabling DNS hostnames and resolution

```bash
aws ec2 describe-vpc-peering-connections --filters Name=status-code,Values=active
```

### VPC Endpoint Issues

**Gateway Endpoints (S3, DynamoDB)**
- Must add a route in the route table to the endpoint
- Endpoint policy may restrict which buckets/tables are accessible
- Only works within the same region

**Interface Endpoints (most other services)**
- Creates an ENI in your subnet - check its security group
- Enable private DNS to use default service endpoints
- Verify the endpoint's subnet has the correct route table

**Docs:** https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html

---

## Lambda Errors

### Timeout Errors

- Default timeout is 3 seconds, maximum is 15 minutes
- Check if the function is waiting on external resources (database, API calls)
- If in a VPC, verify NAT Gateway is configured for internet access
- Use X-Ray tracing to identify slow segments

```bash
aws lambda update-function-configuration \
  --function-name my-function \
  --timeout 30
```

### Memory and Performance

- More memory also allocates more CPU proportionally
- At 1,769 MB, the function gets one full vCPU
- Monitor with CloudWatch metrics: Duration, MaxMemoryUsed
- Use Lambda Power Tuning to find optimal memory setting

### Permission Errors

- Execution role needs permissions for any AWS services the function calls
- Resource-based policy controls who can invoke the function
- For VPC functions, the role needs `ec2:CreateNetworkInterface`, `ec2:DescribeNetworkInterfaces`, `ec2:DeleteNetworkInterface`

### Cold Starts

- First invocation after idle period takes longer (100ms to several seconds)
- Provisioned concurrency eliminates cold starts but adds cost
- Keep deployment packages small
- Avoid initializing heavy resources outside the handler unless reused

**Docs:** https://docs.aws.amazon.com/lambda/latest/dg/troubleshooting.html

---

## CloudFormation Stack Failures

### Stack Rollback Issues

**Common Causes of Failure**
- Insufficient IAM permissions for the resources being created
- Resource limit exceeded (check service quotas)
- Dependency ordering issues between resources
- Invalid parameter values or references

**Debugging Steps**
```bash
# View stack events to find the failure
aws cloudformation describe-stack-events \
  --stack-name my-stack \
  --query 'StackEvents[?ResourceStatus==`CREATE_FAILED`]'

# Check the status reason for details
aws cloudformation describe-stack-events \
  --stack-name my-stack | grep -A5 "CREATE_FAILED"
```

**Stuck in DELETE_FAILED**
- Some resources may have dependencies outside the stack
- Use `--retain-resources` to skip problematic resources during deletion
- Check for S3 buckets that are not empty or ENIs attached to other resources

**Stuck in UPDATE_ROLLBACK_FAILED**
- Use `continue-update-rollback` with `--resources-to-skip` for resources that cannot be rolled back

**Docs:** https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/troubleshooting.html

---

## RDS Connectivity

### Cannot Connect to RDS Instance

**Security Group Configuration**
- RDS security group must allow inbound on the database port (3306 for MySQL, 5432 for PostgreSQL, 1433 for SQL Server)
- Source should be the application's security group or CIDR block
- If connecting from outside VPC, the instance must be publicly accessible with a public subnet

**Parameter Group Issues**
- Changes to static parameters require a reboot
- Check `max_connections` if getting "too many connections" errors
- Verify `require_secure_transport` setting if SSL is expected

**SSL/TLS Connection**
```bash
# Download the RDS CA certificate
wget https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem

# Connect with SSL
mysql -h mydb.xxxx.us-east-1.rds.amazonaws.com -u admin -p --ssl-ca=global-bundle.pem
```

**DNS Resolution**
- RDS endpoints are DNS names, not IP addresses
- After failover, the DNS name resolves to the new primary
- TTL is 5 seconds - do not cache DNS lookups in application code

**Authentication Issues**
- Master password can be reset via console or CLI (causes brief unavailability)
- IAM database authentication generates temporary tokens - check token expiry
- Ensure the database user has the correct grants for the target database/schema

**Docs:** https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Troubleshooting.html

---

## Quick Reference - AWS CLI Debugging

```bash
# Enable debug logging
aws s3 ls --debug 2>&1 | head -100

# Check current identity
aws sts get-caller-identity

# Validate CloudFormation template
aws cloudformation validate-template --template-body file://template.yaml

# Test VPC connectivity with Reachability Analyzer
aws ec2 create-network-insights-path \
  --source i-source \
  --destination i-dest \
  --protocol TCP \
  --destination-port 443
```

---

## Additional Resources

- [AWS Troubleshooting Landing Page](https://docs.aws.amazon.com/index.html)
- [AWS re:Post Knowledge Center](https://repost.aws/knowledge-center)
- [AWS Health Dashboard](https://health.aws.amazon.com/health/status)
- [AWS Service Quotas](https://docs.aws.amazon.com/general/latest/gr/aws_service_information.html)
