# Hands-On Project: Build a CI/CD Pipeline

Build a complete continuous integration and continuous deployment pipeline using GitHub Actions.

**Estimated Time:** 4-5 hours
**Difficulty:** Intermediate
**Prerequisites:** Git, Docker basics, a cloud account (AWS, Azure, or GCP)

---

## Architecture Overview

```
GitHub Repository
  |
  v
GitHub Actions Workflow
  |
  +-- Build Stage (compile, lint, unit tests)
  |
  +-- Test Stage (integration tests, security scan)
  |
  +-- Build Docker Image --> Push to Container Registry
  |
  +-- Deploy to Staging --> Run smoke tests
  |
  +-- Manual Approval Gate
  |
  +-- Deploy to Production
```

---

## Step 1: Source Repository Setup

### Project Structure
```
my-app/
  src/                  # Application source code
  tests/                # Test files
  Dockerfile            # Container build instructions
  docker-compose.yml    # Local development
  terraform/            # Infrastructure as code
    main.tf
    variables.tf
    environments/
      staging.tfvars
      production.tfvars
  .github/
    workflows/
      ci-cd.yml         # Main pipeline
```

### Sample Dockerfile
```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY package*.json ./
EXPOSE 8080
USER node
CMD ["node", "dist/index.js"]
```

---

## Step 2: GitHub Actions Workflow

### Complete Pipeline Configuration

Create `.github/workflows/ci-cd.yml`:

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  # Stage 1: Build and Lint
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Lint
        run: npm run lint

      - name: Build
        run: npm run build

      - name: Upload build artifacts
        uses: actions/upload-artifact@v4
        with:
          name: build-output
          path: dist/

  # Stage 2: Test
  test:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Unit tests
        run: npm test -- --coverage

      - name: Upload coverage
        uses: actions/upload-artifact@v4
        with:
          name: coverage
          path: coverage/

  # Stage 3: Security Scan
  security:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
          severity: 'CRITICAL,HIGH'

  # Stage 4: Build and Push Docker Image
  docker:
    needs: [test, security]
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    outputs:
      image-tag: ${{ steps.meta.outputs.tags }}
    permissions:
      contents: read
      packages: write
    steps:
      - uses: actions/checkout@v4

      - name: Log in to Container Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=sha,prefix=
            type=raw,value=latest

      - name: Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}

  # Stage 5: Deploy to Staging
  deploy-staging:
    needs: docker
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - uses: actions/checkout@v4

      - name: Configure cloud credentials
        # Use OIDC or stored credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
          aws-region: us-east-1

      - name: Deploy to staging
        run: |
          # Example: update ECS service
          aws ecs update-service \
            --cluster staging-cluster \
            --service my-app \
            --force-new-deployment

      - name: Wait for deployment
        run: |
          aws ecs wait services-stable \
            --cluster staging-cluster \
            --services my-app

      - name: Run smoke tests
        run: |
          curl -f https://staging.example.com/health || exit 1

  # Stage 6: Manual Approval + Deploy to Production
  deploy-production:
    needs: deploy-staging
    runs-on: ubuntu-latest
    environment: production  # Requires manual approval in GitHub settings
    steps:
      - uses: actions/checkout@v4

      - name: Configure cloud credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_PROD_ROLE_ARN }}
          aws-region: us-east-1

      - name: Deploy to production
        run: |
          aws ecs update-service \
            --cluster production-cluster \
            --service my-app \
            --force-new-deployment

      - name: Wait for deployment
        run: |
          aws ecs wait services-stable \
            --cluster production-cluster \
            --services my-app

      - name: Verify production
        run: |
          curl -f https://api.example.com/health || exit 1
```

---

## Step 3: Configure Environments in GitHub

### Staging Environment
1. Go to repository Settings - Environments
2. Create "staging" environment
3. Add environment secrets (AWS_ROLE_ARN, etc.)

### Production Environment
1. Create "production" environment
2. Enable "Required reviewers" and add approvers
3. Optionally restrict to the `main` branch
4. Add production-specific secrets

---

## Step 4: Infrastructure with Terraform

### Basic ECS Infrastructure

```hcl
# terraform/main.tf
provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "ci-cd-project/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-cluster"
}

resource "aws_ecs_service" "app" {
  name            = "my-app"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [aws_security_group.app.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "app"
    container_port   = 8080
  }
}
```

### Apply Infrastructure

```bash
# Initialize Terraform
cd terraform
terraform init

# Plan for staging
terraform plan -var-file=environments/staging.tfvars

# Apply
terraform apply -var-file=environments/staging.tfvars
```

---

## Step 5: Alternative Deployment Targets

### Kubernetes (EKS / AKS / GKE)

Replace the ECS deploy step with:
```yaml
- name: Deploy to Kubernetes
  run: |
    kubectl set image deployment/my-app \
      app=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }} \
      --namespace ${{ env.NAMESPACE }}
    kubectl rollout status deployment/my-app \
      --namespace ${{ env.NAMESPACE }} --timeout=300s
```

### Azure Container Apps

```yaml
- name: Deploy to Azure Container Apps
  uses: azure/container-apps-deploy-action@v1
  with:
    imageToDeploy: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
    containerAppName: my-app
    resourceGroup: myRG
```

### GCP Cloud Run

```yaml
- name: Deploy to Cloud Run
  run: |
    gcloud run deploy my-app \
      --image ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }} \
      --region us-central1 \
      --platform managed
```

---

## Step 6: Rollback Strategy

### Automatic Rollback on Failed Health Check

```yaml
- name: Deploy with rollback
  run: |
    aws ecs update-service --cluster production-cluster \
      --service my-app --force-new-deployment

    if ! aws ecs wait services-stable --cluster production-cluster --services my-app; then
      echo "Deployment failed, rolling back..."
      aws ecs update-service --cluster production-cluster \
        --service my-app --task-definition $PREVIOUS_TASK_DEF
      exit 1
    fi
```

---

## Verification Checklist

- [ ] Push to a feature branch triggers build and test only (no deploy)
- [ ] Merge to main triggers the full pipeline
- [ ] Docker image is built and pushed to the registry
- [ ] Staging deployment succeeds and smoke tests pass
- [ ] Production deployment requires manual approval
- [ ] Rollback works when deployment fails
- [ ] Secrets are stored in GitHub environment settings (not in code)

---

## Cleanup

1. Delete cloud resources (ECS cluster, load balancer, VPC)
2. Remove Terraform state bucket
3. Delete container images from the registry
4. Remove GitHub environment configurations

---

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Build Best Practices](https://docs.docker.com/build/building/best-practices/)
- [AWS ECS Developer Guide](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
