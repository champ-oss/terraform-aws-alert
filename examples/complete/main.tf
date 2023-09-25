data "aws_region" "this" {}

variable "slack_url" {
  description = "Slack URL for testing"
  type        = string
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "terraform-aws-alert/test"
  retention_in_days = 5
}

resource "aws_cloudwatch_log_stream" "this" {
  name           = "Test"
  log_group_name = aws_cloudwatch_log_group.this.name
}

module "this" {
  source         = "../../"
  git            = "terraform-aws-alert"
  log_group_name = aws_cloudwatch_log_group.this.name
  name           = "terraform-aws-alert"
  slack_url      = var.slack_url
  region         = data.aws_region.this.name
}

output "cloudwatch_log_group" {
  description = "log group name"
  value       = aws_cloudwatch_log_group.this.name
}

output "cloudwatch_log_stream" {
  description = "log stream name"
  value       = aws_cloudwatch_log_stream.this.name
}
