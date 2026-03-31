# Multi-Account Strategy

**[📖 Organizations](https://docs.snowflake.com/en/user-guide/organizations)** - Organization management overview

## Overview

This document covers Snowflake Organizations, multi-account strategy, replication, failover, and data sharing architecture. These topics represent a significant portion of the SnowPro Advanced Architect exam, focusing on enterprise-grade deployment patterns and business continuity.

## Snowflake Organizations

### Organization Structure
- An organization is a top-level container for Snowflake accounts
- Managed by the ORGADMIN role
- Enables centralized account management across regions and cloud providers
- Provides unified billing and usage monitoring across all accounts

**[📖 ORGADMIN Role](https://docs.snowflake.com/en/user-guide/organizations-manage-accounts)** - Organization admin capabilities

### ORGADMIN Capabilities
- Create and manage accounts within the organization
- View and manage organization-level properties
- Monitor usage and billing across accounts
- Enable replication and failover between accounts
- Cannot access data within individual accounts (separation of duties)

### Account Deployment Patterns
| Pattern | Use Case | Accounts |
|---------|----------|----------|
| Environment Isolation | Dev/staging/prod separation | 3+ per workload |
| Regional Deployment | Low-latency global access | 1 per region |
| Business Unit Separation | Compliance or billing isolation | 1 per business unit |
| Data Provider/Consumer | Data marketplace architecture | Provider + consumer accounts |

### Cross-Cloud and Cross-Region
- Accounts can be created on AWS, Azure, or GCP within one organization
- Cross-cloud replication enables data movement between providers
- Cross-region replication provides geographic redundancy
- Different pricing models per cloud provider and region

**[📖 Supported Regions](https://docs.snowflake.com/en/user-guide/intro-regions)** - Available cloud regions

## Account Replication

### Replication Groups
- Bundle multiple object types for coordinated replication
- Objects replicated together: databases, shares, roles, users, warehouses, parameters
- Replication group defines what is replicated between accounts
- Primary account owns the replication group and controls refresh

**[📖 Replication Groups](https://docs.snowflake.com/en/user-guide/account-replication-config)** - Replication configuration

### Database Replication
```sql
-- On primary account: enable replication for database
ALTER DATABASE my_db ENABLE REPLICATION TO ACCOUNTS org.secondary_acct;

-- On secondary account: create replica
CREATE DATABASE my_db AS REPLICA OF org.primary_acct.my_db;

-- On secondary account: refresh replica
ALTER DATABASE my_db REFRESH;

-- Check replication status
SELECT * FROM TABLE(INFORMATION_SCHEMA.DATABASE_REPLICATION_USAGE_HISTORY());
```

- Primary database is read-write
- Secondary (replica) database is read-only
- Refresh is point-in-time snapshot - not continuous
- Refresh frequency configurable (manual or scheduled)
- Cross-region replication incurs data transfer costs

**[📖 Database Replication](https://docs.snowflake.com/en/user-guide/database-replication-intro)** - Database replication guide

### Replication Considerations
- **Storage Cost:** Secondary database uses storage in the target account
- **Data Transfer:** Cross-region/cross-cloud transfers incur network costs
- **Latency:** Refresh creates a point-in-time copy, not real-time sync
- **Objects Replicated:** Tables, views, stages, file formats, sequences, UDFs
- **Objects NOT Replicated:** Pipes, tasks, streams (must be recreated manually)

## Failover Groups

### Failover Architecture
- Failover groups extend replication groups with automatic failover capability
- Include databases, shares, and account-level objects
- Primary group is read-write, secondary groups are read-only
- Promotion makes a secondary group the new primary

**[📖 Failover Groups](https://docs.snowflake.com/en/user-guide/failover-groups)** - Failover configuration

### Client Redirect
```sql
-- Enable client redirect
ALTER ACCOUNT SET ENABLE_ACCOUNT_REDIRECT = TRUE;

-- Connection URL uses organization-level URL
-- snowflake://org-name-account-name.snowflakecomputing.com
-- Automatically redirects to active primary account
```

- Connection URLs use organization-level naming
- Clients automatically redirect to the active primary
- Transparent failover without application code changes
- DNS-based redirect with configurable TTL

**[📖 Client Redirect](https://docs.snowflake.com/en/user-guide/client-redirect)** - Connection failover

### Failover vs Replication
| Feature | Database Replication | Failover Group |
|---------|---------------------|----------------|
| Scope | Single database | Multiple objects |
| Failover | Manual promotion | Automated with client redirect |
| Objects | Database only | Databases, shares, roles, users |
| Use Case | Read replicas | Business continuity / DR |
| Client Impact | Requires connection change | Transparent redirect |

## Data Sharing

### Sharing Architecture
- Zero-copy data sharing - no data movement or copying
- Provider creates a share object containing databases, schemas, tables, views
- Consumer mounts the share as a read-only database
- Consumer uses their own compute to query shared data
- Provider retains full control and can revoke access at any time

**[📖 Data Sharing Introduction](https://docs.snowflake.com/en/user-guide/data-sharing-intro)** - Sharing overview

### Share Objects
```sql
-- Create a share
CREATE SHARE weather_share;

-- Grant access to specific objects
GRANT USAGE ON DATABASE weather_db TO SHARE weather_share;
GRANT USAGE ON SCHEMA weather_db.public TO SHARE weather_share;
GRANT SELECT ON TABLE weather_db.public.forecasts TO SHARE weather_share;

-- Add consumer account
ALTER SHARE weather_share ADD ACCOUNTS = consumer_acct;

-- Consumer: create database from share
CREATE DATABASE weather_data FROM SHARE provider_acct.weather_share;
```

### Secure Views for Sharing
```sql
-- Secure view hides query logic from consumers
CREATE SECURE VIEW weather_db.public.shared_forecasts AS
  SELECT date, region, temperature, precipitation
  FROM weather_db.internal.raw_forecasts
  WHERE is_published = TRUE;

-- Grant secure view to share (not the underlying table)
GRANT SELECT ON VIEW weather_db.public.shared_forecasts TO SHARE weather_share;
```

- Secure views hide the view definition from consumers
- Consumers cannot see the underlying SQL or table structure
- Secure UDFs similarly protect function logic
- Both prevent information leakage through EXPLAIN plans

**[📖 Secure Views](https://docs.snowflake.com/en/user-guide/views-secure)** - Secure view documentation

### Reader Accounts
- Managed accounts for consumers without Snowflake subscriptions
- Provider creates and manages the reader account
- Provider pays for reader account compute (warehouse credits)
- Consumer accesses data through the reader account interface
- Limited functionality compared to full Snowflake accounts

**[📖 Reader Accounts](https://docs.snowflake.com/en/user-guide/data-sharing-reader-create)** - Reader account setup

### Snowflake Marketplace
- Public platform for discovering and accessing shared data
- Providers can list free or paid datasets
- Consumers get instant access without data copying
- Cross-region auto-fulfillment via replication
- Standard and personalized listings available

**[📖 Snowflake Marketplace](https://docs.snowflake.com/en/user-guide/data-marketplace)** - Marketplace documentation

## Key Decision Framework

### When to Use Each Pattern
| Need | Solution | Key Consideration |
|------|----------|------------------|
| Share with Snowflake users, same region | Direct Share | Zero copy, instant |
| Share with non-Snowflake users | Reader Account | Provider pays compute |
| Access data in another region | Database Replication | Data copy, transfer cost |
| Business continuity / DR | Failover Group | Automated failover |
| Monetize datasets | Marketplace Listing | Auto-fulfillment |
| Group collaboration | Data Exchange | Private, curated group |

### Cost Implications
- **Data Sharing:** No storage cost for provider (data in place), consumer pays compute
- **Reader Accounts:** Provider pays compute, storage shared from provider
- **Replication:** Storage cost in target account + data transfer fees
- **Failover Groups:** Same as replication + failover management overhead
- **Marketplace:** Platform fees for paid listings, replication for cross-region
