module "resource_group" {
  source                  = "../modules/azurerm_resource_group"
  resource_group_name     = "rg-todoapp"
  resource_group_location = "uk south"
}
module "virtual_network" {
  source     = "../modules/azurerm_virtual_network"
  depends_on = [module.resource_group]

  resource_group_name      = "rg-todoapp"
  virtual_network_name     = "vnet"
  virtual_network_location = "uk south"
  address_space            = ["10.0.0.0/16"]
}

module "frontend_subnet" {
  source     = "../modules/azurerm_subnet"
  depends_on = [module.virtual_network]

  resource_group_name  = "rg-todoapp"
  virtual_network_name = "vnet"
  frontend_subnet      = "frontend_subnet"
  address_prefixes     = ["10.0.1.0/24"]
}

# module "backend_subnet" {
#   source     = "../modules/azurerm_subnet"
#   depends_on = [module.virtual_network]

#   resource_group_name  = "rg-todoapp"
#   virtual_network_name = "vnet"
#   frontend_subnet      = "backend_subnet"
#   address_prefixes     = ["10.0.2.0/24"]
# }

module "frontend_pip" {
  source     = "../modules/azurerm_public_ip"
  depends_on = [module.resource_group]

  resource_group_name = "rg-todoapp"
  frontend_ip_name    = "pip_frontend"
  location            = "uk south"
  allocation_method   = "Static"
}

module "nsg" {
  source              = "../modules/azurerm_nsg"
  depends_on          = [module.resource_group]
  name_nsg            = "nsg"
  location            = "uk south"
  resource_group_name = "rg-todoapp"
}

module "frontend_vm" {
  source     = "../modules/azurerm_virtual_machine"
  depends_on = [module.resource_group, module.frontend_subnet, module.frontend_pip]

  resource_group_name  = "rg-todoapp"
  location             = "uk south"
  vm_name              = "frontend-vm"
  vm_size              = "Standard_B1s"
  admin_username       = "stadmin"
  image_publisher      = "Canonical"
  image_offer          = "0001-com-ubuntu-server-jammy"
  image_sku            = "22_04-lts-gen2"
  image_version        = "latest"
  name_nic             = "nic-frontend"
  frontend_ip_name     = "pip_frontend"
  virtual_network_name = "vnet"
  frontend_subnet      = "frontend_subnet"
  key_vault_name       = "st-vault04"
  username_secret_name = "vm-username"
  password_secret_name = "vm-password"
  name_securitygroup   = "nsg"
}

# module "public_ip_backend" {
#   source              = "../modules/azurerm_public_ip"
#   backend_ip_name     = "pip_backtend"
#   resource_group_name = "rg-todoapp"
#   location            = "uk south"
#   allocation_method   = "Static"
# }

# module "backend_vm" {
#   depends_on = [module.backend_subnet]
#   source     = "../modules/azurerm_virtual_machine"

#   resource_group_name  = "rg-todoapp"
#   location             = "uk south"
#   vm_name              = "vm-backend"
#   vm_size              = "Standard_B1s"
#   admin_username       = "devopsadmin"
#   admin_password       = "P@ssw0rd1234!"
#   image_publisher      = "Canonical"
#   image_offer          = "0001-com-ubuntu-server-focal"
#   image_skuer            = "20_04-lts"
#   image_vsion        = "latest"
#   name_nic             = "nic-backend"
#   virtual_network_name = "vnet"
#   backend_subnet      = "backend_subnet"
#   backend_ip_name     = "pip_backtend"
# }

module "sql_server" {
  source                 = "../modules/azurerm_sql_server"
  sql_server_name        = "st-sqlserver"
  resource_group_name    = "rg-todoapp"
  location               = "uk south"
  administrator_login    = "sqladmin"
  administrator_password = "P@ssw0rd1234!"
}

module "sql_database" {
  depends_on          = [module.sql_server]
  source              = "../modules/azurerm_sql_database"
  sql_server_name     = "st-sqlserver"
  resource_group_name = "rg-todoapp"
  sql_database_name   = "tododb"
}

module "key_vault" {
  depends_on          = [module.resource_group]
  source              = "../modules/azurerm_keyvault"
  key_vault_name      = "st-vault04"
  location            = "uk south"
  resource_group_name = "rg-todoapp"
}

module "vm_password" {
  source              = "../modules/azurerm_keyvault_secret"
  depends_on          = [module.key_vault]
  key_vault_name      = "st-vault04"
  resource_group_name = "rg-todoapp"
  secret_name         = "vm-password"
  secret_value        = "P@ssword1234!"
}

module "vm_username" {
  source              = "../modules/azurerm_keyvault_secret"
  depends_on          = [module.key_vault]
  key_vault_name      = "st-vault04"
  resource_group_name = "rg-todoapp"
  secret_name         = "vm-username"
  secret_value        = "samit"
}