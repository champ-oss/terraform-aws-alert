locals {
  tags = {
    cost    = "shared"
    creator = "terraform"
    git     = var.git
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/python-lambda"
  output_path = "cloudwatch_slack.zip"
}

resource "random_string" "identifier" {
  length  = 5
  special = false
  upper   = false
  lower   = true
  number  = false
}

module "this" {
  source                 = "github.com/champ-oss/terraform-aws-lambda.git?ref=v1.0.2-7160ffc"
  git                    = var.git
  name                   = "${var.name}-${random_string.identifier.result}"
  tags                   = merge(local.tags, var.tags)
  runtime                = "python3.8"
  handler                = "cloudwatch_slack.lambda_handler"
  filename               = data.archive_file.lambda_zip.output_path
  enable_lambda_cw_alert = false # this must be disabled to prevent an infinite recursive loop
  environment = {
    SLACK_URL = var.slack_url
    REGION    = var.region
  }
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowCloudwatchToSlackTrigger"
  action        = "lambda:InvokeFunction"
  function_name = module.this.arn
  principal     = "logs.${var.region}.amazonaws.com"
}
