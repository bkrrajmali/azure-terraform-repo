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
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.1.0/24"]

}

resource "azurerm_public_ip" "mypublicip" {
  depends_on          = [azurerm_virtual_network.myvnet, azurerm_subnet.mysubnet]
  name                = "mypublic-ip-1"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  allocation_method   = "Static"

}

resource "azurerm_network_interface" "mynic1" {
  name                = "vm1-nic"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicip.id
  }
}

resource "azurerm_network_security_group" "mynsg" {
  name                = "my_nsg"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_network_security_rule" "allow_all" {
  resource_group_name         = azurerm_resource_group.rg1.name
  name                        = "allow-all"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.mynsg.name
}

resource "azurerm_subnet_network_security_group_association" "mysubnet_nsg_association" {
  subnet_id                 = azurerm_subnet.mysubnet.id
  network_security_group_id = azurerm_network_security_group.mynsg.id
}

resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  name                  = "mylinuxvm-1"
  computer_name         = "devlinuxvm-1"
  resource_group_name   = azurerm_resource_group.rg1.name
  location              = azurerm_resource_group.rg1.location
  size                  = "Standard_DS1_v2"
  admin_username        = "azureadmin"
  network_interface_ids = [azurerm_network_interface.mynic1.id]
  admin_ssh_key {
    username   = "azureadmin"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name                 = "osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }
  custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")
}