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
  count    = 3
  name     = "my-rg1-0${count.index}"
  location = "East US"
}

