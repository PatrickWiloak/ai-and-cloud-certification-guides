# Dynamic Tables

**[📖 Dynamic Tables](https://docs.snowflake.com/en/user-guide/dynamic-tables-about)** - Dynamic table documentation

## Overview

This document covers dynamic tables in Snowflake, including architecture, target lag configuration, pipeline chaining, refresh mechanics, and comparison with alternative approaches. Dynamic tables represent Snowflake's declarative approach to data pipelines, replacing imperative task/stream patterns for many common transformation use cases.

## Architecture

### How Dynamic Tables Work
- Defined by a SQL query that specifies the desired result
- Snowflake automatically determines how to refresh the result
- Incremental refresh when possible, full refresh when needed
- Target lag specifies maximum acceptable data staleness
- Snowflake scheduler manages refresh timing automatically

**[📖 Dynamic Table Concepts](https://docs.snowflake.com/en/user-guide/dynamic-tables-about)** - Core concepts

### Target Lag
- Defines the maximum time the dynamic table can lag behind source data
- Snowflake schedules refreshes to meet the target lag
- Shorter target lag = more frequent refresh = higher cost
- Longer target lag = less frequent refresh = lower cost
- Minimum target lag: 1 minute (downstream) or specific time value

```sql
-- Target lag as time interval
CREATE DYNAMIC TABLE hourly_summary
  TARGET_LAG = '1 hour'
  WAREHOUSE = transform_wh
AS
  SELECT DATE_TRUNC('hour', event_time) AS hour,
         event_type,
         COUNT(*) AS event_count
  FROM raw_events
  GROUP BY 1, 2;

-- Target lag as DOWNSTREAM (matches consumers)
CREATE DYNAMIC TABLE intermediate_table
  TARGET_LAG = DOWNSTREAM
  WAREHOUSE = transform_wh
AS
  SELECT * FROM source_table WHERE is_valid = TRUE;
```

### DOWNSTREAM Target Lag
- Dynamic table refreshes only when a downstream dynamic table needs it
- Useful for intermediate pipeline stages
- Refresh frequency determined by the downstream consumer's target lag
- Avoids unnecessary refreshes when no consumer needs fresh data
- Cannot be set on the final (leaf) dynamic table in a chain

## Pipeline Chaining

### Multi-Stage Pipelines
```sql
-- Stage 1: Cleansing (triggered by downstream)
CREATE DYNAMIC TABLE clean_orders
  TARGET_LAG = DOWNSTREAM
  WAREHOUSE = transform_wh
AS
  SELECT order_id,
         TRIM(customer_name) AS customer_name,
         ABS(order_amount) AS order_amount,
         TO_DATE(order_date_str, 'YYYY-MM-DD') AS order_date
  FROM raw_orders
  WHERE order_id IS NOT NULL
    AND order_amount > 0;

-- Stage 2: Enrichment with joins (triggered by downstream)
CREATE DYNAMIC TABLE enriched_orders
  TARGET_LAG = DOWNSTREAM
  WAREHOUSE = transform_wh
AS
  SELECT o.order_id,
         o.customer_name,
         o.order_amount,
         o.order_date,
         c.customer_segment,
         c.region,
         p.product_category
  FROM clean_orders o
  JOIN dim_customers c ON o.customer_name = c.customer_name
  JOIN dim_products p ON o.product_id = p.product_id;

-- Stage 3: Aggregation (sets the refresh cadence)
CREATE DYNAMIC TABLE daily_sales_summary
  TARGET_LAG = '30 minutes'
  WAREHOUSE = transform_wh
AS
  SELECT order_date,
         region,
         product_category,
         customer_segment,
         COUNT(*) AS order_count,
         SUM(order_amount) AS total_revenue,
         AVG(order_amount) AS avg_order_value
  FROM enriched_orders
  GROUP BY 1, 2, 3, 4;
```

### Pipeline DAG Visualization
```
raw_orders (base table)
    |
    v
clean_orders (DOWNSTREAM lag)
    |
    v
enriched_orders (DOWNSTREAM lag) <-- dim_customers, dim_products
    |
    v
daily_sales_summary (30 minutes lag)  <-- drives refresh of entire chain
```

## Refresh Mechanics

### Incremental vs Full Refresh
- Snowflake automatically determines the optimal refresh strategy
- **Incremental:** Only processes changed data since last refresh
- **Full:** Recomputes entire result set from scratch
- Incremental is preferred but not always possible

### Operations That Support Incremental Refresh
| Operation | Incremental Support |
|-----------|-------------------|
| SELECT with filters | Yes |
| JOIN (inner, left, right) | Yes |
| GROUP BY / aggregation | Yes |
| UNION ALL | Yes |
| Window functions | Depends on complexity |
| UNION (with dedup) | Full refresh required |
| Non-deterministic functions | Full refresh required |
| Subqueries in WHERE | Depends on complexity |

**[📖 Incremental Refresh](https://docs.snowflake.com/en/user-guide/dynamic-tables-refresh)** - Refresh mechanics

### Monitoring Refresh
```sql
-- Refresh history
SELECT name, refresh_version, refresh_action,
       refresh_trigger, state,
       data_timestamp, refresh_start_time, refresh_end_time,
       DATEDIFF('second', refresh_start_time, refresh_end_time) AS duration_sec
FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLE_REFRESH_HISTORY(
  NAME => 'daily_sales_summary',
  DATA_TIMESTAMP_START => DATEADD('day', -1, CURRENT_TIMESTAMP())
))
ORDER BY refresh_start_time DESC;

-- Dynamic table graph (dependency visualization)
SELECT name, target_lag, refresh_mode, scheduling_state
FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLE_GRAPH_HISTORY());
```

### Refresh States
| State | Meaning |
|-------|---------|
| RUNNING | Refresh in progress |
| SUCCEEDED | Refresh completed successfully |
| FAILED | Refresh encountered an error |
| UPSTREAM_FAILED | Upstream dynamic table refresh failed |
| SKIPPED | Refresh skipped (no source changes) |

## Dynamic Tables vs Alternatives

### vs Tasks + Streams
| Aspect | Dynamic Tables | Tasks + Streams |
|--------|---------------|----------------|
| Definition style | Declarative (what) | Imperative (how) |
| Scheduling | Automatic (target lag) | Manual (CRON/interval) |
| Incremental logic | Automatic | Manual (stream consumption) |
| Error handling | Automatic retry | Custom logic needed |
| Complex DML | Limited (INSERT/SELECT) | Full (MERGE, multi-statement) |
| External calls | Not supported | Supported (stored procedures) |
| Debugging | Less transparent | More control and visibility |
| Maintenance | Lower | Higher |

### When to Use Dynamic Tables
- Standard SQL transformations (SELECT, JOIN, GROUP BY)
- Pipeline freshness defined by time-based SLA
- Desire for minimal pipeline maintenance
- No need for complex DML (MERGE, DELETE)
- No external API calls or side effects needed

### When to Use Tasks + Streams
- Complex CDC with MERGE operations
- Multi-statement transaction logic
- Integration with external systems
- Custom error handling and retry logic
- Non-SQL transformations (Snowpark stored procedures)
- Conditional execution based on complex criteria

### vs Materialized Views
| Aspect | Dynamic Tables | Materialized Views |
|--------|---------------|-------------------|
| Joins | Supported | Not supported (single table) |
| Complex SQL | Full SQL | Limited SQL |
| Refresh control | Target lag | Automatic on change |
| Optimizer rewrite | No | Yes (transparent substitution) |
| Chaining | Yes | No |
| Use case | Data pipelines | Query acceleration |

## Advanced Configuration

### Warehouse Selection
```sql
-- Separate warehouse for dynamic table refresh
CREATE WAREHOUSE dt_refresh_wh
  WAREHOUSE_SIZE = 'MEDIUM'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE;

CREATE DYNAMIC TABLE my_dt
  TARGET_LAG = '1 hour'
  WAREHOUSE = dt_refresh_wh
AS
  SELECT ...;
```

- Use dedicated warehouses for dynamic table refresh
- Size warehouse based on transformation complexity
- Short auto-suspend since refresh is periodic
- Separate from user query warehouses for workload isolation

### Altering Dynamic Tables
```sql
-- Change target lag
ALTER DYNAMIC TABLE daily_summary SET TARGET_LAG = '2 hours';

-- Change warehouse
ALTER DYNAMIC TABLE daily_summary SET WAREHOUSE = larger_wh;

-- Suspend refresh
ALTER DYNAMIC TABLE daily_summary SUSPEND;

-- Resume refresh
ALTER DYNAMIC TABLE daily_summary RESUME;

-- Force full refresh
ALTER DYNAMIC TABLE daily_summary REFRESH;
```

### Cost Management
```sql
-- Monitor dynamic table credit usage
SELECT start_time, end_time, table_name,
       credits_used, num_rows_inserted, num_rows_deleted
FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLE_REFRESH_HISTORY())
WHERE start_time >= DATEADD('day', -7, CURRENT_TIMESTAMP())
ORDER BY credits_used DESC;
```

- Credits consumed during refresh (warehouse compute)
- Shorter target lag = more refreshes = higher cost
- Use DOWNSTREAM lag for intermediate tables to minimize refreshes
- Monitor refresh frequency and duration for cost optimization
- Consider longer target lag for non-critical downstream consumers

## Best Practices

### Pipeline Design
1. **Layer your pipeline** - separate cleansing, enrichment, and aggregation
2. **Use DOWNSTREAM for intermediates** - let leaf nodes drive refresh cadence
3. **Right-size target lag** - match business SLA, not aspirational freshness
4. **Monitor refresh duration** - ensure refresh completes within target lag
5. **Test incrementally** - verify incremental refresh works for your SQL patterns

### Performance
1. **Warehouse sizing** - match to transformation complexity
2. **Minimize full refreshes** - use SQL patterns that support incremental
3. **Avoid non-deterministic functions** - they force full refresh
4. **Limit pipeline depth** - deep chains add cumulative lag
5. **Cluster output tables** - if downstream queries benefit from clustering
