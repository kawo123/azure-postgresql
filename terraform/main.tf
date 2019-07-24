provider "azurerm" {
    version = "~>1.5"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"
}

resource "azurerm_postgresql_server" "pgsrv" {
  name                = "${var.prefix}-pgsrv"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  sku {
    name     = "B_Gen5_1"
    capacity = 1
    tier     = "Basic"
    family   = "Gen5"
  }

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = "sqladmin"
  administrator_login_password = "Pa$$w0rd"
  version                      = "10.2"
  ssl_enforcement              = "Enabled"
}

resource "azurerm_postgresql_database" "airlinedb" {
  name                = "airlinedb"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  server_name         = "${azurerm_postgresql_server.pgsrv.name}"
  charset             = "UTF8"
  collation           = "English_United States.1252"
}