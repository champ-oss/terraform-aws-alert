locals {
  tags = {
    git       = var.git
    cost      = "shared"
    creator   = "terraform"
    component = var.name
  }
  trimmed_name = substr("${var.git}-${var.name}", 0, 56)
  name         = "${local.trimmed_name}-${random_id.this.hex}" # 64 characters max length
}

resource "random_id" "this" {
  byte_length = 3
}
