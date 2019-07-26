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

- Thru Portal, allow connection from your client to APG
  - Navigate to "azure-pg-pgsrv" -> "Connection Security" -> Click "Add Client IP" -> Click "Save"

- In `./database`:
  - Run `psql -f pagila.sql -h <apg-server-name>.postgres.database.azure.com -U <apg-username>@<apg-server-name> -d db` to populdate the database


## Next Steps

- PostgreSQL best practice

## Gotchas

- Cannot disable all table triggers in APG (`DISABLE TRIGGER ALL`)
  - "The PostgreSQL superuser attribute is assigned to the azure_superuser, which belongs to the managed service. You do not have access to this role." [reference](https://docs.microsoft.com/en-us/azure/postgresql/concepts-servers#managing-your-server)

- Cannot run SQL scripts with `COPY FROM stdin`
  - Symptom: error "SQL Error [08P01]: ERROR: unexpected message type 0x50 during COPY from stdin" when running SQL script using GUI
  - Cause: `COPY FROM stdin` statement is not supported through DBeaver
  - Reference: https://stackoverflow.com/questions/32271378/in-postgresql-how-to-insert-data-with-copy-command

- Terraform destroy for APG DB sometimes fail if there is active DB connection (DBeaver)
  - Symptom: error "Internal Server Error" when running `terraform destroy` for APG
  - Cause: N/A
