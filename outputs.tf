output "lambda_function_arn" {
  description = "function arn"
  value       = var.enabled ? module.this[0].arn : ""
}

output "cloudwatch_log_group" {
  description = "alarm name output"
  value       = var.enabled ? module.this[0].cloudwatch_log_group : ""
}
