output "resource_group_id" {
  description = "Resource Group ID"
  value = azurerm_resource_group.myrg.id
}

output "resource_group_name" {
  description = "Resource Group Name"
  value = azurerm_resource_group.myrg.name
}

output "virtual_network_name" {
  description = "Virtual Network Name"
  value = azurerm_virtual_network.vnet1.name
}

output "virtual_network_id" {
  description = "Virtual Network ID"
  value = azurerm_virtual_network.vnet1.id
}