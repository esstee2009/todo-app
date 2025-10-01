terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.34.0"
    }
  }
terraform {
  backend "azurerm" {
    resource_group_name  = "tf-rg24-infra"
    storage_account_name = "tf-st24-infra"
    container_name       = "infra-container"
    key                  = "infra24"
  }
 }
}

provider "azurerm" {
    features {}
    subscription_id = "7f243234-0218-497f-9999-f87959687237"
}
