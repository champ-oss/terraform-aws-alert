terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.0.0"
    }
  }
}

data "aws_region" "this" {}

variable "slack_url" {
  description = "Slack URL for testing"
  type        = string
}

variable "enabled" {
  description = "module enabled"
  type        = bool
  default     = true
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
  enabled        = var.enabled
}

output "cloudwatch_log_group" {
  description = "log group name for test messages"
  value       = aws_cloudwatch_log_group.this.name
}

output "cloudwatch_log_stream" {
  description = "log stream name for test messages"
  value       = var.enabled ? aws_cloudwatch_log_stream.this.name : ""
}

output "alert_cloudwatch_log_group" {
  description = "log group name for alert module function"
  value       = var.enabled ? module.this.cloudwatch_log_group : ""
}

output "module_enabled" {
  description = "module enabled"
  value       = var.enabled
}
