# Azure PostgreSQL (APG)

This project demostrates best practices on administrating Azure Databases for PostgreSQL. For more information, please see [APG Single Server](./notes/single_server.md), [APG Hyperscale](./notes/hyperscale.md), and [APG Best Practice](./notes/best_practice.md). 

## Pre-requisite

- [Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)
- [DBeaver](https://dbeaver.io/)
- [psql](https://www.postgresql.org/docs/10/app-psql.html)

## Getting Started

- Clone the repository

- In `./terraform`:
  - Change `prefix` in `variables.tf` because APG server name has to be globally unique
  - Run `terraform plan -out=out.tfplan`
  - Run `terraform apply out.tfplan`
  - Note the outputs of `terraform apply`

- Through Portal:
  - Allow connection from your client to APG
    - Navigate to "azure-pg-pgsrv" -> Select "Connection Security" -> Click "Add Client IP" -> Click "Save"
  - Enable Query Store
    - Navigate to "azure-pg-pgsrv" -> Select "Server Parameters" -> Search for `pg_qs.query_capture_mode` -> Select "TOP"
    - Navigate to "azure-pg-pgsrv" -> Select "Server Parameters" -> Search for `pgms_wait_sampling.query_capture_mode` -> Select "ALL"

- In `./database`:
  - For `pagila` database, run `psql -f pagila.sql -h <apg-server-name>.postgres.database.azure.com -U <apg-username>@<apg-server-name> -d pagila` to populate the database
  - For `dvdrental` database, run `pg_restore -c -h <apg-server-name>.postgres.database.azure.com -U <apg-username>@<apg-server-name> -d dvdrental -v "./dvdrental.tar" -W`

- In `./`:
  - Execute `pg_sample.sql` using `psql` or other PostgreSQL client (e.g. DBeaver) against `dvdrental` database
  - Execute `azurepg.sql` using `psql` or other PostgreSQL client (e.g. DBeaver) against `azure_sys` database

- Through Portal:
  - Access "Query Performance Insight"
    - Navigate to "azure-pg-pgsrv" -> Select "Query Performance Insight" -> Select "Long running queries" or "Wait statistics" to view appropriate metrics
  - Access "Performance Recommendations"
    - Navigate to "azure-pg-pgsrv" -> Select "Performance Recommendations" -> Click "Analyze" -> Select desired database for analysis
  - Enable "Advanced Threat Protection"
    - Navigate to "azure-pg-pgsrv" -> Select "Advanced Threat Protection (Preview)" -> Switch "Advanced Threat Protection" to "On" -> Enter email addresses (optional) -> Click "Save"

## Gotchas

- Cannot disable all table triggers in APG (`DISABLE TRIGGER ALL`) through JDBC
  - "The PostgreSQL superuser attribute is assigned to the azure_superuser, which belongs to the managed service. You do not have access to this role." [reference](https://docs.microsoft.com/en-us/azure/postgresql/concepts-servers#managing-your-server)

- Cannot run SQL scripts with `COPY FROM stdin`
  - Symptom: error "SQL Error [08P01]: ERROR: unexpected message type 0x50 during COPY from stdin" when running SQL script using GUI
  - Cause: `COPY FROM stdin` statement is not supported through DBeaver
  - Reference: https://stackoverflow.com/questions/32271378/in-postgresql-how-to-insert-data-with-copy-command

- Terraform destroy for APG DB sometimes fail if there is active DB connection (DBeaver)
  - Symptom: error "Internal Server Error" when running `terraform destroy` for APG
  - Cause: N/A

---

### PLEASE NOTE FOR THE ENTIRETY OF THIS REPOSITORY AND ALL ASSETS

1. No warranties or guarantees are made or implied.
2. All assets here are provided by me "as is". Use at your own risk. Validate before use.
3. I am not representing my employer with these assets, and my employer assumes no liability whatsoever, and will not provide support, for any use of these assets.
4. Use of the assets in this repo in your Azure environment may or will incur Azure usage and charges. You are completely responsible for monitoring and managing your Azure usage.

---

Unless otherwise noted, all assets here are authored by me. Feel free to examine, learn from, comment, and re-use (subject to the above) as needed and without intellectual property restrictions.

If anything here helps you, attribution and/or a quick note is much appreciated.
