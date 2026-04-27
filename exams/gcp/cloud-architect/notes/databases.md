# GCP Database Fundamentals

## Database Service Overview

### GCP Database Portfolio
| Service | Type | Use Case |
|---------|------|----------|
| **Cloud SQL** | Relational (managed) | Traditional OLTP applications |
| **Cloud Spanner** | Relational (global) | Global consistency, high scale |
| **Firestore** | NoSQL (document) | Mobile/web applications |
| **Bigtable** | NoSQL (wide-column) | Large analytical workloads |
| **BigQuery** | Data warehouse | Analytics and business intelligence |
| **Memorystore** | In-memory cache | Caching, session storage |

### Database Decision Tree
```
Need ACID transactions? → Cloud SQL or Spanner
Global scale with consistency? → Cloud Spanner
Document/mobile data? → Firestore
Time-series/IoT data? → Bigtable
Analytics/data warehouse? → BigQuery
Caching layer? → Memorystore
```

## Cloud SQL

### What is Cloud SQL?
Fully managed relational database service for MySQL, PostgreSQL, and SQL Server.

### Supported Database Engines
| Engine | Latest Version | Use Case |
|--------|----------------|----------|
| **MySQL** | 8.0 | Web applications, e-commerce |
| **PostgreSQL** | 14 | Complex queries, JSON data |
| **SQL Server** | 2019 | Microsoft stack applications |

### Machine Types
| Type | vCPUs | Memory | Use Case |
|------|-------|--------|----------|
| **Shared-core** | Shared | 0.6-3.75 GB | Development, testing |
| **Standard** | 1-96 | 3.75-624 GB | Production workloads |
| **High-memory** | 2-96 | 13-624 GB | Memory-intensive applications |
| **Custom** | 1-96 | Custom ratio | Specific requirements |

### Storage Options
| Type | Max Size | Performance | Use Case |
|------|----------|-------------|----------|
| **SSD** | 64 TB | High IOPS | Production databases |
| **HDD** | 64 TB | Lower IOPS | Cost-effective storage |

### High Availability
#### Regional Persistent Disks
- **Synchronous replication**: Data replicated across zones
- **Automatic failover**: Switch to standby in case of failure
- **99.95% availability**: Higher SLA than single-zone
- **No data loss**: Zero RPO (Recovery Point Objective)

#### Read Replicas
- **Asynchronous replication**: Eventually consistent
- **Cross-region**: Can be in different regions
- **Read scaling**: Distribute read traffic
- **Multiple replicas**: Up to 10 per master

### Backup and Recovery
| Feature | Automated Backups | On-Demand Backups |
|---------|-------------------|-------------------|
| **Frequency** | Daily | Manual |
| **Retention** | Up to 365 days | Until deleted |
| **Point-in-time recovery** | Yes | No |
| **Cross-region** | Optional | Optional |

### Cloud SQL Features
- **Automatic storage scaling**: Grow storage as needed
- **Maintenance windows**: Schedule updates
- **Private IP**: VPC-native connectivity
- **SSL/TLS encryption**: Secure connections
- **IAM authentication**: Integrate with Cloud IAM
- **Database flags**: Customize database configuration

#### Connection Methods
```bash
# Cloud SQL Proxy (recommended)
./cloud_sql_proxy -instances=PROJECT:REGION:INSTANCE=tcp:3306

# Direct IP connection (with authorized networks)
mysql -h INSTANCE_IP -u USERNAME -p

# Private IP (VPC-native)
mysql -h PRIVATE_IP -u USERNAME -p
```

## Cloud Spanner

### What is Cloud Spanner?
Globally distributed, horizontally scalable, ACID-compliant relational database.

### Key Characteristics
- **Global distribution**: Multi-region deployment
- **Horizontal scaling**: Scales to petabytes
- **ACID transactions**: Strong consistency
- **SQL interface**: Standard SQL queries
- **99.999% availability**: Extremely high uptime

### Spanner Architecture
```
Instance (Regional or Multi-regional)
├── Database 1
│   ├── Table A
│   └── Table B
└── Database 2
    ├── Table C
    └── Table D
```

### Instance Configurations
| Type | Regions | Use Case |
|------|---------|----------|
| **Regional** | Single region | Low latency, regional applications |
| **Multi-regional** | Multiple regions | Global applications, disaster recovery |

### Processing Units
- **Minimum**: 100 processing units (or 1 node = 1000 PU)
- **Scaling**: Scale up/down based on needs
- **Cost**: Pay for allocated processing units
- **Performance**: More PUs = higher throughput

