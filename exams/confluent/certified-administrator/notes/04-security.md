# Kafka Security

**[📖 Kafka Security](https://docs.confluent.io/platform/current/security/index.html)** - Complete security documentation
**[📖 Apache Kafka Security](https://kafka.apache.org/documentation/#security)** - Core security reference

## Security Overview

### Security Layers
1. **Authentication** - Verify client identity (who are you?)
2. **Authorization** - Control access to resources (what can you do?)
3. **Encryption** - Protect data in transit and at rest

### Security Protocols

| Protocol | Authentication | Encryption |
|----------|---------------|------------|
| `PLAINTEXT` | None | None |
| `SSL` | Optional (mTLS) | TLS |
| `SASL_PLAINTEXT` | SASL | None |
| `SASL_SSL` | SASL | TLS |

**Production Recommendation:** `SASL_SSL` - provides both authentication and encryption.

## SASL Authentication

**[📖 SASL Configuration](https://docs.confluent.io/platform/current/kafka/authentication_sasl/index.html)** - SASL setup guide

### SASL Mechanisms

#### SASL/PLAIN
- Username and password authentication
- Credentials sent in cleartext (must use with SSL)
- Simple to set up
- Credentials stored in JAAS configuration file
- Not recommended for production without SSL

**Broker Configuration:**
```properties
sasl.enabled.mechanisms=PLAIN
sasl.mechanism.inter.broker.protocol=PLAIN
listeners=SASL_SSL://0.0.0.0:9093
security.inter.broker.protocol=SASL_SSL
```

**JAAS Configuration:**
```
KafkaServer {
    org.apache.kafka.common.security.plain.PlainLoginModule required
    username="admin"
    password="admin-secret"
    user_admin="admin-secret"
    user_client1="client1-secret";
};
```

#### SASL/SCRAM (SCRAM-SHA-256, SCRAM-SHA-512)
- Salted Challenge Response Authentication Mechanism
- Password never sent over the wire
- Credentials stored in ZooKeeper
- More secure than PLAIN
- Recommended for password-based authentication

**[📖 SASL/SCRAM](https://docs.confluent.io/platform/current/kafka/authentication_sasl/authentication_sasl_scram.html)** - SCRAM configuration guide

**Create SCRAM Credentials:**
```bash
kafka-configs --bootstrap-server localhost:9092 --alter \
  --add-config 'SCRAM-SHA-256=[iterations=8192,password=my-secret]' \
  --entity-type users --entity-name admin

kafka-configs --bootstrap-server localhost:9092 --alter \
  --add-config 'SCRAM-SHA-256=[password=client-secret]' \
  --entity-type users --entity-name client1
```

**Broker Configuration:**
```properties
sasl.enabled.mechanisms=SCRAM-SHA-256
sasl.mechanism.inter.broker.protocol=SCRAM-SHA-256
listeners=SASL_SSL://0.0.0.0:9093
security.inter.broker.protocol=SASL_SSL
```

#### SASL/GSSAPI (Kerberos)
- Enterprise-grade authentication
- Integrates with Active Directory / LDAP via Kerberos
- Requires Kerberos infrastructure (KDC)
- Most complex to set up
- Common in enterprise environments

**Broker Configuration:**
```properties
sasl.enabled.mechanisms=GSSAPI
sasl.mechanism.inter.broker.protocol=GSSAPI
sasl.kerberos.service.name=kafka
```

#### SASL/OAUTHBEARER
- OAuth 2.0 token-based authentication
- Modern authentication standard
- Integrates with identity providers (Okta, Auth0, Keycloak)
- Supports token refresh
- Growing adoption in cloud-native environments

### Multiple SASL Mechanisms
```properties
# Enable multiple mechanisms
sasl.enabled.mechanisms=SCRAM-SHA-256,PLAIN,OAUTHBEARER
# Inter-broker uses one specific mechanism
sasl.mechanism.inter.broker.protocol=SCRAM-SHA-256
```

## SSL/TLS Encryption

**[📖 SSL Configuration](https://docs.confluent.io/platform/current/kafka/authentication_ssl.html)** - SSL/TLS setup guide

### Generating Certificates

**Step 1: Create Certificate Authority (CA)**
```bash
openssl req -new -x509 -keyout ca-key -out ca-cert -days 365 \
  -subj "/CN=KafkaCA" -passout pass:ca-password
```

**Step 2: Create Broker Keystore**
```bash
keytool -keystore kafka.broker1.keystore.jks -alias broker1 \
  -validity 365 -genkey -keyalg RSA -storepass keystore-password \
  -dname "CN=broker1.example.com"
```

**Step 3: Create CSR, Sign with CA, Import**
```bash
# Export CSR
keytool -keystore kafka.broker1.keystore.jks -alias broker1 \
  -certreq -file broker1.csr -storepass keystore-password

# Sign with CA
openssl x509 -req -CA ca-cert -CAkey ca-key -in broker1.csr \
  -out broker1-signed.crt -days 365 -CAcreateserial -passin pass:ca-password

# Import CA cert and signed cert into keystore
keytool -keystore kafka.broker1.keystore.jks -alias CARoot \
  -import -file ca-cert -storepass keystore-password -noprompt
keytool -keystore kafka.broker1.keystore.jks -alias broker1 \
  -import -file broker1-signed.crt -storepass keystore-password

# Create truststore with CA cert
keytool -keystore kafka.broker1.truststore.jks -alias CARoot \
  -import -file ca-cert -storepass truststore-password -noprompt
```

### Broker SSL Configuration

```properties
# SSL Settings
ssl.keystore.location=/var/kafka/ssl/kafka.broker1.keystore.jks
ssl.keystore.password=keystore-password
ssl.key.password=key-password
ssl.truststore.location=/var/kafka/ssl/kafka.broker1.truststore.jks
ssl.truststore.password=truststore-password

# Enable SSL listener
listeners=SASL_SSL://0.0.0.0:9093
security.inter.broker.protocol=SASL_SSL

# Require client authentication (mutual TLS)
ssl.client.auth=required  # Options: required, requested, none

# Protocol and cipher configuration
ssl.enabled.protocols=TLSv1.2,TLSv1.3
ssl.protocol=TLSv1.3
```

### Client SSL Configuration
```properties
ssl.truststore.location=/var/kafka/ssl/client.truststore.jks
ssl.truststore.password=truststore-password
security.protocol=SASL_SSL

# For mutual TLS (if ssl.client.auth=required)
ssl.keystore.location=/var/kafka/ssl/client.keystore.jks
ssl.keystore.password=keystore-password
ssl.key.password=key-password
```

## ACL Authorization

**[📖 ACL Management](https://docs.confluent.io/platform/current/kafka/authorization.html)** - Authorization and ACLs

### Enabling ACLs

```properties
# Broker configuration
authorizer.class.name=kafka.security.authorizer.AclAuthorizer
# For KRaft mode:
# authorizer.class.name=org.apache.kafka.metadata.authorizer.StandardAuthorizer

# Super users (bypass ACL checks)
super.users=User:admin;User:kafka

# Allow access when no ACLs are set (default: false)
allow.everyone.if.no.acl.found=false
```

### ACL Management Commands

**[📖 kafka-acls](https://docs.confluent.io/platform/current/kafka/authorization.html#using-acls)** - ACL CLI reference

```bash
# Add read permission on a topic
kafka-acls --bootstrap-server localhost:9092 --add \
  --allow-principal User:alice \
  --operation Read \
  --topic my-topic

# Add write permission on a topic
kafka-acls --bootstrap-server localhost:9092 --add \
  --allow-principal User:producer1 \
  --operation Write \
  --topic my-topic

# Add consumer group access
kafka-acls --bootstrap-server localhost:9092 --add \
  --allow-principal User:alice \
  --operation Read \
  --group my-consumer-group

# Prefixed ACL (applies to all topics starting with "team-a-")
kafka-acls --bootstrap-server localhost:9092 --add \
  --allow-principal User:team-a \
  --operation All \
  --topic team-a \
  --resource-pattern-type prefixed

# Deny ACL
kafka-acls --bootstrap-server localhost:9092 --add \
  --deny-principal User:baduser \
  --operation All \
  --topic sensitive-topic

# List all ACLs
kafka-acls --bootstrap-server localhost:9092 --list

# List ACLs for a specific topic
kafka-acls --bootstrap-server localhost:9092 --list --topic my-topic

# Remove ACL
kafka-acls --bootstrap-server localhost:9092 --remove \
  --allow-principal User:alice \
  --operation Read \
  --topic my-topic
```

### ACL Resources and Operations

**Resources:**
- `Topic` - Kafka topics
- `Group` - Consumer groups
- `Cluster` - Cluster-level operations
- `TransactionalId` - Transactional producers
- `DelegationToken` - Delegation tokens

**Operations:**
| Operation | Applicable Resources |
|-----------|---------------------|
| Read | Topic, Group |
| Write | Topic |
| Create | Cluster, Topic |
| Delete | Topic, Group |
| Alter | Topic, Cluster |
| Describe | Topic, Group, Cluster |
| AlterConfigs | Topic, Cluster |
| DescribeConfigs | Topic, Cluster |
| All | All resources |

### ACL Patterns
- **Literal** - Exact resource name match (default)
- **Prefixed** - Matches all resources starting with the pattern

### Common ACL Patterns

**Producer Access:**
```bash
kafka-acls --add --allow-principal User:producer \
  --operation Write --operation Describe --topic my-topic
```

**Consumer Access:**
```bash
kafka-acls --add --allow-principal User:consumer \
  --operation Read --topic my-topic
kafka-acls --add --allow-principal User:consumer \
  --operation Read --group my-group
```

**Streams Application:**
```bash
kafka-acls --add --allow-principal User:streams-app \
  --operation Read --topic input-topic
kafka-acls --add --allow-principal User:streams-app \
  --operation Write --topic output-topic
kafka-acls --add --allow-principal User:streams-app \
  --operation All --topic streams-app --resource-pattern-type prefixed
kafka-acls --add --allow-principal User:streams-app \
  --operation All --group streams-app --resource-pattern-type prefixed
```

## Encryption at Rest

### Options for Encryption at Rest
- **Filesystem-level encryption** - dm-crypt, LUKS, eCryptfs
- **Volume-level encryption** - Cloud provider volume encryption (EBS, Azure Disk)
- **Application-level encryption** - Encrypt before producing to Kafka
- Kafka does not natively encrypt data at rest
- Confluent offers self-managed encryption features in enterprise edition

## Security Best Practices

1. **Always use SASL_SSL** in production (authentication + encryption)
2. **Use SCRAM or OAUTHBEARER** over PLAIN for password-based auth
3. **Enable ACLs** with `allow.everyone.if.no.acl.found=false`
4. **Use super users sparingly** - only for admin operations
5. **Rotate certificates** before expiration
6. **Use prefixed ACLs** for team-based access control
7. **Separate listeners** for inter-broker and client communication
8. **Audit ACL changes** using Kafka audit logs
9. **Enable SSL for ZooKeeper** communication as well
10. **Use separate credentials** for different applications
