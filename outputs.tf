output "lambda_function_arn" {
  description = "function arn"
  value       = var.module_enabled ? module.this[0].arn : ""
}

output "cloudwatch_log_group" {
  description = "alarm name output"
  value       = var.module_enabled ? module.this[0].cloudwatch_log_group : ""
}
