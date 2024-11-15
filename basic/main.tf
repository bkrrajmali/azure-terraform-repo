terraform {
  required_version = ">=1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "1.40.0"
    }
    random = {
        source = "hashicorp/random"
        version = ">=3.0"
    }
  }
}

provider "azurerm" {
    features {}
    subscription_id = "XXXX"
    client_id = "SSSSSSS"
    client_secret = "DDDDDD"
    tenant_id = "XXSSSSS"
  # Configuration options
}

resource "azurerm_resource_group" "demorg" {
  name = "demorg"
  location = "East US"
}

resource "random_string" "demorandom" {
  length           = 16
  special          = false
  override_special = "/@£$"
  upper            = false
}

resource "azurerm_storage_account" "demosa" {
  name                     = "demosa${random_string.demorandom.id}"
  resource_group_name      = azurerm_resource_group.demorg.name
  location                 = azurerm_resource_group.demorg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  account_encryption_source = "Microsoft.Storage"
}