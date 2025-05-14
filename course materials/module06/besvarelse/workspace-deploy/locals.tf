locals {
  # Common naming prefix to maintain consistency
  prefix    = lower("${var.company}-${var.project}-${var.purpose}-${var.environment}")
  st_prefix = lower("${var.purpose}")

  # Resource naming convention using prefix
  naming = {
    rg   = "rg-${local.prefix}-${var.locationabbreviation[var.location]}"
    st   = [for i in range(1, var.storage_account_instance_count + 1) : format("st%s%03d", replace(local.st_prefix, "-", ""), i)] # Storage accounts don't allow hyphens
    sc   = [for i in range(1, var.storage_container_instance_count + 1) : format("sc%s%03d", replace(local.st_prefix, "-", ""), i)] # Storage containers don't allow hyphens
    kv   = [for i in range(1, var.key_vault_instance_count + 1) : format("kv-%s-%03d", replace(local.st_prefix, "-", ""), i)] # Key vaults don't allow hyphens
    kvs  = "kvs${local.st_prefix}"
  }

  # Standardized tagging
  common_tags = {
    environment  = var.environment
    company      = var.company
    project      = var.project
    billing_code = var.billing_code
    managed_by   = "terraform"
  }
}