data "terraform_remote_state" "foundation" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.state_resource_group_name
    storage_account_name = var.state_storage_account_name
    container_name       = var.aks_state_container_name
    key                  = "foundation.tfstate"
    use_azuread_auth     = true
  }
}

module "postgresql" {
  source              = "../../modules/postgresql"
  environment         = "hml"
  location            = "brazilsouth"
  resource_group_name = data.terraform_remote_state.foundation.outputs.data_resource_group_name
  name_suffix         = var.resource_name_suffix
  delegated_subnet_id = data.terraform_remote_state.foundation.outputs.postgresql_subnet_id
  private_dns_zone_id = data.terraform_remote_state.foundation.outputs.postgresql_private_dns_zone_id
  key_vault_id        = data.terraform_remote_state.foundation.outputs.key_vault_id
  administrator_login = "soat_hml_admin"
  database_name       = "oficina_hml"
  sku_name            = var.postgresql_sku_name
}

# Fase 4: cada microsserviço relacional tem um banco próprio no servidor
# gerenciado. O OS mantém o banco legado e o banco da Saga; o Billing tem o seu.
# O Execution usa Cosmos DB (repositório soat-execution-service).
module "service_databases" {
  for_each = {
    os_saga = "os_saga_hml"
    billing = "billing_hml"
  }

  source        = "../../modules/database"
  server_id     = module.postgresql.server_id
  database_name = each.value
}

# URL de cada banco no Key Vault, lida pelo SecretProviderClass do serviço dono
# (`saga-database-url-<env>` no OS e `billing-database-url-<env>` no Billing).
resource "azurerm_key_vault_secret" "service_database_url" {
  for_each = {
    os_saga = "saga-database-url-hml"
    billing = "billing-database-url-hml"
  }

  name         = each.value
  value        = "${module.postgresql.connection_prefix}/${module.service_databases[each.key].database_name}?sslmode=require"
  key_vault_id = data.terraform_remote_state.foundation.outputs.key_vault_id
  content_type = "application/vnd.soat.database-url"
}
