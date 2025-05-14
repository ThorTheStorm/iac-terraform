
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
  description = "Resource Groupe Name"
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

variable "az_regions" {
  type        = list(string)
  description = "Azure regions for resources"
  default     = ["norwayeast", "westeurope"]
}

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

variable "sub_id" {
  type        = string
  description = "Azure Subscription ID"
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
}

variable "storage_account_admin" {
  type        = string
  description = "Principal ID for the user to get administrative rights on the storage account"
}