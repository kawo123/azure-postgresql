# Azure PostgreSQL

This project demostrates best practices on administrating Azure Databases for PostgreSQL

## Pre-requisite
- [Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)
- [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download?view=sql-server-2017)
  - Install PostgreSQL extension in Azure Data Studio

## Getting Started

- Clone the repository
- In `./terraform`:
  - Run `terraform plan -out=out.tfplan`
  - Run `terraform apply out.tfplan`