# Packer Associate (003) - Fact Sheet

## Exam Logistics

| Attribute | Value |
|-----------|-------|
| Exam name | HashiCorp Certified: Packer Associate (003) |
| Delivery | Online proctored (PSI), multiple-choice and multi-select |
| Duration | 60 minutes |
| Number of questions | 57 |
| Passing score | Approximately 70% (HashiCorp does not publish exact cut score) |
| Cost | $70.50 USD |
| Language | English |
| Validity | 2 years |
| Retake wait | 14 days first retake, 30 days second, 1 year third |
| Recommended experience | 6+ months with Packer, comfort with at least one cloud |

## Exam Domains and Weights

Weights below are realistic estimates aligned with HashiCorp's published objectives.

### Domain 1: Packer Fundamentals (approximately 15%)

- What Packer is and what problem it solves (immutable infrastructure, golden images)
- Packer vs Terraform, Packer vs configuration management (Ansible/Chef/Puppet)
- Packer build lifecycle: parse > validate > build > provision > post-process > artifact
- Packer CLI: `packer init`, `fmt`, `validate`, `build`, `inspect`, `hcl2_upgrade`, `plugins`
- Installing Packer and managing versions

### Domain 2: Plugins: Builders, Provisioners, Post-Processors (approximately 25%)

- Plugin architecture: external plugins pulled via `packer init`
- Key builders: amazon-ebs, amazon-ebssurrogate, amazon-chroot, amazon-instance, azure-arm, googlecompute, vsphere-iso, docker, qemu, virtualbox-iso, hyperv-iso, null
- Provisioners: shell, shell-local, ansible, ansible-local, chef-solo, chef-client, puppet-masterless, puppet-server, file, powershell, windows-shell, breakpoint
- Post-processors: amazon-import, docker-push, docker-tag, manifest, shell-local, vagrant, compress, checksum, vsphere-template, artifice, googlecompute-import, hcp-packer-registry
- When to use each
- Ordering and pipelines

### Domain 3: HCL2 Configuration Authoring (approximately 20%)

- File layout: `.pkr.hcl` files, `packer {}` block, `source` blocks, `build` blocks, `variable` and `local` blocks
- Variable types: string, number, bool, list, map, object
- Sensitive variables
- `locals` with expressions
- Functions: `env()`, `file()`, `fileset()`, `templatefile()`, `formatdate()`, `timestamp()`
- Dynamic blocks and `for_each` on sources
- Required plugins block with version constraints
- `hcl2_upgrade` for migrating JSON to HCL

### Domain 4: HCP Packer and Artifact Management (approximately 15%)

- HCP Packer overview: image registry, channels, iterations
- `hcp-packer-registry` post-processor
- Channels (dev, staging, prod) and promotion
- HCP Packer data sources in Terraform for consuming tracked images
- Ancestry and compliance views
- Revoking iterations

### Domain 5: CI/CD and Multi-Cloud (approximately 15%)

- Running Packer in GitHub Actions, GitLab CI, Jenkins
- Parallel builds across multiple clouds from one template
- Caching and artifact storage
- Versioning images (manifest post-processor, tag conventions)
- Using Packer with Terraform (build image, then provision)

### Domain 6: Security and Credentials (approximately 10%)

- Sensitive variables (`sensitive = true`)
- Environment variables for credentials (`AWS_ACCESS_KEY_ID`, `GOOGLE_APPLICATION_CREDENTIALS`, etc.)
- IAM roles on the build host
- Temporary credentials (STS, GCP service account impersonation)
- `packer validate -evaluate-datasources`
- Encrypted AMIs, encrypted EBS volumes
- SSH key management

## Packer CLI Quick Reference

```
packer init .                         # download plugins per required_plugins
packer fmt .                          # format HCL files
packer validate [-var-file=X.pkrvars.hcl] .    # syntax + internal checks
packer build [-only=...] [-except=...] .       # execute builds
packer build -var 'foo=bar' .         # pass variable
packer build -parallel-builds=1 .     # serialize builds
packer build -on-error=cleanup .      # cleanup, ask, abort, run-cleanup-provisioner
packer inspect .                      # display variables, builders, provisioners
packer hcl2_upgrade template.json     # convert legacy JSON to HCL2
packer plugins installed              # list installed plugins
packer plugins required .             # show required plugins
packer version
```

## Minimal AWS AMI Template

```hcl
packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1.3"
    }
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "ubuntu-base-${formatdate("YYYYMMDD-hhmm", timestamp())}"
  instance_type = "t3.micro"
  region        = var.region

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

  ssh_username = "ubuntu"

  tags = {
    Name        = "ubuntu-base"
    Environment = "build"
  }
}

build {
  name    = "base"
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt-get install -y nginx",
    ]
  }

  post-processor "manifest" {
    output = "manifest.json"
  }
}
```

## Key Builders

