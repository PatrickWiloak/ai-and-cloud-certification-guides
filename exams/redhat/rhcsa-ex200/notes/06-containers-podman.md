# 06 - Containers with Podman

RHEL ships with **Podman** (not Docker). Podman is daemonless, supports rootless containers, and works as a drop-in for most Docker commands.

## Install and prepare

```bash
dnf install -y container-tools                  # meta-package
podman --version
```

For rootless (recommended for the exam where appropriate):

```bash
loginctl enable-linger username                 # let user services run when user not logged in
```

---

## Pull and run

```bash
# Pull image
podman pull registry.access.redhat.com/ubi9/ubi:latest
podman pull docker.io/nginx:latest

# Run interactively
podman run -it --rm registry.access.redhat.com/ubi9/ubi /bin/bash

# Run detached, name it, expose a port
podman run -d --name web -p 8080:80 docker.io/nginx
```

`-p 8080:80` maps host port 8080 to container port 80.

## List, inspect, logs

```bash
podman ps                            # running
podman ps -a                         # all
podman inspect web
podman logs web
podman logs -f web                   # follow
```

## Exec / attach / stop / remove

```bash
podman exec -it web /bin/bash
podman stop web
podman start web
podman restart web
podman rm web
podman rm -f web                     # force (kill if running)
```

## Volumes (persistent storage)

```bash
# Bind mount a host directory
podman run -d --name dbs \
    -v /srv/dbdata:/var/lib/postgresql/data:Z \
    -e POSTGRES_PASSWORD=secret \
    docker.io/postgres:16

# `:Z` sets a private SELinux label (required for SELinux-enforcing systems)
# `:z` sets a shared label (multiple containers share access)

# Or use a named volume managed by Podman
podman volume create myvol
podman run -d -v myvol:/data --name app docker.io/myapp
podman volume ls
podman volume inspect myvol
podman volume rm myvol
```

The `:Z` (or `:z`) suffix is critical with SELinux. Without it, the container will get permission denied on the bind mount.

---

## Networking

### Default

By default Podman uses a bridge network. Each container gets an IP. Map host ports with `-p`.

### List networks

```bash
podman network ls
podman network inspect podman
```

### Create a custom network

```bash
podman network create mynet
podman run -d --name api --network mynet docker.io/myapi
podman run -d --name web --network mynet -p 8080:80 docker.io/mywebapp
# web can reach api by name "api" on mynet
```

### Pod (group of containers sharing namespace - like K8s pod)

```bash
podman pod create --name mypod -p 8080:80
podman run -d --pod mypod --name web docker.io/nginx
podman run -d --pod mypod --name redis docker.io/redis
# web and redis share the network namespace (localhost)
```

---

## Build images

`Containerfile` (or `Dockerfile`):

```dockerfile
FROM registry.access.redhat.com/ubi9/ubi:latest
RUN dnf install -y python3 && dnf clean all
COPY app.py /app/app.py
WORKDIR /app
EXPOSE 8000
CMD ["python3", "app.py"]
```

Build:

```bash
podman build -t myapp:1.0 .
podman images
```

## Push and tag

```bash
podman tag myapp:1.0 registry.example.com/myapp:1.0
podman login registry.example.com
podman push registry.example.com/myapp:1.0
```

---

## Persistent containers (run at boot)

### Method 1: Generate a systemd unit file

For a container you have already created and tested:

```bash
# Generate a unit that creates the container fresh on each start (recommended)
podman generate systemd --new --name web --files \
    -f --restart-policy always

# This produces container-web.service in the current directory.
```

Move and enable as a user service:

```bash
mkdir -p ~/.config/systemd/user
mv container-web.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now container-web.service

# Check
systemctl --user status container-web.service
```

For root-mode systemd:

```bash
mv container-web.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now container-web
```

### Method 2: Quadlet (modern, declarative)

Quadlet is the new way (RHEL 9.4+) - place `.container` files instead of generating units.

`~/.config/containers/systemd/web.container`:

```ini
[Unit]
Description=Web service

[Container]
Image=docker.io/nginx:latest
PublishPort=8080:80
Volume=/srv/www:/usr/share/nginx/html:Z

[Service]
Restart=always

[Install]
WantedBy=default.target
```

Then:

```bash
systemctl --user daemon-reload
systemctl --user start web
```

systemd auto-discovers `.container` files and generates units from them.

---

## Rootless mode

Run containers as a regular user without sudo:

```bash
podman run -d --name web -p 8080:80 docker.io/nginx
```

Note: rootless can't bind to ports below 1024 unless you set `net.ipv4.ip_unprivileged_port_start=80` in `/etc/sysctl.d/`. Or just map to a higher host port (`-p 8080:80`).

Rootless storage lives under `~/.local/share/containers/`.

`loginctl enable-linger username` lets the user's containers run after logout and across reboot if you've enabled their systemd user services.

---

## Common exam tasks

### Pull an image and run a container with port mapping and a volume

```bash
podman pull registry.access.redhat.com/ubi9/ubi:latest
podman pull docker.io/nginx

mkdir -p /srv/www
echo '<h1>Hello</h1>' > /srv/www/index.html

podman run -d --name web \
    -p 8080:80 \
    -v /srv/www:/usr/share/nginx/html:Z \
    docker.io/nginx

curl http://localhost:8080
```

### Configure the container to start at boot via systemd

```bash
podman generate systemd --new --name web --files --restart-policy always
mv container-web.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now container-web.service
systemctl status container-web.service
```

### Run as a regular user (rootless) and survive reboot

```bash
# As that user:
loginctl enable-linger
podman run -d --name web -p 8080:80 docker.io/nginx

mkdir -p ~/.config/systemd/user
podman generate systemd --new --name web > ~/.config/systemd/user/container-web.service
systemctl --user daemon-reload
systemctl --user enable --now container-web.service
```

### Build an image from a Containerfile

```bash
cat > Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi9/ubi:latest
RUN dnf install -y httpd && dnf clean all
COPY index.html /var/www/html/
EXPOSE 80
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EOF

echo '<h1>Built locally</h1>' > index.html

podman build -t mywebapp:1.0 .
podman run -d --name mywebapp -p 8080:80 mywebapp:1.0
```

### Start a container, then convert to a systemd-managed service

```bash
podman run -d --name mydb -e POSTGRES_PASSWORD=secret docker.io/postgres:16
podman generate systemd --new --name mydb --files --restart-policy always
mv container-mydb.service /etc/systemd/system/
systemctl daemon-reload
podman rm -f mydb                         # remove manual container; systemd will recreate
systemctl enable --now container-mydb.service
```

---

## Useful flags

| Flag | Meaning |
|---|---|
| `-d` | detached |
| `-it` | interactive + TTY |
| `--name X` | name the container |
| `-p HOST:CONTAINER` | port mapping |
| `-v HOST:CONTAINER:Z` | bind mount with private SELinux label |
| `-v VOLNAME:CONTAINER` | named volume |
| `-e VAR=value` | environment variable |
| `--rm` | remove on exit |
| `--restart always` | restart policy (with systemd, prefer the unit) |
| `--network mynet` | join a custom network |
| `--pod mypod` | join a pod |
| `--user UID:GID` | run as specific user inside container |

---

## Verification

After container work:

- `podman ps` shows the container running
- `curl http://localhost:8080` (or whichever port) returns expected content
- `systemctl status container-X` (or `--user`) shows `active (running)` and `enabled`
- After `reboot`, the container still runs
