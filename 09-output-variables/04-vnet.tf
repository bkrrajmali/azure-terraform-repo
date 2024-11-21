resource "azurerm_virtual_network" "vnet1" {
  name                = "${var.environment}-${var.virtual_network_name}"
  address_space       = ["10.0.0.0/16"]
  location            = var.resource_group_location
  #resource_group_name = "${var.environment}-${var.resource_group_name}"
  resource_group_name = azurerm_resource_group.myrg.name
}