resource "azurerm_storage_account" "sa_backend" {
  name = "${lower(local.naming.st[0])}${random_string.random_string.result}"
  resource_group_name = azurerm_resource_group.rg_backend.name
  location = azurerm_resource_group.rg_backend.location
  account_tier = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  tags     = local.common_tags
}


resource "azurerm_storage_container" "sc_backend" {
  name                  = local.naming.sc[0]
  storage_account_id    = azurerm_storage_account.sa_backend.id
  container_access_type = "private"
}