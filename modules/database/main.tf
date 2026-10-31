resource "azurerm_postgresql_flexible_server_database" "this" {
  name      = var.database_name
  server_id = var.server_id
  charset   = "UTF8"
  collation = "en_US.utf8"
}
