output "lambda_function_arn" {
  description = "function arn"
  value       = var.enabled ? aws_lambda_function.this[0].arn : ""
}