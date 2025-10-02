terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.34.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tf-rg24-infra"
    storage_account_name = "tfst24infra"
    container_name       = "infra-container"
    key                  = "infra24"
  }
 }
provider "azurerm" {
    features {}
    subscription_id = "bc524287-f28f-43cf-9bc7-37559e1c0887"
}