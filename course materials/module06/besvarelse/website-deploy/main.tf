resource random_string "random_string" {
  length  = 8
  special = false
  upper   = false
  numeric = false
  lower   = true
}

resource "azurerm_resource_group" "rg_website" {
  name     = local.naming.rg
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_storage_account" "sa_website" {
  name                     = "${lower(local.naming.sa[0])}${random_string.random_string.result}"
  resource_group_name      = azurerm_resource_group.rg_website.name
  location                 = azurerm_resource_group.rg_website.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  tags                     = local.common_tags


  }

resource "azurerm_storage_account_static_website" "static_web" {
  storage_account_id = azurerm_storage_account.sa_website.id
  index_document     = var.index_document
}

resource "azurerm_storage_blob" "index_html" {
  name                   = var.index_document # local.naming.sb[0]
  storage_account_name   = azurerm_storage_account.sa_website.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = local.website_content
}

output "primary_web_endpoint" {
  value = azurerm_storage_account.sa_website.primary_web_endpoint
  
}