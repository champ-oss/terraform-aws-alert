output "lambda_function_arn" {
  description = "function arn"
  value       = var.enabled ? aws_lambda_function.this[0].arn : ""
}

output "cloudwatch_log_group" {
  description = "Alarm name output"
  value       = var.enabled ? aws_cloudwatch_log_group.this.name : ""
}