| Builder | Purpose |
|---------|---------|
| amazon-ebs | Build an AMI from an EBS-backed instance |
| amazon-ebssurrogate | Build AMI from a detached root volume; advanced use |
| amazon-chroot | Build AMI in-place on an already-running EC2 instance |
| amazon-instance | Build instance-store AMIs |
| azure-arm | Azure Managed Image or Shared Image Gallery |
| googlecompute | GCP Compute Engine image |
| vsphere-iso | VMware from ISO |
| docker | Docker image from Dockerfile-like steps |
| qemu | QEMU/KVM virtual machine image |
| virtualbox-iso | VirtualBox OVF/OVA |
| null | No-op builder (useful for provisioner-only flows) |

## Key Provisioners

| Provisioner | Purpose |
|-------------|---------|
| shell | Run shell commands on the builder instance |
| shell-local | Run shell commands on the host running Packer |
| ansible | Run Ansible against the builder (requires Ansible installed locally) |
| ansible-local | Run Ansible inside the builder |
| file | Upload file or directory to the builder |
| powershell | Windows PowerShell commands |
| windows-shell | Windows cmd commands |
| chef-solo, chef-client | Chef-based configuration |
| puppet-masterless, puppet-server | Puppet-based configuration |
| breakpoint | Pause build for debugging |

## Key Post-Processors

| Post-processor | Purpose |
|----------------|---------|
| manifest | Write JSON manifest of artifacts |
| docker-tag, docker-push | Tag and push Docker images |
| amazon-import | Import VMDK/OVA as AMI |
| googlecompute-import | Import image to GCP |
| vagrant | Create Vagrant box |
| compress | Compress artifacts |
| checksum | Generate checksums |
| vsphere-template | Convert VM to template |
| shell-local | Run shell on host |
| hcp-packer-registry | Register iteration in HCP Packer |
| artifice | Replace artifact with another file |

## Build Lifecycle

1. **Parse:** read all `.pkr.hcl` files and merge with `.pkrvars.hcl`
2. **Validate:** check syntax, required variables, referenced sources
3. **Provision launch:** create builder instance (EC2, Azure VM, container, etc.)
4. **Connect:** SSH or WinRM to the instance
5. **Provisioners:** run each provisioner in the order declared
6. **Shut down and snapshot:** stop the instance, capture the image
7. **Register:** register AMI, push container, etc. (builder-specific)
8. **Post-process:** run post-processors on the artifact
9. **Cleanup:** remove the builder instance, security group, key pair

## Source and Build Block Structure

Sources declare the builder and its config. Builds reference one or more sources.

```hcl
source "amazon-ebs" "base" { ... }
source "amazon-ebs" "web" { ... }

build {
  name    = "multi"
  sources = [
    "source.amazon-ebs.base",
    "source.amazon-ebs.web",
  ]
  provisioner "shell" { ... }
}
```

Sources within a build run in parallel by default. `packer build -parallel-builds=1` serializes them.

## Variables and Locals

```hcl
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "access_key" {
  type      = string
  sensitive = true
}

locals {
  build_timestamp = formatdate("YYYY-MM-DD-hh-mm", timestamp())
  common_tags = {
    Owner       = "platform-team"
    BuildDate   = local.build_timestamp
  }
}
```

Variable files (`*.pkrvars.hcl`) and auto-loaded files (`*.auto.pkrvars.hcl`) override defaults. CLI `-var-file=` and `-var=` take highest precedence.

## HCP Packer in Brief

```hcl
post-processor "hcp-packer-registry" {
  bucket_name = "ubuntu-base"
  description = "Ubuntu 22.04 base image"
  bucket_labels = {
    "os" = "ubuntu-22.04"
  }
  build_labels = {
    "build-time" = local.build_timestamp
  }
}
```

Authentication: set `HCP_CLIENT_ID` and `HCP_CLIENT_SECRET` env vars.

Terraform consumer:

```hcl
data "hcp_packer_artifact" "ubuntu" {
  bucket_name  = "ubuntu-base"
  channel_name = "production"
  platform     = "aws"
  region       = "us-east-1"
}

resource "aws_instance" "web" {
  ami = data.hcp_packer_artifact.ubuntu.external_identifier
  # ...
}
```

## Exit Codes

- 0: success
- 1: build failure
- 2+: CLI usage error or validation failure

## Legacy JSON vs HCL2

The JSON template format is deprecated. All new exam content is HCL2. If you encounter JSON templates, use `packer hcl2_upgrade template.json` to convert. Key differences:

- HCL2 uses `source` and `build` blocks; JSON used `builders` and `provisioners` arrays
- HCL2 supports `locals`, `dynamic` blocks, and richer functions
- HCL2 has `required_plugins` with version constraints

## Frequently Asked Exam Topics

- How are plugins installed? (`packer init`)
- What is the difference between `only` and `except`? (Run or skip specific builds)
- How do you pass a sensitive variable? (`PKR_VAR_foo`, `-var`, `-var-file`, `sensitive = true`)
- What does the `null` builder do? (No instance, used for provisioner-only workflows)
- What is the `breakpoint` provisioner for? (Pause build for SSH debugging)
- How do channels work in HCP Packer? (Named pointers to iterations; promote by moving channel)
