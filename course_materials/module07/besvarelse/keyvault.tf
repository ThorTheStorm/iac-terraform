data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv_backend" {
    name                        = "${local.naming.kv[0]}-${random_string.random_string.result}"
    location                    = azurerm_resource_group.rg_backend.location
    resource_group_name         = azurerm_resource_group.rg_backend.name
    enabled_for_disk_encryption = true
    tenant_id                   = data.azurerm_client_config.current.tenant_id
    soft_delete_retention_days  = 7
    purge_protection_enabled    = false
    tags     = local.common_tags

    sku_name = "standard"

    access_policy {
        tenant_id = data.azurerm_client_config.current.tenant_id
        object_id = data.azurerm_client_config.current.object_id

        key_permissions = var.key_vault_key_permissions

        secret_permissions = var.key_vault_secret_permissions

        storage_permissions = var.key_vault_storage_permissions
    }
}

resource "azurerm_key_vault_secret" "kvs_backend" {
    name         = local.naming.kvs
    value        = azurerm_storage_account.sa_backend.primary_access_key
    key_vault_id = azurerm_key_vault.kv_backend.id
}