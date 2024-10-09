resource "aws_lambda_function" "this" {
  count                          = var.enabled ? 1 : 0
  function_name                  = local.name
  role                           = aws_iam_role.this[0].arn
  package_type                   = var.package_type
  image_uri                      = var.package_type == "Image" ? var.image_uri : null
  filename                       = var.package_type == "Zip" ? data.archive_file.lambda_zip[0].output_path : null
  handler                        = var.package_type == "Zip" ? "cloudwatch_slack.lambda_handler" : null
  source_code_hash               = var.package_type == "Zip" ? data.archive_file.lambda_zip[0].output_base64sha256 : null
  runtime                        = var.package_type == "Zip" ? "python3.12" : null
  memory_size                    = 128
  timeout                        = 30
  description                    = "Lambda function to send CloudWatch alarms to Slack"
  reserved_concurrent_executions = -1
  tags                           = merge(local.tags, var.tags)
  lifecycle {
    ignore_changes = [
      function_name,
      last_modified
    ]
  }
  environment {
    variables = {
      SLACK_URL = var.slack_url
      REGION    = var.region
    }
  }
}

moved {
  from = module.this.aws_lambda_function.this
  to   = aws_lambda_function.this[0]
}

resource "aws_lambda_permission" "this" {
  count         = var.enabled ? 1 : 0
  statement_id  = "AllowCloudwatchToSlackTrigger"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this[0].arn
  principal     = "logs.${var.region}.amazonaws.com"
}

moved {
  from = aws_lambda_permission.this
  to   = aws_lambda_permission.this[0]
}
