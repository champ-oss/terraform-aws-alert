output "lambda_function_arn" {
  description = "function arn"
  value       = var.enabled ? module.this.arn : ""
}

output "cloudwatch_log_group" {
  description = "alarm name output"
  value       = var.enabled ? module.this.cloudwatch_log_group : ""
}
