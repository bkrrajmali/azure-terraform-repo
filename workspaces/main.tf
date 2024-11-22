terraform {
  required_version = ">=1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=4.0"
    }
    random = {
        source = "hashicorp/random"
        version = ">=3.0"
    }
  }
  backend "azurerm" {
    resource_group_name = "terraform-backend"
    storage_account_name = "demoazurencplstorage"
    container_name = "terraformtfstate1"
    key = "terraform.tfstate"
  }

  
}
provider "azurerm" {
  features {}
  subscription_id = "77e8ed92-1ff2-49eb-8917-b8050644bfd6"
}

variable "vnet_name" {}
variable "address_space" {}
variable "subnet_name" {}
variable "subnet_address" {}
variable "location" {}
variable "resource_group_name" {}

resource "azurerm_resource_group" "myrg" {
  name = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name = var.vnet_name
  address_space =  var.address_space
  location = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

resource "azurerm_subnet" "mysubnet" {
  name = var.subnet_name
  resource_group_name = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes =  var.subnet_address
}