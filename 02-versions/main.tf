terraform {
  required_version = ">=1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=1.4.0"
      #version = "4.9.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "azurerm" {
    features {}
  # Configuration options
  subscription_id = "77e8ed92-1ff2-49eb-8917-b8050644bfd6"

}
resource "azurerm_resource_group" "rg1" {
  # This is Resource Group
  /* This is multiline
    comment for terraform */
  name     = "my-rg1"
  location = "East US"
}

resource "random_string" "random" {
  length           = 16
  special          = false
  override_special = "/@£$"
  upper            = false
}

resource "azurerm_storage_account" "demosa" {
  name                     = "demosa${random_string.random.id}"
  resource_group_name      = azurerm_resource_group.rg1.name
  location                 = azurerm_resource_group.rg1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  account_encryption_source = "Microsoft.Storage"
}