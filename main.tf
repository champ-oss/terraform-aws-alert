locals {
  tags = {
    git       = var.git
    cost      = "shared"
    creator   = "terraform"
    component = try("${var.name}-${random_string.identifier[0].result}", "")
  }
  trimmed_name = substr("${var.git}-${var.name}", 0, 56)
  name         = try("${local.trimmed_name}-${random_string.identifier[0].result}", "") # 64 character max length
}

resource "random_string" "identifier" {
  count   = var.enabled ? 1 : 0
  length  = 5
  special = false
  upper   = false
  lower   = true
  numeric = false
}

module "hash" {
  source   = "github.com/champ-oss/terraform-git-hash.git?ref=v1.0.15-cd75e35"
  path     = path.module
  fallback = ""
}

moved {
  from = random_string.identifier
  to   = random_string.identifier[0]
}
