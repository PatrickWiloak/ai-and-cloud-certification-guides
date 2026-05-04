---
last-updated: 2026-05-03
---

# SSH basics

> **5-minute read.** SSH lets you log in to a remote server and run commands as if you were sitting in front of it. Cloud work assumes SSH knowledge.

## What SSH is

SSH (Secure Shell) opens an encrypted connection from your laptop to a remote server. After authentication, you get a shell on the remote machine. Anything you type runs on the remote, not your laptop.

```bash
ssh username@server-ip
```

If the server is reachable, your password is correct, and the host key checks pass, you get a shell prompt that looks like:

```
ubuntu@ip-10-0-1-23:~$
```

You're now on the remote server.

## Two ways to authenticate

### Password (don't do this in production)
Type a password each time. Vulnerable to brute force, phishing, password reuse. Cloud providers usually disable password SSH on new VMs.

### Key-based (the standard)
You generate a key pair on your laptop:

```bash
ssh-keygen -t ed25519
```

This creates two files:
- `~/.ssh/id_ed25519` - your **private key**. Never share. Never commit. Treat like a password.
- `~/.ssh/id_ed25519.pub` - your **public key**. Safe to share; goes on the server.

You put the public key in the server's `~/.ssh/authorized_keys` file (cloud providers usually do this for you when you launch a VM and pick a key pair).

When you SSH, the server challenges you to prove you have the matching private key. Your client signs a nonce with the private key; the server verifies with the public key. No password ever crosses the wire.

## The host key prompt

The first time you connect to a server, you see:

```
The authenticity of host '203.0.113.5 (203.0.113.5)' can't be established.
ED25519 key fingerprint is SHA256:abcd1234...
Are you sure you want to continue connecting (yes/no)?
```

This is **the server proving it's the server you think it is**. Type `yes` to accept and remember this fingerprint. The host key is saved in `~/.ssh/known_hosts`.

If you connect later and the host key has *changed*, SSH refuses to connect with a scary warning. That's a feature - it means either someone's intercepting your connection (man-in-the-middle), or the server was rebuilt and you need to remove the old entry from `known_hosts`.

## Common gotchas

### "Permission denied (publickey)"
Your private key isn't being offered, or the public key isn't on the server. Check:
- Is your private key at `~/.ssh/id_*`?
- Did you add it with `ssh-add`?
- Is the public key in the right `authorized_keys` on the server (correct user's home directory)?

### Wrong username
Cloud VMs have provider-specific default usernames:
- AWS Ubuntu AMI: `ubuntu`
- AWS Amazon Linux: `ec2-user`
- Azure: depends on the image, often `azureuser`
- GCP: your Google username (or whatever you specified)

If you `ssh user@server` with the wrong user, you'll get permission denied even with a valid key.

### Permissions on key files
SSH refuses to use a private key that's group- or world-readable:

```bash
chmod 600 ~/.ssh/id_ed25519
chmod 700 ~/.ssh
```

### `~/.ssh/config` for shortcuts
Instead of `ssh -i ~/.ssh/work-key.pem ec2-user@1.2.3.4 -p 2222`, set up `~/.ssh/config`:

```
Host work-bastion
    HostName 1.2.3.4
    User ec2-user
    IdentityFile ~/.ssh/work-key.pem
    Port 2222
```

Then just `ssh work-bastion`.

## Things SSH does that you'll meet later

- **Port forwarding (`-L`, `-R`, `-D`)**: tunnel a local port to a remote service through the SSH connection. The basis for "pivoting" in pentesting and for accessing private databases through a bastion host.
- **scp / sftp**: copy files over SSH (`scp file.txt user@server:/path/`).
- **rsync over SSH**: efficient incremental file copy.
- **Bastion / jump hosts**: `ssh -J bastion target` lets you hop through a bastion to reach a server without a public IP.

## What to look at next

- **[Terminal basics](./terminal-basics.md)** - the shell you land in via SSH
- **[Git basics](./git-basics.md)** - SSH keys are also how you authenticate to GitHub
- **[What is a server?](./what-is-a-server.md)** - what you're connected to once you SSH in
