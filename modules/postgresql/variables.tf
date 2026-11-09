variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "name_suffix" {
  type = string
}

variable "delegated_subnet_id" {
  type = string
}

variable "private_dns_zone_id" {
  type = string
}

variable "key_vault_id" {
  type = string
}

variable "administrator_login" {
  type = string
}

variable "database_name" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "B_Standard_B1ms"
}
