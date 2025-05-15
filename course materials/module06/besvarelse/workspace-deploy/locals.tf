locals {
  # Common naming prefix to maintain consistency
  environment_check = terraform.workspace == "default" ? "${var.environment}" : terraform.workspace
  prefix    = lower("${var.company}-${var.project}-${var.purpose}-${local.environment_check}")
  st_prefix = lower("${var.purpose}")

  # Resource naming convention using prefix
  naming = {
    rg   = "rg-${local.prefix}-${var.locationabbreviation[var.location]}"
  }

  # Standardized tagging
  common_tags = {
    environment  = local.environment_check
    company      = var.company
    project      = var.project
    billing_code = var.billing_code
    managed_by   = "terraform"
  }
}