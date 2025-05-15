locals {
  # Common naming prefix to maintain consistency
  environment_check = terraform.workspace == "default" ? "${var.environment}" : terraform.workspace
  prefix    = lower("${var.company}-${var.project}-${var.purpose}-${local.environment_check}")
  sa_prefix = lower("${var.purpose}")

  # Resource naming convention using prefix
  naming = {
    rg   = "rg-${local.prefix}-${var.locationabbreviation[var.location]}"
    sa   = [for i in range(1, var.storage_account_instance_count + 1) : format("sa%s%03d", replace(local.sa_prefix, "-", ""), i)] # Storage accounts don't allow hyphens
    # sb   = [for i in range(1, var.storage_blob_instance_count + 1) : format("sb%s%03d", replace(local.sa_prefix, "-", ""), i)] # Storage containers don't allow hyphens
    swa  = [for i in range(1, var.static_web_app_instance_count + 1) : format("swa-%s-%03d", local.prefix, i)]
  }

  # Standardized tagging
  common_tags = {
    environment  = local.environment_check
    company      = var.company
    project      = var.project
    billing_code = var.billing_code
    managed_by   = "terraform"
  }

  # Website content
  website_content = templatefile("${path.module}/website/index.html.tfpl", {
    title = "${var.source_content_title}"
    content  = "${var.source_content_paragraph} Also, this is the ${terraform.workspace}-workspace"
  })
}