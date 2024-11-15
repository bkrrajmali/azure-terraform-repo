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
  name = "myvnet-1"
  address_space = ["10.0.0.0/16"]
  location = azurerm_resource_group.demorg.location
  resource_group_name = azurerm_resource_group.demorg.name
}

resource "azurerm_subnet" "mysubnet" {
  name = "mysubnet1"
  resource_group_name = azurerm_resource_group.demorg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "publicip" {
  depends_on = [ azurerm_virtual_network.myvnet,azurerm_subnet.mysubnet ]
 name = "mypublicip"
 resource_group_name = azurerm_resource_group.demorg.name
 location = azurerm_resource_group.demorg.location
 allocation_method =   "Static"

}

resource "azurerm_network_interface" "myvmnic" {
  name = "vm1-nic"
  location = azurerm_resource_group.demorg.location
  resource_group_name = azurerm_resource_group.demorg.name
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.1.10"
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
}

# resource "azurerm_network_security_group" "name" {
  
# }