locals {
  tags = {
    cost    = "shared"
    creator = "terraform"
    git     = var.git
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "${var.git}/test"
  retention_in_days = 5
  tags              = local.tags
}

module "this" {
  source         = "../../"
  git            = var.git
  log_group_name = aws_cloudwatch_log_group.this.name
  name           = "terraform-aws-alert"
  slack_url      = var.slack_url
  region         = "us-east-1"
}
