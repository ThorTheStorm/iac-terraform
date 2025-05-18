terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.22.0"
    }
  } # This block is used to specify the required providers for the Terraform configuration.

  backend "azurerm" {
    #use_oidc             = true                                    # Can also be set via `ARM_USE_OIDC` environment variable.
    #tenant_id            = "00000000-0000-0000-0000-000000000000"  # Can also be set via `ARM_TENANT_ID` environment variable.
    #subscription_id      = "00000000-0000-0000-0000-000000000000"  # Can also be set via `ARM_SUBSCRIPTION_ID` environment variable.
    #client_id            = "00000000-0000-0000-0000-000000000000"  # Can also be set via `ARM_CLIENT_ID` environment variable.
    resource_group_name  = "rg-tbtisip-backend-tfstate-dev-ne"                        # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "sttfstate001dnuutfrn"                  # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "sctfstate001"                               # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "backend.terraform.tfstate"                # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  } # This block is used to configure the backend for storing the Terraform state file.

}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

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

resource "azurerm_storage_account" "sa_backend" {
  name = "${lower(local.naming.st[0])}${random_string.random_string.result}"
  resource_group_name = azurerm_resource_group.rg_backend.name
  location = azurerm_resource_group.rg_backend.location
  account_tier = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  tags     = local.common_tags
}

# resource "azurerm_role_assignment" "sa_role_assignment" {
#   scope                = azurerm_storage_account.sa_backend.id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = var.storage_account_admin
# }

resource "azurerm_storage_container" "sc_backend" {
  name                  = local.naming.sc[0]
  storage_account_id    = azurerm_storage_account.sa_backend.id
  container_access_type = "private"
}



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