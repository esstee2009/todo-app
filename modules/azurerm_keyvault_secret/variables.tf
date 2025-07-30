variable "key_vault_name" {
  description = "The name of the Key Vault."
  type        = string
}
variable "resource_group_name" {
  description = "The name of the resource group where the Key Vault is located."
  type        = string
}
variable "secret_name" {
  description = "The name of the Key Vault secret."
  type        = string  
}
variable "secret_value" {
  description = "The value of the Key Vault secret."
  type        = string
}