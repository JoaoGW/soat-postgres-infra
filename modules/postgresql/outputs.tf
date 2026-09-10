output "server_name" {
  value = azurerm_postgresql_flexible_server.this.name
}

output "server_fqdn" {
  value = azurerm_postgresql_flexible_server.this.fqdn
}

output "database_name" {
  value = azurerm_postgresql_flexible_server_database.application.name
}
