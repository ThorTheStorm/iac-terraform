### General Variables ###
variable "location" {
  type        = string
  description = "Deployment location"
  default     = "Norway East"
}

variable "locationabbreviation" {
  type        = map(string)
  description = "Location abbreviation"
  default = {
    "Norway East" = "ne"
    "West Europe" = "we"
  }
}

variable "environment" {
  type        = string
  description = "Environment"
  default     = "stage"

  validation {
    condition     = contains(["dev", "stage", "prod"], lower(var.environment))
    error_message = "Environment must be dev, stage, or prod."
  }
}

variable "rgname" {
  type        = string
  description = "Resource Group Name"
  default     = "rg-torb-terraform"
}

variable "company" {
  type        = string
  description = "Company name"
}

variable "project" {
  type        = string
  description = "Project name"
}

variable "purpose" {
  type        = string
  description = "Purpose of the resource"
}

variable "billing_code" {
  type        = string
  description = "Billing code"
}

variable "sub_id" {
  type        = string
  description = "Azure Subscription ID"
}

### Storage Account Variables ###
variable "storage_account_instance_count" {
  type        = number
  description = "Number of storage accounts to create"
  default     = 1
}

variable "storage_account_replication_type" {
  type        = string
  description = "Define the replication type for the storage account"
  default     = "LRS"
}

variable "storage_account_tier" {
  type        = string
  description = "Define the storage account tier"
  default     = "Standard"
}

variable "storage_account_admin" {
  type        = string
  description = "Principal ID for the user to get administrative rights on the storage account"
}

variable "storage_container_instance_count" {
  type        = number
  description = "Number of storage containers to create"
  default     = 1
}

variable "storage_container_access_type" {
  type        = string
  description = "Access type for the storage container"
  default     = "private"
}

### Key Vault Variables ###
variable "key_vault_instance_count" {
  type        = number
  description = "Number of key vaults to create"
  default     = 1
}

variable "key_vault_key_permissions" {
  type        = list(string)
  description = "Key permissions for the key vault"
  validation {
    condition     = length(var.key_vault_key_permissions) > 0
    error_message = "Key permissions must be provided."
  }
  validation {
    condition     = alltrue([for perm in var.key_vault_key_permissions : substr(perm, 0, 1) == upper(substr(perm, 0, 1))])
    error_message = "All key permissions must start with an uppercase letter."
  }
  validation {
    condition     = contains(["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"], var.key_vault_key_permissions)
    error_message = "Invalid vault key permissions for the environment."
  }
}

variable "key_vault_secret_permissions" {
  type        = list(string)
  description = "Secret permissions for the key vault"
  validation {
    condition     = length(var.key_vault_secret_permissions) > 0
    error_message = "Secret permissions must be provided."
  }
  validation {
    condition     = alltrue([for perm in var.key_vault_secret_permissions : substr(perm, 0, 1) == upper(substr(perm, 0, 1))])
    error_message = "All secret permissions must start with an uppercase letter."
  }
  validation {
    condition     = contains(["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"], var.key_vault_secret_permissions)
    error_message = "Invalid vault secret permissions for the environment."
  }
}

variable "key_vault_storage_permissions" {
  type        = list(string)
  description = "Storage permissions for the key vault"
  validation {
    condition     = length(var.key_vault_storage_permissions) > 0
    error_message = "Storage permissions must be provided."
  }
  validation {
    condition     = alltrue([for perm in var.key_vault_storage_permissions : substr(perm, 0, 1) == upper(substr(perm, 0, 1))])
    error_message = "All storage permissions must start with an uppercase letter."
  }
  validation {
    condition     = contains(["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"], var.key_vault_storage_permissions)
    error_message = "Invalid vault storage permissions for the environment."
  }
}

### Networking Variables ###
variable "network_address_space" {
  type        = string
  description = "Network Address Space"
  default     = "10.0.0.0"
}

variable "vnet_mask" {
  type        = number
  description = "Virtual Network Mask"
  default     = 16
}

variable "vnet_instance_count" {
  type        = number
  description = "Number of virtual networks to create"
  default     = 1
}

variable "snet_mask" {
  type        = number
  description = "Subnet Mask"
  default     = 24
}

variable "snet_mask_offset" {
  type        = number
  description = "Subnet Mask Offset"
  default     = 8
}

variable "snet_instance_count" {
  type        = number
  description = "Number of subnets to create"
  default     = 1
}

### Azure Regions ###
variable "az_regions" {
  type        = list(string)
  description = "Azure regions for resources"
  default     = ["norwayeast", "westeurope"]
}