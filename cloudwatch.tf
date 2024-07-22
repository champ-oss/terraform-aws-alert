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
