resource "aws_cloudwatch_log_subscription_filter" "this" {
  count           = var.enabled ? 1 : 0
  name            = "cloudwatch-to-slack-logfilter"
  log_group_name  = var.log_group_name
  filter_pattern  = var.filter_pattern
  destination_arn = aws_lambda_function.this[0].arn
}

moved {
  from = aws_cloudwatch_log_subscription_filter.this
  to   = aws_cloudwatch_log_subscription_filter.this[0]
}

resource "aws_cloudwatch_log_group" "this" {
  count           = var.enabled ? 1 : 0
  name              = "/aws/lambda/${var.git}-${var.name}-${random_string.identifier[0].result}"
  retention_in_days = 365
  tags              = merge(local.tags, var.tags)

  lifecycle {
    ignore_changes = [
      name
    ]
  }
}

moved {
  from = module.this.aws_cloudwatch_log_group.this
  to   = aws_cloudwatch_log_group.this[0]
}
