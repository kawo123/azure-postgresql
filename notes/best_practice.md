# Best Practices

## General

- Applications should handle transient error (network hiccup, upgrade) with exponential backoff ([ref](https://docs.microsoft.com/en-us/azure/postgresql/concepts-connectivity))
- Leverage query caching (e.g. Pgpool) for read intensive application ([ref](https://techcommunity.microsoft.com/t5/Azure-Database-for-PostgreSQL/Improve-Performance-of-Read-Intensive-Workloads-on-Azure-DB-for/ba-p/743860))
- Leverage connection pooling when application is interacting with APG (e.g. [PgBouncer](https://wiki.postgresql.org/wiki/PgBouncer), Pgpool)
  - In PostgreSQL, establishing a connection is an expensive operation requiring forking of the OS process and a new memory allocation for the connection. Connection pooling helps by reusing existing connections ([ref](https://azure.microsoft.com/en-us/blog/performance-best-practices-for-using-azure-database-for-postgresql-connection-pooling/))
- Enable Autovacuum on update/delete-intensive workloads ([ref](https://docs.microsoft.com/en-us/azure/postgresql/howto-optimize-autovacuum))
  - Improves I/O
- If bulk insert is slow ([ref](https://docs.microsoft.com/en-us/azure/postgresql/howto-optimize-bulk-inserts))
  - Use unlogged table for optimize (faster but inserts are not written into transaction log)
  - After bulk insert complete, ALTER table to "logged" so inserts are durable

## Azure Database for PostgreSQL: Single Server

- Always enable "replication support" at server provision time because enabling it requires server restart
- Enable accelerated networking on Azure VM connecting to Azure PG
- If applicable, always enable service endpoint before Vnet is in production because enabling service endpoint will cause small downtime in Vnet-subnet
- Favor geo-redundant backup storage over locally redundant (but understand cost)
  - Switching backup options require instantiation of new APG server
- Enable monitoring! Favor query store over pg_stat_statements
- Favor Vnet firewall rule over AzurePG firewall rule
- Always enable ATP for intelligent threat detection
