---
type: skill
id: supabase-postgres-best-practices
last_updated: 2026-06-25
source: ~/.config/opencode/skills/supabase-postgres-best-practices/SKILL.md
category: database
projects: [global]
---

# supabase-postgres-best-practices Skill

**Purpose:** Postgres performance optimization and best practices from Supabase. Use when writing, reviewing, or optimizing Postgres queries, schema designs, or database configurations.

## When to Apply
- Writing SQL queries or designing schemas
- Implementing indexes or query optimization
- Reviewing database performance issues
- Configuring connection pooling or scaling
- Optimizing for Postgres-specific features
- Working with Row-Level Security (RLS)

## Rule Categories by Priority

| Priority | Category | Impact | Prefix |
|----------|----------|--------|--------|
| 1 | Query Performance | CRITICAL | `query-` |
| 2 | Connection Management | CRITICAL | `conn-` |
| 3 | Security & RLS | CRITICAL | `security-` |
| 4 | Schema Design | HIGH | `schema-` |
| 5 | Concurrency & Locking | MEDIUM-HIGH | `lock-` |
| 6 | Data Access Patterns | MEDIUM | `data-` |
| 7 | Monitoring & Diagnostics | LOW-MEDIUM | `monitor-` |
| 8 | Advanced Features | LOW | `advanced-` |

## Key Rules

### Query Performance
- Index columns in `WHERE`, `JOIN`, `ORDER BY`, `GROUP BY`
- Use `EXPLAIN ANALYZE` to identify sequential scans
- Avoid `SELECT *` — fetch only needed columns
- Use `LIMIT` with pagination
- Prefer `EXISTS` over `IN` for subquery existence
- Use `BETWEEN`/range queries with range indexes

### Connection Management
- Use PgBouncer (transaction mode) pooling
- Minimize idle connections
- Proper `DISCONNECT` to avoid leaks
- Configure `max_connections` for available memory

### Security & RLS
- RLS for multi-tenant data isolation
- Write policies strict as possible — deny by default
- Avoid RLS on high write-throughput tables without planning
- Use `SECURITY DEFINER` functions sparingly

### Schema Design
- Normalize but denormalize for read performance where measured
- Appropriate data types (`timestamptz` over `varchar` for datetimes)
- `CHECK` constraints for data integrity
- `GENERATED` columns for computed values
- Partition large tables (time-based or key-based)

### Concurrency & Locking
- `NOWAIT` or `SKIP LOCKED` to avoid blocking
- Keep transactions short
- Avoid row-level locking in hot paths

### Data Access Patterns
- Materialized views for expensive aggregations
- Query caching strategy (app-level or Supabase)
- Batch inserts with multi-row `VALUES`
- `COPY` for bulk loads instead of individual inserts

### Monitoring & Diagnostics
- Enable `pg_stat_statements`
- Cache hit ratio target > 99%
- Alerts for long-running queries (> 5s)

### Advanced Features
- `FULL TEXT SEARCH` over `LIKE '%term%'`
- `BRIN` indexes for large append-only tables
- `citext` for case-insensitive lookups
- `uuid-ossp` or `pgcrypto` extensions when needed

## Verification
- `EXPLAIN ANALYZE` for sequential scans
- `pg_stat_activity` for connection pool saturation
- RLS policies with `EXPLAIN (ANALYZE, BUFFERS)`
- `pg_stat_user_indexes` for unused indexes
- Confirm cache hit ratio > 99%

## References
- https://www.postgresql.org/docs/current/
- https://supabase.com/docs
- https://wiki.postgresql.org/wiki/Performance_Optimization
- https://supabase.com/docs/guides/database/overview
- https://supabase.com/docs/guides/auth/row-level-security

(End of file - total 76 lines)