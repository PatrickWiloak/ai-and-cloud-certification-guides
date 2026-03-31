# SnowPro Core Certification (COF-C02)

## Exam Overview

The SnowPro Core Certification validates a candidate's foundational knowledge of Snowflake's cloud data platform. This certification demonstrates understanding of Snowflake's architecture, key features, and core functionality needed to work effectively with the platform. It serves as a prerequisite for all SnowPro Advanced certifications.

**Exam Details:**
- **Exam Code:** COF-C02
- **Duration:** 115 minutes
- **Number of Questions:** 100 multiple choice
- **Passing Score:** 750 out of 1000
- **Cost:** $175 USD
- **Delivery:** Online proctored
- **Validity:** 2 years
- **Prerequisites:** None (Snowflake hands-on experience recommended)

## Exam Domains

### Domain 1: Snowflake Cloud Data Platform Features and Architecture (25%)
- Overview of Snowflake's cloud data platform
- Snowflake's unique multi-cluster shared data architecture
- Virtual warehouses and compute layer
- Storage layer and micro-partitions
- Cloud services layer
- Snowflake editions and features
- Connectivity options and drivers

**Key Concepts:**
- Three-layer architecture: storage, compute, cloud services
- Virtual warehouse sizing and scaling (T-shirt sizes)
- Multi-cluster warehouses and auto-scaling
- Micro-partitions and columnar storage
- Metadata management in the cloud services layer
- Query processing and optimization
- Data caching layers (result cache, local disk cache, remote disk cache)
- Snowflake editions: Standard, Enterprise, Business Critical, VPS
- Support for multiple cloud providers (AWS, Azure, GCP)

### Domain 2: Account Access and Security (20%)
- User and role management
- Role-Based Access Control (RBAC)
- Discretionary Access Control (DAC)
- Multi-Factor Authentication (MFA)
- Network policies and IP allowlists
- Data encryption (at rest and in transit)
- Federated authentication and SSO
- Key pair authentication

**Key Concepts:**
- System-defined roles: ACCOUNTADMIN, SECURITYADMIN, SYSADMIN, USERADMIN, PUBLIC
- Role hierarchy and privilege inheritance
- Object ownership and GRANT/REVOKE
- Column-level security and row access policies
- Dynamic data masking
- External tokenization
- Tri-Secret Secure encryption
- OAuth integration
- SCIM provisioning

### Domain 3: Performance Concepts (15%)
- Query performance optimization
- Warehouse configuration for performance
- Clustering keys and micro-partition pruning
- Caching mechanisms
- Query profiling and execution plans
- Resource monitoring

**Key Concepts:**
- Query Profile and execution plan analysis
- Clustering keys and when to use them
- Automatic clustering and re-clustering
- Result cache (24-hour window, user-specific)
- Warehouse cache (local SSD, cleared on suspend)
- Metadata cache (cloud services layer)
- Warehouse sizing guidelines
- Multi-cluster warehouse scaling policies (standard vs economy)
- Resource monitors and credit usage tracking
- Materialized views for pre-computed results

### Domain 4: Data Loading and Unloading (10%)
- COPY INTO command for bulk loading
- Snowpipe for continuous loading
- Stage types (internal, external)
- File formats and compression
- Data unloading to stages
- PUT and GET commands

**Key Concepts:**
- Internal stages: user, table, named
- External stages: S3, Azure Blob, GCS
- File format options: CSV, JSON, Avro, ORC, Parquet, XML
- COPY INTO with transformation during load
- ON_ERROR options: CONTINUE, SKIP_FILE, ABORT_STATEMENT
- VALIDATION_MODE for dry-run validation
- Snowpipe architecture and auto-ingest
- Snowpipe REST API endpoints
- Data unloading with COPY INTO location
- VARIANT data type for semi-structured data

### Domain 5: Data Transformations (20%)
- SQL functions and operations
- Stored procedures and UDFs
- Streams and tasks
- Semi-structured data handling
- Views (regular, secure, materialized)
- Sequences and auto-increment

**Key Concepts:**
- FLATTEN function for semi-structured data
- LATERAL keyword usage
- GET_PATH and bracket notation for JSON
- JavaScript and SQL stored procedures
- JavaScript, SQL, Python, and Java UDFs
- Table functions (UDTFs)
- External functions
- Streams for change data capture (CDC)
- Tasks for scheduling SQL statements
- Task trees and dependencies
- CREATE TABLE AS SELECT (CTAS)
- INSERT OVERWRITE
- MERGE statement
- Secure views vs regular views
- Recursive CTEs

### Domain 6: Data Protection and Data Sharing (10%)
- Time Travel
- Fail-safe
- Data sharing
- Snowflake Marketplace
- Replication and failover
- Cloning

**Key Concepts:**
- Time Travel retention periods (0-90 days, edition-dependent)
- Fail-safe (7 days, non-configurable, Snowflake managed)
- Zero-copy cloning and metadata operations
- Direct data sharing (no data movement)
- Reader accounts for non-Snowflake customers
- Secure Data Sharing with listings
- Snowflake Marketplace providers and consumers
- Database and share replication across regions/clouds
- Account replication and failover groups
- Data exchange for private sharing

## Key Study Focus Areas

### Architecture Deep Dive
Understanding Snowflake's unique architecture is the most heavily weighted domain. Focus on:
- How the three layers work independently and together
- Virtual warehouse behavior during scaling
- How micro-partitions store and organize data
- The role of the cloud services layer in query optimization
- How caching works at each layer

### Security Model
The second-largest domain requires thorough knowledge of:
- RBAC model and role hierarchy
- When to use each system-defined role
- Network security features
- Encryption methods and key management
- Authentication options

### SQL and Transformations
This domain tests practical Snowflake SQL knowledge:
- Semi-structured data handling (VARIANT, OBJECT, ARRAY)
- Change data capture with streams
- Task scheduling and management
- Stored procedures vs UDFs

## Study Approach

### Recommended Preparation Time
- **Beginners:** 6-8 weeks with daily study
- **Experienced Snowflake Users:** 3-4 weeks focused review
- **Database Professionals:** 4-5 weeks with hands-on practice

### Study Path
1. Start with Snowflake's free trial account for hands-on practice
2. Review official Snowflake documentation for each domain
3. Complete Snowflake University courses (free with trial)
4. Practice with sample queries and real-world scenarios
5. Take practice exams and review weak areas
6. Focus final review on architecture and security domains

### Hands-on Practice Priorities
- Create and manage virtual warehouses of different sizes
- Load data using COPY INTO and Snowpipe
- Work with semi-structured data (JSON, Parquet)
- Implement role hierarchies and access control
- Use Time Travel and cloning features
- Set up resource monitors
- Create and manage streams and tasks
- Query the Snowflake Marketplace

### Common Exam Pitfalls
- Confusing result cache with warehouse cache behavior
- Mixing up stage types and their use cases
- Not understanding role hierarchy inheritance
- Confusing Time Travel with Fail-safe capabilities
- Misunderstanding multi-cluster warehouse scaling policies
- Not knowing edition-specific feature availability
- Confusing Snowpipe with COPY INTO use cases

## Official Resources

- **[Snowflake Documentation](https://docs.snowflake.com/)** - Primary study resource
- **[SnowPro Core Study Guide](https://learn.snowflake.com/en/certifications/snowpro-core/)** - Official exam page
- **[Snowflake University](https://learn.snowflake.com/)** - Free training courses
- **[Snowflake Community](https://community.snowflake.com/)** - Forums and discussions
- **[Snowflake Hands-on Essentials](https://learn.snowflake.com/)** - Free guided labs
