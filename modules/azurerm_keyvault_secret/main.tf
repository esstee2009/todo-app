#iska matlab hai ke key vault already exist karta hai, aur hum uski info sirf read kar rahe hain, banana nahi.
data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}
#Yeh naya secret existing key vault mein create ho raha hai, uska ID hum data block se le rahe hain.
resource "azurerm_key_vault_secret" "secret" { #pehle password phir username bunta hai
  name         = var.secret_name
  value        = var.secret_value
 key_vault_id = data.azurerm_key_vault.kv.id
}
