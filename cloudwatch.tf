resource "aws_cloudwatch_log_subscription_filter" "this" {
  count           = var.module_enabled ? 1 : 0
  name            = "cloudwatch-to-slack-logfilter"
  log_group_name  = var.log_group_name
  filter_pattern  = var.filter_pattern
  destination_arn = module.this.arn
}
