# Workspace Administration - Databricks Lakehouse Platform Administrator

## Overview

Workspace administration covers 30% of the exam - the largest domain. This covers workspace setup, account console management, workspace settings, repos, and notebook management.

**[📖 Administration Guide](https://docs.databricks.com/en/admin/index.html)** - Admin documentation hub

## Account Console vs Workspace

### Account Console

**[📖 Account Console](https://docs.databricks.com/en/admin/account-settings/index.html)** - Account-level management

- Top-level management for all workspaces
- URL: `accounts.cloud.databricks.com` (AWS) or `accounts.azuredatabricks.net` (Azure)
- Account admins manage:
  - Workspaces: Create, configure, and delete
  - Users and groups: Account-level identity management
  - Service principals: Non-human identities for automation
  - Unity Catalog metastore: Central governance
  - Billing: Usage tracking, budgets
  - Network configuration: VPC/VNet settings
  - Private endpoints and connectivity

### Workspace Console

**[📖 Workspace Settings](https://docs.databricks.com/en/admin/workspace-settings/index.html)** - Workspace-level settings

- Workspace-level management for a single workspace
- Workspace admins manage:
  - Workspace settings: Feature toggles, defaults
  - User permissions within the workspace
  - Cluster policies and compute configuration
  - SQL warehouse configuration
  - Repos and notebook settings
  - Secret scopes and access control

### Admin Roles

| Role | Scope | Capabilities |
|------|-------|-------------|
| Account admin | All workspaces | Create workspaces, manage users, billing, Unity Catalog |
| Workspace admin | Single workspace | Manage workspace settings, compute, permissions |
| Metastore admin | Unity Catalog | Manage catalogs, external locations, storage credentials |

## Workspace Setup and Configuration

### Workspace Deployment

**[📖 Create Workspaces](https://docs.databricks.com/en/admin/workspace/index.html)** - Workspace creation

**AWS:**
- Customer-managed VPC or Databricks-managed VPC
- Cross-account IAM role for Databricks to manage resources
- S3 bucket for workspace root storage (DBFS)
- Optional: PrivateLink, customer-managed keys

**Azure:**
- Managed resource group for Databricks resources
- VNet injection for custom networking
- Azure Active Directory integration
- Optional: Private endpoints, customer-managed keys

**GCP:**
- GKE-based deployment
- Customer-managed VPC or Databricks-managed
- GCS bucket for workspace storage

### Workspace Settings

**[📖 Workspace Settings Reference](https://docs.databricks.com/en/admin/workspace-settings/index.html)** - Feature toggles

Key settings to know:
- **Enable/disable features**: Repos, SQL warehouses, Jobs, MLflow, etc.
- **Default language**: Python, SQL, Scala, R for new notebooks
- **Results download**: Enable/disable downloading query results
- **Verbose audit logging**: Additional detail in audit logs
- **Web terminal**: Enable/disable web terminal access on clusters
- **DBFS browser**: Enable/disable DBFS file browser
- **Notebook table clipboard**: Enable/disable copy to clipboard
- **Personal access tokens**: Enable/disable PAT generation

## Workspace Object Management

### Notebooks

**[📖 Notebooks](https://docs.databricks.com/en/notebooks/index.html)** - Notebook management

- File types: `.py`, `.sql`, `.scala`, `.r`, `.ipynb`
- Permissions: No permissions, Can Read, Can Run, Can Edit, Can Manage
- Notebook isolation: Each notebook runs in its own process (with shared cluster)
- Export formats: Source, DBC (archive), HTML, IPython
- Revision history: Built-in version tracking
- Widgets: Parameterize notebooks with input widgets

### Repos (Git Integration)

**[📖 Repos](https://docs.databricks.com/en/repos/index.html)** - Git integration

- Connect to GitHub, GitLab, Bitbucket, Azure DevOps
- Clone, commit, push, pull, branch operations within workspace
- Repos folder structure mirrors Git repository
- Admin controls:
  - Allow/restrict which Git providers are allowed
  - Restrict to specific Git server URLs
  - Enable/disable Repos feature
  - Set Git credential storage policies
- CI/CD integration: Use repos with Databricks Asset Bundles

**[📖 Configure Git Integration](https://docs.databricks.com/en/repos/repos-setup.html)** - Git provider setup

### Folders and Workspace Organization

- **Workspace root**: `/Workspace` - shared content
- **User folders**: `/Users/<email>` - personal notebooks and files
- **Repos folders**: `/Repos/<email>` - Git-connected content
- **Shared folder**: `/Shared` - team-accessible content
- Folder permissions cascade to child objects
- Admin can set default permissions for new objects

## Databricks CLI

**[📖 Databricks CLI](https://docs.databricks.com/en/dev-tools/cli/index.html)** - Command-line administration

### Common Admin Commands

```bash
# Workspace management
databricks workspace list /Users
databricks workspace export /path/to/notebook
databricks workspace import /path/to/notebook

# Cluster management
databricks clusters list
databricks clusters create --json @cluster-config.json

# Jobs management
databricks jobs list
databricks jobs create --json @job-config.json

# Secrets management
databricks secrets create-scope --scope my-scope
databricks secrets put-secret --scope my-scope --key my-key

# Unity Catalog
databricks unity-catalog catalogs list
databricks unity-catalog schemas list --catalog-name my_catalog
```

### Databricks Asset Bundles (DABs)

**[📖 Asset Bundles](https://docs.databricks.com/en/dev-tools/bundles/index.html)** - Deployment automation

- Define workspace resources in YAML configuration
- Deploy jobs, pipelines, notebooks as code
- Environment management (dev, staging, production)
- CI/CD friendly deployment model
- `databricks bundle deploy` to deploy resources
- `databricks bundle validate` to check configuration

## REST API for Administration

**[📖 REST API Reference](https://docs.databricks.com/api/workspace/introduction)** - API documentation

### Key Admin APIs

| API | Purpose |
|-----|---------|
| `/api/2.0/workspace/*` | Notebook and folder management |
| `/api/2.0/clusters/*` | Cluster lifecycle management |
| `/api/2.0/jobs/*` | Job creation and management |
| `/api/2.0/secrets/*` | Secret scope management |
| `/api/2.1/unity-catalog/*` | Unity Catalog management |
| `/api/2.0/sql/warehouses/*` | SQL warehouse management |
| `/api/2.0/token/*` | Personal access token management |
| `/api/2.0/preview/scim/v2/*` | User and group management |

### Authentication Methods

- Personal access tokens (PAT)
- OAuth (machine-to-machine - service principals)
- Azure AD tokens (Azure only)
- OAuth user-to-machine (interactive)

## Terraform Provider

**[📖 Databricks Terraform Provider](https://registry.terraform.io/providers/databricks/databricks/latest/docs)** - Infrastructure as code

- Manage all workspace resources via Terraform
- Resources: workspaces, clusters, jobs, permissions, Unity Catalog
- Import existing resources into Terraform state
- Provider supports both account-level and workspace-level operations

## Common Exam Patterns

1. **"Account-level vs workspace-level"** - Account console for cross-workspace settings; workspace console for workspace-specific
2. **"Restrict Git providers"** - Workspace admin settings for Repos
3. **"Automate workspace deployment"** - Terraform provider or REST API
4. **"Deploy notebooks to production"** - Databricks Asset Bundles or Repos with CI/CD
5. **"Manage notebook permissions"** - ACLs at notebook or folder level
6. **"Service principal for automation"** - Account-level creation, workspace-level assignment
