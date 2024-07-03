output "lambda_function_arn" {
  description = "function arn"
  value       = var.module_enabled ? module.this.arn : ""
}

output "cloudwatch_log_group" {
  description = "alarm name output"
  value       = var.module_enabled ? module.this.cloudwatch_log_group : ""
}
