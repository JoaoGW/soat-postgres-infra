resource "random_password" "administrator" {
  length  = 32
  special = true
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                          = "psql-soat-${var.environment}-${var.name_suffix}"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "16"
  delegated_subnet_id           = var.delegated_subnet_id
  private_dns_zone_id           = var.private_dns_zone_id
  administrator_login           = var.administrator_login
  administrator_password        = random_password.administrator.result
  zone                          = "1"
  storage_mb                    = 32768
  sku_name                      = var.sku_name
  backup_retention_days         = 7
  geo_redundant_backup_enabled  = false
  public_network_access_enabled = false
}

resource "azurerm_postgresql_flexible_server_database" "application" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.this.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "azurerm_postgresql_flexible_server_configuration" "require_tls" {
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.this.id
  value     = "on"
}

resource "azurerm_postgresql_flexible_server_configuration" "audit_logging" {
  for_each = toset([
    "log_connections",
    "log_disconnections",
    "log_checkpoints",
    "logfiles.retention_days",
  ])

  name      = each.value
  server_id = azurerm_postgresql_flexible_server.this.id
  value     = each.value == "logfiles.retention_days" ? "7" : "on"
}

resource "azurerm_postgresql_flexible_server_configuration" "connection_throttle" {
  name      = "connection_throttle.enable"
  server_id = azurerm_postgresql_flexible_server.this.id
  value     = "on"
}

locals {
  database_url = "postgresql://${var.administrator_login}:${urlencode(random_password.administrator.result)}@${azurerm_postgresql_flexible_server.this.fqdn}:5432/${azurerm_postgresql_flexible_server_database.application.name}?sslmode=require"
}

resource "azurerm_key_vault_secret" "database_url" {
  name         = "database-url-${var.environment}"
  value        = local.database_url
  key_vault_id = var.key_vault_id
  content_type = "application/vnd.soat.database-url"

  depends_on = [azurerm_postgresql_flexible_server_configuration.require_tls]
}
