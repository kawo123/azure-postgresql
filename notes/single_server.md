# Azure Database for PostgreSQL: Single Server

### Server

- parent resource for databases; provide namespace and management policies (login, users, firewall, roles, configurations, etc) for databases ([ref](https://docs.microsoft.com/en-us/azure/postgresql/concepts-servers))
- Allows for PG server configurations (subset of local PG instances)

### Database

- Default databases: postgres, azure_maintenance (db for management, no user access), azure_sys (db for query store when enabled)

### Pricing tier

- basic, general purpose, memory optimized; inclusive pay-as-you-go pricing

### Scaling

- When free storage reaches 5%, server is set to read-only
- [Storage auto-grow](https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers#storage-auto-grow): feature that increases storage by 5% when the free storage falls below 5%
- Can scale any resources during lifetime of server except pricing tier (to/from Basic) with < 1 minute downtime ([ref](https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers#scale-resources))

### Security

- By default, firewall prevents all access to AzurePG, FW supports whitelisting of IP ranges ([ref](https://docs.microsoft.com/en-us/azure/postgresql/concepts-firewall-rules#firewall-overview))
- Enforcement of SSL connections is enabled by default
- [Advanced Threat Protection](https://docs.microsoft.com/en-us/azure/postgresql/concepts-data-access-and-security-threat-protection) (public preview): security alerts on anomalous activities, integrates with Azure Security Center which includes details of suspicious activities and recommended action
  - Pricing is defined under [Azure Security Center](https://azure.microsoft.com/en-us/pricing/details/security-center/)
- Does NOT have integration with AAD yet ([feedback](https://feedback.azure.com/forums/597976-azure-database-for-postgresql/suggestions/33700825-add-ability-to-authenticate-against-azure-active-d))

### Business continuity

- Built-in high availability with no additional cost (99.99% SLA)
- Automatic backups and point-in-time-restore from 7 to 35 days ([ref](https://docs.microsoft.com/en-us/azure/postgresql/concepts-backup#backups))
  - Point-in-time restore creates new APG server in the same resource group and region
- Cross region read replicas in public preview ([ref](https://docs.microsoft.com/en-us/azure/postgresql/concepts-read-replicas))
- Major version upgrade NOT supported natively ([ref](https://docs.microsoft.com/en-us/azure/postgresql/concepts-limits#server-version-upgrades))
- [APG geo-restore](https://docs.microsoft.com/en-us/azure/postgresql/concepts-business-continuity#recover-from-an-azure-regional-data-center-outage) feature that restores server using geo-redundant backup (paired region)
  - Geo-restore can create new APG server in any region

### Monitoring & tuning

- Metrics (CPU, Mem, storage, etc.), Server logs
- [Query store](https://docs.microsoft.com/en-us/azure/postgresql/concepts-query-store): stores query execution statistics (runtime stats store), wait stat information
- [Query performance insight](https://docs.microsoft.com/en-us/azure/postgresql/concepts-query-performance-insight): UI for surfacing query store data; visualization and key info from query store
- [Performance recommendation](https://docs.microsoft.com/en-us/azure/postgresql/concepts-performance-recommendations): CREATE INDEX & DROP INDEX recommendations

### Development

- Open source connection libraries supported (Python, Node.js, Java, etc.)
- Handle transient error (network hiccup, upgrade) with exponential backoff ([ref](https://docs.microsoft.com/en-us/azure/postgresql/concepts-connectivity))

### Replication

- In-region read replica (async replication) for improving and scaling read-intensive workload ([ref](https://docs.microsoft.com/en-us/azure/postgresql/concepts-read-replicas))
- Uses PG physical replication (as opposed to logical replication)

### Migration

- Methods
  - Pg_dump and pg_restore with dump file ([ref](https://docs.microsoft.com/en-us/azure/postgresql/howto-migrate-using-dump-and-restore))
  - Pg_dump and psql with SQL script ([ref](https://docs.microsoft.com/en-us/azure/postgresql/howto-migrate-using-export-and-import))
  - [Online migration using DMS](https://docs.microsoft.com/en-us/azure/postgresql/howto-migrate-online) ([tutorial](https://docs.microsoft.com/en-us/azure/dms/tutorial-postgresql-azure-postgresql-online))
    - [Known issues and workarounds](https://docs.microsoft.com/en-us/azure/dms/known-issues-azure-postgresql-online) for Online APG migration
    - DMS service needs to have access to the source and destination databases
    - DMS currently doesn't support schema replication for PostgreSQL. Schema replication has to be done manually
    - The version needs to be supported and match for the source, DMS and Azure target. You are restricted to the supported versions of Azure database for PostgreSQL as well as DMS supported versions for PostgreSQL source database.
    - DMS execution uses a "replication" connection to the database. This requires both connections to be facilitated in the pg_hba.conf on-premises configuration file.
    - DMS establishes a replication which takes up a replication slot.  After the move if you want to delete the database you will need to remove this replication slot.
