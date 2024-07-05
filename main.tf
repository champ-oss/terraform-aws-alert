locals {
  tags = {
    cost    = "shared"
    creator = "terraform"
    git     = var.git
  }
}

data "archive_file" "lambda_zip" {
  type             = "zip"
  output_file_mode = "0666"
  source_file      = "${path.module}/cloudwatch_slack.py"
  output_path      = "${path.module}/cloudwatch_slack.zip"
}

module "this" {
  source                = "github.com/champ-oss/terraform-aws-lambda.git?ref=11415af2651e5e1317df93fca3cf4353f3a7195f"
  git                   = var.git
  name                  = var.name
  tags                  = merge(local.tags, var.tags)
  runtime               = "python3.8"
  handler               = "cloudwatch_slack.lambda_handler"
  filename              = data.archive_file.lambda_zip.output_path
  source_code_hash      = data.archive_file.lambda_zip.output_base64sha256
  enable_logging_alerts = false
  environment = {
    SLACK_URL = var.slack_url
    REGION    = var.region
  }
  enabled = var.enabled
}
