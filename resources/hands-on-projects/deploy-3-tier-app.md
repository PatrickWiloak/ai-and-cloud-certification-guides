# Hands-On Project: Deploy a 3-Tier Application

Deploy a production-like three-tier web application with frontend, backend, and database layers.

**Estimated Time:** 3-4 hours
**Difficulty:** Intermediate
**Prerequisites:** Basic cloud CLI experience, familiarity with networking concepts

---

## Architecture Overview

```
                Internet
                   |
              [CDN / S3]        <-- Frontend (Static files)
                   |
              [Load Balancer]   <-- HTTPS termination
                   |
          [Backend Instances]   <-- Application servers (containers or VMs)
                   |
            [Managed Database]  <-- RDS / Azure SQL / Cloud SQL
```

**Components**
- Frontend: Static site hosted on object storage with CDN
- Backend: Application servers behind a load balancer
- Database: Managed relational database in a private subnet
- Networking: VPC with public and private subnets

---

## Step 1: Create the Network (VPC)

### AWS
```bash
# Create VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16 --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=three-tier-vpc}]'

# Create subnets
# Public subnets (for load balancer)
aws ec2 create-subnet --vpc-id vpc-xxx --cidr-block 10.0.1.0/24 --availability-zone us-east-1a
aws ec2 create-subnet --vpc-id vpc-xxx --cidr-block 10.0.2.0/24 --availability-zone us-east-1b

# Private subnets (for backend)
aws ec2 create-subnet --vpc-id vpc-xxx --cidr-block 10.0.3.0/24 --availability-zone us-east-1a
aws ec2 create-subnet --vpc-id vpc-xxx --cidr-block 10.0.4.0/24 --availability-zone us-east-1b

# Database subnets (isolated)
aws ec2 create-subnet --vpc-id vpc-xxx --cidr-block 10.0.5.0/24 --availability-zone us-east-1a
aws ec2 create-subnet --vpc-id vpc-xxx --cidr-block 10.0.6.0/24 --availability-zone us-east-1b

# Create Internet Gateway and NAT Gateway
aws ec2 create-internet-gateway
aws ec2 attach-internet-gateway --internet-gateway-id igw-xxx --vpc-id vpc-xxx
```

### Azure
```bash
az network vnet create --resource-group myRG --name three-tier-vnet \
  --address-prefix 10.0.0.0/16 \
  --subnet-name public --subnet-prefix 10.0.1.0/24

az network vnet subnet create --resource-group myRG --vnet-name three-tier-vnet \
  --name backend --address-prefix 10.0.3.0/24

az network vnet subnet create --resource-group myRG --vnet-name three-tier-vnet \
  --name database --address-prefix 10.0.5.0/24
```

### GCP
```bash
gcloud compute networks create three-tier-vpc --subnet-mode custom

gcloud compute networks subnets create public-subnet \
  --network three-tier-vpc --range 10.0.1.0/24 --region us-central1

gcloud compute networks subnets create backend-subnet \
  --network three-tier-vpc --range 10.0.3.0/24 --region us-central1

gcloud compute networks subnets create database-subnet \
  --network three-tier-vpc --range 10.0.5.0/24 --region us-central1
```

---

## Step 2: Deploy the Database

### AWS (RDS)
```bash
# Create a DB subnet group
aws rds create-db-subnet-group --db-subnet-group-name three-tier-db \
  --db-subnet-group-description "Database subnets" \
  --subnet-ids subnet-xxx subnet-yyy

# Create security group for database
aws ec2 create-security-group --group-name db-sg --description "Database SG" --vpc-id vpc-xxx
aws ec2 authorize-security-group-ingress --group-id sg-xxx \
  --protocol tcp --port 5432 --source-group sg-backend

# Launch RDS instance
aws rds create-db-instance \
  --db-instance-identifier three-tier-db \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --master-username admin \
  --master-user-password YOUR_PASSWORD \
  --allocated-storage 20 \
  --db-subnet-group-name three-tier-db \
  --vpc-security-group-ids sg-xxx \
  --no-publicly-accessible \
  --storage-encrypted
```

### Azure (Azure SQL)
```bash
az sql server create --resource-group myRG --name three-tier-sql \
  --admin-user admin --admin-password YOUR_PASSWORD

az sql db create --resource-group myRG --server three-tier-sql \
  --name appdb --service-objective S0
```

### GCP (Cloud SQL)
```bash
gcloud sql instances create three-tier-db \
  --database-version POSTGRES_15 \
  --tier db-f1-micro \
  --region us-central1 \
  --network three-tier-vpc \
  --no-assign-ip
```

---

## Step 3: Deploy the Backend

### Option A: Container-Based (ECS / Azure Container Instances / Cloud Run)

**AWS ECS Example**
```bash
# Create an ECS cluster
aws ecs create-cluster --cluster-name three-tier-backend

# Register a task definition (create task-def.json first)
aws ecs register-task-definition --cli-input-json file://task-def.json

# Create a service behind the ALB
aws ecs create-service \
  --cluster three-tier-backend \
  --service-name backend-service \
  --task-definition backend-task \
  --desired-count 2 \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[subnet-xxx,subnet-yyy],securityGroups=[sg-xxx]}" \
  --load-balancers "targetGroupArn=arn:xxx,containerName=app,containerPort=8080"
```

