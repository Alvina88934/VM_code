resource "azurerm_virtual_network" "vnet_1" {
  name                = var.azurerm_virtual_network
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = var.address_space
}
