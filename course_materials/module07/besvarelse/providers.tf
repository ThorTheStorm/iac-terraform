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
        key                  = "ghactions-m07-${terraform.workspace}.terraform.tfstate"                # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
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