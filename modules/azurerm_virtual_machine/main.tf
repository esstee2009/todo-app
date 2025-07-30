resource "azurerm_subnet_network_security_group_association" "nsg_security" {
  subnet_id                 = data.azurerm_subnet.frontend_subnet.id
  network_security_group_id = data.azurerm_network_security_group.securitygroup.id
}

resource "azurerm_network_interface" "nic" {
  name                = var.name_nic
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.frontend_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = data.azurerm_public_ip.frontend_pip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.vm_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  
  admin_username                  = data.azurerm_key_vault_secret.vm-username.value
  # The admin password should be stored securely, e.g., in Azure Key Vault
  admin_password                  = data.azurerm_key_vault_secret.vm-password.value
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher #Publisher ID from Azure Marketplace
    offer     = var.image_offer     #Product ID from Azure Marketplace
    sku       = var.image_sku       #Plan ID from Azure Marketplace
    version   = var.image_version
  }
  
custom_data = base64encode(<<-EOF
#!/bin/bash
apt-get update -y
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx
EOF
)
}