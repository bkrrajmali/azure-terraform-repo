terraform {
  required_version = ">=1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.9.0"
      #   version = ">=1.4.0"
    }
  }
}
provider "azurerm" {
  features {}
  # Configuration options
  subscription_id = "77e8ed92-1ff2-49eb-8917-b8050644bfd6"
}
resource "azurerm_resource_group" "mydemo" {
  name     = "demorg1"
  location = "eastus"
}
resource "azurerm_virtual_network" "demovnet" {
  name                = "demo-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.mydemo.location
  resource_group_name = azurerm_resource_group.mydemo.name
}

resource "azurerm_subnet" "demosub" {
  name                 = "mysubnet-1"
  resource_group_name  = azurerm_resource_group.mydemo.name
  virtual_network_name = azurerm_virtual_network.demovnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "demosg" {
  name                = "demo-sg"
  location            = azurerm_resource_group.mydemo.location
  resource_group_name = azurerm_resource_group.mydemo.name
  security_rule {
    name                       = "allow_everything"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  }
}


resource "azurerm_subnet_network_security_group_association" "demo-nsg-association" {
  subnet_id                 = azurerm_subnet.demosub.id
  network_security_group_id = azurerm_network_security_group.demosg.id
}

resource "azurerm_public_ip" "demo-pip" {
  name                = "demo-pip"
  location            = azurerm_resource_group.mydemo.location
  resource_group_name = azurerm_resource_group.mydemo.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "demo-nic" {
  name                = "demo-nic"
  location            = azurerm_resource_group.mydemo.location
  resource_group_name = azurerm_resource_group.mydemo.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.demosub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.demo-pip.id
  }
}

resource "azurerm_linux_virtual_machine" "demovm" {
  name                  = "demo-linux-vm"
  location              = azurerm_resource_group.mydemo.location
  resource_group_name   = azurerm_resource_group.mydemo.name
  size                  = "Standard_B1s"
  admin_username        = "azureadmin"
  network_interface_ids = [azurerm_network_interface.demo-nic.id]
  admin_ssh_key {
    username   = "azureadmin"
    public_key = file("C:\\Users\\Bala\\.ssh\\id_rsa.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

}

resource "null_resource" "copy_file_to_vm" {
  provisioner "file" {
    source      = "install_apache.sh"
    destination = "/tmp/install_apache.sh"
    connection {
      type        = "ssh"
      host        = azurerm_public_ip.demo-pip.ip_address
      user        = "azureadmin"
      private_key = file("C:\\Users\\Bala\\.ssh\\id_rsa")
    }
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = azurerm_public_ip.demo-pip.ip_address
      user        = "azureadmin"
      private_key = file("C:\\Users\\Bala\\.ssh\\id_rsa")
    }
    inline = [
      "chmod +x /tmp/install_apache.sh",
      "sudo sh /tmp/install_apache.sh"
    ]
  }
  depends_on = [azurerm_linux_virtual_machine.demovm]

}