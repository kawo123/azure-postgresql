output "server_name" {
  description = "The name of the PostgreSQL server"
  value       = "${azurerm_postgresql_server.pgsrv.name}"
}

output "server_fqdn" {
  description = "The fully qualified domain name (FQDN) of the PostgreSQL server"
  value       = "${azurerm_postgresql_server.pgsrv.fqdn}"
}

output "administrator_user" {
  value = "${azurerm_postgresql_server.pgsrv.administrator_login}"
}

output "db_name" {
  value = "${azurerm_postgresql_database.db.name}"
}