### Option B: VM-Based

**AWS EC2 Example**
```bash
# Launch instances in private subnets
aws ec2 run-instances \
  --image-id ami-xxx \
  --instance-type t3.micro \
  --count 2 \
  --subnet-id subnet-xxx \
  --security-group-ids sg-xxx \
  --iam-instance-profile Name=backend-role \
  --user-data file://startup.sh
```

---

## Step 4: Configure the Load Balancer

### AWS (ALB)
```bash
# Create ALB
aws elbv2 create-load-balancer --name three-tier-alb \
  --subnets subnet-pub1 subnet-pub2 \
  --security-groups sg-alb

# Create target group
aws elbv2 create-target-group --name backend-tg \
  --protocol HTTP --port 8080 \
  --vpc-id vpc-xxx --target-type ip \
  --health-check-path /health

# Create HTTPS listener (requires ACM certificate)
aws elbv2 create-listener --load-balancer-arn arn:xxx \
  --protocol HTTPS --port 443 \
  --certificates CertificateArn=arn:aws:acm:xxx \
  --default-actions Type=forward,TargetGroupArn=arn:xxx
```

### Azure (Application Gateway)
```bash
az network application-gateway create --resource-group myRG \
  --name three-tier-appgw --sku Standard_v2 \
  --vnet-name three-tier-vnet --subnet public \
  --http-settings-port 8080 --http-settings-protocol Http \
  --frontend-port 443 --routing-rule-type Basic
```

### GCP (HTTP(S) Load Balancer)
```bash
gcloud compute health-checks create http backend-hc --port 8080 --request-path /health

gcloud compute backend-services create backend-svc \
  --protocol HTTP --port-name http --health-checks backend-hc --global

gcloud compute url-maps create three-tier-lb --default-service backend-svc
gcloud compute target-https-proxies create three-tier-proxy \
  --url-map three-tier-lb --ssl-certificates my-cert
gcloud compute forwarding-rules create three-tier-fwd \
  --target-https-proxy three-tier-proxy --ports 443 --global
```

---

## Step 5: Deploy the Frontend

### AWS (S3 + CloudFront)
```bash
# Create S3 bucket for static hosting
aws s3 mb s3://my-frontend-bucket
aws s3 sync ./frontend/build s3://my-frontend-bucket

# Create CloudFront distribution
aws cloudfront create-distribution \
  --origin-domain-name my-frontend-bucket.s3.amazonaws.com \
  --default-root-object index.html
```

### Azure (Storage + CDN)
```bash
az storage blob service-properties update --account-name mystorageacct \
  --static-website --index-document index.html

az storage blob upload-batch --account-name mystorageacct \
  --source ./frontend/build --destination '$web'

az cdn endpoint create --resource-group myRG --profile-name myCDN \
  --name my-frontend --origin mystorageacct.z13.web.core.windows.net
```

### GCP (Cloud Storage + Cloud CDN)
```bash
gsutil mb gs://my-frontend-bucket
gsutil -m cp -r ./frontend/build/* gs://my-frontend-bucket/
gsutil web set -m index.html gs://my-frontend-bucket

# Cloud CDN is configured via the load balancer backend bucket
gcloud compute backend-buckets create frontend-bucket \
  --gcs-bucket-name my-frontend-bucket --enable-cdn
```

---

## Step 6: Configure DNS

Point your domain to the frontend CDN and backend load balancer.

```
www.example.com    -> CDN distribution (frontend)
api.example.com    -> Load Balancer (backend)
```

Use ALIAS/ANAME records for zone apex or CNAME for subdomains.

---

## Security Checklist

- [ ] Database is in a private subnet with no public IP
- [ ] Backend instances are in private subnets, only accessible via load balancer
- [ ] Security groups follow least-privilege (only required ports)
- [ ] SSL/TLS termination at the load balancer with valid certificates
- [ ] Database credentials stored in a secrets manager (not hardcoded)
- [ ] IAM roles assigned to backend instances (no access keys)
- [ ] Encryption at rest enabled for database and storage
- [ ] Encryption in transit between all layers
- [ ] Access logging enabled on the load balancer
- [ ] Web Application Firewall (WAF) in front of the load balancer

---

## Cleanup

Remove all resources when done to avoid charges:
1. Delete the CDN distribution and S3 bucket
2. Delete the load balancer and target groups
3. Delete backend instances or services
4. Delete the database instance
5. Delete NAT Gateways (they incur hourly charges)
6. Delete the VPC and all associated resources

---

## Additional Resources

- [AWS Three-Tier Architecture](https://docs.aws.amazon.com/whitepapers/latest/serverless-multi-tier-architectures-api-gateway-lambda/three-tier-architecture-overview.html)
- [Azure N-Tier Architecture](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/n-tier)
- [GCP Three-Tier Web App](https://cloud.google.com/architecture/three-tier-web-app-deployment)
