# Terraform CLI Cheat Sheet

Quick reference for Terraform commands used in infrastructure as code workflows and HashiCorp Terraform Associate exam preparation.

**Official Documentation:** https://developer.hashicorp.com/terraform/cli

---

## Table of Contents

- [Core Workflow](#core-workflow)
- [State Management](#state-management)
- [Workspace Management](#workspace-management)
- [Module Commands](#module-commands)
- [Format and Validate](#format-and-validate)
- [Output and Console Commands](#output-and-console-commands)
- [Backend Configuration](#backend-configuration)
- [Variable Management](#variable-management)
- [Import and Migration](#import-and-migration)
- [Useful Flags and Options](#useful-flags-and-options)

---

## Core Workflow

```bash
# Initialize a Terraform working directory
terraform init

# Reinitialize and upgrade providers/modules
terraform init -upgrade

# Initialize with a specific backend config
terraform init -backend-config=backend.hcl

# Initialize without backend configuration
terraform init -backend=false

# Create an execution plan
terraform plan

# Save a plan to a file
terraform plan -out=tfplan

# Plan for destruction
terraform plan -destroy

# Plan targeting specific resources
terraform plan -target=aws_instance.web

# Apply changes
terraform apply

# Apply a saved plan (no approval prompt)
terraform apply tfplan

# Apply with auto-approve (skip confirmation)
terraform apply -auto-approve

# Apply targeting specific resources
terraform apply -target=aws_instance.web

# Destroy all managed resources
terraform destroy

# Destroy with auto-approve
terraform destroy -auto-approve

# Destroy targeting specific resources
terraform destroy -target=aws_instance.web

# Refresh state to match real infrastructure
terraform apply -refresh-only

# Plan a refresh-only operation
terraform plan -refresh-only
```

---

## State Management

```bash
# List all resources in state
terraform state list

# List resources matching a filter
terraform state list aws_instance.*

# Show details of a specific resource
terraform state show aws_instance.web

# Move a resource in state (rename)
terraform state mv aws_instance.old aws_instance.new

# Move a resource to a different state file
terraform state mv -state-out=other.tfstate aws_instance.web aws_instance.web

# Remove a resource from state (without destroying)
terraform state rm aws_instance.web

# Pull remote state to local
terraform state pull

# Push local state to remote
terraform state push

# Replace a provider in state
terraform state replace-provider hashicorp/aws registry.example.com/aws

# Show the full state file
terraform show

# Show a saved plan file
terraform show tfplan

# Show state in JSON format
terraform show -json

# Force unlock state (use with caution)
terraform force-unlock LOCK_ID

# View providers required by configuration
terraform providers

# Create a provider mirror
terraform providers mirror /path/to/mirror

# Lock provider versions
terraform providers lock -platform=linux_amd64
```

---

## Workspace Management

```bash
# List all workspaces
terraform workspace list

# Show current workspace
terraform workspace show

# Create a new workspace
terraform workspace new staging

# Select a workspace
terraform workspace select production

# Delete a workspace
terraform workspace delete staging

# Create and switch to a new workspace
terraform workspace new dev
```

Using workspaces in configuration:

```hcl
# Reference the current workspace
resource "aws_instance" "web" {
  tags = {
    Environment = terraform.workspace
  }
}

# Conditional based on workspace
locals {
  instance_type = terraform.workspace == "production" ? "m5.large" : "t3.micro"
}
```

---

## Module Commands

```bash
# Download and install modules
terraform init

# Get/update modules without full init
terraform get

# Update modules to latest versions
terraform get -update

# View module output
terraform output -module=vpc
```

Module source examples:

```hcl
# Local path
module "vpc" {
  source = "./modules/vpc"
}

# Terraform Registry
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"
}

# GitHub
module "vpc" {
  source = "github.com/example/terraform-module"
}

# S3 bucket
module "vpc" {
  source = "s3::https://s3-eu-west-1.amazonaws.com/bucket/module.zip"
}

# GCS bucket
module "vpc" {
  source = "gcs::https://www.googleapis.com/storage/v1/modules/module.zip"
}
```

---

## Format and Validate

```bash
# Format Terraform files
terraform fmt

# Format recursively
terraform fmt -recursive

# Check formatting without modifying files
terraform fmt -check

# Show diffs of formatting changes
terraform fmt -diff

# Validate configuration syntax
terraform validate

# Validate in JSON output format
terraform validate -json
```

---

## Output and Console Commands

```bash
# List all outputs
terraform output

# Show a specific output
terraform output instance_ip

# Show output in JSON format
terraform output -json

# Show a raw output value (no quotes)
terraform output -raw instance_ip

# Interactive console for expressions
terraform console

# Use console non-interactively
echo 'length(var.subnets)' | terraform console

# Generate a dependency graph
terraform graph

# Generate a graph and render with Graphviz
terraform graph | dot -Tpng > graph.png

# View version information
terraform version
```

---

## Backend Configuration

### S3 Backend

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

### Azure Storage Backend

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatestorage"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
```

### GCS Backend

```hcl
terraform {
  backend "gcs" {
    bucket = "my-terraform-state"
    prefix = "prod"
  }
}
```

### Partial Backend Configuration

```bash
# Initialize with partial backend config from file
terraform init -backend-config=backend.hcl

# Initialize with partial backend config from CLI
terraform init \
  -backend-config="bucket=my-state-bucket" \
  -backend-config="key=prod/terraform.tfstate" \
  -backend-config="region=us-east-1"

# Reconfigure backend
terraform init -reconfigure

# Migrate state between backends
terraform init -migrate-state
```

---

## Variable Management

### Setting Variables

```bash
# Pass variable on command line
terraform plan -var="instance_type=t3.micro"

# Pass multiple variables
terraform plan -var="instance_type=t3.micro" -var="region=us-west-2"

# Use a variable file
terraform plan -var-file="production.tfvars"

# Auto-loaded variable files (no flag needed)
# terraform.tfvars
# terraform.tfvars.json
# *.auto.tfvars
# *.auto.tfvars.json

# Environment variables (prefix with TF_VAR_)
export TF_VAR_instance_type="t3.micro"
export TF_VAR_region="us-west-2"
terraform plan
```

### Variable Definitions

```hcl
# Basic variable
variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance type"
}

# Variable with validation
variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

# Sensitive variable
variable "db_password" {
  type      = string
  sensitive = true
}

# Complex variable types
variable "tags" {
  type = map(string)
  default = {
    Project = "demo"
  }
}

variable "subnets" {
  type = list(object({
    cidr = string
    az   = string
  }))
}
```

---

## Import and Migration

```bash
# Import an existing resource into state
terraform import aws_instance.web i-1234567890abcdef0

# Import with a specific provider
terraform import -provider=aws.west aws_instance.web i-1234567890

# Generate configuration for imported resources (Terraform 1.5+)
# Add import block to configuration:
```

```hcl
import {
  to = aws_instance.web
  id = "i-1234567890abcdef0"
}
```

```bash
# Generate config from import blocks
terraform plan -generate-config-out=generated.tf
```

---

## Useful Flags and Options

### Common Flags

```bash
# Parallelism (default 10)
terraform apply -parallelism=20

# Compact warnings
terraform plan -compact-warnings

# No color output (useful for CI/CD)
terraform plan -no-color

# Lock timeout
terraform apply -lock-timeout=5m

# Disable state locking
terraform apply -lock=false

# Input variables interactively
terraform apply -input=true

# Disable interactive input
terraform apply -input=false
```

### Environment Variables

```bash
# Set log level (TRACE, DEBUG, INFO, WARN, ERROR)
export TF_LOG=DEBUG

# Set log output file
export TF_LOG_PATH=terraform.log

# Set specific component log level
export TF_LOG_CORE=DEBUG
export TF_LOG_PROVIDER=WARN

# Disable color output
export TF_CLI_ARGS="-no-color"

# Set default variable file
export TF_CLI_ARGS_plan="-var-file=prod.tfvars"

# Custom plugin directory
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

# Set data directory
export TF_DATA_DIR=".terraform-custom"

# Disable checkpoint (version check)
export CHECKPOINT_DISABLE=1
```

### .terraformrc / terraform.rc

```hcl
# Plugin cache directory
plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"

# Provider installation settings
provider_installation {
  filesystem_mirror {
    path    = "/usr/share/terraform/providers"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = []
  }
}

# Credentials for Terraform Cloud
credentials "app.terraform.io" {
  token = "your-api-token"
}
```

---

## Terraform Cloud / Enterprise Commands

```bash
# Login to Terraform Cloud
terraform login

# Login to a custom host
terraform login app.terraform.io

# Logout
terraform logout

# Trigger a run via CLI
terraform apply

# Use Terraform Cloud as backend
```

```hcl
terraform {
  cloud {
    organization = "my-org"
    workspaces {
      name = "my-workspace"
    }
  }
}
```

---

## Quick Reference - File Structure

```
project/
  main.tf          # Main configuration
  variables.tf     # Variable declarations
  outputs.tf       # Output declarations
  providers.tf     # Provider configuration
  versions.tf      # Terraform and provider version constraints
  terraform.tfvars # Variable values (do not commit secrets)
  backend.hcl      # Backend configuration (partial)
  modules/         # Local modules
    vpc/
      main.tf
      variables.tf
      outputs.tf
```

---

## Resources

- Terraform CLI Documentation: https://developer.hashicorp.com/terraform/cli
- Terraform Language Documentation: https://developer.hashicorp.com/terraform/language
- Terraform Registry: https://registry.terraform.io/
- Terraform Associate Study Guide: https://developer.hashicorp.com/terraform/tutorials/certification-003/associate-study-003
- Terraform Best Practices: https://developer.hashicorp.com/terraform/cloud-docs/recommended-practices
