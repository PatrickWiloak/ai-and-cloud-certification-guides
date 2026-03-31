# Security

**[📖 MongoDB Security](https://www.mongodb.com/docs/manual/security/)** - Complete security documentation
**[📖 Security Checklist](https://www.mongodb.com/docs/manual/administration/security-checklist/)** - Production security checklist

## Authentication

**[📖 Authentication](https://www.mongodb.com/docs/manual/core/authentication/)** - Authentication mechanisms

### SCRAM Authentication (Default)

**SCRAM-SHA-256** (default since MongoDB 4.0):
- Salted Challenge Response Authentication Mechanism
- Password never sent over the wire
- Uses SHA-256 hash function
- Recommended for most deployments

**Enabling Authentication:**
```yaml
# mongod.conf
security:
  authorization: enabled
```

**Creating Users:**
```javascript
// Connect without auth, create admin user
use admin
db.createUser({
  user: "adminUser",
  pwd: "securePassword",
  roles: [
    { role: "userAdminAnyDatabase", db: "admin" },
    { role: "readWriteAnyDatabase", db: "admin" },
    { role: "clusterAdmin", db: "admin" }
  ]
});

// Create application user
use mydb
db.createUser({
  user: "appUser",
  pwd: "appPassword",
  roles: [
    { role: "readWrite", db: "mydb" }
  ]
});
```

**User Management Commands:**
```javascript
// List users
db.getUsers();

// Update user password
db.changeUserPassword("appUser", "newPassword");

// Grant additional roles
db.grantRolesToUser("appUser", [{ role: "dbAdmin", db: "mydb" }]);

// Revoke roles
db.revokeRolesFromUser("appUser", [{ role: "dbAdmin", db: "mydb" }]);

// Drop user
db.dropUser("appUser");
```

### x.509 Certificate Authentication

**[📖 x.509 Authentication](https://www.mongodb.com/docs/manual/core/security-x.509/)** - Certificate authentication guide

```yaml
# mongod.conf for x.509
security:
  authorization: enabled
net:
  tls:
    mode: requireTLS
    certificateKeyFile: /etc/ssl/mongodb.pem
    CAFile: /etc/ssl/ca.pem
    clusterFile: /etc/ssl/mongodb-cluster.pem
security:
  clusterAuthMode: x509
```

**Key Points:**
- Client certificates must have a subject (DN) that differs from server
- Subject used as the username in MongoDB
- Certificate must be signed by the same CA
- Used for inter-member authentication in replica sets

### LDAP Authentication (Enterprise)

```yaml
# mongod.conf for LDAP
security:
  authorization: enabled
  ldap:
    servers: "ldap.example.com"
    bind:
      method: simple
      queryUser: "cn=admin,dc=example,dc=com"
      queryPassword: "password"
    userToDNMapping: '[{ match: "(.+)", substitution: "uid={0},ou=users,dc=example,dc=com" }]'
    authz:
      queryTemplate: '{USER}?memberOf?base'
```

### Kerberos Authentication (Enterprise)

```yaml
# mongod.conf for Kerberos
security:
  authorization: enabled
setParameter:
  authenticationMechanisms: GSSAPI
```

### Internal/Cluster Authentication

**Keyfile Authentication:**
```yaml
security:
  keyFile: /etc/mongodb/keyfile
```
- Used for inter-member authentication in replica sets and sharded clusters
- File must be readable only by mongod user (chmod 400)
- All members must use the same keyfile
- Keyfile implicitly enables authorization

**x.509 Cluster Authentication:**
```yaml
security:
  clusterAuthMode: x509
net:
  tls:
    clusterFile: /etc/ssl/mongodb-cluster.pem
```

## Authorization (Role-Based Access Control)

**[📖 Authorization](https://www.mongodb.com/docs/manual/core/authorization/)** - RBAC documentation

### Built-in Roles

**Database Roles:**

| Role | Permissions |
|------|------------|
| `read` | Read all non-system collections |
| `readWrite` | Read and write all non-system collections |
| `dbAdmin` | Schema management, indexing, statistics |
| `dbOwner` | readWrite + dbAdmin + userAdmin |
| `userAdmin` | Create/modify users and roles |

**Cluster Roles:**

| Role | Permissions |
|------|------------|
| `clusterAdmin` | Cluster management (addShard, resync, etc.) |
| `clusterManager` | Monitoring and management |
| `clusterMonitor` | Read-only cluster monitoring |
| `hostManager` | Monitor and manage servers |

**All-Database Roles:**

| Role | Permissions |
|------|------------|
| `readAnyDatabase` | Read on all databases |
| `readWriteAnyDatabase` | Read/write on all databases |
| `userAdminAnyDatabase` | User admin on all databases |
| `dbAdminAnyDatabase` | dbAdmin on all databases |

**Superuser Roles:**

| Role | Permissions |
|------|------------|
| `root` | All permissions (superuser) |

**Backup/Restore Roles:**

| Role | Permissions |
|------|------------|
| `backup` | Backup-related operations |
| `restore` | Restore-related operations |

### Custom Roles

```javascript
use admin
db.createRole({
  role: "analyticsRole",
  privileges: [
    {
      resource: { db: "analytics", collection: "" },
      actions: ["find", "aggregate"]
    },
    {
      resource: { db: "analytics", collection: "reports" },
      actions: ["find", "insert", "update"]
    }
  ],
  roles: [
    { role: "read", db: "shared" }
  ]
});

// Assign custom role to user
db.createUser({
  user: "analyst",
  pwd: "password",
  roles: [{ role: "analyticsRole", db: "admin" }]
});
```

**Privilege Actions (common):**

| Action | Description |
|--------|-------------|
| `find` | Query documents |
| `insert` | Insert documents |
| `update` | Update documents |
| `remove` | Delete documents |
| `createCollection` | Create collections |
| `dropCollection` | Drop collections |
| `createIndex` | Create indexes |
| `dropIndex` | Drop indexes |
| `collStats` | Collection statistics |
| `dbStats` | Database statistics |
| `serverStatus` | Server status |
| `killOp` | Kill operations |

## TLS/SSL Encryption

**[📖 TLS Configuration](https://www.mongodb.com/docs/manual/tutorial/configure-ssl/)** - TLS setup guide

### Server Configuration

```yaml
net:
  tls:
    mode: requireTLS
    certificateKeyFile: /etc/ssl/mongodb.pem
    CAFile: /etc/ssl/ca.pem
    allowConnectionsWithoutCertificates: false
    allowInvalidHostnames: false
```

**TLS Modes:**

| Mode | Description |
|------|-------------|
| `disabled` | No TLS |
| `allowTLS` | Accept both TLS and non-TLS connections |
| `preferTLS` | Prefer TLS, accept non-TLS |
| `requireTLS` | Require TLS for all connections |

### Client Connection with TLS

```bash
mongosh --tls \
  --tlsCertificateKeyFile /etc/ssl/client.pem \
  --tlsCAFile /etc/ssl/ca.pem \
  --host mongo1:27017
```

### Certificate Requirements
- Server certificate must include the hostname in SAN or CN
- CA certificate must be trusted by all participants
- Certificate key file combines private key and certificate
- For replica sets, all members need valid certificates

## Audit Logging (Enterprise)

**[📖 Auditing](https://www.mongodb.com/docs/manual/core/auditing/)** - Audit log documentation

```yaml
auditLog:
  destination: file
  format: JSON
  path: /var/log/mongodb/audit.json
  filter: '{ atype: { $in: ["authenticate", "createUser", "dropUser", "createCollection", "dropCollection"] } }'
```

**Audit Events:**
- Authentication attempts (success and failure)
- User creation, modification, and deletion
- Role creation and modification
- Collection creation and deletion
- Database operations (configurable)

## Encryption at Rest

**[📖 Encryption at Rest](https://www.mongodb.com/docs/manual/core/security-encryption-at-rest/)** - Encryption documentation

### Options

**Enterprise - Native Encryption:**
```yaml
security:
  enableEncryption: true
  encryptionKeyFile: /etc/mongodb/encryption-key
  # Or use KMIP:
  # encryptionCipherMode: AES256-CBC
  # kmip:
  #   serverName: kmip.example.com
  #   port: 5696
```

**Community Edition Options:**
- Filesystem-level encryption (dm-crypt, LUKS)
- Cloud provider volume encryption (EBS encryption, Azure Disk Encryption)
- Application-level encryption (Client-Side Field Level Encryption)

### Client-Side Field Level Encryption (CSFLE)

**[📖 CSFLE](https://www.mongodb.com/docs/manual/core/csfle/)** - Field-level encryption documentation

- Encrypts specific fields before sending to server
- Server never sees plaintext for encrypted fields
- Supports automatic and explicit encryption
- Uses envelope encryption with data encryption keys (DEKs)
- Key management via AWS KMS, Azure Key Vault, GCP KMS, or local key

## Security Best Practices

1. **Enable authentication** - Always use `security.authorization: enabled`
2. **Use strong passwords** - Or certificate-based authentication
3. **Principle of least privilege** - Grant minimum required roles
4. **Enable TLS** - Use `requireTLS` in production
5. **Use keyfile or x.509** for replica set internal authentication
6. **Bind to specific IPs** - Use `net.bindIp` to restrict network interfaces
7. **Keep MongoDB updated** - Apply security patches promptly
8. **Enable audit logging** - Track security-relevant events
9. **Encrypt at rest** - Use filesystem or native encryption
10. **Network segmentation** - Use firewalls and VPCs to restrict access
