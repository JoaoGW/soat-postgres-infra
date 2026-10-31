output "database_id" {
  value = azurerm_postgresql_flexible_server_database.this.id
}

output "database_name" {
  value = azurerm_postgresql_flexible_server_database.this.name
}
