data "archive_file" "lambda_zip" {
  count            = var.enabled ? 1 : 0
  type             = "zip"
  source_dir       = "${path.module}/alert"
  output_path      = "${path.module}/alert/cloudwatch_slack.zip"
}

moved {
  from = data.archive_file.lambda_zip
  to   = data.archive_file.lambda_zip[0]
}
