locals {
  tags = {
    cost    = "shared"
    creator = "terraform"
    git     = var.git
  }
}

data "archive_file" "lambda_zip" {
  count            = var.enabled ? 1 : 0
  type             = "zip"
  output_file_mode = "0666"
  source_file      = "${path.module}/cloudwatch_slack.py"
  output_path      = "${path.module}/cloudwatch_slack.zip"
}

moved {
  from = data.archive_file.lambda_zip
  to   = data.archive_file.lambda_zip[0]
}

module "this" {
  source                = "github.com/champ-oss/terraform-aws-lambda.git?ref=v1.0.142-273b055"
  git                   = var.git
  name                  = var.name
  tags                  = merge(local.tags, var.tags)
  runtime               = "python3.8"
  handler               = "cloudwatch_slack.lambda_handler"
  filename              = try(data.archive_file.lambda_zip[0].output_path, "")
  source_code_hash      = try(data.archive_file.lambda_zip[0].output_base64sha256, "")
  enable_logging_alerts = false
  environment = {
    SLACK_URL = var.slack_url
    REGION    = var.region
  }
}
