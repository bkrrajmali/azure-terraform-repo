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

resource "azurerm_virtual_network" "myvnet" {
  name = "myvent-1"
  address_space = ["10.0.0.0/16"]
  location = azurerm_resource_group.demorg.location
  resource_group_name = azurerm_resource_group.demorg.name
}

resource "azurerm_subnet" "mysubnet" {
  name = "mysubnet1"
  resource_group_name = azurerm_resource_group.demorg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes = ["10.10.0.0/24"]
}

resource "azurerm_public_ip" "name" {
  
}

resource "azurerm_network_interface" "name" {
  
}

resource "azurerm_network_security_group" "name" {
  
}