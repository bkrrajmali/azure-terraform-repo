resource "azurerm_resource_group" "myrg" {
  name     = "${var.environment}-${var.resource_group_name}" #PROD-myrg
  location = "${var.resource_group_location}"
}