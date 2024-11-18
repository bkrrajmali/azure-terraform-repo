terraform {
  required_version = ">=1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=1.4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "77e8ed92-1ff2-49eb-8917-b8050644bfd6"
}
resource "random_string" "random" {
  length           = 16
  special          = false
  override_special = "/@£$"
  upper            = false
}
resource "azurerm_resource_group" "rg1" {
  name     = "my-rg1"
  location = "East US"
#   lifecycle {
#     prevent_destroy = true
#   }
}

resource "azurerm_virtual_network" "myvnet" {
  #name                = "myvnet-1"
  name                = "myvnet-2"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  lifecycle {
    create_before_destroy = true
  }
}