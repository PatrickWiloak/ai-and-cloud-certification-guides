---
last-updated: 2026-05-03
---

# Package managers

> **5-minute read.** A package manager installs software, tracks versions, and removes it cleanly. Every operating system and language has one. They all do the same things with different commands.

## What a package manager does

You want to install `nginx`. Without a package manager, you'd:
1. Find the source code
2. Download the right version
3. Install dependencies (libssl, libpcre, ...) one at a time
4. Compile
5. Track where everything went so you can uninstall later

A package manager does all of that with one command:

```bash
apt install nginx
```

It also keeps a database of what's installed so you can list, update, or remove cleanly.

## The big OS package managers

| Manager | OS | Install command |
|---|---|---|
| **apt** | Debian, Ubuntu | `apt install <pkg>` |
| **dnf / yum** | Fedora, RHEL, Amazon Linux | `dnf install <pkg>` |
| **brew** | macOS (also Linux) | `brew install <pkg>` |
| **winget / Chocolatey** | Windows | `winget install <pkg>` |
| **pacman** | Arch Linux | `pacman -S <pkg>` |
| **apk** | Alpine | `apk add <pkg>` |
| **zypper** | openSUSE | `zypper install <pkg>` |

They all support the same operations:

```bash
# Refresh the package list
apt update          # or: dnf check-update, brew update

# Install
apt install nginx

# Upgrade everything
apt upgrade

# Search
apt search nginx

# Show package info
apt show nginx

# Remove
apt remove nginx

# List installed
apt list --installed
```

The commands change but the concepts don't. If you can use one, you can use any of them with the help of `man <command>`.

## Language package managers

Programming languages have their own:

| Manager | Language | Files |
|---|---|---|
| **npm / yarn / pnpm / bun** | JavaScript / TypeScript | `package.json`, `package-lock.json` |
| **pip / poetry / uv** | Python | `requirements.txt`, `pyproject.toml` |
| **cargo** | Rust | `Cargo.toml`, `Cargo.lock` |
| **go mod** | Go | `go.mod`, `go.sum` |
| **maven / gradle** | Java | `pom.xml`, `build.gradle` |
| **gem / bundler** | Ruby | `Gemfile`, `Gemfile.lock` |
| **composer** | PHP | `composer.json`, `composer.lock` |

These install **libraries / frameworks** (not OS-level software). They typically install to a project-local directory (`node_modules/`, `venv/`, `target/`) so different projects can have different versions.

```bash
# Node.js example
npm install lodash       # adds to package.json + downloads
npm install              # install everything from package.json
npm uninstall lodash
```

## Lock files matter

Every modern package manager creates a **lock file** that pins exact versions of every dependency (and dependency-of-dependency). This is what makes a build reproducible across machines.

- `package.json` says "react ^18.0.0" (any 18.x.x)
- `package-lock.json` says "react 18.2.0, with these exact transitive dependencies and hashes"

**Commit lock files to git.** Without them, two developers running `npm install` can get subtly different builds, and you'll spend a day debugging "works on my machine."

## Container image registries are package managers too

Conceptually:

```bash
docker pull nginx:1.27.0
```

is the same as installing a package, except the unit is a whole container image (OS + binaries + config) instead of a single binary. Docker Hub, GitHub Container Registry, AWS ECR, Azure Container Registry, GCP Artifact Registry all serve this role.

## Common gotchas

### "Why do I need sudo?"
OS package managers install system-wide, so they need root. Language package managers install to project-local directories (no sudo needed). If you find yourself running `sudo pip install`, you're probably doing it wrong - use a virtual environment instead.

### Dependency hell
Two libraries depend on different incompatible versions of a third library. Lock files mitigate; container images sidestep entirely; sometimes you just have to upgrade or fork.

### Out-of-date package lists
`apt install nginx` might install a 2-year-old version because Ubuntu's stable repo is conservative. For latest, you sometimes use a third-party PPA, brew, or download the binary directly.

### Removed packages leaving config behind
`apt remove` deletes the binary but leaves config files. Use `apt purge` to delete config too.

## What to look at next

- **[Terminal basics](./terminal-basics.md)** - where you run package commands
- **[Containers vs VMs](../concepts/containers-vs-vms.md)** - why container images are the modern packaging unit
- **[CI/CD explained](../concepts/cicd-explained.md)** - how package installs are automated in pipelines
