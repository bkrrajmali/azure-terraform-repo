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

resource "random_string" "random" {
  length           = 16
  special          = false
  override_special = "/@£$"
  upper            = false
}

resource "azurerm_resource_group" "rg1" {
  # This is Resource Group
  /* This is multiline
    comment for terraform */
  name     = "my-rg1"
  location = "East US"
}

resource "azurerm_virtual_network" "myvnet" {
  name = "myvnet-2"
  address_space = [ "10.0.0.0/16" ]
  location = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_subnet" "mysubnet" {
  name = "mysubnet-1"
  resource_group_name = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes = ["10.0.1.0/24"]

}

resource "azurerm_public_ip" "mypublicip" {
 depends_on = [ azurerm_virtual_network.myvnet, azurerm_subnet.mysubnet ]
  name = "mypublic-ip-1"
  resource_group_name = azurerm_resource_group.rg1.name
  location = azurerm_resource_group.rg1.location
  allocation_method = "Static"

}

resource "azurerm_network_interface" "mynic1" {
  name = "vm1-nic"
  location = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip.id
  }
}