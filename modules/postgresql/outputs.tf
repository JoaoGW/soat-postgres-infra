output "server_name" {
  value = azurerm_postgresql_flexible_server.this.name
}

output "server_id" {
  value = azurerm_postgresql_flexible_server.this.id
}

output "server_fqdn" {
  value = azurerm_postgresql_flexible_server.this.fqdn
}

output "database_name" {
  value = azurerm_postgresql_flexible_server_database.application.name
}

# Prefixo de conexão (sem o nome do banco) usado pelos ambientes para gravar no
# Key Vault a URL de cada banco de serviço. É sensível porque contém a senha.
output "connection_prefix" {
  value     = "postgresql://${var.administrator_login}:${urlencode(random_password.administrator.result)}@${azurerm_postgresql_flexible_server.this.fqdn}:5432"
  sensitive = true
}
