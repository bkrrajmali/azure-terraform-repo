terraform {
  required_version = ">=1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=2.0"
    }
    random = {
        source = "hashicorp/random"
        version = ">=3.0"
    }
  }
  backend "azurerm" {
    resource_group_name = "BalaRG"
    storage_account_name = "demoazurencplstorage"
    container_name = "terraformtfstatefile"
    key = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "77e8ed92-1ff2-49eb-8917-b8050644bfd6"
}

resource "azurerm_resource_group" "samplerg" {
  name = "samplerg"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet1" {
  name = "myvnet1"
  address_space = [ "192.168.0.0/16" ]
  location = azurerm_resource_group.samplerg.location
  resource_group_name = azurerm_resource_group.samplerg.name
}