
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

variable "storage_blob_instance_count" {
  type        = number
  description = "Number of storage containers to create"
  default     = 1
}

variable "source_content_title" {
  type        = string
  description = "Title for the web page"
  default     = "This is a title"
}

variable "source_content_paragraph" {
  type        = string
  description = "Paragraph for the web page"
  default     = "This is a paragraph"
}

variable index_document {
  type        = string
  description = "Name of the index document"
  default     = "index.html"
}

variable "static_web_app_instance_count" {
  type        = number
  description = "Number of static web apps to create"
  default     = 1
}