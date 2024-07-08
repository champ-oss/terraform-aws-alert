locals {
  tags = {
    cost    = "shared"
    creator = "terraform"
    git     = var.git
  }
  trimmed_name = substr("${var.git}-${var.name}", 0, 56)
  name         = "${local.trimmed_name}-${random_id.this.hex}" # 64 characters max length
}

resource "random_id" "this" {
  byte_length = 3
}
