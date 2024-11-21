resource "azurerm_subnet" "mysubnet" {
  name="mysubnet-1"
  resource_group_name = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes = [ "10.0.1.0/24" ]
}