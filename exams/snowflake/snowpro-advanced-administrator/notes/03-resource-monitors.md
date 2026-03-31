# Resource Monitors and Cost Management

**[📖 Resource Monitors](https://docs.snowflake.com/en/user-guide/resource-monitors)** - Cost control documentation

## Overview

This document covers resource monitors, credit tracking, cost optimization, and storage management in Snowflake. Resource management and cost control represent a significant portion of the Advanced Administrator exam, testing both configuration knowledge and analytical skills with ACCOUNT_USAGE views.

## Resource Monitors

### Architecture
- Credit quota tracking mechanism for warehouse compute
- Can be applied at account level or warehouse level
- Triggers execute actions when credit usage reaches thresholds
- Multiple triggers per monitor at different percentage thresholds
- Only tracks warehouse credits (not serverless or storage)

### Creation and Configuration
```sql
-- Comprehensive resource monitor
CREATE RESOURCE MONITOR production_monthly
  WITH CREDIT_QUOTA = 5000
  FREQUENCY = MONTHLY
  START_TIMESTAMP = '2024-01-01 00:00 UTC'
  END_TIMESTAMP = NULL  -- No end date
  TRIGGERS
    ON 25 PERCENT DO NOTIFY
    ON 50 PERCENT DO NOTIFY
    ON 75 PERCENT DO NOTIFY
    ON 90 PERCENT DO SUSPEND
    ON 100 PERCENT DO SUSPEND_IMMEDIATE;

-- Apply to account
ALTER ACCOUNT SET RESOURCE_MONITOR = production_monthly;

-- Apply to specific warehouse
ALTER WAREHOUSE analytics_wh SET RESOURCE_MONITOR = production_monthly;
```

### Monitor Properties
| Property | Description | Options |
|----------|-------------|---------|
| CREDIT_QUOTA | Credit limit for the period | Integer (credits) |
| FREQUENCY | Reset interval | MONTHLY, DAILY, WEEKLY, YEARLY, NEVER |
| START_TIMESTAMP | When monitoring begins | Timestamp or IMMEDIATELY |
| END_TIMESTAMP | When monitoring ends | Timestamp or NULL (no end) |

### Trigger Actions
| Action | Effect | Impact on Queries |
|--------|--------|-------------------|
| NOTIFY | Email notification to admins | None - queries continue |
| SUSPEND | Suspend warehouse(s) gracefully | Running queries complete first |
| SUSPEND_IMMEDIATE | Suspend immediately | Running queries cancelled |

### Monitor Scope
| Level | Applies To | Tracks |
|-------|-----------|--------|
| Account | All warehouses in account | Total warehouse credits |
| Warehouse | Single warehouse | Credits for that warehouse only |

- One account-level monitor per account
- One monitor per warehouse
- If both exist, most restrictive trigger wins
- Account monitor tracks all warehouse credits combined

### Modifying Monitors
```sql
-- Change quota
ALTER RESOURCE MONITOR production_monthly SET CREDIT_QUOTA = 7000;

-- Add trigger
ALTER RESOURCE MONITOR production_monthly SET
  TRIGGERS ON 60 PERCENT DO NOTIFY;

-- View monitors
SHOW RESOURCE MONITORS;

-- View monitor details
DESCRIBE RESOURCE MONITOR production_monthly;
```

### Monitor Limitations
- Do NOT track serverless credits (Snowpipe, serverless tasks, auto-clustering)
- Do NOT track storage costs
- Do NOT track cloud services credits
- Cannot set per-query credit limits
- Notifications sent to account administrators only

## Credit Tracking

### Warehouse Credits
```sql
-- Credit usage by warehouse (last 30 days)
SELECT warehouse_name,
       SUM(credits_used) AS total_credits,
       SUM(credits_used_compute) AS compute_credits,
       SUM(credits_used_cloud_services) AS cloud_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
WHERE start_time >= DATEADD('day', -30, CURRENT_TIMESTAMP())
GROUP BY warehouse_name
ORDER BY total_credits DESC;

-- Hourly credit pattern
SELECT warehouse_name,
       HOUR(start_time) AS hour_of_day,
       DAYNAME(start_time) AS day_of_week,
       AVG(credits_used) AS avg_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
WHERE start_time >= DATEADD('day', -30, CURRENT_TIMESTAMP())
GROUP BY 1, 2, 3
ORDER BY 1, 2;
```

### Serverless Credits
```sql
-- Serverless task credits
SELECT task_name, SUM(credits_used) AS total_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.SERVERLESS_TASK_HISTORY
WHERE start_time >= DATEADD('day', -30, CURRENT_TIMESTAMP())
GROUP BY task_name
ORDER BY total_credits DESC;

-- Snowpipe credits
SELECT pipe_name, SUM(credits_used) AS total_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.PIPE_USAGE_HISTORY
WHERE start_time >= DATEADD('day', -30, CURRENT_TIMESTAMP())
GROUP BY pipe_name
ORDER BY total_credits DESC;

-- Auto-clustering credits
SELECT table_name, SUM(credits_used) AS total_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.AUTOMATIC_CLUSTERING_HISTORY
WHERE start_time >= DATEADD('day', -30, CURRENT_TIMESTAMP())
GROUP BY table_name
ORDER BY total_credits DESC;

-- All metering (combined)
SELECT service_type, SUM(credits_used) AS total_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.METERING_HISTORY
WHERE start_time >= DATEADD('month', -1, CURRENT_TIMESTAMP())
GROUP BY service_type
ORDER BY total_credits DESC;
```

### Cloud Services Credit Adjustment
- Cloud services free up to 10% of daily warehouse compute credits
- Only excess beyond 10% is billed
- Example: 100 warehouse credits/day = 10 free cloud services credits

```sql
-- Cloud services overage analysis
SELECT DATE_TRUNC('day', start_time) AS day,
       SUM(CASE WHEN service_type = 'WAREHOUSE_METERING' THEN credits_used ELSE 0 END) AS warehouse_credits,
       SUM(CASE WHEN service_type = 'CLOUD_SERVICES' THEN credits_used ELSE 0 END) AS cloud_credits,
       SUM(CASE WHEN service_type = 'WAREHOUSE_METERING' THEN credits_used ELSE 0 END) * 0.1 AS free_cloud_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.METERING_HISTORY
WHERE start_time >= DATEADD('day', -30, CURRENT_TIMESTAMP())
GROUP BY 1
HAVING cloud_credits > free_cloud_credits
ORDER BY 1;
```

## Warehouse Optimization

### Auto-Suspend Strategy
| Auto-Suspend Setting | Cache Impact | Cost Impact | Use Case |
|---------------------|-------------|-------------|----------|
| 60 seconds | Cache cleared quickly | Lowest idle cost | Batch/ETL workloads |
| 300 seconds (5 min) | Moderate cache retention | Balanced | Mixed workloads |
| 600 seconds (10 min) | Good cache retention | Higher idle cost | Interactive queries |
| 0 (never suspend) | Best cache retention | Highest cost | 24/7 workloads only |

### Warehouse Scheduling
```sql
-- Business hours warehouse management
CREATE TASK scale_up_morning
  SCHEDULE = 'USING CRON 0 8 * * 1-5 America/New_York'
AS
  ALTER WAREHOUSE analytics_wh SET
    WAREHOUSE_SIZE = 'LARGE'
    MIN_CLUSTER_COUNT = 2;

CREATE TASK scale_down_evening
  SCHEDULE = 'USING CRON 0 19 * * 1-5 America/New_York'
AS
  ALTER WAREHOUSE analytics_wh SET
    WAREHOUSE_SIZE = 'SMALL'
    MIN_CLUSTER_COUNT = 1;

CREATE TASK weekend_suspend
  SCHEDULE = 'USING CRON 0 20 * * 5 America/New_York'
AS
  ALTER WAREHOUSE analytics_wh SUSPEND;
```

### Workload Isolation
| Workload | Warehouse | Size | Scaling |
|----------|-----------|------|---------|
| ETL/ELT pipelines | etl_wh | Medium-Large | Single cluster |
| BI dashboards | bi_wh | Small-Medium | Multi-cluster (auto) |
| Ad-hoc analytics | adhoc_wh | XS-Small | Multi-cluster (auto) |
| Data science | ds_wh | Large-XL | Single cluster |
| Service accounts | svc_wh | XS-Small | Single cluster |

## Storage Management

### Storage Cost Components
| Component | Duration | User Accessible | Description |
|-----------|----------|----------------|-------------|
| Active storage | Indefinite | Yes | Current table data |
| Time Travel | 0-90 days | Yes | Historical data for recovery |
| Fail-safe | 7 days | No (Snowflake support) | Disaster recovery |
| Stage storage | Indefinite | Yes | Files in internal stages |

### Storage Optimization
```sql
-- Table storage analysis
SELECT table_catalog, table_schema, table_name,
       active_bytes/1024/1024/1024 AS active_gb,
       time_travel_bytes/1024/1024/1024 AS time_travel_gb,
       failsafe_bytes/1024/1024/1024 AS failsafe_gb,
       (active_bytes + time_travel_bytes + failsafe_bytes)/1024/1024/1024 AS total_gb
FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS
WHERE active_bytes > 0
ORDER BY total_gb DESC
LIMIT 20;

-- Stage storage
SELECT stage_name, SUM(stage_bytes)/1024/1024/1024 AS stage_gb
FROM SNOWFLAKE.ACCOUNT_USAGE.STAGE_STORAGE_USAGE_HISTORY
WHERE usage_date = CURRENT_DATE()
GROUP BY stage_name
ORDER BY stage_gb DESC;
```

### Transient vs Permanent Tables
| Property | Permanent | Transient | Temporary |
|----------|-----------|-----------|-----------|
| Time Travel | 0-90 days | 0-1 day | 0-1 day |
| Fail-safe | 7 days | None | None |
| Storage cost | Highest | Lower | Lowest (session-scoped) |
| Use case | Production data | ETL staging, temp data | Session-specific work |

```sql
-- Create transient table (no Fail-safe)
CREATE TRANSIENT TABLE staging_data (
  id INTEGER,
  data VARIANT,
  loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Set Time Travel to 0 for transient
ALTER TABLE staging_data SET DATA_RETENTION_TIME_IN_DAYS = 0;
```

### Data Lifecycle Management
```sql
-- Reduce Time Travel for non-critical tables
ALTER TABLE logs SET DATA_RETENTION_TIME_IN_DAYS = 1;

-- Clean up old stages
REMOVE @my_stage/old_data/;

-- Drop unused clones
DROP TABLE IF EXISTS dev_copy_customers;

-- Monitor storage trend
SELECT DATE_TRUNC('month', usage_date) AS month,
       AVG(storage_bytes + stage_bytes + failsafe_bytes)/1024/1024/1024/1024 AS avg_total_tb
FROM SNOWFLAKE.ACCOUNT_USAGE.STORAGE_USAGE
WHERE usage_date >= DATEADD('month', -12, CURRENT_DATE())
GROUP BY 1
ORDER BY 1;
```

## Cost Allocation

### Tag-Based Cost Attribution
```sql
-- Create cost center tag
CREATE TAG cost_center ALLOWED_VALUES 'engineering', 'analytics', 'finance', 'marketing';

-- Tag warehouses
ALTER WAREHOUSE eng_wh SET TAG cost_center = 'engineering';
ALTER WAREHOUSE analytics_wh SET TAG cost_center = 'analytics';

-- Query costs by tag
SELECT tag_value AS cost_center,
       SUM(credits_used) AS total_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY wmh
JOIN SNOWFLAKE.ACCOUNT_USAGE.TAG_REFERENCES tr
  ON wmh.warehouse_name = tr.object_name
  AND tr.tag_name = 'COST_CENTER'
WHERE wmh.start_time >= DATE_TRUNC('month', CURRENT_TIMESTAMP())
GROUP BY tag_value
ORDER BY total_credits DESC;
```
