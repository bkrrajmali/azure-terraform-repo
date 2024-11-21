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
  subscription_id = "77e8ed92-1ff2-49eb-8917-b8050644bfd6"
}

resource "azurerm_virtual_machine" "mylinuxvm" {
  
}

#az vm show --name LINUXVM-1 --resource-group import --query id --output tsv
#terraform import azurerm_virtual_machine.mylinuxvm "/subscriptions/77e8ed92-1ff2-49eb-8917-b8050644bfd6/resourceGroups/import/providers/Microsoft.Compute/virtualMachines/vm1"
