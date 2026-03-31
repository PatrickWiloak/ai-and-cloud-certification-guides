# Docker CLI Cheat Sheet

Quick reference for Docker commands used in container management, development workflows, and certification preparation.

**Official Documentation:** https://docs.docker.com/reference/cli/docker/

---

## Table of Contents

- [Container Lifecycle](#container-lifecycle)
- [Image Management](#image-management)
- [Network Commands](#network-commands)
- [Volume Management](#volume-management)
- [Docker Compose Commands](#docker-compose-commands)
- [Dockerfile Reference Quick Guide](#dockerfile-reference-quick-guide)
- [Debugging](#debugging)
- [Multi-Stage Build Patterns](#multi-stage-build-patterns)
- [Useful Flags and Options](#useful-flags-and-options)

---

## Container Lifecycle

```bash
# Run a container (pull image if needed)
docker run nginx

# Run in detached mode (background)
docker run -d nginx

# Run with a name
docker run -d --name my-nginx nginx

# Run with port mapping (host:container)
docker run -d -p 8080:80 nginx

# Run with environment variables
docker run -d -e MYSQL_ROOT_PASSWORD=secret mysql

# Run with a volume mount
docker run -d -v /host/path:/container/path nginx

# Run with a bind mount (explicit syntax)
docker run -d --mount type=bind,source=/host/path,target=/container/path nginx

# Run with a named volume
docker run -d -v my-volume:/data postgres

# Run interactively with a terminal
docker run -it ubuntu /bin/bash

# Run and remove container on exit
docker run --rm -it alpine sh

# Run with resource limits
docker run -d --memory=512m --cpus=1.5 nginx

# Run with restart policy
docker run -d --restart=unless-stopped nginx

# Run with a specific network
docker run -d --network my-network nginx

# Run with a hostname
docker run -d --hostname web-server nginx

# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# List container IDs only
docker ps -q

# Start a stopped container
docker start container-name

# Stop a running container
docker stop container-name

# Stop with a timeout (seconds)
docker stop -t 30 container-name

# Restart a container
docker restart container-name

# Pause a container
docker pause container-name

# Unpause a container
docker unpause container-name

# Remove a stopped container
docker rm container-name

# Force remove a running container
docker rm -f container-name

# Remove all stopped containers
docker container prune

# Remove all stopped containers (force)
docker container prune -f

# Execute a command in a running container
docker exec container-name ls /app

# Get an interactive shell in a running container
docker exec -it container-name /bin/bash

# Execute as a specific user
docker exec -u root -it container-name /bin/sh

# Rename a container
docker rename old-name new-name

# Wait for a container to stop
docker wait container-name

# Update container configuration
docker update --memory=1g --cpus=2 container-name

# Copy files to/from a container
docker cp local-file.txt container-name:/path/
docker cp container-name:/path/file.txt ./local-file.txt

# Export container filesystem as tar
docker export container-name > container.tar

# Create an image from a container
docker commit container-name my-image:tag
```

---

## Image Management

```bash
# List local images
docker images

# List all images (including intermediate)
docker images -a

# Pull an image from a registry
docker pull nginx

# Pull a specific tag
docker pull nginx:1.25-alpine

# Pull from a specific registry
docker pull registry.example.com/my-image:latest

# Build an image from a Dockerfile
docker build -t my-app:1.0 .

# Build with a specific Dockerfile
docker build -t my-app:1.0 -f Dockerfile.prod .

# Build with build arguments
docker build --build-arg VERSION=1.0 -t my-app .

# Build without cache
docker build --no-cache -t my-app .

# Build with a target stage (multi-stage)
docker build --target builder -t my-app-builder .

# Tag an image
docker tag my-app:1.0 registry.example.com/my-app:1.0

# Push an image to a registry
docker push registry.example.com/my-app:1.0

# Remove an image
docker rmi nginx

# Force remove an image
docker rmi -f nginx

# Remove unused images
docker image prune

# Remove all unused images (not just dangling)
docker image prune -a

# Show image history (layers)
docker history nginx

# Inspect image details
docker inspect nginx

# Save image to a tar file
docker save -o nginx.tar nginx:latest

# Load image from a tar file
docker load -i nginx.tar

# Search Docker Hub
docker search nginx

# View image digest
docker images --digests

# Build with BuildKit (recommended)
DOCKER_BUILDKIT=1 docker build -t my-app .
```

---

## Network Commands

```bash
# List networks
docker network ls

# Create a bridge network
docker network create my-network

# Create a network with a specific driver
docker network create --driver overlay my-overlay

# Create a network with a subnet
docker network create --subnet=172.20.0.0/16 my-network

# Inspect a network
docker network inspect my-network

# Connect a running container to a network
docker network connect my-network container-name

# Connect with a specific IP
docker network connect --ip 172.20.0.10 my-network container-name

# Disconnect a container from a network
docker network disconnect my-network container-name

# Remove a network
docker network rm my-network

# Remove all unused networks
docker network prune

# Default network types:
# bridge  - default for standalone containers
# host    - share host networking (no isolation)
# none    - no networking
# overlay - multi-host networking (Swarm)
# macvlan - assign MAC address to container
```

---

## Volume Management

```bash
# List volumes
docker volume ls

# Create a named volume
docker volume create my-volume

# Inspect a volume
docker volume inspect my-volume

# Remove a volume
docker volume rm my-volume

# Remove all unused volumes
docker volume prune

# Remove all unused volumes (force)
docker volume prune -f

# Use a volume in a container
docker run -d -v my-volume:/data nginx

# Use a read-only volume
docker run -d -v my-volume:/data:ro nginx

# Use tmpfs mount (in-memory)
docker run -d --tmpfs /tmp nginx

# Explicit mount syntax
docker run -d \
  --mount type=volume,source=my-volume,target=/data \
  nginx

# Bind mount with explicit syntax
docker run -d \
  --mount type=bind,source=/host/path,target=/container/path \
  nginx

# Backup a volume
docker run --rm -v my-volume:/data -v $(pwd):/backup alpine \
  tar czf /backup/volume-backup.tar.gz -C /data .

# Restore a volume
docker run --rm -v my-volume:/data -v $(pwd):/backup alpine \
  tar xzf /backup/volume-backup.tar.gz -C /data
```

---

## Docker Compose Commands

```bash
# Start services defined in docker-compose.yml
docker compose up

# Start in detached mode
docker compose up -d

# Start specific services
docker compose up -d web db

# Build and start
docker compose up -d --build

# Stop services
docker compose down

# Stop and remove volumes
docker compose down -v

# Stop and remove images
docker compose down --rmi all

# List running services
docker compose ps

# View service logs
docker compose logs

# Follow logs for a specific service
docker compose logs -f web

# Execute a command in a service container
docker compose exec web /bin/bash

# Run a one-off command
docker compose run --rm web python manage.py migrate

# Scale a service
docker compose up -d --scale web=3

# Build images without starting
docker compose build

# Pull images
docker compose pull

# Restart services
docker compose restart

# View service configuration
docker compose config

# Pause/unpause services
docker compose pause
docker compose unpause

# List containers for services
docker compose top

# Use a specific compose file
docker compose -f docker-compose.prod.yml up -d

# Use multiple compose files (merged)
docker compose -f docker-compose.yml -f docker-compose.override.yml up -d

# Use a specific project name
docker compose -p my-project up -d

# View resource usage
docker compose stats
```

---

## Dockerfile Reference Quick Guide

```dockerfile
# Base image
FROM ubuntu:22.04

# Set working directory
WORKDIR /app

# Copy files
COPY . .
COPY package.json package-lock.json ./

# Add files (supports URLs and auto-extraction of archives)
ADD https://example.com/file.tar.gz /tmp/

# Run commands during build
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Build-time arguments
ARG VERSION=1.0
ARG BUILD_DATE

# Expose ports (documentation only)
EXPOSE 3000

# Set the default command
CMD ["node", "server.js"]

# Set the entrypoint
ENTRYPOINT ["python"]
CMD ["app.py"]

# Add metadata labels
LABEL maintainer="team@example.com"
LABEL version="1.0"

# Create a mount point
VOLUME ["/data"]

# Set the user
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# Shell form vs exec form
# Shell form: RUN echo "hello"         (runs in /bin/sh -c)
# Exec form:  RUN ["echo", "hello"]    (runs directly)

# .dockerignore file (in build context root)
# node_modules
# .git
# *.md
# .env
```

---

## Debugging

```bash
# View container logs
docker logs container-name

# Follow logs in real time
docker logs -f container-name

# View last N lines
docker logs --tail=100 container-name

# View logs since a time
docker logs --since=1h container-name

# View logs with timestamps
docker logs -t container-name

# Inspect container details
docker inspect container-name

# Inspect specific field
docker inspect -f '{{.NetworkSettings.IPAddress}}' container-name
docker inspect -f '{{.State.ExitCode}}' container-name

# View real-time resource stats
docker stats

# View stats for specific containers
docker stats container1 container2

# View stats without streaming (snapshot)
docker stats --no-stream

# View running processes in a container
docker top container-name

# View filesystem changes in a container
docker diff container-name

# View port mappings
docker port container-name

# View container events
docker events

# Filter events
docker events --filter container=my-container
docker events --filter event=start
docker events --since='2024-01-01'

# Check Docker system info
docker info

# View disk usage
docker system df

# View detailed disk usage
docker system df -v

# Full system cleanup (use with caution)
docker system prune

# Full cleanup including volumes
docker system prune -a --volumes
```

---

## Multi-Stage Build Patterns

### Basic Multi-Stage Build

```dockerfile
# Build stage
FROM node:20 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
CMD ["node", "dist/server.js"]
```

### Go Application

```dockerfile
FROM golang:1.22 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/main .

FROM scratch
COPY --from=builder /app/main /main
ENTRYPOINT ["/main"]
```

### Python Application

```dockerfile
FROM python:3.12-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

FROM python:3.12-slim
WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY . .
ENV PATH=/root/.local/bin:$PATH
EXPOSE 8000
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:8000"]
```

### Copy from External Image

```dockerfile
FROM nginx:alpine
COPY --from=minio/mc /usr/bin/mc /usr/bin/mc
```

---

## Useful Flags and Options

### Docker Run Flags

```bash
# Common flags summary
-d              # Detached mode (background)
-it             # Interactive with terminal
--rm            # Remove container on exit
--name          # Assign a name
-p 8080:80      # Port mapping (host:container)
-P              # Publish all exposed ports to random ports
-v              # Volume mount
-e              # Environment variable
--env-file      # Environment file
-w /app         # Working directory
--network       # Connect to a network
--restart       # Restart policy (no, on-failure, always, unless-stopped)
--memory        # Memory limit (e.g., 512m, 1g)
--cpus          # CPU limit (e.g., 1.5)
--pid=host      # Share host PID namespace
--privileged    # Extended privileges (use with caution)
--read-only     # Read-only root filesystem
--user          # Username or UID
--entrypoint    # Override entrypoint
--log-driver    # Logging driver
--health-cmd    # Health check command
```

### Docker Build Flags

```bash
--tag, -t       # Name and tag (name:tag)
--file, -f      # Dockerfile path
--build-arg     # Build-time variable
--no-cache      # Do not use cache
--target        # Target build stage
--platform      # Target platform (linux/amd64, linux/arm64)
--pull          # Always pull newer base image
--quiet, -q     # Suppress build output
--progress      # Progress output type (auto, plain, tty)
--cache-from    # External cache source
--secret        # Secret for build (BuildKit)
--ssh           # SSH agent socket (BuildKit)
```

---

## Resources

- Docker CLI Reference: https://docs.docker.com/reference/cli/docker/
- Dockerfile Reference: https://docs.docker.com/reference/dockerfile/
- Docker Compose Reference: https://docs.docker.com/compose/compose-file/
- Docker Hub: https://hub.docker.com/
- Best Practices for Dockerfiles: https://docs.docker.com/build/building/best-practices/
