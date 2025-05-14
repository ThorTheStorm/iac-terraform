locals {
  # Common naming prefix to maintain consistency
  prefix    = lower("${var.company}-${var.project}-${var.purpose}-${var.environment}")
  sa_prefix = lower("${var.purpose}")

  # Resource naming convention using prefix
  naming = {
    rg   = "rg-${local.prefix}-${var.locationabbreviation[var.location]}"
    sa   = [for i in range(1, var.storage_account_instance_count + 1) : format("st%s%03d", replace(local.sa_prefix, "-", ""), i)] # Storage accounts don't allow hyphens
    sc   = [for i in range(1, var.storage_container_instance_count + 1) : format("sc%s%03d", replace(local.sa_prefix, "-", ""), i)] # Storage containers don't allow hyphens
    kv   = [for i in range(1, var.key_vault_instance_count + 1) : format("kv-%s-%03d", replace(local.sa_prefix, "-", ""), i)] # Key vaults don't allow hyphens
    kvs  = "kvs${local.sa_prefix}"
    nsg  = [for i in range(1, var.vnet_instance_count * var.snet_instance_count + 1) : format("nsg-%s%03d", "${local.prefix}-${var.locationabbreviation[var.location]}", i)]
  }

  networking = {
    # Remove duplicate vnet_address_space definition
    vnet_address_space = [for i in range(0, var.vnet_instance_count) :
      format("%s.%d.0.0/%d",
        regex("^\\d+", var.network_address_space),
        i,
        var.vnet_mask
      )
    ]
    snet_address_space = [for i in range(1, var.snet_instance_count + 1) :
      format("%s.%d.0/%d",
        regex("^\\d+\\.\\d+", var.network_address_space),
        i,
        var.snet_mask
      )
    ]
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