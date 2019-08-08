# Azure PostgreSQL (APG)

This project demostrates best practices on administrating Azure Databases for PostgreSQL

## Pre-requisite

- [Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)
- [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download?view=sql-server-2017)
  - Install PostgreSQL extension in Azure Data Studio
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
    - Navigate to "azure-pg-pgsrv" -> "Connection Security" -> Click "Add Client IP" -> Click "Save"
  - Enable Query Store
    - Navigate to "azure-pg-pgsrv" -> "Server Parameters" -> Search for `pg_qs.query_capture_mode` -> Select "TOP"
    - Navigate to "azure-pg-pgsrv" -> "Server Parameters" -> Search for `pgms_wait_sampling.query_capture_mode` -> Select "ALL"

- In `./database`:
  - For `pagila` database, run `psql -f pagila.sql -h <apg-server-name>.postgres.database.azure.com -U <apg-username>@<apg-server-name> -d db` to populate the database
  - For `dvdrental` database, run `pg_restore -c -h <apg-server-name>.postgres.database.azure.com -U <apg-username>@<apg-server-name> -d dvdrental -v "./dvdrental.tar" -W`

- In `./`:
  - Execute `pg_sample.sql` using `psql` or other PostgreSQL client (e.g. DBeaver)
  - Execute `azurepg.sql` using `psql` or other PostgreSQL client (e.g. DBeaver)

## Next Steps

- APG best practice

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