### Spanner SQL
Standard SQL with extensions for distributed processing:

```sql
-- Interleaved tables for performance
CREATE TABLE Albums (
  SingerId INT64 NOT NULL,
  AlbumId INT64 NOT NULL,
  AlbumTitle STRING(MAX)
) PRIMARY KEY (SingerId, AlbumId),
  INTERLEAVE IN PARENT Singers ON DELETE CASCADE;

-- Array and struct support
SELECT ARRAY(SELECT AlbumTitle FROM Albums 
             WHERE Albums.SingerId = Singers.SingerId) as albums
FROM Singers;
```

### When to Use Spanner
- **Global applications**: Users worldwide need consistent data
- **High scale**: Beyond single-region SQL databases
- **Strong consistency**: ACID transactions required
- **Mission-critical**: Need 99.999% availability
- **Complex queries**: SQL interface required

## Firestore

### What is Firestore?
Serverless NoSQL document database for mobile and web applications.

### Firestore vs Datastore
| Feature | Firestore | Datastore |
|---------|-----------|-----------|
| **Real-time updates** | Yes | No |
| **Mobile SDKs** | Yes | No |
| **Multi-document transactions** | Yes | Limited |
| **Queries** | More powerful | Basic |
| **Pricing** | Per operation | Per operation |

### Data Model
```
Collection: users
├── Document: user1
│   ├── Field: name = "Alice"
│   ├── Field: email = "alice@example.com"
│   └── Subcollection: orders
│       ├── Document: order1
│       └── Document: order2
└── Document: user2
    ├── Field: name = "Bob"
    └── Field: email = "bob@example.com"
```

### Data Types
- **String**: Text data
- **Number**: Integer or floating-point
- **Boolean**: True/false values
- **Map**: Nested objects
- **Array**: Ordered lists
- **Null**: Null values
- **Timestamp**: Date and time
- **Geopoint**: Geographic coordinates
- **Reference**: Document references
- **Blob**: Binary data

### Queries and Indexes
#### Simple Queries
```javascript
// Get all users in California
db.collection("users")
  .where("state", "==", "CA")
  .get()

// Order by age, limit to 10
db.collection("users")
  .orderBy("age")
  .limit(10)
  .get()

// Compound query
db.collection("users")
  .where("state", "==", "CA")
  .where("age", ">", 21)
  .orderBy("age")
  .get()
```

#### Indexes
- **Single-field indexes**: Automatic for each field
- **Composite indexes**: Required for compound queries
- **Array-contains queries**: Special indexing for arrays
- **Collection group queries**: Query across subcollections

### Real-time Updates
```javascript
// Listen for real-time updates
db.collection("users").doc("user1")
  .onSnapshot((doc) => {
    console.log("Current data: ", doc.data());
  });

// Listen to query results
db.collection("users")
  .where("status", "==", "online")
  .onSnapshot((snapshot) => {
    snapshot.docChanges().forEach((change) => {
      if (change.type === "added") {
        console.log("New user: ", change.doc.data());
      }
    });
  });
```

### Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own documents
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Public read access to products
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
  }
}
```

## Bigtable

### What is Bigtable?
High-performance NoSQL database for large analytical and operational workloads.

### Key Characteristics
- **Wide-column**: Sparse, distributed, persistent multidimensional sorted map
- **High throughput**: Millions of operations per second
- **Low latency**: Single-digit millisecond latency
- **Scalable**: Petabyte+ scale
- **HBase compatible**: Use existing HBase tools and APIs

### Data Model
```
Table: user_data
Row Key: user123#20230115
├── Column Family: profile
│   ├── name: "Alice"
│   └── email: "alice@example.com"
└── Column Family: metrics
    ├── page_views: 1250
    └── last_login: "2023-01-15T10:30:00Z"
```

### Row Key Design
**Critical for performance and scalability**

#### Good Row Key Patterns
```
# Time-series data with reverse timestamp
sensor_id#reverse_timestamp

# User data with domain sharding
domain#user_id

