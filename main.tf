locals {
  tags = {
    git       = var.git
    cost      = "shared"
    creator   = "terraform"
    component = var.name
  }
  trimmed_name = substr("${var.git}-${var.name}", 0, 56)
  name         = "${local.trimmed_name}-${random_string.identifier[0].result}" # 64 characters max length
}

resource "random_string" "identifier" {
  count   = var.enabled ? 1 : 0
  length  = 5
  special = false
  upper   = false
  lower   = true
  numeric = false
}

moved {
  from = random_string.identifier
  to   = random_string.identifier[0]
}
