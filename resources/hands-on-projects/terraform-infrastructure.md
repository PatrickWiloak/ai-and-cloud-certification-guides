# Hands-On Project: Build Infrastructure with Terraform

Define and deploy cloud infrastructure using Terraform with remote state and modules.

**Estimated Time:** 3-4 hours
**Difficulty:** Intermediate
**Prerequisites:** Terraform installed, cloud CLI configured, basic HCL knowledge

---

## Architecture Overview

```
Terraform Project
  |
  +-- Remote State (S3 / Azure Storage / GCS)
  |
  +-- Modules
  |     +-- networking (VPC, subnets, routes)
  |     +-- compute (instances, load balancer)
  |     +-- database (managed database)
  |
  +-- Environments
        +-- dev.tfvars
        +-- staging.tfvars
        +-- production.tfvars
```

**Infrastructure to Build**
```
VPC/VNet with public and private subnets
  |
  +-- Load Balancer (public subnet)
  |     |
  +-- Compute Instances (private subnet, auto-scaling)
  |     |
  +-- Managed Database (private subnet, encrypted)
```

---

## Step 1: Project Structure

```
terraform-project/
  modules/
    networking/
      main.tf
      variables.tf
      outputs.tf
    compute/
      main.tf
      variables.tf
      outputs.tf
    database/
      main.tf
      variables.tf
      outputs.tf
  environments/
    dev.tfvars
    staging.tfvars
    production.tfvars
  main.tf
  variables.tf
  outputs.tf
  providers.tf
  backend.tf
```

---

## Step 2: Configure Remote State

### AWS S3 Backend

```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "infrastructure/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

**Create the state bucket and lock table:**
```bash
# Create S3 bucket
aws s3api create-bucket --bucket my-terraform-state-bucket --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning --bucket my-terraform-state-bucket \
  --versioning-configuration Status=Enabled

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

### Azure Storage Backend

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstateaccount"
    container_name       = "tfstate"
    key                  = "infrastructure.tfstate"
  }
}
```

### GCS Backend

```hcl
terraform {
  backend "gcs" {
    bucket = "my-terraform-state-bucket"
    prefix = "infrastructure"
  }
}
```

---

## Step 3: Provider Configuration

```hcl
# providers.tf
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}
```

---

## Step 4: Networking Module

```hcl
# modules/networking/variables.tf
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}
```

```hcl
# modules/networking/main.tf
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.environment}-vpc"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-${var.availability_zones[count.index]}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 10)
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.environment}-private-${var.availability_zones[count.index]}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "${var.environment}-nat-eip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.environment}-nat"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.environment}-public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.environment}-private-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
```

```hcl
# modules/networking/outputs.tf
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
```

---

## Step 5: Compute Module

```hcl
# modules/compute/main.tf
resource "aws_security_group" "alb" {
  name_prefix = "${var.environment}-alb-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app" {
  name_prefix = "${var.environment}-app-"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "main" {
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_target_group" "app" {
  name     = "${var.environment}-app-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    interval            = 30
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_launch_template" "app" {
  name_prefix   = "${var.environment}-app-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.app.id]

  iam_instance_profile {
    name = var.instance_profile_name
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    environment = var.environment
  }))
}

resource "aws_autoscaling_group" "app" {
  name                = "${var.environment}-app-asg"
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [aws_lb_target_group.app.arn]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-app"
    propagate_at_launch = true
  }
}
```

---

## Step 6: Database Module

```hcl
# modules/database/main.tf
resource "aws_security_group" "db" {
  name_prefix = "${var.environment}-db-"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet"
  subnet_ids = var.private_subnet_ids
}

resource "aws_rds_instance" "main" {
  identifier             = "${var.environment}-postgres"
  engine                 = "postgres"
  engine_version         = "15.4"
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  db_name                = var.database_name
  username               = var.master_username
  password               = var.master_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]
  skip_final_snapshot    = var.environment != "production"
  storage_encrypted      = true
  multi_az               = var.environment == "production"
  backup_retention_period = var.environment == "production" ? 7 : 1

  tags = {
    Name = "${var.environment}-postgres"
  }
}
```

---

## Step 7: Root Module

```hcl
# main.tf
module "networking" {
  source             = "./modules/networking"
  vpc_cidr           = var.vpc_cidr
  environment        = var.environment
  availability_zones = var.availability_zones
}

module "compute" {
  source                = "./modules/compute"
  environment           = var.environment
  vpc_id                = module.networking.vpc_id
  public_subnet_ids     = module.networking.public_subnet_ids
  private_subnet_ids    = module.networking.private_subnet_ids
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  desired_capacity      = var.desired_capacity
  min_size              = var.min_size
  max_size              = var.max_size
  certificate_arn       = var.certificate_arn
  instance_profile_name = var.instance_profile_name
}

module "database" {
  source                 = "./modules/database"
  environment            = var.environment
  vpc_id                 = module.networking.vpc_id
  private_subnet_ids     = module.networking.private_subnet_ids
  app_security_group_id  = module.compute.app_security_group_id
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  database_name          = var.database_name
  master_username        = var.db_master_username
  master_password        = var.db_master_password
}
```

---

## Step 8: Environment Variables

```hcl
# environments/dev.tfvars
environment        = "dev"
aws_region         = "us-east-1"
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
instance_type      = "t3.micro"
desired_capacity   = 1
min_size           = 1
max_size           = 2
db_instance_class  = "db.t3.micro"
db_allocated_storage = 20
```

```hcl
# environments/production.tfvars
environment        = "production"
aws_region         = "us-east-1"
vpc_cidr           = "10.1.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
instance_type      = "t3.large"
desired_capacity   = 3
min_size           = 2
max_size           = 10
db_instance_class  = "db.r6g.large"
db_allocated_storage = 100
```

---

## Step 9: Deploy

```bash
# Initialize
terraform init

# Plan for dev environment
terraform plan -var-file=environments/dev.tfvars -out=dev.plan

# Review the plan carefully
terraform show dev.plan

# Apply
terraform apply dev.plan

# View outputs
terraform output
```

---

## Verification Checklist

- [ ] Remote state is stored in cloud storage (not local)
- [ ] State locking is configured (DynamoDB / blob lease / GCS)
- [ ] VPC with public and private subnets is created
- [ ] Load balancer is accessible from the internet
- [ ] Compute instances are in private subnets
- [ ] Database is in a private subnet with encryption enabled
- [ ] Security groups follow least-privilege principles
- [ ] Different environments use different variable files
- [ ] `terraform plan` shows no unintended changes after apply

---

## Cleanup

```bash
# Destroy all resources
terraform destroy -var-file=environments/dev.tfvars

# Manually delete the state bucket and lock table if no longer needed
```

---

## Additional Resources

- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Terraform Best Practices](https://developer.hashicorp.com/terraform/cloud-docs/recommended-practices)
