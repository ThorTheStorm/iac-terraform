resource "azurerm_resource_group" "rg_website" {
  name     = local.naming.rg
  location = var.location
  tags     = local.common_tags
}