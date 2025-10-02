resource "azurerm_public_ip" "frontend_pip" {
  name                = var.frontend_ip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.allocation_method
  sku                 = var.sku
  tags                = var.tags
}
