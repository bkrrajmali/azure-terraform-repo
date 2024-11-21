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
  subscription_id = "XXXX"

}
resource "azurerm_resource_group" "rg1" {
  # This is Resource Group
  /* This is multiline
    comment for terraform */
  name     = "my-rg1"
  location = "East US"
}