# Event data with hash prefix
hash(event_id)#event_id
```

#### Avoid Hot-spotting
- **Sequential keys**: Timestamp-only keys
- **Small key space**: Limited key variety
- **Uneven distribution**: Some keys much more frequent

### Bigtable Instances
| Type | Description | Use Case |
|------|-------------|----------|
| **Production** | High availability, replication | Production workloads |
| **Development** | Single cluster, lower cost | Development and testing |

### Cluster Configuration
- **Nodes**: Processing capacity (min 1, max 1000+ per cluster)
- **Storage type**: SSD or HDD
- **Replication**: Multi-cluster for high availability
- **Autoscaling**: Automatic node adjustment

### Performance Optimization
#### Best Practices
1. **Distribute reads/writes**: Avoid hotspotting
2. **Pre-split tables**: Create initial splits
3. **Batch operations**: Group multiple operations
4. **Connection pooling**: Reuse connections
5. **Monitor metrics**: Track performance indicators

#### Key Metrics
- **CPU utilization**: Should be < 70% for good performance
- **Storage utilization**: Monitor disk usage
- **Hot tablets**: Identify hot partitions
- **Request latency**: Track response times

## BigQuery

### What is BigQuery?
Serverless, highly scalable data warehouse designed for analytics.

### Key Features
- **Serverless**: No infrastructure to manage
- **Petabyte scale**: Handle massive datasets
- **Standard SQL**: ANSI SQL 2011 compliance
- **Streaming inserts**: Real-time data ingestion
- **Machine learning**: Built-in ML capabilities (BigQuery ML)

### Data Organization
```
Project
├── Dataset 1
│   ├── Table A (native)
│   ├── Table B (external)
│   └── View C
└── Dataset 2
    ├── Table D
    └── Materialized View E
```

### Table Types
| Type | Description | Use Case |
|------|-------------|----------|
| **Native tables** | Stored in BigQuery | Regular analytics |
| **External tables** | Data in Cloud Storage/Bigtable | Data lake scenarios |
| **Views** | Virtual tables | Data abstraction |
| **Materialized views** | Cached query results | Performance optimization |

### Data Loading
#### Batch Loading
```bash
# Load from Cloud Storage
bq load --source_format=CSV \
  mydataset.mytable \
  gs://mybucket/myfile.csv \
  schema.json

# Load from local file
bq load --source_format=NEWLINE_DELIMITED_JSON \
  mydataset.mytable \
  data.json \
  schema.json
```

#### Streaming Inserts
```python
from google.cloud import bigquery

client = bigquery.Client()
table_id = "project.dataset.table"

rows_to_insert = [
    {"name": "Alice", "age": 30},
    {"name": "Bob", "age": 25}
]

errors = client.insert_rows_json(table_id, rows_to_insert)
if not errors:
    print("Rows inserted successfully")
```

### Partitioning and Clustering
#### Partitioning
```sql
-- Date partitioned table
CREATE TABLE mydataset.events
(
  event_date DATE,
  user_id STRING,
  event_type STRING
)
PARTITION BY event_date;

-- Integer range partitioning
CREATE TABLE mydataset.sales
(
  sale_date DATE,
  store_id INT64,
  amount NUMERIC
)
PARTITION BY RANGE_BUCKET(store_id, GENERATE_ARRAY(0, 1000, 10));
```

#### Clustering
```sql
-- Clustered table for better performance
CREATE TABLE mydataset.events
(
  event_date DATE,
  user_id STRING,
  event_type STRING,
  country STRING
)
PARTITION BY event_date
CLUSTER BY user_id, event_type;
```

### BigQuery ML
```sql
-- Create ML model
CREATE MODEL mydataset.purchase_prediction
OPTIONS(model_type='logistic_reg') AS
SELECT
  age,
  income,
  previous_purchases,
  will_purchase as label
FROM mydataset.customer_data;

-- Make predictions
SELECT
  customer_id,
  predicted_will_purchase,
  predicted_will_purchase_probs
FROM ML.PREDICT(MODEL mydataset.purchase_prediction,
  (SELECT * FROM mydataset.new_customers));
```

## Memorystore

### What is Memorystore?
Fully managed in-memory data store service for Redis and Memcached.

### Redis vs Memcached
| Feature | Redis | Memcached |
|---------|-------|-----------|
| **Data types** | Rich data structures | Key-value only |
| **Persistence** | Optional | No |
| **Replication** | Yes | No |
| **Clustering** | Yes | No |
| **Atomic operations** | Yes | Limited |

### Redis Features
- **Data structures**: Strings, hashes, lists, sets, sorted sets
- **Persistence**: RDB snapshots, AOF logging
- **High availability**: Master-replica configuration
- **Scaling**: Read replicas for read scaling
- **Security**: AUTH, VPC integration, encryption in transit

### Common Use Cases
#### Caching
```python
import redis

# Connect to Redis
r = redis.Redis(host='10.0.0.3', port=6379, decode_responses=True)

