data "aws_region" "this" {}

resource "aws_cloudwatch_log_group" "this" {
  name              = "terraform-aws-alert/test"
  retention_in_days = 5
}

module "this" {
  source         = "../../"
  git            = "terraform-aws-alert"
  log_group_name = aws_cloudwatch_log_group.this.name
  name           = "terraform-aws-alert"
  slack_url      = ""
  region         = data.aws_region.this.name
}

output "cloudwatch_log_group" {
  description = "alarm name output"
  value       = module.this.cloudwatch_log_group
}
