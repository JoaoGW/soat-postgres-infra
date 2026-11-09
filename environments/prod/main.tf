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
  environment         = "prod"
  location            = "brazilsouth"
  resource_group_name = data.terraform_remote_state.foundation.outputs.data_resource_group_name
  name_suffix         = var.resource_name_suffix
  delegated_subnet_id = data.terraform_remote_state.foundation.outputs.postgresql_subnet_id
  private_dns_zone_id = data.terraform_remote_state.foundation.outputs.postgresql_private_dns_zone_id
  key_vault_id        = data.terraform_remote_state.foundation.outputs.key_vault_id
  administrator_login = "soat_prod_admin"
  database_name       = "oficina_prod"
  sku_name            = var.postgresql_sku_name
}
