resource random_string "random_string" {
  length  = 8
  special = false
  upper = false
  numeric = false
  lower = true
}

resource "azurerm_resource_group" "rg_backend" {
  name     = local.naming.rg
  location = var.location
  tags     = local.common_tags
}