# Cache database query results
def get_user(user_id):
    # Check cache first
    cached_user = r.get(f"user:{user_id}")
    if cached_user:
        return json.loads(cached_user)
    
    # Fetch from database
    user = fetch_user_from_db(user_id)
    
    # Cache for 1 hour
    r.setex(f"user:{user_id}", 3600, json.dumps(user))
    return user
```

#### Session Storage
```python
# Store session data
r.hset(f"session:{session_id}", mapping={
    "user_id": "123",
    "username": "alice",
    "login_time": "2023-01-15T10:30:00Z"
})

# Set session expiration (30 minutes)
r.expire(f"session:{session_id}", 1800)
```

#### Real-time Analytics
```python
# Increment counters
r.incr("page_views:today")
r.hincrby("page_views:by_page", "/home", 1)

# Leaderboards with sorted sets
r.zadd("game_scores", {"player1": 1500, "player2": 1200})
top_players = r.zrevrange("game_scores", 0, 9, withscores=True)
```

## Database Migration and Integration

### Database Migration Service
**Migrate databases to Google Cloud**

#### Supported Sources
- **On-premises**: MySQL, PostgreSQL, SQL Server
- **Other clouds**: AWS RDS, Azure Database
- **Google Cloud**: Between Cloud SQL instances

#### Migration Types
- **One-time**: Single migration event
- **Continuous**: Ongoing replication
- **Heterogeneous**: Different database engines

### Data Transfer Service
**Move data between storage systems**

#### Transfer Types
- **One-time transfers**: Migrate existing data
- **Scheduled transfers**: Regular data movement
- **Event-driven**: Trigger on file changes

### Federated Queries
**Query external data sources from BigQuery**

#### Supported Sources
- **Cloud SQL**: Query operational databases
- **Bigtable**: Access NoSQL data
- **Cloud Storage**: Query files directly
- **Google Sheets**: Analyze spreadsheet data

```sql
-- Query Cloud SQL from BigQuery
SELECT *
FROM EXTERNAL_QUERY("projects/project/locations/region/connections/connection",
  "SELECT user_id, order_total FROM orders WHERE order_date = CURRENT_DATE()");
```

## Database Best Practices

### Performance Optimization
1. **Choose right database**: Match workload to database type
2. **Optimize queries**: Use indexes, avoid full table scans
3. **Partition large tables**: Improve query performance
4. **Use caching**: Implement appropriate caching layers
5. **Monitor performance**: Track key metrics and optimize

### Security Best Practices
1. **Encryption**: Enable encryption at rest and in transit
2. **Access controls**: Use least privilege IAM policies
3. **Private networking**: Use VPC and private IPs
4. **Audit logging**: Enable database audit logs
5. **Regular updates**: Keep database software updated

### Cost Optimization
1. **Right-size instances**: Match capacity to actual needs
2. **Use appropriate storage**: Balance performance and cost
3. **Implement lifecycle policies**: Archive old data
4. **Monitor usage**: Track and optimize database usage
5. **Reserved capacity**: Commit to long-term usage for discounts

### Backup and Recovery
1. **Regular backups**: Automated and tested backups
2. **Cross-region replication**: Disaster recovery planning
3. **Point-in-time recovery**: Enable transaction log backups
4. **Test recovery**: Regular recovery testing
5. **Document procedures**: Clear recovery procedures

## Common Database Pitfalls

### Performance Issues
- **Poor query design**: Inefficient queries without proper indexes
- **Wrong database choice**: Using wrong database type for workload
- **Inadequate capacity**: Under-provisioned resources
- **Hot-spotting**: Uneven data distribution (especially Bigtable)
- **Missing monitoring**: Not tracking performance metrics

### Security Vulnerabilities
- **Weak authentication**: Default or weak passwords
- **Overly permissive access**: Too broad IAM permissions
- **Unencrypted data**: Missing encryption at rest or in transit
- **Public exposure**: Databases accessible from internet
- **Missing audit trails**: No logging of database access

### Operational Problems
- **Insufficient backups**: Inadequate backup strategies
- **No disaster recovery**: Missing DR planning
- **Lack of monitoring**: Insufficient alerting and monitoring
- **Poor capacity planning**: Not planning for growth
- **Manual processes**: Not automating routine tasks

### Cost Issues
- **Over-provisioning**: Allocating more resources than needed
- **Unused resources**: Idle databases and storage
- **Wrong pricing model**: Not optimizing pricing options
- **Data retention**: Keeping data longer than necessary
- **Inefficient queries**: Expensive query patterns