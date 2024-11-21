terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.9.0"
    }
  }
}
provider "azurerm" {
  features {}
  # Configuration options
  subscription_id = "77e8ed92-1ff2-49eb-8917-b8050644bfd6"
}